select * from tbRazaoProdutos where QtdeSaldoFinal != QtdeSaldoApurado

select * from tbRazaoProdutos where QtdeSaldoAnterior != 0 and ValSaldoAnterior = 0

select * from tbRazaoProdutos where QtdeSaldoAnterior = 0 and ValSaldoAnterior != 0
-- update tbValorEstoquePeriodo set SaldoValorEstoque = 0 from tbRazaoProdutos r 
-- where r.CodigoEmpresa = tbValorEstoquePeriodo.CodigoEmpresa 
-- and r.CodigoLocal = tbValorEstoquePeriodo.CodigoLocal 
-- and r.CodigoProduto = tbValorEstoquePeriodo.CodigoProduto
-- and tbValorEstoquePeriodo.PeriodoValorEstoque = '200908'
-- and QtdeSaldoAnterior = 0 and ValSaldoAnterior != 0

select * from tbRazaoProdutos where ValorSaldoFinal != ValorSaldoApurado

select * from tbRazaoProdutos where abs(ValorSaldoFinal - ValorSaldoApurado) > 0.09

-- verifica produtos com saldo e sem custo
select * from tbRazaoProdutos where QtdeSaldoFinal != 0 and ValorSaldoFinal = 0

-- verifica produtos sem saldo e com custo
select * from tbRazaoProdutos where QtdeSaldoFinal = 0 and ValorSaldoFinal != 0

-- Recalcular os Custos das Saidas
whQGRevalorizaCustoEstoque 2620, 0, '201001', 1, 9999, '', 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'


-- Atualizar novo saldo em valores
update tbValorEstoquePeriodo
set SaldoValorEstoque = case when r.ValorSaldoApurado < 0
				then 0
				else r.ValorSaldoApurado
			end
from tbRazaoProdutos r
where r.CodigoEmpresa = tbValorEstoquePeriodo.CodigoEmpresa
and r.CodigoLocal = tbValorEstoquePeriodo.CodigoLocal
and r.CodigoProduto = tbValorEstoquePeriodo.CodigoProduto
and tbValorEstoquePeriodo.PeriodoValorEstoque = '201001'
and tbValorEstoquePeriodo.SaldoValorEstoque != r.ValorSaldoApurado
and abs(ValorSaldoFinal - ValorSaldoApurado) > 0.09
--and ValorSaldoFinal = 0


-- Zerar Saldos em Valores de Itens com Estoque Zero.
UPDATE	tbValorEstoquePeriodo
SET	SaldoValorEstoque = 0
FROM	vwSaldoGeralProdutoPeriodo saldo
WHERE	tbValorEstoquePeriodo.CodigoEmpresa		= saldo.CodigoEmpresa
AND	tbValorEstoquePeriodo.CodigoLocal		= saldo.CodigoLocal
AND	tbValorEstoquePeriodo.CodigoProduto		= saldo.CodigoProduto
AND	tbValorEstoquePeriodo.PeriodoValorEstoque	= saldo.Periodo
AND	tbValorEstoquePeriodo.CodigoEmpresa		= 2620
AND	tbValorEstoquePeriodo.PeriodoValorEstoque	= '201001'
AND	tbValorEstoquePeriodo.SaldoValorEstoque		!= 0
AND	saldo.EstoqueGeral				= 0

UPDATE	tbValorEstoquePeriodo
SET	SaldoValorEstoque				= 0
WHERE	CodigoEmpresa					= 2620
AND	PeriodoValorEstoque				= '201001'
AND	tbValorEstoquePeriodo.SaldoValorEstoque		!= 0
AND	NOT EXISTS (SELECT 1 FROM vwSaldoGeralProdutoPeriodo saldo
			WHERE	saldo.CodigoEmpresa	= tbValorEstoquePeriodo.CodigoEmpresa
			AND	saldo.CodigoLocal	= tbValorEstoquePeriodo.CodigoLocal
			AND	saldo.CodigoProduto	= tbValorEstoquePeriodo.CodigoProduto
			AND	saldo.Periodo		= tbValorEstoquePeriodo.PeriodoValorEstoque)

