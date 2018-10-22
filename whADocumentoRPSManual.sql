IF EXISTS (SELECT 1 FROM sysobjects where id = object_id('whADocumentoRPSManual')) 
	DROP PROCEDURE dbo.whADocumentoRPSManual
GO
CREATE PROCEDURE dbo.whADocumentoRPSManual
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

select * from tbDocumento where NumeroDocumento = 17 and DataDocumento = '2011-03-16'
select * from tbMovimentoContabil where NumeroDocumentoMovtoContabil = 17 and DataLancamentoMovtoContabil = '2011-03-16'
whADocumentoRPS 1608,0,93,'2011-03-16',18850631804,17,'','2011-03-16','ret',0,'PROD'
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/
   @CodigoEmpresa numeric(4) ,
   @CodigoLocal numeric(4) ,
   @NumeroDocumento numeric(12) ,
   @DataDocumento datetime ,
   @CodigoCliFor numeric(14) ,
   @NumeroNFe numeric(15),
   @CodigoVerificacao varchar(50),
   @DataNFe datetime,
   @XMLRetorno varchar(7500),
   @NumeroLote numeric(10) = 0,
   @Ambiente char(4) = 'HOMO'
AS 
DECLARE @NumeroNovoDocto numeric(12)
DECLARE @NumeroNovoDoctoStr char(12)
DECLARE @NumeroAntDoctoStr char(6)
DECLARE @NRI numeric(8)

SELECT @NumeroNovoDocto = RIGHT(CONVERT(VARCHAR(15),@NumeroNFe),12)
SELECT @NumeroNovoDoctoStr = RIGHT(CONVERT(VARCHAR(15),@NumeroNFe),12)
IF LEN(@NumeroDocumento) <= 6 SELECT @NumeroAntDoctoStr = RIGHT(1000000 + CONVERT(VARCHAR(6),@NumeroDocumento),6)
IF LEN(@NumeroDocumento) = 7 SELECT @NumeroAntDoctoStr = RIGHT(10000000 + CONVERT(VARCHAR(7),@NumeroDocumento),7)
IF @NumeroAntDoctoStr IS NULL SELECT @NumeroAntDoctoStr = 999999

--- CONSISTIR MUNICIPIO PARA CONCATENAR O ANO NO NUMERO DA NFE
IF EXISTS ( SELECT 1 FROM tbLocal (NOLOCK)
            WHERE
            tbLocal.CodigoEmpresa = @CodigoEmpresa AND
            tbLocal.CodigoLocal = @CodigoLocal AND
            ( tbLocal.MunicipioLocal = 'JUIZ DE FORA' OR tbLocal.MunicipioLocal = 'BELO HORIZONTE' ) AND
            tbLocal.UFLocal = 'MG' )
BEGIN
	SELECT @NumeroNFe = CONVERT(VARCHAR(4),DATEPART(year,@DataDocumento)) + RIGHT(100000000000 + CONVERT(VARCHAR(6),@NumeroNFe),11)
END

IF EXISTS ( SELECT 1 FROM tbLocal (NOLOCK)
            WHERE
            tbLocal.CodigoEmpresa = @CodigoEmpresa AND
            tbLocal.CodigoLocal = @CodigoLocal AND
            ( tbLocal.MunicipioLocal LIKE '%VALADARES%' ) AND
            tbLocal.UFLocal = 'MG' )
BEGIN
	SELECT @NumeroNFe = 1000000 + CONVERT(NUMERIC(12),@NumeroNFe)
END

BEGIN TRANSACTION

UPDATE tbDocumentoRPS
SET
NumeroNFE = @NumeroNFe,
DataNFE = @DataDocumento,
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

IF @@error <> 0 
BEGIN
	ROLLBACK TRANSACTION
	RETURN
END

