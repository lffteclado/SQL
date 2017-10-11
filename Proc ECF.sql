IF object_id('rtBalSPEDECF') IS NOT NULL
	DROP TABLE rtBalSPEDECF
GO
CREATE TABLE rtBalSPEDECF (
	RazaoSocialEmpresa char(60),
	CodigoLocal numeric(4),
	DescricaoLocal varchar(30),
	CentroCusto numeric(8),
	DescricaoCentroCusto varchar(30),
	CodigoContaContabil char(12),
	Digito numeric(4),
	DescricaoContaContabil varchar(50),
	SaldoAnterior dtValorMonetario,
	D01 dtValorMonetario,
	C01 dtValorMonetario,
	D02 dtValorMonetario,
	C02 dtValorMonetario,
	D03 dtValorMonetario,
	C03 dtValorMonetario,
	D04 dtValorMonetario,
	C04 dtValorMonetario,
	D05 dtValorMonetario,
	C05 dtValorMonetario,
	D06 dtValorMonetario,
	C06 dtValorMonetario,
	D07 dtValorMonetario,
	C07 dtValorMonetario,
	D08 dtValorMonetario,
	C08 dtValorMonetario,
	D09 dtValorMonetario,
	C09 dtValorMonetario,
	D10 dtValorMonetario,
	C10 dtValorMonetario,
	D11 dtValorMonetario,
	C11 dtValorMonetario,
	D12 dtValorMonetario,
	C12 dtValorMonetario,
	SaldoAtual dtValorMonetario,
	Digito1 numeric(18),
	Digito2 numeric(18),
	Digito3 numeric(18),
	Digito4 numeric(18),
	Digito5 numeric(18),
	Numeracao numeric(10),
	GrauPlanoConta char(1)
)
IF object_id('rtBalSPEDECF_DRE') IS NOT NULL
	DROP TABLE rtBalSPEDECF_DRE
GO
CREATE TABLE rtBalSPEDECF_DRE (
	RazaoSocialEmpresa char(60),
	CodigoLocal numeric(4),
	DescricaoLocal varchar(30),
	CentroCusto numeric(8),
	DescricaoCentroCusto varchar(30),
	CodigoContaContabil char(12),
	Digito numeric(4),
	DescricaoContaContabil varchar(50),
	SaldoAnterior dtValorMonetario,
	D01 dtValorMonetario,
	C01 dtValorMonetario,
	D02 dtValorMonetario,
	C02 dtValorMonetario,
	D03 dtValorMonetario,
	C03 dtValorMonetario,
	D04 dtValorMonetario,
	C04 dtValorMonetario,
	D05 dtValorMonetario,
	C05 dtValorMonetario,
	D06 dtValorMonetario,
	C06 dtValorMonetario,
	D07 dtValorMonetario,
	C07 dtValorMonetario,
	D08 dtValorMonetario,
	C08 dtValorMonetario,
	D09 dtValorMonetario,
	C09 dtValorMonetario,
	D10 dtValorMonetario,
	C10 dtValorMonetario,
	D11 dtValorMonetario,
	C11 dtValorMonetario,
	D12 dtValorMonetario,
	C12 dtValorMonetario,
	SaldoAtual dtValorMonetario,
	Digito1 numeric(18),
	Digito2 numeric(18),
	Digito3 numeric(18),
	Digito4 numeric(18),
	Digito5 numeric(18),
	Numeracao numeric(10),
	GrauPlanoConta char(1)
)
IF EXISTS ( SELECT 1 FROM sysobjects WHERE name = 'rtSPEDECF' )
	DROP TABLE dbo.rtSPEDECF
GO
CREATE TABLE dbo.rtSPEDECF
(
	Spid			NUMERIC(8),
	Linha			VARCHAR(8000), 
	TipoRegistro	CHAR(4),
	Ordem			NUMERIC(3),
	Chave			VARCHAR(100)
)
GO
IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('whSPEDECF'))
	DROP PROCEDURE dbo.whSPEDECF
GO
CREATE PROCEDURE dbo.whSPEDECF

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-SYSTEMS
 PROJETO......: Contabilidade Geral 
 AUTOR........: Mizael
 DATA.........: 03/07/2014
 UTILIZADO EM : SPED ECF - Escrituração Contábil Fiscal
 OBJETIVO.....: 

whSPEDECF 1608,-1,'2014-01-01','2014-12-31','F'
whSPEDECF 1608,-1,'2015-01-01','2015-12-31','V','F','F'
whSPEDECF 1608,-1,'2016-01-01','2016-12-31','V','F','F'
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa 		NUMERIC(4),
@CodigoLocal		NUMERIC(4),
@DataInicial		DATETIME,
@DataFinal			DATETIME,
@RecuperarECD		CHAR(1),
@ExtincaoRTT2014	CHAR(1),
@DifContabilFCont	CHAR(1)

WITH ENCRYPTION

AS 

SET NOCOUNT ON
SET ANSI_WARNINGS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @Versao				VARCHAR(6)
DECLARE @GrauAnalitica		CHAR(1)

SELECT	@Versao = '0001'
IF DATEPART(YEAR,@DataFinal) >= 2015 SELECT @Versao = '0002'
IF DATEPART(YEAR,@DataFinal) >= 2016 SELECT @Versao = '0003'

SELECT @GrauAnalitica = '6'
IF EXISTS ( SELECT 1 FROM tbEmpresaCG 
            WHERE
            CodigoEmpresa = @CodigoEmpresa AND
			NumeroDigitosGrau5 = 0 ) SELECT @GrauAnalitica = '5'
			
TRUNCATE TABLE rtSPEDECF

-----------------------------------------------------------------------
--- Bloco 0
-----------------------------------------------------------------------
INSERT rtSPEDECF
SELECT 
@@spid,
	'|0000|'
+	'LECF' + '|'
+	@Versao + '|'
+	tbLocal.CGCLocal + '|'
+	CONVERT(VARCHAR(60),RTRIM(LTRIM(tbEmpresa.RazaoSocialEmpresa))) + '|'
+	SituacaoInicioPeriodo + '|'
+	SituacaoEspecial + '|'
+	CASE WHEN SituacaoEspecial = '6' THEN CONVERT(VARCHAR(3),PatrimonioCisao) ELSE '' END + '|'
+	CASE WHEN SituacaoEspecial = '0' THEN
		''
	ELSE
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,DataSitEspecial)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,DataSitEspecial)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,DataSitEspecial)) 
	END + '|' 
+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,DataInicial)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,DataInicial)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,DataInicial)) + '|' 
+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,DataFinal)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,DataFinal)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,DataFinal)) + '|' 
+	CASE WHEN Finalidade = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN Finalidade = 'V' THEN HashSubstituida ELSE '' END + '|'
+	TipoECF + '|'
+	CASE WHEN TipoECF <> '2' THEN '' ELSE RIGHT('00000000000000' + COALESCE(CONVERT(VARCHAR(14),CodigoSCP),'0'),14) END + '|',
'0000',
0,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN	tbEmpresa (NOLOCK) ON
			tbEmpresa.CodigoEmpresa = tbSPEDECF.CodigoEmpresa
INNER JOIN	tbLocal (NOLOCK) ON
			tbLocal.CodigoEmpresa	= tbSPEDECF.CodigoEmpresa AND
			( 
			  ( tbLocal.CodigoLocal = tbSPEDECF.CodigoLocal ) OR 
			  ( tbLocal.CodigoLocal = 0 AND tbSPEDECF.CodigoLocal = -1 )
			)
WHERE
tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa AND
tbSPEDECF.CodigoLocal	= @CodigoLocal AND
tbSPEDECF.DataInicial	= @DataInicial AND
tbSPEDECF.DataFinal		= @DataFinal


INSERT rtSPEDECF
SELECT 
@@spid,
	'|0010|'
+	'' + '|'
+	CASE WHEN OptanteREFIS = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN OptantePAES = 'V' THEN 'S' ELSE 'N' END + '|'
+	FormaTributLucro + '|'
+	TrimestralAnual + '|' ---- 6
+	QualificacaoPJ + '|'   --- 7
+	FormaTributTrimestres + '|'  --- 8
+	FormaTributMeses + '|'  ---- 9
+	RTRIM(LTRIM(CASE WHEN FormaTributLucro = '5' OR FormaTributLucro = '7' THEN EscritCaixaContabil ELSE '' END)) + '|'  --- 10
+	'' + '|' --- 11
+	'' + '|' --- 12
+	'' + '|' --- 13
+   '' + '|' --- 14
/*
+	CASE WHEN @ExtincaoRTT2014 = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE DATEPART(YEAR,@DataFinal)
	WHEN 2014 THEN
		CASE WHEN @ExtincaoRTT2014 = 'V' THEN
			CASE WHEN @DifContabilFCont = 'V' THEN 'S' ELSE 'N' END
		ELSE
			''
		END
	WHEN 2015 THEN
		CASE WHEN @ExtincaoRTT2014 = 'F' THEN
			CASE WHEN @DifContabilFCont = 'V' THEN 'S' ELSE 'N' END
		ELSE
			''
		END
	ELSE
		''
	END + '|'
*/,
'0010',
0,
0
FROM tbSPEDECF (NOLOCK)
WHERE
tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa AND
tbSPEDECF.CodigoLocal	= @CodigoLocal AND
tbSPEDECF.DataInicial	= @DataInicial AND
tbSPEDECF.DataFinal		= @DataFinal


INSERT rtSPEDECF
SELECT 
@@spid,
	'|0020|'
+	RTRIM(LTRIM(CASE WHEN AliquotaCSLL15Porcento = '0' THEN '' ELSE AliquotaCSLL15Porcento END)) + '|'
+	RIGHT('000' + CONVERT(VARCHAR(3),QtdeSCP),3) + '|'
+	CASE WHEN AdmFundosClubes = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN ParticipacaoConsorcios = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN OperacaoExterior = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN OperacaoPessoaVinculada = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN EnquadradaArt58IN1312 = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN ParticipacaoExterior = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN AtividadeRural = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN LucroExploracao = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN IsenReducLucroPresumido = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN FinorFinamFunres = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN DoacaoEleitoral = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN ParticipacaoColigadas = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN VendaExportadora = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN RendimentoExterior = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN AtivosExterior = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN PJComercialExportadora = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN PagtoExterior = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN ECommerceTI = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN RoyaltiesRecebidos = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN RoyaltiesPagos = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN RendimentoServicos = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN PagamentoServicos = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN InovDesenvTecnologico = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN CapacitacaoInformatica = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN HabilitadaRepesRecapEtc = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN PoloIndManaus = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN ZonaProcessExportacao = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN AreaLivreComercio = 'V' THEN 'S' ELSE 'N' END + '|'
+   CASE WHEN @Versao >= '0003' THEN 'N|' ELSE '' END,
'0020',
0,
0
FROM tbSPEDECF (NOLOCK)
WHERE
tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa AND
tbSPEDECF.CodigoLocal	= @CodigoLocal AND
tbSPEDECF.DataInicial	= @DataInicial AND
tbSPEDECF.DataFinal		= @DataFinal


INSERT rtSPEDECF
SELECT 
@@spid,
	'|0030|'
+	RIGHT('0000' + CONVERT(VARCHAR(4),tbSPEDECF.CodigoNaturezaJuridica),4) + '|'
+	RTRIM(LTRIM(REPLACE(REPLACE(tbLocal.CodigoAtividadeEconomicaLocal,'-',''),'.',''))) + '|'
+	RTRIM(LTRIM(COALESCE(tbLocal.RuaLocal,''))) + '|'
+	RIGHT(RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(6),tbLocal.NumeroEndLocal),''))),6) + '|'
+	RTRIM(LTRIM(COALESCE(tbLocal.ComplementoEndLocal,''))) + '|'
+	RTRIM(LTRIM(tbLocal.BairroLocal)) + '|'
+	CONVERT(VARCHAR(2),tbLocal.UFLocal) + '|'
+	RIGHT(CONVERT(VARCHAR(8),RTRIM(LTRIM(tbCEP.NumeroMunicipio))),7) + '|'
+	CONVERT(VARCHAR(8),tbCEP.NumeroCEP) + '|'
+	RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(4),tbLocal.DDDLocal),''))) + 
	RIGHT(REPLACE(RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(15),tbLocal.TelefoneLocal),''))),'-',''),10) + '|'
+	RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(115),tbLocal.EmailLocal),''))) + '|',
'0030',
0,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN	tbEmpresa (NOLOCK) ON
			tbEmpresa.CodigoEmpresa = tbSPEDECF.CodigoEmpresa
INNER JOIN	tbLocal (NOLOCK) ON
			tbLocal.CodigoEmpresa	= tbSPEDECF.CodigoEmpresa AND
			( 
			  ( tbLocal.CodigoLocal = tbSPEDECF.CodigoLocal ) OR 
			  ( tbLocal.CodigoLocal = 0 AND tbSPEDECF.CodigoLocal = -1 )
			)
INNER JOIN	tbCEP (NOLOCK) ON
			tbCEP.NumeroCEP	= tbLocal.CEPLocal
INNER JOIN	tbUnidadeFederacao (NOLOCK) ON
			tbUnidadeFederacao.UnidadeFederacao	= tbLocal.UFLocal
WHERE
tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa AND
tbSPEDECF.CodigoLocal	= @CodigoLocal AND
tbSPEDECF.DataInicial	= @DataInicial AND
tbSPEDECF.DataFinal		= @DataFinal


INSERT rtSPEDECF
SELECT 
@@spid,
	'|0930|' -- SIGNATÁRIOS
+	RTRIM(LTRIM(COALESCE(tbEmpresa.NomeContadorEmpresa,''))) + '|'
+	RTRIM(LTRIM(COALESCE(tbEmpresa.CPFContadorEmpresa,''))) + '|'
+	'900' + '|'
+	RTRIM(LTRIM(COALESCE(tbEmpresa.CRCContadorEmpresa,''))) + '|'
+	RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(115),tbEmpresa.EmailContadorEmpresa),''))) + '|'
+	RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(4),tbEmpresa.DDDTelefoneContadorEmpresa),''))) +
	RIGHT(REPLACE(RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(15),tbEmpresa.TelefoneContadorEmpresa),''))),'-',''),10) + '|',
'0930',
0,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN	tbEmpresa (NOLOCK) ON
			tbEmpresa.CodigoEmpresa = tbSPEDECF.CodigoEmpresa
WHERE
tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa AND
tbSPEDECF.CodigoLocal	= @CodigoLocal AND
tbSPEDECF.DataInicial	= @DataInicial AND
tbSPEDECF.DataFinal		= @DataFinal


INSERT rtSPEDECF
SELECT 
@@spid,
	'|0930|' -- SIGNATÁRIOS
+	RTRIM(LTRIM(COALESCE(tbSPEDECF.NomeAssinante,''))) + '|'
+	RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(14),tbSPEDECF.CPFCNPJAssinante),''))) + '|'
+	RTRIM(LTRIM(COALESCE(tbSPEDECF.CodigoQualifAssinante,''))) + '|'
+	'' + '|'
+	RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(115),tbSPEDECF.EmailAssinante),''))) + '|'
+	RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(4),tbSPEDECF.DDDAssinante),''))) +
	RIGHT(REPLACE(RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(15),tbSPEDECF.TelefoneAssinante),''))),'-',''),10) + '|',
'0930',
0,
0
FROM tbSPEDECF (NOLOCK)
WHERE
tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa AND
tbSPEDECF.CodigoLocal	= @CodigoLocal AND
tbSPEDECF.DataInicial	= @DataInicial AND
tbSPEDECF.DataFinal		= @DataFinal


-----------------------------------------------------------------------
--- Bloco J
-----------------------------------------------------------------------
INSERT rtSPEDECF
SELECT
@@spid,
	'|J050|'
+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,@DataInicial)) + '|'
+	RIGHT('00' + NaturezaConta,2) + '|'
+	CASE WHEN GrauPlanoConta <> 'A' THEN 'S' ELSE 'A' END + '|'
+	CASE WHEN GrauPlanoConta <> 'A' THEN GrauPlanoConta ELSE @GrauAnalitica END + '|'
+	LTRIM(RTRIM(CodigoContaContabil)) + '|'
+	CASE WHEN CodigoContaContabil = ContaSinteticaPlanoConta THEN '' ELSE RTRIM(LTRIM(ContaSinteticaPlanoConta)) END + '|'
+	RTRIM(LTRIM(DescricaoContaContabil)) + '|',
'J050',
1,
tbPlanoContas.CodigoContaContabil
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbPlanoContas (NOLOCK) ON
	tbPlanoContas.CodigoEmpresa	= tbSPEDECF.CodigoEmpresa
WHERE
tbSPEDECF.CodigoEmpresa		= @CodigoEmpresa	AND
tbSPEDECF.CodigoLocal		= @CodigoLocal		AND
tbSPEDECF.DataInicial		= @DataInicial		AND
tbSPEDECF.DataFinal			= @DataFinal		AND
(	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4') OR
	(	tbSPEDECF.FormaTributLucro	IN ('5','7') AND
		tbSPEDECF.EscritCaixaContabil = 'C'
	)
) AND tbSPEDECF.TipoECF			<> '2'


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|J051|'
+	'' + '|'
+	RTRIM(LTRIM(ContaReferencialSPED)) + '|',
'J051',
1,
tbPlanoContas.CodigoContaContabil
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbPlanoContas (NOLOCK) ON
	tbPlanoContas.CodigoEmpresa	= tbSPEDECF.CodigoEmpresa
WHERE
tbSPEDECF.CodigoEmpresa				= @CodigoEmpresa	AND
tbSPEDECF.CodigoLocal				= @CodigoLocal		AND
tbSPEDECF.DataInicial				= @DataInicial		AND
tbSPEDECF.DataFinal					= @DataFinal		AND
tbPlanoContas.ContaReferencialSPED	IS NOT NULL			AND
tbPlanoContas.NaturezaConta			IN ('01','02','03')	AND
tbPlanoContas.GrauPlanoConta		= 'A'				AND
(	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4') OR
	(	tbSPEDECF.FormaTributLucro	IN ('5','7') AND
		tbSPEDECF.EscritCaixaContabil = 'C'
	)
) AND tbSPEDECF.TipoECF			<> '2'


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|J051|'
+	RTRIM(LTRIM(CONVERT(CHAR(8),CentroCusto))) + '|'
+	RTRIM(LTRIM(ContaReferencialSPED)) + '|',
'J051',
1,
tbPlanoContas.CodigoContaContabil
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbPlanoContas (NOLOCK) ON
	tbPlanoContas.CodigoEmpresa	= tbSPEDECF.CodigoEmpresa
INNER JOIN tbCentroCusto (NOLOCK) ON
	tbCentroCusto.CodigoEmpresa = tbSPEDECF.CodigoEmpresa
WHERE
tbSPEDECF.CodigoEmpresa				= @CodigoEmpresa	AND
tbSPEDECF.CodigoLocal				= @CodigoLocal		AND
tbSPEDECF.DataInicial				= @DataInicial		AND
tbSPEDECF.DataFinal					= @DataFinal		AND
tbPlanoContas.ContaReferencialSPED	IS NOT NULL			AND
tbPlanoContas.NaturezaConta			IN ('04')			AND
tbCentroCusto.CentroCusto			<> 0				AND
tbPlanoContas.GrauPlanoConta		= 'A'				AND
(	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4') OR
	(	tbSPEDECF.FormaTributLucro	IN ('5','7') AND
		tbSPEDECF.EscritCaixaContabil = 'C'
	)
) AND tbSPEDECF.TipoECF			<> '2'
AND EXISTS ( SELECT 1 FROM tbSaldoContaContabil Saldo
             WHERE
             Saldo.CodigoEmpresa = @CodigoEmpresa AND
             Saldo.CodigoContaContabil = tbPlanoContas.CodigoContaContabil AND
             Saldo.CentroCusto = tbCentroCusto.CentroCusto AND
             CONVERT(NUMERIC(4),LEFT(Saldo.PeriodoSaldoContaContabil,4)) = DATEPART(year,@DataInicial) AND
             (Saldo.SaldoAnteriorContaContabil + Saldo.ValorDebitoContaContabil + Saldo.ValorCreditoContaContabil) <> 0)

INSERT rtSPEDECF
SELECT
@@spid,
	'|J100|'
+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|'
+	RTRIM(LTRIM(CONVERT(CHAR(8),CentroCusto))) + '|'
+	RTRIM(LTRIM(DescricaoCentroCusto)) + '|',
'J100',
2,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbCentroCusto (NOLOCK) ON
	tbCentroCusto.CodigoEmpresa = tbSPEDECF.CodigoEmpresa
WHERE
tbSPEDECF.CodigoEmpresa				= @CodigoEmpresa	AND
tbSPEDECF.CodigoLocal				= @CodigoLocal		AND
tbSPEDECF.DataInicial				= @DataInicial		AND
tbSPEDECF.DataFinal					= @DataFinal		AND
tbCentroCusto.CentroCusto			<> 0				AND
(	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4') OR
	(	tbSPEDECF.FormaTributLucro	IN ('5','7') AND
		tbSPEDECF.EscritCaixaContabil = 'C'
	)
)
AND EXISTS ( SELECT 1 FROM tbSaldoContaContabil Saldo
             WHERE
             Saldo.CodigoEmpresa = @CodigoEmpresa AND
             Saldo.CentroCusto = tbCentroCusto.CentroCusto AND
             CONVERT(NUMERIC(4),LEFT(Saldo.PeriodoSaldoContaContabil,4)) = DATEPART(year,@DataInicial) AND
             (Saldo.SaldoAnteriorContaContabil + Saldo.ValorDebitoContaContabil + Saldo.ValorCreditoContaContabil) <> 0)


-----------------------------------------------------------------------
--- BALANCETE
-----------------------------------------------------------------------
DECLARE	@PeriodoBal				VARCHAR(6)		-- Periodo utilizado para gerar o balancete
SELECT	@PeriodoBal = CONVERT(VARCHAR(4),DATEPART(YEAR,@DataInicial)) + RIGHT('00'+CONVERT(VARCHAR(2),DATEPART(MONTH,@DataInicial)),2)

