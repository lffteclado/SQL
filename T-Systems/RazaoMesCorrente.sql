-- Periodo anteriores ao atual
drop table tbRazaoProdutos
go
CREATE TABLE tbRazaoProdutos ( CodigoEmpresa   numeric(4) ,
    CodigoLocal   numeric(4) ,
    CodigoProduto   char(30) null,
    QtdeSaldoAnterior  numeric(16,4) null,
    ValSaldoAnterior  numeric(16,4) null,
    QtdeCompras   numeric(16,4) null,
    ValorCompras   numeric(16,4) null,
    QtdeDevVendas   numeric(16,4)  null,
    ValorDevVendas   numeric(16,4)  null,
    QtdeDevVendasCanc   numeric(16,4)  null,
    ValorDevVendasCanc   numeric(16,4)  null,
    QtdeVendas   numeric(16,4) null,
    ValorVendas   numeric(16,4) null,
    QtdeDevCompras   numeric(16,4) null,
    ValorDevCompras   numeric(16,4) null,
    QtdeDevComprasCanc   numeric(16,4) null,
    ValorDevComprasCanc   numeric(16,4) null,
    QtdeInvEntrada   numeric(16,4) null,
    ValorInvEntrada   numeric(16,4) null,
    QtdeInvSaida   numeric(16,4) null,
    ValorInvSaida   numeric(16,4) null,
    QtdeNFCancelada   numeric(16,4) null,
    ValorNFCancelada  numeric(16,4) null,
    QtdeTransfEntrada  numeric(16,4) null,
    ValorTransfEntrada  numeric(16,4) null,
    QtdeTransfSaida   numeric(16,4) null,
    ValorTransfSaida  numeric(16,4) null,
    QtdeTransfEntradaCanc  numeric(16,4) null,
    ValorTransfEntradaCanc  numeric(16,4) null,
    QtdeTransfSaidaCanc   numeric(16,4) null,
    ValorTransfSaidaCanc  numeric(16,4) null,
    QtdeRemPropEntrada	numeric(16,4) null,
    ValorRemPropEntrada	numeric(16,4) null,
    QtdeRemPropEntradaCanc	numeric(16,4) null,
    ValorRemPropEntradaCanc	numeric(16,4) null,
    QtdeRemPropSaida	numeric(16,4) null,
    ValorRemPropSaida	numeric(16,4) null,
    QtdeRemPropSaidaCanc	numeric(16,4) null,
    ValorRemPropSaidaCanc	numeric(16,4) null,
    QtdeSaldoFinal   numeric(16,4) null,
    ValorSaldoFinal   numeric(16,4) null,
    QtdeSaldoApurado  numeric(16,4) null,
    ValorSaldoApurado  numeric(16,4) null)

declare @CodigoEmpresa	    dtInteiro04
declare @CodigoLocal	    dtInteiro04
declare @PeriodoAnterior    dtAnoMes
declare	@PeriodoMovto	    dtAnoMes
declare @DataInicioMovto    datetime
declare @DataFimMovto	    datetime

-- Locais 0
select @CodigoEmpresa = 260
select @CodigoLocal = 0
select @PeriodoMovto = '201001'

select @DataInicioMovto = CONVERT(DATETIME, SUBSTRING(@PeriodoMovto,1,4) + SUBSTRING(@PeriodoMovto,5,2) + '01')
select @DataFimMovto	= DATEADD(DAY,-1,DATEADD(MONTH,+1,CONVERT(DATETIME, SUBSTRING(@PeriodoMovto,1,4) + SUBSTRING(@PeriodoMovto,5,2) + '01')))
select @PeriodoAnterior = CONVERT(CHAR(6),DATEADD(MONTH, -1, (CONVERT(CHAR(6),@PeriodoMovto) + '01')),112)

select @DataInicioMovto as DataInicio, @DataFimMovto as DataFim, @PeriodoAnterior as PeriodoAnterior


