go
if exists(select 1 from sysobjects where id = object_id('whLClientesAMonitorar')) begin
DROP PROCEDURE dbo.whLClientesAMonitorar end

GO
CREATE PROCEDURE dbo.whLClientesAMonitorar
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

@CodigoEmpresa            	dtInteiro04,
@CodigoLocal   		  	dtInteiro04,
@DataDocumentoInicio		datetime,
@DataDocumentoFim		datetime,
@OrigemDocumentoFT		char(2)

WITH ENCRYPTION
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON


if @OrigemDocumentoFT = 'OS' begin
	select distinct EfetivoEventual = case when docft.CodigoClienteEventual is null then 'EFETIVO' else 'EVENTUAL' end, 
			doc.CodigoCliFor , docft.CodigoClienteEventual 
	from tbDocumento doc (nolock) 
	inner join tbDocumentoFT docft (nolock) on docft.CodigoEmpresa = doc.CodigoEmpresa and docft.CodigoLocal = doc.CodigoLocal and docft.EntradaSaidaDocumento = doc.EntradaSaidaDocumento and docft.NumeroDocumento = doc.NumeroDocumento and docft.DataDocumento = doc.DataDocumento and docft.CodigoCliFor = doc.CodigoCliFor and docft.TipoLancamentoMovimentacao = doc.TipoLancamentoMovimentacao 
	inner join tbNaturezaOperacao nop (nolock) on nop.CodigoEmpresa = docft.CodigoEmpresa and nop.CodigoNaturezaOperacao = docft.CodigoNaturezaOperacao 
	inner join tbPedidoOS pedos (nolock) on docft.CodigoEmpresa = pedos.CodigoEmpresa and docft.CodigoLocal = pedos.CodigoLocal and docft.CentroCusto = pedos.CentroCusto and doc.NumeroPedidoDocumento = pedos.NumeroPedido and doc.NumeroSequenciaPedidoDocumento = pedos.SequenciaPedido 
	inner join tbOROS oros (nolock) on oros.CodigoEmpresa = pedos.CodigoEmpresa and oros.CodigoLocal = pedos.CodigoLocal and oros.FlagOROS = 'S' and oros.NumeroOROS = pedos.CodigoOrdemServicoPedidoOS 
	inner join tbOROSCIT oroscit (nolock) on oroscit.CodigoEmpresa = oros.CodigoEmpresa and oroscit.CodigoLocal  = oros.CodigoLocal and oroscit.FlagOROS = oros.FlagOROS and oroscit.NumeroOROS = oros.NumeroOROS 
	inner join tbCIT cit (nolock) on cit.CodigoEmpresa = oroscit.CodigoEmpresa and cit.CodigoCIT = oroscit.CodigoCIT 
	Where doc.EntradaSaidaDocumento = 'S' 
	and doc.TipoLancamentoMovimentacao = 7 
	and doc.CondicaoNFCancelada = 'F' 
	and cit.OSInternaCIT = 'F' 
--	and cit.GarantiaCIT = 'F' 
	and cit.CITRecapagem = 'F' 
	and nop.CodigoTipoOperacao in (3, 4, 10) 
	and doc.CodigoEmpresa = @CodigoEmpresa
	and doc.CodigoLocal = @CodigoLocal
	and doc.DataDocumento between @DataDocumentoInicio and @DataDocumentoFim
	and docft.OrigemDocumentoFT = @OrigemDocumentoFT
	order by doc.CodigoCliFor, docft.CodigoClienteEventual
end