IF @RecuperarECD = 'F' AND @CodigoLocal <> -1 
BEGIN
	
	TRUNCATE TABLE rtBalSPEDECF

	INSERT rtBalSPEDECF
	(	RazaoSocialEmpresa,
		CodigoLocal,
		DescricaoLocal,
		CentroCusto,
		DescricaoCentroCusto,
		CodigoContaContabil,
		Digito,
		DescricaoContaContabil,
		SaldoAnterior,
		D01,C01,D02,C02,D03,C03,D04,C04,D05,C05,D06,C06,D07,C07,D08,C08,D09,C09,D10,C10,D11,C11,D12,C12,
		SaldoAtual,
		Digito1,
		Digito2,
		Digito3,
		Digito4,
		Digito5,
		Numeracao,
		GrauPlanoConta	)
	EXEC whSPEDECFBalMovtoMensal @CodigoEmpresa,@CodigoLocal,@DataInicial,@DataFinal,@PeriodoBal,'','999999999999',0,99999999,'V','F'

	TRUNCATE TABLE rtBalSPEDECF_DRE

	INSERT rtBalSPEDECF_DRE
	(	RazaoSocialEmpresa,
		CodigoLocal,
		DescricaoLocal,
		CentroCusto,
		DescricaoCentroCusto,
		CodigoContaContabil,
		Digito,
		DescricaoContaContabil,
		SaldoAnterior,
		D01,C01,D02,C02,D03,C03,D04,C04,D05,C05,D06,C06,D07,C07,D08,C08,D09,C09,D10,C10,D11,C11,D12,C12,
		SaldoAtual,
		Digito1,
		Digito2,
		Digito3,
		Digito4,
		Digito5,
		Numeracao,
		GrauPlanoConta	)
	EXEC whSPEDECFBalMovtoMensal @CodigoEmpresa,@CodigoLocal,@DataInicial,@DataFinal,@PeriodoBal,'','999999999999',0,99999999,'V','V'
END

IF @RecuperarECD = 'F' AND @CodigoLocal = -1 
BEGIN
	
	TRUNCATE TABLE rtBalSPEDECF
	
	INSERT rtBalSPEDECF
	(	RazaoSocialEmpresa,
		CodigoLocal,
		DescricaoLocal,
		CentroCusto,
		DescricaoCentroCusto,
		CodigoContaContabil,
		Digito,
		DescricaoContaContabil,
		SaldoAnterior,
		D01,C01,D02,C02,D03,C03,D04,C04,D05,C05,D06,C06,D07,C07,D08,C08,D09,C09,D10,C10,D11,C11,D12,C12,
		SaldoAtual,
		Digito1,
		Digito2,
		Digito3,
		Digito4,
		Digito5,
		Numeracao,
		GrauPlanoConta	)
	EXEC whSPEDECFBalMovtoMensal @CodigoEmpresa,@CodigoLocal,@DataInicial,@DataFinal,@PeriodoBal,'','999999999999',0,99999999,'F','F'
	
	TRUNCATE TABLE rtBalSPEDECF_DRE
	
	INSERT rtBalSPEDECF_DRE
	(	RazaoSocialEmpresa,
		CodigoLocal,
		DescricaoLocal,
		CentroCusto,
		DescricaoCentroCusto,
		CodigoContaContabil,
		Digito,
		DescricaoContaContabil,
		SaldoAnterior,
		D01,C01,D02,C02,D03,C03,D04,C04,D05,C05,D06,C06,D07,C07,D08,C08,D09,C09,D10,C10,D11,C11,D12,C12,
		SaldoAtual,
		Digito1,
		Digito2,
		Digito3,
		Digito4,
		Digito5,
		Numeracao,
		GrauPlanoConta	)
	EXEC whSPEDECFBalMovtoMensal @CodigoEmpresa,@CodigoLocal,@DataInicial,@DataFinal,@PeriodoBal,'','999999999999',0,99999999,'F','V'
END


-----------------------------------------------------------------------
--- PERÍODOS DE APURAÇÃO - LOOP
--- Cada período de apuração (@Periodo) indica o mês ou trimestre 
--- a que se referem os dados informados nos próximos registros.
--- Quando @Período = 0 indica o período completo da escrituração (por exemplo, 01/01 a 31/12)
-----------------------------------------------------------------------
DECLARE
	@DataPeriodoInicial		AS DATETIME,	-- Data Inicial do Período (ano, mês ou trimestre)
	@DataPeriodoFinal		AS DATETIME,	-- Data Final do Período (ano, mês ou trimestre)
	@Periodo				AS INTEGER,		-- Período atual (sequencial) de 0 a 12
	@Contador				AS INTEGER,		-- Controle do loop
	@Intervalo				AS INTEGER,		-- De quantos meses é o intervalo: (1) Mensal (3) Trimestral
	@Trimestre				AS INTEGER		-- Define o trimestre conforme o contador

SELECT @Intervalo = 
	CASE WHEN TrimestralAnual = 'A' AND FormaTributLucro <> '2' THEN
		1
	ELSE
		3
	END
FROM tbSPEDECF
WHERE 
tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa AND
tbSPEDECF.CodigoLocal	= @CodigoLocal AND
tbSPEDECF.DataInicial	= @DataInicial AND
tbSPEDECF.DataFinal		= @DataFinal


-- Inicia as variáveis de controle
SELECT @DataPeriodoInicial		= @DataInicial
SELECT @DataPeriodoFinal		= @DataFinal
SELECT @Periodo					= 0
SELECT @Contador				= DATEPART(MONTH,@DataPeriodoInicial) - 1
SELECT @Trimestre				= 0

WHILE @Contador <= (12 / @Intervalo)
BEGIN

	IF @Periodo <> 0 AND @DataPeriodoFinal = @DataFinal SELECT @Contador = 12
	
	SELECT @Trimestre = CASE WHEN @Intervalo = 3 THEN
							@Contador -- Se o intervalo é trimestral, o contador já indica o trimestre
						ELSE
							CASE
								WHEN @Contador IN ( 1, 2, 3) THEN 1
								WHEN @Contador IN ( 4, 5, 6) THEN 2
								WHEN @Contador IN ( 7, 8, 9) THEN 3
								WHEN @Contador IN (10,11,12) THEN 4
								ELSE 0
							END
						END
	
	DECLARE	@PeriodoApuracao AS VARCHAR(3)	-- Varia entre: 
											-- A00 - período completo na apuração anual
											-- A01 a A12 - meses na apuração anual
											-- T01 a T04 - trimestres na apuração trimestral
											
	SELECT	@PeriodoApuracao = CASE WHEN @Intervalo = 1 THEN 'A' ELSE 'T' END + RIGHT('00' + CONVERT(VARCHAR(2),@Periodo),2)
	
