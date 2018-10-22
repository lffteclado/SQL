drop proc dbo.whDocumentoProduto
go
CREATE PROCEDURE dbo.whDocumentoProduto ----1608,0,0,'','ZZ','2005-01-01','2005-01-31','A'
	@CodigoEmpresa        dtInteiro04,
	@CodigoLocalInicial   dtInteiro04,
	@CodigoLocalFinal     dtInteiro04,
	@UFInicial            char(2)    ,
	@UFFinal              char(2)    ,
	@DataDocumentoInicial datetime   ,
	@DataDocumentoFinal   datetime   ,
     	@EntradaSaida	      char(2)	

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: CDC - Consulters/Humaita
 PROJETO......: Livros Fiscais
 AUTOR........: Tania Okuzono
 DATA.........: 08/04/1998
 UTILIZADO EM : clsDocumento.PesquisarTodosProduto
 OBJETIVO.....: Stored procedure referente a Registro de Produto

 ALTERACAO....: Tania Okuzono - 30/09/1998
 OBJETIVO.....: Juncao table tbDocumentoLF em tbDocumento
		Juncao table tbItemDocumentoLF em tbItemDocumento

 ALTERACAO....: Fabiane - 17/09/1999
 OBJETIVO.....: Alteracao nos filtros (TipoLancamentoMovimentacao) 

 ALTERACAO....: Fabiane - 14/10/1998
 OBJETIVO.....: Os documentos ref. a pessoas fisicas passam a ser exibidos. Antes,
		os documentos exibidos eram apenas das pessoas juridicas.

 ALTERACAO....: Fabiane - 18/10/1998
 OBJETIVO.....: Link da tbUnidadeFederacao com a tbCliFor.

 ALTERACAO....: Fabiane - 19/01/2000
 OBJETIVO.....: Acrescentar registros respeitando:
		- Se ValorFreteItemDocto 	<> 0	Item = 991
		- Se ValorSeguroItemDocto	<> 0	Item = 992
		- Se ValorDespAcesItemDocto 	<> 0	Item = 999		
		Acrescentar o campo CodigoCFO 

 ALTERACAO....: Fabiane - 01/02/2000
 OBJETIVO.....: - ExclusÝo da Consistencia do CodigoModeloNotaFiscal e CodigoCFO

 ALTERACAO....: Simone Rainho - 16/05/2000
 OBJETIVO.....: Alteracao conforme FM 2113

 ALTERACAO....: Simone Rainho - 22/05/2000
 OBJETIVO.....: Alteracao conforme FM 2113

 ALTERACAO....: Alex Kmez - 05/09/2002
 OBJETIVO.....: Alteracao conforme FM 7654

 ALTERACAO....: Alex Kmez - 09/10/2002
 OBJETIVO.....: Substituicao das tabelas #tmp por rts - Performance

select * from tbLocal
dbo.whDocumentoProduto 2620,0,0,'','ZZ','2009-01-20','2009-01-20','A'
SELECT * FROM tbDocumento where CondicaoComplementoICMSDocto = 'V'
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

AS

SET NOCOUNT ON

TRUNCATE TABLE rtDocumentoProduto

INSERT rtDocumentoProduto

SELECT 	
	Spid = @@Spid,
	tbDocumento.CodigoLocal,
	tbDocumento.NumeroDocumento,
	tbDocumento.EntradaSaidaDocumento,
	tbDocumento.CodigoCliFor,
	DataDocumentoOriginal = tbDocumento.DataDocumento,
	DataDocumento = tbDocumento.DataDocumento,
	tbDocumento.TipoLancamentoMovimentacao,
	CASE WHEN tbDocumento.SerieDocumento = '0' THEN '' ELSE tbDocumento.SerieDocumento END AS SerieDocumento,
	tbDocumento.DataEmissaoDocumento,
	CASE WHEN tbDocumento.EspecieDocumento = 'NFE' and tbDocumento.SerieDocumento = '0' THEN
		55
	ELSE
		tbDocumento.CodigoModeloNotaFiscal
	END as CodigoModeloNotaFiscal,
	SequenciaItemDocumento,
	tbItemDocumento.CodigoCFO,
	CGCLocal = 
		CASE 
			WHEN SUBSTRING(COALESCE(tbClienteEventual.CGCCliEven,tbCliForJuridica.CGCJuridica),1,6) = 'ISENTO' THEN
				'00000000000000'
			ELSE
				COALESCE(tbClienteEventual.CGCCliEven,tbCliForJuridica.CGCJuridica)
			END,
	InscricaoEstadualLocal =
		CASE 
			WHEN SUBSTRING(COALESCE(tbClienteEventual.InscricaoEstadualCliEven,tbCliForJuridica.InscricaoEstadualJuridica),1,6) = 'ISENTO' THEN
				''
			ELSE
				COALESCE(tbClienteEventual.InscricaoEstadualCliEven,tbCliForJuridica.InscricaoEstadualJuridica)
			END,

	UFLocal = tbCliFor.UFCliFor,	
	ValorFreteItemDocto = Sum(tbItemDocumento.ValorFreteItemDocto),
	ValorSeguroItemDocto = Sum(tbItemDocumento.ValorSeguroItemDocto),
	ValorDespAcesItemDocto = Sum(tbItemDocumento.ValorDespAcesItemDocto),
	tbItemDocumento.CodigoProduto,
	tbItemDocumento.CodigoItemDocto,
        tbItemDocumento.TipoRegistroItemDocto
