go
if exists(select 1 from sysobjects where id = object_id('whLClientesAMonitorar1')) begin
DROP PROCEDURE dbo.whLClientesAMonitorar1 end

GO
CREATE PROCEDURE dbo.whLClientesAMonitorar1
/*INICIO_CABEC_PROC
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: StarClass Automoveis
 AUTOR........: Marcio Schvartz
 DATA.........: 05/03/2009
 UTILIZADO EM : frmfvaMonitoramentoClientesMonitorar
 OBJETIVO.....: Listar os clientes a monitorar
 ALTERACAO....: 
 OBJETIVO.....: 

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa          dtInteiro04,
@CodigoLocal   		  	dtInteiro04,
@DataDocumentoInicio	datetime,
@DataDocumentoFim		datetime,
@OrigemDocumentoFT		char(2),
@VeiculoNovoUsado		char(1)


WITH ENCRYPTION
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON


if @OrigemDocumentoFT = 'OS' begin
	select 	mon.IdMonitoramento,
			doc.NumeroDocumento, doc.DataDocumento,
			oroscit.NumeroOROS, oroscit.CodigoCIT,
			EfetivoEventual = case when docft.CodigoClienteEventual is null then 'EFETIVO' else 'EVENTUAL' end, 
			oros.DataEntradaVeiculoOS, oroscit.DataEncerramentoOSCIT,
			oros.ContatoClienteOS, oros.DDDTelefoneClienteOS, oros.TelefoneClienteOS,
			
			oros.CodigoCliFor as 'CodigoCliForProprietario', 
			cf_prop.TipoCliFor as 'TipoCliForProprietario',
			cf_prop.NomeCliFor as 'NomeCliForProprietario', 
			cf_prop.DDDCelularCliFor as 'DDDCelularCliForProprietario', 
			cf_prop.CelularCliFor as 'CelularCliForProprietario',
			cf_prop.EmailCliFor as 'EmailCliForProprietario',
			cf_prop.NomeContatoCliFor as 'NomeContatoCliForProprietario',
			cff_prop.DDDComercialFisica as 'DDDComercialFisicaProprietario', 
			cff_prop.TelefoneComercialFisica as 'TelefoneComercialFisicaProprietario',
			cff_prop.DataNascimentoFisica as 'DataNascimentoFisicaProprietario',
			
			oroscit.CodigoCliFor as 'CodigoCliForFaturar', 
			cf_faturar.TipoCliFor as 'TipoCliForFaturar',
			cf_faturar.NomeCliFor as 'NomeCliForFaturar', 
			cf_faturar.DDDCelularCliFor as 'DDDCelularCliForFaturar',
			cf_faturar.CelularCliFor as 'CelularCliForFaturar',
			cf_faturar.EmailCliFor as 'EmailCliForFaturar',
			cf_faturar.NomeContatoCliFor as 'NomeContatoCliForFaturar',
			cff_faturar.DDDComercialFisica as 'DDDComercialFisicaFaturar', 
			cff_faturar.TelefoneComercialFisica as 'TelefoneComercialFisicaFaturar',
			cff_faturar.DataNascimentoFisica as 'DataNascimentoFisicaFaturar',

			veicos.CodigoFabricante, 
			fabrveic.DescricaoFabricanteVeic,
			veicos.ModeloVeiculoOS, veicos.PlacaVeiculoOS,
			oros.ChassiVeiculoOS,
			oros.CodigoRepresentante, rc.NomeRepresentante,
			mon.IdMonitoramento, 
			coalesce(mon.MonitoramentoFinalizado, 'F') as 'MonitoramentoFinalizado', 
			mon.StatusMonitoramento,

		QtdLigacoes =	(case when DataHoraLigacao5 is not null then 5
							 when DataHoraLigacao4 is not null then 4
							 when DataHoraLigacao3 is not null then 3
							 when DataHoraLigacao2 is not null then 2
							 when DataHoraLigacao1 is not null then 1
							 else 0
						 end),

		DataHoraUltimaLigacao = (case when DataHoraLigacao5 is not null then DataHoraLigacao5
									 when DataHoraLigacao4 is not null then DataHoraLigacao4
									 when DataHoraLigacao3 is not null then DataHoraLigacao3
									 when DataHoraLigacao2 is not null then DataHoraLigacao2
									 when DataHoraLigacao1 is not null then DataHoraLigacao1
									 else null
								 end),

		UltimoAtendimento = (select NomeUsuario 
							 from tbUsuarios (nolock) 
							 where CodigoUsuario =  (case when UltimoAtendimento5 is not null then UltimoAtendimento5
														 when UltimoAtendimento4 is not null then UltimoAtendimento4
														 when UltimoAtendimento3 is not null then UltimoAtendimento3
														 when UltimoAtendimento2 is not null then UltimoAtendimento2
														 when UltimoAtendimento1 is not null then UltimoAtendimento1
														 else ''
													 end)),

		ObservacaoUltimaLigacao = (case when ObservacaoLigacao5 is not null then ObservacaoLigacao5
										 when ObservacaoLigacao4 is not null then ObservacaoLigacao4
										 when ObservacaoLigacao3 is not null then ObservacaoLigacao3
										 when ObservacaoLigacao2 is not null then ObservacaoLigacao2
										 when ObservacaoLigacao1 is not null then ObservacaoLigacao1
										 else ''
									 end)

	from tbDocumento doc (nolock) 
	inner join tbDocumentoFT docft (nolock) on docft.CodigoEmpresa = doc.CodigoEmpresa and docft.CodigoLocal = doc.CodigoLocal and docft.EntradaSaidaDocumento = doc.EntradaSaidaDocumento and docft.NumeroDocumento = doc.NumeroDocumento and docft.DataDocumento = doc.DataDocumento and docft.CodigoCliFor = doc.CodigoCliFor and docft.TipoLancamentoMovimentacao = doc.TipoLancamentoMovimentacao 
	inner join tbNaturezaOperacao nop (nolock) on nop.CodigoEmpresa = docft.CodigoEmpresa and nop.CodigoNaturezaOperacao = docft.CodigoNaturezaOperacao 
	inner join tbPedidoOS pedos (nolock) on docft.CodigoEmpresa = pedos.CodigoEmpresa and docft.CodigoLocal = pedos.CodigoLocal and docft.CentroCusto = pedos.CentroCusto and doc.NumeroPedidoDocumento = pedos.NumeroPedido and doc.NumeroSequenciaPedidoDocumento = pedos.SequenciaPedido 
	inner join tbOROS oros (nolock) on oros.CodigoEmpresa = pedos.CodigoEmpresa and oros.CodigoLocal = pedos.CodigoLocal and oros.FlagOROS = 'S' and oros.NumeroOROS = pedos.CodigoOrdemServicoPedidoOS 
	inner join tbOROSCIT oroscit (nolock) on oroscit.CodigoEmpresa = oros.CodigoEmpresa and oroscit.CodigoLocal  = oros.CodigoLocal and oroscit.FlagOROS = oros.FlagOROS and oroscit.NumeroOROS = oros.NumeroOROS 
	inner join tbOROSCITPedido oroscitped (nolock) on oroscitped.CodigoEmpresa = oroscit.CodigoEmpresa and oroscitped.CodigoLocal  = oroscit.CodigoLocal and oroscitped.FlagOROS = oroscit.FlagOROS and oroscitped.NumeroOROS = oroscit.NumeroOROS and oroscitped.CodigoCIT = oroscit.CodigoCIT and oroscitped.CentroCusto = pedos.CentroCusto and oroscitped.NumeroPedido = pedos.NumeroPedido and oroscitped.SequenciaPedido = pedos.SequenciaPedido
	inner join tbCIT cit (nolock) on cit.CodigoEmpresa = oroscit.CodigoEmpresa and cit.CodigoCIT = oroscit.CodigoCIT 
	left join tbRepresentanteComplementar rc (nolock) on rc.CodigoEmpresa = oros.CodigoEmpresa and rc.CodigoRepresentante = oros.CodigoRepresentante 

	inner join tbVeiculoOS veicos (nolock) on veicos.CodigoEmpresa = oros.CodigoEmpresa and veicos.ChassiVeiculoOS = oros.ChassiVeiculoOS 
	left join tbFabricanteVeiculo fabrveic (nolock) on fabrveic.CodigoEmpresa = veicos.CodigoEmpresa and fabrveic.CodigoFabricante = veicos.CodigoFabricante
	
	left join tbCliFor cf_prop (nolock) on 	cf_prop.CodigoEmpresa = oros.CodigoEmpresa and cf_prop.CodigoCliFor = oros.CodigoCliFor
	left join tbCliForFisica cff_prop (nolock) on cff_prop.CodigoEmpresa = cf_prop.CodigoEmpresa and cff_prop.CodigoCliFor = cf_prop.CodigoCliFor

	left join tbCliFor cf_faturar (nolock) on 	cf_faturar.CodigoEmpresa = oros.CodigoEmpresa and cf_faturar.CodigoCliFor = oros.CodigoCliFor
	left join tbCliForFisica cff_faturar (nolock) on cff_faturar.CodigoEmpresa = cf_faturar.CodigoEmpresa and cff_faturar.CodigoCliFor = cf_faturar.CodigoCliFor
	
	left join tbMonitoramento mon (nolock) on mon.CodigoEmpresa = doc.CodigoEmpresa and mon.CodigoLocal = doc.CodigoLocal and mon.CodigoCliFor = doc.CodigoCliFor and mon.DataDocumento = doc.DataDocumento and mon.NumeroDocumento = doc.NumeroDocumento 

	Where doc.EntradaSaidaDocumento = 'S' 
	and doc.TipoLancamentoMovimentacao in (7)
	and doc.CondicaoNFCancelada = 'F' 
	and doc.NumeroSequenciaPedidoDocumento = 1		-- Somente NF de Serviços Oficina (conf. NFe)
	and pedos.SequenciaPedido = 1					-- Somente Pedidos de Serviços Oficina (conf. NFe)
	and cit.OSInternaCIT = 'F' 
--	and cit.GarantiaCIT = 'F' 
	and cit.CITRecapagem = 'F' 
	and nop.CodigoTipoOperacao in (3, 4, 10) 
	and doc.CodigoEmpresa = @CodigoEmpresa
	and doc.CodigoLocal = @CodigoLocal
	and docft.OrigemDocumentoFT = @OrigemDocumentoFT
	and doc.DataDocumento between @DataDocumentoInicio and @DataDocumentoFim
	and oroscit.StatusOSCIT = 'N'

	order by cf_prop.NomeCliFor, oroscit.DataEncerramentoOSCIT desc
end


if @OrigemDocumentoFT = 'CV' begin

	select 	mon.IdMonitoramento,
			doc.NumeroDocumento, doc.DataDocumento,

			docft.OrigemDocumentoFT,
			docft.CodigoClienteEventual,	

			cf_faturado.CodigoCliFor as 'CodigoCliForFaturado',		-- igual ao tbDocumento.CodigoCliFor
			cf_faturado.TipoCliFor as 'TipoCliForFaturado',
			cf_faturado.NomeCliFor as 'NomeCliForFaturado', 
			cf_faturado.DDDCelularCliFor as 'DDDCelularCliForFaturado', 
			cf_faturado.CelularCliFor as 'CelularCliForFaturado',
			cf_faturado.DDDTelefoneCliFor as 'DDDTelefoneCliForFaturado',
			cf_faturado.TelefoneCliFor as 'TelefoneCliForFaturado',
			cf_faturado.NomeContatoCliFor as 'NomeContatoCliForFaturado',
			cf_faturado.EmailCliFor as 'EmailCliForFaturado',
			cff_faturado.DDDComercialFisica as 'DDDComercialFisicaFaturado', 
			cff_faturado.TelefoneComercialFisica as 'TelefoneComercialFisicaFaturado',
			cff_faturado.DataNascimentoFisica as 'DataNascimentoFisicaFaturado',

			cf_leasing.CodigoCliFor as 'CodigoCliForLeasing',		-- cliente que comprou o carro
			cf_leasing.TipoCliFor as 'TipoCliForLeasing',
			cf_leasing.NomeCliFor as 'NomeCliForLeasing', 
			cf_leasing.DDDCelularCliFor as 'DDDCelularCliForLeasing', 
			cf_leasing.CelularCliFor as 'CelularCliForLeasing',
			cf_leasing.DDDTelefoneCliFor as 'DDDTelefoneCliForLeasing',
			cf_leasing.TelefoneCliFor as 'TelefoneCliForLeasing',
			cf_leasing.NomeContatoCliFor as 'NomeContatoCliForLeasing',
			cf_leasing.EmailCliFor as 'EmailCliForLeasing',
			cff_leasing.DDDComercialFisica as 'DDDComercialFisicaLeasing', 
			cff_leasing.TelefoneComercialFisica as 'TelefoneComercialFisicaLeasing',
			cff_leasing.DataNascimentoFisica as 'DataNascimentoFisicaLeasing',

			
			isnull(veiccv.DataVendaVeic, doc.DataDocumento) as 'DataVenda',			-- Data da Venda
			--isnull(veiccv.DataEntregaVeicCV, doc.DataDocumento) as 'DataEntrega',	-- Data da Entrega
			veiccv.DataEntregaVeicCV as 'DataEntrega',	-- Data da Entrega
			veiccv.VeiculoNovoCV,

			negcv.CodigoRepresNegociacao1 as 'CodigoRepresentante', rc.NomeRepresentante, 
			1 as 'QtdVeiculos', 
			veiccv.ModeloVeiculo as 'ModeloVeiculo',
			veiccv.PlacaVeiculo as 'PlacaVeiculo',
			veiccv.NumeroVeiculoCV,
			coalesce(modelcv.CodigoFabricante, '') as 'CodigoFabricante',
			fabrveic.DescricaoFabricanteVeic,

			mon.IdMonitoramento, 
			coalesce(mon.MonitoramentoFinalizado, 'F') as 'MonitoramentoFinalizado', 
			mon.StatusMonitoramento,

		QtdLigacoes =	(case when DataHoraLigacao5 is not null then 5
							 when DataHoraLigacao4 is not null then 4
							 when DataHoraLigacao3 is not null then 3
							 when DataHoraLigacao2 is not null then 2
							 when DataHoraLigacao1 is not null then 1
							 else 0
						 end),

		DataHoraUltimaLigacao = (case when DataHoraLigacao5 is not null then DataHoraLigacao5
									 when DataHoraLigacao4 is not null then DataHoraLigacao4
									 when DataHoraLigacao3 is not null then DataHoraLigacao3
									 when DataHoraLigacao2 is not null then DataHoraLigacao2
									 when DataHoraLigacao1 is not null then DataHoraLigacao1
									 else null
								 end),

		UltimoAtendimento = (select NomeUsuario 
							 from tbUsuarios (nolock) 
							 where CodigoUsuario =  (case when UltimoAtendimento5 is not null then UltimoAtendimento5
														 when UltimoAtendimento4 is not null then UltimoAtendimento4
														 when UltimoAtendimento3 is not null then UltimoAtendimento3
														 when UltimoAtendimento2 is not null then UltimoAtendimento2
														 when UltimoAtendimento1 is not null then UltimoAtendimento1
														 else ''
													 end)),

		ObservacaoUltimaLigacao = (case when ObservacaoLigacao5 is not null then ObservacaoLigacao5
										 when ObservacaoLigacao4 is not null then ObservacaoLigacao4
										 when ObservacaoLigacao3 is not null then ObservacaoLigacao3
										 when ObservacaoLigacao2 is not null then ObservacaoLigacao2
										 when ObservacaoLigacao1 is not null then ObservacaoLigacao1
										 else ''
									 end)


	from tbDocumento doc (nolock) 
	inner join tbDocumentoFT docft (nolock) on docft.CodigoEmpresa = doc.CodigoEmpresa and docft.CodigoLocal = doc.CodigoLocal and docft.EntradaSaidaDocumento = doc.EntradaSaidaDocumento and docft.NumeroDocumento = doc.NumeroDocumento and docft.DataDocumento = doc.DataDocumento and docft.CodigoCliFor = doc.CodigoCliFor and docft.TipoLancamentoMovimentacao = doc.TipoLancamentoMovimentacao 
	inner join tbPedidoCV pedcv (nolock) on docft.CodigoEmpresa = pedcv.CodigoEmpresa and docft.CodigoLocal = pedcv.CodigoLocal and docft.CentroCusto = pedcv.CentroCusto and doc.NumeroPedidoDocumento = pedcv.NumeroPedido and doc.NumeroSequenciaPedidoDocumento = pedcv.SequenciaPedido 
	inner join tbVeiculoCV veiccv (nolock) on veiccv.CodigoEmpresa = pedcv.CodigoEmpresa and veiccv.CodigoLocal = pedcv.CodigoLocal and veiccv.NumeroVeiculoCV = pedcv.NumeroVeiculoCV
	inner join tbModeloVeiculoCV modelcv (nolock) on modelcv.CodigoEmpresa = veiccv.CodigoEmpresa and modelcv.ModeloVeiculo = veiccv.ModeloVeiculo
	inner join tbFabricanteVeiculo fabrveic (nolock) on fabrveic.CodigoEmpresa = modelcv.CodigoEmpresa and fabrveic.CodigoFabricante = modelcv.CodigoFabricante
	inner join tbNegociacaoCV negcv (nolock) on negcv.CodigoEmpresa = pedcv.CodigoEmpresa and negcv.CodigoLocal = pedcv.CodigoLocal and negcv.NumeroVeiculoCV = pedcv.NumeroVeiculoCV
	left join tbRepresentanteComplementar rc (nolock) on rc.CodigoEmpresa = negcv.CodigoEmpresa and rc.CodigoRepresentante = negcv.CodigoRepresNegociacao1
	inner join tbNaturezaOperacao nop (nolock) on nop.CodigoEmpresa = docft.CodigoEmpresa and nop.CodigoNaturezaOperacao = docft.CodigoNaturezaOperacao 

	left join tbCliFor cf_faturado (nolock) on 	cf_faturado.CodigoEmpresa = doc.CodigoEmpresa and cf_faturado.CodigoCliFor = doc.CodigoCliFor
	left join tbCliForFisica cff_faturado (nolock) on cff_faturado.CodigoEmpresa = cf_faturado.CodigoEmpresa and cff_faturado.CodigoCliFor = cf_faturado.CodigoCliFor

	left join tbCliFor cf_leasing (nolock) on 	cf_leasing.CodigoEmpresa = negcv.CodigoEmpresa and cf_leasing.CodigoCliFor = negcv.ClienteLeasing
	left join tbCliForFisica cff_leasing (nolock) on cff_leasing.CodigoEmpresa = cf_leasing.CodigoEmpresa and cff_leasing.CodigoCliFor = cf_leasing.CodigoCliFor

	left join tbMonitoramento mon (nolock) on mon.CodigoEmpresa = doc.CodigoEmpresa and mon.CodigoLocal = doc.CodigoLocal and mon.CodigoCliFor = doc.CodigoCliFor and mon.DataDocumento = doc.DataDocumento and mon.NumeroDocumento = doc.NumeroDocumento 
	Where doc.EntradaSaidaDocumento = 'S' 
	and doc.TipoLancamentoMovimentacao in (7)
	and doc.CondicaoNFCancelada = 'F' 
	and nop.CodigoTipoOperacao in (3, 4, 10) 
	and doc.CodigoEmpresa = @CodigoEmpresa
	and doc.CodigoLocal = @CodigoLocal
	and docft.OrigemDocumentoFT = @OrigemDocumentoFT
	and doc.DataDocumento between isnull(@DataDocumentoInicio, doc.DataDocumento) and isnull(@DataDocumentoFim, doc.DataDocumento)
	and veiccv.VeiculoNovoCV = case when @VeiculoNovoUsado = 'N' then 'V'
									when @VeiculoNovoUsado = 'U' then 'F'
									else veiccv.VeiculoNovoCV
								end

	order by cf_faturado.NomeCliFor, isnull(veiccv.DataEntregaVeicCV, doc.DataDocumento)  desc

end


GO
GRANT EXECUTE ON dbo.whLClientesAMonitorar1 TO SQLUsers
GO