/*
	-- Saldos das Contas no Período de Apuração
	SET @PeriodoBal = CONVERT(VARCHAR(4),DATEPART(YEAR,@DataPeriodoInicial)) + RIGHT('00' + CONVERT(VARCHAR(2),DATEPART(MONTH,@DataPeriodoInicial)),2)
	
	IF @RecuperarECD = 'F' AND @CodigoLocal <> -1 
	BEGIN
		
		TRUNCATE TABLE rtBalanceteSPED

		INSERT rtBalanceteSPED
		( 
		  RazaoSocialEmpresa,
		  CodigoLocal,
		  DescricaoLocal,
		  CentroCusto,
		  DescricaoCentroCusto,
		  CodigoContaContabil,
		  Digito,
		  DescricaoContaContabil,
		  SaldoAnterior,
		  DebitoNoMes,
		  CreditoNoMes,
		  SaldoAtual,
		  Digito1,
		  Digito2,
		  Digito3,
		  Digito4,
		  Digito5,
		  Numeracao,
		  GrauPlanoConta
		)
		EXEC whRelCGBalancete @CodigoEmpresa,@CodigoLocal,@CodigoLocal,'','999999999999',0,99999999,@PeriodoBal,'V','F','V','F','V',@DataInicial,@DataPeriodoFinal,'F'

		TRUNCATE TABLE rtBalanceteReceitaDespesa

		INSERT rtBalanceteReceitaDespesa
		( 
		  RazaoSocialEmpresa,
		  CodigoLocal,
		  DescricaoLocal,
		  CentroCusto,
		  DescricaoCentroCusto,
		  CodigoContaContabil,
		  Digito,
		  DescricaoContaContabil,
		  SaldoAnterior,
		  DebitoNoMes,
		  CreditoNoMes,
		  SaldoAtual,
		  Digito1,
		  Digito2,
		  Digito3,
		  Digito4,
		  Digito5,
		  Numeracao,
		  GrauPlanoConta
		)
		EXEC whRelCGBalancete @CodigoEmpresa,@CodigoLocal,@CodigoLocal,'','999999999999',0,99999999,@PeriodoBal,'V','F','V','V','V',@DataInicial,@DataPeriodoFinal,'F'
	END
	
	IF @RecuperarECD = 'F' AND @CodigoLocal = -1 
	BEGIN
		
		TRUNCATE TABLE rtBalanceteSPED
		
		INSERT rtBalanceteSPED
		( 
		  RazaoSocialEmpresa,
		  CodigoLocal,
		  DescricaoLocal,
		  CentroCusto,
		  DescricaoCentroCusto,
		  CodigoContaContabil,
		  Digito,
		  DescricaoContaContabil,
		  SaldoAnterior,
		  DebitoNoMes,
		  CreditoNoMes,
		  SaldoAtual,
		  Digito1,
		  Digito2,
		  Digito3,
		  Digito4,
		  Digito5,
		  Numeracao,
		  GrauPlanoConta
		)
		EXEC whRelCGBalancete @CodigoEmpresa,@CodigoLocal,@CodigoLocal,'','999999999999',0,99999999,@PeriodoBal,'V','F','F','F','V',@DataInicial,@DataPeriodoFinal,'F'
		
		TRUNCATE TABLE rtBalanceteReceitaDespesa
		
		INSERT rtBalanceteReceitaDespesa
		( 
		  RazaoSocialEmpresa,
		  CodigoLocal,
		  DescricaoLocal,
		  CentroCusto,
		  DescricaoCentroCusto,
		  CodigoContaContabil,
		  Digito,
		  DescricaoContaContabil,
		  SaldoAnterior,
		  DebitoNoMes,
		  CreditoNoMes,
		  SaldoAtual,
		  Digito1,
		  Digito2,
		  Digito3,
		  Digito4,
		  Digito5,
		  Numeracao,
		  GrauPlanoConta
		)
		EXEC whRelCGBalancete @CodigoEmpresa,@CodigoLocal,@CodigoLocal,'','999999999999',0,99999999,@PeriodoBal,'V','F','F','V','V',@DataInicial,@DataPeriodoFinal,'F'
	END
*/	
	
	TRUNCATE TABLE rtBalanceteSPED
	INSERT rtBalanceteSPED SELECT
		RazaoSocialEmpresa,
		CodigoLocal,
		DescricaoLocal,
		CentroCusto,
		DescricaoCentroCusto,
		CodigoContaContabil,
		Digito,
		DescricaoContaContabil,
		SaldoAnterior,
		CASE @Periodo
			WHEN 0 THEN D12
			WHEN 1 THEN D01 WHEN 2 THEN D02 WHEN 3 THEN D03 WHEN 4 THEN D04 WHEN 5 THEN D05 WHEN 6 THEN D06
			WHEN 7 THEN D07 WHEN 8 THEN D08 WHEN 9 THEN D09 WHEN 10 THEN D10 WHEN 11 THEN D11 WHEN 12 THEN D12
		END,
		CASE @Periodo
			WHEN 0 THEN D12
			WHEN 1 THEN C01 WHEN 2 THEN C02 WHEN 3 THEN C03 WHEN 4 THEN C04 WHEN 5 THEN C05 WHEN 6 THEN C06
			WHEN 7 THEN C07 WHEN 8 THEN C08 WHEN 9 THEN C09 WHEN 10 THEN C10 WHEN 11 THEN C11 WHEN 12 THEN C12
		END,
		SaldoAnterior +
		CASE @Periodo
			WHEN 0 THEN D12
			WHEN 1 THEN D01 WHEN 2 THEN D02 WHEN 3 THEN D03 WHEN 4 THEN D04 WHEN 5 THEN D05 WHEN 6 THEN D06
			WHEN 7 THEN D07 WHEN 8 THEN D08 WHEN 9 THEN D09 WHEN 10 THEN D10 WHEN 11 THEN D11 WHEN 12 THEN D12
		END -
		CASE @Periodo
			WHEN 0 THEN D12
			WHEN 1 THEN C01 WHEN 2 THEN C02 WHEN 3 THEN C03 WHEN 4 THEN C04 WHEN 5 THEN C05 WHEN 6 THEN C06
			WHEN 7 THEN C07 WHEN 8 THEN C08 WHEN 9 THEN C09 WHEN 10 THEN C10 WHEN 11 THEN C11 WHEN 12 THEN C12
		END,
		Digito1,
		Digito2,
		Digito3,
		Digito4,
		Digito5,
		Numeracao,
		GrauPlanoConta
	FROM rtBalSPEDECF
		
	TRUNCATE TABLE rtBalanceteReceitaDespesa
	INSERT rtBalanceteReceitaDespesa SELECT
		RazaoSocialEmpresa,
		CodigoLocal,
		DescricaoLocal,
		CentroCusto,
		DescricaoCentroCusto,
		CodigoContaContabil,
		Digito,
		DescricaoContaContabil,
		SaldoAnterior,
		CASE @Periodo 
			WHEN 0 THEN D12
			WHEN 1 THEN D01 WHEN 2 THEN D02 WHEN 3 THEN D03 WHEN 4 THEN D04 WHEN 5 THEN D05 WHEN 6 THEN D06
			WHEN 7 THEN D07 WHEN 8 THEN D08 WHEN 9 THEN D09 WHEN 10 THEN D10 WHEN 11 THEN D11 WHEN 12 THEN D12
		END,
		CASE @Periodo
			WHEN 0 THEN D12
			WHEN 1 THEN C01 WHEN 2 THEN C02 WHEN 3 THEN C03 WHEN 4 THEN C04 WHEN 5 THEN C05 WHEN 6 THEN C06
			WHEN 7 THEN C07 WHEN 8 THEN C08 WHEN 9 THEN C09 WHEN 10 THEN C10 WHEN 11 THEN C11 WHEN 12 THEN C12
		END,
		SaldoAnterior + 
		CASE @Periodo
			WHEN 0 THEN D12
			WHEN 1 THEN D01 WHEN 2 THEN D02 WHEN 3 THEN D03 WHEN 4 THEN D04 WHEN 5 THEN D05 WHEN 6 THEN D06
			WHEN 7 THEN D07 WHEN 8 THEN D08 WHEN 9 THEN D09 WHEN 10 THEN D10 WHEN 11 THEN D11 WHEN 12 THEN D12
		END -
		CASE @Periodo
			WHEN 0 THEN D12
			WHEN 1 THEN C01 WHEN 2 THEN C02 WHEN 3 THEN C03 WHEN 4 THEN C04 WHEN 5 THEN C05 WHEN 6 THEN C06
			WHEN 7 THEN C07 WHEN 8 THEN C08 WHEN 9 THEN C09 WHEN 10 THEN C10 WHEN 11 THEN C11 WHEN 12 THEN C12
		END,
		Digito1,
		Digito2,
		Digito3,
		Digito4,
		Digito5,
		Numeracao,
		GrauPlanoConta
	FROM rtBalSPEDECF_DRE
	
	
	-----------------------------------------------------------------------
	--- Bloco K
	-----------------------------------------------------------------------
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|K030|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataPeriodoFinal)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataPeriodoFinal)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataPeriodoFinal)),'') + '|'
	+	@PeriodoApuracao + '|',
	'K030',
	5 + @Periodo,
	0
	FROM tbSPEDECF (NOLOCK)
	WHERE
	tbSPEDECF.CodigoEmpresa		= @CodigoEmpresa		AND
	tbSPEDECF.CodigoLocal		= @CodigoLocal			AND
	tbSPEDECF.DataInicial		= @DataInicial			AND
	tbSPEDECF.DataFinal			= @DataFinal			AND
	@PeriodoApuracao			<> 'T00'				AND
	(	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4') OR
		(	tbSPEDECF.FormaTributLucro	IN ('5','7') AND
			tbSPEDECF.EscritCaixaContabil = 'C'
		)
	)	AND tbSPEDECF.TipoECF					<> '2'


	--- Ativo/Passivo	
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|K155|'
	+	RTRIM(LTRIM(CONVERT(VARCHAR(12),rtBalanceteSPED.CodigoContaContabil))) + '|'
	+	'' + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SaldoAnterior)),'.',',') + '|'
	+	CASE WHEN SaldoAnterior < 0 THEN 'C' ELSE 'D' END + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(DebitoNoMes)),'.',',') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(CreditoNoMes)),'.',',') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SaldoAtual)),'.',',') + '|'
	+	CASE WHEN SaldoAtual < 0 THEN 'C' ELSE 'D' END + '|',
	'K155',
	5 + @Periodo,
	RIGHT('000000000000'+RTRIM(LTRIM(COALESCE(rtBalanceteSPED.CodigoContaContabil,''))),12)+RIGHT('00000000'+CONVERT(VARCHAR(8),COALESCE(rtBalanceteSPED.CentroCusto,0)),8)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbPlanoContas ON
			   tbPlanoContas.CodigoEmpresa = tbSPEDECF.CodigoEmpresa
	INNER JOIN rtBalanceteSPED (NOLOCK) ON
			   tbPlanoContas.CodigoContaContabil = rtBalanceteSPED.CodigoContaContabil
	WHERE
	@RecuperarECD							= 'F'				AND
	tbSPEDECF.CodigoEmpresa					= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal					= @CodigoLocal		AND
	tbSPEDECF.DataInicial					= @DataInicial		AND
	tbSPEDECF.DataFinal						= @DataFinal		AND
	tbPlanoContas.GrauPlanoConta			= 'A'				AND
	tbPlanoContas.NaturezaConta				IN ('01','02','03')	AND
	@PeriodoApuracao						<> 'T00'			AND
	(	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4') OR
		(	tbSPEDECF.FormaTributLucro	IN ('5','7') AND
			tbSPEDECF.EscritCaixaContabil = 'C'
		)
	)	AND tbSPEDECF.TipoECF					<> '2'	AND
	( ABS(SaldoAnterior) + ABS(DebitoNoMes) + ABS(CreditoNoMes) + ABS(SaldoAtual) ) <> 0
	ORDER BY
	rtBalanceteSPED.CodigoContaContabil
	
	
	--- Receita/Despesa
	INSERT rtSPEDECF
	SELECT
	@@spid,
		'|K155|'
	+	RTRIM(LTRIM(rtBalanceteReceitaDespesa.CodigoContaContabil))+ '|'
	+	RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(8),rtBalanceteReceitaDespesa.CentroCusto),''))) + '|' 
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SaldoAnterior)),'.',',') + '|'
	+	CASE WHEN SaldoAnterior < 0 THEN 'C' ELSE 'D' END + '|' 
	+	REPLACE(CONVERT(VARCHAR(16),ABS(DebitoNoMes)),'.',',') + '|' 
	+	REPLACE(CONVERT(VARCHAR(16),ABS(CreditoNoMes)),'.',',') + '|' 
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SaldoAtual)),'.',',') + '|' 
	+	CASE WHEN SaldoAtual < 0 THEN 'C' ELSE 'D' END + '|',
	'K155',
	5 + @Periodo,
	RIGHT('000000000000'+RTRIM(LTRIM(COALESCE(rtBalanceteReceitaDespesa.CodigoContaContabil,''))),12)+RIGHT('00000000'+CONVERT(VARCHAR(8),COALESCE(rtBalanceteReceitaDespesa.CentroCusto,0)),8)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbPlanoContas ON
			   tbPlanoContas.CodigoEmpresa = tbSPEDECF.CodigoEmpresa
	INNER JOIN rtBalanceteReceitaDespesa (NOLOCK) ON
			   tbPlanoContas.CodigoContaContabil = rtBalanceteReceitaDespesa.CodigoContaContabil
	WHERE
	@RecuperarECD							= 'F'				AND
	tbSPEDECF.CodigoEmpresa					= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal					= @CodigoLocal		AND
	tbSPEDECF.DataInicial					= @DataInicial		AND
	tbSPEDECF.DataFinal						= @DataFinal		AND
	tbPlanoContas.GrauPlanoConta			= 'A'				AND
	tbPlanoContas.NaturezaConta				IN ('01','02','03')	AND
	@PeriodoApuracao						<> 'T00'			AND
	( ABS(SaldoAnterior) + ABS(DebitoNoMes) + ABS(CreditoNoMes) + ABS(SaldoAtual) ) <> 0 AND
	(	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4') OR
		(	tbSPEDECF.FormaTributLucro	IN ('5','7') AND
			tbSPEDECF.EscritCaixaContabil = 'C'
		)
	)	AND tbSPEDECF.TipoECF					<> '2'
	ORDER BY
	rtBalanceteReceitaDespesa.CodigoContaContabil,
	rtBalanceteReceitaDespesa.CentroCusto
	
	
	--- Mapeamento Referencial Ativo/Passivo	
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|K156|'
	+	RTRIM(LTRIM(CONVERT(VARCHAR(255),COALESCE(tbPlanoContas.ContaReferencialSPED,'')))) + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SUM(SaldoAtual))),'.',',') + '|'
	+	CASE WHEN SUM(SaldoAtual) < 0 THEN 'C' ELSE 'D' END + '|',
	'K156',
	5 + @Periodo,
	RIGHT('000000000000'+RTRIM(LTRIM(COALESCE(rtBalanceteSPED.CodigoContaContabil,''))),12)+RIGHT('00000000'+CONVERT(VARCHAR(8),COALESCE(rtBalanceteSPED.CentroCusto,0)),8)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbPlanoContas ON
			   tbPlanoContas.CodigoEmpresa = tbSPEDECF.CodigoEmpresa
	INNER JOIN rtBalanceteSPED (NOLOCK) ON
			   tbPlanoContas.CodigoContaContabil = rtBalanceteSPED.CodigoContaContabil
	WHERE
	@RecuperarECD							= 'F'				AND
	tbSPEDECF.CodigoEmpresa					= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal					= @CodigoLocal		AND
	tbSPEDECF.DataInicial					= @DataInicial		AND
	tbSPEDECF.DataFinal						= @DataFinal		AND
	tbPlanoContas.GrauPlanoConta			= 'A'				AND
	tbPlanoContas.NaturezaConta				IN ('01','02','03')	AND
	@PeriodoApuracao						<> 'T00'			AND
	( ABS(SaldoAnterior) + ABS(DebitoNoMes) + ABS(CreditoNoMes) + ABS(SaldoAtual) ) <> 0 AND
	(	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4') OR
		(	tbSPEDECF.FormaTributLucro	IN ('5','7') AND
			tbSPEDECF.EscritCaixaContabil = 'C'
		)
	)	AND tbSPEDECF.TipoECF					<> '2'
	GROUP BY
	tbPlanoContas.ContaReferencialSPED,
	rtBalanceteSPED.CodigoContaContabil,
	rtBalanceteSPED.CentroCusto
	ORDER BY
	tbPlanoContas.ContaReferencialSPED
	
	
	--- Mapeamento Referencial Receita/Despesa
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|K156|'
	+	RTRIM(LTRIM(CONVERT(VARCHAR(255),COALESCE(tbPlanoContas.ContaReferencialSPED,'')))) + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SUM(SaldoAtual))),'.',',') + '|'
	+	CASE WHEN SUM(SaldoAtual) < 0 THEN 'C' ELSE 'D' END + '|',
	'K156',
	5 + @Periodo,
	RIGHT('000000000000'+RTRIM(LTRIM(COALESCE(rtBalanceteReceitaDespesa.CodigoContaContabil,''))),12)+RIGHT('00000000'+CONVERT(VARCHAR(8),COALESCE(rtBalanceteReceitaDespesa.CentroCusto,0)),8)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbPlanoContas ON
			   tbPlanoContas.CodigoEmpresa = tbSPEDECF.CodigoEmpresa
	INNER JOIN rtBalanceteReceitaDespesa (NOLOCK) ON
			   tbPlanoContas.CodigoContaContabil = rtBalanceteReceitaDespesa.CodigoContaContabil
	WHERE
	@RecuperarECD							= 'F'				AND
	tbSPEDECF.CodigoEmpresa					= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal					= @CodigoLocal		AND
	tbSPEDECF.DataInicial					= @DataInicial		AND
	tbSPEDECF.DataFinal						= @DataFinal		AND
	tbPlanoContas.GrauPlanoConta			= 'A'				AND
	tbPlanoContas.NaturezaConta				IN ('01','02','03')	AND
	@PeriodoApuracao						<> 'T00'			AND
	( ABS(SaldoAnterior) + ABS(DebitoNoMes) + ABS(CreditoNoMes) + ABS(SaldoAtual) ) <> 0 AND
	(	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4') OR
		(	tbSPEDECF.FormaTributLucro	IN ('5','7') AND
			tbSPEDECF.EscritCaixaContabil = 'C'
		)
	)	AND tbSPEDECF.TipoECF					<> '2'
	GROUP BY
	tbPlanoContas.ContaReferencialSPED,
	rtBalanceteReceitaDespesa.CodigoContaContabil,
	rtBalanceteReceitaDespesa.CentroCusto
	ORDER BY
	tbPlanoContas.ContaReferencialSPED
	
	
	-- Volta saldo balancete antes do encerramento
	UPDATE rtBalanceteReceitaDespesa
	SET SaldoAtual =  SaldoAtual - ((	COALESCE((	SELECT SUM(ValorLancamentoMovtoContabil) FROM tbMovimentoContabil
											WHERE CodigoEmpresa = @CodigoEmpresa AND
												OrigemLancamentoMovtoContabil = 'CG' AND
												DataLancamentoMovtoContabil = @DataPeriodoFinal AND 
												NumeroDocumentoMovtoContabil = 999999 AND
												CodigoContaMovtoContabil = rtBalanceteReceitaDespesa.CodigoContaContabil AND
												CodigoCCustoContaMovtoContabil = rtBalanceteReceitaDespesa.CentroCusto AND
												DebCreMovtoContabil = 'D'),0)) +
									(	COALESCE((	SELECT SUM(ValorLancamentoMovtoContabil) FROM tbMovimentoContabil
											WHERE CodigoEmpresa = @CodigoEmpresa AND
												OrigemLancamentoMovtoContabil = 'CG' AND
												DataLancamentoMovtoContabil = @DataPeriodoFinal AND 
												NumeroDocumentoMovtoContabil = 999999 AND
												CodigoContaMovtoContabil = rtBalanceteReceitaDespesa.CodigoContaContabil AND
												CodigoCCustoContaMovtoContabil = rtBalanceteReceitaDespesa.CentroCusto AND
												DebCreMovtoContabil = 'C'),0) * -1 ))
	
	
	--- Receita/Despesa antes do encerramento
	INSERT rtSPEDECF
	SELECT
	@@spid,
		'|K355|'
	+	RTRIM(LTRIM(rtBalanceteReceitaDespesa.CodigoContaContabil)) + '|'
	+	RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(8),rtBalanceteReceitaDespesa.CentroCusto),''))) + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SaldoAtual)),'.',',') + '|'
	+	CASE WHEN SaldoAtual < 0 THEN 'C' ELSE 'D' END + '|',
	'K355',
	5 + @Periodo,
	'9'+RIGHT('00000000000'+RTRIM(LTRIM(COALESCE(rtBalanceteReceitaDespesa.CodigoContaContabil,''))),11)+RIGHT('00000000'+CONVERT(VARCHAR(8),COALESCE(rtBalanceteReceitaDespesa.CentroCusto,0)),8)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbPlanoContas ON
			   tbPlanoContas.CodigoEmpresa = tbSPEDECF.CodigoEmpresa
	INNER JOIN rtBalanceteReceitaDespesa (NOLOCK) ON
			   tbPlanoContas.CodigoContaContabil = rtBalanceteReceitaDespesa.CodigoContaContabil
	WHERE
	@RecuperarECD							= 'F'				AND
	tbSPEDECF.CodigoEmpresa					= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal					= @CodigoLocal		AND
	tbSPEDECF.DataInicial					= @DataInicial		AND
	tbSPEDECF.DataFinal						= @DataFinal		AND
	tbPlanoContas.GrauPlanoConta			= 'A'				AND
	tbPlanoContas.NaturezaConta				IN ('04')			AND
	@PeriodoApuracao						<> 'T00'			AND
	( ABS(SaldoAnterior) + ABS(DebitoNoMes) + ABS(CreditoNoMes) + ABS(SaldoAtual) ) <> 0 AND
	(	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4') OR
		(	tbSPEDECF.FormaTributLucro	IN ('5','7') AND
			tbSPEDECF.EscritCaixaContabil = 'C'
		)
	)	AND tbSPEDECF.TipoECF					<> '2'
	ORDER BY
	rtBalanceteReceitaDespesa.CodigoContaContabil,
	rtBalanceteReceitaDespesa.CentroCusto
	
	
	--- Mapeamento Referencial Receita/Despesa antes do encerramento
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|K356|'
	+	RTRIM(LTRIM(CONVERT(VARCHAR(255),COALESCE(tbPlanoContas.ContaReferencialSPED,'')))) + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SUM(SaldoAtual))),'.',',') + '|'
	+	CASE WHEN SUM(SaldoAtual) < 0 THEN 'C' ELSE 'D' END + '|',
	'K356',
	5 + @Periodo,
	'9'+RIGHT('00000000000'+RTRIM(LTRIM(COALESCE(rtBalanceteReceitaDespesa.CodigoContaContabil,''))),11)+RIGHT('00000000'+CONVERT(VARCHAR(8),COALESCE(rtBalanceteReceitaDespesa.CentroCusto,0)),8)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbPlanoContas (NOLOCK) ON
			   tbPlanoContas.CodigoEmpresa = tbSPEDECF.CodigoEmpresa
	INNER JOIN rtBalanceteReceitaDespesa (NOLOCK) ON
			   tbPlanoContas.CodigoContaContabil = rtBalanceteReceitaDespesa.CodigoContaContabil
	WHERE
	@RecuperarECD							= 'F'				AND
	tbSPEDECF.CodigoEmpresa					= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal					= @CodigoLocal		AND
	tbSPEDECF.DataInicial					= @DataInicial		AND
	tbSPEDECF.DataFinal						= @DataFinal		AND
	tbPlanoContas.GrauPlanoConta			= 'A'				AND
	tbPlanoContas.NaturezaConta				IN ('04')			AND
	@PeriodoApuracao						<> 'T00'			AND
	( ABS(SaldoAnterior) + ABS(DebitoNoMes) + ABS(CreditoNoMes) + ABS(SaldoAtual) ) <> 0 AND
	(	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4') OR
		(	tbSPEDECF.FormaTributLucro	IN ('5','7') AND
			tbSPEDECF.EscritCaixaContabil = 'C'
		)
	)	AND tbSPEDECF.TipoECF					<> '2'
	GROUP BY
	tbPlanoContas.ContaReferencialSPED,
	rtBalanceteReceitaDespesa.CodigoContaContabil,
	rtBalanceteReceitaDespesa.CentroCusto
	ORDER BY
	tbPlanoContas.ContaReferencialSPED


	-----------------------------------------------------------------------
	--- Bloco L
	-----------------------------------------------------------------------
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|L030|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataPeriodoFinal)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataPeriodoFinal)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataPeriodoFinal)),'') + '|'
	+	@PeriodoApuracao + '|',
	'L030',
	33 + @Periodo,
	0
	FROM tbSPEDECF
	WHERE
	tbSPEDECF.CodigoEmpresa					= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal					= @CodigoLocal		AND
	tbSPEDECF.DataInicial					= @DataInicial		AND
	tbSPEDECF.DataFinal						= @DataFinal		AND
	@PeriodoApuracao						<> 'T00'			AND
	tbSPEDECF.FormaTributLucro				IN ('1','2','3','4')


	-- Balanço Patrimonial
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|L100|'
	+	RTRIM(LTRIM(CONVERT(VARCHAR(255),COALESCE(tbPlanoContas.ContaReferencialSPED,'')))) + '|'
	+	RTRIM(LTRIM(tbPlanoContasReferencial.DescricaoContaReferencial)) + '|'
	+	RTRIM(LTRIM(tbPlanoContasReferencial.SinteticaAnalitica)) + '|'
	+	RTRIM(LTRIM(tbPlanoContasReferencial.GrauContaReferencial)) + '|'
	+	RTRIM(LTRIM(COALESCE(tbPlanoContas.NaturezaConta,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(tbPlanoContasReferencial.ContaSintetica,''))) + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SUM(SaldoAnterior))),'.',',') + '|'
	+	CASE WHEN SUM(SaldoAnterior) < 0 THEN 'C' ELSE 'D' END + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SUM(SaldoAtual))),'.',',') + '|'
	+	CASE WHEN SUM(SaldoAtual) < 0 THEN 'C' ELSE 'D' END + '|',
	'L100',
	33 + @Periodo,
	'L100' + tbPlanoContas.ContaReferencialSPED
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN	tbPlanoContas (NOLOCK) ON
				tbPlanoContas.CodigoEmpresa	= tbSPEDECF.CodigoEmpresa
	INNER JOIN	rtBalanceteSPED (NOLOCK) ON
				tbPlanoContas.CodigoContaContabil = rtBalanceteSPED.CodigoContaContabil
	INNER JOIN	tbPlanoContasReferencial (NOLOCK) ON
				tbPlanoContasReferencial.CodigoEmpresa = tbPlanoContas.CodigoEmpresa AND
				tbPlanoContasReferencial.CodigoContaReferencial = tbPlanoContas.ContaReferencialSPED
	WHERE
	@RecuperarECD							= 'F'				AND
	tbSPEDECF.CodigoEmpresa					= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal					= @CodigoLocal		AND
	tbSPEDECF.DataInicial					= @DataInicial		AND
	tbSPEDECF.DataFinal						= @DataFinal		AND
	tbPlanoContas.NaturezaConta				IN ('01','02','03')	AND
	( ABS(SaldoAnterior) + ABS(DebitoNoMes) + ABS(CreditoNoMes) + ABS(SaldoAtual) ) <> 0 AND
	tbSPEDECF.FormaTributLucro				IN ('1','2','3','4')AND
	@PeriodoApuracao						<> 'T00'			AND
	(	@PeriodoApuracao					LIKE 'T%' OR
		(	@PeriodoApuracao				LIKE 'A%' AND
			(	@Periodo = 0 OR 
				SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) = 'B'
			)
		)
	)
	GROUP BY
	tbPlanoContas.ContaReferencialSPED,
	tbPlanoContasReferencial.DescricaoContaReferencial,
	tbPlanoContasReferencial.SinteticaAnalitica,
	tbPlanoContasReferencial.GrauContaReferencial,
	tbPlanoContas.NaturezaConta,
	tbPlanoContasReferencial.ContaSintetica
	ORDER BY
	tbPlanoContas.ContaReferencialSPED
	
	
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|L200|'
	+	MetodoAvaliacaoEstoque + '|',
	'L200',
	33 + @Periodo,
	'L200'
	FROM tbSPEDECF (NOLOCK)
	WHERE
	tbSPEDECF.CodigoEmpresa					= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal					= @CodigoLocal		AND
	tbSPEDECF.DataInicial					= @DataInicial		AND
	tbSPEDECF.DataFinal						= @DataFinal		AND
	tbSPEDECF.QualificacaoPJ				= '01'				AND
	tbSPEDECF.FormaTributLucro				IN ('1','2','3','4')AND
	@PeriodoApuracao						<> 'T00'			AND
	(	@PeriodoApuracao						LIKE 'T%' OR
		(	@PeriodoApuracao				LIKE 'A%' AND
			(	@Periodo = 0 OR 
				SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) = 'B'
			)
		)
	)


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|L210|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'L210',
	33 + @Periodo,
	'L210'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		tbSPEDECF.CodigoEmpresa		= lancto.CodigoEmpresa	AND
		tbSPEDECF.CodigoLocal		= lancto.CodigoLocal	AND
		tbSPEDECF.DataInicial		= lancto.DataInicial	AND
		tbSPEDECF.DataFinal			= lancto.DataFinal		
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro				= lancto.Registro	AND
		tabela.Codigo				= lancto.Codigo
	WHERE
	tbSPEDECF.CodigoEmpresa		= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal		= @CodigoLocal		AND
	tbSPEDECF.DataInicial		= @DataInicial		AND
	tbSPEDECF.DataFinal			= @DataFinal		AND
	lancto.PeriodoApuracao		= @PeriodoApuracao	AND
	lancto.Registro				= 'L210'			AND
	tbSPEDECF.QualificacaoPJ	= '01'				AND
	@PeriodoApuracao			<> 'T00'			AND
	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4')AND
	(	@PeriodoApuracao		LIKE 'T%' OR
		(	@PeriodoApuracao	LIKE 'A%' AND
			(	@Periodo = 0 OR 
				SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) = 'B'
			)
		)
	)


	-- DRE (Demonstração do Lucro Real)
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|L300|'
	+	RTRIM(LTRIM(CONVERT(VARCHAR(255),COALESCE(tbPlanoContas.ContaReferencialSPED,'')))) + '|'
	+	RTRIM(LTRIM(tbPlanoContasReferencial.DescricaoContaReferencial)) + '|'
	+	RTRIM(LTRIM(tbPlanoContasReferencial.SinteticaAnalitica)) + '|'
	+	RTRIM(LTRIM(tbPlanoContasReferencial.GrauContaReferencial)) + '|'
	+	RTRIM(LTRIM(COALESCE(tbPlanoContas.NaturezaConta,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(tbPlanoContasReferencial.ContaSintetica,''))) + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SUM(SaldoAtual))),'.',',') + '|'
	+	CASE WHEN SUM(SaldoAtual) < 0 THEN 'C' ELSE 'D' END + '|',
	'L300',
	33 + @Periodo,
	'L300' + COALESCE(tbPlanoContas.ContaReferencialSPED,'')
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbPlanoContas ON
			   tbPlanoContas.CodigoEmpresa = tbSPEDECF.CodigoEmpresa
	INNER JOIN rtBalanceteReceitaDespesa (NOLOCK) ON
			   tbPlanoContas.CodigoContaContabil = rtBalanceteReceitaDespesa.CodigoContaContabil
	INNER JOIN	tbPlanoContasReferencial (NOLOCK) ON
				tbPlanoContasReferencial.CodigoEmpresa = tbPlanoContas.CodigoEmpresa AND
				tbPlanoContasReferencial.CodigoContaReferencial = tbPlanoContas.ContaReferencialSPED
	WHERE
	@RecuperarECD							= 'F'				AND
	tbSPEDECF.CodigoEmpresa					= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal					= @CodigoLocal		AND
	tbSPEDECF.DataInicial					= @DataInicial		AND
	tbSPEDECF.DataFinal						= @DataFinal		AND
	tbPlanoContas.NaturezaConta				IN ('04')			AND
	( ABS(SaldoAnterior) + ABS(DebitoNoMes) + ABS(CreditoNoMes) + ABS(SaldoAtual) ) <> 0 AND
	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4')AND
	@PeriodoApuracao			<> 'T00'			AND
	(	@PeriodoApuracao		LIKE 'T%' OR
		(	@PeriodoApuracao	LIKE 'A%' AND
			(	@Periodo = 0 OR 
				SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) = 'B'
			)
		)
	)
	GROUP BY
	tbPlanoContas.ContaReferencialSPED,
	tbPlanoContasReferencial.DescricaoContaReferencial,
	tbPlanoContasReferencial.SinteticaAnalitica,
	tbPlanoContasReferencial.GrauContaReferencial,
	tbPlanoContas.NaturezaConta,
	tbPlanoContasReferencial.ContaSintetica
	ORDER BY
	tbPlanoContas.ContaReferencialSPED
	
	
	-----------------------------------------------------------------------
	--- Bloco M
	-----------------------------------------------------------------------
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|M030|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataPeriodoFinal)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataPeriodoFinal)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataPeriodoFinal)),'') + '|'
	+	@PeriodoApuracao + '|',
	'M030',
	47 + @Periodo,
	0
	FROM tbSPEDECF (NOLOCK)
	WHERE
	tbSPEDECF.CodigoEmpresa					= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal					= @CodigoLocal		AND
	tbSPEDECF.DataInicial					= @DataInicial		AND
	tbSPEDECF.DataFinal						= @DataFinal		AND
	@PeriodoApuracao						<> 'T00'			AND
	tbSPEDECF.FormaTributLucro				IN ('1','2','3','4') AND
	(	(	@PeriodoApuracao LIKE 'T%'	AND
			SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R')
		) OR
		(	@PeriodoApuracao LIKE 'A%'	AND
			(	@PeriodoApuracao = 'A00' OR
				SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) IN ('B')	)
		)
	)


	-- Lançamentos Parte A - IRPJ
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|M300|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFCodigoTabDin.Codigo,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFCodigoTabDin.Descricao,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFCodigoTabDin.TipoLancamento,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFParteA.IndicadorRelacionamento,''))) + '|'
	+	REPLACE(COALESCE(tbSPEDECFParteA.ValorLancamento,0),'.',',') + '|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFParteA.HistoricoLancamento,''))) + '|',
	'M300',
	47 + @Periodo,
	'M300' + CONVERT(CHAR(20),tbSPEDECFParteA.CodigoLancamento) -- M300 (IRRF) e registros filhos
	FROM tbSPEDECFParteA (NOLOCK)
	INNER JOIN	tbSPEDECF (NOLOCK) ON
				tbSPEDECF.CodigoEmpresa	= tbSPEDECFParteA.CodigoEmpresa AND
				tbSPEDECF.CodigoLocal	= tbSPEDECFParteA.CodigoLocal AND
				tbSPEDECF.DataInicial	= tbSPEDECFParteA.DataInicial AND
				tbSPEDECF.DataFinal		= tbSPEDECFParteA.DataFinal
	INNER JOIN	tbSPEDECFCodigoTabDin (NOLOCK) ON
				tbSPEDECFCodigoTabDin.Registro	= 'M300'			AND
				tbSPEDECFCodigoTabDin.Codigo	= tbSPEDECFParteA.CodigoLancamento
	WHERE
				tbSPEDECFParteA.CodigoEmpresa	= @CodigoEmpresa	AND
				tbSPEDECFParteA.CodigoLocal		= @CodigoLocal		AND
				tbSPEDECFParteA.DataInicial		= @DataInicial		AND
				tbSPEDECFParteA.DataFinal		= @DataFinal		AND
				tbSPEDECFParteA.TipoImposto		= 'I'				AND -- IRPJ
				tbSPEDECFParteA.PeriodoApuracao	= @PeriodoApuracao	AND
				-- Se houver M030
				@PeriodoApuracao					<> 'T00'			AND
				tbSPEDECF.FormaTributLucro			IN ('1','2','3','4') AND
				(	(	@PeriodoApuracao LIKE 'T%'	AND
						SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R')
					) OR
					(	@PeriodoApuracao LIKE 'A%'	AND
						(	@PeriodoApuracao = 'A00' OR
							SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) IN ('B')	)
					)
				) AND
				SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R','E')


	-- Relacionamento Parte A com Parte B do e-Lalur
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|M305|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFParteA.CodigoContaLalur,''))) + '|'
	+	REPLACE(COALESCE(tbSPEDECFParteA.ValorContaLalur,0),'.',',') + '|'
	+	CASE WHEN tbSPEDECFParteA.TipoLancamento IN ('A','L') THEN
			CASE WHEN tbSPEDECFParteA.ValorLancamento >= 0 THEN
				'D'
			ELSE
				'C'
			END
		ELSE
			CASE WHEN tbSPEDECFParteA.ValorLancamento >= 0 THEN
				'C'
			ELSE
				'D'
			END
		END + '|',
	'M305',
	47 + @Periodo,
	'M300' + CONVERT(CHAR(20),tbSPEDECFParteA.CodigoLancamento) + CONVERT(CHAR(20),COALESCE(tbSPEDECFParteA.CodigoContaLalur,'')) -- M300 (IRRF) e registros filhos
	FROM tbSPEDECFParteA
	INNER JOIN tbSPEDECF ON
		tbSPEDECF.CodigoEmpresa	= tbSPEDECFParteA.CodigoEmpresa AND
		tbSPEDECF.CodigoLocal	= tbSPEDECFParteA.CodigoLocal AND
		tbSPEDECF.DataInicial	= tbSPEDECFParteA.DataInicial AND
		tbSPEDECF.DataFinal		= tbSPEDECFParteA.DataFinal
	WHERE
		tbSPEDECFParteA.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECFParteA.CodigoLocal		= @CodigoLocal		AND
		tbSPEDECFParteA.DataInicial		= @DataInicial		AND
		tbSPEDECFParteA.DataFinal		= @DataFinal		AND
		tbSPEDECFParteA.TipoImposto		= 'I'				AND -- IRPJ
		tbSPEDECFParteA.PeriodoApuracao	= @PeriodoApuracao	AND
		tbSPEDECFParteA.IndicadorRelacionamento IN ('1','3')AND
		-- Se houver M030
		@PeriodoApuracao					<> 'T00'			AND
		tbSPEDECF.FormaTributLucro			IN ('1','2','3','4') AND
		(	(	@PeriodoApuracao LIKE 'T%'	AND
				SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R')
			) OR
			(	@PeriodoApuracao LIKE 'A%'	AND
				(	@PeriodoApuracao = 'A00' OR
					SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) IN ('B')	)
			)
		) AND
		-- Se houver M300
		SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R','E')
	

	-- Relacionamento Parte A com Conta Contábil
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|M310|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFParteA.CodigoContaContabil,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFParteA.CodigoCentroCusto,''))) + '|'
	+	REPLACE(COALESCE(tbSPEDECFParteA.ValorContaContabil,0),'.',',') + '|'
	+	CASE WHEN tbSPEDECFParteA.TipoLancamento IN ('A','L') THEN
			CASE WHEN tbPlanoContas.NaturezaConta IN ('01','02','03') THEN
				CASE WHEN tbSPEDECFParteA.ValorLancamento >= 0 THEN
					'C'
				ELSE
					'D'
				END
			ELSE
				CASE WHEN tbSPEDECFParteA.ValorLancamento >= 0 THEN
					'D'
				ELSE
					'C'
				END
			END
		ELSE
			CASE WHEN tbPlanoContas.NaturezaConta IN ('01','02','03') THEN
				CASE WHEN tbSPEDECFParteA.ValorLancamento >= 0 THEN
					'D'
				ELSE
					'C'
				END
			ELSE
				CASE WHEN tbSPEDECFParteA.ValorLancamento >= 0 THEN
					'C'
				ELSE
					'D'
				END
			END
		END + '|',
	'M310',
	47 + @Periodo,
	'M300' + CONVERT(CHAR(20),tbSPEDECFParteA.CodigoLancamento) + CONVERT(CHAR(12),COALESCE(tbSPEDECFParteA.CodigoContaContabil,'')) + CONVERT(CHAR(8),COALESCE(tbSPEDECFParteA.CodigoCentroCusto,'')) -- M300 (IRRF) e registros filhos
	FROM tbSPEDECFParteA
	INNER JOIN tbSPEDECF ON
		tbSPEDECF.CodigoEmpresa	= tbSPEDECFParteA.CodigoEmpresa AND
		tbSPEDECF.CodigoLocal	= tbSPEDECFParteA.CodigoLocal AND
		tbSPEDECF.DataInicial	= tbSPEDECFParteA.DataInicial AND
		tbSPEDECF.DataFinal		= tbSPEDECFParteA.DataFinal
	INNER JOIN tbPlanoContas ON
		tbPlanoContas.CodigoEmpresa			= tbSPEDECFParteA.CodigoEmpresa AND
		tbPlanoContas.CodigoContaContabil	= tbSPEDECFParteA.CodigoContaContabil
	WHERE
		tbSPEDECFParteA.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECFParteA.CodigoLocal		= @CodigoLocal		AND
		tbSPEDECFParteA.DataInicial		= @DataInicial		AND
		tbSPEDECFParteA.DataFinal		= @DataFinal		AND
		tbSPEDECFParteA.TipoImposto		= 'I'				AND -- IRPJ
		tbSPEDECFParteA.PeriodoApuracao	= @PeriodoApuracao	AND
		tbSPEDECFParteA.IndicadorRelacionamento IN ('2','3')AND
		-- Se houver M030
		@PeriodoApuracao					<> 'T00'			AND
		tbSPEDECF.FormaTributLucro			IN ('1','2','3','4') AND
		(	(	@PeriodoApuracao LIKE 'T%'	AND
				SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R')
			) OR
			(	@PeriodoApuracao LIKE 'A%'	AND
				(	@PeriodoApuracao = 'A00' OR
					SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) IN ('B')	)
			)
		) AND
		-- Se houver M300
		SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R','E')
	

	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|M312|'
	+	tbSPEDECFParteA.OrigemLancamento + 
		RIGHT('00000000' + CONVERT(VARCHAR(8),tbSPEDECFParteA.NRILancamento),8) + 
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbSPEDECFParteA.DataLancamento)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbSPEDECFParteA.DataLancamento)),2,2) + '|',
	'M312',
	47 + @Periodo,
	'M300' + CONVERT(CHAR(20),tbSPEDECFParteA.CodigoLancamento) + CONVERT(CHAR(12),COALESCE(tbSPEDECFParteA.CodigoContaContabil,'')) + CONVERT(CHAR(8),COALESCE(tbSPEDECFParteA.CodigoCentroCusto,'')) + RIGHT('00000000' + CONVERT(VARCHAR(8),tbSPEDECFParteA.NRILancamento),8) -- M300 (IRRF) e registros filhos
	FROM tbSPEDECFParteA
	INNER JOIN tbSPEDECF ON
			   tbSPEDECF.CodigoEmpresa	= tbSPEDECFParteA.CodigoEmpresa AND
			   tbSPEDECF.CodigoLocal	= tbSPEDECFParteA.CodigoLocal AND
			   tbSPEDECF.DataInicial	= tbSPEDECFParteA.DataInicial AND
			   tbSPEDECF.DataFinal		= tbSPEDECFParteA.DataFinal
	WHERE
		tbSPEDECFParteA.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECFParteA.CodigoLocal		= @CodigoLocal		AND
		tbSPEDECFParteA.DataInicial		= @DataInicial		AND
		tbSPEDECFParteA.DataFinal		= @DataFinal		AND
		tbSPEDECFParteA.TipoImposto		= 'I'				AND -- IRPJ
		tbSPEDECFParteA.PeriodoApuracao	= @PeriodoApuracao	AND
		tbSPEDECFParteA.IndicadorRelacionamento IN ('2','3')AND
		tbSPEDECFParteA.NRILancamento	IS NOT NULL			AND
		tbSPEDECFParteA.ValorContaContabil < tbSPEDECFParteA.ValorLancamento AND
		-- Se houver M030
		@PeriodoApuracao					<> 'T00'			AND
		tbSPEDECF.FormaTributLucro			IN ('1','2','3','4') AND
		(	(	@PeriodoApuracao LIKE 'T%'	AND
				SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R')
			) OR
			(	@PeriodoApuracao LIKE 'A%'	AND
				(	@PeriodoApuracao = 'A00' OR
					SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) IN ('B')	)
			)
		) AND
		-- Se houver M300
		SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R','E')
	

	-- Identificação de Processos Judiciais/Adm
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|M315|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFParteA.TipoProcesso,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFParteA.NumeroProcesso,''))) + '|',
	'M315',
	47 + @Periodo,
	'M300' + CONVERT(CHAR(20),tbSPEDECFParteA.CodigoLancamento) + CONVERT(CHAR(30),COALESCE(tbSPEDECFParteA.NumeroProcesso,'')) -- M300 (IRRF) e registros filhos
	FROM tbSPEDECFParteA
	INNER JOIN tbSPEDECF ON
		tbSPEDECF.CodigoEmpresa	= tbSPEDECFParteA.CodigoEmpresa AND
		tbSPEDECF.CodigoLocal	= tbSPEDECFParteA.CodigoLocal AND
		tbSPEDECF.DataInicial	= tbSPEDECFParteA.DataInicial AND
		tbSPEDECF.DataFinal		= tbSPEDECFParteA.DataFinal
	WHERE
		tbSPEDECFParteA.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECFParteA.CodigoLocal		= @CodigoLocal		AND
		tbSPEDECFParteA.DataInicial		= @DataInicial		AND
		tbSPEDECFParteA.DataFinal		= @DataFinal		AND
		tbSPEDECFParteA.TipoImposto		= 'I'				AND -- IRPJ
		tbSPEDECFParteA.PeriodoApuracao	= @PeriodoApuracao	AND
		tbSPEDECFParteA.NumeroProcesso	IS NOT NULL			AND
		-- Se houver M030
		@PeriodoApuracao					<> 'T00'			AND
		tbSPEDECF.FormaTributLucro			IN ('1','2','3','4') AND
		(	(	@PeriodoApuracao LIKE 'T%'	AND
				SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R')
			) OR
			(	@PeriodoApuracao LIKE 'A%'	AND
				(	@PeriodoApuracao = 'A00' OR
					SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) IN ('B')	)
			)
		) AND
		-- Se houver M300
		SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R','E')
	

	-- Lançamentos Parte A - CSLL
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|M350|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFCodigoTabDin.Codigo,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFCodigoTabDin.Descricao,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFCodigoTabDin.TipoLancamento,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFParteA.IndicadorRelacionamento,''))) + '|'
	+	REPLACE(COALESCE(tbSPEDECFParteA.ValorLancamento,0),'.',',') + '|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFParteA.HistoricoLancamento,''))) + '|',
	'M350',
	47 + @Periodo,
	'M350' + CONVERT(CHAR(20),tbSPEDECFParteA.CodigoLancamento) -- M350 (CSLL) e registros filhos
	FROM tbSPEDECFParteA (NOLOCK)
	INNER JOIN	tbSPEDECF (NOLOCK) ON
				tbSPEDECF.CodigoEmpresa	= tbSPEDECFParteA.CodigoEmpresa AND
				tbSPEDECF.CodigoLocal	= tbSPEDECFParteA.CodigoLocal AND
				tbSPEDECF.DataInicial	= tbSPEDECFParteA.DataInicial AND
				tbSPEDECF.DataFinal		= tbSPEDECFParteA.DataFinal
	INNER JOIN	tbSPEDECFCodigoTabDin (NOLOCK) ON
				tbSPEDECFCodigoTabDin.Registro	= 'M350'			AND
				tbSPEDECFCodigoTabDin.Codigo	= tbSPEDECFParteA.CodigoLancamento
	WHERE
				tbSPEDECFParteA.CodigoEmpresa	= @CodigoEmpresa	AND
				tbSPEDECFParteA.CodigoLocal		= @CodigoLocal		AND
				tbSPEDECFParteA.DataInicial		= @DataInicial		AND
				tbSPEDECFParteA.DataFinal		= @DataFinal		AND
				tbSPEDECFParteA.TipoImposto		= 'C'				AND -- CSLL
				tbSPEDECFParteA.PeriodoApuracao	= @PeriodoApuracao	AND
				-- Se houver M030
				@PeriodoApuracao					<> 'T00'			AND
				tbSPEDECF.FormaTributLucro			IN ('1','2','3','4') AND
				(	(	@PeriodoApuracao LIKE 'T%'	AND
						SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R')
					) OR
					(	@PeriodoApuracao LIKE 'A%'	AND
						(	@PeriodoApuracao = 'A00' OR
							SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) IN ('B')	)
					)
				) AND
				SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R','E')
	

	-- Relacionamento Parte A com Parte B do e-Lalur
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|M355|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFParteA.CodigoContaLalur,''))) + '|'
	+	REPLACE(COALESCE(tbSPEDECFParteA.ValorContaLalur,0),'.',',') + '|'
	+	CASE WHEN tbSPEDECFParteA.TipoLancamento IN ('A','L') THEN
			CASE WHEN tbSPEDECFParteA.ValorLancamento >= 0 THEN
				'D'
			ELSE
				'C'
			END
		ELSE
			CASE WHEN tbSPEDECFParteA.ValorLancamento >= 0 THEN
				'C'
			ELSE
				'D'
			END
		END + '|',
	'M355',
	47 + @Periodo,
	'M350' + CONVERT(CHAR(20),tbSPEDECFParteA.CodigoLancamento) + CONVERT(CHAR(20),COALESCE(tbSPEDECFParteA.CodigoContaLalur,'')) -- M350 (CSLL) e registros filhos
	FROM tbSPEDECFParteA
	INNER JOIN tbSPEDECF ON
		tbSPEDECF.CodigoEmpresa	= tbSPEDECFParteA.CodigoEmpresa AND
		tbSPEDECF.CodigoLocal	= tbSPEDECFParteA.CodigoLocal AND
		tbSPEDECF.DataInicial	= tbSPEDECFParteA.DataInicial AND
		tbSPEDECF.DataFinal		= tbSPEDECFParteA.DataFinal
	WHERE
		tbSPEDECFParteA.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECFParteA.CodigoLocal		= @CodigoLocal		AND
		tbSPEDECFParteA.DataInicial		= @DataInicial		AND
		tbSPEDECFParteA.DataFinal		= @DataFinal		AND
		tbSPEDECFParteA.TipoImposto		= 'C'				AND -- CSLL
		tbSPEDECFParteA.PeriodoApuracao	= @PeriodoApuracao	AND
		tbSPEDECFParteA.IndicadorRelacionamento IN ('1','3')AND
		-- Se houver M030
		@PeriodoApuracao					<> 'T00'			AND
		tbSPEDECF.FormaTributLucro			IN ('1','2','3','4') AND
		(	(	@PeriodoApuracao LIKE 'T%'	AND
				SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R')
			) OR
			(	@PeriodoApuracao LIKE 'A%'	AND
				(	@PeriodoApuracao = 'A00' OR
					SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) IN ('B')	)
			)
		) AND
		-- Se houver M350
		SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R','E')
	

	-- Relacionamento Parte A com Conta Contábil
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|M360|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFParteA.CodigoContaContabil,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFParteA.CodigoCentroCusto,''))) + '|'
	+	REPLACE(COALESCE(tbSPEDECFParteA.ValorContaContabil,0),'.',',') + '|'
	+	CASE WHEN tbSPEDECFParteA.TipoLancamento IN ('A','L') THEN
			CASE WHEN tbPlanoContas.NaturezaConta IN ('01','02','03') THEN
				CASE WHEN tbSPEDECFParteA.ValorLancamento >= 0 THEN
					'C'
				ELSE
					'D'
				END
			ELSE
				CASE WHEN tbSPEDECFParteA.ValorLancamento >= 0 THEN
					'D'
				ELSE
					'C'
				END
			END
		ELSE
			CASE WHEN tbPlanoContas.NaturezaConta IN ('01','02','03') THEN
				CASE WHEN tbSPEDECFParteA.ValorLancamento >= 0 THEN
					'D'
				ELSE
					'C'
				END
			ELSE
				CASE WHEN tbSPEDECFParteA.ValorLancamento >= 0 THEN
					'C'
				ELSE
					'D'
				END
			END
		END + '|',
	'M360',
	47 + @Periodo,
	'M350' + CONVERT(CHAR(20),tbSPEDECFParteA.CodigoLancamento) + CONVERT(CHAR(12),COALESCE(tbSPEDECFParteA.CodigoContaContabil,'')) + CONVERT(CHAR(8),COALESCE(tbSPEDECFParteA.CodigoCentroCusto,'')) -- M350 (CSLL) e registros filhos
	FROM tbSPEDECFParteA
	INNER JOIN tbSPEDECF ON
		tbSPEDECF.CodigoEmpresa	= tbSPEDECFParteA.CodigoEmpresa AND
		tbSPEDECF.CodigoLocal	= tbSPEDECFParteA.CodigoLocal AND
		tbSPEDECF.DataInicial	= tbSPEDECFParteA.DataInicial AND
		tbSPEDECF.DataFinal		= tbSPEDECFParteA.DataFinal
	INNER JOIN tbPlanoContas ON
		tbPlanoContas.CodigoEmpresa			= tbSPEDECFParteA.CodigoEmpresa AND
		tbPlanoContas.CodigoContaContabil	= tbSPEDECFParteA.CodigoContaContabil
	WHERE
		tbSPEDECFParteA.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECFParteA.CodigoLocal		= @CodigoLocal		AND
		tbSPEDECFParteA.DataInicial		= @DataInicial		AND
		tbSPEDECFParteA.DataFinal		= @DataFinal		AND
		tbSPEDECFParteA.TipoImposto		= 'C'				AND -- CSLL
		tbSPEDECFParteA.PeriodoApuracao	= @PeriodoApuracao	AND
		tbSPEDECFParteA.IndicadorRelacionamento IN ('2','3')AND
		-- Se houver M030
		@PeriodoApuracao					<> 'T00'			AND
		tbSPEDECF.FormaTributLucro			IN ('1','2','3','4') AND
		(	(	@PeriodoApuracao LIKE 'T%'	AND
				SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R')
			) OR
			(	@PeriodoApuracao LIKE 'A%'	AND
				(	@PeriodoApuracao = 'A00' OR
					SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) IN ('B')	)
			)
		) AND
		-- Se houver M350
		SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R','E')
	

	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|M362|'
	+	tbSPEDECFParteA.OrigemLancamento + 
		RIGHT('00000000' + CONVERT(VARCHAR(8),tbSPEDECFParteA.NRILancamento),8) + 
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbSPEDECFParteA.DataLancamento)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbSPEDECFParteA.DataLancamento)),2,2) + '|',
	'M362',
	47 + @Periodo,
	'M350' + CONVERT(CHAR(20),tbSPEDECFParteA.CodigoLancamento) + CONVERT(CHAR(12),COALESCE(tbSPEDECFParteA.CodigoContaContabil,'')) + CONVERT(CHAR(8),COALESCE(tbSPEDECFParteA.CodigoCentroCusto,'')) + RIGHT('00000000' + CONVERT(VARCHAR(8),tbSPEDECFParteA.NRILancamento),8) -- M350 (CSLL) e registros filhos
	FROM tbSPEDECFParteA
	INNER JOIN tbSPEDECF ON
		tbSPEDECF.CodigoEmpresa	= tbSPEDECFParteA.CodigoEmpresa AND
		tbSPEDECF.CodigoLocal	= tbSPEDECFParteA.CodigoLocal AND
		tbSPEDECF.DataInicial	= tbSPEDECFParteA.DataInicial AND
		tbSPEDECF.DataFinal		= tbSPEDECFParteA.DataFinal
	WHERE
		tbSPEDECFParteA.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECFParteA.CodigoLocal		= @CodigoLocal		AND
		tbSPEDECFParteA.DataInicial		= @DataInicial		AND
		tbSPEDECFParteA.DataFinal		= @DataFinal		AND
		tbSPEDECFParteA.TipoImposto		= 'C'				AND -- CSLL
		tbSPEDECFParteA.PeriodoApuracao	= @PeriodoApuracao	AND
		tbSPEDECFParteA.IndicadorRelacionamento IN ('2','3')AND
		tbSPEDECFParteA.NRILancamento	IS NOT NULL			AND
		tbSPEDECFParteA.ValorContaContabil < tbSPEDECFParteA.ValorLancamento AND
		-- Se houver M030
		@PeriodoApuracao					<> 'T00'			AND
		tbSPEDECF.FormaTributLucro			IN ('1','2','3','4') AND
		(	(	@PeriodoApuracao LIKE 'T%'	AND
				SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R')
			) OR
			(	@PeriodoApuracao LIKE 'A%'	AND
				(	@PeriodoApuracao = 'A00' OR
					SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) IN ('B')	)
			)
		) AND
		-- Se houver M350
		SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R','E')
	

	-- Identificação de Processos Judiciais/Adm
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|M365|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFParteA.TipoProcesso,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFParteA.NumeroProcesso,''))) + '|',
	'M365',
	47 + @Periodo,
	'M350' + CONVERT(CHAR(20),tbSPEDECFParteA.CodigoLancamento) + CONVERT(CHAR(30),COALESCE(tbSPEDECFParteA.NumeroProcesso,'')) -- M350 (CSLL) e registros filhos
	FROM tbSPEDECFParteA
	INNER JOIN tbSPEDECF ON
		tbSPEDECF.CodigoEmpresa	= tbSPEDECFParteA.CodigoEmpresa AND
		tbSPEDECF.CodigoLocal	= tbSPEDECFParteA.CodigoLocal AND
		tbSPEDECF.DataInicial	= tbSPEDECFParteA.DataInicial AND
		tbSPEDECF.DataFinal		= tbSPEDECFParteA.DataFinal
	WHERE
		tbSPEDECFParteA.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECFParteA.CodigoLocal		= @CodigoLocal		AND
		tbSPEDECFParteA.DataInicial		= @DataInicial		AND
		tbSPEDECFParteA.DataFinal		= @DataFinal		AND
		tbSPEDECFParteA.TipoImposto		= 'C'				AND -- CSLL
		tbSPEDECFParteA.PeriodoApuracao	= @PeriodoApuracao	AND
		tbSPEDECFParteA.NumeroProcesso	IS NOT NULL			AND
		-- Se houver M030
		@PeriodoApuracao					<> 'T00'			AND
		tbSPEDECF.FormaTributLucro			IN ('1','2','3','4') AND
		(	(	@PeriodoApuracao LIKE 'T%'	AND
				SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R')
			) OR
			(	@PeriodoApuracao LIKE 'A%'	AND
				(	@PeriodoApuracao = 'A00' OR
					SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) IN ('B')	)
			)
		) AND
		-- Se houver M350
		SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R','E')
	

	-- Lançamentos da Parte B sem reflexo na Parte A
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|M410|'
	+	tbSPEDECFParteB.CodigoContaLalur + '|'
	+	tbSPEDECFParteB.TipoImposto + '|'
	+	REPLACE(COALESCE(tbSPEDECFParteB.ValorLancamento,0),'.',',') + '|'
	+	tbSPEDECFParteB.TipoLancamento + '|'
	+	COALESCE(tbSPEDECFParteB.CPartidaContaLalur,'') + '|'
	+	COALESCE(tbSPEDECFParteB.HistoricoLancamento,'') + '|'
	+	CASE WHEN COALESCE(tbSPEDECFParteB.TributacaoDiferida,'F') = 'V' THEN 'S' ELSE 'N' END + '|',
	'M410',
	47 + @Periodo,
	'M410' + tbSPEDECFParteB.PeriodoApuracao + RIGHT('000' + CONVERT(VARCHAR(3),tbSPEDECFParteB.SequenciaLancamento),3)
	FROM tbSPEDECFParteB
	INNER JOIN tbSPEDECF ON
		tbSPEDECF.CodigoEmpresa	= tbSPEDECFParteB.CodigoEmpresa AND
		tbSPEDECF.CodigoLocal	= tbSPEDECFParteB.CodigoLocal AND
		tbSPEDECF.DataInicial	= tbSPEDECFParteB.DataInicial AND
		tbSPEDECF.DataFinal		= tbSPEDECFParteB.DataFinal
	WHERE
		tbSPEDECFParteB.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECFParteB.CodigoLocal		= @CodigoLocal		AND
		tbSPEDECFParteB.DataInicial		= @DataInicial		AND
		tbSPEDECFParteB.DataFinal		= @DataFinal		AND
		tbSPEDECFParteB.PeriodoApuracao	= @PeriodoApuracao	AND
		-- Se houver M030
		@PeriodoApuracao					<> 'T00'			AND
		tbSPEDECF.FormaTributLucro			IN ('1','2','3','4') AND
		(	(	@PeriodoApuracao LIKE 'T%'	AND
				SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R')
			) OR
			(	@PeriodoApuracao LIKE 'A%'	AND
				(	@PeriodoApuracao = 'A00' OR
					SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) IN ('B')	)
			)
		)
	

	-- Identificação de Processos Judiciais/Adm
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|M415|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFParteB.TipoProcesso,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(tbSPEDECFParteB.NumeroProcesso,''))) + '|',
	'M415',
	47 + @Periodo,
	'M410' + tbSPEDECFParteB.PeriodoApuracao + RIGHT('000' + CONVERT(VARCHAR(3),tbSPEDECFParteB.SequenciaLancamento),3)
	FROM tbSPEDECFParteB
	INNER JOIN tbSPEDECF ON
		tbSPEDECF.CodigoEmpresa	= tbSPEDECFParteB.CodigoEmpresa AND
		tbSPEDECF.CodigoLocal	= tbSPEDECFParteB.CodigoLocal AND
		tbSPEDECF.DataInicial	= tbSPEDECFParteB.DataInicial AND
		tbSPEDECF.DataFinal		= tbSPEDECFParteB.DataFinal
	WHERE
		tbSPEDECFParteB.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECFParteB.CodigoLocal		= @CodigoLocal		AND
		tbSPEDECFParteB.DataInicial		= @DataInicial		AND
		tbSPEDECFParteB.DataFinal		= @DataFinal		AND
		tbSPEDECFParteB.PeriodoApuracao	= @PeriodoApuracao	AND
		tbSPEDECFParteB.NumeroProcesso	IS NOT NULL			AND
		tbSPEDECFParteB.NumeroProcesso	<> ''				AND
		-- Se houver M030
		@PeriodoApuracao					<> 'T00'			AND
		tbSPEDECF.FormaTributLucro			IN ('1','2','3','4') AND
		(	(	@PeriodoApuracao LIKE 'T%'	AND
				SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) IN ('R')
			) OR
			(	@PeriodoApuracao LIKE 'A%'	AND
				(	@PeriodoApuracao = 'A00' OR
					SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) IN ('B')	)
			)
		)


	-----------------------------------------------------------------------
	--- Bloco N
	-----------------------------------------------------------------------
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|N030|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataPeriodoFinal)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataPeriodoFinal)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataPeriodoFinal)),'') + '|'
	+	@PeriodoApuracao + '|',
	'N030',
	89 + @Periodo,
	'N030'+'000000'
	FROM tbSPEDECF (NOLOCK)
	WHERE
	tbSPEDECF.CodigoEmpresa		= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal		= @CodigoLocal		AND
	tbSPEDECF.DataInicial		= @DataInicial		AND
	tbSPEDECF.DataFinal			= @DataFinal		AND
	@PeriodoApuracao			<> 'T00'			AND
	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4')


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|N500|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'N500',
	89 + @Periodo,
	'N500'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.PeriodoApuracao	= @PeriodoApuracao	AND
	@PeriodoApuracao		<> 'T00'			AND
	lancto.Registro			= 'N500'			


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|N600|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'N600',
	89 + @Periodo,
	'N600'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
	tbSPEDECF.CodigoEmpresa		= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal		= @CodigoLocal		AND
	tbSPEDECF.DataInicial		= @DataInicial		AND
	tbSPEDECF.DataFinal			= @DataFinal		AND
	lancto.PeriodoApuracao		= @PeriodoApuracao	AND
	lancto.Registro				= 'N600'			AND
	tbSPEDECF.LucroExploracao	= 'V'				AND
	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4')AND
	@PeriodoApuracao			<> 'T00'			AND
	(	@PeriodoApuracao		LIKE 'T%' OR
		(	@PeriodoApuracao	LIKE 'A%' AND
			(	@Periodo = 0 OR 
				SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) = 'B'
			)
		)
	)


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|N610|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'N610',
	89 + @Periodo,
	'N610'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
	tbSPEDECF.CodigoEmpresa		= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal		= @CodigoLocal		AND
	tbSPEDECF.DataInicial		= @DataInicial		AND
	tbSPEDECF.DataFinal			= @DataFinal		AND
	lancto.PeriodoApuracao		= @PeriodoApuracao	AND
	lancto.Registro				= 'N610'			AND
	tbSPEDECF.LucroExploracao	= 'V'				AND
	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4')AND
	@PeriodoApuracao			<> 'T00'			AND
	(	@PeriodoApuracao		LIKE 'T%' OR
		(	@PeriodoApuracao	LIKE 'A%' AND
			(	@Periodo = 0 OR 
				SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) <> 'E'
			)
		)
	)


	INSERT rtSPEDECF
	SELECT DISTINCT
	@@spid,
		'|N615|'
	+	(	SELECT REPLACE(CONVERT(VARCHAR(16),COALESCE(lancto.ValorLancto,0)),'.',',')
			FROM tbSPEDECFLanctoTabDin lancto (NOLOCK) 
			WHERE
			lancto.CodigoEmpresa	= @CodigoEmpresa	AND
			lancto.CodigoLocal		= @CodigoLocal		AND
			lancto.DataInicial		= @DataInicial		AND
			lancto.DataFinal		= @DataFinal		AND
			lancto.PeriodoApuracao	= @PeriodoApuracao	AND
			lancto.Registro			= 'N615'			AND
			lancto.Codigo			= 'BASECALC'		
		) + '|'
	+	(	SELECT REPLACE(CONVERT(VARCHAR(16),COALESCE(lancto.ValorLancto,0)),'.',',')
			FROM tbSPEDECFLanctoTabDin lancto (NOLOCK) 
			WHERE
			lancto.CodigoEmpresa	= @CodigoEmpresa	AND
			lancto.CodigoLocal		= @CodigoLocal		AND
			lancto.DataInicial		= @DataInicial		AND
			lancto.DataFinal		= @DataFinal		AND
			lancto.PeriodoApuracao	= @PeriodoApuracao	AND
			lancto.Registro			= 'N615'			AND
			lancto.Codigo			= 'PERFINOR'		
		) + '|'
	+	(	SELECT REPLACE(CONVERT(VARCHAR(16),COALESCE(lancto.ValorLancto,0)),'.',',')
			FROM tbSPEDECFLanctoTabDin lancto (NOLOCK) 
			WHERE
			lancto.CodigoEmpresa	= @CodigoEmpresa	AND
			lancto.CodigoLocal		= @CodigoLocal		AND
			lancto.DataInicial		= @DataInicial		AND
			lancto.DataFinal		= @DataFinal		AND
			lancto.PeriodoApuracao	= @PeriodoApuracao	AND
			lancto.Registro			= 'N615'			AND
			lancto.Codigo			= 'VLRFINOR'		
		) + '|'
	+	(	SELECT REPLACE(CONVERT(VARCHAR(16),COALESCE(lancto.ValorLancto,0)),'.',',')
			FROM tbSPEDECFLanctoTabDin lancto (NOLOCK) 
			WHERE
			lancto.CodigoEmpresa	= @CodigoEmpresa	AND
			lancto.CodigoLocal		= @CodigoLocal		AND
			lancto.DataInicial		= @DataInicial		AND
			lancto.DataFinal		= @DataFinal		AND
			lancto.PeriodoApuracao	= @PeriodoApuracao	AND
			lancto.Registro			= 'N615'			AND
			lancto.Codigo			= 'PERFINAM'		
		) + '|'
	+	(	SELECT REPLACE(CONVERT(VARCHAR(16),COALESCE(lancto.ValorLancto,0)),'.',',')
			FROM tbSPEDECFLanctoTabDin lancto (NOLOCK) 
			WHERE
			lancto.CodigoEmpresa	= @CodigoEmpresa	AND
			lancto.CodigoLocal		= @CodigoLocal		AND
			lancto.DataInicial		= @DataInicial		AND
			lancto.DataFinal		= @DataFinal		AND
			lancto.PeriodoApuracao	= @PeriodoApuracao	AND
			lancto.Registro			= 'N615'			AND
			lancto.Codigo			= 'VLRFINAM'		
		) + '|'
		-- VERSÃO 0002 - Campos excluídos
		+	CASE WHEN @Versao >= '0002' THEN
				''
			ELSE
				(	REPLACE(CONVERT(VARCHAR(16), (
						SELECT COALESCE(lancto.ValorLancto,0)
						FROM tbSPEDECFLanctoTabDin lancto (NOLOCK) 
						WHERE
						lancto.CodigoEmpresa	= @CodigoEmpresa	AND
						lancto.CodigoLocal		= @CodigoLocal		AND
						lancto.DataInicial		= @DataInicial		AND
						lancto.DataFinal		= @DataFinal		AND
						lancto.PeriodoApuracao	= @PeriodoApuracao	AND
						lancto.Registro			= 'N615'			AND
						lancto.Codigo			= 'VLRFINOR'		) + (
						SELECT COALESCE(lancto.ValorLancto,0)
						FROM tbSPEDECFLanctoTabDin lancto (NOLOCK) 
						WHERE
						lancto.CodigoEmpresa	= @CodigoEmpresa	AND
						lancto.CodigoLocal		= @CodigoLocal		AND
						lancto.DataInicial		= @DataInicial		AND
						lancto.DataFinal		= @DataFinal		AND
						lancto.PeriodoApuracao	= @PeriodoApuracao	AND
						lancto.Registro			= 'N615'			AND
						lancto.Codigo			= 'VLRFINAM'		)
				),'.',',')) + '|'
			+	(	SELECT REPLACE(CONVERT(VARCHAR(16),COALESCE(lancto.ValorLancto,0)),'.',',')
					FROM tbSPEDECFLanctoTabDin lancto (NOLOCK) 
					WHERE
					lancto.CodigoEmpresa	= @CodigoEmpresa	AND
					lancto.CodigoLocal		= @CodigoLocal		AND
					lancto.DataInicial		= @DataInicial		AND
					lancto.DataFinal		= @DataFinal		AND
					lancto.PeriodoApuracao	= @PeriodoApuracao	AND
					lancto.Registro			= 'N615'			AND
					lancto.Codigo			= 'PERFUNRES'		
				) + '|'
			+	(	SELECT REPLACE(CONVERT(VARCHAR(16),COALESCE(lancto.ValorLancto,0)),'.',',')
					FROM tbSPEDECFLanctoTabDin lancto (NOLOCK) 
					WHERE
					lancto.CodigoEmpresa	= @CodigoEmpresa	AND
					lancto.CodigoLocal		= @CodigoLocal		AND
					lancto.DataInicial		= @DataInicial		AND
					lancto.DataFinal		= @DataFinal		AND
					lancto.PeriodoApuracao	= @PeriodoApuracao	AND
					lancto.Registro			= 'N615'			AND
					lancto.Codigo			= 'VLRFUNRES'		
				) + '|'
			+	(	REPLACE(CONVERT(VARCHAR(16), (
						SELECT COALESCE(lancto.ValorLancto,0)
						FROM tbSPEDECFLanctoTabDin lancto (NOLOCK) 
						WHERE
						lancto.CodigoEmpresa	= @CodigoEmpresa	AND
						lancto.CodigoLocal		= @CodigoLocal		AND
						lancto.DataInicial		= @DataInicial		AND
						lancto.DataFinal		= @DataFinal		AND
						lancto.PeriodoApuracao	= @PeriodoApuracao	AND
						lancto.Registro			= 'N615'			AND
						lancto.Codigo			= 'VLRFINOR'		) + (
						SELECT COALESCE(lancto.ValorLancto,0)
						FROM tbSPEDECFLanctoTabDin lancto (NOLOCK) 
						WHERE
						lancto.CodigoEmpresa	= @CodigoEmpresa	AND
						lancto.CodigoLocal		= @CodigoLocal		AND
						lancto.DataInicial		= @DataInicial		AND
						lancto.DataFinal		= @DataFinal		AND
						lancto.PeriodoApuracao	= @PeriodoApuracao	AND
						lancto.Registro			= 'N615'			AND
						lancto.Codigo			= 'VLRFINAM'		) + (
						SELECT COALESCE(lancto.ValorLancto,0)
						FROM tbSPEDECFLanctoTabDin lancto (NOLOCK) 
						WHERE
						lancto.CodigoEmpresa	= @CodigoEmpresa	AND
						lancto.CodigoLocal		= @CodigoLocal		AND
						lancto.DataInicial		= @DataInicial		AND
						lancto.DataFinal		= @DataFinal		AND
						lancto.PeriodoApuracao	= @PeriodoApuracao	AND
						lancto.Registro			= 'N615'			AND
						lancto.Codigo			= 'VLRFUNRES'		)
				),'.',',')) + '|'
		END,
	'N615',
	89 + @Periodo,
	'N615'+RIGHT(@PeriodoApuracao,2)+'0000'
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	WHERE
	tbSPEDECF.CodigoEmpresa		= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal		= @CodigoLocal		AND
	tbSPEDECF.DataInicial		= @DataInicial		AND
	tbSPEDECF.DataFinal			= @DataFinal		AND
	lancto.PeriodoApuracao		= @PeriodoApuracao	AND
	lancto.Registro				= 'N615'			AND
	lancto.Registro				IS NOT NULL			AND
	tbSPEDECF.FinorFinamFunres	= 'V'				AND
	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4')AND
	@PeriodoApuracao			<> 'T00'			AND
	(	@PeriodoApuracao		LIKE 'T%' OR
		(	@PeriodoApuracao	LIKE 'A%' AND
			(	@Periodo = 0 OR 
				SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) <> 'E'
			)
		)
	)


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|N620|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'N620',
	89 + @Periodo,
	'N620'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.PeriodoApuracao	= @PeriodoApuracao	AND
	lancto.Registro			= 'N620'			AND
	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4')AND
	@PeriodoApuracao		LIKE 'A%'			AND
	@Periodo				<> 0				AND
	SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) = 'E'


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|N630|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'N630',
	89 + @Periodo,
	'N630'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.PeriodoApuracao	= @PeriodoApuracao	AND
	lancto.Registro			= 'N630'			AND
	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4')AND
	@PeriodoApuracao		<> 'T00'			AND
	(	@PeriodoApuracao		LIKE 'T%' OR
		(	@PeriodoApuracao	LIKE 'A%' AND
			(	@Periodo = 0 OR 
				SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) = 'B'
			)
		)
	)


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|N650|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'N650',
	89 + @Periodo,
	'N650'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.PeriodoApuracao	= @PeriodoApuracao	AND
	lancto.Registro			= 'N650'			AND
	@PeriodoApuracao		<> 'T00'			AND
	FormaTributLucro IN ('1','2','3','4')


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|N660|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'N660',
	89 + @Periodo,
	'N660'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.PeriodoApuracao	= @PeriodoApuracao	AND
	lancto.Registro			= 'N660'			AND
	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4')AND
	@PeriodoApuracao		<> 'T00'			AND
	@PeriodoApuracao		LIKE 'A%'			AND
	@Periodo				<> 0				AND
	SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) = 'E'


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|N670|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'N670',
	89 + @Periodo,
	'N670'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.PeriodoApuracao	= @PeriodoApuracao	AND
	lancto.Registro			= 'N670'			AND
	tbSPEDECF.FormaTributLucro	IN ('1','2','3','4')AND
	@PeriodoApuracao		<> 'T00'			AND
	(	@PeriodoApuracao		LIKE 'T%' OR
		(	@PeriodoApuracao	LIKE 'A%' AND
			(	@Periodo = 0 OR 
				SUBSTRING(tbSPEDECF.FormaTributMeses,@Contador,1) = 'B'
			)
		)
	)


	-----------------------------------------------------------------------
	--- Bloco P
	-----------------------------------------------------------------------
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|P030|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataPeriodoFinal)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataPeriodoFinal)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataPeriodoFinal)),'') + '|'
	+	@PeriodoApuracao + '|',
	'P030',
	117 + @Periodo,
	0
	FROM tbSPEDECF (NOLOCK)
	WHERE
	tbSPEDECF.CodigoEmpresa		= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal		= @CodigoLocal		AND
	tbSPEDECF.DataInicial		= @DataInicial		AND
	tbSPEDECF.DataFinal			= @DataFinal		AND
	tbSPEDECF.FormaTributLucro	IN ('3','4','5','7')AND
	@PeriodoApuracao			IN ('A00','T01','T02','T03','T04') AND
	SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1) = 'P'


	-- Balanço Patrimonial
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|P100|'
	+	RTRIM(LTRIM(CONVERT(VARCHAR(255),COALESCE(tbPlanoContas.ContaReferencialSPED,'')))) + '|'
	+	RTRIM(LTRIM(tbPlanoContasReferencial.DescricaoContaReferencial)) + '|'
	+	RTRIM(LTRIM(tbPlanoContasReferencial.SinteticaAnalitica)) + '|'
	+	RTRIM(LTRIM(tbPlanoContasReferencial.GrauContaReferencial)) + '|'
	+	RTRIM(LTRIM(COALESCE(tbPlanoContas.NaturezaConta,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(tbPlanoContasReferencial.ContaSintetica,''))) + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SUM(SaldoAnterior))),'.',',') + '|'
	+	CASE WHEN SUM(SaldoAnterior) < 0 THEN 'C' ELSE 'D' END + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SUM(SaldoAtual))),'.',',') + '|'
	+	CASE WHEN SUM(SaldoAtual) < 0 THEN 'C' ELSE 'D' END + '|',
	'P100',
	117 + @Periodo,
	tbPlanoContas.ContaReferencialSPED
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN	tbPlanoContas (NOLOCK) ON
				tbPlanoContas.CodigoEmpresa = tbSPEDECF.CodigoEmpresa
	INNER JOIN	rtBalanceteSPED (NOLOCK) ON
				tbPlanoContas.CodigoContaContabil = rtBalanceteSPED.CodigoContaContabil
	INNER JOIN	tbPlanoContasReferencial (NOLOCK) ON
				tbPlanoContasReferencial.CodigoEmpresa = tbPlanoContas.CodigoEmpresa AND
				tbPlanoContasReferencial.CodigoContaReferencial = tbPlanoContas.ContaReferencialSPED
	WHERE
		@RecuperarECD				= 'F'				AND
		tbSPEDECF.CodigoEmpresa		= @CodigoEmpresa	AND
		tbSPEDECF.CodigoLocal		= @CodigoLocal		AND
		tbSPEDECF.DataInicial		= @DataInicial		AND
		tbSPEDECF.DataFinal			= @DataFinal		AND
		tbPlanoContas.NaturezaConta	IN ('01','02','03') AND
		( ABS(SaldoAnterior) + ABS(DebitoNoMes) + ABS(CreditoNoMes) + ABS(SaldoAtual) ) <> 0 AND
		tbSPEDECF.FormaTributLucro	IN ('3','4','5','7')AND
		@PeriodoApuracao			IN ('A00','T01','T02','T03','T04') AND
		@PeriodoApuracao			LIKE 'T%'			AND
		@Periodo					<> 0				AND
		tbSPEDECF.EscritCaixaContabil = 'C'				AND
		SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1)	= 'P'	AND
		RIGHT(tbSPEDECF.FormaTributTrimestres,1)				= 'P'
	GROUP BY
	tbPlanoContas.ContaReferencialSPED,
	tbPlanoContasReferencial.DescricaoContaReferencial,
	tbPlanoContasReferencial.SinteticaAnalitica,
	tbPlanoContasReferencial.GrauContaReferencial,
	tbPlanoContas.NaturezaConta,
	tbPlanoContasReferencial.ContaSintetica
	ORDER BY
	tbPlanoContas.ContaReferencialSPED
	
	
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|P130|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'P130',
	117 + @Periodo,
	'P130'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
		tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
		tbSPEDECF.DataInicial	= @DataInicial		AND
		tbSPEDECF.DataFinal		= @DataFinal		AND
		lancto.PeriodoApuracao	= @PeriodoApuracao	AND
		lancto.Registro			= 'P130'			AND
		tbSPEDECF.FormaTributLucro	IN ('3','4','5','7')AND
		@PeriodoApuracao			IN ('A00','T01','T02','T03','T04') AND
		@PeriodoApuracao			LIKE 'T%'			AND
		@Periodo					<> 0				AND
		SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1)	= 'P' AND
		tbSPEDECF.IsenReducLucroPresumido			= 'V' AND
		tbSPEDECF.OptanteREFIS						= 'V'


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|P200|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'P200',
	117 + @Periodo,
	'P200'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
		tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
		tbSPEDECF.DataInicial	= @DataInicial		AND
		tbSPEDECF.DataFinal		= @DataFinal		AND
		lancto.PeriodoApuracao	= @PeriodoApuracao	AND
		lancto.Registro			= 'P200'			AND
		tbSPEDECF.FormaTributLucro	IN ('3','4','5','7')AND
		@PeriodoApuracao			IN ('A00','T01','T02','T03','T04') AND
		@PeriodoApuracao			LIKE 'T%'			AND
		@Periodo					<> 0				AND
		SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1)	= 'P'


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|P230|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'P230',
	117 + @Periodo,
	'P230'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
		tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
		tbSPEDECF.DataInicial	= @DataInicial		AND
		tbSPEDECF.DataFinal		= @DataFinal		AND
		lancto.PeriodoApuracao	= @PeriodoApuracao	AND
		lancto.Registro			= 'P230'			AND
		tbSPEDECF.FormaTributLucro	IN ('3','4','5','7')AND
		@PeriodoApuracao			IN ('A00','T01','T02','T03','T04') AND
		@PeriodoApuracao			LIKE 'T%'			AND
		@Periodo					<> 0				AND
		SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1)	= 'P' AND
		tbSPEDECF.IsenReducLucroPresumido			= 'V' AND
		tbSPEDECF.OptanteREFIS						= 'V'


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|P300|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'P300',
	117 + @Periodo,
	'P300'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
		tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
		tbSPEDECF.DataInicial	= @DataInicial		AND
		tbSPEDECF.DataFinal		= @DataFinal		AND
		lancto.PeriodoApuracao	= @PeriodoApuracao	AND
		lancto.Registro			= 'P300'			AND
		tbSPEDECF.FormaTributLucro	IN ('3','4','5','7')AND
		@PeriodoApuracao			IN ('A00','T01','T02','T03','T04') AND
		@PeriodoApuracao			LIKE 'T%'			AND
		@Periodo					<> 0				AND
		SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1)	= 'P'


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|P400|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'P400',
	117 + @Periodo,
	'P400'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
		tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
		tbSPEDECF.DataInicial	= @DataInicial		AND
		tbSPEDECF.DataFinal		= @DataFinal		AND
		lancto.PeriodoApuracao	= @PeriodoApuracao	AND
		lancto.Registro			= 'P400'			AND
		tbSPEDECF.FormaTributLucro	IN ('3','4','5','7')AND
		@PeriodoApuracao			IN ('A00','T01','T02','T03','T04') AND
		@PeriodoApuracao			LIKE 'T%'			AND
		@Periodo					<> 0				AND
		SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1)	= 'P'


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|P500|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'P500',
	117 + @Periodo,
	'P500'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
		tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
		tbSPEDECF.DataInicial	= @DataInicial		AND
		tbSPEDECF.DataFinal		= @DataFinal		AND
		lancto.PeriodoApuracao	= @PeriodoApuracao	AND
		lancto.Registro			= 'P500'			AND
		tbSPEDECF.FormaTributLucro	IN ('3','4','5','7')AND
		@PeriodoApuracao			IN ('A00','T01','T02','T03','T04') AND
		@PeriodoApuracao			LIKE 'T%'			AND
		@Periodo					<> 0				AND
		SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1)	= 'P'


	-----------------------------------------------------------------------
	--- Bloco T
	-----------------------------------------------------------------------
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|T030|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataPeriodoFinal)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataPeriodoFinal)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataPeriodoFinal)),'') + '|'
	+	@PeriodoApuracao + '|',
	'T030',
	132 + @Periodo,
	0
	FROM tbSPEDECF (NOLOCK)
	WHERE
	tbSPEDECF.CodigoEmpresa					= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal					= @CodigoLocal		AND
	tbSPEDECF.DataInicial					= @DataInicial		AND
	tbSPEDECF.DataFinal						= @DataFinal		AND
	tbSPEDECF.FormaTributLucro				IN ('2','4','6','7')AND
	@PeriodoApuracao						IN ('T01','T02','T03','T04') AND
	SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1)	= 'A'


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|T120|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'T120',
	132 + @Periodo,
	'T120'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.PeriodoApuracao	= @PeriodoApuracao	AND
	lancto.Registro			= 'T120'			AND
	tbSPEDECF.FormaTributLucro					IN ('2','4','6','7')	AND
	@PeriodoApuracao							IN ('T01','T02','T03','T04') AND
	@PeriodoApuracao							LIKE 'T%'				AND
	SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1)	= 'A'


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|T150|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'T150',
	132 + @Periodo,
	'T150'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.PeriodoApuracao	= @PeriodoApuracao	AND
	lancto.Registro			= 'T150'			AND
	tbSPEDECF.FormaTributLucro					IN ('2','4','6','7')	AND
	@PeriodoApuracao							IN ('T01','T02','T03','T04') AND
	@PeriodoApuracao							LIKE 'T%'				AND
	SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1)	= 'A'


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|T170|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'T170',
	132 + @Periodo,
	'T170'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.PeriodoApuracao	= @PeriodoApuracao	AND
	lancto.Registro			= 'T170'			AND
	tbSPEDECF.FormaTributLucro					IN ('2','4','6','7')	AND
	@PeriodoApuracao							IN ('T01','T02','T03','T04') AND
	@PeriodoApuracao							LIKE 'T%'				AND
	SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1)	= 'A'


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|T181|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'T181',
	132 + @Periodo,
	'T181'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.PeriodoApuracao	= @PeriodoApuracao	AND
	lancto.Registro			= 'T181'			AND
	tbSPEDECF.FormaTributLucro					IN ('2','4','6','7')	AND
	@PeriodoApuracao							IN ('T01','T02','T03','T04') AND
	@PeriodoApuracao							LIKE 'T%'				AND
	SUBSTRING(tbSPEDECF.FormaTributTrimestres,@Trimestre,1)	= 'A'


	-----------------------------------------------------------------------
	--- Bloco U
	-----------------------------------------------------------------------
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|U030|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataInicial)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataInicial)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataInicial)),'') + '|'
	+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,@DataPeriodoFinal)),2,2) +
		SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,@DataPeriodoFinal)),2,2) +
		CONVERT(CHAR(4),DATEPART(year,@DataPeriodoFinal)),'') + '|'
	+	@PeriodoApuracao + '|',
	'U030',
	147 + @Periodo,
	0
	FROM tbSPEDECF (NOLOCK)
	WHERE
	tbSPEDECF.CodigoEmpresa					= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal					= @CodigoLocal		AND
	tbSPEDECF.DataInicial					= @DataInicial		AND
	tbSPEDECF.DataFinal						= @DataFinal		AND
	tbSPEDECF.FormaTributLucro				IN ('8','9')		AND
	@PeriodoApuracao						IN ('A00','T01','T02','T03','T04')


	-- Balanço Patrimonial
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|U100|'
	+	RTRIM(LTRIM(CONVERT(VARCHAR(255),COALESCE(tbPlanoContas.ContaReferencialSPED,'')))) + '|'
	+	RTRIM(LTRIM(tbPlanoContasReferencial.DescricaoContaReferencial)) + '|'
	+	RTRIM(LTRIM(tbPlanoContasReferencial.SinteticaAnalitica)) + '|'
	+	RTRIM(LTRIM(tbPlanoContasReferencial.GrauContaReferencial)) + '|'
	+	RTRIM(LTRIM(COALESCE(tbPlanoContas.NaturezaConta,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(tbPlanoContasReferencial.ContaSintetica,''))) + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SUM(SaldoAnterior))),'.',',') + '|'
	+	CASE WHEN SUM(SaldoAnterior) < 0 THEN 'C' ELSE 'D' END + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SUM(SaldoAtual))),'.',',') + '|'
	+	CASE WHEN SUM(SaldoAtual) < 0 THEN 'C' ELSE 'D' END + '|',
	'U100',
	147 + @Periodo,
	tbPlanoContas.ContaReferencialSPED
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN	tbPlanoContas (NOLOCK) ON
				tbPlanoContas.CodigoEmpresa = tbSPEDECF.CodigoEmpresa
	INNER JOIN rtBalanceteSPED (NOLOCK) ON
				tbPlanoContas.CodigoContaContabil = rtBalanceteSPED.CodigoContaContabil
	INNER JOIN	tbPlanoContasReferencial (NOLOCK) ON
				tbPlanoContasReferencial.CodigoEmpresa = tbPlanoContas.CodigoEmpresa AND
				tbPlanoContasReferencial.CodigoContaReferencial = tbPlanoContas.ContaReferencialSPED
	WHERE
	@RecuperarECD							= 'F'				AND
	tbSPEDECF.CodigoEmpresa					= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal					= @CodigoLocal		AND
	tbSPEDECF.DataInicial					= @DataInicial		AND
	tbSPEDECF.DataFinal						= @DataFinal		AND
	tbPlanoContas.NaturezaConta				IN ('01','02','03')	AND
	( ABS(SaldoAnterior) + ABS(DebitoNoMes) + ABS(CreditoNoMes) + ABS(SaldoAtual) ) <> 0 AND
	@PeriodoApuracao						IN ('A00','T01','T02','T03','T04') AND
	tbSPEDECF.FormaTributLucro				IN ('8','9')
	GROUP BY
	tbPlanoContas.ContaReferencialSPED,
	tbPlanoContasReferencial.DescricaoContaReferencial,
	tbPlanoContasReferencial.SinteticaAnalitica,
	tbPlanoContasReferencial.GrauContaReferencial,
	tbPlanoContas.NaturezaConta,
	tbPlanoContasReferencial.ContaSintetica
	ORDER BY
	tbPlanoContas.ContaReferencialSPED
	
	

	INSERT rtSPEDECF
	SELECT
	@@spid,
		'|U150|'
	+	RTRIM(LTRIM(CONVERT(VARCHAR(255),COALESCE(tbPlanoContas.ContaReferencialSPED,'')))) + '|'
	+	RTRIM(LTRIM(tbPlanoContasReferencial.DescricaoContaReferencial)) + '|'
	+	RTRIM(LTRIM(tbPlanoContasReferencial.SinteticaAnalitica)) + '|'
	+	RTRIM(LTRIM(tbPlanoContasReferencial.GrauContaReferencial)) + '|'
	+	RTRIM(LTRIM(COALESCE(tbPlanoContas.NaturezaConta,''))) + '|'
	+	RTRIM(LTRIM(COALESCE(tbPlanoContasReferencial.ContaSintetica,''))) + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SUM(SaldoAnterior))),'.',',') + '|'
	+	CASE WHEN SUM(SaldoAnterior) < 0 THEN 'C' ELSE 'D' END + '|'
	+	REPLACE(CONVERT(VARCHAR(16),ABS(SUM(SaldoAtual))),'.',',') + '|'
	+	CASE WHEN SUM(SaldoAtual) < 0 THEN 'C' ELSE 'D' END + '|',
	'U150',
	147 + @Periodo,
	tbPlanoContas.ContaReferencialSPED
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN	tbPlanoContas (NOLOCK) ON
				tbPlanoContas.CodigoEmpresa = tbSPEDECF.CodigoEmpresa
	INNER JOIN rtBalanceteReceitaDespesa (NOLOCK) ON
				tbPlanoContas.CodigoContaContabil = rtBalanceteReceitaDespesa.CodigoContaContabil
	INNER JOIN	tbPlanoContasReferencial (NOLOCK) ON
				tbPlanoContasReferencial.CodigoEmpresa = tbPlanoContas.CodigoEmpresa AND
				tbPlanoContasReferencial.CodigoContaReferencial = tbPlanoContas.ContaReferencialSPED
	WHERE
	@RecuperarECD							= 'F'				AND
	tbSPEDECF.CodigoEmpresa					= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal					= @CodigoLocal		AND
	tbSPEDECF.DataInicial					= @DataInicial		AND
	tbSPEDECF.DataFinal						= @DataFinal		AND
	tbPlanoContas.NaturezaConta				IN ('04')	AND
	( ABS(SaldoAnterior) + ABS(DebitoNoMes) + ABS(CreditoNoMes) + ABS(SaldoAtual) ) <> 0 AND
	@PeriodoApuracao						IN ('A00','T01','T02','T03','T04') AND
	tbSPEDECF.FormaTributLucro				IN ('8','9')
	GROUP BY
	tbPlanoContas.ContaReferencialSPED,
	tbPlanoContasReferencial.DescricaoContaReferencial,
	tbPlanoContasReferencial.SinteticaAnalitica,
	tbPlanoContasReferencial.GrauContaReferencial,
	tbPlanoContas.NaturezaConta,
	tbPlanoContasReferencial.ContaSintetica
	ORDER BY
	tbPlanoContas.ContaReferencialSPED
	
	
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|U180|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'U180',
	147 + @Periodo,
	'U180'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.PeriodoApuracao	= @PeriodoApuracao	AND
	lancto.Registro			= 'U180'			AND
	@PeriodoApuracao						IN ('A00','T01','T02','T03','T04') AND
	tbSPEDECF.FormaTributLucro				IN ('8','9')


	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|U182|'
	+	tabela.Codigo + '|'
	+	tabela.Descricao + '|'
	+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
	'U182',
	147 + @Periodo,
	'U182'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
		lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
		lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
		lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
		lancto.DataFinal		=	tbSPEDECF.DataFinal			
	INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
		tabela.Registro			=	lancto.Registro				AND
		tabela.Codigo			=	lancto.Codigo
	WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.PeriodoApuracao	= @PeriodoApuracao	AND
	lancto.Registro			= 'U182'			AND
	@PeriodoApuracao						IN ('A00','T01','T02','T03','T04') AND
	tbSPEDECF.FormaTributLucro				IN ('8','9')


	-- Finaliza Período
	IF @Periodo = 0 AND @Intervalo = 3 DELETE rtSPEDECF WHERE TipoRegistro LIKE 'K%'
	IF @Periodo = 0 SELECT @DataPeriodoInicial = DATEADD(DAY,(DATEPART(DAY,@DataPeriodoInicial) * -1) + 1, DATEADD(MONTH,@Intervalo * -1,@DataPeriodoInicial))
	SELECT @Periodo = @Periodo + 1
	
	SELECT 
		@DataPeriodoInicial = DATEADD(MONTH,@Intervalo,@DataPeriodoInicial),
		@DataPeriodoFinal = DATEADD(DAY,-1,DATEADD(MONTH,@Intervalo,@DataPeriodoInicial)),
		@Contador = @Contador + 1
		
	IF @DataPeriodoFinal > @DataFinal SELECT @DataPeriodoFinal = @DataFinal

