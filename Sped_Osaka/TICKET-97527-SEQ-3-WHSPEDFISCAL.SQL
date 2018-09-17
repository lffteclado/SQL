IF EXISTS ( SELECT 1 FROM sysobjects WHERE name = 'rtE110' ) DROP TABLE dbo.rtE110
GO
CREATE TABLE dbo.rtE110
(
NumeroDocumento numeric(12),
DataDocumento datetime,
Valor money
)
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
Linha varchar(500), 
TipoRegistro char(4),
EntradaSaida char(30),
NumeroDocumento numeric(12), 
DataDocumento datetime, 
CodigoCliFor numeric(14), 
TipoLancamentoMovimentacao numeric(3),
Ordem numeric(3),
CodigoProduto varchar(30),
CodigoNaturezaOperacao numeric(6),
CodigoUnidadeProduto char(2),
CodigoClienteEventual numeric(14)
)
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
whSPEDFiscal 1608,0,'201201',0,'V','V','V','FRETE','B','DIF','V',null,null,'V','2010-12-31'
select * from tbItemDocumento where TipoLancamentoMovimentacao = 9 and ValorDifAliquotaICMSItemDocto <> 0
select * from tbSPEDFiscalCIAP
where CodigoEmpresa = 1608 and TipoImposto = 3
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa 	numeric(4)	,
@CodigoLocal	numeric(4) 	, 
@Periodo        varchar(6)  ,
@Finalidade		numeric(1)  = 0,
@IncluirVeiculos char(1) = 'V',
@IncluirVeicCons char(1) = 'V',
@IncluirPecasUsadas char(1) = 'V',
@AjusteICMSCTRCST char(10) = '',
@Perfil char(1) = 'B',
@AjusteICMSDIFALQ char(10) = '',
@IncluirEstoqueTerceiros char(1) = 'V',
@PeriodoInicialPAFECF datetime = null,
@PeriodoFinalPAFECF datetime = null ,
@GerarInventario char(1) = 'V',
@DataGeracaoInventario datetime = null

AS 

SET NOCOUNT ON
SET ANSI_WARNINGS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @DataInicial      datetime
DECLARE @DataFinal        datetime
DECLARE @DataInventario   char(10)
DECLARE @ValorICMSST	  money
DECLARE @UFLocal		  char(2)
DECLARE @Versao			  char(3)
DECLARE @GerarCIAP		  char(1)
DECLARE @PeriodoInventario char(6)

IF @DataGeracaoInventario IS NULL SELECT @DataGeracaoInventario = @DataFinal

SELECT @UFLocal = UFLocal
FROM tbLocal
WHERE
CodigoEmpresa = @CodigoEmpresa AND
CodigoLocal = @CodigoLocal 

SELECT @DataInicial = isnull(@PeriodoInicialPAFECF,convert(datetime, substring(@Periodo,1,4) + substring(@Periodo,5,2) + '01'))
SELECT @DataFinal = isnull(@PeriodoFinalPAFECF,dateadd(day,-1,dateadd(month,+1,convert(datetime, substring(@Periodo,1,4) + substring(@Periodo,5,2) + '01'))))
SELECT @DataInventario = convert(char(10),@DataGeracaoInventario,20)
SELECT @PeriodoInventario = CONVERT(VARCHAR(4),DATEPART(YEAR,@DataGeracaoInventario)) + RIGHT(CONVERT(VARCHAR(3),100 + DATEPART(MONTH,@DataGeracaoInventario)),2)

SELECT @Versao = '002'
IF @DataInicial >= '2010-01-01' SELECT @Versao = '003'
IF @DataInicial >= '2011-01-01' SELECT @Versao = '004'
IF @DataInicial >= '2012-01-01' SELECT @Versao = '005'

SELECT @GerarCIAP = 'F'
IF EXISTS ( SELECT 1 FROM tbSPEDFiscalCIAP (NOLOCK)
            WHERE tbSPEDFiscalCIAP.CodigoEmpresa = @CodigoEmpresa AND
                  tbSPEDFiscalCIAP.CodigoLocal = @CodigoLocal AND
                  tbSPEDFiscalCIAP.Periodo = @Periodo ) SELECT @GerarCIAP = 'V'
 
--- Inventario

DELETE rtRegistroInventario
WHERE Spid = @@spid

SELECT * INTO #TMP FROM rtRegistroInventario
WHERE 1 = 2

IF @GerarInventario = 'V'
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
CONVERT(VARCHAR(15),REPLACE(REPLACE(REPLACE(tbLocal.InscricaoEstadualLocal,'-',''),'/',''),'.','')) + '|' +
COALESCE(CONVERT(VARCHAR(8),COALESCE(CONVERT(VARCHAR(8),tbCEP.NumeroMunicipio),CONVERT(VARCHAR(8),tbMunicipio.NumeroMunicipio))),'') + '|' +
COALESCE(CONVERT(VARCHAR(14),REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.','')),'') + '|' +
'' + '|' +
@Perfil + '|1|',
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
'|0100|' +
RTRIM(LTRIM(COALESCE(tbEmpresa.NomeContadorEmpresa,''))) + '|' +
REPLACE(REPLACE(COALESCE(tbEmpresa.CPFContadorEmpresa,'0'),'.',''),'-','') + '|' +
REPLACE(REPLACE(COALESCE(tbEmpresa.CRCContadorEmpresa,'0'),'.',''),'-','') + '|' +
'|' + 
COALESCE(CEPLocal,'0') + '|' +
RTRIM(LTRIM(COALESCE(tbLocal.RuaLocal,''))) + '|' +
RTRIM(LTRIM(CONVERT(CHAR(10),COALESCE(NumeroEndLocal,'0')))) + '|' +
RTRIM(LTRIM(COALESCE(ComplementoEndLocal,''))) + '|' +
RTRIM(LTRIM(RTRIM(LTRIM(COALESCE(BairroLocal,''))))) + '|' + 
RTRIM(LTRIM(RIGHT(RTRIM(CONVERT(VARCHAR(4),DDDLocal)) + RTRIM(COALESCE(TelefoneLocal,'0')),10))) + '|' +
RTRIM(LTRIM(RIGHT(RTRIM(CONVERT(VARCHAR(4),DDDFaxLocal)) + RTRIM(COALESCE(FaxLocal,'0')),10))) + '|' +
RTRIM(LTRIM(CONVERT(VARCHAR(255),COALESCE(EmailLocal,'')))) + '|' + 
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

---

/*
INSERT rtSPEDFiscal
SELECT
'0450|' +
RTRIM(LTRIM(CodigoTexto)) + '|' +
RTRIM(LTRIM(ConteudoTexto)) ,
'0450',
'E',
0,
getdate(),
0,
0,
8
FROM tbTexto
WHERE
CodigoEmpresa = @CodigoEmpresa AND
CodigoSistema = 'TG'
*/

--- BLOCO C

INSERT rtSPEDFiscal
SELECT
@@spid,
'|C100|' + 
CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' THEN
	'0'
ELSE
	'1'
END + '|' +
CASE WHEN ( 
            ( tbDocumentoNFe.ChaveAcessoNFe IS NOT NULL OR tbDocumento.CondicaoNFCancelada = 'V' ) AND
            tbDocumento.TipoLancamentoMovimentacao not in (1,9,10) AND
			( ( tbDocumento.TipoLancamentoMovimentacao = 7 and tbDocumentoFT.TipoTratamentoNFDigitadaDocFT <> 'N' ) OR
              tbDocumento.TipoLancamentoMovimentacao <> 7 )
          ) OR  --- Emissao Própria ?
          tbDocumento.CondicaoComplementoICMSDocto = 'V' OR
          ( tbDocumento.TipoLancamentoMovimentacao = 7 AND tbNaturezaOperacao.CodigoTipoOperacao in (10,12) ) OR
          ( tbDocumento.TipoLancamentoMovimentacao in (7,10) AND tbDocumento.CondicaoNFCancelada = 'V' and tbDocumentoFT.TipoTratamentoNFDigitadaDocFT <> 'N' ) THEN
	'0'
ELSE
	'1'
END + '|' + 
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
	ELSE
		CONVERT(VARCHAR(14),COALESCE(tbDocumentoFT.CodigoClienteEventual,tbDocumento.CodigoCliFor)) + '|'
END + 
RIGHT(CONVERT(VARCHAR(3),100 + tbDocumento.CodigoModeloNotaFiscal),2) + '|' +
CASE 
	WHEN tbDocumento.CondicaoComplementoICMSDocto = 'V' THEN
		'06'
	WHEN ( tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 ) AND ( tbDocumentoNFe.ChaveAcessoNFe IS NOT NULL OR tbDocumento.CodigoModeloNotaFiscal <> 55 ) THEN
		'02'
	WHEN tbDocumento.CodigoModeloNotaFiscal = 55 AND ( tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 ) AND tbDocumentoNFe.ChaveAcessoNFe IS NULL THEN
		'05' --- INUTILIZAÇÃO
	ELSE
		'00'
END + '|' +
RTRIM(LTRIM(CONVERT(VARCHAR(3),COALESCE(tbDocumento.SerieDocumento,'')))) + '|' +
CONVERT(VARCHAR(9),tbDocumento.NumeroDocumento) + '|' +
RTRIM(LTRIM(COALESCE(tbDocumentoNFe.ChaveAcessoNFe,''))) + '|' +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDocumento.DataEmissaoDocumento)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDocumento.DataEmissaoDocumento)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,tbDocumento.DataEmissaoDocumento)),'') + '|' 
END +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDocumento.DataDocumento)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDocumento.DataDocumento)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,tbDocumento.DataDocumento)) + '|' 
END +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorContabilDocumento),'.',',') + '|' 
END +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
	CASE WHEN ( SELECT COUNT(*) FROM tbDoctoRecPag 
	  WHERE
	  tbDoctoRecPag.CodigoEmpresa = @CodigoEmpresa AND
	  tbDoctoRecPag.CodigoLocal = @CodigoLocal AND
	  tbDoctoRecPag.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
	  tbDoctoRecPag.DataDocumento = tbDocumento.DataDocumento AND
	  tbDoctoRecPag.CodigoCliFor = tbDocumento.CodigoCliFor AND
	  tbDoctoRecPag.NumeroDocumento = tbDocumento.NumeroDocumento AND
	  tbDoctoRecPag.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao ) = 0 THEN '0' ELSE '1' END + '|' 
END +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),0.00),'.',',') + '|'
END +
CASE WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
	''
ELSE
	'0,00'
END + '|' + 
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorContabilDocumento),'.',',') + '|'
END +
CASE WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
	''
ELSE
	CASE WHEN tbDocumentoFT.TipoFreteDocFT IS NOT NULL THEN
		CONVERT(CHAR(1),tbDocumentoFT.TipoFreteDocFT)
	ELSE
		'9'
	END 
END + '|' +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		COALESCE(REPLACE(CONVERT(VARCHAR(16),tbDocumentoFT.ValorFreteDocFT),'.',','),'0,00') + '|'
END +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		COALESCE(REPLACE(CONVERT(VARCHAR(16),tbDocumentoFT.ValorSeguroDocFT),'.',','),'0,00') + '|'
END +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorDespAcesDocumento),'.',',') + '|'
END +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		CASE WHEN 'ZZ' = 'PE' AND --- desativado
                  tbDocumento.EntradaSaidaDocumento = 'S' AND 
                  tbCliFor.UFCliFor <> tbLocal.UFLocal THEN
			'0,00|'
		ELSE
			REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorBaseICMS1Documento),'.',',') + '|'
		END
