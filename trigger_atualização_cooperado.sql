IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('tri_cooperado_api_ged'))
		BEGIN
			DROP TRIGGER [dbo].[tri_cooperado_api_ged]
		END
GO
CREATE TRIGGER [dbo].[tri_cooperado_api_ged] ON [dbo].[tb_cooperado]
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
			  SELECT GETDATE(), 1, 0, 0, i.fk_usuario_ultima_alteracao, i.id FROM INSERTED i WHERE i.discriminator = 'pf' 	  
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
			  SELECT GETDATE(), 1, 0, 1, i.fk_usuario_ultima_alteracao, i.id FROM INSERTED i  WHERE i.discriminator = 'pf' 
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
			SELECT GETDATE(), 1, 0, 2, d.fk_usuario_ultima_alteracao, d.id FROM DELETED d  WHERE d.discriminator = 'pf'

		END
END

GO

ALTER TABLE [dbo].[tb_cooperado] ENABLE TRIGGER [tri_cooperado_api_ged]

GO


