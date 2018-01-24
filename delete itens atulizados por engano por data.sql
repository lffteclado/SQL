--select sum(ValorTabelaPreco) from tbTabelaPreco where DataValidadeTabelaPreco = '2017-03-10' and substring (CodigoProduto,1,1) = 'C'

--delete from tbTabelaPreco where DataValidadeTabelaPreco = '2017-03-10' and substring (CodigoProduto,1,1) = 'C'

select * from tbTabelaPreco where DataValidadeTabelaPreco = '2018-01-15' and CodigoEmpresa = 260
select * from tbTabelaPreco where DataValidadeTabelaPreco = '2017-10-09' and CodigoEmpresa = 260