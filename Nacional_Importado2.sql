/*
============Atualiza��o====================
Autor: Lu�s Felipe Ferreira		
Data Altera��o: 25/05/2017
Motivo: O scrit foi alterado para buscar as informa��es da tabela tempProdutoImportados Base de Dados dbVDL
Data Altera��o: 09/08/2018
Motivo: Inclus�o do Campo "CodigoTributacaoProduto" pois o script n�o estava alterando esse campo deixando itens como importados sendo que n�o s�o.

*/

/*
Para o script funcionar � preciso criar a tabela abaixo na Base dbVDL que ser� alimentada pelo script gerado pelo Portal DTI
DELETE FROM [dbVDL].dbo.tempProdutoImportados
SELECT * FROM [dbVDL].dbo.tempProdutoImportados WHERE Tipo = 'F' and Codigo = 'A90613061150080'
CREATE TABLE tempProdutoImportados (
	Codigo VARCHAR(30),
	Tipo VARCHAR(10) -- O tipo de produto: G = Importado, F = Fabrica��o Propria e N = Nacional
)
*/


BEGIN TRANSACTION

SELECT CodigoEmpresa FROM tbEmpresa

UPDATE P
SET
      P.ProdutoImportado = CASE I.Tipo
            WHEN 'G' THEN 'V'
            WHEN 'N' THEN 'F'
            WHEN 'F' THEN 'F'
      END,
      P.ProdutoImportadoDireto = 'F',
      NacionalMaior40Import = CASE I.Tipo
            WHEN 'G' THEN 'F'
            ELSE NacionalMaior40Import
      END,
      NacionalAte40Import = CASE I.Tipo
            WHEN 'G' THEN 'F'
            ELSE NacionalMaior40Import
      END,
	  CodigoTributacaoProduto = CASE I.Tipo
            WHEN 'G' THEN 'F'
            ELSE NacionalMaior40Import
      END,
      SemSimilarNacional = CASE I.Tipo
            WHEN 'G' THEN 'F'
            ELSE NacionalMaior40Import
      END
FROM
      tbProdutoFT P
INNER JOIN
      --tempProdutoImportados I
      [dbVDL].dbo.tempProdutoImportados I
ON
      REPLACE(P.CodigoProduto,' ','') COLLATE SQL_Latin1_General_CP1_CS_AS = REPLACE(I.[Codigo],' ','')


UPDATE PA
SET
      PA.Importado = CASE I.Tipo
            WHEN 'G' THEN 'V'
            WHEN 'N' THEN 'F'
            WHEN 'F' THEN 'F'
     END
FROM
      tbProdutoAuxiliar PA
INNER JOIN
      --tempProdutoImportados I
      [dbVDL].dbo.tempProdutoImportados I
ON
      REPLACE(PA.CodigoProdutoAuxiliar,' ','') COLLATE SQL_Latin1_General_CP1_CS_AS = REPLACE(I.[Codigo],' ','')


COMMIT TRANSACTION