END +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		CASE WHEN 'ZZ' = 'PE' AND --- desativado
                  tbDocumento.EntradaSaidaDocumento = 'S' AND 
                  tbCliFor.UFCliFor <> tbLocal.UFLocal THEN
			'0,00|'
		ELSE
			REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorICMSDocumento),'.',',') + '|'
		END
END +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' THEN
			REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorBaseICMSSubstTribDocto),'.',',') + '|'
		ELSE
			'0,00' + '|'
		END
END +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' THEN
			REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorICMSSubstTribDocto + tbDocumento.ValorDifAliquotaICMSDocto),'.',',') + '|'
		ELSE
			'0,00' + '|'
		END
END +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorIPIDocumento),'.',',') + '|'
END +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorPISDocumento),'.',',') + '|'
END +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorFinsocialDocumento),'.',',') + '|'
END +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		'' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),COALESCE(tbDocumento.ValorPISSTDocumento,0)),'.',',') + '|'
END +
CASE 
	WHEN tbDocumento.CondicaoNFCancelada = 'V' OR tbDocumento.TipoLancamentoMovimentacao = 11 THEN
		''
    ELSE
		REPLACE(CONVERT(VARCHAR(16),COALESCE(tbDocumento.ValorCofinsSTDocumento,0)),'.',',')
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
	AND tbDocumento.CodigoModeloNotaFiscal IN (1,4,55) 
	AND tbDocumento.EspecieDocumento	<> 'ECF'
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
			( tbDocumento.ValorBaseISSDocumento <> 0 AND tbLocalLF.ImprimeServicoRegSaida = 'V' ) OR
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
			( tbDocumento.TipoLancamentoMovimentacao = 9 AND tbDocumento.Recapagem <> 'V' ) OR 
            tbDocumento.TipoLancamentoMovimentacao <> 9
	    )

IF EXISTS ( SELECT 1 FROM rtSPEDFiscal WHERE TipoRegistro = 'C100' ) 
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

INSERT rtSPEDFiscal
SELECT
@@spid,
'|C130|' + 
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
		REPLACE(CONVERT(VARCHAR(16),tbDocumentoFT.BaseIRRFDocFT),'.',',') + '|' 
END +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbDocumentoFT.ValorIRRFDocFT),'.',',') + '|' 
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
	AND tbDocumento.EspecieDocumento	<> 'ECF'
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
			( tbDocumento.ValorBaseISSDocumento <> 0 AND tbLocalLF.ImprimeServicoRegSaida = 'V' ) OR
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
	AND tbDocumento.EspecieDocumento	<> 'ECF'
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
			( tbDocumento.ValorBaseISSDocumento <> 0 AND tbLocalLF.ImprimeServicoRegSaida = 'V' ) OR
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
'|C141|' + 
CONVERT(VARCHAR(2),CASE WHEN SequenciaDoctoRecPag = 0 THEN 1 ELSE SequenciaDoctoRecPag END) + '|' + 
COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDoctoRecPag.DataVenctoUtilDoctoRecPag)),2,2) +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDoctoRecPag.DataVenctoUtilDoctoRecPag)),2,2) +
CONVERT(CHAR(4),DATEPART(year,tbDoctoRecPag.DataVenctoUtilDoctoRecPag)),'') + '|' +
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
	AND tbDocumento.EspecieDocumento	<> 'ECF'
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
			( tbDocumento.ValorBaseISSDocumento <> 0 AND tbLocalLF.ImprimeServicoRegSaida = 'V' ) OR
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
'|C170|' + 
CONVERT(VARCHAR(4),'XSEQ') + '|' +   ---- alimentado no VB
RTRIM(LTRIM(CONVERT(VARCHAR(30),
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
		'USOCONSUMO'
END))) + '|' +
'' + '|' +
CASE WHEN tbItemDocumento.TipoLancamentoMovimentacao = 9 OR tbItemDocumento.QtdeLancamentoItemDocto = 0 THEN
	'1,000' + '|' 
ELSE
	REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),tbItemDocumento.QtdeLancamentoItemDocto)),'.',',') + '|'
END +
RTRIM(LTRIM(CASE 	
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
END)) + '|' +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		CASE WHEN tbItemDocumento.TipoLancamentoMovimentacao <> 9 THEN
			REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorContabilItemDocto),'.',',') + '|'
		ELSE
			REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorContabilItemDocto),'.',',') + '|'
		END
END +
REPLACE(CONVERT(VARCHAR(16),0.00),'.',',') + '|' +
'0' + '|' +
CASE WHEN tbItemDocumento.TipoLancamentoMovimentacao = 9 OR tbItemDocumento.NumeroVeiculoCV IS NOT NULL OR ( tbItemDocumento.TipoLancamentoMovimentacao in (10,12) AND tbNaturezaOperacao.CodigoNaturezaOperacao IS NOT NULL ) THEN
	RIGHT('000' + COALESCE(COALESCE(CNOItem.CodigoTributacaoNaturezaOper,tbNaturezaOperacao.CodigoTributacaoNaturezaOper),'000'),3) + '|'
ELSE
	CASE WHEN tbItemDocumento.CodigoCFO in (1924,2924,5924,6924,1910,2910,1949,2949,5949,6949,1915,5915,2915,6915,1916,5916,2916,6916) THEN
		'090' + '|'
	ELSE
		RIGHT(('000' + RTRIM(LTRIM(COALESCE(COALESCE(tbItemDocumentoFT.CodigoTributacaoItDocFT,COALESCE(tbProdutoFT.CodigoTributacaoProduto,tbModeloVeiculoCV.CodigoTributacaoVeiculo)),'000')))),3) + '|'
	END
END +
CONVERT(VARCHAR(4),tbItemDocumento.CodigoCFO) + '|' + 
COALESCE(CONVERT(VARCHAR(6),tbItemDocumento.CodigoNaturezaOperacao),'') + '|' +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		CASE WHEN 'ZZ' = 'PE' AND --- desativado
                  tbItemDocumento.EntradaSaidaDocumento = 'S' AND 
                  tbCliFor.UFCliFor <> tbLocal.UFLocal THEN
			'0,00|'
		ELSE
			REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorBaseICMS1ItemDocto),'.',',') + '|' 
		END
END +
CASE 
	WHEN ( tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' ) OR tbItemDocumento.ValorBaseICMS1ItemDocto = 0 THEN
		'0,00' + '|'
    ELSE
		CASE WHEN 'ZZ' = 'PE' AND --- desativado
                  tbItemDocumento.EntradaSaidaDocumento = 'S' AND 
                  tbCliFor.UFCliFor <> tbLocal.UFLocal THEN
			'0,00|'
		ELSE
			REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.PercentualICMSItemDocto),'.',',') + '|' 
		END 
END +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		CASE WHEN 'ZZ' = 'PE' AND --- desativado
                  tbItemDocumento.EntradaSaidaDocumento = 'S' AND 
                  tbCliFor.UFCliFor <> tbLocal.UFLocal THEN
			'0,00|'
		ELSE
			REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorICMSItemDocto),'.',',') + '|' 
		END
END +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' THEN
			REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.BaseICMSSubstTribItemDocto),'.',',') + '|'
		ELSE
			'0,00' + '|'
		END
END +
'0,00' + '|' + ---- aliquota ST
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' THEN
			REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorICMSSubstTribItemDocto),'.',',') + '|' 
		ELSE
			'0,00' + '|'
		END
END +
'0' + '|' + 
'' + '|' +
'' + '|' +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorBaseIPI1ItemDocto),'.',',') + '|'
END +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.PercentualIPIItemDocto),'.',',') + '|'
END +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorIPIItemDocto),'.',',') + '|' 
END +
CASE WHEN tbItemDocumento.ValorBasePISItemDocto <> 0 THEN
	'01'
ELSE
	'04'
END + '|' +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorBasePISItemDocto),'.',',') + '|'
END +
CASE 
	WHEN ( tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' ) THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.PercPISItemDocto),'.',',') + '|' 
END +
'1' + '|' + 
'0,00' + '|' +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbItemDocumento.ValorPISItemDocto),'.',',') + '|' 
END +
CASE WHEN ( tbItemDocumentoFT.BaseCOFINSItDocFT IS NOT NULL AND tbItemDocumentoFT.BaseCOFINSItDocFT <> 0 ) OR ( tbDocumento.TipoLancamentoMovimentacao = 9 AND tbDocumento.ValorBaseFinsocialDocumento <> 0 ) THEN
	'01'
ELSE
	'04'
