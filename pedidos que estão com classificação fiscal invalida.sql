--Para identificar os pedidos que estão com classificação fiscal invalida ( sem cadastro )

declare @Ped INT
declare @CC INT
set @Ped = < numero do pedido >
set @CC = < centro de custo >
select distinct(tbIP.CodigoProduto),
	  tbCF.CodigoClassificacaoFiscal,
	  tbCF.DescricaoClassificacaoFiscal
	   from tbItemPedido tbIP 
		inner join tbProduto tbP on
		tbP.CodigoProduto = tbIP.CodigoProduto 
		inner join tbClassificacaoFiscal tbCF on
		tbCF.CodigoClassificacaoFiscal = tbP.CodigoClassificacaoFiscal
where tbIP.NumeroPedido = @Ped and 
	  tbIP.CentroCusto = @CC
