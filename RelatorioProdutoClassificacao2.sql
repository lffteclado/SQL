--CREATE TABLE tempProdutoFita (
--	Codigo VARCHAR(30),
--	Classificacao VARCHAR(10) -- O tipo de produto: G = Importado, F = Fabricação Propria e N = Nacional
--)

--SELECT TOP 10 * FROM tbProdutoFT

--SELECT TOP 10 * FROM tbProduto

--SELECT TOP 10 * FROM tbClassificacaoFiscal

--select * from tempProdutoFita

SELECT prodFT.CodigoProduto,
       prod.CodigoClassificacaoFiscal,
	   fita.Classificacao AS 'Classificação Fita'
FROM tbProdutoFT prodFT
INNER JOIN tbProduto prod
ON prodFT.CodigoProduto = prod.CodigoProduto
INNER JOIN tempProdutoFita fita
ON REPLACE(prodFT.CodigoProduto, ' ','') = REPLACE(fita.Codigo, ' ', '')