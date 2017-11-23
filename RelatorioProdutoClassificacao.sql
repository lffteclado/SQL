--SELECT TOP 10 * FROM tbProdutoFT

--SELECT TOP 10 * FROM tbProduto

--SELECT TOP 10 * FROM tbClassificacaoFiscal

SELECT prodFT.CodigoProduto,
	   prod.DescricaoProduto,
	   prod.CodigoClassificacaoFiscal,
	   class.DescricaoClassificacaoFiscal,
	   class.CodigoNCM,
	   class.CodigoUnidadeDIPI,
	   class.CodFiscalOperacao AS 'COMPLEMENTO CFO',
	   class.CSTIPI AS 'IPI CST-SAIDAS',
	   class.CSTIPIEntradas AS 'IPI CST-ENTRADAS',
	   class.PercIPIClassificacaoFiscal AS 'PERCENTUAL IPI',
	   class.TributaPIS,
	   class.PercPIS,
	   class.TributaPISST,
	   class.CSTPIS,
	   class.CSTPISEntradas,
	   class.TributaCOFINS,
	   class.PercCOFINS,
	   class.TributaCOFINSST,
	   class.CSTCOFINS,
	   class.CSTCOFINSEntradas,
	   class.PisCofinsMonofasico,
	   class.NecessitaLI,
	   class.SemSimilarNacional,
	   class.NaturezaReceitaPISCOFINS,
	   class.PercPISImportacao,
	   class.PercCOFINSImportacao,
	   class.PercImpostoImportacao AS 'PIS CUSTO',
	   class.CSTICMSDentroEstadoEntradas AS 'COFINS CUSTO',
	   class.CSTICMSForaEstadoEntradas,
	   class.CodigoTributacaoForaEstado AS 'CODIGO ENQUADRAMENTO LEGAL DO IPI',
	   prodFT.TributaCOFINSProduto AS 'CEST'
FROM tbProdutoFT prodFT
INNER JOIN tbProduto prod
ON prodFT.CodigoProduto = prod.CodigoProduto
INNER JOIN tbClassificacaoFiscal class
ON prod.CodigoClassificacaoFiscal = class.CodigoClassificacaoFiscal