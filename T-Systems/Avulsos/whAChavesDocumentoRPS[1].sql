IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('dbo.whAChavesDocumentoRPS'))
DROP PROCEDURE dbo.whAChavesDocumentoRPS
GO
CREATE PROCEDURE dbo.whAChavesDocumentoRPS
/*
INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------------
 EMPRESA......: CDC - Consulters/Humaita
 PROJETO......: Livros Fiscais
 AUTOR........: Fabiane
 DATA.........: 06/07/1999
 UTILIZADO EM : clsDocumento.AtualizarChavesDocumento

 OBJETIVO.....: Atualizar campos chaves do Documento

 whAChavesDocumento 1580, 0, 'E', 155417,'1999-11-08',6666,9,1580,0,'E',155416, '1999-11-08', 6666, 9 

 ALTERACAO....: Edvaldo Ragassi - 17/08/2007
 OBJETIVO.....: Nao permitir DataDocumento inferior a DataEmissaoDocumento
		Retirar EntradaSaidaDocumento da consistencia, afim de considerar os documentos
		espelhos de devolucao (Vendas/Compras), alem de evitar alteracao do campo EntradaSaida
------------------------------------------------------------------------------------------------------
FIM_CABEC_PROC
*/

@CodEmpresaAnt		numeric(4),
@CodLocalAnt		numeric(4),
@EntradaSaidaAnt	char(1),
@NumeroDocumentoAnt	numeric(6),
@DataDocumentoAnt	datetime,
@CodigoCliForAnt	numeric(14),
@TipoLancamentoAnt	numeric(2),
@CodEmpresaAtual	numeric(4),
@CodLocalAtual		numeric(4),
@EntradaSaidaAtual	char(1),
@NumeroDocumentoAtual	numeric(6),
@DataDocumentoAtual	datetime,
@CodigoCliForAtual	numeric(14),
@TipoLancamentoAtual	numeric(2)


WITH ENCRYPTION
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- Inicio do Processamento --
IF NOT EXISTS (	SELECT 1 FROM tbDocumento (NOLOCK)
		WHERE 	CodigoEmpresa 			= @CodEmpresaAnt and
			CodigoLocal 			= @CodLocalAnt and
			EntradaSaidaDocumento 		= @EntradaSaidaAnt and
			NumeroDocumento 		= @NumeroDocumentoAnt and
			DataDocumento 			= @DataDocumentoAnt and
			CodigoCliFor 			= @CodigoCliForAnt and
			TipoLancamentoMovimentacao	= @TipoLancamentoAnt )
BEGIN
  SELECT 'NAO EXISTE DOCUMENTO A SER ALTERADO NO SISTEMA...'
  RETURN
END

DECLARE @blnExisteAvisoPag char(1)
select @blnExisteAvisoPag = 'V'

IF EXISTS (	SELECT 1 FROM tbDocumento (NOLOCK)
		WHERE 	CodigoEmpresa 			= @CodEmpresaAtual and
			CodigoLocal 			= @CodLocalAtual and
			EntradaSaidaDocumento 		= @EntradaSaidaAtual and
			NumeroDocumento 		= @NumeroDocumentoAtual and
			DataDocumento 			= @DataDocumentoAtual and
			CodigoCliFor 			= @CodigoCliForAtual and
			TipoLancamentoMovimentacao	= @TipoLancamentoAtual	)
BEGIN
  SELECT 'JA EXISTE DOCUMENTO COM DADOS ATUAIS NO SISTEMA...'
  RETURN
END

-- Definição de Variaveis

DECLARE @NumeroVeiculoCV numeric(8)

-- Cria novo registro --

BEGIN TRANSACTION

-- tbDocumento
SELECT 	*
INTO #tbDocumento_tmp 
FROM tbDocumento (NOLOCK)
WHERE 	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbDocumento_tmp) GOTO cont_tbDocumento
UPDATE #tbDocumento_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbDocumento SELECT * FROM #tbDocumento_tmp

IF @@ERROR <> 0
BEGIN 
	ROLLBACK TRANSACTION
	RETURN
END

cont_tbDocumento:
DROP TABLE #tbDocumento_tmp