END + '|' +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		COALESCE(REPLACE(CONVERT(VARCHAR(16),tbItemDocumentoFT.BaseCOFINSItDocFT),'.',','),'0,00') + '|' 
END +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		COALESCE(REPLACE(CONVERT(VARCHAR(16),tbItemDocumentoFT.PercCofinsItDocFT),'.',','),'0,00') + '|' 
END +
'1' + '|' +
'0,00' + '|' +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		COALESCE(REPLACE(CONVERT(VARCHAR(16),tbItemDocumentoFT.ValorCOFINSItDocFT),'.',','),'0,00') + '|'
END + '|',
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
		'USOCONSUMO'
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
0
FROM tbItemDocumento (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
INNER JOIN tbCliFor (NOLOCK) ON
           tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
           tbCliFor.CodigoCliFor = tbItemDocumento.CodigoCliFor 			
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
WHERE 
tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbItemDocumento.CodigoLocal = @CodigoLocal AND
tbItemDocumento.DataDocumento between @DataInicial AND @DataFinal AND
rtSPEDFiscal.TipoRegistro = 'C100' AND
tbDocumento.CondicaoComplementoICMSDocto = 'F' AND
tbDocumento.CondicaoNFCancelada = 'F' AND
tbDocumento.TipoLancamentoMovimentacao <> 11 AND
( 
  tbDocumento.CodigoModeloNotaFiscal <> 55 OR 
  ( tbDocumentoNFe.ChaveAcessoNFe IS NULL OR 
    tbDocumentoNFe.NumeroProtocolo IS NULL OR
    tbDocumentoNFe.NumeroProtocolo = 0 )
)

ORDER BY
tbItemDocumento.EntradaSaidaDocumento,
tbItemDocumento.NumeroDocumento,
tbItemDocumento.DataDocumento,
tbItemDocumento.CodigoCliFor,
tbItemDocumento.TipoLancamentoMovimentacao,
tbItemDocumento.SequenciaItemDocumento

--- Uso/Consumo sem Itens
/*
INSERT rtSPEDFiscal
SELECT
@@spid,
'|C170|' + 
'1' + '|' + 
'USOCONSUMO' + '|' +
'' + '|' +
'1,000' + '|' +
'UN' + '|' +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorContabilDocumento),'.',',') + '|'
END +
'0,00' + '|' +
'0' + '|' +
RIGHT(('000' + RTRIM(LTRIM(COALESCE(tbNaturezaOperacao.CodigoTributacaoNaturezaOper,'000')))),3) + '|' +
CONVERT(VARCHAR(4),tbDocumento.CodigoCFO) + '|' + 
CONVERT(VARCHAR(6),tbDocumentoFT.CodigoNaturezaOperacao) + '|' +
'0,00' + '|' +
'0,00' + '|' +
'0,00' + '|' +
'0,00' + '|' +
'0,00' + '|' +
'0,00' + '|' +
'0' + '|' + 
'' + '|' +
'' + '|' +
'0,00' + '|' +
'0,00' + '|' +
'0,00' + '|' +
CASE WHEN tbDocumento.ValorBasePISDocumento <> 0 THEN
	'01'
ELSE
	'04'
END + '|' +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorBasePISDocumento),'.',',') + '|'
END +
'0,00' + '|' +
'1' + '|' + 
'0,00' + '|' +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorPISDocumento),'.',',') + '|' 
END +
CASE WHEN tbDocumento.ValorBaseFinsocialDocumento <> 0 THEN
	'01'
ELSE
	'04'
END + '|' +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		COALESCE(REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorBaseFinsocialDocumento),'.',','),'0,00') + '|' 
END +
'0,00' + '|' +
'1' + '|' +
'0,00' + '|' +
CASE 
	WHEN tbLocalLF.TipoImpressaoNFCancelada = 4 AND tbDocumento.CondicaoNFCancelada = 'V' THEN
		'0,00' + '|'
    ELSE
		COALESCE(REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorFinsocialDocumento),'.',','),'0,00') + '|'
END + '|',
'C170',
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao,
11,
'USOCONSUMO',
tbDocumentoFT.CodigoNaturezaOperacao,
'UN',
0
FROM tbDocumento (NOLOCK)
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal 
INNER JOIN rtSPEDFiscal (NOLOCK) ON
           rtSPEDFiscal.Spid = @@spid AND
           rtSPEDFiscal.EntradaSaida = tbDocumento.EntradaSaidaDocumento AND
           rtSPEDFiscal.DataDocumento = tbDocumento.DataDocumento AND
           rtSPEDFiscal.CodigoCliFor = tbDocumento.CodigoCliFor AND
           rtSPEDFiscal.NumeroDocumento = tbDocumento.NumeroDocumento AND
           rtSPEDFiscal.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao
INNER JOIN tbDocumentoFT (NOLOCK) ON
		   tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND
           tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND
           tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento AND
           tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND
           tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND
           tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND
           tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao
INNER JOIN tbNaturezaOperacao (NOLOCK) ON
           tbNaturezaOperacao.CodigoEmpresa = @CodigoEmpresa AND
           tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao
         
WHERE 
tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbDocumento.CodigoLocal = @CodigoLocal AND
tbDocumento.DataDocumento between @DataInicial AND @DataFinal AND
tbDocumento.TipoLancamentoMovimentacao = 9 AND
rtSPEDFiscal.TipoRegistro = 'C100' AND
tbDocumento.CondicaoComplementoICMSDocto = 'F' AND
NOT EXISTS ( SELECT 1 FROM tbItemDocumento (NOLOCK)
             WHERE
             tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
             tbDocumento.CodigoLocal = @CodigoLocal AND
             tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
             tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND
             tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
             tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
             tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao )
*/
---

INSERT rtSPEDFiscal
SELECT
@@spid,
'|C175|' +
'3' + '|' +
RTRIM(LTRIM(tbLocal.CGCLocal)) + '|' +
tbLocal.UFLocal + '|' + 
RTRIM(LTRIM(NumeroChassisCV)) + '|',
'C175',
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
FROM tbItemDocumento (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
INNER JOIN tbDocumento (NOLOCK) ON
           tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumento.CodigoLocal = @CodigoLocal AND
           tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
           tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND
           tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
INNER JOIN rtSPEDFiscal (NOLOCK) ON
           rtSPEDFiscal.Spid = @@spid AND
           rtSPEDFiscal.EntradaSaida = tbItemDocumento.EntradaSaidaDocumento AND
           rtSPEDFiscal.DataDocumento = tbItemDocumento.DataDocumento AND
           rtSPEDFiscal.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           rtSPEDFiscal.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           rtSPEDFiscal.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
INNER JOIN tbVeiculoCV (NOLOCK) ON
          tbVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
          tbVeiculoCV.CodigoLocal = @CodigoLocal AND
          tbVeiculoCV.NumeroVeiculoCV = tbItemDocumento.NumeroVeiculoCV
WHERE 
tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbItemDocumento.CodigoLocal = @CodigoLocal AND
tbItemDocumento.EntradaSaidaDocumento = 'S' AND
tbItemDocumento.DataDocumento between @DataInicial AND @DataFinal AND
rtSPEDFiscal.TipoRegistro = 'C100' AND
tbDocumento.CondicaoComplementoICMSDocto = 'F' AND
tbVeiculoCV.VeiculoNovoCV = 'V' AND
tbDocumento.CondicaoNFCancelada = 'F' AND
tbDocumento.TipoLancamentoMovimentacao <> 11 AND
tbDocumento.CodigoModeloNotaFiscal <> 55

/*
INSERT rtSPEDFiscal
SELECT
@@spid,
'|C176|' +
'01' + '|' +
CONVERT(VARCHAR(6),vwBaseSTUltimaEntrada.NumeroDocumento) + '|' +
RTRIM(LTRIM(COALESCE(tbDocumento.SerieDocumento,''))) + '|' + 
COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,vwBaseSTUltimaEntrada.DataUltimaEntrada)),2,2) +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,vwBaseSTUltimaEntrada.DataUltimaEntrada)),2,2) +
CONVERT(CHAR(4),DATEPART(year,vwBaseSTUltimaEntrada.DataUltimaEntrada)),'') + '|' +
CONVERT(VARCHAR(14),DoctoEntrada.CodigoCliFor) + '|' +
REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),vwBaseSTUltimaEntrada.QtdeLancamentoItemDocto)),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),( ItemDoctoEntrada.ValorProdutoItemDocto / ItemDoctoEntrada.QtdeLancamentoItemDocto))),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),( vwBaseSTUltimaEntrada.BaseSubstituicaoICMS / vwBaseSTUltimaEntrada.QtdeLancamentoItemDocto))),'.',',') + '|',
'C176',
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
FROM tbItemDocumento (NOLOCK)
INNER JOIN tbDocumento (NOLOCK) ON
           tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumento.CodigoLocal = @CodigoLocal AND
           tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
           tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND
           tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
INNER JOIN rtSPEDFiscal (NOLOCK) ON
           rtSPEDFiscal.Spid = @@spid AND
           rtSPEDFiscal.EntradaSaida = tbItemDocumento.EntradaSaidaDocumento AND
           rtSPEDFiscal.DataDocumento = tbItemDocumento.DataDocumento AND
           rtSPEDFiscal.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
           rtSPEDFiscal.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
           rtSPEDFiscal.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
INNER JOIN vwBaseSTUltimaEntrada (NOLOCK) ON
           vwBaseSTUltimaEntrada.CodigoEmpresa = @CodigoEmpresa AND
           vwBaseSTUltimaEntrada.CodigoLocal = @CodigoLocal AND
           vwBaseSTUltimaEntrada.CodigoProduto = tbItemDocumento.CodigoProduto AND
           vwBaseSTUltimaEntrada.DataUltimaEntrada = ( SELECT MAX(D.DataUltimaEntrada) FROM vwBaseSTUltimaEntrada D (NOLOCK)
								   WHERE D.CodigoEmpresa = @CodigoEmpresa AND 
                                         D.CodigoLocal = @CodigoLocal AND
                                         D.CodigoProduto = tbItemDocumento.CodigoProduto AND
                                         D.DataUltimaEntrada <= tbItemDocumento.DataDocumento )
INNER JOIN tbDocumento DoctoEntrada (NOLOCK) ON
           tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
           tbDocumento.CodigoLocal = @CodigoLocal AND
           tbDocumento.EntradaSaidaDocumento = 'E' AND
           tbDocumento.NumeroDocumento = vwBaseSTUltimaEntrada.NumeroDocumento AND
           tbDocumento.DataDocumento = vwBaseSTUltimaEntrada.DataUltimaEntrada AND
           tbDocumento.TipoLancamentoMovimentacao = 1
INNER JOIN tbItemDocumento ItemDoctoEntrada (NOLOCK) ON
           tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
           tbItemDocumento.CodigoLocal = @CodigoLocal AND
           tbItemDocumento.EntradaSaidaDocumento = 'E' AND
           tbItemDocumento.NumeroDocumento = vwBaseSTUltimaEntrada.NumeroDocumento AND
           tbItemDocumento.DataDocumento = vwBaseSTUltimaEntrada.DataUltimaEntrada AND
           tbItemDocumento.TipoLancamentoMovimentacao = 1 AND
           tbItemDocumento.SequenciaItemDocumento = vwBaseSTUltimaEntrada.SequenciaItemDocumento 
WHERE 
tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbItemDocumento.CodigoLocal = @CodigoLocal AND
tbItemDocumento.EntradaSaidaDocumento = 'S' AND
tbItemDocumento.DataDocumento between @DataInicial AND @DataFinal AND
rtSPEDFiscal.TipoRegistro = 'C100' AND
tbDocumento.CondicaoComplementoICMSDocto = 'F' AND
tbItemDocumento.BaseICMSSubstTribItemDocto <> 0 AND
tbDocumento.CondicaoNFCancelada = 'F' AND
tbDocumento.TipoLancamentoMovimentacao <> 11
*/

---- Temporaria para o C190

SELECT
CASE WHEN tbItemDocumento.TipoLancamentoMovimentacao = 9 OR tbItemDocumento.NumeroVeiculoCV IS NOT NULL OR ( tbItemDocumento.TipoLancamentoMovimentacao in (10,12) AND tbNaturezaOperacao.CodigoNaturezaOperacao IS NOT NULL ) THEN
	RIGHT('000' + COALESCE(COALESCE(CNOItem.CodigoTributacaoNaturezaOper,tbNaturezaOperacao.CodigoTributacaoNaturezaOper),'000'),3)
ELSE
	CASE WHEN tbItemDocumento.CodigoCFO in (1924,2924,5924,6924,1910,2910,1949,2949,5949,6949,1915,5915,2915,6915,1916,5916,2916,6916) THEN
		'090' 
	ELSE
		RIGHT(('000' + RTRIM(LTRIM(COALESCE(COALESCE(tbItemDocumentoFT.CodigoTributacaoItDocFT,COALESCE(tbProdutoFT.CodigoTributacaoProduto,tbModeloVeiculoCV.CodigoTributacaoVeiculo)),'000')))),3)
	END
END AS CodigoTributacao,
tbItemDocumento.CodigoCFO,
CASE WHEN tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 THEN
	tbItemDocumento.PercentualICMSItemDocto
ELSE
	0
END AS PercentualICMSItemDocto,
tbItemDocumento.ValorContabilItemDocto,
CASE WHEN tbItemDocumento.EntradaSaidaDocumento = 'S' AND 'ZZ' = 'PE' AND tbCliFor.UFCliFor <> tbLocal.UFLocal THEN
	0
ELSE
	tbItemDocumento.ValorBaseICMS1ItemDocto
END AS ValorBaseICMS1ItemDocto,	
CASE WHEN tbItemDocumento.EntradaSaidaDocumento = 'S' AND 'ZZ' = 'PE' AND tbCliFor.UFCliFor <> tbLocal.UFLocal THEN
	0
ELSE
	tbItemDocumento.ValorICMSItemDocto
END AS ValorICMSItemDocto,
CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' THEN
	tbItemDocumento.BaseICMSSubstTribItemDocto
ELSE
	0
END as BaseICMSSubstTribItemDocto,
CASE WHEN tbDocumento.EntradaSaidaDocumento = 'S' THEN
	tbItemDocumento.ValorICMSSubstTribItemDocto
ELSE
	0
END as ValorICMSRetido,
CASE WHEN ( tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND (tbItemDocumento.ValorBaseICMS2ItemDocto + tbItemDocumento.ValorBaseICMS3ItemDocto) <> 0 ) THEN 
	(tbItemDocumento.ValorBaseICMS2ItemDocto + tbItemDocumento.ValorBaseICMS3ItemDocto) 
ELSE
	CASE WHEN ((tbDocumento.ValorICMSRetidoDocumento + tbDocumento.ValorICMSSubstTribDocto ) <> 0 AND tbItemDocumento.ValorBaseICMS2ItemDocto <> 0 AND tbItemDocumento.ValorBaseICMS3ItemDocto <> 0 ) THEN
		tbItemDocumento.ValorBaseICMS2ItemDocto
	ELSE
		0
	END
END as ValorIsenta,
tbItemDocumento.ValorIPIItemDocto,
tbDocumento.EntradaSaidaDocumento,
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
tbDocumento.CodigoCliFor,
tbDocumento.TipoLancamentoMovimentacao
INTO #tmpC190
FROM tbItemDocumento (NOLOCK)
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal 
INNER JOIN tbCliFor (NOLOCK) ON
           tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
           tbCliFor.CodigoCliFor = tbItemDocumento.CodigoCliFor 
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
CASE WHEN @Versao = '003' OR @Versao = '004' OR @Versao = '005' THEN '|' ELSE '' END,
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

INSERT rtE110
SELECT
tbItemDocumentoCTRC.NumeroDocumento,
tbItemDocumentoCTRC.DataDocumento,
tbItemDocumentoCTRC.ValorICMSSubstTribItemDocto
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
tbItemDocumentoCTRC.ValorICMSSubstTribItemDocto <> 0

SELECT
CONVERT(money,sum(tbItemDocumentoCTRC.ValorICMSSubstTribItemDocto)) as ValorICMS
INTO #tmpE110
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
tbItemDocumentoCTRC.ValorICMSSubstTribItemDocto <> 0
GROUP BY 
#tmpC197.EntradaSaida,
#tmpC197.NumeroDocumento,
#tmpC197.DataDocumento,
#tmpC197.CodigoCliFor,
#tmpC197.TipoLancamentoMovimentacao,
#tmpC197.CodigoProduto

INSERT rtE110
SELECT
tbItemDocumento.NumeroDocumento,
tbItemDocumento.DataDocumento,
tbItemDocumento.ValorICMSSubstTribItemDocto
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
           tbItemDocumento.CodigoProduto = #tmpC197.CodigoProduto
WHERE 
tbDocumento.EntradaSaidaDocumento = 'E' AND
tbDocumento.CondicaoNFCancelada = 'F' AND
tbDocumento.TipoLancamentoMovimentacao <> 11 AND
tbItemDocumento.ValorICMSSubstTribItemDocto <> 0

INSERT #tmpE110
SELECT 
CONVERT(money,sum(tbItemDocumento.ValorICMSSubstTribItemDocto))
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
           tbItemDocumento.CodigoProduto = #tmpC197.CodigoProduto
WHERE 
tbDocumento.EntradaSaidaDocumento = 'E' AND
tbDocumento.CondicaoNFCancelada = 'F' AND
tbDocumento.TipoLancamentoMovimentacao <> 11 AND
tbItemDocumento.ValorICMSSubstTribItemDocto <> 0
GROUP BY 
#tmpC197.EntradaSaida,
#tmpC197.NumeroDocumento,
#tmpC197.DataDocumento,
#tmpC197.CodigoCliFor,
#tmpC197.TipoLancamentoMovimentacao,
#tmpC197.CodigoProduto

---

SELECT 
#tmpC197.EntradaSaida,
#tmpC197.NumeroDocumento,
#tmpC197.DataDocumento,
#tmpC197.CodigoCliFor,
#tmpC197.TipoLancamentoMovimentacao,
#tmpC197.CodigoProduto,
tbItemDocumentoCTRC.BaseICMSSubstTribItemDocto,
tbItemDocumentoCTRC.PercentualICMSItemDocto,
tbItemDocumentoCTRC.ValorICMSSubstTribItemDocto
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
tbItemDocumentoCTRC.ValorICMSSubstTribItemDocto <> 0

--- dif aliquota

SELECT 
#tmpC197.EntradaSaida,
#tmpC197.NumeroDocumento,
#tmpC197.DataDocumento,
#tmpC197.CodigoCliFor,
#tmpC197.TipoLancamentoMovimentacao,
#tmpC197.CodigoProduto,
SUM(tbItemDocumento.ValorBaseICMS1ItemDocto) AS ValorBaseICMS1ItemDocto,
MAX(tbItemDocumento.PercentualICMSItemDocto) AS PercentualICMSItemDocto,
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
				tbItemDocumento.TipoLancamentoMovimentacao = 9
			)
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
#tmpC197.CodigoProduto

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
tbItemDocumento.ValorICMSSubstTribItemDocto
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
           tbItemDocumento.CodigoProduto = #tmpC197.CodigoProduto
WHERE 
tbDocumento.EntradaSaidaDocumento = 'E' AND
tbDocumento.CondicaoNFCancelada = 'F' AND
tbDocumento.TipoLancamentoMovimentacao <> 11 AND
tbItemDocumento.ValorICMSSubstTribItemDocto <> 0

INSERT rtSPEDFiscal
SELECT
@@Spid,
'|C197|' +
@AjusteICMSCTRCST + '|' +
'|' +
RTRIM(LTRIM(#tmpC197Item.CodigoProduto)) + '|' +
REPLACE(CONVERT(VARCHAR(16),sum(#tmpC197Item.BaseICMSSubstTribItemDocto)),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),max(#tmpC197Item.PercentualICMSItemDocto)),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),sum(#tmpC197Item.ValorICMSSubstTribItemDocto)),'.',',') + '|' +
'0,00|',
'C197',
#tmpC197Item.EntradaSaida,
#tmpC197Item.NumeroDocumento,
#tmpC197Item.DataDocumento,
#tmpC197Item.CodigoCliFor,
#tmpC197Item.TipoLancamentoMovimentacao,
11,
'',
0,
'',
0
FROM #tmpC197Item
WHERE RTRIM(LTRIM(@AjusteICMSCTRCST)) <> '' AND RTRIM(LTRIM(@AjusteICMSCTRCST)) <> '0000000000'
GROUP BY 
#tmpC197Item.EntradaSaida,
#tmpC197Item.NumeroDocumento,
#tmpC197Item.DataDocumento,
#tmpC197Item.CodigoCliFor,
#tmpC197Item.TipoLancamentoMovimentacao,
#tmpC197Item.CodigoProduto

INSERT rtSPEDFiscal
SELECT DISTINCT
@@Spid,
'|C195|ICMSST|ICMS ST SOBRE FRETE|',
'C195',
EntradaSaida,
NumeroDocumento,
DataDocumento,
CodigoCliFor,
TipoLancamentoMovimentacao,
11,
'',
0,
'',
0
FROM rtSPEDFiscal (NOLOCK)
WHERE 
rtSPEDFiscal.Spid = @@Spid AND
rtSPEDFiscal.TipoRegistro = 'C197' AND
EXISTS ( SELECT 1 FROM #tmpC197Item )

INSERT rtSPEDFiscal
SELECT
@@Spid,
'|C197|' +
@AjusteICMSDIFALQ + '|' +
'|' +
RTRIM(LTRIM(#tmpC197ItemDifAliquota.CodigoProduto)) + '|' +
REPLACE(CONVERT(VARCHAR(16),sum(#tmpC197ItemDifAliquota.ValorBaseICMS1ItemDocto)),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),max(#tmpC197ItemDifAliquota.PercentualICMSItemDocto)),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),sum(#tmpC197ItemDifAliquota.ValorDifAliquotaICMSItemDocto)),'.',',') + '|' +
'0,00|',
'C197',
#tmpC197ItemDifAliquota.EntradaSaida,
#tmpC197ItemDifAliquota.NumeroDocumento,
#tmpC197ItemDifAliquota.DataDocumento,
#tmpC197ItemDifAliquota.CodigoCliFor,
#tmpC197ItemDifAliquota.TipoLancamentoMovimentacao,
11,
'',
0,
'',
0
FROM #tmpC197ItemDifAliquota
WHERE RTRIM(LTRIM(@AjusteICMSDIFALQ)) <> '' AND RTRIM(LTRIM(@AjusteICMSDIFALQ)) <> '00000000'
GROUP BY 
#tmpC197ItemDifAliquota.EntradaSaida,
#tmpC197ItemDifAliquota.NumeroDocumento,
#tmpC197ItemDifAliquota.DataDocumento,
#tmpC197ItemDifAliquota.CodigoCliFor,
#tmpC197ItemDifAliquota.TipoLancamentoMovimentacao,
#tmpC197ItemDifAliquota.CodigoProduto

INSERT rtSPEDFiscal
SELECT DISTINCT
@@Spid,
'|C195|DIFALI|ICMS DIFERENCIAL DE ALIQUOTA - AQUISICAO DE MATERIAL DE USO E CONSUMO|',
'C195',
EntradaSaida,
NumeroDocumento,
DataDocumento,
CodigoCliFor,
TipoLancamentoMovimentacao,
11,
'',
0,
'',
0
FROM rtSPEDFiscal (NOLOCK)
WHERE 
rtSPEDFiscal.Spid = @@Spid AND
rtSPEDFiscal.TipoRegistro = 'C197' AND
EXISTS ( SELECT 1 FROM #tmpC197ItemDifAliquota )

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
FROM rtSPEDFiscal (NOLOCK)
WHERE 
rtSPEDFiscal.Spid = @@Spid AND
rtSPEDFiscal.TipoRegistro = 'C197' AND
EXISTS ( SELECT 1 FROM #tmpC197Item )

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
FROM rtSPEDFiscal (NOLOCK)
WHERE 
rtSPEDFiscal.Spid = @@Spid AND
rtSPEDFiscal.TipoRegistro = 'C197' AND
EXISTS ( SELECT 1 FROM #tmpC197ItemDifAliquota )

INSERT #tmpE110
SELECT 
CONVERT(money,sum(ValorDifAliquotaICMSItemDocto))
FROM #tmpC197ItemDifAliquota

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
getdate(),
0,
0,
0,
'',
0,
'',
0
FROM tbMapaECF
WHERE
CodigoEmpresa = @CodigoEmpresa AND
CodigoLocal = @CodigoLocal AND
DataMapaECF between @DataInicial AND @DataFinal

if @Perfil = 'B' 
BEGIN

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C405|' + 
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,DataMapaECF)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,DataMapaECF)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,DataMapaECF)),'') + '|' +
	RIGHT(CONVERT(VARCHAR(8),ContadorReducaoZECF),3) + '|' +
	CONVERT(VARCHAR(8),ContadorReducaoZECF) + '|' +
	CONVERT(VARCHAR(8),NumeroUltimoECF) + '|' +
	REPLACE(CONVERT(VARCHAR(16),GranTotalFimDiaECF),'.',',') + '|' +
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
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0 )),'.',','),'0,00') + '|',
	'C405',
	'E',
	999999,
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
				tbDocumento.CondicaoNFCancelada = 'F' )

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C410|' + 
	REPLACE(CONVERT(VARCHAR(16),sum(ValorPISDocumento)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),sum(ValorFinsocialDocumento)),'.',',') + '|',
	'C410',
	'E',
	999999,
	tbDocumento.DataDocumento,
	0,
	0,
	13,
	'',
	0,
	'',
	0
	FROM tbDocumento
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
			 tbMapaECF.DataMapaECF = tbDocumento.DataDocumento ) 
	GROUP BY tbDocumento.DataDocumento
	
	DELETE rtSPEDFiscal
	WHERE
	Spid = @@spid AND
	TipoRegistro = 'C410' AND
	( Linha is NULL or Linha = '|C410|||' )

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
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase1 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0 )),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	'E',
	999999,
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
				tbDocumento.CondicaoNFCancelada = 'F' )


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
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase2 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0 )),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	'E',
	999999,
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
				tbDocumento.CondicaoNFCancelada = 'F' )


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
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase3 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0 )),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	'E',
	999999,
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
				tbDocumento.CondicaoNFCancelada = 'F' )

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
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS1ItemDocto <> 0 AND
									tbItemDocumento.PercentualICMSItemDocto = PercentualICMSBase4 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0 )),'.',','),'0,00') + '|' +
	'0|' +
	'|',
	'C420',
	'E',
	999999,
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
				tbDocumento.CondicaoNFCancelada = 'F' )

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C420|' + 
	'F1' + '|' +
	REPLACE(CONVERT(VARCHAR(16),SubstituicaoTributECF),'.',',') + '|' +
	'|' +
	'|',
	'C420',
	'E',
	999999,
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
	tbItemDocumento.ValorICMSSubstTribItemDocto <> 0 AND
	tbDocumento.CondicaoNFCancelada = 'F' AND
	tbItemDocumento.QtdeLancamentoItemDocto <> 0 )

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
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									( tbItemDocumento.ValorBaseICMS2ItemDocto <> 0 OR tbItemDocumento.ValorBaseICMS3ItemDocto <> 0 ) AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0 )),'.',','),'0,00') + '|' +
	'|' +
	'|',
	'C420',
	'E',
	999999,
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
	( IsentaICMSECF + NaoTributadaICMSECF + ValorTotalISSECF ) <> 0 AND
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
				tbDocumento.CondicaoNFCancelada = 'F' )


	/*
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
									WHERE
									tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
									tbItemDocumento.CodigoLocal = @CodigoLocal AND
									tbItemDocumento.EntradaSaidaDocumento = 'S' AND
									tbItemDocumento.DataDocumento = tbMapaECF.DataMapaECF AND
									tbDocumento.EspecieDocumento = 'ECF' AND
									tbDocumento.CondicaoNFCancelada = 'F' AND
									tbItemDocumento.ValorBaseICMS3ItemDocto <> 0 AND
									tbItemDocumento.QtdeLancamentoItemDocto <> 0 )),'.',','),'0,00') + '|' +
	'|' +
	'|',
	'C420',
	'E',
	999999,
	DataMapaECF,
	400,
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
	NaoTributadaICMSECF <> 0
	*/
