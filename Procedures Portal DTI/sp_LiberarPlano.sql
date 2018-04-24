IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('sp_LiberarPlano'))
BEGIN
	DROP PROCEDURE dbo.sp_LiberarPlano
END
GO
CREATE PROCEDURE dbo.sp_LiberarPlano
/*
* PROCEDURE CRIADA PARA LIBERAR OS PLANOS DE PAGAMENTO E DESCONTOS
* AUTOR: Luís Felipe Ferreira
* DATA: 03/04/2018
* sp_LiberarPlano Codigo Empresa (930), Codigo Plano (526), Plano Bloqueado('V' ou 'F'), Desconto('30'), Invisível ('V' ou 'F')
* EXEC sp_LiberarPlano 930, '526', 'F', '30', 'F'
*/

@CodigoEmpresa numeric(4),
@CodigoPlano char(8),
@PlanoBloqueado char(1),
@Desconto char(5),
@Invisivel char(1)
--@BDEmpresa char(10)

AS
BEGIN
 IF (@CodigoEmpresa = 1200) --AUTOSETE
 BEGIN
	UPDATE dbAutosete.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado, 
	PercentualDescNFPlanoPagamento = @Desconto,
	PercentualDescontoPEC = @Desconto,
	DescontoInvisivelPlanoPagto = @Invisivel
	WHERE CodigoPlanoPagamento = @CodigoPlano AND CodigoEmpresa = @CodigoEmpresa
 END
 IF (@CodigoEmpresa = 262) --CALISTO
 BEGIN
	UPDATE dbCalisto.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado, 
	PercentualDescNFPlanoPagamento = @Desconto,
	PercentualDescontoPEC = @Desconto,
	DescontoInvisivelPlanoPagto = @Invisivel
	WHERE CodigoPlanoPagamento = @CodigoPlano AND CodigoEmpresa = @CodigoEmpresa
 END
IF (@CodigoEmpresa = 930) --CARDIESEL
 BEGIN
	UPDATE dbCardiesel.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado, 
	PercentualDescNFPlanoPagamento = @Desconto,
	PercentualDescontoPEC = @Desconto,
	DescontoInvisivelPlanoPagto = @Invisivel
	WHERE CodigoPlanoPagamento = @CodigoPlano AND CodigoEmpresa = @CodigoEmpresa
 END	
IF (@CodigoEmpresa = 2630) --GOIAS
 BEGIN
	UPDATE dbGoias.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado, 
	PercentualDescNFPlanoPagamento = @Desconto,
	PercentualDescontoPEC = @Desconto,
	DescontoInvisivelPlanoPagto = @Invisivel
	WHERE CodigoPlanoPagamento = @CodigoPlano AND CodigoEmpresa = @CodigoEmpresa
 END
IF (@CodigoEmpresa = 2890) --POSTO IMPERIAL
 BEGIN
	UPDATE dbPostoimperial.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado, 
	PercentualDescNFPlanoPagamento = @Desconto,
	PercentualDescontoPEC = @Desconto,
	DescontoInvisivelPlanoPagto = @Invisivel
	WHERE CodigoPlanoPagamento = @CodigoPlano AND CodigoEmpresa = @CodigoEmpresa
 END
IF (@CodigoEmpresa = 2620) --UBERLANDIA
 BEGIN
	UPDATE dbUberlandia.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado, 
	PercentualDescNFPlanoPagamento = @Desconto,
	PercentualDescontoPEC = @Desconto,
	DescontoInvisivelPlanoPagto = @Invisivel
	WHERE CodigoPlanoPagamento = @CodigoPlano AND CodigoEmpresa = @CodigoEmpresa
 END
 IF (@CodigoEmpresa = 130) --VADIESEL
 BEGIN
	UPDATE dbVadiesel.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado, 
	PercentualDescNFPlanoPagamento = @Desconto,
	PercentualDescontoPEC = @Desconto,
	DescontoInvisivelPlanoPagto = @Invisivel
	WHERE CodigoPlanoPagamento = @CodigoPlano AND CodigoEmpresa = @CodigoEmpresa
 END
 IF (@CodigoEmpresa = 260) --VALADARES
 BEGIN
	UPDATE dbValadares.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado, 
	PercentualDescNFPlanoPagamento = @Desconto,
	PercentualDescontoPEC = @Desconto,
	DescontoInvisivelPlanoPagto = @Invisivel
	WHERE CodigoPlanoPagamento = @CodigoPlano AND CodigoEmpresa = @CodigoEmpresa
 END
 IF (@CodigoEmpresa = 3140) --MONTES CLAROS
 BEGIN
	UPDATE dbMontesClaros.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado, 
	PercentualDescNFPlanoPagamento = @Desconto,
	PercentualDescontoPEC = @Desconto,
	DescontoInvisivelPlanoPagto = @Invisivel
	WHERE CodigoPlanoPagamento = @CodigoPlano AND CodigoEmpresa = @CodigoEmpresa
 END
 IF (@CodigoEmpresa = 3610)--REDE MINEIRA
 BEGIN
	UPDATE dbRedeMineira.dbo.tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado, 
	PercentualDescNFPlanoPagamento = @Desconto,
	PercentualDescontoPEC = @Desconto,
	DescontoInvisivelPlanoPagto = @Invisivel
	WHERE CodigoPlanoPagamento = @CodigoPlano AND CodigoEmpresa = @CodigoEmpresa
 END	
END