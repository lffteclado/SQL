select * from sysobjects where name like 'tb%TipoDocumento%'

select top 10 * from tbTipoDocumentoComplementar where CaracteristicaTipoDocto = 'CR'

select top 1 * from tbDocumento

select top 10 * from tbTipoDocumento where CaracteristicaTipoDocto = 'CR'

select tc.AbreviaturaTipoDocto,
       tc.CodigoTipoDocumento, 
       tc.CaracteristicaTipoDocto,
	   td.DescricaoTipoDocumento	   
from tbTipoDocumento td
inner join tbTipoDocumentoComplementar tc
on td.CodigoTipoDocumento = tc.CodigoTipoDocumento

where tc.CaracteristicaTipoDocto = 'CR'


