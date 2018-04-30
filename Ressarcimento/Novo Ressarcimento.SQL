DECLARE @CodigoEmpresa numeric(4)
DECLARE @CodigoLocal   numeric(4)
DECLARE @Periodo       char(6)
DECLARE @CFOEntrada    numeric(5)
DECLARE @CFOSaida      numeric(5)

--->>>>> Informar os parametros abaixo antes de executar    <<<<<<--------------------
SELECT @CodigoEmpresa = 260
SELECT @CodigoLocal   = 0
SELECT @Periodo       = '201409'
SELECT @CFOEntrada    = 2403
SELECT @CFOSaida      = 6411
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

--- Saídas

SELECT 
tbItemDocumento.CodigoClassificacaoFiscal,
tbItemDocumento.CodigoProduto, 
tbProduto.DescricaoProduto, 
tbDocumento.NumeroDocumento, 
tbCliForJuridica.CGCJuridica, 
tbItemDocumento.DataDocumento,
tbItemDocumento.QtdeLancamentoItemDocto, 
tbItemDocumento.ValorProdutoItemDocto,
tbItemDocumento.ValorBaseICMS1ItemDocto, 
tbItemDocumento.ValorIPIItemDocto,
tbItemDocumento.ValorICMSItemDocto,
CONVERT(NUMERIC(14,2),0) as BaseOPIPI,
CONVERT(NUMERIC(14,2),0) as BasePercAgregado,
CONVERT(NUMERIC(14,2),0) as ICMSRetST,
CONVERT(NUMERIC(14,2),0) as ICMSSTProduto,
CONVERT(NUMERIC(14,2),0) as NumeroDocumentoSaida,
convert(datetime,'1900-01-01') as DataSaida,
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
INNER JOIN tbCliForJuridica ON 
           tbCliForJuridica.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
           tbCliForJuridica.CodigoCliFor = tbItemDocumento.CodigoCliFor 
INNER JOIN tbProduto ON 
           tbProduto.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
           tbProduto.CodigoProduto = tbItemDocumento.CodigoProduto 
WHERE 1 = 2

DECLARE CurSaidas INSENSITIVE CURSOR FOR

SELECT 
tbItemDocumento.CodigoProduto, 
tbItemDocumento.NumeroDocumento,
tbItemDocumento.DataDocumento,
tbItemDocumento.QtdeLancamentoItemDocto
FROM tbItemDocumento 
INNER JOIN tbCliForJuridica (NOLOCK) ON 
           tbCliForJuridica.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
           tbCliForJuridica.CodigoCliFor = tbItemDocumento.CodigoCliFor 
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
      tbDocumento.CodigoCFO = @CFOSaida AND 
      tbDocumento.CondicaoNFCancelada = 'F'            

