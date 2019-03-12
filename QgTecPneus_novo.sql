IF EXISTS(SELECT 1 FROM sys.objects WHERE name = 'QgTecPneus' AND type = 'P')
	DROP PROCEDURE QgTecPneus
	
GO
CREATE PROCEDURE dbo.QgTecPneus

/*
-------------------------------------------------------------------------------------------------------------------------

 QgTecPneus 1160, 0, '2017-11-29', '2017-11-29'
 
-------------------------------------------------------------------------------------------------------------------------
*/

@CodigoEmpresa 	INTEGER, 
@CodigoLocal 		INTEGER, 
@DataInicial 		DATETIME,
@DataFinal	 		DATETIME,
@IncluirItemsMOB	CHAR(1) = 'V'

--WITH ENCRYPTION
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-------------------------------------------------------------------------------------------------------------------------
CREATE TABLE dbo.#tmpListaBDC 
(
	ContaConcessao VARCHAR(8),
	NumeroDocumento VARCHAR(8), 
	Canal VARCHAR(6), 
	DataDocumento VARCHAR(10),
	NomeCliFor VARCHAR(50),
	TipoCliFor VARCHAR(1),
	CPFCNPJ VARCHAR(14),
	CEPCliFor VARCHAR(8),
	MunicipioCliFor VARCHAR(30),
	UFCliFor VARCHAR(2),
	DDDTelefoneCliFor VARCHAR(3),
	TelefoneCliFor VARCHAR(9), 
	ChassiVeiculoOS VARCHAR(17),
	ModeloVeiculoOS VARCHAR(20),
	AnoModeloVeiculoOS VARCHAR(4),
	PlacaVeiculoOS VARCHAR(8), 
	CodigoProduto VARCHAR(20),
	QtdeLancamentoItemDocto VARCHAR(10),
	ValorContabilItemDocto VARCHAR(10),
	CodigoRepresentante VARCHAR(4),
	DescricaoProduto CHAR(40),
	ClassificacaoItem CHAR(20),
	CodigoLinhaProduto VARCHAR(4), 
	Sistema VARCHAR(10), 
	TipoRegistroItemDocto VARCHAR(20),
	ValorCusto VARCHAR(10),
	ValorImpostos VARCHAR(10),
	ValorMargem VARCHAR(10)
)
CREATE TABLE dbo.#tmpLinhaProduto(CodigoLinhaProduto varCHAR(4))

-------------------------------------------------------------------------------------------------------------------------

INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8001')-- MICHELIN/LEVES
INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8002')-- MICHELIN/PESADO
INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8003')-- MICHELIN LEVE
INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8101')-- TIGAR/LEVES
INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8102')-- KORMORAN/PESADO
INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8201')-- BFGOODRIC/LEVES
INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8202')-- BFGOODRIC/PESAD
INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8301')-- PNEUS RECAUCHUT 
INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8302')-- PNEUS RECAUCHUT
INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8401')-- CAMARAS/BICOS   
INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8501')-- MERCADORIAS DIV
INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8502')-- MERC.DIVERSAS 
INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8503')-- BATERIAS
INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8504')-- OLEO LUBRIFICAN  
INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8505')-- FILTRO
INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8701')-- PECAS RODOAR
INSERT INTO #tmpLinhaProduto (CodigoLinhaProduto) VALUES ('8801')-- PECAS MECANICAS

-------------------------------------------------------------------------------------------------------------------------
INSERT dbo.#tmpListaBDC

