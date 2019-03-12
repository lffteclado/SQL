IF EXISTS(SELECT 1 FROM sysobjects WHERE id = OBJECT_ID('dbo.whLItemPedido'))
DROP PROCEDURE dbo.whLItemPedido
GO
CREATE PROCEDURE dbo.whLItemPedido
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda
 PROJETO......: FT - Faturamento
 AUTOR........: Marcio Simoes
 DATA.........: 30/03/1999
 UTILIZADO EM : clsPedido
 OBJETIVO.....: Listar o item de um Pedido e mais atributos utilizados no calculo do pedido.

 ALTERACAO....: Carlos JSC - 24/09/2002
 OBJETIVO.....: Calculo Imposto Debitado ECF

 ALTERACAO....: Marcio Schvartz - 05/11/2002
 OBJETIVO.....: Adicionado o retorno dos campos TributaPISProduto TributaCOFINSProduto da
                tabela tbProdutoFT

 ALTERACAO....: Edvaldo Ragassi - 17/04/2003
 OBJETIVO.....: Eliminacao da tbProdutoCE.

EXECUTE whLItemPedido @CodigoEmpresa = 1608,@CodigoLocal = 0,@CentroCusto = 11310,@NumeroPedido = 54712,@SequenciaPedido = 0
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa		numeric(4) 	= Null,
@CodigoLocal		numeric(4) 	= Null,
@CentroCusto		numeric(8) 	= Null,
@NumeroPedido		numeric(6) 	= Null,
@SequenciaPedido	numeric(2) 	= Null,
@CodigoProduto		char(30)	= Null


--WITH ENCRYPTION
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE	@DataCorrente	datetime
DECLARE	@BaseICMSTransf	bit

SELECT	@DataCorrente = CONVERT(varchar(10), GETDATE(), 120),
	@BaseICMSTransf = dbo.fnBaseICMSTransferencia(@CodigoEmpresa, @CodigoLocal)

DECLARE	@PosicaoICMS	TABLE
	(	CodigoEmpresa	Numeric(4),
		CodigoLocal	Numeric(4),
		CentroCusto	Numeric(8),
		NumeroPedido	Numeric(6),
		SequenciaPedido	Numeric(2),
		ItemPedido	Numeric(4),
		CSTICMS		Char(3),
		NCM		VarChar(10),
		ICMSIsento	Char(1),
		CondicaoICMS	Numeric(1),
		CFOP		Char(4),
		PercImpostos	Money,
		PercReducaoICMS	Money
	)

-- Carregar Temporaria
INSERT	@PosicaoICMS
SELECT	CodigoEmpresa,
	CodigoLocal,
	CentroCusto,
	NumeroPedido,
	SequenciaPedido,
	ItemPedido,
	CSTICMS	= CASE	WHEN LEN(CSTICMS) = 3
			THEN CSTICMS
			ELSE CONVERT(CHAR(1), dbo.fnRetornaOrigemItemPedido(CodigoEmpresa, CodigoLocal, CentroCusto, NumeroPedido, SequenciaPedido, ItemPedido)) + CONVERT(CHAR(2), CSTICMS) END,
	CodigoClassificacaoFiscal,
	ICMSIsento,
	CondicaoICMSItem,
	CFOP,
	PercentualAproximadoImpostos,
	PercentualReducaoICMS
FROM	dbo.fnRetornaPosicaoICMSItens(@CodigoEmpresa,@CodigoLocal,@CentroCusto,@NumeroPedido,@SequenciaPedido)


DECLARE @UltimaEntradaDocumento TABLE
	(ID		int identity not null
	,CodigoEmpresa	numeric(4) not null
	,CodigoLocal	numeric(4) not null
	,CodigoProduto	char(30) not null
	,ValorEntrada	numeric(16,4) not null
	)

