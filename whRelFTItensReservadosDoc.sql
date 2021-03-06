IF EXISTS(SELECT 1 FROM sysobjects WHERE id = OBJECT_ID('dbo.whRelFTItensReservadosDoc'))
	DROP PROCEDURE dbo.whRelFTItensReservadosDoc
GO
CREATE PROCEDURE dbo.whRelFTItensReservadosDoc

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil 
 PROJETO......: Sistema de Faturamento
 AUTOR........: Fabio Gori Formentin 
 DATA.........: 24/01/2003
 UTILIZADO EM : ftRelItensReservados
 OBJETIVO.....: Listar os Documentos de itens reservados pelo Faturamento, Telemarketing, 
				Oficina obedecendo do produto ate produto.
 Alterado.....: 27/04/2007 - Carlos
				Inclus�o da impress�o da Data do Pedido e Data da Ordem de Servi�o.

 ALTERACAO....:	Edvaldo Ragassi - 06/08/2007
 OBJETIVO.....:	Reestruturacao da procedure.

 ALTERACAO....:	Bruno T. Couto - 15/02/2011
 OBJETIVO.....:	Altera��o de Consistencia Codigo Cliente Fornecedor.

 ALTERACAO....:	Marcelo Palharim - 19/02/2016
 OBJETIVO.....:	Inclus�o de select para requisicoes de saida.
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa		dtInteiro04,
@CodigoLocal		dtInteiro04,
@DoProduto		VarChar(30),
@AteProduto		VarChar(30),
@SistemaFT		Varchar(1),
@SistemaTK		Varchar(1),
@SistemaOS		Varchar(1)

--WITH ENCRYPTION
AS

------------------------------------------------------------------
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
------------------------------------------------------------------

DECLARE @PeriodoAtual		dtAnoMes


SELECT	@PeriodoAtual	= PeriodoAtualEstoque
FROM	tbEmpresaCE
WHERE	CodigoEmpresa	= @CodigoEmpresa

