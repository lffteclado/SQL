IF EXISTS ( SELECT 1 FROM sysobjects where name = 'rtDIRF' ) DROP TABLE dbo.rtDIRF
go
CREATE TABLE dbo.rtDIRF
(
CodigoEmpresa		NUMERIC(4),
AnoIR				NUMERIC(4),
CodRetencao			CHAR(4),
CodigoLocal			NUMERIC(4),
TipoColaborador		CHAR(1),
EspecieDIRF			NUMERIC(1),
NumeroRegistro		NUMERIC(8),
NomeBeneficiario1PA	CHAR(60),
CPFBeneficiario1PA	CHAR(14),
NomeBeneficiario2PA	CHAR(60),
CPFBeneficiario2PA	CHAR(14),
NomeBeneficiario	CHAR(60),
CPFCNPJBeneficiario	CHAR(14),                       
GrupoIR				NUMERIC(1),
SubGrupoIR			NUMERIC(1),
ValorMes01			MONEY,
ValorMes02			MONEY,
ValorMes03			MONEY,
ValorMes04			MONEY,
ValorMes05			MONEY,
ValorMes06			MONEY,
ValorMes07			MONEY,
ValorMes08			MONEY,
ValorMes09			MONEY,
ValorMes10			MONEY,
ValorMes11			MONEY,
ValorMes12			MONEY,
ValorMes13			MONEY,
ValorAssMedOdo		MONEY
)
go
if exists(select 1 from sysobjects where id = object_id('dbo.whRelFPDirfMM'))
DROP PROCEDURE dbo.whRelFPDirfMM
GO
CREATE PROCEDURE dbo.whRelFPDirfMM

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: CDC - Consulters/Humaita
 PROJETO......: FP - Folha de Pagamento
 AUTOR........: Simone Rainho
 DATA.........: 19/01/2000
 UTILIZADO EM : clsColaborador.GerarDirfMM
 OBJETIVO.....: Gerar informacoes para a DIRF Meio Magnetico

 ALTERACAO....: Geraldo Junior - 12/09/2005 
 OBJETIVO.....: Redimensionamento de variavel NomePessoal
		Ticket 26201/2005 -  - FM 1819/2005

 ALTERACAO....: Edson Marson - 01/11/2010 
 OBJETIVO.....: Alterado Limite de Isenção
				Ticket 45060/2010 - FM 8344/2010

 ALTERACAO....: Edson Marson - 11/01/2011 
 OBJETIVO.....: Novo Layout DIRF Meio Magnético
				Ticket 51442/2010 - FM 8665/2011

exec whRelFPDirfMM 1608,null,null,2010
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa	 dtInteiro04	= Null,
@CodigoLocal	 dtInteiro04	= Null,
@TipoColaborador dtCharacter01  = null, 
@AnoBase		 dtInteiro04

AS

DECLARE
	@LocalMin numeric(4),
	@LocalMax numeric(4)

if @CodigoLocal is null
	select
		@LocalMin=min(CodigoLocal),
		@LocalMax=max(CodigoLocal)
	from
		tbLocalFP (nolock)
	where
		CodigoEmpresa = @CodigoEmpresa
else
	begin
		select @LocalMin=@CodigoLocal
		select @LocalMax=@CodigoLocal
	end

-- Assalariados
insert rtDIRF
select distinct
tbIR.CodigoEmpresa,
tbIR.AnoIR,
'0561' CodRetencao,
tbIR.CodigoLocal,
tbIR.TipoColaborador,
'1' EspecieDIRF,
tbIR.NumeroRegistro,
NomeBeneficiario1PA	= 0,
CPFBeneficiario1PA	= 0,
NomeBeneficiario2PA	= 0,
CPFBeneficiario2PA	= 0,
left(tbColaboradorGeral.NomePessoal,60),
case when tbColaborador.CPFColaborador is null then
			'0'
	 else tbColaborador.CPFColaborador
	 end CPFCNPJBeneficiario,
tbIR.GrupoInformeRendimentos,
tbIR.SubGrupoInformeRendimentos,
ValorMes01 = 0,
ValorMes02 = 0,
ValorMes03 = 0,
ValorMes04 = 0,
ValorMes05 = 0,
ValorMes06 = 0,
ValorMes07 = 0,
ValorMes08 = 0,
ValorMes09 = 0,
ValorMes10 = 0,
ValorMes11 = 0,
ValorMes12 = 0,
ValorMes13 = 0,
ValorAssMedODO = 0
FROM tbIR,
	 tbColaborador,
	 tbColaboradorGeral
