IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('sp_BloqueiaAbaixoCusto'))
BEGIN
	DROP PROCEDURE dbo.sp_BloqueiaAbaixoCusto
END
GO
CREATE PROCEDURE  dbo.sp_BloqueiaAbaixoCusto
/*
* PROCEDURE CRIADA PARA BLOQUER E DESBLOQUEAR VENDAS ABAIXO DO CUSTO
* AUTOR: Luís Felipe Ferreira
* Data: 08/09/2017
* EXEC sp_BloqueiaAbaixoCusto 3140, 0, 'F'
*/

@CodigoEmpresa numeric(4),
@CodigoLocal numeric(1),
@Bloqueado char(1)

AS
BEGIN
 IF (@CodigoEmpresa = 3140)
 BEGIN
	UPDATE dbMontesClaros.dbo.tbLocalFT
	SET DadosEmpresaPreImpresso = @Bloqueado
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END
 IF (@CodigoEmpresa = 3610)
 BEGIN
	UPDATE dbRedeMineira.dbo.tbLocalFT
	SET DadosEmpresaPreImpresso = @Bloqueado
	WHERE CodigoEmpresa = @CodigoEmpresa
	AND CodigoLocal = @CodigoLocal
 END	
END
GO