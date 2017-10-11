IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('sp_AcertoPrecoRecompraVDL'))
BEGIN
	DROP PROCEDURE dbo.sp_AcertoPrecoRecompraVDL
END
GO
CREATE PROCEDURE dbo.sp_AcertoPrecoRecompraVDL
/*
* Data: 04/10/2017
* Criado por: Marcos Moraes
* Modificado por: Luís Felipe
* Procedure criada para alterar os preços dos Pedidos de Recompra Telemarketing e Faturamento
* Primeiro é preciso importar a Planilha com os itens na tabela tbPedidoAutorizado no banco dbVDL
*/
	AS
	BEGIN TRANSACTION
	UPDATE tbIP 
		SET tbIP.PrecoUnitarioItemPed = tbPA.PrecoUnitarioItemPed
			FROM tbItemPedido tbIP 
			INNER JOIN tbPedido tbP
				ON 	tbIP.CodigoLocal = tbP.CodigoLocal
				AND tbIP.CentroCusto = tbP.CentroCusto
				AND tbIP.NumeroPedido = tbP.NumeroPedido
			INNER JOIN [dbVDL].[dbo].tbPedidoAutorizado tbPA 
				ON tbIP.CodigoEmpresa = tbPA.CodigoEmpresa
				AND	tbIP.CodigoLocal = tbPA.CodigoLocal 
				AND tbIP.NumeroPedido = tbPA.NumeroPedido 
				AND tbIP.CentroCusto = tbPA.CentroCusto 
				AND REPLACE(tbIP.CodigoProduto,' ', '') = REPLACE(tbPA.CodigoProduto,' ','') COLLATE SQL_Latin1_General_CP1_CS_AS
			INNER JOIN [dbVDL].[dbo].tbClienteAutorizado tbCA 
				ON tbCA.CodigoCliFor = tbPA.CodigoCliFor
			INNER JOIN tbPedidoVenda tbPV 
				ON tbPV.NumeroPedido = tbPA.NumeroPedido
				AND tbPV.CentroCusto = tbPA.CentroCusto
				AND tbPV.CodigoCliForPedVda = tbPA.CodigoCliFor
				AND tbPV.CodigoCliForFat = tbPA.CodigoCliFor
			WHERE tbP.StatusPedidoPed = 1
COMMIT TRANSACTION
DELETE FROM [dbVDL].[dbo].tbPedidoAutorizado