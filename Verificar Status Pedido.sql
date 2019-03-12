select * from sysobjects where name like 'tb%edido%'

select StatusPedidoPed, * from tbPedido where NumeroPedido = 348769 and CodigoEmpresa = 2630 and CodigoLocal = 1

select * from tbItemPedido where NumeroPedido = 348769 and CodigoEmpresa = 2630 and CodigoLocal = 1

select * from tbPedidoVenda where NumeroPedido = 348769 and CodigoEmpresa = 2630 and CodigoLocal = 1
