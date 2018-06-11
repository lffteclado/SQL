DECLARE @CodigoEmpresa numeric(4)
DECLARE @CodigoLocal   numeric(4)
DECLARE @Periodo       char(6)
DECLARE @CFOEntrada    numeric(5)
DECLARE @CFOEntrada1    numeric(5)
DECLARE @CFOEntrada2    numeric(5)
DECLARE @CFOEntrada3    numeric(5)

DECLARE @CFOSaida      numeric(5)
DECLARE @CFOSaida1      numeric(5)
DECLARE @CFOSaida2      numeric(5)
DECLARE @CFOSaida3      numeric(5)
DECLARE @CFOSaida4      numeric(5)
DECLARE @CFOSaida5      numeric(5)
DECLARE @CFOSaida6      numeric(5)
DECLARE @CFOSaida7      numeric(5)
DECLARE @CFOSaida8      numeric(5)

--->>>>> Informar os parametros abaixo antes de executar    <<<<<<--------------------
SELECT @CodigoEmpresa = (select CodigoEmpresa from tbEmpresa)
SELECT @CodigoLocal   = 0
SELECT @Periodo       = '201401'
SELECT @CFOEntrada    = 2403
SELECT @CFOEntrada1    = 2652
SELECT @CFOEntrada2    = 1652
SELECT @CFOEntrada3    = 1403

SELECT @CFOSaida      = 5102
SELECT @CFOSaida1      = 5403
SELECT @CFOSaida2      = 5405
SELECT @CFOSaida3      = 5652
SELECT @CFOSaida4      = 6102
SELECT @CFOSaida5      = 6108
SELECT @CFOSaida6      = 6403
SELECT @CFOSaida7      = 6404
SELECT @CFOSaida8      = 6652

--->>>>> <<<<<>>>>>><<<<<>>>>><<<<<>>>>><<<<<>>>>>><<<<<>   <<<<<<--------------------

SET NOCOUNT ON

DECLARE @SaldoAnteriorQtde numeric(16,4)
DECLARE @DataEntradaInicial datetime
DECLARE @DataInicial datetime
DECLARE @DataFinal   datetime

SELECT @DataInicial = convert(datetime, substring(@Periodo,1,4) + substring(@Periodo,5,2) + '01')
SELECT @DataFinal = dateadd(day,-1,dateadd(month,+1,convert(datetime, substring(@Periodo,1,4) + substring(@Periodo,5,2) + '01')))

DECLARE @CodigoProduto   varchar(30)
DECLARE @NumeroDocumento numeric(6)
DECLARE @DataDocumento   datetime
DECLARE @Quantidade      numeric(16,4)
DECLARE @ValorContabil	 money
--- Saídas

SELECT 
tbItemDocumento.CodigoClassificacaoFiscal,
tbItemDocumento.CodigoProduto, 
tbProduto.DescricaoProduto, 
tbDocumento.NumeroDocumento, 

tbItemDocumento.DataDocumento,
tbItemDocumento.QtdeLancamentoItemDocto, 
tbItemDocumento.ValorProdutoItemDocto,
tbItemDocumento.ValorBaseICMS1ItemDocto, 
tbItemDocumento.ValorIPIItemDocto,
tbItemDocumento.ValorICMSItemDocto,
tbItemDocumento.BaseICMSSubstTribItemDocto,
tbItemDocumento.ValorICMSRetidoItemDocto,
CONVERT(NUMERIC(14,2),0) as BaseOPIPI,
CONVERT(NUMERIC(14,2),0) as BasePercAgregado,
CONVERT(NUMERIC(14,2),0) as ICMSRetST,
CONVERT(NUMERIC(14,2),0) as ICMSSTProduto,
CONVERT(NUMERIC(14),0) as NumeroDocumentoSaida,
convert(datetime,'1900-01-01') as DataSaida,
tbItemDocumento.ValorContabilItemDocto,
CONVERT(NUMERIC(14,2),0) as QtdeSaida,
CONVERT(NUMERIC(14,2),0) as ICMSResProduto,
CONVERT(NUMERIC(14,2),0) as ICMSRes
INTO #tmp
FROM tbItemDocumento 
INNER JOIN tbDocumento ON
           tbDocumento.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
           tbDocumento.CodigoLocal = tbItemDocumento.CodigoLocal and
           tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento and
           tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor and
           tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento and
           tbDocumento.DataDocumento = tbItemDocumento.DataDocumento and
           tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