-- tbComissaoDocumento
SELECT 	*
INTO #tbComissaoDocum_tmp 
FROM tbComissaoDocumento (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS 	(SELECT 1 from #tbComissaoDocum_tmp) GOTO cont_tbComissaoDocum
UPDATE #tbComissaoDocum_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbComissaoDocumento SELECT * FROM #tbComissaoDocum_tmp

cont_tbComissaoDocum:
DROP TABLE #tbComissaoDocum_tmp

-- tbDocumentoTextos
SELECT 	*
INTO #tbDocumentoTextos_tmp 
FROM tbDocumentoTextos (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS 	(SELECT 1 from #tbDocumentoTextos_tmp) GOTO cont_tbDocumentoTextos
UPDATE #tbDocumentoTextos_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbDocumentoTextos SELECT * FROM #tbDocumentoTextos_tmp

cont_tbDocumentoTextos:
DROP TABLE #tbDocumentoTextos_tmp

-- tbDocumentoEmpenho
SELECT 	*
INTO #tbDocumentoEmpenho_tmp 
FROM tbDocumentoEmpenho (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS 	(SELECT 1 from #tbDocumentoEmpenho_tmp) GOTO cont_tbDocumentoEmpenho
UPDATE #tbDocumentoEmpenho_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbDocumentoEmpenho SELECT * FROM #tbDocumentoEmpenho_tmp

cont_tbDocumentoEmpenho:
DROP TABLE #tbDocumentoEmpenho_tmp

-- tbContratoCDCI
SELECT 	*
INTO #tbContratoCDCI_tmp 
FROM tbContratoCDCI (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbContratoCDCI_tmp) GOTO cont_tbContratoCDCI
UPDATE #tbContratoCDCI_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbContratoCDCI SELECT * FROM #tbContratoCDCI_tmp

cont_tbContratoCDCI:
DROP TABLE #tbContratoCDCI_tmp

-- tbParcelaCDCI
SELECT 	*
INTO #tbParcelaCDCI_tmp 
FROM tbParcelaCDCI (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbParcelaCDCI_tmp) GOTO cont_tbParcelaCDCI
UPDATE #tbParcelaCDCI_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbParcelaCDCI SELECT * FROM #tbParcelaCDCI_tmp

cont_tbParcelaCDCI:
DROP TABLE #tbParcelaCDCI_tmp

-- tbDoctoRecPag
SELECT 	*
INTO #tbDoctoRecPag_tmp 
FROM tbDoctoRecPag (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbDoctoRecPag_tmp) GOTO cont_tbDoctoRecPag
UPDATE #tbDoctoRecPag_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbDoctoRecPag SELECT * FROM #tbDoctoRecPag_tmp

cont_tbDoctoRecPag:
DROP TABLE #tbDoctoRecPag_tmp

-- tbDoctoReceber
SELECT 	*
INTO #tbDoctoReceber_tmp 
FROM tbDoctoReceber (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbDoctoReceber_tmp) GOTO cont_tbDoctoReceber
UPDATE #tbDoctoReceber_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbDoctoReceber SELECT * FROM #tbDoctoReceber_tmp

cont_tbDoctoReceber:
DROP TABLE #tbDoctoReceber_tmp

-- tbDoctoReceberRepresentante
SELECT 	*
INTO #tbDoctoReceberR_tmp 
FROM tbDoctoReceberRepresentante (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbDoctoReceberR_tmp) GOTO cont_tbDoctoReceberR
UPDATE #tbDoctoReceberR_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbDoctoReceberRepresentante SELECT * FROM #tbDoctoReceberR_tmp

cont_tbDoctoReceberR:
DROP TABLE #tbDoctoReceberR_tmp

-- tbDoctoRecPagComplementar
SELECT 	*
INTO #tbDoctoRecPagCo_tmp 
FROM tbDoctoRecPagComplementar (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbDoctoRecPagCo_tmp) GOTO cont_tbDoctoRecPagCo
UPDATE #tbDoctoRecPagCo_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbDoctoRecPagComplementar SELECT * FROM #tbDoctoRecPagCo_tmp

cont_tbDoctoRecPagCo:
DROP TABLE #tbDoctoRecPagCo_tmp

-- tbDocumentoPagar
SELECT 	*
INTO #tbDocumentoPaga_tmp 
FROM tbDocumentoPagar (NOLOCK)
WHERE
	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbDocumentoPaga_tmp) GOTO cont_tbDocumentoPaga
UPDATE #tbDocumentoPaga_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbDocumentoPagar SELECT * FROM #tbDocumentoPaga_tmp

cont_tbDocumentoPaga:
DROP TABLE #tbDocumentoPaga_tmp

-- tbHistoricoOcorrencia
SELECT 	*
INTO #tbHistoricoOcor_tmp 
FROM tbHistoricoOcorrencia (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbHistoricoOcor_tmp) GOTO cont_tbHistoricoOcor
UPDATE #tbHistoricoOcor_tmp
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbHistoricoOcorrencia SELECT * FROM #tbHistoricoOcor_tmp

cont_tbHistoricoOcor:
DROP TABLE #tbHistoricoOcor_tmp

-- tbParcelaDocto
SELECT	*
INTO #tbParcelaDocto_tmp 
FROM tbParcelaDocto (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbParcelaDocto_tmp) GOTO cont_tbParcelaDocto
IF NOT EXISTS (SELECT 1 FROM #tbParcelaDocto_tmp INNER JOIN tbAvisoPagamento ON
			#tbParcelaDocto_tmp.CodigoEmpresa			= tbAvisoPagamento.CodigoEmpresa
			AND #tbParcelaDocto_tmp.CodigoLocal			= tbAvisoPagamento.CodigoLocal
			AND #tbParcelaDocto_tmp.TipoAvisoPagamento		= tbAvisoPagamento.TipoAvisoPagamento
			AND #tbParcelaDocto_tmp.ClassificacaoAvisoPagamento 	= tbAvisoPagamento.ClassificacaoAvisoPagamento
			AND #tbParcelaDocto_tmp.NumeroAvisoPagamento 		= tbAvisoPagamento.NumeroAvisoPagamento)  
BEGIN
	SELECT	@blnExisteAvisoPag ='F'
	INSERT tbAvisoPagamento
		(CodigoEmpresa,
		CodigoLocal,
		TipoAvisoPagamento,
		ClassificacaoAvisoPagamento,
		NumeroAvisoPagamento,
		DataAvisoPagamento,
		ValorAvisoPagamento,
		ValorLancadoAvisoPagamento,
		ValorBatidoAvisoPagamento,
		TextoHistoricoAvisoPagamento,
		CodigoSistema,
		CodigoTexto,
		CodigoBanco,
		CodigoAgencia,
		ContaCorrente)
	SELECT 	#tbParcelaDocto_tmp.CodigoEmpresa,
		#tbParcelaDocto_tmp.CodigoLocal,
		#tbParcelaDocto_tmp.TipoAvisoPagamento,
		#tbParcelaDocto_tmp.ClassificacaoAvisoPagamento,
		#tbParcelaDocto_tmp.NumeroAvisoPagamento,
		getdate(),
		1,
		1,
		'F',
		'Temporario',
		Null,
		Null,
		#tbParcelaDocto_tmp.CodigoBanco,
		#tbParcelaDocto_tmp.CodigoAgencia,
		MIN(tbContaCorrente.ContaCorrente)
	FROM 	#tbParcelaDocto_tmp
		INNER JOIN tbContaCorrente ON
			#tbParcelaDocto_tmp.CodigoBanco		= tbContaCorrente.CodigoBanco	
			AND #tbParcelaDocto_tmp.CodigoAgencia	= tbContaCorrente.CodigoAgencia
	GROUP BY 
		#tbParcelaDocto_tmp.CodigoEmpresa,
		#tbParcelaDocto_tmp.CodigoLocal,
		#tbParcelaDocto_tmp.TipoAvisoPagamento,
		#tbParcelaDocto_tmp.ClassificacaoAvisoPagamento,
		#tbParcelaDocto_tmp.NumeroAvisoPagamento,
		#tbParcelaDocto_tmp.CodigoBanco,
		#tbParcelaDocto_tmp.CodigoAgencia
END
UPDATE #tbParcelaDocto_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbParcelaDocto SELECT * FROM #tbParcelaDocto_tmp

IF @blnExisteAvisoPag = 'F' 
	BEGIN
		DELETE FROM tbAvisoPagamento from #tbParcelaDocto_tmp INNER JOIN tbAvisoPagamento ON
			#tbParcelaDocto_tmp.CodigoEmpresa			= tbAvisoPagamento.CodigoEmpresa
			AND #tbParcelaDocto_tmp.CodigoLocal			= tbAvisoPagamento.CodigoLocal
			AND #tbParcelaDocto_tmp.TipoAvisoPagamento		= tbAvisoPagamento.TipoAvisoPagamento
			AND #tbParcelaDocto_tmp.ClassificacaoAvisoPagamento 	= tbAvisoPagamento.ClassificacaoAvisoPagamento
			AND #tbParcelaDocto_tmp.NumeroAvisoPagamento		= tbAvisoPagamento.NumeroAvisoPagamento	
	END

cont_tbParcelaDocto:
DROP TABLE #tbParcelaDocto_tmp

-- tbDocumentoFT
SELECT	*
INTO #tbDocumentoFT_tmp 
FROM tbDocumentoFT (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbDocumentoFT_tmp) GOTO cont_tbDocumentoFT
UPDATE #tbDocumentoFT_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbDocumentoFT SELECT * FROM #tbDocumentoFT_tmp

cont_tbDocumentoFT:
DROP TABLE #tbDocumentoFT_tmp

-- tbDocumentoCV
SELECT	*
INTO #tbDocumentoCV_tmp 
FROM tbDocumentoCV (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbDocumentoCV_tmp) GOTO cont_tbDocumentoCV
UPDATE #tbDocumentoCV_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbDocumentoCV SELECT * FROM #tbDocumentoCV_tmp

cont_tbDocumentoCV:
DROP TABLE #tbDocumentoCV_tmp

-- tbItemDocumento
SELECT 	*
INTO #tbItemDocumento_tmp 
FROM tbItemDocumento (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbItemDocumento_tmp) GOTO cont_tbItemDocumento
UPDATE #tbItemDocumento_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbItemDocumento SELECT * FROM #tbItemDocumento_tmp

cont_tbItemDocumento:
DROP TABLE #tbItemDocumento_tmp

-- tbItemDocumentoFT
SELECT	*
INTO #tbItemDoctoFT_tmp 
FROM tbItemDocumentoFT (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbItemDoctoFT_tmp) GOTO cont_tbItemDoctoFT
UPDATE #tbItemDoctoFT_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbItemDocumentoFT SELECT * FROM #tbItemDoctoFT_tmp

cont_tbItemDoctoFT:
DROP TABLE #tbItemDoctoFT_tmp

-- tbItemDocumentoTextos
SELECT	*
INTO #tbItemDocumentoTextos_tmp 
FROM tbItemDocumentoTextos (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbItemDocumentoTextos_tmp) GOTO cont_tbItemDocumentoTextos
UPDATE #tbItemDocumentoTextos_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbItemDocumentoTextos SELECT * FROM #tbItemDocumentoTextos_tmp

cont_tbItemDocumentoTextos:
DROP TABLE #tbItemDocumentoTextos_tmp

-- tbNotaCTRCEntrada
SELECT	*
INTO #tbNotaCTRCEntra_tmp 
FROM tbNotaCTRCEntrada (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbNotaCTRCEntra_tmp) GOTO cont_tbNotaCTRCEntra
UPDATE #tbNotaCTRCEntra_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbNotaCTRCEntrada SELECT * FROM #tbNotaCTRCEntra_tmp

cont_tbNotaCTRCEntra:
DROP TABLE #tbNotaCTRCEntra_tmp

-- tbNotaFatura
SELECT 	*
INTO #tbNotaFatura_tmp 
FROM tbNotaFatura (NOLOCK)
WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
	CodigoLocal 			= @CodLocalAnt and
-- 	EntradaSaidaDocumento 		= @EntradaSaidaAnt and
	NumeroDocumento 		= @NumeroDocumentoAnt and
	DataDocumento 			= @DataDocumentoAnt and
	CodigoCliFor 			= @CodigoCliForAnt and
	TipoLancamentoMovimentacao	= @TipoLancamentoAnt
IF NOT EXISTS (SELECT 1 FROM #tbNotaFatura_tmp) GOTO cont_tbNotaFatura
UPDATE #tbNotaFatura_tmp 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual

INSERT tbNotaFatura SELECT * FROM #tbNotaFatura_tmp

cont_tbNotaFatura:
DROP TABLE #tbNotaFatura_tmp

-- *******************************************************
-- Alteracao de registros nao pk --
-----------------------------------
-- tbPedidoComplementar
UPDATE tbPedidoComplementar 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbProgramacaoContato
UPDATE tbProgramacaoContato 
	SET 	CodigoEmpresa 			= @CodEmpresaAtual,
		CodigoLocal 			= @CodLocalAtual,
		EntradaSaidaDocumento 		= @EntradaSaidaAtual,
		NumeroDocumento 		= @NumeroDocumentoAtual,
		DataDocumento 			= @DataDocumentoAtual,
		CodigoCliForDocto		= @CodigoCliForAtual,
		CodigoCliFor 			= @CodigoCliForAtual,
		TipoLancamentoMovimentacao	= @TipoLancamentoAtual
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt


-- tbDoctoRecPag
----  Atualiza o Documento no Veiculo  ----------

SELECT @NumeroVeiculoCV = 0

SELECT @NumeroVeiculoCV = (SELECT MIN(NumeroVeiculoCV)
			        FROM tbItemDocumento (NOLOCK)
				WHERE 	CodigoEmpresa 			= @CodEmpresaAtual and
					CodigoLocal 			= @CodLocalAtual and
					EntradaSaidaDocumento 		= @EntradaSaidaAtual and
					NumeroDocumento 		= @NumeroDocumentoAtual and
					DataDocumento 			= @DataDocumentoAtual and
					CodigoCliFor 			= @CodigoCliForAtual and
					TipoLancamentoMovimentacao	= @TipoLancamentoAtual	)

IF @NumeroVeiculoCV <> 0 
BEGIN
   IF @EntradaSaidaAtual = 'E' 
   BEGIN
     UPDATE tbVeiculoCV
     SET NumeroNotaFiscalEntradaVeic = @NumeroDocumentoAtual,
         DataEntradaVeiculoCV = @DataDocumentoAtual,
		 FornecedorCV = @CodigoCliForAtual
     WHERE CodigoEmpresa = @CodEmpresaAnt
     AND   CodigoLocal = @CodLocalAnt
     AND   NumeroVeiculoCV = @NumeroVeiculoCV
   END
   ELSE
     UPDATE tbVeiculoCV
     SET NumeroNotaFiscalVendaCV= @NumeroDocumentoAtual,
         DataNotaFiscalVendaCV= @DataDocumentoAtual,
	 DataVendaVeic = @DataDocumentoAtual
     WHERE CodigoEmpresa   = @CodEmpresaAnt
     AND   CodigoLocal     = @CodLocalAnt
     AND   NumeroVeiculoCV = @NumeroVeiculoCV
END

--  FIM Atualiza o Documento no Veiculo  ------

-- tbDocumentoRPS --- não tem FK, sendo assim pode fazer Update direto

DECLARE @NumeroNFE NUMERIC(15)

SELECT @NumeroNFE = @NumeroDocumentoAtual
IF EXISTS ( SELECT 1 FROM tbLocal (NOLOCK)
            WHERE CodigoEmpresa = @CodEmpresaAnt AND
                  CodigoLocal = @CodLocalAnt AND
				  UFLocal = 'MG' AND
                  RTRIM(LTRIM(MunicipioLocal)) = 'BELO HORIZONTE' )
BEGIN
	--- Em belo horizonte, o numero da NFE tem o ANO
	SELECT @NumeroNFE = CONVERT(VARCHAR(4),DATEPART(YEAR,@DataDocumentoAtual)) + RIGHT(100000000000 + @NumeroDocumentoAtual,11)
END 
 
-- fim tbDocumentoRPS

------------------------------
-- Exclusao de registros pk --
------------------------------
-- tbNotaFatura
DELETE tbNotaFatura 
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbNotaCTRCEntrada
DELETE tbNotaCTRCEntrada 
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbItemDocumentoFT
DELETE tbItemDocumentoFT 
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbDocumentoFT
DELETE tbDocumentoFT 
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbDocumentoCV
DELETE tbDocumentoCV 
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbItemDocumento
DELETE tbItemDocumento 
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbParcelaDocto
DELETE tbParcelaDocto
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbHistoricoOcorrencia
DELETE tbHistoricoOcorrencia 
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbDocumentoPagar
DELETE tbDocumentoPagar
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbDoctoRecPagComplementar
DELETE tbDoctoRecPagComplementar 
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbDoctoReceberRepresentante
DELETE tbDoctoReceberRepresentante 
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbDoctoReceber
DELETE tbDoctoReceber 
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbDoctoRecPag
DELETE tbDoctoRecPag 
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbParcelaCDCI
DELETE tbParcelaCDCI 
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbContratoCDCI
DELETE tbContratoCDCI 
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbComissaoDocumento
DELETE tbComissaoDocumento 
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbDocumentoEmpenho
DELETE tbDocumentoEmpenho
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

-- tbDocumento
DELETE tbDocumento 
	WHERE	CodigoEmpresa 			= @CodEmpresaAnt and
		CodigoLocal 			= @CodLocalAnt and
-- 		EntradaSaidaDocumento 		= @EntradaSaidaAnt and
		NumeroDocumento 		= @NumeroDocumentoAnt and
		DataDocumento 			= @DataDocumentoAnt and
		CodigoCliFor 			= @CodigoCliForAnt and
		TipoLancamentoMovimentacao	= @TipoLancamentoAnt

IF @@ERROR <> 0
BEGIN 
	ROLLBACK TRANSACTION
	SELECT 'HOUVE ERRO NA ATUALIZACAO...'
	RETURN
END


COMMIT TRANSACTION
SELECT 'FIM DA ATUALIZACAO...'


SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whAChavesDocumento TO SQLUsers
GO
