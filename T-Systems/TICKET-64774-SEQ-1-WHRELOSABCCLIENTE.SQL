/*
whRelOSABCCliente 
@CodigoEmpresa = 1608, @CodigoLocal = 0, @DataEncerramentoDe = '2009-03-01', @DataEncerramentoAte = '2009-03-31',
@CentroCustoInicial = 1, @CentroCustoFinal = 99999999,
-- SERVICOS
--@SomenteLinhaProdPecasOrig = 'F', @ImprimePECCLO = 'F', @ImprimeMOB = 'V', @SelecionaOS = 'V', @SelecionaFT = 'F', @SelecionaTK = 'F'
-- SERVICOS sem selecionar MOB
@SomenteLinhaProdPecasOrig = 'F', @ImprimePECCLO = 'F', @ImprimeMOB = 'V', @SelecionaOS = 'F', @SelecionaFT = 'F', @SelecionaTK = 'F'
-- PECAS
--@SomenteLinhaProdPecasOrig = 'F', @ImprimePECCLO = 'V', @ImprimeMOB = 'F', @SelecionaOS = 'V', @SelecionaFT = 'V', @SelecionaTK = 'V'
*/


go
if exists (select * from sysobjects where name = 'whRelOSABCCliente') begin
	drop PROCEDURE dbo.whRelOSABCCliente
end
go
CREATE PROCEDURE dbo.whRelOSABCCliente
/* INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: Controle de Oficina - StarClass
 AUTOR........: Marcio Schvartz
 DATA.........: 19/07/2010
 OBJETIVO.....: 

whRelOSABCCliente 1608, 0, '2010-01-01', '2010-03-31',0,99999999, 'V', 'V','F', 'F', 'F', 'F' -- Pecas Originais + PEC + CLO
whRelOSABCCliente 1608, 0, '2010-01-01', '2010-03-31',0,99999999, 'V', 'V','F', 'V', 'F', 'F' -- Pecas Originais + PEC + CLO
whRelOSABCCliente 1608, 0, '2010-01-01', '2010-03-31',0,99999999, 'V', 'V','F', 'V', 'V', 'F' -- Pecas Originais + PEC + CLO
whRelOSABCCliente 1608, 0, '2010-01-01', '2010-03-31',0,99999999, 'V', 'V','F', 'F', 'V', 'V' -- Pecas Originais + PEC + CLO
whRelOSABCCliente 1608, 0, '2010-01-01', '2010-07-31',0,99999999, 'F', 'V','F'	-- Somente PEC/CLO
whRelOSABCCliente 1608, 0, '2010-01-01', '2010-07-10',0,99999999, 'F', 'F','V'	-- Somente MOB

whRelOSABCCliente 1608, 0, '2010-01-01', '2010-07-10',0,99999999, 'F', 'F','V','V','F','F'	-- Somente MOB

whRelOSABCCliente 1608, 0, '2010-01-01', '2010-12-31', 11310, 11310, 'F', 'V','F'	-- Somente PEC/CLO

-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC */

@CodigoEmpresa				dtInteiro04, 
@CodigoLocal				dtInteiro04, 
@DataEncerramentoDe			DateTime,
@DataEncerramentoAte		DateTime,
@CentroCustoInicial			numeric(08),
@CentroCustoFinal			numeric(08),
@SomenteLinhaProdPecasOrig	char(1)	= 'F',
@ImprimePECCLO				char(1) = 'F',
@ImprimeMOB					char(1) = 'F',
@SelecionaOS				char(1) = 'V',
@SelecionaFT				char(1) = 'V',
@SelecionaTK				char(1) = 'V'

AS

SET nocount On

declare @CodigoCliFor			numeric(14)
declare @QtdFrota				numeric(10)
declare @OrdemFrota				numeric(10)
declare @ValorFaturamento		numeric(19,2)
declare @QtdPassagensOficina	numeric(10)
declare @TicketMedio			numeric(16,2)
declare @Contador				numeric(10)


-- Se não selecionou nenhum tipo de Relatorio (SERVICOS / PEÇAS), erro...
IF @ImprimePECCLO = 'F' and @ImprimeMOB = 'F' BEGIN
	RAISERROR 70321 'É obrigatório selecionar se imprime Peças ou Serviços.'
	return 0
end

-- Se Relatorio de SERVICOS e não selecionou Sistema de OFICINA, forçar OFICINA
IF @ImprimeMOB = 'V' and @SelecionaOS = 'F' BEGIN
	select @SelecionaOS = 'V'
END

-- Se não selecionou nenhum Sistema, erro...
IF @SelecionaOS = 'F' and @SelecionaFT = 'F' and @SelecionaTK = 'F' BEGIN
	RAISERROR 70321 'É obrigatório selecionar a área (OS / FT / TK).'
	return 0
end