if @OrigemDocumentoFT = 'CV' begin
	select distinct EfetivoEventual = case when docft.CodigoClienteEventual is null then 'EFETIVO' else 'EVENTUAL' end, 
			doc.CodigoCliFor , docft.CodigoClienteEventual 
	from tbDocumento doc (nolock) 
	inner join tbDocumentoFT docft (nolock) on docft.CodigoEmpresa = doc.CodigoEmpresa and docft.CodigoLocal = doc.CodigoLocal and docft.EntradaSaidaDocumento = doc.EntradaSaidaDocumento and docft.NumeroDocumento = doc.NumeroDocumento and docft.DataDocumento = doc.DataDocumento and docft.CodigoCliFor = doc.CodigoCliFor and docft.TipoLancamentoMovimentacao = doc.TipoLancamentoMovimentacao 
	inner join tbNaturezaOperacao nop (nolock) on nop.CodigoEmpresa = docft.CodigoEmpresa and nop.CodigoNaturezaOperacao = docft.CodigoNaturezaOperacao 
	Where doc.EntradaSaidaDocumento = 'S' 
	and doc.TipoLancamentoMovimentacao = 7 
	and doc.CondicaoNFCancelada = 'F' 
	and nop.CodigoTipoOperacao in (3, 4, 10) 
	and doc.CodigoEmpresa = @CodigoEmpresa
	and doc.CodigoLocal = @CodigoLocal
	and doc.DataDocumento between @DataDocumentoInicio and @DataDocumentoFim
	and docft.OrigemDocumentoFT = @OrigemDocumentoFT
	order by doc.CodigoCliFor, docft.CodigoClienteEventual
end


GO
GRANT EXECUTE ON dbo.whLClientesAMonitorar TO SQLUsers
GO






go
if exists(select 1 from sysobjects where id = object_id('whLMonitoramentosRealizados')) begin
DROP PROCEDURE dbo.whLMonitoramentosRealizados end