insert tbRazaoProdutos
 select a.CodigoEmpresa,
  a.CodigoLocal,
  a.CodigoProduto,
  sum(QtdeAntSaldoAtuAlmoxarifado),
  0, -- ValSaldoAnterior
  0, -- QtdeCompras
  0, -- ValorCompras
  0, -- QtdeDevVendas
  0, -- ValorDevVendas
  0, -- QtdeDevVendasCanc
  0, -- ValorDevVendasCanc
  0, -- QtdeVendas
  0, -- ValorVendas
  0, -- QtdeDevCompras
  0, -- ValorDevCompras
  0, -- QtdeDevComprasCanc
  0, -- ValorDevComprasCanc
  0, -- QtdeInvEntrada
  0, -- ValorInvEntrada
  0, -- QtdeInvSaida
  0, -- ValorInvSaida
  0, -- QtdeNFCancelada
  0, -- ValorNFCancelada
  0, -- QtdeTransfEntrada
  0, -- ValorTransfEntrada
  0, -- QtdeTransfSaida
  0, -- ValorTransfSaida
  0, -- QtdeTransfEntradaCanc
  0, -- ValorTransfEntradaCanc
  0, -- QtdeTransfSaidaCanc
  0, -- ValorTransfSaidaCanc
  0, -- QtdeRemPropEntrada
  0, -- ValorRemPropEntrada
  0, -- QtdeRemPropEntradaCanc
  0, -- ValorRemPropEntradaCanc
  0, -- QtdeRemPropSaida
  0, -- ValorRemPropSaida
  0, -- QtdeRemPropSaidaCanc
  0, -- ValorRemPropSaidaCanc
  sum(QtdeAntSaldoAtuAlmoxarifado + QtdeEntradaSaldoAtuAlmox - QtdeSaidaSaldoAtuAlmoxarifado),
  a.SaldoValorEstoque,
  0, -- QtdeSaldoApurado
  0  -- ValorSaldoApurado
 from tbValorEstoquePeriodo a
 inner join tbSaldoAtualAlmoxarifado b
 on b.CodigoEmpresa   = a.CodigoEmpresa
 and b.CodigoLocal   = a.CodigoLocal
 and b.CodigoProduto   = a.CodigoProduto
 inner join tbAlmoxarifado c
 on c.CodigoEmpresa   = b.CodigoEmpresa
 and c.CodigoLocal   = b.CodigoLocal
 and c.CodigoAlmoxarifado  = b.CodigoAlmoxarifado
 where a.CodigoEmpresa   = @CodigoEmpresa
 and a.CodigoLocal   = @CodigoLocal
 and a.PeriodoValorEstoque  = @PeriodoMovto
-- and b.PeriodoSaldoAlmoxarifado = @PeriodoMovto
 and (c.ProducaoAlmoxarifado  = 'V' OR c.TipoAlmoxarifadoConsumo NOT IN ('C', 'D', 'E', 'M', 'N', 'U'))
 group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto, a.SaldoValorEstoque

-- atualiza valor anterior
update tbRazaoProdutos
set ValSaldoAnterior = a.SaldoValorEstoque
from tbValorEstoquePeriodo a
where a.CodigoEmpresa  = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal  = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto  = tbRazaoProdutos.CodigoProduto
and a.PeriodoValorEstoque = @PeriodoAnterior

-- atualiza compras
select CodigoEmpresa,
 CodigoLocal,
 CodigoProduto,
 sum(QtdeLancamentoItemDocto) AS QtdeCompras,
 sum(ValorLancamentoItemDocto) AS ValorCompras
into #Compras
from vwItemDocumentoCompras
where CodigoEmpresa = @CodigoEmpresa and CodigoLocal = @CodigoLocal and DataDocumento between @DataInicioMovto and @DataFimMovto
group by CodigoEmpresa, CodigoLocal, CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeCompras = a.QtdeCompras,
 tbRazaoProdutos.ValorCompras = a.ValorCompras
from #Compras a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto
 
-- atualiza Devolucao Vendas
select a.CodigoEmpresa,
 a.CodigoLocal,
 a.CodigoProduto,
 sum(QtdeLancamentoItemDocto)    AS QtdeDevVendas,
 sum(QtdeLancamentoItemDocto * CustoLancamentoItemDocto) AS ValorDevVendas
