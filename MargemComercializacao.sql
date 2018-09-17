select * from [dbVDL].[dbo].ControleERP where ModuloAcessa like  '%CS%' order by ID desc 
--update ControleERP set ModuloAcessa = "" where ID = and Empresa = ""

select * from sysobjects where name like 'tbMarge%'

select * into tbMargemComercializacaoBKP07122017 from tbMargemComercializacao

select * from tbMargemComercializacao
where CodigoMargemComercializacao in ('M02','M06')
AND CodigoEmpresa = 930

update tbMargemComercializacao
set IndiceMargemComercializacao = 2.09, IndiceMargemComercializacaoImportado = 2.31
where CodigoEmpresa = 3140

