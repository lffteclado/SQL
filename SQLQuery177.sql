select NumeroNotaFiscalPed,* from tbPedido where NumeroPedido = 28988 and CentroCusto = 27720 and DataPedidoPed in ('2017-03-17','2017-03-20')
select CodigoProduto, QuantidadeItemPed,* from tbItemPedido where NumeroPedido = 28988 and CentroCusto = 27720
select * from tbItemDocumento where DataDocumento in ('2017-03-17','2017-03-20') and CodigoLocal = 0 and NumeroDocumento = '28988'
select * from tbDocumentoNFe where DataDocumento in ('2017-03-17','2017-03-20') and CodigoLocal = 0 and NumeroDocumento =  '28988'
select * from tbDMSTransitoNFe where DataDocumento in ('2017-03-17','2017-03-20') and NumeroDocumento = '28988'

select * from tbFichaControleProducao where NumeroFicha = 249328
select * from tbFichaControleProducao where NumeroFicha = 249330
select * from tbFichaControleProducao where NumeroFicha = 249331 
select * from tbFichaControlePedidoFicha where NumeroLote = 7272 
select * from tbFichaControlePedidoCapa where NumeroLote = 7272 

select * from tbFichaControleProducao where NotaFiscalVenda = 28988

select top(1) * from tbFichaControlePedidoCapa where NotaFiscalPecas = 28988

select * from tbRegistroMovtoEstoque where CodigoProduto = '9 BZY'

select * from NFDocumento where NumeroPedidoDocumento = 28988