END
ELSE
BEGIN

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C405|' + 
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,DataMapaECF)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,DataMapaECF)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,DataMapaECF)),'') + '|' +
	RIGHT(CONVERT(VARCHAR(8),ContadorReducaoZECF),3) + '|' +
	CONVERT(VARCHAR(9),tbDocumento.NumeroDocumento) + '|' +
	CONVERT(VARCHAR(9),tbDocumento.NumeroDocumento) + '|' +
	REPLACE(CONVERT(VARCHAR(16),sum(GranTotalFimDiaECF)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),ValorContabilDocumento),'.',',') + '|',
	'C405',
	RTRIM(LTRIM(NumeroSerieFabricacaoECF)),
	tbDocumento.NumeroDocumento,
	tbDocumento.DataDocumento,
	300,
	0,
	0, --datepart(day,tbDocumento.DataDocumento),
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
	tbDocumento.CondicaoNFCancelada = 'F'
	GROUP BY
	tbDocumento.NumeroDocumento,
    tbDocumento.DataDocumento,
	DataMapaECF,
	ContadorReducaoZECF,
	ValorContabilDocumento,
	tbMapaECF.NumeroSerieFabricacaoECF

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C410|' + 
	REPLACE(CONVERT(VARCHAR(16),ValorPISDocumento),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),ValorFinsocialDocumento),'.',',') + '|',
	'C410',
	RTRIM(LTRIM(SerieECFDocFT)),
	tbDocumento.NumeroDocumento,
	tbDocumento.DataDocumento,
	300,
	0,
	0, ---datepart(day,tbDocumento.DataDocumento),
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
			 tbMapaECF.NumeroSerieFabricacaoECF = tbDocumentoFT.SerieECFDocFT) 

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
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorContabilItemDocto)),'.',',') + '|' +
	'0|' +
	'|',
	'C420',
	RTRIM(LTRIM(SerieECFDocFT)),
	tbDocumento.NumeroDocumento,
	tbDocumento.DataDocumento,
	300,
	0,
	0, --DATEPART(DAY,tbDocumento.DataDocumento),
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
	tbItemDocumento.ValorBaseICMS1ItemDocto <> 0
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
	tbItemDocumento.NumeroDocumento,
	tbItemDocumento.DataDocumento,
	300,
	0,
	0, --DATEPART(DAY,tbItemDocumento.DataDocumento),
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
	tbItemDocumento.QtdeLancamentoItemDocto <> 0
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
	tbItemDocumento.NumeroDocumento,
	tbItemDocumento.DataDocumento,
	300,
	0,
	0, --DATEPART(DAY,tbItemDocumento.DataDocumento),
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
	( tbItemDocumento.ValorBaseICMS2ItemDocto <> 0 OR tbItemDocumento.ValorBaseICMS3ItemDocto <> 0 ) 
	GROUP BY 
	tbItemDocumento.NumeroDocumento,
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
CONVERT(VARCHAR(9),tbDocumento.NumeroDocumento) + '|' +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDocumento.DataDocumento)),2,2) +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDocumento.DataDocumento)),2,2) +
CONVERT(CHAR(4),DATEPART(year,tbDocumento.DataDocumento)) + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorContabilDocumento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorPISDocumento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorFinsocialDocumento),'.',',') + '|' +
RTRIM(COALESCE(tbCliForFisica.CPFFisica,tbCliForJuridica.CGCJuridica)) + '|' +
RTRIM(tbCliFor.NomeCliFor) + '|',
'C460',
RTRIM(LTRIM(SerieECFDocFT)),
tbDocumento.NumeroDocumento,
tbDocumento.DataDocumento,
300,
0,
0, --datepart(day,tbDocumento.DataDocumento),
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
WHERE
tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbDocumento.CodigoLocal = @CodigoLocal AND
tbDocumento.EntradaSaidaDocumento = 'S' AND
tbDocumento.DataDocumento between @DataInicial AND @DataFinal AND
tbDocumento.EspecieDocumento = 'ECF' AND
tbDocumento.TipoLancamentoMovimentacao = 7 AND
tbDocumento.CondicaoNFCancelada = 'F' AND
@Perfil = 'A'

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
		'USOCONSUMO'
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
RIGHT(('000' + RTRIM(LTRIM(COALESCE(COALESCE(tbItemDocumentoFT.CodigoTributacaoItDocFT,tbProdutoFT.CodigoTributacaoProduto),'000')))),3) + '|' +
CONVERT(VARCHAR(4),tbItemDocumento.CodigoCFO) + '|' + 
REPLACE(CONVERT(VARCHAR(16),PercentualICMSItemDocto),'.',',') + '|' + 
REPLACE(CONVERT(VARCHAR(16),SUM(ValorPISItemDocto)),'.',',') + '|' +
COALESCE(REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumentoFT.ValorCOFINSItDocFT)),'.',','),'0,00') + '|',
'C470',
RTRIM(LTRIM(SerieECFDocFT)),
tbItemDocumento.NumeroDocumento,
tbItemDocumento.DataDocumento,
300,
0,
0, --datepart(day,tbItemDocumento.DataDocumento),
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
		'USOCONSUMO'
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
tbItemDocumento.TipoLancamentoMovimentacao = 7 AND
tbItemDocumento.ValorICMSSubstTribItemDocto = 0 AND
tbDocumento.CondicaoNFCancelada = 'F' AND
tbItemDocumento.QtdeLancamentoItemDocto <> 0 AND
@Perfil = 'A'
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
tbProdutoFT.CodigoTributacaoProduto,
tbItemDocumento.CodigoCFO,
SerieECFDocFT

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
		'USOCONSUMO'
