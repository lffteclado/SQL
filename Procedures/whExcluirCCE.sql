Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.whExcluirCCE

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------  
EMPRESA......: T-SYSTEMS  
PROJETO......: NFE  
AUTOR........: Talita 
DATA.........: 22/06/2012
OBJETIVO.....: Excluir notas com status CCE

whExcluirPEN 1608,0,'S',50238,'2010-09-01 00:00:00.000',31108819850,7,'CCE'
-----------------------------------------------------------------------------------------------  
FIM_CABEC_PROC*/  

@CodigoEmpresa dtInteiro04, 
@CodigoLocal dtInteiro04, 
@EntradaSaidaDocumento dtCharacter01,  
@NumeroDocumento numeric(12), 
@DataDocumento datetime, 
@CodigoCliFor numeric(14), 
@TipoLancamentoMovimentacao dtInteiro02,
@StatusNFe char(3)

AS  
  
ALTER TABLE tbDocumentoNFe DISABLE TRIGGER tnd_DSPa_DocumentoNFe

DELETE tbDocumentoNFe
WHERE CodigoEmpresa = @CodigoEmpresa
  AND CodigoLocal = @CodigoLocal
  AND EntradaSaidaDocumento = @EntradaSaidaDocumento
  AND NumeroDocumento = @NumeroDocumento
  AND DataDocumento = @DataDocumento 
  AND CodigoCliFor = @CodigoCliFor
  AND TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao
  AND StatusNFe = @StatusNFe

ALTER TABLE tbDocumentoNFe ENABLE TRIGGER tnd_DSPa_DocumentoNFe

DELETE tbDocumentoCCe
WHERE CodigoEmpresa = @CodigoEmpresa
  AND CodigoLocal = @CodigoLocal
  AND EntradaSaidaDocumento = @EntradaSaidaDocumento
  AND NumeroDocumento = @NumeroDocumento
  AND DataDocumento = @DataDocumento 
  AND CodigoCliFor = @CodigoCliFor
  AND TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao



