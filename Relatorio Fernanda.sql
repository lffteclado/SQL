--select CodigoProduto from tbProdutoFT where CodigoFonteFornecimento = 6 and CodigoLinhaProduto = 6

--select * from sysobjects where name like 'tb%Aux%'

--SELECT CodigoProduto,
--	   ValorTabelaPreco,
--	   DataValidadeTabelaPreco
--INTO tbAux FROM dbUberlandia.dbo.tbTabelaPreco
--WHERE CodigoProduto
--IN (select distinct CodigoProduto from dbUberlandia.dbo.tbProdutoFT where CodigoFonteFornecimento = 6 and CodigoLinhaProduto = 6)
--AND CodigoTipoTabelaPreco in (3,103)

SELECT CodigoProduto AS 'CODIGO PRODUTO',
	   MAX(DataValidadeTabelaPreco) AS 'DATA PREÇO'
	   FROM tbAux GROUP BY CodigoProduto ORDER BY CodigoProduto

--SELECT CodigoProduto AS 'CODIGOPRODUTO',
--	   MAX(DataValidadeTabelaPreco) AS 'DATAPRECO' INTO tbAux2
--FROM tbAux GROUP BY CodigoProduto ORDER BY CodigoProduto

select * from tbAux2 where CodigoProduto in (select CODIGOPRODUTO from tbAux2) and DataValidadeTabelaPreco in (select DATAPRECO from tbAux2)

select CODIGOPRODUTO,
	   RTRIM(LTRIM(convert (varchar(10),DATAPRECO,103))) AS 'DATA PREÇO'
from tbAux2

select * from tbAux where CodigoProduto = 'A0009890401' order by DataValidadeTabelaPreco desc 2017-01-10 00:00:00.000

select * from tbAux where CodigoProduto = 'A0009892803' order by DataValidadeTabelaPreco desc 2016-12-22 00:00:00.000

select * from dbUberlandia.dbo.tbTabelaPreco where CodigoProduto = 'A0049890420    0020' order by DataValidadeTabelaPreco desc

select * from tbAux where CodigoProduto = 'C0240111' order by DataValidadeTabelaPreco desc 2015-04-17 00:00:00.000


SELECT DISTINCT CodigoProduto FROM tbAux

SELECT DISTINCT CodigoProduto FROM dbUberlandia.dbo.tbTabelaPreco WHERE CodigoTipoTabelaPreco in (3,103) AND  CodigoProduto
IN (select DISTINCT CodigoProduto from dbUberlandia.dbo.tbProdutoFT where CodigoLinhaProduto = 6)

select DISTINCT CodigoProduto from dbUberlandia.dbo.tbProdutoFT where CodigoLinhaProduto = 6

select CodigoProduto from dbUberlandia.dbo.tbProdutoFT where CodigoFonteFornecimento = 6 and CodigoLinhaProduto = 6

SELECT CodigoProduto AS 'CODIGO PRODUTO',
	   ValorTabelaPreco AS 'PREÇO',
	   MAX(RTRIM(LTRIM(convert (varchar(10),DataValidadeTabelaPreco,103)))) AS 'DATA PREÇO'
	   --DataValidadeTabelaPreco AS 'DATA PREÇO'
FROM  dbUberlandia.dbo.tbTabelaPreco
WHERE CodigoProduto
IN (select DISTINCT CodigoProduto from dbUberlandia.dbo.tbProdutoFT where CodigoFonteFornecimento = 6 and CodigoLinhaProduto = 6)
AND CodigoTipoTabelaPreco NOT IN (1,101)
--AND DataValidadeTabelaPreco BETWEEN '2017-01-01' AND '2017-10-31'

