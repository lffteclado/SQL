IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('sp_BloqueiaDescMinimo'))
BEGIN
	DROP PROCEDURE dbo.sp_BloqueiaDescMinimo
END
GO
CREATE PROCEDURE  dbo.sp_BloqueiaDescMinimo
/*
* PROCEDURE CRIADA PARA BLOQUER E DESBLOQUEAR DESCONTO MINIMO
* AUTOR: Luís Felipe Ferreira
* Data: 08/09/2017
* EXEC sp_BloqueiaDescMinimo 930, 0, 'F', '51,00'
*/

@CodigoEmpresa numeric(4),
@CodigoLocal numeric(1),
@Bloqueado char(1),
@ValorMin char(5)

AS
BEGIN
 IF (@CodigoEmpresa = 3140 and @CodigoLocal = 0)--Montes Claros
 BEGIN
	UPDATE dbMontesClaros.dbo.tbLocalFT
	SET DescontoMinimoPedido = @Bloqueado, ValorMinimoDesconto = @ValorMin
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END
 IF (@CodigoEmpresa = 3610 and @CodigoLocal = 0)--Rede Mineira
 BEGIN
	UPDATE dbRedeMineira.dbo.tbLocalFT
	SET DescontoMinimoPedido = @Bloqueado, ValorMinimoDesconto = @ValorMin
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END
END
GO