FROM   
	tbDocumento (nolock)
	INNER JOIN tbCliFor (nolock) ON
       		tbDocumento.CodigoEmpresa              		= tbCliFor.CodigoEmpresa
		AND tbDocumento.CodigoCliFor               	= tbCliFor.CodigoCliFor
	INNER JOIN tbCliForJuridica (nolock) ON
		tbCliFor.CodigoEmpresa                 		= tbCliForJuridica.CodigoEmpresa
		AND tbCliFor.CodigoCliFor                  	= tbCliForJuridica.CodigoCliFor	   					    
	INNER JOIN tbItemDocumento (nolock) ON
		tbDocumento.CodigoEmpresa              		= tbItemDocumento.CodigoEmpresa 
		AND tbDocumento.CodigoLocal                	= tbItemDocumento.CodigoLocal 
		AND tbDocumento.EntradaSaidaDocumento      	= tbItemDocumento.EntradaSaidaDocumento 
		AND tbDocumento.NumeroDocumento            	= tbItemDocumento.NumeroDocumento 
		AND tbDocumento.DataDocumento              	= tbItemDocumento.DataDocumento 
		AND tbDocumento.CodigoCliFor               	= tbItemDocumento.CodigoCliFor 
		AND tbDocumento.TipoLancamentoMovimentacao 	= tbItemDocumento.TipoLancamentoMovimentacao
	LEFT JOIN tbDocumentoFT ON
		tbDocumentoFT.CodigoEmpresa		= tbItemDocumento.CodigoEmpresa
		AND tbDocumentoFT.CodigoLocal		= tbItemDocumento.CodigoLocal
		AND tbDocumentoFT.EntradaSaidaDocumento	= tbItemDocumento.EntradaSaidaDocumento
		AND tbDocumentoFT.NumeroDocumento		= tbItemDocumento.NumeroDocumento
		AND tbDocumentoFT.CodigoCliFor		= tbItemDocumento.CodigoCliFor	    
	 	AND tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao 
		AND tbDocumentoFT.DataDocumento		= tbItemDocumento.DataDocumento 
	LEFT JOIN tbClienteEventual ON
		tbClienteEventual.CodigoEmpresa 	= @CodigoEmpresa AND
                tbClienteEventual.CodigoClienteEventual = tbDocumentoFT.CodigoClienteEventual
	LEFT JOIN tbProdutoFT (nolock) ON
        	tbItemDocumento.CodigoEmpresa       		= tbProdutoFT.CodigoEmpresa
		AND  tbItemDocumento.CodigoProduto      	= tbProdutoFT.CodigoProduto
	INNER JOIN tbUnidadeFederacao (nolock) ON 
		tbCliFor.UFCliFor				= tbUnidadeFederacao.UnidadeFederacao
	LEFT JOIN tbUnidadeDIPI (nolock) ON
       		tbItemDocumento.CodigoUnidadeDIPI        	= tbUnidadeDIPI.CodigoUnidadeDIPI
	LEFT JOIN tbNaturezaOperacao (nolock) ON
		tbItemDocumento.CodigoEmpresa 			= tbNaturezaOperacao.CodigoEmpresa AND
		tbItemDocumento.CodigoNaturezaOperacao 		= tbNaturezaOperacao.CodigoNaturezaOperacao 
	INNER JOIN tbLocalLF (nolock) ON
		tbLocalLF.CodigoEmpresa				= tbItemDocumento.CodigoEmpresa AND
		tbLocalLF.CodigoLocal				= tbItemDocumento.CodigoLocal 
	INNER JOIN tbLocal ON
        	tbItemDocumento.CodigoEmpresa    = tbLocal.CodigoEmpresa
   		AND tbItemDocumento.CodigoLocal  = tbLocal.CodigoLocal

