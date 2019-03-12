select * from tbDocumento where NumeroDocumento in (1869) and CodigoLocal = 2 and DataDocumento > = '20190201' and CodigoCliFor = '59104273000129'
select * from tbDocumentoRPS where NumeroDocumento in (1869) and CodigoLocal = 2 and DataDocumento > = '20190201' and CodigoCliFor = '59104273000129'

select * from tbOS where CodigoEmpresa = 2620 and CodigoLocal = 2 and NumeroOROS = 3114

select * from tbOROSCIT where NumeroOROS = 3114 and CodigoEmpresa = 2620 and CodigoLocal = 2

select * from tbPedidoOS where CodigoOrdemServicoPedidoOS = '3114'  and CodigoEmpresa = 2620 and CodigoLocal = 2

select NumeroPedido,SequenciaPedido,EspecieNotaFiscalPed,DataEmissaoNotaFiscalPed,NumeroNotaFiscalPed
 from tbPedido where NumeroPedido in (4926,4927) and SequenciaPedido in (1,2) and CentroCusto = 21330

select * from update tbPedido set NumeroNotaFiscalPed = 1852 where NumeroPedido = 4926 and SequenciaPedido = 1 and DataEmissaoNotaFiscalPed = '2019-02-12 00:00:00.000'

select * from tbDocumentoRPS where CodigoLocal = 2 and DataDocumento > = '20190201'

select * from update tbDocumentoRPS SET NumeroNFE = 0 where NumeroDocumento in (1872) and CodigoLocal = 2 and DataDocumento > = '20190213' and CodigoCliFor = '59104273000129'


--select * from  tbDocumentoRPS set NumeroNFE = 99 where NumeroDocumento in (1871,1872,1873) and CodigoLocal = 2 and DataDocumento > = '20190201' 

/*
alter table tbDocumento disable trigger  tni_DSPa_Documento
go
whAChavesDocumento  2620,2,'S',1873,'2019-02-13 00:00:00.000',59104273000129,7,
 2620,2,'S',1872,'2019-02-13 00:00:00.000',59104273000129,7
 go
 alter table tbDocumento enable trigger  tni_DSPa_Documento
 go
 whPesquisaTrigger
 */