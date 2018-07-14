--drop PROCEDURE dbo.whRelCPDoctosPagar
go
CREATE PROCEDURE dbo.whRelCPDoctosPagar

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: CDC - Consulters/Humaita
 PROJETO......: Contas a Pagar
 AUTOR........: Marcello Ferri
 DATA.........: 16/06/1998
 UTILIZADO EM : RelDoctosaPagar.rpt
 OBJETIVO.....: Trazer Documentos a Pagar por Data de Vencimento

 whRelCPDoctosPagar 1000, '2002-10-01', V, 0, 0, '2002-01-01','2002-10-31', V, 0, 99, 0, 2
 whRelCPDoctosPagar 1608, '2015-12-31',V,0,0, '2015-01-01','2015-12-31', F, 0, 99, 0, 2,NULL
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/


-- exec dbo.whRelCPDoctosPagar 260,'2018-07-13 00:00:00','F',0,9999,'1900-01-01 00:00:00','2050-12-31 23:59:59','F',0,99,0,99,NULL


	@CodigoEmpresa			dtInteiro04, 
	@EmitidosAte			datetime,	
	@ImprimirPagosApos		dtBooleano,  
	@LocalInicial			dtInteiro04,
	@LocalFinal				dtInteiro04,
	@DoVencto				datetime,
	@AteVencto				datetime,
--	@AteVencto				varchar(20),
	@DoctosPrevistos		dtBooleano,
	@DeTipoDocto			dtInteiro02,
	@AteTipoDocto			dtInteiro02,	
	@DeTipoPagto			dtInteiro02,
	@AteTipoPagto			dtInteiro02,
	@BorderoSelecionado		char(1) = NULL


AS


DELETE FROM rtRelCPDoctosPagar where Spid = @@Spid

