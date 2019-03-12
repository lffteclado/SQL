IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('sp_vdl_di'))
BEGIN
	DROP PROCEDURE dbo.sp_vdl_di
END
GO
CREATE PROCEDURE sp_vdl_di 
/*
* PROCEDURE CRIADA PARA LIMPAR OS PEDIDOS DIMS QUE NÃO ATUALIZAM AUTOMÁTICAMENTE NO CONTROLE ESTOQUE
* AUTOR: Luís Felipe Ferreira
* CHAMADO: 66512
* Data: 29/11/2017
* EXEC sp_vdl_di 1200, 0
*/
@CodigoEmpresa NUMERIC(4),
@CodigoLocal NUMERIC(2)

AS  
BEGIN TRANSACTION  
	IF (@CodigoEmpresa = 1200)--AutoSete
		BEGIN
			DELETE [dbAutosete].[dbo].tbEncomenda
			FROM [dbAutosete].[dbo].tbEncomenda tbE
			INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
			ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
			AND CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal
			COMMIT TRANSACTION
		END
	IF (@CodigoEmpresa = 262)--Calisto
		BEGIN
			DELETE [dbCalisto].[dbo].tbEncomenda
			FROM [dbCalisto].[dbo].tbEncomenda tbE
			INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
			ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
			AND CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal
			COMMIT TRANSACTION	
		END
	IF (@CodigoEmpresa = 930)--Cardiesel
		BEGIN
			DELETE [dbCardiesel_I].[dbo].tbEncomenda
			FROM [dbCardiesel_I].[dbo].tbEncomenda tbE
			INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
			ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
			AND CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal
			COMMIT TRANSACTION	
		END
	IF (@CodigoEmpresa = 2630)--Goias
		BEGIN
			DELETE [dbGoias].[dbo].tbEncomenda
			FROM [dbGoias].[dbo].tbEncomenda tbE
			INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
			ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
			AND CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal
			COMMIT TRANSACTION	
		END
	IF (@CodigoEmpresa = 2620)--Uberlandia
		BEGIN
			DELETE [dbUberlandia].[dbo].tbEncomenda
			FROM [dbUberlandia].[dbo].tbEncomenda tbE
			INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
			ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
			AND CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal
			COMMIT TRANSACTION	
		END
	IF (@CodigoEmpresa = 2890)--Posto Imperial
		BEGIN
			DELETE [dbPostoImperialDP].[dbo].tbEncomenda
			FROM [dbPostoImperialDP].[dbo].tbEncomenda tbE
			INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
			ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
			AND CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal
			COMMIT TRANSACTION	
		END
	IF (@CodigoEmpresa = 130)--Vadiesel
		BEGIN
			DELETE [dbVadiesel].[dbo].tbEncomenda
			FROM [dbVadiesel].[dbo].tbEncomenda tbE
			INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
			ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
			AND CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal
			COMMIT TRANSACTION	
		END
	IF (@CodigoEmpresa = 260)--Valadares
		BEGIN
			DELETE [dbValadaresCNV].[dbo].tbEncomenda
			FROM [dbValadaresCNV].[dbo].tbEncomenda tbE
			INNER JOIN [dbVDL].[dbo].tempPedidoDIM tbD
			ON REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			WHERE REPLACE(tbE.CodigoProduto,' ','') = REPLACE(tbD.Codigo,' ','') collate Latin1_General_CS_AS
			AND tbE.NumeroDocumentoEncomenda = tbD.NumeroEncomenda collate Latin1_General_CS_AS
			AND CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal
			COMMIT TRANSACTION	
		END
DELETE FROM [dbVDL].[dbo].tempPedidoDIM