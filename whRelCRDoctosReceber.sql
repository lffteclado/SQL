if exists(select 1 from sysobjects where id = object_id('whRelCRDoctosReceber'))
DROP PROCEDURE dbo.whRelCRDoctosReceber
GO
CREATE PROCEDURE dbo.whRelCRDoctosReceber

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: CDC - Consulters/Humaita
 PROJETO......: CR
 AUTOR........: Marcello
 DATA.........: 15/06/1998
 UTILIZADO EM : RelDoctosaReceber.rpt
 OBJETIVO.....: Relacao de Doctos Recebidos (e Previstos) 
		por Vencto / Vencto Util.
 ALTERACAO....: Marcelo Leite - 26/05/1999
 OBJETIVO.....: Ajuste do valor do saldo do Documento

 ALTERACAO....: Rubens Jose Soares Fortunato - 02/06/1999
 OBJETIVO.....: Selecionar apenas documentos de saida

 ALTERACAO....: Fabiane - 20/08/1999
 OBJETIVO.....: Alteracao no calculo do ValorSaldoDocto

 ALTERACAO....: Simone - 30/08/2000
 OBJETIVO.....: Alteracao conforme FM 2738  CAC 51180/2000

 ALTERACAO....: Andrade - 25/09/2000
 OBJETIVO.....: Alteracao conforme FM 2859
  
 ALTERACAO....: Alex Kmez - 17/10/2002
 OBJETIVO.....: Substituicao das tabelas #tmp por rts - Performance

 ALTERACAO....: Marcelo Bueno - 18/09/2006
 OBJETIVO.....: Parametros De/Ate DataEmissaoDocumento

 ALTERACAO....: Marcelo Bueno - 07/11/2008
 OBJETIVO.....: Inclusão do campo DataVenctoOriginalDoctoRecPag

 whRelCRDoctosReceber 1608, '2002-01-01', 'V', 0, 9999,'2001-01-01','2006-05-01', 'V','V',0,10,1,1,'V','2001-01-01','2006-05-01',' ' ,'ZZZZ'

 whRelCRDoctosReceber 1608, '2002-01-01', 'V', 0, 9999,'2001-01-01','2006-05-01', 'V','V',0,4,1,1,'V','2001-01-01','2006-05-01','28FQ' ,'28FQ'

-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa			dtInteiro04,
@DataEmissao			datetime,
@ImprimirPagos			dtBooleano,
@LocalInicial			dtInteiro04,
@LocalFinal				dtInteiro04,
@VenctoUtilInicial		datetime,
@VenctoUtilFinal		datetime,
@DiaUtilVencto			dtBooleano,
@DoctosPrevistos		dtBooleano,
@TipoDocumentoInicial	dtInteiro02,
@TipoDocumentoFinal		dtInteiro02,
@TipoCobrancaInicial	dtInteiro02,
@TipoCobrancaFinal		dtInteiro02,
@DataCreditoParcela     char(1),
@DaDataEmissao			datetime,
@AteDataEmissao			datetime,
@DePlanoPagamento		char(4),	---- 		
@AtePlanoPagamento		char(4),	---- 
@BorderoSelecionado		char(1) = NULL


--WITH ENCRYPTION

AS

DELETE FROM rtRelCRDoctosReceber where Spid = @@Spid

