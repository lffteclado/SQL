IF EXISTS (SELECT 1 FROM sysobjects where id = object_id('whADocumentoRPSLote')) 
	DROP PROCEDURE dbo.whADocumentoRPSLote
GO
CREATE PROCEDURE dbo.whADocumentoRPSLote
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
   @CodigoCliFor numeric(14),
   @NumeroLote numeric(10) = 0
AS 

UPDATE tbDocumentoRPS
SET
NumeroLote = @NumeroLote
WHERE 
   CodigoEmpresa = @CodigoEmpresa AND
   CodigoLocal = @CodigoLocal AND
   NumeroDocumento = @NumeroDocumento AND
   DataDocumento = @DataDocumento AND
   CodigoCliFor = @CodigoCliFor AND
   TipoLancamentoMovimentacao = 7

GO
GRANT EXECUTE ON dbo.whADocumentoRPSLote TO SQLUsers
GO
--SQL2000