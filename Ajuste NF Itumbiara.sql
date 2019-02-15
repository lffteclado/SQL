select * from tbDocumento where NumeroDocumento in (1868) and CodigoLocal = 2 and DataDocumento > = '20190201' and CodigoCliFor = '59104273000129'
select * from tbDocumentoRPS where NumeroDocumento in (1866, 1870) and CodigoLocal = 2 and DataDocumento > = '20190201' and CodigoCliFor = '59104273000129'

select * from tbDocumentoRPS where CodigoLocal = 2 and DataDocumento > = '20190201'

select * from update tbDocumentoRPS SET NumeroNFE = 0 where NumeroDocumento in (1869) and CodigoLocal = 2 and DataDocumento > = '20190201' and CodigoCliFor = '59104273000129'


--select * from  tbDocumentoRPS set NumeroNFE = 99 where NumeroDocumento in (1871,1872,1873) and CodigoLocal = 2 and DataDocumento > = '20190201' 

/*
alter table tbDocumento disable trigger  tni_DSPa_Documento
go
whAChavesDocumento  2620,2,'S',1868,'2019-02-11 00:00:00.000',59104273000129,7,
 2620,2,'S',1869,'2019-02-11 00:00:00.000',59104273000129,7
 go
 alter table tbDocumento enable trigger  tni_DSPa_Documento
 go
 whPesquisaTrigger
 */