WHERE
tbColaborador.CodigoEmpresa = tbColaboradorGeral.CodigoEmpresa and
tbColaborador.CodigoLocal = tbColaboradorGeral.CodigoLocal and
tbColaborador.TipoColaborador = tbColaboradorGeral.TipoColaborador and
tbColaborador.NumeroRegistro = tbColaboradorGeral.NumeroRegistro and
tbColaborador.CodigoEmpresa = tbIR.CodigoEmpresa and
tbColaborador.CodigoLocal = tbIR.CodigoLocal and
tbColaborador.TipoColaborador = tbIR.TipoColaborador and
tbColaborador.NumeroRegistro = tbIR.NumeroRegistro and
tbIR.CodigoEmpresa = @CodigoEmpresa and
tbIR.CodigoLocal between @LocalMin and @LocalMax and
tbIR.AnoIR = @AnoBase 

UPDATE rtDIRF
SET
ValorMes01 = COALESCE(( select sum(ValorSubGrupo) from tbIR
            where
			tbIR.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
			tbIR.AnoIR = rtDIRF.AnoIR AND
			tbIR.CodigoLocal = rtDIRF.CodigoLocal AND
			tbIR.TipoColaborador = rtDIRF.TipoColaborador AND
			tbIR.NumeroRegistro = rtDIRF.NumeroRegistro AND
			tbIR.GrupoInformeRendimentos = rtDIRF.GrupoIR AND
			tbIR.SubGrupoInformeRendimentos = rtDIRF.SubGrupoIR AND
            tbIR.TipoPagamentoIR IN ('M','F') AND
            tbIR.MesPagamento = 1 ),0),
ValorMes02 = COALESCE(( select sum(ValorSubGrupo) from tbIR
            where
			tbIR.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
			tbIR.AnoIR = rtDIRF.AnoIR AND
			tbIR.CodigoLocal = rtDIRF.CodigoLocal AND
			tbIR.TipoColaborador = rtDIRF.TipoColaborador AND
			tbIR.NumeroRegistro = rtDIRF.NumeroRegistro AND
			tbIR.GrupoInformeRendimentos = rtDIRF.GrupoIR AND
			tbIR.SubGrupoInformeRendimentos = rtDIRF.SubGrupoIR AND
            tbIR.TipoPagamentoIR IN ('M','F') AND
            tbIR.MesPagamento = 2 ),0),
ValorMes03 = COALESCE(( select sum(ValorSubGrupo) from tbIR
            where
			tbIR.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
			tbIR.AnoIR = rtDIRF.AnoIR AND
			tbIR.CodigoLocal = rtDIRF.CodigoLocal AND
			tbIR.TipoColaborador = rtDIRF.TipoColaborador AND
			tbIR.NumeroRegistro = rtDIRF.NumeroRegistro AND
			tbIR.GrupoInformeRendimentos = rtDIRF.GrupoIR AND
			tbIR.SubGrupoInformeRendimentos = rtDIRF.SubGrupoIR AND
            tbIR.TipoPagamentoIR IN ('M','F') AND
            tbIR.MesPagamento = 3 ),0),
ValorMes04 = COALESCE(( select sum(ValorSubGrupo) from tbIR
            where
			tbIR.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
			tbIR.AnoIR = rtDIRF.AnoIR AND
			tbIR.CodigoLocal = rtDIRF.CodigoLocal AND
			tbIR.TipoColaborador = rtDIRF.TipoColaborador AND
			tbIR.NumeroRegistro = rtDIRF.NumeroRegistro AND
			tbIR.GrupoInformeRendimentos = rtDIRF.GrupoIR AND
			tbIR.SubGrupoInformeRendimentos = rtDIRF.SubGrupoIR AND
            tbIR.TipoPagamentoIR IN ('M','F') AND
            tbIR.MesPagamento = 4 ),0),
