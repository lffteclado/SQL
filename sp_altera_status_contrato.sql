IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('sp_alteraStatusContrato'))
BEGIN
	DROP PROCEDURE dbo.sp_alteraStatusContrato
END
GO
CREATE PROCEDURE  dbo.sp_alteraStatusContrato(
 @idEntidadeConvenio BIGINT
)
/*
* PROCEDURE CRIADA PARA ALTERAR OS STATUS DOS CONTRATOS (MODULO GESTÃO DE CONTRATOS)
* AUTOR: Luís Felipe Ferreira
* EMPRESA: FENCOM
* Data: 26/08/2020
*/

AS

IF (@idEntidadeConvenio IS NULL)
BEGIN
	/* AGUARDANDO INICIO */
	IF(EXISTS(select 1 from tb_gestao_contratos
	where data_contratual > CONVERT(DATE,GETDATE())
	and (data_vencimento is null or data_vencimento >= CONVERT(DATE,GETDATE()))
	and registro_ativo = 1
	and status_contrato <> 3))
	BEGIN
		UPDATE tb_gestao_contratos SET status_contrato = 0
		WHERE data_contratual > CONVERT(DATE,GETDATE())
		and (data_vencimento is null or data_vencimento >= CONVERT(DATE,GETDATE()))
		and registro_ativo = 1
		and status_contrato <> 3
	END
	/* ATIVO */
	IF (EXISTS(select 1 from tb_gestao_contratos
	where data_contratual <= CONVERT(DATE,GETDATE())
	and (data_vencimento is null or data_vencimento >= CONVERT(DATE,GETDATE()))
	and registro_ativo = 1
	and status_contrato <> 3))
	BEGIN
		UPDATE tb_gestao_contratos SET status_contrato = 1
		WHERE data_contratual <= CONVERT(DATE,GETDATE())
		and (data_vencimento is null or data_vencimento >= CONVERT(DATE,GETDATE()))
		and registro_ativo = 1
		and status_contrato <> 3
	END
	/* VENCIDO */
	IF(EXISTS(select 1 from tb_gestao_contratos
	where data_contratual <= CONVERT(DATE,GETDATE())
	and (data_vencimento is not null and data_vencimento < CONVERT(DATE,GETDATE()))
	and registro_ativo = 1
	and status_contrato <> 3))
	BEGIN
		UPDATE tb_gestao_contratos SET status_contrato = 2
		WHERE data_contratual <= CONVERT(DATE,GETDATE())
		and (data_vencimento is not null and data_vencimento < CONVERT(DATE,GETDATE()))
		and registro_ativo = 1
		and status_contrato <> 3
	END
END
IF (@idEntidadeConvenio IS NOT NULL)
BEGIN
	/* AGUARDANDO INICIO */
	IF(EXISTS(select 1 from tb_gestao_contratos
	where data_contratual > CONVERT(DATE,GETDATE())
	and (data_vencimento is null or data_vencimento >= CONVERT(DATE,GETDATE()))
	and registro_ativo = 1
	and status_contrato <> 3
	and fk_entidade_convenio = @idEntidadeConvenio))
	BEGIN
		UPDATE tb_gestao_contratos SET status_contrato = 0
		WHERE data_contratual > CONVERT(DATE,GETDATE())
		and (data_vencimento is null or data_vencimento >= CONVERT(DATE,GETDATE()))
		and registro_ativo = 1
		and status_contrato <> 3
		and fk_entidade_convenio = @idEntidadeConvenio
	END
	/* ATIVO */
	IF (EXISTS(select 1 from tb_gestao_contratos
	where data_contratual <= CONVERT(DATE,GETDATE())
	and (data_vencimento is null or data_vencimento >= CONVERT(DATE,GETDATE()))
	and registro_ativo = 1
	and status_contrato <> 3
	and fk_entidade_convenio = @idEntidadeConvenio))
	BEGIN
		UPDATE tb_gestao_contratos SET status_contrato = 1
		WHERE data_contratual <= CONVERT(DATE,GETDATE())
		and (data_vencimento is null or data_vencimento >= CONVERT(DATE,GETDATE()))
		and registro_ativo = 1
		and status_contrato <> 3
		and fk_entidade_convenio = @idEntidadeConvenio
	END
	/* VENCIDO */
	IF(EXISTS(select 1 from tb_gestao_contratos
	where data_contratual <= CONVERT(DATE,GETDATE())
	and (data_vencimento is not null and data_vencimento < CONVERT(DATE,GETDATE()))
	and registro_ativo = 1
	and status_contrato <> 3
	and fk_entidade_convenio = @idEntidadeConvenio))
	BEGIN
		UPDATE tb_gestao_contratos SET status_contrato = 2
		WHERE data_contratual <= CONVERT(DATE,GETDATE())
		and (data_vencimento is not null and data_vencimento < CONVERT(DATE,GETDATE()))
		and registro_ativo = 1
		and status_contrato <> 3
		and fk_entidade_convenio = @idEntidadeConvenio
	END
END