END))) + '|' +
REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),SUM(tbItemDocumento.QtdeLancamentoItemDocto))),'.',',') + '|' +
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
REPLACE(CONVERT(VARCHAR(16),SUM(ValorPISItemDocto)),'.',',') + '|' +
COALESCE(REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumentoFT.ValorCOFINSItDocFT)),'.',','),'0,00') + '|',
'C425',
'E',
999999,
tbItemDocumento.DataDocumento,
CASE WHEN sum(ValorBaseICMS1ItemDocto) <> 0 THEN
	MIN(CONVERT(NUMERIC(4),PercentualICMSItemDocto))
ELSE
	300 
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
		'USOCONSUMO'
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
@Perfil <> 'A'
GROUP BY
tbItemDocumento.CodigoProduto,
tbItemDocumento.CodigoMaoObraOS,
tbVeiculoCV.NumeroChassisCV,
tbItemDocumento.CodigoItemDocto,
tbProdutoFT.CodigoUnidadeProduto,
tbItemDocumento.NumeroVeiculoCV,
tbItemDocumento.DataDocumento,
tbItemDocumento.PercentualICMSItemDocto

INSERT rtSPEDFiscal
SELECT
@@spid,
'|C425|' + 
CONVERT(VARCHAR(30),
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
		'USOCONSUMO'
END) + '|' +
REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,3),SUM(tbItemDocumento.QtdeLancamentoItemDocto))),'.',',') + '|' +
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
REPLACE(CONVERT(VARCHAR(16),SUM(ValorPISItemDocto)),'.',',') + '|' +
COALESCE(REPLACE(CONVERT(VARCHAR(16),SUM(tbItemDocumentoFT.ValorCOFINSItDocFT)),'.',','),'0,00') + '|',
'C425',
'E',
999999,
tbItemDocumento.DataDocumento,
300,
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
		'USOCONSUMO'
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
@Perfil <> 'A'
GROUP BY
tbItemDocumento.CodigoProduto,
tbItemDocumento.CodigoMaoObraOS,
tbVeiculoCV.NumeroChassisCV,
tbItemDocumento.CodigoItemDocto,
tbProdutoFT.CodigoUnidadeProduto,
tbItemDocumento.NumeroVeiculoCV,
tbItemDocumento.DataDocumento,
tbItemDocumento.PercentualICMSItemDocto

---- trata C490

IF @Perfil <> 'A' 
BEGIN
	SELECT
	tbItemDocumento.DataDocumento,
	RIGHT(('000' + RTRIM(LTRIM(COALESCE(COALESCE(tbItemDocumentoFT.CodigoTributacaoItDocFT,tbProdutoFT.CodigoTributacaoProduto),'000')))),3) AS CodigoTributacao,
	tbItemDocumento.CodigoCFO,
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
	END) AS ValorICMSItemDocto 
	INTO #tmpC490
	FROM tbItemDocumento
	INNER JOIN tbLocalLF ON
			   tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
			   tbLocalLF.CodigoLocal = @CodigoLocal 
	INNER JOIN tbDocumento ON
			   tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
			   tbDocumento.CodigoLocal = @CodigoLocal AND 
			   tbDocumento.EntradaSaidaDocumento = 'S' AND
			   tbDocumento.DataDocumento = tbItemDocumento.DataDocumento AND  
			   tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
			   tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			   tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
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
	WHERE
	tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
	tbItemDocumento.CodigoLocal = @CodigoLocal AND
	tbItemDocumento.EntradaSaidaDocumento = 'S' AND
	tbItemDocumento.DataDocumento between @DataInicial AND @DataFinal AND
	tbDocumento.EspecieDocumento = 'ECF' AND
    tbItemDocumento.TipoLancamentoMovimentacao = 7 AND
	tbDocumento.CondicaoNFCancelada = 'F' AND
	tbItemDocumento.QtdeLancamentoItemDocto <> 0 
	GROUP BY
	tbItemDocumentoFT.CodigoTributacaoItDocFT,
	tbProdutoFT.CodigoTributacaoProduto,
	tbItemDocumento.CodigoCFO,
	tbItemDocumento.PercentualICMSItemDocto,
	tbLocalLF.TipoImpressaoNFCancelada,
	tbDocumento.CondicaoNFCancelada,
	tbItemDocumento.DataDocumento

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
	'E',
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
	DataDocumento

	DROP TABLE #tmpC490
