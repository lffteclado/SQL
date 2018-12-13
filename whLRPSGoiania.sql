/*INICIO_CABEC_PROC  
-----------------------------------------------------------------------------------------------  
EMPRESA......: T-SYSTEMS  
PROJETO......: NFS-e  
AUTOR........: Condez  
DATA.........: 20/11/2009  
OBJETIVO.....:   
  
whLRPS  1608, 0, '2012-01-09'  
  
select * from tbPedido where NumeroPedido in (66447,66448)  
-----------------------------------------------------------------------------------------------  
FIM_CABEC_PROC*/  
  
CREATE PROCEDURE dbo.whLRPSGoiania  
 @CodigoEmpresa numeric(4) = NULL,  
 @CodigoLocal numeric(4) = NULL,  
    @DataImplantacao datetime  
AS  
  
SET NOCOUNT ON   
  
--- NFs Emitidas  
  
INSERT tbDocumentoRPS  
SELECT  
tbDocumento.CodigoEmpresa,  
tbDocumento.CodigoLocal,  
tbDocumento.CodigoCliFor,  
'S',  
tbDocumento.NumeroDocumento,  
tbDocumento.DataDocumento,  
tbDocumento.TipoLancamentoMovimentacao,  
'RPS',  
tbDocumento.SerieDocumento,  
0,  
getdate(),  
'',  
0,  
'',  
0,  
0  
FROM tbDocumento (NOLOCK)  
INNER JOIN tbDocumentoFT (NOLOCK) ON  
           tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa AND  
           tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal AND  
           tbDocumentoFT.EntradaSaidaDocumento = 'S' AND  
           tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento AND  
           tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento AND  
           tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor AND  
           tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao  
WHERE  
tbDocumento.CodigoEmpresa = @CodigoEmpresa AND  
tbDocumento.CodigoLocal = @CodigoLocal AND  
tbDocumento.EntradaSaidaDocumento = 'S' AND  
tbDocumento.TipoLancamentoMovimentacao = 7 AND  
tbDocumento.DataDocumento >= @DataImplantacao AND  
tbDocumento.ValorBaseISSDocumento <> 0 AND  
tbDocumento.CondicaoNFCancelada <> 'V' AND  
NOT EXISTS ( SELECT 1 FROM tbDocumentoRPS (NOLOCK) WHERE  
             tbDocumentoRPS.CodigoEmpresa = @CodigoEmpresa AND  
             tbDocumentoRPS.CodigoLocal = @CodigoLocal AND  
             tbDocumentoRPS.EntradaSaidaDocumento = 'S' AND  
             tbDocumentoRPS.DataDocumento = tbDocumento.DataDocumento AND  
             tbDocumentoRPS.CodigoCliFor = tbDocumento.CodigoCliFor AND  
             tbDocumentoRPS.NumeroDocumento = tbDocumento.NumeroDocumento AND  
             tbDocumentoRPS.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao )  
  
--- NFs Canceladas  
/*  
UPDATE tbDocumentoRPS  
SET TipoRPS = 'CAN'  
FROM tbDocumento (NOLOCK)  
WHERE  
tbDocumentoRPS.CodigoEmpresa = tbDocumento.CodigoEmpresa AND  
tbDocumentoRPS.CodigoLocal = tbDocumento.CodigoLocal AND  
tbDocumentoRPS.EntradaSaidaDocumento = 'S' AND  
tbDocumentoRPS.NumeroDocumento = tbDocumento.NumeroDocumento AND  
tbDocumentoRPS.DataDocumento = tbDocumento.DataDocumento AND  
tbDocumentoRPS.CodigoCliFor = tbDocumento.CodigoCliFor AND  
tbDocumentoRPS.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao AND  
tbDocumento.CodigoEmpresa = @CodigoEmpresa AND  
tbDocumento.CodigoLocal = @CodigoLocal AND  
tbDocumento.EntradaSaidaDocumento = 'S' AND  
tbDocumento.CondicaoNFCancelada = 'V' AND  
tbDocumento.DataDocumento >= @DataImplantacao AND  
tbDocumento.CondicaoNFCancelada = 'V' AND  
tbDocumentoRPS.NumeroNFE <> 0  
*/  
  
---  
  
SET ROWCOUNT 1  
  
SELECT DISTINCT  
 tbDocumentoRPS.*,  
 tbCliFor.NomeCliFor,  
 COALESCE(tbPedidoOS.CodigoOrdemServicoPedidoOS,0) AS NumeroOROS,  
 CASE WHEN ( SELECT COUNT(*) FROM tbItemDocumento (NOLOCK) WHERE  
    tbItemDocumento.CodigoEmpresa = tbDocumento.CodigoEmpresa AND  
    tbItemDocumento.CodigoLocal = tbDocumento.CodigoLocal AND  
    tbItemDocumento.DataDocumento = tbDocumento.DataDocumento AND  
    tbItemDocumento.CodigoCliFor = tbDocumento.CodigoCliFor AND  
    tbItemDocumento.NumeroDocumento = tbDocumento.NumeroDocumento AND  
    tbItemDocumento.TipoLancamentoMovimentacao = 7 AND  
    tbItemDocumento.CodigoMaoObraOS IN ('ALIBA','RES') ) > 0 THEN 'V' ELSE 'F' END AS Recapagem,  
    tbDocumentoFT.CentroCusto,  
    tbCaracteristicaImpressora.CodigoImpressora,  
