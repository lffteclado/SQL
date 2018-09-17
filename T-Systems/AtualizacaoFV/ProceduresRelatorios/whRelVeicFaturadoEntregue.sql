go
if exists(select 1 from sysobjects where id = object_id('whRelVeicFaturadoEntregue'))
	DROP PROCEDURE dbo.whRelVeicFaturadoEntregue
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
CREATE PROCEDURE dbo.whRelVeicFaturadoEntregue
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda.
 PROJETO......: DealerPlus
 AUTOR.... ...: Marcio Schvartz
 DATA.........: 16/12/2008
 UTILIZADO EM : Força de Vendas - Automóveis
 OBJETIVO.....: Relatório de Veículos Faturados e Entregues

 whRelVeicFaturadoEntregue 1608, 0, '2007-12-16', '2009-12-16', 'V', 'V', null,'035'
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa			numeric(4),
@CodigoLocal			numeric(4),
@DataFaturamentoInicial		datetime,
@DataFaturamentoFinal		datetime,
@VeiculoFaturado			char(1) = 'V',
@EntregaRealizadaFichaContato	char(1) = 'V',
@CodigoRepresentante		numeric(4) = null,
@CodigoFabricante			char(5) = NULL

AS


update tbMonitoramento set CodigoFabricanteVeiculo = null where ltrim(rtrim(CodigoFabricanteVeiculo)) = ''


select distinct fc.NumeroFichaContato, fc.DataHoraInicioFichaContato, fc.DataHoraTerminoFichaContato,
	fc.VeiculoFaturado, fc.DataFaturamento,
	fc.EntregaRealizadaFichaContato, fc.EntregaRealizadaDataHoraFichaContato,
	fc.TipoClientePF, fc.CodigoClientePF, fc.TipoClientePJ, fc.CodigoClientePJ, 
	case when cff.NomeCliFor is not null then cff.NomeCliFor
		when cfj.NomeCliFor is not null then cfj.NomeCliFor
		when cpf.RazaoSocialClientePotencial is not null then cpf.RazaoSocialClientePotencial
		when cpj.RazaoSocialClientePotencial is not null then cpj.RazaoSocialClientePotencial 
		else '' 
	end as 'NomeCliente',
	fc.CodigoRepresentante, rc.NomeRepresentante,
	fc.OrigemFichaContato,
	fcvi.ZeroKM, fcvi.CodigoFabricante, fcvi.ModeloVeiculo, fcvi.AnoFabricacaoVeiculo, 
	fcvi.AnoModeloVeiculo, fcvi.CodigoCombustivel, fcvi.PrecoVeiculo,
	fv.DescricaoFabricanteVeic, (select count(tbFichaContatoVeicInteresse.ModeloVeiculo) 
						from tbFichaContatoVeicInteresse (nolock)
							inner join tbFichaContato (nolock)
							on tbFichaContatoVeicInteresse.CodigoEmpresa = tbFichaContato.CodigoEmpresa 
							and tbFichaContatoVeicInteresse.CodigoLocal = tbFichaContato.CodigoLocal 
							and tbFichaContatoVeicInteresse.NumeroFichaContato = tbFichaContato.NumeroFichaContato 
							and tbFichaContatoVeicInteresse.ItemFichaContatoVeiculo = 1
						where tbFichaContatoVeicInteresse.CodigoEmpresa = @CodigoEmpresa
						and tbFichaContatoVeicInteresse.CodigoLocal = @CodigoLocal
						and tbFichaContatoVeicInteresse.ModeloVeiculo = fcvi.ModeloVeiculo
						and tbFichaContato.DataFaturamento between @DataFaturamentoInicial and @DataFaturamentoFinal ) as Quantidade 
from tbFichaContato fc (nolock)

inner join tbFichaContatoVeicInteresse fcvi (nolock)
on fc.CodigoEmpresa = fcvi.CodigoEmpresa and fc.CodigoLocal = fcvi.CodigoLocal 
and fc.NumeroFichaContato = fcvi.NumeroFichaContato and fcvi.ItemFichaContatoVeiculo = 1

inner join tbRepresentanteComplementar rc (nolock) 
on rc.CodigoEmpresa = fc.CodigoEmpresa and rc.CodigoRepresentante = fc.CodigoRepresentante

left join tbCliFor cff (nolock) 
on cff.CodigoEmpresa = fc.CodigoEmpresa and cff.CodigoCliFor = fc.CodigoClientePF

left join tbCliFor cfj (nolock) 
on cfj.CodigoEmpresa = fc.CodigoEmpresa and cfj.CodigoCliFor = fc.CodigoClientePF

left join tbClientePotencial cpf (nolock) 
on cpf.CodigoEmpresa = fc.CodigoEmpresa and cpf.CodigoClientePotencial = fc.CodigoClientePF
	
left join tbClientePotencial cpj (nolock) 
on cpj.CodigoEmpresa = fc.CodigoEmpresa and cpj.CodigoClientePotencial = fc.CodigoClientePJ

inner join tbFabricanteVeiculo fv (nolock)
on fv.CodigoEmpresa = fcvi.CodigoEmpresa and fv.CodigoFabricante = fcvi.CodigoFabricante

where 	fc.CodigoEmpresa = @CodigoEmpresa
and 	fc.CodigoLocal = @CodigoLocal
and 	fc.DataFaturamento between @DataFaturamentoInicial and @DataFaturamentoFinal
and 	fc.VeiculoFaturado = @VeiculoFaturado				--'V'
and 	fc.EntregaRealizadaFichaContato = @EntregaRealizadaFichaContato	--'V'
and 	fc.CodigoRepresentante = isnull(@CodigoRepresentante, fc.CodigoRepresentante)
and ((fv.CodigoFabricante = @CodigoFabricante and @CodigoFabricante is not null) 
		or (fv.CodigoFabricante is  null and @CodigoFabricante is null))
GO

GRANT EXECUTE ON dbo.whRelVeicFaturadoEntregue TO SQLUsers
GO