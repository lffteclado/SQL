select sum(ValorTotalOS) from tbOROSCIT where CodigoCIT in ('C1F', 'C1N', 'C1U', 'I5NE', 'I5NM', 'I5NO', 'I5NP', 'I5UM', 'I5UO', 'IVO', 'I5UE') and DataEmissaoNotaFiscalOS between '2017-06-21 00:00:00.000' and '2017-07-20 23:59:00.000'

select * from tbOROSCIT where CodigoCIT in ('C1F', 'C1N', 'C1U', 'I5NE', 'I5NM', 'I5NO', 'I5NP', 'I5UM', 'I5UO', 'IVO', 'I5UE') and DataEmissaoNotaFiscalOS between '2017-06-21 00:00:00.000' and '2017-07-20 23:59:00.000' order by NumeroOROS desc

select * from tbOROSCIT where DataEmissaoNotaFiscalOS between '2017-06-21 00:00:00.000' and '2017-07-20 23:59:00.000'

select NumeroPedido, * from tbPedidoOS where CodigoOrdemServicoPedidoOS in (select NumeroOROS from tbOROSCIT where CodigoCIT in ('C1F', 'C1N', 'C1U', 'I5NE', 'I5NM', 'I5NO', 'I5NP', 'I5UM', 'I5UO', 'IVO', 'I5UE') and DataEmissaoNotaFiscalOS between '2017-06-21 00:00:00.000' and '2017-07-20 23:59:00.000')

--Peças
select sum(TotalProdutosPed) from tbPedido where NumeroPedido in (select NumeroPedido from tbPedidoOS where CodigoOrdemServicoPedidoOS in (select NumeroOROS from tbOROSCIT where CodigoCIT in ('C1F', 'C1N', 'C1U', 'I5NE', 'I5NM', 'I5NO', 'I5NP', 'I5UM', 'I5UO', 'IVO', 'I5UE') and DataEmissaoNotaFiscalOS between '2017-06-21 00:00:00.000' and '2017-07-20 23:59:00.000')) and CodigoLocal = 0 and CodigoNaturezaOperacao <> 500220 and SequenciaPedido <> 0 and DataEmissaoNotaFiscalPed between '2017-06-21 00:00:00.000' and '2017-07-20 23:59:00.000'


select  from tbPedidoOS

--Mão de Obra
select sum(TotalProdutosPed) from tbPedido where NumeroPedido in (select NumeroPedido from tbPedidoOS where CodigoOrdemServicoPedidoOS in (select NumeroOROS from tbOROSCIT where CodigoCIT in ('C1F', 'C1N', 'C1U', 'I5NE', 'I5NM', 'I5NO', 'I5NP', 'I5UM', 'I5UO', 'IVO', 'I5UE') and DataEmissaoNotaFiscalOS between '2017-06-21 00:00:00.000' and '2017-07-20 23:59:00.000')) and CodigoLocal = 0 and CodigoNaturezaOperacao = 500220 and SequenciaPedido <> 0 and DataEmissaoNotaFiscalPed between '2017-06-21 00:00:00.000' and '2017-07-20 23:59:00.000'


select * from tbPedido where NumeroPedido in (select NumeroPedido from tbPedidoOS where CodigoOrdemServicoPedidoOS in (select NumeroOROS from tbOROSCIT where CodigoCIT in ('C1F', 'C1N', 'C1U', 'I5NE', 'I5NM', 'I5NO', 'I5NP', 'I5UM', 'I5UO', 'IVO', 'I5UE') and DataEmissaoNotaFiscalOS between '2017-06-21 00:00:00.000' and '2017-07-20 23:59:00.000')) and CodigoLocal = 0 and CodigoNaturezaOperacao <> 500220 and SequenciaPedido <> 0 and DataEmissaoNotaFiscalPed between '2017-06-21 00:00:00.000' and '2017-07-20 23:59:00.000'


select distinct tOR.NumeroOROS, tP.NumeroPedido, tP.NumeroNotaFiscalPed, tP.DataPedidoPed, tP.ValorContabilPed  from tbOROSCIT tOR
inner join tbPedidoOS tPOS on
tPOS.CodigoOrdemServicoPedidoOS = tOR.NumeroOROS
inner join tbPedido tP on
tP.NumeroPedido = tPOS.NumeroPedido where tP.TipoTratamentoNFDigitadaPedido = 'P' and NumeroNotaFiscalPed <> 0 and tP.CodigoLocal = 0 and tP.DataEmissaoNotaFiscalPed between '2017-06-21 00:00:00.000' and '2017-07-20 23:59:00.000' order by NumeroNotaFiscalPed
 





