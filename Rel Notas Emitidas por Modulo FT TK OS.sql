declare @strCodigoEmpresa 	varchar(255),
@strDataInicial 	varchar(255),
@strDataFinal 		varchar(255),
@strLocalInicial 	varchar(255),
@strLocalFinal 		varchar(255),
@strClienteInicial 	varchar(255),
@strClienteFinal	varchar(255) 

set @strCodigoEmpresa = '930'
set @strDataInicial ='2017-04-01'
set @strDataFinal ='2017-04-30'
set @strLocalInicial ='0'
set @strLocalFinal = '0'		
set @strClienteInicial ='0'
set @strClienteFinal ='99999999999999'

DECLARE @Meses   	 varchar(120),
 	@DataIni 	 datetime,
        @DataFim 	 datetime,
        @CodigoEmpresa 	 dtInteiro04,
        @LocalInicial 	 dtInteiro04,
        @LocalFinal   	 dtInteiro04,
        @ClienteInicial  numeric(14),
        @ClienteFinal    numeric(14)


SELECT  @Meses 		= 'JANEIRO   FEVEREIRO MARªO     ABRIL     MAIO      JUNHO     JULHO     AGOSTO    SETEMBRO  OUTUBRO   NOVEMBRO  DEZEMBRO  '

SELECT  @DataIni 	= CONVERT(datetime,@strDataInicial) ,
        @DataFim 	= CONVERT(datetime,@strDataFinal),
	@CodigoEmpresa 	= CONVERT(INT,@strCodigoEmpresa),
	@LocalInicial  	= CONVERT(INT,@strLocalInicial),
	@LocalFinal    	= CONVERT(INT,@strLocalFinal),
	@ClienteInicial = CONVERT(NUMERIC,@strClienteInicial),
	@ClienteFinal   = CONVERT(NUMERIC,@strClienteFinal)

SELECT 	CONVERT (VARCHAR, tbDocumento.DataEmissaoDocumento,3) as [Data Emissão],
	--tbDocumento.DataDocumento,
	tbDocumento.EspecieDocumento,
	--tbDocumento.SerieDocumento,
	tbDocumento.NumeroDocumento,
	--tbDocumentoFT.CodigoNaturezaOperacao
	tbDocumentoFT.OrigemDocumentoFT
	--tbDocumento.NumLivroRegEntradaSaida,
	--tbDocumento.NumFolhaRegEntradaSaida,
	--tbItemDocumento.CodigoCFO,
	--tbCliFor.CodigoCliFor,
	--tbCliFor.NomeCliFor,	
	--tbLocal.CodigoLocal,
	--tbLocal.DescricaoLocal,
	--tbEmpresa.CodigoEmpresa,
	--tbEmpresa.RazaoSocialEmpresa,	
	--SUM(tbItemDocumento.ValorContabilItemDocto)	AS ValorContabilItemDocto,
	--SUM(tbItemDocumento.ValorICMSItemDocto)		AS ValorICMSItemDocto,
	--SUM(tbItemDocumento.ValorIPIItemDocto)		AS ValorIPIItemDocto,
	--SUM(tbItemDocumento.ValorISSItemDocto)		AS ValorISSItemDocto,
	--(RTRIM(substring(@Meses, (DATEPART(mm, tbDocumento.DataDocumento) -1 ) * 10 + 1,10)) + '/' + LTRIM(STR(DATEPART(yy, tbDocumento.DataDocumento)))) MesAno