IF @BaseICMSTransf = 1
	INSERT	@UltimaEntradaDocumento
	SELECT	I.CodigoEmpresa,
		I.CodigoLocal,
		I.CodigoProduto,
		CASE WHEN idft.PrecoLiquidoUnitarioItDocFT = 0 THEN ROUND(((IdDoc.ValorProdutoItemDocto - IdDoc.ValorDescontoItemDocto) / IdDoc.QtdeLancamentoItemDocto), 2) ELSE idft.PrecoLiquidoUnitarioItDocFT END
	FROM (	SELECT CodigoEmpresa,CodigoLocal,CodigoProduto,[E]
		FROM (	SELECT  idoc.CodigoEmpresa,idoc.CodigoLocal,idoc.CodigoProduto,idoc.EntradaSaidaDocumento,MAX(idoc.DataDocumento) AS maxDt
			FROM	tbItemDocumento idoc with (nolock)
			INNER JOIN tbNaturezaOperacao nop WITH (NOLOCK)
			ON	nop.CodigoEmpresa = idoc.CodigoEmpresa
			AND	nop.CodigoNaturezaOperacao = idoc.CodigoNaturezaOperacao
			WHERE EXISTS (	SELECT	1
					FROM	tbItemPedido iped (NOLOCK)
					WHERE	iped.CodigoEmpresa	= idoc.CodigoEmpresa
					AND	iped.CodigoLocal	= idoc.CodigoLocal
					AND	iped.CodigoProduto	= idoc.CodigoProduto
					AND	iped.CentroCusto	= @CentroCusto
					AND	iped.NumeroPedido	= @NumeroPedido
					AND	iped.SequenciaPedido	= @SequenciaPedido)
			AND	idoc.CodigoEmpresa	= @CodigoEmpresa
			AND	idoc.CodigoLocal	= @CodigoLocal
			AND	nop.CodigoTipoOperacao	= 1
			AND	idoc.DataDocumento	<= @DataCorrente
			GROUP BY idoc.CodigoEmpresa,idoc.CodigoLocal,idoc.CodigoProduto,idoc.EntradaSaidaDocumento) AS SourceTable  
	PIVOT (	MAX(maxDt)
		FOR EntradaSaidaDocumento IN ([E])) AS PivotTable) AS I
	INNER JOIN tbItemDocumento IdDoc (NOLOCK)
	ON	IdDoc.CodigoEmpresa	= I.CodigoEmpresa
	AND	IdDoc.CodigoLocal	= I.CodigoLocal
	AND	IdDoc.CodigoProduto	= I.CodigoProduto
	AND	IdDoc.DataDocumento	= I.E
	INNER JOIN tbItemDocumentoFT idft (NOLOCK)
	ON	idft.CodigoEmpresa	= IdDoc.CodigoEmpresa
	AND	idft.CodigoLocal	= IdDoc.CodigoLocal
	AND	idft.EntradaSaidaDocumento = IdDoc.EntradaSaidaDocumento
	AND	idft.NumeroDocumento	= IdDoc.NumeroDocumento
	AND	idft.DataDocumento	= IdDoc.DataDocumento
	AND	idft.CodigoCliFor	= IdDoc.CodigoCliFor
	AND	idft.TipoLancamentoMovimentacao	= IdDoc.TipoLancamentoMovimentacao
	AND	idft.SequenciaItemDocumento = IdDoc.SequenciaItemDocumento
	INNER JOIN tbNaturezaOperacao nat (NOLOCK)
	ON	nat.CodigoEmpresa	= IdDoc.CodigoEmpresa
	AND	nat.CodigoNaturezaOperacao = IdDoc.CodigoNaturezaOperacao
	AND	nat.CodigoTipoOperacao	= 1


DECLARE @UED TABLE
	(ID		int not null
	,CodigoEmpresa	numeric(4) not null
	,CodigoLocal	numeric(4) not null
	,CodigoProduto	char(30) not null
	,ValorEntrada	numeric(16,4) not null
	)

INSERT	@UED
SELECT	*
FROM	@UltimaEntradaDocumento a
WHERE	ID = (SELECT MAX(ID) FROM @UltimaEntradaDocumento b WHERE b.CodigoEmpresa = a.CodigoEmpresa AND b.CodigoLocal = a.CodigoLocal AND b.CodigoProduto = a.CodigoProduto)



