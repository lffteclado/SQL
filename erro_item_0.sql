
select * from tbLinhaProduto


select * from NFDocumento where NumeroDocumento = 77777

select * from tbProdutoFT where CodigoLinhaProduto not in (6,3) and SubstituicaoTributariaProduto = 'V'


select * from tbPedido where NumeroPedido = 202037 and CentroCusto = 21330
select * from tbItemPedido where NumeroPedido = 202037 and CentroCusto = 21330 and CodigoProduto in ('C010001','A9406821160','A9585205641')