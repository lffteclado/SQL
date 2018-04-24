--USE [dbVDL]
--GO
--CREATE TABLE [dbo].[LOOKUPRole](
--[LOOKUPRoleID] [int] IDENTITY(1,1) NOT NULL,
--[RoleName] [varchar](100) DEFAULT '',
--[RoleDescription] [varchar](500) DEFAULT '',
--[RowCreatedSYSUserID] [int] NOT NULL,
--[RowCreatedDateTime] [datetime] DEFAULT GETDATE(),
--[RowModifiedSYSUserID] [int] NOT NULL,
--[RowModifiedDateTime] [datetime] DEFAULT GETDATE(),
--PRIMARY KEY (LOOKUPRoleID)
--)
--GO

--USE [dbVDL]
--GO
--CREATE TABLE [dbo].[SYSUser](
--[SYSUserID] [int] IDENTITY(1,1) NOT NULL,
--[LoginName] [varchar](50) NOT NULL,
--[PasswordEncryptedText] [varchar](200) NOT NULL,
--[RowCreatedSYSUserID] [int] NOT NULL,
--[RowCreatedDateTime] [datetime] DEFAULT GETDATE(),
--[RowModifiedSYSUserID] [int] NOT NULL,
--[RowModifiedDateTime] [datetime] DEFAULT GETDATE(),
--PRIMARY KEY (SYSUserID)
--)
--GO

--USE [dbVDL]
--GO
--CREATE TABLE [dbo].[SYSUserProfile](
--[SYSUserProfileID] [int] IDENTITY(1,1) NOT NULL,
--[SYSUserID] [int] NOT NULL,
--[FirstName] [varchar](50) NOT NULL,
--[LastName] [varchar](50) NOT NULL,
--[Gender] [char](1) NOT NULL,
--[RowCreatedSYSUserID] [int] NOT NULL,
--[RowCreatedDateTime] [datetime] DEFAULT GETDATE(),
--[RowModifiedSYSUserID] [int] NOT NULL,
--[RowModifiedDateTime] [datetime] DEFAULT GETDATE(),
--PRIMARY KEY (SYSUserProfileID)
--)
--GO
--ALTER TABLE [dbo].[SYSUserProfile] WITH CHECK ADD FOREIGN KEY([SYSUserID])
--REFERENCES [dbo].[SYSUser] ([SYSUserID])
--GO
--USE [dbVDL]
--GO
--CREATE TABLE [dbo].[SYSUserRole](
--[SYSUserRoleID] [int] IDENTITY(1,1) NOT NULL,
--[SYSUserID] [int] NOT NULL,
--[LOOKUPRoleID] [int] NOT NULL,
--[IsActive] [bit] DEFAULT (1),
--[RowCreatedSYSUserID] [int] NOT NULL,
--[RowCreatedDateTime] [datetime] DEFAULT GETDATE(),
--[RowModifiedSYSUserID] [int] NOT NULL,
--[RowModifiedDateTime] [datetime] DEFAULT GETDATE(),
--PRIMARY KEY (SYSUserRoleID)
--)
--GO
--ALTER TABLE [dbo].[SYSUserRole] WITH CHECK ADD FOREIGN KEY([LOOKUPRoleID])
--REFERENCES [dbo].[LOOKUPRole] ([LOOKUPRoleID])
--GO
--ALTER TABLE [dbo].[SYSUserRole] WITH CHECK ADD FOREIGN KEY([SYSUserID])
--REFERENCES [dbo].[SYSUser] ([SYSUserID])
--GO

select * from SYSUser
select * from LOOKUPRole
select * from SYSUserProfile
select * from SYSUserRole

/*Inserindo Usuário*/
--DECLARE @LoginName nvarchar(100) = 'caixa1@cardiesel.com.br'

--IF NOT EXISTS(SELECT 1 FROM SYSUser WHERE LoginName = (@LoginName))
--BEGIN
--	INSERT INTO SYSUser (LoginName, PasswordEncryptedText, RowCreatedSYSUserID, RowModifiedSYSUserID)
--	VALUES (@LoginName, '***', 1, 1)
--END

--INSERT INTO SYSUserProfile (SYSUserID,FirstName,LastName,Gender,RowCreatedSYSUserID,RowModifiedSYSUserID)
--VALUES (11,'Monica Ribeiro','Financeiro','F',1,1)

--INSERT INTO SYSUserRole (SYSUserID,LOOKUPRoleID,IsActive,RowCreatedSYSUserID,
--RowModifiedSYSUserID)
--VALUES (11,3,1,1,1)

/* Cadastrar Perfis */

--INSERT INTO LOOKUPRole (RoleName,RoleDescription,RowCreatedSYSUserID,RowModifiedSYSUserID)
--VALUES ('Dti','Can Edit, Update',1,1)

--INSERT INTO LOOKUPRole (RoleName,RoleDescription,RowCreatedSYSUserID,RowModifiedSYSUserID)
--VALUES ('Finan','Read only',1,1)

--UPDATE SYSUserProfile SET SYSUserID = 4 WHERE SYSUserProfileID = 4

--UPDATE SYSUser SET LoginName = 'shirleyc@cardiesel.com.br' WHERE SYSUserID = 6

--UPDATE SYSUserRole SET LOOKUPRoleID = 4 WHERE SYSUserRoleID = 5 AND SYSUserID = 5




