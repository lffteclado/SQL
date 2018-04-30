-- drop TABLE tbMonitoramentoQuestao 
CREATE  TABLE tbMonitoramentoQuestao ( 
											CodigoEmpresa  numeric(4)NOT NULL,
											CodigoLocal	  numeric(4)NOT NULL,
											NumeroQuestao numeric(4) NOT NULL,
											TextoQuestaoVD  varchar(200),
											AlternativaAVD	varchar(100),
											AlternativaBVD	varchar(100),
											AlternativaCVD	varchar(100),
											AlternativaDVD	varchar(100),
											AlternativaEVD	varchar(100),
											TextoQuestaoPV  varchar(200),
											AlternativaAPV	varchar(100),
											AlternativaBPV	varchar(100),
											AlternativaCPV	varchar(100),
											AlternativaDPV	varchar(100),
											AlternativaEPV	varchar(100)
									 )

GO
ALTER TABLE tbMonitoramentoQuestao ADD CONSTRAINT fkCodigoEmpresa FOREIGN KEY (CodigoEmpresa) REFERENCES tbEmpresa 
GO 
ALTER TABLE tbMonitoramentoQuestao ADD CONSTRAINT fkCodigoLocal  FOREIGN KEY (CodigoEmpresa,CodigoLocal) REFERENCES tbLocal

GO
ALTER TABLE tbMonitoramentoQuestao ADD CONSTRAINT pkNumeroQuestao PRIMARY KEY(CodigoEmpresa, CodigoLocal, NumeroQuestao)
GO

if exists (select * from sysobjects where name = 'spAMonitoramentoQuestao') begin
drop PROC dbo.spAMonitoramentoQuestao		end
go
CREATE PROC dbo.spAMonitoramentoQuestao
	@CodigoEmpresa numeric(4),
	@CodigoLocal   numeric(4), 
	@NumeroQuestao numeric(4),
	@TextoQuestaoVD  varchar(200),
	@AlternativaAVD	varchar(100),
	@AlternativaBVD	varchar(100),
	@AlternativaCVD	varchar(100),
	@AlternativaDVD	varchar(100),
	@AlternativaEVD	varchar(100),
	@TextoQuestaoPV  varchar(200),
	@AlternativaAPV	varchar(100),
	@AlternativaBPV	varchar(100),
	@AlternativaCPV	varchar(100),
	@AlternativaDPV	varchar(100),
	@AlternativaEPV	varchar(100)

AS UPDATE tbMonitoramentoQuestao SET 
	TextoQuestaoVD  = @TextoQuestaoVD,
	AlternativaAVD  = @AlternativaAVD,
	AlternativaBVD  = @AlternativaBVD,
	AlternativaCVD	= @AlternativaCVD,
	AlternativaDVD	= @AlternativaDVD,
	AlternativaEVD	= @AlternativaEVD,
	TextoQuestaoPV  = @TextoQuestaoPV,
	AlternativaAPV	= @AlternativaAPV,
	AlternativaBPV	= @AlternativaBPV,
	AlternativaCPV	= @AlternativaCPV,
	AlternativaDPV	= @AlternativaDPV,
	AlternativaEPV	= @AlternativaEPV

WHERE CodigoEmpresa = @CodigoEmpresa
AND	CodigoLocal = @CodigoLocal
AND NumeroQuestao = @NumeroQuestao

GO



if exists (select * from sysobjects where name = 'spIMonitoramentoQuestao') begin
drop PROC dbo.spIMonitoramentoQuestao		end
go
CREATE PROC dbo.spIMonitoramentoQuestao
	@CodigoEmpresa numeric(4),
	@CodigoLocal   numeric(4), 
	@NumeroQuestao numeric(4),
	@TextoQuestaoVD  varchar(200),
	@AlternativaAVD	varchar(100),
	@AlternativaBVD	varchar(100),
	@AlternativaCVD	varchar(100),
	@AlternativaDVD	varchar(100),
	@AlternativaEVD	varchar(100),
	@TextoQuestaoPV  varchar(200),
	@AlternativaAPV	varchar(100),
	@AlternativaBPV	varchar(100),
	@AlternativaCPV	varchar(100),
	@AlternativaDPV	varchar(100),
	@AlternativaEPV	varchar(100)

AS INSERT tbMonitoramentoQuestao 
	(
		CodigoEmpresa,
		CodigoLocal,
		NumeroQuestao ,
		TextoQuestaoVD,
		AlternativaAVD,
		AlternativaBVD	,
		AlternativaCVD	,
		AlternativaDVD	,
		AlternativaEVD	,
		TextoQuestaoPV ,
		AlternativaAPV	,
		AlternativaBPV	,
		AlternativaCPV	,
		AlternativaDPV	,
		AlternativaEPV	
	)

