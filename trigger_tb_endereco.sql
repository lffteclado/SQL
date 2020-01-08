IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('tri_endereco_cooperado_api_ged'))
		BEGIN
			DROP TRIGGER [dbo].[tri_endereco_cooperado_api_ged]
		END
GO
CREATE TRIGGER [dbo].[tri_endereco_cooperado_api_ged] ON [dbo].[tb_endereco]
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @action as char(1)
	SET @action = 'I'; -- Set Action to Insert by default.
    IF EXISTS(SELECT * FROM DELETED)
		BEGIN
			SET @action = 
				CASE
					WHEN EXISTS(SELECT * FROM INSERTED) THEN 'U' -- Set Action to Updated.
					ELSE 'D' -- Set Action to Deleted.       
				END
		END

	IF @action = 'I'
		BEGIN
			INSERT INTO rl_sincronizacao_cooperado_api_ged (
	            data_ultima_alteracao,
	            registro_ativo,
				status,
				tipo,
				fk_usuario_ultima_alteracao,
				 fk_cooperado)
			  SELECT GETDATE(), 1, 0, 0, i.fk_usuario_ultima_alteracao, i.fk_cooperado FROM INSERTED i
			  INNER JOIN tb_cooperado coop ON (i.fk_cooperado = coop.id)
			   WHERE i.discriminator = 'Cooperado' AND coop.discriminator = 'pf'
		END

	IF @action = 'U'
		BEGIN
			INSERT INTO rl_sincronizacao_cooperado_api_ged (
	            data_ultima_alteracao,
	            registro_ativo,
				status,
				tipo,
				fk_usuario_ultima_alteracao,
				 fk_cooperado)
			  SELECT GETDATE(), 1, 0, 1, i.fk_usuario_ultima_alteracao, i.fk_cooperado FROM INSERTED i
			  INNER JOIN tb_cooperado coop ON (i.fk_cooperado = coop.id)
			    WHERE i.discriminator = 'Cooperado' AND coop.discriminator = 'pf'
		END

	IF @action = 'D'
		BEGIN
			INSERT INTO rl_sincronizacao_cooperado_api_ged (
	            data_ultima_alteracao,
	            registro_ativo,
				status,
				tipo,
				fk_usuario_ultima_alteracao,
				 fk_cooperado)
			SELECT GETDATE(), 1, 0, 2, d.fk_usuario_ultima_alteracao, d.fk_cooperado FROM DELETED d
			 INNER JOIN tb_cooperado coop ON (d.fk_cooperado = coop.id)
			    WHERE d.discriminator = 'Cooperado' AND coop.discriminator = 'pf'

		END
END

GO

ALTER TABLE [dbo].[tb_endereco] ENABLE TRIGGER [tri_endereco_cooperado_api_ged]

GO


