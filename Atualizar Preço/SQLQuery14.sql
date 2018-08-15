select * from tbEmpresa 

select * from tbProduto where CodigoProduto COLLATE SQL_Latin1_General_CP1_CS_AS in (select Codigo from  [dbVDL].dbo.tempProdutoImportados)

select tbP.CodigoProduto,
	   tbP.DescricaoProduto,
	   tbP.CodigoClassificacaoFiscal,
	   tbPF.CondicaoIPIProduto,
	   tbPF.CondicaoICMSProduto,
	   tbPFCondicaoRedICMSProduto
from tbProduto tbP
inner join tbProdutoFT tbPF on
tbP.CodigoProduto = tbPF.CodigoProduto

select * from tbProdutoFT

select * from tbProdutoAuxiliar

select * from sysobjects where name like 'tb%Produto%'

