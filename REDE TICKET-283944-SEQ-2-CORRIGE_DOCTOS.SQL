declare @CodigoEmpresa numeric(4),@CodigoLocal numeric(4),@DataInicial datetime,@DataFinal datetime
--------------------------------------------------------------------------------
-- Informar antes de executar
select
	@CodigoEmpresa	= 3610,
	@CodigoLocal	= 0,
	@DataInicial	= '2018-08-01',
	@DataFinal		= '2018-08-31'
--------------------------------------------------------------------------------

declare
	@cEntradaSaidaDocumento char(1),
	@cNumeroDocumento numeric(12),
	@cDataDocumento datetime,
	@cCodigoCliFor numeric(14),
	@cTipoLancamentoMovimentacao numeric(2),
	@cSequenciaItemDocumento numeric(6),
	@cTipoRegistroItemDocto char(3),
	@user varchar(30)

declare @ItCtaCtb table (
	CodigoEmpresa numeric(4),
	CodigoLocal numeric(4),
	EntradaSaidaDocumento char(1),
	NumeroDocumento numeric(12),
	DataDocumento datetime,
	CodigoCliFor numeric(14),
	TipoLancamentoMovimentacao numeric(2),
	SequenciaItemDocumento numeric(6),
	ContaContabil varchar(12),
	CentroCusto numeric(8) )

set nocount on

select @user = upper(convert(char(30), (select nt_username from master.dbo.sysprocesses where spid = @@Spid)))

delete tbItemDocumentoContaContabil where ContaContabil = '' and CentroCusto = 0

if object_id('tempdb..#tbCursor') is not null
	drop table #tbCursor

declare @count int
set rowcount 0

select
	EntradaSaidaDocumento,
	NumeroDocumento,
	DataDocumento,
	CodigoCliFor,
	TipoLancamentoMovimentacao,
	SequenciaItemDocumento,
	TipoRegistroItemDocto
into #tbCursor
from tbItemDocumento
where
	CodigoEmpresa = @CodigoEmpresa
and CodigoLocal = @CodigoLocal
and DataDocumento between @DataInicial and @DataFinal
and TipoLancamentoMovimentacao < 9
and not exists (	select 1 from tbItemDocumentoContaContabil (nolock)
					where
						tbItemDocumentoContaContabil.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
					and tbItemDocumentoContaContabil.CodigoLocal = tbItemDocumento.CodigoLocal
					and tbItemDocumentoContaContabil.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento
					and tbItemDocumentoContaContabil.NumeroDocumento = tbItemDocumento.NumeroDocumento
					and tbItemDocumentoContaContabil.DataDocumento = tbItemDocumento.DataDocumento
					and tbItemDocumentoContaContabil.CodigoCliFor = tbItemDocumento.CodigoCliFor
					and tbItemDocumentoContaContabil.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
					and tbItemDocumentoContaContabil.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento
				)

alter table #tbCursor add id bigint identity(1,1)

set rowcount 1 
select @count = id from #tbCursor