INNER JOIN tbCliFor ON
           tbCliFor.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
           tbCliFor.CodigoCliFor = tbItemDocumento.CodigoCliFor 
INNER JOIN tbProduto ON 
           tbProduto.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
           tbProduto.CodigoProduto = tbItemDocumento.CodigoProduto 
WHERE 1 = 2

DECLARE CurSaidas INSENSITIVE CURSOR FOR

SELECT 
tbItemDocumento.CodigoProduto, 
tbItemDocumento.NumeroDocumento,
tbItemDocumento.DataDocumento,
tbItemDocumento.QtdeLancamentoItemDocto,
tbItemDocumento.ValorContabilItemDocto
FROM tbItemDocumento 
INNER JOIN tbProduto (NOLOCK) ON 
           tbProduto.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
           tbProduto.CodigoProduto = tbItemDocumento.CodigoProduto 
INNER JOIN tbDocumento (NOLOCK) ON
           tbDocumento.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
           tbDocumento.CodigoLocal = tbItemDocumento.CodigoLocal and
           tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento and
           tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor and
           tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento and
           tbDocumento.DataDocumento = tbItemDocumento.DataDocumento and
           tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
WHERE tbItemDocumento.CodigoEmpresa = @CodigoEmpresa and
      tbItemDocumento.CodigoLocal = @CodigoLocal and
      tbItemDocumento.DataDocumento between @DataInicial And @DataFinal AND 
      (tbDocumento.CodigoCFO = @CFOSaida or
	   tbDocumento.CodigoCFO = @CFOSaida1 or
	   tbDocumento.CodigoCFO = @CFOSaida2 or
	   tbDocumento.CodigoCFO = @CFOSaida3 or
	   tbDocumento.CodigoCFO = @CFOSaida4 or
	   tbDocumento.CodigoCFO = @CFOSaida5 or
	   tbDocumento.CodigoCFO = @CFOSaida6 or
	   tbDocumento.CodigoCFO = @CFOSaida7 or
	   tbDocumento.CodigoCFO = @CFOSaida8) AND 
      tbDocumento.CondicaoNFCancelada = 'F'            

---- Cria TMP Entradas
	SELECT 
	tbItemDocumento.CodigoClassificacaoFiscal,
	tbItemDocumento.CodigoProduto,
	tbItemDocumento.NumeroDocumento,
        tbDocumento.DataDocumento as DataEmissaoDocumento,
	QtdeLancamentoItemDocto,
	tbItemDocumento.ValorProdutoItemDocto,
	( tbItemDocumento.ValorContabilItemDocto - tbItemDocumento.ValorIPIItemDocto - CASE WHEN @Periodo < '200805' THEN tbItemDocumento.ValorICMSSubstTribItemDocto ELSE tbItemDocumento.ValorICMSRetidoItemDocto END ) as BaseICMS1,         	
	tbItemDocumento.ValorIPIItemDocto,
	tbItemDocumento.CodigoCliFor,
	tbItemDocumento.BaseICMSSubstTribItemDocto,
	tbItemDocumento.ValorICMSRetidoItemDocto
	INTO #tmpEntradas
	FROM tbItemDocumento
		INNER JOIN tbProduto (NOLOCK) ON 
	           tbProduto.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
	           tbProduto.CodigoProduto = tbItemDocumento.CodigoProduto 
	INNER JOIN tbDocumento (NOLOCK) ON
        	   tbDocumento.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
	           tbDocumento.CodigoLocal = tbItemDocumento.CodigoLocal and
	           tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento and
	           tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor and
	           tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento and
	           tbDocumento.DataDocumento = tbItemDocumento.DataDocumento and
	           tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	WHERE 
	1 = 2	

-------

