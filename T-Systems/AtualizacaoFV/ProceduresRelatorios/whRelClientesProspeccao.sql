go
IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('whRelClientesProspeccao')) BEGIN 
	DROP PROCEDURE dbo.whRelClientesProspeccao
END

GO
CREATE PROCEDURE dbo.whRelClientesProspeccao
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda.
 PROJETO......: DealerPlus
 AUTOR.... ...: Marcio Schvartz
 DATA.........: 03/12/2008
 UTILIZADO EM : Força de Vendas - Automóveis
 OBJETIVO.....: Relatório de Objetivos dos Representantes

whRelClientesProspeccao 1608, 0, 1, 4, '2008-01-01', '2009-06-01','001'
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa		numeric(4),
@CodigoLocal		numeric(4),
@CodigoRepresentante	numeric(4), 
@PropensaoCompra	numeric(3),
@PeriodoInicial 	datetime = null,
@PeriodoFinal		datetime = null,
@CodigoFabricante	char(5) = null

AS

set nocount on

update tbMonitoramento set CodigoFabricanteVeiculo = null where ltrim(rtrim(CodigoFabricanteVeiculo)) = ''


if @PeriodoInicial is null begin
	select @PeriodoInicial = min(DataHoraInicioFichaContato) 
	from tbFichaContato (nolock)
	where OrigemFichaContato = 'P'			-- PROSPECÇÃO
	and CodigoEmpresa = @CodigoEmpresa
	and CodigoLocal = @CodigoLocal
end

if @PeriodoFinal is null begin
	select @PeriodoFinal = max(DataHoraInicioFichaContato) 
	from tbFichaContato (nolock)
	where OrigemFichaContato = 'P'			-- PROSPECÇÃO
	and CodigoEmpresa = @CodigoEmpresa
	and CodigoLocal = @CodigoLocal
end

set nocount off


select distinct fc.NumeroFichaContato, fc.DataHoraInicioFichaContato,
	fc.TipoClientePF, fc.CodigoClientePF, fc.TipoClientePJ, fc.CodigoClientePJ, 
	case when cff.NomeCliFor is not null then cff.NomeCliFor
		when cfj.NomeCliFor is not null then cfj.NomeCliFor
		when cpf.RazaoSocialClientePotencial is not null then cpf.RazaoSocialClientePotencial
		when cpj.RazaoSocialClientePotencial is not null then cpj.RazaoSocialClientePotencial 
		else '' 
	end as 'NomeCliente',

	case    when cff.NomeCliFor is not null then ltrim(rtrim(coalesce(cff.DDDTelefoneCliFor, ' '))) + ' ' + ltrim(rtrim(coalesce(cff.TelefoneCliFor, ' '))) + ' / ' + ltrim(rtrim(coalesce(cff.DDDCelularCliFor, ' '))) + ' ' + ltrim(rtrim(coalesce(cff.CelularCliFor, ' ')))
		when cfj.NomeCliFor is not null then ltrim(rtrim(coalesce(cfj.DDDTelefoneCliFor, ' '))) + ' ' + ltrim(rtrim(coalesce(cfj.TelefoneCliFor, ' '))) + ' / ' + ltrim(rtrim(coalesce(cfj.DDDCelularCliFor, ' '))) + ' ' + ltrim(rtrim(coalesce(cfj.CelularCliFor, ' ')))
		when cpf.RazaoSocialClientePotencial is not null then ltrim(rtrim(coalesce(cpf.DDDFoneResidenciaClientePot, ' '))) + ' ' + ltrim(rtrim(coalesce(cpf.FoneResidenciaClientePot, ' '))) + ' / ' + ltrim(rtrim(coalesce(cpf.DDDCelularClientePotencial, ' '))) + ' ' + ltrim(rtrim(coalesce(cpf.FoneCelularClientePotencial, ' '))) + ' / ' + ltrim(rtrim(coalesce(cpf.DDDFoneComercialClientePot, ' '))) + ' ' + ltrim(rtrim(coalesce(cpf.FoneComercialClientePot, ' ')))
		when cpj.RazaoSocialClientePotencial is not null then ltrim(rtrim(coalesce(cpj.DDDFoneResidenciaClientePot, ' '))) + ' ' + ltrim(rtrim(coalesce(cpj.FoneResidenciaClientePot, ' '))) + ' / ' + ltrim(rtrim(coalesce(cpj.DDDCelularClientePotencial, ' '))) + ' ' + ltrim(rtrim(coalesce(cpj.FoneCelularClientePotencial, ' '))) + ' / ' + ltrim(rtrim(coalesce(cpj.DDDFoneComercialClientePot, ' '))) + ' ' + ltrim(rtrim(coalesce(cpj.FoneComercialClientePot, ' ')))
		else '' 
	end as 'Telefone',

	fc.CodigoRepresentante, rc.NomeRepresentante,
	fch.PropensaoCompra, pc.DescrPropCompra,
	fch.DataContatoHistorico

