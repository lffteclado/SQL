select * from tbEvento
select * from tbEventoBaseCalculo
select * from tbEventoIndividual
select * from tbTermoRescisaoEvento

select * from tbProdutoFT where CodigoFonteFornecimento = 1

select * from tbProdutoFTBKP72726 where CodigoFonteFornecimento = 5

select * into tbProdutoFTBKP72726 from tbProdutoFT

select * from sysobjects where name like '%tbProdutoFT%'