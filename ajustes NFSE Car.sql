sp_helptext whNFeBH

select * from tbLocalLF

select * from tbDocumento where NumeroDocumento = 1553

select * from tbItemDocumento where NumeroDocumento = 1553 and EntradaSaidaDocumento = 'S' and DataDocumento = ' 2018-04-27 00:00:00.000'

select * from tbTipoServicoNFSE

select * from tbParametroNFSE

sp_helptext fnItensNFEletronicaBH

select * from sysobjects where name like 'tb%NF%'
--update tbItemDocumento set CodigoServicoISSItemDocto = '1401' where NumeroDocumento = 63828 and DataDocumento = '20180427'
SELEct CodigoNaturezaOperacao,CodigoServicoISSItemDocto, * from tbItemDocumento
where NumeroDocumento = 63834 and DataDocumento = '20180427'

select * from tbTipoServicoNFSE

