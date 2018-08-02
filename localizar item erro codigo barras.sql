select CodigoProduto, CodigoBarrasProduto from tbProdutoFT where CodigoBarrasProduto like '%SEM%' and CodigoProduto = 'QC2585'

QW6MULTI20                    
QC2585                        
LUB122158                     

--rollback transaction
--EXECUTE whCEMovimentacaoEstoqueDIMS @CodigoEmpresa = 3140,@CodigoLocal = 0,@DataInicial = '2018-05-09',@DataFinal = '2018-05-09',@TipoEnvio = 2

--sp_who2

--kill 238

sp_helptext whCEMovimentacaoEstoqueDIMS

select * from tbItemDocumento where NumeroDocumento = 28579 and DataDocumento = '2018-07-26 00:00:00.000'

select * from tbItemPedido where NumeroPedido = 940881 and DataDocumento = '2018-07-26 00:00:00.000'