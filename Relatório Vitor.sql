select DataLancamentoMovtoContabil,
		tbMC.CodigoEmpresa,
		tbMC.CodigoLocal,
		tbMC.OrigemLancamentoMovtoContabil,
		tbMC.CodigoCCustoContaMovtoContabil as CentroCustoContaMovto,
		tbCC.DescricaoCentroCusto as DescricaoCentroCustoMovto,
		tbMC.CodigoContaMovtoContabil,
		tbPC.DescricaoContaContabil,
		tbMC.CodigoCCustoCPartMovtoContabil,
		tbMC.ContraPartidaMovtoContabil,
		tbMC.NumeroDocumentoMovtoContabil as NF,
		tbMC.NumeroDocumentoMovtoContabil as Dcoumento,
		tbMC.NumeroControleMovtoContabil as NRI,
		tbMC.HistoricoMovtoContabil as HistoricoLancamento,
		tbMC.SequenciaLanctoMovtoContabil as SequenciaMovto,
		tbMC.SequenciaDoctoMovtoContabil as SequenciaMovtoDocto,
		tbMC.DebCreMovtoContabil as TipoMovto,
		tbMC.ValorLancamentoMovtoContabil 		
		from tbMovimentoContabil tbMC 
		left join tbCentroCusto tbCC on
		tbCC.CentroCusto = tbMC.CodigoCCustoContaMovtoContabil
		or tbCC.CentroCusto = tbMC.CodigoCCustoCPartMovtoContabil
		inner join tbPlanoContas tbPC on
		tbPC.CodigoContaContabil = tbMC.CodigoContaMovtoContabil 
		where tbMC.DataLancamentoMovtoContabil between '2017-08-01' and '2017-08-31'
		and tbMC.CodigoContaMovtoContabil between  4301019901 and 5101049949
		order by tbMC.DataLancamentoMovtoContabil,tbMC.CodigoCCustoContaMovtoContabil ASC