SELECT	IP.CodigoEmpresa, IP.CodigoLocal, IP.CentroCusto, 
	IP.NumeroPedido, IP.SequenciaPedido, IP.ItemPedido,
	IP.CodigoItemPed, IP.TipoRegistroItemPed, IP.TipoMaoObraItemPed,
	IP.TextoItemPedido, IP.CodigoTributacao, IP.ItemNotaFiscalOriginalItemPed,
	IP.AtualizaPrecoReposicaoItemPed, IP.QuantidadeItemPed, IP.PercDescontoItemPed,
	IP.PrecoUnitarioItemPed, IP.PrecoBrutoItemPed, IP.ValorDescontoItemPed,
	IP.PrecoLiquidoUnitarioItemPed, IP.PrecoTotalItemPed, 	IP.PesoBrutoItemPed,
	IP.PesoLiquidoItemPed,
	CASE WHEN (LEFT(IP.CodigoTributacao, 1) IN ('3', '5', '8') AND COALESCE(PFT.CodigoTributacaoForaEstado, vcv.nFCI, '') != '') THEN 'NUMERO FCI: ' + COALESCE(PFT.CodigoTributacaoForaEstado, vcv.nFCI, '') ELSE (CASE WHEN PED.OrigemPedido = 'CV' THEN '' ELSE IP.TextoNotaFiscal01ItemPed END) END AS 'TextoNotaFiscal01ItemPed', 
	CASE WHEN PED.OrigemPedido != 'CV' THEN IP.TextoNotaFiscal02ItemPed ELSE '' END AS 'TextoNotaFiscal02ItemPed', 
	IP.QtdeDevolucaoVendaItemPed, 
	IP.QtdeDevolucaoCompraItemPed, 
	ValorCustoMovimentoItemPed = CAST(ISNULL(dbo.fnApurarCustoUnitario(IP.CodigoEmpresa, IP.CodigoLocal, IP.CentroCusto, IP.NumeroPedido, IP.SequenciaPedido, IP.ItemPedido),0) AS MONEY),
	IP.CondicaoIPIItemPed, 
	IP.CondicaoICMSItemPed, 
	IP.BaseIRRFItemPed, 
	IP.ValorIRRFItemPed, 
	IP.ValorICMSRetidoFonteItemPed, 
	IP.PercICMSSubsTributariaItemPed, 
	IP.BaseICMSSubsTributariaItemPed, 
	IP.ValorICMSSubsTributariaItemPed, 
	IP.PercICMSItemPed, 
	IP.BaseICMS1ItemPed, 
	IP.BaseICMS2ItemPed, 
	IP.BaseICMS3ItemPed, 
	IP.ValorICMSItemPed, 
	IP.PercIPIItemPed, 
	IP.BaseIPI1ItemPed, 
	IP.BaseIPI2ItemPed, 
	IP.ValorIPIItemPed, 
	IP.PercISSItemPed, 
	IP.ValorBaseISSItemPed, 
	IP.ValorISSItemPed,
	IP.PercCofinsItemPed, 
	IP.BaseCOFINSItemPed, 
	IP.ValorCOFINSItemPed,
	IP.PercPISItemPed, 
	IP.BasePISItemPed, 
	IP.ValorPISItemPed,
	IP.PercCofinsSTItemPed,
	IP.BaseCofinsSTItemPed, 
	IP.ValorCofinsSTItemPed,
	IP.PercPISSTItemPed,
	IP.BasePISSTItemPed, 
	IP.ValorPISSTItemPed, 
	IP.ImpostoImportacaoItemPed, 
	IP.RateioFreteItemPed, 
	IP.RateioSeguroItemPed, 
	IP.RateioEncargoFinanItemPed, 
	IP.RateioDescontoItemPed, 
	IP.BaseICMSSTUltEntradaItemPed, 
	IP.ValorICMSSTUltEntradaItemPed, 
	IP.ValorReembolsoSTItemPed, 
	IP.UnidadeItemPed, 
	IP.UnidadeValorizacaoItemPed, 
	IP.BaseIPI3ItemPed, 
	IP.MercadoPecasItemPed, 
	IP.DataSeparacaoExpedicao, 
	IP.QtdeSeparadaExpedicao, 
	IP.ItemCargaEPC, 
	IP.FlagArmazenadoDevolucao, 
	IP.ValorDescInvisivelItemPed, 
	IP.PrecoUnitarioOriginalItemPed, 
	IP.CodigoAlmoxarifadoOrigem, 
	IP.ChassiVeiculoOS, 
	IP.CodigoMaoObraOS, 
	IP.CodigoAlmoxarifadoDestino, 
	IP.CodigoProduto, 
	IP.CodigoNaturezaOperacao, 
	IP.CentroCustoMaoObra, 
	IP.RateioDespAcessoriasItemPed, 
	IP.ProdVendPromocaoItemPed, 
	IP.DataLimitePromocaoItemPed, 
	IP.RateioSegSocialItemPed, 
	IP.OrdemSeparacaoImpressa, IP.ValorICMSDiferidoItemPed,
	IP.CodigoProdutoReclassificacao, IP.QuantidadeReclassificacao,
	IP.CSTIPIItemPed, IP.CSTCOFINSItemPed, IP.CSTPISItemPed,
	IP.vBCImportacaoItemPed, IP.vDespAduaneirasItemPed, IP.vIOFItemPed,
	IP.vCOFINSRetidoItemPed, IP.vPISRetidoItemPed, IP.xPedCompra, IP.nItemPedCompra,
	PD.DescricaoProduto,
	CLF.CodigoClassificacaoFiscal,
	PD.CodigoEditadoProduto, 
	PL.VendaBloqueada, PL.SugestaoBloqueada, PL.DataUltimaVenda, 
	PL.DataUltimaMovimentacao, PL.FrequenciaVenda, PL.DiasTempoReposicao, 
	PL.DiasRitmoAquisicao, PL.DiasEstoqueMinimo, PL.ConsumoMedioInformado, 
	PL.DataLimiteConsMedioInformado, PL.ConsumoMedioCalculado,
	PL.ConsumoMedioAnoAnterior, PL.PontoPedidoCalculado, 
	PL.QuantidadeInventarios, PL.PromocaoProduto, PL.QuantidadeLimitePromocao, 
	PL.SaldoItemPromocao, PL.DataLimitePromocao, PL.QuantidadeEstoqueMinimo, 
	PL.QuantidadeEstoqueMaximo, PL.ClassifABCValorVenda, 
	PL.ClassifABCValorEstoque, PL.ClassifABCValorCompras, 
	PL.ClassifABCValorReposicao, PL.DataApurABCValorVenda, 
	PL.DataApurABCValorEstoque, PL.DataApurABCValorCompras, 
	PL.DataApurABCValorReposicao, PL.ClassifABCQuantidadeVenda, 
	PL.ClassifABCQuantidadeEstoque, PL.ClassifABCQuantidadeCompras, 
	PL.ClassifABCFrequenciaVenda, PL.DataApurABCQuantidadeVenda, 
	PL.DataApurABCQuantidadeEstoque, PL.DataApurABCQuantidadeCompras, 
	PL.DataApurABCFrequenciaVenda, PL.DataUltimoInventario, 
	PL.DataUltimaVendaPerdida, PL.QuantidadeObjetivoVenda, 
	PL.DataUltimaCompra, PL.DataUltimoReajustePreco,  PL.GeraDemandaDIMSPromocao,
	PL.DataInicioPromocao, PL.ClassificacaoPreco123, PL.CodigoGrPlan,
	PL.DataLimiteEstoqueMinimo, PL.DataLimiteEstoqueMaximo,
	PFT.CodigoFormatadoProduto, PFT.CodigoBarrasProduto, 
	PFT.EmbalagemComercialProduto, PFT.MarcaProduto, PFT.DataCadastroProduto, 
	PFT.PrecoReposicaoIndiceProduto, PFT.PesoLiquidoProduto, 
	PFT.PesoBrutoProduto, PFT.CondicaoIPIProduto, PFT.CondicaoICMSProduto, 
	PFT.CondicaoRedICMSProduto, PFT.FatorConversaoDIPIProduto, 
	PFT.CodigoTributacaoProduto, PFT.CodigoTributacaoForaEstado, PFT.PercRedBaseICMSProduto, 
	PFT.PercentualImportacaoProduto, PFT.QuantidadeAntecessoresProduto, 
	PFT.QuantidadeOpcionaisProduto, PFT.QuantidadeSucessoresProduto, 
	PFT.QuantidadeOutrasFontesProduto, PFT.SubstituicaoTributariaProduto, 
	PFT.EspecificacoesTecnicasProduto, PFT.CodigoCategoria, 
	PFT.CodigoLinhaProduto, PFT.CodigoUnidadeProduto, 
	PFT.CodigoFonteFornecimento, PFT.ItemForaListaProduto, PFT.Decreto31424RJ, 
	CLF.TributaPIS AS TributaPISProduto, CLF.TributaCOFINS AS TributaCOFINSProduto, 
	PFT.CodigoMargemComercializacao, PFT.ImunidadeICMSProduto, 
	PFT.IVADentroEstado, PFT.IVAForaEstado, PFT.ProdutoImportado, PFT.ProdutoImportadoDireto, PFT.TipoUtilizacao,
	PFT.QuantidadeMinimaVenda, PFT.Comprimento, PFT.Largura, PFT.Profundidade, PFT.CodigoANP, PFT.CODIF,
	PFT.NacionalMaior40Import, PFT.NacionalAte40Import, PFT.SemSimilarNacional,
	UNPROD.CodigoDIPIUnidadeProduto, UNPROD.DescricaoUnidadeProduto,	
	UNPROD.UsaCasasDecimaisUnidadeProduto, UNPROD.DescricaoUnidadeProdutoMBB,
	NATOP.DescricaoNaturezaOperacao, NATOP.DesoneracaoCondicionalICMS,
	NATOP.DescricaoNFNaturezaOperacao, NATOP.CodigoTributacaoNaturezaOper, 
	NATOP.GeraDuplicataNaturezaOperacao, NATOP.CondicaoIPINaturezaOperacao, 
	NATOP.CondicaoICMSNaturezaOperacao, NATOP.CondicaoReducaoICMSNatOper, 
	NATOP.PercentualICMSNaturezaOperacao, NATOP.PercReducaoICMSNaturezaOper, 
	NATOP.PercAproveitamentoIPINatOper, NATOP.CFONaturezaOperacao, 
	NATOP.AtualizaEstoqueNaturezaOper, NATOP.AtualizaLFNaturezaOperacao, 
	NATOP.AtualizaCRNaturezaOperacao, NATOP.AtualizaCPNaturezaOperacao, 
	NATOP.AtualizaComisNaturezaOperacao, NATOP.AtualizaEstatNaturezaOperacao, 
	NATOP.AtualizaCGNaturezaOperacao, NATOP.AtualizaAFNaturezaOperacao, 
	NATOP.ZonaFrancaNaturezaOperacao, NATOP.ObservacaoNaturezaOperacao, 
	NATOP.ConsumoImobilizadoNatOper, NATOP.SubstTributariaNaturezaOper, 
	NATOP.DeduzINSSDup, NATOP.ReduzBCICMSST,
	CASE	WHEN ISNULL((SELECT ISNULL(tmo.CodigoServicoFederal,'')
			FROM	tbMaoObraOS mob
			INNER JOIN tbTipoMaoObra tmo
			ON	tmo.CodigoEmpresa	= mob.CodigoEmpresa
			AND	tmo.CodigoTipoMaoObra	= mob.CodigoTipoMaoObra
			WHERE	mob.CodigoEmpresa	= IP.CodigoEmpresa
			AND	mob.CodigoMaoObraOS	= IP.CodigoMaoObraOS),'') = ''
		THEN	NATOP.CodigoServicoNaturezaOperacao
		when PED.SequenciaPedido = 10 then NATOP.CodigoServicoNaturezaOperacao
		ELSE (SELECT ISNULL(tmo.CodigoServicoFederal,'')
			FROM	tbMaoObraOS mob
			INNER JOIN tbTipoMaoObra tmo
			ON	tmo.CodigoEmpresa	= mob.CodigoEmpresa
			AND	tmo.CodigoTipoMaoObra	= mob.CodigoTipoMaoObra
			WHERE	mob.CodigoEmpresa	= IP.CodigoEmpresa
			AND	mob.CodigoMaoObraOS	= IP.CodigoMaoObraOS)
	END	AS CodigoServicoNaturezaOperacao,
	NATOP.CalculaPISNaturezaOperacao, NATOP.CalculaFinSocialNaturezaOper, 
	NATOP.PercentualISSNaturezaOperacao, NATOP.CodigoTipoOperacao, 
	NATOP.ICMSRetidoFonteNaturezaOper, NATOP.PercReducaoISSNaturezaOperacao, 
	NATOP.FreteTributadoNaturezaOperacao, NATOP.ImportacaoNaturezaOperacao, 
	NATOP.DiferencaICMSNaturezaOperacao, NATOP.IncideIRRFServNaturezaOperacao, 
	NATOP.PercReducaoIPINaturezaOperacao, NATOP.CondicaoReducaoIPINatOper, 
	NATOP.CFONaturezaOperacaoForaEstado, NATOP.DescricaoCFONFNaturezaOper, 
	NATOP.CalculaIPISobreBase3, NATOP.DeduzValorCompraBaseICMS, 
	NULL AS CodigoSituacaoTributaria, NATOP.CodigoTipoMovimentacao, 
	NATOP.CodigoModeloNotaFiscal, NATOP.CodigoSistemaTextoNF, 
	NATOP.CodigoTextoNotaFiscal, NATOP.CodigoSistemaTextoNF2, 
	NATOP.CodigoTextoNotaFiscal2, NATOP.CodigoFatoGeradorContato, 
	NATOP.CFONatOperInternoIN428, NATOP.CodigoCFO, NATOP.EntradaSaidaNaturezaOperacao,
	NATOP.CalculoAutomaticoIRRF, NATOP.CalculaSegSocial, NATOP.PercSegSocial,
	NATOP.MP135PercentualCSLL, NATOP.MP135RetemImpostosFonte,
	NATOP.PercPIS, NATOP.PercCOFINS, NATOP.MP135DemonstraImpFonte, 
	NATOP.DemonstraISSPrefeitura, NATOP.RetemISSPrefeitura, NATOP.PercISSPrefeitura,
	NATOP.SomaIPIBase3LivroEntrada, NATOP.PercentualIRRF, NATOP.GeraContasPagarPISCOFINS,
	NATOP.CNOBloqueado, NATOP.TextoNFGS3, NATOP.NotaEstorno, NATOP.PrazoRetorno,
	CLF.DescricaoClassificacaoFiscal, CLF.PercIPIClassificacaoFiscal, CLF.CodigoUnidadeDIPI,
	CASE	WHEN	(NATOP.CSTIPI IS NOT NULL AND NATOP.CSTIPI != '')
		THEN	NATOP.CSTIPI
		ELSE	CASE	WHEN NATOP.EntradaSaidaNaturezaOperacao = 'E'
				THEN ISNULL(CLF.CSTIPIEntradas, '')
				ELSE ISNULL(CLF.CSTIPI, '')
			END
	END	AS	CSTIPI, 
	CASE	WHEN	(NATOP.CSTCOFINS IS NOT NULL AND NATOP.CSTCOFINS != '')
		THEN	NATOP.CSTCOFINS
		ELSE	CASE	WHEN NATOP.EntradaSaidaNaturezaOperacao = 'E'
				THEN ISNULL(CLF.CSTCOFINSEntradas, '')
				ELSE ISNULL(CLF.CSTCOFINS, '')
			END
	END	AS	CSTCOFINS,
	CASE	WHEN	(NATOP.CSTPIS IS NOT NULL AND NATOP.CSTPIS != '')
		THEN	NATOP.CSTPIS
		ELSE	CASE	WHEN NATOP.EntradaSaidaNaturezaOperacao = 'E'
				THEN ISNULL(CLF.CSTPISEntradas, '')
				ELSE ISNULL(CLF.CSTPIS, '')
			END
	END	AS	CSTPIS,
	CLF.CodFiscalOperacao,
	CST.ICMSIsento,
	LIP.CombustivelLinhaProduto, LIP.PneuLinhaProduto,
	CLF.PercPISImportacao, CLF.PercCOFINSImportacao, CLF.PercImpostoImportacao,
	CLF.CodigoNCM, CLF.PercPIS, CLF.PercCOFINS,
	NATOP.SomaPISCOFINSICMSValorContab,
	PL.CondicaoEstocagem, PL.EstoqueMinimoEmergencia,
	---------  Rotina incluida para Empresa CJD - Chrysler utilizado no ModEmitirNFatDup - MoverAtributosItemPedido
	COALESCE(neg.ValorICMSSubstTributariaCV,0) AS 'ValorICMSSTBiPartido',
	COALESCE(tpv.VendaDireta,'F') AS 'VendaDireta',
	COALESCE((dbo.fnBiPartidoNegociacao(PEDCV.CodigoEmpresa, PEDCV.CodigoLocal, PEDCV.NumeroVeiculoCV)),0) AS 'BiPartido',
	CASE	WHEN (dbo.fnIndustria(IP.CodigoEmpresa)) > 0
		THEN COALESCE(neg.ValorDescontoVendaVeic,0) 
		ELSE 0 
	END 'ValorDescontoVendaVeic',
	CST.CSTICMS,
	CST.CFOP,
	CST.CondicaoICMS	AS CondicaoICMSItem,
	CASE	WHEN RIGHT(CST.CSTICMS, 2)  = '60'
		THEN (SELECT dbo.fnRetornaSTUltimaEntrada(IP.CodigoEmpresa, IP.CodigoLocal, CASE WHEN IP.TipoRegistroItemPed = 'VEC' THEN IP.CodigoItemPed ELSE IP.CodigoProduto END, IP.TipoRegistroItemPed, 'B') * CONVERT(MONEY,IP.QuantidadeItemPed))
		ELSE 0
	END 'BaseSTUltimaEntrada',
	CASE	WHEN RIGHT(CST.CSTICMS, 2)  = '60'
		THEN (SELECT dbo.fnRetornaSTUltimaEntrada(IP.CodigoEmpresa, IP.CodigoLocal, CASE WHEN IP.TipoRegistroItemPed = 'VEC' THEN IP.CodigoItemPed ELSE IP.CodigoProduto END, IP.TipoRegistroItemPed, 'I') * CONVERT(MONEY,IP.QuantidadeItemPed))
		ELSE 0
	END 'ICMSSTUltimaEntrada',
	CASE	WHEN RIGHT(CST.CSTICMS, 2)  = '60'
		THEN	CASE	WHEN (CONVERT(MONEY,(IP.PrecoUnitarioItemPed * IP.QuantidadeItemPed)) < (SELECT dbo.fnRetornaSTUltimaEntrada(IP.CodigoEmpresa, IP.CodigoLocal, CASE WHEN IP.TipoRegistroItemPed = 'VEC' THEN IP.CodigoItemPed ELSE IP.CodigoProduto END, IP.TipoRegistroItemPed, 'B') * CONVERT(MONEY,IP.QuantidadeItemPed)))
				THEN ROUND(((SELECT dbo.fnRetornaSTUltimaEntrada(IP.CodigoEmpresa, IP.CodigoLocal, CASE WHEN IP.TipoRegistroItemPed = 'VEC' THEN IP.CodigoItemPed ELSE IP.CodigoProduto END, IP.TipoRegistroItemPed, 'B') * CONVERT(MONEY,IP.QuantidadeItemPed))
					* (SELECT dbo.fnRetornaSTUltimaEntrada(IP.CodigoEmpresa, IP.CodigoLocal, CASE WHEN IP.TipoRegistroItemPed = 'VEC' THEN IP.CodigoItemPed ELSE IP.CodigoProduto END, IP.TipoRegistroItemPed, 'A') / 100))
					- (CONVERT(MONEY,(IP.PrecoUnitarioItemPed * IP.QuantidadeItemPed)) * (SELECT dbo.fnRetornaSTUltimaEntrada(IP.CodigoEmpresa, IP.CodigoLocal, CASE WHEN IP.TipoRegistroItemPed = 'VEC' THEN IP.CodigoItemPed ELSE IP.CodigoProduto END, IP.TipoRegistroItemPed, 'A') / 100)), 2)
				ELSE 0
			END
		ELSE 0
	END 'ValorReembolsoST',
	CST.PercImpostos	AS PercentualAproximadoImpostos,
	PFT.CodigoMarketingCNH,	
	PFT.DescontoEmergencialCNH,
	PFT.DescontoEstoqueCNH,
	PED.Recapagem,
	CST.PercReducaoICMS,
	NATOP.PercReducaoICMSNatOperDestino,
	@BaseICMSTransf AS 'UtilizaUltimaCompra',
	COALESCE(UED.ValorEntrada, 0) AS BaseICMSTransferencia,
	CLF.RedPIS,
	CLF.RedCOFINS

