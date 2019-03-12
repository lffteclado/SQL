select * from tbDocumento where NumeroDocumento = 999 and CodigoLocal = 1 and DataDocumento = '2017-05-09'
select * from tbPedido where NumeroPedido = 348239 and CodigoLocal = 1 and CentroCusto = 21320
select * from tbItemPedido where NumeroPedido = 348239 and CentroCusto = 21320 and CodigoLocal = 1
select * from tbRegistroMovtoEstoque where CodigoProduto in ('A0028206161', 'A0028205961') and CodigoLocal = 1 order by timestamp