while @@rowcount <> 0 
begin

	set rowcount 0 

	select
		@cEntradaSaidaDocumento = EntradaSaidaDocumento,
		@cNumeroDocumento = NumeroDocumento,
		@cDataDocumento = DataDocumento,
		@cCodigoCliFor = CodigoCliFor,
		@cTipoLancamentoMovimentacao = TipoLancamentoMovimentacao,
		@cSequenciaItemDocumento = SequenciaItemDocumento,
		@cTipoRegistroItemDocto = TipoRegistroItemDocto
	from #tbCursor
	where id = @count

	if @cTipoRegistroItemDocto in ('PEC','CLO')
	begin

		insert @ItCtaCtb
		select
			CodigoEmpresa = idoc.CodigoEmpresa,
			CodigoLocal = idoc.CodigoLocal,
			EntradaSaidaDocumento = idoc.EntradaSaidaDocumento,
			NumeroDocumento = idoc.NumeroDocumento,
			DataDocumento = idoc.DataDocumento,
			CodigoCliFor = idoc.CodigoCliFor,
			TipoLancamentoMovimentacao = idoc.TipoLancamentoMovimentacao,
			SequenciaItemDocumento = idoc.SequenciaItemDocumento,
			ContaContabil =	coalesce(case
							when idoc.EntradaSaidaDocumento = 'E' then
								case
								when cno.CodigoTipoOperacao in (1,15,16,7,6) then rclp.ContaEstoqueLinha
								when cno.CodigoTipoOperacao in (14,5) then rclc.ContaRemessaLinhaCNO
								when cno.CodigoTipoOperacao in (9) then rger.ContaMercTranRegraContabGeral
								else '' end
							else
								case
								when cno.CodigoTipoOperacao in (3,15,98) then rclc.ContaTotalLinhaCNO
								when cno.CodigoTipoOperacao in (14,5) then rclc.ContaRemessaLinhaCNO
								when cno.CodigoTipoOperacao in (9) then rger.ContaMercTranRegraContabGeral
								when cno.CodigoTipoOperacao in (7,16) then rclp.ContaEstoqueLinha
								else '' end
							end,''),
			CentroCusto =	coalesce(rclc.CentroCustoContabilLinhaCNO,rclc.CentroCusto,dFT.CentroCusto)

		from tbItemDocumento idoc (nolock)
		
		inner join tbItemDocumentoFT idFT (nolock)
		on  idFT.CodigoEmpresa = idoc.CodigoEmpresa
		and idFT.CodigoLocal = idoc.CodigoLocal
		and idFT.EntradaSaidaDocumento = idoc.EntradaSaidaDocumento
		and idFT.NumeroDocumento = idoc.NumeroDocumento
		and idFT.DataDocumento = idoc.DataDocumento
		and idFT.CodigoCliFor = idoc.CodigoCliFor
		and idFT.TipoLancamentoMovimentacao = idoc.TipoLancamentoMovimentacao
		and idFT.SequenciaItemDocumento = idoc.SequenciaItemDocumento
		
		inner join tbDocumentoFT dFT (nolock)
		on  dFT.CodigoEmpresa = idoc.CodigoEmpresa
		and dFT.CodigoLocal = idoc.CodigoLocal
		and dFT.EntradaSaidaDocumento = idoc.EntradaSaidaDocumento
		and dFT.NumeroDocumento = idoc.NumeroDocumento
		and dFT.DataDocumento = idoc.DataDocumento
		and dFT.CodigoCliFor = idoc.CodigoCliFor
		and dFT.TipoLancamentoMovimentacao = idoc.TipoLancamentoMovimentacao
		
		inner join tbNaturezaOperacao cno (nolock)
		on  cno.CodigoEmpresa = idoc.CodigoEmpresa
		and cno.CodigoNaturezaOperacao = idoc.CodigoNaturezaOperacao
		
		inner join tbProdutoFT pft (nolock)
		on  pft.CodigoEmpresa = idoc.CodigoEmpresa
		and pft.CodigoProduto = idoc.CodigoProduto
		
		inner join tbRegraContabilGeral rger (nolock)
		on  rger.CodigoEmpresa = idoc.CodigoEmpresa

		inner join tbRegraContabilLinha rclp (nolock)
		on  rclp.CodigoEmpresa = pft.CodigoEmpresa
		and rclp.CodigoLinhaProduto = pft.CodigoLinhaProduto
		
		left join tbRegraContabilLinhaCNO rclc (nolock)
		on  rclc.CodigoEmpresa = pft.CodigoEmpresa
		and rclc.CodigoLinhaProduto = pft.CodigoLinhaProduto
		and rclc.CodigoNaturezaOperacao = idoc.CodigoNaturezaOperacao
		and rclc.CentroCusto = dFT.CentroCusto

		where
			idoc.CodigoEmpresa = @CodigoEmpresa
		and idoc.CodigoLocal = @CodigoLocal
		and idoc.EntradaSaidaDocumento = @cEntradaSaidaDocumento
		and idoc.NumeroDocumento = @cNumeroDocumento
		and idoc.DataDocumento = @cDataDocumento
		and idoc.CodigoCliFor = @cCodigoCliFor
		and idoc.TipoLancamentoMovimentacao = @cTipoLancamentoMovimentacao
		and idoc.SequenciaItemDocumento = @cSequenciaItemDocumento

	end

	if @cTipoRegistroItemDocto = 'VEC' or @cTipoRegistroItemDocto is null
	begin

		insert @ItCtaCtb
		select
			CodigoEmpresa = idoc.CodigoEmpresa,
			CodigoLocal = idoc.CodigoLocal,
			EntradaSaidaDocumento = idoc.EntradaSaidaDocumento,
			NumeroDocumento = idoc.NumeroDocumento,
			DataDocumento = idoc.DataDocumento,
			CodigoCliFor = idoc.CodigoCliFor,
			TipoLancamentoMovimentacao = idoc.TipoLancamentoMovimentacao,
			SequenciaItemDocumento = idoc.SequenciaItemDocumento,
			ContaContabil =	coalesce(case
							when @cEntradaSaidaDocumento = 'E' then
								case
								when cno.CodigoTipoOperacao in (2,13) then rcgv.ContaEstoqueVeiculo
								when cno.CodigoTipoOperacao in (8) then rcve.ContaTotalVeiculo
								when cno.CodigoTipoOperacao in (6) then rcve.ContaRemessaVeiculo
								else '' end
							else
								case
								when cno.CodigoTipoOperacao in (4,8) then rcve.ContaTotalVeiculo
								when cno.CodigoTipoOperacao in (8,13) then rcgv.ContaEstoqueVeiculo
								when cno.CodigoTipoOperacao in (6) then rcve.ContaRemessaVeiculo
								else '' end
							end,''),
			CentroCusto =	dFT.CentroCusto

		from tbItemDocumento idoc (nolock)
		
		inner join tbItemDocumentoFT idFT (nolock)
		on  idFT.CodigoEmpresa = idoc.CodigoEmpresa
		and idFT.CodigoLocal = idoc.CodigoLocal
		and idFT.EntradaSaidaDocumento = idoc.EntradaSaidaDocumento
		and idFT.NumeroDocumento = idoc.NumeroDocumento
		and idFT.DataDocumento = idoc.DataDocumento
		and idFT.CodigoCliFor = idoc.CodigoCliFor
		and idFT.TipoLancamentoMovimentacao = idoc.TipoLancamentoMovimentacao
		and idFT.SequenciaItemDocumento = idoc.SequenciaItemDocumento
		
		left join tbDocumentoFT dFT (nolock)
		on  dFT.CodigoEmpresa = idoc.CodigoEmpresa
		and dFT.CodigoLocal = idoc.CodigoLocal
		and dFT.EntradaSaidaDocumento = idoc.EntradaSaidaDocumento
		and dFT.NumeroDocumento = idoc.NumeroDocumento
		and dFT.DataDocumento = idoc.DataDocumento
		and dFT.CodigoCliFor = idoc.CodigoCliFor
		and dFT.TipoLancamentoMovimentacao = idoc.TipoLancamentoMovimentacao
		
		inner join tbNaturezaOperacao cno (nolock)
		on  cno.CodigoEmpresa = idoc.CodigoEmpresa
		and cno.CodigoNaturezaOperacao = idoc.CodigoNaturezaOperacao

		inner join tbVeiculoCV veic (nolock)
		on  veic.CodigoEmpresa = idoc.CodigoEmpresa
		and veic.CodigoLocal = idoc.CodigoLocal
		and veic.NumeroVeiculoCV = idoc.NumeroVeiculoCV

		inner join tbModeloVeiculoCV modv (nolock)
		on  modv.CodigoEmpresa = veic.CodigoEmpresa
		and modv.ModeloVeiculo = veic.ModeloVeiculo

		inner join tbRegraContabilGrupoVeiculo rcgv (nolock)
		on  rcgv.CodigoEmpresa = modv.CodigoEmpresa
		and rcgv.CodigoGrupoVeiculo = modv.CodigoGrupoVeiculo
		and rcgv.NovoUsadoGrupoVeiculo = case when veic.VeiculoNovoCV = 'V' then 'N' else 'U' end

		left join tbRegraContabilVeiculo rcve (nolock)
		on  rcve.CodigoEmpresa = modv.CodigoEmpresa
		and rcve.CodigoGrupoVeiculo = modv.CodigoGrupoVeiculo
		and rcve.NovoUsadoVeiculo = case when veic.VeiculoNovoCV = 'V' then 'N' else 'U' end
		and rcve.CodigoNaturezaOperacao = idoc.CodigoNaturezaOperacao

		where
			idoc.CodigoEmpresa = @CodigoEmpresa
		and idoc.CodigoLocal = @CodigoLocal
		and idoc.EntradaSaidaDocumento = @cEntradaSaidaDocumento
		and idoc.NumeroDocumento = @cNumeroDocumento
		and idoc.DataDocumento = @cDataDocumento
		and idoc.CodigoCliFor = @cCodigoCliFor
		and idoc.TipoLancamentoMovimentacao = @cTipoLancamentoMovimentacao
		and idoc.SequenciaItemDocumento = @cSequenciaItemDocumento

	end

	if @cTipoRegistroItemDocto = 'MOB'
	begin

		insert @ItCtaCtb
		select
			CodigoEmpresa = idoc.CodigoEmpresa,
			CodigoLocal = idoc.CodigoLocal,
			EntradaSaidaDocumento = idoc.EntradaSaidaDocumento,
			NumeroDocumento = idoc.NumeroDocumento,
			DataDocumento = idoc.DataDocumento,
			CodigoCliFor = idoc.CodigoCliFor,
			TipoLancamentoMovimentacao = idoc.TipoLancamentoMovimentacao,
			SequenciaItemDocumento = idoc.SequenciaItemDocumento,
			ContaContabil =	coalesce(rcos.ContaTotalOficina,''),
			CentroCusto =	coalesce(rcos.CentroCustoContabOficina,rcos.CentroCusto)
			
		from tbItemDocumento idoc (nolock)
		
		inner join tbItemDocumentoFT idFT (nolock)
		on  idFT.CodigoEmpresa = idoc.CodigoEmpresa
		and idFT.CodigoLocal = idoc.CodigoLocal
		and idFT.EntradaSaidaDocumento = idoc.EntradaSaidaDocumento
		and idFT.NumeroDocumento = idoc.NumeroDocumento
		and idFT.DataDocumento = idoc.DataDocumento
		and idFT.CodigoCliFor = idoc.CodigoCliFor
		and idFT.TipoLancamentoMovimentacao = idoc.TipoLancamentoMovimentacao
		and idFT.SequenciaItemDocumento = idoc.SequenciaItemDocumento
		
		inner join tbDocumento doc (nolock)
		on  doc.CodigoEmpresa = idoc.CodigoEmpresa
		and doc.CodigoLocal = idoc.CodigoLocal
		and doc.EntradaSaidaDocumento = idoc.EntradaSaidaDocumento
		and doc.NumeroDocumento = idoc.NumeroDocumento
		and doc.DataDocumento = idoc.DataDocumento
		and doc.CodigoCliFor = idoc.CodigoCliFor
		and doc.TipoLancamentoMovimentacao = idoc.TipoLancamentoMovimentacao
		
		inner join tbDocumentoFT dFT (nolock)
		on  dFT.CodigoEmpresa = idoc.CodigoEmpresa
		and dFT.CodigoLocal = idoc.CodigoLocal
		and dFT.EntradaSaidaDocumento = idoc.EntradaSaidaDocumento
		and dFT.NumeroDocumento = idoc.NumeroDocumento
		and dFT.DataDocumento = idoc.DataDocumento
		and dFT.CodigoCliFor = idoc.CodigoCliFor
		and dFT.TipoLancamentoMovimentacao = idoc.TipoLancamentoMovimentacao
		
		inner join tbNaturezaOperacao cno (nolock)
		on  cno.CodigoEmpresa = idoc.CodigoEmpresa
		and cno.CodigoNaturezaOperacao = idoc.CodigoNaturezaOperacao

		inner join tbMaoObraOS moos (nolock)
		on  moos.CodigoEmpresa = idoc.CodigoEmpresa
		and moos.CodigoMaoObraOS = idoc.CodigoItemDocto

		inner join tbTipoMaoObra tpmo (nolock)
		on  tpmo.CodigoEmpresa = moos.CodigoEmpresa
		and tpmo.CodigoTipoMaoObra = moos.CodigoTipoMaoObra

		inner join tbItemPedido iPed (nolock)
		on  iPed.CodigoEmpresa = idoc.CodigoEmpresa
		and iPed.CodigoLocal = idoc.CodigoLocal
		and iPed.CentroCusto = dFT.CentroCusto
		and iPed.NumeroPedido = doc.NumeroPedidoDocumento
		and iPed.SequenciaPedido = doc.NumeroSequenciaPedidoDocumento
		and iPed.ItemPedido = idoc.SequenciaItemDocumento

		inner join tbRegraContabilOS rcos (nolock)
		on  rcos.CodigoEmpresa = idoc.CodigoEmpresa
		and rcos.CodigoTipoMaoObra = moos.CodigoTipoMaoObra
		and rcos.CodigoCIT = dFT.CodigoCIT
		and rcos.CentroCusto = iPed.CentroCustoMaoObra
		
		where
			idoc.CodigoEmpresa = @CodigoEmpresa
		and idoc.CodigoLocal = @CodigoLocal
		and idoc.EntradaSaidaDocumento = @cEntradaSaidaDocumento
		and idoc.NumeroDocumento = @cNumeroDocumento
		and idoc.DataDocumento = @cDataDocumento
		and idoc.CodigoCliFor = @cCodigoCliFor
		and idoc.TipoLancamentoMovimentacao = @cTipoLancamentoMovimentacao
		and idoc.SequenciaItemDocumento = @cSequenciaItemDocumento
		and cno.CodigoTipoOperacao = 10

	end

	if @cTipoRegistroItemDocto in ('OUT','MOB')
	begin

		insert @ItCtaCtb
		select
			CodigoEmpresa = idoc.CodigoEmpresa,
			CodigoLocal = idoc.CodigoLocal,
			EntradaSaidaDocumento = idoc.EntradaSaidaDocumento,
			NumeroDocumento = idoc.NumeroDocumento,
			DataDocumento = idoc.DataDocumento,
			CodigoCliFor = idoc.CodigoCliFor,
			TipoLancamentoMovimentacao = idoc.TipoLancamentoMovimentacao,
			SequenciaItemDocumento = idoc.SequenciaItemDocumento,
			ContaContabil =	coalesce(case when cno.CodigoTipoOperacao in (6) then rcno.ContaRemessaCNO else rcno.ContaTotalCNO end,''),
			CentroCusto =	coalesce(rcno.CentroCustoContabilCNO,rcno.CentroCusto)

		from tbItemDocumento idoc (nolock)
		
		inner join tbItemDocumentoFT idFT (nolock)
		on  idFT.CodigoEmpresa = idoc.CodigoEmpresa
		and idFT.CodigoLocal = idoc.CodigoLocal
		and idFT.EntradaSaidaDocumento = idoc.EntradaSaidaDocumento
		and idFT.NumeroDocumento = idoc.NumeroDocumento
		and idFT.DataDocumento = idoc.DataDocumento
		and idFT.CodigoCliFor = idoc.CodigoCliFor
		and idFT.TipoLancamentoMovimentacao = idoc.TipoLancamentoMovimentacao
		and idFT.SequenciaItemDocumento = idoc.SequenciaItemDocumento
		
		inner join tbDocumentoFT dFT (nolock)
		on  dFT.CodigoEmpresa = idoc.CodigoEmpresa
		and dFT.CodigoLocal = idoc.CodigoLocal
		and dFT.EntradaSaidaDocumento = idoc.EntradaSaidaDocumento
		and dFT.NumeroDocumento = idoc.NumeroDocumento
		and dFT.DataDocumento = idoc.DataDocumento
		and dFT.CodigoCliFor = idoc.CodigoCliFor
		and dFT.TipoLancamentoMovimentacao = idoc.TipoLancamentoMovimentacao
		
		inner join tbNaturezaOperacao cno (nolock)
		on  cno.CodigoEmpresa = idoc.CodigoEmpresa
		and cno.CodigoNaturezaOperacao = idoc.CodigoNaturezaOperacao
		
		left join tbRegraContabilCNO rcno (nolock)
		on  rcno.CodigoEmpresa = idoc.CodigoEmpresa
		and rcno.CodigoNaturezaOperacao = idoc.CodigoNaturezaOperacao
		and rcno.CentroCusto = dFT.CentroCusto

		where
			idoc.CodigoEmpresa = @CodigoEmpresa
		and idoc.CodigoLocal = @CodigoLocal
		and idoc.EntradaSaidaDocumento = @cEntradaSaidaDocumento
		and idoc.NumeroDocumento = @cNumeroDocumento
		and idoc.DataDocumento = @cDataDocumento
		and idoc.CodigoCliFor = @cCodigoCliFor
		and idoc.TipoLancamentoMovimentacao = @cTipoLancamentoMovimentacao
		and idoc.SequenciaItemDocumento = @cSequenciaItemDocumento
		and (@cTipoRegistroItemDocto = 'OUT' or cno.CodigoTipoOperacao = 12)

	end

	delete #tbCursor where id = @count

	set rowcount 1
	select @count = id from #tbCursor