FROM	tbDocumento (NOLOCK)
	INNER JOIN tbEmpresa (NOLOCK) ON
        	tbDocumento.CodigoEmpresa = tbEmpresa.CodigoEmpresa
	INNER JOIN tbLocal (NOLOCK) ON
		tbDocumento.CodigoEmpresa = tbLocal.CodigoEmpresa
    		AND tbDocumento.CodigoLocal = tbLocal.CodigoLocal 
	INNER JOIN tbCliFor (NOLOCK)ON
        	tbDocumento.CodigoEmpresa = tbCliFor.CodigoEmpresa
    		AND tbDocumento.CodigoCliFor = tbCliFor.CodigoCliFor
	INNER JOIN tbItemDocumento(NOLOCK) ON
        	tbDocumento.CodigoEmpresa    			= tbItemDocumento.CodigoEmpresa
	    	AND tbDocumento.CodigoLocal  			= tbItemDocumento.CodigoLocal
    		AND tbDocumento.EntradaSaidaDocumento 		= tbItemDocumento.EntradaSaidaDocumento
	    	AND tbDocumento.NumeroDocumento       		= tbItemDocumento.NumeroDocumento
    		AND tbDocumento.CodigoCliFor          		= tbItemDocumento.CodigoCliFor	    
	 	AND tbDocumento.TipoLancamentoMovimentacao 	= tbItemDocumento.TipoLancamentoMovimentacao 
		AND tbDocumento.DataDocumento              	= tbItemDocumento.DataDocumento                    	
	LEFT JOIN tbDocumentoFT (NOLOCK)ON
        	tbDocumentoFT.CodigoEmpresa    			= tbItemDocumento.CodigoEmpresa
	    	AND tbDocumentoFT.CodigoLocal  			= tbItemDocumento.CodigoLocal
    		AND tbDocumentoFT.EntradaSaidaDocumento 		= tbItemDocumento.EntradaSaidaDocumento
	    	AND tbDocumentoFT.NumeroDocumento       		= tbItemDocumento.NumeroDocumento
    		AND tbDocumentoFT.CodigoCliFor          		= tbItemDocumento.CodigoCliFor	    
	 	AND tbDocumentoFT.TipoLancamentoMovimentacao 	= tbItemDocumento.TipoLancamentoMovimentacao 
		AND tbDocumentoFT.DataDocumento              	= tbItemDocumento.DataDocumento
		AND tbDocumentoFT.CodigoNaturezaOperacao        = tbItemDocumento.CodigoNaturezaOperacao   
	LEFT JOIN tbNaturezaOperacao(NOLOCK) ON
		tbNaturezaOperacao.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao 	
WHERE 	
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao AND
		tbItemDocumento.TipoLancamentoMovimentacao IN (7,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)
	OR tbDocumento.TipoLancamentoMovimentacao IN (1,9,10,12)
	) 
AND	tbDocumento.CodigoEmpresa 	   = @CodigoEmpresa 			 
AND	( tbDocumento.EntradaSaidaDocumento  = 'S' or ( tbDocumento.EntradaSaidaDocumento = 'E' and TipoPedidoDocFT in (5,8)))
AND	tbDocumento.CodigoLocal 	BETWEEN @LocalInicial   AND @LocalFinal  
AND	tbDocumento.DataEmissaoDocumento 	BETWEEN @DataIni	AND @DataFim     
AND	tbDocumento.CodigoCliFor 	BETWEEN @ClienteInicial AND @ClienteFinal

GROUP BY 
	tbEmpresa.CodigoEmpresa,
	tbEmpresa.RazaoSocialEmpresa,
	tbLocal.CodigoLocal,
	tbLocal.DescricaoLocal,
	tbCliFor.CodigoCliFor,
	tbCliFor.NomeCliFor,	
	tbDocumento.NumeroDocumento,
	tbItemDocumento.CodigoCFO,
	tbDocumento.DataEmissaoDocumento,
	tbDocumento.DataDocumento,
	tbDocumento.EspecieDocumento,
	tbDocumento.SerieDocumento,	
	tbDocumento.NumLivroRegEntradaSaida,
	tbDocumento.NumFolhaRegEntradaSaida,
	tbDocumentoFT.OrigemDocumentoFT

	ORDER BY tbDocumento.DataEmissaoDocumento
	
--SQL2000 Order by	tbEmpresa.CodigoEmpresa,tbEmpresa.RazaoSocialEmpresa,tbLocal.CodigoLocal,
--SQL2000 tbLocal.DescricaoLocal,tbCliFor.CodigoCliFor,tbCliFor.NomeCliFor,tbDocumento.NumeroDocumento,
--SQL2000 tbItemDocumento.CodigoCFO,tbDocumento.DataEmissaoDocumento,tbDocumento.DataDocumento,
--SQL2000 tbDocumento.EspecieDocumento,tbDocumento.SerieDocumento,tbDocumento.NumLivroRegEntradaSaida,
--SQL2000 tbDocumento.NumFolhaRegEntradaSaida