-----------------------------------------------------------------------------------------
-- Criar tabela temporaria
-----------------------------------------------------------------------------------------
SELECT  CodigoCliFor = convert(numeric(14), 0), 
		NomeCliFor = space(60) ,
        TipoItemOS = ' ',
		NumeroOROS = 0,

		ValorFaturamento = tbItemOROS.ValorLiquidoInvisivelItemOS, 
		PercParticipacaoFaturamento = convert(numeric(6,2), 0),
		PercParticipacaoFaturamentoAcumulado = convert(numeric(6,2), 0),
		OrdemFaturamento = 0, 
		ABCFaturamento = 'X',

		QtdPassagensOficina = 0,
		PercParticipacaoPassagens = convert(numeric(6,2), 0),
		PercParticipacaoPassagensAcumulado = convert(numeric(6,2), 0),
		OrdemPassagens = 0, 
		ABCPassagens = 'X',

		TicketMedio = tbItemOROS.ValorLiquidoInvisivelItemOS, 
		PercParticipacaoTicketMedio = convert(numeric(6,2), 0),
		PercParticipacaoTicketMedioAcumulado = convert(numeric(6,2), 0),
		OrdemTicketMedio = 0, 
		ABCTicketMedio = 'X',

		QtdFrota = 0, 
		PercParticipacaoFrota = convert(numeric(6,2), 0),
		PercParticipacaoFrotaAcumulado = convert(numeric(6,2), 0),
		OrdemFrota = 0, 
		ABCFrota = 'X',

		ABCGeralServicos = 'XXX', 
		ABCGeralPecas = 'XX', 

		CodigoLinhaProduto = null ,
		TipoLinhaProduto = null , 
		CodigoProduto = space(30), 
		CodigoProdutoItemOROS = space(30)

INTO	#tmp1
from tbItemOROS (nolock)
where 1 = 2

