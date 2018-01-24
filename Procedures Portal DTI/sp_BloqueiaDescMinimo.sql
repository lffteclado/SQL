IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('sp_BloqueiaDescMinimo'))
BEGIN
	DROP PROCEDURE dbo.sp_BloqueiaDescMinimo
END
GO
CREATE PROCEDURE  dbo.sp_BloqueiaDescMinimo
/*
* PROCEDURE CRIADA PARA BLOQUER E DESBLOQUEAR DESCONTO MINIMO
* AUTOR: Lu�s Felipe Ferreira
* DATA: 08/09/2017
* EXEC sp_BloqueiaDescMinimo 930, 0, 'F', '51,00'
* ATUALIZA��O: 02/01/2018
* MOTIVO: MIGRA��O NOVO SERVIDOR 0.60
* AUTOR: LU�S FELIPE
*/

@CodigoEmpresa numeric(4),
@CodigoLocal numeric(1),
@Bloqueado char(1),
@ValorMin char(5)

AS
BEGIN
 IF (@CodigoEmpresa = 1200)--Autosete
 BEGIN
	UPDATE dbAutosete.dbo.tbLocalFT
	SET DescontoMinimoPedido = @Bloqueado, ValorMinimoDesconto = @ValorMin
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END
 IF (@CodigoEmpresa = 262)--Calisto
 BEGIN
	UPDATE dbCalisto.dbo.tbLocalFT
	SET DescontoMinimoPedido = @Bloqueado, ValorMinimoDesconto = @ValorMin
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END
 IF (@CodigoEmpresa = 930)--Cardiesel
 BEGIN
	UPDATE dbCardiesel.dbo.tbLocalFT
	SET DescontoMinimoPedido = @Bloqueado, ValorMinimoDesconto = @ValorMin
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END
 IF (@CodigoEmpresa = 2630)--Goias
 BEGIN
	UPDATE dbGoias.dbo.tbLocalFT
	SET DescontoMinimoPedido = @Bloqueado, ValorMinimoDesconto = @ValorMin
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END
 IF (@CodigoEmpresa = 2890)--Posto Imperial
 BEGIN
	UPDATE dbPostoImperial.dbo.tbLocalFT
	SET DescontoMinimoPedido = @Bloqueado, ValorMinimoDesconto = @ValorMin
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END
 IF (@CodigoEmpresa = 2620)--Uberlandia
 BEGIN
	UPDATE dbUberlandia.dbo.tbLocalFT
	SET DescontoMinimoPedido = @Bloqueado, ValorMinimoDesconto = @ValorMin
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END
 --IF (@CodigoEmpresa = 130)--Vadiesel
 --BEGIN
	--UPDATE dbVadiesel.dbo.tbLocalFT
	--SET DescontoMinimoPedido = @Bloqueado, ValorMinimoDesconto = @ValorMin
	--WHERE CodigoEmpresa = @CodigoEmpresa
	--AND CodigoLocal = @CodigoLocal
 --END
 --IF (@CodigoEmpresa = 260)--Valadares
 --BEGIN
	--UPDATE dbValadares.dbo.tbLocalFT
	--SET DescontoMinimoPedido = @Bloqueado, ValorMinimoDesconto = @ValorMin
	--WHERE CodigoEmpresa = @CodigoEmpresa
	--AND CodigoLocal = @CodigoLocal
 --END
 --IF (@CodigoEmpresa = 3140 and @CodigoLocal = 0)--Montes Claros
 --BEGIN
	--UPDATE dbMontesClaros.dbo.tbLocalFT
	--SET DescontoMinimoPedido = @Bloqueado, ValorMinimoDesconto = @ValorMin
	--WHERE CodigoEmpresa = @CodigoEmpresa
	--AND CodigoLocal = @CodigoLocal
 --END
 --IF (@CodigoEmpresa = 3610 and @CodigoLocal = 0)--Rede Mineira
 --BEGIN
	--UPDATE dbRedeMineira.dbo.tbLocalFT
	--SET DescontoMinimoPedido = @Bloqueado, ValorMinimoDesconto = @ValorMin
	--WHERE CodigoEmpresa = @CodigoEmpresa
	--AND CodigoLocal = @CodigoLocal
 --END
END