WHERE 
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao AND
		tbItemDocumento.TipoLancamentoMovimentacao IN (1,7,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)			
	OR  tbDocumento.TipoLancamentoMovimentacao IN (9,10,12)
	)
	AND ( tbDocumento.EspecieDocumento	<> 'ECF' OR tbLocal.UFLocal = 'PI' )
	AND tbDocumento.CodigoModeloNotaFiscal <> 8
	AND tbCliFor.TipoCliFor  		= 'J'
	AND tbDocumento.CodigoEmpresa		= @CodigoEmpresa 
	AND tbDocumento.CodigoLocal		between @CodigoLocalInicial   and @CodigoLocalFinal
	AND tbDocumento.DataDocumento		between @DataDocumentoInicial and @DataDocumentoFinal
	AND tbUnidadeFederacao.UnidadeFederacao between @UFInicial and @UFFinal
	AND tbDocumento.CodigoModeloNotaFiscal IN (1,3,6,21,22,55)
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND (@EntradaSaida = 'A' OR tbDocumento.EntradaSaidaDocumento = @EntradaSaida)
	AND tbDocumento.CondicaoNFCancelada <> 'V'
	AND tbDocumento.ValorContabilDocumento <> 0
	AND (
         (tbLocalLF.ImprimeServicoRegSaida = 'F' AND tbItemDocumento.ValorISSItemDocto = 0)
         OR 
         (tbLocalLF.ImprimeServicoRegSaida = 'V')
		 OR
		 tbDocumento.EntradaSaidaDocumento = 'E'
        )

GROUP BY
	tbDocumento.CodigoLocal,
	tbDocumento.NumeroDocumento,
	tbDocumento.EntradaSaidaDocumento,
	tbDocumento.CodigoCliFor,
	tbDocumento.DataDocumento,
	tbDocumento.TipoLancamentoMovimentacao,
	tbDocumento.SerieDocumento,
	tbDocumento.DataEmissaoDocumento,
	tbDocumento.CodigoModeloNotaFiscal,
	tbItemDocumento.SequenciaItemDocumento,
	tbItemDocumento.CodigoCFO,
	tbCliForJuridica.CGCJuridica,
	tbCliForJuridica.InscricaoEstadualJuridica,
	tbCliFor.UFCliFor,
	tbItemDocumento.CodigoProduto,
	tbItemDocumento.CodigoItemDocto,
	tbClienteEventual.CGCCliEven,
	tbClienteEventual.InscricaoEstadualCliEven,
    tbItemDocumento.TipoRegistroItemDocto,
    tbDocumento.EspecieDocumento


INSERT INTO rtDocumentoProduto
SELECT 
	Spid = @@Spid,
	tbDocumento.CodigoLocal,
	tbDocumento.NumeroDocumento,
	tbDocumento.EntradaSaidaDocumento,
	tbDocumento.CodigoCliFor,
	DataDocumentoOriginal = tbDocumento.DataDocumento,
	DataDocumento = tbDocumento.DataDocumento,
	tbDocumento.TipoLancamentoMovimentacao,
	CASE WHEN tbDocumento.SerieDocumento = '0' THEN '' ELSE tbDocumento.SerieDocumento END AS SerieDocumento,
	tbDocumento.DataEmissaoDocumento,
	CASE WHEN tbDocumento.EspecieDocumento = 'NFE' and tbDocumento.SerieDocumento = '0' THEN
		55
	ELSE
		tbDocumento.CodigoModeloNotaFiscal
	END as CodigoModeloNotaFiscal,
	SequenciaItemDocumento,
	CodigoCFO = tbItemDocumento.CodigoCFO,
	CGCLocal =	CASE WHEN tbClienteEventual.CGCCliEven IS NOT NULL THEN
					tbClienteEventual.CGCCliEven
				ELSE
					COALESCE(tbClienteEventual.CPFCliEven,tbCliForFisica.CPFFisica)
				END,  
	InscricaoEstadualLocal = CASE WHEN tbClienteEventual.InscricaoEstadualCliEven IS NOT NULL THEN
									tbClienteEventual.InscricaoEstadualCliEven
							 ELSE
									''
						     END,
	UFLocal = tbCliFor.UFCliFor,
	ValorFreteItemDocto = Sum(tbItemDocumento.ValorFreteItemDocto),
	ValorSeguroItemDocto = Sum(tbItemDocumento.ValorSeguroItemDocto),
	ValorDespAcesItemDocto = Sum(tbItemDocumento.ValorDespAcesItemDocto),
	tbItemDocumento.CodigoProduto,
	tbItemDocumento.CodigoItemDocto,
        tbItemDocumento.TipoRegistroItemDocto