SELECT 	
	CONVERT(CHAR(8), tbLocal.CGCLocal) ContaConcessao,
	REPLICATE('0', 8 - LEN(tbItemDocumento.NumeroDocumento)) + CAST(tbItemDocumento.NumeroDocumento as VARCHAR(8)) NumeroDocumento,
	CONVERT(CHAR(6), CASE WHEN tbDocumentoFT.OrigemDocumentoFT = 'OS' THEN rtrim(tbDocumentoFT.CodigoCIT)
							when tbCentroCustoSistema.Sistema = 'BALCÃO' THEN 'BALCAO'
							when tbCentroCustoSistema.Sistema = 'TELEPEÇAS' THEN 'TELEPE'					
							when tbDocumentoFT.OrigemDocumentoFT = 'FT' THEN 'BALCAO'
							when tbDocumentoFT.OrigemDocumentoFT = 'TK' THEN 'TELEPE'
							ELSE '      '
					END ) Canal, 
	CONVERT(CHAR(10), tbItemDocumento.DataDocumento, 103) DataDocumento,
	CONVERT(CHAR(50), tbCliFor.NomeCliFor) NomeCliFor,
	tbCliFor.TipoCliFor,
	CONVERT(CHAR(14), CASE WHEN tbCliFor.TipoCliFor = 'J'
				     THEN coalesce(tbCliForJuridica.CGCJuridica,'')
				     ELSE coalesce(tbCliForFisica.CPFFisica,'')
				     END) CPFCNPJ,
	CONVERT(CHAR(8), coalesce(tbCliFor.CEPCliFor,'')) CEPCliFor,
	CONVERT(CHAR(30), coalesce(tbCliFor.MunicipioCliFor,'')) MunicipioCliFor,
	CONVERT(CHAR(2), coalesce(tbCliFor.UFCliFor,'')) UFCliFor,
	CONVERT(CHAR(3), coalesce(tbCliFor.DDDTelefoneCliFor, '000')) DDDTelefoneCliFor,
	CONVERT(CHAR(9), coalesce(tbCliFor.TelefoneCliFor, '000000000')) TelefoneCliFor, 
	CONVERT(CHAR(17), CASE WHEN tbDocumentoFT.OrigemDocumentoFT = 'OS'
			     THEN '' --coalesce(tbOROS.ChassiVeiculoOS,'')
			     ELSE '' 
			     END) ChassiVeiculoOS,
	CONVERT(CHAR(20), CASE WHEN tbDocumentoFT.OrigemDocumentoFT = 'OS'
			     THEN '' --coalesce(tbVeiculoOS.ModeloVeiculoOS,'')
			     ELSE '' 
			     END) ModeloVeiculoOS,
	CONVERT(CHAR(4), CASE WHEN tbDocumentoFT.OrigemDocumentoFT = 'OS'
			     THEN '' --CONVERT(CHAR(4),coalesce(tbVeiculoOS.AnoModeloVeiculoOS,0))
			     ELSE ''
			     END) AnoModeloVeiculoOS,
	CONVERT(CHAR(8), CASE WHEN tbDocumentoFT.OrigemDocumentoFT = 'OS'
			     THEN '' --coalesce(tbVeiculoOS.PlacaVeiculoOS,'')
			     ELSE '' 
			     END) PlacaVeiculoOS, 
	CONVERT(CHAR(20), 
		CASE WHEN tbItemDocumento.TipoRegistroItemDocto in ('PEC', 'CLO') 
			THEN coalesce(tbProdutoFT.CodigoProduto, tbItemDocumento.CodigoProduto, '')
			ELSE 
				CASE WHEN tbMaoObraOS.TipoAcumuladorOS = 'M'
					THEN 'MOO'
					ELSE 
						CASE WHEN tbItemDocumento.TipoRegistroItemDocto  = 'MOB'
							THEN coalesce(tbItemDocumento.CodigoItemDocto, '')
							ELSE 
								CASE WHEN tbDocumentoFT.OrigemDocumentoFT in ('FT') and tbItemDocumento.TipoRegistroItemDocto = 'OUT'
									and tbNaturezaOperacao.CodigoTipoOperacao = 4
									THEN coalesce(tbItemDocumento.CodigoItemDocto, '')
									ELSE
										'OUTROS'
								END
					    END
			    END
		END) CodigoProduto,
	RIGHT(space(25) + REPLACE(CONVERT(varCHAR(25), CONVERT(numeric(18,2), tbItemDocumento.QtdeLancamentoItemDocto)), '.',','), 10) QtdeLancamentoItemDocto,
	CASE  
		WHEN tbItemDocumento.EntradaSaidaDocumento = 'E' THEN REPLACE(CONVERT(CHAR(10), tbItemDocumento.ValorContabilItemDocto * -1 ), '.', ',')
		ELSE
			CASE WHEN (tbDocumento.CondicaoNFCancelada = 'F' AND tbDocumento.TipoLancamentoMovimentacao = 11) THEN
				CONVERT(CHAR(10),  0)
			ELSE
				REPLACE(CONVERT(CHAR(10), tbItemDocumento.ValorContabilItemDocto), '.', ',') 
			END	
	END ValorContabilItemDocto,
	RIGHT( space(4) + CONVERT(varCHAR(4), coalesce(	case	when exists (	select 1 from tbComissaoDocumento cdoc with (nolock) 
																				where cdoc.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa and
																				cdoc.CodigoLocal = tbDocumentoFT.CodigoLocal and
																				cdoc.EntradaSaidaDocumento in ('E','S') and
																				cdoc.NumeroDocumento = tbDocumentoFT.NumeroDocumento and
																				cdoc.DataDocumento = tbDocumentoFT.DataDocumento and
																				cdoc.CodigoCliFor = tbDocumentoFT.CodigoCliFor and
																				cdoc.TipoLancamentoMovimentacao = tbDocumentoFT.TipoLancamentoMovimentacao) 
																	THEN (	select top 1 cdoc.CodigoRepresentante 
																			from tbComissaoDocumento cdoc with (nolock) 
																			where cdoc.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa and
																			cdoc.CodigoLocal = tbDocumentoFT.CodigoLocal and
																			cdoc.EntradaSaidaDocumento in ('E','S') and
																			cdoc.NumeroDocumento = tbDocumentoFT.NumeroDocumento and
																			cdoc.DataDocumento = tbDocumentoFT.DataDocumento and
																			cdoc.CodigoCliFor = tbDocumentoFT.CodigoCliFor and
																			cdoc.TipoLancamentoMovimentacao = tbDocumentoFT.TipoLancamentoMovimentacao)
																ELSE (	select top 1 docrec.CodigoRepresentante 
																		from tbDoctoReceberRepresentante docrec with (nolock) 
																		where docrec.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa and
																		docrec.CodigoLocal = tbDocumentoFT.CodigoLocal and
																		docrec.EntradaSaidaDocumento in ('E','S') and
																		docrec.NumeroDocumento = tbDocumentoFT.NumeroDocumento and
																		docrec.DataDocumento = tbDocumentoFT.DataDocumento and
																		docrec.CodigoCliFor = tbDocumentoFT.CodigoCliFor and
																		docrec.TipoLancamentoMovimentacao = tbDocumentoFT.TipoLancamentoMovimentacao)
														END, '0')), 4) CodigoRepresentante,
	CASE
		WHEN TipoRegistroItemDocto = 'PEC' THEN RIGHT(RTRIM(LTRIM(COALESCE(tbProduto.DescricaoProduto, '#N/D'))), 40)
		WHEN TipoRegistroItemDocto = 'OUT' THEN 'ITEM DE RECAPAGEM'
		WHEN TipoRegistroItemDocto = 'MOB' THEN 'SERVICO DE MAO DE OBRA'
		ELSE '#N/D'
	END DescricaoProduto, 
	CASE 
		WHEN TipoRegistroItemDocto = 'PEC' AND (tbClassificacaoFiscal.DescricaoClassificacaoFiscal = 'PNEUS NOVOS PARA AUTOMOVEIS DE') THEN 'PNEU_NOVO' 
		WHEN TipoRegistroItemDocto = 'PEC' AND (tbClassificacaoFiscal.DescricaoClassificacaoFiscal = 'PNEUS NOVOS PARA ONIBUS OU C') THEN 'PNEU_NOVO' 
		WHEN TipoRegistroItemDocto = 'PEC' AND (tbClassificacaoFiscal.DescricaoClassificacaoFiscal = 'OUTROS PNEUS NOVOS PARA ONIBUS') THEN 'PNEU_NOVO' 
		WHEN TipoRegistroItemDocto = 'PEC' AND tbClassificacaoFiscal.DescricaoClassificacaoFiscal = 'OUTROS PNEUS NOVOS DE BORRACHA' THEN 'ITEM_DE_BORRACHARIA'
		WHEN TipoRegistroItemDocto = 'PEC' AND tbClassificacaoFiscal.DescricaoClassificacaoFiscal = 'OUTROS PNEUS NOVOS DE BORRACHA' THEN 'ITEM_DE_BORRACHARIA'
		WHEN TipoRegistroItemDocto = 'PEC' THEN 'ITEM_DE_BORRACHARIA'
		WHEN TipoRegistroItemDocto = 'OUT' THEN 'RECAPAGEM'
		WHEN TipoRegistroItemDocto = 'MOB' THEN 'MAO_DE_OBRA'
		ELSE SUBSTRING (tbClassificacaoFiscal.DescricaoClassificacaoFiscal, 1 , 20)  
	END ClassificacaoItem,

	CodigoLinhaProduto = CASE WHEN tbLinhaProduto.CodigoLinhaProduto is null THEN 'MOB'
										ELSE RIGHT('0000' + CONVERT(varCHAR(4), tbLinhaProduto.CodigoLinhaProduto), 4)
								END,
	
	Sistema =	CONVERT(CHAR(6),case	when tbDocumentoFT.OrigemDocumentoFT = 'OS' THEN rtrim(tbDocumentoFT.CodigoCIT)
						when tbCentroCustoSistema.Sistema = 'BALCÃO' THEN 'BALCAO'
						when tbCentroCustoSistema.Sistema = 'TELEPEÇAS' THEN 'TELEPE'					
						when tbDocumentoFT.OrigemDocumentoFT = 'FT' THEN 'BALCAO'
						when tbDocumentoFT.OrigemDocumentoFT = 'TK' THEN 'TELEPE'
						ELSE '      '
				END ),
	TipoRegistroItemDocto = tbItemDocumento.TipoRegistroItemDocto,
	ValorCusto = CASE
		WHEN tbItemDocumento.EntradaSaidaDocumento = 'E' THEN
			REPLACE(CONVERT(CHAR(10), tbItemDocumento.CustoLancamentoItemDocto * tbItemDocumento.QtdeLancamentoItemDocto * -1), '.', ',')
		ELSE
			REPLACE(CONVERT(CHAR(10), tbItemDocumento.CustoLancamentoItemDocto * tbItemDocumento.QtdeLancamentoItemDocto), '.', ',')
		END,
	ValorImpostos = CASE
		WHEN tbItemDocumento.EntradaSaidaDocumento = 'E' THEN
			REPLACE(CONVERT(CHAR(10), tbItemDocumento.ValorEncargoFinItemDocto * -1), '.', ',')
		ELSE
			REPLACE(CONVERT(CHAR(10), tbItemDocumento.ValorEncargoFinItemDocto), '.', ',')
		END,
	ValorMargem = CASE
		WHEN tbItemDocumento.EntradaSaidaDocumento = 'E' THEN
			REPLACE(CONVERT(CHAR(10), (tbItemDocumento.ValorContabilItemDocto - tbItemDocumento.ValorEncargoFinItemDocto - tbItemDocumento.CustoLancamentoItemDocto * tbItemDocumento.QtdeLancamentoItemDocto) * -1), '.', ',')
		ELSE
			REPLACE(CONVERT(CHAR(10), tbItemDocumento.ValorContabilItemDocto - tbItemDocumento.ValorEncargoFinItemDocto - tbItemDocumento.CustoLancamentoItemDocto * tbItemDocumento.QtdeLancamentoItemDocto), '.', ',') 
		END