from tbFichaContato fc (nolock)

inner join tbFichaContatoHistorico fch (nolock) 
on fc.CodigoEmpresa = fch.CodigoEmpresa 
and fc.CodigoLocal = fch.CodigoLocal 
and fc.NumeroFichaContato = fch.NumeroFichaContato
and fch.DataContatoHistorico = (select Max(fch1.DataContatoHistorico) 
				from tbFichaContatoHistorico fch1 (nolock)
				where fc.CodigoEmpresa = fch1.CodigoEmpresa 
				and fc.CodigoLocal = fch1.CodigoLocal 
				and fc.NumeroFichaContato = fch1.NumeroFichaContato)

left join tbCliFor cff (nolock) 
on cff.CodigoEmpresa = fc.CodigoEmpresa 
and cff.CodigoCliFor = fc.CodigoClientePF

left join tbCliFor cfj (nolock) 
on cfj.CodigoEmpresa = fc.CodigoEmpresa 
and cfj.CodigoCliFor = fc.CodigoClientePF

left join tbClientePotencial cpf (nolock) 
on cpf.CodigoEmpresa = fc.CodigoEmpresa 
and cpf.CodigoClientePotencial = fc.CodigoClientePF
	
left join tbClientePotencial cpj (nolock) 
on cpj.CodigoEmpresa = fc.CodigoEmpresa 
and cpj.CodigoClientePotencial = fc.CodigoClientePJ

inner join tbRepresentanteComplementar rc (nolock) 
on rc.CodigoEmpresa = fc.CodigoEmpresa 
and rc.CodigoRepresentante = fc.CodigoRepresentante

INNER JOIN tbFichaContatoVeicInteresse
ON  tbFichaContatoVeicInteresse.CodigoEmpresa = fc.CodigoEmpresa 
AND tbFichaContatoVeicInteresse.CodigoLocal = fc.CodigoLocal
AND tbFichaContatoVeicInteresse.NumeroFichaContato = fc.NumeroFichaContato
AND tbFichaContatoVeicInteresse.ItemFichaContatoVeiculo = 1

INNER JOIN tbFabricanteVeiculo 
ON  tbFabricanteVeiculo.CodigoEmpresa = tbFichaContatoVeicInteresse.CodigoEmpresa
AND tbFabricanteVeiculo.CodigoFabricante = tbFichaContatoVeicInteresse.CodigoFabricante

left join tbPropensaoCompraST pc (nolock)
on rc.CodigoEmpresa = fc.CodigoEmpresa 
and pc.CodigoLocal = fc.CodigoLocal
and pc.PropensaoCompra =fch.PropensaoCompra 

where 	fc.DataHoraTerminoFichaContato is null
and 	fc.OrigemFichaContato = 'P'			-- PROSPECÇÃO
and 	fc.CodigoEmpresa = @CodigoEmpresa
and 	fc.CodigoLocal = @CodigoLocal
and 	fc.CodigoRepresentante = isnull(@CodigoRepresentante, fc.CodigoRepresentante)
and		fch.PropensaoCompra = isnull(@PropensaoCompra, fch.PropensaoCompra)
and 	fc.DataHoraInicioFichaContato between @PeriodoInicial and @PeriodoFinal
AND ((tbFabricanteVeiculo.CodigoFabricante = @CodigoFabricante AND @CodigoFabricante IS NOT NULL) 
		OR (tbFabricanteVeiculo.CodigoFabricante IS NOT NULL AND @CodigoFabricante IS NULL))

GO
GRANT EXECUTE ON dbo.whRelClientesProspeccao TO SQLUsers
GO