GO
CREATE PROCEDURE dbo.whLMonitoramentosRealizados
/*INICIO_CABEC_PROC
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: StarClass Automoveis
 AUTOR........: Marcio Schvartz
 DATA.........: 05/03/2009
 UTILIZADO EM : frmfvaMonitoramentoClientesMonitorar
 OBJETIVO.....: Pesquisar os dados do cliente a monitorar. Somente Oficina porque  de Pos-Vendas.
 ALTERACAO....: 
 OBJETIVO.....: 

whLMonitoramentosRealizados 1608, 0, '2009-09-01', '2009-09-30', 'OS', 'T'
whLMonitoramentosRealizados 1608, 0, '2009-09-01', '2009-09-30', 'OS', 'V'
whLMonitoramentosRealizados 1608, 0, '2009-09-01', '2009-09-30', 'OS', 'F'

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa				dtInteiro04,
@CodigoLocal   		  		dtInteiro04,
@DataMonitoramentoInicio	datetime,
@DataMonitoramentoFim		datetime,
@OrigemDocumentoFT			char(2),
@MonitoramentoFinalizado	char(1)

AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


if @OrigemDocumentoFT = 'OS' begin

	select 	doc.NumeroDocumento, doc.DataDocumento,
			docft.OrigemDocumentoFT,
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
			mon.*

	from tbMonitoramento mon (nolock)
	inner join tbDocumento doc (nolock) on doc.CodigoEmpresa = mon.CodigoEmpresa and doc.CodigoLocal = mon.CodigoLocal and doc.CodigoCliFor = mon.CodigoCliFor and doc.DataDocumento = mon.DataDocumento and doc.NumeroDocumento = mon.NumeroDocumento 

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
	and oroscit.StatusOSCIT = 'N'
	and mon.DataMonitoramento between @DataMonitoramentoInicio and @DataMonitoramentoFim
	and mon.MonitoramentoFinalizado =	case 
											when @MonitoramentoFinalizado = 'T' then mon.MonitoramentoFinalizado
											else @MonitoramentoFinalizado
										end

end



if @OrigemDocumentoFT = 'CV' begin

	select 	mon.IdMonitoramento,
			doc.NumeroDocumento, doc.DataDocumento,

			docft.OrigemDocumentoFT,
			negcv.ClienteLeasing,
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
			mon.*

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
	and mon.DataMonitoramento between @DataMonitoramentoInicio and @DataMonitoramentoFim
	and mon.MonitoramentoFinalizado =	case 
											when @MonitoramentoFinalizado = 'T' then mon.MonitoramentoFinalizado
											else @MonitoramentoFinalizado
										end

end


GO
GRANT EXECUTE ON dbo.whLMonitoramentosRealizados TO SQLUsers
GO






go
if exists(select 1 from sysobjects where id = object_id('whPClienteMonitoramento')) begin
DROP PROCEDURE dbo.whPClienteMonitoramento end

GO
CREATE PROCEDURE dbo.whPClienteMonitoramento
/*INICIO_CABEC_PROC
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: StarClass Automoveis
 AUTOR........: Marcio Schvartz
 DATA.........: 05/03/2009
 UTILIZADO EM : frmfvaMonitoramentoClientesMonitorar
 OBJETIVO.....: Pesquisar os dados do cliente a monitorar. Somente Oficina porque  de Pos-Vendas.
 ALTERACAO....: 
 OBJETIVO.....: 

whPClienteMonitoramento 1608, 0, '2009-02-01', '2009-02-28','OS', 10
whPClienteMonitoramento 1608, 0, '2008-02-01', '2009-02-28', 'CV',100

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa            	dtInteiro04,
@CodigoLocal   		  	dtInteiro04,
@DataDocumentoInicio		datetime,
@DataDocumentoFim		datetime,
@OrigemDocumentoFT		char(2),
@CodigoCliFor			numeric(14)

WITH ENCRYPTION
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

if @OrigemDocumentoFT = 'OS' begin
	select top 1
		docft.OrigemDocumentoFT,
		doc.CodigoCliFor, docft.CodigoClienteEventual,	
		EfetivoEventual = case when docft.CodigoClienteEventual is null then 'EFETIVO' else 'EVENTUAL' end, 
		(select top 1 cf.NomeCliFor from tbCliFor cf (nolock) where cf.CodigoEmpresa = doc.CodigoEmpresa and cf.CodigoCliFor = doc.CodigoCliFor) as 'NomeCliFor',
		oros.ContatoClienteOS as 'ContatoCliente', 
		oros.DDDTelefoneClienteOS as 'DDDTelefoneCliente', 
		oros.TelefoneClienteOS as 'TelefoneCliente', 
		oros.DataEntradaVeiculoOS,  
		oros.CodigoRepresentante, rc.NomeRepresentante, oros.NumeroOROS, oroscit.CodigoCIT,  
		coalesce(oros.DataEncerramentoOS, oroscit.DataEncerramentoOSCIT) as 'DataEncerramentoOS',
		veicos.PlacaVeiculoOS as 'PlacaVeiculo', 
		veicos.ModeloVeiculoOS as 'ModeloVeiculo',
		case 	when docft.CodigoClienteEventual is null 
				then (select top 1 cf1.EmailCliFor from tbCliFor cf1 (nolock) where cf1.CodigoEmpresa = doc.CodigoEmpresa and cf1.CodigoCliFor = doc.CodigoCliFor)
			else
				''
		end as 'Email',

		case 	when docft.CodigoClienteEventual is null 
				then (select top 1 cf2.DataNascimentoFisica from tbCliForFisica cf2 (nolock) where cf2.CodigoEmpresa = doc.CodigoEmpresa and cf2.CodigoCliFor = doc.CodigoCliFor)
			else
				''
		end as 'DataNascimentoFisica',
		veicos.CodigoFabricante

	from tbDocumento doc (nolock) 
	inner join tbDocumentoFT docft (nolock) on docft.CodigoEmpresa = doc.CodigoEmpresa and docft.CodigoLocal = doc.CodigoLocal and docft.EntradaSaidaDocumento = doc.EntradaSaidaDocumento and docft.NumeroDocumento = doc.NumeroDocumento and docft.DataDocumento = doc.DataDocumento and docft.CodigoCliFor = doc.CodigoCliFor and docft.TipoLancamentoMovimentacao = doc.TipoLancamentoMovimentacao 
	inner join tbPedidoOS pedos (nolock) on docft.CodigoEmpresa = pedos.CodigoEmpresa and docft.CodigoLocal = pedos.CodigoLocal and docft.CentroCusto = pedos.CentroCusto and doc.NumeroPedidoDocumento = pedos.NumeroPedido and doc.NumeroSequenciaPedidoDocumento = pedos.SequenciaPedido 
	inner join tbOROS oros (nolock) on oros.CodigoEmpresa = pedos.CodigoEmpresa and oros.CodigoLocal = pedos.CodigoLocal and oros.FlagOROS = 'S' and oros.NumeroOROS = pedos.CodigoOrdemServicoPedidoOS 
	inner join tbOROSCIT oroscit (nolock) on oroscit.CodigoEmpresa = oros.CodigoEmpresa and oroscit.CodigoLocal  = oros.CodigoLocal and oroscit.FlagOROS = oros.FlagOROS and oroscit.NumeroOROS = oros.NumeroOROS 
	inner join tbCIT cit (nolock) on cit.CodigoEmpresa = oroscit.CodigoEmpresa and cit.CodigoCIT = oroscit.CodigoCIT 
	inner join tbVeiculoOS veicos (nolock) on veicos.CodigoEmpresa = oros.CodigoEmpresa and veicos.ChassiVeiculoOS = oros.ChassiVeiculoOS 
	left join tbRepresentanteComplementar rc (nolock) on rc.CodigoEmpresa = oros.CodigoEmpresa and rc.CodigoRepresentante = oros.CodigoRepresentante 
	where doc.EntradaSaidaDocumento = 'S' 
	and doc.TipoLancamentoMovimentacao = 7 
	and doc.CondicaoNFCancelada = 'F' 
	and doc.NumeroSequenciaPedidoDocumento = 1		-- Somente NF de Serviços Oficina (conf. NFe)
	and docft.OrigemDocumentoFT = @OrigemDocumentoFT
	and cit.OSInternaCIT = 'F' 
--	and cit.GarantiaCIT = 'F' 
	and cit.CITRecapagem = 'F' 
	and doc.CodigoEmpresa = @CodigoEmpresa
	and doc.CodigoLocal = @CodigoLocal
	and doc.DataDocumento between @DataDocumentoInicio and @DataDocumentoFim
	and doc.CodigoCliFor = @CodigoCliFor
	and not exists ( select * from tbOROSCIT 
					 where CodigoEmpresa  = @CodigoEmpresa
					 and CodigoLocal = @CodigoLocal
					 and FlagOROS = oros.FlagOROS
					 and CodigoCIT = oroscit.CodigoCIT
					 and NumeroOROS = oros.NumeroOROS
					 and StatusOSCIT in ('A','C'))
	order by doc.DataDocumento desc
end


if @OrigemDocumentoFT = 'CV' begin
	select top 1
		docft.OrigemDocumentoFT,
		isnull(negcv.ClienteLeasing, doc.CodigoCliFor) as 'CodigoCliFor', docft.CodigoClienteEventual,	
		case when docft.CodigoClienteEventual is null then 'EFETIVO' else 'EVENTUAL' end as 'EfetivoEventual', 
		(select top 1 cf.NomeCliFor from tbCliFor cf (nolock) where cf.CodigoEmpresa = doc.CodigoEmpresa and cf.CodigoCliFor = isnull(negcv.ClienteLeasing, doc.CodigoCliFor)) as 'NomeCliFor',
		(select top 1 cf.NomeContatoCliFor from tbCliFor cf (nolock) where cf.CodigoEmpresa = doc.CodigoEmpresa and cf.CodigoCliFor = isnull(negcv.ClienteLeasing, doc.CodigoCliFor)) as 'ContatoCliente',
		(select top 1 cf.DDDTelefoneCliFor from tbCliFor cf (nolock) where cf.CodigoEmpresa = doc.CodigoEmpresa and cf.CodigoCliFor = isnull(negcv.ClienteLeasing, doc.CodigoCliFor)) as 'DDDTelefoneCliente',
		(select top 1 cf.TelefoneCliFor from tbCliFor cf (nolock) where cf.CodigoEmpresa = doc.CodigoEmpresa and cf.CodigoCliFor = isnull(negcv.ClienteLeasing, doc.CodigoCliFor)) as 'TelefoneCliente',
		(select top 1 cf.DDDCelularCliFor from tbCliFor cf (nolock) where cf.CodigoEmpresa = doc.CodigoEmpresa and cf.CodigoCliFor = isnull(negcv.ClienteLeasing, doc.CodigoCliFor)) as 'DDDCelularCliente',
		(select top 1 cf.CelularCliFor from tbCliFor cf (nolock) where cf.CodigoEmpresa = doc.CodigoEmpresa and cf.CodigoCliFor = isnull(negcv.ClienteLeasing, doc.CodigoCliFor)) as 'CelularCliFor',
		isnull(veiccv.DataEntregaVeicCV, doc.DataDocumento) as 'DataEntrega',
		negcv.CodigoRepresNegociacao1 as 'CodigoRepresentante', rc.NomeRepresentante, 
		veiccv.DataVendaVeic,	-- Data da Venda
		1 as 'QtdVeiculos', 
		doc.NumeroDocumento,
		veiccv.ModeloVeiculo as 'ModeloVeiculo',
		veiccv.PlacaVeiculo as 'PlacaVeiculo',
		veiccv.NumeroVeiculoCV,
		coalesce(modelcv.CodigoFabricante, '') as 'CodigoFabricante',
		case 	when docft.CodigoClienteEventual is null 
				then (select top 1 cf1.EmailCliFor from tbCliFor cf1 (nolock) where cf1.CodigoEmpresa = doc.CodigoEmpresa and cf1.CodigoCliFor = doc.CodigoCliFor)
			else
				''
		end as 'Email',

		case 	when docft.CodigoClienteEventual is null 
				then (select top 1 cf2.DataNascimentoFisica from tbCliForFisica cf2 (nolock) where cf2.CodigoEmpresa = doc.CodigoEmpresa and cf2.CodigoCliFor = doc.CodigoCliFor)
			else
				''
		end as 'DataNascimentoFisica',
		modelcv.CodigoFabricante

	from tbDocumento doc (nolock) 
	inner join tbDocumentoFT docft (nolock) on docft.CodigoEmpresa = doc.CodigoEmpresa and docft.CodigoLocal = doc.CodigoLocal and docft.EntradaSaidaDocumento = doc.EntradaSaidaDocumento and docft.NumeroDocumento = doc.NumeroDocumento and docft.DataDocumento = doc.DataDocumento and docft.CodigoCliFor = doc.CodigoCliFor and docft.TipoLancamentoMovimentacao = doc.TipoLancamentoMovimentacao 
	inner join tbPedidoCV pedcv (nolock) on docft.CodigoEmpresa = pedcv.CodigoEmpresa and docft.CodigoLocal = pedcv.CodigoLocal and docft.CentroCusto = pedcv.CentroCusto and doc.NumeroPedidoDocumento = pedcv.NumeroPedido and doc.NumeroSequenciaPedidoDocumento = pedcv.SequenciaPedido 
	inner join tbVeiculoCV veiccv (nolock) on veiccv.CodigoEmpresa = pedcv.CodigoEmpresa and veiccv.CodigoLocal = pedcv.CodigoLocal and veiccv.NumeroVeiculoCV = pedcv.NumeroVeiculoCV
	inner join tbModeloVeiculoCV modelcv (nolock) on modelcv.CodigoEmpresa = veiccv.CodigoEmpresa and modelcv.ModeloVeiculo = veiccv.ModeloVeiculo
	inner join tbNegociacaoCV negcv (nolock) on negcv.CodigoEmpresa = pedcv.CodigoEmpresa and negcv.CodigoLocal = pedcv.CodigoLocal and negcv.NumeroVeiculoCV = pedcv.NumeroVeiculoCV
	left join tbRepresentanteComplementar rc (nolock) on rc.CodigoEmpresa = negcv.CodigoEmpresa and rc.CodigoRepresentante = negcv.CodigoRepresNegociacao1

	where doc.EntradaSaidaDocumento = 'S' 
	and doc.TipoLancamentoMovimentacao = 7 
	and doc.CondicaoNFCancelada = 'F' 
	and docft.OrigemDocumentoFT = @OrigemDocumentoFT
	--and cit.OSInternaCIT = 'F' 
	--and cit.GarantiaCIT = 'F' 
	--and cit.CITRecapagem = 'F' 
	and doc.CodigoEmpresa = @CodigoEmpresa
	and doc.CodigoLocal = @CodigoLocal
	and doc.DataDocumento between @DataDocumentoInicio and @DataDocumentoFim
	and doc.CodigoCliFor = @CodigoCliFor
	order by doc.DataDocumento desc
end


GO
GRANT EXECUTE ON dbo.whPClienteMonitoramento TO SQLUsers
GO





go
drop PROCEDURE dbo.whIMonitoramento 
go
CREATE PROCEDURE dbo.whIMonitoramento  
@CodigoEmpresa dtInteiro04 ,
@CodigoLocal dtInteiro04 ,
@IdMonitoramento numeric(6),
@DataMonitoramento datetime,
@TipoMonitoramento char(2),			-- VD/PV : Venda / Pos-Venda
@StatusMonitoramento char(2),			-- CO/NC/NR : Contatado / Não Contatado / Não Quiz Responder
@MonitoramentoFinalizado dtBooleano,		-- V/F
@TipoCliente char(10),				-- EFETIVO / EVENTUAL
@CodigoCliFor numeric(14),
@CodigoClienteEventual numeric(14),
@NumeroFichaContato numeric(6),
@DataDocumento datetime,
@UsuarioEmUtilizacao varchar(30),
@DataHoraLigacao1 datetime,
@ObservacaoLigacao1 varchar(100),
@UltimoAtendimento1 varchar(30),
@DataHoraLigacao2 datetime,
@ObservacaoLigacao2 varchar(100),
@UltimoAtendimento2 varchar(30),
@DataHoraLigacao3 datetime,
@ObservacaoLigacao3 varchar(100),
@UltimoAtendimento3 varchar(30),
@DataHoraLigacao4 datetime,
@ObservacaoLigacao4 varchar(100),
@UltimoAtendimento4 varchar(30),
@DataHoraLigacao5 datetime,
@ObservacaoLigacao5 varchar(100),
@UltimoAtendimento5 varchar(30),
@RespostaQuestao1 dtBooleano,
@RespostaQuestao2 dtBooleano,
@RespostaQuestao3 dtBooleano,
@RespostaQuestao4 dtBooleano,
@RespostaQuestao5 dtBooleano,
@MotivoQuestao1 varchar(100),
@MotivoQuestao2 varchar(100),
@MotivoQuestao3 varchar(100),
@MotivoQuestao4 varchar(100),
@MotivoQuestao5 varchar(100),
@PossiveisMotivos1 varchar(1),
@PossiveisMotivos2 varchar(1),
@PossiveisMotivos3 varchar(1),
@PossiveisMotivos4 varchar(1),
@PossiveisMotivos5 varchar(1),
@AnaliseProcedencia dtBooleano,
@MotivoAnaliseProcedencia varchar(100),
@PossiveisMotivosAnProced varchar(1),
@AcaoPontual varchar(1),
@MotivoOutrosAcaoPontual varchar(100),
@DataContatoAcaoPontual datetime,
@ComentariosAcaoPontual varchar(250),
@AcaoCorretiva dtBooleano

AS

select @IdMonitoramento = (	select (coalesce(max(IdMonitoramento), 0) + 1) 
				from tbMonitoramento 
				where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal)

insert into tbMonitoramento 
(CodigoEmpresa,
CodigoLocal ,
IdMonitoramento ,
DataMonitoramento,
TipoMonitoramento ,
StatusMonitoramento ,
MonitoramentoFinalizado ,
TipoCliente,
CodigoCliFor,
CodigoClienteEventual,
NumeroFichaContato,
DataDocumento,
UsuarioEmUtilizacao,
DataHoraLigacao1 ,
ObservacaoLigacao1 ,
UltimoAtendimento1,
DataHoraLigacao2 ,
ObservacaoLigacao2,
UltimoAtendimento2,
DataHoraLigacao3 ,
ObservacaoLigacao3,
UltimoAtendimento3,
DataHoraLigacao4 ,
ObservacaoLigacao4,
UltimoAtendimento4,
DataHoraLigacao5 ,
ObservacaoLigacao5,
UltimoAtendimento5,
RespostaQuestao1 ,
RespostaQuestao2 ,
RespostaQuestao3 ,
RespostaQuestao4 ,
RespostaQuestao5 ,
MotivoQuestao1 ,
MotivoQuestao2 ,
MotivoQuestao3 ,
MotivoQuestao4 ,
MotivoQuestao5 ,
PossiveisMotivos1 ,
PossiveisMotivos2 ,
PossiveisMotivos3 ,
PossiveisMotivos4 ,
PossiveisMotivos5 ,
AnaliseProcedencia ,
MotivoAnaliseProcedencia ,
PossiveisMotivosAnProced ,
AcaoPontual ,
MotivoOutrosAcaoPontual ,
DataContatoAcaoPontual ,
ComentariosAcaoPontual ,
AcaoCorretiva )

values
(@CodigoEmpresa,
@CodigoLocal ,
@IdMonitoramento,
@DataMonitoramento,
@TipoMonitoramento ,
@StatusMonitoramento ,
@MonitoramentoFinalizado ,
@TipoCliente,
@CodigoCliFor,
@CodigoClienteEventual,
@NumeroFichaContato,
@DataDocumento,
@UsuarioEmUtilizacao,
@DataHoraLigacao1 ,
@ObservacaoLigacao1 ,
@UltimoAtendimento1,
@DataHoraLigacao2 ,
@ObservacaoLigacao2,
@UltimoAtendimento2,
@DataHoraLigacao3 ,
@ObservacaoLigacao3,
@UltimoAtendimento3,
@DataHoraLigacao4 ,
@ObservacaoLigacao4,
@UltimoAtendimento4,
@DataHoraLigacao5 ,
@ObservacaoLigacao5,
@UltimoAtendimento5,
@RespostaQuestao1 ,
@RespostaQuestao2 ,
@RespostaQuestao3 ,
@RespostaQuestao4 ,
@RespostaQuestao5 ,
@MotivoQuestao1 ,
@MotivoQuestao2 ,
@MotivoQuestao3 ,
@MotivoQuestao4 ,
@MotivoQuestao5 ,
@PossiveisMotivos1 ,
@PossiveisMotivos2 ,
@PossiveisMotivos3 ,
@PossiveisMotivos4 ,
@PossiveisMotivos5 ,
@AnaliseProcedencia ,
@MotivoAnaliseProcedencia ,
@PossiveisMotivosAnProced ,
@AcaoPontual ,
@MotivoOutrosAcaoPontual ,
@DataContatoAcaoPontual ,
@ComentariosAcaoPontual ,
@AcaoCorretiva )


go
grant execute on dbo.whIMonitoramento  to SQLUsers
go




go
if exists (select * from sysobjects where name = 'spPClienteEntrevistaConsult') begin
	drop procedure dbo.spPClienteEntrevistaConsult 
end

go
create procedure dbo.spPClienteEntrevistaConsult
@CodigoEmpresa numeric(4), 
@PotencialEfetivo char(1),
@CodigoCliente numeric(14),
@TipoCliente char(1)

AS

select * from tbClienteEntrevistaConsult (nolock)
where CodigoEmpresa = @CodigoEmpresa
and PotencialEfetivo = @PotencialEfetivo
and CodigoCliente = @CodigoCliente
and TipoCliente = @TipoCliente


go
grant execute on dbo.spPClienteEntrevistaConsult to SQLUsers
go