end

set rowcount 0

update @ItCtaCtb set CentroCusto = null where CentroCusto = 0
update @ItCtaCtb set CentroCusto = null where left(ContaContabil,1) <= '2'
delete @ItCtaCtb where coalesce(ContaContabil,'') = ''

insert tbItemDocumentoContaContabil
select * from @ItCtaCtb

insert tbLogTransNegocio
select
	@CodigoEmpresa,
	@CodigoLocal,
	@user,
	'LF',
	host_name(),
	getdate(),
	'Conta Contábil Item Documento',
	'Carga Inicial',
	db_name(),
	'',
	convert(varchar,EntradaSaidaDocumento)+'|'+convert(varchar,NumeroDocumento)+'|'+convert(varchar(10),DataDocumento,120)+'|'+convert(varchar,CodigoCliFor)+'|'+convert(varchar,TipoLancamentoMovimentacao) + '|'+convert(varchar,SequenciaItemDocumento)+'|'+rtrim(ltrim(coalesce(convert(varchar,ContaContabil),'')))+'|'+coalesce(convert(varchar,CentroCusto),'')+'|'
from @ItCtaCtb


select
	tbItemDocumento.CodigoEmpresa,
	tbItemDocumento.CodigoLocal,
	tbItemDocumento.EntradaSaidaDocumento,
	tbItemDocumento.NumeroDocumento,
	tbItemDocumento.DataDocumento,
	tbItemDocumento.CodigoCliFor,
	tbItemDocumento.TipoLancamentoMovimentacao,
	tbItemDocumento.SequenciaItemDocumento	