------------------------------------------------------------------
	SELECT 	Ped.CodigoEmpresa as CodigoEmpresa,
		Ped.CodigoLocal as CodigoLocal,
		Ped.CentroCusto as CentroCusto,
		Ped.NumeroPedido as NumeroPedido,
		Ped.DataPedidoPed	as DataPedido,
		Ped.OrigemPedido	as Origem,
		Item.PrecoTotalItemPed	as ValorContabil,
		Item.CodigoAlmoxarifadoDestino	as CodigoAlmoxarifado,
		Item.CodigoProduto as CodigoProduto,
		Item.QuantidadeItemPed as QuantidadeItemPed,
		ProdFT.PrecoReposicaoIndiceProduto as PrecoReposicaoIndiceProduto,
		Prod.DescricaoProduto as DescricaoProduto,  
		null			as NumeroOS,		
		null			as CodigoCIT,
		null			as DataOROS,
		case when Ped.TipoPedidoPed in (1, 2)
				then PedVenda.CodigoCliForFat
			 when Ped.TipoPedidoPed in (4)
				then PedDevol.CodigoCliFor
			 when Ped.TipoPedidoPed in (6)
				then ISNULL(PedRemes.CodigoCliFor, PedTransf.CodigoCliFor)
		end as CodigoCliFor,
		(select NomeCliFor from tbCliFor where CodigoEmpresa = Ped.CodigoEmpresa
			and CodigoCliFor = (case when Ped.TipoPedidoPed in (1, 2)
				then PedVenda.CodigoCliForFat
			 when Ped.TipoPedidoPed in (4)
				then PedDevol.CodigoCliFor
			 when Ped.TipoPedidoPed in (6)
				then ISNULL(PedRemes.CodigoCliFor, PedTransf.CodigoCliFor)
			 end))	as NomeCliFor,
		Custo.CustoMedioUnitario		as CustoUnitario
	from 	tbPedido Ped 
	inner join tbItemPedido Item  on 
	Ped.CodigoEmpresa	= Item.CodigoEmpresa and 
	Ped.CodigoLocal		= Item.CodigoLocal and
	Ped.CentroCusto		= Item.CentroCusto and
	Ped.NumeroPedido	= Item.NumeroPedido and
	Ped.SequenciaPedido	= Item.SequenciaPedido 
	inner join tbPedidoComplementar PedComp  on
	Ped.CodigoEmpresa 	= PedComp.CodigoEmpresa and
	Ped.CodigoLocal  	= PedComp.CodigoLocal and
	Ped.CentroCusto 	= PedComp.CentroCusto and
	Ped.NumeroPedido 	= PedComp.NumeroPedido and
	Ped.SequenciaPedido 	= PedComp.SequenciaPedido 
	left join tbPedidoVenda PedVenda  on
	Ped.CodigoEmpresa 	= PedVenda.CodigoEmpresa and
	Ped.CodigoLocal  	= PedVenda.CodigoLocal and
	Ped.CentroCusto 	= PedVenda.CentroCusto and
	Ped.NumeroPedido 	= PedVenda.NumeroPedido and
	Ped.SequenciaPedido 	= PedVenda.SequenciaPedido 
	inner join tbAlmoxarifado Almox  on 
	Item.CodigoEmpresa		= Almox.CodigoEmpresa and
	Item.CodigoLocal		= Almox.CodigoLocal and
	Item.CodigoAlmoxarifadoDestino 	= Almox.CodigoAlmoxarifado
	inner join tbProduto Prod  on 
	Item.CodigoEmpresa	= Prod.CodigoEmpresa and
	Item.CodigoProduto	= Prod.CodigoProduto
	inner join tbProdutoFT ProdFT  on 
	Prod.CodigoEmpresa	= ProdFT.CodigoEmpresa and
	Prod.CodigoProduto	= ProdFT.CodigoProduto
	inner join vwCustoMedioProdutoPeriodo Custo on
	Custo.CodigoEmpresa	= Item.CodigoEmpresa and
	Custo.CodigoLocal	= Item.CodigoLocal and
	Custo.CodigoProduto	= Item.CodigoProduto
	left join tbPedidoDevolucaoCompra PedDevol on
	Ped.CodigoEmpresa	= PedDevol.CodigoEmpresa And
	Ped.CodigoLocal		= PedDevol.CodigoLocal	 And
	Ped.CentroCusto		= PedDevol.CentroCusto	 And
	Ped.NumeroPedido	= PedDevol.NumeroPedido	 And
	Ped.SequenciaPedido = PedDevol.SequenciaPedido
	left join tbPedidoRemessa PedRemes on
	Ped.CodigoEmpresa	= PedRemes.CodigoEmpresa And
	Ped.CodigoLocal		= PedRemes.CodigoLocal	 And
	Ped.CentroCusto		= PedRemes.CentroCusto	 And
	Ped.NumeroPedido	= PedRemes.NumeroPedido  And
	Ped.SequenciaPedido = PedRemes.SequenciaPedido
	left join tbPedidoTransferencia PedTransf on
	Ped.CodigoEmpresa	= PedTransf.CodigoEmpresa And
	Ped.CodigoLocal		= PedTransf.CodigoLocal	  And
	Ped.CentroCusto		= PedTransf.CentroCusto	  And
	Ped.NumeroPedido	= PedTransf.NumeroPedido  And
	Ped.SequenciaPedido = PedTransf.SequenciaPedido
	where 	Ped.CodigoEmpresa		= @CodigoEmpresa and
		Ped.CodigoLocal 		= @CodigoLocal and
		Ped.StatusPedidoPed		in (1, 2, 3, 8, 9) and
		Ped.TipoPedidoPed		in (1, 2, 4, 6) and 
		Ped.OrigemPedido		= 'FT' and
		Item.CodigoProduto 		between @DoProduto and @AteProduto and 
		Almox.TipoAlmoxarifadoConsumo 	IN ('D', 'P') and
		CONVERT(CHAR(6),Custo.PeriodoValorEstoque)	= CONVERT(CHAR(6),@PeriodoAtual) and
		@SistemaFT			= 'V'