SET NOCOUNT ON

	INSERT rtRelCPDoctosPagar
	
	SELECT	
		Spid = @@Spid,
		tbDoctoRecPag.CodigoEmpresa						CodigoEmpresa,
		tbDoctoRecPag.DataVenctoUtilDoctoRecPag			DataVenctoUtil,
		DATEDIFF(dd,tbDoctoRecPag.DataVenctoUtilDoctoRecPag,@EmitidosAte) 	NoDias,
		tbDoctoRecPag.CodigoCliFor						CodigoCliFor, 
		tbCliFor.NomeCliFor								NomeCliFor,
		tbDoctoRecPag.CodigoLocal						CodigoLocal, 
		tbDoctoRecPag.NumeroDocumento					NumeroDocumento,
		tbDoctoRecPag.SequenciaDoctoRecPag				SequenciaDocumento,
		tbTipoDocumento.DescricaoTipoDocumento			DescricaoTipoDocumento,
		tbDocumento.DataDocumento						DataDocumento,
		tbDocumento.DataEmissaoDocumento				DataEmissaoDocumento,
		tbDoctoRecPag.DataPagamentoDoctoRecPag			DataPagamento,
		tbDoctoRecPag.CodigoBanco						CodigoBanco, 
		tbDoctoRecPag.CodigoAgencia						CodigoAgencia,
        tbTipoPagamento.AbreviaturaTipoPagamento		AbreviaturaTipoPagamento,
		tbDoctoRecPag.NumeroTituloDoctoRecPag			NumeroTitulo,
		Valor = ( 
			CASE WHEN tbTipoDocumentoComplementar.SinalTipoDocto = 'P' THEN 
				(tbDoctoRecPag.ValorEmissaoDoctoRecPag       
				- tbDoctoRecPag.ValorAbatimentoDoctoRecPag    
				- tbDoctoRecPag.ValorLigadoDoctoRecPag 
				- ISNULL((
					SELECT 			
						SUM(ValorPagtoParcelaDoctoRecPag) - SUM(ValorJurosParcelaDoctoRecPag)
						- SUM(ValorMultaParcela) + SUM(ValorDescParcelaDoctoRecPag) - SUM(ValorOutrasDespParcDoctoRecPag) 
						+ SUM(ValorPISParcelaDoctoReceber) + SUM(ValorCOFINSParcelaDoctoReceber)
						+ SUM(ValorIRPJParcelaDoctoReceber) + SUM(ValorContribSocialParcDoctoRec)
	
					FROM 
						tbParcelaDocto (NOLOCK)
					WHERE 
						CodigoEmpresa 				= tbDoctoRecPag.CodigoEmpresa
						AND CodigoLocal 			= tbDoctoRecPag.CodigoLocal
						AND EntradaSaidaDocumento 	= tbDoctoRecPag.EntradaSaidaDocumento
						AND NumeroDocumento 		= tbDoctoRecPag.NumeroDocumento
						AND DataDocumento 			= tbDoctoRecPag.DataDocumento
						AND CodigoCliFor 			= tbDoctoRecPag.CodigoCliFor
						AND TipoLancamentoMovimentacao 	= tbDoctoRecPag.TipoLancamentoMovimentacao
						AND SequenciaDoctoRecPag 		= tbDoctoRecPag.SequenciaDoctoRecPag
						AND DataPagtoParcelaDoctoRecPag <= @EmitidosAte
						AND EfetivadoPagtoParcDoctoRecPag = 'V'
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
						+ SUM(ValorIRPJParcelaDoctoReceber) + SUM(ValorContribSocialParcDoctoRec)	
					FROM 
						tbParcelaDocto (NOLOCK)
					WHERE 
		  				CodigoEmpresa 				= tbDoctoRecPag.CodigoEmpresa
				 		AND CodigoLocal 			= tbDoctoRecPag.CodigoLocal
						AND EntradaSaidaDocumento 	= tbDoctoRecPag.EntradaSaidaDocumento
						AND NumeroDocumento 		= tbDoctoRecPag.NumeroDocumento
						AND DataDocumento 			= tbDoctoRecPag.DataDocumento
						AND CodigoCliFor 			= tbDoctoRecPag.CodigoCliFor
						AND TipoLancamentoMovimentacao 	= tbDoctoRecPag.TipoLancamentoMovimentacao
						AND SequenciaDoctoRecPag 		= tbDoctoRecPag.SequenciaDoctoRecPag
						AND DataPagtoParcelaDoctoRecPag <= @EmitidosAte
						AND EfetivadoPagtoParcDoctoRecPag = 'V'
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
			END),
                @EmitidosAte 
	FROM	
		tbDoctoRecPag  
		INNER JOIN tbDocumentoPagar ON
		tbDoctoRecPag.CodigoEmpresa                  = tbDocumentoPagar.CodigoEmpresa              AND
		tbDoctoRecPag.CodigoLocal                    = tbDocumentoPagar.CodigoLocal                AND
		tbDoctoRecPag.EntradaSaidaDocumento          = tbDocumentoPagar.EntradaSaidaDocumento      AND
		tbDoctoRecPag.NumeroDocumento                = tbDocumentoPagar.NumeroDocumento            AND
		tbDoctoRecPag.DataDocumento                  = tbDocumentoPagar.DataDocumento              AND
		tbDoctoRecPag.CodigoCliFor                   = tbDocumentoPagar.CodigoCliFor               AND
		tbDoctoRecPag.TipoLancamentoMovimentacao     = tbDocumentoPagar.TipoLancamentoMovimentacao AND
		tbDoctoRecPag.SequenciaDoctoRecPag           = tbDocumentoPagar.SequenciaDoctoRecPag

                -- Wagner Breggi - Em 11/09/1998
		 
                INNER JOIN tbDoctoRecPagComplementar (NOLOCK)On 

		tbDoctoRecPag.CodigoEmpresa                  = tbDoctoRecPagComplementar.CodigoEmpresa              AND
		tbDoctoRecPag.CodigoLocal                    = tbDoctoRecPagComplementar.CodigoLocal                AND
		tbDoctoRecPag.EntradaSaidaDocumento          = tbDoctoRecPagComplementar.EntradaSaidaDocumento      AND
		tbDoctoRecPag.NumeroDocumento                = tbDoctoRecPagComplementar.NumeroDocumento            AND
		tbDoctoRecPag.DataDocumento                  = tbDoctoRecPagComplementar.DataDocumento              AND
		tbDoctoRecPag.CodigoCliFor                   = tbDoctoRecPagComplementar.CodigoCliFor               AND
		tbDoctoRecPag.TipoLancamentoMovimentacao     = tbDoctoRecPagComplementar.TipoLancamentoMovimentacao AND
		tbDoctoRecPag.SequenciaDoctoRecPag           = tbDoctoRecPagComplementar.SequenciaDoctoRecPag

		INNER JOIN tbTipoDocumento(NOLOCK) ON 
		tbDoctoRecPag.CodigoEmpresa = tbTipoDocumento.CodigoEmpresa AND 
		tbDoctoRecPag.CodigoTipoDoctoInclusao = tbTipoDocumento.CodigoTipoDocumento AND 
		tbDoctoRecPag.CaractTipoDoctoInclusao = tbTipoDocumento.CaracteristicaTipoDocto 

		INNER JOIN tbDocumento(NOLOCK) ON 
		tbDoctoRecPag.CodigoEmpresa = tbDocumento.CodigoEmpresa AND 
		tbDoctoRecPag.CodigoLocal = tbDocumento.CodigoLocal AND 
		tbDoctoRecPag.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND 
		tbDoctoRecPag.NumeroDocumento = tbDocumento.NumeroDocumento AND 
		tbDoctoRecPag.DataDocumento = tbDocumento.DataDocumento AND 
		tbDoctoRecPag.CodigoCliFor = tbDocumento.CodigoCliFor AND 
		tbDoctoRecPag.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao 

		LEFT OUTER JOIN tbCliFor (NOLOCK)ON 
		tbDoctoRecPag.CodigoCliFor = tbCliFor.CodigoCliFor AND 
		tbDoctoRecPag.CodigoEmpresa = tbCliFor.CodigoEmpresa

		INNER JOIN tbTipoPagamento (NOLOCK)ON
		tbDocumentoPagar.CodigoEmpresa                  = tbTipoPagamento.CodigoEmpresa                 AND
		tbDocumentoPagar.CodigoTipoPagamento            = tbTipoPagamento.CodigoTipoPagamento

		INNER JOIN tbTipoDocumentoComplementar (NOLOCK)	ON
		tbTipoDocumento.CodigoEmpresa                  = tbTipoDocumentoComplementar.CodigoEmpresa             AND
		tbTipoDocumento.CaracteristicaTipoDocto        = tbTipoDocumentoComplementar.CaracteristicaTipoDocto   AND
		tbTipoDocumento.CodigoTipoDocumento            = tbTipoDocumentoComplementar.CodigoTipoDocumento
	WHERE    
                (tbDoctoRecPag.TipoLancamentoMovimentacao <> 13) AND   
		(tbDoctoRecPag.CodigoEmpresa = @CodigoEmpresa) AND
		(tbDoctoRecPag.CodigoLocal	BETWEEN @LocalInicial	AND @LocalFinal)					AND
		(tbDoctoRecPag.CodigoTipoDoctoInclusao BETWEEN @DeTipoDocto AND @AteTipoDocto)      	AND
		(tbDocumentoPagar.CodigoTipoPagamento BETWEEN @DeTipoPagto	AND @AteTipoPagto)			AND
		(tbDoctoRecPag.DataVenctoUtilDoctoRecPag BETWEEN @DoVencto	AND @AteVencto)				AND
		(tbDoctoRecPag.DataDocumento <= @EmitidosAte)					
		AND tbDoctoRecPag.EmTrabalhoDoctoRecPag = 'F' 
		AND (
			tbDoctoRecPagComplementar.TipoLoteDocto = 5
			OR tbDoctoRecPagComplementar.TipoLoteDocto IS NULL
		)

		AND (
			(
			@ImprimirPagosApos = 'V'
			AND (
				(@EmitidosAte IS NULL)
 				OR (tbDoctoRecPag.DataPagamentoDoctoRecPag > @EmitidosAte)
			     )
			)
			OR tbDoctoRecPag.DataPagamentoDoctoRecPag IS NULL 
		) 
	
		AND ((tbDoctoRecPag.DataEstornoDoctoRecPag	IS NOT NULL AND tbDoctoRecPagComplementar.TipoLoteDocto = 5 )
			OR tbDoctoRecPag.DataEstornoDoctoRecPag IS NULL 
			OR tbDoctoRecPag.DataEstornoDoctoRecPag > @EmitidosAte )
		AND 
			(
			 (tbDoctoRecPagComplementar.NumeroBordero IS NOT NULL AND @BorderoSelecionado = 'V')
				OR
			 (tbDoctoRecPagComplementar.NumeroBordero IS NULL AND @BorderoSelecionado = 'F')
				OR
			 (@BorderoSelecionado IS NULL)	
			)


	IF @DoctosPrevistos = 'V'
	
	BEGIN
	INSERT rtRelCPDoctosPagar
	SELECT	
		Spid = @@Spid,
		tbDoctoPrevisto.CodigoEmpresa 						CodigoEmpresa,
		tbDoctoPrevisto.DataVenctoDoctoPrevisto 			DataVenctoUtil,
		DATEDIFF(dd,tbDoctoPrevisto.DataVenctoDoctoPrevisto,@EmitidosAte) 	NoDias,
		tbCliFor.CodigoCliFor,
		coalesce(tbCliFor.NomeCliFor,tbDoctoPrevisto.DescricaoDoctoPrevisto) DescricaoDocumento,
		tbDoctoPrevisto.CodigoLocal 						CodigoLocal, 
		tbDoctoPrevisto.NumeroDoctoPrevisto 				NumeroDocumento,
		tbDoctoPrevisto.NumeroSeqDoctoPrevisto 				SequenciaDocumento,
		tbTipoDocumento.DescricaoTipoDocumento,
		tbDoctoPrevisto.DataEmissaoDoctoPrevisto 			DataDocumento,
		tbDoctoPrevisto.DataEmissaoDoctoPrevisto 			DataEmissaoDocumento,
		null,
		null,
		null,
		null,
		null,
		tbDoctoPrevisto.ValorDoctoPrevisto,
                @EmitidosAte 
	FROM tbDoctoPrevisto(NOLOCK)
	INNER JOIN tbDoctoPrevistoPagar (NOLOCK) ON
			   tbDoctoPrevistoPagar.CodigoEmpresa = @CodigoEmpresa AND
			   tbDoctoPrevistoPagar.CodigoLocal = tbDoctoPrevisto.CodigoLocal AND
			   tbDoctoPrevistoPagar.TipoDoctoPrevisto = tbDoctoPrevisto.TipoDoctoPrevisto AND
			   tbDoctoPrevistoPagar.NumeroDoctoPrevisto = tbDoctoPrevisto.NumeroDoctoPrevisto AND
			   tbDoctoPrevistoPagar.NumeroSeqDoctoPrevisto = tbDoctoPrevisto.NumeroSeqDoctoPrevisto AND
			   ( tbDoctoPrevistoPagar.CodigoCliFor = tbDoctoPrevisto.CodigoCliFor or
				 tbDoctoPrevistoPagar.CodigoCliFor is null and tbDoctoPrevisto.CodigoCliFor is null )
	LEFT JOIN tbTipoDocumento (NOLOCK) ON 
			   tbTipoDocumento.CodigoEmpresa = @CodigoEmpresa AND
			   tbTipoDocumento.CaracteristicaTipoDocto = 'CP' AND
			   tbTipoDocumento.CodigoTipoDocumento =  tbDoctoPrevistoPagar.CodigoTipoDocumento
	LEFT JOIN tbCliFor (NOLOCK) ON
			  tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
			  tbCliFor.CodigoCliFor = tbDoctoPrevistoPagar.CodigoCliFor 
	WHERE    
		tbDoctoPrevisto.CodigoEmpresa = @CodigoEmpresa				AND
		tbDoctoPrevisto.CodigoLocal	BETWEEN @LocalInicial			AND @LocalFinal	AND
		tbDoctoPrevisto.DataVenctoDoctoPrevisto	BETWEEN @DoVencto	AND @AteVencto	AND
        tbDoctoPrevisto.TipoDoctoPrevisto = 2
		AND ( tbDoctoPrevistoPagar.CodigoTipoDocumento BETWEEN @DeTipoDocto AND @AteTipoDocto or
			  ( tbDoctoPrevistoPagar.CodigoTipoDocumento is null and @DeTipoDocto = 0 and @AteTipoDocto = 99 )
			)
END
SET NOCOUNT OFF

IF NOT EXISTS ( SELECT 1 FROM rtRelCPDoctosPagar 
				WHERE 
				Spid = @@Spid )
BEGIN
	insert rtRelCPDoctosPagar
	SELECT	
		Spid = @@Spid,
		@CodigoEmpresa,
		null as DataVenctoUtil,
		null as NoDias,
		null,
		'SEM TITULOS A PAGAR' + CHAR(13) + CHAR(10) + CASE WHEN @LocalInicial = @LocalFinal THEN (SELECT 'Local : ' + CONVERT(VARCHAR(4),@LocalInicial) + '-' + DescricaoLocal FROM tbLocal WHERE CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @LocalInicial ) ELSE '' END,
		NULL , 
		0 ,
		NULL ,
		NULL ,
		NULL ,
		NULL ,
		null,
		null,
		null,
		null,
		null,
		0,
		@EmitidosAte 
END 

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
	,DataDocumento
	,DataEmissaoDocumento
	,DataPagamento
	,CodigoBanco
	,CodigoAgencia
	,DescricaoTipoPagamento
	,NumeroTitulo
	,Valor
	,EmitidosAte
FROM 
	rtRelCPDoctosPagar 
WHERE 
	Spid = @@Spid
ORDER BY 
	CodigoEmpresa, DataVenctoUtil, NomeCliFor




DELETE FROM rtRelCPDoctosPagar where Spid = @@Spid



go
grant execute on dbo.whRelCPDoctosPagar to SQLUsers
go