-----------------------------------------------------------------------------------------
-- Inserir dados da OS
-----------------------------------------------------------------------------------------
if (@ImprimeMOB = 'V' and  @SelecionaOS = 'V') or (@ImprimePECCLO = 'V' and @SelecionaOS = 'V') begin
	insert INTO	#tmp1

	SELECT  cf.CodigoCliFor, 
			cf.NomeCliFor,
			tbOROSCITTipo.TipoItemOS,
			tbOROS.NumeroOROS,
			ValorFaturamento =	COALESCE(CASE WHEN tbItemOROS.ValorLiquidoInvisivelItemOS <> 0 
	  								  THEN (COALESCE(tbItemOROS.ValorLiquidoInvisivelItemOS, 0))
		 							  ELSE CASE WHEN tbItemOROS.ValorDescontoRateadoItemOROS <> 0
									  THEN (COALESCE(tbItemOROS.ValorBrutoItemOS - tbItemOROS.ValorDescontoRateadoItemOROS,0))
									  ELSE (tbItemOROS.ValorLiquidoItemOS)
									  END
								END , 0),
			PercParticipacaoFaturamento = 0, 
			PercParticipacaoFaturamentoAcumulado = 0,
			OrdemFaturamento = 0,
			ABCFaturamento = 'X',

			QtdPassagensOficina = 0,
			PercParticipacaoPassagens = 0,
			PercParticipacaoPassagensAcumulado = 0,
			OrdemPassagens = 0,
			ABCPassagens = 'X',

			TicketMedio = 0,
			PercParticipacaoTicketMedio = 0,
			PercParticipacaoTicketMedioAcumulado = 0,
			OrdemTicketMedio = 0,
			ABCTicketMedio = 'X',

			QtdFrota = 0,
			PercParticipacaoFrota = 0,
			PercParticipacaoFrotaAcumulado = 0,
			OrdemFrota = 0,
			ABCFrota = 'X',

			ABCGeralServicos = 'XXX',
			ABCGeralPecas = 'XX',
			tbLinhaProduto.CodigoLinhaProduto,
			tbLinhaProduto.TipoLinhaProduto,
			tbProdutoFT.CodigoProduto,
			tbItemProdOROS.CodigoProdutoItemOROS

	FROM    tbOROS  (NOLOCK)

	INNER JOIN tbOROSCIT (NOLOCK) 
	ON	tbOROS.CodigoEmpresa = tbOROSCIT.CodigoEmpresa 
	AND	tbOROS.CodigoLocal = tbOROSCIT.CodigoLocal 
	AND tbOROS.FlagOROS = tbOROSCIT.FlagOROS 
	AND tbOROS.NumeroOROS = tbOROSCIT.NumeroOROS 

	INNER JOIN tbCIT (NOLOCK)
	ON tbCIT.CodigoEmpresa = tbOROSCIT.CodigoEmpresa
	AND tbCIT.CodigoCIT = tbOROSCIT.CodigoCIT

	INNER JOIN tbCliFor cf (NOLOCK) 
	ON	cf.CodigoEmpresa = tbOROSCIT.CodigoEmpresa 
	AND	cf.CodigoCliFor  = tbOROSCIT.CodigoCliFor

	INNER JOIN tbPlanoPagamento (NOLOCK) 
	ON	tbOROSCIT.CodigoEmpresa = tbPlanoPagamento.CodigoEmpresa 
	AND tbOROSCIT.CodigoPlanoPagamento = tbPlanoPagamento.CodigoPlanoPagamento

	INNER JOIN tbCentroCusto (NOLOCK) 
	ON	tbOROSCIT.CodigoEmpresa = tbCentroCusto.CodigoEmpresa 
	AND tbOROSCIT.CentroCusto = tbCentroCusto.CentroCusto

	INNER JOIN tbOROSCITTipo (NOLOCK) 
	ON	tbOROSCIT.CodigoEmpresa = tbOROSCITTipo.CodigoEmpresa 
	AND tbOROSCIT.CodigoLocal = tbOROSCITTipo.CodigoLocal 
	AND tbOROSCIT.FlagOROS = tbOROSCITTipo.FlagOROS 
	AND tbOROSCIT.NumeroOROS = tbOROSCITTipo.NumeroOROS 
	AND tbOROSCIT.CodigoCIT = tbOROSCITTipo.CodigoCIT 

	INNER JOIN tbItemOROS (NOLOCK) 
	ON  tbOROSCITTipo.CodigoEmpresa = tbItemOROS.CodigoEmpresa 
	AND tbOROSCITTipo.CodigoLocal = tbItemOROS.CodigoLocal 
	AND tbOROSCITTipo.FlagOROS = tbItemOROS.FlagOROS 
	AND	tbOROSCITTipo.NumeroOROS = tbItemOROS.NumeroOROS 
	AND tbOROSCITTipo.CodigoCIT = tbItemOROS.CodigoCIT 
	AND tbOROSCITTipo.TipoItemOS = tbItemOROS.TipoItemOS 

	LEFT JOIN tbItemMOOROS (NOLOCK) 
	ON	tbItemOROS.CodigoEmpresa = tbItemMOOROS.CodigoEmpresa 
	AND tbItemOROS.CodigoLocal = tbItemMOOROS.CodigoLocal 
	AND tbItemOROS.FlagOROS = tbItemMOOROS.FlagOROS 
	AND tbItemOROS.NumeroOROS = tbItemMOOROS.NumeroOROS 
	AND tbItemOROS.CodigoCIT = tbItemMOOROS.CodigoCIT 
	AND tbItemOROS.TipoItemOS = tbItemMOOROS.TipoItemOS 
	AND tbItemOROS.SequenciaItemOS = tbItemMOOROS.SequenciaItemOS 

	LEFT JOIN tbItemProdOROS (NOLOCK) 
	ON 	tbItemOROS.CodigoEmpresa = tbItemProdOROS.CodigoEmpresa 
	AND tbItemOROS.CodigoLocal = tbItemProdOROS.CodigoLocal 
	AND tbItemOROS.FlagOROS = tbItemProdOROS.FlagOROS 
	AND tbItemOROS.NumeroOROS = tbItemProdOROS.NumeroOROS 
	AND tbItemOROS.CodigoCIT = tbItemProdOROS.CodigoCIT 
	AND tbItemOROS.TipoItemOS = tbItemProdOROS.TipoItemOS 
	AND tbItemOROS.SequenciaItemOS = tbItemProdOROS.SequenciaItemOS 

	LEFT JOIN tbProdutoFT (NOLOCK) 
	ON	tbProdutoFT.CodigoEmpresa = tbItemProdOROS.CodigoEmpresa 
	AND tbProdutoFT.CodigoProduto = tbItemProdOROS.CodigoProdutoItemOROS

	LEFT JOIN tbLinhaProduto (NOLOCK) 
	ON	tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa 
	AND tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto

	WHERE	tbOROS.CodigoEmpresa = @CodigoEmpresa
	AND		tbOROS.CodigoLocal = @CodigoLocal
	AND		tbOROSCIT.CentroCusto BETWEEN @CentroCustoInicial AND @CentroCustoFinal
	AND		tbOROSCIT.StatusOSCIT IN ('N') --,'E') 
	AND		tbOROS.FlagOROS = 'S'
	and		tbOROSCITTipo.TipoItemOS in ('P', 'C', 'M')
	AND		tbOROSCIT.DataEmissaoNotaFiscalOS BETWEEN @DataEncerramentoDe + ' 00:00:00' and @DataEncerramentoAte + ' 23:59:59'
	AND		tbCIT.GarantiaCIT = 'F'
	AND		tbCIT.OSInternaCIT = 'F'

	order by tbOROSCIT.CodigoCliFor

end



