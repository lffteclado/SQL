IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('sp_BloqueiaAbaixoCusto'))
BEGIN
	DROP PROCEDURE dbo.sp_BloqueiaAbaixoCusto
END
GO
CREATE PROCEDURE  dbo.sp_BloqueiaAbaixoCusto
/*
* PROCEDURE CRIADA PARA BLOQUEAR E DESBLOQUEAR VENDAS ABAIXO DO CUSTO
* AUTOR: Luís Felipe Ferreira
* Data: 08/09/2017
* EXEC sp_BloqueiaAbaixoCusto 930, 0, 'F'
*/

@CodigoEmpresa numeric(4),
@CodigoLocal numeric(1),
@Bloqueado char(1)

AS
BEGIN
 IF (@CodigoEmpresa = 1200)--AUTOSETE
 BEGIN
	UPDATE dbAutoSete.dbo.tbLocalFT
	SET DadosEmpresaPreImpresso = @Bloqueado
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END
 IF (@CodigoEmpresa = 262)--CALISTO
 BEGIN
	UPDATE dbCalisto.dbo.tbLocalFT
	SET DadosEmpresaPreImpresso = @Bloqueado
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END
 IF (@CodigoEmpresa = 930)--CARDIESEL
 BEGIN
	UPDATE dbCardiesel_I.dbo.tbLocalFT
	SET DadosEmpresaPreImpresso = @Bloqueado
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END
 IF (@CodigoEmpresa = 2630)--GOIAS
 BEGIN
	UPDATE dbGoias.dbo.tbLocalFT
	SET DadosEmpresaPreImpresso = @Bloqueado
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END
 IF (@CodigoEmpresa = 2890)--POSTO IMPERIAL
 BEGIN
	UPDATE dbPostoImperialDP.dbo.tbLocalFT
	SET DadosEmpresaPreImpresso = @Bloqueado
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END
 IF (@CodigoEmpresa = 2620)-- UBERLANDIA
 BEGIN
	UPDATE dbUberlandia.dbo.tbLocalFT
	SET DadosEmpresaPreImpresso = @Bloqueado
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END
 IF (@CodigoEmpresa = 130)--VADIESEL
 BEGIN
	UPDATE dbVadiesel.dbo.tbLocalFT
	SET DadosEmpresaPreImpresso = @Bloqueado
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END
 IF (@CodigoEmpresa = 260)--VALADARES
 BEGIN
	UPDATE dbValadaresCNV.dbo.tbLocalFT
	SET DadosEmpresaPreImpresso = @Bloqueado
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END	
END
GO
