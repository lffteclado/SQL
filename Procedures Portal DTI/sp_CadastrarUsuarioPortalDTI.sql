IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('sp_CadastrarUsuarioPortalDTI'))
BEGIN
	DROP PROCEDURE dbo.sp_CadastrarUsuarioPortalDTI
END
GO
CREATE PROCEDURE dbo.sp_CadastrarUsuarioPortalDTI
/*
* PROCEDURE CRIADA PARA CADASTRAR USUARIO NO PORTAL DTI
* AUTOR: Luís Felipe Ferreira
* DATA: 07/04/2018
* sp_LiberarPlanoCasa Codigo Plano (526), Plano Bloqueado('V' ou 'F'), Desconto('30'), Invisível ('V' ou 'F')
* EXEC sp_LiberarPlanoCasa '526', 'F', '30', 'F'
*/

@LoginName nvarchar(100)

AS

BEGIN TRANSACTION
	IF NOT EXISTS(SELECT 1 FROM SYSUser WHERE LoginName = @LoginName)
		BEGIN
			INSERT INTO SYSUser (LoginName, PasswordEncryptedText, RowCreatedSYSUserID, RowModifiedSYSUserID)
			VALUES (@LoginName, '***', 1, 1)

			COMMIT
		END
	ELSE
		ROLLBACK TRANSACTION
	END