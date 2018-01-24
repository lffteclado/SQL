IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('sp_BloqueiaPlano'))
BEGIN
	DROP PROCEDURE dbo.sp_BloqueiaPlano
END
GO
CREATE PROCEDURE dbo.sp_BloqueiaPlano
/*
* PROCEDURE CRIADA PARA BLOQUER E DESBLOQUEAR PLANOS
* AUTOR: Luís Felipe Ferreira
* Data: 08/09/2017
* EXEC sp_BloqueiaPlano 3140, 526, 'V'
*/

@CodigoEmpresa numeric(4),
@CodigoPlano char(8),
@PlanoBloqueado char(1)
--@BDEmpresa char(10)

AS
BEGIN
 IF (@CodigoEmpresa = 3140)
 BEGIN
	UPDATE dbMontesClaros.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado
	WHERE CodigoPlanoPagamento = @CodigoPlano
	AND CodigoEmpresa = CodigoEmpresa
 END
 IF (@CodigoEmpresa = 3610)
 BEGIN
	UPDATE dbRedeMineira.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado
	WHERE CodigoPlanoPagamento = @CodigoPlano
	AND CodigoEmpresa = CodigoEmpresa
 END	
END
GO