-----------------------------------------------------------------------------------------
-- Inserir dados do FT
-----------------------------------------------------------------------------------------
IF @ImprimePECCLO = 'V' AND @SelecionaFT = 'V' begin

	insert INTO	#tmp1
	
	SELECT
	cf.CodigoCliFor, cf.NomeCliFor,
	case when tbLinhaProduto.CombustivelLinhaProduto = 'V' 
			then 'C'
			else 'P'
	end as 'TipoItemOS',
	tbItemDocumento.NumeroDocumento as 'NumeroOROS',
	tbItemDocumento.ValorContabilItemDocto as 'ValorFaturamento',
	PercParticipacaoFaturamento = 0, 
	PercParticipacaoFaturamentoAcumulado = 0,
	OrdemFaturamento = 0, ABCFaturamento = 'X',

	QtdPassagensOficina = 0, 
	PercParticipacaoPassagens = 0, PercParticipacaoPassagensAcumulado = 0,
	OrdemPassagens = 0, ABCPassagens = 'X',

	TicketMedio = 0, --convert(numeric(16,2), 0), 
	PercParticipacaoTicketMedio = 0, PercParticipacaoTicketMedioAcumulado = 0,
	OrdemTicketMedio = 0, ABCTicketMedio = 'X',

	QtdFrota = 0, 
	PercParticipacaoFrota = 0, PercParticipacaoFrotaAcumulado = 0,
	OrdemFrota = 0, ABCFrota = 'X',

	ABCGeralServicos = 'XXX', ABCGeralPecas = 'XX',
	tbLinhaProduto.CodigoLinhaProduto, tbLinhaProduto.TipoLinhaProduto,
	tbItemDocumento.CodigoProduto, tbItemDocumento.CodigoProduto as 'CodigoProdutoItemOROS'

	from tbDocumento (nolock)
	inner join tbDocumentoFT (nolock)
	on tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa 
	and tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal
	and tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
	and tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento
	and tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento
	and tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor
	and tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao

	inner join tbItemDocumento (nolock)
	on tbItemDocumento.CodigoEmpresa = tbDocumento.CodigoEmpresa 
	and tbItemDocumento.CodigoLocal = tbDocumento.CodigoLocal
	and tbItemDocumento.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
	and tbItemDocumento.NumeroDocumento = tbDocumento.NumeroDocumento
	and tbItemDocumento.DataDocumento = tbDocumento.DataDocumento
	and tbItemDocumento.CodigoCliFor = tbDocumento.CodigoCliFor
	and tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao

	INNER JOIN tbCliFor cf (NOLOCK) 
	ON	cf.CodigoEmpresa = tbDocumento.CodigoEmpresa 
	AND	cf.CodigoCliFor  = tbDocumento.CodigoCliFor

	INNER JOIN tbNaturezaOperacao nop (NOLOCK) 
	ON	nop.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa 
	AND	nop.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao

	INNER JOIN tbProdutoFT (NOLOCK) 
	ON	tbProdutoFT.CodigoEmpresa = tbItemDocumento.CodigoEmpresa 
	AND tbProdutoFT.CodigoProduto = tbItemDocumento.CodigoProduto

	INNER JOIN tbLinhaProduto (NOLOCK) 
	ON	tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa 
	AND tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto


	WHERE	tbDocumento.CodigoEmpresa = @CodigoEmpresa
	AND		tbDocumento.CodigoLocal = @CodigoLocal
	AND		tbDocumento.EntradaSaidaDocumento = 'S'
	AND		tbDocumento.DataDocumento BETWEEN @DataEncerramentoDe + ' 00:00:00' and @DataEncerramentoAte + ' 23:59:59'
	AND		tbDocumento.TipoLancamentoMovimentacao = 7
	AND		tbDocumentoFT.OrigemDocumentoFT = 'FT'
	AND		tbDocumento.CondicaoNFCancelada = 'F'
	AND		tbDocumentoFT.CentroCusto BETWEEN @CentroCustoInicial AND @CentroCustoFinal
	and		nop.CodigoTipoOperacao in (3, 4)	-- Venda

end


