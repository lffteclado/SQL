---------------------------------------------------------------------------------------------------
-- ROTINA 2
-- Atualizar tbMonitoramento ==> NumeroDocumento, DataDocumento, CodigoCliFor, CodigoFabricanteVeiculo
-- quando NÃO TEM NumeroDocumento 
-- Vendas (VD) Origem Veiculos (CV)   e   Pos-Vendas (PV)  Origem Oficina (OS)
---------------------------------------------------------------------------------------------------

set nocount on 

declare @CodigoEmpresa numeric(4)
declare @CodigoLocal numeric(4)
declare @IdMonitoramento numeric(6)
declare @DataMonitoramento datetime
declare @NumeroDocumento numeric(6)
declare @DataDocumento datetime
declare @CodigoCliFor numeric(14)
declare @TipoMonitoramento char(2)
declare @CodigoFabricanteVeiculo char(5)

declare @QtdRegistros numeric(5)
select @QtdRegistros = 0

---------------------------------------------------------------------------------------------------
-- Seleciona os Monitoramentos 
---------------------------------------------------------------------------------------------------
select * into #tmpMonitoramento 
from tbMonitoramento (nolock)
where CodigoEmpresa = 1470 and CodigoLocal = 0
and (NumeroDocumento = 0 or NumeroDocumento is null)
--and DataMonitoramento between '2009-09-17' and '2009-09-18'
order by TipoMonitoramento


---------------------------------------------------------------------------------------------------
set rowcount 1

