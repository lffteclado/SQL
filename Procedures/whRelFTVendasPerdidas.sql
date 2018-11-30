Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Create Procedure dbo.whRelFTVendasPerdidas
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: DBK/Humaita
 PROJETO......: CE
 AUTOR........: Marcelo Bueno
 DATA.........: 28/09/2001
 UTILIZADO EM : frmftRelVendasPerdidas
 OBJETIVO.....: Gerar Relat¢rio de Vendas Perdidas
 ALTERACAO....: CAC 19690 - Alex Sandro Ribeiro - (08/07/2002)
 MOTIVO.......: Informar os precos praticados na data da venda perdida, e, caso haja mais 
		de 01 vendedor para o pedido, repetir as informacoes para todos.
 ALTERA€AO....: CAC 40473/2002 - Alex Sandro Ribeiro - (30/09/2002)
 Motivo.......: Performance / substituir #temp por rt / rever order by
 ALTERA€AO....: Marcio schvartz - 18/11/2002 - CAC 49132/2002
 MOTIVO.......: Inclui produtos na rtVendasPerdidas que nao tenham vinculo com o pedido
 ALTERA€AO....: Marcio schvartz - 06/11/2003 
 MOTIVO.......: Incluido set nocount on / off
 ALTERA€AO....: Marcio schvartz - 13/11/2003 
 MOTIVO.......: Ajustado regras de negocio
 ALTERA€AO....: Jordy Withoeft - 08/12/2015 
 MOTIVO.......: Adicionada lógica que disponibiliza registros mesmo não havendo venda perdida

whRelFTVendasPerdidas 1608, 0, 1, '2010-01-01', '2010-01-31', 0, 9999, '', 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'
whRelFTVendasPerdidas 1608, 0, 2, '2010-01-01', '2010-01-31', 0, 9999, '', 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'
whRelFTVendasPerdidas 1608, 0, 3, '2010-01-01', '2010-01-31', 0, 9999, '', 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ','','ZZZZ','','ZZZZZZZ'

-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa		dtInteiro04 ,
@CodigoLocal		dtInteiro04 ,
@TipoClassificacao      dtInteiro01 ,
@DataInicial            datetime,
@DataFinal         	datetime,
@LinhaProdutoInicial    dtInteiro08 = null,
@LinhaProdutoFinal      dtInteiro08 = null ,
@ProdutoInicial	 	Char(30) = null,
@ProdutoFinal		Char(30) = null,
@DoComodite			varchar(5) = null,
@AteComodite		varchar(5) = null,	
@DoResponsability	varchar(7) = null,
@AteResponsability	varchar(7) = null 

--WITH ENCRYPTION
as

set nocount on
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @CodigoProduto		char(30)
declare @QuantidadeGiro		numeric(12,4)
declare @DataUltimaVendaPeca	datetime

declare @VersaoSQL				varchar(10)
select @VersaoSQL = left(convert(varchar(20), SERVERPROPERTY('productversion')),2)


if @VersaoSQL >= '11' begin
	if not exists (select * from sys.indexes  where name = 'ix_tbTabelaPreco_001') begin
		CREATE NONCLUSTERED INDEX [ix_tbTabelaPreco_001]
		ON [dbo].[tbTabelaPreco] ([CodigoEmpresa],[CodigoProduto],[DataValidadeTabelaPreco])
	end
end else begin
	if not exists (select * from sysindexes  where name = 'ix_tbTabelaPreco_001') begin
		CREATE NONCLUSTERED INDEX [ix_tbTabelaPreco_001]
		ON [dbo].[tbTabelaPreco] ([CodigoEmpresa],[CodigoProduto],[DataValidadeTabelaPreco])
	end
end



if @LinhaProdutoInicial is null		select @LinhaProdutoInicial = min(CodigoLinhaProduto) from tbLinhaProduto with (nolock) where CodigoEmpresa = @CodigoEmpresa
if @LinhaProdutoFinal is null		select @LinhaProdutoFinal = max(CodigoLinhaProduto) from tbLinhaProduto  with (nolock) where CodigoEmpresa = @CodigoEmpresa

