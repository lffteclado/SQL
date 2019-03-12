/* Declaração das Variáveis */

declare @CodEmp numeric(04)
declare @DataI Datetime
declare @DataF Datetime
--declare @ContaI char(12)
--declare @ContaF char(12)
declare @CCustoI NUMERIC(8)
declare @CCustoF NUMERIC(8)
declare @CodLoc numeric(04)
declare @CodLocF numeric(04)


--select * from #tmpVenda order by NotaFiscal

--select * from tbMovimentoContabil where CodigoContaMovtoContabil between '3103019902' and '3103019908'

--select * from tbMovimentoContabil where NumeroControleMovtoContabil = 4804933

--select * from tbMovimentoContabil where NumeroDocumentoMovtoContabil = 278328
 

--select * from #tmpCusto order by NotaFiscal

--select * from #tmpVenda where NotaFiscal = 286264
--select CONVERT (VARCHAR, DataL,3) as [Data do Movimento], * from #tmpICMS order by DataL

--select * from #tmpPIS order by NotaFiscal where NotaFiscal = 278328

--select * from #tmpCOF  order by NotaFiscal where NotaFiscal = 278328




--drop table #tmpCusto

--drop table #tmpVenda

--drop table #tmpICMS

--drop table #tmpPIS

--drop table #tmpCOF


/*

select CONVERT (VARCHAR, tpV.DataL,3) as [Data do Movimento],
       tpV.NotaFiscal as [Nota Fiscal],
       tpV.CentroCusto as [Centro de Custo],
	   tpV.ValorVenda as [Valor da Venda],
	   tpV.DebitoCredito as [Débito/Crédito],
	   tpC.Custo,
	   tpC.DebitoCredito as  [Débito/Crédito],
	   CONVERT (VARCHAR, tpPS.DataL,3) as [Data do Movimento PIS],
	   tpPS.PIS,
	   tpPS.NotaFiscal as [Nota Fiscal PIS],
	   tpPS.DebitoCredito as [Débito/Crédito],
	   CONVERT (VARCHAR, tpCF.DataL,3) as [Data do Movimento COFINS],
	   tpCF.COFINS,
	   tpCF.NotaFiscal as [Nota Fiscal COFINS],
	   tpCF.DebitoCredito as [Débito/Crédito]
 from  #tmpVenda tpV
 inner join #tmpCusto tpC on
 tpV.NotaFiscal = tpC.NotaFiscal
 full outer join #tmpPIS tpPS on
 tpV.NotaFiscal = tpPS.NotaFiscal 
 full outer join #tmpCOF tpCF on
 tpV.NotaFiscal = tpCF.Notafiscal order by tpV.NotaFiscal
 


 

select distinct tpV.DataL as [Data do Movimento],
       tpV.NotaFiscal as [Nota Fiscal],
	   tpV.CentroCusto as [Centro de Custo],
	   tpV.ValorVenda as [Valor da Venda],       
	   tpI.ICMS
 from #tmpVenda tpV
 inner join #tmpICMS tpI on
 tpV.NotaFiscal = tpI.NotaFiscal
 

 select CONVERT (VARCHAR, tpPS.DataL,3) as [Data do Movimento],
		tpPS.NotaFiscal as [Nota Fiscal],
		tpPS.CentroCusto as [Centro de Custo],

 from #tmpPIS
				
*/

 



/* Alimentando a Tabela Temporária Venda */	

/* Setando os valores para as variáveis */


set @CodEmp = 1200
set @DataI = '2017-01-01'
set @DataF = '2017-04-30'
--set @ContaI = '3103019901'
--set @ContaF = '3103019901'
set @CCustoI = 21330
set @CCustoF = 21330
set @CodLoc = 0
set @CodLocF = 0

select CodigoEmpresa as Empresa,
	   DataLancamentoMovtoContabil as DataL,
	   NumeroDocumentoMovtoContabil as NotaFiscal,
       CodigoCCustoContaMovtoContabil as CentroCusto,
	   ValorLancamentoMovtoContabil as ValorVenda,
	   DebCreMovtoContabil as DebitoCredito      
into #tmpVenda
from tbMovimentoContabil (nolock) 
where	
			CodigoEmpresa = @CodEmp and
			DataLancamentoMovtoContabil between @DataI and @DataF and 
			CodigoContaMovtoContabil in ('3103019901', '3103029901', '3103039901') and 
			CodigoCCustoContaMovtoContabil between @CCustoI and @CCustoF and
			CodigoLocal between @CodLoc and @CodLocF and
				(
					(
					CodigoOperacaoBancaria is null			
					)
					or
					(
					CodigoOperacaoBancaria in (select CodigoOperacaoBancaria
									from tbOperacaoBancaria (nolock)
									where ContabilOperacaoBancaria = 'V'
									and CodigoEmpresa = @CodEmp)				
					)
				)	


/* Alimentando a Tabela Temporária Custo */	

/* Setando os valores para as variáveis */

set @CodEmp = 1200
set @DataI = '2017-01-01'
set @DataF = '2017-04-30'
--set @ContaI = '4103019901'
--set @ContaF = '4103019901'
set @CCustoI = 21330
set @CCustoF = 21330
set @CodLoc = 0
set @CodLocF = 0

select CodigoEmpresa as Empresa,
	   DataLancamentoMovtoContabil as DataL,
	   NumeroDocumentoMovtoContabil as NotaFiscal,
       CodigoCCustoContaMovtoContabil as CentroCusto,
	   ValorLancamentoMovtoContabil as Custo,
	   DebCreMovtoContabil as DebitoCredito   	   