OPEN CurSaidas
FETCH NEXT FROM	CurSaidas INTO 
		@CodigoProduto, 		
		@NumeroDocumento, 
		@DataDocumento, 
		@Quantidade,
		@ValorContabil
		
WHILE (@@FETCH_STATUS <> -1) 
BEGIN 

	SELECT @SaldoAnteriorQtde = sum(QtdeAnteriorSaldoAlmoxarifado)
	FROM tbSaldoAlmoxarifadoPeriodo (NOLOCK)
	INNER JOIN tbAlmoxarifado (NOLOCK) ON
               tbAlmoxarifado.CodigoEmpresa = @CodigoEmpresa AND
			   tbAlmoxarifado.CodigoLocal = @CodigoLocal AND
               tbAlmoxarifado.CodigoAlmoxarifado = tbSaldoAlmoxarifadoPeriodo.CodigoAlmoxarifado
	WHERE
	tbSaldoAlmoxarifadoPeriodo.CodigoEmpresa = @CodigoEmpresa AND
    tbSaldoAlmoxarifadoPeriodo.CodigoLocal = @CodigoLocal AND
    tbSaldoAlmoxarifadoPeriodo.CodigoProduto = @CodigoProduto AND
    tbSaldoAlmoxarifadoPeriodo.PeriodoSaldoAlmoxarifado = @Periodo AND
    tbAlmoxarifado.ProducaoAlmoxarifado = 'V'

	IF @SaldoAnteriorQtde IS NULL SELECT @SaldoAnteriorQtde = 0

	SELECT @DataEntradaInicial = '1999-01-01'
	IF @SaldoAnteriorQtde = 0 SELECT @DataEntradaInicial = @DataInicial

	INSERT #tmpEntradas
	SELECT 
	tbItemDocumento.CodigoClassificacaoFiscal,
	tbItemDocumento.CodigoProduto,
	tbItemDocumento.NumeroDocumento,
        tbDocumento.DataDocumento,
	SUM(QtdeLancamentoItemDocto) as QtdeLancamentoItemDocto,
	sum(tbItemDocumento.ValorProdutoItemDocto) as ValorProdutoItemDocto,
	SUM(tbItemDocumento.ValorContabilItemDocto - tbItemDocumento.ValorIPIItemDocto - CASE WHEN @Periodo < '200805' THEN tbItemDocumento.ValorICMSSubstTribItemDocto ELSE tbItemDocumento.ValorICMSRetidoItemDocto END) as BaseICMS1,         	
	SUM(tbItemDocumento.ValorIPIItemDocto) AS ValorIPIItemDocto,
	tbItemDocumento.CodigoCliFor,
	SUM(tbItemDocumento.BaseICMSSubstTribItemDocto),
	SUM(tbItemDocumento.ValorICMSRetidoItemDocto)
	FROM tbItemDocumento
	
	INNER JOIN tbProduto (NOLOCK) ON 
	           tbProduto.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
	           tbProduto.CodigoProduto = tbItemDocumento.CodigoProduto 
	INNER JOIN tbDocumento (NOLOCK) ON
        	   tbDocumento.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
	           tbDocumento.CodigoLocal = tbItemDocumento.CodigoLocal and
	           tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento and
	           tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor and
	           tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento and
	           tbDocumento.DataDocumento = tbItemDocumento.DataDocumento and
	           tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	WHERE 
		tbItemDocumento.CodigoEmpresa = @CodigoEmpresa and
		tbItemDocumento.CodigoLocal = @CodigoLocal and
		tbItemDocumento.EntradaSaidaDocumento = 'E' and
		tbItemDocumento.CodigoProduto = @CodigoProduto and
		(tbItemDocumento.CodigoCFO = @CFOEntrada or
		tbItemDocumento.CodigoCFO = @CFOEntrada1 or
		tbItemDocumento.CodigoCFO = @CFOEntrada2 or
		tbItemDocumento.CodigoCFO = @CFOEntrada3) and
        tbItemDocumento.DataDocumento <= @DataFinal
	GROUP BY 
		tbItemDocumento.CodigoClassificacaoFiscal,
		tbItemDocumento.CodigoProduto,
		tbItemDocumento.NumeroDocumento,
				tbDocumento.DataDocumento,
		tbItemDocumento.CodigoCliFor

	/*IF EXISTS ( select 1 from sysobjects where name = 'tbEntradasDATAFLEX' )
	BEGIN
		INSERT #tmpEntradas
		SELECT
			CodigoProduto,
			NumeroDocumento, 
			CGCJuridica,
			DataEmissaoDocumento,
			QtdeLancamentoItemDocto,
			( ValorContabil - ValorIPI - ValorICMSSubstTrib ),         	
			ValorIPI,
			tbEntradasDATAFLEX.CodigoCliFor
		FROM tbEntradasDATAFLEX
		INNER JOIN tbCliForJuridica ON
				   tbCliForJuridica.CodigoEmpresa = @CodigoEmpresa AND
				   tbCliForJuridica.CodigoCliFor = tbEntradasDATAFLEX.CodigoCliFor
		WHERE tbEntradasDATAFLEX.CodigoEmpresa = @CodigoEmpresa AND
				  tbEntradasDATAFLEX.CodigoLocal = @CodigoLocal AND
				  CodigoProduto = @CodigoProduto AND
				  CFO = @CFOEntrada and
				  tbEntradasDATAFLEX.CodigoCliFor = 59104273001443 and
				  tbEntradasDATAFLEX.DataEmissaoDocumento >= @DataInicial
	END*/

	INSERT #tmp
	SELECT
	#tmpEntradas.CodigoClassificacaoFiscal,
	#tmpEntradas.CodigoProduto, 
	tbProduto.DescricaoProduto, 
	#tmpEntradas.NumeroDocumento, 
	
	#tmpEntradas.DataEmissaoDocumento,
	#tmpEntradas.QtdeLancamentoItemDocto, 
	#tmpEntradas.ValorProdutoItemDocto,
	#tmpEntradas.BaseICMS1, 
	#tmpEntradas.ValorIPIItemDocto,
	ROUND((( #tmpEntradas.BaseICMS1  * CASE WHEN tbProdutoFT.ProdutoImportado	= 'V' AND tbProdutoFT.SemSimilarNacional	= 'F' AND tbProdutoFT.SemSimilarNacional	= 'F' then ICMSEntradaUF else ICMSSaidaUF END) / 100 ),2) ValorICMSItemDocto,
	#tmpEntradas.BaseICMSSubstTribItemDocto,
	#tmpEntradas.ValorICMSRetidoItemDocto,
	#tmpEntradas.BaseICMS1 + #tmpEntradas.ValorIPIItemDocto, 
    ROUND((((#tmpEntradas.BaseICMS1 + #tmpEntradas.ValorIPIItemDocto ) * 126.5 ) / 100),2),
	0,
	0,
	@NumeroDocumento,
	@DataDocumento,
	@ValorContabil,
---	CASE WHEN @Quantidade > #tmpEntradas.QtdeLancamentoItemDocto THEN
		---#tmpEntradas.QtdeLancamentoItemDocto
		
---	ELSE
		@Quantidade,
	---END,
    0,
	0
	FROM #tmpEntradas
	
	INNER JOIN tbProduto (NOLOCK) ON 
	           tbProduto.CodigoEmpresa = @CodigoEmpresa and
	           tbProduto.CodigoProduto = @CodigoProduto
	INNER JOIN tbProdutoFT (NOLOCK) ON 
	           tbProdutoFT.CodigoEmpresa = @CodigoEmpresa and
	           tbProdutoFT.CodigoProduto = @CodigoProduto
	INNER JOIN tbCliFor (NOLOCK) ON
                   tbCliFor.CodigoEmpresa = @CodigoEmpresa and
                   tbCliFor.CodigoCliFor = #tmpEntradas.CodigoCliFor
	INNER JOIN tbLocal (NOLOCK) ON
                   tbLocal.CodigoEmpresa = @CodigoEmpresa and
                   tbLocal.CodigoLocal = @CodigoLocal 
	INNER JOIN tbPercentual (NOLOCK) ON
              	   tbPercentual.UFDestino = tbLocal.UFLocal AND
                   tbPercentual.UFOrigem = tbCliFor.UFCliFor 
	WHERE 
	#tmpEntradas.CodigoProduto = @CodigoProduto and
	#tmpEntradas.DataEmissaoDocumento = ( SELECT max(DataEmissaoDocumento) FROM #tmpEntradas A (NOLOCK) 
					  	WHERE
					          A.CodigoProduto = @CodigoProduto and
						  A.DataEmissaoDocumento <= @DataDocumento )

	TRUNCATE TABLE #tmpEntradas

	FETCH NEXT FROM	CurSaidas INTO 
			@CodigoProduto, 
			@NumeroDocumento, 
			@DataDocumento, 
			@Quantidade ,
			@ValorContabil
		
END
		
CLOSE CurSaidas
DEALLOCATE CurSaidas

select #tmp.NumeroDocumentoSaida,
	   #tmp.DataSaida as DataSaida_Venda,
	   #tmp.CodigoProduto,
	   #tmp.DescricaoProduto,
	   #tmp.QtdeSaida,
	  min(#tmp.NumeroDocumento) as NumDocEntrada
	  into #tmpU
	  from #tmp
	  group by #tmp.NumeroDocumentoSaida,#tmp.CodigoProduto, #tmp.DataSaida ,#tmp.DescricaoProduto,#tmp.QtdeSaida


DECLARE @sta char(5)
select @sta = 'OK'

DECLARE @staE char(5)
select @staE = 'ERROR'


select #tmp.CodigoProduto, 
		#tmp.DescricaoProduto,
		#tmp.NumeroDocumento as NumeroDocumento_Entrada,
		--tbCli.CodigoCliFor,
		#tmp.DataDocumento as DataDocumento_Entrada,
		cast(#tmp.QtdeLancamentoItemDocto as NUMERIC(14,2)) as QtdeLancamentoItemDocto_Entrada,
		#tmp.BaseICMSSubstTribItemDocto,
		#tmp.ValorIPIItemDocto,
	    #tmp.NumeroDocumentoSaida,	  
	    #tmp.DataSaida as DataSaida_Venda,	   
	    #tmp.QtdeSaida as QtdeSaida_Venda,
	    #tmp.ValorContabilItemDocto as ValorContabilItemDocto_Venda,
	    tbCli.UFCliFor,
	    tbIDoc.CodigoCFO as CodigoCFO_VENDA,	  
	   (#tmp.ValorProdutoItemDocto + #tmp.ValorIPIItemDocto + #tmp.ValorICMSRetidoItemDocto ) as ValorContabilItemDocto_Entrada,		
		#tmp.ValorICMSRetidoItemDocto,
		case when #tmp.QtdeLancamentoItemDocto >= #tmp.QtdeSaida then
		@sta
		else 
		@staE
		end 
	   from #tmp
		inner join #tmpU U on
		U.NumeroDocumentoSaida = #tmp.NumeroDocumentoSaida
	   and U.#tmp.DataSaida  = #tmp.DataSaida 
	   and U.CodigoProduto = #tmp.CodigoProduto
	   and U.DescricaoProduto = #tmp.DescricaoProduto
	   and U.QtdeSaida = #tmp.QtdeSaida
	   and U.NumDocEntrada = #tmp.NumeroDocumento
		inner join tbItemDocumento tbIDoc on
		tbIDoc.NumeroDocumento = #tmp.NumeroDocumentoSaida
		and tbIDoc.CodigoProduto = #tmp.CodigoProduto
		and tbIDoc.DataDocumento = #tmp.DataSaida
		and tbIDoc.ValorContabilItemDocto = #tmp.ValorContabilItemDocto
		and tbIDoc.QtdeLancamentoItemDocto = #tmp.QtdeSaida
		inner join tbCliFor tbCli on
		tbCli.CodigoCliFor = tbIDoc.CodigoCliFor
		order by #tmp.DataSaida


DROP TABLE #tmp
DROP TABLE #tmpEntradas
DROP TABLE #tmpU


SET NOCOUNT OFF