END
ELSE
BEGIN

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|C490|' +
	RIGHT(('000' + RTRIM(LTRIM(COALESCE(tbItemDocumentoFT.CodigoTributacaoItDocFT,'000')))),3) + '|' +
	CONVERT(VARCHAR(4),tbItemDocumento.CodigoCFO) + '|' +
	REPLACE(CONVERT(VARCHAR(16),PercentualICMSItemDocto),'.',',') + '|' + 
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorContabilItemDocto)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorBaseICMS1ItemDocto)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),SUM(ValorICMSItemDocto)),'.',',') + '|' +
	'' + '|',
	'C490',
	RTRIM(LTRIM(SerieECFDocFT)),
	tbItemDocumento.NumeroDocumento,
	tbItemDocumento.DataDocumento,
	300,
	0,
	0, --DATEPART(DAY,tbItemDocumento.DataDocumento),
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
	WHERE
	tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
	tbItemDocumento.CodigoLocal = @CodigoLocal AND
	tbItemDocumento.EntradaSaidaDocumento = 'S' AND
	tbItemDocumento.DataDocumento between @DataInicial AND @DataFinal AND
	tbDocumento.EspecieDocumento = 'ECF' AND
    tbItemDocumento.TipoLancamentoMovimentacao = 7 AND
	tbItemDocumento.ValorICMSSubstTribItemDocto = 0 AND
	tbDocumento.CondicaoNFCancelada = 'F' AND
	tbItemDocumento.QtdeLancamentoItemDocto <> 0 
	GROUP BY
	tbItemDocumento.NumeroDocumento,
	tbItemDocumento.DataDocumento,
	tbItemDocumento.PercentualICMSItemDocto,
	tbItemDocumentoFT.CodigoTributacaoItDocFT,
	tbItemDocumento.CodigoCFO,
	SerieECFDocFT

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
RTRIM(LTRIM(CONVERT(VARCHAR(3),COALESCE(tbDocumento.SerieDocumento,'')))) + '|' +
'' + '|' +
'01' + '|' +
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
CASE WHEN @Versao = '003' OR @Versao = '004' OR @Versao = '005' THEN '||' ELSE '' END,
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
	AND tbDocumento.CodigoModeloNotaFiscal in (6,28)
	AND tbDocumento.EspecieDocumento	<> 'ECF'
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
CONVERT(VARCHAR(4),tbItemDocumento.CodigoCFO) + '|' +
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
	AND tbDocumento.CodigoModeloNotaFiscal in (6,28)
	AND tbDocumento.EspecieDocumento	<> 'ECF'
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
tbDocumento.TipoLancamentoMovimentacao

----

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
'|D100|' + 
CASE WHEN tbDocumento.EntradaSaidaDocumento = 'E' THEN
	'0'
ELSE
	'1'
END + '|' +
'1|' +
CONVERT(VARCHAR(14),tbDocumento.CodigoCliFor) + '|' + 
RIGHT(CONVERT(VARCHAR(3),100 + tbDocumento.CodigoModeloNotaFiscal),2) + '|' +
'00' + '|' +
RTRIM(LTRIM(CONVERT(VARCHAR(3),COALESCE(tbDocumento.SerieDocumento,'')))) + '|' +
'' + '|' +
CONVERT(VARCHAR(9),tbDocumento.NumeroDocumento) + '|' +
RTRIM(LTRIM(COALESCE(tbDocumentoNFe.ChaveAcessoNFe,''))) + '|' +
COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDocumento.DataEmissaoDocumento)),2,2) +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDocumento.DataEmissaoDocumento)),2,2) +
CONVERT(CHAR(4),DATEPART(year,tbDocumento.DataEmissaoDocumento)),'') + '|' +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbDocumento.DataDocumento)),2,2) +
SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbDocumento.DataDocumento)),2,2) +
CONVERT(CHAR(4),DATEPART(year,tbDocumento.DataDocumento)) + '|' +
'' + '|' +
'' + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorContabilDocumento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.TotalDescontoDocumento),'.',',') + '|' +
COALESCE(CONVERT(CHAR(1),tbDocumentoFT.TipoFreteDocFT),'2') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorContabilDocumento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorBaseICMS1Documento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorICMSDocumento),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),tbDocumento.ValorBaseICMS3Documento),'.',',') + '|' +
'' + '|' +
'' + '|',
'D100',
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
	AND tbDocumento.CodigoModeloNotaFiscal IN (7,8,9,10,11,26,27,57)
	AND tbDocumento.EspecieDocumento	<> 'ECF'
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

INSERT rtSPEDFiscal
SELECT
@@spid,
'|D190|' + 
'010' + '|' +
--RIGHT(('000' + RTRIM(LTRIM(COALESCE(CodigoTributacaoNaturezaOper,'000')))),3) + '|' +
CONVERT(VARCHAR(4),tbItemDocumento.CodigoCFO) + '|' +
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
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal
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
	AND tbDocumento.CodigoModeloNotaFiscal IN (7,8,9,10,11,26,27,57)
	AND tbDocumento.EspecieDocumento	<> 'ECF'
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
tbDocumento.TipoLancamentoMovimentacao

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
RTRIM(LTRIM(CONVERT(VARCHAR(3),COALESCE(tbDocumento.SerieDocumento,'')))) + '|' +
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
'' + '|' + 
CASE WHEN @Versao = '003' or @Versao = '004' or @Versao = '005' THEN '1|' ELSE '' END,
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
	AND tbDocumento.EspecieDocumento	<> 'ECF'
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
CONVERT(VARCHAR(4),tbItemDocumento.CodigoCFO) + '|' +
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
INNER JOIN tbLocalLF (NOLOCK) ON
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalLF.CodigoLocal = @CodigoLocal
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
	AND tbDocumento.EspecieDocumento	<> 'ECF'
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
tbDocumento.TipoLancamentoMovimentacao

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
'|E110|' +
REPLACE(CONVERT(VARCHAR(16),@ICMSSaidas),'.',',') + '|' +
'0,00|' + 
REPLACE(CONVERT(VARCHAR(16),( OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 )),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),( EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 )),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),@ICMSEntradas),'.',',') + '|' +
'0,00|' + 
REPLACE(CONVERT(VARCHAR(16),( OutrosCreditosValor1 + OutrosCreditosValor2 + OutrosCreditosValor3 + OutrosCreditosValor4 )),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),( EstornosDebitosValor1 + EstornosDebitosValor2 + EstornosDebitosValor3 + EstornosDebitosValor4 )),'.',',') + '|' +
REPLACE(CONVERT(VARCHAR(16),SaldoAnterior),'.',',') + '|' +
CASE WHEN ( @ICMSSaidas + OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 - @ICMSEntradas - OutrosCreditosValor1 - OutrosCreditosValor2 - OutrosCreditosValor3 - OutrosCreditosValor4 - EstornosDebitosValor1 - EstornosDebitosValor2 - EstornosDebitosValor3 - EstornosDebitosValor4 - SaldoAnterior ) > 0 THEN
	REPLACE(CONVERT(VARCHAR(16),( @ICMSSaidas + OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 - @ICMSEntradas - OutrosCreditosValor1 - OutrosCreditosValor2 - OutrosCreditosValor3 - OutrosCreditosValor4 - EstornosDebitosValor1 - EstornosDebitosValor2 - EstornosDebitosValor3 - EstornosDebitosValor4 - SaldoAnterior)),'.',',') 
ELSE
	'0,00'
END + '|' +
REPLACE(CONVERT(VARCHAR(16),( DeducoesValor1 + DeducoesValor2 + DeducoesValor3 + DeducoesValor4)),'.',',') + '|'  +
CASE WHEN ( @ICMSSaidas + OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 - @ICMSEntradas - OutrosCreditosValor1 - OutrosCreditosValor2 - OutrosCreditosValor3 - OutrosCreditosValor4 - EstornosDebitosValor1 - EstornosDebitosValor2 - EstornosDebitosValor3 - EstornosDebitosValor4 - SaldoAnterior ) - ( DeducoesValor1 + DeducoesValor2 + DeducoesValor3 + DeducoesValor4) > 0 THEN
	REPLACE(CONVERT(VARCHAR(16), ( ( @ICMSSaidas + OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 - @ICMSEntradas - OutrosCreditosValor1 - OutrosCreditosValor2 - OutrosCreditosValor3 - OutrosCreditosValor4 - EstornosDebitosValor1 - EstornosDebitosValor2 - EstornosDebitosValor3 - EstornosDebitosValor4 - SaldoAnterior ) - ( DeducoesValor1 + DeducoesValor2 + DeducoesValor3 + DeducoesValor4))),'.',',') 
ELSE
	'0,00'
END + '|' +
CASE WHEN ( SaldoAnterior - ( @ICMSSaidas + OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 ) + ( @ICMSEntradas + OutrosCreditosValor1 + OutrosCreditosValor2 + OutrosCreditosValor3 + OutrosCreditosValor4 + EstornosDebitosValor1 + EstornosDebitosValor2 + EstornosDebitosValor3 + EstornosDebitosValor4 ) - DeducoesValor1 - DeducoesValor2 - DeducoesValor3 - DeducoesValor4 ) > 0 THEN
	REPLACE(CONVERT(VARCHAR(16),( SaldoAnterior - ( @ICMSSaidas + OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 ) + ( @ICMSEntradas + OutrosCreditosValor1 + OutrosCreditosValor2 + OutrosCreditosValor3 + OutrosCreditosValor4 + EstornosDebitosValor1 + EstornosDebitosValor2 + EstornosDebitosValor3 + EstornosDebitosValor4 ) - DeducoesValor1 - DeducoesValor2 - DeducoesValor3 - DeducoesValor4 ) ),'.',',')
ELSE
	'0,00'
END + '|' + 
CASE WHEN NOT EXISTS ( SELECT 1 FROM #tmpE110 ) THEN
	'0,00' + '|'
ELSE
	REPLACE(CONVERT(VARCHAR(16),COALESCE(( SELECT SUM(ValorICMS) FROM #tmpE110),0) ),'.',',') + '|'
END,
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

DROP TABLE #tmpE110

--- E111
DECLARE @SequenciaE111 numeric(2)

SELECT @SequenciaE111 = 0

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
END + 
'|AJUSTES DEBITOS|' + 
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
END + 
'|AJUSTES DEBITOS|' + 
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
END + 
'|AJUSTES DEBITOS|' + 
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
END + 
'|AJUSTES DEBITOS|' + 
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
			EstornosCreditosValor1 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos)) = '' THEN
	tbLocal.UFLocal + '0' + '1' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoEstornoCreditos))
END + 
'|ESTORNO CREDITOS|' + 
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
END + 
'|ESTORNO CREDITOS|' + 
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
END + 
'|ESTORNO CREDITOS|' + 
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
END + 
'|ESTORNO CREDITOS|' + 
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
			OutrosCreditosValor1 <> 0 ) SELECT @SequenciaE111 = @SequenciaE111 + 1

