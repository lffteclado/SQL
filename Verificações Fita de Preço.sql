-- select * from sysobjects where name like '%tbTabelaPreco%'
-- select * from sysobjects where name like '%tempItemForaTabela%'
-- drop table tbTabelaPreco05102017  ( Avaliar se necess�rio _)
-- drop table tempItemForaTabela ( Avaliar se necess�rio _)
-- select * into tbTabelaPreco07112017 from tbTabelaPreco
-- create table tempItemForaTabela(CodPro varchar(50) not null, CodPreco money,CodAlt varchar(1));
-- select * from tbEmpresa

-- select * from tempItemForaTabela where CodAlt is null
-- select sum (CodPreco) from tempItemForaTabela where CodAlt is null

-- select sum(ValorTabelaPreco) from tbTabelaPreco as tbP where exists (select CodPro from tempItemForaTabela as tbIP where tbP.CodigoProduto = tbIP.CodPro and tbIP.CodAlt = 'A' and tbP.ValorTabelaPreco = tbIP.CodPreco ) and DataValidadeTabelaPreco = '2017-11-07'