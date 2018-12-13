--USE [dbVDL]
--GO
--CREATE TABLE [dbo].[ControleERP](
--[ID] [int] IDENTITY(1,1) NOT NULL,
--[Empresa] [varchar](100) NOT NULL,
--[Tecnico] [varchar](100) NOT NULL,
--[Usuario] [varchar](100) NOT NULL,
--[NomeCompleto] [varchar](100) NOT NULL,
--[ModuloAcessa] [varchar](500) NOT NULL,
--[Departamento] [varchar](50) NOT NULL,
--[Cargo] [varchar](50) NOT NULL,
--[AcessaMaisEmpresa] [bit] DEFAULT (0),
--[OutraEmpresa] [varchar](50) DEFAULT '',
--[OutroUsuario] [varchar](50) DEFAULT '',
--[DataAtualizacao] [datetime] DEFAULT GETDATE(),
--PRIMARY KEY (ID)
--)
--GO

select * from ControleERP where Tecnico = 'Nodir Carlos' and Empresa like 'Posto Imperial'

select * from ControleERP where Tecnico = 'Nodir Carlos' and OutraEmpresa like '%Imperial%'





--        public int ID { get; set; }
--        public string Empresa { get; set; }
--        public string Tecnico { get; set; }
--        public string Usuario { get; set; }
--        public string NomeCompleto { get; set; }
--        public string ModuloAcessa { get; set; }
--        public string Departamento { get; set; }
--        public string Cargo { get; set; }
--        public bool AcessaMaisEmpresa { get; set; }
--        public string OutraEmpresa { get; set; }
--        public string OutroUsuario { get; set; }
--		public DateTime DataAtualizacao { get; set; }



--		CREATE TABLE [dbo].[SYSUserRole](
----[SYSUserRoleID] [int] IDENTITY(1,1) NOT NULL,
--[SYSUserID] [int] NOT NULL,
--[LOOKUPRoleID] [int] NOT NULL,
--[IsActive] [bit] DEFAULT (1),
--[RowCreatedSYSUserID] [int] NOT NULL,
--[RowCreatedDateTime] [datetime] DEFAULT GETDATE(),
--[RowModifiedSYSUserID] [int] NOT NULL,
--[RowModifiedDateTime] [datetime] DEFAULT GETDATE(),
--PRIMARY KEY (SYSUserRoleID)