-----------------------------------------------------------------------------------------
-- Inserir dados do TK
-----------------------------------------------------------------------------------------
IF @ImprimePECCLO = 'V' AND @SelecionaTK = 'V' begin

	insert INTO	#tmp1
	
	SELECT
	cf.CodigoCliFor, cf.NomeCliFor,
	case when tbLinhaProduto.CombustivelLinhaProduto = 'V' 
			then 'C'
			else 'P'
	end as 'TipoItemOS',
	tbItemDocumento.NumeroDocumento as 'NumeroOROS',
	tbItemDocumento.ValorContabilItemDocto as 'ValorFaturamento',
	PercParticipacaoFaturamento = 0, 
	PercParticipacaoFaturamentoAcumulado = 0,
	OrdemFaturamento = 0, ABCFaturamento = 'X',

	QtdPassagensOficina = 0, 
	PercParticipacaoPassagens = 0, PercParticipacaoPassagensAcumulado = 0,
	OrdemPassagens = 0, ABCPassagens = 'X',

	--TicketMedio = convert(numeric(16,2), 0), OrdemTicketMedio = 0, ABCTicketMedio = 'X',
	TicketMedio = 0, --convert(numeric(16,2), 0), 
	PercParticipacaoTicketMedio = 0, PercParticipacaoTicketMedioAcumulado = 0,
	OrdemTicketMedio = 0, ABCTicketMedio = 'X',

	QtdFrota = 0, 
	PercParticipacaoFrota = 0, PercParticipacaoFrotaAcumulado = 0,
	OrdemFrota = 0, ABCFrota = 'X',

	ABCGeralServicos = 'XXX', ABCGeralPecas = 'XX',
	tbLinhaProduto.CodigoLinhaProduto, tbLinhaProduto.TipoLinhaProduto,
	tbItemDocumento.CodigoProduto, tbItemDocumento.CodigoProduto as 'CodigoProdutoItemOROS'

	from tbDocumento (nolock)
	inner join tbDocumentoFT (nolock)
	on tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa 
	and tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal
	and tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
	and tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento
	and tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento
	and tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor
	and tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao

	inner join tbItemDocumento (nolock)
	on tbItemDocumento.CodigoEmpresa = tbDocumento.CodigoEmpresa 
	and tbItemDocumento.CodigoLocal = tbDocumento.CodigoLocal
	and tbItemDocumento.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
	and tbItemDocumento.NumeroDocumento = tbDocumento.NumeroDocumento
	and tbItemDocumento.DataDocumento = tbDocumento.DataDocumento
	and tbItemDocumento.CodigoCliFor = tbDocumento.CodigoCliFor
	and tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao

	INNER JOIN tbCliFor cf (NOLOCK) 
	ON	cf.CodigoEmpresa = tbDocumento.CodigoEmpresa 
	AND	cf.CodigoCliFor  = tbDocumento.CodigoCliFor

	INNER JOIN tbNaturezaOperacao nop (NOLOCK) 
	ON	nop.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa 
	AND	nop.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao

	INNER JOIN tbProdutoFT (NOLOCK) 
	ON	tbProdutoFT.CodigoEmpresa = tbItemDocumento.CodigoEmpresa 
	AND tbProdutoFT.CodigoProduto = tbItemDocumento.CodigoProduto

	INNER JOIN tbLinhaProduto (NOLOCK) 
	ON	tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa 
	AND tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto

	WHERE	tbDocumento.CodigoEmpresa = @CodigoEmpresa
	AND		tbDocumento.CodigoLocal = @CodigoLocal
	AND		tbDocumento.EntradaSaidaDocumento = 'S'
	AND		tbDocumento.DataDocumento BETWEEN @DataEncerramentoDe + ' 00:00:00' and @DataEncerramentoAte + ' 23:59:59'
	AND		tbDocumento.TipoLancamentoMovimentacao = 7
	AND		tbDocumentoFT.OrigemDocumentoFT = 'TK'
	AND		tbDocumento.CondicaoNFCancelada = 'F'
	AND		tbDocumentoFT.CentroCusto BETWEEN @CentroCustoInicial AND @CentroCustoFinal
	and		nop.CodigoTipoOperacao in (3, 4)	-- Venda

end



-----------------------------------------------------------------------------------------
-- Excluir itens indesejados conforme parametro
-----------------------------------------------------------------------------------------
IF @SomenteLinhaProdPecasOrig = 'V' BEGIN	-- Somente Pecas originais
	DELETE FROM #tmp1 WHERE TipoLinhaProduto != 0
END
IF @ImprimePECCLO = 'F' BEGIN
	DELETE FROM #tmp1 WHERE TipoItemOS in ('P', 'C')	-- excluir pecas + combustiveis	
END
IF @ImprimeMOB = 'F' BEGIN
	DELETE FROM #tmp1 WHERE TipoItemOS = 'M'			-- excluir mao de obra	
END

DELETE FROM #tmp1 WHERE CodigoCliFor = 0


