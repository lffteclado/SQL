select * from sysobjects where name like 'tb%TipoDocumento%'
tbTipoDocumento
tbTipoDocumentoComplementar

select * from tbTipoDocumento where CaracteristicaTipoDocto = '50' and CaracteristicaTipoDocto = 'CR'

select * from tbTipoDocumento where CodigoTipoDocumento = '32' and CaracteristicaTipoDocto = 'CR'

select * from tbTipoDocumentoComplementar where CaracteristicaTipoDocto = 'CR'  and  CodigoTipoDocumento = '50'

SELECT tbD.DescricaoTipoDocumento AS TipoDocumento,
	   tbC.AbreviaturaTipoDocto AS Abreviatura,
	   tbD.CaracteristicaTipoDocto AS Origem,
	   tbD.CodigoTipoDocumento AS Codigo
FROM tbTipoDocumento tbD
INNER JOIN tbTipoDocumentoComplementar tbC
ON tbD.CodigoTipoDocumento = tbC.CodigoTipoDocumento
WHERE tbD.CaracteristicaTipoDocto = 'CR' or tbD.CaracteristicaTipoDocto = 'CP'

SELECT AbreviaturaTipoDocto AS Abreviatura,
	   CaracteristicaTipoDocto AS Origem,
	   CodigoTipoDocumento AS Codigo
FROM tbTipoDocumentoComplementar
WHERE CaracteristicaTipoDocto = 'CR' or CaracteristicaTipoDocto = 'CP'