if @ProdutoInicial is null			select @ProdutoInicial = min(CodigoProduto) from tbProduto  with (nolock) where CodigoEmpresa = @CodigoEmpresa
if @ProdutoFinal is null			select @ProdutoFinal = max(CodigoProduto) from tbProduto  with (nolock) where CodigoEmpresa = @CodigoEmpresa

if @DoComodite is null				select @DoComodite = min(ComoditeCode) from tbComodite  with (nolock) where CodigoEmpresa = @CodigoEmpresa
if @AteComodite is null				select @AteComodite = max(ComoditeCode) from tbComodite  with (nolock) where CodigoEmpresa = @CodigoEmpresa

if @DoResponsability is null		select @DoResponsability = min(Responsability) from tbComodite  with (nolock) where CodigoEmpresa = @CodigoEmpresa
if @AteResponsability is null		select @AteResponsability = max(Responsability) from tbComodite  with (nolock) where CodigoEmpresa = @CodigoEmpresa


------------------------------------------------------------------------------------------
-- inicializa‡ao inicial
------------------------------------------------------------------------------------------
delete from rtVendasPerdidas where spid = @@spid

--select @DataInicial = @DataInicial + ' 00:00:00'
--select @DataFinal   = @DataFinal   + ' 23:59:59'

------------------------------------------------------------------------------------------
-- insere dados na rt
------------------------------------------------------------------------------------------
insert	into rtVendasPerdidas

select  @@spid,
	tvp.CodigoCliFor, -- CodigoCliente,
	null, -- NomeCliente
	tvp.CodigoProduto,
	null, -- QuantidadeGiro
	null, -- DataUltimaVendaPeca
	null, -- PrecoUnitarioPeca
	tvp.QuantidadeVendaPerdida,
	null, -- ValorTotal
	tvp.DataVendaPerdida,

	--dsc.NomeRepresentante Vendedor,
	dsc.NomeRepresentante as Vendedor,

	mot.DescricaoVendaPerdida CausaVendaPerdida,

	--tvp.CentroCusto,
	case 	when tvp.CentroCusto is null then 0
		when tvp.CentroCusto is not null then tvp.CentroCusto
	end,

	--tvp.NumeroPedido,
	case 	when tvp.NumeroPedido is null then 0
		when tvp.NumeroPedido is not null then tvp.NumeroPedido
	end,

	--tvp.SequenciaPedido,
	case 	when tvp.SequenciaPedido is null then 0
		when tvp.SequenciaPedido is not null then tvp.SequenciaPedido
	end,

	case 	when ped.TipoPedidoPed is null then 0
		when ped.TipoPedidoPed is not null then ped.TipoPedidoPed
	end,
	case when ped.OrigemPedido is null then tvp.Origem
		when ped.OrigemPedido is not null then ped.OrigemPedido
	end OrigemPedido
from	tbVendaPerdida tvp with (nolock)

left	join tbPedido ped with (nolock)
on	ped.CodigoEmpresa	= tvp.CodigoEmpresa
and	ped.CodigoLocal		= tvp.CodigoLocal
and	ped.CentroCusto		= tvp.CentroCusto
and	ped.NumeroPedido	= tvp.NumeroPedido
and	ped.SequenciaPedido	= tvp.SequenciaPedido

left    join tbRepresentanteComplementar dsc with (nolock)
on      tvp.CodigoEmpresa	= dsc.CodigoEmpresa
AND 	tvp.CodigoRepresentante = dsc.CodigoRepresentante

inner	join tbProdutoFT pft with (nolock)
on	pft.CodigoEmpresa	= tvp.CodigoEmpresa
and	pft.CodigoProduto	= tvp.CodigoProduto

inner	join tbMotivoVendaPerdida mot with (nolock)
on	mot.CodigoEmpresa	= tvp.CodigoEmpresa
and	mot.MotivoVendaPerdida	= tvp.MotivoVendaPerdida

where	tvp.CodigoEmpresa	= @CodigoEmpresa
and	tvp.CodigoLocal		= @CodigoLocal
and	tvp.DataVendaPerdida	between @DataInicial	and @DataFinal
and	tvp.CodigoProduto	between @ProdutoInicial	and @ProdutoFinal
and	pft.CodigoLinhaProduto	between @LinhaProdutoInicial and @LinhaProdutoFinal
and	tvp.NumeroPedido is not null


