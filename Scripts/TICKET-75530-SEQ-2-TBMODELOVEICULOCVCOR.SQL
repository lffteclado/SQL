CREATE TABLE dbo.tbModeloVeiculoCVCor
(
	CodigoEmpresa				dtInteiro04 NOT NULL,
	ModeloVeiculo				varchar(21) NOT NULL,
	AplicacaoCor				char(1) ,
	CodigoCorVeic				char(4)	
	CONSTRAINT pkModeloVeiculoCVCor PRIMARY KEY (CodigoEmpresa, ModeloVeiculo, AplicacaoCor, CodigoCorVeic),
	CONSTRAINT fkModeloVeiculoCVCorEmp FOREIGN KEY (CodigoEmpresa) REFERENCES tbEmpresa ,
	CONSTRAINT fkModeloVeiculoCVCores FOREIGN KEY (CodigoEmpresa, AplicacaoCor, CodigoCorVeic ) REFERENCES tbCoresVeiculos ,
	CONSTRAINT fkModeloVeiculoCVCorMod FOREIGN KEY (CodigoEmpresa, ModeloVeiculo) REFERENCES tbModeloVeiculoCV
)
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('spIModeloVeiculoCVCor')) 
	DROP PROCEDURE dbo.spIModeloVeiculoCVCor
GO
CREATE PROCEDURE dbo.spIModeloVeiculoCVCor
	@CodigoEmpresa numeric(4) ,
	@ModeloVeiculo varchar(21) ,
	@AplicacaoCor char(1) ,
	@CodigoCorVeic char(4)
AS 
INSERT tbModeloVeiculoCVCor
(
	CodigoEmpresa,
	ModeloVeiculo,
	AplicacaoCor,
	CodigoCorVeic
)
VALUES
(
	@CodigoEmpresa,
	@ModeloVeiculo,
	@AplicacaoCor,
	@CodigoCorVeic
)

go

IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('spEModeloVeiculoCVCor')) 
	DROP PROCEDURE dbo.spEModeloVeiculoCVCor
GO
CREATE PROCEDURE dbo.spEModeloVeiculoCVCor
	@CodigoEmpresa numeric(4) ,
	@ModeloVeiculo varchar(21),
	@AplicacaoCor char(1) ,
	@CodigoCorVeic char(4)	
AS
DELETE FROM tbModeloVeiculoCVCor
WHERE CodigoEmpresa = @CodigoEmpresa 
AND   ModeloVeiculo = @ModeloVeiculo 		 
AND   AplicacaoCor = @AplicacaoCor 		 
AND   CodigoCorVeic = @CodigoCorVeic 

go
IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('spLModeloVeiculoCVCor')) 
	DROP PROCEDURE dbo.spLModeloVeiculoCVCor
GO
CREATE PROCEDURE dbo.spLModeloVeiculoCVCor
	@CodigoEmpresa numeric(4) = null ,
	@ModeloVeiculo varchar(21) = null,
	@AplicacaoCor  char(1)= null,
	@CodigoCorVeic char(4) = null
AS

SELECT * FROM tbModeloVeiculoCVCor (NOLOCK)
WHERE (CodigoEmpresa = @CodigoEmpresa or @CodigoEmpresa is null)
AND   (ModeloVeiculo = @ModeloVeiculo or @ModeloVeiculo is null)
AND   (AplicacaoCor = @AplicacaoCor or @AplicacaoCor is null)
AND   (CodigoCorVeic = @CodigoCorVeic or @CodigoCorVeic is null)
go
IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('spPModeloVeiculoCVCor')) 
	DROP PROCEDURE dbo.spPModeloVeiculoCVCor
GO
CREATE PROCEDURE dbo.spPModeloVeiculoCVCor
	@CodigoEmpresa numeric(4) ,
	@ModeloVeiculo varchar(21),
	@AplicacaoCor char(1) ,
	@CodigoCorVeic char(4)	
AS

SELECT * FROM tbModeloVeiculoCVCor (NOLOCK)
WHERE (CodigoEmpresa = @CodigoEmpresa)
AND   (ModeloVeiculo = @ModeloVeiculo)
AND   (AplicacaoCor = @AplicacaoCor)
AND   (CodigoCorVeic = @CodigoCorVeic)

go
GRANT ALL ON dbo.tbModeloVeiculoCVCor TO SQLUsers
GO
GRANT EXECUTE ON dbo.spIModeloVeiculoCVCor TO SQLUsers
GO
GRANT EXECUTE ON dbo.spEModeloVeiculoCVCor TO SQLUsers
GO
GRANT EXECUTE ON dbo.spLModeloVeiculoCVCor TO SQLUsers
GO
GRANT EXECUTE ON dbo.spPModeloVeiculoCVCor TO SQLUsers
GO