from tbItemDocumento (nolock)
inner join tbDocumento (nolock)
on  tbDocumento.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
and tbDocumento.CodigoLocal = tbItemDocumento.CodigoLocal
and tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento
and tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento
and tbDocumento.DataDocumento = tbItemDocumento.DataDocumento
and tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor
and tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
inner join tbNaturezaOperacao cno (nolock)
on  cno.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
and cno.CodigoNaturezaOperacao = tbItemDocumento.CodigoNaturezaOperacao
where
	tbDocumento.CodigoEmpresa = @CodigoEmpresa
and tbDocumento.CodigoLocal = @CodigoLocal
and tbDocumento.DataDocumento between @DataInicial and @DataFinal
and not exists	(	select 1 from tbItemDocumentoContaContabil (nolock)
					where
						tbItemDocumentoContaContabil.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
					and tbItemDocumentoContaContabil.CodigoLocal = tbItemDocumento.CodigoLocal
					and tbItemDocumentoContaContabil.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento
					and tbItemDocumentoContaContabil.NumeroDocumento = tbItemDocumento.NumeroDocumento
					and tbItemDocumentoContaContabil.DataDocumento = tbItemDocumento.DataDocumento
					and tbItemDocumentoContaContabil.CodigoCliFor = tbItemDocumento.CodigoCliFor
					and tbItemDocumentoContaContabil.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
					and tbItemDocumentoContaContabil.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento
				)
and tbDocumento.TipoLancamentoMovimentacao not in (2,3,4,5,6,8,11,15)
and tbDocumento.CondicaoNFCancelada <> 'V'
and cno.AtualizaLFNaturezaOperacao = 'V'
and ( tbDocumento.EntradaSaidaDocumento = 'S' or 
      ( tbDocumento.EntradaSaidaDocumento = 'E' and tbDocumento.TipoLancamentoMovimentacao not in (1,9,10) ) or
	  ( tbDocumento.EntradaSaidaDocumento = 'E' and tbDocumento.TipoLancamentoMovimentacao in (1,9,10) and tbDocumento.ValorPISDocumento + tbDocumento.ValorFinsocialDocumento <> 0 )
	)

set nocount off