IF @Ambiente <> 'HOMO'
BEGIN

	UPDATE tbDocumento
	SET
	NumeroNFDocumento = @NumeroNovoDocto
	WHERE 
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	NumeroDocumento = @NumeroDocumento AND
	DataDocumento = @DataDocumento AND
	CodigoCliFor = @CodigoCliFor AND
	TipoLancamentoMovimentacao = 7

	IF @@error <> 0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	SELECT @NRI = NumeroControleDocFT
	FROM tbDocumentoFT (NOLOCK)
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	EntradaSaidaDocumento = 'S' AND
	NumeroDocumento = @NumeroDocumento AND
	DataDocumento = @DataDocumento AND
	CodigoCliFor = @CodigoCliFor AND
	TipoLancamentoMovimentacao = 7

	IF @@error <> 0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	SELECT * INTO #tmp FROM tbDocumentoRPS
	WHERE 
    CodigoEmpresa = @CodigoEmpresa AND
    CodigoLocal = @CodigoLocal AND
     NumeroDocumento = @NumeroDocumento AND
    DataDocumento = @DataDocumento AND
    CodigoCliFor = @CodigoCliFor AND
    TipoLancamentoMovimentacao = 7

	IF @@error <> 0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	UPDATE #tmp
	SET NumeroDocumento = @NumeroNovoDocto

	IF @@error <> 0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	INSERT tbDocumentoRPS
	SELECT * FROM #tmp

	IF @@error <> 0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	DROP TABLE #tmp

	ALTER TABLE tbDocumentoCaixa DISABLE TRIGGER tnd_DSPa_DocumentoCaixa
	
	EXEC whAChavesDocumentoRPS @CodigoEmpresa, @CodigoLocal, 'S', @NumeroDocumento, @DataDocumento, @CodigoCliFor,7, @CodigoEmpresa, @CodigoLocal, 'S', @NumeroNovoDocto, @DataDocumento, @CodigoCliFor,7

	ALTER TABLE tbDocumentoCaixa ENABLE TRIGGER tnd_DSPa_DocumentoCaixa
	
	IF @@error <> 0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	UPDATE tbMovimentoContabil
	SET NumeroDocumentoMovtoContabil = @NumeroNovoDocto,
	HistoricoMovtoContabil = REPLACE(HistoricoMovtoContabil,@NumeroAntDoctoStr,@NumeroNovoDoctoStr)
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	DataLancamentoMovtoContabil >= @DataDocumento AND
	OrigemLancamentoMovtoContabil = 'CB' AND
	NumeroDocumentoMovtoContabil = @NumeroDocumento

	IF @@error <> 0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END
	
	UPDATE tbMovimentoContabil
	SET NumeroDocumentoMovtoContabil = @NumeroNovoDocto,
	HistoricoMovtoContabil = REPLACE(HistoricoMovtoContabil,@NumeroAntDoctoStr,@NumeroNovoDoctoStr)
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	DataLancamentoMovtoContabil = @DataDocumento AND
	NumeroControleMovtoContabil = @NRI AND
	OrigemLancamentoMovtoContabil = 'FT'

	IF @@error <> 0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	DELETE tbDocumentoRPS
	WHERE 
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	NumeroDocumento = @NumeroDocumento AND
	DataDocumento = @DataDocumento AND
	CodigoCliFor = @CodigoCliFor AND
	TipoLancamentoMovimentacao = 7

	IF @@error <> 0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	UPDATE tbPedido
	SET NumeroNotaFiscalPed = @NumeroNovoDocto
	FROM tbPedidoVenda
	WHERE
	tbPedido.CodigoEmpresa = tbPedidoVenda.CodigoEmpresa AND
    tbPedido.CodigoLocal = tbPedidoVenda.CodigoLocal AND
    tbPedido.CentroCusto = tbPedidoVenda.CentroCusto AND
    tbPedido.NumeroPedido = tbPedidoVenda.NumeroPedido AND
    tbPedido.SequenciaPedido = tbPedidoVenda.SequenciaPedido AND
	tbPedido.CodigoEmpresa = @CodigoEmpresa AND
	tbPedido.CodigoLocal = @CodigoLocal AND
	tbPedido.DataEmissaoNotaFiscalPed = @DataDocumento AND
	tbPedido.NumeroNotaFiscalPed = @NumeroDocumento AND
	tbPedidoVenda.CodigoCliForFat = @CodigoCliFor

	IF @@error <> 0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	UPDATE tbOROSCIT
	SET NumeroNotaFiscalOS = @NumeroNovoDocto
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	NumeroNotaFiscalOS = @NumeroDocumento AND
	DATEPART(day,DataEmissaoNotaFiscalOS) = DATEPART(day,@DataDocumento) AND
	DATEPART(month,DataEmissaoNotaFiscalOS) = DATEPART(month,@DataDocumento) AND
	DATEPART(year,DataEmissaoNotaFiscalOS) = DATEPART(year,@DataDocumento) 

	IF @@error <> 0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	--- Recapagem

	UPDATE tbFichaControlePedidoCapa
	SET NotaFiscal = @NumeroNovoDocto
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	CodigoCliFor = @CodigoCliFor AND
	NotaFiscal = @NumeroDocumento AND
	DataNotaFiscal = @DataDocumento 

	IF @@error <> 0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	UPDATE tbFichaControleProducao
	SET NotaFiscalVenda = @NumeroNovoDocto
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	CodigoCliente = @CodigoCliFor AND
	NotaFiscalVenda = @NumeroDocumento AND
	DataNotaFiscalVenda = @DataDocumento 

	IF @@error <> 0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END
	
	---
END

COMMIT TRANSACTION

GO

GRANT EXECUTE ON dbo.whADocumentoRPSManual TO SQLUsers
GO