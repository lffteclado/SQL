--Verificar Status OS, NF emitidas e outras informa��es refrentes a OS.
select * from tbOROSCIT where NumeroOROS = 11429 and CodigoCIT = 'I5UE' and CodigoLocal = 1
union all
select * from tbOROSCIT where NumeroOROS = 185335 

--update tbOROSCIT set DataEmissaoNotaFiscalOS = DataEncerramentoOSCIT where NumeroOROS = 11429 and CodigoCIT = 'I5UE' and CodigoLocal = 1

select * from tbPedidoOS where CodigoOrdemServicoPedidoOS = 96073
select NumeroPedido,SequenciaPedido,EspecieNotaFiscalPed,DataEmissaoNotaFiscalPed,NumeroNotaFiscalPed from tbPedido where NumeroPedido in (80767) and SequenciaPedido in (1,2) and CentroCusto = 21330
select NumeroPedido,SequenciaPedido,EspecieNotaFiscalPed,DataEmissaoNotaFiscalPed,NumeroNotaFiscalPed from tbPedido where NumeroPedido in (517987) and SequenciaPedido = 1 and CentroCusto = 22330
select * from tbDocumento where NumeroDocumento in (936910) and NumeroPedidoDocumento in(170302, 170303)

select * from tbDocumento where NumeroDocumento = 4770 and CodigoLocal = 1

select * from tbPedido where NumeroPedido in (936910) and OrigemPedido = 'OS' 

SELECT * FROM tbOS WHERE CodigoEmpresa = 3140 and CodigoLocal = 0 and NumeroOROS = 164660
union all
SELECT * FROM tbOS WHERE CodigoEmpresa = 930 and CodigoLocal = 0 and NumeroOROS = 304137

SELECT * FROM tbOROSCIT WHERE CodigoEmpresa = 2890 and CodigoLocal = 0 and NumeroOROS = 96073

--update tbOROSCIT set DataEmissaoNotaFiscalOS = '2018-05-02 16:15:00.000' WHERE CodigoEmpresa = 2630 and CodigoLocal = 0 and NumeroOROS = 186395 and CodigoCIT = 'C1N'
--update tbOROSCIT set DataEncerramentoOSCIT = '2018-05-02 16:15:00.000' WHERE CodigoEmpresa = 2630 and CodigoLocal = 0 and NumeroOROS = 186395 and CodigoCIT = 'C1N'

--update tbOS set StatusOS = 'N' WHERE CodigoEmpresa = 930 and CodigoLocal = 0 and NumeroOROS = 304137

/* Liberar OS encerrada para transferencia entre itens

alter table tbOROSCIT disable trigger tnu_DSPa_StatusOSCIT

update tbOROSCIT set StatusOSCIT = 'A' where CodigoEmpresa = 2890 and CodigoLocal = 0 and NumeroOROS = 96073 and CodigoCIT = 'I3'

alter table tbOROSCIT enable trigger tnu_DSPa_StatusOSCIT

*/

/*Bloquear OS encerrada ap�s a transferencia entre itens

alter table tbOROSCIT disable trigger tnu_DSPa_StatusOSCIT

update tbOROSCIT set StatusOSCIT = 'N' where CodigoEmpresa = 2630 and CodigoLocal = 0 and NumeroOROS = 186443 and CodigoCIT = 'C1N'

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



--update tbOROSCIT set DataEmissaoNotaFiscalOS = '2017-05-04 09:39:00.000' where CodigoEmpresa = 930 and CodigoLocal = 0 and NumeroOROS = '299660' and CodigoCIT = 'I5T' and FlagOROS = 'S'

--update tbOROSCIT set DataEncerramentoOSCIT = '2017-07-04 15:53:00.000' where CodigoEmpresa = 2630 and CodigoLocal = 0 and NumeroOROS = '183255' and CodigoCIT = 'C1N' and FlagOROS = 'S'


DataEncerramentoOSCIT

DataEmissaoNotaFiscalOS