-- tbCaracteristicaImpressora.EnderecoRede,  
 '' as EnderecoRede,  
 tbCaracteristicaImpressora.PortaLocal  
  
FROM   
 tbDocumentoRPS (NOLOCK)  
  
INNER JOIN tbCliFor (NOLOCK)  
ON tbCliFor.CodigoEmpresa = tbDocumentoRPS.CodigoEmpresa  
AND tbCliFor.CodigoCliFor = tbDocumentoRPS.CodigoCliFor  
  
INNER JOIN tbDocumento (NOLOCK) ON  
           tbDocumento.CodigoEmpresa = @CodigoEmpresa AND  
           tbDocumento.CodigoLocal = @CodigoLocal AND  
           tbDocumento.EntradaSaidaDocumento = 'S' AND  
           tbDocumento.NumeroDocumento = tbDocumentoRPS.NumeroDocumento AND  
           tbDocumento.DataDocumento = tbDocumentoRPS.DataDocumento AND  
           tbDocumento.CodigoCliFor = tbDocumentoRPS.CodigoCliFor AND  
           tbDocumento.TipoLancamentoMovimentacao = tbDocumentoRPS.TipoLancamentoMovimentacao  
  
INNER JOIN tbDocumentoFT (NOLOCK) ON  
           tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND  
           tbDocumentoFT.CodigoLocal = @CodigoLocal AND  
           tbDocumentoFT.EntradaSaidaDocumento = 'S' AND  
           tbDocumentoFT.NumeroDocumento = tbDocumentoRPS.NumeroDocumento AND  
           tbDocumentoFT.DataDocumento = tbDocumentoRPS.DataDocumento AND  
           tbDocumentoFT.CodigoCliFor = tbDocumentoRPS.CodigoCliFor AND  
           tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumentoRPS.TipoLancamentoMovimentacao  
  
LEFT JOIN tbPedidoOS (NOLOCK) ON  
          tbPedidoOS.CodigoEmpresa = @CodigoEmpresa AND  
          tbPedidoOS.CodigoLocal = @CodigoLocal AND  
          tbPedidoOS.CentroCusto = tbDocumentoFT.CentroCusto AND  
          tbPedidoOS.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND  
          tbPedidoOS.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento  
  
LEFT JOIN tbUsuarioDocumento (NOLOCK) ON  
          tbUsuarioDocumento.CodigoEmpresa = @CodigoEmpresa AND  
          tbUsuarioDocumento.CodigoLocal = @CodigoLocal AND  
          tbUsuarioDocumento.EntradaSaidaDocumento = 'S' AND  
          tbUsuarioDocumento.NumeroDocumento = tbDocumentoRPS.NumeroDocumento AND  
          tbUsuarioDocumento.DataDocumento = tbDocumentoRPS.DataDocumento AND  
          tbUsuarioDocumento.CodigoCliFor = tbDocumentoRPS.CodigoCliFor AND  
          tbUsuarioDocumento.TipoLancamentoMovimentacao IN (7,13)  
  
LEFT JOIN tbFormularioDoctoUsuarioFT (NOLOCK) ON  
          tbFormularioDoctoUsuarioFT.CodigoEmpresa = @CodigoEmpresa AND  
          tbFormularioDoctoUsuarioFT.CodigoUsuario = tbUsuarioDocumento.CodigoUsuario AND  
          tbFormularioDoctoUsuarioFT.TipoFormulario = 'DANF'  
  
LEFT JOIN tbCaracteristicaImpressora (NOLOCK) ON  
          tbCaracteristicaImpressora.CodigoImpressora =  tbFormularioDoctoUsuarioFT.CodigoImpressora            
  
WHERE   
 tbDocumentoRPS.CodigoEmpresa = @CodigoEmpresa AND  
    tbDocumentoRPS.CodigoLocal = @CodigoLocal AND  
 tbDocumentoRPS.DataDocumento >= @DataImplantacao AND  
    tbDocumentoRPS.NumeroNFE = 0 AND  
 tbDocumento.CondicaoNFCancelada <> 'V'    
  
ORDER BY  
 tbDocumentoRPS.NumeroLote,  
 tbDocumentoRPS.NumeroDocumento,  
 tbDocumentoRPS.DataDocumento  
  
SET ROWCOUNT 0  
  
SET NOCOUNT OFF  
  