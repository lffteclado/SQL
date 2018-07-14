select top 10 * from tbProdutoFT

select * from tbOROSCIT where NumeroOROS = 164973 and CodigoCIT = 'C1N'

select * from tbPedidoOS where CodigoOrdemServicoPedidoOS = 164973

select * from tbPedido where NumeroPedido = 15279 and CentroCusto = 21330

select * from tbItemPedido
 where NumeroPedido = 15279 and CentroCusto = 21330 and CodigoProduto in ('A6954900065', 'A0019909178', 'A6954900065', 'A0019909178', 'A6954900065', 'A0019909178')

select * from tbClassificacao

select * from sysobjects where name like 'tb%Classificacao%'

select * from tbClassificacaoFiscal where CodigoClassificacaoFiscal = '38200000' and CodigoTributacaoDentroEstado = 0199900

select tbi.CodigoProduto, tbi.CodigoClassificacaoFiscal, tbc.CodigoTributacaoDentroEstado from tbItemPedido tbi
left join tbClassificacaoFiscal tbc on tbi.CodigoClassificacaoFiscal = tbc.CodigoClassificacaoFiscal
where tbi.NumeroPedido = 15279 and tbi.CentroCusto = 21330 and tbc.CodigoTributacaoDentroEstado = 0100500

