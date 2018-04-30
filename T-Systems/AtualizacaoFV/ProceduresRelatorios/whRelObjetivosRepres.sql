go
IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('whRelObjetivosRepres')) BEGIN 
	DROP PROCEDURE dbo.whRelObjetivosRepres
END

GO
CREATE PROCEDURE dbo.whRelObjetivosRepres
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda.
 PROJETO......: DealerPlus
 AUTOR.... ...: Marcio Schvartz
 DATA.........: 03/12/2008
 UTILIZADO EM : Força de Vendas - Automóveis
 OBJETIVO.....: Relatório de Objetivos dos Representantes

 whRelObjetivosRepres 1608, 0, '200812','001'
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa		numeric(4),
@CodigoLocal		numeric(4),
@PeriodoObjetivo	char(6),
@CodigoFabricante	char(5) = NULL

AS

set nocount on
update tbMonitoramento set CodigoFabricanteVeiculo = null where ltrim(rtrim(CodigoFabricanteVeiculo)) = ''
set nocount off



select 	obr.*, rc.NomeRepresentante,
 	(select count(*) from tbFichaContato a (nolock)

	inner join tbFichaContatoHistorico b (nolock) 
	on a.CodigoEmpresa = b.CodigoEmpresa 
	and a.CodigoLocal = b.CodigoLocal 
	and a.NumeroFichaContato = b.NumeroFichaContato

	inner join tbFichaContatoVeicInteresse c (nolock)
	on  c.CodigoEmpresa = a.CodigoEmpresa
	and c.CodigoLocal   = a.CodigoLocal
	and c.NumeroFichaContato = a.NumeroFichaContato	

	inner join tbFabricanteVeiculo d (nolock)
	on d.CodigoEmpresa  = c.CodigoEmpresa
	and d.CodigoFabricante = c.CodigoFabricante
	
	where a.OrigemFichaContato = 'P'
	and a.CodigoEmpresa = obr.CodigoEmpresa
	and a.CodigoLocal = obr.CodigoLocal
	and a.CodigoRepresentante = obr.CodigoRepresentante
	and substring(convert(varchar(10), b.DataContatoHistorico, 103), 7,4) + substring(convert(varchar(10), b.DataContatoHistorico, 103), 4,2) = obr.PeriodoObjetivo
	and ((d.CodigoFabricante = @CodigoFabricante and @CodigoFabricante is not null) 
			or (d.CodigoFabricante is  null and @CodigoFabricante is null))) as 'TotalRealizadoProspeccao'

from tbObjetivoRepresentante obr
inner join tbRepresentanteComplementar rc (nolock) on obr.CodigoEmpresa = rc.CodigoEmpresa and obr.CodigoRepresentante = rc.CodigoRepresentante
inner join tbRepresentante rep (nolock) on obr.CodigoEmpresa = rep.CodigoEmpresa and obr.CodigoRepresentante = rep.CodigoRepresentante
where rep.RepresentanteBloqueado = 'F'
and obr.CodigoEmpresa = @CodigoEmpresa
and obr.CodigoLocal = @CodigoLocal
and obr.PeriodoObjetivo = @PeriodoObjetivo

order by rc.NomeRepresentante

GO
GRANT EXECUTE ON dbo.whRelObjetivosRepres TO SQLUsers
GO