---- Cria TMP Entradas
	SELECT 
	tbItemDocumento.CodigoClassificacaoFiscal,
	tbItemDocumento.CodigoProduto,
	tbItemDocumento.NumeroDocumento,
        CGCJuridica,
        tbDocumento.DataDocumento as DataEmissaoDocumento,
	QtdeLancamentoItemDocto,
	tbItemDocumento.ValorProdutoItemDocto,
	( tbItemDocumento.ValorContabilItemDocto - tbItemDocumento.ValorIPIItemDocto - CASE WHEN @Periodo < '200805' THEN tbItemDocumento.ValorICMSSubstTribItemDocto ELSE tbItemDocumento.ValorICMSRetidoItemDocto END ) as BaseICMS1,         	
	tbItemDocumento.ValorIPIItemDocto,
	tbItemDocumento.CodigoCliFor
	INTO #tmpEntradas
	FROM tbItemDocumento
	INNER JOIN tbCliForJuridica (NOLOCK) ON 
	           tbCliForJuridica.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
	           tbCliForJuridica.CodigoCliFor = tbItemDocumento.CodigoCliFor 
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
		@Quantidade 
		
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
    CGCJuridica,
    tbDocumento.DataDocumento,
	SUM(QtdeLancamentoItemDocto) as QtdeLancamentoItemDocto,
	sum(tbItemDocumento.ValorProdutoItemDocto) as ValorProdutoItemDocto,
	SUM(tbItemDocumento.ValorContabilItemDocto - tbItemDocumento.ValorIPIItemDocto - CASE WHEN @Periodo < '200805' THEN tbItemDocumento.ValorICMSSubstTribItemDocto ELSE tbItemDocumento.ValorICMSRetidoItemDocto END) as BaseICMS1,         	
	SUM(tbItemDocumento.ValorIPIItemDocto) AS ValorIPIItemDocto,
	tbItemDocumento.CodigoCliFor
	FROM tbItemDocumento
	INNER JOIN tbCliForJuridica (NOLOCK) ON 
	           tbCliForJuridica.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
	           tbCliForJuridica.CodigoCliFor = tbItemDocumento.CodigoCliFor 
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
		tbItemDocumento.CodigoCFO = @CFOEntrada and
		tbItemDocumento.CodigoCliFor = 59104273001443 and
        tbItemDocumento.DataDocumento <= @DataFinal
	GROUP BY 
		tbItemDocumento.CodigoClassificacaoFiscal,
		tbItemDocumento.CodigoProduto,
		tbItemDocumento.NumeroDocumento,
		CGCJuridica,
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
	tbCliForJuridica.CGCJuridica, 
	#tmpEntradas.DataEmissaoDocumento,
	#tmpEntradas.QtdeLancamentoItemDocto, 
	#tmpEntradas.ValorProdutoItemDocto,
	#tmpEntradas.BaseICMS1, 
	#tmpEntradas.ValorIPIItemDocto,
	ROUND((( #tmpEntradas.BaseICMS1  * CASE WHEN tbProdutoFT.ProdutoImportado	= 'V' AND tbProdutoFT.SemSimilarNacional	= 'F' AND tbProdutoFT.SemSimilarNacional	= 'F' then ICMSEntradaUF else ICMSSaidaUF END) / 100 ),2) ValorICMSItemDocto,
	#tmpEntradas.BaseICMS1 + #tmpEntradas.ValorIPIItemDocto, 
    ROUND((((#tmpEntradas.BaseICMS1 + #tmpEntradas.ValorIPIItemDocto ) * 126.5 ) / 100),2),
	0,
	0,
	@NumeroDocumento,
	@DataDocumento,
---	CASE WHEN @Quantidade > #tmpEntradas.QtdeLancamentoItemDocto THEN
		---#tmpEntradas.QtdeLancamentoItemDocto
---	ELSE
		@Quantidade,
	---END,
    0,
	0
	FROM #tmpEntradas
	INNER JOIN tbCliForJuridica (NOLOCK) ON 
	           tbCliForJuridica.CodigoEmpresa = @CodigoEmpresa and
	           tbCliForJuridica.CodigoCliFor = #tmpEntradas.CodigoCliFor 
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
			@Quantidade 
		
END
		
CLOSE CurSaidas
DEALLOCATE CurSaidas

SELECT 
CodigoClassificacaoFiscal,
#tmp.CodigoProduto, 
DescricaoProduto, 
CASE WHEN tbProdutoFT.ProdutoImportado	= 'V' AND tbProdutoFT.SemSimilarNacional	= 'F' AND tbProdutoFT.SemSimilarNacional	= 'F' THEN
	'Importado'
ELSE
	'Nacional'
END as Origem,
NumeroDocumento, 
CGCJuridica, 
DataDocumento,
QtdeLancamentoItemDocto, 
ValorProdutoItemDocto,
ValorBaseICMS1ItemDocto, 
ValorIPIItemDocto,
ValorICMSItemDocto,
BaseOPIPI,
BasePercAgregado,
( ROUND(((BasePercAgregado * 18) /100),2) - ValorICMSItemDocto ) as ICMSRetST,
ROUND(ROUND(((BasePercAgregado * 18) /100),2) / QtdeLancamentoItemDocto,2) as ICMSporUnidade,
NumeroDocumentoSaida,
DataSaida,
QtdeSaida,
ROUND(ROUND(((BasePercAgregado * 18) /100),2) / QtdeLancamentoItemDocto,2)  as ICMSResProduto,
ROUND(ROUND(ROUND(((BasePercAgregado * 18) /100),2) / QtdeLancamentoItemDocto,2) * QtdeSaida,2) as ICMSRes
from #tmp
INNER JOIN tbProdutoFT ON
           tbProdutoFT.CodigoEmpresa = @CodigoEmpresa AND
           tbProdutoFT.CodigoProduto = #tmp.CodigoProduto
ORDER BY #tmp.CodigoProduto,
         DataDocumento

DROP TABLE #tmp
DROP TABLE #tmpEntradas

SET NOCOUNT OFF