into #DevVendas
from tbItemDocumento a
inner join tbNaturezaOperacao b
on b.CodigoEmpresa   = a.CodigoEmpresa
and b.CodigoNaturezaOperacao = a.CodigoNaturezaOperacao
where a.CodigoEmpresa   = @CodigoEmpresa
and a.CodigoLocal   = @CodigoLocal
and a.DataDocumento   between @DataInicioMovto and @DataFimMovto
and a.CodigoProduto   is not null
and b.CodigoTipoOperacao  = 7 and a.TipoLancamentoMovimentacao = 7
and a.EntradaSaidaDocumento  = 'E'
group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeDevVendas = a.QtdeDevVendas,
 tbRazaoProdutos.ValorDevVendas = a.ValorDevVendas
from #DevVendas a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto

-- atualiza Devolucao de Vendas - Cancelada
select a.CodigoEmpresa,
 a.CodigoLocal,
 a.CodigoProduto,
 sum(QtdeLancamentoItemDocto)    AS QtdeDevVendasCanc,
 sum(QtdeLancamentoItemDocto * CustoLancamentoItemDocto)	AS ValorDevVendasCanc
into #DevVendasCanc
from tbItemDocumento a
inner join tbNaturezaOperacao b
on b.CodigoEmpresa   = a.CodigoEmpresa
and b.CodigoNaturezaOperacao = a.CodigoNaturezaOperacao
where a.CodigoEmpresa   = @CodigoEmpresa
and a.CodigoLocal   = @CodigoLocal
and a.DataDocumento   between @DataInicioMovto and @DataFimMovto
and a.CodigoProduto   is not null
and b.CodigoTipoOperacao  = 7 and a.TipoLancamentoMovimentacao = 11
and a.EntradaSaidaDocumento  = 'E'
group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeDevVendasCanc = a.QtdeDevVendasCanc,
 tbRazaoProdutos.ValorDevVendasCanc = a.ValorDevVendasCanc
from #DevVendasCanc a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto


-- atualiza Vendas
select a.CodigoEmpresa,
 a.CodigoLocal,
 a.CodigoProduto,
 sum(QtdeLancamentoItemDocto)    AS QtdeVendas,
 sum(QtdeLancamentoItemDocto * CustoLancamentoItemDocto) AS ValorVendas
into #Vendas
from tbItemDocumento a
inner join tbNaturezaOperacao b
on b.CodigoEmpresa   = a.CodigoEmpresa
and b.CodigoNaturezaOperacao = a.CodigoNaturezaOperacao
where a.CodigoEmpresa   = @CodigoEmpresa
and a.CodigoLocal   = @CodigoLocal
and a.DataDocumento   between @DataInicioMovto and @DataFimMovto
and a.CodigoProduto   is not null
and b.CodigoTipoOperacao  IN (3, 98)
and a.TipoLancamentoMovimentacao IN (2, 7)
group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeVendas = a.QtdeVendas,
 tbRazaoProdutos.ValorVendas = a.ValorVendas
from #Vendas a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto
 
-- atualiza Devolucao de Compras
select a.CodigoEmpresa,
 a.CodigoLocal,
 a.CodigoProduto,
 sum(QtdeLancamentoItemDocto)    AS QtdeDevCompras,
 sum(QtdeLancamentoItemDocto * CustoLancamentoItemDocto) AS ValorDevCompras
into #DevCompras
from tbItemDocumento a
inner join tbNaturezaOperacao b
on b.CodigoEmpresa   = a.CodigoEmpresa
and b.CodigoNaturezaOperacao = a.CodigoNaturezaOperacao
where a.CodigoEmpresa   = @CodigoEmpresa
and a.CodigoLocal   = @CodigoLocal
and a.DataDocumento   between @DataInicioMovto and @DataFimMovto
and a.CodigoProduto   is not null
and b.CodigoTipoOperacao  = 7 and a.TipoLancamentoMovimentacao = 7
and a.EntradaSaidaDocumento  = 'S'
group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeDevCompras = a.QtdeDevCompras,
 tbRazaoProdutos.ValorDevCompras = a.ValorDevCompras