-----------------------------------------------------------------------------------------
-- Processar ValorFaturamento de cada cliente
-----------------------------------------------------------------------------------------
select distinct CodigoCliFor into #tmpCliFat from #tmp1
while exists (select * from #tmpCliFat) begin
	select top 1 @CodigoCliFor = CodigoCliFor from #tmpCliFat
	select @ValorFaturamento = sum(ValorFaturamento) from #tmp1 where CodigoCliFor = @CodigoCliFor
	update #tmp1 set ValorFaturamento = @ValorFaturamento where CodigoCliFor = @CodigoCliFor
	delete from #tmpCliFat where CodigoCliFor = @CodigoCliFor
end


-----------------------------------------------------------------------------------------
-- Processar QtdPassagensOficina de cada cliente
-----------------------------------------------------------------------------------------
select CodigoCliFor, count(*) as 'QtdPassagensOficina' into #tmpCliPassagens from #tmp1 group by CodigoCliFor, NumeroOROS order by CodigoCliFor, NumeroOROS
while exists (select * from #tmpCliPassagens) begin
	select top 1 @CodigoCliFor = CodigoCliFor from #tmpCliPassagens
	select @QtdPassagensOficina = sum(QtdPassagensOficina) from #tmpCliPassagens where CodigoCliFor = @CodigoCliFor
	update #tmp1 set QtdPassagensOficina = @QtdPassagensOficina where CodigoCliFor = @CodigoCliFor
	delete from #tmpCliPassagens where CodigoCliFor = @CodigoCliFor
end


-----------------------------------------------------------------------------------------
-- Processar TicketMedio de cada cliente
-----------------------------------------------------------------------------------------
update #tmp1 set TicketMedio = round((ValorFaturamento / QtdPassagensOficina),2)


-----------------------------------------------------------------------------------------
-- Processar QtdFrota de cada cliente
-----------------------------------------------------------------------------------------
select distinct CodigoCliFor into #tmpCliFrota from #tmp1
while exists (select * from #tmpCliFrota) begin
	select top 1 @CodigoCliFor = CodigoCliFor from #tmpCliFrota

	select @QtdFrota = coalesce(sum(fc.QtdeVeiculosFrotaCliente), 0)
	from tbCliFor cf (nolock)
	inner join tbClienteStarTruck cst (nolock) on cst.CodigoEmpresa = cf.CodigoEmpresa and cst.CodigoLocal = @CodigoLocal and cst.CodigoClienteST = cf.CodigoCliFor and TipoCliEfetivoPotencial = 'E'
	inner join tbCaracteristicaCliente carac (nolock) 
	on carac.CodigoEmpresa = cst.CodigoEmpresa and carac.CodigoCliFor = cst.CodigoClienteST
	inner join tbFrotaCliente fc (nolock) 
	on fc.CodigoEmpresa = carac.CodigoEmpresa and fc.NumeroClientePotencialEfetivo = carac.NumeroClientePotencialEfetivo
	where cf.CodigoEmpresa = @CodigoEmpresa and cf.CodigoCliFor = @CodigoCliFor

	update #tmp1 set QtdFrota = @QtdFrota where CodigoCliFor = @CodigoCliFor
	delete from #tmpCliFrota where CodigoCliFor = @CodigoCliFor
end


-----------------------------------------------------------------------------------------
-- Cria tabela temporaria #tmp2 somente com clientes válidos
-----------------------------------------------------------------------------------------
select distinct CodigoCliFor, NomeCliFor, --CentroCusto, DescricaoCentroCusto, 
				ValorFaturamento, PercParticipacaoFaturamento, PercParticipacaoFaturamentoAcumulado, OrdemFaturamento, ABCFaturamento, 
				QtdPassagensOficina, PercParticipacaoPassagens, PercParticipacaoPassagensAcumulado, OrdemPassagens, ABCPassagens, 
				TicketMedio, PercParticipacaoTicketMedio, PercParticipacaoTicketMedioAcumulado, OrdemTicketMedio, ABCTicketMedio, 
				QtdFrota, PercParticipacaoFrota = 0, PercParticipacaoFrotaAcumulado = 0, OrdemFrota, ABCFrota, 
				ABCGeralServicos, ABCGeralPecas	
into #tmp2
from #tmp1


-----------------------------------------------------------------------------------------
-- Apura Totais Gerais para FATURAMENTO/ QTD PASSAGENS / TICKET MEDIO / QTD FROTA
-- de todos os clientes para calculo da participacao individual
-----------------------------------------------------------------------------------------
declare @TotalValorFaturamento numeric(18,2)
declare @TotalQtdPassagensOficina numeric(18,2)
declare @TotalTicketMedio numeric(18,2)
declare @TotalQtdFrota numeric(18,2)

select @TotalValorFaturamento = sum(ValorFaturamento) from #tmp2
select @TotalQtdPassagensOficina = sum(QtdPassagensOficina) from #tmp2
select @TotalTicketMedio = sum(TicketMedio) from #tmp2
select @TotalQtdFrota = sum(QtdFrota) from #tmp2


-----------------------------------------------------------------------------------------
-- Processar Perc. Participacão de FATURAMENTO / QTD PASSAGENS / TICKET MEDIO / QTD FROTA
-- de todos os clientes
-----------------------------------------------------------------------------------------

update #tmp2 set PercParticipacaoFaturamento = 0 
update #tmp2 set PercParticipacaoPassagens =  0 
update #tmp2 set PercParticipacaoTicketMedio = 0 
update #tmp2 set PercParticipacaoFrota = 0 

if @TotalValorFaturamento > 0 begin
	update #tmp2 set PercParticipacaoFaturamento = round(ValorFaturamento / @TotalValorFaturamento * 100, 2) 
end
if @TotalQtdPassagensOficina > 0 begin
	update #tmp2 set PercParticipacaoPassagens = round(QtdPassagensOficina / @TotalQtdPassagensOficina * 100, 2) 
end
if @TotalTicketMedio > 0 begin
update #tmp2 set PercParticipacaoTicketMedio = round(TicketMedio / @TotalTicketMedio * 100, 2)
end
if @TotalQtdFrota > 0 begin
	update #tmp2 set PercParticipacaoFrota = round(QtdFrota / @TotalQtdFrota * 100, 2) 
end 


-----------------------------------------------------------------------------------------
-- PARTICIPACAO DO FATURAMENTO
-- Calcula Perc Participacao Acumulada do Faturamento com ranking A=70%, B=20%, C=10%
-----------------------------------------------------------------------------------------
declare @PercParticipacaoFaturamentoAcumulado numeric(10,2)
select @PercParticipacaoFaturamentoAcumulado = 0

if @ImprimePECCLO = 'V' begin
	
	---- PECAS
	select ValorFaturamento, PercParticipacaoFaturamento, CodigoCliFor, QtdFrota, QtdPassagensOficina, TicketMedio
	into #tmp3 from #tmp2 
	order by ValorFaturamento desc, QtdFrota desc

	set rowcount 1
	while exists (select * from #tmp3) begin
		
		select	@CodigoCliFor = CodigoCliFor ,
				@PercParticipacaoFaturamentoAcumulado = @PercParticipacaoFaturamentoAcumulado + PercParticipacaoFaturamento 
		from	#tmp3 
		order by ValorFaturamento desc, QtdFrota desc

		update #tmp2 
		set PercParticipacaoFaturamentoAcumulado = @PercParticipacaoFaturamentoAcumulado,
			ABCFaturamento = case	when @PercParticipacaoFaturamentoAcumulado <= 70 then 'A'
									when @PercParticipacaoFaturamentoAcumulado <= 90 then 'B'
									else 'C'
							 end
		where CodigoCliFor = @CodigoCliFor 

		delete from #tmp3 where CodigoCliFor = @CodigoCliFor 

	end
	set rowcount 0

end
else
begin

	-- SERVICOS
	select ValorFaturamento, PercParticipacaoFaturamento, CodigoCliFor, QtdFrota, QtdPassagensOficina, TicketMedio
	into #tmp33 from #tmp2 
	order by ValorFaturamento desc, QtdPassagensOficina desc, TicketMedio desc


	set rowcount 1
	while exists (select * from #tmp33) begin
		select	@CodigoCliFor = CodigoCliFor ,
				@PercParticipacaoFaturamentoAcumulado = @PercParticipacaoFaturamentoAcumulado + PercParticipacaoFaturamento 
		from	#tmp33 
		order by ValorFaturamento desc, QtdPassagensOficina desc, TicketMedio desc

		update #tmp2 
		set PercParticipacaoFaturamentoAcumulado = @PercParticipacaoFaturamentoAcumulado,
			ABCFaturamento = case	when @PercParticipacaoFaturamentoAcumulado <= 70 then 'A'
									when @PercParticipacaoFaturamentoAcumulado <= 90 then 'B'
									else 'C'
							 end
		where CodigoCliFor = @CodigoCliFor 

		delete from #tmp33 where CodigoCliFor = @CodigoCliFor 
	end
	set rowcount 0

end


--select 'FATURAMENTO', CodigoCliFor, @TotalValorFaturamento AS 'TotalValorFaturamento', ValorFaturamento, ABCFaturamento, PercParticipacaoFaturamento, PercParticipacaoFaturamentoAcumulado
--from #tmp2 
--order by ValorFaturamento desc


-----------------------------------------------------------------------------------------
-- PARTICIPACAO DE PASSAGENS PELA OFICINA
-- Calcula Perc Participacao Acumulada de Passagens pela Oficina com ranking A=70%, B=20%, C=10%
-----------------------------------------------------------------------------------------
declare @PercParticipacaoPassagensAcumulado numeric(10,2)
select @PercParticipacaoPassagensAcumulado = 0

select QtdPassagensOficina, PercParticipacaoPassagens, CodigoCliFor, ValorFaturamento, TicketMedio
into #tmp4 from #tmp2 
order by QtdPassagensOficina desc, ValorFaturamento desc, TicketMedio desc

set rowcount 1
while exists (select * from #tmp4) begin

	select	@CodigoCliFor = CodigoCliFor ,
			@PercParticipacaoPassagensAcumulado  = @PercParticipacaoPassagensAcumulado + PercParticipacaoPassagens
	from	#tmp4 
	order by QtdPassagensOficina desc, ValorFaturamento desc, TicketMedio desc

	update #tmp2 
	set PercParticipacaoPassagensAcumulado = @PercParticipacaoPassagensAcumulado,
		ABCPassagens =	case	when @PercParticipacaoPassagensAcumulado <= 70 then 'A'
								when @PercParticipacaoPassagensAcumulado <= 90 then 'B'
								else 'C'
						end
	where CodigoCliFor = @CodigoCliFor 

	delete from #tmp4 where CodigoCliFor = @CodigoCliFor 
end
set rowcount 0


--select 'PASSAGENS', CodigoCliFor, @TotalQtdPassagensOficina as 'TotalQtdPassagensOficina', QtdPassagensOficina, ABCPassagens, PercParticipacaoPassagens, PercParticipacaoPassagensAcumulado
--from #tmp2 
--order by QtdPassagensOficina desc


-----------------------------------------------------------------------------------------
-- PARTICIPACAO DE TICKET MEDIO
-- Calcula Perc Participacao Acumulada de Ticket Medio com ranking A=70%, B=20%, C=10%
-----------------------------------------------------------------------------------------
declare @PercParticipacaoTicketMedioAcumulado numeric(10,2)
select @PercParticipacaoTicketMedioAcumulado = 0

select TicketMedio, PercParticipacaoTicketMedio, CodigoCliFor, ValorFaturamento, QtdPassagensOficina
into #tmp5 from #tmp2 
order by TicketMedio desc, ValorFaturamento desc, QtdPassagensOficina desc

set rowcount 1
while exists (select * from #tmp5) begin

	select	@CodigoCliFor = CodigoCliFor ,
			@PercParticipacaoTicketMedioAcumulado  = @PercParticipacaoTicketMedioAcumulado + PercParticipacaoTicketMedio
	from	#tmp5
	order by TicketMedio desc, ValorFaturamento desc, QtdPassagensOficina desc

	update #tmp2 
	set PercParticipacaoTicketMedioAcumulado = @PercParticipacaoTicketMedioAcumulado,
		ABCTicketMedio =	case	when @PercParticipacaoTicketMedioAcumulado <= 70 then 'A'
									when @PercParticipacaoTicketMedioAcumulado <= 90 then 'B'
									else 'C'
							end
	where CodigoCliFor = @CodigoCliFor 

	delete from #tmp5 where CodigoCliFor = @CodigoCliFor 
end
set rowcount 0


--select 'TICKET MEDIO', CodigoCliFor, @TotalTicketMedio as 'TotalTicketMedio', TicketMedio, ABCTicketMedio, PercParticipacaoTicketMedio, PercParticipacaoTicketMedioAcumulado
--from #tmp2 
--order by TicketMedio desc




-----------------------------------------------------------------------------------------
-- PARTICIPACAO DE FROTA
-- Calcula Perc Participacao Acumulada de Frotas com ranking A=70%, B=20%, C=10%
-----------------------------------------------------------------------------------------
declare @PercParticipacaoFrotaAcumulado numeric(10,2)
select @PercParticipacaoFrotaAcumulado = 0

select QtdFrota, PercParticipacaoFrota, CodigoCliFor, ValorFaturamento
into #tmp6 from #tmp2 
order by QtdFrota desc, ValorFaturamento desc

set rowcount 1
while exists (select * from #tmp6) begin

	select	@CodigoCliFor = CodigoCliFor ,
			@PercParticipacaoFrotaAcumulado = @PercParticipacaoFrotaAcumulado + PercParticipacaoFrota
	from	#tmp6
	order by QtdFrota desc, ValorFaturamento desc

	update #tmp2 
	set PercParticipacaoFrotaAcumulado = @PercParticipacaoFrotaAcumulado,
		ABCFrota =	case	when @PercParticipacaoFrotaAcumulado <= 70 then 'A'
							when @PercParticipacaoFrotaAcumulado <= 90 then 'B'
							else 'C'
					end
	where CodigoCliFor = @CodigoCliFor 

	delete from #tmp6 where CodigoCliFor = @CodigoCliFor 
end
set rowcount 0


--select 'QTD FROTA', CodigoCliFor, @TotalQtdFrota as 'TotalQtdFrota', QtdFrota, ABCFrota, PercParticipacaoFrota, PercParticipacaoFrotaAcumulado
--from #tmp2 
--order by QtdFrota desc



-------------------------------------------------------------------------------------------
---- Atualizar Curva ABCGeralServicos e ABCGeralPecas
-------------------------------------------------------------------------------------------
update #tmp2
set ABCGeralServicos = (ABCFaturamento + ABCPassagens + ABCTicketMedio),
    ABCGeralPecas = (ABCFaturamento + ABCFrota)

-----------------------------------------------------------------------------------------
SET nocount OFF

-----------------------------------------------------------------------------------------
-- Listar OK
-----------------------------------------------------------------------------------------
if @ImprimePECCLO = 'V' begin
	--select * from #tmpTicketMedio order by ValorFaturamento desc, QtdFrota desc, NomeCliFor 
	select 
	CodigoCliFor, NomeCliFor, ValorFaturamento, OrdemFaturamento, ABCFaturamento,
	QtdPassagensOficina, OrdemPassagens, ABCPassagens,
	TicketMedio, OrdemTicketMedio, ABCTicketMedio,
	QtdFrota, OrdemFrota, ABCFrota,
	ABCGeralServicos, ABCGeralPecas,
	PercParticipacaoFaturamento, PercParticipacaoFaturamentoAcumulado,
	PercParticipacaoPassagens, PercParticipacaoPassagensAcumulado,
	PercParticipacaoTicketMedio, PercParticipacaoTicketMedioAcumulado
	from #tmp2 
	order by ValorFaturamento desc, QtdFrota desc, NomeCliFor 
end
else
begin
	--select * from #tmpTicketMedio order by ValorFaturamento desc, QtdPassagensOficina desc, TicketMedio desc, NomeCliFor 
	select 
	CodigoCliFor, NomeCliFor, ValorFaturamento, OrdemFaturamento, ABCFaturamento,
	QtdPassagensOficina, OrdemPassagens, ABCPassagens,
	TicketMedio, OrdemTicketMedio, ABCTicketMedio,
	QtdFrota, OrdemFrota, ABCFrota,
	ABCGeralServicos, ABCGeralPecas,
	PercParticipacaoFaturamento, PercParticipacaoFaturamentoAcumulado,
	PercParticipacaoPassagens, PercParticipacaoPassagensAcumulado,
	PercParticipacaoTicketMedio, PercParticipacaoTicketMedioAcumulado
	from #tmp2 
	order by ValorFaturamento desc, QtdPassagensOficina desc, TicketMedio desc, NomeCliFor 
end


go
grant execute on dbo.whRelOSABCCliente to SQLUsers
go