UNION ALL

	select 	Ped.CodigoEmpresa as CodigoEmpresa,
		Ped.CodigoLocal as CodigoLocal,
		Ped.CentroCusto as CentroCusto,
		Ped.NumeroPedido as NumeroPedido,
		Ped.DataPedidoPed		as DataPedido,
		Ped.OrigemPedido		as Origem,
		Item.PrecoTotalItemPed		as ValorContabil,
		Item.CodigoAlmoxarifadoDestino	as CodigoAlmoxarifado,
		Item.CodigoProduto as CodigoProduto,
		Item.QuantidadeItemPed as QuantidadeItemPed,
		ProdFT.PrecoReposicaoIndiceProduto as PrecoReposicaoIndiceProduto,
		Prod.DescricaoProduto as DescricaoProduto,  
		null				as NumeroOS,
		null				as CodigoCIT,
		null				as DataOROS,
		case when PedVenda.CodigoCliForFat is Null
		     then ISNULL(Ped.CodigoCliFor,PedComp.CodigoCliFor)
		     else PedVenda.CodigoCliForFat
	             end			as CodigoCliFor,
		(select NomeCliFor from tbCliFor where CodigoEmpresa = Ped.CodigoEmpresa
			and CodigoCliFor = (case when PedVenda.CodigoCliForFat is Null
						then ISNULL(Ped.CodigoCliFor,PedComp.CodigoCliFor)
						else PedVenda.CodigoCliForFat
						end))	as NomeCliFor,
		Custo.CustoMedioUnitario		as CustoUnitario
	from 	tbPedido Ped 
	inner join tbPedidoTK PedTK on 
	Ped.CodigoEmpresa	= PedTK.CodigoEmpresa and 
	Ped.CodigoLocal		= PedTK.CodigoLocal and
	Ped.CentroCusto		= PedTK.CentroCusto and
	Ped.NumeroPedido	= PedTK.NumeroPedido and
	Ped.SequenciaPedido	= PedTK.SequenciaPedido 
	inner join tbPedidoComplementar PedComp  on
	Ped.CodigoEmpresa 	= PedComp.CodigoEmpresa and
	Ped.CodigoLocal  	= PedComp.CodigoLocal and
	Ped.CentroCusto 	= PedComp.CentroCusto and
	Ped.NumeroPedido 	= PedComp.NumeroPedido and
	Ped.SequenciaPedido 	= PedComp.SequenciaPedido 
	left join tbPedidoVenda PedVenda  on
	Ped.CodigoEmpresa 	= PedVenda.CodigoEmpresa and
	Ped.CodigoLocal  	= PedVenda.CodigoLocal and
	Ped.CentroCusto 	= PedVenda.CentroCusto and
	Ped.NumeroPedido 	= PedVenda.NumeroPedido and
	Ped.SequenciaPedido 	= PedVenda.SequenciaPedido 
	inner join tbItemPedido Item  on 
	Ped.CodigoEmpresa	= Item.CodigoEmpresa and 
	Ped.CodigoLocal		= Item.CodigoLocal and
	Ped.CentroCusto		= Item.CentroCusto and
	Ped.NumeroPedido	= Item.NumeroPedido and
	Ped.SequenciaPedido	= Item.SequenciaPedido 
	inner join tbAlmoxarifado Almox  on 
	Item.CodigoEmpresa		= Almox.CodigoEmpresa and
	Item.CodigoLocal		= Almox.CodigoLocal and
	Item.CodigoAlmoxarifadoDestino 	= Almox.CodigoAlmoxarifado
	inner join tbProduto Prod  on 
	Item.CodigoEmpresa	= Prod.CodigoEmpresa and
	Item.CodigoProduto	= Prod.CodigoProduto
	inner join tbProdutoFT ProdFT  on 
	Prod.CodigoEmpresa	= ProdFT.CodigoEmpresa and
	Prod.CodigoProduto	= ProdFT.CodigoProduto
	inner join vwCustoMedioProdutoPeriodo Custo on
	Custo.CodigoEmpresa	= Item.CodigoEmpresa and
	Custo.CodigoLocal	= Item.CodigoLocal and
	Custo.CodigoProduto	= Item.CodigoProduto
	where 	Ped.CodigoEmpresa		= @CodigoEmpresa and
		Ped.CodigoLocal 		= @CodigoLocal and
		Ped.StatusPedidoPed		in (1, 2, 3, 8, 9) and
		Ped.TipoPedidoPed		in (1, 2, 9) and 
		Ped.OrigemPedido		= 'TK' and
		PedTK.ReservaEstoquePedidoTK	= 'V' and
		PedTK.StatusPedidoTK		= 1 and
		Item.CodigoProduto 		between @DoProduto and @AteProduto and 
		Almox.TipoAlmoxarifadoConsumo 	IN ('D', 'P') and
		CONVERT(CHAR(6), Custo.PeriodoValorEstoque)	= CONVERT(CHAR(6), @PeriodoAtual) and
		@SistemaTK			= 'V'