-------------------------------------  Vendas Perdidas Oficina  ---------------------------
insert	into rtVendasPerdidas
select  @@spid,
	tvpos.CodigoCliFor, -- CodigoCliente,
	null, -- NomeCliente
	tvpos.CodigoProduto,
	null, -- QuantidadeGiro
	null, -- DataUltimaVendaPeca
	null, -- PrecoUnitarioPeca
	tvpos.QtdeVendaPerdidaOS,
	null, -- ValorTotal
	tvpos.DataVendaPerdidaOS,

	--dsc.NomeRepresentante Vendedor,
	case 	when dsc.NomeRepresentante is null then convert(varchar(30), dsc2.NomeRepresentante)
		when dsc.NomeRepresentante is not null then convert(varchar(30), dsc.NomeRepresentante)
	end Vendedor,

	mot.DescricaoVendaPerdida CausaVendaPerdida,

	orosc.CentroCusto,

	--tvp.NumeroPedido,
	case 	when tvpos.NumeroOROS is null then 0
		when tvpos.NumeroOROS is not null then tvpos.NumeroOROS
	end,

	0, --tvp.SequenciaPedido, para Oficina sequencia 99
	0,
	'OS'
	
from	tbVendaPerdidaOS tvpos with (nolock)

left	join tbRepresentanteComplementar dsc with (nolock)
on	dsc.CodigoEmpresa	= tvpos.CodigoEmpresa
and	dsc.CodigoRepresentante	= tvpos.CodigoRepresentante

left    join tbRepresentanteComplementar dsc2 with (nolock)
on      tvpos.CodigoEmpresa	= dsc2.CodigoEmpresa
AND 	tvpos.CodigoRepresentante = dsc2.CodigoRepresentante

inner join tbOROSCIT orosc with (nolock)
on orosc.CodigoEmpresa = tvpos.CodigoEmpresa
and orosc.CodigoLocal  = tvpos.CodigoLocal
and orosc.FlagOROS     = tvpos.FlagOROS
and orosc.NumeroOROS   = tvpos.NumeroOROS
and orosc.CodigoCIT    = tvpos.CodigoCIT

inner	join tbProdutoFT pft with (nolock)
on	pft.CodigoEmpresa	= tvpos.CodigoEmpresa
and	pft.CodigoProduto	= tvpos.CodigoProduto

inner	join tbMotivoVendaPerdida mot with (nolock)
on	mot.CodigoEmpresa	= tvpos.CodigoEmpresa
and	mot.MotivoVendaPerdida	= tvpos.MotivoVendaPerdida

where	tvpos.CodigoEmpresa	= @CodigoEmpresa
and	tvpos.CodigoLocal	= @CodigoLocal
and	tvpos.DataVendaPerdidaOS	between @DataInicial	and @DataFinal
and	tvpos.CodigoProduto		between @ProdutoInicial	and @ProdutoFinal
and	pft.CodigoLinhaProduto	between @LinhaProdutoInicial and @LinhaProdutoFinal



------------------------------------------------------------------------------------------
-- Atualiza o codigo do cliente
------------------------------------------------------------------------------------------
update	rtVendasPerdidas set CodigoCliente = aux.CodigoCliForPedVda
from 	tbPedidoVenda aux with (nolock)
where 	TipoPedidoPed = 1
and	aux.CodigoEmpresa	= @CodigoEmpresa
and	aux.CodigoLocal		= @CodigoLocal
and	aux.CentroCusto		= rtVendasPerdidas.CentroCusto
and	aux.NumeroPedido	= rtVendasPerdidas.NumeroPedido
and	aux.SequenciaPedido	= rtVendasPerdidas.SequenciaPedido
and	spid = @@spid
and	rtVendasPerdidas.NumeroPedido is not null

------------------------------------------------------------------------------------------
update	rtVendasPerdidas set CodigoCliente = aux.CodigoCliForPedVda
from 	tbPedidoVenda aux with (nolock)
where 	TipoPedidoPed = 2
and	aux.CodigoEmpresa	= @CodigoEmpresa
and	aux.CodigoLocal		= @CodigoLocal
and	aux.CentroCusto		= rtVendasPerdidas.CentroCusto
and	aux.NumeroPedido	= rtVendasPerdidas.NumeroPedido
and	aux.SequenciaPedido	= rtVendasPerdidas.SequenciaPedido
and	spid = @@spid
and	rtVendasPerdidas.NumeroPedido is not null