FROM tbItemPedido IP 

INNER JOIN @PosicaoICMS CST
ON	CST.CodigoEmpresa		= IP.CodigoEmpresa
AND	CST.CodigoLocal			= IP.CodigoLocal
AND	CST.CentroCusto			= IP.CentroCusto
AND	CST.NumeroPedido		= IP.NumeroPedido
AND	CST.SequenciaPedido		= IP.SequenciaPedido
AND	CST.ItemPedido			= IP.ItemPedido

INNER JOIN tbPedido PED
ON	PED.CodigoEmpresa		= IP.CodigoEmpresa
AND	PED.CodigoLocal			= IP.CodigoLocal
AND	PED.CentroCusto			= IP.CentroCusto
AND	PED.NumeroPedido		= IP.NumeroPedido
AND	PED.SequenciaPedido		= IP.SequenciaPedido

INNER JOIN tbNaturezaOperacao NATOP
ON	NATOP.CodigoEmpresa		= IP.CodigoEmpresa AND 
	NATOP.CodigoNaturezaOperacao	= IP.CodigoNaturezaOperacao 

INNER JOIN tbLocalFT LFT
ON	LFT.CodigoEmpresa		= IP.CodigoEmpresa
AND	LFT.CodigoLocal			= IP.CodigoLocal