INSERT rtSPEDFiscal
SELECT
@@spid,
'|E111|' +
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos)) = '' THEN
	tbLocal.UFLocal + '0' + '2' + '000' + CONVERT(VARCHAR(1),@SequenciaE111) 
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoOutrosCreditos))
END +
'|AJUSTES CREDITOS|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosCreditosValor1),'.',',') + '|',
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
END +
'|AJUSTES CREDITOS|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosCreditosValor2),'.',',') + '|',
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
END +
'|AJUSTES CREDITOS|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosCreditosValor3),'.',',') + '|',
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
END +
'|AJUSTES CREDITOS|' + 
REPLACE(CONVERT(VARCHAR(16),OutrosCreditosValor4),'.',',') + '|',
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
OutrosCreditosValor4 <> 0

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
END  + 
'|ESTORNO DEBITOS|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosDebitosValor1),'.',',') + '|',
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
END  + 
'|ESTORNO DEBITOS|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosDebitosValor2),'.',',') + '|',
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
END  + 
'|ESTORNO DEBITOS|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosDebitosValor3),'.',',') + '|',
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
END  + 
'|ESTORNO DEBITOS|' + 
REPLACE(CONVERT(VARCHAR(16),EstornosDebitosValor4),'.',',') + '|',
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
EstornosDebitosValor4 <> 0

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
END + 
'|DEDUCOES|' + 
REPLACE(CONVERT(VARCHAR(16),DeducoesValor1),'.',',') + '|',
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
END + 
'|DEDUCOES|' + 
REPLACE(CONVERT(VARCHAR(16),DeducoesValor2),'.',',') + '|',
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
DeducoesValor2 <> 0

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
CASE WHEN RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes3)) = '' THEN
	tbLocal.UFLocal + '0' + '4' + '000' + CONVERT(VARCHAR(1),@SequenciaE111)
ELSE
	RTRIM(LTRIM(tbMovimentacaoIPIICMS.CodigoDeducoes3))
END + 
'|DEDUCOES|' + 
REPLACE(CONVERT(VARCHAR(16),DeducoesValor3),'.',',') + '|',
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
END + 
'|DEDUCOES|' + 
REPLACE(CONVERT(VARCHAR(16),DeducoesValor4),'.',',') + '|',
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
DeducoesValor4 <> 0

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
CASE WHEN @Versao <> '004' AND @Versao <> '005' THEN
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

IF EXISTS ( SELECT 1 FROM rtSPEDFiscal where Spid = @@spid AND TipoRegistro = 'E110' )
BEGIN
	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|E001|0|',
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
END
ELSE
BEGIN
	INSERT rtSPEDFiscal
	SELECT 
	@@spid,
	'|E001|1|',
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
END

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
	CASE WHEN @Versao <> '004' AND @Versao <> '005' THEN
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
    tbItemDocumento.ValorContabilItemDocto <> 0 AND
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
	tbItemDocumento.ValorContabilItemDocto <> 0 AND
    tbItemDocumento.EntradaSaidaDocumento = 'E' AND
	tbDocumento.CondicaoNFCancelada <> 'V'


	IF @CreIPI IS NULL SELECT @CreIPI = 0
	IF @DebIPI IS NULL SELECT @DebIPI = 0

	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|E510|' + 
	CONVERT(VARCHAR(4),tbItemDocumento.CodigoCFO) + '|' + 
    CONVERT(VARCHAR(2),COALESCE(tbItemDocumentoFT.CSTIPI,'')) + '|' +
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
	tbItemDocumento.ValorContabilItemDocto <> 0 AND
	tbDocumento.CondicaoNFCancelada <> 'V'
	GROUP BY
	tbItemDocumento.CodigoCFO,
    tbItemDocumentoFT.CSTIPI

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|E520|' +
	REPLACE(CONVERT(VARCHAR(16),SaldoAnterior),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),@DebIPI),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),@CreIPI),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),( OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4)),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),( OutrosCreditosValor1 + OutrosCreditosValor2 + OutrosCreditosValor3 + OutrosCreditosValor4 +  EstornosDebitosValor1 + EstornosDebitosValor2 + EstornosDebitosValor3 + EstornosDebitosValor4)),'.',',') + '|' +
	CASE WHEN ( @DebIPI + OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 - @CreIPI - OutrosCreditosValor1 - OutrosCreditosValor2 - OutrosCreditosValor3 - OutrosCreditosValor4 - EstornosDebitosValor1 - EstornosDebitosValor2 - EstornosDebitosValor3 - EstornosDebitosValor4 - SaldoAnterior ) < 0 THEN
		REPLACE(CONVERT(VARCHAR(16), ( ABS(( @DebIPI + OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 - @CreIPI - OutrosCreditosValor1 - OutrosCreditosValor2 - OutrosCreditosValor3 - OutrosCreditosValor4 - EstornosDebitosValor1 - EstornosDebitosValor2 - EstornosDebitosValor3 - EstornosDebitosValor4 - SaldoAnterior ) - ( DeducoesValor1 + DeducoesValor2 + DeducoesValor3 + DeducoesValor4)))),'.',',') + '|0,00|'
	ELSE
		'0,00|'  +REPLACE(CONVERT(VARCHAR(16), ( ABS(( @DebIPI + OutrosDebitosValor1 + OutrosDebitosValor2 + OutrosDebitosValor3 + OutrosDebitosValor4 + EstornosCreditosValor1 + EstornosCreditosValor2 + EstornosCreditosValor3 + EstornosCreditosValor4 - @CreIPI - OutrosCreditosValor1 - OutrosCreditosValor2 - OutrosCreditosValor3 - OutrosCreditosValor4 - EstornosDebitosValor1 - EstornosDebitosValor2 - EstornosDebitosValor3 - EstornosDebitosValor4 - SaldoAnterior ) - ( DeducoesValor1 + DeducoesValor2 + DeducoesValor3 + DeducoesValor4)))),'.',',') + '|'
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
REPLACE(CONVERT(VARCHAR(16),( SELECT SUM(CONVERT(NUMERIC(16,2),CustoTotal)) FROM rtRegistroInventario WHERE Spid = @@spid )),'.',',') + '|',
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
	DELETE rtRegistroInventario WHERE Spid = @@spid
END

IF EXISTS ( SELECT 1 FROM rtSPEDFiscal WHERE TipoRegistro = 'H005' )
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
rtRegistroInventario.CodigoLinhaProduto in (9990,9991,9995,9996,9997,9998,9999)

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
	END + '|',
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
	Spid = @@spid
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
	END + '|',
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
	Spid = @@spid
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
INSERT rtSPEDFiscal
SELECT
@@spid,
'|1001|1|',
'K001',
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
'K002',
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
---- CIAP

IF @GerarCIAP = 'V' 
BEGIN
	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|0300|' +
	CONVERT(VARCHAR(8),CodigoItemPatrimonial) + CONVERT(VARCHAR(4),SequenciaItemPatrimonial) + '|' +
	'1|' +
	RTRIM(LTRIM(DescricaoItemPatrimonial)) + '|' +
	'|' +
	RTRIM(LTRIM(ContaItemRegraContabilItemAF)) + '|' +
	'48|' ,
	'0300',
	'E',
	0,
	DataAquisicaoItem,
	CONVERT(NUMERIC(14),CONVERT(VARCHAR(8),CodigoItemPatrimonial) + CONVERT(VARCHAR(4),SequenciaItemPatrimonial)),
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
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) <= 48 AND
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
	CONVERT(NUMERIC(14),CONVERT(VARCHAR(8),CodigoItemPatrimonial) + CONVERT(VARCHAR(4),SequenciaItemPatrimonial)),
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
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) <= 48 AND
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
		REPLACE(CONVERT(VARCHAR(16),(CONVERT(NUMERIC(16,4),(ValorSaidasTributadas / ValorSaidas)))),'.',',') + '|'
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
	CONVERT(VARCHAR(8),CodigoItemPatrimonial) + CONVERT(VARCHAR(4),SequenciaItemPatrimonial) + '|' +
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
		'SI'
	ELSE
		'IM'
	END	+ '|' + 
	REPLACE(CONVERT(VARCHAR(16),tbControleICMSAtivo.ValorCreditoICMSAtivo),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),tbControleICMSAtivo.ValorICMSST),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),tbControleICMSAtivo.ValorICMSFrete),'.',',') + '|' +
	REPLACE(CONVERT(VARCHAR(16),COALESCE(CONVERT(NUMERIC(16,2),tbControleICMSAtivo.ValorICMSDifAliquota),0.00)),'.',',') + '|' +
	CONVERT(VARCHAR(3),DATEDIFF(MONTH,DataAquisicaoItem,@DataInicial) + 1) + '|' + 
	REPLACE(CONVERT(VARCHAR(16),( tbControleICMSAtivo.ValorCreditoICMSAtivo / 48 )),'.',',') + '|',
	'G125',
	'E',
	0,
	@DataInicial,
	CONVERT(NUMERIC(14),CONVERT(VARCHAR(8),CodigoItemPatrimonial) + CONVERT(VARCHAR(4),SequenciaItemPatrimonial)),
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
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) <= 48 AND
    tbItemPatrimonial.DataBaixaItem IS NULL 

	--- Baixa do Item

	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|G125|' + 
	CONVERT(VARCHAR(8),CodigoItemPatrimonial) + CONVERT(VARCHAR(4),SequenciaItemPatrimonial) + '|' +
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbItemPatrimonial.DataBaixaItem)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbItemPatrimonial.DataBaixaItem)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbItemPatrimonial.DataBaixaItem)),'') + '|' +
	'OT' + '|' + 
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
	CONVERT(NUMERIC(14),CONVERT(VARCHAR(8),CodigoItemPatrimonial) + CONVERT(VARCHAR(4),SequenciaItemPatrimonial)),
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
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) <= 48 AND
    tbItemPatrimonial.DataBaixaItem BETWEEN @DataInicial AND @DataFinal

	--- Fim da Apropriacao

	--- Baixa do Item

	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|G125|' + 
	CONVERT(VARCHAR(8),CodigoItemPatrimonial) + CONVERT(VARCHAR(4),SequenciaItemPatrimonial) + '|' +
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataFinal)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataFinal)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,@DataFinal)),'') + '|' +
	'BA' + '|' + 
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
	CONVERT(NUMERIC(14),CONVERT(VARCHAR(8),CodigoItemPatrimonial) + CONVERT(VARCHAR(4),SequenciaItemPatrimonial)),
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
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) = 48 

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
	RTRIM(LTRIM(COALESCE(( SELECT MIN(SerieDocumento) FROM tbDocumento (NOLOCK)
	           WHERE
			   tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
	           tbDocumento.CodigoLocal = @CodigoLocal AND
	           tbDocumento.EntradaSaidaDocumento = 'E' AND 
			   tbDocumento.CodigoCliFor = tbItemPatrimonial.CodigoCliFor AND
 	           tbDocumento.NumeroDocumento = tbItemPatrimonial.NumeroDoctoAquisicaoItem AND 
	           tbDocumento.DataDocumento = tbItemPatrimonial.DataAquisicaoItem ),''))) + '|' +
	CONVERT(VARCHAR(6),tbItemPatrimonial.NumeroDoctoAquisicaoItem) + '|' + 
	RTRIM(LTRIM(COALESCE(tbDocumentoNFe.ChaveAcessoNFe,''))) + '|' +
	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbItemPatrimonial.DataAquisicaoItem)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbItemPatrimonial.DataAquisicaoItem)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbItemPatrimonial.DataAquisicaoItem)),'') + '|',
	'G130',
	'E',
	0,
	@DataInicial,
	CONVERT(NUMERIC(14),CONVERT(VARCHAR(8),CodigoItemPatrimonial) + CONVERT(VARCHAR(4),SequenciaItemPatrimonial)),
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
              tbDocumentoNFe.NumeroDocumento = tbItemPatrimonial.NumeroDoctoAquisicaoItem AND
              tbDocumentoNFe.TipoLancamentoMovimentacao = 7   
	WHERE 
    tbControleICMSAtivo.CodigoEmpresa = @CodigoEmpresa AND
	tbControleICMSAtivo.CodigoLocal = @CodigoLocal AND
	tbItemPatrimonial.DataAquisicaoItem <= @DataFinal AND
	ValorCreditoICMSAtivo <> 0 AND
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) <= 48 AND
    ( tbItemPatrimonial.DataBaixaItem IS NULL OR tbItemPatrimonial.DataBaixaItem BETWEEN @DataInicial AND @DataFinal )

	INSERT rtSPEDFiscal
	SELECT DISTINCT
	@@spid,
	'|G140|1|' + 
	CONVERT(VARCHAR(8),CodigoItemPatrimonial) + CONVERT(VARCHAR(4),SequenciaItemPatrimonial) + '|',
	'G140',
	'E',
	0,
	@DataInicial,
	CONVERT(NUMERIC(14),CONVERT(VARCHAR(8),CodigoItemPatrimonial) + CONVERT(VARCHAR(4),SequenciaItemPatrimonial)),
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
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) <= 48 AND
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
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) <= 48 AND
    ( tbItemPatrimonial.DataBaixaItem IS NULL OR tbItemPatrimonial.DataBaixaItem BETWEEN @DataInicial AND @DataFinal )

	SELECT
           @SomaParcelas = SUM(tbControleICMSAtivo.ValorCreditoICMSAtivo / 48)
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
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) <= 48 AND
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
				REPLACE(Linha,'ICMSAPROP',REPLACE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),( @SomaParcelas * CONVERT(NUMERIC(16,4),( ValorSaidasTributadas / ValorSaidas ))))),'.',','))
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