------------------------------------------------------------------------------------------
update	rtVendasPerdidas set CodigoCliente = aux.CodigoCliFor
from	tbPedidoEntrada aux with (nolock)
where 	TipoPedidoPed = 3
and	aux.CodigoEmpresa	= @CodigoEmpresa
and	aux.CodigoLocal		= @CodigoLocal
and	aux.CentroCusto		= rtVendasPerdidas.CentroCusto
and	aux.NumeroPedido	= rtVendasPerdidas.NumeroPedido
and	aux.SequenciaPedido	= rtVendasPerdidas.SequenciaPedido
and	spid = @@spid
and	rtVendasPerdidas.NumeroPedido is not null

------------------------------------------------------------------------------------------
update	rtVendasPerdidas set CodigoCliente = aux.CodigoCliFor
from	tbPedidoDevolucaoCompra aux with (nolock)
where	TipoPedidoPed = 4
and	aux.CodigoEmpresa	= @CodigoEmpresa
and	aux.CodigoLocal		= @CodigoLocal
and	aux.CentroCusto		= rtVendasPerdidas.CentroCusto
and	aux.NumeroPedido	= rtVendasPerdidas.NumeroPedido
and	aux.SequenciaPedido	= rtVendasPerdidas.SequenciaPedido
and	spid = @@spid
and	rtVendasPerdidas.NumeroPedido is not null

------------------------------------------------------------------------------------------
update	rtVendasPerdidas set CodigoCliente = aux.CodigoCliFor
from	tbPedidoDevolucaoCompra aux with (nolock)
where	TipoPedidoPed = 5
and	aux.CodigoEmpresa	= @CodigoEmpresa
and	aux.CodigoLocal		= @CodigoLocal
and	aux.CentroCusto		= rtVendasPerdidas.CentroCusto
and	aux.NumeroPedido	= rtVendasPerdidas.NumeroPedido
and	aux.SequenciaPedido	= rtVendasPerdidas.SequenciaPedido
and	spid = @@spid
and	rtVendasPerdidas.NumeroPedido is not null

------------------------------------------------------------------------------------------
update	rtVendasPerdidas set 	CodigoCliente = aux.CodigoCliFor
from	tbPedidoRemessa aux with (nolock)
where 	TipoPedidoPed = 6
and	aux.CodigoEmpresa	= @CodigoEmpresa
and	aux.CodigoLocal		= @CodigoLocal
and	aux.CentroCusto		= rtVendasPerdidas.CentroCusto
and	aux.NumeroPedido	= rtVendasPerdidas.NumeroPedido
and	aux.SequenciaPedido	= rtVendasPerdidas.SequenciaPedido
and	spid = @@spid
and	rtVendasPerdidas.NumeroPedido is not null

------------------------------------------------------------------------------------------
update	rtVendasPerdidas set CodigoCliente = aux.CodigoCliFor
from	tbPedidoRemessa aux with (nolock)
where	TipoPedidoPed = 7
and	aux.CodigoEmpresa	= @CodigoEmpresa
and	aux.CodigoLocal		= @CodigoLocal
and	aux.CentroCusto		= rtVendasPerdidas.CentroCusto
and	aux.NumeroPedido	= rtVendasPerdidas.NumeroPedido
and	aux.SequenciaPedido	= rtVendasPerdidas.SequenciaPedido
and	spid = @@spid
and	rtVendasPerdidas.NumeroPedido is not null

------------------------------------------------------------------------------------------
update	rtVendasPerdidas set CodigoCliente = aux.CodigoCliFor
from	tbPedidoDevolucaoVenda aux with (nolock)
where 	TipoPedidoPed = 8
and	aux.CodigoEmpresa	= @CodigoEmpresa
and	aux.CodigoLocal		= @CodigoLocal
and	aux.CentroCusto		= rtVendasPerdidas.CentroCusto
and	aux.NumeroPedido	= rtVendasPerdidas.NumeroPedido
and	aux.SequenciaPedido	= rtVendasPerdidas.SequenciaPedido
and	spid = @@spid
and	rtVendasPerdidas.NumeroPedido is not null