END


-----------------------------------------------------------------------
--- Identificação das Contas da Parte B
-----------------------------------------------------------------------
INSERT rtSPEDECF
SELECT 
@@spid,
	'|M010|'
+	conta.CodigoContaLalur + '|'
+	conta.DescricaoContaLalur + '|'
+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,conta.DataCriacaoConta)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,conta.DataCriacaoConta)),2,2) +
	CONVERT(CHAR(4),DATEPART(YEAR,conta.DataCriacaoConta)),'') + '|'
+	REPLACE(COALESCE(tabela.Codigo,''),'.','') + '|' +
+	COALESCE(tabela.Descricao,'') + '|' +
+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,conta.DataLimite)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,conta.DataLimite)),2,2) +
	CONVERT(CHAR(4),DATEPART(YEAR,conta.DataLimite)),'') + '|'
+	COALESCE(conta.TributoContaLalur,'') + '|' +
+	REPLACE(CASE WHEN conta.DataCriacaoConta BETWEEN @DataInicial AND @DataFinal THEN 0 ELSE COALESCE(conta.SaldoContaLalur,0) END,'.',',') + '|'
+	CASE WHEN conta.DataCriacaoConta BETWEEN @DataInicial AND @DataFinal THEN 'D' ELSE COALESCE(conta.DebCredContaLalur,'D') END + '|'
+	'|',
'M010',
47,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbContaLalur conta (NOLOCK) ON
	tbSPEDECF.CodigoEmpresa = conta.CodigoEmpresa