SET NOCOUNT ON

	INSERT rtRelCRDoctosReceber

	SELECT	
		Spid = @@Spid,
		tbDoctoRecPag.CodigoEmpresa	CodigoEmpresa,
		tbDoctoRecPag.DataVenctoUtilDoctoRecPag	DataVenctoUtil,
		DATEDIFF(dd,tbDoctoRecPag.DataVenctoUtilDoctoRecPag,@DataEmissao) NoDias,
		tbDoctoRecPag.CodigoCliFor	CodigoCliFor, 
		tbCliFor.NomeCliFor	NomeCliFor,
	 	tbDoctoRecPag.CodigoLocal	CodigoLocal, 
		tbDoctoRecPag.NumeroDocumento	NumeroDocumento,
		tbDoctoRecPag.SequenciaDoctoRecPag	SequenciaDocumento,
		F.AbreviaturaTipoDocto	DescricaoTipoDocumento,
		
		CASE WHEN tbDocumento.DataEmissaoDocumento is not null
		THEN
	    		tbDocumento.DataEmissaoDocumento
		ELSE	
	    		tbDoctoRecPag.DataDocumento
		END AS DataEmissaoDocumento,
		
		tbDoctoRecPag.DataPagamentoDoctoRecPag	DataPagamento,
		tbDoctoRecPag.CodigoBanco	CodigoBanco, 
		tbDoctoRecPag.CodigoAgencia	CodigoAgencia,
		tbDoctoReceber.CodigoTipoCobranca	CodigoTipoCobranca,
		tbDoctoRecPag.NumeroTituloDoctoRecPag	NumeroTitulo,
		( CASE WHEN F.SinalTipoDocto = 'P' THEN 
			(tbDoctoRecPag.ValorEmissaoDoctoRecPag       
			- tbDoctoRecPag.ValorAbatimentoDoctoRecPag    
			- tbDoctoRecPag.ValorLigadoDoctoRecPag 
			- ISNULL((
				SELECT 
					SUM(ValorPagtoParcelaDoctoRecPag) - SUM(ValorJurosParcelaDoctoRecPag)
					- SUM(ValorMultaParcela) + SUM(ValorDescParcelaDoctoRecPag) - SUM(ValorOutrasDespParcDoctoRecPag) 
					+ SUM(ValorPISParcelaDoctoReceber) + SUM(ValorCOFINSParcelaDoctoReceber)
					+ SUM(ValorIRPJParcelaDoctoReceber) + SUM(ValorContribSocialParcDoctoRec) + SUM(ValorISSTercParcDoctoRec)
				FROM 
					tbParcelaDocto (NOLOCK)
				WHERE 
					CodigoEmpresa 			  = tbDoctoRecPag.CodigoEmpresa
			 		AND CodigoLocal 		  	  = tbDoctoRecPag.CodigoLocal
					AND EntradaSaidaDocumento 	  = tbDoctoRecPag.EntradaSaidaDocumento
					AND NumeroDocumento 		  = tbDoctoRecPag.NumeroDocumento
					AND DataDocumento 		  = tbDoctoRecPag.DataDocumento
					AND CodigoCliFor 		  	  = tbDoctoRecPag.CodigoCliFor
					AND TipoLancamentoMovimentacao  = tbDoctoRecPag.TipoLancamentoMovimentacao
					AND SequenciaDoctoRecPag 	  = tbDoctoRecPag.SequenciaDoctoRecPag
					AND EfetivadoPagtoParcDoctoRecPag = 'V'
					AND (
						( @DataCreditoParcela 			= 'V' 
						AND DataCreditoParcelaDoctoReceber 	<= @DataEmissao ) 
						OR 
						( @DataCreditoParcela 			= 'F'
						AND DataPagtoParcelaDoctoRecPag 	<= @DataEmissao )
					)
				GROUP BY 
					CodigoEmpresa, 
					CodigoLocal, 
					EntradaSaidaDocumento, 
					NumeroDocumento, 
					DataDocumento, 
					CodigoCliFor, 
					TipoLancamentoMovimentacao, 
					SequenciaDoctoRecPag), 0)
			)
       	        ELSE
			(tbDoctoRecPag.ValorEmissaoDoctoRecPag       
			- tbDoctoRecPag.ValorAbatimentoDoctoRecPag    
			- tbDoctoRecPag.ValorLigadoDoctoRecPag 
			- ISNULL((
				SELECT 
					SUM(ValorPagtoParcelaDoctoRecPag) - SUM(ValorJurosParcelaDoctoRecPag)
					- SUM(ValorMultaParcela) + SUM(ValorDescParcelaDoctoRecPag) - SUM(ValorOutrasDespParcDoctoRecPag) 
					+ SUM(ValorPISParcelaDoctoReceber) + SUM(ValorCOFINSParcelaDoctoReceber)
					+ SUM(ValorIRPJParcelaDoctoReceber) + SUM(ValorContribSocialParcDoctoRec)+ SUM(ValorISSTercParcDoctoRec)
				FROM 
					tbParcelaDocto (NOLOCK)
				WHERE 
					CodigoEmpresa 			= tbDoctoRecPag.CodigoEmpresa
			 		AND CodigoLocal 		= tbDoctoRecPag.CodigoLocal
					AND EntradaSaidaDocumento 	= tbDoctoRecPag.EntradaSaidaDocumento
					AND NumeroDocumento 		= tbDoctoRecPag.NumeroDocumento
					AND DataDocumento 		= tbDoctoRecPag.DataDocumento
					AND CodigoCliFor 		= tbDoctoRecPag.CodigoCliFor
					AND TipoLancamentoMovimentacao 	= tbDoctoRecPag.TipoLancamentoMovimentacao
					AND SequenciaDoctoRecPag 	= tbDoctoRecPag.SequenciaDoctoRecPag
					AND EfetivadoPagtoParcDoctoRecPag = 'V'
					AND (
						( @DataCreditoParcela 			= 'V' 
						AND DataCreditoParcelaDoctoReceber 	<= @DataEmissao ) 
						OR 
						( @DataCreditoParcela 			= 'F'
						AND DataPagtoParcelaDoctoRecPag 	<= @DataEmissao )
					)
				GROUP BY 
					CodigoEmpresa, 
					CodigoLocal, 
					EntradaSaidaDocumento, 
					NumeroDocumento, 
					DataDocumento, 
					CodigoCliFor, 
					TipoLancamentoMovimentacao, 
					SequenciaDoctoRecPag), 0)
			) * -1
		END ) Valor,
		COALESCE(tbPlanoPagamento.CodigoPlanoPagamento,'') as Plano,
		tbDoctoRecPag.DataVenctoOriginalDoctoRecPag
	FROM	
		tbDoctoRecPag (NOLOCK)

		INNER JOIN tbTipoDocumento (NOLOCK) ON 
		tbDoctoRecPag.CodigoEmpresa = tbTipoDocumento.CodigoEmpresa AND 
		tbDoctoRecPag.CodigoTipoDoctoInclusao = tbTipoDocumento.CodigoTipoDocumento AND 
		tbDoctoRecPag.CaractTipoDoctoInclusao = tbTipoDocumento.CaracteristicaTipoDocto 

		INNER JOIN tbTipoDocumentoComplementar F (NOLOCK) ON
		tbTipoDocumento.CodigoEmpresa                  	= F.CodigoEmpresa              		AND
		tbTipoDocumento.CaracteristicaTipoDocto        	= F.CaracteristicaTipoDocto    		AND
		tbTipoDocumento.CodigoTipoDocumento            	= F.CodigoTipoDocumento

		INNER JOIN tbDocumento (NOLOCK) ON 
		tbDoctoRecPag.CodigoEmpresa = tbDocumento.CodigoEmpresa AND 
		tbDoctoRecPag.CodigoLocal = tbDocumento.CodigoLocal AND 
		tbDoctoRecPag.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND 
		tbDoctoRecPag.NumeroDocumento = tbDocumento.NumeroDocumento AND 
		tbDoctoRecPag.DataDocumento = tbDocumento.DataDocumento AND 
		tbDoctoRecPag.CodigoCliFor = tbDocumento.CodigoCliFor AND 
		tbDoctoRecPag.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao 

		INNER JOIN tbDoctoRecPagComplementar (NOLOCK) ON 
		tbDoctoRecPag.CodigoEmpresa = tbDoctoRecPagComplementar.CodigoEmpresa AND 
		tbDoctoRecPag.CodigoLocal = tbDoctoRecPagComplementar.CodigoLocal AND 
		tbDoctoRecPag.EntradaSaidaDocumento = tbDoctoRecPagComplementar.EntradaSaidaDocumento AND 
		tbDoctoRecPag.NumeroDocumento = tbDoctoRecPagComplementar.NumeroDocumento AND 
		tbDoctoRecPag.DataDocumento = tbDoctoRecPagComplementar.DataDocumento AND 
		tbDoctoRecPag.CodigoCliFor = tbDoctoRecPagComplementar.CodigoCliFor AND 
		tbDoctoRecPag.TipoLancamentoMovimentacao = tbDoctoRecPagComplementar.TipoLancamentoMovimentacao AND 
		tbDoctoRecPag.SequenciaDoctoRecPag = tbDoctoRecPagComplementar.SequenciaDoctoRecPag 

		INNER JOIN tbDoctoReceber (NOLOCK) ON 
		tbDoctoRecPag.CodigoEmpresa = tbDoctoReceber.CodigoEmpresa AND 
		tbDoctoRecPag.CodigoLocal = tbDoctoReceber.CodigoLocal AND 
		tbDoctoRecPag.EntradaSaidaDocumento = tbDoctoReceber.EntradaSaidaDocumento AND 
		tbDoctoRecPag.NumeroDocumento = tbDoctoReceber.NumeroDocumento AND 
		tbDoctoRecPag.DataDocumento = tbDoctoReceber.DataDocumento AND 
		tbDoctoRecPag.CodigoCliFor = tbDoctoReceber.CodigoCliFor AND 
		tbDoctoRecPag.TipoLancamentoMovimentacao = tbDoctoReceber.TipoLancamentoMovimentacao AND 
		tbDoctoRecPag.SequenciaDoctoRecPag = tbDoctoReceber.SequenciaDoctoRecPag

		LEFT JOIN tbCliFor (NOLOCK) ON 
		tbDoctoRecPag.CodigoCliFor = tbCliFor.CodigoCliFor AND 
		tbDoctoRecPag.CodigoEmpresa = tbCliFor.CodigoEmpresa

		LEFT JOIN tbDocumentoFT (NOLOCK) ON
		tbDocumento.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa AND 
		tbDocumento.CodigoLocal = tbDocumentoFT.CodigoLocal AND 
		tbDocumento.EntradaSaidaDocumento = tbDocumentoFT.EntradaSaidaDocumento AND 
		tbDocumento.NumeroDocumento = tbDocumentoFT.NumeroDocumento AND 
		tbDocumento.DataDocumento = tbDocumentoFT.DataDocumento AND 
		tbDocumento.CodigoCliFor = tbDocumentoFT.CodigoCliFor AND 
		tbDocumento.TipoLancamentoMovimentacao = tbDocumentoFT.TipoLancamentoMovimentacao 

		LEFT JOIN tbPlanoPagamento (NOLOCK) ON
		tbDocumentoFT.CodigoEmpresa 	= 	tbPlanoPagamento.CodigoEmpresa AND
		tbDocumentoFT.CodigoPlanoPagamento = 	tbPlanoPagamento.CodigoPlanoPagamento		

	WHERE    
		tbDoctoRecPag.CodigoEmpresa = @CodigoEmpresa AND
		tbDoctoRecPag.EntradaSaidaDocumento = 'S' AND
		tbDoctoRecPag.TipoLancamentoMovimentacao <> 13 AND
		tbDoctoRecPag.CodigoLocal	BETWEEN @LocalInicial	AND @LocalFinal	AND
		CASE @DiaUtilVencto
			WHEN 'V' THEN tbDoctoRecPag.DataVenctoUtilDoctoRecPag 
			WHEN 'F' THEN tbDoctoRecPag.DataVenctoDoctoRecPag
		END	
		BETWEEN @VenctoUtilInicial		AND @VenctoUtilFinal	AND
		tbDoctoRecPag.CodigoTipoDoctoInclusao	BETWEEN @TipoDocumentoInicial	AND @TipoDocumentoFinal AND
		tbDoctoReceber.CodigoTipoCobranca		BETWEEN @TipoCobrancaInicial	AND @TipoCobrancaFinal	AND 
		tbDoctoRecPag.EmTrabalhoDoctoRecPag = 'F' 	AND
		(tbDoctoRecPagComplementar.TipoLoteDocto NOT IN (1 , 3) OR tbDoctoRecPagComplementar.TipoLoteDocto IS NULL)	AND
		((@ImprimirPagos = 'V'	AND (@DataEmissao IS NULL OR tbDoctoRecPag.DataPagamentoDoctoRecPag > @DataEmissao)) OR tbDoctoRecPag.DataPagamentoDoctoRecPag IS NULL) AND
		((tbDoctoRecPag.DataLiquidacaoDoctoRecPag IS NOT NULL AND tbDoctoRecPagComplementar.TipoLoteDocto = 3) OR tbDoctoRecPag.DataLiquidacaoDoctoRecPag IS NULL or tbDoctoRecPag.DataLiquidacaoDoctoRecPag > @DataEmissao) AND
		((tbDoctoRecPag.DataEstornoDoctoRecPag IS NOT NULL AND tbDoctoRecPagComplementar.TipoLoteDocto = 2) OR tbDoctoRecPag.DataEstornoDoctoRecPag IS NULL OR tbDoctoRecPag.DataEstornoDoctoRecPag > @DataEmissao)	AND
		(@DataEmissao IS NULL OR tbDoctoRecPag.DataDocumento <= @DataEmissao) AND
		(
		 (tbDocumentoFT.CodigoPlanoPagamento BETWEEN @DePlanoPagamento AND @AtePlanoPagamento)
		  OR
		 (@DePlanoPagamento = ' ' AND @AtePlanoPagamento = 'ZZZZ' AND tbDocumentoFT.CodigoPlanoPagamento IS NULL)
		)
		AND
		tbDocumento.DataDocumento BETWEEN @DaDataEmissao AND @AteDataEmissao
		-- Bordero Selecionado
		AND (
			 (tbDoctoRecPagComplementar.NumeroBordero IS NOT NULL AND @BorderoSelecionado = 'V')
				OR
			 (tbDoctoRecPagComplementar.NumeroBordero IS NULL AND @BorderoSelecionado = 'F')
				OR
			 (@BorderoSelecionado IS NULL)			
			)