ValorMes05 = COALESCE(( select sum(ValorSubGrupo) from tbIR
            where
			tbIR.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
			tbIR.AnoIR = rtDIRF.AnoIR AND
			tbIR.CodigoLocal = rtDIRF.CodigoLocal AND
			tbIR.TipoColaborador = rtDIRF.TipoColaborador AND
			tbIR.NumeroRegistro = rtDIRF.NumeroRegistro AND
			tbIR.GrupoInformeRendimentos = rtDIRF.GrupoIR AND
			tbIR.SubGrupoInformeRendimentos = rtDIRF.SubGrupoIR AND
            tbIR.TipoPagamentoIR IN ('M','F') AND
            tbIR.MesPagamento = 5 ),0),
ValorMes06 = COALESCE(( select sum(ValorSubGrupo) from tbIR
            where
			tbIR.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
			tbIR.AnoIR = rtDIRF.AnoIR AND
			tbIR.CodigoLocal = rtDIRF.CodigoLocal AND
			tbIR.TipoColaborador = rtDIRF.TipoColaborador AND
			tbIR.NumeroRegistro = rtDIRF.NumeroRegistro AND
			tbIR.GrupoInformeRendimentos = rtDIRF.GrupoIR AND
			tbIR.SubGrupoInformeRendimentos = rtDIRF.SubGrupoIR AND
            tbIR.TipoPagamentoIR IN ('M','F') AND
            tbIR.MesPagamento = 6 ),0),
ValorMes07 = COALESCE(( select sum(ValorSubGrupo) from tbIR
            where
			tbIR.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
			tbIR.AnoIR = rtDIRF.AnoIR AND
			tbIR.CodigoLocal = rtDIRF.CodigoLocal AND
			tbIR.TipoColaborador = rtDIRF.TipoColaborador AND
			tbIR.NumeroRegistro = rtDIRF.NumeroRegistro AND
			tbIR.GrupoInformeRendimentos = rtDIRF.GrupoIR AND
			tbIR.SubGrupoInformeRendimentos = rtDIRF.SubGrupoIR AND
            tbIR.TipoPagamentoIR IN ('M','F') AND
            tbIR.MesPagamento = 7 ),0),
ValorMes08 = COALESCE(( select sum(ValorSubGrupo) from tbIR
            where
			tbIR.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
			tbIR.AnoIR = rtDIRF.AnoIR AND
			tbIR.CodigoLocal = rtDIRF.CodigoLocal AND
			tbIR.TipoColaborador = rtDIRF.TipoColaborador AND
			tbIR.NumeroRegistro = rtDIRF.NumeroRegistro AND
			tbIR.GrupoInformeRendimentos = rtDIRF.GrupoIR AND
			tbIR.SubGrupoInformeRendimentos = rtDIRF.SubGrupoIR AND
            tbIR.TipoPagamentoIR IN ('M','F') AND
            tbIR.MesPagamento = 8 ),0),
ValorMes09 = COALESCE(( select sum(ValorSubGrupo) from tbIR
            where
			tbIR.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
			tbIR.AnoIR = rtDIRF.AnoIR AND
			tbIR.CodigoLocal = rtDIRF.CodigoLocal AND
			tbIR.TipoColaborador = rtDIRF.TipoColaborador AND
			tbIR.NumeroRegistro = rtDIRF.NumeroRegistro AND
			tbIR.GrupoInformeRendimentos = rtDIRF.GrupoIR AND
			tbIR.SubGrupoInformeRendimentos = rtDIRF.SubGrupoIR AND
            tbIR.TipoPagamentoIR IN ('M','F') AND
            tbIR.MesPagamento = 9 ),0),
ValorMes10 = COALESCE(( select sum(ValorSubGrupo) from tbIR
            where
			tbIR.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
			tbIR.AnoIR = rtDIRF.AnoIR AND
			tbIR.CodigoLocal = rtDIRF.CodigoLocal AND
			tbIR.TipoColaborador = rtDIRF.TipoColaborador AND
			tbIR.NumeroRegistro = rtDIRF.NumeroRegistro AND
			tbIR.GrupoInformeRendimentos = rtDIRF.GrupoIR AND
			tbIR.SubGrupoInformeRendimentos = rtDIRF.SubGrupoIR AND
            tbIR.TipoPagamentoIR IN ('M','F') AND
            tbIR.MesPagamento = 10 ),0),