LEFT JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
	tabela.Registro			= CASE WHEN COALESCE(conta.TributoContaLalur,'') = 'I' THEN 'M300' ELSE 'M350' END	AND
	tabela.Codigo			= conta.TipoLancamentoConta
WHERE
		tbSPEDECF.CodigoEmpresa					= @CodigoEmpresa	AND
		tbSPEDECF.CodigoLocal					= @CodigoLocal		AND
		tbSPEDECF.DataInicial					= @DataInicial		AND
		tbSPEDECF.DataFinal						= @DataFinal		AND
		tbSPEDECF.FormaTributLucro				IN ('1','2','3','4')


-----------------------------------------------------------------------
--- BLOCO X
-----------------------------------------------------------------------
DECLARE 
	@TipoBeneficio				VARCHAR(30)	,
	@TipoProjeto				VARCHAR(30)	,
	@AtoConcessorio				VARCHAR(400),
	@VigenciaInicio				VARCHAR(90)	,
	@VigenciaFim				VARCHAR(90)	,
	@auxTipoBeneficio			VARCHAR(30)	,
	@auxTipoProjeto				VARCHAR(30)	,
	@auxAtoConcessorio			VARCHAR(400),
	@auxVigenciaInicio			VARCHAR(90)	,
	@auxVigenciaFim				VARCHAR(90)	

