IF EXISTS (SELECT 1 FROM sysobjects WHERE id = object_id('whLRPS'))
	DROP PROCEDURE dbo.whLRPS
GO
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
EMPRESA......: T-SYSTEMS
PROJETO......: NFS-e
AUTOR........: Condez
DATA.........: 20/11/2009
OBJETIVO.....: 

whLRPS  1608, 0, '2010-03-30'
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

CREATE PROCEDURE dbo.whLRPS
	@CodigoEmpresa numeric(4) = NULL,
	@CodigoLocal numeric(4) = NULL,
    @DataImplantacao datetime
AS

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
'1990-01-01',
'',
0,
'',
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

SELECT
	tbDocumentoRPS.*,
	tbCliFor.NomeCliFor,
	COALESCE(tbPedidoOS.CodigoOrdemServicoPedidoOS,0) AS NumeroOROS

FROM 
	tbDocumentoRPS (NOLOCK)

INNER JOIN tbCliFor (NOLOCK)
ON	tbCliFor.CodigoEmpresa = tbDocumentoRPS.CodigoEmpresa
AND	tbCliFor.CodigoCliFor = tbDocumentoRPS.CodigoCliFor

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
GO
GRANT EXECUTE ON dbo.whLRPS TO SQLUsers
GO


