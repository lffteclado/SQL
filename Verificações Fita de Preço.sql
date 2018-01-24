-- select * from sysobjects where name like '%tbTabelaPreco%'
-- select * from sysobjects where name like '%tempItemForaTabela%'
-- drop table tbTabelaPreco08122017  ( Avaliar se necessário _)
-- drop table tempItemForaTabela ( Avaliar se necessário _)
-- select * into tbTabelaPreco05012018 from tbTabelaPreco
-- create table tempItemForaTabela(CodPro varchar(50) not null, CodPreco money,CodAlt varchar(1));
-- select * from tbEmpresa

-- select * from tempItemForaTabela where CodAlt is null
-- select sum (CodPreco) from tempItemForaTabela where CodAlt is null

-- select sum(ValorTabelaPreco) from tbTabelaPreco as tbP where exists (select CodPro from tempItemForaTabela as tbIP where tbP.CodigoProduto = tbIP.CodPro and tbIP.CodAlt = 'A' and tbP.ValorTabelaPreco = tbIP.CodPreco ) and DataValidadeTabelaPreco = '2018-01-05'