IF @DoctosPrevistos	= 'V'
	BEGIN
	INSERT rtRelCRDoctosReceber
	SELECT	
		Spid = @@Spid,
		tbDoctoPrevisto.CodigoEmpresa CodigoEmpresa,
		tbDoctoPrevisto.DataVenctoDoctoPrevisto DataVenctoUtil,
		DATEDIFF(dd,tbDoctoPrevisto.DataVenctoDoctoPrevisto,@DataEmissao) NoDias,
		null,
		null,
		tbDoctoPrevisto.CodigoLocal CodigoLocal, 
		tbDoctoPrevisto.NumeroDoctoPrevisto NumeroDocumento,
		tbDoctoPrevisto.NumeroSeqDoctoPrevisto SequenciaDocumento,
		null,
		tbDoctoPrevisto.DataEmissaoDoctoPrevisto DataEmissaoDocumento,
		null,
		null,
		null,
		null,
		null,
		tbDoctoPrevisto.ValorDoctoPrevisto,
                '',
		null
	FROM	
		tbDoctoPrevisto (NOLOCK)
	WHERE    
		tbDoctoPrevisto.CodigoEmpresa = @CodigoEmpresa AND
		tbDoctoPrevisto.CodigoLocal	BETWEEN @LocalInicial	AND @LocalFinal		AND
		tbDoctoPrevisto.DataVenctoDoctoPrevisto	BETWEEN @VenctoUtilInicial AND @VenctoUtilFinal	AND
                tbDoctoPrevisto.TipoDoctoPrevisto = 1
	END

SET NOCOUNT OFF

SELECT 
	CodigoEmpresa
	,DataVenctoUtil
	,NoDias
	,CodigoCliFor
	,NomeCliFor
	,CodigoLocal
	,NumeroDocumento
	,SequenciaDocumento
	,DescricaoTipoDocumento
	,DataEmissaoDocumento
	,DataPagamento
	,CodigoBanco
	,CodigoAgencia
	,CodigoTipoCobranca
	,NumeroTitulo
	,Valor
	,CodigoPlanoPagamento
	,DataVenctoOriginal
FROM 
	rtRelCRDoctosReceber
WHERE Spid = @@Spid
ORDER BY 
	DataVenctoUtil, 
	DataPagamento, 
	NomeCliFor

DELETE FROM rtRelCRDoctosReceber where Spid = @@Spid
GO
GRANT EXECUTE ON dbo.whRelCRDoctosReceber TO SQLUsers
GO