UNION ALL

	select 	ProdOROS.CodigoEmpresa as CodigoEmpresa,
		ProdOROS.CodigoLocal as CodigoLocal,
		null as CentroCusto,
		null as NumeroPedido,
		null 				as DataPedido,
		'OS'				as Origem,
		ItemOROS.ValorLiquidoItemOS	as ValorContabil,
		ReqOS.CodigoAlmoxReservaReqOS	as CodigoAlmoxarifado,
		ReqOS.CodigoProduto as CodigoProduto,	
		ReqOS.QtdeAtendidaAcumRequisicaoOS	as QuantidadeItemPed,
		ProdFT.PrecoReposicaoIndiceProduto as PrecoReposicaoIndiceProduto,
		Prod.DescricaoProduto as DescricaoProduto,  
		ProdOROS.NumeroOROS		as NumeroOS,
		ProdOROS.CodigoCIT as CodigoCIT,
		OROS.DataAberturaOS		as DataOROS,
		OROS.CodigoCliFor as CodigoCliFor,
		(select NomeCliFor from tbCliFor 
			where CodigoEmpresa = OROS.CodigoEmpresa
			and CodigoCliFor = OROS.CodigoCliFor) as NomeCliFor,
		Custo.CustoMedioUnitario	as CustoUnitario
	from tbItemProdOROS ProdOROS  
	inner join tbItemOROS ItemOROS  on 
	ProdOROS.CodigoEmpresa 		= ItemOROS.CodigoEmpresa and
	ProdOROS.CodigoLocal 		= ItemOROS.CodigoLocal and 
	ProdOROS.FlagOROS  		= ItemOROS.FlagOROS and 
	ProdOROS.NumeroOROS 		= ItemOROS.NumeroOROS and 
	ProdOROS.CodigoCIT 		= ItemOROS.CodigoCIT and 
	ProdOROS.TipoItemOS  		= ItemOROS.TipoItemOS and
	ProdOROS.SequenciaItemOS 	= ItemOROS.SequenciaItemOS
	inner join tbRequisicaoOS ReqOS  on 
	ProdOROS.CodigoEmpresa 		= ReqOS.CodigoEmpresa and
	ProdOROS.CodigoLocal 		= ReqOS.CodigoLocal and
	ProdOROS.FlagOROS 		= ReqOS.FlagOROS and
	ProdOROS.NumeroOROS 		= ReqOS.NumeroOROS and
	ProdOROS.CodigoCIT 		= ReqOS.CodigoCIT and
	ProdOROS.CodigoProdutoItemOROS 	= ReqOS.CodigoProduto 
	inner join tbProduto Prod  on 
	ProdOROS.CodigoEmpresa 		= Prod.CodigoEmpresa and
	ProdOROS.CodigoProdutoItemOROS 	= Prod.CodigoProduto
	inner join tbProdutoFT ProdFT  on 
	Prod.CodigoEmpresa	= ProdFT.CodigoEmpresa and
	Prod.CodigoProduto	= ProdFT.CodigoProduto
	inner join tbOROS OROS  on  
	ProdOROS.CodigoEmpresa 		= OROS.CodigoEmpresa and
	ProdOROS.CodigoLocal  		= OROS.CodigoLocal and 
	ProdOROS.FlagOROS  		= OROS.FlagOROS and 
	ProdOROS.NumeroOROS 		= OROS.NumeroOROS 
	inner join tbOROSCIT OROSCIT  on
	ProdOROS.CodigoEmpresa  	= OROSCIT.CodigoEmpresa and
	ProdOROS.CodigoLocal  		= OROSCIT.CodigoLocal and 
	ProdOROS.FlagOROS  		= OROSCIT.FlagOROS and 
	ProdOROS.NumeroOROS  		= OROSCIT.NumeroOROS and 
	ProdOROS.CodigoCIT 		= OROSCIT.CodigoCIT
	inner join vwAlmoxarifadosEstoque almox on
	almox.CodigoEmpresa		= ReqOS.CodigoEmpresa and
	almox.CodigoLocal		= ReqOS.CodigoLocal and
	almox.CodigoAlmoxarifado	= ReqOS.CodigoAlmoxReservaReqOS
	inner join vwCustoMedioProdutoPeriodo Custo on
	Custo.CodigoEmpresa	= ProdOROS.CodigoEmpresa and
	Custo.CodigoLocal	= ProdOROS.CodigoLocal and
	Custo.CodigoProduto	= ProdOROS.CodigoProdutoItemOROS
	where	ProdOROS.CodigoEmpresa		= @CodigoEmpresa and
		ProdOROS.CodigoLocal 		= @CodigoLocal and
		ProdOROS.FlagOROS 		= 'S' and
		ProdOROS.TipoItemOS 		<> 'M' and -- Excluir da pesquisa registros de m�o-de-obra
		(OROSCIT.StatusOSCIT 		in ('A', 'E') or OROSCIT.StatusOSCIT = 'N' and not exists (select 1 from tbOROSCITPedido where CodigoEmpresa = @CodigoEmpresa 		and CodigoLocal = @CodigoLocal and NumeroOROS = ProdOROS.NumeroOROS and CodigoCIT = ProdOROS.CodigoCIT and SequenciaPedido in (1,2))) and
		ProdOROS.CodigoProdutoItemOROS 	between @DoProduto and @AteProduto and
		CONVERT(CHAR(6), Custo.PeriodoValorEstoque)	= CONVERT(CHAR(6), @PeriodoAtual) and
		@SistemaOS			= 'V'

