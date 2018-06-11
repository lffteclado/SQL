select * from sysobjects where name like 'tb%TipoDocumento%'

select CaracteristicaTipoDocto, CodigoTipoDocumento, DescricaoTipoDocumento from tbTipoDocumento where CaracteristicaTipoDocto = 'CP'