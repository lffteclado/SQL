ALTER TABLE tbDocumentoRPS ADD NumeroLote numeric(10) NULL
GO
UPDATE tbDocumentoRPS SET NumeroLote = 0
GO
ALTER TABLE tbDocumentoRPS ALTER COLUMN NumeroLote numeric(10) NOT NULL
GO
DROP PROC dbo.spIDocumentoRPS
GO
CREATE PROCEDURE dbo.spIDocumentoRPS
   @CodigoEmpresa numeric(4) ,
   @CodigoLocal numeric(4) ,
   @EntradaSaidaDocumento char(1) ,
   @NumeroDocumento numeric(6) ,
   @DataDocumento datetime ,
   @CodigoCliFor numeric(14) ,
   @TipoLancamentoMovimentacao numeric(2) ,
   @TipoRPS varchar(5),
   @SerieRPS varchar(5),
   @NumeroNFE numeric(15),
   @DataNFE datetime,
   @CodigoVerificacaoNFE varchar(15),
   @ValorCreditoNFE money,
   @XMLRetorno varchar(7500) = null,
   @NumeroLote numeric(10) = 0
AS 
INSERT tbDocumentoRPS
   (CodigoEmpresa,
   CodigoLocal,
   EntradaSaidaDocumento,
   NumeroDocumento,
   DataDocumento,
   CodigoCliFor,
   TipoLancamentoMovimentacao,
   TipoRPS,
   SerieRPS,
   NumeroNFE,
   DataNFE,
   CodigoVerificacaoNFE,
   ValorCreditoNFE,
   XMLRetorno,
   NumeroLote)
VALUES
   (@CodigoEmpresa,
   @CodigoLocal,
   @EntradaSaidaDocumento,
   @NumeroDocumento,
   @DataDocumento,
   @CodigoCliFor,
   @TipoLancamentoMovimentacao,
   @TipoRPS,
   @SerieRPS,
   @NumeroNFE,
   @DataNFE,
   @CodigoVerificacaoNFE,
   @ValorCreditoNFE,
   @XMLRetorno,
   @NumeroLote)
go
DROP PROC dbo.spADocumentoRPS
go
CREATE PROCEDURE dbo.spADocumentoRPS
   @CodigoEmpresa numeric(4) ,
   @CodigoLocal numeric(4) ,
   @EntradaSaidaDocumento char(1) ,
   @NumeroDocumento numeric(6) ,
   @DataDocumento datetime ,
   @CodigoCliFor numeric(14) ,
   @TipoLancamentoMovimentacao numeric(2) ,
   @TipoRPS varchar(5),
   @SerieRPS varchar(5),
   @NumeroNFE numeric(8),
   @DataNFE datetime,
   @CodigoVerificacaoNFE varchar(8),
   @ValorCreditoNFE money,
   @XMLRetorno varchar(7500) = null,
   @NumeroLote numeric(10) = 0
AS 
UPDATE tbDocumentoRPS
SET
   TipoRPS = @TipoRPS ,
   SerieRPS = @SerieRPS,
   NumeroNFE = @NumeroNFE,
   DataNFE = @DataNFE,
   CodigoVerificacaoNFE = @CodigoVerificacaoNFE,
   ValorCreditoNFE = @ValorCreditoNFE,
   XMLRetorno = @XMLRetorno,
   NumeroLote = @NumeroLote
WHERE 
   CodigoEmpresa = @CodigoEmpresa AND
   CodigoLocal = @CodigoLocal AND
   EntradaSaidaDocumento = @EntradaSaidaDocumento AND
   NumeroDocumento = @NumeroDocumento AND
   DataDocumento = @DataDocumento AND
   CodigoCliFor = @CodigoCliFor AND
   TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao 
go