FROM tbItemDocumento with (nolock)

	INNER JOIN tbEmpresa with (nolock) on
		tbEmpresa.CodigoEmpresa = tbItemDocumento.CodigoEmpresa

	INNER JOIN tbLocal with (nolock) on
		tbLocal.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
		tbLocal.CodigoLocal = tbItemDocumento.CodigoLocal

	INNER JOIN tbCliFor with (nolock) on 
		tbCliFor.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
		tbCliFor.CodigoCliFor  = tbItemDocumento.CodigoCliFor

	LEFT JOIN tbCliForFisica with (nolock) on
		tbCliFor.CodigoEmpresa = tbCliForFisica.CodigoEmpresa and
		tbCliFor.CodigoCliFor  = tbCliForFisica.CodigoCliFor

	LEFT JOIN tbCliForJuridica with (nolock) on
		tbCliFor.CodigoEmpresa = tbCliForJuridica.CodigoEmpresa and
		tbCliFor.CodigoCliFor  = tbCliForJuridica.CodigoCliFor

	INNER JOIN tbDocumentoFT with (nolock) on
	    tbDocumentoFT.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
		tbDocumentoFT.CodigoLocal = tbItemDocumento.CodigoLocal and
		tbDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento and
		tbDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento and
		tbDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento and
		tbDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor and
		tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
		
	LEFT JOIN tbCentroCustoSistema with (nolock) on 
	    tbCentroCustoSistema.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa and
		tbCentroCustoSistema.CentroCusto = tbDocumentoFT.CentroCusto

	INNER JOIN tbDocumento with (nolock) on
	    tbDocumento.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
		tbDocumento.CodigoLocal = tbItemDocumento.CodigoLocal and
		tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento and
		tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento and
		tbDocumento.DataDocumento = tbItemDocumento.DataDocumento and
		tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor and
		tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao

	INNER JOIN tbNaturezaOperacao with (nolock) on
		tbNaturezaOperacao.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
		tbNaturezaOperacao.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao

	LEFT JOIN tbPedidoOS with (nolock) on
	    tbPedidoOS.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
		tbPedidoOS.CodigoLocal = tbItemDocumento.CodigoLocal and
		tbPedidoOS.CentroCusto = tbDocumentoFT.CentroCusto and
		tbPedidoOS.NumeroPedido = tbDocumento.NumeroPedidoDocumento and
		tbPedidoOS.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento

	LEFT JOIN tbOROS with (nolock) on
	    tbOROS.CodigoEmpresa = tbPedidoOS.CodigoEmpresa and
		tbOROS.CodigoLocal = tbPedidoOS.CodigoLocal and
		tbOROS.FlagOROS = 'S' and 
		tbOROS.NumeroOROS = tbPedidoOS.CodigoOrdemServicoPedidoOS

	LEFT JOIN tbVeiculoOS with (nolock) on
	    tbVeiculoOS.CodigoEmpresa = tbPedidoOS.CodigoEmpresa and
		tbVeiculoOS.ChassiVeiculoOS = tbOROS.ChassiVeiculoOS

	LEFT JOIN tbMaoObraOS with (nolock) on
	    tbMaoObraOS.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and 
	    tbMaoObraOS.CodigoMaoObraOS = tbItemDocumento.CodigoItemDocto

	LEFT JOIN tbProdutoFT with (nolock) on
		tbProdutoFT.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
		tbProdutoFT.CodigoProduto = tbItemDocumento.CodigoProduto and
		tbProdutoFT.CodigoFonteFornecimento = tbProdutoFT.CodigoFonteFornecimento
		
	LEFT JOIN tbLinhaProduto with (nolock) on
		tbLinhaProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa and
		tbLinhaProduto.CodigoLinhaProduto = tbProdutoFT.CodigoLinhaProduto 

	LEFT JOIN tbClassificacaoFiscal with (nolock) on
	    tbClassificacaoFiscal.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
		tbClassificacaoFiscal.CodigoLocal = tbItemDocumento.CodigoLocal and
		tbClassificacaoFiscal.CodigoClassificacaoFiscal = CAST(tbItemDocumento.CodigoClassificacaoFiscal AS CHAR(10))

	LEFT JOIN tbProduto with (nolock) on
	    tbProduto.CodigoEmpresa = tbItemDocumento.CodigoEmpresa and
		tbProduto.CodigoProduto = tbItemDocumento.CodigoProduto