FROM   
	tbDocumento (nolock)
	INNER JOIN tbCliFor (nolock) ON
       		tbDocumento.CodigoEmpresa              		= tbCliFor.CodigoEmpresa
		AND tbDocumento.CodigoCliFor               	= tbCliFor.CodigoCliFor
	INNER JOIN tbCliForFisica (nolock) ON
		tbCliFor.CodigoEmpresa                 		= tbCliForFisica.CodigoEmpresa
		AND tbCliFor.CodigoCliFor                  	= tbCliForFisica.CodigoCliFor	   					    
	INNER JOIN tbItemDocumento (nolock) ON
		tbDocumento.CodigoEmpresa              		= tbItemDocumento.CodigoEmpresa 
		AND tbDocumento.CodigoLocal                	= tbItemDocumento.CodigoLocal 
		AND tbDocumento.EntradaSaidaDocumento      	= tbItemDocumento.EntradaSaidaDocumento 
		AND tbDocumento.NumeroDocumento            	= tbItemDocumento.NumeroDocumento 
		AND tbDocumento.DataDocumento              	= tbItemDocumento.DataDocumento 
		AND tbDocumento.CodigoCliFor               	= tbItemDocumento.CodigoCliFor 
		AND tbDocumento.TipoLancamentoMovimentacao 	= tbItemDocumento.TipoLancamentoMovimentacao
	LEFT JOIN tbDocumentoFT ON
		tbDocumentoFT.CodigoEmpresa		= tbItemDocumento.CodigoEmpresa
		AND tbDocumentoFT.CodigoLocal		= tbItemDocumento.CodigoLocal
		AND tbDocumentoFT.EntradaSaidaDocumento	= tbItemDocumento.EntradaSaidaDocumento
		AND tbDocumentoFT.NumeroDocumento		= tbItemDocumento.NumeroDocumento
		AND tbDocumentoFT.CodigoCliFor		= tbItemDocumento.CodigoCliFor	    
	 	AND tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao 
		AND tbDocumentoFT.DataDocumento		= tbItemDocumento.DataDocumento 
	LEFT JOIN tbClienteEventual ON
		tbClienteEventual.CodigoEmpresa 	= @CodigoEmpresa AND
                tbClienteEventual.CodigoClienteEventual = tbDocumentoFT.CodigoClienteEventual
	LEFT JOIN tbUnidadeDIPI (nolock) ON
       		tbItemDocumento.CodigoUnidadeDIPI        	= tbUnidadeDIPI.CodigoUnidadeDIPI
	LEFT JOIN tbProdutoFT (nolock) ON
        	tbItemDocumento.CodigoEmpresa       		= tbProdutoFT.CodigoEmpresa
		AND  tbItemDocumento.CodigoProduto      	= tbProdutoFT.CodigoProduto
	INNER JOIN tbUnidadeFederacao (nolock) ON 
		tbCliFor.UFCliFor				= tbUnidadeFederacao.UnidadeFederacao
	LEFT JOIN tbNaturezaOperacao (nolock) ON
		tbItemDocumento.CodigoEmpresa 			= tbNaturezaOperacao.CodigoEmpresa AND
		tbItemDocumento.CodigoNaturezaOperacao 		= tbNaturezaOperacao.CodigoNaturezaOperacao 
	INNER JOIN tbLocalLF (nolock) ON
		tbLocalLF.CodigoEmpresa				= tbItemDocumento.CodigoEmpresa AND
		tbLocalLF.CodigoLocal				= tbItemDocumento.CodigoLocal 
	INNER JOIN tbLocal ON
        	tbItemDocumento.CodigoEmpresa    = tbLocal.CodigoEmpresa
    		AND tbItemDocumento.CodigoLocal  = tbLocal.CodigoLocal

