--Verificar Status OS, NF emitidas e outras informações refrentes a OS.
select * from tbOROSCIT where NumeroOROS = 99045

select * from tbOROSCIT where NumeroOROS = 184495


select * from tbPedidoOS where CodigoOrdemServicoPedidoOS = 184495
select NumeroPedido,SequenciaPedido,EspecieNotaFiscalPed,DataEmissaoNotaFiscalPed,NumeroNotaFiscalPed from tbPedido where NumeroPedido in (666834) and SequenciaPedido in (1) and CentroCusto = 21330
select NumeroPedido,SequenciaPedido,EspecieNotaFiscalPed,DataEmissaoNotaFiscalPed,NumeroNotaFiscalPed from tbPedido where NumeroPedido in (170303) and SequenciaPedido = 2 and CentroCusto = 21330
select * from tbDocumento where NumeroDocumento in (62206, 2837) and NumeroPedidoDocumento in(170302, 170303)

select * from tbDocumento where NumeroDocumento = 4770 and CodigoLocal = 1

select * from tbPedido where NumeroPedido in (516281) and OrigemPedido = 'OS'

SELECT * FROM tbOS WHERE CodigoEmpresa = 2630 and CodigoLocal = 0 and NumeroOROS = 184812

SELECT * FROM tbOROSCIT WHERE CodigoEmpresa = 2630 and CodigoLocal = 0 and NumeroOROS = 184812

--update tbOROSCIT set DataEmissaoNotaFiscalOS = '2017-12-18 17:39:00.000' WHERE CodigoEmpresa = 2630 and CodigoLocal = 0 and NumeroOROS = 184812 and CodigoCIT = 'C1N'

--update tbOS set StatusOS = 'A' WHERE CodigoEmpresa = 130 and CodigoLocal = 0 and NumeroOROS = 99045

/* Liberar OS encerrada para transferencia entre itens

alter table tbOROSCIT disable trigger tnu_DSPa_StatusOSCIT

update tbOROSCIT set StatusOSCIT = 'U' where CodigoEmpresa = 130 and CodigoLocal = 0 and NumeroOROS = 99045 and CodigoCIT = 'CT'

alter table tbOROSCIT enable trigger tnu_DSPa_StatusOSCIT

*/

/*Bloquear OS encerrada para transferencia entre itens

alter table tbOROSCIT disable trigger tnu_DSPa_StatusOSCIT

update tbOROSCIT set StatusOSCIT = 'N' where CodigoEmpresa = 2630 and CodigoLocal = 0 and NumeroOROS = 184495 and CodigoCIT = 'C1N'

alter table tbOROSCIT enable trigger tnu_DSPa_StatusOSCIT

*/


SELECT DataEmissaoNotaFiscalOS, NumeroNotaFiscalOS, * FROM tbOROSCIT WHERE NumeroOROS = 10853

select * from tbOROSCIT where NumeroOROS = 11102

select * from sysobjects where name like 'tb%Ped%'
select * from tbPedidoPecasProdOROS where NumeroOROS = 183548
select * from tbPedido where NumeroPedido = 26438

--update tbOROSCIT set DataEmissaoNotaFiscalOS = '2017-08-11 13:56:00.000' where CodigoEmpresa = 2630 and CodigoLocal = 0 and NumeroOROS = 183573 and CodigoCIT = 'C1U'

--update tbOROSCIT set NumeroNotaFiscalOS = 143059 where CodigoEmpresa = 2630 and CodigoLocal = 0 and NumeroOROS = 183573 and CodigoCIT = 'C1U'

--select * from sysobjects where name like 'tb%OROSCIT%'



--update tbOROSCIT set DataEmissaoNotaFiscalOS = '2017-07-26 09:39:00.000' where CodigoEmpresa = 930 and CodigoLocal = 0 and NumeroOROS = '299660' and CodigoCIT = 'I5T' and FlagOROS = 'S'

--update tbOROSCIT set DataEncerramentoOSCIT = '2017-07-04 15:53:00.000' where CodigoEmpresa = 2630 and CodigoLocal = 0 and NumeroOROS = '183255' and CodigoCIT = 'C1N' and FlagOROS = 'S'


DataEncerramentoOSCIT

DataEmissaoNotaFiscalOS