into #tmpCusto
from tbMovimentoContabil (nolock) 
where	
			CodigoEmpresa = @CodEmp and
			DataLancamentoMovtoContabil between @DataI and @DataF and 
			CodigoContaMovtoContabil in ('4103019901', '4103029901', '4103039901') and 
			CodigoCCustoContaMovtoContabil between @CCustoI and @CCustoF and
			CodigoLocal between @CodLoc and @CodLocF and
				(
					(
					CodigoOperacaoBancaria is null			
					)
					or
					(
					CodigoOperacaoBancaria in (select CodigoOperacaoBancaria
									from tbOperacaoBancaria (nolock)
									where ContabilOperacaoBancaria = 'V'
									and CodigoEmpresa = @CodEmp)				
					)
				)

/* Alimentando a Tabela Temporária ICMS */	

/* Setando os valores para as variáveis */

set @CodEmp = 1200
set @DataI = '2017-01-01'
set @DataF = '2017-04-30'
--set @ContaI = '3303019903'
--set @ContaF = '3303019903'
set @CCustoI = 21330
set @CCustoF = 21330
set @CodLoc = 0
set @CodLocF = 0

select CodigoEmpresa as Empresa,
	   DataLancamentoMovtoContabil as DataL,
	   NumeroDocumentoMovtoContabil as NotaFiscal,
       CodigoCCustoContaMovtoContabil as CentroCusto,
	   ValorLancamentoMovtoContabil as ICMS,
	   DebCreMovtoContabil as DebitoCredito   	   
into #tmpICMS
from tbMovimentoContabil (nolock) 
where	
			CodigoEmpresa = @CodEmp and
			DataLancamentoMovtoContabil between @DataI and @DataF and 
			CodigoContaMovtoContabil in ('3303019903', '3303029903', '3303039903') and 
			CodigoCCustoContaMovtoContabil between @CCustoI and @CCustoF and
			CodigoLocal between @CodLoc and @CodLocF and
				(
					(
					CodigoOperacaoBancaria is null			
					)
					or
					(
					CodigoOperacaoBancaria in (select CodigoOperacaoBancaria
									from tbOperacaoBancaria (nolock)
									where ContabilOperacaoBancaria = 'V'
									and CodigoEmpresa = @CodEmp)				
					)
				)
/* Alimentando a Tabela Temporária PIS */	

/* Setando os valores para as variáveis */

set @CodEmp = 1200
set @DataI = '2017-01-01'
set @DataF = '2017-04-30'
--set @ContaI = '3303029903'
--set @ContaF = '3303029903'
set @CCustoI = 21330
set @CCustoF = 21330
set @CodLoc = 0
set @CodLocF = 0

select CodigoEmpresa as Empresa,
	   DataLancamentoMovtoContabil as DataL,
	   NumeroDocumentoMovtoContabil as NotaFiscal,
       CodigoCCustoContaMovtoContabil as CentroCusto,
	   ValorLancamentoMovtoContabil as PIS,
	   DebCreMovtoContabil as DebitoCredito   	   
into #tmpPIS
from tbMovimentoContabil (nolock) 
where	
			CodigoEmpresa = @CodEmp and
			DataLancamentoMovtoContabil between @DataI and @DataF and 
			CodigoContaMovtoContabil in ('3303019904', '3303029904', '3303039904') and 
			CodigoCCustoContaMovtoContabil between @CCustoI and @CCustoF and
			CodigoLocal between @CodLoc and @CodLocF and
				(
					(
					CodigoOperacaoBancaria is null			
					)
					or
					(
					CodigoOperacaoBancaria in (select CodigoOperacaoBancaria
									from tbOperacaoBancaria (nolock)
									where ContabilOperacaoBancaria = 'V'
									and CodigoEmpresa = @CodEmp)				
					)
				)

/* Alimentando a Tabela Temporária COFINS */	

/* Setando os valores para as variáveis */

set @CodEmp = 1200
set @DataI = '2017-01-01'
set @DataF = '2017-04-30'
--set @ContaI = '3303039903'
--set @ContaF = '3303039903'
set @CCustoI = 21330
set @CCustoF = 21330
set @CodLoc = 0
set @CodLocF = 0

select CodigoEmpresa as Empresa,
	   DataLancamentoMovtoContabil as DataL,
	   NumeroDocumentoMovtoContabil as NotaFiscal,
       CodigoCCustoContaMovtoContabil as CentroCusto,
	   ValorLancamentoMovtoContabil as COFINS,
	   DebCreMovtoContabil as DebitoCredito      
into #tmpCOF
from tbMovimentoContabil (nolock) 
where	
			CodigoEmpresa = @CodEmp and
			DataLancamentoMovtoContabil between @DataI and @DataF and 
			CodigoContaMovtoContabil in ('3303019905', '3303029905', '3303039905') and 
			CodigoCCustoContaMovtoContabil between @CCustoI and @CCustoF and
			CodigoLocal between @CodLoc and @CodLocF and
				(
					(
					CodigoOperacaoBancaria is null			
					)
					or
					(
					CodigoOperacaoBancaria in (select CodigoOperacaoBancaria
									from tbOperacaoBancaria (nolock)
									where ContabilOperacaoBancaria = 'V'
									and CodigoEmpresa = @CodEmp)				
					)
				)