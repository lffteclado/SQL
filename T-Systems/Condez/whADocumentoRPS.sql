IF EXISTS (SELECT 1 FROM sysobjects where id = object_id('whADocumentoRPS')) 
	DROP PROCEDURE dbo.whADocumentoRPS
GO
CREATE PROCEDURE dbo.whADocumentoRPS
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda.
 PROJETO......: NFSe
 AUTOR........: Condez
 DATA.........: 
 UTILIZADO EM : 
 OBJETIVO.....: 

 ALTERACAO....: 
 OBJETIVO.....: 
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/
   @CodigoEmpresa numeric(4) ,
   @CodigoLocal numeric(4) ,
   @NumeroDocumento numeric(6) ,
   @DataDocumento datetime ,
   @CodigoCliFor numeric(14) ,
   @NumeroNFe numeric(15),
   @CodigoVerificacao varchar(15),
   @DataNFe datetime,
   @XMLRetorno varchar(7500),
   @NumeroLote numeric(10) = 0
AS 
DECLARE @NumeroNovoDocto numeric(6)
DECLARE @NumeroNovoDoctoStr char(6)
DECLARE @NumeroAntDoctoStr char(6)

SELECT @NumeroNovoDocto = RIGHT(CONVERT(VARCHAR(15),@NumeroNFe),6)
SELECT @NumeroNovoDoctoStr = RIGHT(CONVERT(VARCHAR(15),@NumeroNFe),6)
SELECT @NumeroAntDoctoStr = RIGHT(1000000 + CONVERT(VARCHAR(6),@NumeroDocumento),6)

UPDATE tbDocumentoRPS
SET
NumeroNFE = @NumeroNFe,
DataNFE = @DataNFe,
CodigoVerificacaoNFE = @CodigoVerificacao,
TipoRPS = 'RPS',
XMLRetorno = @XMLRetorno,
NumeroLote = @NumeroLote
WHERE 
   CodigoEmpresa = @CodigoEmpresa AND
   CodigoLocal = @CodigoLocal AND
   NumeroDocumento = @NumeroDocumento AND
   DataDocumento = @DataDocumento AND
   CodigoCliFor = @CodigoCliFor AND
   TipoLancamentoMovimentacao = 7

EXEC whAChavesDocumento @CodigoEmpresa, @CodigoLocal, 'S', @NumeroDocumento, @DataDocumento, @CodigoCliFor,7, @CodigoEmpresa, @CodigoLocal, 'S', @NumeroNovoDocto, @DataDocumento, @CodigoCliFor,7

UPDATE tbMovimentoContabil
SET NumeroDocumentoMovtoContabil = @NumeroNovoDocto,
HistoricoMovtoContabil = REPLACE(HistoricoMovtoContabil,@NumeroAntDoctoStr,@NumeroNovoDoctoStr)
WHERE
CodigoEmpresa = @CodigoEmpresa AND
DataLancamentoMovtoContabil = @DataDocumento AND
NumeroDocumentoMovtoContabil = @NumeroDocumento AND
OrigemLancamentoMovtoContabil = 'FT'

UPDATE tbDocumentoRPS
SET
NumeroDocumento = @NumeroNovoDocto
WHERE 
   CodigoEmpresa = @CodigoEmpresa AND
   CodigoLocal = @CodigoLocal AND
   NumeroDocumento = @NumeroDocumento AND
   DataDocumento = @DataDocumento AND
   CodigoCliFor = @CodigoCliFor AND
   TipoLancamentoMovimentacao = 7

UPDATE tbPedido
SET NumeroNotaFiscalPed = @NumeroNovoDocto
WHERE
CodigoEmpresa = @CodigoEmpresa AND
CodigoLocal = @CodigoLocal AND
DataEmissaoNotaFiscalPed = @DataDocumento AND
NumeroNotaFiscalPed = @NumeroDocumento

UPDATE tbOROSCIT
SET NumeroNotaFiscalOS = @NumeroNovoDocto
WHERE
CodigoEmpresa = @CodigoEmpresa AND
CodigoLocal = @CodigoLocal AND
NumeroNotaFiscalOS = @NumeroDocumento AND
DATEPART(day,DataEmissaoNotaFiscalOS) = DATEPART(day,@DataDocumento) AND
DATEPART(month,DataEmissaoNotaFiscalOS) = DATEPART(month,@DataDocumento) AND
DATEPART(year,DataEmissaoNotaFiscalOS) = DATEPART(year,@DataDocumento) 
GO

GRANT EXECUTE ON dbo.whADocumentoRPS TO SQLUsers
GO
--SQL2000