from #DevCompras a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto
 
-- atualiza Devolucao de Compras - Cancelada
select a.CodigoEmpresa,
 a.CodigoLocal,
 a.CodigoProduto,
 sum(QtdeLancamentoItemDocto)    AS QtdeDevComprasCanc,
 sum(QtdeLancamentoItemDocto * CustoLancamentoItemDocto) AS ValorDevComprasCanc
into #DevComprasCanc
from tbItemDocumento a
inner join tbNaturezaOperacao b
on b.CodigoEmpresa   = a.CodigoEmpresa
and b.CodigoNaturezaOperacao = a.CodigoNaturezaOperacao
where a.CodigoEmpresa   = @CodigoEmpresa
and a.CodigoLocal   = @CodigoLocal
and a.DataDocumento   between @DataInicioMovto and @DataFimMovto
and a.CodigoProduto   is not null
and b.CodigoTipoOperacao  = 7 and a.TipoLancamentoMovimentacao = 11
and a.EntradaSaidaDocumento  = 'S'
group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeDevComprasCanc = a.QtdeDevComprasCanc,
 tbRazaoProdutos.ValorDevComprasCanc = a.ValorDevComprasCanc
from #DevComprasCanc a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto
 
-- atualiza Inventario - entradas
select a.CodigoEmpresa,
 a.CodigoLocal,
 a.CodigoProduto,
 sum(QtdeLancamentoItemDocto)   AS QtdeInvEntrada,
 sum(ValorLancamentoItemDocto)	AS 
ValorInvEntrada
into #InvEntradas
from tbItemDocumento a
inner join tbNaturezaOperacao b
on b.CodigoEmpresa   = a.CodigoEmpresa
and b.CodigoNaturezaOperacao = a.CodigoNaturezaOperacao
where a.CodigoEmpresa   = @CodigoEmpresa
and a.CodigoLocal   = @CodigoLocal
and a.DataDocumento   between @DataInicioMovto and @DataFimMovto
and a.CodigoProduto   is not null
and b.CodigoTipoOperacao  = 93
and a.EntradaSaidaDocumento  = 'E'
group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeInvEntrada = a.QtdeInvEntrada,
 tbRazaoProdutos.ValorInvEntrada = a.ValorInvEntrada
from #InvEntradas a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto

-- atualiza Inventario - saidas
select a.CodigoEmpresa,
 a.CodigoLocal,
 a.CodigoProduto,
 sum(QtdeLancamentoItemDocto)    AS QtdeInvSaida,
 sum(QtdeLancamentoItemDocto * CustoLancamentoItemDocto) AS ValorInvSaida
into #InvSaidas
from tbItemDocumento a
inner join tbNaturezaOperacao b
on b.CodigoEmpresa   = a.CodigoEmpresa
and b.CodigoNaturezaOperacao = a.CodigoNaturezaOperacao
where a.CodigoEmpresa   = @CodigoEmpresa
and a.CodigoLocal   = @CodigoLocal
and a.DataDocumento   between @DataInicioMovto and @DataFimMovto
and a.CodigoProduto   is not null
and b.CodigoTipoOperacao  = 93
and a.EntradaSaidaDocumento  = 'S'
group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeInvSaida = a.QtdeInvSaida,
 tbRazaoProdutos.ValorInvSaida = a.ValorInvSaida
from #InvSaidas a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto

-- atualiza Vendas Canceladas
select a.CodigoEmpresa,
 a.CodigoLocal,
 a.CodigoProduto,
 sum(QtdeLancamentoItemDocto)    AS QtdeNFCancelada,
 sum(QtdeLancamentoItemDocto * CustoLancamentoItemDocto) AS ValorNFCancelada
