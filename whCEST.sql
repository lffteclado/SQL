IF EXISTS(SELECT 1 FROM sysobjects WHERE id = OBJECT_ID('dbo.whConsistirDadosItemPedido'))
	DROP PROCEDURE dbo.whConsistirDadosItemPedido

go
-- Encrypted text
go
GRANT EXECUTE ON dbo.whConsistirDadosItemPedido TO SQLUsers