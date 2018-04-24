IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('sp_LiberarPlanoCasa'))
BEGIN
	DROP PROCEDURE dbo.sp_LiberarPlanoCasa
END
GO
CREATE PROCEDURE dbo.sp_LiberarPlanoCasa
/*
* PROCEDURE CRIADA PARA LIBERAR OS PLANOS DE PAGAMENTO E DESCONTOS POR BANCO
* AUTOR: Luís Felipe Ferreira
* DATA: 03/04/2018
* sp_LiberarPlanoCasa Codigo Plano (526), Plano Bloqueado('V' ou 'F'), Desconto('30'), Invisível ('V' ou 'F')
* EXEC sp_LiberarPlanoCasa '526', 'F', '30', 'F'
*/

@CodigoPlano char(8),
@PlanoBloqueado char(1),
@Desconto char(5),
@Invisivel char(1)
--@BDEmpresa char(10)

AS
BEGIN
	UPDATE tbPlanoPagamento
	SET BloqueadoPlanoPagto = @PlanoBloqueado, 
	PercentualDescNFPlanoPagamento = @Desconto,
	PercentualDescontoPEC = @Desconto,
	DescontoInvisivelPlanoPagto = @Invisivel
	WHERE CodigoPlanoPagamento = @CodigoPlano
 END