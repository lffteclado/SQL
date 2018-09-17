--Verificar Status OS, NF emitidas e outras informações refrentes a OS.
select * from tbOROSCIT where NumeroOROS = 162296

select * from tbPedidoOS where CodigoOrdemServicoPedidoOS = 124848
select NumeroPedido,SequenciaPedido,EspecieNotaFiscalPed,DataEmissaoNotaFiscalPed,NumeroNotaFiscalPed from tbPedido where NumeroPedido in (170302) and SequenciaPedido = 1 and CentroCusto = 21330
select NumeroPedido,SequenciaPedido,EspecieNotaFiscalPed,DataEmissaoNotaFiscalPed,NumeroNotaFiscalPed from tbPedido where NumeroPedido in (170303) and SequenciaPedido = 2 and CentroCusto = 21330
select * from tbDocumento where NumeroDocumento in (62206, 2837) and NumeroPedidoDocumento in(170302, 170303)

select * from tbDocumento where NumeroDocumento = 4770 and CodigoLocal = 1

select * from tbPedido where NumeroPedido in (170303)

SELECT * FROM tbOS WHERE NumeroOROS = 162296

SELECT DataEmissaoNotaFiscalOS, NumeroNotaFiscalOS, * FROM tbOROSCIT WHERE NumeroOROS = 162296

select * from tbOROSCIT where NumeroOROS = 124848

--select * from sysobjects where name like 'tb%OROSCIT%'