ValorMes11 = COALESCE(( select sum(ValorSubGrupo) from tbIR
            where
			tbIR.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
			tbIR.AnoIR = rtDIRF.AnoIR AND
			tbIR.CodigoLocal = rtDIRF.CodigoLocal AND
			tbIR.TipoColaborador = rtDIRF.TipoColaborador AND
			tbIR.NumeroRegistro = rtDIRF.NumeroRegistro AND
			tbIR.GrupoInformeRendimentos = rtDIRF.GrupoIR AND
			tbIR.SubGrupoInformeRendimentos = rtDIRF.SubGrupoIR AND
            tbIR.TipoPagamentoIR IN ('M','F') AND
            tbIR.MesPagamento = 11 ),0),
ValorMes12 = COALESCE(( select sum(ValorSubGrupo) from tbIR
            where
			tbIR.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
			tbIR.AnoIR = rtDIRF.AnoIR AND
			tbIR.CodigoLocal = rtDIRF.CodigoLocal AND
			tbIR.TipoColaborador = rtDIRF.TipoColaborador AND
			tbIR.NumeroRegistro = rtDIRF.NumeroRegistro AND
			tbIR.GrupoInformeRendimentos = rtDIRF.GrupoIR AND
			tbIR.SubGrupoInformeRendimentos = rtDIRF.SubGrupoIR AND
            tbIR.TipoPagamentoIR IN ('M','F') AND
            tbIR.MesPagamento = 12 ),0),
ValorMes13 = COALESCE(( select sum(ValorSubGrupo) from tbIR
            where
			tbIR.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
			tbIR.AnoIR = rtDIRF.AnoIR AND
			tbIR.CodigoLocal = rtDIRF.CodigoLocal AND
			tbIR.TipoColaborador = rtDIRF.TipoColaborador AND
			tbIR.NumeroRegistro = rtDIRF.NumeroRegistro AND
			tbIR.GrupoInformeRendimentos = rtDIRF.GrupoIR AND
			tbIR.SubGrupoInformeRendimentos = rtDIRF.SubGrupoIR AND
            tbIR.TipoPagamentoIR = 'D'),0),
-- Assistencia médica/Odonto
ValorAssMedOdo = COALESCE(( select sum(ValorSubGrupo) from tbIR
            where
			tbIR.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
			tbIR.AnoIR = rtDIRF.AnoIR AND
			tbIR.CodigoLocal = rtDIRF.CodigoLocal AND
			tbIR.TipoColaborador = rtDIRF.TipoColaborador AND
			tbIR.NumeroRegistro = rtDIRF.NumeroRegistro AND
			tbIR.GrupoInformeRendimentos = 4 AND
			tbIR.SubGrupoInformeRendimentos IN (1,2)),0)

-- Pensao Alimenticia
UPDATE rtDIRF
SET
NomeBeneficiario1PA = ( select min(left(NomeBeneficiario,60))
						from tbBeneficiario,
							 tbIR
						where							
							tbBeneficiario.CodigoEmpresa = tbIR.CodigoEmpresa AND
							tbBeneficiario.CodigoLocal = tbIR.CodigoLocal AND
							tbBeneficiario.TipoColaborador = tbIR.TipoColaborador AND
							tbBeneficiario.NumeroRegistro = tbIR.NumeroRegistro AND
							tbIR.GrupoInformeRendimentos = 1 AND
							tbIR.SubGrupoInformeRendimentos = 4 AND
							tbBeneficiario.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
							tbBeneficiario.CodigoLocal = rtDIRF.CodigoLocal AND
							tbBeneficiario.TipoColaborador = rtDIRF.TipoColaborador AND
							tbBeneficiario.NumeroRegistro = rtDIRF.NumeroRegistro AND
							tbBeneficiario.SequenciaBeneficiario = 1),
CPFBeneficiario1PA = ( select min(CPFBeneficiario)
						from tbBeneficiario,
							 tbIR
						where							
							tbBeneficiario.CodigoEmpresa = tbIR.CodigoEmpresa AND
							tbBeneficiario.CodigoLocal = tbIR.CodigoLocal AND
							tbBeneficiario.TipoColaborador = tbIR.TipoColaborador AND
							tbBeneficiario.NumeroRegistro = tbIR.NumeroRegistro AND
							tbIR.GrupoInformeRendimentos = 1 AND
							tbIR.SubGrupoInformeRendimentos = 4 AND
							tbBeneficiario.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
							tbBeneficiario.CodigoLocal = rtDIRF.CodigoLocal AND
							tbBeneficiario.TipoColaborador = rtDIRF.TipoColaborador AND
							tbBeneficiario.NumeroRegistro = rtDIRF.NumeroRegistro AND
							tbBeneficiario.SequenciaBeneficiario = 1),
