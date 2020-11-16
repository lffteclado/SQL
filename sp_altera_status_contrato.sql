IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('sp_alteraStatusContrato'))
BEGIN
	DROP PROCEDURE dbo.sp_alteraStatusContrato
END
GO
CREATE PROCEDURE  dbo.sp_alteraStatusContrato
/*
* PROCEDURE CRIADA PARA ALTERAR OS STATUS DOS CONTRATOS (MODULO GESTÃO DE CONTRATOS)
* AUTOR: Luís Felipe Ferreira
* EMPRESA: FENCOM
* Data: 26/08/2020
*/

AS

/* AGUARDANDO INICIO */
IF(EXISTS(select 1 from tb_gestao_contratos
where data_contratual > getdate()
and (data_vencimento is null or data_vencimento >= getdate())
and registro_ativo = 1
and status_contrato <> 3))
BEGIN
	UPDATE tb_gestao_contratos SET status_contrato = 0
	WHERE data_contratual > getdate()
	and (data_vencimento is null or data_vencimento >= getdate())
	and registro_ativo = 1
	and status_contrato <> 3
END
/* ATIVO */
IF (EXISTS(select 1 from tb_gestao_contratos
where data_contratual <= getdate()
and (data_vencimento is null or data_vencimento >= getdate())
and registro_ativo = 1
and status_contrato <> 3))
BEGIN
	UPDATE tb_gestao_contratos SET status_contrato = 1
	WHERE data_contratual <= getdate()
	and (data_vencimento is null or data_vencimento >= getdate())
	and registro_ativo = 1
	and status_contrato <> 3
END
/* VENCIDO */
IF(EXISTS(select 1 from tb_gestao_contratos
where data_contratual <= getdate()
and (data_vencimento is not null and data_vencimento < getdate())
and registro_ativo = 1
and status_contrato <> 3))
BEGIN
	UPDATE tb_gestao_contratos SET status_contrato = 2
	WHERE data_contratual <= getdate()
	and (data_vencimento is not null and data_vencimento < getdate())
	and registro_ativo = 1
	and status_contrato <> 3
END