------------------------------------------------------------------------------------------
update	rtVendasPerdidas set CodigoCliente = aux.CodigoCliFor
from	tbPedidoTK aux with (nolock)
where	TipoPedidoPed = 9
and	aux.CodigoEmpresa	= @CodigoEmpresa
and	aux.CodigoLocal		= @CodigoLocal
and	aux.CentroCusto		= rtVendasPerdidas.CentroCusto
and	aux.NumeroPedido	= rtVendasPerdidas.NumeroPedido
and	aux.SequenciaPedido	= rtVendasPerdidas.SequenciaPedido
and	spid = @@spid
and	rtVendasPerdidas.NumeroPedido is not null

------------------------------------------------------------------------------------------
-- Atualiza o nome do cliente
------------------------------------------------------------------------------------------
update 	rtVendasPerdidas 
set	NomeCliente = convert(varchar(30), NomeCliFor)
from	rtVendasPerdidas  with (nolock) 
inner	join tbCliFor cf with (nolock)
on	cf.CodigoCliFor = rtVendasPerdidas.CodigoCliente
where	spid = @@spid
and	rtVendasPerdidas.CodigoCliente is not null


------------------------------------------------------------------------------------------
-- Inclui a rtVendasPerdidas para produtos que nao tenham vinculo com o pedido
------------------------------------------------------------------------------------------
insert	into rtVendasPerdidas
select  @@spid,
	tvp.CodigoCliFor, -- CodigoCliente,
	convert(varchar(30), cli.NomeCliFor),
	--null, -- NomeCliente
	tvp.CodigoProduto,
	0, -- QuantidadeGiro
	null, -- DataUltimaVendaPeca
	0, -- PrecoUnitarioPeca
	tvp.QuantidadeVendaPerdida,
	0, -- ValorTotal
	tvp.DataVendaPerdida,
	convert(varchar(30), repc.NomeRepresentante),
	--null, --dsc.NomeRepresentante Vendedor,
	mot.DescricaoVendaPerdida CausaVendaPerdida,
	0, --tvp.CentroCusto,
	0, --tvp.NumeroPedido,
	0, --tvp.SequenciaPedido,
	0, -- ped.TipoPedidoPed,
	'' -- Origem	
from	tbVendaPerdida tvp with (nolock)

inner	join tbProdutoFT pft with (nolock)
on	pft.CodigoEmpresa	= tvp.CodigoEmpresa
and	pft.CodigoProduto	= tvp.CodigoProduto

inner	join tbMotivoVendaPerdida mot with (nolock)
on	mot.CodigoEmpresa	= tvp.CodigoEmpresa
and	mot.MotivoVendaPerdida	= tvp.MotivoVendaPerdida

inner 	join tbRepresentanteComplementar repc with (nolock)
ON 	mot.CodigoEmpresa       = repc.CodigoEmpresa
AND	tvp.CodigoRepresentante = repc.CodigoRepresentante

left    join tbCliFor cli with (nolock)
ON 	tvp.CodigoEmpresa	= cli.CodigoEmpresa
AND	tvp.CodigoCliFor	= cli.CodigoCliFor

where	tvp.CodigoEmpresa	= @CodigoEmpresa
and	tvp.CodigoLocal		= @CodigoLocal
and	tvp.DataVendaPerdida	between @DataInicial	and @DataFinal
and	tvp.CodigoProduto	between @ProdutoInicial	and @ProdutoFinal
and	pft.CodigoLinhaProduto	between @LinhaProdutoInicial and @LinhaProdutoFinal
and	tvp.NumeroPedido is null

--and     tvp.CodigoCliFor IS NULL  
--and 	tvp.CodigoRepresentante IS NOT NULL



------------------------------------------------------------------------------------------
-- Atualiza a quantidade giro / cursor manual
------------------------------------------------------------------------------------------
select 	@CodigoProduto = min(CodigoProduto)
from 	rtVendasPerdidas with (nolock)
where	spid = @@spid

