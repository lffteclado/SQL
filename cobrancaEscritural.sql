select * from sysobjects where name like 'tb%Lay%'

--select * into tbAuxCE from dbRedeMineira.dbo.tbLayOutCobrancaEscritural where CodigoBanco = 637 and TipoArquivoOcorDoctoRecPag = 1
--select * into tbAuxCE from tbLayOutCobrancaEscritural where CodigoBanco = 1025 and TipoArquivoOcorDoctoRecPag = 2


select * from tbLayOutCobrancaEscritural where CodigoBanco = 637 and TipoRegistroLayOut = 2

select * from tbLayOutCobrancaEscritural where CodigoBanco = 637 and TipoArquivoOcorDoctoRecPag = 1

select  * from tbDoctoRecPag order by DataDocumento desc

select * from dbVDL.dbo.tbAux where TipoArquivoOcorDoctoRecPag = 1

select * from dbVDL.dbo.tbAuxCE

--drop table tbAuxCE

--update dbVDL.dbo.tbAuxCE set CodigoEmpresa = 930

--update dbVDL.dbo.tbAux set CodigoBanco = 637

--delete from tbLayOutCobrancaEscritural where CodigoEmpresa = 930 and CodigoBanco = 637 and TipoArquivoOcorDoctoRecPag = 1

--select * into tbLayOutCobrancaEscrituralBKP25022019 from tbLayOutCobrancaEscritural

--insert into tbLayOutCobrancaEscritural select * from dbCardieselTeste.dbo.tbLayOutCobrancaEscritural where CodigoBanco = 637 and TipoArquivoOcorDoctoRecPag = 1

select * from tbLocal