VALUES 
    (
		@CodigoEmpresa,
		@CodigoLocal,
		@NumeroQuestao ,
		@TextoQuestaoVD ,
		@AlternativaAVD	,
		@AlternativaBVD	,
		@AlternativaCVD	,
		@AlternativaDVD	,
		@AlternativaEVD	,
		@TextoQuestaoPV ,
		@AlternativaAPV	,
		@AlternativaBPV	,
		@AlternativaCPV	,
		@AlternativaDPV	,
		@AlternativaEPV	
	)

GO 


if exists (select * from sysobjects where name = 'spEMonitoramentoQuestao') begin
drop PROC dbo.spEMonitoramentoQuestao		end
go
CREATE PROC dbo.spEMonitoramentoQuestao
	@CodigoEmpresa numeric(4),
	@CodigoLocal   numeric(4), 
	@NumeroQuestao numeric(4)

AS DELETE tbMonitoramentoQuestao
WHERE CodigoEmpresa = @CodigoEmpresa
AND	CodigoLocal = @CodigoLocal
AND NumeroQuestao = @NumeroQuestao

GO 



if exists (select * from sysobjects where name = 'spPMonitoramentoQuestao') begin
drop PROC dbo.spPMonitoramentoQuestao		end
go
CREATE PROC dbo.spPMonitoramentoQuestao
	@CodigoEmpresa numeric(4),
	@CodigoLocal   numeric(4), 
	@NumeroQuestao numeric(4)

AS SELECT * FROM tbMonitoramentoQuestao 
WHERE CodigoEmpresa = @CodigoEmpresa
AND	CodigoLocal = @CodigoLocal
AND NumeroQuestao = @NumeroQuestao
GO 



if exists (select * from sysobjects where name = 'spLMonitoramentoQuestao') begin
drop PROC dbo.spLMonitoramentoQuestao		end
go
CREATE PROC dbo.spLMonitoramentoQuestao
	@CodigoEmpresa numeric(4),
	@CodigoLocal   numeric(4), 
	@NumeroQuestao numeric(4)

AS SELECT * FROM tbMonitoramentoQuestao 
WHERE (CodigoEmpresa = @CodigoEmpresa OR @CodigoEmpresa IS NULL)
AND	(CodigoLocal = @CodigoLocal OR CodigoLocal IS NULL)
AND (NumeroQuestao = @NumeroQuestao OR NumeroQuestao IS NULL)

GO 

GRANT EXECUTE ON dbo.spAMonitoramentoQuestao  TO SQLUsers 
GRANT EXECUTE ON dbo.spIMonitoramentoQuestao  TO SQLUsers 
GRANT EXECUTE ON dbo.spEMonitoramentoQuestao  TO SQLUsers 
GRANT EXECUTE ON dbo.spPMonitoramentoQuestao  TO SQLUsers 
GRANT EXECUTE ON dbo.spLMonitoramentoQuestao  TO SQLUsers 

GO 

----declare @CodigoEmpresa numeric(4)
----select @CodigoEmpresa = (select min(CodigoEmpresa) from tbEmpresa)
----EXECUTE dbo.spIMonitoramentoQuestao @CodigoEmpresa,0, 4,'Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1-Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo','Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1- Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo'
----EXECUTE dbo.spIMonitoramentoQuestao @CodigoEmpresa,1, 4,'Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1-Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo','Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1- Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo'
----EXECUTE dbo.spIMonitoramentoQuestao @CodigoEmpresa,2, 4,'Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1-Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo','Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1- Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo'
----EXECUTE dbo.spIMonitoramentoQuestao @CodigoEmpresa,3, 4,'Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1-Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo','Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1- Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo'
----EXECUTE dbo.spIMonitoramentoQuestao @CodigoEmpresa,4, 4,'Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1-Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo','Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1- Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo'
----EXECUTE dbo.spIMonitoramentoQuestao @CodigoEmpresa,5, 4,'Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1-Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo','Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1- Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo'
----EXECUTE dbo.spIMonitoramentoQuestao @CodigoEmpresa,6, 4,'Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1-Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo','Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1- Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo'
----EXECUTE dbo.spIMonitoramentoQuestao @CodigoEmpresa,7, 4,'Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1-Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo','Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1- Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo'
----EXECUTE dbo.spIMonitoramentoQuestao @CodigoEmpresa,8, 4,'Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1-Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo','Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1- Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo'
----EXECUTE dbo.spIMonitoramentoQuestao @CodigoEmpresa,9, 4,'Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1-Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo','Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1- Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo'
----EXECUTE dbo.spIMonitoramentoQuestao @CodigoEmpresa,10, 4,'Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1-Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo','Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1- Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo'
----EXECUTE dbo.spIMonitoramentoQuestao @CodigoEmpresa,11, 4,'Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1-Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo','Qual nota o Sr. daria para o atendimento geral do nosso departamento ?','1- Péssimo','2- Ruim','3- Regular','4- Bom','5 - Ótimo'
--
--GO 
 
--declare @login varchar(255)
--declare @script varchar(255)
--select @login = (select distinct nt_username from master..sysprocesses where spid = @@spid)
--select @script = '0401FM6649.sql'
--
--insert into tbControleScript 
--(NomeScript, DataExecucaoScript, LoginUsuario)
--values 
--(@script, getdate(), @login)