NomeBeneficiario2PA = ( select min(left(NomeBeneficiario,60))
						from tbBeneficiario,
							 tbIR
						where							
							tbBeneficiario.CodigoEmpresa = tbIR.CodigoEmpresa AND
							tbBeneficiario.CodigoLocal = tbIR.CodigoLocal AND
							tbBeneficiario.TipoColaborador = tbIR.TipoColaborador AND
							tbBeneficiario.NumeroRegistro = tbIR.NumeroRegistro AND
							tbIR.GrupoInformeRendimentos = 1 AND
							tbIR.SubGrupoInformeRendimentos = 4 AND
							tbBeneficiario.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
							tbBeneficiario.CodigoLocal = rtDIRF.CodigoLocal AND
							tbBeneficiario.TipoColaborador = rtDIRF.TipoColaborador AND
							tbBeneficiario.NumeroRegistro = rtDIRF.NumeroRegistro AND
							tbBeneficiario.SequenciaBeneficiario = 2),
CPFBeneficiario2PA = ( select min(CPFBeneficiario)
						from tbBeneficiario,
							 tbIR
						where							
							tbBeneficiario.CodigoEmpresa = tbIR.CodigoEmpresa AND
							tbBeneficiario.CodigoLocal = tbIR.CodigoLocal AND
							tbBeneficiario.TipoColaborador = tbIR.TipoColaborador AND
							tbBeneficiario.NumeroRegistro = tbIR.NumeroRegistro AND
							tbIR.GrupoInformeRendimentos = 1 AND
							tbIR.SubGrupoInformeRendimentos = 4 AND
							tbBeneficiario.CodigoEmpresa = rtDIRF.CodigoEmpresa AND
							tbBeneficiario.CodigoLocal = rtDIRF.CodigoLocal AND
							tbBeneficiario.TipoColaborador = rtDIRF.TipoColaborador AND
							tbBeneficiario.NumeroRegistro = rtDIRF.NumeroRegistro AND
							tbBeneficiario.SequenciaBeneficiario = 2)

 -- terceiros (Rend.Tributavel)
insert rtDIRF
select distinct
tbDirf.CodigoEmpresa,
tbDirf.AnoDIRF,
SUBSTRING(CONVERT(CHAR(5), 10000 + tbDirf.CodigoRetencao),2,4),
tbDirf.CodigoLocal,
tbDirf.TipoColaborador,
tbDirf.EspecieDIRF,
tbDirf.NumeroRegistro,
NomeBeneficiario1PA	= null,
CPFBeneficiario1PA	= null,
NomeBeneficiario2PA	= null,
CPFBeneficiario2PA	= null,
left(tbDirf.NomeBeneficiarioRendimento,60),
tbDirf.TipoBeneficiario,
'1' GrupoIR,
'1' SubGrupoIR,
tbDirf.ValorRendimento01,
tbDirf.ValorRendimento02,
tbDirf.ValorRendimento03,
tbDirf.ValorRendimento04,
tbDirf.ValorRendimento05,
tbDirf.ValorRendimento06,
tbDirf.ValorRendimento07,
tbDirf.ValorRendimento08,
tbDirf.ValorRendimento09,
tbDirf.ValorRendimento10,
tbDirf.ValorRendimento11,
tbDirf.ValorRendimento12,
tbDirf.ValorRendimento13Sal,
ValorAssMedOdo = 0
FROM tbDirf
WHERE
tbDirf.CodigoEmpresa = @CodigoEmpresa and
tbDirf.CodigoLocal between @LocalMin and @LocalMax and
tbDirf.AnoDIRF = @AnoBase and
tbDirf.TipoColaborador = 'T'

 -- terceiros (Prev.Oficial)
