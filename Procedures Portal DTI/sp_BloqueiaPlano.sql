IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('sp_BloqueiaPlano'))
BEGIN
	DROP PROCEDURE dbo.sp_BloqueiaPlano
END
GO
CREATE PROCEDURE dbo.sp_BloqueiaPlano
/*
* PROCEDURE CRIADA PARA BLOQUER E DESBLOQUEAR PLANOS
* AUTOR: Luís Felipe Ferreira
* DATA: 08/09/2017
* ATUALIZAÇÃO: 02/01/2018
* MOTIVO: MIGRAÇÃO NOVO SERVIDOR 0.60
* AUTOR: LUÍS FELIPE
*/

@CodigoEmpresa numeric(4),
@CodigoPlano char(8),
@PlanoBloqueado char(1)
--@BDEmpresa char(10)

AS
BEGIN
 IF (@CodigoEmpresa = 1200)
 BEGIN
	UPDATE dbAutosete.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado
	WHERE CodigoPlanoPagamento = @CodigoPlano
	AND CodigoEmpresa = @CodigoEmpresa
 END
 IF (@CodigoEmpresa = 262)
 BEGIN
	UPDATE dbCalisto.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado
	WHERE CodigoPlanoPagamento = @CodigoPlano
	AND CodigoEmpresa = @CodigoEmpresa
 END
IF (@CodigoEmpresa = 930)
 BEGIN
	UPDATE dbCardiesel.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado
	WHERE CodigoPlanoPagamento = @CodigoPlano
	AND CodigoEmpresa = @CodigoEmpresa
 END	
IF (@CodigoEmpresa = 2630)
 BEGIN
	UPDATE dbGoias.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado
	WHERE CodigoPlanoPagamento = @CodigoPlano
	AND CodigoEmpresa = @CodigoEmpresa
 END
IF (@CodigoEmpresa = 2890)
 BEGIN
	UPDATE dbPostoImperial.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado
	WHERE CodigoPlanoPagamento = @CodigoPlano
	AND CodigoEmpresa = @CodigoEmpresa
 END
--IF (@CodigoEmpresa = 3610)
-- BEGIN
--	UPDATE dbRedeMineira.dbo.tbPlanoPagamento
--	SET BloqueadoPlanoPagto = @PlanoBloqueado
--	WHERE CodigoPlanoPagamento = @CodigoPlano
--	AND CodigoEmpresa = @CodigoEmpresa
-- END	
IF (@CodigoEmpresa = 2620)
 BEGIN
	UPDATE dbUberlandia.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado
	WHERE CodigoPlanoPagamento = @CodigoPlano
	AND CodigoEmpresa = @CodigoEmpresa
 END	
--IF (@CodigoEmpresa = 130)
-- BEGIN
--	UPDATE dbVadiesel.dbo.tbPlanoPagamento
--	SET BloqueadoPlanoPagto = @PlanoBloqueado
--	WHERE CodigoPlanoPagamento = @CodigoPlano
--	AND CodigoEmpresa = @CodigoEmpresa
-- END	
--IF (@CodigoEmpresa = 260)
-- BEGIN
--	UPDATE dbValadares.dbo.tbPlanoPagamento
--	SET BloqueadoPlanoPagto = @PlanoBloqueado
--	WHERE CodigoPlanoPagamento = @CodigoPlano
--	AND CodigoEmpresa = @CodigoEmpresa
-- END	
--IF (@CodigoEmpresa = 3140)
-- BEGIN
--	UPDATE dbMontesClaros.dbo.tbPlanoPagamento
--	SET BloqueadoPlanoPagto = @PlanoBloqueado
--	WHERE CodigoPlanoPagamento = @CodigoPlano
--	AND CodigoEmpresa = CodigoEmpresa
-- END			
END