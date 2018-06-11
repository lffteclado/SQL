--select * from tbProdutoFT where CodigoBarrasProduto like '%SEM%'

--rollback transaction
EXECUTE whCEMovimentacaoEstoqueDIMS @CodigoEmpresa = 3140,@CodigoLocal = 0,@DataInicial = '2018-05-09',@DataFinal = '2018-05-09',@TipoEnvio = 2

--sp_who2

--kill 238

sp_helptext whCEMovimentacaoEstoqueDIMS