INNER JOIN tbLocal LOC
ON	LOC.CodigoEmpresa		= LFT.CodigoEmpresa
AND	LOC.CodigoLocal			= LFT.CodigoLocal

LEFT JOIN tbProduto PD
ON	PD.CodigoEmpresa		= IP.CodigoEmpresa
AND	PD.CodigoProduto		= CASE	WHEN CONVERT(CHAR(30), IP.CodigoProduto) IS NOT NULL
							THEN CONVERT(CHAR(30), IP.CodigoProduto)
						ELSE CONVERT(CHAR(30), IP.CodigoItemPed)
					END

LEFT JOIN tbPlanejamentoProduto PL
ON	PL.CodigoEmpresa		= IP.CodigoEmpresa AND 
	PL.CodigoLocal			= IP.CodigoLocal and
	PL.CodigoProduto		= IP.CodigoProduto 

LEFT JOIN tbProdutoFT PFT
ON	PFT.CodigoEmpresa		= IP.CodigoEmpresa AND 
	PFT.CodigoProduto		= IP.CodigoProduto 

LEFT JOIN tbClassificacaoFiscal CLF
ON	CLF.CodigoEmpresa		= IP.CodigoEmpresa
AND	CLF.CodigoLocal			= IP.CodigoLocal
AND	CLF.CodigoClassificacaoFiscal	= CST.NCM --dbo.fnRetornaClassifFiscalItem(IP.CodigoEmpresa, IP.CodigoLocal, IP.CentroCusto, IP.NumeroPedido, IP.SequenciaPedido, IP.ItemPedido)

