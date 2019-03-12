select * from tbProdutoFT where CodigoLinhaProduto = 20

select * from sysobjects where name like 'tb%Patri%'

select * from tbItemPatrimonial

select * from tbLinhaProduto where AbreviaturaLinhaProduto like '%ESC%'

sp_helptext whRelCEMobilidadeEstoque

--exec dbCardiesel.dbo.whRelCEMobilidadeEstoque 930,0,'2','20171101','20171120',0,100.00,1,1,'F','F',1,1

--exec dbCardiesel.dbo.whRelCEMobilidadeEstoque 930,0,'2','20170101','20171120',0,100.00,1,9996,'F','F',1,6

--Ativos 8410
select distinct CodigoProduto from tbRegistroMovtoEstoque
where DataMovtoEstoque > '2017-11-20'

--Inativos 22026
select distinct CodigoProduto from tbRegistroMovtoEstoque where CodigoProduto not in (select distinct CodigoProduto from tbRegistroMovtoEstoque
where DataMovtoEstoque > '2017-11-20')

select distinct CodigoProduto from tbRegistroMovtoEstoque

select * from tbRegistroMovtoEstoque where CodigoProduto = 'A3825287982'