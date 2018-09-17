--select * from sysobjects where name  like 'tb%Cargo%'

select CodigoEmpresa, CodigoLocal, CodigoCargo, DescricaoCargo, CBO, CodigoCategoriaESocial from tbCargo where CodigoLocal = 0