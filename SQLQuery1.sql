sp_helptext whEliminarEstruturaDocumento

select * from tbPedidoComplementar where NumeroDocumento = '14339'

sp_help tbPedidoComplementar
--select top(10) * from tbPedido

select * from tbPedido where NumeroPedido = 210288 and SequenciaPedido = 0 and CodigoLocal = 0 and NumeroNotaFiscalPed = 34269
select CodigoAlmoxarifadoOrigem,CodigoAlmoxarifadoDestino, CodigoProduto,* from tbItemPedido where NumeroPedido = 210288 and SequenciaPedido = 0 and CodigoLocal = 0
select * from tbDocumento where NumeroDocumento = 14339 and EntradaSaidaDocumento = 'E' and CodigoLocal = 0 and DataDocumento between '2017-03-20' and '2017-03-28'
select * from tbPedidoComplementar where NumeroDocumento = 14339 and EntradaSaidaDocumento = 'E' and CodigoLocal = 0 and DataDocumento between '2017-03-20' and '2017-03-28'

select * from tbPedido where NumeroPedido = 210288 and SequenciaPedido = 0 and CodigoLocal = 0 and NumeroNotaFiscalPed = 34269
select CodigoAlmoxarifadoOrigem,CodigoAlmoxarifadoDestino, CodigoProduto,* from tbItemPedido where NumeroPedido = 210288 and SequenciaPedido = 0 and CodigoLocal = 0
select * from tbDocumento where NumeroDocumento = 14339 and EntradaSaidaDocumento = 'E' and CodigoLocal = 0 and DataDocumento between '2017-03-20' and '2017-03-28'
select * from tbPedidoComplementar where NumeroDocumento = 14339 and EntradaSaidaDocumento = 'E' and CodigoLocal = 0 and DataDocumento between '2017-03-20' and '2017-03-28'



select top(10) * from tbItemPedido where NumeroPedido = 210288

select * from sysobjects where name like 'tb%stoque%'

select * from tbRegistroMovtoEstoque where CodigoProduto = 'A6111800009' and DataMovtoEstoque between '2017-03-01' and '2017-03-29'

/***********************************************************************************************************************************/

select tbCC.CodigoCliFor,
		tbCF.NomeCliFor,
		tbCC.CodigoPlanoPagamento
		from tbClienteComplementar tbCC
		inner join tbCliFor tbCF on
		tbCF.CodigoCliFor = tbCC.CodigoCliFor
		where substring (tbCC.CodigoPlanoPagamento,1,1) = '7'

/**************************************************************************************************************************************/