UNION ALL

	select 	ProdOROS.CodigoEmpresa as CodigoEmpresa,
		ProdOROS.CodigoLocal as CodigoLocal,
		null as CentroCusto,
		null  as NumeroPedido,
		null 				as DataPedido,
		'OS'				as Origem,
		ItemOROS.ValorLiquidoItemOS	as ValorContabil,
		ReqOS.CodigoAlmoxReservaReqOS	as CodigoAlmoxarifado,
		ReqOS.CodigoProduto as CodigoProduto,	
		ReqOS.QtdeAtendidaAcumRequisicaoOS	as QuantidadeItemPed,
		ProdFT.PrecoReposicaoIndiceProduto as PrecoReposicaoIndiceProduto,
		Prod.DescricaoProduto as DescricaoProduto,  
		ProdOROS.NumeroOROS		as NumeroOS,
		ProdOROS.CodigoCIT as CodigoCIT,
		OROS.DataAberturaOS		as DataOROS,
		OROS.CodigoCliFor as CodigoCliFor,
		(select NomeCliFor from tbCliFor 
			where CodigoEmpresa = OROS.CodigoEmpresa
			and CodigoCliFor = OROS.CodigoCliFor) as NomeCliFor,
		Custo.CustoMedioConsignado	as CustoUnitario
	from tbItemProdOROS ProdOROS  
	inner join tbItemOROS ItemOROS  on 
	ProdOROS.CodigoEmpresa 		= ItemOROS.CodigoEmpresa and
	ProdOROS.CodigoLocal 		= ItemOROS.CodigoLocal and 
	ProdOROS.FlagOROS  		= ItemOROS.FlagOROS and 
	ProdOROS.NumeroOROS 		= ItemOROS.NumeroOROS and 
	ProdOROS.CodigoCIT 		= ItemOROS.CodigoCIT and 
	ProdOROS.TipoItemOS  		= ItemOROS.TipoItemOS and
	ProdOROS.SequenciaItemOS 	= ItemOROS.SequenciaItemOS
	inner join tbRequisicaoOS ReqOS  on 
	ProdOROS.CodigoEmpresa 		= ReqOS.CodigoEmpresa and
	ProdOROS.CodigoLocal 		= ReqOS.CodigoLocal and
	ProdOROS.FlagOROS 		= ReqOS.FlagOROS and
	ProdOROS.NumeroOROS 		= ReqOS.NumeroOROS and
	ProdOROS.CodigoCIT 		= ReqOS.CodigoCIT and
	ProdOROS.CodigoProdutoItemOROS 	= ReqOS.CodigoProduto 
	inner join tbProduto Prod  on 
	ProdOROS.CodigoEmpresa 		= Prod.CodigoEmpresa and
	ProdOROS.CodigoProdutoItemOROS 	= Prod.CodigoProduto
	inner join tbProdutoFT ProdFT  on 
	Prod.CodigoEmpresa	= ProdFT.CodigoEmpresa and
	Prod.CodigoProduto	= ProdFT.CodigoProduto
	inner join tbOROS OROS  on  
	ProdOROS.CodigoEmpresa 		= OROS.CodigoEmpresa and
	ProdOROS.CodigoLocal  		= OROS.CodigoLocal and 
	ProdOROS.FlagOROS  		= OROS.FlagOROS and 
	ProdOROS.NumeroOROS 		= OROS.NumeroOROS 
	inner join tbOROSCIT OROSCIT  on
	ProdOROS.CodigoEmpresa  	= OROSCIT.CodigoEmpresa and
	ProdOROS.CodigoLocal  		= OROSCIT.CodigoLocal and 
	ProdOROS.FlagOROS  		= OROSCIT.FlagOROS and 
	ProdOROS.NumeroOROS  		= OROSCIT.NumeroOROS and 
	ProdOROS.CodigoCIT 		= OROSCIT.CodigoCIT
	inner join vwAlmoxarifadosConsignado almox on
	almox.CodigoEmpresa		= ReqOS.CodigoEmpresa and
	almox.CodigoLocal		= ReqOS.CodigoLocal and
	almox.CodigoAlmoxarifado	= ReqOS.CodigoAlmoxReservaReqOS
	inner join vwCustoMedioConsignadoPeriodo Custo on
	Custo.CodigoEmpresa	= ProdOROS.CodigoEmpresa and
	Custo.CodigoLocal	= ProdOROS.CodigoLocal and
	Custo.CodigoProduto	= ProdOROS.CodigoProdutoItemOROS
	where	ProdOROS.CodigoEmpresa		= @CodigoEmpresa and
		ProdOROS.CodigoLocal 		= @CodigoLocal and
		ProdOROS.FlagOROS 		= 'S' and
		ProdOROS.TipoItemOS 		<> 'M' and -- Excluir da pesquisa registros de m�o-de-obra
		(OROSCIT.StatusOSCIT 		in ('A', 'E') or OROSCIT.StatusOSCIT = 'N' and not exists (select 1 from tbOROSCITPedido where CodigoEmpresa = @CodigoEmpresa 		and CodigoLocal = @CodigoLocal and NumeroOROS = ProdOROS.NumeroOROS and CodigoCIT = ProdOROS.CodigoCIT and SequenciaPedido in (1,2))) and
		ProdOROS.CodigoProdutoItemOROS 	between @DoProduto and @AteProduto and
		CONVERT(CHAR(6), Custo.PeriodoValorEstoque)	= CONVERT(CHAR(6), @PeriodoAtual) and
		@SistemaOS			= 'V'