into #Canceladas
from tbItemDocumento a
inner join tbNaturezaOperacao b
on b.CodigoEmpresa   = a.CodigoEmpresa
and b.CodigoNaturezaOperacao = a.CodigoNaturezaOperacao
where a.CodigoEmpresa   = @CodigoEmpresa
and a.CodigoLocal   = @CodigoLocal
and a.DataDocumento   between @DataInicioMovto and @DataFimMovto
and a.CodigoProduto   is not null
and b.CodigoTipoOperacao  IN (3, 98)
and a.TipoLancamentoMovimentacao = 11
group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeNFCancelada = a.QtdeNFCancelada,
 tbRazaoProdutos.ValorNFCancelada = a.ValorNFCancelada
from #Canceladas a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto
 
-- atualiza Transferencias - Entrada
select a.CodigoEmpresa,
 a.CodigoLocal,
 a.CodigoProduto,
 sum(QtdeLancamentoItemDocto)    AS QtdeTransfEntrada,
 sum(QtdeLancamentoItemDocto * CustoLancamentoItemDocto) AS ValorTransfEntrada
into #TransfEntrada
from tbItemDocumento a
inner join tbNaturezaOperacao b
on b.CodigoEmpresa   = a.CodigoEmpresa
and b.CodigoNaturezaOperacao = a.CodigoNaturezaOperacao
where a.CodigoEmpresa   = @CodigoEmpresa
and a.CodigoLocal   = @CodigoLocal
and a.DataDocumento   between @DataInicioMovto and @DataFimMovto
and a.CodigoProduto   is not null
and b.CodigoTipoOperacao  IN (9, 30)
and a.EntradaSaidaDocumento  = 'E' and a.TipoLancamentoMovimentacao != 11
group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeTransfEntrada = a.QtdeTransfEntrada,
 tbRazaoProdutos.ValorTransfEntrada = a.ValorTransfEntrada
from #TransfEntrada a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto
 
-- atualiza Transferencias - Entrada Cancelada
select a.CodigoEmpresa,
 a.CodigoLocal,
 a.CodigoProduto,
 sum(QtdeLancamentoItemDocto)    AS QtdeTransfEntradaCanc,
 sum(QtdeLancamentoItemDocto * CustoLancamentoItemDocto) AS ValorTransfEntradaCanc
into #TransfEntradaCanc
from tbItemDocumento a
inner join tbNaturezaOperacao b
on b.CodigoEmpresa   = a.CodigoEmpresa
and b.CodigoNaturezaOperacao = a.CodigoNaturezaOperacao
where a.CodigoEmpresa   = @CodigoEmpresa
and a.CodigoLocal   = @CodigoLocal
and a.DataDocumento   between @DataInicioMovto and @DataFimMovto
and a.CodigoProduto   is not null
and b.CodigoTipoOperacao  IN (9, 30)
and a.EntradaSaidaDocumento  = 'E'  and a.TipoLancamentoMovimentacao = 11
group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeTransfEntradaCanc = a.QtdeTransfEntradaCanc,
 tbRazaoProdutos.ValorTransfEntradaCanc = a.ValorTransfEntradaCanc
from #TransfEntradaCanc a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto
 
-- atualiza Transferencias - Saida
select a.CodigoEmpresa,
 a.CodigoLocal,
 a.CodigoProduto,
 sum(QtdeLancamentoItemDocto)    AS QtdeTransfSaida,
 sum(QtdeLancamentoItemDocto * CustoLancamentoItemDocto) AS ValorTransfSaida
into #TransfSaida
from tbItemDocumento a
inner join tbNaturezaOperacao b
on b.CodigoEmpresa   = a.CodigoEmpresa
and b.CodigoNaturezaOperacao = a.CodigoNaturezaOperacao
where a.CodigoEmpresa   = @CodigoEmpresa
and a.CodigoLocal   = @CodigoLocal
and a.DataDocumento   between @DataInicioMovto and @DataFimMovto
and a.CodigoProduto   is not null
and b.CodigoTipoOperacao  IN (9, 30)
and a.EntradaSaidaDocumento  = 'S' and a.TipoLancamentoMovimentacao != 11
group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeTransfSaida = a.QtdeTransfSaida,
 tbRazaoProdutos.ValorTransfSaida = a.ValorTransfSaida
from #TransfSaida a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto

