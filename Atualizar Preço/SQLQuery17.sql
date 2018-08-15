


--select * into tbProdutoFT23052017 from tbProdutoFT

SELECT * FROM tbProduto where CodigoProduto = 'X014059167       9147'
union all
SELECT CodigoProduto, ProdutoImportado, ProdutoImportadoDireto, NacionalAte40Import, NacionalMaior40Import, CodigoTributacaoProduto FROM tbProdutoFT23052017


--select * into tbProdutoAuxiliar23052017 from tbProdutoAuxiliar

SELECT * FROM tbProdutoAuxiliar WHERE Importado = 'F'

SELECT CodigoProdutoAuxiliar, Importado FROM tbProdutoAuxiliar23052017 WHERE Importado = 'V' or Importado = 'F'