SELECT
	@TipoBeneficio			= COALESCE(TipoBeneficio,''),
	@TipoProjeto			= COALESCE(TipoProjeto,''),
	@AtoConcessorio			= COALESCE(AtoConcessorio,''),
	@VigenciaInicio			= COALESCE(VigenciaInicio,''),
	@VigenciaFim			= COALESCE(VigenciaFim,'')
FROM tbSPEDECF
WHERE
tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
tbSPEDECF.DataInicial	= @DataInicial		AND
tbSPEDECF.DataFinal		= @DataFinal

WHILE @TipoBeneficio <> ''
BEGIN
	
	SELECT @auxTipoBeneficio = SUBSTRING(@TipoBeneficio, 1, CHARINDEX('|', @TipoBeneficio, 1) - 1)
	SELECT @auxTipoProjeto = SUBSTRING(@TipoProjeto, 1, CHARINDEX('|', @TipoProjeto, 1) - 1)
	SELECT @auxAtoConcessorio = SUBSTRING(@AtoConcessorio, 1, CHARINDEX('|', @AtoConcessorio, 1) - 1)
	SELECT @auxVigenciaInicio = SUBSTRING(@VigenciaInicio, 1, CHARINDEX('|', @VigenciaInicio, 1) - 1)
	SELECT @auxVigenciaFim = SUBSTRING(@VigenciaFim, 1, CHARINDEX('|', @VigenciaFim, 1) - 1)

	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|X280|'
	+	@auxTipoBeneficio + '|'
	+	@auxTipoProjeto + '|'
	+	@auxAtoConcessorio + '|'
	+	@auxVigenciaInicio + '|'
	+	@auxVigenciaFim + '|',
	'X280',
	163,
	'X280'+@auxTipoBeneficio+@auxTipoProjeto+'00'
	FROM tbSPEDECF (NOLOCK)
	WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	(
		(
			tbSPEDECF.LucroExploracao = 'V' AND
			tbSPEDECF.FormaTributLucro IN ('1','2','3','4')
		) OR
		(
			tbSPEDECF.FormaTributLucro IN ('5','7') AND
			tbSPEDECF.OptanteREFIS = 'V' AND
			tbSPEDECF.IsenReducLucroPresumido = 'V'
		)
	)

	SELECT @TipoBeneficio = RIGHT(@TipoBeneficio, LEN(@TipoBeneficio) - LEN(@auxTipoBeneficio) - 1)
	SELECT @TipoProjeto = RIGHT(@TipoProjeto, LEN(@TipoProjeto) - LEN(@auxTipoProjeto) - 1)
	SELECT @AtoConcessorio = RIGHT(@AtoConcessorio, LEN(@AtoConcessorio) - LEN(@auxAtoConcessorio) - 1)
	SELECT @VigenciaInicio = RIGHT(@VigenciaInicio, LEN(@VigenciaInicio) - LEN(@auxVigenciaInicio) - 1)
	SELECT @VigenciaFim = RIGHT(@VigenciaFim, LEN(@VigenciaFim) - LEN(@auxVigenciaFim) - 1)

	SELECT @auxTipoBeneficio = ''
	SELECT @auxTipoProjeto = ''
	SELECT @auxAtoConcessorio = ''
	SELECT @auxVigenciaInicio = ''
	SELECT @auxVigenciaFim = ''

END


INSERT rtSPEDECF
SELECT 
@@spid,
	'|X291|'
+	tabela.Codigo + '|'
+	tabela.Descricao + '|'
+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
'X291',
163,
'X291'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
	lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
	lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
	lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
	lancto.DataFinal		=	tbSPEDECF.DataFinal			
INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
	tabela.Registro			=	lancto.Registro				AND
	tabela.Codigo			=	lancto.Codigo
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.Registro			= 'X291'			AND
	tbSPEDECF.OperacaoExterior = 'V'			AND
	tbSPEDECF.OperacaoPessoaVinculada = 'V'		AND
	tbSPEDECF.FormaTributLucro NOT IN ('8','9')


INSERT rtSPEDECF
SELECT 
@@spid,
	'|X292|'
+	tabela.Codigo + '|'
+	tabela.Descricao + '|'
+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
'X292',
164,
'X292'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
	lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
	lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
	lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
	lancto.DataFinal		=	tbSPEDECF.DataFinal			
INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
	tabela.Registro			=	lancto.Registro				AND
	tabela.Codigo			=	lancto.Codigo
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.Registro			= 'X292'			AND
	tbSPEDECF.OperacaoExterior = 'V'			AND
	tbSPEDECF.OperacaoPessoaVinculada = 'F'		AND
	tbSPEDECF.FormaTributLucro NOT IN ('8','9')


INSERT rtSPEDECF
SELECT 
@@spid,
	'|X300|'
+	CONVERT(VARCHAR(4),X300.NumeroOrdem) + '|'
+	RIGHT('00'+CONVERT(VARCHAR(2),X300.TipoExportacao),2) + '|'
+	X300.DescricaoExportacao + '|'
+	REPLACE(CONVERT(VARCHAR(16),X300.TotalOperacao),'.',',') + '|'
+	CASE WHEN COALESCE(X300.CodigoNCM,0) = 0 THEN '' ELSE CONVERT(VARCHAR(8),X300.CodigoNCM) END + '|'
+	CASE WHEN COALESCE(X300.Quantidade,0) = 0 THEN '' ELSE REPLACE(CONVERT(VARCHAR(16),X300.Quantidade),'.',',') END + '|'
+	RTRIM(LTRIM(X300.UnidadeMedida)) + '|'
+	CASE WHEN X300.SujeitaArbitramento = 'V' THEN 'S' ELSE 'N' END + '|'
+	RTRIM(LTRIM(X300.TipoMetodo)) + '|'
+	CASE WHEN COALESCE(X300.ValorParametro,0) = 0 THEN '' ELSE REPLACE(CONVERT(VARCHAR(16),X300.ValorParametro),'.',',') END + '|'
+	CASE WHEN COALESCE(X300.ValorPraticado,0) = 0 THEN '' ELSE REPLACE(CONVERT(VARCHAR(16),X300.ValorPraticado),'.',',') END + '|'
+	CASE WHEN COALESCE(X300.ValorAjuste,0) = 0 THEN '' ELSE REPLACE(CONVERT(VARCHAR(16),X300.ValorAjuste),'.',',') END + '|'
+	CASE WHEN COALESCE(X300.ValorJuros,0) = 0 THEN '' ELSE REPLACE(CONVERT(VARCHAR(16),X300.ValorJuros),'.',',') END + '|'
+	CASE WHEN COALESCE(X300.TaxaJurosMinima,0) = 0 THEN '' ELSE REPLACE(CONVERT(VARCHAR(16),X300.TaxaJurosMinima),'.',',') END + '|'
+	CASE WHEN COALESCE(X300.TaxaJurosMaxima,0) = 0 THEN '' ELSE REPLACE(CONVERT(VARCHAR(16),X300.TaxaJurosMaxima),'.',',') END + '|'
+	CASE WHEN COALESCE(X300.CodigoCNC,0) = 0 THEN '' ELSE CONVERT(VARCHAR(8),X300.CodigoCNC) END + '|'
+	RTRIM(LTRIM(X300.Moeda)) + '|',
'X300',
165,
'X300'+RIGHT('0000'+CONVERT(VARCHAR(4),X300.NumeroOrdem),4)
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegX300 X300 (NOLOCK) ON
	X300.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
	X300.CodigoLocal	=	tbSPEDECF.CodigoLocal		AND
	X300.DataInicial	=	tbSPEDECF.DataInicial		AND
	X300.DataFinal		=	tbSPEDECF.DataFinal			
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		


