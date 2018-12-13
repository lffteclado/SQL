--select CodigoProduto, PrecoReposicaoIndiceProduto from tbProdutoFT where len(PrecoReposicaoIndiceProduto) > (select len(PrecoReposicaoIndiceProduto) as tamanho from tbProdutoFT  where CodigoProduto = 'X002776039')

--select len(PrecoReposicaoIndiceProduto) as tamanho from tbProdutoFT  where CodigoProduto = 'X002776039'

--34162,58

EXECUTE whCEMovimentacaoEstoqueDIMS @CodigoEmpresa = 3140,@CodigoLocal = 0,@DataInicial = '2018-01-17',@DataFinal = '2018-01-18',@TipoEnvio = 2