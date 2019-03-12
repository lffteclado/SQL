select * from sysobjects where name like 'tb%Autorizado%'

--exec sp_AcertoPrecoRecompraVDL

select * from tbPedidoAutorizado

153980000596

select * from tbClienteAutorizado where CodigoCliFor = '153980000596'

--insert into tbClienteAutorizado (CodigoCliFor, NomeAbrev) values ('153980000596', 'Ap Goiania')

--insert into tbPedidoAutorizado select * from tbPedidoAutorizado$