IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('spADocumentoRPS'))
	DROP PROCEDURE dbo.spADocumentoRPS
GO
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
   @CodigoVerificacaoNFE varchar(50),
   @ValorCreditoNFE money,
   @XMLRetorno varchar(7500) = null,
   @NumeroLote numeric(10) = 0,
   @NumeroRPS numeric(10) = 0
AS 

IF EXISTS ( SELECT 1 FROM tbDocumentoRPS (NOLOCK) 
		    WHERE
			CodigoEmpresa = @CodigoEmpresa AND
			CodigoLocal = @CodigoLocal AND
			EntradaSaidaDocumento = @EntradaSaidaDocumento AND
			NumeroDocumento = @NumeroDocumento AND
			DataDocumento = @DataDocumento AND
			CodigoCliFor = @CodigoCliFor AND
			TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao AND
            NumeroDocumento <> @NumeroNFE ) AND
   NOT EXISTS ( SELECT 1 FROM tbLocal (NOLOCK)
			    WHERE
                tbLocal.CodigoEmpresa = @CodigoEmpresa AND
                tbLocal.CodigoLocal = @CodigoLocal AND
                RTRIM(LTRIM(tbLocal.MunicipioLocal)) = 'SAO PAULO' AND
                tbLocal.UFLocal = 'SP' )
BEGIN
	
	IF @DataNFE = '1990-01-01' SELECT @DataNFE = @DataDocumento
	
	EXEC whADocumentoRPSManual @CodigoEmpresa,@CodigoLocal,@NumeroDocumento,@DataDocumento,@CodigoCliFor,@NumeroNFE,@CodigoVerificacaoNFE,@DataNFE,@XMLRetorno,@NumeroDocumento,'PROD'

END
ELSE
BEGIN
	UPDATE tbDocumentoRPS
	SET
	   TipoRPS = @TipoRPS ,
	   SerieRPS = @SerieRPS,
	   NumeroNFE = @NumeroNFE,
	   DataNFE = @DataNFE,
	   CodigoVerificacaoNFE = @CodigoVerificacaoNFE,
	   ValorCreditoNFE = @ValorCreditoNFE,
	   XMLRetorno = @XMLRetorno,
	   NumeroLote = @NumeroLote,
	   NumeroRPS = @NumeroRPS
	WHERE 
	   CodigoEmpresa = @CodigoEmpresa AND
	   CodigoLocal = @CodigoLocal AND
	   EntradaSaidaDocumento = @EntradaSaidaDocumento AND
	   NumeroDocumento = @NumeroDocumento AND
	   DataDocumento = @DataDocumento AND
	   CodigoCliFor = @CodigoCliFor AND
	   TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao 
END