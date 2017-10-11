--Verificar Status OS, NF emitidas e outras informações refrentes a OS.
select * from tbOROSCIT where NumeroOROS = 183915	

select * from tbPedidoOS where CodigoOrdemServicoPedidoOS = 183915
select NumeroPedido,SequenciaPedido,EspecieNotaFiscalPed,DataEmissaoNotaFiscalPed,NumeroNotaFiscalPed from tbPedido where NumeroPedido in (665905) --and SequenciaPedido = 1 and CentroCusto = 22330
select NumeroPedido,SequenciaPedido,EspecieNotaFiscalPed,DataEmissaoNotaFiscalPed,NumeroNotaFiscalPed from tbPedido where NumeroPedido in (159978) and SequenciaPedido = 2 and CentroCusto = 22330
select * from tbDocumento where NumeroDocumento in (2825,62165) and NumeroPedidoDocumento in(159977,159978)

SELECT * FROM tbOS WHERE NumeroOROS = 183915

SELECT DataEmissaoNotaFiscalOS, NumeroNotaFiscalOS, * FROM tbOROSCIT WHERE NumeroOROS = 124818

select * from tbOROSCIT where NumeroOROS = 124818

--update tbOROSCIT set DataEmissaoNotaFiscalOS = '2017-09-18 14:43:00.000', DataEncerramentoOSCIT = '2017-09-18 14:43:00.000' where CodigoEmpresa = 2630 and CodigoLocal = 0 and NumeroOROS = 183915 and CodigoCIT = 'C1N'

--update tbOROSCIT set NumeroNotaFiscalOS = 144353 where CodigoEmpresa = 2630 and CodigoLocal = 0 and NumeroOROS = 183915 and CodigoCIT = 'C1N'

--select * from sysobjects where name like 'tb%OROSCIT%'

665905	2	NFE	2017-09-18 00:00:00.000	144353