while @CodigoProduto is not null
begin
	select 	@QuantidadeGiro = convert(numeric(8,2),sum(QuantidadeConsumo) / 12)
	from	tbConsumoProduto with (nolock)
	where	CodigoEmpresa	= @CodigoEmpresa
	and	CodigoLocal	= @CodigoLocal
	and	CodigoProduto	= @CodigoProduto
	and	PeriodoConsumo <= convert(char(6),getdate(),112)
	and	PeriodoConsumo >= convert(char(6),dateadd(year,-1,getdate()),112)

	update	rtVendasPerdidas
	set	QuantidadeGiro 	= @QuantidadeGiro
	where	CodigoProduto 	= @CodigoProduto
	and	spid = @@spid

	select 	@CodigoProduto = min(CodigoProduto)
	from 	rtVendasPerdidas with (nolock)
	where	CodigoProduto	> @CodigoProduto
	and	spid		= @@spid
end

------------------------------------------------------------------------------------------
-- Atualiza a data da ultima venda
------------------------------------------------------------------------------------------
select	@CodigoProduto = min(CodigoProduto)
from	rtVendasPerdidas  with (nolock)
where	spid = @@spid

while @CodigoProduto is not null
begin

   	select 	@DataUltimaVendaPeca = max(DataUltimaVenda)
	from	tbPlanejamentoProduto with (nolock)
	where	CodigoEmpresa	= @CodigoEmpresa
	and	CodigoLocal	= @CodigoLocal
	and	CodigoProduto 	= @CodigoProduto 
	and	DataUltimaVenda is not null

	update	rtVendasPerdidas set DataUltimaVendaPeca = @DataUltimaVendaPeca
	where	CodigoProduto = @CodigoProduto 
	and 	spid = @@spid

	select	@CodigoProduto = min(CodigoProduto)
	from	rtVendasPerdidas with (nolock)
	where	CodigoProduto > @CodigoProduto
	and	spid = @@spid
end

------------------------------------------------------------------------------------------
-- Atualiza PrecoUnitarioPeca
------------------------------------------------------------------------------------------
update	rtVendasPerdidas set PrecoUnitarioPeca = tabpre.ValorTabelaPreco
from	tbTabelaPreco tabpre with (nolock)
inner	join tbTipoTabelaPreco tiptab with (nolock)
on	tiptab.CodigoEmpresa		= tabpre.CodigoEmpresa
and	tiptab.CodigoTipoTabelaPreco	= tabpre.CodigoTipoTabelaPreco 
and 	tiptab.TabelaVendaTabelaPreco 	= 'V'  
where	tabpre.CodigoEmpresa		= @CodigoEmpresa
and	tabpre.CodigoProduto		= rtVendasPerdidas.CodigoProduto
and	tabpre.DataValidadeTabelaPreco 	= 		-- Seleciona tabela abaixo
					(Select max(tabpre2.DataValidadeTabelaPreco)
					from	tbTabelaPreco tabpre2 with (nolock)
					where	tabpre2.CodigoEmpresa	 	 = @CodigoEmpresa
					and	tabpre2.DataValidadeTabelaPreco <= rtVendasPerdidas.DataVendaPerdida
					and	tabpre2.CodigoProduto	 	 = rtVendasPerdidas.CodigoProduto)

------------------------------------------------------------------------------------------
-- Atualizações das colunas de valor
------------------------------------------------------------------------------------------
update	rtVendasPerdidas set QuantidadeGiro = 0 where QuantidadeGiro is null
update	rtVendasPerdidas set DataUltimaVendaPeca = getdate() where DataUltimaVendaPeca is null
update	rtVendasPerdidas set PrecoUnitarioPeca = 0 where PrecoUnitarioPeca is null
update	rtVendasPerdidas set ValorTotal = 0 where ValorTotal is null
update	rtVendasPerdidas set ValorTotal = QuantidadePerdida * PrecoUnitarioPeca