---------------------------------------------------------------------------------------------------
-- Pega os dados para atualizacao
---------------------------------------------------------------------------------------------------
while exists (select * from #tmpMonitoramento) begin
	select	@CodigoEmpresa = CodigoEmpresa,		@CodigoLocal = CodigoLocal, 
			@IdMonitoramento = IdMonitoramento, @DataMonitoramento = DataMonitoramento,
			@CodigoCliFor = CodigoCliFor, @TipoMonitoramento = TipoMonitoramento
	from	#tmpMonitoramento

	if @TipoMonitoramento = 'PV' begin		-- Oficina
		select	@DataDocumento = doc.DataDocumento, @NumeroDocumento = doc.NumeroDocumento, 
				@CodigoFabricanteVeiculo = coalesce(veicos.CodigoFabricante, null)
		from tbDocumento doc (nolock)
		inner join tbDocumentoFT docft (nolock) on docft.CodigoEmpresa = doc.CodigoEmpresa and docft.CodigoLocal = doc.CodigoLocal and docft.EntradaSaidaDocumento = doc.EntradaSaidaDocumento and docft.NumeroDocumento = doc.NumeroDocumento and docft.DataDocumento = doc.DataDocumento and docft.CodigoCliFor = doc.CodigoCliFor and docft.TipoLancamentoMovimentacao = doc.TipoLancamentoMovimentacao
		inner join tbPedidoOS pedos (nolock) on docft.CodigoEmpresa = pedos.CodigoEmpresa and docft.CodigoLocal = pedos.CodigoLocal and docft.CentroCusto = pedos.CentroCusto and doc.NumeroPedidoDocumento = pedos.NumeroPedido and doc.NumeroSequenciaPedidoDocumento = pedos.SequenciaPedido 
		inner join tbOROS oros (nolock) on oros.CodigoEmpresa = pedos.CodigoEmpresa and oros.CodigoLocal = pedos.CodigoLocal and oros.FlagOROS = 'S' and oros.NumeroOROS = pedos.CodigoOrdemServicoPedidoOS 
		inner join tbVeiculoOS veicos (nolock) on veicos.CodigoEmpresa = oros.CodigoEmpresa and veicos.ChassiVeiculoOS = oros.ChassiVeiculoOS 
		where docft.OrigemDocumentoFT = 'OS'
		and doc.CodigoEmpresa = @CodigoEmpresa
		and doc.CodigoLocal = @CodigoLocal
		and doc.CodigoCliFor = @CodigoCliFor			-- Pesquisa ultima tbDocumento pelo tbMonitoramento.CodigoCliFor
		and doc.DataDocumento <= @DataMonitoramento		-- com a tbDocumento.DataDocumento <= tbMonitoramento.DataMonitoramento
		and doc.EntradaSaidaDocumento = 'S'
		and doc.TipoLancamentoMovimentacao = 7
		and doc.NumeroSequenciaPedidoDocumento = 1		-- Somente NF de Serviços Oficina (conf. NFe)
		and pedos.SequenciaPedido = 1					-- Somente Pedidos de Serviços Oficina (conf. NFe)
		order by doc.DataDocumento desc 
	end


	if @TipoMonitoramento = 'VD' begin		-- Veiculos
		select @DataDocumento = doc.DataDocumento, @NumeroDocumento = doc.NumeroDocumento, 
				@CodigoFabricanteVeiculo = coalesce(modelcv.CodigoFabricante, null)
		from tbDocumento doc (nolock) 
		inner join tbDocumentoFT docft (nolock) on docft.CodigoEmpresa = doc.CodigoEmpresa and docft.CodigoLocal = doc.CodigoLocal and docft.EntradaSaidaDocumento = doc.EntradaSaidaDocumento and docft.NumeroDocumento = doc.NumeroDocumento and docft.DataDocumento = doc.DataDocumento and docft.CodigoCliFor = doc.CodigoCliFor and docft.TipoLancamentoMovimentacao = doc.TipoLancamentoMovimentacao 
		inner join tbPedidoCV pedcv (nolock) on docft.CodigoEmpresa = pedcv.CodigoEmpresa and docft.CodigoLocal = pedcv.CodigoLocal and docft.CentroCusto = pedcv.CentroCusto and doc.NumeroPedidoDocumento = pedcv.NumeroPedido and doc.NumeroSequenciaPedidoDocumento = pedcv.SequenciaPedido 
		inner join tbVeiculoCV veiccv (nolock) on veiccv.CodigoEmpresa = pedcv.CodigoEmpresa and veiccv.CodigoLocal = pedcv.CodigoLocal and veiccv.NumeroVeiculoCV = pedcv.NumeroVeiculoCV
		inner join tbModeloVeiculoCV modelcv (nolock) on modelcv.CodigoEmpresa = veiccv.CodigoEmpresa and modelcv.ModeloVeiculo = veiccv.ModeloVeiculo
		inner join tbNaturezaOperacao nop (nolock) on nop.CodigoEmpresa = docft.CodigoEmpresa and nop.CodigoNaturezaOperacao = docft.CodigoNaturezaOperacao 
		where doc.CodigoEmpresa = @CodigoEmpresa
		and doc.CodigoLocal = @CodigoLocal
		and doc.CodigoCliFor = @CodigoCliFor			-- Pesquisa ultimo tbDocumento pelo tbMonitoramento.CodigoCliFor
		and doc.DataDocumento <= @DataMonitoramento		-- com a tbDocumento.DataDocumento <= tbMonitoramento.DataMonitoramento
		and doc.EntradaSaidaDocumento = 'S'
		and doc.TipoLancamentoMovimentacao = 7
		and doc.CondicaoNFCancelada = 'F' 
		and docft.OrigemDocumentoFT = 'CV'
		and nop.CodigoTipoOperacao in (3, 4, 10) 
		order by doc.DataDocumento desc 
	end


	select	@TipoMonitoramento, NumeroDocumento, DataDocumento, @NumeroDocumento as 'NumeroDocumento-Novo', 
			@DataDocumento as 'DataDocumento-Novo', @CodigoFabricanteVeiculo
	from tbMonitoramento
	where CodigoEmpresa = @CodigoEmpresa
	and CodigoLocal = @CodigoLocal
	and IdMonitoramento = @IdMonitoramento


	select @QtdRegistros = @QtdRegistros + 1

	update tbMonitoramento 
	set DataDocumento = @DataDocumento, NumeroDocumento = @NumeroDocumento, 
		CodigoFabricanteVeiculo = @CodigoFabricanteVeiculo  --, CodigoCliFor = @CodigoCliFor
	where CodigoEmpresa = @CodigoEmpresa
	and CodigoLocal = @CodigoLocal
	and IdMonitoramento = @IdMonitoramento


	delete from #tmpMonitoramento
	where CodigoEmpresa = @CodigoEmpresa
	and CodigoLocal = @CodigoLocal
	and IdMonitoramento = @IdMonitoramento

end

select convert(varchar(5), @QtdRegistros) + ' Registros Atualizados !!!' as 'Fim do Processo...'

set rowcount 0
set nocount off

go
drop table #tmpMonitoramento 
go