LEFT JOIN tbUnidadeProduto UNPROD
ON	UNPROD.CodigoUnidadeProduto	= PFT.CodigoUnidadeProduto 

LEFT JOIN tbLinhaProduto LIP
ON	LIP.CodigoEmpresa		= PFT.CodigoEmpresa
AND	LIP.CodigoLinhaProduto		= PFT.CodigoLinhaProduto

LEFT JOIN tbPedidoCV PEDCV
ON	PEDCV.CodigoEmpresa		= IP.CodigoEmpresa
AND	PEDCV.CodigoLocal		= IP.CodigoLocal
AND	PEDCV.CentroCusto		= IP.CentroCusto
AND	PEDCV.NumeroPedido		= IP.NumeroPedido
AND	PEDCV.SequenciaPedido		= IP.SequenciaPedido

LEFT JOIN tbNegociacaoCV neg
ON	neg.CodigoEmpresa		= PEDCV.CodigoEmpresa
AND	neg.CodigoLocal			= PEDCV.CodigoLocal
AND	neg.NumeroVeiculoCV		= PEDCV.NumeroVeiculoCV

LEFT JOIN tbTipoPoliticaVenda tpv
ON	tpv.CodigoEmpresa		= neg.CodigoEmpresa
AND	tpv.CodigoTipoPoliticaVenda	= neg.CodigoTipoPoliticaVenda

LEFT JOIN tbVeiculoCV vcv
ON	vcv.CodigoEmpresa		= PEDCV.CodigoEmpresa
AND	vcv.CodigoLocal			= PEDCV.CodigoLocal
AND	vcv.NumeroVeiculoCV		= PEDCV.NumeroVeiculoCV

LEFT JOIN @UED UED
ON	UED.CodigoEmpresa		= IP.CodigoEmpresa
AND	UED.CodigoLocal			= IP.CodigoLocal
AND	UED.CodigoProduto		= IP.CodigoProduto

WHERE	IP.CodigoEmpresa		= @CodigoEmpresa
AND	IP.CodigoLocal			= @CodigoLocal
AND	IP.CentroCusto			= @CentroCusto
AND	IP.NumeroPedido			= @NumeroPedido
AND	IP.SequenciaPedido		= @SequenciaPedido

SET NOCOUNT OFF
SET ANSI_WARNINGS ON

GO
GRANT EXECUTE ON dbo.whLItemPedido TO SQLUsers
GO