------------------------------------------------------------------------------------------
-- lista os dados da tabela
------------------------------------------------------------------------------------------
if @TipoClassificacao <= 3 begin
	set nocount off
	select	CodigoCliente,
		NomeCliente,
		rc.CodigoProduto,
		QuantidadeGiro,
		DataUltimaVendaPeca,
		PrecoUnitarioPeca,
		QuantidadePerdida,
		ValorTotal,
		DataVendaPerdida,
		Vendedor,
		CausaVendaPerdida, 
		lp.CodigoLinhaProduto, 
		lp.DescricaoLinhaProduto,
		rc.Origem
		, convert(varchar(6), DataVendaPerdida, 112) as 'AnoMesVendaPerdida',
		com.ComoditeCode,
		com.Responsability,
		com.CodigoEmpresa,
		rc.NumeroPedido

	from 	rtVendasPerdidas rc with (nolock)
	inner 	join tbProdutoFT pft with (nolock)
	on 	pft.CodigoEmpresa = @CodigoEmpresa
	and 	pft.CodigoProduto = rc.CodigoProduto
	inner 	join tbLinhaProduto lp with (nolock)
	on 	lp.CodigoEmpresa = pft.CodigoEmpresa
	and 	lp.CodigoLinhaProduto = pft.CodigoLinhaProduto
	LEFT JOIN tbComodite com with (nolock)
	ON	pft.CodigoEmpresa  		= com.CodigoEmpresa and
		pft.CodigoProduto		= com.CodigoProduto

	WHERE spid = @@spid
	AND	(com.ComoditeCode	BETWEEN @DoComodite AND @AteComodite or com.ComoditeCode is null)
	AND	(com.Responsability	BETWEEN	@DoResponsability AND @AteResponsability or com.Responsability is null) 
	order 	by (case @TipoClassificacao
			when 1 then rc.DataVendaPerdida
       	     		when 2 then ''
       	     		when 3 then pft.CodigoLinhaProduto
		  end) , rc.CodigoProduto
end


 --agrupar por AnoMesVendaPerdida