-- atualiza Transferencias - Saida Cancelada
select a.CodigoEmpresa,
 a.CodigoLocal,
 a.CodigoProduto,
 sum(QtdeLancamentoItemDocto)    AS QtdeTransfSaidaCanc,
 sum(QtdeLancamentoItemDocto * CustoLancamentoItemDocto) AS ValorTransfSaidaCanc
into #TransfSaidaCanc
from tbItemDocumento a
inner join tbNaturezaOperacao b
on b.CodigoEmpresa   = a.CodigoEmpresa
and b.CodigoNaturezaOperacao = a.CodigoNaturezaOperacao
where a.CodigoEmpresa   = @CodigoEmpresa
and a.CodigoLocal   = @CodigoLocal
and a.DataDocumento   between @DataInicioMovto and @DataFimMovto
and a.CodigoProduto   is not null
and b.CodigoTipoOperacao  IN (9, 30)
and a.EntradaSaidaDocumento  = 'S' and a.TipoLancamentoMovimentacao = 11
group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeTransfSaidaCanc = a.QtdeTransfSaidaCanc,
 tbRazaoProdutos.ValorTransfSaidaCanc = a.ValorTransfSaidaCanc
from #TransfSaidaCanc a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto

-- atualiza Remessas Proprias - Entrada
select a.CodigoEmpresa,
 a.CodigoLocal,
 a.CodigoProduto,
 sum(QtdeLancamentoItemDocto)    AS QtdeRemPropEntrada,
 sum(ValorLancamentoItemDocto) AS ValorRemPropEntrada
into #RemPropEntrada
from tbItemDocumento a
inner join tbNaturezaOperacao b
on b.CodigoEmpresa   = a.CodigoEmpresa
and b.CodigoNaturezaOperacao = a.CodigoNaturezaOperacao
where a.CodigoEmpresa   = @CodigoEmpresa
and a.CodigoLocal   = @CodigoLocal
and a.DataDocumento   between @DataInicioMovto and @DataFimMovto
and a.CodigoProduto   is not null
and b.CodigoTipoOperacao  = 14 and a.TipoLancamentoMovimentacao = 7
and a.EntradaSaidaDocumento  = 'E'
group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeRemPropEntrada = a.QtdeRemPropEntrada,
 tbRazaoProdutos.ValorRemPropEntrada = a.ValorRemPropEntrada
from #RemPropEntrada a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto

-- atualiza Remessas Proprias - Entrada Cancelada
select a.CodigoEmpresa,
 a.CodigoLocal,
 a.CodigoProduto,
 sum(QtdeLancamentoItemDocto)    AS QtdeRemPropEntradaCanc,
 sum(ValorLancamentoItemDocto) AS ValorRemPropEntradaCanc
into #RemPropEntradaCanc
from tbItemDocumento a
inner join tbNaturezaOperacao b
on b.CodigoEmpresa   = a.CodigoEmpresa
and b.CodigoNaturezaOperacao = a.CodigoNaturezaOperacao
where a.CodigoEmpresa   = @CodigoEmpresa
and a.CodigoLocal   = @CodigoLocal
and a.DataDocumento   between @DataInicioMovto and @DataFimMovto
and a.CodigoProduto   is not null
and b.CodigoTipoOperacao  = 14 and a.TipoLancamentoMovimentacao = 11
and a.EntradaSaidaDocumento  = 'E'
group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeRemPropEntradaCanc = a.QtdeRemPropEntradaCanc,
 tbRazaoProdutos.ValorRemPropEntradaCanc = a.ValorRemPropEntradaCanc
from #RemPropEntradaCanc a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto

-- atualiza Remessas Proprias - Saida
select a.CodigoEmpresa,
 a.CodigoLocal,
 a.CodigoProduto,
 sum(QtdeLancamentoItemDocto)    AS QtdeRemPropSaida,
 sum(QtdeLancamentoItemDocto * CustoLancamentoItemDocto) AS ValorRemPropSaida