insert rtDIRF
select distinct
tbDirf.CodigoEmpresa,
tbDirf.AnoDIRF,
SUBSTRING(CONVERT(CHAR(5), 10000 + tbDirf.CodigoRetencao),2,4),
tbDirf.CodigoLocal,
tbDirf.TipoColaborador,
tbDirf.EspecieDIRF,
tbDirf.NumeroRegistro,
NomeBeneficiario1PA	= null,
CPFBeneficiario1PA	= null,
NomeBeneficiario2PA	= null,
CPFBeneficiario2PA	= null,
left(tbDirf.NomeBeneficiarioRendimento,60),
tbDirf.TipoBeneficiario,
'1' GrupoIR,
'2' SubGrupoIR,
tbDirf.ValorDeducao01,
tbDirf.ValorDeducao02,
tbDirf.ValorDeducao03,
tbDirf.ValorDeducao04,
tbDirf.ValorDeducao05,
tbDirf.ValorDeducao06,
tbDirf.ValorDeducao07,
tbDirf.ValorDeducao08,
tbDirf.ValorDeducao09,
tbDirf.ValorDeducao10,
tbDirf.ValorDeducao11,
tbDirf.ValorDeducao12,
tbDirf.ValorDeducao13Sal,
ValorAssMedOdo = 0
FROM tbDirf
WHERE
tbDirf.CodigoEmpresa = @CodigoEmpresa and
tbDirf.CodigoLocal between @LocalMin and @LocalMax and
tbDirf.AnoDIRF = @AnoBase and
tbDirf.TipoColaborador = 'T'

 -- terceiros (Pensao Alimenticia)
insert rtDIRF
select distinct
tbDirf.CodigoEmpresa,
tbDirf.AnoDIRF,
SUBSTRING(CONVERT(CHAR(5), 10000 + tbDirf.CodigoRetencao),2,4),
tbDirf.CodigoLocal,
tbDirf.TipoColaborador,
tbDirf.EspecieDIRF,
tbDirf.NumeroRegistro,
NomeBeneficiario1PA	= null,
CPFBeneficiario1PA	= null,
NomeBeneficiario2PA	= null,
CPFBeneficiario2PA	= null,
left(tbDirf.NomeBeneficiarioRendimento,60),
tbDirf.TipoBeneficiario,
'1' GrupoIR,
'4' SubGrupoIR,
tbDirf.ValorDeducaoPen01,
tbDirf.ValorDeducaoPen02,
tbDirf.ValorDeducaoPen03,
tbDirf.ValorDeducaoPen04,
tbDirf.ValorDeducaoPen05,
tbDirf.ValorDeducaoPen06,
tbDirf.ValorDeducaoPen07,
tbDirf.ValorDeducaoPen08,
tbDirf.ValorDeducaoPen09,
tbDirf.ValorDeducaoPen10,
tbDirf.ValorDeducaoPen11,
tbDirf.ValorDeducaoPen12,
tbDirf.ValorDeducaoPen13Sal,
ValorAssMedOdo = 0
FROM tbDirf
WHERE
tbDirf.CodigoEmpresa = @CodigoEmpresa and
tbDirf.CodigoLocal between @LocalMin and @LocalMax and
tbDirf.AnoDIRF = @AnoBase and
tbDirf.TipoColaborador = 'T'

 -- terceiros (IRRF)
insert rtDIRF
select distinct
tbDirf.CodigoEmpresa,
tbDirf.AnoDIRF,
SUBSTRING(CONVERT(CHAR(5), 10000 + tbDirf.CodigoRetencao),2,4),
tbDirf.CodigoLocal,
tbDirf.TipoColaborador,
tbDirf.EspecieDIRF,
tbDirf.NumeroRegistro,
NomeBeneficiario1PA	= null,
CPFBeneficiario1PA	= null,
NomeBeneficiario2PA	= null,
CPFBeneficiario2PA	= null,
left(tbDirf.NomeBeneficiarioRendimento,60),
tbDirf.TipoBeneficiario,
'1' GrupoIR,
'5' SubGrupoIR,
tbDirf.ValorIRRF01,
tbDirf.ValorIRRF02,
tbDirf.ValorIRRF03,
tbDirf.ValorIRRF04,
tbDirf.ValorIRRF05,
tbDirf.ValorIRRF06,
tbDirf.ValorIRRF07,
tbDirf.ValorIRRF08,
tbDirf.ValorIRRF09,
tbDirf.ValorIRRF10,
tbDirf.ValorIRRF11,
tbDirf.ValorIRRF12,
tbDirf.ValorIRRF13SalDIRF,
ValorAssMedOdo = 0
FROM tbDirf
WHERE
tbDirf.CodigoEmpresa = @CodigoEmpresa and
tbDirf.CodigoLocal between @LocalMin and @LocalMax and
tbDirf.AnoDIRF = @AnoBase and
tbDirf.TipoColaborador = 'T'

 -- terceiros (Dependentes)