UNION ALL

---------------   Verificar se existem Itens de Recapagem em aberto

SELECT tbFichaControleProducao.CodigoEmpresa				as CodigoEmpresa ,
		tbFichaControleProducao.CodigoLocal					as CodigoLocal,
		tbFichaControleProducao.CentroCusto					as CentroCusto,
		tbFichaControleProducao.NumeroFicha 				as NumeroPedido,
		tbFichaControleProducao.Data						as DataPedido,
		'SR'												as Origem,
		tbFichaControleProducao.ValorBruto 					as ValorContabil,
		tbFichaControleProducao.CodigoAlmoxarifadoDestino	as CodigoAlmoxarifado,
		tbFichaControleProducao.CodigoBanda					as CodigoProduto,
		tbFichaControleProducao.QuantidadeBanda				as QuantidadeItemPed,
		ProdFT.PrecoReposicaoIndiceProduto					as PrecoReposicaoIndiceProduto,
		Prod.DescricaoProduto								as DescricaoProduto,  
		null												as NumeroOS,		
		null												as CodigoCIT,
		null												as DataOROS,
		tbFichaControleProducao.CodigoCliente 				as CodigoCliFor,
		tbCliFor.NomeCliFor									as NomeCliFor,
		tbFichaControleProducao.ValorBanda					as CustoUnitario

	from tbFichaControleProducao  
	inner join tbCliFor		on 
	tbCliFor.CodigoEmpresa	= tbFichaControleProducao.CodigoEmpresa and
	tbCliFor.CodigoCliFor	= tbFichaControleProducao.CodigoCliente
	
	inner join tbAlmoxarifado Almox			on 
	tbFichaControleProducao.CodigoEmpresa	= Almox.CodigoEmpresa and
	tbFichaControleProducao.CodigoLocal		= Almox.CodigoLocal and
	tbFichaControleProducao.CodigoAlmoxarifadoDestino = Almox.CodigoAlmoxarifado

	inner join tbProduto Prod  on 
	tbFichaControleProducao.CodigoEmpresa	= Prod.CodigoEmpresa and
	tbFichaControleProducao.CodigoBanda		= Prod.CodigoProduto

	inner join tbProdutoFT ProdFT  on 
	Prod.CodigoEmpresa	= ProdFT.CodigoEmpresa and
	Prod.CodigoProduto	= ProdFT.CodigoProduto

	inner join vwCustoMedioProdutoPeriodo Custo on
	Custo.CodigoEmpresa	= tbFichaControleProducao.CodigoEmpresa and
	Custo.CodigoLocal	= tbFichaControleProducao.CodigoLocal and
	Custo.CodigoProduto	= tbFichaControleProducao.CodigoBanda

	where 	tbFichaControleProducao.CodigoEmpresa	= @CodigoEmpresa and
	tbFichaControleProducao.CodigoLocal 			= @CodigoLocal and
	tbFichaControleProducao.Status					in (0, 1, 2, 3, 4) and
	tbFichaControleProducao.CodigoBanda 			between @DoProduto and @AteProduto and 
	Almox.TipoAlmoxarifadoConsumo 					= 'P' and
	CONVERT(CHAR(6), Custo.PeriodoValorEstoque)		= CONVERT(CHAR(6), @PeriodoAtual)