WHERE 
	(
	(
		tbNaturezaOperacao.CodigoEmpresa 		= tbItemDocumento.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao 	= tbItemDocumento.CodigoNaturezaOperacao AND
		tbItemDocumento.TipoLancamentoMovimentacao 	IN (1,7,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao	= 'V'
	)			
	OR  tbDocumento.TipoLancamentoMovimentacao IN (9,10,12)
	)
	AND ( tbDocumento.EspecieDocumento	<> 'ECF' OR tbLocal.UFLocal = 'PI' )
	AND tbCliFor.TipoCliFor  		= 'F'
	AND tbDocumento.CodigoModeloNotaFiscal <> 8
	AND tbDocumento.CodigoEmpresa		= @CodigoEmpresa 
	AND tbDocumento.CodigoLocal		between @CodigoLocalInicial   and @CodigoLocalFinal
	AND tbDocumento.DataDocumento		between @DataDocumentoInicial and @DataDocumentoFinal
	AND tbUnidadeFederacao.UnidadeFederacao between @UFInicial and @UFFinal
	AND tbDocumento.CodigoModeloNotaFiscal IN (1,3,6,21,22,55)
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND (@EntradaSaida = 'A' OR tbDocumento.EntradaSaidaDocumento = @EntradaSaida)
	AND tbDocumento.CondicaoNFCancelada <> 'V'
	AND tbDocumento.ValorContabilDocumento <> 0
	AND (
         (tbLocalLF.ImprimeServicoRegSaida = 'F' AND tbItemDocumento.ValorISSItemDocto = 0)
         OR 
         (tbLocalLF.ImprimeServicoRegSaida = 'V')
        )

GROUP BY
	tbDocumento.CodigoLocal,
	tbDocumento.NumeroDocumento,
	tbDocumento.EntradaSaidaDocumento,
	tbDocumento.CodigoCliFor,
	tbDocumento.DataDocumento,
	tbDocumento.TipoLancamentoMovimentacao,
	tbDocumento.SerieDocumento,
	tbDocumento.DataEmissaoDocumento,
	tbDocumento.CodigoModeloNotaFiscal,
	tbItemDocumento.SequenciaItemDocumento,
	tbItemDocumento.CodigoCFO,
	tbCliForFisica.CPFFisica,	
	tbCliFor.UFCliFor,
	tbItemDocumento.CodigoProduto,
	tbItemDocumento.CodigoItemDocto,
	tbClienteEventual.CPFCliEven,
    tbItemDocumento.TipoRegistroItemDocto,
	tbClienteEventual.CGCCliEven,
	tbClienteEventual.InscricaoEstadualCliEven,
    tbDocumento.EspecieDocumento

-- ****************************************************

SELECT 
	Registro = '54',
	rtDocumentoProduto.NumeroDocumento,
	rtDocumentoProduto.EntradaSaidaDocumento,
	rtDocumentoProduto.DataDocumento ,
	rtDocumentoProduto.SerieDocumento,
	rtDocumentoProduto.DataEmissaoDocumento,
	rtDocumentoProduto.CodigoModeloNotaFiscal,
	0 as SequenciaItemDocumento,
	rtDocumentoProduto.CodigoCFO,
	rtDocumentoProduto.CGCLocal,
	min(rtDocumentoProduto.InscricaoEstadualLocal) as InscricaoEstadualLocal ,
	min(rtDocumentoProduto.UFLocal) as UFLocal,	
	CASE WHEN ( rtDocumentoProduto.EntradaSaidaDocumento = 'E' or
		    tbItemDocumento.TipoLancamentoMovimentacao <> 7 or	
    	            sum(tbItemDocumento.ValorContabilItemDocto) = 0 or
		    sum( ValorProdutoItemDocto - ValorContabilItemDocto ) < 0 OR
	            ( tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V') 
		  ) THEN
		0	
	ELSE
		sum( ValorDescontoItemDocto )
	END as ValorDescontoItemDocto,
	tbItemDocumento.CodigoItemDocto,
	CodigoProduto = 
		CASE
			WHEN tbDocumento.CondicaoComplementoICMSDocto = 'V' THEN
                ''
			WHEN tbItemDocumento.CodigoProduto is not null THEN
				CASE WHEN LEN(RTRIM(REPLACE(tbItemDocumento.CodigoProduto,' ',''))) <= 14 THEN
					REPLACE(tbItemDocumento.CodigoProduto,' ','') 
				ELSE
				        SUBSTRING(REPLACE(tbItemDocumento.CodigoProduto,' ',''),LEN(REPLACE(tbItemDocumento.CodigoProduto,' ',''))-13,14)
				END
			WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
				SUBSTRING(REPLACE(tbItemDocumento.CodigoMaoObraOS,' ',''),1,14)
			WHEN tbVeiculoCV.NumeroChassisCV is not null THEN
                                CASE WHEN LEN(RTRIM(NumeroChassisCV)) > 6 THEN
	                                SUBSTRING(RTRIM(REPLACE(NumeroChassisCV,' ','')),LEN(RTRIM(NumeroChassisCV)) - 5,6)
				ELSE
	                                RTRIM(REPLACE(NumeroChassisCV,' ',''))
				END
			WHEN tbItemDocumento.CodigoItemDocto is not null THEN
				SUBSTRING(REPLACE(tbItemDocumento.CodigoItemDocto,' ',''),1,14)
			ELSE
				'USOCONSUMO'
			END,
	QtdeLancamentoItemDocto = 
		CASE WHEN sum(tbItemDocumento.ValorContabilItemDocto) > 0 and sum(tbItemDocumento.QtdeLancamentoItemDocto) = 0 THEN
			1
		ELSE
			sum(tbItemDocumento.QtdeLancamentoItemDocto)
		END,
	sum(tbItemDocumento.ValorProdutoItemDocto) as ValorProdutoItemDocto,
	ValorTotalProduto = CASE WHEN (
                                       rtDocumentoProduto.EntradaSaidaDocumento = 'E' or
				       tbItemDocumento.TipoLancamentoMovimentacao <> 7 or
				       sum(tbItemDocumento.ValorContabilItemDocto) = 0	                                       
				      ) 	
                                        THEN 
                                 sum(tbItemDocumento.ValorContabilItemDocto) - (CASE WHEN sum(ValorICMSSubstTribItemDocto) = sum(ValorICMSRetidoItemDocto) THEN
													sum(tbItemDocumento.ValorICMSSubstTribItemDocto)
												ELSE
													sum(ValorICMSRetidoItemDocto)
												END ) - sum(tbItemDocumento.ValorIPIItemDocto)
				 WHEN ( tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V') THEN
				 0	
				 ELSE
				 sum(tbItemDocumento.ValorContabilItemDocto + tbItemDocumento.ValorDescontoItemDocto - tbItemDocumento.ValorIPIItemDocto)
			    END, 	---tbItemDocumento.ValorProdutoItemDocto *  tbItemDocumento.QtdeLancamentoItemDocto,
	PercentualICMSItemDocto =
	CASE
		WHEN tbDocumento.CondicaoNFCancelada = 'V' THEN
			0
		ELSE
		     	PercentualICMSItemDocto
		END,
	ValorBaseICMS1ItemDocto = 
        CASE 
        	WHEN (tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V') THEN
			0
                ELSE
			sum(tbItemDocumento.ValorBaseICMS1ItemDocto)
		END,
	BaseICMSSubstTribItemDocto = sum(tbItemDocumento.BaseICMSSubstTribItemDocto),
	ValorIPIItemDocto       = sum(tbItemDocumento.ValorIPIItemDocto),
	sum(rtDocumentoProduto.ValorFreteItemDocto) as ValorFreteItemDocto,
	sum(rtDocumentoProduto.ValorSeguroItemDocto) as ValorSeguroItemDocto,
	sum(rtDocumentoProduto.ValorDespAcesItemDocto) as ValorDespAcesItemDocto,
	CodigoSituacaoTributaria = 
	CASE	WHEN min(tbItemDocumentoFT.CodigoTributacaoItDocFT) = '' or min(tbItemDocumentoFT.CodigoTributacaoItDocFT) IS NULL THEN
			COALESCE(tbNaturezaOperacao.CodigoTributacaoNaturezaOper,'   ')
		ELSE
			COALESCE(min(tbItemDocumentoFT.CodigoTributacaoItDocFT),'000')
		END,
	CASE WHEN min(tbItemDocumento.TipoRegistroItemDocto) = 'VEC' or ( tbItemDocumento.TipoLancamentoMovimentacao = 1 and min(tbItemDocumento.NumeroVeiculoCV) is not null ) THEN
		convert(varchar(8),min(tbItemDocumento.NumeroVeiculoCV))
	ELSE
		' '
	END as NumeroVeiculoCV,
	min(tbVeiculoCV.NumeroChassisCV) as NumeroChassisCV,
	min(tbItemDocumento.PercentualIPIItemDocto) as PercentualIPIItemDocto,
	min(tbVeiculoCV.VeiculoNovoCV) as VeiculoNovoCV,
	3 as TipoOperacao,
	CGCConcessao = '00000000000000',
        CASE WHEN tbDocumento.CondicaoComplementoICMSDocto <> 'V' THEN
        	rtDocumentoProduto.TipoRegistroItemDocto
	ELSE
		'COM'
	END as TipoRegistroItemDocto,
	rtDocumentoProduto.CodigoLocal
INTO #tmp
FROM 
	rtDocumentoProduto (nolock)
	INNER JOIN tbItemDocumento (nolock) ON
		tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
		rtDocumentoProduto.CodigoLocal	= tbItemDocumento.CodigoLocal	AND
		rtDocumentoProduto.NumeroDocumento = tbItemDocumento.NumeroDocumento	AND
		rtDocumentoProduto.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento	AND
		rtDocumentoProduto.DataDocumentoOriginal = tbItemDocumento.DataDocumento	AND
		rtDocumentoProduto.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao	AND
		rtDocumentoProduto.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
	        rtDocumentoProduto.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento
	LEFT JOIN tbDocumentoFT (nolock) ON
		tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
		rtDocumentoProduto.CodigoLocal	= tbDocumentoFT.CodigoLocal	AND
		rtDocumentoProduto.NumeroDocumento = tbDocumentoFT.NumeroDocumento	AND
		rtDocumentoProduto.EntradaSaidaDocumento = tbDocumentoFT.EntradaSaidaDocumento	AND
		rtDocumentoProduto.DataDocumentoOriginal = tbDocumentoFT.DataDocumento	AND
		rtDocumentoProduto.TipoLancamentoMovimentacao = tbDocumentoFT.TipoLancamentoMovimentacao	AND
		rtDocumentoProduto.CodigoCliFor = tbDocumentoFT.CodigoCliFor 
	LEFT JOIN tbNaturezaOperacao (nolock) ON
        tbNaturezaOperacao.CodigoEmpresa = @CodigoEmpresa AND 
        tbNaturezaOperacao.CodigoNaturezaOperacao = COALESCE(tbDocumentoFT.CodigoNaturezaOperacao,tbItemDocumento.CodigoNaturezaOperacao)
	LEFT JOIN tbItemDocumentoFT (nolock) ON
		tbItemDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
		rtDocumentoProduto.CodigoLocal	= tbItemDocumentoFT.CodigoLocal	AND
		rtDocumentoProduto.NumeroDocumento = tbItemDocumentoFT.NumeroDocumento	AND
		rtDocumentoProduto.EntradaSaidaDocumento = tbItemDocumentoFT.EntradaSaidaDocumento	AND
		rtDocumentoProduto.DataDocumentoOriginal = tbItemDocumentoFT.DataDocumento	AND
		rtDocumentoProduto.TipoLancamentoMovimentacao = tbItemDocumentoFT.TipoLancamentoMovimentacao	AND
		rtDocumentoProduto.CodigoCliFor = tbItemDocumentoFT.CodigoCliFor AND
	        rtDocumentoProduto.SequenciaItemDocumento = tbItemDocumentoFT.SequenciaItemDocumento
	INNER JOIN tbDocumento (nolock) ON
	        tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
		rtDocumentoProduto.CodigoLocal	= tbDocumento.CodigoLocal	AND
		rtDocumentoProduto.NumeroDocumento = tbDocumento.NumeroDocumento	AND
		rtDocumentoProduto.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento	AND
		rtDocumentoProduto.DataDocumentoOriginal = tbDocumento.DataDocumento	AND
		rtDocumentoProduto.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao	AND
		rtDocumentoProduto.CodigoCliFor = tbDocumento.CodigoCliFor 
	LEFT JOIN tbProdutoFT (nolock) ON
		  tbProdutoFT.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND
                  tbProdutoFT.CodigoProduto = tbItemDocumento.CodigoProduto
	INNER JOIN tbLocalLF (nolock) ON
		   tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
		   tbLocalLF.CodigoLocal = rtDocumentoProduto.CodigoLocal
	INNER JOIN tbLocal (nolock) ON
		   tbLocal.CodigoEmpresa = @CodigoEmpresa AND
		   tbLocal.CodigoLocal = rtDocumentoProduto.CodigoLocal
	LEFT JOIN tbVeiculoCV (nolock) ON
		  tbVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
		  tbVeiculoCV.CodigoLocal = rtDocumentoProduto.CodigoLocal AND
		  tbVeiculoCV.NumeroVeiculoCV = tbItemDocumento.NumeroVeiculoCV
WHERE Spid = @@Spid
group by 
 	rtDocumentoProduto.NumeroDocumento,
	rtDocumentoProduto.EntradaSaidaDocumento,
	rtDocumentoProduto.DataDocumento ,
	rtDocumentoProduto.CodigoCFO,
	rtDocumentoProduto.CGCLocal,
	rtDocumentoProduto.SerieDocumento,
	rtDocumentoProduto.DataEmissaoDocumento,
	rtDocumentoProduto.CodigoModeloNotaFiscal,
		CASE 	
			WHEN tbDocumento.CondicaoComplementoICMSDocto = 'V' THEN
                ''
			WHEN tbItemDocumento.CodigoProduto is not null THEN
				CASE WHEN LEN(RTRIM(REPLACE(tbItemDocumento.CodigoProduto,' ',''))) <= 14 THEN
					REPLACE(tbItemDocumento.CodigoProduto,' ','') 
				ELSE
				        SUBSTRING(REPLACE(tbItemDocumento.CodigoProduto,' ',''),LEN(REPLACE(tbItemDocumento.CodigoProduto,' ',''))-13,14)
				END
			WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
				SUBSTRING(REPLACE(tbItemDocumento.CodigoMaoObraOS,' ',''),1,14)
			WHEN tbVeiculoCV.NumeroChassisCV is not null THEN
                                CASE WHEN LEN(RTRIM(NumeroChassisCV)) > 6 THEN
	                                SUBSTRING(RTRIM(REPLACE(NumeroChassisCV,' ','')),LEN(RTRIM(NumeroChassisCV)) - 5,6)
				ELSE
	                                RTRIM(REPLACE(NumeroChassisCV,' ',''))
				END
			WHEN tbItemDocumento.CodigoItemDocto is not null THEN
				SUBSTRING(REPLACE(tbItemDocumento.CodigoItemDocto,' ',''),1,14)
			ELSE
				'USOCONSUMO'
			END,	tbItemDocumento.TipoLancamentoMovimentacao,
        tbLocalLF.TipoImpressaoNFCancelada,
        tbDocumento.CondicaoNFCancelada,
        tbItemDocumento.CodigoItemDocto,
	tbItemDocumento.PercentualICMSItemDocto,
	rtDocumentoProduto.TipoRegistroItemDocto,
	CondicaoComplementoICMSDocto,
	rtDocumentoProduto.CodigoLocal,
	tbNaturezaOperacao.CodigoTributacaoNaturezaOper

---- Agrupa Mão de Obra (998)

SELECT * into #tmpMOB
FROM #tmp
where TipoRegistroItemDocto = 'MOB'

DELETE #tmp
where TipoRegistroItemDocto = 'MOB'

INSERT #tmp
SELECT
54 ,
NumeroDocumento ,
EntradaSaidaDocumento ,
DataDocumento ,                                         
SerieDocumento ,
DataEmissaoDocumento ,                                  
CodigoModeloNotaFiscal ,
0 ,
CodigoCFO ,
#tmpMOB.CGCLocal ,      
#tmpMOB.InscricaoEstadualLocal ,
#tmpMOB.UFLocal ,
CASE WHEN tbLocal.UFLocal = 'RS' OR  ( @UFInicial = 'RS' AND @UFFinal = 'RS' ) THEN  --- valor desconto
	sum(ValorTotalProduto)
ELSE
	0
END,
' ' ,               
' ' ,                                                                                                                                                                                                                                                          

                                                                                                                                                                                                                                                               

                                                                                                                                                                                                                                                               

                                                                                                                                                                                                                                                               

                                                                                                                                                                                                                                                               

                                                                                                                                                                                                                                                               

                                                                                                                                                                                                                                                               

                                                                                                                                                                                                                                                               

                                                                                                                                                                                                             
                                                                                                                                                                                                                                                               

                                                                                                                                                                                                                                                               

                                                                                                                                                                                                                                                               

                                                                                                                                                                                                                                                               

                                                                                                                                                                                                                                                               

                                                                                                           
0,
sum(ValorProdutoItemDocto), 
CASE WHEN tbLocal.UFLocal = 'RS' OR ( @UFInicial = 'RS' AND @UFFinal = 'RS' ) THEN
	0
ELSE
	sum(ValorTotalProduto)
END,
0,
sum(ValorBaseICMS1ItemDocto), 
sum(BaseICMSSubstTribItemDocto), 
0,
sum(ValorFreteItemDocto),
sum(ValorSeguroItemDocto),
sum(ValorDespAcesItemDocto), 
'   ' ,
' ',
null,
0,
null ,
3,
'00000000000000',   
'XOB',  ---- coloquei o MOB como XOB para ele ficar como último item do documento
#tmpMOB.CodigoLocal
FROM #tmpMOB
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = #tmpMOB.CodigoLocal
GROUP BY
NumeroDocumento ,
EntradaSaidaDocumento ,
DataDocumento ,                                         
SerieDocumento ,
DataEmissaoDocumento ,                                  
CodigoModeloNotaFiscal ,
CodigoCFO ,
#tmpMOB.CGCLocal ,      
#tmpMOB.InscricaoEstadualLocal ,
#tmpMOB.UFLocal ,
CodigoSituacaoTributaria,
#tmpMOB.CodigoLocal ,
tbLocal.UFLocal

---- Tratamento especifico para Rio Grande do Sul BR : 651062 NF Complemento de ICMS
UPDATE #tmp
SET ValorDescontoItemDocto = ValorICMSDocumento
FROM tbLocal, tbDocumento
WHERE
tbLocal.CodigoEmpresa = @CodigoEmpresa AND
tbLocal.CodigoLocal = #tmp.CodigoLocal AND
tbLocal.UFLocal = 'RS' AND
#tmp.TipoRegistroItemDocto = 'COM' AND
tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbDocumento.CodigoLocal = #tmp.CodigoLocal AND
tbDocumento.EntradaSaidaDocumento = #tmp.EntradaSaidaDocumento AND
tbDocumento.DataDocumento = #tmp.DataDocumento AND
tbDocumento.NumeroDocumento = #tmp.NumeroDocumento AND
tbDocumento.CondicaoComplementoICMSDocto = 'V'
---

SELECT * FROM #tmp
ORDER BY
EntradaSaidaDocumento,
DataDocumento,
NumeroDocumento,
TipoRegistroItemDocto

TRUNCATE TABLE rtDocumentoProduto 
DROP TABLE #tmp
DROP TABLE #tmpMOB

SET NOCOUNT OFF



