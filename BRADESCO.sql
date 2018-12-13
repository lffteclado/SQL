select * into tbEstruturaRelacaoBancaria21102018 from tbEstruturaRelacaoBancaria

SELECT * FROM dbo.tbEstruturaRelacaoBancaria  WHERE  CodigoBanco = 237

--insert into tbEstruturaRelacaoBancaria select * from [dbCardiesel].[dbo].tbEstruturaRelacaoBancaria where CodigoBanco = 237

SELECT * FROM sysobjects where name like 'tbEstrutura%'

SELECT * FROM dbo.tbEstruturaRelacaoBancaria (NOLOCK)
   WHERE  CodigoBanco = 237 AND TipoRegistroRB = 1 


select * from [dbVDL].[dbo].tbAux

--update [dbVDL].[dbo].tbAux set CodigoEmpresa = 2890

--insert into tbLayOutCobrancaEscritural select * from [dbVDL].[dbo].tbAux