ALTER TABLE tbFichaControleProducaoItem DROP CONSTRAINT pkFichaControleProducaoItem
go
ALTER TABLE tbFichaControleProducao ALTER COLUMN CodigoFabricante char(3) COLLATE Latin1_General_CS_AS
GO
ALTER TABLE tbFichaControleProducao ALTER COLUMN CodigoMedida char(20) COLLATE Latin1_General_CS_AS
GO
ALTER TABLE tbFichaControleProducao ALTER COLUMN DOT char(10) COLLATE Latin1_General_CS_AS
GO
ALTER TABLE tbFichaControleProducao ALTER COLUMN Serie char(10) COLLATE Latin1_General_CS_AS
GO
ALTER TABLE tbFichaControleProducao ALTER COLUMN NumeroFogo char(15) COLLATE Latin1_General_CS_AS
GO
ALTER TABLE tbFichaControleProducao ALTER COLUMN Carcaca char(10) COLLATE Latin1_General_CS_AS
GO
ALTER TABLE tbFichaControleProducao ALTER COLUMN Bandag char(1) COLLATE Latin1_General_CS_AS
GO
ALTER TABLE tbFichaControleProducao ALTER COLUMN PreMoldado char(1) COLLATE Latin1_General_CS_AS
GO
ALTER TABLE tbFichaControleProducao ALTER COLUMN Quente char(1) COLLATE Latin1_General_CS_AS
GO
ALTER TABLE tbFichaControleProducao ALTER COLUMN Outros char(1) COLLATE Latin1_General_CS_AS
GO
ALTER TABLE tbFichaControleProducao ALTER COLUMN Radial char(1) COLLATE Latin1_General_CS_AS
GO
ALTER TABLE tbFichaControleProducao ALTER COLUMN Observacao char(300) COLLATE Latin1_General_CS_AS
GO
ALTER TABLE tbFichaControleProducao ALTER COLUMN CodigoBanda char(30) COLLATE Latin1_General_CS_AS
GO
ALTER TABLE tbFichaControleProducao ALTER COLUMN CodigoAlmoxarifadoOrigem CHAR(6) COLLATE Latin1_General_CS_AS
GO
ALTER TABLE tbFichaControleProducao ALTER COLUMN CodigoAlmoxarifadoDestino CHAR(6) COLLATE Latin1_General_CS_AS
GO
ALTER TABLE tbFichaControleProducao ALTER COLUMN CodigoLaudo CHAR(3) COLLATE Latin1_General_CS_AS
GO
ALTER TABLE tbFichaControleProducaoItem ALTER COLUMN CodigoProduto char(30) COLLATE Latin1_General_CS_AS
go
ALTER TABLE tbFichaControleProducaoItem ALTER COLUMN CodigoAlmoxarifadoOrigem char(6) COLLATE Latin1_General_CS_AS
go
ALTER TABLE tbFichaControleProducaoItem ALTER COLUMN CodigoAlmoxarifadoDestino char(6) COLLATE Latin1_General_CS_AS
go
ALTER TABLE tbFichaControleProducaoItem ADD CONSTRAINT pkFichaControleProducaoItem PRIMARY KEY ( CodigoEmpresa, CodigoLocal, NumeroFicha, CodigoProduto)
go
