select * from sysobjects where name like 'tb%Lay%'

--select * into tbAux from dbUberlandia.dbo.tbLayOutCobrancaEscritural where CodigoBanco = 341 and TipoArquivoOcorDoctoRecPag = 1
--select * into tbAux from tbLayOutCobrancaEscritural where CodigoBanco = 1025 and TipoArquivoOcorDoctoRecPag = 2


select * from dbCardiesel_I.dbo.tbLayOutCobrancaEscritural where CodigoBanco = 784

select * from tbLayOutCobrancaEscritural where CodigoBanco = 341 and TipoArquivoOcorDoctoRecPag = 1

select  * from tbDoctoRecPag order by DataDocumento desc

select * from dbVDL.dbo.tbAux where TipoArquivoOcorDoctoRecPag = 1

select * from tbAux

--drop table tbAux

--update tbAux set CodigoEmpresa = 130

--delete from tbLayOutCobrancaEscritural where CodigoEmpresa = 3610 CodigoBanco = 1025 and TipoArquivoOcorDoctoRecPag = 2

--select * into tbLayOutCobrancaEscritural_BKP10102017 from tbLayOutCobrancaEscritural

--insert into tbLayOutCobrancaEscritural select * from dbVDL.dbo.tbAux

select * from tbLocal