UNION ALL

---------------   Verificar se existem Itens de Recapagem em aberto (Agregado)

SELECT tbFichaControleProducaoItem.CodigoEmpresa			as CodigoEmpresa,
		tbFichaControleProducaoItem.CodigoLocal				as CodigoLocal,
		tbFichaControleProducao.CentroCusto					as CentroCusto,
		tbFichaControleProducao.NumeroFicha 				as NumeroPedido,
		tbFichaControleProducao.Data						as DataPedido,
		'SR'												as Origem,
		tbFichaControleProducaoItem.PrecoTotal 				as ValorContabil,
		tbFichaControleProducao.CodigoAlmoxarifadoDestino	as CodigoAlmoxarifado,
		tbFichaControleProducaoItem.CodigoProduto			as CodigoProduto,
		tbFichaControleProducaoItem.Quantidade				as QuantidadeItemPed,
		ProdFT.PrecoReposicaoIndiceProduto					,
		Prod.DescricaoProduto								,  
		null												as NumeroOS,		
		null												as CodigoCIT,
		null												as DataOROS,
		tbFichaControleProducao.CodigoCliente 				as CodigoCliFor,
		tbCliFor.NomeCliFor									as NomeCliFor,
		tbFichaControleProducaoItem.PrecoUnitario			as CustoUnitario

	from tbFichaControleProducaoItem  
	inner join tbFichaControleProducao		on 
	tbFichaControleProducao.CodigoEmpresa	= tbFichaControleProducaoItem.CodigoEmpresa and
	tbFichaControleProducao.CodigoLocal		= tbFichaControleProducaoItem.CodigoLocal and
	tbFichaControleProducao.NumeroFicha		= tbFichaControleProducaoItem.NumeroFicha

	inner join tbCliFor		on 
	tbCliFor.CodigoEmpresa	= tbFichaControleProducao.CodigoEmpresa and
	tbCliFor.CodigoCliFor	= tbFichaControleProducao.CodigoCliente
	
	inner join tbAlmoxarifado Almox  on 
	tbFichaControleProducao.CodigoEmpresa		  = Almox.CodigoEmpresa and
	tbFichaControleProducao.CodigoLocal		  = Almox.CodigoLocal and
	tbFichaControleProducao.CodigoAlmoxarifadoDestino = Almox.CodigoAlmoxarifado

	inner join tbProduto Prod  on 
	tbFichaControleProducao.CodigoEmpresa	  = Prod.CodigoEmpresa and
	tbFichaControleProducaoItem.CodigoProduto = Prod.CodigoProduto

	inner join tbProdutoFT ProdFT  on 
	Prod.CodigoEmpresa	= ProdFT.CodigoEmpresa and
	Prod.CodigoProduto	= ProdFT.CodigoProduto

	inner join vwCustoMedioProdutoPeriodo Custo on
	Custo.CodigoEmpresa	= tbFichaControleProducao.CodigoEmpresa and
	Custo.CodigoLocal	= tbFichaControleProducao.CodigoLocal and
	Custo.CodigoProduto	= Prod.CodigoProduto

	where 	tbFichaControleProducaoItem.CodigoEmpresa	= @CodigoEmpresa and
	tbFichaControleProducaoItem.CodigoLocal 			= @CodigoLocal and
	tbFichaControleProducao.Status						in (0, 1, 2, 3, 4) and
	tbFichaControleProducaoItem.CodigoProduto 			between @DoProduto and @AteProduto and 
	Almox.TipoAlmoxarifadoConsumo 						= 'P' and
	CONVERT(CHAR(6), Custo.PeriodoValorEstoque)			= CONVERT(CHAR(6), @PeriodoAtual)