INSERT rtSPEDECF
SELECT
@@spid,
	'|X310|'
+	X310.Nome + '|'
+	CONVERT(VARCHAR(4),X310.Pais) + '|'
+	REPLACE(CONVERT(VARCHAR(16),X310.ValorOperacao),'.',',') + '|'
+	RIGHT('00'+CONVERT(VARCHAR(2),X310.CondicaoPessoa),2) + '|',
'X310',
165,
'X300'+RIGHT('0000'+CONVERT(VARCHAR(4),X310.NumeroOrdem),4)+X310.Nome
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegX300 X300 (NOLOCK) ON
	X300.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
	X300.CodigoLocal	=	tbSPEDECF.CodigoLocal		AND
	X300.DataInicial	=	tbSPEDECF.DataInicial		AND
	X300.DataFinal		=	tbSPEDECF.DataFinal			
INNER JOIN tbSPEDECFRegX310 X310 (NOLOCK) ON
	X310.CodigoEmpresa	=	X300.CodigoEmpresa		AND
	X310.CodigoLocal	=	X300.CodigoLocal		AND
	X310.DataInicial	=	X300.DataInicial		AND
	X310.DataFinal		=	X300.DataFinal			AND
	X310.NumeroOrdem	=	X300.NumeroOrdem		
	
	
INSERT rtSPEDECF
SELECT 
@@spid,
	'|X320|'
+	CONVERT(VARCHAR(4),X320.NumeroOrdem) + '|'
+	RIGHT('00'+CONVERT(VARCHAR(2),X320.TipoImportacao),2) + '|'
+	X320.DescricaoImportacao + '|'
+	REPLACE(CONVERT(VARCHAR(16),X320.TotalOperacao),'.',',') + '|'
+	CASE WHEN COALESCE(X320.CodigoNCM,0) = 0 THEN '' ELSE CONVERT(VARCHAR(8),X320.CodigoNCM) END + '|'
+	CASE WHEN COALESCE(X320.Quantidade,0) = 0 THEN '' ELSE REPLACE(CONVERT(VARCHAR(16),X320.Quantidade),'.',',') END + '|'
+	RTRIM(LTRIM(X320.UnidadeMedida)) + '|'
+	RTRIM(LTRIM(X320.TipoMetodo)) + '|'
+	CASE WHEN COALESCE(X320.ValorParametro,0) = 0 THEN '' ELSE REPLACE(CONVERT(VARCHAR(16),X320.ValorParametro),'.',',') END + '|'
+	CASE WHEN COALESCE(X320.ValorPraticado,0) = 0 THEN '' ELSE REPLACE(CONVERT(VARCHAR(16),X320.ValorPraticado),'.',',') END + '|'
+	CASE WHEN COALESCE(X320.ValorAjuste,0) = 0 THEN '' ELSE REPLACE(CONVERT(VARCHAR(16),X320.ValorAjuste),'.',',') END + '|'
+	CASE WHEN COALESCE(X320.ValorJuros,0) = 0 THEN '' ELSE REPLACE(CONVERT(VARCHAR(16),X320.ValorJuros),'.',',') END + '|'
+	CASE WHEN COALESCE(X320.TaxaJurosMinima,0) = 0 THEN '' ELSE REPLACE(CONVERT(VARCHAR(16),X320.TaxaJurosMinima),'.',',') END + '|'
+	CASE WHEN COALESCE(X320.TaxaJurosMaxima,0) = 0 THEN '' ELSE REPLACE(CONVERT(VARCHAR(16),X320.TaxaJurosMaxima),'.',',') END + '|'
+	CASE WHEN COALESCE(X320.CodigoCNC,0) = 0 THEN '' ELSE CONVERT(VARCHAR(8),X320.CodigoCNC) END + '|'
+	RTRIM(LTRIM(X320.Moeda)) + '|',
'X320',
165,
'X320'+RIGHT('0000'+CONVERT(VARCHAR(4),X320.NumeroOrdem),4)
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegX320 X320 (NOLOCK) ON
	X320.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
	X320.CodigoLocal	=	tbSPEDECF.CodigoLocal		AND
	X320.DataInicial	=	tbSPEDECF.DataInicial		AND
	X320.DataFinal		=	tbSPEDECF.DataFinal			
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		


INSERT rtSPEDECF
SELECT
@@spid,
	'|X330|'
+	X330.Nome + '|'
+	CONVERT(VARCHAR(4),X330.Pais) + '|'
+	REPLACE(CONVERT(VARCHAR(16),X330.ValorOperacao),'.',',') + '|'
+	RIGHT('00'+CONVERT(VARCHAR(2),X330.CondicaoPessoa),2) + '|',
'X330',
165,
'X320'+RIGHT('0000'+CONVERT(VARCHAR(4),X330.NumeroOrdem),4)+X330.Nome
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegX320 X320 (NOLOCK) ON
	X320.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
	X320.CodigoLocal	=	tbSPEDECF.CodigoLocal		AND
	X320.DataInicial	=	tbSPEDECF.DataInicial		AND
	X320.DataFinal		=	tbSPEDECF.DataFinal			
INNER JOIN tbSPEDECFRegX330 X330 (NOLOCK) ON
	X330.CodigoEmpresa	=	X320.CodigoEmpresa		AND
	X330.CodigoLocal	=	X320.CodigoLocal		AND
	X330.DataInicial	=	X320.DataInicial		AND
	X330.DataFinal		=	X320.DataFinal			AND
	X330.NumeroOrdem	=	X320.NumeroOrdem		
	
	
INSERT rtSPEDECF
SELECT 
@@spid,
	'|X390|'
+	tabela.Codigo + '|'
+	tabela.Descricao + '|'
+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
'X390',
168,
'X390'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
	lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
	lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
	lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
	lancto.DataFinal		=	tbSPEDECF.DataFinal			
INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
	tabela.Registro			=	lancto.Registro				AND
	tabela.Codigo			=	lancto.Codigo
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.Registro			= 'X390'			AND
	tbSPEDECF.FormaTributLucro IN ('8','9')


INSERT rtSPEDECF
SELECT 
@@spid,
	'|X400|'
+	tabela.Codigo + '|'
+	tabela.Descricao + '|'
+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
'X400',
169,
'X400'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
	lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
	lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
	lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
	lancto.DataFinal		=	tbSPEDECF.DataFinal			
INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
	tabela.Registro			=	lancto.Registro				AND
	tabela.Codigo			=	lancto.Codigo
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.Registro			= 'X400'			AND
	tbSPEDECF.ECommerceTI	= 'V'


INSERT rtSPEDECF
SELECT 
@@spid,
	'|X410|'
+	COALESCE(ECommerceCodPais,'') + '|'
+	CASE WHEN ECommerceHomePage = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN ECommerceServidor = 'V' THEN 'S' ELSE 'N' END + '|',
'X410',
170,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.ECommerceTI	= 'V'


INSERT rtSPEDECF
SELECT 
@@spid,
	'|X420|'
+	tbSPEDECFRegX420.TipoRoyalties + '|'
+	tbSPEDECFRegX420.Pais + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX420.ValorDireitoSoftware),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX420.ValorDireitoAutoral),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX420.ValorMarca),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX420.ValorPatente),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX420.ValorKnowHow),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX420.ValorFranquia),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX420.ValorPropIntelectual),'.',',') + '|',
'X420',
171,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegX420 (NOLOCK) ON
	tbSPEDECFRegX420.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa	AND
	tbSPEDECFRegX420.CodigoLocal	=	tbSPEDECF.CodigoLocal	AND
	tbSPEDECFRegX420.DataInicial	=	tbSPEDECF.DataInicial	AND
	tbSPEDECFRegX420.DataFinal		=	tbSPEDECF.DataFinal
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	(
		tbSPEDECF.RoyaltiesRecebidos = 'V' OR
		tbSPEDECF.RoyaltiesPagos = 'V'
	)


INSERT rtSPEDECF
SELECT 
@@spid,
	'|X430|'
+	tbSPEDECFRegX430.Pais + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX430.ValorAssistComTranf),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX430.ValorAssistSemTranfBR),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX430.ValorAssistSemTranfEX),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX430.ValorJurosCapitalProp),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX430.ValorJurosDemais),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX430.ValorDividendos),'.',',') + '|',
'X430',
172,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegX430 (NOLOCK) ON
	tbSPEDECFRegX430.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa	AND
	tbSPEDECFRegX430.CodigoLocal	=	tbSPEDECF.CodigoLocal	AND
	tbSPEDECFRegX430.DataInicial	=	tbSPEDECF.DataInicial	AND
	tbSPEDECFRegX430.DataFinal		=	tbSPEDECF.DataFinal
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.RendimentoServicos = 'V'


INSERT rtSPEDECF
SELECT 
@@spid,
	'|X450|'
+	tbSPEDECFRegX450.Pais + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX450.ValorAssistComTranf),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX450.ValorAssistSemTranfBR),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX450.ValorAssistSemTranfEX),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX450.ValorJurosCapitalPropPF),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX450.ValorJurosCapitalPropPJ),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX450.ValorJurosDemais),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX450.ValorDividendosPF),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegX450.ValorDividendosPJ),'.',',') + '|',
'X450',
173,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegX450 (NOLOCK) ON
	tbSPEDECFRegX450.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa	AND
	tbSPEDECFRegX450.CodigoLocal	=	tbSPEDECF.CodigoLocal	AND
	tbSPEDECFRegX450.DataInicial	=	tbSPEDECF.DataInicial	AND
	tbSPEDECFRegX450.DataFinal		=	tbSPEDECF.DataFinal
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.PagamentoServicos = 'V'


INSERT rtSPEDECF
SELECT 
@@spid,
	'|X460|'
+	tabela.Codigo + '|'
+	tabela.Descricao + '|'
+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
'X460',
174,
'X460'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
	lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
	lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
	lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
	lancto.DataFinal		=	tbSPEDECF.DataFinal			
INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
	tabela.Registro			=	lancto.Registro				AND
	tabela.Codigo			=	lancto.Codigo
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.Registro			= 'X460'			AND
	tbSPEDECF.InovDesenvTecnologico = 'V'		AND
	tbSPEDECF.FormaTributLucro NOT IN ('8','9')


INSERT rtSPEDECF
SELECT 
@@spid,
	'|X470|'
+	tabela.Codigo + '|'
+	tabela.Descricao + '|'
+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
'X470',
175,
'X470'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
	lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
	lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
	lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
	lancto.DataFinal		=	tbSPEDECF.DataFinal			
INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
	tabela.Registro			=	lancto.Registro				AND
	tabela.Codigo			=	lancto.Codigo
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.Registro			= 'X470'			AND
	tbSPEDECF.CapacitacaoInformatica = 'V'		AND
	tbSPEDECF.FormaTributLucro NOT IN ('8','9')


INSERT rtSPEDECF
SELECT 
@@spid,
	'|X480|'
+	tabela.Codigo + '|'
+	tabela.Descricao + '|'
+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
'X480',
176,
'X480'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
	lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
	lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
	lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
	lancto.DataFinal		=	tbSPEDECF.DataFinal			
INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
	tabela.Registro			=	lancto.Registro				AND
	tabela.Codigo			=	lancto.Codigo
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.Registro			= 'X480'			AND
	tbSPEDECF.HabilitadaRepesRecapEtc = 'V'		AND
	tbSPEDECF.FormaTributLucro NOT IN ('8','9')


INSERT rtSPEDECF
SELECT 
@@spid,
	'|X490|'
+	tabela.Codigo + '|'
+	tabela.Descricao + '|'
+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
'X490',
177,
'X490'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
	lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
	lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
	lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
	lancto.DataFinal		=	tbSPEDECF.DataFinal			
INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
	tabela.Registro			=	lancto.Registro				AND
	tabela.Codigo			=	lancto.Codigo
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.Registro			= 'X490'			AND
	tbSPEDECF.PoloIndManaus = 'V'				AND
	tbSPEDECF.FormaTributLucro NOT IN ('8','9')


INSERT rtSPEDECF
SELECT 
@@spid,
	'|X500|'
+	tabela.Codigo + '|'
+	tabela.Descricao + '|'
+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
'X500',
178,
'X500'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
	lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
	lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
	lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
	lancto.DataFinal		=	tbSPEDECF.DataFinal			
INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
	tabela.Registro			=	lancto.Registro				AND
	tabela.Codigo			=	lancto.Codigo
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.Registro			= 'X500'			AND
	tbSPEDECF.ZonaProcessExportacao = 'V'		AND
	tbSPEDECF.FormaTributLucro NOT IN ('8','9')


INSERT rtSPEDECF
SELECT 
@@spid,
	'|X510|'
+	tabela.Codigo + '|'
+	tabela.Descricao + '|'
+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
'X510',
179,
'X510'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
	lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
	lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
	lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
	lancto.DataFinal		=	tbSPEDECF.DataFinal			
INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
	tabela.Registro			=	lancto.Registro				AND
	tabela.Codigo			=	lancto.Codigo
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.Registro			= 'X510'			AND
	tbSPEDECF.AreaLivreComercio = 'V'			AND
	tbSPEDECF.FormaTributLucro NOT IN ('8','9')



-----------------------------------------------------------------------
--- BLOCO Y
-----------------------------------------------------------------------
INSERT rtSPEDECF
SELECT 
@@spid,
	'|Y520|'
+	tbSPEDECFRegY520.RendimentoPagoRecebido + '|'
+	tbSPEDECFRegY520.Pais + '|'
+	tbSPEDECFRegY520.FormaRecebimento + '|'
+	tbSPEDECFRegY520.NaturezaOperacao + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY520.ValorRecebimento),'.',',') + '|',
'Y520',
182,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegY520 (NOLOCK) ON
	tbSPEDECFRegY520.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa	AND
	tbSPEDECFRegY520.CodigoLocal	=	tbSPEDECF.CodigoLocal	AND
	tbSPEDECFRegY520.DataInicial	=	tbSPEDECF.DataInicial	AND
	tbSPEDECFRegY520.DataFinal		=	tbSPEDECF.DataFinal
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	(
		tbSPEDECF.RendimentoExterior = 'V' OR
		tbSPEDECF.PagtoExterior = 'V'
	)


INSERT rtSPEDECF
SELECT 
@@spid,
	'|Y540|'
+	tbSPEDECFRegY540.CNPJ + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY540.ValorReceita),'.',',') + '|'
+	tbSPEDECFRegY540.CNAE + '|',
'Y540',
183,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegY540 (NOLOCK) ON
	tbSPEDECFRegY540.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa	AND
	tbSPEDECFRegY540.CodigoLocal	=	tbSPEDECF.CodigoLocal	AND
	tbSPEDECFRegY540.DataInicial	=	tbSPEDECF.DataInicial	AND
	tbSPEDECFRegY540.DataFinal		=	tbSPEDECF.DataFinal
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		


INSERT rtSPEDECF
SELECT 
@@spid,
	'|Y550|'
+	tbSPEDECFRegY550.CNPJ + '|'
+	tbSPEDECFRegY550.CodigoNCM + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY550.ValorVenda),'.',',') + '|',
'Y550',
184,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegY550 (NOLOCK) ON
	tbSPEDECFRegY550.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa	AND
	tbSPEDECFRegY550.CodigoLocal	=	tbSPEDECF.CodigoLocal	AND
	tbSPEDECFRegY550.DataInicial	=	tbSPEDECF.DataInicial	AND
	tbSPEDECFRegY550.DataFinal		=	tbSPEDECF.DataFinal
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.VendaExportadora = 'V'			AND
	tbSPEDECF.FormaTributLucro NOT IN ('8','9')


INSERT rtSPEDECF
SELECT 
@@spid,
	'|Y560|'
+	tbSPEDECFRegY560.CNPJ + '|'
+	tbSPEDECFRegY560.CodigoNCM + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY560.ValorCompra),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY560.ValorExportacao),'.',',') + '|',
'Y560',
185,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegY560 (NOLOCK) ON
	tbSPEDECFRegY560.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa	AND
	tbSPEDECFRegY560.CodigoLocal	=	tbSPEDECF.CodigoLocal	AND
	tbSPEDECFRegY560.DataInicial	=	tbSPEDECF.DataInicial	AND
	tbSPEDECFRegY560.DataFinal		=	tbSPEDECF.DataFinal
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.PJComercialExportadora = 'V'		AND
	tbSPEDECF.FormaTributLucro NOT IN ('8','9')


INSERT rtSPEDECF
SELECT 
@@spid,
	'|Y570|'
+	tbSPEDECFRegY570.CNPJ + '|'
+	tbSPEDECFRegY570.NomeEmpresa + '|'
+	CASE WHEN tbSPEDECFRegY570.OrgaoPublico = 'V' THEN 'S' ELSE 'N' END + '|'
+	tbSPEDECFRegY570.CodigoReceita + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY570.RendimentoBruto),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY570.ValorIRRF),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY570.ValorCSLL),'.',',') + '|',
'Y570',
186,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegY570 (NOLOCK) ON
	tbSPEDECFRegY570.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa	AND
	tbSPEDECFRegY570.CodigoLocal	=	tbSPEDECF.CodigoLocal	AND
	tbSPEDECFRegY570.DataInicial	=	tbSPEDECF.DataInicial	AND
	tbSPEDECFRegY570.DataFinal		=	tbSPEDECF.DataFinal
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.FormaTributLucro NOT IN ('8','9')


INSERT rtSPEDECF
SELECT 
@@spid,
	'|Y580|'
+	tbSPEDECFRegY580.CNPJ + '|'
+	tbSPEDECFRegY580.TipoBeneficiario + '|'
+	tbSPEDECFRegY580.FormaDoacao + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY580.ValorDoacao),'.',',') + '|',
'Y580',
187,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegY580 (NOLOCK) ON
	tbSPEDECFRegY580.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa	AND
	tbSPEDECFRegY580.CodigoLocal	=	tbSPEDECF.CodigoLocal	AND
	tbSPEDECFRegY580.DataInicial	=	tbSPEDECF.DataInicial	AND
	tbSPEDECFRegY580.DataFinal		=	tbSPEDECF.DataFinal
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.DoacaoEleitoral = 'V'				AND
	tbSPEDECF.FormaTributLucro NOT IN ('8','9')


INSERT rtSPEDECF
SELECT 
@@spid,
	'|Y590|'
+	tbSPEDECFRegY590.TipoAtivo + '|'
+	tbSPEDECFRegY590.Pais + '|'
+	tbSPEDECFRegY590.Discriminacao + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY590.ValorAnterior),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY590.ValorAtual),'.',',') + '|',
'Y590',
188,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegY590 (NOLOCK) ON
	tbSPEDECFRegY590.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa	AND
	tbSPEDECFRegY590.CodigoLocal	=	tbSPEDECF.CodigoLocal	AND
	tbSPEDECFRegY590.DataInicial	=	tbSPEDECF.DataInicial	AND
	tbSPEDECFRegY590.DataFinal		=	tbSPEDECF.DataFinal
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.AtivosExterior = 'V'


INSERT rtSPEDECF
SELECT 
@@spid,
	'|Y600|'
+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbSPEDECFRegY600.DataEntradaSocio)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbSPEDECFRegY600.DataEntradaSocio)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbSPEDECFRegY600.DataEntradaSocio)) + '|'
+	COALESCE(SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbSPEDECFRegY600.DataSaidaSocio)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbSPEDECFRegY600.DataSaidaSocio)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbSPEDECFRegY600.DataSaidaSocio)),'') + '|'
+	tbSPEDECFRegY600.Pais + '|'
+	'P' + tbSPEDECFRegY600.PessoaFisicaJuridica + '|'
+	tbSPEDECFRegY600.CPFCNPJ + '|'
+	tbSPEDECFRegY600.NomeSocio + '|'
+	RIGHT('0' + tbSPEDECFRegY600.QualificacaoSocio,2) + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY600.PercCapitalTotal),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY600.PercCapitalVotante),'.',',') + '|'
+	tbSPEDECFRegY600.CPFRepresentante + '|'
+	CASE WHEN tbSPEDECFRegY600.QualifRepresentante = '' THEN
		''
	ELSE
		RIGHT('0'+tbSPEDECFRegY600.QualifRepresentante,2)
	END + '|'
-- VERSÃO 0002
+	CASE WHEN @Versao >= '0002' THEN
			REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY600.RemuneracaoTrabalho),'.',',') + '|'
		+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY600.LucrosDividendos),'.',',') + '|'
		+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY600.JurosCapitalProprio),'.',',') + '|'
		+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY600.DemaisRendimentos),'.',',') + '|'
		+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY600.IRRFRendimentos),'.',',') + '|'
	ELSE
		''
	END,
'Y600',
189,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegY600 (NOLOCK) ON
	tbSPEDECFRegY600.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa	AND
	tbSPEDECFRegY600.CodigoLocal	=	tbSPEDECF.CodigoLocal	AND
	tbSPEDECFRegY600.DataInicial	=	tbSPEDECF.DataInicial	AND
	tbSPEDECFRegY600.DataFinal		=	tbSPEDECF.DataFinal
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.FormaTributLucro IN ('1','2','3','4','5','6','7')


-- VERSÃO 0001
IF @Versao < '0002'
BEGIN
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|Y611|'
	+	tbSPEDECFRegY600.Pais + '|'
	+	'P' + tbSPEDECFRegY600.PessoaFisicaJuridica + '|'
	+	tbSPEDECFRegY600.CPFCNPJ + '|'
	+	tbSPEDECFRegY600.NomeSocio + '|'
	+	RIGHT('0' + tbSPEDECFRegY600.QualificacaoSocio,2) + '|'
	+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY600.RemuneracaoTrabalho),'.',',') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY600.LucrosDividendos),'.',',') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY600.JurosCapitalProprio),'.',',') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY600.DemaisRendimentos),'.',',') + '|'
	+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY600.IRRFRendimentos),'.',',') + '|',
	'Y611',
	190,
	0
	FROM tbSPEDECF (NOLOCK)
	INNER JOIN tbSPEDECFRegY600 (NOLOCK) ON
		tbSPEDECFRegY600.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa	AND
		tbSPEDECFRegY600.CodigoLocal	=	tbSPEDECF.CodigoLocal	AND
		tbSPEDECFRegY600.DataInicial	=	tbSPEDECF.DataInicial	AND
		tbSPEDECFRegY600.DataFinal		=	tbSPEDECF.DataFinal
	WHERE
		tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
		tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
		tbSPEDECF.DataInicial	= @DataInicial		AND
		tbSPEDECF.DataFinal		= @DataFinal		AND
		tbSPEDECF.FormaTributLucro IN ('1','2','3','4','5','6','7')