WHERE tbItemDocumento.CodigoEmpresa = @CodigoEmpresa
	AND tbItemDocumento.CodigoLocal = @CodigoLocal
	AND tbItemDocumento.DataDocumento BETWEEN @DataInicial and @DataFinal 
	AND 
	(
		(tbDocumento.CondicaoNFCancelada = 'F' AND tbDocumento.TipoLancamentoMovimentacao = 11) OR
		(tbDocumento.CondicaoNFCancelada = 'F' AND tbDocumento.TipoLancamentoMovimentacao = 7)
	)
	AND tbDocumentoFT.CentroCusto IN (27730)
	AND (tbDocumentoFT.OrigemDocumentoFT in ('FT', 'TK') OR (tbDocumentoFT.OrigemDocumentoFT = 'OS' AND tbProdutoFT.CodigoLinhaProduto IN (7, 10, 20)) OR (tbDocumentoFT.OrigemDocumentoFT = 'OS' AND tbDocumentoFT.CodigoCIT = 'P1'))
	AND tbItemDocumento.TipoRegistroItemDocto in ('PEC', 'CLO', 'MOB', 'OUT')


	---------------------------------------------------------------------------------------------------------------------
	-- CONSIDERAR DOCUMENTOS DE VENDA E DEVOLUÇÃO DE VENDAS - Ticket 104361 - MBB
	---------------------------------------------------------------------------------------------------------------------
	and	(	
			----------------------------------------------------------------------------------------
			-- VENDAS
			----------------------------------------------------------------------------------------
			(	tbNaturezaOperacao.EntradaSaidaNaturezaOperacao = 'S'
				and	(	(	tbDocumentoFT.OrigemDocumentoFT = 'OS' 
							and (tbNaturezaOperacao.CodigoTipoOperacao = 3 or tbNaturezaOperacao.CodigoTipoOperacao = 10)
							and tbOROS.ChassiVeiculoOS is not null
							and tbOROS.ChassiVeiculoOS <> ''
						)
						or 
						(	tbDocumentoFT.OrigemDocumentoFT in ('FT','TK') 
							and tbNaturezaOperacao.CodigoTipoOperacao = 3
							and tbItemDocumento.TipoRegistroItemDocto <> 'MOB'
						)
						or 
						(	tbDocumentoFT.OrigemDocumentoFT in ('FT')
							and tbItemDocumento.TipoRegistroItemDocto = 'OUT'
							and tbNaturezaOperacao.CodigoTipoOperacao = 4
						)
					)
				
				and	(	(tbItemDocumento.TipoRegistroItemDocto in ('PEC','CLO') and tbNaturezaOperacao.CodigoTipoOperacao = 3) 
						or 
						(tbItemDocumento.TipoRegistroItemDocto in ('OUT') and tbNaturezaOperacao.CodigoTipoOperacao = 4 and tbDocumentoFT.OrigemDocumentoFT = 'FT')
						or
						(tbItemDocumento.TipoRegistroItemDocto	= 'MOB')
					)
			)
			
		OR
			----------------------------------------------------------------------------------------
			-- DEVOLUÇÕES
			----------------------------------------------------------------------------------------
			(	
				(tbNaturezaOperacao.EntradaSaidaNaturezaOperacao = 'E' and tbNaturezaOperacao.CodigoTipoOperacao = 7)
				
				and	(	
						(	tbDocumentoFT.OrigemDocumentoFT = 'OS' and tbOROS.ChassiVeiculoOS is not null and tbOROS.ChassiVeiculoOS <> '' )
						or 
						(	tbDocumentoFT.OrigemDocumentoFT in ('FT','TK') and tbItemDocumento.TipoRegistroItemDocto <> 'MOB')
					)
				
				and	(	tbItemDocumento.TipoRegistroItemDocto in ('PEC','CLO') or tbItemDocumento.TipoRegistroItemDocto	= 'MOB' )
			)
		OR
			----------------------------------------------------------------------------------------
			-- CANCELAMENTOS (incl. 01/11/2017 - GA)
			----------------------------------------------------------------------------------------
			(	
				tbDocumento.CondicaoNFCancelada = 'F' AND tbDocumento.TipoLancamentoMovimentacao = 11
			)
	
		)

