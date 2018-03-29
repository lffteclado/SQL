IF EXISTS ( SELECT 1 FROM sysobjects WHERE name = 'rtE110' ) DROP TABLE dbo.rtE110
GO
CREATE TABLE dbo.rtE110 (
	EntradaSaida			CHAR(1),
	NumeroDocumento			NUMERIC(12),
	DataDocumento			DATETIME,
	CodigoCliFor			NUMERIC(14),
	TipoLancamento			NUMERIC(2),
	TipoRegistro			CHAR(4),
	CodigoAjuste			VARCHAR(10),
	DescricaoComplementar	VARCHAR(255),
	CodigoItem				VARCHAR(30),
	BaseCalculoICMS			MONEY,
	AliquotaICMS			MONEY,
	ValorICMS				MONEY,
	OutrosValores			MONEY	)
go
IF EXISTS ( SELECT 1 FROM sysobjects WHERE name = 'rtRegraVeiculo' ) DROP TABLE dbo.rtRegraVeiculo
GO
CREATE TABLE dbo.rtRegraVeiculo
(
CodigoLinhaProduto numeric(4),
CodigoProduto varchar(30),
ContaEstoque varchar(12)
)
GO
IF EXISTS ( SELECT 1 FROM sysobjects WHERE name = 'rtSPEDFiscal' ) DROP TABLE dbo.rtSPEDFiscal
GO
CREATE TABLE dbo.rtSPEDFiscal
( 
Spid numeric(8),
Linha varchar(500) null, 
TipoRegistro char(4) null,
EntradaSaida char(30) null,
NumeroDocumento numeric(12) null, 
DataDocumento datetime null, 
CodigoCliFor numeric(14) null, 
TipoLancamentoMovimentacao numeric(3) null,
Ordem numeric(3) null,
CodigoProduto varchar(30) null,
CodigoNaturezaOperacao numeric(6) null,
CodigoUnidadeProduto char(2) null,
CodigoClienteEventual numeric(14) null
)
GO 
CREATE INDEX ixSPEDFiscal ON rtSPEDFiscal
(
Spid,
EntradaSaida,
DataDocumento,
CodigoCliFor,
NumeroDocumento,
TipoLancamentoMovimentacao,
TipoRegistro
)
GO
CREATE INDEX ixSPEDFiscal_CliFor ON rtSPEDFiscal
(
CodigoCliFor
)
GO
GO
if exists(select 1 from sysobjects where id = object_id('whSPEDFiscal'))
DROP PROCEDURE dbo.whSPEDFiscal
GO
CREATE PROCEDURE dbo.whSPEDFiscal

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-SYSTEMS
 PROJETO......: Livros Fiscais 
 AUTOR........: Condez
 DATA.........: 13/10/2008
 UTILIZADO EM : Geração SPED Fiscal
 OBJETIVO.....: 

whSPEDFiscal 1608,0,'201602',0,'F','F','F','ST10ENTRAD','B','DA10ICMSST','F',null,null,'F',null,'RF10ICMSST','DA70CTRC'
whSPEDFiscal 1608,0,'201709',0,'F','F','F',null,'B',null,'F',null,null,'F',null,null,null
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa 	numeric(4)	,
@CodigoLocal	numeric(4) 	, 
@Periodo        varchar(6)  ,
@Finalidade		numeric(1)  = 0,
@IncluirVeiculos char(1) = 'V',
@IncluirVeicCons char(1) = 'V',
@IncluirPecasUsadas char(1) = 'V',
@AjusteICMSCTRCST varchar(10) = '',
@Perfil char(1) = 'B',
@AjusteICMSDIFALQ varchar(10) = '',
@IncluirEstoqueTerceiros char(1) = 'V',
@PeriodoInicialPAFECF datetime = null,
@PeriodoFinalPAFECF datetime = null ,
@GerarInventario char(1) = 'V',
@DataGeracaoInventario datetime = null,
@AjusteICMSCTRCSTRetido varchar(10) = '',
@AjusteICMSDIFALQCTRC varchar(10) = ''

AS 

SET NOCOUNT ON
SET ANSI_WARNINGS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @DataInicial			datetime
DECLARE @DataFinal				datetime
DECLARE @DataInventario			char(10)
DECLARE @ValorICMSST			money
DECLARE @UFLocal				char(2)
DECLARE @Versao					char(3)
DECLARE @GerarCIAP				char(1)
DECLARE @PeriodoInventario		char(6)
DECLARE @ContaEntrada			varchar(12)
DECLARE @ContaSaida				varchar(12)
DECLARE @EquiparadoIndustria	char(1)

-- Limpa códigos de ajuste quando vem zerados
IF @AjusteICMSCTRCST LIKE '000%' SET @AjusteICMSCTRCST = ''
IF @AjusteICMSDIFALQ LIKE '000%' SET @AjusteICMSDIFALQ = ''
IF @AjusteICMSCTRCSTRetido LIKE '000%' SET @AjusteICMSCTRCSTRetido = ''
IF @AjusteICMSDIFALQCTRC LIKE '000%' SET @AjusteICMSDIFALQCTRC = ''

SELECT 
@ContaEntrada = RTRIM(LTRIM(ContaContabilLivroFiscal)),
@ContaSaida   = RTRIM(LTRIM(ContaContabilSaidaLivroFiscal))
FROM tbEmpresaLF (NOLOCK)
WHERE
CodigoEmpresa = @CodigoEmpresa

IF @ContaEntrada IS NULL SELECT @ContaEntrada = '' 
IF @ContaSaida IS NULL SELECT @ContaSaida = ''

SELECT @UFLocal = UFLocal
FROM tbLocal
WHERE
CodigoEmpresa = @CodigoEmpresa AND
CodigoLocal = @CodigoLocal 

SELECT @DataInicial = isnull(@PeriodoInicialPAFECF,convert(datetime, substring(@Periodo,1,4) + substring(@Periodo,5,2) + '01'))
SELECT @DataFinal = isnull(@PeriodoFinalPAFECF,dateadd(day,-1,dateadd(month,+1,convert(datetime, substring(@Periodo,1,4) + substring(@Periodo,5,2) + '01'))))
IF @DataGeracaoInventario IS NULL SELECT @DataGeracaoInventario = @DataFinal
SELECT @DataInventario = convert(char(10),@DataGeracaoInventario,20)
SELECT @PeriodoInventario = CONVERT(VARCHAR(4),DATEPART(YEAR,@DataGeracaoInventario)) + RIGHT(CONVERT(VARCHAR(3),100 + DATEPART(MONTH,@DataGeracaoInventario)),2)

SELECT @Versao = '002'
IF @DataInicial >= '2010-01-01' SELECT @Versao = '003'
IF @DataInicial >= '2011-01-01' SELECT @Versao = '004'
IF @DataInicial >= '2012-01-01' SELECT @Versao = '005'
IF @DataInicial >= '2012-07-01' SELECT @Versao = '006'
IF @DataInicial >= '2013-01-01' SELECT @Versao = '007'
IF @DataInicial >= '2014-01-01' SELECT @Versao = '008'
IF @DataInicial >= '2015-01-01' SELECT @Versao = '009'
IF @DataInicial >= '2016-01-01' SELECT @Versao = '010'
IF @DataInicial >= '2017-01-01' SELECT @Versao = '011'
IF @DataInicial >= '2018-01-01' SELECT @Versao = '012'

SELECT @EquiparadoIndustria = tbEmpresa.EquiparadoIndustria FROM tbEmpresa WHERE CodigoEmpresa = @CodigoEmpresa

SELECT @GerarCIAP = 'F'
IF EXISTS ( SELECT 1 FROM tbSPEDFiscalCIAP (NOLOCK)
            WHERE tbSPEDFiscalCIAP.CodigoEmpresa = @CodigoEmpresa AND
                  tbSPEDFiscalCIAP.CodigoLocal = @CodigoLocal AND
                  tbSPEDFiscalCIAP.Periodo = @Periodo ) SELECT @GerarCIAP = 'V'

--- Frete

update tbDocumentoFT
set
ValorFreteDocFT = ( SELECT SUM(ValorFreteItemDocto) FROM tbItemDocumento (NOLOCK) 
						WHERE
						tbItemDocumento.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa AND
						tbItemDocumento.CodigoLocal = tbDocumentoFT.CodigoLocal AND
						tbItemDocumento.EntradaSaidaDocumento = tbDocumentoFT.EntradaSaidaDocumento and
						tbItemDocumento.CodigoCliFor = tbDocumentoFT.CodigoCliFor and
						tbItemDocumento.DataDocumento = tbDocumentoFT.DataDocumento and
						tbItemDocumento.NumeroDocumento = tbDocumentoFT.NumeroDocumento and
						tbItemDocumento.TipoLancamentoMovimentacao = tbDocumentoFT.TipoLancamentoMovimentacao )
where
tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
tbDocumentoFT.CodigoLocal = @CodigoLocal AND
tbDocumentoFT.TipoLancamentoMovimentacao = 1 AND
tbDocumentoFT.EntradaSaidaDocumento = 'E' AND
tbDocumentoFT.DataDocumento between @DataInicial and @DataFinal AND
ValorFreteDocFT <> ( SELECT SUM(ValorFreteItemDocto) FROM tbItemDocumento (NOLOCK) 
					WHERE
					tbItemDocumento.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa AND
					tbItemDocumento.CodigoLocal = tbDocumentoFT.CodigoLocal AND
					tbItemDocumento.EntradaSaidaDocumento = tbDocumentoFT.EntradaSaidaDocumento and
					tbItemDocumento.CodigoCliFor = tbDocumentoFT.CodigoCliFor and
					tbItemDocumento.DataDocumento = tbDocumentoFT.DataDocumento and
					tbItemDocumento.NumeroDocumento = tbDocumentoFT.NumeroDocumento and
					tbItemDocumento.TipoLancamentoMovimentacao = tbDocumentoFT.TipoLancamentoMovimentacao )

update tbDocumento
set
TotalProdutosDocumento = ( SELECT SUM(ValorProdutoItemDocto) FROM tbItemDocumento (NOLOCK) 
						WHERE
						tbItemDocumento.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
						tbItemDocumento.CodigoLocal = tbDocumento.CodigoLocal AND
						tbItemDocumento.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento and
						tbItemDocumento.CodigoCliFor = tbDocumento.CodigoCliFor and
						tbItemDocumento.DataDocumento = tbDocumento.DataDocumento and
						tbItemDocumento.NumeroDocumento = tbDocumento.NumeroDocumento and
						tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao )
where
tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbDocumento.CodigoLocal = @CodigoLocal AND
tbDocumento.TipoLancamentoMovimentacao = 1 AND
tbDocumento.EntradaSaidaDocumento = 'E' AND
tbDocumento.DataDocumento between @DataInicial and @DataFinal AND
tbDocumento.TotalProdutosDocumento = 0 AND
tbDocumento.TotalProdutosDocumento <> ( SELECT SUM(ValorProdutoItemDocto) FROM tbItemDocumento (NOLOCK) 
										WHERE
										tbItemDocumento.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
										tbItemDocumento.CodigoLocal = tbDocumento.CodigoLocal AND
										tbItemDocumento.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento and
										tbItemDocumento.CodigoCliFor = tbDocumento.CodigoCliFor and
										tbItemDocumento.DataDocumento = tbDocumento.DataDocumento and
										tbItemDocumento.NumeroDocumento = tbDocumento.NumeroDocumento and
										tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao )

update tbDocumento
set
TotalProdutosDocumento = ( SELECT SUM(ValorProdutoItemDocto) FROM tbItemDocumento (NOLOCK) 
						WHERE
						tbItemDocumento.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
						tbItemDocumento.CodigoLocal = tbDocumento.CodigoLocal AND
						tbItemDocumento.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento and
						tbItemDocumento.CodigoCliFor = tbDocumento.CodigoCliFor and
						tbItemDocumento.DataDocumento = tbDocumento.DataDocumento and
						tbItemDocumento.NumeroDocumento = tbDocumento.NumeroDocumento and
						tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao )
where
tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbDocumento.CodigoLocal = @CodigoLocal AND
tbDocumento.TipoLancamentoMovimentacao = 1 AND
tbDocumento.EntradaSaidaDocumento = 'E' AND
tbDocumento.DataDocumento between @DataInicial and @DataFinal AND
tbDocumento.TotalProdutosDocumento <> 0 AND
tbDocumento.TotalProdutosDocumento <> ( SELECT SUM(ValorProdutoItemDocto) FROM tbItemDocumento (NOLOCK) 
										WHERE
										tbItemDocumento.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
										tbItemDocumento.CodigoLocal = tbDocumento.CodigoLocal AND
										tbItemDocumento.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento and
										tbItemDocumento.CodigoCliFor = tbDocumento.CodigoCliFor and
										tbItemDocumento.DataDocumento = tbDocumento.DataDocumento and
										tbItemDocumento.NumeroDocumento = tbDocumento.NumeroDocumento and
										tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao ) AND
EXISTS ( SELECT 1 FROM tbItemDocumento (NOLOCK) 
		 WHERE
		 tbItemDocumento.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
		 tbItemDocumento.CodigoLocal = tbDocumento.CodigoLocal AND
		 tbItemDocumento.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento and
		 tbItemDocumento.CodigoCliFor = tbDocumento.CodigoCliFor and
		 tbItemDocumento.DataDocumento = tbDocumento.DataDocumento and
		 tbItemDocumento.NumeroDocumento = tbDocumento.NumeroDocumento and
		 tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
         tbItemDocumento.TipoRegistroItemDocto = 'MOB' )

--- ICMS Nota Uso/Consumo

update tbDocumento
set
ValorICMSDocumento = ( SELECT SUM(ValorICMSItemDocto) FROM tbItemDocumento (NOLOCK) 
						WHERE
						tbItemDocumento.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
						tbItemDocumento.CodigoLocal = tbDocumento.CodigoLocal AND
						tbItemDocumento.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento and
						tbItemDocumento.CodigoCliFor = tbDocumento.CodigoCliFor and
						tbItemDocumento.DataDocumento = tbDocumento.DataDocumento and
						tbItemDocumento.NumeroDocumento = tbDocumento.NumeroDocumento and
						tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao )
where
tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbDocumento.CodigoLocal = @CodigoLocal AND
tbDocumento.TipoLancamentoMovimentacao = 9 AND
tbDocumento.EntradaSaidaDocumento = 'E' AND
tbDocumento.DataDocumento between @DataInicial and @DataFinal AND
tbDocumento.ValorICMSDocumento <> ( SELECT SUM(ValorICMSItemDocto) FROM tbItemDocumento (NOLOCK) 
										WHERE
										tbItemDocumento.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
										tbItemDocumento.CodigoLocal = tbDocumento.CodigoLocal AND
										tbItemDocumento.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento and
										tbItemDocumento.CodigoCliFor = tbDocumento.CodigoCliFor and
										tbItemDocumento.DataDocumento = tbDocumento.DataDocumento and
										tbItemDocumento.NumeroDocumento = tbDocumento.NumeroDocumento and
										tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao ) AND
EXISTS ( SELECT 1 FROM tbItemDocumento (NOLOCK) 
		 WHERE
		 tbItemDocumento.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
		 tbItemDocumento.CodigoLocal = tbDocumento.CodigoLocal AND
		 tbItemDocumento.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento and
		 tbItemDocumento.CodigoCliFor = tbDocumento.CodigoCliFor and
		 tbItemDocumento.DataDocumento = tbDocumento.DataDocumento and
		 tbItemDocumento.NumeroDocumento = tbDocumento.NumeroDocumento and
		 tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao )

-- Chave Acesso Transferência

IF @DataInicial >= '2012-04-01' 
BEGIN
	INSERT tbDocumentoNFe
	SELECT
	@CodigoEmpresa,
    @CodigoLocal,
    'E',
    tbDocumento.NumeroDocumento,
    tbDocumento.DataDocumento,
	tbDocumento.CodigoCliFor,
    1,
	'',
	tbDocumentoNFe.ChaveAcessoNFe,
	null,
	null,
	null,
	'F',
	'V', --- DanfeOK
	'F',
	'F',
	NULL,
	NULL,
	NULL, --COD BARRAS
	NULL,
	NULL,
	'F',
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	'F'
	FROM tbDocumento
	INNER JOIN tbDocumentoFT ON
               tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
               tbDocumentoFT.CodigoLocal = @CodigoLocal AND
               tbDocumentoFT.EntradaSaidaDocumento = 'E' AND
               tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND
               tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
               tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
               tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao 
	INNER JOIN tbNaturezaOperacao ON
               tbNaturezaOperacao.CodigoEmpresa = @CodigoEmpresa AND 
               tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao
	INNER JOIN tbLocal ON 
               tbLocal.CodigoEmpresa = @CodigoEmpresa AND
               tbLocal.CodigoLocal = @CodigoLocal
	INNER JOIN tbDocumentoNFe ON
               tbDocumentoNFe.CodigoEmpresa = @CodigoEmpresa AND 
               tbDocumentoNFe.EntradaSaidaDocumento = 'S' AND
               tbDocumentoNFe.DataDocumento = tbDocumento.DataEmissaoDocumento AND
               tbDocumentoNFe.CodigoCliFor = tbLocal.CodigoCliFor AND
               tbDocumentoNFe.NumeroDocumento = tbDocumento.NumeroDocumento AND
               tbDocumentoNFe.TipoLancamentoMovimentacao = 7
	WHERE
	tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
	tbDocumento.CodigoLocal = @CodigoLocal AND
    tbDocumento.EntradaSaidaDocumento = 'E' AND
	tbDocumento.DataDocumento BETWEEN @DataInicial AND @DataFinal AND
    tbDocumento.TipoLancamentoMovimentacao = 1 AND
	tbNaturezaOperacao.CodigoTipoOperacao IN (9,13) AND
	NOT EXISTS ( SELECT 1 FROM tbDocumentoNFe A
                 WHERE
                 A.CodigoEmpresa = @CodigoEmpresa AND
                 A.CodigoLocal = @CodigoLocal AND
                 A.EntradaSaidaDocumento = 'E' AND
                 A.DataDocumento = tbDocumento.DataDocumento AND
                 A.NumeroDocumento = tbDocumento.NumeroDocumento AND
                 A.CodigoCliFor = tbDocumento.CodigoCliFor AND
                 A.TipoLancamentoMovimentacao = 1 )
   
END

---

--- Inventario

DELETE rtRegistroInventario
WHERE Spid = @@spid

SELECT * INTO #TMP FROM rtRegistroInventario
WHERE 1 = 2

IF @GerarInventario = 'V' OR @EquiparadoIndustria = 'V'
BEGIN
	INSERT #TMP
	EXEC whRelCEInventarioLinhaProduto @CodigoEmpresa, @CodigoLocal, 0, 9999, 0, @PeriodoInventario, @IncluirVeiculos, 0, @DataInventario, @DataInventario, @IncluirVeicCons, @IncluirPecasUsadas 
END

IF @IncluirEstoqueTerceiros = 'F' 
BEGIN
	DELETE rtRegistroInventario
	WHERE CodigoLinhaProduto = 9100 AND
          Spid = @@spid
END

DROP TABLE #TMP

---

DELETE rtSPEDFiscal WHERE Spid = @@spid

--- Bloco 0
INSERT rtSPEDFiscal
SELECT 
@@spid,
'|0000|' +
@Versao + '|' +
CONVERT(CHAR(1),@Finalidade) + '|' +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
CONVERT(CHAR(4),DATEPART(year,@DataInicial)) + '|' +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataFinal)),2,2) +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataFinal)),2,2) +
CONVERT(CHAR(4),DATEPART(year,@DataFinal)) + '|' +
RTRIM(LTRIM(CONVERT(VARCHAR(60),tbEmpresa.RazaoSocialEmpresa))) + '|' +
tbLocal.CGCLocal + '|' + 
'|' +
tbLocal.UFLocal + '|' +
RTRIM(LTRIM(CONVERT(VARCHAR(15),REPLACE(REPLACE(REPLACE(tbLocal.InscricaoEstadualLocal,'-',''),'/',''),'.','')))) + '|' +
COALESCE(CONVERT(VARCHAR(8),COALESCE(CONVERT(VARCHAR(8),tbCEP.NumeroMunicipio),CONVERT(VARCHAR(8),tbMunicipio.NumeroMunicipio))),'') + '|' +
RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(14),REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.','')),''))) + '|' +
'' + '|' +
@Perfil + CASE WHEN dbo.fnIndustria(@CodigoEmpresa) = 0 THEN '|1|' ELSE '|0|' END,
'0000',
'E',
0,
getdate(),
0,
0,
0,
'',
0,
'',
0
FROM tbLocal (NOLOCK)
INNER JOIN tbEmpresa (NOLOCK) ON
           tbEmpresa.CodigoEmpresa = tbLocal.CodigoEmpresa
LEFT JOIN tbCEP (NOLOCK) ON
          tbCEP.NumeroCEP = tbLocal.CEPLocal
LEFT JOIN tbMunicipio (NOLOCK) ON
          tbMunicipio.UF = tbLocal.UFLocal AND
          tbMunicipio.Municipio = tbLocal.MunicipioLocal
WHERE
tbLocal.CodigoEmpresa = @CodigoEmpresa AND
tbLocal.CodigoLocal = @CodigoLocal

INSERT rtSPEDFiscal
SELECT
@@spid,
'|0001|0|',
'0001',
'E',
0,
getdate(),
0,
0,
1,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|0005|' +
RTRIM(LTRIM(CONVERT(VARCHAR(30),tbEmpresa.RazaoSocialEmpresa))) + '|' +
tbLocal.CEPLocal + '|' +
CONVERT(VARCHAR(60),tbLocal.RuaLocal) + '|' + 
RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(6),tbLocal.NumeroEndLocal),''))) + '|' +
RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(6),tbLocal.ComplementoEndLocal),''))) + '|' +
RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(70),tbLocal.BairroLocal),''))) + '|' +
RIGHT(RTRIM(LTRIM(RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(4),tbLocal.DDDLocal),''))) + RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(15),tbLocal.TelefoneLocal),''))))),10) + '|' +
RIGHT(RTRIM(LTRIM(RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(4),tbLocal.DDDFaxLocal),''))) + RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(15),tbLocal.FaxLocal),''))))),10) + '|' +
RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(255),tbLocal.EmailLocal),''))) + '|',
'0001',
'E',
0,
getdate(),
0,
0,
2,
'',
0,
'',
0
FROM tbLocal 
INNER JOIN tbEmpresa ON 
           tbEmpresa.CodigoEmpresa = tbLocal.CodigoEmpresa
WHERE
tbLocal.CodigoEmpresa = @CodigoEmpresa AND
tbLocal.CodigoLocal = @CodigoLocal

INSERT rtSPEDFiscal
SELECT
@@spid,
'|0015|' +
tbInscricaoEstadualST.UFDestino + '|' + 
RTRIM(LTRIM(tbInscricaoEstadualST.NumeroInscricaoEstadualST)) + '|',
'0001',
'E',
0,
getdate(),
0,
0,
2,
'',
0,
'',
0
FROM tbLocal 
INNER JOIN tbInscricaoEstadualST (NOLOCK) ON
tbInscricaoEstadualST.CodigoEmpresa = tbLocal.CodigoEmpresa AND
tbInscricaoEstadualST.CodigoLocal = tbLocal.CodigoLocal
WHERE
tbInscricaoEstadualST.UFOrigem = tbLocal.UFLocal AND
tbInscricaoEstadualST.UFDestino <> tbLocal.UFLocal AND
tbLocal.CodigoEmpresa = @CodigoEmpresa AND
tbLocal.CodigoLocal = @CodigoLocal

INSERT tbSPEDFiscalE200
SELECT
@CodigoEmpresa,
@CodigoLocal,
tbInscricaoEstadualST.UFDestino,
@Periodo,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
''
FROM tbLocal 
INNER JOIN tbInscricaoEstadualST (NOLOCK) ON
tbInscricaoEstadualST.CodigoEmpresa = tbLocal.CodigoEmpresa AND
tbInscricaoEstadualST.CodigoLocal = tbLocal.CodigoLocal
WHERE
tbInscricaoEstadualST.UFOrigem = tbLocal.UFLocal AND
tbInscricaoEstadualST.UFDestino <> tbLocal.UFLocal AND
tbLocal.CodigoEmpresa = @CodigoEmpresa AND
tbLocal.CodigoLocal = @CodigoLocal AND
NOT EXISTS (SELECT 1 FROM tbSPEDFiscalE200 
			WHERE	tbSPEDFiscalE200.CodigoEmpresa = @CodigoEmpresa AND
					tbSPEDFiscalE200.CodigoLocal = @CodigoLocal AND
					tbSPEDFiscalE200.Periodo = @Periodo AND
					tbSPEDFiscalE200.UF = tbInscricaoEstadualST.UFDestino)

INSERT rtSPEDFiscal
SELECT
@@spid,
'|0100|' +
RTRIM(LTRIM(COALESCE(tbEmpresa.NomeContadorEmpresa,''))) + '|' +
RTRIM(LTRIM(REPLACE(REPLACE(COALESCE(tbEmpresa.CPFContadorEmpresa,'0'),'.',''),'-',''))) + '|' +
RTRIM(LTRIM(REPLACE(REPLACE(COALESCE(tbEmpresa.CRCContadorEmpresa,'0'),'.',''),'-',''))) + '|' +
'|' + 
COALESCE(tbEmpresa.CEPContadorEmpresa,'0') + '|' +
RTRIM(LTRIM(COALESCE(tbEmpresa.RuaContadorEmpresa,''))) + '|' +
RTRIM(LTRIM(CONVERT(CHAR(10),COALESCE(tbEmpresa.NumeroEndContadorEmpresa,'0')))) + '|' +
RTRIM(LTRIM(COALESCE(tbEmpresa.ComplementoEndContadorEmpresa,''))) + '|' +
RTRIM(LTRIM(RTRIM(LTRIM(COALESCE(tbEmpresa.BairroContadorEmpresa,''))))) + '|' + 
RTRIM(LTRIM(RIGHT(RTRIM(CONVERT(VARCHAR(4),COALESCE(tbEmpresa.DDDTelefoneContadorEmpresa,''))) + RTRIM(COALESCE(tbEmpresa.TelefoneContadorEmpresa,'0')),10))) + '|' +
RTRIM(LTRIM(RIGHT(RTRIM(CONVERT(VARCHAR(4),COALESCE(tbEmpresa.DDDFaxContadorEmpresa,''))) + RTRIM(COALESCE(tbEmpresa.FaxContadorEmpresa,'0')),10))) + '|' +
RTRIM(LTRIM(CONVERT(VARCHAR(255),COALESCE(tbEmpresa.EmailContadorEmpresa,'')))) + '|' + 
RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(8),COALESCE(CONVERT(VARCHAR(8),tbCEP.NumeroMunicipio),CONVERT(VARCHAR(8),tbMunicipio.NumeroMunicipio))),''))) + '|',
'0100',
'E',
0,
getdate(),
0,
0,
3,
'',
0,
'',
0
FROM tbEmpresa (NOLOCK)
LEFT JOIN tbCEP (NOLOCK) ON
          tbCEP.NumeroCEP = tbEmpresa.CEPContadorEmpresa
LEFT JOIN tbMunicipio (NOLOCK) ON
          tbMunicipio.UF = tbEmpresa.UFContadorEmpresa AND
          tbMunicipio.Municipio = tbEmpresa.MunicipioContadorEmpresa
WHERE
tbEmpresa.CodigoEmpresa = @CodigoEmpresa

--- BLOCO C

INSERT rtSPEDFiscal
SELECT
@@spid,
	'|C100|'
+	CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' THEN
		'0'
	ELSE
		'1'
	END + '|'
+	CASE WHEN ( 
            ( tbDocumentoNFe.ChaveAcessoNFe IS NOT NULL OR tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.EspecieDocumento = 'ECF' ) AND
            tbDocumento.TipoLancamentoMovimentacao not in (1,9,10) AND
			( ( tbDocumento.TipoLancamentoMovimentacao = 7 and ( tbDocumentoFT.TipoTratamentoNFDigitadaDocFT <> 'N' OR tbDocumento.CodigoEmpresa = 2490 )) OR ---Mavel Totvs 
              tbDocumento.TipoLancamentoMovimentacao <> 7 )
          ) OR  --- Emissao Própria ?
		  ( tbDocumento.TipoLancamentoMovimentacao = 10 AND tbDocumento.EntradaSaidaDocumento = 'S' AND tbDocumento.CodigoEmpresa = 2380 AND tbDocumento.CodigoLocal = 3 ) OR
          ( tbDocumento.CondicaoComplementoICMSDocto = 'V' and tbDocumento.EntradaSaidaDocumento = 'S' ) OR
          ( tbDocumento.TipoLancamentoMovimentacao = 7 AND tbNaturezaOperacao.CodigoTipoOperacao in (10,12) ) OR
          ( tbDocumento.TipoLancamentoMovimentacao in (7,10) AND tbDocumento.CondicaoNFCancelada = 'V' and tbDocumentoFT.TipoTratamentoNFDigitadaDocFT <> 'N' ) THEN
		CASE WHEN tbDocumento.SerieDocumento BETWEEN '890' AND '899' THEN
			'1' -- Emissão de Terceiros (NF Avulsa emitida pelo Estado - série 890 a 899)
		ELSE
			'0' -- Emissao Própria
		END
	ELSE
		'1'
	END + '|'
+	CASE 
		WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
			''
		ELSE
			CASE WHEN tbDocumento.CodigoModeloNotaFiscal = 65 THEN
				''
			ELSE
				CONVERT(VARCHAR(14),COALESCE(tbDocumentoFT.CodigoClienteEventual,tbDocumento.CodigoCliFor))
			END
	END + '|' -- [04] Código do Participante
+	RIGHT(CONVERT(VARCHAR(3),100 + tbDocumento.CodigoModeloNotaFiscal),2) + '|' -- [05] COD_MOD
+	CASE
		WHEN tbDocumento.CondicaoNFCancelada = 'F' AND tbDocumento.CondicaoComplementoICMSDocto = 'V' THEN
			'06'
		WHEN ( tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 ) AND ( tbDocumentoNFe.ChaveAcessoNFe IS NOT NULL OR tbDocumento.CodigoModeloNotaFiscal not in (55,65) ) THEN
			'02'
		WHEN tbDocumento.CodigoModeloNotaFiscal in (55,65) AND ( tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 ) AND tbDocumentoNFe.ChaveAcessoNFe IS NULL THEN
			'05' --- INUTILIZAÇÃO
		WHEN tbDocumento.EspecieDocumento = 'ECF' OR tbDocumento.SerieDocumento BETWEEN '890' AND '899' THEN
			'08'
		ELSE
			'00'
	END + '|' -- [06] COD_SIT
+	CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
		'001'
	ELSE
		right('000'+rtrim(ltrim(coalesce(tbDocumento.SerieDocumento,''))),3)
	END + '|'
+	CONVERT(VARCHAR(9),tbDocumento.NumeroDocumento) + '|'
+	RTRIM(LTRIM(COALESCE(tbDocumentoNFe.ChaveAcessoNFe,''))) + '|'
+	CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDocumento.DataEmissaoDocumento)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDocumento.DataEmissaoDocumento)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,tbDocumento.DataEmissaoDocumento)),'') + '|' 
	END
+	CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDocumento.DataDocumento)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDocumento.DataDocumento)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,tbDocumento.DataDocumento)) + '|' 
	END
+	CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		CASE WHEN tbDocumento.EspecieDocumento = 'ECF' AND @UFLocal <> 'RN' THEN
			'0,00' + '|'
		ELSE
			REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorContabilItemDocto)),'.',',') + '|' 
		END
	END
+	CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		CASE 
		WHEN tbNaturezaOperacao.CodigoTipoOperacao IN (5,6,7,9,13,14,15,17,23,30,80,90,92,93,94,95,96,97) THEN
			CASE WHEN CONVERT(NUMERIC(4),@Versao) >= 6 THEN
				'2' -- Outros
			ELSE
				'9' -- Sem pagamento
			END
		WHEN ( SELECT COUNT(*) FROM tbDoctoRecPag 
					WHERE
					tbDoctoRecPag.CodigoEmpresa = @CodigoEmpresa AND
					tbDoctoRecPag.CodigoLocal = @CodigoLocal AND
					tbDoctoRecPag.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
					tbDoctoRecPag.DataDocumento = tbDocumento.DataDocumento AND
					tbDoctoRecPag.CodigoCliFor = tbDocumento.CodigoCliFor AND
					tbDoctoRecPag.NumeroDocumento = tbDocumento.NumeroDocumento AND
					tbDoctoRecPag.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao ) = 0 THEN
			'0' -- À Vista
		ELSE
			'1' -- À prazo
		END + '|' 
	END -- [13] IND_PGTO
+	CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		''
    ELSE
		REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(tbItemDocumento.ValorDescontoItemDocto) FROM tbItemDocumento (nolock)
									  WHERE 
									  tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									  tbItemDocumento.CodigoLocal = @CodigoLocal AND
				                      tbItemDocumento.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									  tbItemDocumento.DataDocumento = tbDocumento.DataDocumento AND
	                                  tbItemDocumento.CodigoCliFor = tbDocumento.CodigoCliFor AND
	                                  tbItemDocumento.NumeroDocumento = tbDocumento.NumeroDocumento AND
	                                  tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao)),'.',',')
	END  + '|' -- [14] VL_DESC
+	CASE WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		''
	ELSE
		'0,00'
	END + '|' -- [15] VL_ABAT_NT
+	CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		''
    ELSE
		CASE WHEN tbDocumento.EspecieDocumento = 'ECF' AND tbLocal.UFLocal <> 'RN' THEN
			'0,00'
		ELSE
			CASE
			WHEN tbDocumento.TipoLancamentoMovimentacao IN (9,10) THEN
				REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorContabilDocumento - COALESCE(tbDocumentoFT.ValorFreteDocFT,0)),'.',',')
			WHEN tbDocumento.TotalProdutosDocumento = 0 THEN
				REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorContabilItemDocto) - SUM(COALESCE(tbItemDocumento.ValorFreteItemDocto,0))),'.',',')
			ELSE
				REPLACE(CONVERT(VARCHAR(16),
					
					SUM(ValorProdutoItemDocto) +

					-- ICMS-ST sem direito a crédito
					CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' THEN
						case when tbDocumento.CodigoEmpresa in (6050) then -- Querência (TKT 254103)
							0
						else
							CASE WHEN NOT tbEmpresa.EquiparadoIndustria = 'V' OR tbDocumento.CodigoEmpresa IN (710,730,920,1918) THEN -- TICKET 201296
								SUM(tbItemDocumento.ValorICMSRetidoItemDocto)
							ELSE
								0
							END
						end
					ELSE
						0
					END +

					-- IPI sem direito a crédito
					CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' THEN
						CASE WHEN NOT (tbEmpresa.EquiparadoIndustria = 'V' OR tbLocalLF.CondicaoContribuinteIPI = 'V') OR tbDocumento.ValorBaseIPI1Documento = 0 THEN
							SUM(ValorIPIItemDocto)
						ELSE
							0
						END
					ELSE
						0
					END

				),'.',',')
			END
		END
	END  + '|' -- [16] VL_MERC
+	CASE WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		''
	ELSE
		CASE WHEN tbDocumentoFT.TipoFreteDocFT IS NOT NULL THEN
			CONVERT(CHAR(1),tbDocumentoFT.TipoFreteDocFT)
		ELSE
			'9'
		END 
	END + '|' -- [17] IND_FRT
+	CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
			'0,00' + '|'
		ELSE
				REPLACE(CONVERT(VARCHAR(16),SUM(COALESCE(tbItemDocumento.ValorFreteItemDocto,0))),'.',',') + '|'
		END
	END
+	CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
			'0,00' + '|'
		ELSE
			COALESCE(REPLACE(CONVERT(VARCHAR(16),tbDocumentoFT.ValorSeguroDocFT),'.',','),'0,00') + '|'
		END
	END
+	CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
			'0,00' + '|'
		ELSE
			REPLACE(CONVERT(VARCHAR(16),SUM(COALESCE(tbItemDocumento.ValorDespAcesItemDocto,0))),'.',',') + '|'
		END
	END
+	CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		CASE WHEN 'ZZ' = 'PE' AND --- desativado
                  tbDocumento.EntradaSaidaDocumento = 'S' AND 
                  tbCliFor.UFCliFor <> tbLocal.UFLocal THEN
			'0,00|'
		ELSE
			CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
				'0,00' + '|'
			ELSE
				REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorBaseICMS1Documento),'.',',') + '|'
			END
		END
	END -- [21] VL_BC_ICMS
+	CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		CASE WHEN 'ZZ' = 'PE' AND --- desativado
                  tbDocumento.EntradaSaidaDocumento = 'S' AND 
                  tbCliFor.UFCliFor <> tbLocal.UFLocal THEN
			'0,00|'
		ELSE
			CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
				'0,00' + '|'
			ELSE
				REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorICMSDocumento),'.',',') + '|'
			END
		END
	END -- [22] VL_ICMS
+	CASE WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		''
	ELSE
		CASE WHEN tbDocumento.CodigoModeloNotaFiscal = 65 THEN
			''
		ELSE
			CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
				'0,00'
			ELSE
				CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' THEN
					REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorBaseICMSSubstTribDocto),'.',',')
				ELSE
					'0,00'
				END
			END
		END
	END + '|'
+	CASE WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		''
	ELSE
		CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
			'0,00'
		ELSE
			CASE WHEN tbDocumento.CodigoModeloNotaFiscal = 65 THEN
				''
			ELSE
				CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' THEN
					REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorICMSSubstTribDocto + tbDocumento.ValorDifAliquotaICMSDocto),'.',',')
				ELSE
					'0,00'
				END
			END
		END
	END + '|' -- [24] VL_ICMS_ST
+	CASE
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		''
    ELSE
		CASE WHEN tbDocumento.CodigoModeloNotaFiscal = 65 THEN
			''
		ELSE
			CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' THEN
				REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorIPIDocumento),'.',',')
			ELSE
				CASE WHEN tbEmpresa.EquiparadoIndustria = 'V' OR tbLocalLF.CondicaoContribuinteIPI = 'V' THEN
					CASE WHEN tbDocumento.ValorBaseIPI1Documento <> 0 THEN
						REPLACE(CONVERT(VARCHAR(16),SUM(ValorIPIItemDocto)),'.',',')
					ELSE
						'0,00'
					END
				ELSE
					'0,00'
				END
			END
		END
	END + '|' -- [25] VL_IPI
+	CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		''
    ELSE
		CASE WHEN tbDocumento.CodigoModeloNotaFiscal = 65 THEN
			''
		ELSE
			CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
				'0,00'
			ELSE
				REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorPISDocumento),'.',',')
			END
		END
	END + '|'
+	CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		''
    ELSE
		CASE WHEN tbDocumento.CodigoModeloNotaFiscal = 65 THEN
			''
		ELSE
			CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
				'0,00'
			ELSE
				REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorFinsocialDocumento),'.',',')
			END
		END
	END + '|'
+	CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		''
    ELSE
		CASE WHEN tbDocumento.CodigoModeloNotaFiscal = 65 THEN
			''
		ELSE
			CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
				'0,00'
			ELSE
				REPLACE(CONVERT(VARCHAR(16),COALESCE(tbDocumento.ValorPISSTDocumento,0)),'.',',')
			END
		END
	END + '|'
+	CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		''
    ELSE
		CASE WHEN tbDocumento.CodigoModeloNotaFiscal = 65 THEN
			''
		ELSE
			CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
				'0,00' 
			ELSE
				REPLACE(CONVERT(VARCHAR(16),COALESCE(tbDocumento.ValorCofinsSTDocumento,0)),'.',',')
			END
		END
	END + '|',
'C100',
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		0
	ELSE
		tbDocumento.CodigoCliFor
END,
tbDocumento.TipoLancamentoMovimentacao,
11,
'',
0,
'',
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		0
	ELSE
		COALESCE(tbDocumentoFT.CodigoClienteEventual,0)
END
FROM tbDocumento (NOLOCK)
INNER JOIN tbEmpresa (NOLOCK) ON
           tbEmpresa.CodigoEmpresa = @CodigoEmpresa
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal
INNER JOIN tbCliFor (NOLOCK) ON
           tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
           tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor 
LEFT JOIN tbDocumentoFT (NOLOCK) ON
		  tbDocumentoFT.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoFT.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoFT.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoFT.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoFT.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoFT.DataDocumento		= tbDocumento.DataDocumento 
LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
		  tbNaturezaOperacao.CodigoEmpresa	= tbDocumento.CodigoEmpresa AND
		  tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao 
LEFT JOIN tbDocumentoNFe (NOLOCK) ON
		  tbDocumentoNFe.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoNFe.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoNFe.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoNFe.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoNFe.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoNFe.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoNFe.DataDocumento		= tbDocumento.DataDocumento 
LEFT JOIN tbItemDocumento (NOLOCK) ON
		  tbItemDocumento.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbItemDocumento.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbItemDocumento.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbItemDocumento.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbItemDocumento.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbItemDocumento.DataDocumento		= tbDocumento.DataDocumento 
WHERE 
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = tbDocumento.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao AND
		tbDocumento.TipoLancamentoMovimentacao IN (1,7,9,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)			
	OR  tbDocumento.TipoLancamentoMovimentacao IN (10,12)
	OR  ( tbDocumento.TipoLancamentoMovimentacao = 1 AND tbDocumentoFT.CodigoNaturezaOperacao IS NULL )
	)
	AND tbDocumento.CodigoModeloNotaFiscal IN (1,4,55,65)
	AND (	tbDocumento.EspecieDocumento <> 'ECF' OR						-- Cupons Fiscais somente vão no SPED
			tbDocumento.NumeroDocumento <> tbDocumento.NumeroNFDocumento )	-- se tiverem NF Conjugada (TKT 234897 / 2016)
	AND tbDocumento.CodigoEmpresa		= @CodigoEmpresa 
	AND tbDocumento.CodigoLocal		    = @CodigoLocal
	AND tbDocumento.DataDocumento 		between @DataInicial and @DataFinal  
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
	(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento = tbDocumento.DataEmissaoDocumento) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento = 0 ))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento <> tbDocumento.DataEmissaoDocumento) OR (tbDocumento.TipoLancamentoMovimentacao = 11) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento <> 0))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 12 OR tbDocumento.TipoLancamentoMovimentacao = 11 OR tbDocumento.CondicaoNFCancelada = 'V')) OR 
	(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 11))
	)
	AND 'V' = CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' and 
	          	    tbDocumento.CondicaoNFCancelada = 'V' and 
               		    tbDocumento.TipoLancamentoMovimentacao <> 7 
			THEN 'F'
			ELSE 'V'
		  END
	AND ( 
			tbLocalLF.ImprimeServicoRegSaida = 'V' OR
            ( tbDocumento.TipoLancamentoMovimentacao <> 7 ) OR
			( tbDocumento.ValorBaseISSDocumento = 0 AND
 			  NOT EXISTS ( SELECT 1 FROM tbItemDocumento B
			 		       WHERE 
						   B.CodigoEmpresa = @CodigoEmpresa AND
					       B.CodigoLocal = @CodigoLocal AND
					       B.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
					       B.DataDocumento = tbDocumento.DataDocumento AND
					       B.CodigoCliFor = tbDocumento.CodigoCliFor AND
					       B.NumeroDocumento = tbDocumento.NumeroDocumento AND
					       B.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
                           B.TipoRegistroItemDocto = 'MOB' ))
		)
	AND EXISTS ( SELECT 1 FROM tbItemDocumento A
                 WHERE 
                 A.CodigoEmpresa = @CodigoEmpresa AND
                 A.CodigoLocal = @CodigoLocal AND
                 A.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
                 A.DataDocumento = tbDocumento.DataDocumento AND
                 A.CodigoCliFor = tbDocumento.CodigoCliFor AND
                 A.NumeroDocumento = tbDocumento.NumeroDocumento AND
                 A.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao )
	AND (
			--- o campo recapagem foi utilizado em NF/Uso/Consumo para indicar se a nota é de serviços	
			--- se for de serviços, não leva para o sped fiscal
			( tbDocumento.TipoLancamentoMovimentacao IN (9,10) AND tbDocumento.Recapagem <> 'V' ) OR 
            tbDocumento.TipoLancamentoMovimentacao NOT IN (9,10)
	    )
GROUP BY
	tbDocumento.CodigoEmpresa,
	tbDocumento.CodigoLocal,
	tbDocumento.EntradaSaidaDocumento,
	tbDocumento.NumeroDocumento,
	tbDocumento.DataDocumento,
	tbDocumento.CodigoCliFor,
	tbDocumento.TipoLancamentoMovimentacao,
	tbDocumentoNFe.ChaveAcessoNFe,
	tbDocumento.CondicaoNFCancelada,
	tbDocumento.EspecieDocumento,
	tbDocumentoFT.TipoTratamentoNFDigitadaDocFT,
	tbDocumento.CondicaoComplementoICMSDocto,
	tbNaturezaOperacao.CodigoTipoOperacao,
	tbDocumentoFT.CodigoClienteEventual,
	tbDocumento.CodigoModeloNotaFiscal,
	tbDocumento.SerieDocumento,
	tbDocumento.DataEmissaoDocumento,
	tbDocumento.ValorContabilDocumento,
	tbLocal.UFLocal,
	tbDocumento.TotalProdutosDocumento,
	tbDocumentoFT.ValorFreteDocFT,
	tbDocumentoFT.TipoFreteDocFT,
	tbDocumentoFT.ValorSeguroDocFT,
	tbDocumento.ValorBaseICMS1Documento,
	tbDocumento.ValorICMSDocumento,
	tbDocumento.ValorBaseICMSSubstTribDocto,
	tbDocumento.ValorICMSSubstTribDocto,
	tbDocumento.ValorDifAliquotaICMSDocto,
	tbEmpresa.EquiparadoIndustria,
	tbLocalLF.CondicaoContribuinteIPI,
	tbDocumento.ValorIPIDocumento,
	tbDocumento.ValorPISDocumento,
	tbDocumento.ValorFinsocialDocumento,
	tbDocumento.ValorPISSTDocumento,
	tbDocumento.ValorCofinsSTDocumento,
	tbCliFor.UFCliFor,
	tbDocumento.ValorBaseIPI1Documento

IF CONVERT(NUMERIC(4),@Versao) >= 10
BEGIN
	---- C101 - PARTILHA DE ICMS NAS VENDAS A CONSUMIDOR NÃO CONTRIBUINTE
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|C101|'
	+	REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumentoPartilhaICMS.vFCPUFDest)),'.',',') + '|' -- VL_FCP_UF_DEST
	+	REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumentoPartilhaICMS.vICMSUFDest)),'.',',') + '|' -- VL_ICMS_UF_DEST
	+	REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumentoPartilhaICMS.vICMSUFRemet)),'.',',') + '|', -- VL_ICMS_UF_REM
	'C101',
	tbDocumento.EntradaSaidaDocumento,
	tbDocumento.NumeroDocumento,
	tbDocumento.DataDocumento,
	tbDocumento.CodigoCliFor,
	tbDocumento.TipoLancamentoMovimentacao,
	11,
	'',
	0,
	'',
	COALESCE(tbDocumentoFT.CodigoClienteEventual,0)
	FROM tbDocumento (NOLOCK)
	INNER JOIN	rtSPEDFiscal (NOLOCK) ON
				rtSPEDFiscal.Spid = @@spid AND
				rtSPEDFiscal.EntradaSaida = tbDocumento.EntradaSaidaDocumento AND
				rtSPEDFiscal.DataDocumento = tbDocumento.DataDocumento AND
				rtSPEDFiscal.CodigoCliFor = tbDocumento.CodigoCliFor AND
				rtSPEDFiscal.NumeroDocumento = tbDocumento.NumeroDocumento AND
				rtSPEDFiscal.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
				rtSPEDFiscal.TipoRegistro = 'C100'
	INNER JOIN	tbItemDocumentoPartilhaICMS (NOLOCK) ON
				tbItemDocumentoPartilhaICMS.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
				tbItemDocumentoPartilhaICMS.CodigoLocal = tbDocumento.CodigoLocal AND
				tbItemDocumentoPartilhaICMS.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
				tbItemDocumentoPartilhaICMS.NumeroDocumento = tbDocumento.NumeroDocumento AND
				tbItemDocumentoPartilhaICMS.DataDocumento = tbDocumento.DataDocumento AND
				tbItemDocumentoPartilhaICMS.CodigoCliFor = tbDocumento.CodigoCliFor AND
				tbItemDocumentoPartilhaICMS.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao
	INNER JOIN	tbDocumentoFT (NOLOCK) ON
				tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
				tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND
				tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
				tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
				tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND
				tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
				tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao
	WHERE 
		tbDocumento.CodigoModeloNotaFiscal = 55
	GROUP BY
		tbDocumento.CodigoEmpresa,
		tbDocumento.CodigoLocal,
		tbDocumento.EntradaSaidaDocumento,
		tbDocumento.NumeroDocumento,
		tbDocumento.DataDocumento,
		tbDocumento.CodigoCliFor,
		tbDocumento.TipoLancamentoMovimentacao,
		tbDocumentoFT.CodigoClienteEventual
END


---- C110

INSERT rtSPEDFiscal
SELECT DISTINCT
@@spid,
	'|C110|'
+	CASE
	WHEN tbNaturezaOperacao.CodigoTipoOperacao IN (7, 8) AND tbDocumento.EntradaSaidaDocumento = 'S' THEN
		'DEVVEN' -- DEVOLUÇÃO DE VENDA
	WHEN tbNaturezaOperacao.CodigoTipoOperacao IN (7, 8) AND tbDocumento.EntradaSaidaDocumento = 'E' THEN
		'DEVCOM' -- DEVOLUÇÃO DE COMPRA
	WHEN tbNaturezaOperacao.CodigoTipoOperacao IN (6) THEN
		'REMESS' -- SIMPLES REMESSA
	WHEN tbNaturezaOperacao.CodigoTipoOperacao IN (82) THEN
		'RETCON' -- RETORNO DE VEICULO EM CONSIGNACAO
	WHEN tbNaturezaOperacao.CodigoTipoOperacao IN (20) THEN
		'COMPLM' -- NF COMPLEMENTAR ICMS/IPI
	WHEN tbNaturezaOperacao.CodigoTipoOperacao IN (97) THEN
		'RVTERC' -- RETORNO DE VEICULO DE TERCEIRO
	ELSE
		'OBSDOC' -- OBSERVAÇÕES - DOCUMENTOS EM GERAL
	END + '|'
+	RTRIM(LTRIM(LEFT(REPLACE(REPLACE(REPLACE(
		RTRIM(COALESCE(tbDocumentoTextos.ObservacaoDocumento,'')) + ' ' +
		dbo.fnGeraTextoInfCompDANFE(tbDocumento.CodigoEmpresa,
									tbDocumento.CodigoLocal,
									tbDocumento.EntradaSaidaDocumento,
									tbDocumento.NumeroDocumento,
									tbDocumento.DataDocumento,
									tbDocumento.CodigoCliFor,
									tbDocumento.TipoLancamentoMovimentacao),
	CHAR(13),' '),CHAR(10),' '),' ',' '),255))) + '|',
'C110',
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao,
11,
'',
0,
'',
0
FROM tbDocumento (NOLOCK)
INNER JOIN tbCliFor (NOLOCK) ON
           tbCliFor.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
           tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
           tbLocalLF.CodigoLocal = tbDocumento.CodigoLocal
INNER JOIN tbLocalFT (NOLOCK) ON
           tbLocalFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
           tbLocalFT.CodigoLocal = tbDocumento.CodigoLocal
INNER JOIN tbDocumentoFT (NOLOCK) ON
		  tbDocumentoFT.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoFT.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoFT.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoFT.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoFT.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoFT.DataDocumento		= tbDocumento.DataDocumento 
LEFT JOIN tbItemDocumento (NOLOCK) ON
		  tbItemDocumento.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbItemDocumento.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbItemDocumento.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbItemDocumento.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbItemDocumento.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbItemDocumento.DataDocumento		= tbDocumento.DataDocumento 
INNER JOIN tbNaturezaOperacao (NOLOCK) ON
		  tbNaturezaOperacao.CodigoEmpresa	= tbDocumento.CodigoEmpresa AND
		  tbNaturezaOperacao.CodigoNaturezaOperacao = COALESCE(tbDocumentoFT.CodigoNaturezaOperacao,tbItemDocumento.CodigoNaturezaOperacao)
INNER JOIN rtSPEDFiscal (NOLOCK) ON
           rtSPEDFiscal.Spid = @@spid AND
           rtSPEDFiscal.EntradaSaida = tbDocumento.EntradaSaidaDocumento AND
           rtSPEDFiscal.DataDocumento = tbDocumento.DataDocumento AND
           rtSPEDFiscal.CodigoCliFor = tbDocumento.CodigoCliFor AND
           rtSPEDFiscal.NumeroDocumento = tbDocumento.NumeroDocumento AND
           rtSPEDFiscal.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		   rtSPEDFiscal.TipoRegistro = 'C100'
INNER JOIN tbDocumentoTextos (NOLOCK) ON
		  tbDocumentoTextos.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoTextos.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoTextos.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoTextos.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoTextos.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoTextos.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoTextos.DataDocumento		= tbDocumento.DataDocumento 

WHERE 
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = tbDocumento.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao AND
		tbDocumento.TipoLancamentoMovimentacao IN (1,7,9,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)			
	OR  tbDocumento.TipoLancamentoMovimentacao IN (10,12)
	OR  ( tbDocumento.TipoLancamentoMovimentacao = 1 AND tbDocumentoFT.CodigoNaturezaOperacao IS NULL )
	)
	AND tbDocumento.CodigoEmpresa		= @CodigoEmpresa 
	AND tbDocumento.CodigoLocal		    = @CodigoLocal
	AND tbDocumento.CodigoModeloNotaFiscal <> 65
	AND (
			tbNaturezaOperacao.CodigoTipoOperacao IN (6, 7, 8, 20, 82, 97)	-- Observação gerada obrigatoriamente
		OR 
			LEFT(RTRIM(LTRIM(REPLACE(
			RTRIM(COALESCE(tbDocumentoTextos.ObservacaoDocumento,'')) + ' ' +
			dbo.fnGeraTextoInfCompDANFE(tbDocumento.CodigoEmpresa,
										tbDocumento.CodigoLocal,
										tbDocumento.EntradaSaidaDocumento,
										tbDocumento.NumeroDocumento,
										tbDocumento.DataDocumento,
										tbDocumento.CodigoCliFor,
										tbDocumento.TipoLancamentoMovimentacao),
			CHAR(13)+CHAR(10), ' '))),255) <> ''							-- Quando houver observações a informar
		)
	AND tbDocumento.DataDocumento 		between @DataInicial and @DataFinal  
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
	(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento = tbDocumento.DataEmissaoDocumento) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento = 0 ))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento <> tbDocumento.DataEmissaoDocumento) OR (tbDocumento.TipoLancamentoMovimentacao = 11) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento <> 0))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 12 OR tbDocumento.TipoLancamentoMovimentacao = 11 OR tbDocumento.CondicaoNFCancelada = 'V')) OR 
	(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 11))
	)
	AND tbDocumento.CondicaoNFCancelada = 'F'
	AND ( 
			tbLocalLF.ImprimeServicoRegSaida = 'V' OR
			tbDocumento.ValorBaseISSDocumento = 0
		)
	AND EXISTS ( SELECT 1 FROM tbItemDocumento A
                 WHERE 
                 A.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
                 A.CodigoLocal = tbDocumento.CodigoLocal AND
                 A.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
                 A.DataDocumento = tbDocumento.DataDocumento AND
                 A.CodigoCliFor = tbDocumento.CodigoCliFor AND
                 A.NumeroDocumento = tbDocumento.NumeroDocumento AND
                 A.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao )
		-- Regra retirada conf. Ticket 218018 (FM 14653) para permitir que o registro seja informado também nos documentos de emissão própria
		--  AND ((tbDocumento.EntradaSaidaDocumento <> 'E' AND tbNaturezaOperacao.CodigoTipoOperacao NOT IN (7,8)) 
			--OR NOT EXISTS ( SELECT 1 FROM tbDocumentoNFe 
			--				 WHERE
			--				 tbDocumentoNFe.CodigoEmpresa = @CodigoEmpresa AND
			--				 tbDocumentoNFe.CodigoLocal = @CodigoLocal AND
			--				 tbDocumentoNFe.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
			--				 tbDocumentoNFe.DataDocumento = tbDocumento.DataDocumento AND
			--				 tbDocumentoNFe.CodigoCliFor = tbDocumento.CodigoCliFor AND
			--				 tbDocumentoNFe.NumeroDocumento = tbDocumento.NumeroDocumento AND
			--				 tbDocumentoNFe.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
			--				 tbDocumentoNFe.NumeroProtocolo IS NOT NULL AND
			--				 tbDocumentoNFe.NumeroProtocolo > 0))

---- 
INSERT rtSPEDFiscal
SELECT DISTINCT
@@spid,
'|C110|VENECF||',
'C110',
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao,
11,
'',
0,
'',
0
FROM tbDocumento (NOLOCK)
INNER JOIN tbCliFor (NOLOCK) ON
           tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
           tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal
INNER JOIN tbLocalFT (NOLOCK) ON
           tbLocalFT.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalFT.CodigoLocal = @CodigoLocal
INNER JOIN tbDocumentoFT (NOLOCK) ON
		  tbDocumentoFT.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoFT.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoFT.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoFT.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoFT.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoFT.DataDocumento		= tbDocumento.DataDocumento 
LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
		  tbNaturezaOperacao.CodigoEmpresa	= tbDocumento.CodigoEmpresa AND
		  tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao 
INNER JOIN rtSPEDFiscal (NOLOCK) ON
           rtSPEDFiscal.Spid = @@spid AND
           rtSPEDFiscal.EntradaSaida = tbDocumento.EntradaSaidaDocumento AND
           rtSPEDFiscal.DataDocumento = tbDocumento.DataDocumento AND
           rtSPEDFiscal.CodigoCliFor = tbDocumento.CodigoCliFor AND
           rtSPEDFiscal.NumeroDocumento = tbDocumento.NumeroDocumento AND
           rtSPEDFiscal.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		   rtSPEDFiscal.TipoRegistro = 'C100'
WHERE 
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = tbDocumento.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao AND
		tbDocumento.TipoLancamentoMovimentacao IN (1,7,9,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)			
	OR  tbDocumento.TipoLancamentoMovimentacao IN (10,12)
	OR  ( tbDocumento.TipoLancamentoMovimentacao = 1 AND tbDocumentoFT.CodigoNaturezaOperacao IS NULL )
	)
	AND tbDocumento.EspecieDocumento	= 'ECF'
	AND tbDocumento.CodigoEmpresa		= @CodigoEmpresa 
	AND tbDocumento.CodigoLocal		    = @CodigoLocal
	AND tbDocumento.DataDocumento 		between @DataInicial and @DataFinal  
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND tbDocumento.CodigoModeloNotaFiscal <> 65 
	AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
	(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento = tbDocumento.DataEmissaoDocumento) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento = 0 ))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento <> tbDocumento.DataEmissaoDocumento) OR (tbDocumento.TipoLancamentoMovimentacao = 11) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento <> 0))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 12 OR tbDocumento.TipoLancamentoMovimentacao = 11 OR tbDocumento.CondicaoNFCancelada = 'V')) OR 
	(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 11))
	)
	AND tbDocumento.EntradaSaidaDocumento = 'S'
	AND tbDocumento.CondicaoNFCancelada = 'F'
	AND ( 
			tbLocalLF.ImprimeServicoRegSaida = 'V' OR
			tbDocumento.ValorBaseISSDocumento = 0
		)
	AND EXISTS ( SELECT 1 FROM tbItemDocumento A
                 WHERE 
                 A.CodigoEmpresa = @CodigoEmpresa AND
                 A.CodigoLocal = @CodigoLocal AND
                 A.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
                 A.DataDocumento = tbDocumento.DataDocumento AND
                 A.CodigoCliFor = tbDocumento.CodigoCliFor AND
                 A.NumeroDocumento = tbDocumento.NumeroDocumento AND
                 A.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao )

---- C113 - DOCUMENTO FISCAL REFERENCIADO
-- C113 - Documento Referenciado na tbDocumentoFT.NotaFiscalOriginalDocFT
INSERT rtSPEDFiscal
SELECT
@@spid,
'|C113|' + 
+	CASE WHEN docRef.EntradaSaidaDocumento = 'E' THEN
		'0'
	ELSE
		'1'
	END + '|'
+	CASE WHEN ( 
            ( tbDocumentoNFe.ChaveAcessoNFe IS NOT NULL OR docRef.CondicaoNFCancelada = 'V' OR docRef.EspecieDocumento = 'ECF' ) AND
            docRef.TipoLancamentoMovimentacao not in (1,9,10) AND
			( ( docRef.TipoLancamentoMovimentacao = 7 and ( tbDocumentoFT.TipoTratamentoNFDigitadaDocFT <> 'N' OR docRef.CodigoEmpresa = 2490 )) OR ---Mavel Totvs 
              docRef.TipoLancamentoMovimentacao <> 7 )
          ) OR  --- Emissao Própria ?
		  ( docRef.TipoLancamentoMovimentacao = 10 AND docRef.EntradaSaidaDocumento = 'S' AND docRef.CodigoEmpresa = 2380 AND docRef.CodigoLocal = 3 ) OR
          ( docRef.CondicaoComplementoICMSDocto = 'V' and docRef.EntradaSaidaDocumento = 'S' ) OR
          ( docRef.TipoLancamentoMovimentacao = 7 AND tbNaturezaOperacao.CodigoTipoOperacao in (10,12) ) OR
          ( docRef.TipoLancamentoMovimentacao in (7,10) AND docRef.CondicaoNFCancelada = 'V' and tbDocumentoFT.TipoTratamentoNFDigitadaDocFT <> 'N' ) THEN
		'0'
	ELSE
		'1'
	END + '|'
+	CASE 
	WHEN docRef.CondicaoNFCancelada = 'V' OR docRef.TipoLancamentoMovimentacao = 11 THEN
		''
	ELSE
		CONVERT(VARCHAR(14),COALESCE(tbDocumentoFT.CodigoClienteEventual,docRef.CodigoCliFor))
	END  + '|'
+	RIGHT(CONVERT(VARCHAR(3),100 + docRef.CodigoModeloNotaFiscal),2) + '|'
+	right('000'+rtrim(ltrim(coalesce(docRef.SerieDocumento,''))),3) + '|'
+	'' + '|' -- SUB
+	CONVERT(VARCHAR(9),docRef.NumeroDocumento) + '|'
+	CASE 
	WHEN docRef.CondicaoNFCancelada = 'V' OR docRef.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,docRef.DataEmissaoDocumento)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,docRef.DataEmissaoDocumento)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,docRef.DataEmissaoDocumento)) + '|' 
	END
+	CASE WHEN CONVERT(NUMERIC(3),@Versao) >= 11 THEN
		COALESCE(tbDocumentoNFe.ChaveAcessoNFe,'')
	ELSE
		''
	END + '|',
'C113',
docPrinc.EntradaSaidaDocumento,
docPrinc.NumeroDocumento,
docPrinc.DataDocumento,
docPrinc.CodigoCliFor,
docPrinc.TipoLancamentoMovimentacao,
11,
'',
0,
'',
0
FROM tbDocumento docRef (NOLOCK)
INNER JOIN tbDocumentoFT docPrinc (NOLOCK) ON
		   docPrinc.CodigoEmpresa = docRef.CodigoEmpresa AND
		   docPrinc.CodigoLocal = docRef.CodigoLocal AND
		   docPrinc.CodigoCliFor = docRef.CodigoCliFor AND
		   docPrinc.NotaFiscalOriginalDocFT = docRef.NumeroDocumento AND
		   docPrinc.DataEmissaoNFOriginalDocFT = docRef.DataEmissaoDocumento
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal
INNER JOIN tbDocumentoFT (NOLOCK) ON
 		   tbDocumentoFT.CodigoEmpresa		= docRef.CodigoEmpresa AND
           tbDocumentoFT.CodigoLocal		= docRef.CodigoLocal AND
		   tbDocumentoFT.EntradaSaidaDocumento	= docRef.EntradaSaidaDocumento AND
		   tbDocumentoFT.NumeroDocumento		= docRef.NumeroDocumento AND
		   tbDocumentoFT.CodigoCliFor		= docRef.CodigoCliFor AND
		   tbDocumentoFT.TipoLancamentoMovimentacao = docRef.TipoLancamentoMovimentacao AND
		   tbDocumentoFT.DataDocumento		= docRef.DataDocumento 
INNER JOIN tbNaturezaOperacao (NOLOCK) ON
		   tbNaturezaOperacao.CodigoEmpresa	= docRef.CodigoEmpresa AND
		   tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao 
INNER JOIN rtSPEDFiscal (NOLOCK) ON
           rtSPEDFiscal.Spid = @@spid AND
           rtSPEDFiscal.EntradaSaida = docPrinc.EntradaSaidaDocumento AND
           rtSPEDFiscal.DataDocumento = docPrinc.DataDocumento AND
           rtSPEDFiscal.CodigoCliFor = docPrinc.CodigoCliFor AND
           rtSPEDFiscal.NumeroDocumento = docPrinc.NumeroDocumento AND
           rtSPEDFiscal.TipoLancamentoMovimentacao = docPrinc.TipoLancamentoMovimentacao AND
		   rtSPEDFiscal.TipoRegistro = 'C110'
LEFT JOIN  tbDocumentoNFe (NOLOCK) ON
		   tbDocumentoNFe.CodigoEmpresa		= docRef.CodigoEmpresa AND
           tbDocumentoNFe.CodigoLocal		= docRef.CodigoLocal AND
		   tbDocumentoNFe.EntradaSaidaDocumento	= docRef.EntradaSaidaDocumento AND
		   tbDocumentoNFe.NumeroDocumento		= docRef.NumeroDocumento AND
		   tbDocumentoNFe.CodigoCliFor		= docRef.CodigoCliFor AND
		   tbDocumentoNFe.TipoLancamentoMovimentacao = docRef.TipoLancamentoMovimentacao AND
		   tbDocumentoNFe.DataDocumento		= docRef.DataDocumento 

WHERE 
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = docRef.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao AND
		docRef.TipoLancamentoMovimentacao IN (1,7,9,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)			
	OR  docRef.TipoLancamentoMovimentacao IN (10,12)
	OR  ( docRef.TipoLancamentoMovimentacao = 1 AND tbDocumentoFT.CodigoNaturezaOperacao IS NULL )
	)
	AND docRef.CodigoEmpresa		= @CodigoEmpresa 
	AND docRef.CodigoLocal		    = @CodigoLocal
	AND docPrinc.CodigoEmpresa		= @CodigoEmpresa 
	AND docPrinc.CodigoLocal		    = @CodigoLocal
	AND docPrinc.DataDocumento between @DataInicial AND @DataFinal 
	AND docRef.TipoLancamentoMovimentacao <> 11
	AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
	(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((docRef.TipoLancamentoMovimentacao = 12 AND docRef.DataDocumento = docRef.DataEmissaoDocumento) OR (docRef.CondicaoNFCancelada = 'V' AND docRef.ValorContabilDocumento = 0 ))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((docRef.TipoLancamentoMovimentacao = 12 AND docRef.DataDocumento <> docRef.DataEmissaoDocumento) OR (docRef.TipoLancamentoMovimentacao = 11) OR (docRef.CondicaoNFCancelada = 'V' AND docRef.ValorContabilDocumento <> 0))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (docRef.TipoLancamentoMovimentacao = 12 OR docRef.TipoLancamentoMovimentacao = 11 OR docRef.CondicaoNFCancelada = 'V')) OR 
	(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (docRef.TipoLancamentoMovimentacao = 11))
	)
	AND docRef.CondicaoNFCancelada = 'F'
	AND ( 
			tbLocalLF.ImprimeServicoRegSaida = 'V' OR
			docRef.ValorBaseISSDocumento = 0
		)
	AND EXISTS ( SELECT 1 FROM tbItemDocumento A
                 WHERE 
                 A.CodigoEmpresa = @CodigoEmpresa AND
                 A.CodigoLocal = @CodigoLocal AND
                 A.EntradaSaidaDocumento = docRef.EntradaSaidaDocumento AND
                 A.DataDocumento = docRef.DataDocumento AND
                 A.CodigoCliFor = docRef.CodigoCliFor AND
                 A.NumeroDocumento = docRef.NumeroDocumento AND
                 A.TipoLancamentoMovimentacao = docRef.TipoLancamentoMovimentacao )
	AND docPrinc.DataDocumento >= docRef.DataDocumento

-- C113 - Documento Referenciado na tbPedidoComplementar.NotaFiscalOriginal
INSERT rtSPEDFiscal
SELECT
@@spid,
'|C113|' + 
+	CASE WHEN docRef.EntradaSaidaDocumento = 'E' THEN
		'0'
	ELSE
		'1'
	END + '|'
+	CASE WHEN ( 
            ( tbDocumentoNFe.ChaveAcessoNFe IS NOT NULL OR docRef.CondicaoNFCancelada = 'V' OR docRef.EspecieDocumento = 'ECF' ) AND
            docRef.TipoLancamentoMovimentacao not in (1,9,10) AND
			( ( docRef.TipoLancamentoMovimentacao = 7 and ( tbDocumentoFT.TipoTratamentoNFDigitadaDocFT <> 'N' OR docRef.CodigoEmpresa = 2490 )) OR ---Mavel Totvs 
              docRef.TipoLancamentoMovimentacao <> 7 )
          ) OR  --- Emissao Própria ?
		  ( docRef.TipoLancamentoMovimentacao = 10 AND docRef.EntradaSaidaDocumento = 'S' AND docRef.CodigoEmpresa = 2380 AND docRef.CodigoLocal = 3 ) OR
          ( docRef.CondicaoComplementoICMSDocto = 'V' and docRef.EntradaSaidaDocumento = 'S' ) OR
          ( docRef.TipoLancamentoMovimentacao = 7 AND tbNaturezaOperacao.CodigoTipoOperacao in (10,12) ) OR
          ( docRef.TipoLancamentoMovimentacao in (7,10) AND docRef.CondicaoNFCancelada = 'V' and tbDocumentoFT.TipoTratamentoNFDigitadaDocFT <> 'N' ) THEN
		'0'
	ELSE
		'1'
	END + '|'
+	CASE 
	WHEN docRef.CondicaoNFCancelada = 'V' OR docRef.TipoLancamentoMovimentacao = 11 THEN
		''
	ELSE
		CONVERT(VARCHAR(14),COALESCE(tbDocumentoFT.CodigoClienteEventual,docRef.CodigoCliFor))
	END  + '|'
+	RIGHT(CONVERT(VARCHAR(3),100 + docRef.CodigoModeloNotaFiscal),2) + '|'
+	right('000'+rtrim(ltrim(coalesce(docRef.SerieDocumento,''))),3) + '|'
+	'' + '|' -- SUB
+	CONVERT(VARCHAR(12),docRef.NumeroDocumento) + '|'
+	CASE 
	WHEN docRef.CondicaoNFCancelada = 'V' OR docRef.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,docRef.DataEmissaoDocumento)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,docRef.DataEmissaoDocumento)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,docRef.DataEmissaoDocumento)) + '|' 
	END
+	CASE WHEN CONVERT(NUMERIC(3),@Versao) >= 11 THEN
		COALESCE(tbDocumentoNFe.ChaveAcessoNFe,'')
	ELSE
		''
	END + '|',
'C113',
docPrinc.EntradaSaidaDocumento,
docPrinc.NumeroDocumento,
docPrinc.DataDocumento,
docPrinc.CodigoCliFor,
docPrinc.TipoLancamentoMovimentacao,
11,
'',
0,
'',
0
FROM tbPedidoComplementar pedCompl (NOLOCK)
INNER JOIN tbPedido ped (NOLOCK) ON
		   pedCompl.CodigoEmpresa = ped.CodigoEmpresa AND
		   pedCompl.CodigoLocal = ped.CodigoLocal AND
		   pedCompl.CentroCusto = ped.CentroCusto AND
		   pedCompl.NumeroPedido = ped.NumeroPedido AND
		   pedCompl.SequenciaPedido = ped.SequenciaPedido
INNER JOIN tbDocumento doc (NOLOCK) ON
		   doc.CodigoEmpresa = ped.CodigoEmpresa AND
		   doc.CodigoLocal = ped.CodigoLocal AND
		   doc.NumeroPedidoDocumento = ped.NumeroPedido AND
		   doc.NumeroSequenciaPedidoDocumento = ped.SequenciaPedido
INNER JOIN tbDocumentoFT docPrinc (NOLOCK) ON
		   docPrinc.CodigoEmpresa = doc.CodigoEmpresa AND
		   docPrinc.CodigoLocal = doc.CodigoLocal AND
		   docPrinc.EntradaSaidaDocumento = doc.EntradaSaidaDocumento AND
		   docPrinc.NumeroDocumento = doc.NumeroDocumento AND
		   docPrinc.DataDocumento = doc.DataDocumento AND
		   docPrinc.CodigoCliFor = doc.CodigoCliFor AND
		   docPrinc.TipoLancamentoMovimentacao = doc.TipoLancamentoMovimentacao AND
		   docPrinc.CentroCusto = ped.CentroCusto
INNER JOIN tbDocumento docRef (NOLOCK) ON
		   docRef.CodigoEmpresa = doc.CodigoEmpresa AND
		   docRef.CodigoLocal = doc.CodigoLocal AND
		   docRef.CodigoCliFor = doc.CodigoCliFor AND
		   docRef.NumeroDocumento = pedCompl.NotaFiscalOriginal AND
		   docRef.DataEmissaoDocumento = pedCompl.DataEmissaoNFOriginal
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal
INNER JOIN tbDocumentoFT (NOLOCK) ON
 		   tbDocumentoFT.CodigoEmpresa		= docRef.CodigoEmpresa AND
           tbDocumentoFT.CodigoLocal		= docRef.CodigoLocal AND
		   tbDocumentoFT.EntradaSaidaDocumento	= docRef.EntradaSaidaDocumento AND
		   tbDocumentoFT.NumeroDocumento		= docRef.NumeroDocumento AND
		   tbDocumentoFT.CodigoCliFor		= docRef.CodigoCliFor AND
		   tbDocumentoFT.TipoLancamentoMovimentacao = docRef.TipoLancamentoMovimentacao AND
		   tbDocumentoFT.DataDocumento		= docRef.DataDocumento 
INNER JOIN tbNaturezaOperacao (NOLOCK) ON
		   tbNaturezaOperacao.CodigoEmpresa	= docRef.CodigoEmpresa AND
		   tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao 
INNER JOIN rtSPEDFiscal (NOLOCK) ON
           rtSPEDFiscal.Spid = @@spid AND
           rtSPEDFiscal.EntradaSaida = docPrinc.EntradaSaidaDocumento AND
           rtSPEDFiscal.DataDocumento = docPrinc.DataDocumento AND
           rtSPEDFiscal.CodigoCliFor = docPrinc.CodigoCliFor AND
           rtSPEDFiscal.NumeroDocumento = docPrinc.NumeroDocumento AND
           rtSPEDFiscal.TipoLancamentoMovimentacao = docPrinc.TipoLancamentoMovimentacao AND
		   rtSPEDFiscal.TipoRegistro = 'C110'
LEFT JOIN  tbDocumentoNFe (NOLOCK) ON
		   tbDocumentoNFe.CodigoEmpresa		= docRef.CodigoEmpresa AND
           tbDocumentoNFe.CodigoLocal		= docRef.CodigoLocal AND
		   tbDocumentoNFe.EntradaSaidaDocumento	= docRef.EntradaSaidaDocumento AND
		   tbDocumentoNFe.NumeroDocumento		= docRef.NumeroDocumento AND
		   tbDocumentoNFe.CodigoCliFor		= docRef.CodigoCliFor AND
		   tbDocumentoNFe.TipoLancamentoMovimentacao = docRef.TipoLancamentoMovimentacao AND
		   tbDocumentoNFe.DataDocumento		= docRef.DataDocumento 

WHERE 
	pedCompl.NotaFiscalOriginal IS NOT NULL AND
	pedCompl.NotaFiscalOriginal <> 0 AND
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = docRef.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao AND
		docRef.TipoLancamentoMovimentacao IN (1,7,9,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)			
	OR  docRef.TipoLancamentoMovimentacao IN (10,12)
	OR  ( docRef.TipoLancamentoMovimentacao = 1 AND tbDocumentoFT.CodigoNaturezaOperacao IS NULL )
	)
	AND docRef.CodigoEmpresa		= @CodigoEmpresa 
	AND docRef.CodigoLocal		    = @CodigoLocal
	AND docRef.TipoLancamentoMovimentacao <> 11
	AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
	(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((docRef.TipoLancamentoMovimentacao = 12 AND docRef.DataDocumento = docRef.DataEmissaoDocumento) OR (docRef.CondicaoNFCancelada = 'V' AND docRef.ValorContabilDocumento = 0 ))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((docRef.TipoLancamentoMovimentacao = 12 AND docRef.DataDocumento <> docRef.DataEmissaoDocumento) OR (docRef.TipoLancamentoMovimentacao = 11) OR (docRef.CondicaoNFCancelada = 'V' AND docRef.ValorContabilDocumento <> 0))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (docRef.TipoLancamentoMovimentacao = 12 OR docRef.TipoLancamentoMovimentacao = 11 OR docRef.CondicaoNFCancelada = 'V')) OR 
	(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (docRef.TipoLancamentoMovimentacao = 11))
	)
	AND docRef.CondicaoNFCancelada = 'F'
	AND ( 
			tbLocalLF.ImprimeServicoRegSaida = 'V' OR
			docRef.ValorBaseISSDocumento = 0
		)
	AND EXISTS ( SELECT 1 FROM tbItemDocumento A
                 WHERE 
                 A.CodigoEmpresa = @CodigoEmpresa AND
                 A.CodigoLocal = @CodigoLocal AND
                 A.EntradaSaidaDocumento = docRef.EntradaSaidaDocumento AND
                 A.DataDocumento = docRef.DataDocumento AND
                 A.CodigoCliFor = docRef.CodigoCliFor AND
                 A.NumeroDocumento = docRef.NumeroDocumento AND
                 A.TipoLancamentoMovimentacao = docRef.TipoLancamentoMovimentacao )
	AND (docPrinc.NotaFiscalOriginalDocFT IS NULL OR docPrinc.NotaFiscalOriginalDocFT = 0) -- Somente quando não existir a informação na tbDocumentoFT
	AND docPrinc.DataDocumento >= docRef.DataDocumento

-- C113 - Nota Fiscal de Remessa de Veículos (busca remessa anterior do mesmo veículo, com EntradaSaida inversa)
INSERT rtSPEDFiscal
SELECT
@@spid,
'|C113|' + 
+	CASE WHEN docRef.EntradaSaidaDocumento = 'E' THEN
		'0'
	ELSE
		'1'
	END + '|'
+	CASE WHEN ( 
            ( dnfeDocRef.ChaveAcessoNFe IS NOT NULL OR docRef.CondicaoNFCancelada = 'V' OR docRef.EspecieDocumento = 'ECF' ) AND
            docRef.TipoLancamentoMovimentacao not in (1,9,10) AND
			( ( docRef.TipoLancamentoMovimentacao = 7 and ( dftDocRef.TipoTratamentoNFDigitadaDocFT <> 'N' OR docRef.CodigoEmpresa = 2490 )) OR ---Mavel Totvs 
              docRef.TipoLancamentoMovimentacao <> 7 )
          ) OR  --- Emissao Própria ?
		  ( docRef.TipoLancamentoMovimentacao = 10 AND docRef.EntradaSaidaDocumento = 'S' AND docRef.CodigoEmpresa = 2380 AND docRef.CodigoLocal = 3 ) OR
          ( docRef.CondicaoComplementoICMSDocto = 'V' and docRef.EntradaSaidaDocumento = 'S' ) OR
          ( docRef.TipoLancamentoMovimentacao = 7 AND cnoDocRef.CodigoTipoOperacao in (10,12) ) OR
          ( docRef.TipoLancamentoMovimentacao in (7,10) AND docRef.CondicaoNFCancelada = 'V' and dftDocRef.TipoTratamentoNFDigitadaDocFT <> 'N' ) THEN
		'0'
	ELSE
		'1'
	END + '|'
+	CASE 
	WHEN docRef.CondicaoNFCancelada = 'V' OR docRef.TipoLancamentoMovimentacao = 11 THEN
		''
	ELSE
		CONVERT(VARCHAR(14),COALESCE(dftDocRef.CodigoClienteEventual,docRef.CodigoCliFor))
	END  + '|'
+	RIGHT(CONVERT(VARCHAR(3),100 + docRef.CodigoModeloNotaFiscal),2) + '|'
+	right('000'+rtrim(ltrim(coalesce(docRef.SerieDocumento,''))),3) + '|'
+	'' + '|' -- SUB
+	CONVERT(VARCHAR(9),docRef.NumeroDocumento) + '|'
+	CASE 
	WHEN docRef.CondicaoNFCancelada = 'V' OR docRef.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,docRef.DataEmissaoDocumento)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,docRef.DataEmissaoDocumento)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,docRef.DataEmissaoDocumento)) + '|' 
	END
+	CASE WHEN CONVERT(NUMERIC(3),@Versao) >= 11 THEN
		COALESCE(dnfeDocRef.ChaveAcessoNFe,'')
	ELSE
		''
	END + '|',
'C113',
docPrinc.EntradaSaidaDocumento,
docPrinc.NumeroDocumento,
docPrinc.DataDocumento,
docPrinc.CodigoCliFor,
docPrinc.TipoLancamentoMovimentacao,
11,
'',
0,
'',
0
FROM tbDocumento docRef (NOLOCK)
INNER JOIN tbDocumentoFT dftDocRef (NOLOCK) ON
 		   dftDocRef.CodigoEmpresa		= docRef.CodigoEmpresa AND
           dftDocRef.CodigoLocal		= docRef.CodigoLocal AND
		   dftDocRef.EntradaSaidaDocumento	= docRef.EntradaSaidaDocumento AND
		   dftDocRef.NumeroDocumento		= docRef.NumeroDocumento AND
		   dftDocRef.CodigoCliFor		= docRef.CodigoCliFor AND
		   dftDocRef.TipoLancamentoMovimentacao = docRef.TipoLancamentoMovimentacao AND
		   dftDocRef.DataDocumento		= docRef.DataDocumento 
INNER JOIN tbItemDocumento iDocRef (NOLOCK) ON
		   iDocRef.CodigoEmpresa = docRef.CodigoEmpresa AND
		   iDocRef.CodigoLocal = docRef.CodigoLocal AND
		   iDocRef.EntradaSaidaDocumento = docRef.EntradaSaidaDocumento AND
		   iDocRef.NumeroDocumento = docRef.NumeroDocumento AND
		   iDocRef.DataDocumento = docRef.DataDocumento AND
		   iDocRef.CodigoCliFor = docRef.CodigoCliFor AND
		   iDocRef.TipoLancamentoMovimentacao = docRef.TipoLancamentoMovimentacao
INNER JOIN tbNaturezaOperacao cnoDocRef (NOLOCK) ON
		   cnoDocRef.CodigoEmpresa	= docRef.CodigoEmpresa AND
		   cnoDocRef.CodigoNaturezaOperacao = dftDocRef.CodigoNaturezaOperacao 
INNER JOIN tbDocumento docPrinc (NOLOCK) ON
		   docPrinc.CodigoEmpresa = docRef.CodigoEmpresa AND
		   docPrinc.CodigoLocal = docRef.CodigoLocal AND
		   docPrinc.CodigoCliFor = docRef.CodigoCliFor AND
		   docPrinc.DataDocumento >= docRef.DataDocumento AND
		   docPrinc.EntradaSaidaDocumento <> docRef.EntradaSaidaDocumento
INNER JOIN tbDocumentoFT dftDocPrinc (NOLOCK) ON
 		   dftDocPrinc.CodigoEmpresa		= docRef.CodigoEmpresa AND
           dftDocPrinc.CodigoLocal		= docRef.CodigoLocal AND
		   dftDocPrinc.EntradaSaidaDocumento	= docRef.EntradaSaidaDocumento AND
		   dftDocPrinc.NumeroDocumento		= docRef.NumeroDocumento AND
		   dftDocPrinc.CodigoCliFor		= docRef.CodigoCliFor AND
		   dftDocPrinc.TipoLancamentoMovimentacao = docRef.TipoLancamentoMovimentacao AND
		   dftDocPrinc.DataDocumento		= docRef.DataDocumento 
INNER JOIN tbItemDocumento iDocPrinc (NOLOCK) ON
		   iDocPrinc.CodigoEmpresa = docPrinc.CodigoEmpresa AND
		   iDocPrinc.CodigoLocal = docPrinc.CodigoLocal AND
		   iDocPrinc.EntradaSaidaDocumento = docPrinc.EntradaSaidaDocumento AND
		   iDocPrinc.NumeroDocumento = docPrinc.NumeroDocumento AND
		   iDocPrinc.DataDocumento = docPrinc.DataDocumento AND
		   iDocPrinc.CodigoCliFor = docPrinc.CodigoCliFor AND
		   iDocPrinc.TipoLancamentoMovimentacao = docPrinc.TipoLancamentoMovimentacao
INNER JOIN tbNaturezaOperacao cnoDocPrinc (NOLOCK) ON
		   cnoDocPrinc.CodigoEmpresa			= dftDocPrinc.CodigoEmpresa AND
		   cnoDocPrinc.CodigoNaturezaOperacao	= dftDocPrinc.CodigoNaturezaOperacao 
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal
INNER JOIN rtSPEDFiscal (NOLOCK) ON
           rtSPEDFiscal.Spid = @@spid AND
           rtSPEDFiscal.EntradaSaida = docPrinc.EntradaSaidaDocumento AND
           rtSPEDFiscal.DataDocumento = docPrinc.DataDocumento AND
           rtSPEDFiscal.CodigoCliFor = docPrinc.CodigoCliFor AND
           rtSPEDFiscal.NumeroDocumento = docPrinc.NumeroDocumento AND
           rtSPEDFiscal.TipoLancamentoMovimentacao = docPrinc.TipoLancamentoMovimentacao AND
		   rtSPEDFiscal.TipoRegistro = 'C110'
LEFT JOIN  tbDocumentoNFe dnfeDocRef (NOLOCK) ON
		   dnfeDocRef.CodigoEmpresa		= docRef.CodigoEmpresa AND
           dnfeDocRef.CodigoLocal		= docRef.CodigoLocal AND
		   dnfeDocRef.EntradaSaidaDocumento	= docRef.EntradaSaidaDocumento AND
		   dnfeDocRef.NumeroDocumento		= docRef.NumeroDocumento AND
		   dnfeDocRef.CodigoCliFor		= docRef.CodigoCliFor AND
		   dnfeDocRef.TipoLancamentoMovimentacao = docRef.TipoLancamentoMovimentacao AND
		   dnfeDocRef.DataDocumento		= docRef.DataDocumento 
WHERE 
	(
	(
		cnoDocRef.CodigoEmpresa = docRef.CodigoEmpresa AND 
		cnoDocRef.CodigoNaturezaOperacao = dftDocRef.CodigoNaturezaOperacao AND
		docRef.TipoLancamentoMovimentacao IN (1,7,9,11) AND
		cnoDocRef.AtualizaLFNaturezaOperacao='V'
	)			
	OR  docRef.TipoLancamentoMovimentacao IN (10,12)
	OR  ( docRef.TipoLancamentoMovimentacao = 1 AND dftDocRef.CodigoNaturezaOperacao IS NULL )
	)
	AND docRef.CodigoEmpresa		= @CodigoEmpresa 
	AND docRef.CodigoLocal		    = @CodigoLocal
	AND docPrinc.CodigoEmpresa		= @CodigoEmpresa 
	AND docPrinc.CodigoLocal		    = @CodigoLocal
	AND docPrinc.DataDocumento between @DataInicial AND @DataFinal
	AND docRef.TipoLancamentoMovimentacao <> 11
	AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
	(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((docRef.TipoLancamentoMovimentacao = 12 AND docRef.DataDocumento = docRef.DataEmissaoDocumento) OR (docRef.CondicaoNFCancelada = 'V' AND docRef.ValorContabilDocumento = 0 ))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((docRef.TipoLancamentoMovimentacao = 12 AND docRef.DataDocumento <> docRef.DataEmissaoDocumento) OR (docRef.TipoLancamentoMovimentacao = 11) OR (docRef.CondicaoNFCancelada = 'V' AND docRef.ValorContabilDocumento <> 0))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (docRef.TipoLancamentoMovimentacao = 12 OR docRef.TipoLancamentoMovimentacao = 11 OR docRef.CondicaoNFCancelada = 'V')) OR 
	(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (docRef.TipoLancamentoMovimentacao = 11))
	)
	AND docRef.CondicaoNFCancelada = 'F'
	AND ( 
			tbLocalLF.ImprimeServicoRegSaida = 'V' OR
			docRef.ValorBaseISSDocumento = 0
		)
	AND iDocRef.TipoRegistroItemDocto = 'VEC'
	AND iDocPrinc.TipoRegistroItemDocto = 'VEC'
	AND iDocRef.CodigoItemDocto = iDocPrinc.CodigoItemDocto
	AND dftDocPrinc.NotaFiscalOriginalDocFT IS NULL
	AND docRef.DataDocumento = (SELECT MAX(A.DataDocumento) FROM tbDocumento A
								WHERE	A.CodigoEmpresa = docPrinc.CodigoEmpresa AND
										A.CodigoLocal = docPrinc.CodigoLocal AND
										A.CodigoCliFor = docPrinc.CodigoCliFor AND
										A.EntradaSaidaDocumento <> docPrinc.EntradaSaidaDocumento AND
										A.DataDocumento <= docPrinc.DataDocumento
								)
	
---- C114
IF EXISTS ( SELECT 1 FROM tbDocumento 
            WHERE
            tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
            tbDocumento.CodigoLocal = @CodigoLocal AND
            tbDocumento.EspecieDocumento	= 'ECF' AND
            tbDocumento.EntradaSaidaDocumento = 'S' AND
            tbDocumento.DataDocumento between @DataInicial and @DataFinal )
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C114|' + 
	'2D|' +
	RTRIM(LTRIM(SerieECFDocFT)) + '|' +
	RTRIM(LTRIM(CONVERT(VARCHAR(8),CONVERT(NUMERIC(8),NumeroECFDocFT)))) + '|' +
	CONVERT(VARCHAR(9),tbDocumento.NumeroNFDocumento) + '|' +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDocumento.DataDocumento)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDocumento.DataDocumento)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbDocumento.DataDocumento)) + '|',
	'C114',
	tbDocumento.EntradaSaidaDocumento,
	tbDocumento.NumeroDocumento,
	tbDocumento.DataDocumento,
	tbDocumento.CodigoCliFor,
	tbDocumento.TipoLancamentoMovimentacao,
	11,
	'',
	0,
	'',
	0
	FROM tbDocumento (NOLOCK)
	INNER JOIN tbCliFor (NOLOCK) ON
			   tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
			   tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
	INNER JOIN tbLocalLF (NOLOCK) ON
			   tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
			   tbLocalLF.CodigoLocal = @CodigoLocal
	INNER JOIN tbLocalFT (NOLOCK) ON
			   tbLocalFT.CodigoEmpresa = @CodigoEmpresa AND
			   tbLocalFT.CodigoLocal = @CodigoLocal
	INNER JOIN tbDocumentoFT (NOLOCK) ON
			  tbDocumentoFT.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
			  tbDocumentoFT.CodigoLocal		= tbDocumento.CodigoLocal AND
			  tbDocumentoFT.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
			  tbDocumentoFT.NumeroDocumento		= tbDocumento.NumeroDocumento AND
			  tbDocumentoFT.CodigoCliFor		= tbDocumento.CodigoCliFor AND
			  tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
			  tbDocumentoFT.DataDocumento		= tbDocumento.DataDocumento 
	LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
			  tbNaturezaOperacao.CodigoEmpresa	= tbDocumento.CodigoEmpresa AND
			  tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao 
	INNER JOIN rtSPEDFiscal (NOLOCK) ON
			   rtSPEDFiscal.Spid = @@spid AND
			   rtSPEDFiscal.EntradaSaida = tbDocumento.EntradaSaidaDocumento AND
			   rtSPEDFiscal.DataDocumento = tbDocumento.DataDocumento AND
			   rtSPEDFiscal.CodigoCliFor = tbDocumento.CodigoCliFor AND
			   rtSPEDFiscal.NumeroDocumento = tbDocumento.NumeroDocumento AND
			   rtSPEDFiscal.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
			   rtSPEDFiscal.TipoRegistro = 'C100'
	WHERE 
		(
		(
			tbNaturezaOperacao.CodigoEmpresa = tbDocumento.CodigoEmpresa AND 
			tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao AND
			tbDocumento.TipoLancamentoMovimentacao IN (1,7,9,11) AND
			tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
		)			
		OR  tbDocumento.TipoLancamentoMovimentacao IN (10,12)
		OR  ( tbDocumento.TipoLancamentoMovimentacao = 1 AND tbDocumentoFT.CodigoNaturezaOperacao IS NULL )
		)
		AND tbDocumento.EspecieDocumento	= 'ECF'
		AND tbDocumento.CodigoEmpresa		= @CodigoEmpresa 
		AND tbDocumento.CodigoLocal		    = @CodigoLocal
		AND tbDocumento.DataDocumento 		between @DataInicial and @DataFinal  
		AND tbDocumento.TipoLancamentoMovimentacao <> 11
		AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
		(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento = tbDocumento.DataEmissaoDocumento) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento = 0 ))) OR
		(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento <> tbDocumento.DataEmissaoDocumento) OR (tbDocumento.TipoLancamentoMovimentacao = 11) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento <> 0))) OR
		(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 12 OR tbDocumento.TipoLancamentoMovimentacao = 11 OR tbDocumento.CondicaoNFCancelada = 'V')) OR 
		(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 11))
		)
		AND tbDocumento.EntradaSaidaDocumento = 'S'
		AND tbDocumento.CondicaoNFCancelada = 'F'
		AND ( 
				tbLocalLF.ImprimeServicoRegSaida = 'V' OR
				tbDocumento.ValorBaseISSDocumento = 0
			)
		AND EXISTS ( SELECT 1 FROM tbItemDocumento A
					 WHERE 
					 A.CodigoEmpresa = @CodigoEmpresa AND
					 A.CodigoLocal = @CodigoLocal AND
					 A.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
					 A.DataDocumento = tbDocumento.DataDocumento AND
					 A.CodigoCliFor = tbDocumento.CodigoCliFor AND
					 A.NumeroDocumento = tbDocumento.NumeroDocumento AND
					 A.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao )
		AND ISNUMERIC(NumeroECFDocFT) = 1
END

----

--- c120 importação

IF OBJECT_ID('tbItemEntradaXML') IS NOT NULL
BEGIN
	INSERT rtSPEDFiscal
	SELECT 
	@@spid,
	'|C120|' +
	'0|' +
	RTRIM(LTRIM(COALESCE(COALESCE(tbVeiculoCV.DeclaracaoImportacao,tbItemEntradaXML.nDI),tbItemDocumento.NumeroDocumento))) + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorPISItemDocto)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumentoFT.ValorCOFINSItDocFT)),'.',',') + '|' +
	'|',
	'C120',
	tbItemDocumento.EntradaSaidaDocumento,
	tbItemDocumento.NumeroDocumento,
	tbItemDocumento.DataDocumento,
	CASE 
		WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbItemDocumento.TipoLancamentoMovimentacao = 11 THEN
			0
		ELSE
			tbItemDocumento.CodigoCliFor
	END,
	tbItemDocumento.TipoLancamentoMovimentacao,
	11,
	'',
	0,
	'',
	0
	FROM tbItemDocumento (NOLOCK)

	INNER JOIN tbEmpresa (NOLOCK) ON 
			   tbEmpresa.CodigoEmpresa = @CodigoEmpresa

	INNER JOIN tbDocumento (NOLOCK) ON
	tbDocumento.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
	tbDocumento.CodigoLocal = tbItemDocumento.CodigoLocal and
	tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento and
	tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento and
	tbDocumento.DataDocumento = tbItemDocumento.DataDocumento and
	tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor and
	tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao

	LEFT JOIN tbDocumentoFT (NOLOCK) 
	ON	tbDocumentoFT.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
	AND	tbDocumentoFT.CodigoLocal = tbItemDocumento.CodigoLocal
	AND	tbDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento
	AND	tbDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento
	AND tbDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento
	AND tbDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor
	AND tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao

	INNER JOIN tbItemDocumentoFT (NOLOCK) 
	ON	tbItemDocumentoFT.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
	AND	tbItemDocumentoFT.CodigoLocal = tbItemDocumento.CodigoLocal
	AND	tbItemDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento
	AND	tbItemDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento
	AND tbItemDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento
	AND tbItemDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor
	AND tbItemDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	AND tbItemDocumentoFT.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento
		
	INNER JOIN tbNaturezaOperacao (NOLOCK) ON
		   tbNaturezaOperacao.CodigoEmpresa = @CodigoEmpresa AND
		   tbNaturezaOperacao.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao
	INNER JOIN tbCliFor (NOLOCK) ON
		   tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
		   tbCliFor.CodigoCliFor = tbItemDocumento.CodigoCliFor
	LEFT JOIN tbDocumentoNFe (NOLOCK) ON
		tbDocumentoNFe.CodigoEmpresa    = tbItemDocumento.CodigoEmpresa
		AND tbDocumentoNFe.CodigoLocal  = tbItemDocumento.CodigoLocal
		AND tbDocumentoNFe.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento
		AND tbDocumentoNFe.NumeroDocumento       = tbItemDocumento.NumeroDocumento
		AND tbDocumentoNFe.CodigoCliFor          = tbItemDocumento.CodigoCliFor	    
		AND tbDocumentoNFe.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao 
		AND tbDocumentoNFe.DataDocumento         = tbItemDocumento.DataDocumento 
	LEFT JOIN tbVeiculoCV (NOLOCK) ON
		tbVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
		tbVeiculoCV.CodigoLocal = tbItemDocumento.CodigoLocal AND
		tbVeiculoCV.NumeroVeiculoCV = tbItemDocumento.NumeroVeiculoCV
	LEFT JOIN tbItemEntradaXML (NOLOCK) ON
		tbItemEntradaXML.CodigoEmpresa = @CodigoEmpresa AND
		tbItemEntradaXML.CodigoLocal = tbItemDocumento.CodigoLocal AND 
		tbItemEntradaXML.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
		tbItemEntradaXML.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
		tbItemEntradaXML.Modelo = tbDocumento.CodigoModeloNotaFiscal AND
		tbItemEntradaXML.DataEmissao = tbDocumento.DataEmissaoDocumento AND
		tbItemEntradaXML.nItem = tbItemDocumento.SequenciaItemDocumento

		WHERE tbDocumento.CodigoModeloNotaFiscal IN (1,4,55) AND
		tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
			(( 	tbItemDocumento.TipoLancamentoMovimentacao = 1 AND
				tbNaturezaOperacao.CodigoTipoOperacao <> 13 AND
				tbNaturezaOperacao.CodigoTipoOperacao <> 9
	       		)	
				OR
			( 	tbItemDocumento.TipoLancamentoMovimentacao = 7  AND
				tbNaturezaOperacao.CodigoTipoOperacao = 7	AND 
				tbItemDocumento.EntradaSaidaDocumento = 'S'                        			
			)
			OR
			( 	tbItemDocumento.TipoLancamentoMovimentacao = 7  AND
				tbNaturezaOperacao.CodigoTipoOperacao = 7 AND 
				tbItemDocumento.EntradaSaidaDocumento = 'E'                        			
			))AND
				tbItemDocumento.DataDocumento between @DataInicial and @DataFinal AND
				 tbDocumento.CondicaoNFCancelada <> 'V' and
				tbDocumento.CodigoModeloNotaFiscal <> 8 and
				tbDocumento.CodigoModeloNotaFiscal <> 57
			AND
			( EXISTS ( SELECT 1 FROM tbItemDocumento A (NOLOCK)
					   WHERE A.CodigoEmpresa = @CodigoEmpresa 					    AND
					   A.CodigoLocal = tbDocumento.CodigoLocal 				    AND
					   A.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento	    AND
					   A.NumeroDocumento = tbDocumento.NumeroDocumento			    AND
					   A.DataDocumento = tbDocumento.DataDocumento			    AND
					   A.CodigoCliFor = tbDocumento.CodigoCliFor				    AND
	   				   A.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
					   A.ValorPISItemDocto <> 0 ) OR
			  ( tbDocumento.EntradaSaidaDocumento = 'E' AND tbNaturezaOperacao.CodigoTipoOperacao in (7,8) )
			 )
		AND tbDocumento.CodigoModeloNotaFiscal NOT IN (6,7,8,9,10,11,26,27,28,29,57)
		AND tbEmpresa.MarcaFabricanteEmpresa IN (10, 38, 41) -- Chrysler (10) e Foton (38,41)
		AND tbItemDocumento.CodigoCFO LIKE '3%'

	GROUP BY
	tbItemDocumento.EntradaSaidaDocumento,
	tbItemDocumento.CodigoLocal,
	tbItemDocumento.NumeroDocumento,
	tbItemDocumento.DataDocumento,
	CASE 
		WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbItemDocumento.TipoLancamentoMovimentacao = 11 THEN
			0
		ELSE
			tbItemDocumento.CodigoCliFor
	END,
	tbItemDocumento.TipoLancamentoMovimentacao,
	tbVeiculoCV.DeclaracaoImportacao,
	tbItemEntradaXML.nDI
END

---

INSERT rtSPEDFiscal
SELECT
@@spid,
'|C130|' + 
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),CASE WHEN tbDocumento.TipoLancamentoMovimentacao = 10 THEN tbDocumento.ValorBaseISSDocumento ELSE tbDocumentoFT.TotalServicosDocFT END),'.',',') + '|' 
END +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorBaseISSDocumento),'.',',') + '|' 
END +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorISSDocumento),'.',',') + '|' 
END +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),COALESCE(tbDocumentoFT.BaseIRRFDocFT,0)),'.',',') + '|' 
END +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),COALESCE(tbDocumentoFT.ValorIRRFDocFT,0)),'.',',') + '|' 
END +
'0,00' + '|' +
'0,00' + '|',
'C130',
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao,
11,
'',
0,
'',
0
FROM tbDocumento (NOLOCK)
INNER JOIN tbCliFor (NOLOCK) ON
           tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
           tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal
INNER JOIN tbLocalFT (NOLOCK) ON
           tbLocalFT.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalFT.CodigoLocal = @CodigoLocal
LEFT JOIN tbDocumentoFT (NOLOCK) ON
		  tbDocumentoFT.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoFT.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoFT.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoFT.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoFT.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoFT.DataDocumento		= tbDocumento.DataDocumento 
LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
		  tbNaturezaOperacao.CodigoEmpresa	= tbDocumento.CodigoEmpresa AND
		  tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao 
INNER JOIN rtSPEDFiscal (NOLOCK) ON
           rtSPEDFiscal.Spid = @@spid AND
           rtSPEDFiscal.EntradaSaida = tbDocumento.EntradaSaidaDocumento AND
           rtSPEDFiscal.DataDocumento = tbDocumento.DataDocumento AND
           rtSPEDFiscal.CodigoCliFor = tbDocumento.CodigoCliFor AND
           rtSPEDFiscal.NumeroDocumento = tbDocumento.NumeroDocumento AND
           rtSPEDFiscal.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		   rtSPEDFiscal.TipoRegistro = 'C100'
WHERE 
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = tbDocumento.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao AND
		tbDocumento.TipoLancamentoMovimentacao IN (1,7,9,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)			
	OR  tbDocumento.TipoLancamentoMovimentacao IN (10,12)
	OR  ( tbDocumento.TipoLancamentoMovimentacao = 1 AND tbDocumentoFT.CodigoNaturezaOperacao IS NULL )
	)
	AND tbDocumento.CodigoModeloNotaFiscal IN (1,4) 
	AND (	tbDocumento.EspecieDocumento <> 'ECF' OR						-- Cupons Fiscais somente vão no SPED
			tbDocumento.NumeroDocumento <> tbDocumento.NumeroNFDocumento )	-- se tiverem NF Conjugada (TKT 234897 / 2016)
	AND tbDocumento.CodigoEmpresa		= @CodigoEmpresa 
	AND tbDocumento.CodigoLocal		    = @CodigoLocal
	AND tbDocumento.DataDocumento 		between @DataInicial and @DataFinal  
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
	(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento = tbDocumento.DataEmissaoDocumento) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento = 0 ))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento <> tbDocumento.DataEmissaoDocumento) OR (tbDocumento.TipoLancamentoMovimentacao = 11) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento <> 0))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 12 OR tbDocumento.TipoLancamentoMovimentacao = 11 OR tbDocumento.CondicaoNFCancelada = 'V')) OR 
	(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 11))
	)
	AND tbDocumento.EntradaSaidaDocumento = 'S'
	AND tbDocumento.CondicaoNFCancelada = 'F'
	AND ( 
			tbLocalLF.ImprimeServicoRegSaida = 'V' OR
			tbDocumento.ValorBaseISSDocumento = 0
		)
	AND EXISTS ( SELECT 1 FROM tbItemDocumento A
                 WHERE 
                 A.CodigoEmpresa = @CodigoEmpresa AND
                 A.CodigoLocal = @CodigoLocal AND
                 A.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
                 A.DataDocumento = tbDocumento.DataDocumento AND
                 A.CodigoCliFor = tbDocumento.CodigoCliFor AND
                 A.NumeroDocumento = tbDocumento.NumeroDocumento AND
                 A.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao )

INSERT rtSPEDFiscal
SELECT
@@spid,
'|C140|' + 
CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' THEN
	'0|'
ELSE
	'1|'
END + 
'00|' +
'|' +
CONVERT(VARCHAR(9),tbDocumento.NumeroDocumento) + '|' +
CONVERT(VARCHAR(2),( SELECT COUNT(*) FROM tbDoctoRecPag 
  WHERE
  tbDoctoRecPag.CodigoEmpresa = @CodigoEmpresa AND
  tbDoctoRecPag.CodigoLocal = @CodigoLocal AND
  tbDoctoRecPag.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
  tbDoctoRecPag.DataDocumento = tbDocumento.DataDocumento AND
  tbDoctoRecPag.CodigoCliFor = tbDocumento.CodigoCliFor AND
  tbDoctoRecPag.NumeroDocumento = tbDocumento.NumeroDocumento AND
  tbDoctoRecPag.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao )) + '|' + 
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorContabilDocumento),'.',',') + '|',
'C140',
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao,
11,
'',
0,
'',
0
FROM tbDocumento (NOLOCK)
INNER JOIN tbCliFor (NOLOCK) ON
           tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
           tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal
INNER JOIN tbLocalFT (NOLOCK) ON
           tbLocalFT.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalFT.CodigoLocal = @CodigoLocal
LEFT JOIN tbDocumentoFT (NOLOCK) ON
		  tbDocumentoFT.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoFT.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoFT.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoFT.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoFT.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoFT.DataDocumento		= tbDocumento.DataDocumento 
LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
		  tbNaturezaOperacao.CodigoEmpresa	= tbDocumento.CodigoEmpresa AND
		  tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao 

WHERE 
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = tbDocumento.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao AND
		tbDocumento.TipoLancamentoMovimentacao IN (1,7,9,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)			
	OR  tbDocumento.TipoLancamentoMovimentacao IN (10,12)
	OR  ( tbDocumento.TipoLancamentoMovimentacao = 1 AND tbDocumentoFT.CodigoNaturezaOperacao IS NULL )
	)
	AND tbDocumento.CodigoModeloNotaFiscal = 1 
	AND (	tbDocumento.EspecieDocumento <> 'ECF' OR						-- Cupons Fiscais somente vão no SPED
			tbDocumento.NumeroDocumento <> tbDocumento.NumeroNFDocumento )	-- se tiverem NF Conjugada (TKT 234897 / 2016)
	AND tbDocumento.CodigoEmpresa		= @CodigoEmpresa 
	AND tbDocumento.CodigoLocal		    = @CodigoLocal
	AND tbDocumento.DataDocumento 		between @DataInicial and @DataFinal  
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
	(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento = tbDocumento.DataEmissaoDocumento) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento = 0 ))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento <> tbDocumento.DataEmissaoDocumento) OR (tbDocumento.TipoLancamentoMovimentacao = 11) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento <> 0))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 12 OR tbDocumento.TipoLancamentoMovimentacao = 11 OR tbDocumento.CondicaoNFCancelada = 'V')) OR 
	(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 11))
	)
	AND tbDocumento.ValorContabilDocumento > 0
	AND ( SELECT COUNT(*) FROM tbDoctoRecPag 
		  WHERE
		  tbDoctoRecPag.CodigoEmpresa = @CodigoEmpresa AND
		  tbDoctoRecPag.CodigoLocal = @CodigoLocal AND
		  tbDoctoRecPag.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
		  tbDoctoRecPag.DataDocumento = tbDocumento.DataDocumento AND
		  tbDoctoRecPag.CodigoCliFor = tbDocumento.CodigoCliFor AND
		  tbDoctoRecPag.NumeroDocumento = tbDocumento.NumeroDocumento AND
		  tbDoctoRecPag.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao ) > 0
	AND 'V' = CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' and 
	          	    tbDocumento.CondicaoNFCancelada = 'V' and 
               		    tbDocumento.TipoLancamentoMovimentacao <> 7 
			THEN 'F'
			ELSE 'V'
		  END
	AND tbDocumento.CondicaoNFCancelada = 'F' 
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND ( 
			tbLocalLF.ImprimeServicoRegSaida = 'V' OR
			tbDocumento.ValorBaseISSDocumento = 0
		)
	AND EXISTS ( SELECT 1 FROM tbItemDocumento A
                 WHERE 
                 A.CodigoEmpresa = @CodigoEmpresa AND
                 A.CodigoLocal = @CodigoLocal AND
                 A.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
                 A.DataDocumento = tbDocumento.DataDocumento AND
                 A.CodigoCliFor = tbDocumento.CodigoCliFor AND
                 A.NumeroDocumento = tbDocumento.NumeroDocumento AND
                 A.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao )
	AND (
			( tbDocumento.TipoLancamentoMovimentacao IN (9,10) AND tbDocumento.Recapagem <> 'V' ) OR 
            tbDocumento.TipoLancamentoMovimentacao NOT IN (9,10)
	    )

INSERT rtSPEDFiscal
SELECT
@@spid,
'|C141|' + 
CONVERT(VARCHAR(2),CASE WHEN SequenciaDoctoRecPag = 0 THEN 1 ELSE SequenciaDoctoRecPag END) + '|' + 
CASE WHEN tbDoctoRecPag.DataVenctoUtilDoctoRecPag >= tbDoctoRecPag.DataDocumento THEN 
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDoctoRecPag.DataVenctoUtilDoctoRecPag)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDoctoRecPag.DataVenctoUtilDoctoRecPag)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbDoctoRecPag.DataVenctoUtilDoctoRecPag)),'') 
ELSE
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDoctoRecPag.DataDocumento)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDoctoRecPag.DataDocumento)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbDoctoRecPag.DataDocumento)),'') 
END + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDoctoRecPag.ValorEmissaoDoctoRecPag),'.',',') + '|',
'C141',
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao,
11,
'',
0,
'',
0
FROM tbDocumento (NOLOCK)
INNER JOIN tbCliFor (NOLOCK) ON
           tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
           tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal
INNER JOIN tbLocalFT (NOLOCK) ON
           tbLocalFT.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalFT.CodigoLocal = @CodigoLocal
LEFT JOIN tbDocumentoFT (NOLOCK) ON
		  tbDocumentoFT.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoFT.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoFT.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoFT.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoFT.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoFT.DataDocumento		= tbDocumento.DataDocumento 
INNER JOIN tbDoctoRecPag (NOLOCK) ON
		  tbDoctoRecPag.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDoctoRecPag.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDoctoRecPag.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDoctoRecPag.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDoctoRecPag.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDoctoRecPag.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDoctoRecPag.DataDocumento		= tbDocumento.DataDocumento 
LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
		  tbNaturezaOperacao.CodigoEmpresa	= tbDocumento.CodigoEmpresa AND
		  tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao 

WHERE 
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = tbDocumento.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao AND
		tbDocumento.TipoLancamentoMovimentacao IN (1,7,9,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)			
	OR  tbDocumento.TipoLancamentoMovimentacao IN (10,12)
	OR  ( tbDocumento.TipoLancamentoMovimentacao = 1 AND tbDocumentoFT.CodigoNaturezaOperacao IS NULL )
	)
	AND tbDocumento.CodigoModeloNotaFiscal = 1
	AND (	tbDocumento.EspecieDocumento <> 'ECF' OR						-- Cupons Fiscais somente vão no SPED
			tbDocumento.NumeroDocumento <> tbDocumento.NumeroNFDocumento )	-- se tiverem NF Conjugada (TKT 234897 / 2016)
	AND tbDocumento.CodigoEmpresa		= @CodigoEmpresa 
	AND tbDocumento.CodigoLocal		    = @CodigoLocal
	AND tbDocumento.DataDocumento 		between @DataInicial and @DataFinal  
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
	(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento = tbDocumento.DataEmissaoDocumento) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento = 0 ))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento <> tbDocumento.DataEmissaoDocumento) OR (tbDocumento.TipoLancamentoMovimentacao = 11) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento <> 0))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 12 OR tbDocumento.TipoLancamentoMovimentacao = 11 OR tbDocumento.CondicaoNFCancelada = 'V')) OR 
	(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 11))
	)
	AND tbDocumento.ValorContabilDocumento > 0
	AND 'V' = CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' and 
	          	    tbDocumento.CondicaoNFCancelada = 'V' and 
               		    tbDocumento.TipoLancamentoMovimentacao <> 7 
			THEN 'F'
			ELSE 'V'
		  END
	AND tbDocumento.CondicaoNFCancelada = 'F' 
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND ( 
			tbLocalLF.ImprimeServicoRegSaida = 'V' OR
			tbDocumento.ValorBaseISSDocumento = 0
		)
	AND EXISTS ( SELECT 1 FROM tbItemDocumento A
                 WHERE 
                 A.CodigoEmpresa = @CodigoEmpresa AND
                 A.CodigoLocal = @CodigoLocal AND
                 A.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
                 A.DataDocumento = tbDocumento.DataDocumento AND
                 A.CodigoCliFor = tbDocumento.CodigoCliFor AND
                 A.NumeroDocumento = tbDocumento.NumeroDocumento AND
                 A.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao )
	AND (
			( tbDocumento.TipoLancamentoMovimentacao = 9 AND tbDocumento.Recapagem <> 'V' ) OR 
            tbDocumento.TipoLancamentoMovimentacao <> 9
	    )

INSERT rtSPEDFiscal
SELECT
@@spid,
	'|C170|'
+	CONVERT(VARCHAR(4),'XSEQ') + '|'   ---- alimentado no VB
+	RTRIM(LTRIM(CONVERT(VARCHAR(30),
	CASE 	
	WHEN tbItemDocumento.CodigoProduto is not null THEN
		tbItemDocumento.CodigoProduto
	WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
		tbItemDocumento.CodigoMaoObraOS
	WHEN tbVeiculoCV.NumeroChassisCV is not null THEN
		CASE WHEN dbo.fnIndustria(@CodigoEmpresa) = 0 THEN
			tbVeiculoCV.NumeroChassisCV
		ELSE
			tbVeiculoCV.ModeloVeiculo
		END
	WHEN tbItemDocumento.CodigoItemDocto is not null AND RTRIM(LTRIM(tbItemDocumento.CodigoItemDocto)) <> '' THEN
		tbItemDocumento.CodigoItemDocto
	ELSE
		CASE WHEN tbItemDocumento.TipoLancamentoMovimentacao = 10 THEN
			'OUTRAS'
		ELSE
			'USOCONSUMO'
		END
	END))) + '|'
+	'' + '|'
+	CASE WHEN tbItemDocumento.TipoLancamentoMovimentacao = 9 OR tbItemDocumento.QtdeLancamentoItemDocto = 0 THEN
		'1,000' + '|' 
	ELSE
		REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),tbItemDocumento.QtdeLancamentoItemDocto)),'.',',') + '|'
	END
+	RTRIM(LTRIM(CASE 	
		WHEN tbItemDocumento.CodigoProduto is not null THEN
			COALESCE(tbProdutoFT.CodigoUnidadeProduto,'UN')
		WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
			'HR'
		WHEN tbVeiculoCV.NumeroChassisCV is not null THEN
			'UN'
		WHEN tbItemDocumento.CodigoItemDocto is not null THEN
			'UN'
		ELSE
			'UN'
	END)) + '|'
+	CASE WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00'
    ELSE
		CASE WHEN tbDocumento.TipoLancamentoMovimentacao = 9 or tbDocumento.TipoLancamentoMovimentacao = 10 THEN
			REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorContabilItemDocto - COALESCE(tbItemDocumento.ValorFreteItemDocto,0) ),'.',',')
		ELSE
			REPLACE(CONVERT(VARCHAR(16),
				
				tbItemDocumento.ValorProdutoItemDocto +

				-- ICMS-ST sem direito a crédito
				CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' THEN
					case when tbDocumento.CodigoEmpresa in (6050) then -- Querência (TKT 254103)
						0
					else
						CASE WHEN NOT tbEmpresa.EquiparadoIndustria = 'V' OR tbEmpresa.CodigoEmpresa IN (710,730,920,1918) THEN -- TICKET 201296
							tbItemDocumento.ValorICMSRetidoItemDocto
						ELSE
							0
						END
					end
				ELSE
					0
				END +

				-- IPI sem direito a crédito
				CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' THEN
					CASE WHEN NOT (tbEmpresa.EquiparadoIndustria = 'V' OR tbLocalLF.CondicaoContribuinteIPI = 'V') OR tbDocumento.ValorBaseIPI1Documento = 0 THEN
						tbItemDocumento.ValorIPIItemDocto
					ELSE
						0
					END
				ELSE
					0
				END
			
			),'.',',')
		END
	END  + '|' -- [07] VL_ITEM
+	REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorDescontoItemDocto),'.',',') + '|'
+	'0' + '|'
+	RIGHT('' + RTRIM(LTRIM(COALESCE(tbItemDocumentoFT.CodigoTributacaoItDocFT,CNOItem.CodigoTributacaoNaturezaOper,tbModeloVeiculoCV.CodigoTributacaoVeiculo,''))),3) + '|'
+	CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
		CONVERT(VARCHAR(4),tbLocalLF.CodigoCFOECF)
	ELSE
		CONVERT(VARCHAR(4),tbItemDocumento.CodigoCFO)
	END + '|'
+	COALESCE(CONVERT(VARCHAR(6),tbItemDocumento.CodigoNaturezaOperacao),'') + '|'
+	CASE WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		CASE WHEN 'ZZ' = 'PE' AND --- desativado
                  tbItemDocumento.EntradaSaidaDocumento = 'S' AND 
                  tbCliFor.UFCliFor <> tbLocal.UFLocal THEN
			'0,00|'
		ELSE
			REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorBaseICMS1ItemDocto),'.',',') + '|' 
		END
	END
+	CASE WHEN ( tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' ) OR tbItemDocumento.ValorBaseICMS1ItemDocto = 0 THEN
		'0,00' + '|'
    ELSE
		CASE WHEN 'ZZ' = 'PE' AND --- desativado
                  tbItemDocumento.EntradaSaidaDocumento = 'S' AND 
                  tbCliFor.UFCliFor <> tbLocal.UFLocal THEN
			'0,00|'
		ELSE
			REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.PercentualICMSItemDocto),'.',',') + '|' 
		END 
	END
+	CASE WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		CASE WHEN tbItemDocumento.EntradaSaidaDocumento = 'S' AND tbCliFor.UFCliFor <> tbLocal.UFLocal THEN
			'0,00|'
		ELSE
			REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorICMSItemDocto),'.',',') + '|' 
		END
	END
+	CASE WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		''
	ELSE
		CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
			'0,00'
		ELSE
			CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' THEN
				REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.BaseICMSSubstTribItemDocto),'.',',')
			ELSE
				CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' AND tbEmpresa.EquiparadoIndustria = 'V' THEN
					CASE WHEN tbEmpresa.CodigoEmpresa NOT IN (710,730,920,1918) THEN -- TICKET 201296
						REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.BaseICMSSubstTribItemDocto),'.',',')
					ELSE
						'0,00'
					END
				ELSE
					case when tbDocumento.CodigoEmpresa in (6050) and tbItemDocumento.ValorICMSRetidoItemDocto <> 0 THEN -- Querência (TKT 254103)
						REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.BaseICMSSubstTribItemDocto),'.',',')
					else
						'0,00'
					end
				END
			END
		END			
	END + '|' -- [16] VL_BC_ICMS_ST
+	CASE WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		''
	ELSE
		CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
			'0,00'
		ELSE
			CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' THEN
				CASE WHEN tbItemDocumento.BaseICMSSubstTribItemDocto <> 0 THEN
					REPLACE(CONVERT(VARCHAR(16),COALESCE(PercDestino.ICMSSaidaUF,0)),'.',',')
				ELSE
					''
				END
			ELSE
				CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' AND tbEmpresa.EquiparadoIndustria = 'V' THEN
					CASE WHEN tbEmpresa.CodigoEmpresa NOT IN (710,730,920,1918) THEN -- TICKET 201296
						REPLACE(CONVERT(VARCHAR(16),COALESCE(PercDestino.ICMSEntradaUF,0)),'.',',')
					ELSE
						'0,00'
					END
				ELSE
					CASE WHEN tbDocumento.CodigoEmpresa in (6050) and tbItemDocumento.ValorICMSRetidoItemDocto <> 0 THEN -- Querência (TKT 254103)
						REPLACE(CONVERT(VARCHAR(16),COALESCE(PercDestino.ICMSEntradaUF,0)),'.',',')
					ELSE
						'0,00'
					END
				END
			END
		END
	END + '|' -- [17] ALIQ_ST
+	CASE WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		''
	ELSE
		CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
			'0,00'
		ELSE
			CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' THEN
				REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorICMSSubstTribItemDocto),'.',',')
			ELSE
				CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' AND tbEmpresa.EquiparadoIndustria = 'V' THEN
					CASE WHEN tbEmpresa.CodigoEmpresa NOT IN (710,730,920,1918) THEN -- TICKET 201296
						REPLACE(CONVERT(VARCHAR(16),COALESCE(tbItemDocumento.ValorICMSRetidoItemDocto,0)),'.',',')
					ELSE
						'0,00'
					END
				ELSE
					CASE WHEN tbDocumento.CodigoEmpresa in (6050) and tbItemDocumento.ValorICMSRetidoItemDocto <> 0 THEN -- Querência (TKT 254103)
						REPLACE(CONVERT(VARCHAR(16),COALESCE(tbItemDocumento.ValorICMSRetidoItemDocto,0)),'.',',')
					ELSE
						'0,00'
					END
				END
			END
		END			
	END + '|' -- [18] VL_ICMS_ST
+	'0' + '|'
+	'' + '|'
+	'' + '|'
+	REPLACE(CONVERT(VARCHAR(16),
		CASE WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
			0
		ELSE
			CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' OR tbEmpresa.EquiparadoIndustria = 'V' OR tbLocalLF.CondicaoContribuinteIPI = 'V' THEN
				tbItemDocumento.ValorBaseIPI1ItemDocto
			ELSE
				0
			END
		END),'.',',') + '|' -- [22] VL_BC_IPI
+	CASE WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00'
    ELSE
		CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' OR tbEmpresa.EquiparadoIndustria = 'V' OR tbLocalLF.CondicaoContribuinteIPI = 'V' THEN
			CASE WHEN tbItemDocumento.ValorBaseIPI1ItemDocto <> 0 THEN
				REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.PercentualIPIItemDocto),'.',',')
			ELSE
				'0,00'
			END
		ELSE
			'0,00'
		END
	END + '|' -- [23] ALIQ_IPI
+	CASE WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00'
    ELSE
		CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' OR tbEmpresa.EquiparadoIndustria = 'V' OR tbLocalLF.CondicaoContribuinteIPI = 'V' THEN
			CASE WHEN tbItemDocumento.ValorBaseIPI1ItemDocto <> 0 THEN
				REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorIPIItemDocto),'.',',')
			ELSE
				'0,00'
			END
		ELSE
			'0,00'
		END
	END + '|' -- [24] VL_IPI
+	RTRIM(LTRIM(COALESCE(tbItemDocumentoFT.CSTPIS,''))) + '|' -- [25] CST_PIS
+	CASE WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorBasePISItemDocto),'.',',') + '|'
	END
+	CASE WHEN (tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V') or coalesce(tbItemDocumento.ValorBasePISItemDocto,0) = 0 THEN
		'0,00'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.PercPISItemDocto),'.',',')
	END + '|'
+	'' + '|'
+	'' + '|'
+	CASE WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorPISItemDocto),'.',',') + '|' 
	END
+	RTRIM(LTRIM(COALESCE(tbItemDocumentoFT.CSTCOFINS,''))) + '|' -- [31] CST_COFINS
+	CASE WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		COALESCE(REPLACE(CONVERT(VARCHAR(16),tbItemDocumentoFT.BaseCOFINSItDocFT),'.',','),'0,00') + '|' 
	END
+	CASE WHEN (tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V') or coalesce(tbItemDocumentoFT.BaseCOFINSItDocFT,0) = 0 THEN
		'0,00'
    ELSE
		COALESCE(REPLACE(CONVERT(VARCHAR(16),tbItemDocumentoFT.PercCofinsItDocFT),'.',','),'0,00')
	END + '|'
+	'' + '|'
+	'' + '|'
+	CASE WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		COALESCE(REPLACE(CONVERT(VARCHAR(16),tbItemDocumentoFT.ValorCOFINSItDocFT),'.',','),'0,00') + '|'
	END
+	CASE WHEN tbItemDocumento.EntradaSaidaDocumento = 'E' THEN @ContaEntrada ELSE @ContaSaida END + '|',
'C170',
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao,
11,
CASE 	
	WHEN tbItemDocumento.CodigoProduto is not null THEN
		tbItemDocumento.CodigoProduto
	WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
		tbItemDocumento.CodigoMaoObraOS
	WHEN tbVeiculoCV.NumeroChassisCV is not null THEN
		tbVeiculoCV.NumeroChassisCV
	WHEN tbItemDocumento.CodigoItemDocto is not null AND RTRIM(LTRIM(tbItemDocumento.CodigoItemDocto)) <> '' THEN
		tbItemDocumento.CodigoItemDocto
	ELSE
		CASE WHEN tbItemDocumento.TipoLancamentoMovimentacao = 10 THEN
			'OUTRAS'
		ELSE
			'USOCONSUMO'
		END
END,
tbItemDocumento.CodigoNaturezaOperacao,
CASE 	
	WHEN tbItemDocumento.CodigoProduto is not null THEN
		tbProdutoFT.CodigoUnidadeProduto
	WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
		'HR'
	WHEN tbVeiculoCV.NumeroChassisCV is not null THEN
		'UN'
	WHEN tbItemDocumento.CodigoItemDocto is not null THEN
		'UN'
	ELSE
		'UN'
END ,
tbItemDocumento.SequenciaItemDocumento
FROM tbItemDocumento (NOLOCK)
INNER JOIN tbEmpresa (NOLOCK) ON
           tbEmpresa.CodigoEmpresa = @CodigoEmpresa
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
INNER JOIN tbCliFor (NOLOCK) ON
           tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
           tbCliFor.CodigoCliFor = tbItemDocumento.CodigoCliFor 			
INNER JOIN tbPercentual (NOLOCK) ON
          tbPercentual.UFOrigem =  tbLocal.UFLocal AND
          tbPercentual.UFDestino = tbCliFor.UFCliFor
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal 
INNER JOIN tbDocumento (NOLOCK) ON
           tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumento.CodigoLocal = @CodigoLocal AND
           tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
           tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND
           tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
LEFT JOIN tbDocumentoFT (NOLOCK) ON
           tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumentoFT.CodigoLocal = @CodigoLocal AND
           tbDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
           tbDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
           tbDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
          tbNaturezaOperacao.CodigoEmpresa = @CodigoEmpresa AND
          tbNaturezaOperacao.CodigoNaturezaOperacao = COALESCE(tbDocumentoFT.CodigoNaturezaOperacao,tbItemDocumento.CodigoNaturezaOperacao)
INNER JOIN rtSPEDFiscal (NOLOCK) ON
           rtSPEDFiscal.Spid = @@spid AND
           rtSPEDFiscal.EntradaSaida = tbItemDocumento.EntradaSaidaDocumento AND
           rtSPEDFiscal.DataDocumento = tbItemDocumento.DataDocumento AND
           rtSPEDFiscal.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           rtSPEDFiscal.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           rtSPEDFiscal.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
LEFT JOIN tbItemDocumentoFT (NOLOCK) ON
           tbItemDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
           tbItemDocumentoFT.CodigoLocal = @CodigoLocal AND
           tbItemDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
           tbItemDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
           tbItemDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbItemDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbItemDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND
           tbItemDocumentoFT.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento
LEFT JOIN tbProdutoFT (NOLOCK) ON
          tbProdutoFT.CodigoEmpresa = @CodigoEmpresa AND
          tbProdutoFT.CodigoProduto = tbItemDocumento.CodigoProduto
LEFT JOIN tbVeiculoCV (NOLOCK) ON
          tbVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
          tbVeiculoCV.CodigoLocal = @CodigoLocal AND
          tbVeiculoCV.NumeroVeiculoCV = tbItemDocumento.NumeroVeiculoCV
LEFT JOIN tbModeloVeiculoCV (NOLOCK) ON
          tbModeloVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
          tbModeloVeiculoCV.ModeloVeiculo = tbVeiculoCV.ModeloVeiculo
LEFT JOIN tbDocumentoNFe (NOLOCK) ON
		  tbDocumentoNFe.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoNFe.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoNFe.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoNFe.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoNFe.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoNFe.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoNFe.DataDocumento		= tbDocumento.DataDocumento 
LEFT JOIN tbNaturezaOperacao CNOItem (NOLOCK) ON
          CNOItem.CodigoEmpresa = @CodigoEmpresa AND
          CNOItem.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao
LEFT JOIN tbPercentual PercDestino (NOLOCK) ON
          PercDestino.UFOrigem =  tbCliFor.UFCliFor AND
          PercDestino.UFDestino = tbCliFor.UFCliFor
LEFT JOIN tbSPEDFiscalC176 (NOLOCK) ON
		  tbSPEDFiscalC176.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND
		  tbSPEDFiscalC176.CodigoLocal = tbItemDocumento.CodigoLocal AND
		  tbSPEDFiscalC176.EntSaiDoctoSaida = tbItemDocumento.EntradaSaidaDocumento AND
		  tbSPEDFiscalC176.NumeroDoctoSaida = tbItemDocumento.NumeroDocumento AND
		  tbSPEDFiscalC176.DataDoctoSaida = tbItemDocumento.DataDocumento AND
		  tbSPEDFiscalC176.CodigoCliForDoctoSaida = tbItemDocumento.CodigoCliFor AND
		  tbSPEDFiscalC176.TipoLanctoDoctoSaida = tbItemDocumento.TipoLancamentoMovimentacao AND
		  tbSPEDFiscalC176.SequenciaItemDoctoSaida = tbItemDocumento.SequenciaItemDocumento
WHERE
tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbItemDocumento.CodigoLocal = @CodigoLocal AND
tbItemDocumento.DataDocumento between @DataInicial AND @DataFinal AND
rtSPEDFiscal.TipoRegistro = 'C100' AND
tbDocumento.CondicaoComplementoICMSDocto = 'F' AND
tbDocumento.CondicaoNFCancelada = 'F' AND
tbDocumento.TipoLancamentoMovimentacao <> 11 AND
tbDocumento.CodigoModeloNotaFiscal <> 65 AND
( 
  tbDocumento.CodigoModeloNotaFiscal <> 55 OR 
  tbSPEDFiscalC176.SequenciaItemDoctoSaida IS NOT NULL OR
  ( tbDocumentoNFe.ChaveAcessoNFe IS NULL OR 
    tbDocumentoNFe.NumeroProtocolo IS NULL OR
    tbDocumentoNFe.NumeroProtocolo = 0 )
) AND
NOT ( tbDocumento.TipoLancamentoMovimentacao = 10 AND tbDocumento.EntradaSaidaDocumento = 'S' AND tbDocumento.CodigoEmpresa = 2380 AND tbDocumento.CodigoLocal = 3 AND tbDocumento.ValorISSDocumento = 0 ) -- alvorada

ORDER BY
tbItemDocumento.EntradaSaidaDocumento,
tbItemDocumento.NumeroDocumento,
tbItemDocumento.DataDocumento,
tbItemDocumento.CodigoCliFor,
tbItemDocumento.TipoLancamentoMovimentacao,
tbItemDocumento.SequenciaItemDocumento


---- C175: OPERAÇÕES COM VEÍCULOS NOVOS (CÓDIGO 01 e 55) - TKT 247864
INSERT rtSPEDFiscal
SELECT
@@spid,
	'|C175|' -- [01] REG
+	CASE WHEN tbNaturezaOperacao.CodigoTipoOperacao = 4 THEN
		'3' -- Venda da concessionária
	ELSE
		'9' -- Outros
	END + '|' -- [02] IND_VEIC_OPER
+	tbLocal.CGCLocal + '|' -- [03] CNPJ
+	tbLocal.UFLocal + '|' -- [04] UF
+	tbVeiculoCV.NumeroChassisCV + '|', -- [05] CHASSI_VEIC
'C175',
tbItemDocumento.EntradaSaidaDocumento,
tbItemDocumento.NumeroDocumento,
tbItemDocumento.DataDocumento,
tbItemDocumento.CodigoCliFor,
tbItemDocumento.TipoLancamentoMovimentacao,
11,
tbVeiculoCV.NumeroChassisCV,
tbItemDocumento.CodigoNaturezaOperacao,
'UN',
tbItemDocumento.SequenciaItemDocumento
FROM tbItemDocumento (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND
           tbLocal.CodigoLocal = tbItemDocumento.CodigoLocal 
INNER JOIN tbNaturezaOperacao (NOLOCK) ON
          tbNaturezaOperacao.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND
          tbNaturezaOperacao.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao
INNER JOIN rtSPEDFiscal (NOLOCK) ON
           rtSPEDFiscal.Spid = @@spid AND
           rtSPEDFiscal.EntradaSaida = tbItemDocumento.EntradaSaidaDocumento AND
           rtSPEDFiscal.DataDocumento = tbItemDocumento.DataDocumento AND
           rtSPEDFiscal.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           rtSPEDFiscal.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           rtSPEDFiscal.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
INNER JOIN tbVeiculoCV (NOLOCK) ON
          tbVeiculoCV.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND
          tbVeiculoCV.CodigoLocal = tbItemDocumento.CodigoLocal AND
          tbVeiculoCV.NumeroVeiculoCV = tbItemDocumento.NumeroVeiculoCV
WHERE
tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbItemDocumento.CodigoLocal = @CodigoLocal AND
tbItemDocumento.EntradaSaidaDocumento = 'E' AND		-- Documentos de entrada
tbVeiculoCV.VeiculoNovoCV = 'V' AND					-- de veículos novos
rtSPEDFiscal.TipoRegistro = 'C170'					-- que gerarem o registro C170
ORDER BY
tbItemDocumento.EntradaSaidaDocumento,
tbItemDocumento.NumeroDocumento,
tbItemDocumento.DataDocumento,
tbItemDocumento.CodigoCliFor,
tbItemDocumento.TipoLancamentoMovimentacao,
tbItemDocumento.SequenciaItemDocumento



---- C176: RESSARCIMENTO DE ICMS EM OPERAÇÕES COM SUBSTITUIÇÃO TRIBUTÁRIA
INSERT rtSPEDFiscal
SELECT
@@spid,
	'|C176|' -- [01] REG
+	RIGHT(CONVERT(VARCHAR(3),100 + tbDocumento.CodigoModeloNotaFiscal),2) + '|' -- [02] COD_MOD_ULT_E
+	CONVERT(VARCHAR(9),tbDocumento.NumeroDocumento) + '|' -- [03] NUM_DOC_ULT_E
+	right('000'+rtrim(ltrim(coalesce(tbDocumento.SerieDocumento,''))),3) + '|' -- [04] SER_ULT_E
+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDocumento.DataDocumento)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDocumento.DataDocumento)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbDocumento.DataDocumento)) + '|' -- [05] DT_ULT_E
+	CONVERT(VARCHAR(14),tbDocumento.CodigoCliFor) + '|' -- [06] COD_PART_ULT_E
+	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),coalesce(tbSPEDFiscalC176.QtdeUltEntrada,0))),'.',',') + '|' -- [07] QUANT_ULT_E
+	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),coalesce(tbSPEDFiscalC176.ValorUnitarioUltEntrada,0))),'.',',') + '|' -- [08] VL_UNIT_ULT_E
+	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),coalesce(tbSPEDFiscalC176.ValorUnitBCICMSSTUltEntrada,0))),'.',',') + '|' -- [09] VL_UNIT_BC_ST
+	RTRIM(LTRIM(COALESCE(tbDocumentoNFe.ChaveAcessoNFe,''))) + '|' -- [10] CHAVE_NFE_ULT_E
+	CONVERT(VARCHAR(6),RTRIM(LTRIM(coalesce(tbSPEDFiscalC176.SequenciaItemDoctoEntrada,0)))) + '|' -- [11] NUM_ITEM_ULT_E
+	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),coalesce(tbSPEDFiscalC176.ValorUnitBCICMSOPUltEntrada,0))),'.',',') + '|' -- [12] VL_UNIT_BC_ICMS_ULT_E
+	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),coalesce(tbSPEDFiscalC176.AliqICMSUltEntrada,0))),'.',',') + '|' -- [13] ALIQ_ICMS_ULT_E
+	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),	case when coalesce(tbSPEDFiscalC176.ValorUnitBCICMSOPUltEntrada,0) < coalesce(tbSPEDFiscalC176.ValorUnitBCICMSSTUltEntrada,0) then
															coalesce(tbSPEDFiscalC176.ValorUnitBCICMSOPUltEntrada,0)
														else
															coalesce(tbSPEDFiscalC176.ValorUnitBCICMSSTUltEntrada,0)
														end)),'.',',') + '|' -- [14] VL_UNIT_LIMITE_BC_ICMS_ULT_E
+	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),coalesce(tbSPEDFiscalC176.AliqICMSUltEntrada * (
														case when tbSPEDFiscalC176.ValorUnitBCICMSOPUltEntrada < tbSPEDFiscalC176.ValorUnitBCICMSSTUltEntrada then
															tbSPEDFiscalC176.ValorUnitBCICMSOPUltEntrada
														else
															tbSPEDFiscalC176.ValorUnitBCICMSSTUltEntrada
														end),0))),'.',',') + '|' -- [15] VL_UNIT_ICMS_ULT_E
+	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),coalesce(tbSPEDFiscalC176.AliqICMSSTUltEntrada,0))),'.',',') + '|' -- [16] ALIQ_ST_ULT_E
+	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),coalesce(tbSPEDFiscalC176.ValorUnitBCICMSSTUltEntrada * tbSPEDFiscalC176.AliqICMSSTUltEntrada,0))),'.',',') + '|' -- [17] VL_UNIT_RES
+	COALESCE(tbSPEDFiscalC176.CodResponsavelRetencao,'') + '|' -- [18] COD_RESP_RET
+	COALESCE(tbSPEDFiscalC176.CodMotivoRessarcimento,'') + '|' -- [19] COD_MOT_RES
+	COALESCE(tbSPEDFiscalC176.ChaveAcessoDoctoRet,'') + '|' -- [20] CHAVE_NFE_RET
+	COALESCE(convert(varchar(14),tbSPEDFiscalC176.CodigoCliForDoctoRet),'') + '|' -- [21] COD_PART_NFE_RET
+	right('000'+rtrim(ltrim(coalesce(tbSPEDFiscalC176.SerieDoctoRet,''))),3) + '|' -- [22] SER_NFE_RET
+	COALESCE(convert(varchar(9),tbSPEDFiscalC176.NumeroDoctoRet),'') + '|' -- [23] NUM_NFE_RET
+	COALESCE(convert(varchar(3),tbSPEDFiscalC176.SequenciaItemDoctoRet),'') + '|' -- [24] ITEM_NFE_RET
+	COALESCE(convert(varchar(2),tbSPEDFiscalC176.CodModeloDoctoArrecadacao),'') + '|' -- [25] COD_DA
+	COALESCE(tbSPEDFiscalC176.NumeroDoctoArrecadacao,'') + '|' -- [26] NUM_DA
,	'C176'
,	tbSPEDFiscalC176.EntSaiDoctoSaida
,	tbSPEDFiscalC176.NumeroDoctoSaida
,	tbSPEDFiscalC176.DataDoctoSaida
,	tbSPEDFiscalC176.CodigoCliForDoctoSaida
,	tbSPEDFiscalC176.TipoLanctoDoctoSaida
,	11
,	''
,	0
,	''
,	tbSPEDFiscalC176.SequenciaItemDoctoSaida
FROM tbSPEDFiscalC176 (NOLOCK)
INNER JOIN tbDocumento (NOLOCK) ON
           tbDocumento.CodigoEmpresa = tbSPEDFiscalC176.CodigoEmpresa AND
           tbDocumento.CodigoLocal = tbSPEDFiscalC176.CodigoLocal AND
           tbDocumento.EntradaSaidaDocumento = tbSPEDFiscalC176.EntSaiDoctoEntrada AND
           tbDocumento.NumeroDocumento = tbSPEDFiscalC176.NumeroDoctoEntrada AND
           tbDocumento.DataDocumento = tbSPEDFiscalC176.DataDoctoEntrada AND
           tbDocumento.CodigoCliFor = tbSPEDFiscalC176.CodigoCliForDoctoEntrada AND
           tbDocumento.TipoLancamentoMovimentacao = tbSPEDFiscalC176.TipoLanctoDoctoEntrada
INNER JOIN tbItemDocumento (NOLOCK) ON
           tbItemDocumento.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
           tbItemDocumento.CodigoLocal = tbDocumento.CodigoLocal AND
           tbItemDocumento.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
           tbItemDocumento.NumeroDocumento = tbDocumento.NumeroDocumento AND
           tbItemDocumento.DataDocumento = tbDocumento.DataDocumento AND
           tbItemDocumento.CodigoCliFor = tbDocumento.CodigoCliFor AND
           tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
           tbItemDocumento.SequenciaItemDocumento = tbSPEDFiscalC176.SequenciaItemDoctoEntrada
left join  tbDocumentoNFe (nolock) on
           tbDocumentoNFe.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
           tbDocumentoNFe.CodigoLocal = tbDocumento.CodigoLocal AND
           tbDocumentoNFe.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
           tbDocumentoNFe.NumeroDocumento = tbDocumento.NumeroDocumento AND
           tbDocumentoNFe.DataDocumento = tbDocumento.DataDocumento AND
           tbDocumentoNFe.CodigoCliFor = tbDocumento.CodigoCliFor AND
           tbDocumentoNFe.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao
INNER JOIN rtSPEDFiscal (NOLOCK) ON
           rtSPEDFiscal.Spid = @@spid AND
           rtSPEDFiscal.EntradaSaida = tbSPEDFiscalC176.EntSaiDoctoSaida AND
           rtSPEDFiscal.DataDocumento = tbSPEDFiscalC176.DataDoctoSaida AND
           rtSPEDFiscal.CodigoCliFor = tbSPEDFiscalC176.CodigoCliForDoctoSaida AND
           rtSPEDFiscal.NumeroDocumento = tbSPEDFiscalC176.NumeroDoctoSaida AND
           rtSPEDFiscal.TipoLancamentoMovimentacao = tbSPEDFiscalC176.TipoLanctoDoctoSaida
WHERE 
           rtSPEDFiscal.TipoRegistro = 'C100' AND
           tbDocumento.CondicaoComplementoICMSDocto = 'F' AND
           tbDocumento.CondicaoNFCancelada = 'F'



---- Temporaria para o C190

SELECT
RIGHT(RTRIM(LTRIM(COALESCE(tbItemDocumentoFT.CodigoTributacaoItDocFT,CNOItem.CodigoTributacaoNaturezaOper,tbModeloVeiculoCV.CodigoTributacaoVeiculo,tbNaturezaOperacao.CodigoTributacaoNaturezaOper,''))),3) AS CodigoTributacao,
CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
	CONVERT(VARCHAR(4),tbLocalLF.CodigoCFOECF)
ELSE
	tbItemDocumento.CodigoCFO
END AS CodigoCFO,
CASE WHEN tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND tbDocumento.EspecieDocumento <> 'ECF' THEN
	tbItemDocumento.PercentualICMSItemDocto
ELSE
	0
END AS PercentualICMSItemDocto,
CASE WHEN tbDocumento.EspecieDocumento = 'ECF' AND tbLocal.UFLocal <> 'RN' THEN
	0
ELSE
	tbItemDocumento.ValorContabilItemDocto
END AS ValorContabilItemDocto,
CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
	0
ELSE
	tbItemDocumento.ValorBaseICMS1ItemDocto
END AS ValorBaseICMS1ItemDocto,	
CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
	0
ELSE
	tbItemDocumento.ValorICMSItemDocto
END AS ValorICMSItemDocto,
CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' AND tbDocumento.EspecieDocumento <> 'ECF' THEN
	tbItemDocumento.BaseICMSSubstTribItemDocto
WHEN tbDocumento.EntradaSaidaDocumento = 'E' AND tbEmpresa.EquiparadoIndustria = 'V' THEN
	CASE WHEN tbEmpresa.CodigoEmpresa NOT IN (710,730,920,1918) THEN -- TICKET 201296
		tbItemDocumento.BaseICMSSubstTribItemDocto
	ELSE
		0
	END
ELSE
	CASE WHEN tbDocumento.CodigoEmpresa in (6050) and tbDocumento.EntradaSaidaDocumento = 'E' AND tbItemDocumento.ValorICMSRetidoItemDocto <> 0 THEN -- Querência (TKT 254103)
		tbItemDocumento.BaseICMSSubstTribItemDocto
	ELSE
		0
	END
END AS BaseICMSSubstTribItemDocto,
CASE
WHEN tbDocumento.EntradaSaidaDocumento = 'S' AND tbDocumento.EspecieDocumento <> 'ECF' THEN
	tbItemDocumento.ValorICMSSubstTribItemDocto
WHEN tbDocumento.EntradaSaidaDocumento = 'E' AND tbEmpresa.EquiparadoIndustria = 'V' THEN
	CASE WHEN tbEmpresa.CodigoEmpresa NOT IN (710,730,920,1918) THEN -- TICKET 201296
		tbItemDocumento.ValorICMSSubstTribItemDocto
	ELSE
		0
	END
ELSE
	CASE WHEN tbDocumento.CodigoEmpresa in (6050) and tbDocumento.EntradaSaidaDocumento = 'E' AND tbItemDocumento.ValorICMSRetidoItemDocto <> 0 THEN -- Querência (TKT 254103)
		tbItemDocumento.ValorICMSRetidoItemDocto
	ELSE
		0
	END
END AS ValorICMSRetido,
CASE WHEN tbDocumento.EspecieDocumento <> 'ECF' THEN
	CASE WHEN ( tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND (tbItemDocumento.ValorBaseICMS2ItemDocto + tbItemDocumento.ValorBaseICMS3ItemDocto) <> 0 ) THEN 
		(tbItemDocumento.ValorBaseICMS2ItemDocto + tbItemDocumento.ValorBaseICMS3ItemDocto) 
	ELSE
		CASE WHEN ((tbDocumento.ValorICMSRetidoDocumento + tbDocumento.ValorICMSSubstTribDocto ) <> 0 AND tbItemDocumento.ValorBaseICMS2ItemDocto <> 0 AND tbItemDocumento.ValorBaseICMS3ItemDocto <> 0 ) THEN
			tbItemDocumento.ValorBaseICMS2ItemDocto
		ELSE
			0
		END
	END 
ELSE
	0
END as ValorIsenta,
CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' THEN
	tbItemDocumento.ValorIPIItemDocto
ELSE
	CASE WHEN tbEmpresa.EquiparadoIndustria = 'V' OR tbLocalLF.CondicaoContribuinteIPI = 'V' THEN
		CASE WHEN tbItemDocumento.ValorBaseIPI1ItemDocto <> 0 THEN
			tbItemDocumento.ValorIPIItemDocto
		ELSE
			0
		END
	ELSE
		0
	END
END AS ValorIPIItemDocto,
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao
INTO #tmpC190
FROM tbItemDocumento (NOLOCK)
INNER JOIN tbEmpresa (NOLOCK) ON
           tbEmpresa.CodigoEmpresa = @CodigoEmpresa
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
INNER JOIN tbCliFor (NOLOCK) ON
           tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
           tbCliFor.CodigoCliFor = tbItemDocumento.CodigoCliFor
INNER JOIN tbPercentual (NOLOCK) ON
		   tbPercentual.UFDestino = tbCliFor.UFCliFor AND
		   tbPercentual.UFOrigem = tbLocal.UFLocal
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal 
INNER JOIN tbDocumento (NOLOCK) ON
           tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumento.CodigoLocal = @CodigoLocal AND
           tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
           tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND
           tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
LEFT JOIN tbDocumentoFT (NOLOCK) ON
           tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumentoFT.CodigoLocal = @CodigoLocal AND
           tbDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
           tbDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
           tbDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
          tbNaturezaOperacao.CodigoEmpresa = @CodigoEmpresa AND
          tbNaturezaOperacao.CodigoNaturezaOperacao = COALESCE(tbDocumentoFT.CodigoNaturezaOperacao,tbItemDocumento.CodigoNaturezaOperacao)
INNER JOIN rtSPEDFiscal (NOLOCK) ON
           rtSPEDFiscal.Spid = @@spid AND
           rtSPEDFiscal.EntradaSaida = tbItemDocumento.EntradaSaidaDocumento AND
           rtSPEDFiscal.DataDocumento = tbItemDocumento.DataDocumento AND
           rtSPEDFiscal.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           rtSPEDFiscal.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           rtSPEDFiscal.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
LEFT JOIN tbItemDocumentoFT (NOLOCK) ON
           tbItemDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
           tbItemDocumentoFT.CodigoLocal = @CodigoLocal AND
           tbItemDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
           tbItemDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
           tbItemDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbItemDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbItemDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND
           tbItemDocumentoFT.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento
LEFT JOIN tbProdutoFT (NOLOCK) ON
          tbProdutoFT.CodigoEmpresa = @CodigoEmpresa AND
          tbProdutoFT.CodigoProduto = tbItemDocumento.CodigoProduto
LEFT JOIN tbVeiculoCV (NOLOCK) ON
          tbVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
          tbVeiculoCV.CodigoLocal = @CodigoLocal AND
          tbVeiculoCV.NumeroVeiculoCV = tbItemDocumento.NumeroVeiculoCV
LEFT JOIN tbModeloVeiculoCV (NOLOCK) ON
          tbModeloVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
          tbModeloVeiculoCV.ModeloVeiculo = tbVeiculoCV.ModeloVeiculo
LEFT JOIN tbNaturezaOperacao CNOItem (NOLOCK) ON
          CNOItem.CodigoEmpresa = @CodigoEmpresa AND
          CNOItem.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao
WHERE 
tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbItemDocumento.CodigoLocal = @CodigoLocal AND
tbItemDocumento.DataDocumento between @DataInicial AND @DataFinal AND
rtSPEDFiscal.TipoRegistro = 'C100' AND
tbDocumento.CondicaoNFCancelada = 'F' AND
tbDocumento.TipoLancamentoMovimentacao <> 11

----
INSERT rtSPEDFiscal
SELECT
@@spid,
'|C190|' + 
RIGHT('000' + RTRIM(LTRIM(CONVERT(VARCHAR(3),CodigoTributacao))),3) + '|' +
CONVERT(VARCHAR(4),CodigoCFO) + '|' +
REPLACE(CONVERT(VARCHAR(16),PercentualICMSItemDocto),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(ValorContabilItemDocto)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(ValorBaseICMS1ItemDocto)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(ValorICMSItemDocto)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(BaseICMSSubstTribItemDocto)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),sum(ValorICMSRetido)),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),SUM(ValorIsenta)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(ValorIPIItemDocto)),'.',',') + '|' +
CASE WHEN CONVERT(numeric(4),@Versao) > 3 THEN '|' ELSE '' END,
'C190',
EntradaSaidaDocumento,
NumeroDocumento,
DataDocumento,
CodigoCliFor,
TipoLancamentoMovimentacao,
11,
'',
0,
'',
0
FROM #tmpC190
GROUP BY
CodigoTributacao,
CodigoCFO,
PercentualICMSItemDocto,
EntradaSaidaDocumento,
NumeroDocumento,
DataDocumento,
CodigoCliFor,
TipoLancamentoMovimentacao
ORDER BY 
CodigoTributacao,
CodigoCFO,
PercentualICMSItemDocto

DROP TABLE #tmpC190

--- C195 e C197

SELECT DISTINCT
EntradaSaida,
NumeroDocumento,
DataDocumento,
CodigoCliFor,
TipoLancamentoMovimentacao,
CodigoProduto
INTO #tmpC197
FROM rtSPEDFiscal
WHERE
rtSPEDFiscal.Spid = @@Spid AND
rtSPEDFiscal.TipoRegistro = 'C170' AND
rtSPEDFiscal.EntradaSaida = 'E'

--- Acumular para totais
TRUNCATE TABLE rtE110

SELECT 
#tmpC197.EntradaSaida,
#tmpC197.NumeroDocumento,
#tmpC197.DataDocumento,
#tmpC197.CodigoCliFor,
#tmpC197.TipoLancamentoMovimentacao,
#tmpC197.CodigoProduto,
tbItemDocumentoCTRC.BaseICMSSubstTribItemDocto,
tbItemDocumentoCTRC.PercentualICMSItemDocto,
tbItemDocumentoCTRC.ValorICMSSubstTribItemDocto, 
tbItemDocumentoCTRC.ValorICMSRetidoItemDocto
INTO #tmpC197Item
FROM #tmpC197
INNER JOIN tbDocumento (NOLOCK) ON
           tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumento.CodigoLocal = @CodigoLocal AND
           tbDocumento.EntradaSaidaDocumento = 'E' AND
           tbDocumento.DataDocumento = #tmpC197.DataDocumento AND
           tbDocumento.CodigoCliFor = #tmpC197.CodigoCliFor AND
           tbDocumento.NumeroDocumento = #tmpC197.NumeroDocumento AND
           tbDocumento.TipoLancamentoMovimentacao = #tmpC197.TipoLancamentoMovimentacao
INNER JOIN tbItemDocumento tbItemDocumentoCTRC (NOLOCK) ON
           tbItemDocumentoCTRC.CodigoEmpresa = @CodigoEmpresa AND
           tbItemDocumentoCTRC.CodigoLocal = @CodigoLocal AND
           tbItemDocumentoCTRC.EntradaSaidaDocumento = 'E' AND
           tbItemDocumentoCTRC.DataDocumento = tbDocumento.DataEmissaoCTRC AND
           tbItemDocumentoCTRC.NumeroDocumento = tbDocumento.NumeroCTRC AND
           tbItemDocumentoCTRC.TipoLancamentoMovimentacao = 1 AND
           tbItemDocumentoCTRC.CodigoProduto = #tmpC197.CodigoProduto
WHERE 
tbDocumento.CondicaoNFCancelada = 'F' AND
tbDocumento.TipoLancamentoMovimentacao <> 11 AND
tbDocumento.NumeroCTRC IS NOT NULL AND
(
	tbItemDocumentoCTRC.ValorICMSSubstTribItemDocto <> 0 OR 
	tbItemDocumentoCTRC.ValorICMSRetidoItemDocto <> 0
) AND
tbItemDocumentoCTRC.ValorDifAliquotaICMSItemDocto = 0

--- dif aliquota

SELECT 
#tmpC197.EntradaSaida,
#tmpC197.NumeroDocumento,
#tmpC197.DataDocumento,
#tmpC197.CodigoCliFor,
#tmpC197.TipoLancamentoMovimentacao,
#tmpC197.CodigoProduto,
SUM(tbItemDocumento.ValorContabilItemDocto) AS ValorBaseICMS1ItemDocto,
MAX(tbPercentual.ICMSSaidaUF) - 
	CASE
	WHEN MAX(tbItemDocumento.PercentualICMSItemDocto) <> 0 THEN
		MAX(tbItemDocumento.PercentualICMSItemDocto)
	WHEN MAX(tbNaturezaOperacao.PercentualICMSNaturezaOperacao) <> 0 THEN
		MAX(tbNaturezaOperacao.PercentualICMSNaturezaOperacao)
	ELSE
		(	SELECT MAX(tbPercentual.ICMSSaidaUF)
			FROM tbPercentual (NOLOCK) 
			WHERE 
				tbPercentual.UFDestino	= tbLocal.UFLocal AND
				tbPercentual.UFOrigem	= tbCliFor.UFCliFor
		)
	END AS PercentualICMSItemDocto,
SUM(tbItemDocumento.ValorDifAliquotaICMSItemDocto) AS ValorDifAliquotaICMSItemDocto
INTO #tmpC197ItemDifAliquota
FROM #tmpC197
INNER JOIN tbDocumento (NOLOCK) ON
           tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumento.CodigoLocal = @CodigoLocal AND
           tbDocumento.EntradaSaidaDocumento = 'E' AND
           tbDocumento.DataDocumento = #tmpC197.DataDocumento AND
           tbDocumento.CodigoCliFor = #tmpC197.CodigoCliFor AND
           tbDocumento.NumeroDocumento = #tmpC197.NumeroDocumento AND
           tbDocumento.TipoLancamentoMovimentacao = #tmpC197.TipoLancamentoMovimentacao
INNER JOIN tbLocal (NOLOCK) ON
		   tbLocal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
		   tbLocal.CodigoLocal = tbDocumento.CodigoLocal
INNER JOIN tbCliFor (NOLOCK) ON
		   tbCliFor.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
		   tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
INNER JOIN tbItemDocumento (NOLOCK) ON
           tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
           tbItemDocumento.CodigoLocal = @CodigoLocal AND
           tbItemDocumento.EntradaSaidaDocumento = 'E' AND
           tbItemDocumento.DataDocumento =  #tmpC197.DataDocumento  AND
		   tbItemDocumento.CodigoCliFor = #tmpC197.CodigoCliFor AND
           tbItemDocumento.NumeroDocumento = #tmpC197.NumeroDocumento AND
           tbItemDocumento.TipoLancamentoMovimentacao = #tmpC197.TipoLancamentoMovimentacao and
		   ( 
				( tbItemDocumento.CodigoProduto = #tmpC197.CodigoProduto AND tbItemDocumento.TipoLancamentoMovimentacao = 1 ) 
				OR 
				tbItemDocumento.TipoLancamentoMovimentacao IN (9, 10)
			)
LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
		  tbNaturezaOperacao.CodigoEmpresa	= tbItemDocumento.CodigoEmpresa AND
		  tbNaturezaOperacao.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao 
INNER JOIN tbPercentual (NOLOCK) ON
           tbPercentual.UFOrigem = tbLocal.UFLocal AND
           tbPercentual.UFDestino = tbLocal.UFLocal 
WHERE 
tbDocumento.CondicaoNFCancelada = 'F' AND
tbDocumento.TipoLancamentoMovimentacao <> 11 AND
tbItemDocumento.ValorDifAliquotaICMSItemDocto <> 0
GROUP BY 
#tmpC197.EntradaSaida,
#tmpC197.NumeroDocumento,
#tmpC197.DataDocumento,
#tmpC197.CodigoCliFor,
#tmpC197.TipoLancamentoMovimentacao,
#tmpC197.CodigoProduto,
tbLocal.UFLocal,
tbCliFor.UFCliFor

--- fim dif aliquota

INSERT #tmpC197Item 
SELECT
#tmpC197.EntradaSaida,
#tmpC197.NumeroDocumento,
#tmpC197.DataDocumento,
#tmpC197.CodigoCliFor,
#tmpC197.TipoLancamentoMovimentacao,
#tmpC197.CodigoProduto,
tbItemDocumento.BaseICMSSubstTribItemDocto,
tbItemDocumento.PercentualICMSItemDocto,
tbItemDocumento.ValorICMSSubstTribItemDocto,
tbItemDocumento.ValorICMSRetidoItemDocto
FROM #tmpC197
INNER JOIN tbDocumento (NOLOCK) ON
           tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumento.CodigoLocal = @CodigoLocal AND
           tbDocumento.EntradaSaidaDocumento = 'E' AND
           tbDocumento.DataDocumento = #tmpC197.DataDocumento AND
           tbDocumento.CodigoCliFor = #tmpC197.CodigoCliFor AND
           tbDocumento.NumeroDocumento = #tmpC197.NumeroDocumento AND
           tbDocumento.TipoLancamentoMovimentacao = #tmpC197.TipoLancamentoMovimentacao
INNER JOIN tbItemDocumento (NOLOCK) ON
           tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
           tbItemDocumento.CodigoLocal = @CodigoLocal AND
           tbItemDocumento.EntradaSaidaDocumento = 'E' AND
           tbItemDocumento.DataDocumento = #tmpC197.DataDocumento AND
           tbItemDocumento.CodigoCliFor = #tmpC197.CodigoCliFor AND
           tbItemDocumento.NumeroDocumento = #tmpC197.NumeroDocumento AND
           tbItemDocumento.TipoLancamentoMovimentacao = #tmpC197.TipoLancamentoMovimentacao AND
           COALESCE(tbItemDocumento.CodigoProduto,tbItemDocumento.CodigoItemDocto) = #tmpC197.CodigoProduto
WHERE 
tbDocumento.EntradaSaidaDocumento = 'E' AND
tbDocumento.CondicaoNFCancelada = 'F' AND
tbDocumento.TipoLancamentoMovimentacao <> 11 AND
(
	tbItemDocumento.ValorICMSSubstTribItemDocto <> 0 OR 
	tbItemDocumento.ValorICMSRetidoItemDocto <> 0
) AND
tbItemDocumento.ValorDifAliquotaICMSItemDocto = 0



-- C197 - ICMS-ST Calculado na Entrada
INSERT rtE110
SELECT
#tmpC197Item.EntradaSaida,									-- EntradaSaida
#tmpC197Item.NumeroDocumento,								-- NumeroDocumento
#tmpC197Item.DataDocumento,									-- DataDocumento
#tmpC197Item.CodigoCliFor,									-- CodigoCliFor
#tmpC197Item.TipoLancamentoMovimentacao,					-- TipoLancamento
'C197',														-- TipoRegistro
@AjusteICMSCTRCST,											-- CodigoAjuste
'',															-- DescricaoComplementar
#tmpC197Item.CodigoProduto,									-- CodigoItem
sum(#tmpC197Item.BaseICMSSubstTribItemDocto),				-- BaseCalculoICMS
max(#tmpC197Item.PercentualICMSItemDocto),					-- AliquotaICMS
sum(#tmpC197Item.ValorICMSSubstTribItemDocto),				-- ValorICMS
0															-- OutrosValores
FROM	#tmpC197Item
WHERE	#tmpC197Item.ValorICMSRetidoItemDocto = 0
GROUP BY 
#tmpC197Item.EntradaSaida,
#tmpC197Item.NumeroDocumento,
#tmpC197Item.DataDocumento,
#tmpC197Item.CodigoCliFor,
#tmpC197Item.TipoLancamentoMovimentacao,
#tmpC197Item.CodigoProduto



-- C197 - ICMS-ST Retido na NF
INSERT rtE110
SELECT
#tmpC197Item.EntradaSaida,									-- EntradaSaida
#tmpC197Item.NumeroDocumento,								-- NumeroDocumento
#tmpC197Item.DataDocumento,									-- DataDocumento
#tmpC197Item.CodigoCliFor,									-- CodigoCliFor
#tmpC197Item.TipoLancamentoMovimentacao,					-- TipoLancamento
'C197',														-- TipoRegistro
@AjusteICMSCTRCSTRetido,									-- CodigoAjuste
'',															-- DescricaoComplementar
#tmpC197Item.CodigoProduto,									-- CodigoItem
sum(#tmpC197Item.BaseICMSSubstTribItemDocto),				-- BaseCalculoICMS
max(#tmpC197Item.PercentualICMSItemDocto),					-- AliquotaICMS
sum(#tmpC197Item.ValorICMSRetidoItemDocto),					-- ValorICMS
0															-- OutrosValores
FROM	#tmpC197Item
WHERE	#tmpC197Item.ValorICMSRetidoItemDocto <> 0
GROUP BY 
#tmpC197Item.EntradaSaida,
#tmpC197Item.NumeroDocumento,
#tmpC197Item.DataDocumento,
#tmpC197Item.CodigoCliFor,
#tmpC197Item.TipoLancamentoMovimentacao,
#tmpC197Item.CodigoProduto



-- C197 - Diferencial de Alíquotas
INSERT rtE110
SELECT
#tmpC197ItemDifAliquota.EntradaSaida,						-- EntradaSaida
#tmpC197ItemDifAliquota.NumeroDocumento,					-- NumeroDocumento
#tmpC197ItemDifAliquota.DataDocumento,						-- DataDocumento
#tmpC197ItemDifAliquota.CodigoCliFor,						-- CodigoCliFor
#tmpC197ItemDifAliquota.TipoLancamentoMovimentacao,			-- TipoLancamento
'C197',														-- TipoRegistro
@AjusteICMSDIFALQ,											-- CodigoAjuste
'',															-- DescricaoComplementar
#tmpC197ItemDifAliquota.CodigoProduto,						-- CodigoItem
sum(#tmpC197ItemDifAliquota.ValorBaseICMS1ItemDocto),		-- BaseCalculoICMS
max(#tmpC197ItemDifAliquota.PercentualICMSItemDocto),		-- AliquotaICMS
sum(#tmpC197ItemDifAliquota.ValorDifAliquotaICMSItemDocto),	-- ValorICMS
0															-- OutrosValores
FROM #tmpC197ItemDifAliquota
GROUP BY 
#tmpC197ItemDifAliquota.EntradaSaida,
#tmpC197ItemDifAliquota.NumeroDocumento,
#tmpC197ItemDifAliquota.DataDocumento,
#tmpC197ItemDifAliquota.CodigoCliFor,
#tmpC197ItemDifAliquota.TipoLancamentoMovimentacao,
#tmpC197ItemDifAliquota.CodigoProduto



-- D197 - Diferencial de Alíquotas Fretes
INSERT rtE110
SELECT
tbDocumento.EntradaSaidaDocumento,							-- EntradaSaida
tbDocumento.NumeroDocumento,								-- NumeroDocumento
tbDocumento.DataDocumento,									-- DataDocumento
tbDocumento.CodigoCliFor,									-- CodigoCliFor
tbDocumento.TipoLancamentoMovimentacao,						-- TipoLancamento
'D197',														-- TipoRegistro
@AjusteICMSDIFALQCTRC,										-- CodigoAjuste
'DIFERENCIAL DE ALIQUOTAS SOBRE AQUISICAO DE FRETE',		-- DescricaoComplementar
'',															-- CodigoItem
SUM(tbItemDocumento.ValorContabilItemDocto),				-- BaseCalculoICMS
MAX(tbPercentual.ICMSSaidaUF) - 
	CASE
	WHEN MAX(tbItemDocumento.PercentualICMSItemDocto) <> 0 THEN
		MAX(tbItemDocumento.PercentualICMSItemDocto)
	WHEN MAX(tbNaturezaOperacao.PercentualICMSNaturezaOperacao) <> 0 THEN
		MAX(tbNaturezaOperacao.PercentualICMSNaturezaOperacao)
	ELSE
		(	SELECT MAX(tbPercentual.ICMSSaidaUF)
			FROM tbPercentual (NOLOCK) 
			WHERE 
				tbPercentual.UFDestino	= tbLocal.UFLocal AND
				tbPercentual.UFOrigem	= tbCliFor.UFCliFor
		)
	END,													-- AliquotaICMS
SUM(tbItemDocumento.ValorDifAliquotaICMSItemDocto),			-- ValorICMS
0															-- OutrosValores
FROM tbItemDocumento (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal
INNER JOIN tbPercentual (NOLOCK) ON
           tbPercentual.UFOrigem = tbLocal.UFLocal AND
           tbPercentual.UFDestino = tbLocal.UFLocal 
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal
LEFT JOIN tbDocumento (NOLOCK) ON
		  tbDocumento.CodigoEmpresa		= tbItemDocumento.CodigoEmpresa AND
          tbDocumento.CodigoLocal		= tbItemDocumento.CodigoLocal AND
		  tbDocumento.EntradaSaidaDocumento	= tbItemDocumento.EntradaSaidaDocumento AND
		  tbDocumento.NumeroDocumento		= tbItemDocumento.NumeroDocumento AND
		  tbDocumento.CodigoCliFor		= tbItemDocumento.CodigoCliFor AND
		  tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND
		  tbDocumento.DataDocumento		= tbItemDocumento.DataDocumento 
INNER JOIN tbCliFor (NOLOCK) ON
		  tbCliFor.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
		  tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
LEFT JOIN tbDocumentoFT (NOLOCK) ON
		  tbDocumentoFT.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoFT.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoFT.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoFT.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoFT.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoFT.DataDocumento		= tbDocumento.DataDocumento 
LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
		  tbNaturezaOperacao.CodigoEmpresa	= tbDocumento.CodigoEmpresa AND
		  tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao 
LEFT JOIN tbDocumentoNFe (NOLOCK) ON
		  tbDocumentoNFe.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoNFe.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoNFe.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoNFe.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoNFe.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoNFe.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoNFe.DataDocumento		= tbDocumento.DataDocumento 
WHERE RTRIM(LTRIM(@AjusteICMSDIFALQCTRC)) <> '' AND RTRIM(LTRIM(@AjusteICMSDIFALQCTRC)) <> '00000000' AND
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = tbDocumento.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao AND
		tbDocumento.TipoLancamentoMovimentacao IN (7,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)			
	OR  tbDocumento.TipoLancamentoMovimentacao IN (1,9,10,12)
	)
	AND tbDocumento.CodigoModeloNotaFiscal IN (7,8,9,10,11,26,27,57)
	AND tbItemDocumento.ValorDifAliquotaICMSItemDocto <> 0
	AND (	tbDocumento.EspecieDocumento <> 'ECF' OR						-- Cupons Fiscais somente vão no SPED
			tbDocumento.NumeroDocumento <> tbDocumento.NumeroNFDocumento )	-- se tiverem NF Conjugada (TKT 234897 / 2016)
	AND tbDocumento.CodigoEmpresa		= @CodigoEmpresa 
	AND tbDocumento.CodigoLocal		    = @CodigoLocal
	AND tbDocumento.DataDocumento 		between @DataInicial and @DataFinal  
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
	(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento = tbDocumento.DataEmissaoDocumento) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento = 0 ))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento <> tbDocumento.DataEmissaoDocumento) OR (tbDocumento.TipoLancamentoMovimentacao = 11) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento <> 0))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 12 OR tbDocumento.TipoLancamentoMovimentacao = 11 OR tbDocumento.CondicaoNFCancelada = 'V')) OR 
	(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 11))
	)
	AND 'V' = CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' and 
	          	    tbDocumento.CondicaoNFCancelada = 'V' and 
               		    tbDocumento.TipoLancamentoMovimentacao <> 7 
			THEN 'F'
			ELSE 'V'
		  END
GROUP BY
	tbDocumento.CodigoEmpresa,
	tbDocumento.CodigoLocal,
	tbDocumento.EntradaSaidaDocumento,
	tbDocumento.NumeroDocumento,
	tbDocumento.DataDocumento,
	tbDocumento.CodigoCliFor,
	tbDocumento.TipoLancamentoMovimentacao,
	tbItemDocumento.PercentualICMSItemDocto,
	tbLocal.UFLocal, 
	tbCliFor.UFCliFor



-- Gera registros |C197| / |D197|
INSERT rtSPEDFiscal
SELECT
	@@Spid,
	'|' + TipoRegistro + '|'
+	CodigoAjuste + '|'
+	DescricaoComplementar + '|'
+	RTRIM(LTRIM(CodigoItem)) + '|'
+	REPLACE(CONVERT(VARCHAR(16),BaseCalculoICMS),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),AliquotaICMS),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),ValorICMS),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),OutrosValores),'.',',') + '|',
TipoRegistro,
EntradaSaida,
NumeroDocumento,
DataDocumento,
CodigoCliFor,
TipoLancamento,
CASE WHEN TipoRegistro = 'C197' THEN 11 ELSE 40 END,
'',
0,
'',
0
FROM rtE110
WHERE RTRIM(LTRIM(CodigoAjuste)) NOT IN ('','0000000000')



INSERT rtSPEDFiscal
SELECT DISTINCT
@@Spid,
'|C195|ICMSST|ICMS ST|',
'C195',
EntradaSaida,
NumeroDocumento,
DataDocumento,
CodigoCliFor,
TipoLancamento,
11,
'',
0,
'',
0
FROM rtE110
WHERE	TipoRegistro = 'C197'
AND		RTRIM(LTRIM(CodigoAjuste)) NOT IN ('','0000000000')
AND		(	RTRIM(LTRIM(CodigoAjuste)) = @AjusteICMSCTRCST OR
			RTRIM(LTRIM(CodigoAjuste)) = @AjusteICMSCTRCSTRetido	) 



INSERT rtSPEDFiscal
SELECT DISTINCT
@@Spid,
'|C195|DIFALI|ICMS DIFERENCIAL DE ALIQUOTA - AQUISICAO DE MATERIAL DE USO E CONSUMO|',
'C195',
EntradaSaida,
NumeroDocumento,
DataDocumento,
CodigoCliFor,
TipoLancamento,
11,
'',
0,
'',
0
FROM rtE110
WHERE	TipoRegistro = 'C197'
AND		RTRIM(LTRIM(CodigoAjuste)) NOT IN ('','0000000000')
AND		RTRIM(LTRIM(CodigoAjuste)) = @AjusteICMSDIFALQ



INSERT rtSPEDFiscal
SELECT DISTINCT
@@spid,
'|D195|DAFRTE||',
'D195',
EntradaSaida,
NumeroDocumento,
DataDocumento,
CodigoCliFor,
TipoLancamento,
40,
'',
0,
'',
0
FROM rtE110
WHERE	TipoRegistro = 'D197'
AND		RTRIM(LTRIM(CodigoAjuste)) NOT IN ('','0000000000')
AND		RTRIM(LTRIM(CodigoAjuste)) = @AjusteICMSDIFALQCTRC



INSERT rtSPEDFiscal
SELECT DISTINCT
@@Spid,
'|0450|DEVVEN|DEVOLUCAO VENDA|',
'0450',
'E',
0,
getdate(),
0,
0,
9,
'',
0,
'',
0
FROM rtSPEDFiscal (NOLOCK)
WHERE 
rtSPEDFiscal.Spid = @@Spid AND
rtSPEDFiscal.TipoRegistro = 'C110' AND
rtSPEDFiscal.Linha like '%DEVVEN%'

INSERT rtSPEDFiscal
SELECT DISTINCT
@@Spid,
'|0450|DEVCOM|DEVOLUCAO COMPRA|',
'0450',
'E',
0,
getdate(),
0,
0,
9,
'',
0,
'',
0
FROM rtSPEDFiscal (NOLOCK)
WHERE 
rtSPEDFiscal.Spid = @@Spid AND
rtSPEDFiscal.TipoRegistro = 'C110' AND
rtSPEDFiscal.Linha like '%DEVCOM%'

INSERT rtSPEDFiscal
SELECT DISTINCT
@@Spid,
'|0450|RETCON|RETORNO DE VEICULO EM CONSIGNACAO|',
'0450',
'E',
0,
getdate(),
0,
0,
9,
'',
0,
'',
0
FROM rtSPEDFiscal (NOLOCK)
WHERE 
rtSPEDFiscal.Spid = @@Spid AND
rtSPEDFiscal.TipoRegistro = 'C110' AND
rtSPEDFiscal.Linha like '%|RETCON|%'

INSERT rtSPEDFiscal
SELECT DISTINCT
@@Spid,
'|0450|REMESS|SIMPLES REMESSA|',
'0450',
'E',
0,
getdate(),
0,
0,
9,
'',
0,
'',
0
FROM rtSPEDFiscal (NOLOCK)
WHERE 
rtSPEDFiscal.Spid = @@Spid AND
rtSPEDFiscal.TipoRegistro = 'C110' AND
rtSPEDFiscal.Linha like '%|REMESS|%'

INSERT rtSPEDFiscal
SELECT DISTINCT
@@Spid,
'|0450|RVTERC|REMESSA DE VEICULO DE TERCEIRO|',
'0450',
'E',
0,
getdate(),
0,
0,
9,
'',
0,
'',
0
FROM rtSPEDFiscal (NOLOCK)
WHERE 
rtSPEDFiscal.Spid = @@Spid AND
rtSPEDFiscal.TipoRegistro = 'C110' AND
rtSPEDFiscal.Linha like '%|RVTERC|%'

INSERT rtSPEDFiscal
SELECT DISTINCT
@@Spid,
'|0450|COMPLM|NF COMPLEMENTAR ICMS/IPI|',
'0450',
'E',
0,
getdate(),
0,
0,
9,
'',
0,
'',
0
FROM rtSPEDFiscal (NOLOCK)
WHERE 
rtSPEDFiscal.Spid = @@Spid AND
rtSPEDFiscal.TipoRegistro = 'C110' AND
rtSPEDFiscal.Linha like '%|COMPLM|%'

INSERT rtSPEDFiscal
SELECT DISTINCT
@@Spid,
'|0450|VENECF|VENDA POR ECF|',
'0450',
'E',
0,
getdate(),
0,
0,
9,
'',
0,
'',
0
FROM rtSPEDFiscal (NOLOCK)
WHERE 
rtSPEDFiscal.Spid = @@Spid AND
rtSPEDFiscal.TipoRegistro = 'C110' AND
rtSPEDFiscal.Linha like '%VENECF%'

INSERT rtSPEDFiscal
SELECT DISTINCT
@@Spid,
'|0450|OBSDOC|OBSERVAÇÃO GERAL|',
'0450',
'E',
0,
getdate(),
0,
0,
9,
'',
0,
'',
0
FROM rtSPEDFiscal (NOLOCK)
WHERE 
rtSPEDFiscal.Spid = @@Spid AND
rtSPEDFiscal.TipoRegistro = 'C110' AND
rtSPEDFiscal.Linha like '%OBSDOC%'

INSERT rtSPEDFiscal
SELECT DISTINCT
@@Spid,
'|0460|ICMSST|ICMS ST|',
'0460',
'E',
0,
getdate(),
0,
0,
9,
'',
0,
'',
0
FROM rtE110
WHERE	TipoRegistro = 'C197'
AND		RTRIM(LTRIM(CodigoAjuste)) NOT IN ('','0000000000')
AND		(	RTRIM(LTRIM(CodigoAjuste)) = @AjusteICMSCTRCST OR
			RTRIM(LTRIM(CodigoAjuste)) = @AjusteICMSCTRCSTRetido	) 

			

INSERT rtSPEDFiscal
SELECT DISTINCT
@@Spid,
'|0460|DIFALI|ICMS DIFERENCIAL DE ALIQUOTA - AQUISICAO DE MATERIAL DE USO E CONSUMO|',
'0460',
'E',
0,
getdate(),
0,
0,
9,
'',
0,
'',
0
FROM rtE110
WHERE	TipoRegistro = 'C197'
AND		RTRIM(LTRIM(CodigoAjuste)) NOT IN ('','0000000000')
AND		RTRIM(LTRIM(CodigoAjuste)) = @AjusteICMSDIFALQ



INSERT rtSPEDFiscal
SELECT DISTINCT
@@Spid,
'|0460|DAFRTE|ICMS DIFERENCIAL DE ALIQUOTA - AQUISICAO DE FRETE|',
'0460',
'E',
0,
getdate(),
0,
0,
9,
'',
0,
'',
0
FROM rtE110
WHERE	TipoRegistro = 'D197'
AND		RTRIM(LTRIM(CodigoAjuste)) NOT IN ('','0000000000')
AND		RTRIM(LTRIM(CodigoAjuste)) = @AjusteICMSDIFALQCTRC



DROP TABLE #tmpC197
DROP TABLE #tmpC197Item
DROP TABLE #tmpC197ItemDifAliquota


--- ECF

INSERT rtSPEDFiscal
SELECT DISTINCT
@@spid,
'|C400|' + 
'2D|' +
RTRIM(LTRIM(NumOrdemEquipamentoECF)) + '|' +
RTRIM(LTRIM(NumeroSerieFabricacaoECF)) + '|' +
'1' + '|',
'C400',
RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
0,
@DataInicial,
0,
0,
13,
'',
0,
'',
0
FROM tbMapaECF
WHERE
CodigoEmpresa = @CodigoEmpresa AND
CodigoLocal = @CodigoLocal AND
DataMapaECF between @DataInicial AND @DataFinal AND
NumeroSerieFabricacaoECF NOT LIKE 'DJ%'

if @Perfil = 'B' 
BEGIN

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C405|'
+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,DataMapaECF)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,DataMapaECF)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,DataMapaECF)),'') + '|'
+	RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),CRO))),3) + '|'
+	RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),ContadorReducaoZECF))),6) + '|'
+	RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(9),CupomReducaoZECF))),9) + '|'
+	REPLACE(CONVERT(VARCHAR(16),GranTotalFimDiaECF),'.',',') + '|'
+	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
						   		  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
									INNER JOIN tbDocumentoFT (NOLOCK)
									ON	tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa
									AND	tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal
									AND	tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor
									AND	tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
									AND	tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento
									AND	tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento
									AND	tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumentoFT.SerieECFDocFT = tbMapaECF.NumeroSerieFabricacaoECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0 )),'.',','),'0,00') + '|',
	'C405',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	0,
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C410|' + 
	REPLACE(CONVERT(VARCHAR(16),sum(ValorPISDocumento)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),sum(ValorFinsocialDocumento)),'.',',') + '|',
	'C410',
	tbDocumentoFT.SerieECFDocFT,
	0,
	tbDocumento.DataDocumento,
	0,
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbDocumento
	INNER JOIN tbDocumentoFT (NOLOCK) ON
               tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
               tbDocumentoFT.CodigoLocal = @CodigoLocal AND
               tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
               tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND
               tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
               tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
               tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao 
	WHERE
	tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
	tbDocumento.CodigoLocal = @CodigoLocal AND
	tbDocumento.DataDocumento between @DataInicial AND @DataFinal AND
	tbDocumento.EspecieDocumento = 'ECF' AND 
    tbDocumento.TipoLancamentoMovimentacao = 7 AND
	tbDocumento.CondicaoNFCancelada = 'F' AND
	EXISTS ( SELECT 1 FROM tbMapaECF 
			 WHERE
			 tbMapaECF.CodigoEmpresa = @CodigoEmpresa AND
			 tbMapaECF.CodigoLocal = @CodigoLocal AND
			 tbMapaECF.DataMapaECF = tbDocumento.DataDocumento AND
			 NumeroSerieFabricacaoECF NOT LIKE 'DJ%')
	GROUP BY 
		tbDocumento.DataDocumento,
		tbDocumentoFT.SerieECFDocFT
	
	DELETE rtSPEDFiscal
	WHERE
	Spid = @@spid AND
	TipoRegistro = 'C410' AND
	( Linha is NULL or Linha = '|C410|||' )
	
	
	
	
	-- PercentualICMSBase1
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'T' + RIGHT('0000' + REPLACE(CONVERT(VARCHAR(6),PercentualICMSBase1),'.',''),4) + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase1 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF = 'T')),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	CONVERT(NUMERIC(4),PercentualICMSBase1),
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	PercentualICMSBase1 <> 0 AND
	BaseCalculo1ICMSECF <> 0 AND
	EXISTS (  SELECT 1
			  FROM tbItemDocumento
   			  INNER JOIN tbDocumento ON
				tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbDocumento.CodigoLocal = @CodigoLocal AND 
				tbDocumento.EntradaSaidaDocumento = 'S' AND
				tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
				tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
				tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
				tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
				WHERE
				tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbItemDocumento.CodigoLocal = @CodigoLocal AND
				tbItemDocumento.EntradaSaidaDocumento = 'S' AND
				tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
				tbDocumento.EspecieDocumento = 'ECF' AND
				tbDocumento.CondicaoNFCancelada = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
	
	
	
	
	-- PercentualICMSBase2
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'T' + RIGHT('0000' + REPLACE(CONVERT(VARCHAR(6),PercentualICMSBase2),'.',''),4) + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase2 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF = 'T')),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	CONVERT(NUMERIC(4),PercentualICMSBase2),
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	PercentualICMSBase2 <> 0 and
	BaseCalculo2ICMSECF <> 0 AND
	EXISTS (  SELECT 1
			  FROM tbItemDocumento
   			  INNER JOIN tbDocumento ON
				tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbDocumento.CodigoLocal = @CodigoLocal AND 
				tbDocumento.EntradaSaidaDocumento = 'S' AND
				tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
				tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
				tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
				tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
				WHERE
				tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbItemDocumento.CodigoLocal = @CodigoLocal AND
				tbItemDocumento.EntradaSaidaDocumento = 'S' AND
				tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
				tbDocumento.EspecieDocumento = 'ECF' AND
				tbDocumento.CondicaoNFCancelada = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
	
	
	
	
	-- PercentualICMSBase3
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'T' + RIGHT('0000' + REPLACE(CONVERT(VARCHAR(6),PercentualICMSBase3),'.',''),4) + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase3 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF = 'T')),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	CONVERT(NUMERIC(4),PercentualICMSBase3),
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	PercentualICMSBase3 <> 0 AND
	BaseCalculo3ICMSECF <> 0 AND
	EXISTS (  SELECT 1
			  FROM tbItemDocumento
   			  INNER JOIN tbDocumento ON
				tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbDocumento.CodigoLocal = @CodigoLocal AND 
				tbDocumento.EntradaSaidaDocumento = 'S' AND
				tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
				tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
				tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
				tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
				WHERE
				tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbItemDocumento.CodigoLocal = @CodigoLocal AND
				tbItemDocumento.EntradaSaidaDocumento = 'S' AND
				tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
				tbDocumento.EspecieDocumento = 'ECF' AND
				tbDocumento.CondicaoNFCancelada = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
	
	
	
	
	-- PercentualICMSBase4
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'T' + RIGHT('0000' + REPLACE(CONVERT(VARCHAR(6),PercentualICMSBase4),'.',''),4) + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase4 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF = 'T')),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	CONVERT(NUMERIC(4),PercentualICMSBase4),
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	PercentualICMSBase4 <> 0 AND
	BaseCalculo4ICMSECF <> 0 AND
	EXISTS (  SELECT 1
			  FROM tbItemDocumento
   			  INNER JOIN tbDocumento ON
				tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbDocumento.CodigoLocal = @CodigoLocal AND 
				tbDocumento.EntradaSaidaDocumento = 'S' AND
				tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
				tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
				tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
				tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
				WHERE
				tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbItemDocumento.CodigoLocal = @CodigoLocal AND
				tbItemDocumento.EntradaSaidaDocumento = 'S' AND
				tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
				tbDocumento.EspecieDocumento = 'ECF' AND
				tbDocumento.CondicaoNFCancelada = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
	
	
	
	
	-- PercentualICMSBase5
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'T' + RIGHT('0000' + REPLACE(CONVERT(VARCHAR(6),PercentualICMSBase5),'.',''),4) + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase5 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF = 'T')),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	CONVERT(NUMERIC(4),PercentualICMSBase5),
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	PercentualICMSBase5 <> 0 AND
	BaseCalculo5ICMSECF <> 0 AND
	EXISTS (  SELECT 1
			  FROM tbItemDocumento
   			  INNER JOIN tbDocumento ON
				tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbDocumento.CodigoLocal = @CodigoLocal AND 
				tbDocumento.EntradaSaidaDocumento = 'S' AND
				tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
				tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
				tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
				tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
				WHERE
				tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbItemDocumento.CodigoLocal = @CodigoLocal AND
				tbItemDocumento.EntradaSaidaDocumento = 'S' AND
				tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
				tbDocumento.EspecieDocumento = 'ECF' AND
				tbDocumento.CondicaoNFCancelada = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
	
	
	
	
	-- PercentualICMSBase6
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'T' + RIGHT('0000' + REPLACE(CONVERT(VARCHAR(6),PercentualICMSBase6),'.',''),4) + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase6 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF = 'T')),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	CONVERT(NUMERIC(4),PercentualICMSBase6),
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	PercentualICMSBase6 <> 0 AND
	BaseCalculo6ICMSECF <> 0 AND
	EXISTS (  SELECT 1
			  FROM tbItemDocumento
   			  INNER JOIN tbDocumento ON
				tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbDocumento.CodigoLocal = @CodigoLocal AND 
				tbDocumento.EntradaSaidaDocumento = 'S' AND
				tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
				tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
				tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
				tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
				WHERE
				tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbItemDocumento.CodigoLocal = @CodigoLocal AND
				tbItemDocumento.EntradaSaidaDocumento = 'S' AND
				tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
				tbDocumento.EspecieDocumento = 'ECF' AND
				tbDocumento.CondicaoNFCancelada = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
	
	
	
	
	-- PercentualICMSBase7
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'T' + RIGHT('0000' + REPLACE(CONVERT(VARCHAR(6),PercentualICMSBase7),'.',''),4) + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase7 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF = 'T')),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	CONVERT(NUMERIC(4),PercentualICMSBase7),
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	PercentualICMSBase7 <> 0 AND
	BaseCalculo7ICMSECF <> 0 AND
	EXISTS (  SELECT 1
			  FROM tbItemDocumento
   			  INNER JOIN tbDocumento ON
				tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbDocumento.CodigoLocal = @CodigoLocal AND 
				tbDocumento.EntradaSaidaDocumento = 'S' AND
				tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
				tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
				tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
				tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
				WHERE
				tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbItemDocumento.CodigoLocal = @CodigoLocal AND
				tbItemDocumento.EntradaSaidaDocumento = 'S' AND
				tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
				tbDocumento.EspecieDocumento = 'ECF' AND
				tbDocumento.CondicaoNFCancelada = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
	
	
	
	
	-- PercentualICMSBase8
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'T' + RIGHT('0000' + REPLACE(CONVERT(VARCHAR(6),PercentualICMSBase8),'.',''),4) + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase8 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF = 'T')),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	CONVERT(NUMERIC(4),PercentualICMSBase8),
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	PercentualICMSBase8 <> 0 AND
	BaseCalculo8ICMSECF <> 0 AND
	EXISTS (  SELECT 1
			  FROM tbItemDocumento
   			  INNER JOIN tbDocumento ON
				tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbDocumento.CodigoLocal = @CodigoLocal AND 
				tbDocumento.EntradaSaidaDocumento = 'S' AND
				tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
				tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
				tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
				tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
				WHERE
				tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbItemDocumento.CodigoLocal = @CodigoLocal AND
				tbItemDocumento.EntradaSaidaDocumento = 'S' AND
				tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
				tbDocumento.EspecieDocumento = 'ECF' AND
				tbDocumento.CondicaoNFCancelada = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
	
	
	
	
	-- PercentualICMSBase9
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'T' + RIGHT('0000' + REPLACE(CONVERT(VARCHAR(6),PercentualICMSBase9),'.',''),4) + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase9 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF = 'T')),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	CONVERT(NUMERIC(4),PercentualICMSBase9),
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	PercentualICMSBase9 <> 0 AND
	BaseCalculo9ICMSECF <> 0 AND
	EXISTS (  SELECT 1
			  FROM tbItemDocumento
   			  INNER JOIN tbDocumento ON
				tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbDocumento.CodigoLocal = @CodigoLocal AND 
				tbDocumento.EntradaSaidaDocumento = 'S' AND
				tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
				tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
				tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
				tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
				WHERE
				tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbItemDocumento.CodigoLocal = @CodigoLocal AND
				tbItemDocumento.EntradaSaidaDocumento = 'S' AND
				tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
				tbDocumento.EspecieDocumento = 'ECF' AND
				tbDocumento.CondicaoNFCancelada = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
	
	
	
	
	-- PercentualICMSBase10
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'T' + RIGHT('0000' + REPLACE(CONVERT(VARCHAR(6),PercentualICMSBase10),'.',''),4) + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase10 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF = 'T')),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	CONVERT(NUMERIC(4),PercentualICMSBase10),
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	PercentualICMSBase10 <> 0 AND
	BaseCalculo10ICMSECF <> 0 AND
	EXISTS (  SELECT 1
			  FROM tbItemDocumento
   			  INNER JOIN tbDocumento ON
				tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbDocumento.CodigoLocal = @CodigoLocal AND 
				tbDocumento.EntradaSaidaDocumento = 'S' AND
				tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
				tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
				tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
				tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
				WHERE
				tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbItemDocumento.CodigoLocal = @CodigoLocal AND
				tbItemDocumento.EntradaSaidaDocumento = 'S' AND
				tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
				tbDocumento.EspecieDocumento = 'ECF' AND
				tbDocumento.CondicaoNFCancelada = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
	
	
	
	
	-- PercentualICMSBase11
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'T' + RIGHT('0000' + REPLACE(CONVERT(VARCHAR(6),PercentualICMSBase11),'.',''),4) + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase11 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF = 'T')),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	CONVERT(NUMERIC(4),PercentualICMSBase11),
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	PercentualICMSBase11 <> 0 AND
	BaseCalculo11ICMSECF <> 0 AND
	EXISTS (  SELECT 1
			  FROM tbItemDocumento
   			  INNER JOIN tbDocumento ON
				tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbDocumento.CodigoLocal = @CodigoLocal AND 
				tbDocumento.EntradaSaidaDocumento = 'S' AND
				tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
				tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
				tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
				tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
				WHERE
				tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbItemDocumento.CodigoLocal = @CodigoLocal AND
				tbItemDocumento.EntradaSaidaDocumento = 'S' AND
				tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
				tbDocumento.EspecieDocumento = 'ECF' AND
				tbDocumento.CondicaoNFCancelada = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
	
	
	
	
	-- PercentualICMSBase12
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'T' + RIGHT('0000' + REPLACE(CONVERT(VARCHAR(6),PercentualICMSBase12),'.',''),4) + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase12 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF = 'T')),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	CONVERT(NUMERIC(4),PercentualICMSBase12),
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	PercentualICMSBase12 <> 0 AND
	BaseCalculo12ICMSECF <> 0 AND
	EXISTS (  SELECT 1
			  FROM tbItemDocumento
   			  INNER JOIN tbDocumento ON
				tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbDocumento.CodigoLocal = @CodigoLocal AND 
				tbDocumento.EntradaSaidaDocumento = 'S' AND
				tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
				tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
				tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
				tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
				WHERE
				tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbItemDocumento.CodigoLocal = @CodigoLocal AND
				tbItemDocumento.EntradaSaidaDocumento = 'S' AND
				tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
				tbDocumento.EspecieDocumento = 'ECF' AND
				tbDocumento.CondicaoNFCancelada = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
	
	
	
	
	-- PercentualICMSBase13
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'T' + RIGHT('0000' + REPLACE(CONVERT(VARCHAR(6),PercentualICMSBase13),'.',''),4) + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase13 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF = 'T')),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	CONVERT(NUMERIC(4),PercentualICMSBase13),
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	PercentualICMSBase13 <> 0 AND
	BaseCalculo13ICMSECF <> 0 AND
	EXISTS (  SELECT 1
			  FROM tbItemDocumento
   			  INNER JOIN tbDocumento ON
				tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbDocumento.CodigoLocal = @CodigoLocal AND 
				tbDocumento.EntradaSaidaDocumento = 'S' AND
				tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
				tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
				tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
				tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
				WHERE
				tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbItemDocumento.CodigoLocal = @CodigoLocal AND
				tbItemDocumento.EntradaSaidaDocumento = 'S' AND
				tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
				tbDocumento.EspecieDocumento = 'ECF' AND
				tbDocumento.CondicaoNFCancelada = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
	
	
	
	
	-- PercentualICMSBase14
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'T' + RIGHT('0000' + REPLACE(CONVERT(VARCHAR(6),PercentualICMSBase14),'.',''),4) + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase14 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF = 'T')),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	CONVERT(NUMERIC(4),PercentualICMSBase14),
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	PercentualICMSBase14 <> 0 AND
	BaseCalculo14ICMSECF <> 0 AND
	EXISTS (  SELECT 1
			  FROM tbItemDocumento
   			  INNER JOIN tbDocumento ON
				tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbDocumento.CodigoLocal = @CodigoLocal AND 
				tbDocumento.EntradaSaidaDocumento = 'S' AND
				tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
				tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
				tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
				tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
				WHERE
				tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbItemDocumento.CodigoLocal = @CodigoLocal AND
				tbItemDocumento.EntradaSaidaDocumento = 'S' AND
				tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
				tbDocumento.EspecieDocumento = 'ECF' AND
				tbDocumento.CondicaoNFCancelada = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
	
	
	
	
	-- F1 (Substituição Tributária)
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'F1' + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumentoFT.SerieECFDocFT = tbMapaECF.NumeroSerieFabricacaoECF AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									( tbItemDocumento.ValorBaseICMS3ItemDocto <> 0 ) AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF = 'F')),'.',','),'0,00') + '|' +
	'|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	200,
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	SubstituicaoTributECF <> 0 AND
	EXISTS 
	( SELECT 1 FROM tbItemDocumento 
	INNER JOIN tbDocumento ON
	tbDocumento.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND
	tbDocumento.CodigoLocal = tbItemDocumento.CodigoLocal AND 
	tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
	tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
	tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
	tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
	tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
   INNER JOIN tbDocumentoFT (NOLOCK) ON
	tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
	tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
	tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
	tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
	tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
	tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
	tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
	vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
	vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
	vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
	vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
	vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento	
	WHERE
	tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
	tbItemDocumento.CodigoLocal = @CodigoLocal AND
	tbItemDocumento.EntradaSaidaDocumento = 'S' AND
	tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
	tbDocumento.EspecieDocumento = 'ECF' AND
	tbDocumentoFT.SerieECFDocFT = tbMapaECF.NumeroSerieFabricacaoECF AND	
	tbDocumento.CondicaoNFCancelada = 'F' AND
	( tbItemDocumento.ValorBaseICMS3ItemDocto <> 0 ) AND
	tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
	vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
	vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
	vwPedidoEmissaoCupomFiscal.TributacaoECF = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
	
	-- I1 (Isento)
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'I1' + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumentoFT.SerieECFDocFT = tbMapaECF.NumeroSerieFabricacaoECF AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									( tbItemDocumento.ValorBaseICMS2ItemDocto <> 0 ) AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF IN ('I','S'))),'.',','),'0,00') + '|' +
	'|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	300,
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	( IsentaICMSECF + ValorTotalISSECF ) <> 0 AND
	EXISTS (  SELECT 1
			  FROM tbItemDocumento
   			  INNER JOIN tbDocumento ON
				tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbDocumento.CodigoLocal = @CodigoLocal AND 
				tbDocumento.EntradaSaidaDocumento = 'S' AND
				tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
				tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
				tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
				tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
				WHERE
				tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbItemDocumento.CodigoLocal = @CodigoLocal AND
				tbItemDocumento.EntradaSaidaDocumento = 'S' AND
				tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
				tbDocumento.EspecieDocumento = 'ECF' AND
				tbDocumento.CondicaoNFCancelada = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'


	
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'N1' + '|' +
	COALESCE(REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(ValorContabilItemDocto)
								  FROM tbItemDocumento
					   			  INNER JOIN tbDocumento ON
									tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbDocumento.CodigoLocal = @CodigoLocal AND 
									tbDocumento.EntradaSaidaDocumento = 'S' AND
									tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
									tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
									tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
									tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
								   INNER JOIN tbDocumentoFT (NOLOCK) ON
									tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND 
									tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
									tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
									tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
									tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
									tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao									
								   INNER JOIN vwPedidoEmissaoCupomFiscal (NOLOCK) ON
									vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
									vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
									vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
									vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
									vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									(tbItemDocumento.ValorBaseICMS2ItemDocto <> 0 OR tbItemDocumento.ValorBaseICMS3ItemDocto <> 0) AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0 AND
									vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento AND
									vwPedidoEmissaoCupomFiscal.ItemCancelado = 'F' AND
									vwPedidoEmissaoCupomFiscal.TributacaoECF = 'N' )),'.',','),'0,00') + '|' +
	'|' +
	'|',
	'C420',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	0,
	DataMapaECF,
	200,
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbMapaECF
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	DataMapaECF between @DataInicial AND @DataFinal AND
	NaoTributadaICMSECF <> 0 AND
	EXISTS (  SELECT 1
			  FROM tbItemDocumento
   			  INNER JOIN tbDocumento ON
				tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbDocumento.CodigoLocal = @CodigoLocal AND 
				tbDocumento.EntradaSaidaDocumento = 'S' AND
				tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
				tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
				tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
				tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
				WHERE
				tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
				tbItemDocumento.CodigoLocal = @CodigoLocal AND
				tbItemDocumento.EntradaSaidaDocumento = 'S' AND
				tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
				tbDocumento.EspecieDocumento = 'ECF' AND
				tbDocumento.CondicaoNFCancelada = 'F' ) AND
	NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
	
	
	

END
ELSE
BEGIN

	IF @UFLocal = 'RN'
	BEGIN
	
		INSERT rtSPEDFiscal
		SELECT
		@@spid,
		'|C405|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,DataMapaECF)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,DataMapaECF)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,DataMapaECF)),'') + '|'
	+	RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),CRO))),3) + '|'
	+	RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),ContadorReducaoZECF))),6) + '|'
	+	RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(9),CupomReducaoZECF))),9) + '|'
	+	REPLACE(CONVERT(VARCHAR(16),sum(GranTotalFimDiaECF)),'.',',') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),SUM(ValorContabilDocumento)),'.',',') + '|',
		'C405',
		MIN(tbDocumentoFT.SerieECFDocFT),
		0,
		DataMapaECF,
		300,
		0,
		13, --datepart(day,tbDocumento.DataDocumento),
		'',
		0,
		'',
		0
		FROM tbDocumento (NOLOCK)
		INNER JOIN tbCliFor (NOLOCK) ON
				   tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
				   tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
		INNER JOIN tbDocumentoFT (NOLOCK) ON
				   tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
				   tbDocumentoFT.CodigoLocal = @CodigoLocal AND
				   tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
				   tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND
				   tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
				   tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
				   tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao 
		INNER JOIN tbMapaECF (NOLOCK) ON
				   tbMapaECF.CodigoEmpresa = @CodigoEmpresa AND 
				   tbMapaECF.CodigoLocal = @CodigoLocal AND
				   tbMapaECF.DataMapaECF = tbDocumento.DataDocumento AND
				   tbMapaECF.NumeroSerieFabricacaoECF = tbDocumentoFT.SerieECFDocFT
		LEFT JOIN tbCliForFisica (NOLOCK) ON
				  tbCliForFisica.CodigoEmpresa = @CodigoEmpresa AND
				  tbCliForFisica.CodigoCliFor = tbDocumento.CodigoCliFor
		LEFT JOIN tbCliForJuridica (NOLOCK) ON
				  tbCliForJuridica.CodigoEmpresa = @CodigoEmpresa AND
				  tbCliForJuridica.CodigoCliFor = tbDocumento.CodigoCliFor
		WHERE
		tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
		tbDocumento.CodigoLocal = @CodigoLocal AND
		tbDocumento.EntradaSaidaDocumento = 'S' AND
		tbDocumento.DataDocumento between @DataInicial AND @DataFinal AND
		tbDocumento.EspecieDocumento = 'ECF' AND
		tbDocumento.TipoLancamentoMovimentacao = 7 AND
		tbDocumento.CondicaoNFCancelada = 'F' AND
		NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
		GROUP BY
		tbMapaECF.NumeroMapaECF,
		DataMapaECF,
		CRO,
		tbMapaECF.NumeroSerieFabricacaoECF,
		ContadorReducaoZECF,
		CupomReducaoZECF
			
	END
	
	IF @UFLocal <> 'RN'
	BEGIN
		INSERT rtSPEDFiscal
		SELECT
		@@spid,
		'|C405|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,DataMapaECF)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,DataMapaECF)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,DataMapaECF)),'') + '|'
	+	RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),CRO))),3) + '|'
	+	RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(8),ContadorReducaoZECF))),6) + '|'
	+	RIGHT(RTRIM(LTRIM(CONVERT(VARCHAR(9),CupomReducaoZECF))),9) + '|'
	+	REPLACE(CONVERT(VARCHAR(16),sum(GranTotalFimDiaECF)),'.',',') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),SUM(ValorContabilDocumento)),'.',',') + '|',
		'C405',
		MIN(tbDocumentoFT.SerieECFDocFT),
		0,
		DataMapaECF,
		300,
		0,
		13, --datepart(day,tbDocumento.DataDocumento),
		'',
		0,
		'',
		0
		FROM tbDocumento (NOLOCK)
		INNER JOIN tbCliFor (NOLOCK) ON
				   tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
				   tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
		INNER JOIN tbDocumentoFT (NOLOCK) ON
				   tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
				   tbDocumentoFT.CodigoLocal = @CodigoLocal AND
				   tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
				   tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND
				   tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
				   tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
				   tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao 
		INNER JOIN tbMapaECF (NOLOCK) ON
				   tbMapaECF.CodigoEmpresa = @CodigoEmpresa AND 
				   tbMapaECF.CodigoLocal = @CodigoLocal AND
				   tbMapaECF.DataMapaECF = tbDocumento.DataDocumento AND
				   tbMapaECF.NumeroSerieFabricacaoECF = tbDocumentoFT.SerieECFDocFT
		LEFT JOIN tbCliForFisica (NOLOCK) ON
				  tbCliForFisica.CodigoEmpresa = @CodigoEmpresa AND
				  tbCliForFisica.CodigoCliFor = tbDocumento.CodigoCliFor
		LEFT JOIN tbCliForJuridica (NOLOCK) ON
				  tbCliForJuridica.CodigoEmpresa = @CodigoEmpresa AND
				  tbCliForJuridica.CodigoCliFor = tbDocumento.CodigoCliFor
		WHERE
		tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
		tbDocumento.CodigoLocal = @CodigoLocal AND
		tbDocumento.EntradaSaidaDocumento = 'S' AND
		tbDocumento.DataDocumento between @DataInicial AND @DataFinal AND
		tbDocumento.EspecieDocumento = 'ECF' AND
		tbDocumento.TipoLancamentoMovimentacao = 7 AND
		tbDocumento.CondicaoNFCancelada = 'F' AND
		NumeroSerieFabricacaoECF NOT LIKE 'DJ%'
		GROUP BY
		tbMapaECF.NumeroMapaECF,
		CupomReducaoZECF,
		DataMapaECF,
		ContadorReducaoZECF,
		tbMapaECF.NumeroSerieFabricacaoECF,
		CRO
	END
	
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C410|' + 
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorPISDocumento)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorFinsocialDocumento)),'.',',') + '|',
	'C410',
	RTRIM(LTRIM(SerieECFDocFT)),
	0,
	tbDocumento.DataDocumento,
	300,
	0,
	13, ---datepart(day,tbDocumento.DataDocumento),
	'',
	0,
	'',
	0
	FROM tbDocumento (NOLOCK)
	INNER JOIN tbDocumentoFT (NOLOCK) ON
               tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
               tbDocumentoFT.CodigoLocal = @CodigoLocal AND
               tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
               tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND
               tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
               tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
               tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao 
	WHERE
	tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
	tbDocumento.CodigoLocal = @CodigoLocal AND
	tbDocumento.DataDocumento between @DataInicial AND @DataFinal AND
	tbDocumento.EspecieDocumento = 'ECF' AND
    tbDocumento.TipoLancamentoMovimentacao = 7 AND
	tbDocumento.CondicaoNFCancelada = 'F' AND
	EXISTS ( SELECT 1 FROM tbMapaECF 
			 WHERE
			 tbMapaECF.CodigoEmpresa = @CodigoEmpresa AND
			 tbMapaECF.CodigoLocal = @CodigoLocal AND
			 tbMapaECF.DataMapaECF = tbDocumento.DataDocumento AND
			 tbMapaECF.NumeroSerieFabricacaoECF = tbDocumentoFT.SerieECFDocFT AND
			 NumeroSerieFabricacaoECF NOT LIKE 'DJ%')
	GROUP BY
		tbDocumento.DataDocumento,
		tbDocumentoFT.SerieECFDocFT

	DELETE rtSPEDFiscal
	WHERE
	Spid = @@spid AND
	TipoRegistro = 'C410' AND
	( Linha is NULL or Linha = '|C410|||' )

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'T' + RIGHT('0000' + REPLACE(CONVERT(VARCHAR(6),PercentualICMSItemDocto),'.',''),4) + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorBaseICMS1ItemDocto)),'.',',') + '|' +
	'0|' +
	'|',
	'C420',
	RTRIM(LTRIM(SerieECFDocFT)),
	0,
	tbDocumento.DataDocumento,
	300,
	0,
	13, --DATEPART(DAY,tbDocumento.DataDocumento),
	'',
	0,
	'',
	0
	FROM tbItemDocumento (NOLOCK)
	INNER JOIN tbDocumento (NOLOCK) ON
               tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
               tbDocumento.CodigoLocal = @CodigoLocal AND
               tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
               tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND
               tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
               tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	INNER JOIN tbDocumentoFT (NOLOCK) ON
               tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
               tbDocumentoFT.CodigoLocal = @CodigoLocal AND
               tbDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   tbDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
               tbDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
               tbDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
               tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	WHERE
	tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
	tbItemDocumento.CodigoLocal = @CodigoLocal AND
	tbItemDocumento.EntradaSaidaDocumento = 'S' AND
	tbItemDocumento.DataDocumento between @DataInicial AND @DataFinal AND
	tbDocumento.EspecieDocumento = 'ECF' AND
    tbItemDocumento.TipoLancamentoMovimentacao = 7 AND
	tbDocumento.CondicaoNFCancelada = 'F' AND
	tbItemDocumento.PercentualICMSItemDocto <> 0 AND
	tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
	SerieECFDocFT NOT LIKE 'DJ%'
	GROUP BY
	tbDocumento.NumeroDocumento,
	tbDocumento.DataDocumento,
	tbItemDocumento.PercentualICMSItemDocto,
    tbDocumentoFT.SerieECFDocFT

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'F1' + '|' +
	REPLACE(CONVERT(VARCHAR(16),sum(tbItemDocumento.ValorICMSSubstTribItemDocto)),'.',',') + '|' +
	'|' +
	'|',
	'C420',
	RTRIM(LTRIM(SerieECFDocFT)),
	0,
	tbItemDocumento.DataDocumento,
	300,
	0,
	13, --DATEPART(DAY,tbItemDocumento.DataDocumento),
	'',
	0,
	'',
	0
	FROM tbItemDocumento
	INNER JOIN tbDocumento (NOLOCK) ON
               tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
               tbDocumento.CodigoLocal = @CodigoLocal AND
               tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
               tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND
               tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
               tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	INNER JOIN tbDocumentoFT (NOLOCK) ON
               tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
               tbDocumentoFT.CodigoLocal = @CodigoLocal AND
               tbDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   tbDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
               tbDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
               tbDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
               tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	WHERE
	tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
	tbItemDocumento.CodigoLocal = @CodigoLocal AND
	tbItemDocumento.DataDocumento between @DataInicial AND @DataFinal AND
	tbItemDocumento.EntradaSaidaDocumento = 'S' AND
	tbDocumento.EspecieDocumento = 'ECF' AND
    tbItemDocumento.TipoLancamentoMovimentacao = 7 AND
	tbItemDocumento.ValorICMSSubstTribItemDocto <> 0 AND
	tbDocumento.CondicaoNFCancelada = 'F' AND
	tbItemDocumento.QtdeLancamentoItemDocto <> 0 AND
	SerieECFDocFT NOT LIKE 'DJ%'
	GROUP BY
	tbItemDocumento.NumeroDocumento,
	tbItemDocumento.DataDocumento,
	tbDocumentoFT.SerieECFDocFT

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'I1' + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorContabilItemDocto)),'.',',') + '|' +
	'|' +
	'|',
	'C420',
	RTRIM(LTRIM(SerieECFDocFT)),
	0,
	tbItemDocumento.DataDocumento,
	300,
	0,
	13, --DATEPART(DAY,tbItemDocumento.DataDocumento),
	'',
	0,
	'',
	0
	FROM tbItemDocumento
	INNER JOIN tbDocumento (NOLOCK) ON
               tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
               tbDocumento.CodigoLocal = @CodigoLocal AND
               tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
               tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND
               tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
               tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	INNER JOIN tbDocumentoFT (NOLOCK) ON
               tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
               tbDocumentoFT.CodigoLocal = @CodigoLocal AND
               tbDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   tbDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
               tbDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
               tbDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
               tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	WHERE
	tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
	tbItemDocumento.CodigoLocal = @CodigoLocal AND
	tbItemDocumento.DataDocumento between @DataInicial AND @DataFinal AND
	tbItemDocumento.EntradaSaidaDocumento = 'S' AND
	tbDocumento.EspecieDocumento = 'ECF' AND
    tbItemDocumento.TipoLancamentoMovimentacao = 7 AND
	tbDocumento.CondicaoNFCancelada = 'F' AND
	tbItemDocumento.QtdeLancamentoItemDocto <> 0 AND
	( tbItemDocumento.ValorBaseICMS2ItemDocto <> 0 OR tbItemDocumento.ValorBaseICMS3ItemDocto <> 0 ) AND
	SerieECFDocFT NOT LIKE 'DJ%'
	GROUP BY 
	tbItemDocumento.DataDocumento,
	SerieECFDocFT
	
END

INSERT rtSPEDFiscal
SELECT
@@spid,
'|C460|' + 
'02|' +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'02'
	WHEN tbDocumento.CondicaoComplementoICMSDocto = 'V' THEN
		'06'
	ELSE
		'00'
END + '|' +
CASE WHEN @UFLocal = 'RN' THEN 
	CONVERT(VARCHAR(9),tbDocumento.NumeroNFDocumento) 
ELSE
	CONVERT(VARCHAR(9),tbDocumento.NumeroDocumento) 
END + '|' +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDocumento.DataDocumento)),2,2) +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDocumento.DataDocumento)),2,2) +
CONVERT(CHAR(4),DATEPART(year,tbDocumento.DataDocumento)) + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorContabilDocumento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorPISDocumento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorFinsocialDocumento),'.',',') + '|' +
RTRIM(COALESCE(tbClienteEventual.CGCCliEven,tbClienteEventual.CPFCliEven,tbCliForFisica.CPFFisica,tbCliForJuridica.CGCJuridica)) + '|' +
RTRIM(COALESCE(tbClienteEventual.NomeCliEven,tbCliFor.NomeCliFor)) + '|',
'C460',
RTRIM(LTRIM(SerieECFDocFT)),
CASE WHEN @UFLocal = 'RN' THEN 
	CONVERT(VARCHAR(9),tbDocumento.NumeroNFDocumento) 
ELSE
	CONVERT(VARCHAR(9),tbDocumento.NumeroDocumento) 
END,
tbDocumento.DataDocumento,
300,
0,
13, --datepart(day,tbDocumento.DataDocumento),
'',
0,
'',
0
FROM tbDocumento (NOLOCK)
INNER JOIN tbCliFor (NOLOCK) ON
           tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
           tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
INNER JOIN tbDocumentoFT (NOLOCK) ON
           tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumentoFT.CodigoLocal = @CodigoLocal AND
           tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
		   tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
           tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND
           tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
           tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao
LEFT JOIN tbCliForFisica (NOLOCK) ON
          tbCliForFisica.CodigoEmpresa = @CodigoEmpresa AND
          tbCliForFisica.CodigoCliFor = tbDocumento.CodigoCliFor
LEFT JOIN tbCliForJuridica (NOLOCK) ON
          tbCliForJuridica.CodigoEmpresa = @CodigoEmpresa AND
          tbCliForJuridica.CodigoCliFor = tbDocumento.CodigoCliFor
LEFT JOIN tbClienteEventual (NOLOCK) ON
          tbClienteEventual.CodigoEmpresa = @CodigoEmpresa AND
          tbClienteEventual.CodigoClienteEventual = tbDocumentoFT.CodigoClienteEventual
WHERE
tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbDocumento.CodigoLocal = @CodigoLocal AND
tbDocumento.EntradaSaidaDocumento = 'S' AND
tbDocumento.DataDocumento between @DataInicial AND @DataFinal AND
tbDocumento.EspecieDocumento = 'ECF' AND
tbDocumento.TipoLancamentoMovimentacao = 7 AND
tbDocumento.CondicaoNFCancelada = 'F' AND
@Perfil = 'A' AND
SerieECFDocFT NOT LIKE 'DJ%'

INSERT rtSPEDFiscal
SELECT
@@spid,
'|C470|' + 
RTRIM(LTRIM(CONVERT(VARCHAR(30),
	CASE 	
	WHEN tbItemDocumento.CodigoProduto is not null THEN
		tbItemDocumento.CodigoProduto
	WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
		tbItemDocumento.CodigoMaoObraOS
	WHEN tbVeiculoCV.NumeroChassisCV is not null THEN
		tbVeiculoCV.NumeroChassisCV
	WHEN tbItemDocumento.CodigoItemDocto is not null THEN
		tbItemDocumento.CodigoItemDocto
	ELSE
		CASE WHEN MAX(tbItemDocumento.TipoLancamentoMovimentacao) = 10 THEN
			'OUTRAS'
		ELSE
			'USOCONSUMO'
		END
END))) + '|' +
REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),SUM(tbItemDocumento.QtdeLancamentoItemDocto))),'.',',') + '|' +
'|' +
RTRIM(LTRIM(CASE 	
	WHEN tbItemDocumento.CodigoProduto is not null THEN
		tbProdutoFT.CodigoUnidadeProduto
	WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
		'HR'
	WHEN tbItemDocumento.NumeroVeiculoCV is not null THEN
		'UN'
	WHEN tbItemDocumento.CodigoItemDocto is not null THEN
		'UN'
	ELSE
		'UN'
END)) + '|' +
REPLACE(CONVERT(VARCHAR(16),SUM(ValorContabilItemDocto)),'.',',') + '|' +
RIGHT('000' + RTRIM(LTRIM(COALESCE(tbItemDocumentoFT.CodigoTributacaoItDocFT,CNOItem.CodigoTributacaoNaturezaOper,'000'))),3) + '|' +
CONVERT(VARCHAR(4),CASE WHEN @UFLocal = 'RN' THEN 5405 ELSE
						CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
							CONVERT(VARCHAR(4),tbLocalLF.CodigoCFOECF)
						ELSE
							MIN(tbItemDocumento.CodigoCFO)
						END
					END) + '|' + 
REPLACE(CONVERT(VARCHAR(16),PercentualICMSItemDocto),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(ValorPISItemDocto)),'.',',') + '|' +
COALESCE(REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumentoFT.ValorCOFINSItDocFT)),'.',','),'0,00') + '|',
'C470',
RTRIM(LTRIM(SerieECFDocFT)),
CASE WHEN @UFLocal = 'RN' THEN 
	CONVERT(VARCHAR(9),tbDocumento.NumeroNFDocumento) 
ELSE
	CONVERT(VARCHAR(9),tbItemDocumento.NumeroDocumento) 
END,
tbItemDocumento.DataDocumento,
300,
0,
13, --datepart(day,tbItemDocumento.DataDocumento),
CASE
	WHEN tbItemDocumento.CodigoProduto is not null THEN
		tbItemDocumento.CodigoProduto
	WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
		tbItemDocumento.CodigoMaoObraOS
	WHEN tbVeiculoCV.NumeroChassisCV is not null THEN
		tbVeiculoCV.NumeroChassisCV
	WHEN tbItemDocumento.CodigoItemDocto is not null THEN
		tbItemDocumento.CodigoItemDocto
	ELSE
		CASE WHEN MAX(tbItemDocumento.TipoLancamentoMovimentacao) = 10 THEN
			'OUTRAS'
		ELSE
			'USOCONSUMO'
		END
END,
0,
CASE 	
	WHEN tbItemDocumento.CodigoProduto is not null THEN
		tbProdutoFT.CodigoUnidadeProduto
	WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
		'HR'
	WHEN tbItemDocumento.NumeroVeiculoCV is not null THEN
		'UN'
	WHEN tbItemDocumento.CodigoItemDocto is not null THEN
		'UN'
	ELSE
		'UN'
END,
0
FROM tbItemDocumento
INNER JOIN tbDocumento ON
           tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumento.CodigoLocal = @CodigoLocal AND 
           tbDocumento.EntradaSaidaDocumento = 'S' AND
           tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
           tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
INNER JOIN tbDocumentoFT ON
           tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumentoFT.CodigoLocal = @CodigoLocal AND 
           tbDocumentoFT.EntradaSaidaDocumento = 'S' AND
           tbDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND  
           tbDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
LEFT JOIN tbItemDocumentoFT (NOLOCK) ON
           tbItemDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
           tbItemDocumentoFT.CodigoLocal = @CodigoLocal AND
           tbItemDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
           tbItemDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
           tbItemDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbItemDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbItemDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND
           tbItemDocumentoFT.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento
LEFT JOIN tbNaturezaOperacao CNOItem (NOLOCK) ON
			CNOItem.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND
			CNOItem.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao
LEFT JOIN tbProdutoFT ON
          tbProdutoFT.CodigoEmpresa = @CodigoEmpresa AND
          tbProdutoFT.CodigoProduto = tbItemDocumento.CodigoProduto 
LEFT JOIN tbVeiculoCV ON
          tbVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
          tbVeiculoCV.CodigoLocal = @CodigoLocal AND
          tbVeiculoCV.NumeroVeiculoCV = tbItemDocumento.NumeroVeiculoCV
INNER JOIN tbLocal (NOLOCK) ON
		   tbLocal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
		   tbLocal.CodigoLocal = tbDocumento.CodigoLocal
INNER JOIN tbLocalLF (NOLOCK) ON
		   tbLocalLF.CodigoEmpresa = tbLocal.CodigoEmpresa AND
		   tbLocalLF.CodigoLocal = tbLocal.CodigoLocal
INNER JOIN tbCliFor (NOLOCK) ON
		   tbCliFor.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
		   tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
INNER JOIN tbPercentual (NOLOCK) ON
		   tbPercentual.UFDestino = tbCliFor.UFCliFor AND
		   tbPercentual.UFOrigem = tbLocal.UFLocal
WHERE
tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbItemDocumento.CodigoLocal = @CodigoLocal AND
tbItemDocumento.EntradaSaidaDocumento = 'S' AND
tbItemDocumento.DataDocumento between @DataInicial AND @DataFinal AND
tbDocumento.EspecieDocumento = 'ECF' AND
tbItemDocumento.TipoLancamentoMovimentacao = 7 AND
--tbItemDocumento.ValorICMSSubstTribItemDocto = 0 AND
tbDocumento.CondicaoNFCancelada = 'F' AND
tbItemDocumento.QtdeLancamentoItemDocto <> 0 AND
@Perfil = 'A' AND
SerieECFDocFT NOT LIKE 'DJ%'
GROUP BY
tbItemDocumento.NumeroDocumento,
tbItemDocumento.CodigoProduto,
tbItemDocumento.CodigoMaoObraOS,
tbVeiculoCV.NumeroChassisCV,
tbItemDocumento.CodigoItemDocto,
tbProdutoFT.CodigoUnidadeProduto,
tbItemDocumento.NumeroVeiculoCV,
tbItemDocumento.DataDocumento,
tbItemDocumento.PercentualICMSItemDocto,
tbItemDocumentoFT.CodigoTributacaoItDocFT,
CNOItem.CodigoTributacaoNaturezaOper,
tbDocumento.EspecieDocumento,
tbPercentual.CFOSaidaUF,
tbLocalLF.CodigoCFOECF,
CASE WHEN @UFLocal = 'RN' THEN 5405 ELSE
	CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
		tbLocalLF.CodigoCFOECF
	ELSE
		tbItemDocumento.CodigoCFO
	END
END,
SerieECFDocFT,
tbDocumento.NumeroNFDocumento

---- 

INSERT rtSPEDFiscal
SELECT
@@spid,
'|C425|' + 
RTRIM(LTRIM(CONVERT(VARCHAR(30),
	CASE 	
	WHEN tbItemDocumento.CodigoProduto is not null THEN
		tbItemDocumento.CodigoProduto
	WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
		tbItemDocumento.CodigoMaoObraOS
	WHEN tbVeiculoCV.NumeroChassisCV is not null THEN
		tbVeiculoCV.NumeroChassisCV
	WHEN tbItemDocumento.CodigoItemDocto is not null THEN
		tbItemDocumento.CodigoItemDocto
	ELSE
		CASE WHEN MAX(tbItemDocumento.TipoLancamentoMovimentacao) = 10 THEN
			'OUTRAS'
		ELSE
			'USOCONSUMO'
		END
END))) + '|' +
REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),SUM(tbItemDocumento.QtdeLancamentoItemDocto))),'.',',') + '|' +
RTRIM(LTRIM(CASE 	
	WHEN tbItemDocumento.CodigoProduto is not null THEN
		COALESCE(tbProdutoFT.CodigoUnidadeProduto,'UN')
	WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
		'HR'
	WHEN tbItemDocumento.NumeroVeiculoCV is not null THEN
		'UN'
	WHEN tbItemDocumento.CodigoItemDocto is not null THEN
		'UN'
	ELSE
		'UN'
END)) + '|' +
REPLACE(CONVERT(VARCHAR(16),SUM(ValorContabilItemDocto)),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),SUM(ValorPISItemDocto)),'.',',') + '|' +
COALESCE(REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumentoFT.ValorCOFINSItDocFT)),'.',','),'0,00') + '|',
'C425',
RTRIM(LTRIM(SerieECFDocFT)),
0,
tbItemDocumento.DataDocumento,
CASE
	WHEN sum(ValorBaseICMS1ItemDocto) <> 0 THEN
		MIN(CONVERT(NUMERIC(4),PercentualICMSItemDocto))
	WHEN vwPedidoEmissaoCupomFiscal.TributacaoECF = 'F' THEN
		200
	WHEN vwPedidoEmissaoCupomFiscal.TributacaoECF IN ('I','S') THEN
		300
	WHEN vwPedidoEmissaoCupomFiscal.TributacaoECF = 'N' THEN
		400
	ELSE
		400
END,
0,
13,
CASE
	WHEN tbItemDocumento.CodigoProduto is not null THEN
		tbItemDocumento.CodigoProduto
	WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
		tbItemDocumento.CodigoMaoObraOS
	WHEN tbVeiculoCV.NumeroChassisCV is not null THEN
		tbVeiculoCV.NumeroChassisCV
	WHEN tbItemDocumento.CodigoItemDocto is not null THEN
		tbItemDocumento.CodigoItemDocto
	ELSE
		CASE WHEN MAX(tbItemDocumento.TipoLancamentoMovimentacao) = 10 THEN
			'OUTRAS'
		ELSE
			'USOCONSUMO'
		END
END,
0,
CASE 	
	WHEN tbItemDocumento.CodigoProduto is not null THEN
		COALESCE(tbProdutoFT.CodigoUnidadeProduto,'UN')
	WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
		'HR'
	WHEN tbItemDocumento.NumeroVeiculoCV is not null THEN
		'UN'
	WHEN tbItemDocumento.CodigoItemDocto is not null THEN
		'UN'
	ELSE
		'UN'
END,
0
FROM tbItemDocumento
INNER JOIN tbDocumento ON
           tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumento.CodigoLocal = @CodigoLocal AND 
           tbDocumento.EntradaSaidaDocumento = 'S' AND
           tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
           tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
INNER JOIN tbDocumentoFT ON
           tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumentoFT.CodigoLocal = @CodigoLocal AND 
           tbDocumentoFT.EntradaSaidaDocumento = 'S' AND
           tbDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND  
           tbDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
INNER JOIN	vwPedidoEmissaoCupomFiscal (NOLOCK) ON
			vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
			vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
			vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
			vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
			vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento AND
			vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento
			
LEFT JOIN tbItemDocumentoFT (NOLOCK) ON
           tbItemDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
           tbItemDocumentoFT.CodigoLocal = @CodigoLocal AND
           tbItemDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
           tbItemDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
           tbItemDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbItemDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbItemDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND
           tbItemDocumentoFT.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento
LEFT JOIN tbProdutoFT ON
          tbProdutoFT.CodigoEmpresa = @CodigoEmpresa AND
          tbProdutoFT.CodigoProduto = tbItemDocumento.CodigoProduto 
LEFT JOIN tbVeiculoCV ON
          tbVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
          tbVeiculoCV.CodigoLocal = @CodigoLocal AND
          tbVeiculoCV.NumeroVeiculoCV = tbItemDocumento.NumeroVeiculoCV
WHERE
tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbItemDocumento.CodigoLocal = @CodigoLocal AND
tbItemDocumento.EntradaSaidaDocumento = 'S' AND
tbItemDocumento.DataDocumento between @DataInicial AND @DataFinal AND
tbDocumento.EspecieDocumento = 'ECF' AND
tbDocumento.TipoLancamentoMovimentacao = 7 AND
tbItemDocumento.ValorICMSSubstTribItemDocto = 0 AND
tbDocumento.CondicaoNFCancelada = 'F' AND
tbItemDocumento.QtdeLancamentoItemDocto <> 0 AND
@Perfil <> 'A' AND
SerieECFDocFT NOT LIKE 'DJ%'
GROUP BY
tbItemDocumento.CodigoProduto,
tbItemDocumento.CodigoMaoObraOS,
tbVeiculoCV.NumeroChassisCV,
tbItemDocumento.CodigoItemDocto,
tbProdutoFT.CodigoUnidadeProduto,
tbItemDocumento.NumeroVeiculoCV,
tbItemDocumento.DataDocumento,
tbItemDocumento.PercentualICMSItemDocto,
tbDocumentoFT.SerieECFDocFT,
vwPedidoEmissaoCupomFiscal.TributacaoECF


INSERT rtSPEDFiscal
SELECT
@@spid,
'|C425|' + 
RTRIM(LTRIM(CONVERT(VARCHAR(30),
	CASE 	
	WHEN tbItemDocumento.CodigoProduto is not null THEN
		tbItemDocumento.CodigoProduto
	WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
		tbItemDocumento.CodigoMaoObraOS
	WHEN tbVeiculoCV.NumeroChassisCV is not null THEN
		tbVeiculoCV.NumeroChassisCV
	WHEN tbItemDocumento.CodigoItemDocto is not null THEN
		tbItemDocumento.CodigoItemDocto
	ELSE
		CASE WHEN MAX(tbItemDocumento.TipoLancamentoMovimentacao) = 10 THEN
			'OUTRAS'
		ELSE
			'USOCONSUMO'
		END
END))) + '|' +
REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),SUM(tbItemDocumento.QtdeLancamentoItemDocto))),'.',',') + '|' +
RTRIM(LTRIM(CASE 	
	WHEN tbItemDocumento.CodigoProduto is not null THEN
		COALESCE(tbProdutoFT.CodigoUnidadeProduto,'UN')
	WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
		'HR'
	WHEN tbItemDocumento.NumeroVeiculoCV is not null THEN
		'UN'
	WHEN tbItemDocumento.CodigoItemDocto is not null THEN
		'UN'
	ELSE
		'UN'
END)) + '|' +
REPLACE(CONVERT(VARCHAR(16),SUM(ValorContabilItemDocto)),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),SUM(ValorPISItemDocto)),'.',',') + '|' +
COALESCE(REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumentoFT.ValorCOFINSItDocFT)),'.',','),'0,00') + '|',
'C425',
RTRIM(LTRIM(SerieECFDocFT)),
0,
tbItemDocumento.DataDocumento,
CASE
	WHEN sum(ValorBaseICMS1ItemDocto) <> 0 THEN
		MIN(CONVERT(NUMERIC(4),PercentualICMSItemDocto))
	WHEN vwPedidoEmissaoCupomFiscal.TributacaoECF = 'F' THEN
		200
	WHEN vwPedidoEmissaoCupomFiscal.TributacaoECF IN ('I','S') THEN
		300
	WHEN vwPedidoEmissaoCupomFiscal.TributacaoECF = 'N' THEN
		400
	ELSE
		400 
END,
0,
13,
CASE
	WHEN tbItemDocumento.CodigoProduto is not null THEN
		tbItemDocumento.CodigoProduto
	WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
		tbItemDocumento.CodigoMaoObraOS
	WHEN tbVeiculoCV.NumeroChassisCV is not null THEN
		tbVeiculoCV.NumeroChassisCV
	WHEN tbItemDocumento.CodigoItemDocto is not null THEN
		tbItemDocumento.CodigoItemDocto
	ELSE
		CASE WHEN MAX(tbItemDocumento.TipoLancamentoMovimentacao) = 10 THEN
			'OUTRAS'
		ELSE
			'USOCONSUMO'
		END
END,
0,
CASE 	
	WHEN tbItemDocumento.CodigoProduto is not null THEN
		COALESCE(tbProdutoFT.CodigoUnidadeProduto,'UN')
	WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
		'HR'
	WHEN tbItemDocumento.NumeroVeiculoCV is not null THEN
		'UN'
	WHEN tbItemDocumento.CodigoItemDocto is not null THEN
		'UN'
	ELSE
		'UN'
END,
0
FROM tbItemDocumento
INNER JOIN tbDocumento ON
           tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumento.CodigoLocal = @CodigoLocal AND 
           tbDocumento.EntradaSaidaDocumento = 'S' AND
           tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
           tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
INNER JOIN tbDocumentoFT ON
           tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumentoFT.CodigoLocal = @CodigoLocal AND 
           tbDocumentoFT.EntradaSaidaDocumento = 'S' AND
           tbDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND  
           tbDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
INNER JOIN	vwPedidoEmissaoCupomFiscal (NOLOCK) ON
			vwPedidoEmissaoCupomFiscal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
			vwPedidoEmissaoCupomFiscal.CodigoLocal = tbDocumento.CodigoLocal AND 
			vwPedidoEmissaoCupomFiscal.CentroCusto = tbDocumentoFT.CentroCusto AND
			vwPedidoEmissaoCupomFiscal.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
			vwPedidoEmissaoCupomFiscal.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento AND
			vwPedidoEmissaoCupomFiscal.ItemPedido = tbItemDocumento.SequenciaItemDocumento
LEFT JOIN tbItemDocumentoFT (NOLOCK) ON
           tbItemDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
           tbItemDocumentoFT.CodigoLocal = @CodigoLocal AND
           tbItemDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
           tbItemDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
           tbItemDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbItemDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbItemDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND
           tbItemDocumentoFT.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento
LEFT JOIN tbProdutoFT ON
          tbProdutoFT.CodigoEmpresa = @CodigoEmpresa AND
          tbProdutoFT.CodigoProduto = tbItemDocumento.CodigoProduto 
LEFT JOIN tbVeiculoCV ON
          tbVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
          tbVeiculoCV.CodigoLocal = @CodigoLocal AND
          tbVeiculoCV.NumeroVeiculoCV = tbItemDocumento.NumeroVeiculoCV
WHERE
tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbItemDocumento.CodigoLocal = @CodigoLocal AND
tbItemDocumento.EntradaSaidaDocumento = 'S' AND
tbItemDocumento.DataDocumento between @DataInicial AND @DataFinal AND
tbDocumento.EspecieDocumento = 'ECF' AND
tbDocumento.TipoLancamentoMovimentacao = 7 AND
tbItemDocumento.ValorICMSSubstTribItemDocto <> 0 AND
tbDocumento.CondicaoNFCancelada = 'F' AND
tbItemDocumento.QtdeLancamentoItemDocto <> 0 AND
@Perfil <> 'A' AND
SerieECFDocFT NOT LIKE 'DJ%'
GROUP BY
tbItemDocumento.CodigoProduto,
tbItemDocumento.CodigoMaoObraOS,
tbVeiculoCV.NumeroChassisCV,
tbItemDocumento.CodigoItemDocto,
tbProdutoFT.CodigoUnidadeProduto,
tbItemDocumento.NumeroVeiculoCV,
tbItemDocumento.DataDocumento,
tbItemDocumento.PercentualICMSItemDocto,
tbDocumentoFT.SerieECFDocFT,
vwPedidoEmissaoCupomFiscal.TributacaoECF


---- trata C490

IF @Perfil <> 'A' 
BEGIN
	SELECT
	tbItemDocumento.DataDocumento,
	RIGHT('000' + RTRIM(LTRIM(COALESCE(tbItemDocumentoFT.CodigoTributacaoItDocFT,CNOItem.CodigoTributacaoNaturezaOper,'000'))),3) AS CodigoTributacao,
	CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
		tbLocalLF.CodigoCFOECF
	ELSE
		tbItemDocumento.CodigoCFO
	END AS CodigoCFO,
	tbItemDocumento.PercentualICMSItemDocto,
	CONVERT(NUMERIC(16,2),CASE 
		WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
			0.00
		ELSE
			SUM(tbItemDocumento.ValorContabilItemDocto)
	END) AS ValorContabilItemDocto,
	CONVERT(NUMERIC(16,2),CASE 
		WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
			0.00
		ELSE
			SUM(tbItemDocumento.ValorBaseICMS1ItemDocto)
	END) AS ValorBaseICMS1ItemDocto,
	CONVERT(NUMERIC(16,2),CASE 
		WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
			0.00
		ELSE
			SUM(tbItemDocumento.ValorICMSItemDocto)
	END) AS ValorICMSItemDocto,
	tbDocumentoFT.SerieECFDocFT
	INTO #tmpC490
	FROM tbItemDocumento
	INNER JOIN tbDocumento ON
			   tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
			   tbDocumento.CodigoLocal = @CodigoLocal AND 
			   tbDocumento.EntradaSaidaDocumento = 'S' AND
			   tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
			   tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
			   tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	INNER JOIN tbLocal (NOLOCK) ON
			   tbLocal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
			   tbLocal.CodigoLocal = tbDocumento.CodigoLocal
	INNER JOIN tbLocalLF ON
			   tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
			   tbLocalLF.CodigoLocal = @CodigoLocal 
	INNER JOIN tbDocumentoFT ON
			   tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
			   tbDocumentoFT.CodigoLocal = @CodigoLocal AND 
			   tbDocumentoFT.EntradaSaidaDocumento = 'S' AND
			   tbDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND  
			   tbDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
			   tbDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	LEFT JOIN tbItemDocumentoFT (NOLOCK) ON
			   tbItemDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
			   tbItemDocumentoFT.CodigoLocal = @CodigoLocal AND
			   tbItemDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
			   tbItemDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
			   tbItemDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   tbItemDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
			   tbItemDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND
			   tbItemDocumentoFT.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento
	LEFT JOIN tbNaturezaOperacao CNOItem (NOLOCK) ON
				CNOItem.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND
				CNOItem.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao
	LEFT JOIN tbProdutoFT ON
			  tbProdutoFT.CodigoEmpresa = @CodigoEmpresa AND
			  tbProdutoFT.CodigoProduto = tbItemDocumento.CodigoProduto 
	INNER JOIN tbCliFor (NOLOCK) ON
			   tbCliFor.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
			   tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
	INNER JOIN tbPercentual (NOLOCK) ON
			   tbPercentual.UFDestino = tbCliFor.UFCliFor AND
			   tbPercentual.UFOrigem = tbLocal.UFLocal
	WHERE
	tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
	tbItemDocumento.CodigoLocal = @CodigoLocal AND
	tbItemDocumento.EntradaSaidaDocumento = 'S' AND
	tbItemDocumento.DataDocumento between @DataInicial AND @DataFinal AND
	tbDocumento.EspecieDocumento = 'ECF' AND
    tbItemDocumento.TipoLancamentoMovimentacao = 7 AND
	tbDocumento.CondicaoNFCancelada = 'F' AND
	tbItemDocumento.QtdeLancamentoItemDocto <> 0  AND
	SerieECFDocFT NOT LIKE 'DJ%'
	GROUP BY
	tbItemDocumentoFT.CodigoTributacaoItDocFT,
	tbItemDocumento.CodigoCFO,
	CNOItem.CodigoTributacaoNaturezaOper,
	tbItemDocumento.PercentualICMSItemDocto,
	tbLocalLF.TipoImpressaoNFCancelada,
	tbDocumento.CondicaoNFCancelada,
	tbItemDocumento.DataDocumento,
	tbDocumentoFT.SerieECFDocFT,
	tbDocumento.EspecieDocumento,
	tbPercentual.CFOSaidaUF,
	tbLocalLF.CodigoCFOECF

	----

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C490|' +
	RIGHT(('000' + RTRIM(LTRIM(COALESCE(CodigoTributacao,'000')))),3) + '|' +
	CONVERT(VARCHAR(4),CodigoCFO) + '|' +
	REPLACE(CONVERT(VARCHAR(16),PercentualICMSItemDocto),'.',',') + '|' + 
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorContabilItemDocto)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorBaseICMS1ItemDocto)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorICMSItemDocto)),'.',',') + '|' +
	'' + '|',
	'C490',
	RTRIM(LTRIM(SerieECFDocFT)),
	999999,
	DataDocumento,
	500,
	0,
	13,
	'',
	0,
	'',
	0
	FROM #tmpC490
	GROUP BY
	CodigoTributacao,
	CodigoCFO,
	PercentualICMSItemDocto,
	DataDocumento,
	SerieECFDocFT

	DROP TABLE #tmpC490
END
ELSE
BEGIN

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C490|' +
	RIGHT(('000' + RTRIM(LTRIM(COALESCE(tbItemDocumentoFT.CodigoTributacaoItDocFT,'000')))),3) + '|' +
	CONVERT(VARCHAR(4),CASE WHEN @UFLocal = 'RN' THEN 5405 ELSE
		CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
			tbLocalLF.CodigoCFOECF
		ELSE
			MIN(tbItemDocumento.CodigoCFO)
		END
	END) + '|' +
	REPLACE(CONVERT(VARCHAR(16),PercentualICMSItemDocto),'.',',') + '|' + 
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorContabilItemDocto)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorBaseICMS1ItemDocto)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorICMSItemDocto)),'.',',') + '|' +
	'' + '|',
	'C490',
	RTRIM(LTRIM(SerieECFDocFT)),
	999999,
	tbItemDocumento.DataDocumento,
	300,
	0,
	13, --DATEPART(DAY,tbItemDocumento.DataDocumento),
	'',
	0,
	'',
	0
	FROM tbItemDocumento
	INNER JOIN tbDocumento ON
			   tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
			   tbDocumento.CodigoLocal = @CodigoLocal AND 
			   tbDocumento.EntradaSaidaDocumento = 'S' AND
			   tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
			   tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
			   tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	INNER JOIN tbDocumentoFT ON
			   tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
			   tbDocumentoFT.CodigoLocal = @CodigoLocal AND 
			   tbDocumentoFT.EntradaSaidaDocumento = 'S' AND
			   tbDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND  
			   tbDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
			   tbDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	LEFT JOIN tbItemDocumentoFT (NOLOCK) ON
			   tbItemDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
			   tbItemDocumentoFT.CodigoLocal = @CodigoLocal AND
			   tbItemDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
			   tbItemDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
			   tbItemDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   tbItemDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
			   tbItemDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND
			   tbItemDocumentoFT.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento
	LEFT JOIN tbVeiculoCV ON
			  tbVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
			  tbVeiculoCV.CodigoLocal = @CodigoLocal AND
			  tbVeiculoCV.NumeroVeiculoCV = tbItemDocumento.NumeroVeiculoCV
	INNER JOIN tbLocal (NOLOCK) ON
			   tbLocal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
			   tbLocal.CodigoLocal = tbDocumento.CodigoLocal
	INNER JOIN tbLocalLF (NOLOCK) ON
			   tbLocalLF.CodigoEmpresa = tbLocal.CodigoEmpresa AND
			   tbLocalLF.CodigoLocal = tbLocal.CodigoLocal
	INNER JOIN tbCliFor (NOLOCK) ON
			   tbCliFor.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
			   tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
	INNER JOIN tbPercentual (NOLOCK) ON
			   tbPercentual.UFDestino = tbCliFor.UFCliFor AND
			   tbPercentual.UFOrigem = tbLocal.UFLocal
	WHERE
	tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
	tbItemDocumento.CodigoLocal = @CodigoLocal AND
	tbItemDocumento.EntradaSaidaDocumento = 'S' AND
	tbItemDocumento.DataDocumento between @DataInicial AND @DataFinal AND
	tbDocumento.EspecieDocumento = 'ECF' AND
    tbItemDocumento.TipoLancamentoMovimentacao = 7 AND
--	tbItemDocumento.ValorICMSSubstTribItemDocto = 0 AND
	tbDocumento.CondicaoNFCancelada = 'F' AND
	tbItemDocumento.QtdeLancamentoItemDocto <> 0 AND
	SerieECFDocFT NOT LIKE 'DJ%'
	GROUP BY
	SerieECFDocFT,
	tbItemDocumento.DataDocumento,
	tbItemDocumentoFT.CodigoTributacaoItDocFT,
	CASE WHEN @UFLocal = 'RN' THEN 5405 ELSE tbItemDocumento.CodigoCFO END,
	tbItemDocumento.PercentualICMSItemDocto,
	tbDocumento.EspecieDocumento,
	tbPercentual.CFOSaidaUF,
	tbLocalLF.CodigoCFOECF

END

IF @UFLocal = 'BA' and CONVERT(NUMERIC(4),@Versao) < 8
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C495|' +
	REPLACE(CONVERT(VARCHAR(16),PercentualICMSItemDocto),'.',',') + '|' + 
	RTRIM(LTRIM(CONVERT(VARCHAR(30),
		CASE 	
		WHEN tbItemDocumento.CodigoProduto is not null THEN
			tbItemDocumento.CodigoProduto
		WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
			tbItemDocumento.CodigoMaoObraOS
		WHEN tbItemDocumento.CodigoItemDocto is not null THEN
			tbItemDocumento.CodigoItemDocto
		ELSE
			CASE WHEN MAX(tbItemDocumento.TipoLancamentoMovimentacao) = 10 THEN
				'OUTRAS'
			ELSE
				'USOCONSUMO'
			END
	END))) + '|' +
	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),SUM(tbItemDocumento.QtdeLancamentoItemDocto))),'.',',') + '|' +
	'0,000|' +
	RTRIM(LTRIM(CASE 	
		WHEN tbItemDocumento.CodigoProduto is not null THEN
			tbProdutoFT.CodigoUnidadeProduto
		WHEN tbItemDocumento.CodigoMaoObraOS is not null THEN
			'HR'
		WHEN tbItemDocumento.CodigoItemDocto is not null THEN
			'UN'
		ELSE
			'UN'
	END)) + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorContabilItemDocto)),'.',',') + '|' +
	'0,00|' +
	'0,00|' +
	'0,00|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorBaseICMS1ItemDocto)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorICMSItemDocto)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorBaseICMS2ItemDocto)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorBaseICMS3ItemDocto)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),sum(tbItemDocumento.ValorICMSSubstTribItemDocto)),'.',',') + '|',
	'C495',
	'E',
	999999,
	'2030-01-01',
	500,
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbItemDocumento
	INNER JOIN tbDocumento ON
			   tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
			   tbDocumento.CodigoLocal = @CodigoLocal AND 
			   tbDocumento.EntradaSaidaDocumento = 'S' AND
			   tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
			   tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
			   tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	INNER JOIN tbDocumentoFT ON
			   tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
			   tbDocumentoFT.CodigoLocal = @CodigoLocal AND 
			   tbDocumentoFT.EntradaSaidaDocumento = 'S' AND
			   tbDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND  
			   tbDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
			   tbDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	LEFT JOIN tbItemDocumentoFT (NOLOCK) ON
			   tbItemDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
			   tbItemDocumentoFT.CodigoLocal = @CodigoLocal AND
			   tbItemDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
			   tbItemDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
			   tbItemDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   tbItemDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
			   tbItemDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND
			   tbItemDocumentoFT.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento
	LEFT JOIN tbProdutoFT (NOLOCK) ON
              tbProdutoFT.CodigoEmpresa = @CodigoEmpresa AND
              tbProdutoFT.CodigoProduto = tbItemDocumento.CodigoProduto
	WHERE
	tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
	tbItemDocumento.CodigoLocal = @CodigoLocal AND
	tbItemDocumento.EntradaSaidaDocumento = 'S' AND
	tbItemDocumento.DataDocumento between @DataInicial AND @DataFinal AND
	tbDocumento.EspecieDocumento = 'ECF' AND
    tbItemDocumento.TipoLancamentoMovimentacao = 7 AND
	tbDocumento.CondicaoNFCancelada = 'F' AND
	tbItemDocumento.QtdeLancamentoItemDocto <> 0 AND
	SerieECFDocFT NOT LIKE 'DJ%'
	GROUP BY
	tbItemDocumento.CodigoProduto,
	tbProdutoFT.CodigoUnidadeProduto,
	tbItemDocumento.CodigoMaoObraOS,
	tbItemDocumento.CodigoItemDocto,
	tbItemDocumento.PercentualICMSItemDocto
	
END
----

INSERT rtSPEDFiscal
SELECT
@@spid,
'|C500|' + 
CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' THEN
	'0'
ELSE
	'1'
END + '|' +
CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' or ( tbDocumento.EntradaSaidaDocumento = 'E' and tbDocumento.TipoLancamentoMovimentacao = 7 ) or tbDocumento.CondicaoComplementoICMSDocto = 'V' THEN
	'0'
ELSE
	'1'
END + '|' + 
CONVERT(VARCHAR(14),tbDocumento.CodigoCliFor) + '|' + 
RIGHT(CONVERT(VARCHAR(3),100 + tbDocumento.CodigoModeloNotaFiscal),2) + '|' +
'00' + '|' +
right('000'+rtrim(ltrim(coalesce(tbDocumento.SerieDocumento,''))),3) + '|' +
'' + '|'
+	case when tbDocumento.CodigoModeloNotaFiscal = 29 then
		'99' -- Água - 1 registro por documento
	else
		'01' -- Uso Comercial - Energia ou Gás 
	end + '|' + -- [09] COD_CONS
CONVERT(VARCHAR(9),tbDocumento.NumeroDocumento) + '|' +
COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDocumento.DataEmissaoDocumento)),2,2) +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDocumento.DataEmissaoDocumento)),2,2) +
CONVERT(CHAR(4),DATEPART(year,tbDocumento.DataEmissaoDocumento)),'') + '|' +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDocumento.DataDocumento)),2,2) +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDocumento.DataDocumento)),2,2) +
CONVERT(CHAR(4),DATEPART(year,tbDocumento.DataDocumento)) + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorContabilDocumento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.TotalDescontoDocumento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorContabilDocumento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorContabilDocumento),'.',',') + '|' +
'0,00' + '|' +
'0,00' + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorBaseICMS1Documento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorICMSDocumento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorBaseICMSSubstTribDocto),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorICMSSubstTribDocto),'.',',') + '|' +
'' + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorPISDocumento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorFinsocialDocumento),'.',',') + '|' +
CASE WHEN CONVERT(numeric(4),@Versao) > 3 THEN '||' ELSE '' END,
'C500',
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao,
13,
'',
0,
'',
0
FROM tbDocumento (NOLOCK)
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal
LEFT JOIN tbDocumentoFT (NOLOCK) ON
		  tbDocumentoFT.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoFT.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoFT.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoFT.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoFT.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoFT.DataDocumento		= tbDocumento.DataDocumento 
LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
		  tbNaturezaOperacao.CodigoEmpresa	= tbDocumento.CodigoEmpresa AND
		  tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao 
WHERE 
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = tbDocumento.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao AND
		tbDocumento.TipoLancamentoMovimentacao IN (7,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)			
	OR  tbDocumento.TipoLancamentoMovimentacao IN (1,9,10,12)
	)
	AND tbDocumento.CodigoModeloNotaFiscal in (6,28,29)
	AND (	tbDocumento.EspecieDocumento <> 'ECF' OR						-- Cupons Fiscais somente vão no SPED
			tbDocumento.NumeroDocumento <> tbDocumento.NumeroNFDocumento )	-- se tiverem NF Conjugada (TKT 234897 / 2016)
	AND tbDocumento.CodigoEmpresa		= @CodigoEmpresa 
	AND tbDocumento.CodigoLocal		    = @CodigoLocal
	AND tbDocumento.DataDocumento 		between @DataInicial and @DataFinal  
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
	(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento = tbDocumento.DataEmissaoDocumento) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento = 0 ))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento <> tbDocumento.DataEmissaoDocumento) OR (tbDocumento.TipoLancamentoMovimentacao = 11) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento <> 0))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 12 OR tbDocumento.TipoLancamentoMovimentacao = 11 OR tbDocumento.CondicaoNFCancelada = 'V')) OR 
	(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 11))
	)
	AND 'V' = CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' and 
	          	    tbDocumento.CondicaoNFCancelada = 'V' and 
               		    tbDocumento.TipoLancamentoMovimentacao <> 7 
			THEN 'F'
			ELSE 'V'
		  END
	AND EXISTS ( SELECT 1 FROM tbItemDocumento A
                 WHERE 
                 A.CodigoEmpresa = @CodigoEmpresa AND
                 A.CodigoLocal = @CodigoLocal AND
                 A.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
                 A.DataDocumento = tbDocumento.DataDocumento AND
                 A.CodigoCliFor = tbDocumento.CodigoCliFor AND
                 A.NumeroDocumento = tbDocumento.NumeroDocumento AND
                 A.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao )

INSERT rtSPEDFiscal
SELECT
@@spid,
'|C590|' + 
RIGHT(('000' + RTRIM(LTRIM(COALESCE(CodigoTributacaoNaturezaOper,'000')))),3) + '|' +
CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
	CONVERT(VARCHAR(4),tbLocalLF.CodigoCFOECF)
ELSE
	CONVERT(VARCHAR(4),tbItemDocumento.CodigoCFO)
END + '|' +
REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.PercentualICMSItemDocto),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorContabilItemDocto)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorBaseICMS1ItemDocto)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorICMSItemDocto)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.BaseICMSSubstTribItemDocto)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorICMSSubstTribItemDocto)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorBaseICMS2ItemDocto + tbItemDocumento.ValorBaseICMS3ItemDocto)),'.',',') + '|' + 
'' + '|',
'C590',
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao,
13,
'',
0,
'',
0
FROM tbDocumento (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
		   tbLocal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
		   tbLocal.CodigoLocal = tbDocumento.CodigoLocal
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal
LEFT JOIN tbDocumentoFT (NOLOCK) ON
		  tbDocumentoFT.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoFT.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoFT.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoFT.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoFT.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoFT.DataDocumento		= tbDocumento.DataDocumento 
LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
		  tbNaturezaOperacao.CodigoEmpresa	= tbDocumento.CodigoEmpresa AND
		  tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao 
INNER JOIN tbItemDocumento ON
		   tbDocumento.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND 
		   tbDocumento.CodigoLocal = tbItemDocumento.CodigoLocal AND 
		   tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND 
		   tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND 
		   tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND 
		   tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND 
		   tbDocumento.DataDocumento = tbItemDocumento.DataDocumento 
INNER JOIN tbCliFor (NOLOCK) ON
		   tbCliFor.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
		   tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
INNER JOIN tbPercentual (NOLOCK) ON
		   tbPercentual.UFDestino = tbCliFor.UFCliFor AND
		   tbPercentual.UFOrigem = tbLocal.UFLocal
WHERE 
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = tbDocumento.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao AND
		tbDocumento.TipoLancamentoMovimentacao IN (7,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)			
	OR  tbDocumento.TipoLancamentoMovimentacao IN (1,9,10,12)
	)
	AND tbDocumento.CodigoModeloNotaFiscal in (6,28,29)
	AND (	tbDocumento.EspecieDocumento <> 'ECF' OR						-- Cupons Fiscais somente vão no SPED
			tbDocumento.NumeroDocumento <> tbDocumento.NumeroNFDocumento )	-- se tiverem NF Conjugada (TKT 234897 / 2016)
	AND tbDocumento.CodigoEmpresa		= @CodigoEmpresa 
	AND tbDocumento.CodigoLocal		    = @CodigoLocal
	AND tbDocumento.DataDocumento 		between @DataInicial and @DataFinal  
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
	(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento = tbDocumento.DataEmissaoDocumento) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento = 0 ))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento <> tbDocumento.DataEmissaoDocumento) OR (tbDocumento.TipoLancamentoMovimentacao = 11) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento <> 0))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 12 OR tbDocumento.TipoLancamentoMovimentacao = 11 OR tbDocumento.CondicaoNFCancelada = 'V')) OR 
	(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 11))
	)
	AND 'V' = CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' and 
	          	    tbDocumento.CondicaoNFCancelada = 'V' and 
               		    tbDocumento.TipoLancamentoMovimentacao <> 7 
			THEN 'F'
			ELSE 'V'
		  END
GROUP BY
CodigoTributacaoNaturezaOper,
tbItemDocumento.CodigoCFO,
tbItemDocumento.PercentualICMSItemDocto,
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao,
tbDocumento.EspecieDocumento,
tbPercentual.CFOSaidaUF,
tbLocalLF.CodigoCFOECF

----

IF EXISTS ( SELECT 1 FROM rtSPEDFiscal WHERE rtSPEDFiscal.Spid = @@Spid AND TipoRegistro IN ('C100','C500') ) 
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C001|0|',
	'C001',
	'E',
	0,
	getdate(),
	0,
	0,
	10,
	'',
	0,
	'',
	0
END
ELSE
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C001|1|',
	'C001',
	'E',
	0,
	getdate(),
	0,
	0,
	10,
	'',
	0,
	'',
	0
END

---- Ajustes específicos por Legislação Estadual

IF @UFLocal = 'RS'
BEGIN
	DELETE rtSPEDFiscal WHERE TipoRegistro IN ('C195','C197')
END

----
INSERT rtSPEDFiscal
SELECT
@@spid,
'|C990|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro LIKE 'C%' ) + 1) + '|',
'C990',
'E',
999999,
getdate(),
0,
0,
31,
'',
0,
'',
0

---

--- CTRC

INSERT rtSPEDFiscal
SELECT
@@spid,
	'|D100|'
+	CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' THEN
		'0'
	ELSE
		'1'
	END + '|'
+	'1|'
+	CONVERT(VARCHAR(14),tbDocumento.CodigoCliFor) + '|'
+	RIGHT(CONVERT(VARCHAR(3),100 + tbDocumento.CodigoModeloNotaFiscal),2) + '|'
+	'00' + '|'
+	right('000'+rtrim(ltrim(coalesce(tbDocumento.SerieDocumento,''))),3) + '|'
+	'' + '|'
+	CONVERT(VARCHAR(9),tbDocumento.NumeroDocumento) + '|'
+	CASE WHEN tbDocumento.CodigoModeloNotaFiscal <> 57 THEN
		''
	ELSE
		RTRIM(LTRIM(COALESCE(tbDocumentoNFe.ChaveAcessoNFe,'')))
	END + '|'
+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDocumento.DataEmissaoDocumento)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDocumento.DataEmissaoDocumento)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbDocumento.DataEmissaoDocumento)),'') + '|'
+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDocumento.DataDocumento)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDocumento.DataDocumento)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbDocumento.DataDocumento)) + '|'
+	CASE WHEN tbDocumento.CodigoModeloNotaFiscal <> 57 THEN
		''
	ELSE
		'0' -- CT-e Normal
	END + '|' -- [13] TP_CT-e
+	'' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorContabilDocumento),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbDocumento.TotalDescontoDocumento),'.',',') + '|'
+	COALESCE(CONVERT(CHAR(1),tbDocumentoFT.TipoFreteDocFT),'2') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorContabilDocumento),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorBaseICMS1Documento),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorICMSDocumento),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorBaseICMS3Documento),'.',',') + '|'
+	'' + '|'
+	@ContaEntrada + '|'
+	'' + '|' --coalesce(tbDocumentoFT.MunicipioOrigem,'') + '|' -- [24] COD_MUN_ORIG
+	'' + '|' --coalesce(tbDocumentoFT.MunicipioDestino,'') + '|' -- [25] 25 COD_MUN_DEST
,	'D100',
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao,
40,
'',
0,
'',
0
FROM tbDocumento (NOLOCK)
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal
LEFT JOIN tbDocumentoFT (NOLOCK) ON
		  tbDocumentoFT.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoFT.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoFT.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoFT.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoFT.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoFT.DataDocumento		= tbDocumento.DataDocumento 
LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
		  tbNaturezaOperacao.CodigoEmpresa	= tbDocumento.CodigoEmpresa AND
		  tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao 
LEFT JOIN tbDocumentoNFe (NOLOCK) ON
		  tbDocumentoNFe.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoNFe.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoNFe.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoNFe.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoNFe.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoNFe.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoNFe.DataDocumento		= tbDocumento.DataDocumento 
WHERE 
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = tbDocumento.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao AND
		tbDocumento.TipoLancamentoMovimentacao IN (7,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)			
	OR  tbDocumento.TipoLancamentoMovimentacao IN (1,9,10,12)
	)
	AND tbDocumento.CodigoModeloNotaFiscal IN (7,8,9,10,11,26,27,57,67)
	AND (	tbDocumento.EspecieDocumento <> 'ECF' OR						-- Cupons Fiscais somente vão no SPED
			tbDocumento.NumeroDocumento <> tbDocumento.NumeroNFDocumento )	-- se tiverem NF Conjugada (TKT 234897 / 2016)
	AND tbDocumento.CodigoEmpresa		= @CodigoEmpresa 
	AND tbDocumento.CodigoLocal		    = @CodigoLocal
	AND tbDocumento.DataDocumento 		between @DataInicial and @DataFinal  
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
	(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento = tbDocumento.DataEmissaoDocumento) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento = 0 ))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento <> tbDocumento.DataEmissaoDocumento) OR (tbDocumento.TipoLancamentoMovimentacao = 11) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento <> 0))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 12 OR tbDocumento.TipoLancamentoMovimentacao = 11 OR tbDocumento.CondicaoNFCancelada = 'V')) OR 
	(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 11))
	)
	AND 'V' = CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' and 
	          	    tbDocumento.CondicaoNFCancelada = 'V' and 
               		    tbDocumento.TipoLancamentoMovimentacao <> 7 
			THEN 'F'
			ELSE 'V'
		  END
	AND EXISTS ( SELECT 1 FROM tbItemDocumento 
                 WHERE tbDocumento.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND
                       tbDocumento.CodigoLocal = tbItemDocumento.CodigoLocal AND
                       tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
                       tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
                       tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND
                       tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
                       tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao )

IF CONVERT(NUMERIC(4),@Versao) >= 10
BEGIN
	---- D101 - PARTILHA DE ICMS NAS VENDAS A CONSUMIDOR NÃO CONTRIBUINTE
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|D101|'
	+	REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumentoPartilhaICMS.vFCPUFDest)),'.',',') + '|' -- VL_FCP_UF_DEST
	+	REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumentoPartilhaICMS.vICMSUFDest)),'.',',') + '|' -- VL_ICMS_UF_DEST
	+	REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumentoPartilhaICMS.vICMSUFRemet)),'.',',') + '|', -- VL_ICMS_UF_REM
	'D101',
	tbDocumento.EntradaSaidaDocumento,
	tbDocumento.NumeroDocumento,
	tbDocumento.DataDocumento,
	tbDocumento.CodigoCliFor,
	tbDocumento.TipoLancamentoMovimentacao,
	11,
	'',
	0,
	'',
	0
	FROM tbDocumento (NOLOCK)
	INNER JOIN	rtSPEDFiscal (NOLOCK) ON
				rtSPEDFiscal.Spid = @@spid AND
				rtSPEDFiscal.EntradaSaida = tbDocumento.EntradaSaidaDocumento AND
				rtSPEDFiscal.DataDocumento = tbDocumento.DataDocumento AND
				rtSPEDFiscal.CodigoCliFor = tbDocumento.CodigoCliFor AND
				rtSPEDFiscal.NumeroDocumento = tbDocumento.NumeroDocumento AND
				rtSPEDFiscal.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
				rtSPEDFiscal.TipoRegistro = 'D100'
	INNER JOIN	tbItemDocumentoPartilhaICMS (NOLOCK) ON
				tbItemDocumentoPartilhaICMS.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
				tbItemDocumentoPartilhaICMS.CodigoLocal = tbDocumento.CodigoLocal AND
				tbItemDocumentoPartilhaICMS.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
				tbItemDocumentoPartilhaICMS.NumeroDocumento = tbDocumento.NumeroDocumento AND
				tbItemDocumentoPartilhaICMS.DataDocumento = tbDocumento.DataDocumento AND
				tbItemDocumentoPartilhaICMS.CodigoCliFor = tbDocumento.CodigoCliFor AND
				tbItemDocumentoPartilhaICMS.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao
	WHERE 
		tbDocumento.CodigoModeloNotaFiscal IN (57,67)
	GROUP BY
		tbDocumento.CodigoEmpresa,
		tbDocumento.CodigoLocal,
		tbDocumento.EntradaSaidaDocumento,
		tbDocumento.NumeroDocumento,
		tbDocumento.DataDocumento,
		tbDocumento.CodigoCliFor,
		tbDocumento.TipoLancamentoMovimentacao
END


INSERT rtSPEDFiscal
SELECT
@@spid,
'|D190|' + 
COALESCE(( SELECT MIN(CodigoTributacaoItDocFT) FROM tbItemDocumentoFT
  WHERE
  tbItemDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
  tbItemDocumentoFT.CodigoLocal = @CodigoLocal AND
  tbItemDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
  tbItemDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND
  tbItemDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
  tbItemDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
  tbItemDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
  tbItemDocumentoFT.CodigoTributacaoItDocFT IS NOT NULL AND
  RTRIM(LTRIM(tbItemDocumentoFT.CodigoTributacaoItDocFT)) <> '' ),'010') + '|' +
CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
	CONVERT(VARCHAR(4),tbLocalLF.CodigoCFOECF)
ELSE
	CONVERT(VARCHAR(4),tbItemDocumento.CodigoCFO)
END + '|' +
REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.PercentualICMSItemDocto),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorContabilItemDocto)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorBaseICMS1ItemDocto)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorICMSItemDocto)),'.',',') + '|' + 
CASE WHEN SUM(tbItemDocumento.ValorBaseICMS1ItemDocto) <> 0 AND SUM((tbItemDocumento.ValorBaseICMS2ItemDocto + tbItemDocumento.ValorBaseICMS3ItemDocto)) <> 0 THEN 
	REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorBaseICMS2ItemDocto + tbItemDocumento.ValorBaseICMS3ItemDocto)),'.',',') + '|'
ELSE
	'0,00|'
END + 
'' + '|',
'D190',
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao,
40,
'',
0,
'',
0
FROM tbDocumento (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
		   tbLocal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
		   tbLocal.CodigoLocal = tbDocumento.CodigoLocal
INNER JOIN tbLocalLF (NOLOCK) ON
		   tbLocalLF.CodigoEmpresa = tbLocal.CodigoEmpresa AND
		   tbLocalLF.CodigoLocal = tbLocal.CodigoLocal
INNER JOIN tbCliFor (NOLOCK) ON
		   tbCliFor.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
		   tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
INNER JOIN tbPercentual (NOLOCK) ON
		   tbPercentual.UFDestino = tbCliFor.UFCliFor AND
		   tbPercentual.UFOrigem = tbLocal.UFLocal
INNER JOIN tbItemDocumento ON
		   tbDocumento.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND 
		   tbDocumento.CodigoLocal = tbItemDocumento.CodigoLocal AND 
		   tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND 
		   tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND 
		   tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND 
		   tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND 
		   tbDocumento.DataDocumento = tbItemDocumento.DataDocumento 
LEFT JOIN tbDocumentoFT (NOLOCK) ON
		  tbDocumentoFT.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoFT.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoFT.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoFT.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoFT.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoFT.DataDocumento		= tbDocumento.DataDocumento 
LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
		  tbNaturezaOperacao.CodigoEmpresa	= tbDocumento.CodigoEmpresa AND
		  tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao 

WHERE 
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = tbDocumento.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao AND
		tbDocumento.TipoLancamentoMovimentacao IN (7,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)			
	OR  tbDocumento.TipoLancamentoMovimentacao IN (1,9,10,12)
	)
	AND tbDocumento.CodigoModeloNotaFiscal IN (7,8,9,10,11,26,27,57,63,67)
	AND (	tbDocumento.EspecieDocumento <> 'ECF' OR						-- Cupons Fiscais somente vão no SPED
			tbDocumento.NumeroDocumento <> tbDocumento.NumeroNFDocumento )	-- se tiverem NF Conjugada (TKT 234897 / 2016)
	AND tbDocumento.CodigoEmpresa		= @CodigoEmpresa 
	AND tbDocumento.CodigoLocal		    = @CodigoLocal
	AND tbDocumento.DataDocumento 		between @DataInicial and @DataFinal  
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
	(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento = tbDocumento.DataEmissaoDocumento) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento = 0 ))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento <> tbDocumento.DataEmissaoDocumento) OR (tbDocumento.TipoLancamentoMovimentacao = 11) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento <> 0))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 12 OR tbDocumento.TipoLancamentoMovimentacao = 11 OR tbDocumento.CondicaoNFCancelada = 'V')) OR 
	(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 11))
	)
	AND 'V' = CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' and 
	          	    tbDocumento.CondicaoNFCancelada = 'V' and 
               		    tbDocumento.TipoLancamentoMovimentacao <> 7 
			THEN 'F'
			ELSE 'V'
		  END
GROUP BY
CodigoTributacaoNaturezaOper,
tbItemDocumento.CodigoCFO,
tbItemDocumento.PercentualICMSItemDocto,
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao,
tbDocumento.EspecieDocumento,
tbPercentual.CFOSaidaUF,
tbLocalLF.CodigoCFOECF



INSERT rtSPEDFiscal
SELECT
@@spid,
'|D500|' + 
CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' THEN
	'0'
ELSE
	'1'
END + '|' +
'1|' +
CONVERT(VARCHAR(14),tbDocumento.CodigoCliFor) + '|' + 
RIGHT(CONVERT(VARCHAR(3),100 + tbDocumento.CodigoModeloNotaFiscal),2) + '|' +
'00' + '|' +
right('000'+rtrim(ltrim(coalesce(tbDocumento.SerieDocumento,''))),3) + '|' +
'' + '|' +
CONVERT(VARCHAR(9),tbDocumento.NumeroDocumento) + '|' +
COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDocumento.DataEmissaoDocumento)),2,2) +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDocumento.DataEmissaoDocumento)),2,2) +
CONVERT(CHAR(4),DATEPART(year,tbDocumento.DataEmissaoDocumento)),'') + '|' +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDocumento.DataDocumento)),2,2) +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDocumento.DataDocumento)),2,2) +
CONVERT(CHAR(4),DATEPART(year,tbDocumento.DataDocumento)) + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorContabilDocumento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.TotalDescontoDocumento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorContabilDocumento),'.',',') + '|' +
'0,00' + '|' +
'0,00' + '|' +
'0,00' + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorBaseICMS1Documento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorICMSDocumento),'.',',') + '|' +
'' + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorPISDocumento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorFinsocialDocumento),'.',',') + '|' +
@ContaEntrada + '|' + 
CASE WHEN CONVERT(numeric(4),@Versao) > 3 THEN '1|' ELSE '' END,
'D500',
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao,
42,
'',
0,
'',
0
FROM tbDocumento (NOLOCK)
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal
LEFT JOIN tbDocumentoFT (NOLOCK) ON
		  tbDocumentoFT.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoFT.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoFT.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoFT.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoFT.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoFT.DataDocumento		= tbDocumento.DataDocumento 
LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
		  tbNaturezaOperacao.CodigoEmpresa	= tbDocumento.CodigoEmpresa AND
		  tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao 

WHERE 
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = tbDocumento.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao AND
		tbDocumento.TipoLancamentoMovimentacao IN (7,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)			
	OR  tbDocumento.TipoLancamentoMovimentacao IN (1,9,10,12)
	)
	AND tbDocumento.CodigoModeloNotaFiscal IN (21,22)
	AND (	tbDocumento.EspecieDocumento <> 'ECF' OR						-- Cupons Fiscais somente vão no SPED
			tbDocumento.NumeroDocumento <> tbDocumento.NumeroNFDocumento )	-- se tiverem NF Conjugada (TKT 234897 / 2016)
	AND tbDocumento.CodigoEmpresa		= @CodigoEmpresa 
	AND tbDocumento.CodigoLocal		    = @CodigoLocal
	AND tbDocumento.DataDocumento 		between @DataInicial and @DataFinal  
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
	(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento = tbDocumento.DataEmissaoDocumento) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento = 0 ))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento <> tbDocumento.DataEmissaoDocumento) OR (tbDocumento.TipoLancamentoMovimentacao = 11) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento <> 0))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 12 OR tbDocumento.TipoLancamentoMovimentacao = 11 OR tbDocumento.CondicaoNFCancelada = 'V')) OR 
	(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 11))
	)
	AND 'V' = CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' and 
	          	    tbDocumento.CondicaoNFCancelada = 'V' and 
               		    tbDocumento.TipoLancamentoMovimentacao <> 7 
			THEN 'F'
			ELSE 'V'
		  END
	AND EXISTS ( SELECT 1 FROM tbItemDocumento A
                 WHERE 
                 A.CodigoEmpresa = @CodigoEmpresa AND
                 A.CodigoLocal = @CodigoLocal AND
                 A.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
                 A.DataDocumento = tbDocumento.DataDocumento AND
                 A.CodigoCliFor = tbDocumento.CodigoCliFor AND
                 A.NumeroDocumento = tbDocumento.NumeroDocumento AND
                 A.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao )

INSERT rtSPEDFiscal
SELECT
@@spid,
'|D590|' + 
RIGHT(('000' + RTRIM(LTRIM(COALESCE(CodigoTributacaoNaturezaOper,'000')))),3) + '|' +
CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
	CONVERT(VARCHAR(4),tbLocalLF.CodigoCFOECF)
ELSE
	CONVERT(VARCHAR(4),tbItemDocumento.CodigoCFO)
END + '|' +
REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.PercentualICMSItemDocto),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorContabilItemDocto)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorBaseICMS1ItemDocto)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorICMSItemDocto)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.BaseICMSSubstTribItemDocto)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorICMSSubstTribItemDocto)),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorBaseICMS2ItemDocto + tbItemDocumento.ValorBaseICMS3ItemDocto)),'.',',') + '|' + 
'' + '|',
'D590',
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao,
42,
'',
0,
'',
0
FROM tbDocumento (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
		   tbLocal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
		   tbLocal.CodigoLocal = tbDocumento.CodigoLocal
INNER JOIN tbLocalLF (NOLOCK) ON
		   tbLocalLF.CodigoEmpresa = tbLocal.CodigoEmpresa AND
		   tbLocalLF.CodigoLocal = tbLocal.CodigoLocal
INNER JOIN tbCliFor (NOLOCK) ON
		   tbCliFor.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
		   tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
INNER JOIN tbPercentual (NOLOCK) ON
		   tbPercentual.UFDestino = tbCliFor.UFCliFor AND
		   tbPercentual.UFOrigem = tbLocal.UFLocal
INNER JOIN tbItemDocumento ON
		   tbDocumento.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND 
		   tbDocumento.CodigoLocal = tbItemDocumento.CodigoLocal AND 
		   tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND 
		   tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND 
		   tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND 
		   tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND 
		   tbDocumento.DataDocumento = tbItemDocumento.DataDocumento 
LEFT JOIN tbDocumentoFT (NOLOCK) ON
		  tbDocumentoFT.CodigoEmpresa		= tbDocumento.CodigoEmpresa AND
          tbDocumentoFT.CodigoLocal		= tbDocumento.CodigoLocal AND
		  tbDocumentoFT.EntradaSaidaDocumento	= tbDocumento.EntradaSaidaDocumento AND
		  tbDocumentoFT.NumeroDocumento		= tbDocumento.NumeroDocumento AND
		  tbDocumentoFT.CodigoCliFor		= tbDocumento.CodigoCliFor AND
		  tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND
		  tbDocumentoFT.DataDocumento		= tbDocumento.DataDocumento 
LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
		  tbNaturezaOperacao.CodigoEmpresa	= tbDocumento.CodigoEmpresa AND
		  tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao 
WHERE 
	(
	(
		tbNaturezaOperacao.CodigoEmpresa = tbDocumento.CodigoEmpresa AND 
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao AND
		tbDocumento.TipoLancamentoMovimentacao IN (7,11) AND
		tbNaturezaOperacao.AtualizaLFNaturezaOperacao='V'
	)			
	OR  tbDocumento.TipoLancamentoMovimentacao IN (1,9,10,12)
	)
	AND tbDocumento.CodigoModeloNotaFiscal IN (21,22)
	AND (	tbDocumento.EspecieDocumento <> 'ECF' OR						-- Cupons Fiscais somente vão no SPED
			tbDocumento.NumeroDocumento <> tbDocumento.NumeroNFDocumento )	-- se tiverem NF Conjugada (TKT 234897 / 2016)
	AND tbDocumento.CodigoEmpresa		= @CodigoEmpresa 
	AND tbDocumento.CodigoLocal		    = @CodigoLocal
	AND tbDocumento.DataDocumento 		between @DataInicial and @DataFinal  
	AND tbDocumento.TipoLancamentoMovimentacao <> 11
	AND ( tbLocalLF.TipoImpressaoNFCancelada = 0 OR
	(tbLocalLF.TipoImpressaoNFCancelada = 1 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento = tbDocumento.DataEmissaoDocumento) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento = 0 ))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 2 AND NOT ((tbDocumento.TipoLancamentoMovimentacao = 12 AND tbDocumento.DataDocumento <> tbDocumento.DataEmissaoDocumento) OR (tbDocumento.TipoLancamentoMovimentacao = 11) OR (tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumento.ValorContabilDocumento <> 0))) OR
	(tbLocalLF.TipoImpressaoNFCancelada = 3 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 12 OR tbDocumento.TipoLancamentoMovimentacao = 11 OR tbDocumento.CondicaoNFCancelada = 'V')) OR 
	(tbLocalLF.TipoImpressaoNFCancelada = 4 AND NOT (tbDocumento.TipoLancamentoMovimentacao = 11))
	)
	AND 'V' = CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' and 
	          	    tbDocumento.CondicaoNFCancelada = 'V' and 
               		    tbDocumento.TipoLancamentoMovimentacao <> 7 
			THEN 'F'
			ELSE 'V'
		  END
GROUP BY
CodigoTributacaoNaturezaOper,
tbItemDocumento.CodigoCFO,
tbItemDocumento.PercentualICMSItemDocto,
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao,
tbDocumento.EspecieDocumento,
tbPercentual.CFOSaidaUF,
tbLocalLF.CodigoCFOECF

IF EXISTS ( SELECT 1 FROM rtSPEDFiscal WHERE Spid = @@spid AND TipoRegistro like 'D%' )
BEGIN
	INSERT rtSPEDFiscal
	SELECT 
	@@spid,
	'|D001|0|',
	'D001',
	'E',
	0,
	getdate(),
	0,
	0,
	42,
	'',
	0,
	'',
	0
END
ELSE
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|D001|1|',
	'D001',
	'E',
	0,
	getdate(),
	0,
	0,
	42,
	'',
	0,
	'',
	0
END

INSERT rtSPEDFiscal
SELECT
@@spid,
'|D990|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro LIKE 'D%' ) + 1) + '|',
'D990',
'E',
999999,
getdate(),
0,
0,
42,
'',
0,
'',
0
WHERE
EXISTS ( SELECT 1 FROM rtSPEDFiscal WHERE Spid = @@spid AND TipoRegistro like 'D%' )

---- Apuração do ICMS/IPI

--- total
DECLARE @ICMSEntradas  money
DECLARE @ICMSSaidas    money

TRUNCATE TABLE rtRelLFCFO

INSERT rtRelLFCFO 
(
	RazaoSocialEmpresa, 
	CodCFO, 
	DescrCFO, 
	EntradaSaida, 
	IE, 
	CGC, 
	DataDocto, 
	ICMS, 
	TotalFolhasRegEntradas, 
	CondicaoRegEntradasSeq, 
	CondTermoAbEncerRegEntSai, 
	TipoLancamentoMovimentacao, 
	AtualizaLFNaturezaOperacao, 
	VlContabil, 
	BaseCalculo,                
	ImpostoDebitado, 
	IstNTrib, 
	Outras
)

EXECUTE whRelLFEntCFO @CodigoEmpresa,@CodigoLocal,@DataInicial,@DataFinal

DELETE rtRelLFCFO WHERE CodCFO IS NULL OR VlContabil IS NULL

SELECT @ICMSEntradas = 0
SELECT @ICMSSaidas = 0

SELECT @ICMSEntradas = SUM(ImpostoDebitado)
FROM rtRelLFCFO
WHERE Spid = @@spid

TRUNCATE TABLE rtRelLFCFO

INSERT rtRelLFCFO 
(
	RazaoSocialEmpresa, 
	CodCFO, 
	DescrCFO, 
	EntradaSaida, 
	IE, 
	CGC, 
	DataDocto, 
	ICMS, 
	TotalFolhasRegEntradas, 
	CondicaoRegEntradasSeq, 
	CondTermoAbEncerRegEntSai, 
	TipoLancamentoMovimentacao, 
	AtualizaLFNaturezaOperacao, 
	VlContabil, 
	BaseCalculo,                
	ImpostoDebitado, 
	IstNTrib, 
	Outras
)

EXECUTE whRelLFSaiCFO @CodigoEmpresa,@CodigoLocal,@DataInicial,@DataFinal

DELETE rtRelLFCFO WHERE CodCFO IS NULL OR VlContabil IS NULL

SELECT @ICMSSaidas = SUM(ImpostoDebitado)
FROM rtRelLFCFO
WHERE Spid = @@spid

TRUNCATE TABLE rtRelLFCFO

IF @ICMSSaidas IS NULL SELECT @ICMSSaidas = 0
IF @ICMSEntradas IS NULL SELECT @ICMSEntradas = 0
 
INSERT rtSPEDFiscal
SELECT
@@spid,
	'|E110|'
+	REPLACE(CONVERT(VARCHAR(16),@ICMSSaidas),'.',',') + '|'
+	'0,00|'
+	REPLACE(CONVERT(VARCHAR(16),( 
		OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + OutrosDebitosValor5 + 
		OutrosDebitosValor6 + OutrosDebitosValor7 + OutrosDebitosValor8 + OutrosDebitosValor9 + OutrosDebitosValor10 )),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),( 
		EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 + EstornosCreditosValor5 + 
		EstornosCreditosValor6 + EstornosCreditosValor7 + EstornosCreditosValor8 + EstornosCreditosValor9 + EstornosCreditosValor10 )),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),@ICMSEntradas),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),COALESCE((	SELECT SUM(ValorICMS) FROM rtE110 
											WHERE	SUBSTRING(CodigoAjuste,3,1) IN ('0','1','2') AND
													SUBSTRING(CodigoAjuste,4,1) IN ('0','3','4','5','6','7','8')
											),0) ),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),( 
		OutrosCreditosValor1 + OutrosCreditosValor2 + OutrosCreditosValor3 + OutrosCreditosValor4 + OutrosCreditosValor5 + 
		OutrosCreditosValor6 + OutrosCreditosValor7 + OutrosCreditosValor8 + OutrosCreditosValor9 + OutrosCreditosValor10 )),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),( 
		EstornosDebitosValor1 + EstornosDebitosValor2 + EstornosDebitosValor3 + EstornosDebitosValor4 + EstornosDebitosValor5 + 
		EstornosDebitosValor6 + EstornosDebitosValor7 + EstornosDebitosValor8 + EstornosDebitosValor9 + EstornosDebitosValor10 )),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),SaldoAnterior),'.',',') + '|'
+	CASE WHEN ( 
		@ICMSSaidas + 
		OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + OutrosDebitosValor5 + 
		OutrosDebitosValor6 + OutrosDebitosValor7 + OutrosDebitosValor8 + OutrosDebitosValor9 + OutrosDebitosValor10 + 
		EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 + EstornosCreditosValor5 + 
		EstornosCreditosValor6 + EstornosCreditosValor7 + EstornosCreditosValor8 + EstornosCreditosValor9 + EstornosCreditosValor10 - 
		@ICMSEntradas - 
		OutrosCreditosValor1 - OutrosCreditosValor2 - OutrosCreditosValor3 - OutrosCreditosValor4 - OutrosCreditosValor5 - 
		OutrosCreditosValor6 - OutrosCreditosValor7 - OutrosCreditosValor8 - OutrosCreditosValor9 - OutrosCreditosValor10 - 
		EstornosDebitosValor1 - EstornosDebitosValor2 - EstornosDebitosValor3 - EstornosDebitosValor4 - EstornosDebitosValor5 - 
		EstornosDebitosValor6 - EstornosDebitosValor7 - EstornosDebitosValor8 - EstornosDebitosValor9 - EstornosDebitosValor10 - 
		SaldoAnterior ) > 0 
	THEN
		REPLACE(CONVERT(VARCHAR(16),( 
		@ICMSSaidas + 
		OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + OutrosDebitosValor5 + 
		OutrosDebitosValor6 + OutrosDebitosValor7 + OutrosDebitosValor8 + OutrosDebitosValor9 + OutrosDebitosValor10 + 
		EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 + EstornosCreditosValor5 + 
		EstornosCreditosValor6 + EstornosCreditosValor7 + EstornosCreditosValor8 + EstornosCreditosValor9 + EstornosCreditosValor10 - 
		@ICMSEntradas - 
		OutrosCreditosValor1 - OutrosCreditosValor2 - OutrosCreditosValor3 - OutrosCreditosValor4 - OutrosCreditosValor5 - 
		OutrosCreditosValor6 - OutrosCreditosValor7 - OutrosCreditosValor8 - OutrosCreditosValor9 - OutrosCreditosValor10 - 
		EstornosDebitosValor1 - EstornosDebitosValor2 - EstornosDebitosValor3 - EstornosDebitosValor4 - EstornosDebitosValor5 - 
		EstornosDebitosValor6 - EstornosDebitosValor7 - EstornosDebitosValor8 - EstornosDebitosValor9 - EstornosDebitosValor10 - 
		SaldoAnterior)),'.',',') 
	ELSE
		'0,00'
	END + '|'
+	REPLACE(CONVERT(VARCHAR(16),( DeducoesValor1 + DeducoesValor2 + DeducoesValor3 + DeducoesValor4 + DeducoesValor5 + DeducoesValor6 + DeducoesValor7 + DeducoesValor8 + DeducoesValor9 + DeducoesValor10)),'.',',') + '|'
+	CASE WHEN ( 
		@ICMSSaidas + 
		OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + OutrosDebitosValor5 + 
		OutrosDebitosValor6 + OutrosDebitosValor7 + OutrosDebitosValor8 + OutrosDebitosValor9 + OutrosDebitosValor10 + 
		EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 + EstornosCreditosValor5 + 
		EstornosCreditosValor6 + EstornosCreditosValor7 + EstornosCreditosValor8 + EstornosCreditosValor9 + EstornosCreditosValor10 - 
		@ICMSEntradas - 
		COALESCE(	(	SELECT SUM(ValorICMS) FROM rtE110
						WHERE	SUBSTRING(CodigoAjuste,3,1) IN ('0','1','2') AND
								SUBSTRING(CodigoAjuste,4,1) IN ('0','3','4','5','6','7','8')
					),0) -
		OutrosCreditosValor1 - OutrosCreditosValor2 - OutrosCreditosValor3 - OutrosCreditosValor4 - OutrosCreditosValor5 - 
		OutrosCreditosValor6 - OutrosCreditosValor7 - OutrosCreditosValor8 - OutrosCreditosValor9 - OutrosCreditosValor10 - 
		EstornosDebitosValor1 - EstornosDebitosValor2 - EstornosDebitosValor3 - EstornosDebitosValor4 - EstornosDebitosValor5 - 
		EstornosDebitosValor6 - EstornosDebitosValor7 - EstornosDebitosValor8 - EstornosDebitosValor9 - EstornosDebitosValor10 - 
		SaldoAnterior ) - ( 
		DeducoesValor1 + DeducoesValor2 + DeducoesValor3 + DeducoesValor4 + DeducoesValor5 + 
		DeducoesValor6 + DeducoesValor7 + DeducoesValor8 + DeducoesValor9 + DeducoesValor10) > 0 
	THEN
		REPLACE(CONVERT(VARCHAR(16), ( ( 
		@ICMSSaidas + 
		OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + OutrosDebitosValor5 + 
		OutrosDebitosValor6 + OutrosDebitosValor7 + OutrosDebitosValor8 + OutrosDebitosValor9 + OutrosDebitosValor10 + 
		EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 + EstornosCreditosValor5 + 
		EstornosCreditosValor6 + EstornosCreditosValor7 + EstornosCreditosValor8 + EstornosCreditosValor9 + EstornosCreditosValor10 - 
		@ICMSEntradas - 
		COALESCE(	(	SELECT SUM(ValorICMS) FROM rtE110
						WHERE	SUBSTRING(CodigoAjuste,3,1) IN ('0','1','2') AND
								SUBSTRING(CodigoAjuste,4,1) IN ('0','3','4','5','6','7','8')
					),0) -
		OutrosCreditosValor1 - OutrosCreditosValor2 - OutrosCreditosValor3 - OutrosCreditosValor4 - OutrosCreditosValor5 - 
		OutrosCreditosValor6 - OutrosCreditosValor7 - OutrosCreditosValor8 - OutrosCreditosValor9 - OutrosCreditosValor10 - 
		EstornosDebitosValor1 - EstornosDebitosValor2 - EstornosDebitosValor3 - EstornosDebitosValor4 - EstornosDebitosValor5 - 
		EstornosDebitosValor6 - EstornosDebitosValor7 - EstornosDebitosValor8 - EstornosDebitosValor9 - EstornosDebitosValor10 - 
		SaldoAnterior ) - ( 
		DeducoesValor1 + DeducoesValor2 + DeducoesValor3 + DeducoesValor4 + DeducoesValor5 + 
		DeducoesValor6 + DeducoesValor7 + DeducoesValor8 + DeducoesValor9 + DeducoesValor10))),'.',',') 
	ELSE
		'0,00'
	END + '|'
+	CASE WHEN ( 
		SaldoAnterior - ( 
		@ICMSSaidas + 
		OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + OutrosDebitosValor5 + 
		OutrosDebitosValor6 + OutrosDebitosValor7 + OutrosDebitosValor8 + OutrosDebitosValor9 + OutrosDebitosValor10 + 
		EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 + EstornosCreditosValor5 + 
		EstornosCreditosValor6 + EstornosCreditosValor7 + EstornosCreditosValor8 + EstornosCreditosValor9 + EstornosCreditosValor10 ) + ( 
		@ICMSEntradas + 
		COALESCE(	(	SELECT SUM(ValorICMS) FROM rtE110
						WHERE	SUBSTRING(CodigoAjuste,3,1) IN ('0','1','2') AND
								SUBSTRING(CodigoAjuste,4,1) IN ('0','3','4','5','6','7','8')
					),0) +
		OutrosCreditosValor1 + OutrosCreditosValor2 + OutrosCreditosValor3 + OutrosCreditosValor4 + OutrosCreditosValor5 + 
		OutrosCreditosValor6 + OutrosCreditosValor7 + OutrosCreditosValor8 + OutrosCreditosValor9 + OutrosCreditosValor10 + 
		EstornosDebitosValor1 + EstornosDebitosValor2 + EstornosDebitosValor3 + EstornosDebitosValor4 + EstornosDebitosValor5 + 
		EstornosDebitosValor6 + EstornosDebitosValor7 + EstornosDebitosValor8 + EstornosDebitosValor9 + EstornosDebitosValor10 ) - 
		DeducoesValor1 - DeducoesValor2 - DeducoesValor3 - DeducoesValor4 - DeducoesValor5 - 
		DeducoesValor6 - DeducoesValor7 - DeducoesValor8 - DeducoesValor9 - DeducoesValor10 ) > 0 
	THEN
		REPLACE(CONVERT(VARCHAR(16),( 
		SaldoAnterior - ( 
		@ICMSSaidas + 
		OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + OutrosDebitosValor5 + 
		OutrosDebitosValor6 + OutrosDebitosValor7 + OutrosDebitosValor8 + OutrosDebitosValor9 + OutrosDebitosValor10 + 
		EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 + EstornosCreditosValor5 + 
		EstornosCreditosValor6 + EstornosCreditosValor7 + EstornosCreditosValor8 + EstornosCreditosValor9 + EstornosCreditosValor10 ) + ( 
		@ICMSEntradas + 
		COALESCE(	(	SELECT SUM(ValorICMS) FROM rtE110
						WHERE	SUBSTRING(CodigoAjuste,3,1) IN ('0','1','2') AND
								SUBSTRING(CodigoAjuste,4,1) IN ('0','3','4','5','6','7','8')
					),0) +
		OutrosCreditosValor1 + OutrosCreditosValor2 + OutrosCreditosValor3 + OutrosCreditosValor4 + OutrosCreditosValor5 + 
		OutrosCreditosValor6 + OutrosCreditosValor7 + OutrosCreditosValor8 + OutrosCreditosValor9 + OutrosCreditosValor10 + 
		EstornosDebitosValor1 + EstornosDebitosValor2 + EstornosDebitosValor3 + EstornosDebitosValor4 + EstornosDebitosValor5 + 
		EstornosDebitosValor6 + EstornosDebitosValor7 + EstornosDebitosValor8 + EstornosDebitosValor9 + EstornosDebitosValor10 ) - 
		DeducoesValor1 - DeducoesValor2 - DeducoesValor3 - DeducoesValor4 - DeducoesValor5 - 
		DeducoesValor6 - DeducoesValor7 - DeducoesValor8 - DeducoesValor9 - DeducoesValor10 ) ),'.',',')
	ELSE
		'0,00'
	END + '|'
+	REPLACE(CONVERT(VARCHAR(16),
		(	DebitosEspeciaisValor1 + DebitosEspeciaisValor2 + DebitosEspeciaisValor3 + DebitosEspeciaisValor4 + DebitosEspeciaisValor5 + 
			DebitosEspeciaisValor6 + DebitosEspeciaisValor7 + DebitosEspeciaisValor8 + DebitosEspeciaisValor9 + DebitosEspeciaisValor10
		) + 
		COALESCE((	SELECT SUM(ValorICMS) FROM rtE110 WHERE	SUBSTRING(CodigoAjuste,3,1) = '7' AND SUBSTRING(CodigoAjuste,4,1) = '0' ),0)
		),'.',',')	+ '|',
'E110',
'E',
999999,
getdate(),
0,
0,
51,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
WHERE
CodigoEmpresa = @CodigoEmpresa AND
CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo

declare @SequenciaE111 numeric(2)

--- E111
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosDebitosValor1 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos)) = '' THEN
	tbLocal.UFLocal + '0' + '0' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosDebitosDescricao1,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosDebitosDescricao1
ELSE
	'AJUSTES DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosDebitosValor1),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
1,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
OutrosDebitosValor1 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosDebitosValor2 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos2)) = '' THEN
	tbLocal.UFLocal + '0' + '0' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos2))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosDebitosDescricao2,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosDebitosDescricao2
ELSE
	'AJUSTES DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosDebitosValor2),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
2,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
OutrosDebitosValor2 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosDebitosValor3 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos3)) = '' THEN
	tbLocal.UFLocal + '0' + '0' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos3))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosDebitosDescricao3,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosDebitosDescricao3
ELSE
	'AJUSTES DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosDebitosValor3),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
3,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
OutrosDebitosValor3 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosDebitosValor4 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos4)) = '' THEN
	tbLocal.UFLocal + '0' + '0' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos4))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosDebitosDescricao4,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosDebitosDescricao4
ELSE
	'AJUSTES DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosDebitosValor4),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
4,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
OutrosDebitosValor4 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosDebitosValor5 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos5)) = '' THEN
	tbLocal.UFLocal + '0' + '0' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos5))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosDebitosDescricao5,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosDebitosDescricao5
ELSE
	'AJUSTES DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosDebitosValor5),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
4,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
OutrosDebitosValor5 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosDebitosValor6 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos6)) = '' THEN
	tbLocal.UFLocal + '0' + '0' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos6))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosDebitosDescricao6,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosDebitosDescricao6
ELSE
	'AJUSTES DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosDebitosValor6),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
4,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
OutrosDebitosValor6 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosDebitosValor7 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos7)) = '' THEN
	tbLocal.UFLocal + '0' + '0' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos7))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosDebitosDescricao7,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosDebitosDescricao7
ELSE
	'AJUSTES DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosDebitosValor7),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
4,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
OutrosDebitosValor7 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosDebitosValor8 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos8)) = '' THEN
	tbLocal.UFLocal + '0' + '0' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos8))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosDebitosDescricao8,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosDebitosDescricao8
ELSE
	'AJUSTES DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosDebitosValor8),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
4,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
OutrosDebitosValor8 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosDebitosValor9 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos9)) = '' THEN
	tbLocal.UFLocal + '0' + '0' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos9))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosDebitosDescricao9,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosDebitosDescricao9
ELSE
	'AJUSTES DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosDebitosValor9),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
4,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
OutrosDebitosValor9 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosDebitosValor10 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos10)) = '' THEN
	tbLocal.UFLocal + '0' + '0' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosDebitos10))
END +  '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosDebitosDescricao10,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosDebitosDescricao10
ELSE
	'AJUSTES DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosDebitosValor10),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
4,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
OutrosDebitosValor10 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosCreditosValor1 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos)) = '' THEN
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos))
END +  '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosCreditosDescricao1,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosCreditosDescricao1
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosCreditosValor1),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
5,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
EstornosCreditosValor1 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosCreditosValor2 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos2)) = '' THEN
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos2))
END +  '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosCreditosDescricao2,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosCreditosDescricao2
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosCreditosValor2),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
6,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
EstornosCreditosValor2 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosCreditosValor3 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos3)) = '' THEN
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos3))
END +  '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosCreditosDescricao3,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosCreditosDescricao3
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosCreditosValor3),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
7,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
EstornosCreditosValor3 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosCreditosValor4 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos4)) = '' THEN
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos4))
END +  '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosCreditosDescricao4,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosCreditosDescricao4
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosCreditosValor4),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
8,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
EstornosCreditosValor4 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosCreditosValor5 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos5)) = '' THEN			
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos5))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosCreditosDescricao5,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosCreditosDescricao5
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosCreditosValor5),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
9,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
EstornosCreditosValor5 <> 0			

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosCreditosValor6 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos6)) = '' THEN			
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos6))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosCreditosDescricao6,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosCreditosDescricao6
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosCreditosValor6),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
10,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
EstornosCreditosValor6 <> 0			

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosCreditosValor7 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos7)) = '' THEN			
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos7))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosCreditosDescricao7,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosCreditosDescricao7
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosCreditosValor7),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
11,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
EstornosCreditosValor7 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosCreditosValor8 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos8)) = '' THEN			
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos8))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosCreditosDescricao8,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosCreditosDescricao8
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosCreditosValor8),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
12,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
EstornosCreditosValor8 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosCreditosValor9 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos9)) = '' THEN			
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos9))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosCreditosDescricao9,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosCreditosDescricao9
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosCreditosValor9),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
13,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
EstornosCreditosValor9 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosCreditosValor10 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos10)) = '' THEN			
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos10))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosCreditosDescricao10,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosCreditosDescricao10
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosCreditosValor10),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
14,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
EstornosCreditosValor10 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosCreditosValor1 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos)) = '' THEN
	tbLocal.UFLocal + '0' + '2' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosCreditosDescricao1,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosCreditosDescricao1
ELSE
	'AJUSTES CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosCreditosValor1),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
15,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
OutrosCreditosValor1 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosCreditosValor2 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos2)) = '' THEN
	tbLocal.UFLocal + '0' + '2' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos2))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosCreditosDescricao2,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosCreditosDescricao2
ELSE
	'AJUSTES CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosCreditosValor2),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
16,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
OutrosCreditosValor2 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosCreditosValor3 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos3)) = '' THEN
	tbLocal.UFLocal + '0' + '2' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos3))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosCreditosDescricao3,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosCreditosDescricao3
ELSE
	'AJUSTES CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosCreditosValor3),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
17,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
OutrosCreditosValor3 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosCreditosValor4 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos4)) = '' THEN
	tbLocal.UFLocal + '0' + '2' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos4))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosCreditosDescricao4,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosCreditosDescricao4
ELSE
	'AJUSTES CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosCreditosValor4),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
18,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
OutrosCreditosValor4 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosCreditosValor5 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos5)) = '' THEN			
	tbLocal.UFLocal + '0' + '2' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos5))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosCreditosDescricao5,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosCreditosDescricao5
ELSE
	'AJUSTES CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosCreditosValor5),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
19,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
OutrosCreditosValor5 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosCreditosValor6 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos6)) = '' THEN			
	tbLocal.UFLocal + '0' + '2' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos6))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosCreditosDescricao6,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosCreditosDescricao6
ELSE
	'AJUSTES CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosCreditosValor6),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
20,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
OutrosCreditosValor6 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosCreditosValor7 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos7)) = '' THEN			
	tbLocal.UFLocal + '0' + '2' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos7))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosCreditosDescricao7,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosCreditosDescricao7
ELSE
	'AJUSTES CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosCreditosValor7),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
21,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
OutrosCreditosValor7 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosCreditosValor8 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos8)) = '' THEN			
	tbLocal.UFLocal + '0' + '2' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos8))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosCreditosDescricao8,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosCreditosDescricao8
ELSE
	'AJUSTES CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosCreditosValor8),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
22,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
OutrosCreditosValor8 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosCreditosValor9 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos9)) = '' THEN			
	tbLocal.UFLocal + '0' + '2' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos9))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosCreditosDescricao9,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosCreditosDescricao9
ELSE
	'AJUSTES CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosCreditosValor9),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
23,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
OutrosCreditosValor9 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			OutrosCreditosValor10 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos10)) = '' THEN			
	tbLocal.UFLocal + '0' + '2' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos10))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.OutrosCreditosDescricao10,''))) <> '' THEN
	tbMovimentacaoIPIICMS.OutrosCreditosDescricao10
ELSE
	'AJUSTES CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosCreditosValor10),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
24,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
OutrosCreditosValor10 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosDebitosValor1 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos)) = '' THEN
	tbLocal.UFLocal + '0' + '3' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos))
END  + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosDebitosDescricao1,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosDebitosDescricao1
ELSE
	'ESTORNO DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosDebitosValor1),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
25,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
EstornosDebitosValor1 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosDebitosValor2 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos2)) = '' THEN
	tbLocal.UFLocal + '0' + '3' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos2))
END  + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosDebitosDescricao2,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosDebitosDescricao2
ELSE
	'ESTORNO DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosDebitosValor2),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
26,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
EstornosDebitosValor2 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosDebitosValor3 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos3)) = '' THEN
	tbLocal.UFLocal + '0' + '3' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos3))
END  + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosDebitosDescricao3,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosDebitosDescricao3
ELSE
	'ESTORNO DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosDebitosValor3),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
27,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
EstornosDebitosValor3 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosDebitosValor4 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos4)) = '' THEN
	tbLocal.UFLocal + '0' + '3' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos4))
END  + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosDebitosDescricao4,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosDebitosDescricao4
ELSE
	'ESTORNO DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosDebitosValor4),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
28,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
EstornosDebitosValor4 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosDebitosValor5 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos5)) = '' THEN			
	tbLocal.UFLocal + '0' + '3' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos5))		
END  + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosDebitosDescricao5,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosDebitosDescricao5
ELSE
	'ESTORNO DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosDebitosValor5),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
29,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
EstornosDebitosValor5 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosDebitosValor6 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos6)) = '' THEN			
	tbLocal.UFLocal + '0' + '3' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos6))		
END  + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosDebitosDescricao6,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosDebitosDescricao6
ELSE
	'ESTORNO DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosDebitosValor6),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
30,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
EstornosDebitosValor6 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosDebitosValor7 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos7)) = '' THEN			
	tbLocal.UFLocal + '0' + '3' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos7))		
END  + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosDebitosDescricao7,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosDebitosDescricao7
ELSE
	'ESTORNO DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosDebitosValor7),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
31,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
EstornosDebitosValor7 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosDebitosValor8 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos8)) = '' THEN			
	tbLocal.UFLocal + '0' + '3' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos8))		
END  + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosDebitosDescricao8,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosDebitosDescricao8
ELSE
	'ESTORNO DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosDebitosValor8),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
32,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
EstornosDebitosValor8 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosDebitosValor9 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos9)) = '' THEN			
	tbLocal.UFLocal + '0' + '3' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos9))		
END  + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosDebitosDescricao9,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosDebitosDescricao9
ELSE
	'ESTORNO DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosDebitosValor9),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
33,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
EstornosDebitosValor9 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			EstornosDebitosValor10 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos10)) = '' THEN			
	tbLocal.UFLocal + '0' + '3' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoDebitos10))		
END  + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.EstornosDebitosDescricao10,''))) <> '' THEN
	tbMovimentacaoIPIICMS.EstornosDebitosDescricao10
ELSE
	'ESTORNO DEBITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosDebitosValor10),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
34,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
EstornosDebitosValor10 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DeducoesValor1 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes)) = '' THEN
	tbLocal.UFLocal + '0' + '4' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DeducoesDescricao1,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DeducoesDescricao1
ELSE
	'DEDUCOES'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DeducoesValor1),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
35,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
DeducoesValor1 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DeducoesValor2 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes2)) = '' THEN
	tbLocal.UFLocal + '0' + '4' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes2))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DeducoesDescricao2,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DeducoesDescricao2
ELSE
	'DEDUCOES'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DeducoesValor2),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
36,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
DeducoesValor2 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DeducoesValor3 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes3)) = '' THEN
	tbLocal.UFLocal + '0' + '4' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes3))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DeducoesDescricao3,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DeducoesDescricao3
ELSE
	'DEDUCOES'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DeducoesValor3),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
37,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
DeducoesValor3 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DeducoesValor4 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes4)) = '' THEN
	tbLocal.UFLocal + '0' + '4' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes4))
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DeducoesDescricao4,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DeducoesDescricao4
ELSE
	'DEDUCOES'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DeducoesValor4),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
38,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
DeducoesValor4 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DeducoesValor5 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes5)) = '' THEN			
	tbLocal.UFLocal + '0' + '4' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes5))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DeducoesDescricao5,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DeducoesDescricao5
ELSE
	'DEDUCOES'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DeducoesValor5),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
39,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
DeducoesValor5 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DeducoesValor6 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes6)) = '' THEN			
	tbLocal.UFLocal + '0' + '4' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes6))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DeducoesDescricao6,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DeducoesDescricao6
ELSE
	'DEDUCOES'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DeducoesValor6),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
40,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
DeducoesValor6 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DeducoesValor7 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes7)) = '' THEN			
	tbLocal.UFLocal + '0' + '4' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes7))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DeducoesDescricao7,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DeducoesDescricao7
ELSE
	'DEDUCOES'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DeducoesValor7),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
41,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
DeducoesValor7 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DeducoesValor8 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes8)) = '' THEN			
	tbLocal.UFLocal + '0' + '4' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes8))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DeducoesDescricao8,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DeducoesDescricao8
ELSE
	'DEDUCOES'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DeducoesValor8),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
42,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
DeducoesValor8 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DeducoesValor9 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes9)) = '' THEN			
	tbLocal.UFLocal + '0' + '4' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes9))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DeducoesDescricao9,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DeducoesDescricao9
ELSE
	'DEDUCOES'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DeducoesValor9),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
43,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
DeducoesValor9 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DeducoesValor10 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes10)) = '' THEN			
	tbLocal.UFLocal + '0' + '4' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes10))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DeducoesDescricao10,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DeducoesDescricao10
ELSE
	'DEDUCOES'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DeducoesValor10),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
44,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
DeducoesValor10 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DebitosEspeciaisValor1 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais1)) = '' THEN
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais1))
END +  '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao1,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao1
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DebitosEspeciaisValor1),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
5,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
DebitosEspeciaisValor1 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DebitosEspeciaisValor2 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais2)) = '' THEN
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais2))
END +  '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao2,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao2
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DebitosEspeciaisValor2),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
6,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
DebitosEspeciaisValor2 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DebitosEspeciaisValor3 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais3)) = '' THEN
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais3))
END +  '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao3,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao3
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DebitosEspeciaisValor3),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
7,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
DebitosEspeciaisValor3 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DebitosEspeciaisValor4 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais4)) = '' THEN
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais4))
END +  '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao4,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao4
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DebitosEspeciaisValor4),'.',',') + '|',
'E111',
'E',
999999,
getdate(),
0,
8,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND
TipoImposto = 1 AND
NumeroRecolhimento = 1 AND
Periodo = @Periodo AND
DebitosEspeciaisValor4 <> 0

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DebitosEspeciaisValor5 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais5)) = '' THEN			
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais5))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao5,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao5
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DebitosEspeciaisValor5),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
9,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
DebitosEspeciaisValor5 <> 0			

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DebitosEspeciaisValor6 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais6)) = '' THEN			
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais6))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao6,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao6
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DebitosEspeciaisValor6),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
10,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
DebitosEspeciaisValor6 <> 0			

IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DebitosEspeciaisValor7 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais7)) = '' THEN			
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais7))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao7,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao7
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DebitosEspeciaisValor7),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
11,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
DebitosEspeciaisValor7 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DebitosEspeciaisValor8 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais8)) = '' THEN			
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais8))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao8,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao8
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DebitosEspeciaisValor8),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
12,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
DebitosEspeciaisValor8 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DebitosEspeciaisValor9 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais9)) = '' THEN			
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais9))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao9,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao9
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DebitosEspeciaisValor9),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
13,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
DebitosEspeciaisValor9 <> 0			
			
IF EXISTS ( SELECT 1 FROM tbMovimentacaoIPIICMS (NOLOCK)			
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			TipoImposto = 1 AND
			NumeroRecolhimento = 1 AND
			Periodo = @Periodo AND
			DebitosEspeciaisValor10 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1
			
INSERT rtSPEDFiscal			
SELECT			
@@spid,			
'|E111|' +			
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais10)) = '' THEN			
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 		
ELSE			
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDebitosEspeciais10))		
END + '|' +
RTRIM(LTRIM(CASE WHEN RTRIM(LTRIM(COALESCE(tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao10,''))) <> '' THEN
	tbMovimentacaoIPIICMS.DebitosEspeciaisDescricao10
ELSE
	'ESTORNO CREDITOS'
END)) + '|' + 
REPLACE(CONVERT(VARCHAR(16),DebitosEspeciaisValor10),'.',',') + '|',			
'E111',			
'E',			
999999,
getdate(),			
0,
14,
52,
'',
0,
'',
0
FROM tbMovimentacaoIPIICMS (NOLOCK)			
INNER JOIN tbLocal (NOLOCK) ON			
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND			
           tbLocal.CodigoLocal = @CodigoLocal 			
WHERE			
tbMovimentacaoIPIICMS.CodigoEmpresa = @CodigoEmpresa AND			
tbMovimentacaoIPIICMS.CodigoLocal = @CodigoLocal AND			
TipoImposto = 1 AND			
NumeroRecolhimento = 1 AND			
Periodo = @Periodo AND			
DebitosEspeciaisValor10 <> 0			
			
--- e116

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E116|' + CodigoObrigacao + '|' + 
REPLACE(CONVERT(VARCHAR(16),Valor),'.',',') + '|' +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,DataVencto)),2,2) +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,DataVencto)),2,2) +
CONVERT(CHAR(4),DATEPART(year,DataVencto)) + '|' +
RTRIM(LTRIM(CodigoReceita)) + '|' +
RTRIM(LTRIM(NumeroProcesso)) + '|' +
RTRIM(LTRIM(IndicadorOrigem)) + '|' +
RTRIM(LTRIM(DescricaoProcesso)) + '|' +
RTRIM(LTRIM(DescricaoComplementar)) + '|' +
CASE WHEN CONVERT(numeric(4),@Versao) <= 3 THEN
	''
ELSE
	RIGHT(@Periodo,2) + LEFT(@Periodo,4) + '|'	
END,
'E116',
'E',
999999,
getdate(),
0,
convert(numeric(3),CodigoObrigacao),
53,
'',
0,
'',
0
FROM tbSPEDFiscalE116 (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
WHERE
tbSPEDFiscalE116.CodigoEmpresa = @CodigoEmpresa AND
tbSPEDFiscalE116.CodigoLocal = @CodigoLocal AND
tbSPEDFiscalE116.Periodo = @Periodo 

---

INSERT rtSPEDFiscal
SELECT DISTINCT
@@spid,
'|E100|' + 
COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|' + 
COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataFinal)),2,2) +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataFinal)),2,2) +
CONVERT(CHAR(4),DATEPART(year,@DataFinal)),'') + '|',
'E100',
'E',
999999,
getdate(),
0,
0,
50,
'',
0,
'',
0
FROM rtSPEDFiscal
WHERE
Spid = @@spid and
EXISTS ( SELECT 1 FROM rtSPEDFiscal where Spid = @@spid AND TipoRegistro = 'E110' )

--- Apuração ST
DECLARE @ContaRegistros numeric(3)
DECLARE @curUF char(2)
DECLARE @SaldoDevedorSemDeducoes money
DECLARE @ImpostoRecolher money
DECLARE @SaldoCredorTransportar money

SELECT @ContaRegistros = 54

DECLARE curST INSENSITIVE CURSOR FOR
SELECT
UF
FROM tbSPEDFiscalE200
WHERE
CodigoEmpresa = @CodigoEmpresa AND
CodigoLocal = @CodigoLocal AND
Periodo = @Periodo

OPEN curST

FETCH NEXT FROM curST INTO 
@curUF

WHILE (@@fetch_status <> -1)
BEGIN

	INSERT rtSPEDFiscal
	SELECT 
	@@spid,
	'|E200|' + 
	@curUF + '|' +
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|' + 
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataFinal)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataFinal)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,@DataFinal)),'') + '|',
	'E200',
	'E',
	999999,
	getdate(),
	0,
	0,
	@ContaRegistros,
	'',
	0,
	'',
	0

    SELECT @SaldoDevedorSemDeducoes = ( Retencao + OutrosDebitos + AjustesDebitos ) - ( SaldoCredorAnterior + Devolucao + Ressarcimento + OutrosCreditos + AjustesCreditos)
	FROM tbSPEDFiscalE200 (NOLOCK)
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	Periodo = @Periodo AND
    UF = @curUF

	IF @SaldoDevedorSemDeducoes < 0 SELECT @SaldoDevedorSemDeducoes = 0

    IF @SaldoDevedorSemDeducoes > 0 
	BEGIN
        SELECT @ImpostoRecolher = @SaldoDevedorSemDeducoes - Deducoes
		FROM tbSPEDFiscalE200 (NOLOCK)
		WHERE
		CodigoEmpresa = @CodigoEmpresa AND
		CodigoLocal = @CodigoLocal AND
		Periodo = @Periodo AND
		UF = @curUF
	END
    ELSE
	BEGIN
        SELECT @ImpostoRecolher = 0
    END

    SELECT @SaldoCredorTransportar = (SaldoCredorAnterior + Devolucao + Ressarcimento + OutrosCreditos + AjustesCreditos) - ( Retencao + OutrosDebitos + AjustesDebitos)
	FROM tbSPEDFiscalE200 (NOLOCK)
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	Periodo = @Periodo AND
	UF = @curUF

    If @SaldoCredorTransportar < 0 SELECT @SaldoCredorTransportar = 0

	SELECT @ContaRegistros = @ContaRegistros + 1

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|E210|1|' +
	REPLACE(CONVERT(VARCHAR(16),SaldoCredorAnterior),'.',',') + '|' +    --3
	REPLACE(CONVERT(VARCHAR(16),Devolucao),'.',',') + '|' + --4
	REPLACE(CONVERT(VARCHAR(16),Ressarcimento),'.',',') + '|' + --5
	REPLACE(CONVERT(VARCHAR(16),OutrosCreditos),'.',',') + '|' + --6
	REPLACE(CONVERT(VARCHAR(16),AjustesCreditos),'.',',') + '|' + --7
	REPLACE(CONVERT(VARCHAR(16),Retencao),'.',',') + '|' + --8
	REPLACE(CONVERT(VARCHAR(16),OutrosDebitos),'.',',') + '|' + --9
	REPLACE(CONVERT(VARCHAR(16),AjustesDebitos),'.',',') + '|' + --10
	REPLACE(CONVERT(VARCHAR(16),@SaldoDevedorSemDeducoes),'.',',') + '|' + --11
	REPLACE(CONVERT(VARCHAR(16),Deducoes),'.',',') + '|' + --12
	REPLACE(CONVERT(VARCHAR(16),@ImpostoRecolher),'.',',') + '|' + --13
	REPLACE(CONVERT(VARCHAR(16),@SaldoCredorTransportar),'.',',') + '|' + --14
	REPLACE(CONVERT(VARCHAR(16),ExtraApuracao),'.',',') + '|', + ---15
	'E210',
	'E',
	999999,
	getdate(),
	0,
	0,
	@ContaRegistros,
	'',
	0,
	'',
	0
	FROM tbSPEDFiscalE200 (NOLOCK)
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	Periodo = @Periodo AND
    UF = @curUF

	--- E220

	SELECT @ContaRegistros = @ContaRegistros + 1

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|E220|' + 
	CONVERT(VARCHAR(8),CodigoAjuste) + '||' +
	REPLACE(CONVERT(VARCHAR(16),( OutrosCreditos + OutrosDebitos + Deducoes + ExtraApuracao )),'.',',') + '|',
	'E220',
	'E',
	999999,
	getdate(),
	0,
	0,
	@ContaRegistros,
	'',
	0,
	'',
	0
	FROM tbSPEDFiscalE200 (NOLOCK)
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	Periodo = @Periodo AND
    UF = @curUF AND
	( OutrosCreditos + OutrosDebitos + Deducoes + ExtraApuracao ) <> 0

	SELECT @ContaRegistros = @ContaRegistros + 1

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|E250|' + CodigoObrigacao + '|' + 
	REPLACE(CONVERT(VARCHAR(16),Valor),'.',',') + '|' +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,DataVencto)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,DataVencto)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,DataVencto)) + '|' +
	RTRIM(LTRIM(CodigoReceita)) + '|' +
	RTRIM(LTRIM(NumeroProcesso)) + '|' +
	RTRIM(LTRIM(IndicadorOrigem)) + '|' +
	RTRIM(LTRIM(DescricaoProcesso)) + '|' +
	RTRIM(LTRIM(DescricaoComplementar)) + '|' +
	CASE WHEN CONVERT(numeric(4),@Versao) <= 3 THEN
		''
	ELSE
		RIGHT(@Periodo,2) + LEFT(@Periodo,4) + '|'	
	END,
	'E250',
	'E',
	999999,
	getdate(),
	0,
	0,
	@ContaRegistros,
	'',
	0,
	'',
	0
	FROM tbSPEDFiscalE250 (NOLOCK)
	INNER JOIN tbLocal (NOLOCK) ON
			   tbLocal.CodigoEmpresa = @CodigoEmpresa AND
			   tbLocal.CodigoLocal = @CodigoLocal 
	WHERE
	tbSPEDFiscalE250.CodigoEmpresa = @CodigoEmpresa AND
	tbSPEDFiscalE250.CodigoLocal = @CodigoLocal AND
	tbSPEDFiscalE250.Periodo = @Periodo AND
    tbSPEDFiscalE250.UF = @curUF

	SELECT @ContaRegistros = @ContaRegistros + 1

	FETCH NEXT FROM curST INTO 
	@curUF

END

CLOSE curST
DEALLOCATE curST


IF CONVERT(NUMERIC(4),@Versao) >= 10
BEGIN
	---- PERÍODO APURAÇÃO DIFAL (DIFERENCIAL ALÍQUOTA) DECORRENTE DA PARTILHA DE ICMS
	-- Estados com apuração do ICMS Partilha
	INSERT rtSPEDFiscal
	SELECT 
	@@spid,
		'|E300|'
	+	mipt.UF + '|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|' + 
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataFinal)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataFinal)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataFinal)),'') + '|',
	'E300',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal AND
				mipt.Periodo = @Periodo
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal

	-- Estados com inscrição estadual
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E300|'
	+	iest.UFDestino + '|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|' + 
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataFinal)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataFinal)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataFinal)),'') + '|',
	'E300',
	iest.UFDestino,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbInscricaoEstadualST iest (NOLOCK) ON
				iest.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				iest.CodigoLocal = tbLocal.CodigoLocal AND
				iest.UFOrigem = tbLocal.UFLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				NOT EXISTS (	SELECT 1 FROM rtSPEDFiscal
								WHERE Spid = @@spid AND
								TipoRegistro = 'E300' AND
								EntradaSaida = iest.UFDestino	)

	---- APURAÇÃO DIFAL (DIFERENCIAL ALÍQUOTA) DECORRENTE DA PARTILHA DE ICMS
	create table #E310 (
		CodigoEmpresa numeric(4),
		CodigoLocal numeric(4),
		Periodo char(6),
		UF char(2),
		OutrosDebitosDifal money,
		OutrosCreditosDifal money,
		DeducoesDifal money,
		DebitoEspecialDifal money,
		OutrosDebitosFCP money,
		OutrosCreditosFCP money,
		DeducoesFCP money,
		DebitoEspecialFCP money
	)

	create table #AjustesDifal (
		CodigoEmpresa numeric(4),
		CodigoLocal numeric(4),
		Periodo char(6),
		UF char(2),
		CodigoAjuste varchar(8),
		DescricaoAjuste varchar(60),
		ValorAjuste money,
		Observacao varchar(255)
	)
	
	-- Ajustes Outros Débitos
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosDebitosCodigo1,OutrosDebitosDescricao1,OutrosDebitosValor1,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosDebitosCodigo1,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosDebitosCodigo2,OutrosDebitosDescricao2,OutrosDebitosValor2,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosDebitosCodigo2,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosDebitosCodigo3,OutrosDebitosDescricao3,OutrosDebitosValor3,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosDebitosCodigo3,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosDebitosCodigo4,OutrosDebitosDescricao4,OutrosDebitosValor4,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosDebitosCodigo4,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosDebitosCodigo5,OutrosDebitosDescricao5,OutrosDebitosValor5,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosDebitosCodigo5,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosDebitosCodigo6,OutrosDebitosDescricao6,OutrosDebitosValor6,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosDebitosCodigo6,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosDebitosCodigo7,OutrosDebitosDescricao7,OutrosDebitosValor7,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosDebitosCodigo7,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosDebitosCodigo8,OutrosDebitosDescricao8,OutrosDebitosValor8,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosDebitosCodigo8,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosDebitosCodigo9,OutrosDebitosDescricao9,OutrosDebitosValor9,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosDebitosCodigo9,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosDebitosCodigo10,OutrosDebitosDescricao10,OutrosDebitosValor10,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosDebitosCodigo10,''))) <> ''

	-- Ajustes Outros Créditos
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosCreditosCodigo1,OutrosCreditosDescricao1,OutrosCreditosValor1,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosCreditosCodigo1,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosCreditosCodigo2,OutrosCreditosDescricao2,OutrosCreditosValor2,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosCreditosCodigo2,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosCreditosCodigo3,OutrosCreditosDescricao3,OutrosCreditosValor3,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosCreditosCodigo3,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosCreditosCodigo4,OutrosCreditosDescricao4,OutrosCreditosValor4,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosCreditosCodigo4,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosCreditosCodigo5,OutrosCreditosDescricao5,OutrosCreditosValor5,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosCreditosCodigo5,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosCreditosCodigo6,OutrosCreditosDescricao6,OutrosCreditosValor6,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosCreditosCodigo6,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosCreditosCodigo7,OutrosCreditosDescricao7,OutrosCreditosValor7,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosCreditosCodigo7,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosCreditosCodigo8,OutrosCreditosDescricao8,OutrosCreditosValor8,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosCreditosCodigo8,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosCreditosCodigo9,OutrosCreditosDescricao9,OutrosCreditosValor9,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosCreditosCodigo9,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,OutrosCreditosCodigo10,OutrosCreditosDescricao10,OutrosCreditosValor10,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(OutrosCreditosCodigo10,''))) <> ''

	-- Ajustes Deduções
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,DeducoesCodigo1,DeducoesDescricao1,DeducoesValor1,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(DeducoesCodigo1,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,DeducoesCodigo2,DeducoesDescricao2,DeducoesValor2,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(DeducoesCodigo2,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,DeducoesCodigo3,DeducoesDescricao3,DeducoesValor3,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(DeducoesCodigo3,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,DeducoesCodigo4,DeducoesDescricao4,DeducoesValor4,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(DeducoesCodigo4,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,DeducoesCodigo5,DeducoesDescricao5,DeducoesValor5,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(DeducoesCodigo5,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,DeducoesCodigo6,DeducoesDescricao6,DeducoesValor6,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(DeducoesCodigo6,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,DeducoesCodigo7,DeducoesDescricao7,DeducoesValor7,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(DeducoesCodigo7,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,DeducoesCodigo8,DeducoesDescricao8,DeducoesValor8,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(DeducoesCodigo8,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,DeducoesCodigo9,DeducoesDescricao9,DeducoesValor9,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(DeducoesCodigo9,''))) <> ''
	insert #AjustesDifal select CodigoEmpresa,CodigoLocal,Periodo,UF,DeducoesCodigo10,DeducoesDescricao10,DeducoesValor10,Observacao from tbMovtoICMSPartilha where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and Periodo = @Periodo and rtrim(ltrim(coalesce(DeducoesCodigo10,''))) <> ''

	insert #E310
	select distinct
		CodigoEmpresa,
		CodigoLocal,
		Periodo,
		UF,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0
	from tbMovtoICMSPartilha
	where 
		CodigoEmpresa = @CodigoEmpresa
	and	CodigoLocal = @CodigoLocal 
	and	Periodo = @Periodo

	update #E310
	set OutrosDebitosDifal = coalesce(
		(	select sum(ValorAjuste)
			from #AjustesDifal where
				#AjustesDifal.CodigoEmpresa = #E310.CodigoEmpresa
			and	#AjustesDifal.CodigoLocal = #E310.CodigoLocal
			and #AjustesDifal.Periodo = #E310.Periodo
			and #AjustesDifal.UF = #E310.UF
			and SUBSTRING(#AjustesDifal.CodigoAjuste,3,1) = '2' AND SUBSTRING(#AjustesDifal.CodigoAjuste,4,1) IN ('0','1')
			group by
				#AjustesDifal.CodigoEmpresa,
				#AjustesDifal.CodigoLocal,
				#AjustesDifal.Periodo,
				#AjustesDifal.UF
		),0)
	where
		#E310.CodigoEmpresa = @CodigoEmpresa
	and	#E310.CodigoLocal = @CodigoLocal
	and #E310.Periodo = @Periodo

	update #E310
	set OutrosCreditosDifal = coalesce(
		(	select sum(ValorAjuste)
			from #AjustesDifal where
				#AjustesDifal.CodigoEmpresa = #E310.CodigoEmpresa
			and	#AjustesDifal.CodigoLocal = #E310.CodigoLocal
			and #AjustesDifal.Periodo = #E310.Periodo
			and #AjustesDifal.UF = #E310.UF
			and SUBSTRING(#AjustesDifal.CodigoAjuste,3,1) = '2' AND SUBSTRING(#AjustesDifal.CodigoAjuste,4,1) IN ('2','3')
			group by
				#AjustesDifal.CodigoEmpresa,
				#AjustesDifal.CodigoLocal,
				#AjustesDifal.Periodo,
				#AjustesDifal.UF
		),0)
	where
		#E310.CodigoEmpresa = @CodigoEmpresa
	and	#E310.CodigoLocal = @CodigoLocal
	and #E310.Periodo = @Periodo

	update #E310
	set DeducoesDifal = coalesce(
		(	select sum(ValorAjuste)
			from #AjustesDifal where
				#AjustesDifal.CodigoEmpresa = #E310.CodigoEmpresa
			and	#AjustesDifal.CodigoLocal = #E310.CodigoLocal
			and #AjustesDifal.Periodo = #E310.Periodo
			and #AjustesDifal.UF = #E310.UF
			and SUBSTRING(#AjustesDifal.CodigoAjuste,3,1) = '2' AND SUBSTRING(#AjustesDifal.CodigoAjuste,4,1) IN ('4')
			group by
				#AjustesDifal.CodigoEmpresa,
				#AjustesDifal.CodigoLocal,
				#AjustesDifal.Periodo,
				#AjustesDifal.UF
		),0)
	where
		#E310.CodigoEmpresa = @CodigoEmpresa
	and	#E310.CodigoLocal = @CodigoLocal
	and #E310.Periodo = @Periodo

	update #E310
	set DebitoEspecialDifal = coalesce(
		(	select sum(ValorAjuste)
			from #AjustesDifal where
				#AjustesDifal.CodigoEmpresa = #E310.CodigoEmpresa
			and	#AjustesDifal.CodigoLocal = #E310.CodigoLocal
			and #AjustesDifal.Periodo = #E310.Periodo
			and #AjustesDifal.UF = #E310.UF
			and SUBSTRING(#AjustesDifal.CodigoAjuste,3,1) = '2' AND SUBSTRING(#AjustesDifal.CodigoAjuste,4,1) IN ('5')
			group by
				#AjustesDifal.CodigoEmpresa,
				#AjustesDifal.CodigoLocal,
				#AjustesDifal.Periodo,
				#AjustesDifal.UF
		),0)
	where
		#E310.CodigoEmpresa = @CodigoEmpresa
	and	#E310.CodigoLocal = @CodigoLocal
	and #E310.Periodo = @Periodo


	update #E310
	set OutrosDebitosFCP =  coalesce(
		(	select sum(ValorAjuste)
			from #AjustesDifal where
				#AjustesDifal.CodigoEmpresa = #E310.CodigoEmpresa
			and	#AjustesDifal.CodigoLocal = #E310.CodigoLocal
			and #AjustesDifal.Periodo = #E310.Periodo
			and #AjustesDifal.UF = #E310.UF
			and SUBSTRING(#AjustesDifal.CodigoAjuste,3,1) = '3' AND SUBSTRING(#AjustesDifal.CodigoAjuste,4,1) IN ('0','1')
			group by
				#AjustesDifal.CodigoEmpresa,
				#AjustesDifal.CodigoLocal,
				#AjustesDifal.Periodo,
				#AjustesDifal.UF
		),0)
	where
		#E310.CodigoEmpresa = @CodigoEmpresa
	and	#E310.CodigoLocal = @CodigoLocal
	and #E310.Periodo = @Periodo

	update #E310
	set OutrosCreditosFCP =  coalesce(
		(	select sum(ValorAjuste)
			from #AjustesDifal where
				#AjustesDifal.CodigoEmpresa = #E310.CodigoEmpresa
			and	#AjustesDifal.CodigoLocal = #E310.CodigoLocal
			and #AjustesDifal.Periodo = #E310.Periodo
			and #AjustesDifal.UF = #E310.UF
			and SUBSTRING(#AjustesDifal.CodigoAjuste,3,1) = '3' AND SUBSTRING(#AjustesDifal.CodigoAjuste,4,1) IN ('2','3')
			group by
				#AjustesDifal.CodigoEmpresa,
				#AjustesDifal.CodigoLocal,
				#AjustesDifal.Periodo,
				#AjustesDifal.UF
		),0)
	where
		#E310.CodigoEmpresa = @CodigoEmpresa
	and	#E310.CodigoLocal = @CodigoLocal
	and #E310.Periodo = @Periodo

	update #E310
	set DeducoesFCP =  coalesce(
		(	select sum(ValorAjuste)
			from #AjustesDifal where
				#AjustesDifal.CodigoEmpresa = #E310.CodigoEmpresa
			and	#AjustesDifal.CodigoLocal = #E310.CodigoLocal
			and #AjustesDifal.Periodo = #E310.Periodo
			and #AjustesDifal.UF = #E310.UF
			and SUBSTRING(#AjustesDifal.CodigoAjuste,3,1) = '3' AND SUBSTRING(#AjustesDifal.CodigoAjuste,4,1) IN ('4')
			group by
				#AjustesDifal.CodigoEmpresa,
				#AjustesDifal.CodigoLocal,
				#AjustesDifal.Periodo,
				#AjustesDifal.UF
		),0)
	where
		#E310.CodigoEmpresa = @CodigoEmpresa
	and	#E310.CodigoLocal = @CodigoLocal
	and #E310.Periodo = @Periodo

	update #E310
	set DebitoEspecialFCP =  coalesce(
		(	select sum(ValorAjuste)
			from #AjustesDifal where
				#AjustesDifal.CodigoEmpresa = #E310.CodigoEmpresa
			and	#AjustesDifal.CodigoLocal = #E310.CodigoLocal
			and #AjustesDifal.Periodo = #E310.Periodo
			and #AjustesDifal.UF = #E310.UF
			and SUBSTRING(#AjustesDifal.CodigoAjuste,3,1) = '3' AND SUBSTRING(#AjustesDifal.CodigoAjuste,4,1) IN ('5')
			group by
				#AjustesDifal.CodigoEmpresa,
				#AjustesDifal.CodigoLocal,
				#AjustesDifal.Periodo,
				#AjustesDifal.UF
		),0)
	where
		#E310.CodigoEmpresa = @CodigoEmpresa
	and	#E310.CodigoLocal = @CodigoLocal
	and #E310.Periodo = @Periodo
	
	-- Estados com apuração do ICMS Partilha
	if convert(numeric,@Versao) < 11
	begin
		insert rtSPEDFiscal
		select 
		@@spid,
			'|E310|'
		+	case when	(	coalesce(mipt.DebDifalMovtoICMSPartilha,0) +
							coalesce(mipt.DebFCPMovtoICMSPartilha,0) +
							coalesce(mipt.CreDifalMovtoICMSPartilha,0) +
							coalesce(mipt.CreFCPMovtoICMSPartilha,0)
						) <> 0
			then
				'1' -- Com movimento
			else
				'0' -- Sem movimento
			end + '|' -- IND_MOV_DIFAL
		+	replace(convert(varchar(16),coalesce(mipt.SaldoAnterior,0)),'.',',') + '|' -- VL_SLD_CRED_ANT_DIFAL
		+	replace(convert(varchar(16),coalesce(mipt.DebDifalMovtoICMSPartilha,0)),'.',',') + '|' -- VL_TOT_DEBITOS_DIFAL
		+	replace(convert(varchar(16),coalesce(#E310.OutrosDebitosDifal,0)),'.',',') + '|' -- VL_OUT_DEB_DIFAL
		+	replace(convert(varchar(16),coalesce(mipt.DebFCPMovtoICMSPartilha,0)),'.',',') + '|' -- VL_TOT_DEB_FCP
		+	replace(convert(varchar(16),coalesce(mipt.CreDifalMovtoICMSPartilha,0)),'.',',') + '|' -- VL_TOT_CREDITOS_DIFAL
		+	replace(convert(varchar(16),coalesce(mipt.CreFCPMovtoICMSPartilha,0)),'.',',') + '|' -- VL_TOT_CRED_FCP
		+	replace(convert(varchar(16),coalesce(#E310.OutrosCreditosDifal,0)),'.',',') + '|' -- VL_OUT_CRED_DIFAL
		+	replace(convert(varchar(16),coalesce(
				case when
					(	coalesce(mipt.DebDifalMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosDifal,0) +
						coalesce(mipt.DebFCPMovtoICMSPartilha,0)
					) - 
					(	coalesce(mipt.SaldoAnterior,0) +
						coalesce(mipt.CreDifalMovtoICMSPartilha,0) +
						coalesce(#E310.OutrosCreditosDifal,0) +
						coalesce(mipt.CreFCPMovtoICMSPartilha,0)
					) > 0
				then
					(	coalesce(mipt.DebDifalMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosDifal,0) +
						coalesce(mipt.DebFCPMovtoICMSPartilha,0)
					) - 
					(	coalesce(mipt.SaldoAnterior,0) +
						coalesce(mipt.CreDifalMovtoICMSPartilha,0) +
						coalesce(#E310.OutrosCreditosDifal,0) +
						coalesce(mipt.CreFCPMovtoICMSPartilha,0)
					)
				else
					0
				end,0)),'.',',') + '|' -- VL_SLD_DEV_ANT_DIFAL
		+	replace(convert(varchar(16),coalesce(#E310.DeducoesDifal,0)),'.',',') + '|' -- VL_DEDUÇÕES_DIFAL
		+	replace(convert(varchar(16),
				case when
					(	coalesce(mipt.DebDifalMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosDifal,0) +
						coalesce(mipt.DebFCPMovtoICMSPartilha,0)
					) - 
					(	coalesce(mipt.SaldoAnterior,0) +
						coalesce(mipt.CreDifalMovtoICMSPartilha,0) +
						coalesce(#E310.OutrosCreditosDifal,0) +
						coalesce(mipt.CreFCPMovtoICMSPartilha,0)
					) -
					coalesce(#E310.DeducoesDifal,0)
					> 0
				then
			
						(	coalesce(mipt.DebDifalMovtoICMSPartilha,0) + 
							coalesce(#E310.OutrosDebitosDifal,0) +
							coalesce(mipt.DebFCPMovtoICMSPartilha,0)
						) - 
							(	coalesce(mipt.SaldoAnterior,0) +
								coalesce(mipt.CreDifalMovtoICMSPartilha,0) +
								coalesce(#E310.OutrosCreditosDifal,0) +
								coalesce(mipt.CreFCPMovtoICMSPartilha,0)
							) -
							coalesce(#E310.DeducoesDifal,0)
				else
					0
				end),'.',',') + '|' -- VL_RECOL
		+	replace(convert(varchar(16), - 1 * (
				case when
					(	coalesce(mipt.DebDifalMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosDifal,0) +
						coalesce(mipt.DebFCPMovtoICMSPartilha,0)
					) - 
					(	coalesce(mipt.SaldoAnterior,0) +
						coalesce(mipt.CreDifalMovtoICMSPartilha,0) +
						coalesce(#E310.OutrosCreditosDifal,0) +
						coalesce(mipt.CreFCPMovtoICMSPartilha,0)
					) -
					coalesce(#E310.DeducoesDifal,0)
					< 0
				then
					(	coalesce(mipt.DebDifalMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosDifal,0) +
						coalesce(mipt.DebFCPMovtoICMSPartilha,0)
					) - 
					(	coalesce(mipt.SaldoAnterior,0) +
						coalesce(mipt.CreDifalMovtoICMSPartilha,0) +
						coalesce(#E310.OutrosCreditosDifal,0) +
						coalesce(mipt.CreFCPMovtoICMSPartilha,0)
					) -
					coalesce(#E310.DeducoesDifal,0)
				else
					0
				end)),'.',',') + '|' -- VL_SLD_CRED_TRANSPORTAR
		+	replace(convert(varchar(16),coalesce(#E310.DebitoEspecialDifal,0)),'.',',') + '|', -- DEB_ESP_DIFAL
		'E310',
		mipt.UF,
		999999,
		getdate(),
		0,
		0,
		0,
		'',
		0,
		'',
		0
		from tbMovtoICMSPartilha mipt (nolock)
		inner join #E310 (nolock) on
			#E310.CodigoEmpresa = mipt.CodigoEmpresa
		and	#E310.CodigoLocal = mipt.CodigoLocal
		and	#E310.Periodo = mipt.Periodo  collate SQL_Latin1_General_CP1_CS_AS
		and	#E310.UF = mipt.UF collate SQL_Latin1_General_CP1_CS_AS
		where
			mipt.CodigoEmpresa = @CodigoEmpresa
		and	mipt.CodigoLocal = @CodigoLocal
		and	mipt.Periodo = @Periodo
	end

	if convert(numeric,@Versao) >= 11
	begin
		insert rtSPEDFiscal
		select
		@@spid,
			'|E310|'
		+	case when	(	coalesce(mipt.DebDifalMovtoICMSPartilha,0) +
							coalesce(mipt.DebFCPMovtoICMSPartilha,0) +
							coalesce(mipt.CreDifalMovtoICMSPartilha,0) +
							coalesce(mipt.CreFCPMovtoICMSPartilha,0)
						) <> 0
			then
				'1' -- Com movimento
			else
				'0' -- Sem movimento
			end + '|' -- IND_MOV_DIFAL
			-- APURAÇÃO DIFAL ----------------------------------------------------------------------------------------------------
		+	replace(convert(varchar(16),coalesce(mipt.SaldoAnterior,0)),'.',',') + '|' -- VL_SLD_CRED_ANT_DIFAL
		+	replace(convert(varchar(16),coalesce(mipt.DebDifalMovtoICMSPartilha,0)),'.',',') + '|' -- VL_TOT_DEBITOS_DIFAL
		+	replace(convert(varchar(16),coalesce(#E310.OutrosDebitosDifal,0)),'.',',') + '|' -- VL_OUT_DEB_DIFAL
		+	replace(convert(varchar(16),coalesce(mipt.CreDifalMovtoICMSPartilha,0)),'.',',') + '|' -- VL_TOT_CREDITOS_DIFAL
		+	replace(convert(varchar(16),coalesce(#E310.OutrosCreditosDifal,0)),'.',',') + '|' -- VL_OUT_CRED_DIFAL
		+	replace(convert(varchar(16),coalesce(
				case when
					(	coalesce(mipt.DebDifalMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosDifal,0)
					) - 
					(	coalesce(mipt.SaldoAnterior,0) +
						coalesce(mipt.CreDifalMovtoICMSPartilha,0) +
						coalesce(#E310.OutrosCreditosDifal,0)
					) > 0
				then
					(	coalesce(mipt.DebDifalMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosDifal,0)
					) - 
					(	coalesce(mipt.SaldoAnterior,0) +
						coalesce(mipt.CreDifalMovtoICMSPartilha,0) +
						coalesce(#E310.OutrosCreditosDifal,0)
					)
				else
					0
				end,0)),'.',',') + '|' -- VL_SLD_DEV_ANT_DIFAL
		+	replace(convert(varchar(16),coalesce(#E310.DeducoesDifal,0)),'.',',') + '|' -- VL_DEDUÇÕES_DIFAL
		+	replace(convert(varchar(16),
				case when
					(	coalesce(mipt.DebDifalMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosDifal,0)
					) - 
					(	coalesce(mipt.SaldoAnterior,0) +
						coalesce(mipt.CreDifalMovtoICMSPartilha,0) +
						coalesce(#E310.OutrosCreditosDifal,0)
					) -
					coalesce(#E310.DeducoesDifal,0)
					> 0
				then
					(	coalesce(mipt.DebDifalMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosDifal,0)
					) - 
						(	coalesce(mipt.SaldoAnterior,0) +
							coalesce(mipt.CreDifalMovtoICMSPartilha,0) +
							coalesce(#E310.OutrosCreditosDifal,0)
						) -
						coalesce(#E310.DeducoesDifal,0)
				else
					0
				end),'.',',') + '|' -- VL_RECOL_DIFAL
		+	replace(convert(varchar(16), - 1 * (
				case when
					(	coalesce(mipt.DebDifalMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosDifal,0)
					) - 
					(	coalesce(mipt.SaldoAnterior,0) +
						coalesce(mipt.CreDifalMovtoICMSPartilha,0) +
						coalesce(#E310.OutrosCreditosDifal,0)
					) -
					coalesce(#E310.DeducoesDifal,0)
					< 0
				then
					(	coalesce(mipt.DebDifalMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosDifal,0)
					) - 
					(	coalesce(mipt.SaldoAnterior,0) +
						coalesce(mipt.CreDifalMovtoICMSPartilha,0) +
						coalesce(#E310.OutrosCreditosDifal,0)
					) -
					coalesce(#E310.DeducoesDifal,0)
				else
					0
				end)),'.',',') + '|' -- VL_SLD_CRED_TRANSPORTAR_DIFAL
		+	replace(convert(varchar(16),coalesce(#E310.DebitoEspecialDifal,0)),'.',',') + '|' -- DEB_ESP_DIFAL
			-- APURAÇÃO FCP ------------------------------------------------------------------------------------------------------
		+	replace(convert(varchar(16),coalesce(mipt.SaldoAnteriorFCP,0)),'.',',') + '|' -- VL_SLD_CRED_ANT_FCP
		+	replace(convert(varchar(16),coalesce(mipt.DebFCPMovtoICMSPartilha,0)),'.',',') + '|' -- VL_TOT_DEBITOS_FCP
		+	replace(convert(varchar(16),coalesce(#E310.OutrosDebitosFCP,0)),'.',',') + '|' -- VL_OUT_DEB_FCP
		+	replace(convert(varchar(16),coalesce(mipt.CreFCPMovtoICMSPartilha,0)),'.',',') + '|' -- VL_TOT_CREDITOS_FCP
		+	replace(convert(varchar(16),coalesce(#E310.OutrosCreditosFCP,0)),'.',',') + '|' -- VL_OUT_CRED_FCP
		+	replace(convert(varchar(16),coalesce(
				case when
					(	coalesce(mipt.DebFCPMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosFCP,0)
					) - 
					(	coalesce(mipt.SaldoAnteriorFCP,0) +
						coalesce(mipt.CreFCPMovtoICMSPartilha,0) +
						coalesce(#E310.OutrosCreditosFCP,0)
					) > 0
				then
					(	coalesce(mipt.DebFCPMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosFCP,0)
					) - 
					(	coalesce(mipt.SaldoAnteriorFCP,0) +
						coalesce(mipt.CreFCPMovtoICMSPartilha,0) +
						coalesce(#E310.OutrosCreditosFCP,0)
					)
				else
					0
				end,0)),'.',',') + '|' -- VL_SLD_DEV_ANT_FCP
		+	replace(convert(varchar(16),coalesce(#E310.DeducoesFCP,0)),'.',',') + '|' -- VL_DEDUÇÕES_FCP
		+	replace(convert(varchar(16),
				case when
					(	coalesce(mipt.DebFCPMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosFCP,0)
					) - 
					(	coalesce(mipt.SaldoAnteriorFCP,0) +
						coalesce(mipt.CreFCPMovtoICMSPartilha,0) +
						coalesce(#E310.OutrosCreditosFCP,0)
					) -
					coalesce(#E310.DeducoesFCP,0)
					> 0
				then
					(	coalesce(mipt.DebFCPMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosFCP,0)
					) - 
						(	coalesce(mipt.SaldoAnteriorFCP,0) +
							coalesce(mipt.CreFCPMovtoICMSPartilha,0) +
							coalesce(#E310.OutrosCreditosFCP,0)
						) -
						coalesce(#E310.DeducoesFCP,0)
				else
					0
				end),'.',',') + '|' -- VL_RECOL_FCP
		+	replace(convert(varchar(16), - 1 * (
				case when
					(	coalesce(mipt.DebFCPMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosFCP,0)
					) - 
					(	coalesce(mipt.SaldoAnteriorFCP,0) +
						coalesce(mipt.CreFCPMovtoICMSPartilha,0) +
						coalesce(#E310.OutrosCreditosFCP,0)
					) -
					coalesce(#E310.DeducoesFCP,0)
					< 0
				then
					(	coalesce(mipt.DebFCPMovtoICMSPartilha,0) + 
						coalesce(#E310.OutrosDebitosFCP,0)
					) - 
					(	coalesce(mipt.SaldoAnteriorFCP,0) +
						coalesce(mipt.CreFCPMovtoICMSPartilha,0) +
						coalesce(#E310.OutrosCreditosFCP,0)
					) -
					coalesce(#E310.DeducoesFCP,0)
				else
					0
				end)),'.',',') + '|' -- VL_SLD_CRED_TRANSPORTAR_FCP
		+	replace(convert(varchar(16),coalesce(#E310.DebitoEspecialFCP,0)),'.',',') + '|', -- DEB_ESP_FCP
		'E310',
		mipt.UF,
		999999,
		getdate(),
		0,
		0,
		0,
		'',
		0,
		'',
		0
		from tbMovtoICMSPartilha mipt (nolock)
		inner join #E310 (nolock) on
			#E310.CodigoEmpresa = mipt.CodigoEmpresa
		and	#E310.CodigoLocal = mipt.CodigoLocal
		and	#E310.Periodo = mipt.Periodo  collate SQL_Latin1_General_CP1_CS_AS
		and	#E310.UF = mipt.UF collate SQL_Latin1_General_CP1_CS_AS
		where
			mipt.CodigoEmpresa = @CodigoEmpresa
		and	mipt.CodigoLocal = @CodigoLocal
		and	mipt.Periodo = @Periodo
	end


	drop table #E310
	drop table #AjustesDifal

	-- Estados com inscrição estadual
	INSERT rtSPEDFiscal
	SELECT 
	@@spid,
		'|E310|'
	+	'0' + '|' -- IND_MOV_DIFAL (Sem movimento)
	+	'0|' -- VL_SLD_CRED_ANT_DIFAL
	+	'0|' -- VL_TOT_DEBITOS_DIFAL
	+	'0|' -- VL_OUT_DEB_DIFAL
	+	'0|' -- VL_TOT_DEB_FCP
	+	'0|' -- VL_TOT_CREDITOS_DIFAL
	+	'0|' -- VL_TOT_CRED_FCP
	+	'0|' -- VL_OUT_CRED_DIFAL
	+	'0|' -- VL_SLD_DEV_ANT_DIFAL
	+	'0|' -- VL_DEDUÇÕES_DIFAL
	+	'0|' -- VL_RECOL
	+	'0|' -- VL_SLD_CRED_TRANSPORTAR
	+	'0|'
	+	CASE WHEN CONVERT(NUMERIC(3),@Versao) >= 11 THEN 
		'0|' -- VL_TOT_CRED_FCP
	+	'0|' -- VL_OUT_CRED_DIFAL
	+	'0|' -- VL_SLD_DEV_ANT_DIFAL
	+	'0|' -- VL_DEDUÇÕES_DIFAL
	+	'0|' -- VL_RECOL
	+	'0|' -- VL_SLD_CRED_TRANSPORTAR
	+	'0|' -- VL_OUT_CRED_DIFAL
	+	'0|' ELSE '' END, -- VL_DEDUÇÕES_DIFAL, -- DEB_ESP_DIFAL
	'E310',
	iest.UFDestino,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbInscricaoEstadualST iest (NOLOCK) ON
				iest.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				iest.CodigoLocal = tbLocal.CodigoLocal AND
				iest.UFOrigem = tbLocal.UFLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				NOT EXISTS (	SELECT 1 FROM rtSPEDFiscal
								WHERE Spid = @@spid AND
								TipoRegistro = 'E310' AND
								EntradaSaida = iest.UFDestino	)

	---- AJUSTE/BENEFÍCIO/INCENTIVO DIFAL (DIFERENCIAL ALÍQUOTA) DECORRENTE DA PARTILHA DE ICMS
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosDebitosCodigo1,''))) + '|'
	+	COALESCE(mipt.OutrosDebitosDescricao1,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosDebitosValor1),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosDebitosValor1 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosDebitosCodigo2,''))) + '|'
	+	COALESCE(mipt.OutrosDebitosDescricao2,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosDebitosValor2),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosDebitosValor2 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosDebitosCodigo3,''))) + '|'
	+	COALESCE(mipt.OutrosDebitosDescricao3,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosDebitosValor3),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosDebitosValor3 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosDebitosCodigo4,''))) + '|'
	+	COALESCE(mipt.OutrosDebitosDescricao4,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosDebitosValor4),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosDebitosValor4 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosDebitosCodigo5,''))) + '|'
	+	COALESCE(mipt.OutrosDebitosDescricao5,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosDebitosValor5),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosDebitosValor5 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosDebitosCodigo6,''))) + '|'
	+	COALESCE(mipt.OutrosDebitosDescricao6,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosDebitosValor6),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosDebitosValor6 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosDebitosCodigo7,''))) + '|'
	+	COALESCE(mipt.OutrosDebitosDescricao7,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosDebitosValor7),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosDebitosValor7 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosDebitosCodigo8,''))) + '|'
	+	COALESCE(mipt.OutrosDebitosDescricao8,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosDebitosValor8),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosDebitosValor8 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosDebitosCodigo9,''))) + '|'
	+	COALESCE(mipt.OutrosDebitosDescricao9,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosDebitosValor9),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosDebitosValor9 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosDebitosCodigo10,''))) + '|'
	+	COALESCE(mipt.OutrosDebitosDescricao10,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosDebitosValor10),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosDebitosValor10 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosCreditosCodigo1,''))) + '|'
	+	COALESCE(mipt.OutrosCreditosDescricao1,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosCreditosValor1),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosCreditosValor1 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosCreditosCodigo2,''))) + '|'
	+	COALESCE(mipt.OutrosCreditosDescricao2,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosCreditosValor2),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosCreditosValor2 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosCreditosCodigo3,''))) + '|'
	+	COALESCE(mipt.OutrosCreditosDescricao3,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosCreditosValor3),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosCreditosValor3 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosCreditosCodigo4,''))) + '|'
	+	COALESCE(mipt.OutrosCreditosDescricao4,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosCreditosValor4),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosCreditosValor4 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosCreditosCodigo5,''))) + '|'
	+	COALESCE(mipt.OutrosCreditosDescricao5,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosCreditosValor5),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosCreditosValor5 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosCreditosCodigo6,''))) + '|'
	+	COALESCE(mipt.OutrosCreditosDescricao6,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosCreditosValor6),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosCreditosValor6 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosCreditosCodigo7,''))) + '|'
	+	COALESCE(mipt.OutrosCreditosDescricao7,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosCreditosValor7),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosCreditosValor7 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosCreditosCodigo8,''))) + '|'
	+	COALESCE(mipt.OutrosCreditosDescricao8,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosCreditosValor8),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosCreditosValor8 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosCreditosCodigo9,''))) + '|'
	+	COALESCE(mipt.OutrosCreditosDescricao9,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosCreditosValor9),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosCreditosValor9 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.OutrosCreditosCodigo10,''))) + '|'
	+	COALESCE(mipt.OutrosCreditosDescricao10,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.OutrosCreditosValor10),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.OutrosCreditosValor10 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.DeducoesCodigo1,''))) + '|'
	+	COALESCE(mipt.DeducoesDescricao1,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.DeducoesValor1),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.DeducoesValor1 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.DeducoesCodigo2,''))) + '|'
	+	COALESCE(mipt.DeducoesDescricao2,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.DeducoesValor2),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.DeducoesValor2 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.DeducoesCodigo3,''))) + '|'
	+	COALESCE(mipt.DeducoesDescricao3,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.DeducoesValor3),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.DeducoesValor3 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.DeducoesCodigo4,''))) + '|'
	+	COALESCE(mipt.DeducoesDescricao4,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.DeducoesValor4),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.DeducoesValor4 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.DeducoesCodigo5,''))) + '|'
	+	COALESCE(mipt.DeducoesDescricao5,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.DeducoesValor5),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.DeducoesValor5 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.DeducoesCodigo6,''))) + '|'
	+	COALESCE(mipt.DeducoesDescricao6,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.DeducoesValor6),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.DeducoesValor6 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.DeducoesCodigo7,''))) + '|'
	+	COALESCE(mipt.DeducoesDescricao7,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.DeducoesValor7),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.DeducoesValor7 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.DeducoesCodigo8,''))) + '|'
	+	COALESCE(mipt.DeducoesDescricao8,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.DeducoesValor8),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.DeducoesValor8 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.DeducoesCodigo9,''))) + '|'
	+	COALESCE(mipt.DeducoesDescricao9,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.DeducoesValor9),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.DeducoesValor9 <> 0


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
		'|E311|'
	+	RTRIM(LTRIM(COALESCE(mipt.DeducoesCodigo10,''))) + '|'
	+	COALESCE(mipt.DeducoesDescricao10,'') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),mipt.DeducoesValor10),'.',',') + '|',
	'E311',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbLocal
	INNER JOIN	tbMovtoICMSPartilha mipt (NOLOCK) ON
				mipt.CodigoEmpresa = tbLocal.CodigoEmpresa AND
				mipt.CodigoLocal = tbLocal.CodigoLocal
	WHERE		tbLocal.CodigoEmpresa = @CodigoEmpresa AND
				tbLocal.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo AND
				mipt.DeducoesValor10 <> 0


	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
		'|E316|'
	+	oip.CodigoObrigacao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),oip.Valor),'.',',') + '|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,oip.DataVencimento)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,oip.DataVencimento)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,oip.DataVencimento)),'') + '|'
	+	RTRIM(LTRIM(COALESCE(oip.CodigoReceita,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(oip.NumeroProcesso,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(oip.OrigemProcesso,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(oip.DescricaoProcesso,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(oip.TextoComplementar,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(RIGHT(oip.MesReferencia,2)+LEFT(oip.MesReferencia,4),''))) + '|',
	'E316',
	mipt.UF,
	999999,
	getdate(),
	0,
	0,
	0,
	'',
	0,
	'',
	0
	FROM		tbMovtoICMSPartilha mipt (NOLOCK)
	INNER JOIN	tbObrigacoesICMSPartilha oip (NOLOCK) ON
				oip.CodigoEmpresa = mipt.CodigoEmpresa AND
				oip.CodigoLocal = mipt.CodigoLocal AND
				oip.Periodo = mipt.Periodo AND
				oip.UF = mipt.UF
	WHERE		mipt.CodigoEmpresa = @CodigoEmpresa AND
				mipt.CodigoLocal = @CodigoLocal AND
				mipt.Periodo = @Periodo
END


---- IPI

IF EXISTS ( SELECT 1 FROM tbLocalLF (NOLOCK)
			WHERE
			CodigoEmpresa = @CodigoEmpresa AND
            CodigoLocal = @CodigoLocal AND
            CondicaoContribuinteIPI = 'V' )
BEGIN 

	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|E500|0|' + 
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|' + 
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataFinal)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataFinal)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,@DataFinal)),'') + '|',
	'E500',
	'E',
	999999,
	getdate(),
	0,
	0,
	@ContaRegistros,
	'',
	0,
	'',
	0

	SELECT @ContaRegistros = @ContaRegistros + 1

	DECLARE @DebIPI money
	DECLARE @CreIPI money

	SELECT @DebIPI = SUM(ValorIPIItemDocto)
	FROM tbItemDocumento (NOLOCK)
	INNER JOIN rtSPEDFiscal (NOLOCK) ON
			   rtSPEDFiscal.Spid = @@spid AND
			   rtSPEDFiscal.EntradaSaida = tbItemDocumento.EntradaSaidaDocumento AND
			   rtSPEDFiscal.DataDocumento = tbItemDocumento.DataDocumento AND
			   rtSPEDFiscal.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   rtSPEDFiscal.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
			   rtSPEDFiscal.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND
               rtSPEDFiscal.TipoRegistro = 'C100'
	INNER JOIN tbItemDocumentoFT (NOLOCK) ON
               tbItemDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
               tbItemDocumentoFT.CodigoLocal = @CodigoLocal AND
               tbItemDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
               tbItemDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
               tbItemDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
               tbItemDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
               tbItemDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND
               tbItemDocumentoFT.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento 
	WHERE
	tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
    tbItemDocumento.CodigoLocal = @CodigoLocal AND
	tbItemDocumento.DataDocumento between @DataInicial and @DataFinal  AND
    tbItemDocumento.ValorBaseIPI1ItemDocto <> 0 AND
    tbItemDocumento.EntradaSaidaDocumento = 'S'

	SELECT @CreIPI = SUM(ValorIPIItemDocto)
	FROM tbItemDocumento (NOLOCK)
	INNER JOIN tbDocumento (NOLOCK) ON
               tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
               tbDocumento.CodigoLocal = @CodigoLocal AND
               tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
               tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
               tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND
               tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
               tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	INNER JOIN rtSPEDFiscal (NOLOCK) ON
			   rtSPEDFiscal.Spid = @@spid AND
			   rtSPEDFiscal.EntradaSaida = tbItemDocumento.EntradaSaidaDocumento AND
			   rtSPEDFiscal.DataDocumento = tbItemDocumento.DataDocumento AND
			   rtSPEDFiscal.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   rtSPEDFiscal.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
			   rtSPEDFiscal.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND
               rtSPEDFiscal.TipoRegistro = 'C100'
	LEFT JOIN tbItemDocumentoFT (NOLOCK) ON
               tbItemDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
               tbItemDocumentoFT.CodigoLocal = @CodigoLocal AND
               tbItemDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
               tbItemDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
               tbItemDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
               tbItemDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
               tbItemDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND
               tbItemDocumentoFT.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento 
	WHERE
	tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
    tbItemDocumento.CodigoLocal = @CodigoLocal AND
	tbItemDocumento.DataDocumento between @DataInicial and @DataFinal  AND
    tbItemDocumento.ValorBaseIPI1ItemDocto <> 0  AND
    tbItemDocumento.EntradaSaidaDocumento = 'E' AND
	tbDocumento.CondicaoNFCancelada <> 'V'


	IF @CreIPI IS NULL SELECT @CreIPI = 0
	IF @DebIPI IS NULL SELECT @DebIPI = 0

	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|E510|' + 
	CASE WHEN tbDocumento.EspecieDocumento = 'ECF' THEN
		CONVERT(VARCHAR(4),tbLocalLF.CodigoCFOECF)
	ELSE
		CONVERT(VARCHAR(4),tbItemDocumento.CodigoCFO)
	END + '|' +
    RIGHT('00' + RTRIM(LTRIM(CONVERT(VARCHAR(2),COALESCE(tbItemDocumentoFT.CSTIPI,'')))),2) + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorContabilItemDocto)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorBaseIPI1ItemDocto)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumento.ValorIPIItemDocto)),'.',',') + '|',
	'E510',
	'E',
	999999,
	getdate(),
	0,
	0,
	@ContaRegistros,
	'',
	0,
	'',
	0
	FROM tbItemDocumento (NOLOCK)
	INNER JOIN rtSPEDFiscal (NOLOCK) ON
			   rtSPEDFiscal.Spid = @@spid AND
			   rtSPEDFiscal.EntradaSaida = tbItemDocumento.EntradaSaidaDocumento AND
			   rtSPEDFiscal.DataDocumento = tbItemDocumento.DataDocumento AND
			   rtSPEDFiscal.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   rtSPEDFiscal.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
			   rtSPEDFiscal.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND
               rtSPEDFiscal.TipoRegistro = 'C100'
	INNER JOIN tbDocumento (NOLOCK) ON
               tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
               tbDocumento.CodigoLocal = @CodigoLocal AND
               tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
               tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
               tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND
               tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
               tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
	INNER JOIN tbLocal (NOLOCK) ON
			   tbLocal.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
			   tbLocal.CodigoLocal = tbDocumento.CodigoLocal
	INNER JOIN tbLocalLF (NOLOCK) ON
			   tbLocalLF.CodigoEmpresa = tbLocal.CodigoEmpresa AND
			   tbLocalLF.CodigoLocal = tbLocal.CodigoLocal
	INNER JOIN tbCliFor (NOLOCK) ON
			   tbCliFor.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
			   tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor
	INNER JOIN tbPercentual (NOLOCK) ON
			   tbPercentual.UFDestino = tbCliFor.UFCliFor AND
			   tbPercentual.UFOrigem = tbLocal.UFLocal
	LEFT JOIN tbItemDocumentoFT (NOLOCK) ON
               tbItemDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
               tbItemDocumentoFT.CodigoLocal = @CodigoLocal AND
               tbItemDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
               tbItemDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
               tbItemDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
               tbItemDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
               tbItemDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND
               tbItemDocumentoFT.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento 
	WHERE
	tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
    tbItemDocumento.CodigoLocal = @CodigoLocal AND
	tbItemDocumento.DataDocumento between @DataInicial and @DataFinal  AND
    tbItemDocumento.ValorBaseIPI1ItemDocto <> 0  AND
	tbDocumento.CondicaoNFCancelada <> 'V'
	GROUP BY
	tbItemDocumento.CodigoCFO,
    tbItemDocumentoFT.CSTIPI,
    tbDocumento.EspecieDocumento,
	tbPercentual.CFOSaidaUF,
	tbLocalLF.CodigoCFOECF


	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|E520|' +
	REPLACE(CONVERT(VARCHAR(16),SaldoAnterior),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),@DebIPI),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),@CreIPI),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),( 
		OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + OutrosDebitosValor5 + 
		OutrosDebitosValor6 + OutrosDebitosValor7 + OutrosDebitosValor8 + OutrosDebitosValor9 + OutrosDebitosValor10 + 
		EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 + EstornosCreditosValor5 +
		EstornosCreditosValor6 + EstornosCreditosValor7 + EstornosCreditosValor8 + EstornosCreditosValor9 + EstornosCreditosValor10)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),( 
		OutrosCreditosValor1 + OutrosCreditosValor2 + OutrosCreditosValor3 + OutrosCreditosValor4 + OutrosCreditosValor5 + 
		OutrosCreditosValor6 + OutrosCreditosValor7 + OutrosCreditosValor8 + OutrosCreditosValor9 + OutrosCreditosValor10 + 
		EstornosDebitosValor1 + EstornosDebitosValor2 + EstornosDebitosValor3 + EstornosDebitosValor4 + EstornosDebitosValor5 +
		EstornosDebitosValor6 + EstornosDebitosValor7 + EstornosDebitosValor8 + EstornosDebitosValor9 + EstornosDebitosValor10)),'.',',') + '|' +
	CASE WHEN ( 
		@DebIPI + 
		OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + OutrosDebitosValor5 + 
		OutrosDebitosValor6 + OutrosDebitosValor7 + OutrosDebitosValor8 + OutrosDebitosValor9 + OutrosDebitosValor10 + 
		EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 + EstornosCreditosValor5 +
		EstornosCreditosValor6 + EstornosCreditosValor7 + EstornosCreditosValor8 + EstornosCreditosValor9 + EstornosCreditosValor10 -
		@CreIPI - 
		OutrosCreditosValor1 - OutrosCreditosValor2 - OutrosCreditosValor3 - OutrosCreditosValor4 - OutrosCreditosValor5 - 
		OutrosCreditosValor6 - OutrosCreditosValor7 - OutrosCreditosValor8 - OutrosCreditosValor9 - OutrosCreditosValor10 - 
		EstornosDebitosValor1 - EstornosDebitosValor2 - EstornosDebitosValor3 - EstornosDebitosValor4 - EstornosDebitosValor5 - 
		EstornosDebitosValor6 - EstornosDebitosValor7 - EstornosDebitosValor8 - EstornosDebitosValor9 - EstornosDebitosValor10 - 
		SaldoAnterior ) < 0 
	THEN
		REPLACE(CONVERT(VARCHAR(16), ( ABS(
		(	
			@DebIPI + 
			OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + OutrosDebitosValor5 + 
			OutrosDebitosValor6 + OutrosDebitosValor7 + OutrosDebitosValor8 + OutrosDebitosValor9 + OutrosDebitosValor10 + 
			EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 + EstornosCreditosValor5 +
			EstornosCreditosValor6 + EstornosCreditosValor7 + EstornosCreditosValor8 + EstornosCreditosValor9 + EstornosCreditosValor10 - 
			@CreIPI - 
			OutrosCreditosValor1 - OutrosCreditosValor2 - OutrosCreditosValor3 - OutrosCreditosValor4 - OutrosCreditosValor5 - 
			OutrosCreditosValor6 - OutrosCreditosValor7 - OutrosCreditosValor8 - OutrosCreditosValor9 - OutrosCreditosValor10 - 
			EstornosDebitosValor1 - EstornosDebitosValor2 - EstornosDebitosValor3 - EstornosDebitosValor4 - EstornosDebitosValor5 - 
			EstornosDebitosValor6 - EstornosDebitosValor7 - EstornosDebitosValor8 - EstornosDebitosValor9 - EstornosDebitosValor10 - 
			SaldoAnterior 
		) - 
		( 
			DeducoesValor1 + DeducoesValor2 + DeducoesValor3 + DeducoesValor4 + DeducoesValor5 + 
			DeducoesValor6 + DeducoesValor7 + DeducoesValor8 + DeducoesValor9 + DeducoesValor10
		)
		))),'.',',') + '|0,00|'
	ELSE
		'0,00|' + 
		REPLACE(CONVERT(VARCHAR(16), ( ABS(
		(
			@DebIPI + 
			OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + OutrosDebitosValor5 + 
			OutrosDebitosValor6 + OutrosDebitosValor7 + OutrosDebitosValor8 + OutrosDebitosValor9 + OutrosDebitosValor10 + 
			EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 + EstornosCreditosValor5 +
			EstornosCreditosValor6 + EstornosCreditosValor7 + EstornosCreditosValor8 + EstornosCreditosValor9 + EstornosCreditosValor10 - 
			@CreIPI - 
			OutrosCreditosValor1 - OutrosCreditosValor2 - OutrosCreditosValor3 - OutrosCreditosValor4 - OutrosCreditosValor5 - 
			OutrosCreditosValor6 - OutrosCreditosValor7 - OutrosCreditosValor8 - OutrosCreditosValor9 - OutrosCreditosValor10 - 
			EstornosDebitosValor1 - EstornosDebitosValor2 - EstornosDebitosValor3 - EstornosDebitosValor4 - EstornosDebitosValor5 - 
			EstornosDebitosValor6 - EstornosDebitosValor7 - EstornosDebitosValor8 - EstornosDebitosValor9 - EstornosDebitosValor10 - 
			SaldoAnterior 
		) - ( 
			DeducoesValor1 + DeducoesValor2 + DeducoesValor3 + DeducoesValor4 + DeducoesValor5 + 
			DeducoesValor6 + DeducoesValor7 + DeducoesValor8 + DeducoesValor9 + DeducoesValor10
		)))),'.',',') + '|'
	END,  
	'E520',
	'E',
	999999,
	getdate(),
	0,
	0,
	@ContaRegistros,
	'',
	0,
	'',
	0
	FROM tbMovimentacaoIPIICMS (NOLOCK)
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	TipoImposto = 2 AND
	NumeroRecolhimento = 1 AND
	Periodo = @Periodo

END

----

INSERT rtSPEDFiscal
SELECT DISTINCT
@@spid,
	'|E001|'
+	CASE WHEN EXISTS (SELECT 1 FROM rtSPEDFiscal where Spid = @@spid AND TipoRegistro LIKE 'E%') THEN
		'0'
	ELSE
		'1'
	END + '|',
'E001',
'E',
999999,
getdate(),
0,
0,
49,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E990|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro LIKE 'E%' ) + 1) + '|',
'E990',
'E',
999999,
getdate(),
0,
0,
68,
'',
0,
'',
0

---- Inventario

INSERT rtSPEDFiscal
SELECT
@@spid,
'|H005|' + 
COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataGeracaoInventario)),2,2) +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataGeracaoInventario)),2,2) +
CONVERT(CHAR(4),DATEPART(year,@DataGeracaoInventario)),'') + '|' + 
REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(CONVERT(NUMERIC(16,2),CustoTotal)) FROM rtRegistroInventario WHERE Spid = @@spid )),'.',',') + '|' +
CASE WHEN CONVERT(numeric(4),@Versao) >= 6 THEN '01|' ELSE '' END,
'H005',
'E',
999999,
getdate(),
0,
0,
69,
'',
0,
'',
0

DELETE rtSPEDFiscal WHERE TipoRegistro = 'H005' AND Linha IS NULL

IF @GerarInventario = 'F' BEGIN
	DELETE rtSPEDFiscal WHERE TipoRegistro = 'H005'
END

IF EXISTS ( SELECT 1 FROM rtSPEDFiscal WHERE rtSPEDFiscal.Spid = @@Spid AND TipoRegistro = 'H005' )
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|H001|0|',
	'H001',
	'E',
	0,
	getdate(),
	0,
	0,
	68,
	'',
	0,
	'',
	0
END
ELSE
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|H001|1|',
	'H001',
	'E',
	0,
	getdate(),
	0,
	0,
	68,
	'',
	0,
	'',
	0
END

---- Contas de Veículo
TRUNCATE TABLE rtRegraVeiculo

UPDATE rtRegistroInventario
SET CodigoLinhaProduto = 9990
WHERE
rtRegistroInventario.CodigoLinhaProduto in (9990,9991,9994,9995,9996,9997,9998,9999)

INSERT rtRegraVeiculo
SELECT DISTINCT
rtRegistroInventario.CodigoLinhaProduto,
rtRegistroInventario.CodigoProduto,
MIN(tbRegraContabilGrupoVeiculo.ContaEstoqueVeiculo)
FROM rtRegistroInventario
INNER JOIN tbVeiculoCV (NOLOCK) ON 
           tbVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
           tbVeiculoCV.NumeroChassisCV = rtRegistroInventario.CodigoProduto
INNER JOIN tbModeloVeiculoCV (NOLOCK) ON
           tbModeloVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
           tbModeloVeiculoCV.ModeloVeiculo = tbVeiculoCV.ModeloVeiculo
INNER JOIN tbRegraContabilGrupoVeiculo (NOLOCK) ON
      tbRegraContabilGrupoVeiculo.CodigoEmpresa = @CodigoEmpresa AND
      tbRegraContabilGrupoVeiculo.CodigoGrupoVeiculo = tbModeloVeiculoCV.CodigoGrupoVeiculo AND
      tbRegraContabilGrupoVeiculo.NovoUsadoGrupoVeiculo = CASE WHEN tbVeiculoCV.VeiculoNovoCV = 'V' THEN 'N' ELSE 'U' END
WHERE
Spid = @@spid AND
rtRegistroInventario.CodigoLinhaProduto in (9990,9995,9996,9997,9998,9999)
GROUP BY
rtRegistroInventario.CodigoLinhaProduto,
rtRegistroInventario.CodigoProduto


----

UPDATE rtRegistroInventario
SET CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto
FROM tbProdutoFT (NOLOCK)
WHERE
tbProdutoFT.CodigoEmpresa = @CodigoEmpresa AND
tbProdutoFT.CodigoProduto = rtRegistroInventario.CodigoProduto AND
rtRegistroInventario.CodigoLinhaProduto in (9000,9100,9200,9300)

UPDATE rtRegistroInventario
SET CodigoProduto = RTRIM(LTRIM(CodigoProduto))
WHERE
Spid = @@Spid and
exists ( select 1 from tbProduto A
         where 
         A.CodigoEmpresa = @CodigoEmpresa and
         A.CodigoProduto = RTRIM(LTRIM(rtRegistroInventario.CodigoProduto)) )

IF @UFLocal = 'GO' 
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|H010|' + 
	RTRIM(LTRIM(rtRegistroInventario.CodigoProduto)) + '|' + 
	RTRIM(LTRIM(COALESCE(tbProdutoFT.CodigoUnidadeProduto,'UN'))) + '|' +
	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),SUM(rtRegistroInventario.QuantidadeProduto))),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,6),SUM(( rtRegistroInventario.CustoTotal / rtRegistroInventario.QuantidadeProduto)))),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(CONVERT(NUMERIC(16,2),rtRegistroInventario.CustoTotal))),'.',',') + '|' +
	'0' + '|' + 
	'' + '|' +
	CASE WHEN tbProdutoFT.SubstituicaoTributariaProduto IS NOT NULL AND 
             ( tbProdutoFT.SubstituicaoTributariaProduto = 'V' OR 
               EXISTS ( SELECT 1 FROM vwProtocoloICMS41AnexoUnico A
						WHERE
						A.CodigoEmpresa = @CodigoEmpresa AND
						A.CodigoLocal = @CodigoLocal AND
                        A.CodigoProduto = rtRegistroInventario.CodigoProduto )
             ) THEN
		'INVENTARIO DE MERCADORIA SUBMETIDA AO REGIME DE SUBSTITUICAO TRIBUTARIA, NOS TERMOS DO ART.80, I DO ANEXO VIII DO DEC. N. 4,852/97' 
	ELSE
		''
	END + '|' +
	CASE WHEN rtRegistroInventario.CodigoLinhaProduto in (9990,9995,9996,9997,9998,9999) THEN
		RTRIM(LTRIM(COALESCE(rtRegraVeiculo.ContaEstoque,'')))
	 ELSE
		RTRIM(LTRIM(COALESCE(tbRegraContabilLinha.ContaEstoqueLinha,'')))
	END + '|' +
	CASE WHEN CONVERT(NUMERIC,@Versao) >= 9 THEN
		REPLACE(CONVERT(VARCHAR(16),SUM(CONVERT(NUMERIC(16,2),rtRegistroInventario.CustoTotal))),'.',',') + '|'
	ELSE
		''
	END,
	'H010',
	'E',
	999999,
	getdate(),
	0,
	0,
	69,
	rtRegistroInventario.CodigoProduto,
	0,
	COALESCE(tbProdutoFT.CodigoUnidadeProduto,'UN'),
	0
	FROM rtRegistroInventario
	LEFT JOIN tbProdutoFT ON 
			  tbProdutoFT.CodigoEmpresa = @CodigoEmpresa AND
			  tbProdutoFT.CodigoProduto = rtRegistroInventario.CodigoProduto
	LEFT JOIN tbRegraContabilLinha ON
			  tbRegraContabilLinha.CodigoEmpresa = @CodigoEmpresa AND
			  tbRegraContabilLinha.CodigoLinhaProduto = rtRegistroInventario.CodigoLinhaProduto
	LEFT JOIN rtRegraVeiculo ON
			  rtRegraVeiculo.CodigoProduto = rtRegistroInventario.CodigoProduto AND
			  rtRegraVeiculo.CodigoLinhaProduto = rtRegistroInventario.CodigoLinhaProduto
	where
	Spid = @@spid AND
	@GerarInventario = 'V'
	GROUP BY
	rtRegistroInventario.CodigoProduto,
	tbProdutoFT.CodigoUnidadeProduto,
	tbRegraContabilLinha.ContaEstoqueLinha,
	rtRegraVeiculo.ContaEstoque,
	rtRegistroInventario.CodigoLinhaProduto,
	tbProdutoFT.SubstituicaoTributariaProduto
END
ELSE
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|H010|' + 
	RTRIM(LTRIM(rtRegistroInventario.CodigoProduto)) + '|' + 
	RTRIM(LTRIM(COALESCE(tbProdutoFT.CodigoUnidadeProduto,'UN'))) + '|' +
	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),SUM(rtRegistroInventario.QuantidadeProduto))),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,6),SUM(( rtRegistroInventario.CustoTotal / rtRegistroInventario.QuantidadeProduto)))),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(CONVERT(NUMERIC(16,2),rtRegistroInventario.CustoTotal))),'.',',') + '|' +
	'0' + '|' + 
	'' + '|' +
	'' + '|' +
	CASE WHEN rtRegistroInventario.CodigoLinhaProduto in (9990,9995,9996,9997,9998,9999) THEN
		RTRIM(LTRIM(COALESCE(rtRegraVeiculo.ContaEstoque,'')))
	 ELSE
		RTRIM(LTRIM(COALESCE(tbRegraContabilLinha.ContaEstoqueLinha,'')))
	END + '|' +
	CASE WHEN CONVERT(NUMERIC,@Versao) >= 9 THEN
		REPLACE(CONVERT(VARCHAR(16),SUM(CONVERT(NUMERIC(16,2),rtRegistroInventario.CustoTotal))),'.',',') + '|'
	ELSE
		''
	END,
	'H010',
	'E',
	999999,
	getdate(),
	0,
	0,
	69,
	rtRegistroInventario.CodigoProduto,
	0,
	COALESCE(tbProdutoFT.CodigoUnidadeProduto,'UN'),
	0
	FROM rtRegistroInventario
	LEFT JOIN tbProdutoFT ON 
			  tbProdutoFT.CodigoEmpresa = @CodigoEmpresa AND
			  tbProdutoFT.CodigoProduto = rtRegistroInventario.CodigoProduto
	LEFT JOIN tbRegraContabilLinha ON
			  tbRegraContabilLinha.CodigoEmpresa = @CodigoEmpresa AND
			  tbRegraContabilLinha.CodigoLinhaProduto = rtRegistroInventario.CodigoLinhaProduto
	LEFT JOIN rtRegraVeiculo ON
			  rtRegraVeiculo.CodigoProduto = rtRegistroInventario.CodigoProduto AND
			  rtRegraVeiculo.CodigoLinhaProduto = rtRegistroInventario.CodigoLinhaProduto
	where
	Spid = @@spid AND
	@GerarInventario = 'V'
	GROUP BY
	rtRegistroInventario.CodigoProduto,
	tbProdutoFT.CodigoUnidadeProduto,
	tbRegraContabilLinha.ContaEstoqueLinha,
	rtRegraVeiculo.ContaEstoque,
	rtRegistroInventario.CodigoLinhaProduto
END 

INSERT rtSPEDFiscal
SELECT
@@spid,
'|H990|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro LIKE 'H%' ) + 1) + '|',
'H990',
'E',
999999,
getdate(),
0,
0,
69,
'',
0,
'',
0

----
IF NOT EXISTS ( SELECT 1 FROM tbSPEDFiscal1600 (NOLOCK)
                WHERE
                CodigoEmpresa = @CodigoEmpresa AND
                CodigoLocal = @CodigoLocal AND
                Periodo = @Periodo )
BEGIN
	IF CONVERT(numeric(4),@Versao) < 6 
	BEGIN	
		INSERT rtSPEDFiscal
		SELECT
		@@spid,
		'|1001|1|',
		'W001',
		'E',
		999999,
		getdate(),
		0,
		0,
		70,
		'',
		0,
		'',
		0

		INSERT rtSPEDFiscal
		SELECT
		@@spid,
		'|1990|2|',
		'W002',
		'E',
		999999,
		getdate(),
		0,
		0,
		72,
		'',
		0,
		'',
		0

	END
	ELSE
	BEGIN
		INSERT rtSPEDFiscal
		SELECT
		@@spid,
		'|1001|0|',
		'W001',
		'E',
		999999,
		getdate(),
		0,
		0,
		70,
		'',
		0,
		'',
		0

		INSERT rtSPEDFiscal
		SELECT
		@@spid,
		'|1010|N|N|N|N|N|N|N|N|N|',
		'W002',
		'E',
		999999,
		getdate(),
		0,
		0,
		71,
		'',
		0,
		'',
		0

		INSERT rtSPEDFiscal
		SELECT
		@@spid,
		'|1990|3|',
		'W002',
		'E',
		999999,
		getdate(),
		0,
		0,
		72,
		'',
		0,
		'',
		0
	END
END
ELSE
BEGIN

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|1001|0|',
	'W001',
	'E',
	999999,
	getdate(),
	0,
	0,
	70,
	'',
	0,
	'',
	0

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|1010|N|N|N|N|N|N|S|N|N|',
	'W002',
	'E',
	999999,
	getdate(),
	0,
	0,
	71,
	'',
	0,
	'',
	0

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|1600|' +
	CONVERT(VARCHAR(14),CodigoCliFor) + '|' +
	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbSPEDFiscal1600.TotalCredito)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbSPEDFiscal1600.TotalDebito)),'.',',') + '|',
	'W002',
	'E',
	999999,
	getdate(),
	CodigoCliFor,
	0,
	72,
	'',
	0,
	'',
	0
	FROM tbSPEDFiscal1600
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
    CodigoLocal = @CodigoLocal AND
    Periodo = @Periodo

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|1990|' +
	CONVERT(VARCHAR(16),3 + ( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and Linha LIKE '|1600|%' )) + '|',
	'W003',
	'E',
	999999,
	getdate(),
	0,
	0,
	73,
	'',
	0,
	'',
	0

END

---- CIAP

IF @GerarCIAP = 'V' 
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|0300|' +
	RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4) + '|' +
	'1|' +
	RTRIM(LTRIM(DescricaoItemPatrimonial)) + '|' +
	'|' +
	RTRIM(LTRIM(ContaItemRegraContabilItemAF)) + '|' +
	'48|' ,
	'0300',
	'E',
	0,
	DataAquisicaoItem,
	CONVERT(NUMERIC(14),RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4)),
	0,
	7,
	'',
	0,
	'',
	0
	FROM tbControleICMSAtivo (NOLOCK)
	INNER JOIN tbItemPatrimonial (NOLOCK) ON 
               tbItemPatrimonial.CodigoEmpresa = @CodigoEmpresa AND
               tbItemPatrimonial.CodigoLocal = @CodigoLocal AND
               tbItemPatrimonial.CodigoItemPatrimonial = tbControleICMSAtivo.CodigoItemICMSAtivo AND
               tbItemPatrimonial.SequenciaItemPatrimonial = tbControleICMSAtivo.SeqItemICMSAtivo
	INNER JOIN tbRegraContabilItemAF (NOLOCK) ON 
               tbRegraContabilItemAF.CodigoEmpresa = @CodigoEmpresa AND
               tbRegraContabilItemAF.CodigoGrupoItem = tbItemPatrimonial.CodigoGrupoItem AND
               tbRegraContabilItemAF.CodigoSubGrupoItem = tbItemPatrimonial.CodigoSubGrupoItem 
	WHERE 
    tbControleICMSAtivo.CodigoEmpresa = @CodigoEmpresa AND
	tbControleICMSAtivo.CodigoLocal = @CodigoLocal AND
	tbItemPatrimonial.DataAquisicaoItem <= @DataFinal AND
	ValorCreditoICMSAtivo <> 0 AND
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) + 1 <= 48 AND
    ( tbItemPatrimonial.DataBaixaItem IS NULL OR tbItemPatrimonial.DataBaixaItem BETWEEN @DataInicial AND @DataFinal )

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|0305|' +
	CONVERT(VARCHAR(8),tbItemPatrimonial.CentroCusto) + '|' +
	RTRIM(LTRIM(CONVERT(VARCHAR(60),tbItemPatrimonial.DescricaoItemPatrimonial))) + '|' +
	CONVERT(VARCHAR(3),tbItemPatrimonial.VidaUtilItem) + '|',
	'0305',
	'E',
	0,
	DataAquisicaoItem,
	CONVERT(NUMERIC(14),RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4)),
	0,
	7,
	'',
	0,
	'',
	0
	FROM tbControleICMSAtivo (NOLOCK)
	INNER JOIN tbItemPatrimonial (NOLOCK) ON 
               tbItemPatrimonial.CodigoEmpresa = @CodigoEmpresa AND
               tbItemPatrimonial.CodigoLocal = @CodigoLocal AND
               tbItemPatrimonial.CodigoItemPatrimonial = tbControleICMSAtivo.CodigoItemICMSAtivo AND
               tbItemPatrimonial.SequenciaItemPatrimonial = tbControleICMSAtivo.SeqItemICMSAtivo
	INNER JOIN tbRegraContabilItemAF (NOLOCK) ON 
               tbRegraContabilItemAF.CodigoEmpresa = @CodigoEmpresa AND
               tbRegraContabilItemAF.CodigoGrupoItem = tbItemPatrimonial.CodigoGrupoItem AND
               tbRegraContabilItemAF.CodigoSubGrupoItem = tbItemPatrimonial.CodigoSubGrupoItem 
	WHERE 
    tbControleICMSAtivo.CodigoEmpresa = @CodigoEmpresa AND
	tbControleICMSAtivo.CodigoLocal = @CodigoLocal AND
	tbItemPatrimonial.DataAquisicaoItem <= @DataFinal AND
	ValorCreditoICMSAtivo <> 0 AND
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) + 1 <= 48 AND
    ( tbItemPatrimonial.DataBaixaItem IS NULL OR tbItemPatrimonial.DataBaixaItem BETWEEN @DataInicial AND @DataFinal )

	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|0500|' +
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|' +
	CASE 
		WHEN tbPlanoContas.GrupoPlanoConta = 'A' THEN
			'01'
		WHEN tbPlanoContas.GrupoPlanoConta = 'P' THEN
			'02'
		WHEN tbPlanoContas.GrupoPlanoConta = 'R' THEN
			'04'
		ELSE
			'09'
	END + '|' +
	'A' + '|' +
	'5' + '|' +
	RTRIM(LTRIM(ContaItemRegraContabilItemAF)) + '|' +
	RTRIM(LTRIM(tbPlanoContas.DescricaoContaContabil)) + '|',
	'0500',
	'E',
	0,
	getdate(),
	0,
	0,
	7,
	'',
	0,
	'',
	0
	FROM tbItemPatrimonial
	INNER JOIN tbRegraContabilItemAF (NOLOCK) ON 
               tbRegraContabilItemAF.CodigoEmpresa = @CodigoEmpresa AND
               tbRegraContabilItemAF.CodigoGrupoItem = tbItemPatrimonial.CodigoGrupoItem AND
               tbRegraContabilItemAF.CodigoSubGrupoItem = tbItemPatrimonial.CodigoSubGrupoItem 
	INNER JOIN tbPlanoContas (NOLOCK) ON
               tbPlanoContas.CodigoEmpresa = @CodigoEmpresa AND 
               tbPlanoContas.CodigoContaContabil = tbRegraContabilItemAF.ContaItemRegraContabilItemAF
	WHERE
	tbItemPatrimonial.CodigoEmpresa = @CodigoEmpresa AND
	tbItemPatrimonial.CodigoLocal = @CodigoLocal AND
	DataAquisicaoItem <= @DataFinal AND
	StatusDepreciacaoItem <> 2

	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|0600|' +
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|' +
	CONVERT(VARCHAR(8),tbItemPatrimonial.CentroCusto) + '|' +
	RTRIM(LTRIM(tbCentroCusto.DescricaoCentroCusto)) + '|',
	'0600',
	'E',
	0,
	getdate(),
	0,
	0,
	7,
	'',
	0,
	'',
	0
	FROM tbItemPatrimonial
	INNER JOIN tbRegraContabilItemAF (NOLOCK) ON 
               tbRegraContabilItemAF.CodigoEmpresa = @CodigoEmpresa AND
               tbRegraContabilItemAF.CodigoGrupoItem = tbItemPatrimonial.CodigoGrupoItem AND
               tbRegraContabilItemAF.CodigoSubGrupoItem = tbItemPatrimonial.CodigoSubGrupoItem 
	INNER JOIN tbCentroCusto (NOLOCK) ON
               tbCentroCusto.CodigoEmpresa = @CodigoEmpresa AND
               tbCentroCusto.CentroCusto = tbItemPatrimonial.CentroCusto
	WHERE
	tbItemPatrimonial.CodigoEmpresa = @CodigoEmpresa AND
	tbItemPatrimonial.CodigoLocal = @CodigoLocal AND
	DataAquisicaoItem <= @DataFinal AND
	StatusDepreciacaoItem <> 2

	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|G001|0|',
	'G001',
	'E',
	0,
	getdate(),
	0,
	0,
	68,
	'',
	0,
	'',
	0

	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|G110|' + 
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|' +
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataFinal)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataFinal)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,@DataFinal)),'') + '|' +
	'SOMAINI' + '|' +
	'SOMA10'  + '|' +
	REPLACE(CONVERT(VARCHAR(16),ValorSaidasTributadas),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),ValorSaidas),'.',',') + '|' +
	CASE WHEN ValorSaidas <> 0 THEN
		REPLACE(CONVERT(VARCHAR(16),(CONVERT(NUMERIC(16,8),(convert(numeric(16,8),ValorSaidasTributadas) / ValorSaidas)))),'.',',') + '|'
	ELSE
		'0,00|'
	END +
	'ICMSAPROP' + '|' +
	'0,00' + '|',
	'G110',
	'E',
	0,
	getdate(),
	0,
	0,
	68,
	'',
	0,
	'',
	0
	FROM tbSPEDFiscalCIAP
	WHERE 
    CodigoEmpresa = @CodigoEmpresa AND
    CodigoLocal = @CodigoLocal AND
    Periodo = @Periodo 

	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|G125|' + 
	RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4) + '|' +
	CASE WHEN tbItemPatrimonial.DataAquisicaoItem < @DataInicial THEN
		COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') 
	ELSE
		COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbItemPatrimonial.DataAquisicaoItem)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbItemPatrimonial.DataAquisicaoItem)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,tbItemPatrimonial.DataAquisicaoItem)),'') 
	END	+ '|' +
	CASE WHEN tbItemPatrimonial.DataAquisicaoItem < @DataInicial THEN
		'SI' -- Saldo inicial de bens imobilizados
	ELSE
		'IM' -- Imobilização de bem individual
	END	+ '|' + 
	REPLACE(CONVERT(VARCHAR(16),tbControleICMSAtivo.ValorCreditoICMSAtivo),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),tbControleICMSAtivo.ValorICMSST),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),tbControleICMSAtivo.ValorICMSFrete),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),COALESCE(CONVERT(NUMERIC(16,2),tbControleICMSAtivo.ValorICMSDifAliquota),0.00)),'.',',') + '|' +
	CONVERT(VARCHAR(3),DATEDIFF(MONTH,DataAquisicaoItem,@DataInicial) + 1) + '|' + 
	REPLACE(CONVERT(VARCHAR(16),( CONVERT(NUMERIC(16,2),( tbControleICMSAtivo.ValorCreditoICMSAtivo + tbControleICMSAtivo.ValorICMSST + tbControleICMSAtivo.ValorICMSFrete + COALESCE(CONVERT(NUMERIC(16,2),tbControleICMSAtivo.ValorICMSDifAliquota),0.00) ) / 48 ))),'.',',') + '|',
	'G125',
	'E',
	0,
	@DataInicial,
	CONVERT(NUMERIC(14),RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4)),
	0,
	69,
	'',
	0,
	'',
	0
	FROM tbControleICMSAtivo (NOLOCK)
	INNER JOIN tbItemPatrimonial (NOLOCK) ON 
               tbItemPatrimonial.CodigoEmpresa = @CodigoEmpresa AND
               tbItemPatrimonial.CodigoLocal = @CodigoLocal AND
               tbItemPatrimonial.CodigoItemPatrimonial = tbControleICMSAtivo.CodigoItemICMSAtivo AND
               tbItemPatrimonial.SequenciaItemPatrimonial = tbControleICMSAtivo.SeqItemICMSAtivo
	WHERE 
    tbControleICMSAtivo.CodigoEmpresa = @CodigoEmpresa AND
	tbControleICMSAtivo.CodigoLocal = @CodigoLocal AND
	tbItemPatrimonial.DataAquisicaoItem <= @DataFinal AND
	ValorCreditoICMSAtivo <> 0 AND
	DATEDIFF(MONTH,DataAquisicaoItem,@DataInicial) + 1 <= 48 AND
    ( tbItemPatrimonial.DataBaixaItem IS NULL or tbItemPatrimonial.DataBaixaItem between @DataInicial AND @DataFinal )

	--- Baixa por venda ou transferência
	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|G125|' + 
	RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4) + '|' +
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbItemPatrimonial.DataBaixaItem)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbItemPatrimonial.DataBaixaItem)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbItemPatrimonial.DataBaixaItem)),'') + '|' +
	'AT' + '|' + -- Outras Saídas do Imobilizado
	'|' + 
	'|' +
	'|' +
	'|' + 
	'|' + 
	'|',
	'G125',
	'E',
	0,
	@DataInicial,
	CONVERT(NUMERIC(14),RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4)),
	0,
	69,
	'',
	0,
	'',
	0
	FROM tbControleICMSAtivo (NOLOCK)
	INNER JOIN tbItemPatrimonial (NOLOCK) ON 
               tbItemPatrimonial.CodigoEmpresa = @CodigoEmpresa AND
               tbItemPatrimonial.CodigoLocal = @CodigoLocal AND
               tbItemPatrimonial.CodigoItemPatrimonial = tbControleICMSAtivo.CodigoItemICMSAtivo AND
               tbItemPatrimonial.SequenciaItemPatrimonial = tbControleICMSAtivo.SeqItemICMSAtivo
	WHERE 
    tbControleICMSAtivo.CodigoEmpresa = @CodigoEmpresa AND
	tbControleICMSAtivo.CodigoLocal = @CodigoLocal AND
	tbItemPatrimonial.DataAquisicaoItem <= @DataFinal AND
	ValorCreditoICMSAtivo <> 0 AND
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) + 1 <= 48 AND
    tbItemPatrimonial.DataBaixaItem between @DataInicial AND @DataFinal


	--- Baixa do Item por final da depreciação
	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|G125|' + 
	RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4) + '|' +
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataFinal)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataFinal)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,@DataFinal)),'') + '|' +
	'BA' + '|' + -- Baixa do bem - Fim do período de apropriação
	'|' + 
	'|' +
	'|' +
	'|' + 
	'|' + 
	'|',
	'G125',
	'E',
	0,
	@DataInicial,
	CONVERT(NUMERIC(14),RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4)),
	1,
	69,
	'',
	0,
	'',
	0
	FROM tbControleICMSAtivo (NOLOCK)
	INNER JOIN tbItemPatrimonial (NOLOCK) ON 
               tbItemPatrimonial.CodigoEmpresa = @CodigoEmpresa AND
               tbItemPatrimonial.CodigoLocal = @CodigoLocal AND
               tbItemPatrimonial.CodigoItemPatrimonial = tbControleICMSAtivo.CodigoItemICMSAtivo AND
               tbItemPatrimonial.SequenciaItemPatrimonial = tbControleICMSAtivo.SeqItemICMSAtivo
	WHERE 
    tbControleICMSAtivo.CodigoEmpresa = @CodigoEmpresa AND
	tbControleICMSAtivo.CodigoLocal = @CodigoLocal AND
	tbItemPatrimonial.DataAquisicaoItem <= @DataFinal AND
	ValorCreditoICMSAtivo <> 0 AND
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) + 1 = 48 AND -- Itens que já concluíram a depreciação
    (	tbItemPatrimonial.DataBaixaItem between @DataInicial AND @DataFinal -- Item baixado no período
		OR tbItemPatrimonial.DataBaixaItem IS NULL -- Item não baixado
	)
	---


	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|G130|' + 
	CASE WHEN EXISTS ( SELECT 1 FROM tbDocumento (NOLOCK) 
					   WHERE
                       tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
                       tbDocumento.CodigoLocal = @CodigoLocal AND
                       tbDocumento.EntradaSaidaDocumento = 'E' AND 
					   tbDocumento.CodigoCliFor = tbItemPatrimonial.CodigoCliFor AND
                       tbDocumento.NumeroDocumento = tbItemPatrimonial.NumeroDoctoAquisicaoItem AND 
                       tbDocumento.DataDocumento = tbItemPatrimonial.DataAquisicaoItem AND
                       tbDocumento.TipoLancamentoMovimentacao = 7 ) THEN
		'0'
	ELSE
		'1'
	END + '|' +
	CONVERT(VARCHAR(14),tbItemPatrimonial.CodigoCliFor) + '|' +
	COALESCE(RIGHT(CONVERT(VARCHAR(3),( SELECT 100 + MIN(CodigoModeloNotaFiscal) FROM tbDocumento (NOLOCK)
	           WHERE
			   tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
	           tbDocumento.CodigoLocal = @CodigoLocal AND
	           tbDocumento.EntradaSaidaDocumento = 'E' AND 
			   tbDocumento.CodigoCliFor = tbItemPatrimonial.CodigoCliFor AND
 	           tbDocumento.NumeroDocumento = tbItemPatrimonial.NumeroDoctoAquisicaoItem AND 
	           tbDocumento.DataDocumento = tbItemPatrimonial.DataAquisicaoItem )),2),'01') + '|' +
	right('000'+rtrim(ltrim(coalesce(( SELECT MIN(SerieDocumento) FROM tbDocumento (NOLOCK)
	           WHERE
			   tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
	           tbDocumento.CodigoLocal = @CodigoLocal AND
	           tbDocumento.EntradaSaidaDocumento = 'E' AND 
			   tbDocumento.CodigoCliFor = tbItemPatrimonial.CodigoCliFor AND
 	           tbDocumento.NumeroDocumento = tbItemPatrimonial.NumeroDoctoAquisicaoItem AND 
	           tbDocumento.DataDocumento = tbItemPatrimonial.DataAquisicaoItem ),''))),3) + '|' +
	RTRIM(LTRIM(CONVERT(VARCHAR(12),tbItemPatrimonial.NumeroDoctoAquisicaoItem))) + '|' + 
	RTRIM(LTRIM(COALESCE(tbDocumentoNFe.ChaveAcessoNFe,''))) + '|' +
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbItemPatrimonial.DataAquisicaoItem)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbItemPatrimonial.DataAquisicaoItem)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbItemPatrimonial.DataAquisicaoItem)),'') + '|',
	'G130',
	'E',
	0,
	@DataInicial,
	CONVERT(NUMERIC(14),RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4)),
	1,
	69,
	'',
	0,
	'',
	0
	FROM tbControleICMSAtivo (NOLOCK)
	INNER JOIN tbItemPatrimonial (NOLOCK) ON 
               tbItemPatrimonial.CodigoEmpresa = @CodigoEmpresa AND
               tbItemPatrimonial.CodigoLocal = @CodigoLocal AND
               tbItemPatrimonial.CodigoItemPatrimonial = tbControleICMSAtivo.CodigoItemICMSAtivo AND
               tbItemPatrimonial.SequenciaItemPatrimonial = tbControleICMSAtivo.SeqItemICMSAtivo
	LEFT JOIN tbDocumentoNFe (NOLOCK) ON
              tbDocumentoNFe.CodigoEmpresa = @CodigoEmpresa AND
              tbDocumentoNFe.CodigoLocal = @CodigoLocal AND
              tbDocumentoNFe.CodigoCliFor = tbItemPatrimonial.CodigoCliFor AND
              tbDocumentoNFe.DataDocumento = tbItemPatrimonial.DataAquisicaoItem AND
              tbDocumentoNFe.NumeroDocumento = tbItemPatrimonial.NumeroDoctoAquisicaoItem
	WHERE 
    tbControleICMSAtivo.CodigoEmpresa = @CodigoEmpresa AND
	tbControleICMSAtivo.CodigoLocal = @CodigoLocal AND
	tbItemPatrimonial.DataAquisicaoItem <= @DataFinal AND
	ValorCreditoICMSAtivo <> 0 AND
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) + 1 <= 48 AND
    ( tbItemPatrimonial.DataBaixaItem IS NULL OR tbItemPatrimonial.DataBaixaItem BETWEEN @DataInicial AND @DataFinal )

	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|G140|1|' + 
	RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4) + '|',
	'G140',
	'E',
	0,
	@DataInicial,
	CONVERT(NUMERIC(14),RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4)),
	1,
	69,
	'',
	0,
	'',
	0
	FROM tbControleICMSAtivo (NOLOCK)
	INNER JOIN tbItemPatrimonial (NOLOCK) ON 
               tbItemPatrimonial.CodigoEmpresa = @CodigoEmpresa AND
               tbItemPatrimonial.CodigoLocal = @CodigoLocal AND
               tbItemPatrimonial.CodigoItemPatrimonial = tbControleICMSAtivo.CodigoItemICMSAtivo AND
               tbItemPatrimonial.SequenciaItemPatrimonial = tbControleICMSAtivo.SeqItemICMSAtivo
	WHERE 
    tbControleICMSAtivo.CodigoEmpresa = @CodigoEmpresa AND
	tbControleICMSAtivo.CodigoLocal = @CodigoLocal AND
	tbItemPatrimonial.DataAquisicaoItem <= @DataFinal AND
	ValorCreditoICMSAtivo <> 0 AND
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) + 1 <= 48 AND
    ( tbItemPatrimonial.DataBaixaItem IS NULL OR tbItemPatrimonial.DataBaixaItem BETWEEN @DataInicial AND @DataFinal )

	DECLARE @SaldoInicialICMS money
	DECLARE @SomaParcelas money

	SELECT @SaldoInicialICMS = SUM(tbControleICMSAtivo.ValorCreditoICMSAtivo + 
                                   tbControleICMSAtivo.ValorICMSST +
								   tbControleICMSAtivo.ValorICMSFrete +
								   COALESCE(tbControleICMSAtivo.ValorICMSDifAliquota,0)	)
	FROM tbControleICMSAtivo (NOLOCK)
	INNER JOIN tbItemPatrimonial (NOLOCK) ON 
               tbItemPatrimonial.CodigoEmpresa = @CodigoEmpresa AND
               tbItemPatrimonial.CodigoLocal = @CodigoLocal AND
               tbItemPatrimonial.CodigoItemPatrimonial = tbControleICMSAtivo.CodigoItemICMSAtivo AND
               tbItemPatrimonial.SequenciaItemPatrimonial = tbControleICMSAtivo.SeqItemICMSAtivo
	WHERE 
    tbControleICMSAtivo.CodigoEmpresa = @CodigoEmpresa AND
	tbControleICMSAtivo.CodigoLocal = @CodigoLocal AND
	tbItemPatrimonial.DataAquisicaoItem < @DataInicial AND
	ValorCreditoICMSAtivo <> 0 AND
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) + 1 <= 48 AND
    ( tbItemPatrimonial.DataBaixaItem IS NULL OR tbItemPatrimonial.DataBaixaItem BETWEEN @DataInicial AND @DataFinal )

	SELECT
           @SomaParcelas = SUM(( tbControleICMSAtivo.ValorCreditoICMSAtivo + tbControleICMSAtivo.ValorICMSST + tbControleICMSAtivo.ValorICMSFrete + COALESCE(CONVERT(NUMERIC(16,2),tbControleICMSAtivo.ValorICMSDifAliquota),0.00) ) / 48) 
	FROM tbControleICMSAtivo (NOLOCK)
	INNER JOIN tbItemPatrimonial (NOLOCK) ON 
               tbItemPatrimonial.CodigoEmpresa = @CodigoEmpresa AND
               tbItemPatrimonial.CodigoLocal = @CodigoLocal AND
               tbItemPatrimonial.CodigoItemPatrimonial = tbControleICMSAtivo.CodigoItemICMSAtivo AND
               tbItemPatrimonial.SequenciaItemPatrimonial = tbControleICMSAtivo.SeqItemICMSAtivo
	WHERE 
    tbControleICMSAtivo.CodigoEmpresa = @CodigoEmpresa AND
	tbControleICMSAtivo.CodigoLocal = @CodigoLocal AND
	tbItemPatrimonial.DataAquisicaoItem <= @DataFinal AND
	ValorCreditoICMSAtivo <> 0 AND
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) + 1 <= 48 AND
    ( tbItemPatrimonial.DataBaixaItem IS NULL OR tbItemPatrimonial.DataBaixaItem BETWEEN @DataInicial AND @DataFinal )

	IF @SaldoInicialICMS IS NULL SELECT @SaldoInicialICMS = 0
	IF @SomaParcelas IS NULL SELECT @SomaParcelas = 0

	UPDATE rtSPEDFiscal
	SET 
    Linha = REPLACE(Linha,'SOMAINI',REPLACE(CONVERT(VARCHAR(16),@SaldoInicialICMS),'.',','))
	WHERE
	TipoRegistro = 'G110'

	UPDATE rtSPEDFiscal
	SET 
    Linha = REPLACE(Linha,'SOMA10',REPLACE(CONVERT(VARCHAR(16),@SomaParcelas),'.',','))
	WHERE
	TipoRegistro = 'G110'
	

	UPDATE rtSPEDFiscal
	SET 
    Linha = CASE WHEN ValorSaidas <> 0 THEN
				REPLACE(Linha,'ICMSAPROP',REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),( @SomaParcelas * CONVERT(NUMERIC(16,8),( ValorSaidasTributadas / ValorSaidas ))))),'.',','))
			ELSE
				REPLACE(Linha,'ICMSAPROP','0,00')
			END
	FROM tbSPEDFiscalCIAP
	WHERE 
    CodigoEmpresa = @CodigoEmpresa AND
    CodigoLocal = @CodigoLocal AND
    Periodo = @Periodo AND
	TipoRegistro = 'G110'

	---G990

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|G990|' +
	CONVERT(VARCHAR(8),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro like 'G%' ) + 1) + '|',
	'G990',
	'E',
	0,
	getdate(),
	0,
	0,
	70,
	'',
	0,
	'',
	0

	---
	
END
ELSE
BEGIN

	IF CONVERT(numeric(4),@Versao) > 3
	BEGIN
		INSERT rtSPEDFiscal
		SELECT DISTINCT
		@@spid,
		'|G001|1|',
		'G001',
		'E',
		0,
		getdate(),
		0,
		0,
		68,
		'',
		0,
		'',
		0

		---G990

		INSERT rtSPEDFiscal
		SELECT
		@@spid,
		'|G990|' +
		CONVERT(VARCHAR(8),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro like 'G%' ) + 1) + '|',
		'G990',
		'E',
		0,
		getdate(),
		0,
		0,
		70,
		'',
		0,
		'',
		0
	END
END


IF CONVERT(NUMERIC(4),@Versao) >= 10
BEGIN
	-------------------------------------------------------------------------
	-- BLOCO K
	-------------------------------------------------------------------------
	IF @EquiparadoIndustria = 'V'
	BEGIN
		INSERT rtSPEDFiscal
		SELECT DISTINCT
		@@spid,
		'|K200|' + 
		COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataFinal)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataFinal)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataFinal)),'') + '|' +
		RTRIM(LTRIM(rtRegistroInventario.CodigoProduto)) + '|' +
		RTRIM(LTRIM(rtRegistroInventario.QuantidadeProduto)) + '|' +
		'0|' +
		'|',
		'K200',
		'E',
		0,
		getdate(),
		0,
		0,
		70,
		'',
		0,
		'',
		0
		FROM rtRegistroInventario
		WHERE
		Spid = @@spid 

		INSERT rtSPEDFiscal
		SELECT DISTINCT
		@@spid,
		'|K100|' + 
		COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|' + 
		COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataFinal)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataFinal)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataFinal)),'') + '|',
		'K100',
		'E',
		0,
		getdate(),
		0,
		0,
		70,
		'',
		0,
		'',
		0
		FROM rtSPEDFiscal
		WHERE
		Spid = @@spid 
		AND EXISTS ( SELECT 1 FROM rtSPEDFiscal where Spid = @@spid AND TipoRegistro = 'K200' )
	END
	
	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|K001|' +
	CASE WHEN EXISTS (SELECT 1 FROM rtSPEDFiscal where Spid = @@spid AND TipoRegistro LIKE 'K%') THEN
		'0'
	ELSE
		'1'
	END + '|',
	'K001',
	'E',
	0,
	getdate(),
	0,
	0,
	70,
	'',
	0,
	'',
	0

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|K990|' +
	CONVERT(VARCHAR(8),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro like 'K%' ) + 1) + '|',
	'K990',
	'E',
	0,
	getdate(),
	0,
	0,
	71,
	'',
	0,
	'',
	0
END

---- Tabelas Basicas

UPDATE rtSPEDFiscal SET CodigoCliFor = 0, CodigoClienteEventual = 0
FROM tbDocumento (NOLOCK)
WHERE
rtSPEDFiscal.Spid = @@spid
AND tbDocumento.CodigoEmpresa = @CodigoEmpresa
AND tbDocumento.CodigoLocal = @CodigoLocal
AND tbDocumento.EntradaSaidaDocumento = rtSPEDFiscal.EntradaSaida
AND tbDocumento.NumeroDocumento = rtSPEDFiscal.NumeroDocumento
AND tbDocumento.DataDocumento = rtSPEDFiscal.DataDocumento
AND tbDocumento.CodigoCliFor = rtSPEDFiscal.CodigoCliFor
AND tbDocumento.TipoLancamentoMovimentacao = rtSPEDFiscal.TipoLancamentoMovimentacao
AND tbDocumento.CodigoModeloNotaFiscal = 65

INSERT rtSPEDFiscal
SELECT
@@spid,
'|0150|' +
CONVERT(VARCHAR(14),tbCliFor.CodigoCliFor) + '|' +
RTRIM(LTRIM(CONVERT(VARCHAR(60),dbo.fnRemoveSpecialCharacter(tbCliFor.NomeCliFor)))) + '|' +
CONVERT(VARCHAR(5),COALESCE(tbCliFor.IdPais,'1058')) + '|' +
RTRIM(LTRIM(CASE WHEN tbCliFor.TipoCliFor = 'J' AND CGCJuridica NOT LIKE 'ISEN%' THEN CGCJuridica ELSE '' END)) + '|' +
RTRIM(LTRIM(CASE WHEN tbCliFor.TipoCliFor = 'F' AND CPFFisica NOT LIKE 'ISEN%' THEN CPFFisica ELSE '' END)) + '|' +
RTRIM(LTRIM(CASE WHEN tbCliFor.TipoCliFor = 'J' AND RTRIM(LTRIM(InscricaoEstadualJuridica)) NOT LIKE 'ISENT%' THEN COALESCE(REPLACE(REPLACE(InscricaoEstadualJuridica,'.',''),'-',''),'') ELSE '' END)) + '|' +
CONVERT(VARCHAR(7),COALESCE(COALESCE(CONVERT(VARCHAR(8) ,tbCEP.NumeroMunicipio),CONVERT(VARCHAR(8),tbMunicipio.NumeroMunicipio)),'')) + '|' +
'' + '|' +
RTRIM(LTRIM(CONVERT(VARCHAR(60),RuaCliFor))) + '|' +
CASE WHEN COALESCE(CONVERT(VARCHAR(6),NumeroEndCliFor),'') = '0' THEN '' ELSE COALESCE(CONVERT(VARCHAR(6),NumeroEndCliFor),'') END + '|' +
RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(20),ComplementoEndCliFor),''))) + '|' +
RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(70),BairroCliFor),''))) + '|',
'0150',
'E',
0,
CONVERT(DATETIME,CONVERT(VARCHAR(4),DATEPART(YEAR,GETDATE()))+'-'+
RIGHT(CONVERT(VARCHAR(3),100+DATEPART(MONTH,GETDATE())),2)+'-'+
RIGHT(CONVERT(VARCHAR(3),100+DATEPART(DAY,GETDATE())),2)),
tbCliFor.CodigoCliFor,
0,
4,
'',
0,
'',
0
FROM tbCliFor (NOLOCK)
LEFT JOIN tbCliForFisica (NOLOCK) ON
          tbCliForFisica.CodigoEmpresa = tbCliFor.CodigoEmpresa AND
          tbCliForFisica.CodigoCliFor = tbCliFor.CodigoCliFor
LEFT JOIN tbCliForJuridica (NOLOCK) ON
          tbCliForJuridica.CodigoEmpresa = tbCliFor.CodigoEmpresa AND
          tbCliForJuridica.CodigoCliFor = tbCliFor.CodigoCliFor
LEFT JOIN tbCEP (NOLOCK) ON
          tbCEP.NumeroCEP = tbCliFor.CEPCliFor
LEFT JOIN tbMunicipio (NOLOCK) ON
          tbMunicipio.UF = tbCliFor.UFCliFor AND
          tbMunicipio.Municipio = tbCliFor.MunicipioCliFor
WHERE
tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK)
         WHERE rtSPEDFiscal.Spid = @@spid AND
               rtSPEDFiscal.TipoRegistro IN ('C100','C500','D100','D500','W002') AND
			   rtSPEDFiscal.CodigoCliFor = tbCliFor.CodigoCliFor AND
               rtSPEDFiscal.CodigoClienteEventual = 0 )
------
AND tbCliFor.ClienteEventual <> 'V'

-- Cadastro CliFor C176
INSERT rtSPEDFiscal
SELECT
@@spid,
'|0150|' +
CONVERT(VARCHAR(14),tbCliFor.CodigoCliFor) + '|' +
RTRIM(LTRIM(CONVERT(VARCHAR(60),dbo.fnRemoveSpecialCharacter(tbCliFor.NomeCliFor)))) + '|' +
CONVERT(VARCHAR(5),COALESCE(tbCliFor.IdPais,'1058')) + '|' +
RTRIM(LTRIM(CASE WHEN tbCliFor.TipoCliFor = 'J' AND CGCJuridica NOT LIKE 'ISEN%' THEN CGCJuridica ELSE '' END)) + '|' +
RTRIM(LTRIM(CASE WHEN tbCliFor.TipoCliFor = 'F' AND CPFFisica NOT LIKE 'ISEN%' THEN CPFFisica ELSE '' END)) + '|' +
RTRIM(LTRIM(CASE WHEN tbCliFor.TipoCliFor = 'J' AND RTRIM(LTRIM(InscricaoEstadualJuridica)) NOT LIKE 'ISENT%' THEN COALESCE(REPLACE(REPLACE(InscricaoEstadualJuridica,'.',''),'-',''),'') ELSE '' END)) + '|' +
CONVERT(VARCHAR(7),COALESCE(COALESCE(CONVERT(VARCHAR(8) ,tbCEP.NumeroMunicipio),CONVERT(VARCHAR(8),tbMunicipio.NumeroMunicipio)),'')) + '|' +
'' + '|' +
RTRIM(LTRIM(CONVERT(VARCHAR(60),RuaCliFor))) + '|' +
CASE WHEN COALESCE(CONVERT(VARCHAR(6),NumeroEndCliFor),'') = '0' THEN '' ELSE COALESCE(CONVERT(VARCHAR(6),NumeroEndCliFor),'') END + '|' +
RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(20),ComplementoEndCliFor),''))) + '|' +
RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(70),BairroCliFor),''))) + '|',
'0150',
'E',
0,
CONVERT(DATETIME,CONVERT(VARCHAR(4),DATEPART(YEAR,GETDATE()))+'-'+
RIGHT(CONVERT(VARCHAR(3),100+DATEPART(MONTH,GETDATE())),2)+'-'+
RIGHT(CONVERT(VARCHAR(3),100+DATEPART(DAY,GETDATE())),2)),
tbCliFor.CodigoCliFor,
0,
4,
'',
0,
'',
0
FROM tbCliFor (NOLOCK)
LEFT JOIN tbCliForFisica (NOLOCK) ON
          tbCliForFisica.CodigoEmpresa = tbCliFor.CodigoEmpresa AND
          tbCliForFisica.CodigoCliFor = tbCliFor.CodigoCliFor
LEFT JOIN tbCliForJuridica (NOLOCK) ON
          tbCliForJuridica.CodigoEmpresa = tbCliFor.CodigoEmpresa AND
          tbCliForJuridica.CodigoCliFor = tbCliFor.CodigoCliFor
LEFT JOIN tbCEP (NOLOCK) ON
          tbCEP.NumeroCEP = tbCliFor.CEPCliFor
LEFT JOIN tbMunicipio (NOLOCK) ON
          tbMunicipio.UF = tbCliFor.UFCliFor AND
          tbMunicipio.Municipio = tbCliFor.MunicipioCliFor
WHERE
	tbCliFor.CodigoEmpresa = @CodigoEmpresa
AND EXISTS (	select 1 from tbSPEDFiscalC176 (nolock) where 
				tbSPEDFiscalC176.CodigoLocal = @CodigoLocal and
				tbSPEDFiscalC176.DataDoctoSaida between @DataInicial and @DataFinal and
				tbCliFor.CodigoEmpresa = tbSPEDFiscalC176.CodigoEmpresa and
				tbCliFor.CodigoCliFor in (tbSPEDFiscalC176.CodigoCliForDoctoEntrada,tbSPEDFiscalC176.CodigoCliForDoctoRet)
	)
AND NOT EXISTS (	select 1 from rtSPEDFiscal (nolock) where
					rtSPEDFiscal.Spid = @@spid and
					rtSPEDFiscal.TipoRegistro = '0150' and
					rtSPEDFiscal.CodigoCliFor = tbCliFor.CodigoCliFor
	)

--- Cliente Eventual

INSERT rtSPEDFiscal
SELECT
@@spid,
'|0150|' +
CONVERT(VARCHAR(14),tbClienteEventual.CodigoClienteEventual) + '|' +
RTRIM(LTRIM(CONVERT(VARCHAR(60),tbClienteEventual.NomeCliEven))) + '|' +
CONVERT(VARCHAR(5),'1058') + '|' +
RTRIM(LTRIM(CASE WHEN CGCCliEven IS NOT NULL AND CGCCliEven NOT LIKE 'ISEN%' THEN CGCCliEven ELSE '' END)) + '|' +
RTRIM(LTRIM(CASE WHEN CPFCliEven IS NOT NULL AND CPFCliEven NOT LIKE 'ISEN%' THEN CPFCliEven ELSE '' END)) + '|' +
RTRIM(LTRIM(CASE WHEN InscricaoEstadualCliEven IS NOT NULL AND RTRIM(LTRIM(InscricaoEstadualCliEven)) NOT LIKE 'ISEN%' THEN COALESCE(InscricaoEstadualCliEven,'') ELSE '' END)) + '|' +
CONVERT(VARCHAR(7),COALESCE(COALESCE(CONVERT(VARCHAR(8),tbCEP.NumeroMunicipio),CONVERT(VARCHAR(8),tbMunicipio.NumeroMunicipio)),'')) + '|' +
'' + '|' +
RTRIM(LTRIM(CONVERT(VARCHAR(60),EnderecoCliEven))) + '|' +
'' + '|' +
'' + '|' +
RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(70),BairroCliEven),''))) + '|',
'0150',
'E',
0,
CONVERT(DATETIME,CONVERT(VARCHAR(4),DATEPART(YEAR,GETDATE()))+'-'+
RIGHT(CONVERT(VARCHAR(3),100+DATEPART(MONTH,GETDATE())),2)+'-'+
RIGHT(CONVERT(VARCHAR(3),100+DATEPART(DAY,GETDATE())),2)),
tbClienteEventual.CodigoClienteEventual,
0,
4,
'',
0,
'',
0
FROM tbClienteEventual (NOLOCK)
LEFT JOIN tbCEP (NOLOCK) ON
          tbCEP.NumeroCEP = tbClienteEventual.CEPCliEven
LEFT JOIN tbMunicipio (NOLOCK) ON
          tbMunicipio.UF = tbClienteEventual.UnidadeFederacao AND
          tbMunicipio.Municipio = tbClienteEventual.MunicipioCliEven
WHERE
tbClienteEventual.CodigoEmpresa = @CodigoEmpresa AND
EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK)
         WHERE rtSPEDFiscal.Spid = @@spid AND
               rtSPEDFiscal.TipoRegistro = 'C100' AND
               rtSPEDFiscal.CodigoClienteEventual = tbClienteEventual.CodigoClienteEventual AND
               rtSPEDFiscal.CodigoClienteEventual <> 0
              ) AND
NOT EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK)
			 WHERE rtSPEDFiscal.Spid = @@spid AND
               rtSPEDFiscal.TipoRegistro = '0150' AND
			   rtSPEDFiscal.CodigoCliFor = tbClienteEventual.CodigoClienteEventual )


IF @GerarCIAP = 'V' 
BEGIN
	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|0150|' +
	CONVERT(VARCHAR(14),tbCliFor.CodigoCliFor) + '|' +
	RTRIM(LTRIM(CONVERT(VARCHAR(60),dbo.fnRemoveSpecialCharacter(tbCliFor.NomeCliFor)))) + '|' +
	CONVERT(VARCHAR(5),COALESCE(tbCliFor.IdPais,'1058')) + '|' +
	RTRIM(LTRIM(CASE WHEN tbCliFor.TipoCliFor = 'J' AND CGCJuridica NOT LIKE 'ISEN%' THEN CGCJuridica ELSE '' END)) + '|' +
	RTRIM(LTRIM(CASE WHEN tbCliFor.TipoCliFor = 'F' AND CPFFisica NOT LIKE 'ISEN%' THEN CPFFisica ELSE '' END)) + '|' +
	RTRIM(LTRIM(CASE WHEN tbCliFor.TipoCliFor = 'J' AND RTRIM(LTRIM(InscricaoEstadualJuridica)) NOT LIKE 'ISENT%' THEN COALESCE(REPLACE(REPLACE(InscricaoEstadualJuridica,'.',''),'-',''),'') ELSE '' END)) + '|' +
	CONVERT(VARCHAR(7),COALESCE(COALESCE(CONVERT(VARCHAR(8) ,tbCEP.NumeroMunicipio),CONVERT(VARCHAR(8),tbMunicipio.NumeroMunicipio)),'')) + '|' +
	'' + '|' +
	RTRIM(LTRIM(CONVERT(VARCHAR(60),RuaCliFor))) + '|' +
	COALESCE(CONVERT(VARCHAR(6),NumeroEndCliFor),'') + '|' +
	RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(20),ComplementoEndCliFor),''))) + '|' +
	RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(70),BairroCliFor),''))) + '|',
	'0150',
	'E',
	0,
	CONVERT(DATETIME,CONVERT(VARCHAR(4),DATEPART(YEAR,GETDATE()))+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(MONTH,GETDATE())),2)+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(DAY,GETDATE())),2)),
	tbCliFor.CodigoCliFor,
	0,
	4,
	'',
	0,
	'',
	0
	FROM tbControleICMSAtivo (NOLOCK)
	INNER JOIN tbItemPatrimonial (NOLOCK) ON 
			   tbItemPatrimonial.CodigoEmpresa = @CodigoEmpresa AND
			   tbItemPatrimonial.CodigoLocal = @CodigoLocal AND
			   tbItemPatrimonial.CodigoItemPatrimonial = tbControleICMSAtivo.CodigoItemICMSAtivo AND
			   tbItemPatrimonial.SequenciaItemPatrimonial = tbControleICMSAtivo.SeqItemICMSAtivo
	INNER JOIN tbCliFor (NOLOCK) ON
			   tbCliFor.CodigoEmpresa = @CodigoEmpresa AND 
			   tbCliFor.CodigoCliFor = tbItemPatrimonial.CodigoCliFor
	LEFT JOIN tbCliForFisica (NOLOCK) ON
			  tbCliForFisica.CodigoEmpresa = tbCliFor.CodigoEmpresa AND
			  tbCliForFisica.CodigoCliFor = tbCliFor.CodigoCliFor
	LEFT JOIN tbCliForJuridica (NOLOCK) ON
			  tbCliForJuridica.CodigoEmpresa = tbCliFor.CodigoEmpresa AND
			  tbCliForJuridica.CodigoCliFor = tbCliFor.CodigoCliFor
	LEFT JOIN tbCEP (NOLOCK) ON
			  tbCEP.NumeroCEP = tbCliFor.CEPCliFor
	LEFT JOIN tbMunicipio (NOLOCK) ON
			  tbMunicipio.UF = tbCliFor.UFCliFor AND
			  tbMunicipio.Municipio = tbCliFor.MunicipioCliFor
	WHERE 
	tbControleICMSAtivo.CodigoEmpresa = @CodigoEmpresa AND
	tbControleICMSAtivo.CodigoLocal = @CodigoLocal AND
	tbItemPatrimonial.DataAquisicaoItem <= @DataFinal AND
	ValorCreditoICMSAtivo <> 0 AND
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) + 1 <= 48 AND
	( tbItemPatrimonial.DataBaixaItem IS NULL OR tbItemPatrimonial.DataBaixaItem BETWEEN @DataInicial AND @DataFinal ) AND
	NOT EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK)
				 WHERE rtSPEDFiscal.Spid = @@spid AND
				   rtSPEDFiscal.TipoRegistro = '0150' AND
				   rtSPEDFiscal.CodigoCliFor = tbItemPatrimonial.CodigoCliFor )
END

-- Cadastro participante referente registro C176
INSERT rtSPEDFiscal
SELECT
@@spid,
'|0150|' +
CONVERT(VARCHAR(14),tbCliFor.CodigoCliFor) + '|' +
RTRIM(LTRIM(CONVERT(VARCHAR(60),dbo.fnRemoveSpecialCharacter(tbCliFor.NomeCliFor)))) + '|' +
CONVERT(VARCHAR(5),COALESCE(tbCliFor.IdPais,'1058')) + '|' +
RTRIM(LTRIM(CASE WHEN tbCliFor.TipoCliFor = 'J' AND CGCJuridica NOT LIKE 'ISEN%' THEN CGCJuridica ELSE '' END)) + '|' +
RTRIM(LTRIM(CASE WHEN tbCliFor.TipoCliFor = 'F' AND CPFFisica NOT LIKE 'ISEN%' THEN CPFFisica ELSE '' END)) + '|' +
RTRIM(LTRIM(CASE WHEN tbCliFor.TipoCliFor = 'J' AND RTRIM(LTRIM(InscricaoEstadualJuridica)) NOT LIKE 'ISENT%' THEN COALESCE(REPLACE(REPLACE(InscricaoEstadualJuridica,'.',''),'-',''),'') ELSE '' END)) + '|' +
CONVERT(VARCHAR(7),COALESCE(COALESCE(CONVERT(VARCHAR(8) ,tbCEP.NumeroMunicipio),CONVERT(VARCHAR(8),tbMunicipio.NumeroMunicipio)),'')) + '|' +
'' + '|' +
RTRIM(LTRIM(CONVERT(VARCHAR(60),RuaCliFor))) + '|' +
COALESCE(CONVERT(VARCHAR(6),NumeroEndCliFor),'') + '|' +
RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(20),ComplementoEndCliFor),''))) + '|' +
RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(70),BairroCliFor),''))) + '|',
'0150',
'E',
0,
CONVERT(DATETIME,CONVERT(VARCHAR(4),DATEPART(YEAR,GETDATE()))+'-'+
RIGHT(CONVERT(VARCHAR(3),100+DATEPART(MONTH,GETDATE())),2)+'-'+
RIGHT(CONVERT(VARCHAR(3),100+DATEPART(DAY,GETDATE())),2)),
tbCliFor.CodigoCliFor,
0,
4,
'',
0,
'',
0
FROM tbCliFor (NOLOCK)
LEFT JOIN tbCliForFisica (NOLOCK) ON
          tbCliForFisica.CodigoEmpresa = tbCliFor.CodigoEmpresa AND
          tbCliForFisica.CodigoCliFor = tbCliFor.CodigoCliFor
LEFT JOIN tbCliForJuridica (NOLOCK) ON
          tbCliForJuridica.CodigoEmpresa = tbCliFor.CodigoEmpresa AND
          tbCliForJuridica.CodigoCliFor = tbCliFor.CodigoCliFor
LEFT JOIN tbCEP (NOLOCK) ON
          tbCEP.NumeroCEP = tbCliFor.CEPCliFor
LEFT JOIN tbMunicipio (NOLOCK) ON
          tbMunicipio.UF = tbCliFor.UFCliFor AND
          tbMunicipio.Municipio = tbCliFor.MunicipioCliFor
WHERE
tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
EXISTS (	SELECT 1 FROM rtSPEDFiscal (NOLOCK)
			INNER JOIN tbSPEDFiscalC176 (NOLOCK) ON
			rtSPEDFiscal.EntradaSaida = tbSPEDFiscalC176.EntSaiDoctoSaida AND
			rtSPEDFiscal.DataDocumento = tbSPEDFiscalC176.DataDoctoSaida AND
			rtSPEDFiscal.CodigoCliFor = tbSPEDFiscalC176.CodigoCliForDoctoSaida AND
			rtSPEDFiscal.NumeroDocumento = tbSPEDFiscalC176.NumeroDoctoSaida AND
			rtSPEDFiscal.TipoLancamentoMovimentacao = tbSPEDFiscalC176.TipoLanctoDoctoSaida
			WHERE rtSPEDFiscal.Spid = @@spid )
AND NOT EXISTS (	SELECT 1 FROM rtSPEDFiscal
					WHERE	rtSPEDFiscal.Spid = @@spid
					AND		rtSPEDFiscal.TipoRegistro = '0150'
					AND		tbCliFor.CodigoEmpresa = @CodigoEmpresa
					AND		rtSPEDFiscal.CodigoCliFor = tbCliFor.CodigoCliFor )
AND EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK)
         WHERE rtSPEDFiscal.Spid = @@spid AND
               rtSPEDFiscal.TipoRegistro IN ('C100','C500','D100','D500','W002') AND
			   rtSPEDFiscal.CodigoCliFor = tbCliFor.CodigoCliFor AND
               rtSPEDFiscal.CodigoClienteEventual = 0 )



-- REGISTRO 0175 - ALTERAÇÕES NO CADASTRO DO PARTICIPANTE
IF EXISTS ( SELECT 1 FROM sysobjects WHERE name = 'rtAlteracaoCliFor' )
BEGIN
	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
		'|0175|'
	+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,rtAlteracaoCliFor.DataAlteracao)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,rtAlteracaoCliFor.DataAlteracao)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,rtAlteracaoCliFor.DataAlteracao)) + '|'
	+	'03' + '|' -- NOME
	+	RTRIM(LTRIM(rtAlteracaoCliFor.NomeCliFor)) + '|',
	'0175',
	'E',
	0,
	CONVERT(DATETIME,CONVERT(VARCHAR(4),DATEPART(YEAR,GETDATE()))+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(MONTH,GETDATE())),2)+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(DAY,GETDATE())),2)),
	rtAlteracaoCliFor.CodigoCliFor,
	0,
	4,
	'',
	0,
	'',
	0
	FROM rtAlteracaoCliFor (NOLOCK)
	INNER JOIN rtSPEDFiscal (NOLOCK) ON
		rtSPEDFiscal.CodigoCliFor = rtAlteracaoCliFor.CodigoCliFor AND
		rtSPEDFiscal.Spid = @@spid AND
		rtSPEDFiscal.TipoRegistro = '0150'
	WHERE 
	rtAlteracaoCliFor.CodigoEmpresa = @CodigoEmpresa AND
	rtAlteracaoCliFor.DataAlteracao BETWEEN @DataInicial AND @DataFinal AND
	rtAlteracaoCliFor.NomeCliFor IS NOT NULL
	
	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
		'|0175|'
	+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,rtAlteracaoCliFor.DataAlteracao)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,rtAlteracaoCliFor.DataAlteracao)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,rtAlteracaoCliFor.DataAlteracao)) + '|'
	+	'04' + '|' -- COD_PAIS
	+	RTRIM(LTRIM(rtAlteracaoCliFor.IdPais)) + '|',
	'0175',
	'E',
	0,
	CONVERT(DATETIME,CONVERT(VARCHAR(4),DATEPART(YEAR,GETDATE()))+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(MONTH,GETDATE())),2)+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(DAY,GETDATE())),2)),
	rtAlteracaoCliFor.CodigoCliFor,
	0,
	4,
	'',
	0,
	'',
	0
	FROM rtAlteracaoCliFor (NOLOCK)
	INNER JOIN rtSPEDFiscal (NOLOCK) ON
		rtSPEDFiscal.CodigoCliFor = rtAlteracaoCliFor.CodigoCliFor AND
		rtSPEDFiscal.Spid = @@spid AND
		rtSPEDFiscal.TipoRegistro = '0150'
	WHERE 
	rtAlteracaoCliFor.CodigoEmpresa = @CodigoEmpresa AND
	rtAlteracaoCliFor.DataAlteracao BETWEEN @DataInicial AND @DataFinal AND
	rtAlteracaoCliFor.IdPais IS NOT NULL
	
	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
		'|0175|'
	+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,rtAlteracaoCliFor.DataAlteracao)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,rtAlteracaoCliFor.DataAlteracao)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,rtAlteracaoCliFor.DataAlteracao)) + '|'
	+	'08' + '|' -- COD_MUN
	+	CONVERT(VARCHAR(7),COALESCE(CONVERT(VARCHAR(8),tbCEP.NumeroMunicipio),'')) + '|',
	'0175',
	'E',
	0,
	CONVERT(DATETIME,CONVERT(VARCHAR(4),DATEPART(YEAR,GETDATE()))+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(MONTH,GETDATE())),2)+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(DAY,GETDATE())),2)),
	rtAlteracaoCliFor.CodigoCliFor,
	0,
	4,
	'',
	0,
	'',
	0
	FROM rtAlteracaoCliFor (NOLOCK)
	INNER JOIN rtSPEDFiscal (NOLOCK) ON
		rtSPEDFiscal.CodigoCliFor = rtAlteracaoCliFor.CodigoCliFor AND
		rtSPEDFiscal.Spid = @@spid AND
		rtSPEDFiscal.TipoRegistro = '0150'
	LEFT JOIN tbCEP (NOLOCK) ON
		tbCEP.NumeroCEP = rtAlteracaoCliFor.CEPCliFor
	WHERE 
	rtAlteracaoCliFor.CodigoEmpresa = @CodigoEmpresa AND
	rtAlteracaoCliFor.DataAlteracao BETWEEN @DataInicial AND @DataFinal AND
	rtAlteracaoCliFor.MunicipioCliFor IS NOT NULL AND
	rtAlteracaoCliFor.CEPCliFor IS NOT NULL
	
	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
		'|0175|'
	+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,rtAlteracaoCliFor.DataAlteracao)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,rtAlteracaoCliFor.DataAlteracao)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,rtAlteracaoCliFor.DataAlteracao)) + '|'
	+	'09' + '|' -- SUFRAMA
	+	RTRIM(LTRIM(rtAlteracaoCliFor.InscricaoSUFRAMA)) + '|',
	'0175',
	'E',
	0,
	CONVERT(DATETIME,CONVERT(VARCHAR(4),DATEPART(YEAR,GETDATE()))+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(MONTH,GETDATE())),2)+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(DAY,GETDATE())),2)),
	rtAlteracaoCliFor.CodigoCliFor,
	0,
	4,
	'',
	0,
	'',
	0
	FROM rtAlteracaoCliFor (NOLOCK)
	INNER JOIN rtSPEDFiscal (NOLOCK) ON
		rtSPEDFiscal.CodigoCliFor = rtAlteracaoCliFor.CodigoCliFor AND
		rtSPEDFiscal.Spid = @@spid AND
		rtSPEDFiscal.TipoRegistro = '0150'
	WHERE 
	rtAlteracaoCliFor.CodigoEmpresa = @CodigoEmpresa AND
	rtAlteracaoCliFor.DataAlteracao BETWEEN @DataInicial AND @DataFinal AND
	rtAlteracaoCliFor.InscricaoSUFRAMA IS NOT NULL
	
	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
		'|0175|'
	+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,rtAlteracaoCliFor.DataAlteracao)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,rtAlteracaoCliFor.DataAlteracao)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,rtAlteracaoCliFor.DataAlteracao)) + '|'
	+	'10' + '|' -- END
	+	RTRIM(LTRIM(rtAlteracaoCliFor.RuaCliFor)) + '|',
	'0175',
	'E',
	0,
	CONVERT(DATETIME,CONVERT(VARCHAR(4),DATEPART(YEAR,GETDATE()))+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(MONTH,GETDATE())),2)+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(DAY,GETDATE())),2)),
	rtAlteracaoCliFor.CodigoCliFor,
	0,
	4,
	'',
	0,
	'',
	0
	FROM rtAlteracaoCliFor (NOLOCK)
	INNER JOIN rtSPEDFiscal (NOLOCK) ON
		rtSPEDFiscal.CodigoCliFor = rtAlteracaoCliFor.CodigoCliFor AND
		rtSPEDFiscal.Spid = @@spid AND
		rtSPEDFiscal.TipoRegistro = '0150'
	WHERE 
	rtAlteracaoCliFor.CodigoEmpresa = @CodigoEmpresa AND
	rtAlteracaoCliFor.DataAlteracao BETWEEN @DataInicial AND @DataFinal AND
	rtAlteracaoCliFor.RuaCliFor IS NOT NULL
	
	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
		'|0175|'
	+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,rtAlteracaoCliFor.DataAlteracao)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,rtAlteracaoCliFor.DataAlteracao)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,rtAlteracaoCliFor.DataAlteracao)) + '|'
	+	'11' + '|' -- NUM
	+	RTRIM(LTRIM(rtAlteracaoCliFor.NumeroEndCliFor)) + '|',
	'0175',
	'E',
	0,
	CONVERT(DATETIME,CONVERT(VARCHAR(4),DATEPART(YEAR,GETDATE()))+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(MONTH,GETDATE())),2)+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(DAY,GETDATE())),2)),
	rtAlteracaoCliFor.CodigoCliFor,
	0,
	4,
	'',
	0,
	'',
	0
	FROM rtAlteracaoCliFor (NOLOCK)
	INNER JOIN rtSPEDFiscal (NOLOCK) ON
		rtSPEDFiscal.CodigoCliFor = rtAlteracaoCliFor.CodigoCliFor AND
		rtSPEDFiscal.Spid = @@spid AND
		rtSPEDFiscal.TipoRegistro = '0150'
	WHERE 
	rtAlteracaoCliFor.CodigoEmpresa = @CodigoEmpresa AND
	rtAlteracaoCliFor.DataAlteracao BETWEEN @DataInicial AND @DataFinal AND
	rtAlteracaoCliFor.NumeroEndCliFor IS NOT NULL
	
	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
		'|0175|'
	+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,rtAlteracaoCliFor.DataAlteracao)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,rtAlteracaoCliFor.DataAlteracao)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,rtAlteracaoCliFor.DataAlteracao)) + '|'
	+	'12' + '|' -- COMPL
	+	CASE WHEN RTRIM(LTRIM(rtAlteracaoCliFor.ComplementoEndCliFor)) = '' THEN
			'.'
		ELSE
			RTRIM(LTRIM(rtAlteracaoCliFor.ComplementoEndCliFor))
		END + '|',
	'0175',
	'E',
	0,
	CONVERT(DATETIME,CONVERT(VARCHAR(4),DATEPART(YEAR,GETDATE()))+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(MONTH,GETDATE())),2)+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(DAY,GETDATE())),2)),
	rtAlteracaoCliFor.CodigoCliFor,
	0,
	4,
	'',
	0,
	'',
	0
	FROM rtAlteracaoCliFor (NOLOCK)
	INNER JOIN rtSPEDFiscal (NOLOCK) ON
		rtSPEDFiscal.CodigoCliFor = rtAlteracaoCliFor.CodigoCliFor AND
		rtSPEDFiscal.Spid = @@spid AND
		rtSPEDFiscal.TipoRegistro = '0150'
	WHERE 
	rtAlteracaoCliFor.CodigoEmpresa = @CodigoEmpresa AND
	rtAlteracaoCliFor.DataAlteracao BETWEEN @DataInicial AND @DataFinal AND
	rtAlteracaoCliFor.ComplementoEndCliFor IS NOT NULL
	
	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
		'|0175|'
	+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,rtAlteracaoCliFor.DataAlteracao)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,rtAlteracaoCliFor.DataAlteracao)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,rtAlteracaoCliFor.DataAlteracao)) + '|'
	+	'13' + '|' -- BAIRRO
	+	RTRIM(LTRIM(rtAlteracaoCliFor.BairroCliFor)) + '|',
	'0175',
	'E',
	0,
	CONVERT(DATETIME,CONVERT(VARCHAR(4),DATEPART(YEAR,GETDATE()))+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(MONTH,GETDATE())),2)+'-'+
	RIGHT(CONVERT(VARCHAR(3),100+DATEPART(DAY,GETDATE())),2)),
	rtAlteracaoCliFor.CodigoCliFor,
	0,
	4,
	'',
	0,
	'',
	0
	FROM rtAlteracaoCliFor (NOLOCK)
	INNER JOIN rtSPEDFiscal (NOLOCK) ON
		rtSPEDFiscal.CodigoCliFor = rtAlteracaoCliFor.CodigoCliFor AND
		rtSPEDFiscal.Spid = @@spid AND
		rtSPEDFiscal.TipoRegistro = '0150'
	WHERE 
	rtAlteracaoCliFor.CodigoEmpresa = @CodigoEmpresa AND
	rtAlteracaoCliFor.DataAlteracao BETWEEN @DataInicial AND @DataFinal AND
	rtAlteracaoCliFor.BairroCliFor IS NOT NULL
END


INSERT rtSPEDFiscal
SELECT
@@spid,
'|0190|' +
RTRIM(LTRIM(CONVERT(VARCHAR(4),CodigoUnidadeProduto))) + '|' + 
RTRIM(LTRIM(DescricaoUnidadeProduto)) + '|',
'0190',
'E',
0,
getdate(),
0,
0,
5,
'',
0,
CodigoUnidadeProduto,
0
FROM tbUnidadeProduto
WHERE
EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK)
         WHERE
         rtSPEDFiscal.Spid = @@spid AND
         rtSPEDFiscal.CodigoUnidadeProduto = tbUnidadeProduto.CodigoUnidadeProduto )

INSERT rtSPEDFiscal
SELECT DISTINCT
@@spid,
'|0190|' +
'UN' + '|' +
'UNIDADE' + '|',
'0190',
'E',
0,
getdate(),
0,
0,
5,
'',
0,
'',
0
FROM rtSPEDFiscal
WHERE
rtSPEDFiscal.Spid = @@Spid AND
EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK)
         WHERE
         rtSPEDFiscal.Spid = @@spid AND
         rtSPEDFiscal.CodigoUnidadeProduto = 'UN' AND
         rtSPEDFiscal.TipoRegistro <> '0190' ) AND
NOT EXISTS ( 
             SELECT 1 FROM rtSPEDFiscal (NOLOCK)
			 WHERE
             rtSPEDFiscal.Spid = @@spid AND
             rtSPEDFiscal.CodigoUnidadeProduto = 'UN' AND
             rtSPEDFiscal.TipoRegistro = '0190'
           )

INSERT rtSPEDFiscal
SELECT
@@spid,
'|0190|HR|HORAS|',
'0190',
'E',
0,
getdate(),
0,
0,
5,
'',
0,
'',
0
WHERE
EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK)
         WHERE
         rtSPEDFiscal.Spid = @@spid AND
         rtSPEDFiscal.CodigoUnidadeProduto = 'HR' )

--- Produtos
INSERT rtSPEDFiscal
SELECT DISTINCT
@@spid,
	'|0200|'
+	RTRIM(LTRIM(tbProduto.CodigoProduto)) + '|'
+	RTRIM(LTRIM(dbo.fnRemoveSpecialCharacter(tbProduto.DescricaoProduto))) + '|'
+	COALESCE(RTRIM(LTRIM(tbProdutoFT.CodigoBarrasProduto)),'') + '|'
+	'|'
+	RTRIM(LTRIM(CodigoUnidadeProduto)) + '|'
+	CASE WHEN tbLinhaProduto.UsoConsumoLinhaProduto = 'V' THEN
		'07'
	ELSE
		'00'
	END + '|'
+	RTRIM(LTRIM(CONVERT(VARCHAR(8),tbProduto.CodigoClassificacaoFiscal))) + '|'
+	CASE WHEN LEN(RTRIM(LTRIM(tbProduto.CodigoClassificacaoFiscal))) > 8 THEN
		RIGHT(RTRIM(LTRIM(tbProduto.CodigoClassificacaoFiscal)),LEN(RTRIM(LTRIM(tbProduto.CodigoClassificacaoFiscal))) - 8)
	ELSE
		''
	END + '|' +
+	'|' + 
+	'|' +
+	REPLACE(CONVERT(VARCHAR(16),tbPercentual.ICMSSaidaUF),'.',',') + '|'
+   CASE WHEN CONVERT(NUMERIC,@Versao) >= 11 THEN COALESCE(tbProdutoFT.TributaCOFINSProduto,'') + '|' ELSE '' END,
'0200',
RTRIM(LTRIM(tbProduto.CodigoProduto)),
0,
@DataInicial,
0,
0,
6,
RTRIM(LTRIM(tbProduto.CodigoProduto)),
0,
'',
0
FROM tbProduto (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = tbProduto.CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal
INNER JOIN tbProdutoFT (NOLOCK) ON
           tbProdutoFT.CodigoEmpresa = tbProduto.CodigoEmpresa AND 
           tbProdutoFT.CodigoProduto = tbProduto.CodigoProduto 
INNER JOIN tbLinhaProduto (NOLOCK) ON
		   tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa AND
		   tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto
INNER JOIN tbPercentual (NOLOCK) ON
           tbPercentual.UFDestino = tbLocal.UFLocal AND
           tbPercentual.UFOrigem  = tbLocal.UFLocal
WHERE
tbProduto.CodigoEmpresa = @CodigoEmpresa AND
EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
         WHERE
         rtSPEDFiscal.Spid = @@spid AND
         rtSPEDFiscal.CodigoProduto = tbProduto.CodigoProduto )

--- veículos (Chrysler)
INSERT rtSPEDFiscal
SELECT DISTINCT
@@spid,
'|0200|' +
RTRIM(LTRIM(tbVeiculoCV.ModeloVeiculo)) + '|' +
RTRIM(LTRIM(tbModeloVeiculoCV.DescricaoModeloVeiculoCV)) + '|' +
'|' +
'|' +
'UN' + '|' +
'00|' +
COALESCE(CONVERT(VARCHAR(8),tbModeloVeiculoCV.CodigoClassificacaoFiscal),'') + '|' +
CASE WHEN LEN(RTRIM(LTRIM(tbModeloVeiculoCV.CodigoClassificacaoFiscal))) > 8 THEN
	RIGHT(RTRIM(LTRIM(tbModeloVeiculoCV.CodigoClassificacaoFiscal)),LEN(RTRIM(LTRIM(tbModeloVeiculoCV.CodigoClassificacaoFiscal))) - 8)
ELSE
	''
END + '|' +
'|' + 
'|' +
'12,00' + '|' +
CASE WHEN CONVERT(NUMERIC,@Versao) >= 11 THEN '|' ELSE '' END,
'0200',
RTRIM(LTRIM(tbVeiculoCV.ModeloVeiculo)),
0,
@DataInicial,
0,
0,
6,
RTRIM(LTRIM(tbVeiculoCV.ModeloVeiculo)),
0,
'',
0
FROM tbVeiculoCV 
INNER JOIN tbModeloVeiculoCV ON
           tbModeloVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
           tbModeloVeiculoCV.ModeloVeiculo = tbVeiculoCV.ModeloVeiculo
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal
INNER JOIN tbPercentual (NOLOCK) ON
           tbPercentual.UFDestino = tbLocal.UFLocal AND
           tbPercentual.UFOrigem  = tbLocal.UFLocal
WHERE 
tbVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
tbVeiculoCV.CodigoLocal = @CodigoLocal AND
EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
         WHERE 
         rtSPEDFiscal.Spid = @@spid AND
         rtSPEDFiscal.CodigoProduto = NumeroChassisCV AND
         rtSPEDFiscal.TipoRegistro = 'C170' ) AND
dbo.fnIndustria(@CodigoEmpresa) = 1

--- veículos (não Chrysler)
INSERT rtSPEDFiscal
SELECT DISTINCT
@@spid,
	'|0200|'
+	RTRIM(LTRIM(NumeroChassisCV)) + '|'
+	RTRIM(LTRIM(dbo.fnRemoveSpecialCharacter(tbModeloVeiculoCV.DescricaoModeloVeiculoCV))) + '|'
+	'|'
+	'|'
+	'UN' + '|'
+	'00' + '|'
+	COALESCE(CONVERT(VARCHAR(8),tbModeloVeiculoCV.CodigoClassificacaoFiscal),'') + '|'
+	CASE WHEN LEN(RTRIM(LTRIM(tbModeloVeiculoCV.CodigoClassificacaoFiscal))) > 8 THEN
		RIGHT(RTRIM(LTRIM(tbModeloVeiculoCV.CodigoClassificacaoFiscal)),LEN(RTRIM(LTRIM(tbModeloVeiculoCV.CodigoClassificacaoFiscal))) - 8)
	ELSE
		''
	END + '|'
+	'|'
+	'|'
+	CASE WHEN COALESCE(tbNaturezaOperacao.PercentualICMSNaturezaOperacao,0) <> 0 THEN
		REPLACE(CONVERT(VARCHAR(16),tbNaturezaOperacao.PercentualICMSNaturezaOperacao),'.',',') -- CNO Venda Grupo Veículo
	ELSE
		CASE WHEN tbLocal.UFLocal = 'SC' THEN
			'17,00'
		ELSE
			REPLACE(CONVERT(VARCHAR(16),tbPercentual.ICMSSaidaUF),'.',',')
		END
	END + '|' +  -- [12] ALIQ_ICMS
	CASE WHEN CONVERT(NUMERIC,@Versao) >= 11 THEN '|' ELSE '' END,
'0200',
RTRIM(LTRIM(NumeroChassisCV)),
0,
@DataInicial,
0,
0,
6,
RTRIM(LTRIM(NumeroChassisCV)),
0,
'',
0
FROM tbVeiculoCV 
INNER JOIN tbModeloVeiculoCV ON
           tbModeloVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
           tbModeloVeiculoCV.ModeloVeiculo = tbVeiculoCV.ModeloVeiculo

LEFT JOIN  tbGrupoVeiculoLocal (NOLOCK)
ON	tbGrupoVeiculoLocal.CodigoEmpresa = tbModeloVeiculoCV.CodigoEmpresa
AND	tbGrupoVeiculoLocal.CodigoLocal = tbVeiculoCV.CodigoLocal
AND	tbGrupoVeiculoLocal.CodigoGrupoVeiculo = tbModeloVeiculoCV.CodigoGrupoVeiculo

LEFT JOIN tbNaturezaOperacao (NOLOCK)
ON	tbNaturezaOperacao.CodigoEmpresa = tbGrupoVeiculoLocal.CodigoEmpresa
AND	tbNaturezaOperacao.CodigoNaturezaOperacao = tbGrupoVeiculoLocal.NatOperVendaNovos

INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal
INNER JOIN tbPercentual (NOLOCK) ON
           tbPercentual.UFDestino = tbLocal.UFLocal AND
           tbPercentual.UFOrigem  = tbLocal.UFLocal
WHERE 
tbVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
tbVeiculoCV.CodigoLocal = @CodigoLocal AND
EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
         WHERE 
         rtSPEDFiscal.Spid = @@spid AND
         rtSPEDFiscal.CodigoProduto = NumeroChassisCV ) AND
( dbo.fnIndustria(@CodigoEmpresa) = 0 OR 
  ( @GerarInventario = 'V' AND
    EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
           WHERE 
           rtSPEDFiscal.Spid = @@spid AND
           rtSPEDFiscal.CodigoProduto = NumeroChassisCV AND
           rtSPEDFiscal.Linha LIKE '%|H010|%')  
  )
)

--- Mão de Obra
INSERT rtSPEDFiscal
SELECT DISTINCT
@@spid,
	'|0200|'
+	RTRIM(LTRIM(tbMaoObraOS.CodigoMaoObraOS)) + '|'
+	RTRIM(LTRIM(tbMaoObraOS.DescricaoMaoObraOS)) + '|'
+	'|'
+	'|'
+	'HR' + '|'
+	'09|'
+	'|'
+	'|'
+	'|'
+	CASE WHEN CONVERT(NUMERIC,@Versao) <= 8 THEN
		RIGHT('0000'+CONVERT(VARCHAR,RTRIM(LTRIM(CodigoServicoFederal))),4)
	ELSE
		RIGHT('00000'+CONVERT(VARCHAR,CONVERT(MONEY,RTRIM(LTRIM(CodigoServicoFederal)))/100),5)
	END + '|'
+	'|' +
+ CASE WHEN CONVERT(NUMERIC,@Versao) >= 11 THEN '|' ELSE '' END, 
'0200',
RTRIM(LTRIM(tbMaoObraOS.CodigoMaoObraOS)),
0,
@DataInicial,
0,
0,
6,
RTRIM(LTRIM(tbMaoObraOS.CodigoMaoObraOS)),
0,
'',
0
FROM tbMaoObraOS (NOLOCK)
INNER JOIN tbTipoMaoObra (NOLOCK) ON
           tbTipoMaoObra.CodigoEmpresa = @CodigoEmpresa AND
           tbTipoMaoObra.CodigoTipoMaoObra = tbMaoObraOS.CodigoTipoMaoObra
WHERE
tbMaoObraOS.CodigoEmpresa = @CodigoEmpresa AND
EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
         WHERE
         rtSPEDFiscal.Spid = @@spid AND
         rtSPEDFiscal.CodigoProduto = tbMaoObraOS.CodigoMaoObraOS ) AND
NOT EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
			 WHERE
             rtSPEDFiscal.Spid = @@spid AND
			 rtSPEDFiscal.CodigoProduto = tbMaoObraOS.CodigoMaoObraOS AND
             rtSPEDFiscal.TipoRegistro = '0200' ) 

--- Produto Uso/Consumo e Itens sem cadastro
INSERT rtSPEDFiscal
SELECT DISTINCT
@@spid,
'|0200|' +
RTRIM(LTRIM(CodigoItemDocto)) + '|' +
RTRIM(LTRIM(COALESCE(tbProdutoUsoConsumo.Descricao,CodigoItemDocto))) + '|' +
'|' +
'|' +
COALESCE(tbProdutoUsoConsumo.Unidade,'UN') + '|' +
CASE WHEN tbProdutoUsoConsumo.TipoItem IS NULL THEN
	CASE WHEN RTRIM(LTRIM(CodigoItemDocto)) LIKE 'COMIS%' OR RTRIM(LTRIM(CodigoItemDocto)) LIKE 'CURSO%' THEN
		'09|'
	WHEN RTRIM(LTRIM(CodigoItemDocto)) LIKE 'SUCATA%' THEN
		'99|'
	ELSE
		'99|'
	END
ELSE
	tbProdutoUsoConsumo.TipoItem + '|' 
END
+	CASE WHEN COALESCE(CONVERT(VARCHAR,tbProdutoUsoConsumo.NCM),CONVERT(VARCHAR,tbItemDocumento.CodigoClassificacaoFiscal),'') = '0' THEN
		'00000000'
	ELSE
		LEFT(COALESCE(CONVERT(VARCHAR,tbProdutoUsoConsumo.NCM),CONVERT(VARCHAR,tbItemDocumento.CodigoClassificacaoFiscal),''),8)
	END + '|'
+	CASE WHEN tbProdutoUsoConsumo.CodigoEX IS NULL THEN
		CASE WHEN LEN(COALESCE(tbProdutoUsoConsumo.NCM,CONVERT(VARCHAR,tbItemDocumento.CodigoClassificacaoFiscal),'')) > 8 THEN
			RIGHT(RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR,tbItemDocumento.CodigoClassificacaoFiscal),''))),LEN(COALESCE(CONVERT(VARCHAR,tbItemDocumento.CodigoClassificacaoFiscal),'')) - 8)
		ELSE
			''
		END 
	ELSE
		RTRIM(LTRIM(tbProdutoUsoConsumo.CodigoEX)) 
	END + '|'
+	CASE WHEN tbProdutoUsoConsumo.CodigoGenero IS NOT NULL THEN
		RIGHT('00' + CONVERT(VARCHAR(2),tbProdutoUsoConsumo.CodigoGenero),2)
	ELSE
		''
	END + '|'
+	CASE WHEN tbProdutoUsoConsumo.CodigoServico IS NOT NULL AND tbProdutoUsoConsumo.CodigoServico <> 0 THEN
		CASE WHEN CONVERT(NUMERIC,@Versao) <= 8 THEN
			RIGHT('0000'+CONVERT(VARCHAR,RTRIM(LTRIM(tbProdutoUsoConsumo.CodigoServico))),4)
		ELSE
			RIGHT('00000'+CONVERT(VARCHAR,CONVERT(MONEY,RTRIM(LTRIM(tbProdutoUsoConsumo.CodigoServico)))/100),5)
		END
	ELSE
		''
	END + '|'
+	case when tbNaturezaOperacao.CodigoTipoOperacao in (10,12) then
		'' -- Itens de Serviço
	else
		REPLACE(CONVERT(VARCHAR(16),COALESCE(tbProdutoUsoConsumo.AliquotaICMS,tbPercentual.ICMSSaidaUF)),'.',',')
	end + '|'
+   CASE WHEN CONVERT(NUMERIC,@Versao) >= 11 THEN '|' ELSE '' END,
'0200',
RTRIM(LTRIM(CodigoItemDocto)),
0,
@DataInicial,
0,
0,
6,
RTRIM(LTRIM(CodigoItemDocto)),
0,
'',
0
FROM
tbItemDocumento (NOLOCK)
LEFT JOIN tbNaturezaOperacao (NOLOCK) ON
          tbNaturezaOperacao.CodigoEmpresa = @CodigoEmpresa AND
          tbNaturezaOperacao.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal
INNER JOIN tbPercentual (NOLOCK) ON
           tbPercentual.UFDestino = tbLocal.UFLocal AND
           tbPercentual.UFOrigem  = tbLocal.UFLocal
LEFT JOIN tbProdutoUsoConsumo (NOLOCK) ON
          tbProdutoUsoConsumo.CodigoEmpresa = @CodigoEmpresa AND
          tbProdutoUsoConsumo.Codigo = tbItemDocumento.CodigoItemDocto
WHERE 
tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbItemDocumento.CodigoLocal = @CodigoLocal AND
CodigoItemDocto IS NOT NULL AND
DataDocumento between @DataInicial AND @DataFinal AND
RTRIM(LTRIM(CodigoItemDocto)) <> '' AND
( TipoRegistroItemDocto IN ('MOB','OUT') OR TipoRegistroItemDocto IS NULL ) AND
EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
         WHERE
         rtSPEDFiscal.Spid = @@spid AND
         rtSPEDFiscal.CodigoProduto = CodigoItemDocto ) AND
NOT EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
			 WHERE
             rtSPEDFiscal.Spid = @@spid AND
			 rtSPEDFiscal.CodigoProduto = CodigoItemDocto AND
             rtSPEDFiscal.TipoRegistro = '0200' ) AND
( 
	( NumeroVeiculoCV IS null and dbo.fnIndustria(@CodigoEmpresa) = 1 ) OR
	dbo.fnIndustria(@CodigoEmpresa) = 0
)

--- Uso/Consumo sem item
INSERT rtSPEDFiscal
SELECT
@@spid,
'|0200|' +
'USOCONSUMO' + '|' +
'MATERIAL DE USO E CONSUMO' + '|' +
'|' +
'|' +
'UN' + '|' +
'07|' +
'|' +
'|' +
'|' + 
'|' + 
'|' + 
CASE WHEN CONVERT(NUMERIC,@Versao) >= 11 THEN '|' ELSE '' END, 
'0200',
'USOCONSUMO',
0,
@DataInicial,
0,
0,
6,
'',
0,
'',
0
WHERE
EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
         WHERE
         rtSPEDFiscal.Spid = @@spid AND
         rtSPEDFiscal.CodigoProduto = 'USOCONSUMO' )

--- Outros
INSERT rtSPEDFiscal
SELECT
@@spid,
'|0200|' +
'OUTRAS' + '|' +
'OUTRAS MERCADORIAS' + '|' +
'|' +
'|' +
'UN' + '|' +
'07|' +
'|' +
'|' +
'|' + 
'|' + 
'|' + 
CASE WHEN CONVERT(NUMERIC,@Versao) >= 11 THEN '|' ELSE '' END, 
'0200',
'OUTRAS',
0,
@DataInicial,
0,
0,
6,
'',
0,
'',
0
WHERE
EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
         WHERE
         rtSPEDFiscal.Spid = @@spid AND
         rtSPEDFiscal.CodigoProduto = 'OUTRAS' )


IF @GerarCIAP = 'V'
BEGIN
	
	--- Item Patrimonial
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|0200|'
	+	CONVERT(VARCHAR(14),RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4)) + '|'
	+	RTRIM(LTRIM(tbItemPatrimonial.DescricaoItemPatrimonial)) + '|'
	+	COALESCE(RTRIM(LTRIM(tbItemPatrimonial.EANItemPatrimonial)),'') + '|'
	+	'|'
	+	'UN' + '|'
	+	'08' + '|'
	+	LEFT(RTRIM(LTRIM(COALESCE(tbItemPatrimonial.CodigoClassificacaoFiscal,''))),8) + '|' +
	+	CASE WHEN LEN(RTRIM(LTRIM(COALESCE(tbItemPatrimonial.CodigoClassificacaoFiscal,'')))) > 8 THEN
			RIGHT(RTRIM(LTRIM(COALESCE(tbItemPatrimonial.CodigoClassificacaoFiscal,''))),LEN(RTRIM(LTRIM(COALESCE(tbItemPatrimonial.CodigoClassificacaoFiscal,'')))) - 8)
		ELSE
			''
		END + '|'
	+	'|'
	+	'|'
	+	REPLACE(CONVERT(VARCHAR(16),tbPercentual.ICMSSaidaUF),'.',',') + '|'
	+   CASE WHEN CONVERT(NUMERIC,@Versao) >= 11 THEN '|' ELSE '' END,
	'0200',
	CONVERT(VARCHAR(14),RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4)),
	0,
	@DataInicial,
	0,
	0,
	6,
	CONVERT(VARCHAR(14),RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4)),
	0,
	'',
	0
	FROM tbItemPatrimonial (NOLOCK)
	INNER JOIN tbLocal (NOLOCK) ON
			   tbLocal.CodigoEmpresa = @CodigoEmpresa AND
			   tbLocal.CodigoLocal = @CodigoLocal
	INNER JOIN tbPercentual (NOLOCK) ON
			   tbPercentual.UFDestino = tbLocal.UFLocal AND
			   tbPercentual.UFOrigem  = tbLocal.UFLocal
	WHERE
	tbItemPatrimonial.CodigoEmpresa = @CodigoEmpresa AND
	tbItemPatrimonial.CodigoLocal = @CodigoLocal AND
	EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
			 WHERE
			 rtSPEDFiscal.TipoRegistro = 'G140' AND
			 rtSPEDFiscal.Spid = @@spid AND
			 rtSPEDFiscal.CodigoCliFor = CONVERT(NUMERIC(14),RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4))) AND
	NOT EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
			 WHERE
             rtSPEDFiscal.Spid = @@spid AND
			 rtSPEDFiscal.CodigoProduto = CONVERT(VARCHAR(14),CONVERT(NUMERIC(14),RIGHT('00000000' + CONVERT(VARCHAR(8),CodigoItemPatrimonial),8) + RIGHT('0000' + CONVERT(VARCHAR(4),SequenciaItemPatrimonial),4))) AND
             rtSPEDFiscal.TipoRegistro = '0200' ) 


END


IF EXISTS ( SELECT 1 FROM sysobjects WHERE name = 'rtAlteracaoProduto' )
BEGIN
	INSERT rtSPEDFiscal
	SELECT
		@@spid,
		'|0205|'
	+	RTRIM(LTRIM(rtAlteracaoProduto.DescricaoProduto)) + '|'
	+	CASE WHEN COALESCE(rtAlteracaoProduto.DataAlteracaoAnterior,tbProdutoFT.DataCadastroProduto) < '2000-01-01' THEN
			'01012000' -- Menor data aceita pelo SPED
		ELSE
			SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,COALESCE(rtAlteracaoProduto.DataAlteracaoAnterior,tbProdutoFT.DataCadastroProduto))),2,2) +
			SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,COALESCE(rtAlteracaoProduto.DataAlteracaoAnterior,tbProdutoFT.DataCadastroProduto))),2,2) +
			CONVERT(CHAR(4),DATEPART(year,COALESCE(rtAlteracaoProduto.DataAlteracaoAnterior,tbProdutoFT.DataCadastroProduto)))
		END + '|'
	+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,DATEADD(DAY,CASE WHEN tbProdutoFT.DataCadastroProduto = rtAlteracaoProduto.DataAlteracao THEN 0 ELSE -1 END,rtAlteracaoProduto.DataAlteracao))),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,DATEADD(DAY,CASE WHEN tbProdutoFT.DataCadastroProduto = rtAlteracaoProduto.DataAlteracao THEN 0 ELSE -1 END,rtAlteracaoProduto.DataAlteracao))),2,2) +
		CONVERT(CHAR(4),DATEPART(year,DATEADD(DAY,CASE WHEN tbProdutoFT.DataCadastroProduto = rtAlteracaoProduto.DataAlteracao THEN 0 ELSE -1 END,rtAlteracaoProduto.DataAlteracao))) + '|'
	+	'|', -- Código do Produto, não tratado pois o sistema não permite alteração neste campo
	'0205',
	RTRIM(LTRIM(rtAlteracaoProduto.CodigoProduto)),
	0,
	@DataInicial,
	0,
	0,
	6,
	RTRIM(LTRIM(rtAlteracaoProduto.CodigoProduto)),
	0,
	'',
	0
	FROM rtAlteracaoProduto (NOLOCK)
	INNER JOIN tbProdutoFT (NOLOCK) ON
		tbProdutoFT.CodigoEmpresa = rtAlteracaoProduto.CodigoEmpresa AND
		tbProdutoFT.CodigoProduto = rtAlteracaoProduto.CodigoProduto
	WHERE
	rtAlteracaoProduto.CodigoEmpresa = @CodigoEmpresa AND
	EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
			 WHERE
			 rtSPEDFiscal.Spid = @@spid AND
			 rtSPEDFiscal.CodigoProduto = rtAlteracaoProduto.CodigoProduto ) AND
	(
		rtAlteracaoProduto.DataAlteracao BETWEEN @DataInicial AND @DataFinal OR
		(
			rtAlteracaoProduto.DataAlteracao < @DataInicial AND
			NOT EXISTS	(
							SELECT 1 FROM tbItemDocumento
							INNER JOIN rtAlteracaoProduto (NOLOCK) ON
								tbItemDocumento.CodigoEmpresa	= rtAlteracaoProduto.CodigoEmpresa AND
								tbItemDocumento.CodigoLocal		= @CodigoLocal AND
								tbItemDocumento.CodigoProduto	= rtAlteracaoProduto.CodigoProduto
							WHERE tbItemDocumento.DataDocumento	BETWEEN rtAlteracaoProduto.DataAlteracao AND DATEADD(dd, -1, @DataInicial)
						)
		)
	)
END


INSERT rtSPEDFiscal
SELECT
@@spid,
'|0400|' +
CONVERT(VARCHAR(6),tbNaturezaOperacao.CodigoNaturezaOperacao) + '|' +
RTRIM(LTRIM(tbNaturezaOperacao.DescricaoNaturezaOperacao)) + '|',
'0400',
'E',
0,
getdate(),
0,
0,
8,
'',
0,
'',
0
FROM tbNaturezaOperacao
WHERE
CodigoEmpresa = @CodigoEmpresa AND
EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK)
		 WHERE
         rtSPEDFiscal.Spid = @@spid AND
		 rtSPEDFiscal.CodigoNaturezaOperacao = tbNaturezaOperacao.CodigoNaturezaOperacao )

---- Final 

----


INSERT rtSPEDFiscal
SELECT
@@spid,
'|9001|0|',
'Z001',
'E',
999999,
getdate(),
0,
0,
80,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|0000|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
90,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|0001|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
100,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|0005|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
110,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|0015|' + 
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and Linha LIKE '|0015|%' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
111,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|0100|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
120,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|0150|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = '0150' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
130,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|0175|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = '0175' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
130,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|0190|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = '0190' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
140,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|0200|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = '0200' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
150,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|0205|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = '0205' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
130,
'',
0,
'',
0

IF @GerarCIAP = 'V' 
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|0300|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = '0300' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	152,
	'',
	0,
	'',
	0

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|0305|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = '0305' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	153,
	'',
	0,
	'',
	0
END

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|0400|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = '0400' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
160,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|0450|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = '0450' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
161,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|0460|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = '0460' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
162,
'',
0,
'',
0

IF @ContaEntrada <> '' AND 
   (
    ( EXISTS ( SELECT 1 FROM rtSPEDFiscal 
	 		   WHERE
			   Spid = @@spid AND 
			   TipoRegistro = 'C170' AND
			   EntradaSaida = 'E' )) OR
    ( EXISTS ( SELECT 1 FROM rtSPEDFiscal 
	 		   WHERE
			   Spid = @@spid AND 
			   TipoRegistro = 'D100' AND
			   EntradaSaida = 'E' )) OR
    ( EXISTS ( SELECT 1 FROM rtSPEDFiscal 
	 		   WHERE
			   Spid = @@spid AND 
			   TipoRegistro = 'D500' AND
			   EntradaSaida = 'E' ))
   )
BEGIN
	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|0500|' +
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|' +
	CASE 
		WHEN tbPlanoContas.GrupoPlanoConta = 'A' THEN
			'01'
		WHEN tbPlanoContas.GrupoPlanoConta = 'P' THEN
			'02'
		WHEN tbPlanoContas.GrupoPlanoConta = 'R' THEN
			'04'
		ELSE
			'09'
	END + '|' +
	'A' + '|' +
	'5' + '|' +
	RTRIM(LTRIM(@ContaEntrada)) + '|' +
	RTRIM(LTRIM(tbPlanoContas.DescricaoContaContabil)) + '|',
	'0500',
	'E',
	0,
	getdate(),
	0,
	0,
	7,
	'',
	0,
	'',
	0
	FROM tbPlanoContas
	WHERE
	tbPlanoContas.CodigoEmpresa = @CodigoEmpresa AND
	tbPlanoContas.CodigoContaContabil = @ContaEntrada 
END

IF @ContaSaida <> '' AND
EXISTS ( SELECT 1 FROM rtSPEDFiscal 
	 		   WHERE
			   Spid = @@spid AND 
			   TipoRegistro = 'C170' AND
			   EntradaSaida = 'S' ) AND
NOT EXISTS ( SELECT 1 FROM rtSPEDFiscal 
	 		   WHERE
			   Spid = @@spid AND 
			   TipoRegistro = '0500' AND
			   Linha like '%' + @ContaSaida + '%' )
BEGIN
	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|0500|' +
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|' +
	CASE 
		WHEN tbPlanoContas.GrupoPlanoConta = 'A' THEN
			'01'
		WHEN tbPlanoContas.GrupoPlanoConta = 'P' THEN
			'02'
		WHEN tbPlanoContas.GrupoPlanoConta = 'R' THEN
			'04'
		ELSE
			'09'
	END + '|' +
	'A' + '|' +
	'5' + '|' +
	RTRIM(LTRIM(@ContaSaida)) + '|' +
	RTRIM(LTRIM(tbPlanoContas.DescricaoContaContabil)) + '|',
	'0500',
	'E',
	0,
	getdate(),
	0,
	0,
	7,
	'',
	0,
	'',
	0
	FROM tbPlanoContas
	WHERE
	tbPlanoContas.CodigoEmpresa = @CodigoEmpresa AND
	tbPlanoContas.CodigoContaContabil = @ContaSaida
END

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|0500|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = '0500' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
162,
'',
0,
'',
0

IF @GerarCIAP = 'V' 
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|0600|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = '0600' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	163,
	'',
	0,
	'',
	0
END

INSERT rtSPEDFiscal
SELECT
@@spid,
'|0990|' +
CONVERT(VARCHAR(8),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro like '0%' ) + 1) + '|',
'0990',
'E',
0,
getdate(),
0,
0,
9,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|0990|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
170,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C001|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
180,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C100|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C100' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
188,
'',
0,
'',
0

IF CONVERT(NUMERIC(4),@Versao) >= 10
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|C101|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C101' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	188,
	'',
	0,
	'',
	0
END

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C110|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C110' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
190,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C113|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C113' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
190,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C114|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C114' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
191,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C130|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C130' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
191,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C140|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C140' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
192,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C141|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C141' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
193,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C170|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C170' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
194,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C175|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C175' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
195,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C176|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C176' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
196,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C190|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C190' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
197,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C195|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C195' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
198,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C197|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C197' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
199,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C400|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C400' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
200,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C405|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C405' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
201,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C410|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid AND TipoRegistro = 'C410' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
202,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C420|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C420' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
203,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C425|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C425' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
204,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C460|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C460' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
204,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C470|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C470' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
204,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C490|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C490' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
205,
'',
0,
'',
0

IF EXISTS (SELECT 1 FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C495')
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|C495|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C495' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	205,
	'',
	0,
	'',
	0
END

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C500|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C500' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
206,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C590|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'C590' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
207,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|C990|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
210,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|D001|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
220,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|D100|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'D100' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
230,
'',
0,
'',
0

IF CONVERT(NUMERIC(4),@Versao) >= 10
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|D101|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'D101' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	188,
	'',
	0,
	'',
	0
END

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|D190|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'D190' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
231,
'',
0,
'',
0

IF (SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'D195') > 0
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|D195|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'D195' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	231,
	'',
	0,
	'',
	0
END

IF (SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'D197') > 0
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|D197|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'D197' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	231,
	'',
	0,
	'',
	0
END

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|D500|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'D500' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
232,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|D590|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'D590' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
233,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|D990|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
240,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|E001|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
250,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|E100|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'E100' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
260,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|E110|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'E110' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
270,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|E111|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'E111' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
271,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|E116|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'E116' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
272,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|E200|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'E200' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
273,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|E210|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'E210' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
274,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|E220|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'E220' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
275,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|E250|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'E250' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
276,
'',
0,
'',
0

IF CONVERT(NUMERIC(4),@Versao) >= 10
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|E300|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'E300' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	276,
	'',
	0,
	'',
	0

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|E310|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'E310' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	276,
	'',
	0,
	'',
	0

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|E311|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'E311' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	276,
	'',
	0,
	'',
	0

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|E316|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'E316' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	276,
	'',
	0,
	'',
	0
END

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|E500|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'E500' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
277,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|E510|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'E510' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
278,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|E520|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'E520' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
279,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|E530|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'E530' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
280,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|E990|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
281,
'',
0,
'',
0

IF CONVERT(numeric(4),@Versao) > 3
BEGIN

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|G001|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'G001' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	282,
	'',
	0,
	'',
	0
END

IF @GerarCIAP = 'V' 
BEGIN

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|G110|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'G110' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	283,
	'',
	0,
	'',
	0

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|G125|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'G125' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	284,
	'',
	0,
	'',
	0

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|G130|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'G130' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	285,
	'',
	0,
	'',
	0

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|G140|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'G140' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	286,
	'',
	0,
	'',
	0

END

IF CONVERT(numeric(4),@Versao) > 3
BEGIN

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|G990|' +
	CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'G990' )) + '|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	287,
	'',
	0,
	'',
	0
END

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|H001|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
290,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|H005|' + CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'H005' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
300,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|H010|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'H010' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
310,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|H990|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
319,
'',
0,
'',
0


IF CONVERT(NUMERIC(4),@Versao) >= 10
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|K001|1|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	319,
	'',
	0,
	'',
	0
	
	IF @EquiparadoIndustria = 'V'
	BEGIN
		INSERT rtSPEDFiscal
		SELECT
		@@spid,
		'|9900|K100|' +
		CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'K100' )) + '|',
		'Z001',
		'E',
		999999,
		getdate(),
		0,
		0,
		319,
		'',
		0,
		'',
		0

		INSERT rtSPEDFiscal
		SELECT
		@@spid,
		'|9900|K200|' +
		CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = 'K200' )) + '|',
		'Z001',
		'E',
		999999,
		getdate(),
		0,
		0,
		319,
		'',
		0,
		'',
		0	
	END

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|K990|1|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	319,
	'',
	0,
	'',
	0
END

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|1001|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
320,
'',
0,
'',
0

IF @Versao >= 6 
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|9900|1010|1|',
	'Z001',
	'E',
	999999,
	getdate(),
	0,
	0,
	320,
	'',
	0,
	'',
	0
END

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|1600|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and Linha LIKE '|1600|%' )) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
321,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|1990|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
322,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|9001|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
323,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|9990|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
324,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|9999|1|',
'Z001',
'E',
999999,
getdate(),
0,
0,
325,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9900|9900|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and Linha LIKE '|9900|%' ) + 1) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
326,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9990|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro LIKE 'Z%' ) + 2) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
330,
'',
0,
'',
0

INSERT rtSPEDFiscal
SELECT
@@spid,
'|9999|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid ) + 1) + '|',
'Z001',
'E',
999999,
getdate(),
0,
0,
340,
'',
0,
'',
0

----
SELECT Linha
FROM rtSPEDFiscal
WHERE
Spid = @@spid
ORDER BY 
LEFT(TipoRegistro,2),
Ordem,
EntradaSaida,
DataDocumento,
NumeroDocumento,
CodigoCliFor,
TipoLancamentoMovimentacao,
LEFT(TipoRegistro,3),
CodigoClienteEventual,
TipoRegistro,
Linha

SET NOCOUNT OFF
SET ANSI_WARNINGS ON

GO
GRANT EXECUTE ON whSPEDFiscal TO SQLUsers
GO
