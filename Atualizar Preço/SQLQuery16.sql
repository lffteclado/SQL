/*
Para o script funcionar foi criada a tabela abaixo e importado os registro de uma planilha excel enviada pelo Glayson Gomes
CREATE TABLE tempProdutoImportados (
	Letra VARCHAR(10), --A letra inicial do produto
	Codigo VARCHAR(30),--O codigo que deve ser concatenado com a letra
	Tipo VARCHAR(10) -- O tipo de produto: G = Importado, F = Fabricação Propria e N = Nacional
)
*/

select * from tempProdutoImportados where Codigo = 'X0140591679147'

sp_spaceused tbProdutoFT

--drop table tempProdutoImportados