ORDER BY tbItemDocumento.DataDocumento, tbDocumento.TipoLancamentoMovimentacao, tbItemDocumento.NumeroDocumento

if @IncluirItemsMOB = 'F' begin
	delete from #tmpListaBDC where TipoRegistroItemDocto = 'MOB' 
END

	
-------------------------------------------------------------------------------------------------------------------------
SET NOCOUNT OFF

-------------------------------------------------------------------------------------------------------------------------

SELECT 
	a.ContaConcessao, a.NumeroDocumento, a.Canal, a.DataDocumento,
	a.NomeCliFor, a.TipoCliFor, a.CPFCNPJ, a.CEPCliFor, a.MunicipioCliFor, a.UFCliFor, a.DDDTelefoneCliFor, a.TelefoneCliFor, 
	a.ChassiVeiculoOS, a.ModeloVeiculoOS, a.AnoModeloVeiculoOS, a.PlacaVeiculoOS, a.CodigoProduto, a.QtdeLancamentoItemDocto,
	a.ValorContabilItemDocto, a.CodigoRepresentante, a.ClassificacaoItem, a.DescricaoProduto, a.ValorCusto, a.ValorImpostos, a.ValorMargem
--	a.CodigoLinhaProduto, a.TipoRegistroItemDocto, a.Sistema
FROM dbo.#tmpListaBDC a
	INNER JOIN dbo.#tmpLinhaProduto b on a.CodigoLinhaProduto = b.CodigoLinhaProduto 
ORDER BY a.ContaConcessao, CONVERT(datetime, a.DataDocumento, 103), a.NumeroDocumento

-------------------------------------------------------------------------------------------------------------------------
DROP TABLE dbo.#tmpListaBDC
DROP TABLE dbo.#tmpLinhaProduto

-------------------------------------------------------------------------------------------------------------------------