into #RemPropSaida
from tbItemDocumento a
inner join tbNaturezaOperacao b
on b.CodigoEmpresa   = a.CodigoEmpresa
and b.CodigoNaturezaOperacao = a.CodigoNaturezaOperacao
where a.CodigoEmpresa   = @CodigoEmpresa
and a.CodigoLocal   = @CodigoLocal
and a.DataDocumento   between @DataInicioMovto and @DataFimMovto
and a.CodigoProduto   is not null
and b.CodigoTipoOperacao  = 14 and a.TipoLancamentoMovimentacao = 7
and a.EntradaSaidaDocumento  = 'S'
group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeRemPropSaida = a.QtdeRemPropSaida,
 tbRazaoProdutos.ValorRemPropSaida = a.ValorRemPropSaida
from #RemPropSaida a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto

-- atualiza Remessas Proprias - Saida Cancelada
select a.CodigoEmpresa,
 a.CodigoLocal,
 a.CodigoProduto,
 sum(QtdeLancamentoItemDocto)    AS QtdeRemPropSaidaCanc,
 sum(QtdeLancamentoItemDocto * CustoLancamentoItemDocto) AS ValorRemPropSaidaCanc
into #RemPropSaidaCanc
from tbItemDocumento a
inner join tbNaturezaOperacao b
on b.CodigoEmpresa   = a.CodigoEmpresa
and b.CodigoNaturezaOperacao = a.CodigoNaturezaOperacao
where a.CodigoEmpresa   = @CodigoEmpresa
and a.CodigoLocal   = @CodigoLocal
and a.DataDocumento   between @DataInicioMovto and @DataFimMovto
and a.CodigoProduto   is not null
and b.CodigoTipoOperacao  = 14 and a.TipoLancamentoMovimentacao = 11
and a.EntradaSaidaDocumento  = 'S'
group by a.CodigoEmpresa, a.CodigoLocal, a.CodigoProduto
update tbRazaoProdutos
set tbRazaoProdutos.QtdeRemPropSaidaCanc = a.QtdeRemPropSaidaCanc,
 tbRazaoProdutos.ValorRemPropSaidaCanc = a.ValorRemPropSaidaCanc
from #RemPropSaidaCanc a
where a.CodigoEmpresa   = tbRazaoProdutos.CodigoEmpresa
and a.CodigoLocal   = tbRazaoProdutos.CodigoLocal
and a.CodigoProduto   = tbRazaoProdutos.CodigoProduto

-- apurar saldo final
update tbRazaoProdutos
set QtdeSaldoApurado = QtdeSaldoAnterior + QtdeCompras + QtdeDevVendas - QtdeDevVendasCanc - QtdeVendas - QtdeDevCompras + QtdeDevComprasCanc + QtdeInvEntrada - QtdeInvSaida + QtdeNFCancelada + QtdeTransfEntrada - QtdeTransfEntradaCanc - QtdeTransfSaida + QtdeTransfSaidaCanc + QtdeRemPropEntrada - QtdeRemPropEntradaCanc - QtdeRemPropSaida + QtdeRemPropSaidaCanc,
 ValorSaldoApurado = ValSaldoAnterior + ValorCompras + ValorDevVendas - ValorDevVendasCanc - ValorVendas - ValorDevCompras + ValorDevComprasCanc + ValorInvEntrada - ValorInvSaida + ValorNFCancelada + ValorTransfEntrada - ValorTransfEntradaCanc - ValorTransfSaida + ValorTransfSaidaCanc + ValorRemPropEntrada - ValorRemPropEntradaCanc - ValorRemPropSaida + ValorRemPropSaidaCanc

--select * from tbRazaoProdutos where QtdeSaldoFinal != QtdeSaldoApurado
--select * from tbRazaoProdutos where ValorSaldoFinal != ValorSaldoApurado
drop table #Compras
drop table #DevVendas
drop table #DevVendasCanc
drop table #Vendas
drop table #DevCompras
drop table #DevComprasCanc
drop table #Canceladas
drop table #InvSaidas
drop table #InvEntradas
drop table #TransfEntrada
drop table #TransfSaida
drop table #TransfEntradaCanc
drop table #TransfSaidaCanc
drop table #RemPropEntrada
drop table #RemPropEntradaCanc
drop table #RemPropSaida
drop table #RemPropSaidaCanc