if @TipoClassificacao = 4 begin		
	---------------------------------- Consolidar valores para compor grau de atendimento
	-- Consolidar Quantidade Perdida
	select	'Mes  ' as 'Tipo',
			convert(varchar(6), DataVendaPerdida, 112) as 'AnoMesVendaPerdida',
			case when coalesce(sum(QuantidadePerdida), 0) > 0 then coalesce(sum(QuantidadePerdida), 0)
				else 0
			end as 'QuantidadePerdida',
			0 as 'QuantidadeVendida',
			@@spid as 'spid'
	into #tmp1
	from rtVendasPerdidas rc with (nolock)
	WHERE spid = @@spid
	group by convert(varchar(6), DataVendaPerdida, 112)
	order by convert(varchar(6), DataVendaPerdida, 112)

	-- Gerar tabela temporaria que conterá todos as datas que serão disponibilizadas no relatório
	select AnoMesVendaPerdida into #tmpAnoMesPeriodo from #tmp1

	declare @AnoMesVendaPerdida char(6)
	declare @QuantidadeConsumo  numeric(10)
	declare @DataAux	        datetime

	select @DataAux = @DataInicial

	while ((MONTH(@DataAux) > MONTH(@DataFinal) and YEAR(@DataAux) < YEAR(@DataFinal)) or 
		   (MONTH(@DataAux) <= MONTH(@DataFinal) and YEAR(@DataAux) <= YEAR(@DataFinal))) begin
		
		select @AnoMesVendaPerdida = CAST(YEAR(@DataAux)AS VARCHAR(4)) + RIGHT('00' + CAST(MONTH(@DataAux) AS VARCHAR(2)), 2)

		if not exists(select 1 from #tmpAnoMesPeriodo where AnoMesVendaPerdida = @AnoMesVendaPerdida)
		begin
			insert into #tmpAnoMesPeriodo (AnoMesVendaPerdida) values (@AnoMesVendaPerdida)
		end

		select @DataAux = DATEADD(MONTH, 1, @DataAux)

	end
	
	-- processar Quantidade Vendida
	while exists (select 1 from #tmpAnoMesPeriodo) begin
	
		select @AnoMesVendaPerdida = AnoMesVendaPerdida	from #tmpAnoMesPeriodo

		select @QuantidadeConsumo = coalesce(sum(QuantidadeConsumo), 0)
		from tbConsumoProduto with (nolock)
		where CodigoEmpresa = @CodigoEmpresa
		and CodigoLocal = @CodigoLocal
		and PeriodoConsumo = @AnoMesVendaPerdida
		
		-- Se já existir registro de vendas perdidas, atualiza com o total consumido
		if exists(select 1 from #tmp1 where AnoMesVendaPerdida = @AnoMesVendaPerdida)
		begin
			update #tmp1 set QuantidadeVendida = @QuantidadeConsumo
			where spid = @@spid
			and Tipo = 'Mes'
			and AnoMesVendaPerdida = @AnoMesVendaPerdida
		end
		-- Se não houver, insere registro na tabela temporária com vendas perdidas = 0
		else
		begin
			insert into #tmp1 values('Mes  ', @AnoMesVendaPerdida, 0, @QuantidadeConsumo, @@spid)
		end
		
		delete from #tmpAnoMesPeriodo where AnoMesVendaPerdida = @AnoMesVendaPerdida
		
	end

	-------------------------------------------------------- calcular Grau de Atendimento
	select	Tipo,
			AnoMesVendaPerdida, 
			left(AnoMesVendaPerdida, 4) as 'AnoVendaPerdida', 
			right(AnoMesVendaPerdida, 2) as 'MesVendaPerdida',
			QuantidadePerdida, QuantidadeVendida, 
			case when (QuantidadeVendida - QuantidadePerdida) > 0
				then QuantidadeVendida - QuantidadePerdida 
				else 0
				end as 'QuantidadeAtendida',
			case when (QuantidadeVendida - QuantidadePerdida) > 0
				then round((QuantidadeVendida - QuantidadePerdida) / QuantidadeVendida * 100, 2)
				else 0
				end as 'GrauAtendimento'							
	into #tmp2
	from #tmp1
	order by AnoMesVendaPerdida

	-------------------------------------------------------------------------------------
	declare @TotalMeses numeric(2),
			@QuantidadePerdida numeric(15,2),
			@QuantidadeVendida numeric(15,2),
			@QuantidadeAtendida numeric(15,2),
			@GrauAtendimento numeric(15,2)

	select	@TotalMeses = coalesce(count(*), 0),
			@QuantidadePerdida = coalesce(sum(QuantidadePerdida), 0),
			@QuantidadeVendida = coalesce(sum(QuantidadeVendida), 0),
			@QuantidadeAtendida = coalesce(sum(QuantidadeAtendida), 0),
			@GrauAtendimento = sum(GrauAtendimento)
	from #tmp2
	

	--------------------------------------------------- Incluir Grau de Atendimento médio
	insert into #tmp2
	select 'Media' as 'Tipo', 
			'999999' as 'AnoMesVendaPerdida', 
			'9999',
			'99', 
			@QuantidadePerdida,
			@QuantidadeVendida,
			@QuantidadeAtendida,
			round(coalesce(@GrauAtendimento / @TotalMeses, 0),2)

	set nocount off


	select *, 
			DescricaoMes =(case when MesVendaPerdida = '01' then 'Jan  '
							 when MesVendaPerdida = '02' then 'Fev  '
							 when MesVendaPerdida = '03' then 'Mar  '
							 when MesVendaPerdida = '04' then 'Abr  '
							 when MesVendaPerdida = '05' then 'Mai  '
							 when MesVendaPerdida = '06' then 'Jun  '
							 when MesVendaPerdida = '07' then 'Jul  '
							 when MesVendaPerdida = '08' then 'Ago  '
							 when MesVendaPerdida = '09' then 'Set  '
							 when MesVendaPerdida = '10' then 'Out  '
							 when MesVendaPerdida = '11' then 'Nov  '
							 when MesVendaPerdida = '12' then 'Dez  '
							 else 'Média'
						end)--,com.ComoditeCode
					--, com.Responsability
	from #tmp2 
	--LEFT JOIN tbComodite com
	--ON	#tmp2.CodigoEmpresa  		= com.CodigoEmpresa and
	--	#tmp2.CodigoProduto		= com.CodigoProduto
	--where (com.ComoditeCode	BETWEEN @DoComodite AND @AteComodite or com.ComoditeCode is null)
	--	AND	(com.Responsability	BETWEEN	@DoResponsability AND @AteResponsability or com.Responsability is null) 
	order by Tipo desc, AnoMesVendaPerdida 

end


------------------------------------------------------------------------------------------
-- limpeza final
------------------------------------------------------------------------------------------
set nocount on
delete from rtVendasPerdidas where spid = @@spid
set nocount off