END


INSERT rtSPEDECF
SELECT 
@@spid,
	'|Y612|'
+	tbSPEDECFRegY600.CPFCNPJ + '|'
+	tbSPEDECFRegY600.NomeSocio + '|'
+	tbSPEDECFRegY600.QualificacaoSocio + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY600.RemuneracaoTrabalho),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY600.DemaisRendimentos),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY600.IRRFRendimentos),'.',',') + '|',
'Y612',
191,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegY600 (NOLOCK) ON
	tbSPEDECFRegY600.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa	AND
	tbSPEDECFRegY600.CodigoLocal	=	tbSPEDECF.CodigoLocal	AND
	tbSPEDECFRegY600.DataInicial	=	tbSPEDECF.DataInicial	AND
	tbSPEDECFRegY600.DataFinal		=	tbSPEDECF.DataFinal
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.FormaTributLucro IN ('8','9')


INSERT rtSPEDECF
SELECT 
@@spid,
	'|Y620|'
+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbSPEDECFRegY620.DataEvento)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbSPEDECFRegY620.DataEvento)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbSPEDECFRegY620.DataEvento)) + '|'
+	tbSPEDECFRegY620.TipoRelacionamento + '|'
+	tbSPEDECFRegY620.CodigoPais + '|'
+	tbSPEDECFRegY620.CNPJ + '|'
+	tbSPEDECFRegY620.NomeEmpresarial + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY620.ValorReais),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY620.ValorMoedaOriginal),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY620.PercCapitalTotal),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY620.PercCapitalVotante),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY620.ResultadoEquivalencia),'.',',') + '|'
+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbSPEDECFRegY620.DataAquisicao)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbSPEDECFRegY620.DataAquisicao)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbSPEDECFRegY620.DataAquisicao)) + '|'
+	CASE WHEN tbSPEDECFRegY620.ProcessoCartorio = 'V' THEN 'S' ELSE 'N' END + '|'
+	tbSPEDECFRegY620.NumeroRegistroCartorio + '|'
+	tbSPEDECFRegY620.NomeEnderecoCartorio + '|'
+	CASE WHEN tbSPEDECFRegY620.ProcessoRFB = 'V' THEN 'S' ELSE 'N' END + '|'
+	tbSPEDECFRegY620.NumeroRegistroRFB + '|',
'Y620',
192,
0
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegY620 (NOLOCK) ON
	tbSPEDECFRegY620.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa	AND
	tbSPEDECFRegY620.CodigoLocal	=	tbSPEDECF.CodigoLocal	AND
	tbSPEDECFRegY620.DataInicial	=	tbSPEDECF.DataInicial	AND
	tbSPEDECFRegY620.DataFinal		=	tbSPEDECF.DataFinal
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.ParticipacaoColigadas = 'V'		AND
	tbSPEDECF.FormaTributLucro NOT IN ('8','9')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y671|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.AquisicaoMaquinas),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.DoacaoFundoCrianca),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.DoacaoFundoIdoso),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.AquisicaoImobilizado),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.BaixasImobilizado),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.BensIncentivoInicio),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.BensIncentivoFinal),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.CreditoCSLLDepreciacao),'.',',') + '|'
--	+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.DifCapitalxValorCont),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.OperCambioIsentoIOF),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.TotalFolhaSujAliqRed),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.AliquotaReduzida),'.',',') + '|'
+	COALESCE(tbSPEDECF.AlteracaoCapital,'0') + '|'
+	COALESCE(tbSPEDECF.EscritBaseNegAtivo,'0') + '|',
'Y671',
197,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.FormaTributLucro IN ('1','2','3','4')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y672|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.CapitalRegAnoAnt),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.CapitalRegistrado),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.EstoquesAnoAnterior),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.Estoque),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.SldCxBcoAnoAnterior),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.SldCxBco),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.SldAplicFinancAnoAnt),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.SldAplicFinanc),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ContasReceberAnoAnt),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ContasReceber),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ContasPagarAnoAnt),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ContasPagar),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ComprasMercadorias),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ComprasAtivo),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.Receitas),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.TotalAtivo),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.TotalFolhaSujAliqRed),'.',',') + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.AliquotaReduzida),'.',',') + '|'
+	COALESCE(tbSPEDECF.RegimeApuracaoReceitas,'0') + '|'
+	COALESCE(tbSPEDECF.MetodoAvaliacaoEstoque,'0') + '|',
'Y672',
198,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.FormaTributLucro IN ('5','6','7')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y680|'
+	RIGHT(lancto.PeriodoApuracao,2) + '|',
'Y680',
199,
'Y680'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
	lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
	lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
	lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
	lancto.DataFinal		=	tbSPEDECF.DataFinal			
INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
	tabela.Registro			=	lancto.Registro				AND
	tabela.Codigo			=	lancto.Codigo
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.Registro			= 'Y681'			AND
	tbSPEDECF.OptanteREFIS = 'V'				AND
	tbSPEDECF.FormaTributLucro NOT IN ('8','9')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y681|'
+	tabela.Codigo + '|'
+	tabela.Descricao + '|'
+	REPLACE(CONVERT(VARCHAR(16),lancto.ValorLancto),'.',',') + '|',
'Y681',
199,
'Y680'+RIGHT(lancto.PeriodoApuracao,2)+RIGHT('0000'+CONVERT(VARCHAR(4),tabela.Ordem),4)
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFLanctoTabDin lancto (NOLOCK) ON
	lancto.CodigoEmpresa	=	tbSPEDECF.CodigoEmpresa		AND
	lancto.CodigoLocal		=	tbSPEDECF.CodigoLocal		AND
	lancto.DataInicial		=	tbSPEDECF.DataInicial		AND
	lancto.DataFinal		=	tbSPEDECF.DataFinal			
INNER JOIN tbSPEDECFCodigoTabDin tabela (NOLOCK) ON
	tabela.Registro			=	lancto.Registro				AND
	tabela.Codigo			=	lancto.Codigo
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	lancto.Registro			= 'Y681'			AND
	tbSPEDECF.OptanteREFIS	= 'V'				AND
	tbSPEDECF.FormaTributLucro NOT IN ('8','9')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y682|'
+	'01' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.AcrescPatrimPAES01),'.',',') + '|',
'Y682',
200,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptanteREFIS = 'V'				AND
	tbSPEDECF.FormaTributLucro IN ('8','9')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y682|'
+	'02' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.AcrescPatrimPAES02),'.',',') + '|',
'Y682',
200,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptanteREFIS = 'V'				AND
	tbSPEDECF.FormaTributLucro IN ('8','9')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y682|'
+	'03' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.AcrescPatrimPAES03),'.',',') + '|',
'Y682',
200,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptanteREFIS = 'V'				AND
	tbSPEDECF.FormaTributLucro IN ('8','9')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y682|'
+	'04' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.AcrescPatrimPAES04),'.',',') + '|',
'Y682',
200,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptanteREFIS = 'V'				AND
	tbSPEDECF.FormaTributLucro IN ('8','9')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y682|'
+	'05' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.AcrescPatrimPAES05),'.',',') + '|',
'Y682',
200,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptanteREFIS = 'V'				AND
	tbSPEDECF.FormaTributLucro IN ('8','9')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y682|'
+	'06' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.AcrescPatrimPAES06),'.',',') + '|',
'Y682',
200,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptanteREFIS = 'V'				AND
	tbSPEDECF.FormaTributLucro IN ('8','9')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y682|'
+	'07' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.AcrescPatrimPAES07),'.',',') + '|',
'Y682',
200,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptanteREFIS = 'V'				AND
	tbSPEDECF.FormaTributLucro IN ('8','9')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y682|'
+	'08' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.AcrescPatrimPAES08),'.',',') + '|',
'Y682',
200,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptanteREFIS = 'V'				AND
	tbSPEDECF.FormaTributLucro IN ('8','9')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y682|'
+	'09' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.AcrescPatrimPAES09),'.',',') + '|',
'Y682',
200,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptanteREFIS = 'V'				AND
	tbSPEDECF.FormaTributLucro IN ('8','9')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y682|'
+	'10' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.AcrescPatrimPAES10),'.',',') + '|',
'Y682',
200,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptanteREFIS = 'V'				AND
	tbSPEDECF.FormaTributLucro IN ('8','9')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y682|'
+	'11' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.AcrescPatrimPAES11),'.',',') + '|',
'Y682',
200,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptanteREFIS = 'V'				AND
	tbSPEDECF.FormaTributLucro IN ('8','9')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y682|'
+	'12' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.AcrescPatrimPAES12),'.',',') + '|',
'Y682',
200,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptanteREFIS = 'V'				AND
	tbSPEDECF.FormaTributLucro IN ('8','9')


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y690|'
+	'01' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ReceitaBrutaPAES01),'.',',') + '|',
'Y690',
201,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptantePAES = 'V'					


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y690|'
+	'02' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ReceitaBrutaPAES02),'.',',') + '|',
'Y690',
201,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptantePAES = 'V'					


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y690|'
+	'03' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ReceitaBrutaPAES03),'.',',') + '|',
'Y690',
201,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptantePAES = 'V'					


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y690|'
+	'04' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ReceitaBrutaPAES04),'.',',') + '|',
'Y690',
201,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptantePAES = 'V'					


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y690|'
+	'05' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ReceitaBrutaPAES05),'.',',') + '|',
'Y690',
201,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptantePAES = 'V'					


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y690|'
+	'06' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ReceitaBrutaPAES06),'.',',') + '|',
'Y690',
201,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptantePAES = 'V'					


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y690|'
+	'07' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ReceitaBrutaPAES07),'.',',') + '|',
'Y690',
201,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptantePAES = 'V'					


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y690|'
+	'08' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ReceitaBrutaPAES08),'.',',') + '|',
'Y690',
201,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptantePAES = 'V'					


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y690|'
+	'09' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ReceitaBrutaPAES09),'.',',') + '|',
'Y690',
201,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptantePAES = 'V'					


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y690|'
+	'10' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ReceitaBrutaPAES10),'.',',') + '|',
'Y690',
201,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptantePAES = 'V'					


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y690|'
+	'11' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ReceitaBrutaPAES11),'.',',') + '|',
'Y690',
201,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptantePAES = 'V'					


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y690|'
+	'12' + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.ReceitaBrutaPAES12),'.',',') + '|',
'Y690',
201,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.OptantePAES = 'V'					


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y700|'
+	tbSPEDECFRegY700.NumeroEDossie + '|'
+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbSPEDECFRegY700.DataInicioAto)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbSPEDECFRegY700.DataInicioAto)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbSPEDECFRegY700.DataInicioAto)) + '|'
+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbSPEDECFRegY700.DataFimAto)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbSPEDECFRegY700.DataFimAto)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbSPEDECFRegY700.DataFimAto)) + '|'
+	CONVERT(VARCHAR(4),tbSPEDECFRegY700.AnoInicio) + '|'
+	CONVERT(VARCHAR(4),tbSPEDECFRegY700.AnoFim) + '|'
+	CASE WHEN tbSPEDECFRegY700.PartesDependentesBRA = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN tbSPEDECFRegY700.PartesDependentesEXT_TNF = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN tbSPEDECFRegY700.PartesDependentesEXT_TF = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN tbSPEDECFRegY700.PartesIndependentesBRA = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN tbSPEDECFRegY700.PartesIndependentesEXT_TNF = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN tbSPEDECFRegY700.PartesIndependentesEXT_TF = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN tbSPEDECFRegY700.AtivoFiscalDiferido = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN tbSPEDECFRegY700.ReorganizaoSocietaria = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN tbSPEDECFRegY700.PassivoTerceiros = 'V' THEN 'S' ELSE 'N' END + '|'
+	CONVERT(VARCHAR(1),tbSPEDECFRegY700.Beneficiarios) + '|'
+	CASE WHEN tbSPEDECFRegY700.ReducaoBaseTribut = 'V' THEN 'S' ELSE 'N' END + '|'
+	CASE WHEN tbSPEDECFRegY700.ReducaoAtivos = 'V' THEN 'S' ELSE 'N' END + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY700.PercentReducaoAtivos),'.',',') + '|'
+	tbSPEDECFRegY700.DescSumaria + '|'
+	tbSPEDECFRegY700.FundamJuridica + '|'
+	tbSPEDECFRegY700.JustSumaria + '|',
'Y700',
202,
'Y700' + RIGHT('0000'+CONVERT(VARCHAR(4),tbSPEDECFRegY700.SequenciaDIOR),4)
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegY700 (NOLOCK) ON
	tbSPEDECFRegY700.CodigoEmpresa	= tbSPEDECF.CodigoEmpresa	AND
	tbSPEDECFRegY700.CodigoLocal	= tbSPEDECF.CodigoLocal		AND
	tbSPEDECFRegY700.DataInicial	= tbSPEDECF.DataInicial		AND
	tbSPEDECFRegY700.DataFinal		= tbSPEDECF.DataFinal		
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y710|'
+	CONVERT(VARCHAR(2),tbSPEDECFRegY710.CodigoTributo) + '|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECFRegY710.ValorTributo),'.',',') + '|'
+	CONVERT(VARCHAR(4),tbSPEDECFRegY710.AnoRepercussao) + '|',
'Y710',
202,
'Y700' + RIGHT('0000'+CONVERT(VARCHAR(4),tbSPEDECFRegY700.SequenciaDIOR),4) + RIGHT('00'+CONVERT(VARCHAR(2),tbSPEDECFRegY710.CodigoTributo),2) + RIGHT('0000'+CONVERT(VARCHAR(4),tbSPEDECFRegY710.AnoRepercussao),4)
FROM tbSPEDECF (NOLOCK)
INNER JOIN tbSPEDECFRegY700 (NOLOCK) ON
	tbSPEDECFRegY700.CodigoEmpresa	= tbSPEDECF.CodigoEmpresa	AND
	tbSPEDECFRegY700.CodigoLocal	= tbSPEDECF.CodigoLocal		AND
	tbSPEDECFRegY700.DataInicial	= tbSPEDECF.DataInicial		AND
	tbSPEDECFRegY700.DataFinal		= tbSPEDECF.DataFinal		
INNER JOIN tbSPEDECFRegY710 (NOLOCK) ON
	tbSPEDECFRegY700.CodigoEmpresa	= tbSPEDECF.CodigoEmpresa	AND
	tbSPEDECFRegY700.CodigoLocal	= tbSPEDECF.CodigoLocal		AND
	tbSPEDECFRegY700.DataInicial	= tbSPEDECF.DataInicial		AND
	tbSPEDECFRegY700.DataFinal		= tbSPEDECF.DataFinal		
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y720|'
+	REPLACE(CONVERT(VARCHAR(16),tbSPEDECF.Y720LucroLiquido),'.',',') + '|'
+	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(DAY,tbSPEDECF.Y720DataLucroLiquido)),2,2) +
	SUBSTRING(CONVERT(CHAR(3),100 + DATEPART(MONTH,tbSPEDECF.Y720DataLucroLiquido)),2,2) +
	CONVERT(CHAR(4),DATEPART(year,tbSPEDECF.Y720DataLucroLiquido)) + '|',
'Y720',
203,
'Y720'
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.Y720DataLucroLiquido IS NOT NULL	


INSERT rtSPEDECF
SELECT DISTINCT
@@spid,
	'|Y800|'
+	'RTFY800' + '|'
+	'Y800FIM' + '|',
'Y800',
300,
0
FROM tbSPEDECF (NOLOCK)
WHERE
	tbSPEDECF.CodigoEmpresa	= @CodigoEmpresa	AND
	tbSPEDECF.CodigoLocal	= @CodigoLocal		AND
	tbSPEDECF.DataInicial	= @DataInicial		AND
	tbSPEDECF.DataFinal		= @DataFinal		AND
	tbSPEDECF.PossuiRegY800	= 'V'


-----------------------------------------------------------------------
--- ABERTURA E ENCERRAMENTO DOS BLOCOS
-----------------------------------------------------------------------
INSERT rtSPEDECF
SELECT 
@@spid,
	'|0001|'
+	CASE WHEN (SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE '0%') > 0 THEN '0' ELSE '1' END + '|',
'0001',
0,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|0990|'
+	CONVERT(VARCHAR(15),(SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE '0%') + 1) + '|',
'0990',
0,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|C001|'
+	CASE WHEN (SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'C%') > 0 THEN '0' ELSE '1' END + '|',
'C001',
1,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|C990|'
+	CONVERT(VARCHAR(15),(SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'C%') + 1) + '|',
'C990',
1,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|E001|'
+	CASE WHEN (SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'E%') > 0 THEN '0' ELSE '1' END + '|',
'E001',
1,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|E990|'
+	CONVERT(VARCHAR(15),(SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'E%') + 1) + '|',
'E990',
1,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|J001|'
+	CASE WHEN (SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'J%') > 0 THEN '0' ELSE '1' END + '|',
'J001',
1,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|J990|'
+	CONVERT(VARCHAR(15),(SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'J%') + 1) + '|',
'J990',
3,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|K001|'
+	CASE WHEN (SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'K%') > 0 THEN '0' ELSE '1' END + '|',
'K001',
4,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|K990|'
+	CONVERT(VARCHAR(15),(SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'K%') + 1) + '|',
'K990',
31,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|L001|'
+	CASE WHEN (SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'L%') > 0 THEN '0' ELSE '1' END + '|',
'L001',
32,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|L990|'
+	CONVERT(VARCHAR(15),(SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'L%') + 1) + '|',
'L990',
46,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|M001|'
+	CASE WHEN (SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'M%') > 0 THEN '0' ELSE '1' END + '|',
'M001',
47,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|M990|'
+	CONVERT(VARCHAR(15),(SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'M%') + 1) + '|',
'M990',
87,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|N001|'
+	CASE WHEN (SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'N%') > 0 THEN '0' ELSE '1' END + '|',
'N001',
88,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|N990|'
+	CONVERT(VARCHAR(15),(SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'N%') + 1) + '|',
'N990',
115,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|P001|'
+	CASE WHEN (SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'P%') > 0 THEN '0' ELSE '1' END + '|',
'P001',
116,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|P990|'
+	CONVERT(VARCHAR(15),(SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'P%') + 1) + '|',
'P990',
130,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|Q001|'
+	CASE WHEN (SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'Q%') > 0 THEN '0' ELSE '1' END + '|',
'Q001',
130,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|Q990|'
+	CONVERT(VARCHAR(15),(SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'Q%') + 1) + '|',
'Q990',
130,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|T001|'
+	CASE WHEN (SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'T%') > 0 THEN '0' ELSE '1' END + '|',
'T001',
131,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|T990|'
+	CONVERT(VARCHAR(15),(SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'T%') + 1) + '|',
'T990',
145,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|U001|'
+	CASE WHEN (SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'U%') > 0 THEN '0' ELSE '1' END + '|',
'U001',
146,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|U990|'
+	CONVERT(VARCHAR(15),(SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'U%') + 1) + '|',
'U990',
150,
0

IF @Versao >= '0003'
BEGIN
	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|W001|'
	+	CASE WHEN (SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'W%') > 0 THEN '0' ELSE '1' END + '|',
	'W001',
	155,
	0

	INSERT rtSPEDECF
	SELECT 
	@@spid,
		'|W990|'
	+	CONVERT(VARCHAR(15),(SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'W%') + 1) + '|',
	'W990',
	156,
	0
END

INSERT rtSPEDECF
SELECT 
@@spid,
	'|X001|'
+	CASE WHEN (SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'X%') > 0 THEN '0' ELSE '1' END + '|',
'X001',
161,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|X990|'
+	CONVERT(VARCHAR(15),(SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'X%') + 1) + '|',
'X990',
180,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|Y001|'
+	CASE WHEN (SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'Y%') > 0 THEN '0' ELSE '1' END + '|',
'Y001',
181,
0

INSERT rtSPEDECF
SELECT 
@@spid,
	'|Y990|'
+	CONVERT(VARCHAR(15),(SELECT COUNT(1) FROM rtSPEDECF WHERE TipoRegistro LIKE 'Y%') + 1) + '|',
'Y990',
301,
0

INSERT rtSPEDECF
SELECT
@@spid,
'|9001|' +
'0' + '|',
'Z001',
302,
0

SELECT TipoRegistro, COUNT(TipoRegistro) as QtdeLinhas INTO #tmp9900 FROM rtSPEDECF GROUP BY TipoRegistro

INSERT rtSPEDECF
SELECT
@@spid,
'|9900|' +
REPLACE(TipoRegistro, 'Z', '9') + '|' +
CONVERT(VARCHAR(5), QtdeLinhas) + '|',
'Z900',
303,
REPLACE(TipoRegistro, 'Z', '9')
FROM #tmp9900

DROP TABLE #tmp9900

INSERT rtSPEDECF
SELECT
@@spid,
'|9900|' +
'9900' + '|' +
CONVERT(VARCHAR(5), (SELECT COUNT(TipoRegistro) FROM rtSPEDECF WHERE TipoRegistro = 'Z900') + 3) + '|',
'Z900',
303,
'Z900'

INSERT rtSPEDECF SELECT @@spid, '|9900|9990|1|', 'Z900', 303, 'Z990'
INSERT rtSPEDECF SELECT @@spid, '|9900|9999|1|', 'Z900', 303, 'Z999'

INSERT rtSPEDECF
SELECT
@@spid,
'|9990|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDECF WHERE Spid = @@spid and TipoRegistro LIKE 'Z%' ) + 2) + '|',
'Z990',
304,
0

INSERT rtSPEDECF
SELECT
@@spid,
'|9999|' +
CONVERT(VARCHAR(16),( SELECT COUNT(*) FROM rtSPEDECF) + 1) + '|',
'Z999',
305,
0

-----------------------------------------------------------------------
--- SELECT Final
-----------------------------------------------------------------------
SELECT 
Linha, Ordem, Chave, TipoRegistro
FROM rtSPEDECF
WHERE
Spid = @@spid
ORDER BY Ordem, Chave, TipoRegistro, Linha

SET NOCOUNT OFF
SET ANSI_WARNINGS ON

GO
GRANT EXECUTE ON whSPEDECF TO SQLUsers
GO