---- Tabelas Basicas

INSERT rtSPEDFiscal
SELECT
@@spid,
'|0150|' +
CONVERT(VARCHAR(14),tbCliFor.CodigoCliFor) + '|' +
RTRIM(LTRIM(CONVERT(VARCHAR(60),tbCliFor.NomeCliFor))) + '|' +
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
getdate(),
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
               rtSPEDFiscal.TipoRegistro IN ('C100','C500','D100','D500') AND
			   rtSPEDFiscal.CodigoCliFor = tbCliFor.CodigoCliFor AND
               rtSPEDFiscal.CodigoClienteEventual = 0 )
------
AND tbCliFor.ClienteEventual <> 'V'

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
getdate(),
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
	RTRIM(LTRIM(CONVERT(VARCHAR(60),tbCliFor.NomeCliFor))) + '|' +
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
	getdate(),
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
	DATEDIFF(MONTH,tbItemPatrimonial.DataAquisicaoItem,@DataInicial) <= 48 AND
	( tbItemPatrimonial.DataBaixaItem IS NULL OR tbItemPatrimonial.DataBaixaItem BETWEEN @DataInicial AND @DataFinal ) AND
	NOT EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK)
				 WHERE rtSPEDFiscal.Spid = @@spid AND
				   rtSPEDFiscal.TipoRegistro = '0150' AND
				   rtSPEDFiscal.CodigoCliFor = tbItemPatrimonial.CodigoCliFor )
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

INSERT rtSPEDFiscal
SELECT
@@spid,
'|0200|' +
RTRIM(LTRIM(tbProduto.CodigoProduto)) + '|' +
RTRIM(LTRIM(tbProduto.DescricaoProduto)) + '|' +
COALESCE(RTRIM(LTRIM(tbProdutoFT.CodigoBarrasProduto)),'') + '|' +
'|' +
RTRIM(LTRIM(CodigoUnidadeProduto)) + '|' +
'00|' +
RTRIM(LTRIM(CONVERT(VARCHAR(8),tbProduto.CodigoClassificacaoFiscal))) + '|' +
CASE WHEN LEN(RTRIM(LTRIM(tbProduto.CodigoClassificacaoFiscal))) = 10 THEN
	RIGHT(RTRIM(LTRIM(tbProduto.CodigoClassificacaoFiscal)),2)
ELSE
	''
END + '|' +
'|' + 
'|' +
'|',
'0200',
'E',
0,
getdate(),
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
INNER JOIN tbPercentual (NOLOCK) ON
           tbPercentual.UFDestino = tbLocal.UFLocal AND
           tbPercentual.UFOrigem  = tbLocal.UFLocal
WHERE
tbProduto.CodigoEmpresa = @CodigoEmpresa AND
EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
         WHERE
         rtSPEDFiscal.Spid = @@spid AND
         rtSPEDFiscal.CodigoProduto = tbProduto.CodigoProduto )

INSERT rtSPEDFiscal
SELECT DISTINCT
@@spid,
'|0200|' +
RTRIM(LTRIM(NumeroChassisCV)) + '|' +
RTRIM(LTRIM(tbVeiculoCV.ModeloVeiculo)) + '|' +
'|' +
'|' +
'UN' + '|' +
'00|' +
COALESCE(CONVERT(VARCHAR(8),tbModeloVeiculoCV.CodigoClassificacaoFiscal),'') + '|' +
CASE WHEN LEN(RTRIM(LTRIM(tbModeloVeiculoCV.CodigoClassificacaoFiscal))) = 10 THEN
	RIGHT(RTRIM(LTRIM(tbModeloVeiculoCV.CodigoClassificacaoFiscal)),2)
ELSE
	''
END + '|' +
'|' + 
'|' +
'' + '|',
'0200',
'E',
0,
getdate(),
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
WHERE 
tbVeiculoCV.CodigoEmpresa = @CodigoEmpresa AND
tbVeiculoCV.CodigoLocal = @CodigoLocal AND
EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
         WHERE 
         rtSPEDFiscal.Spid = @@spid AND
         rtSPEDFiscal.CodigoProduto = NumeroChassisCV ) 

INSERT rtSPEDFiscal
SELECT
@@spid,
'|0200|' +
RTRIM(LTRIM(tbMaoObraOS.CodigoMaoObraOS)) + '|' +
RTRIM(LTRIM(tbMaoObraOS.DescricaoMaoObraOS)) + '|' +
'|' +
'|' +
'HR' + '|' +
'09|' +
'|' +
'|' +
'|' + 
RTRIM(LTRIM(COALESCE(CodigoServicoFederal,''))) + '|' +
'|', 
'0200',
'E',
0,
getdate(),
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

INSERT rtSPEDFiscal
SELECT DISTINCT
@@spid,
'|0200|' +
RTRIM(LTRIM(CodigoItemDocto)) + '|' +
RTRIM(LTRIM(CodigoItemDocto)) + '|' +
'|' +
'|' +
'UN' + '|' +
CASE WHEN tbNaturezaOperacao.CodigoNaturezaOperacao IS NOT NULL AND tbNaturezaOperacao.CodigoTipoOperacao in (10,12) THEN
	'07|'
ELSE
	'09|'
END +
COALESCE(CONVERT(VARCHAR(8),tbItemDocumento.CodigoClassificacaoFiscal),'') + '|' +
CASE WHEN LEN(RTRIM(LTRIM(tbItemDocumento.CodigoClassificacaoFiscal))) = 10 THEN
	RIGHT(RTRIM(LTRIM(tbItemDocumento.CodigoClassificacaoFiscal)),2)
ELSE
	''
END + '|' +
'|' + 
'|' +
'' + '|',
'0200',
'E',
0,
getdate(),
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
WHERE 
tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
CodigoLocal = @CodigoLocal AND
CodigoItemDocto IS NOT NULL AND
DataDocumento between @DataInicial AND @DataFinal AND
( TipoRegistroItemDocto IN ('MOB','OUT') OR TipoRegistroItemDocto IS NULL ) AND
EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
         WHERE
         rtSPEDFiscal.Spid = @@spid AND
         rtSPEDFiscal.CodigoProduto = CodigoItemDocto ) AND
NOT EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
			 WHERE
             rtSPEDFiscal.Spid = @@spid AND
			 rtSPEDFiscal.CodigoProduto = CodigoItemDocto AND
             rtSPEDFiscal.TipoRegistro = '0200' ) 

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
'|', 
'0200',
'E',
0,
getdate(),
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

IF @GerarCIAP = 'V'
BEGIN

	INSERT rtSPEDFiscal
	SELECT
	@@spid,
	'|0200|' +
	CONVERT(VARCHAR(14),CONVERT(NUMERIC(14),CONVERT(VARCHAR(8),CodigoItemPatrimonial) + CONVERT(VARCHAR(4),SequenciaItemPatrimonial))) + '|' +
	RTRIM(LTRIM(tbItemPatrimonial.DescricaoItemPatrimonial)) + '|' +
	COALESCE(RTRIM(LTRIM(tbItemPatrimonial.EANItemPatrimonial)),'') + '|' +
	'|' +
	'UN|' +
	'00|' +
	'|' +
	'|' +
	'|' + 
	'|' +
	'|',
	'0200',
	'E',
	0,
	getdate(),
	0,
	0,
	6,
	CONVERT(VARCHAR(14),CONVERT(NUMERIC(14),CONVERT(VARCHAR(8),CodigoItemPatrimonial) + CONVERT(VARCHAR(4),SequenciaItemPatrimonial))),
	0,
	'',
	0
	FROM tbItemPatrimonial (NOLOCK)
	WHERE
	tbItemPatrimonial.CodigoEmpresa = @CodigoEmpresa AND
	tbItemPatrimonial.CodigoLocal = @CodigoLocal AND
	EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
			 WHERE
			 rtSPEDFiscal.TipoRegistro = 'G140' AND
			 rtSPEDFiscal.Spid = @@spid AND
			 rtSPEDFiscal.CodigoCliFor = CONVERT(NUMERIC(14),CONVERT(VARCHAR(8),CodigoItemPatrimonial) + CONVERT(VARCHAR(4),SequenciaItemPatrimonial))) AND
	NOT EXISTS ( SELECT 1 FROM rtSPEDFiscal (NOLOCK) 
			 WHERE
             rtSPEDFiscal.Spid = @@spid AND
			 rtSPEDFiscal.CodigoProduto = CONVERT(VARCHAR(14),CONVERT(NUMERIC(14),CONVERT(VARCHAR(8),CodigoItemPatrimonial) + CONVERT(VARCHAR(4),SequenciaItemPatrimonial))) AND
             rtSPEDFiscal.TipoRegistro = '0200' ) 


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
'|9900|0460|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDFiscal WHERE Spid = @@spid and TipoRegistro = '0460' )) + '|',
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

IF @GerarCIAP = 'V' 
BEGIN
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
190,
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
320,
'',
0,
'',
0

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
SELECT Linha FROM rtSPEDFiscal
WHERE
Spid = @@spid
ORDER BY 
LEFT(TipoRegistro,2),
Ordem,
EntradaSaida,
NumeroDocumento,
DataDocumento,
CodigoCliFor,
TipoLancamentoMovimentacao,
TipoRegistro

SET NOCOUNT OFF
SET ANSI_WARNINGS ON

DELETE rtSPEDFiscal WHERE Spid = @@spid

GO
GRANT EXECUTE ON whSPEDFiscal TO SQLUsers
GO