UNION ALL

SELECT ReqS.CodigoEmpresa					as CodigoEmpresa,
		ReqS.CodigoLocal					as CodigoLocal,
		ReqS.DocumentoRequisicaoSaida		as NumeroPedido,
		ReqS.CentroCusto					as CentroCusto,
		ReqS.DataEmissaoRequisicaoSaida		as DataPedido,
		'CE'								as Origem,
		0									as ValorContabil,
		ReqItemS.CodigoAlmoxOrigemReqSaida	as CodigoAlmoxarifado,
		ReqItemS.CodigoProduto				as CodigoProduto, 
		ReqItemS.QuantidadeItemSaida		as QuantidadeItemPed,
		0									as PrecoReposicaoIndiceProduto,
		''									as DescricaoProduto,
		null								as NumeroOS,		
		null								as CodigoCIT,
		null								as DataOROS,
		null								as CodigoCliFor,
		null								as NomeCliFor,
		null								as CustoUnitario

from tbRequisicaoSaida ReqS
	inner join tbItemRequisicaoSaida ReqItemS on
	ReqS.CodigoEmpresa			  =  ReqItemS.CodigoEmpresa and
	ReqS.CodigoLocal			  =  ReqItemS.CodigoLocal and
	ReqS.DocumentoRequisicaoSaida =  ReqItemS.DocumentoRequisicaoSaida

where ReqS.CodigoEmpresa	= @CodigoEmpresa 
and	ReqS.CodigoLocal 		= @CodigoLocal 
and ReqItemS.CodigoProduto 	between @DoProduto and @AteProduto

SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whRelFTItensReservadosDoc TO SQLUsers
GO