insert rtDIRF
select distinct
tbDirf.CodigoEmpresa,
tbDirf.AnoDIRF,
SUBSTRING(CONVERT(CHAR(5), 10000 + tbDirf.CodigoRetencao),2,4),
tbDirf.CodigoLocal,
tbDirf.TipoColaborador,
tbDirf.EspecieDIRF,
tbDirf.NumeroRegistro,
NomeBeneficiario1PA	= null,
CPFBeneficiario1PA	= null,
NomeBeneficiario2PA	= null,
CPFBeneficiario2PA	= null,
left(tbDirf.NomeBeneficiarioRendimento,60),
tbDirf.TipoBeneficiario,
'1' GrupoIR,
'6' SubGrupoIR,
tbDirf.ValorDeducaoDep01,
tbDirf.ValorDeducaoDep02,
tbDirf.ValorDeducaoDep03,
tbDirf.ValorDeducaoDep04,
tbDirf.ValorDeducaoDep05,
tbDirf.ValorDeducaoDep06,
tbDirf.ValorDeducaoDep07,
tbDirf.ValorDeducaoDep08,
tbDirf.ValorDeducaoDep09,
tbDirf.ValorDeducaoDep10,
tbDirf.ValorDeducaoDep11,
tbDirf.ValorDeducaoDep12,
tbDirf.ValorDeducaoDep13Sal,
ValorAssMedOdo = 0
FROM tbDirf
WHERE
tbDirf.CodigoEmpresa = @CodigoEmpresa and
tbDirf.CodigoLocal between @LocalMin and @LocalMax and
tbDirf.AnoDIRF = @AnoBase and
tbDirf.TipoColaborador = 'T'

-- descarrega o resultado final
SELECT  CodigoEmpresa,
	    AnoIR,
		CodRetencao,
--		CodigoLocal, 		
		TipoColaborador,
		EspecieDIRF,
--		NumeroRegistro,
		NomeBeneficiario1PA,
		CPFBeneficiario1PA,
		NomeBeneficiario2PA,
		CPFBeneficiario2PA,
		left(NomeBeneficiario,60) NomeBeneficiario,
		CPFCNPJBeneficiario,
		GrupoIR,
		SubGrupoIR,
		sum(ValorMes01) ValorMes01,
		sum(ValorMes02) ValorMes02,
		sum(ValorMes03) ValorMes03,
		sum(ValorMes04) ValorMes04,
		sum(ValorMes05) ValorMes05,
		sum(ValorMes06) ValorMes06,
		sum(ValorMes07) ValorMes07,
		sum(ValorMes08) ValorMes08,
		sum(ValorMes09) ValorMes09,
		sum(ValorMes10) ValorMes10,
		sum(ValorMes11) ValorMes11,
		sum(ValorMes12) ValorMes12,
		sum(ValorMes13) ValorMes13,
		sum(ValorAssMedOdo) ValorAssMedOdo
FROM rtDIRF
WHERE (ValorMes01 + ValorMes02 + ValorMes03 + ValorMes04 + ValorMes05 + ValorMes06 + ValorMes07 + 
	   ValorMes08 + ValorMes09 + ValorMes10 + ValorMes11 + ValorMes12 + ValorMes13) <> 0
GROUP BY CodigoEmpresa,
	     AnoIR,
		 CodRetencao,
--         CodigoLocal, 		
		 TipoColaborador,
		 EspecieDIRF,
--         NumeroRegistro,
		 NomeBeneficiario1PA,
		 CPFBeneficiario1PA,
		 NomeBeneficiario2PA,
		 CPFBeneficiario2PA,
		 NomeBeneficiario,
		 CPFCNPJBeneficiario,
		 GrupoIR,
		 SubGrupoIR
ORDER BY AnoIR, 
		 CodRetencao, 
		 CodigoEmpresa, 
--		 CodigoLocal,
		 CPFCNPJBeneficiario, 
--		 NumeroRegistro, 
		 NomeBeneficiario,
		 GrupoIR, 
		 SubGrupoIR

TRUNCATE TABLE dbo.rtDIRF

GO
GRANT EXECUTE ON dbo.whRelFPDirfMM TO SQLUsers
GO
