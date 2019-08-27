/*
* Relatório Valores Repasse nos últimos seis meses 
* Chamado 0819-000121
*/

/* Declaração de Variáveis */
DECLARE
    @DataInicial varchar(10),
	@DataFinal varchar(10),
    @IDCooperativa int



/* INFORME OS PARAMETROS */

select @DataInicial = '2019-08-01',
       @DataFinal = '2019-12-31',
	   @IDCooperativa = 43

select cooperado.nome as 'Nome',
       cooperado.numero_conselho as 'CRM',
	   case (count(conversao.id))
	   when 0 then 'NÃO' else 'SIM' end as 'Conversão Ativa',
	   isnull(cooperadoPJ.nome, '') as 'Nome do Cooperado PJ',
       format(sum(repasseLancamento.valor_lancamento), 'C', 'pt-br') as 'Valor repassado na PF',
	   isnull((select format(sum(valor_lancamento), 'C', 'pt-br') from rl_repasse_lancamento where fk_cooperado_lancamento = cooperadoPJ.id and fk_repasse = repasse.id and registro_ativo = 1), '') as 'Valor repassado na PJ',
	   sum(valorPJ.valor_honorario) as ' Valor repassado para cooperado na PJ',
	   repasse.numero_repasse as ' Numero do Repasse',
	   convert(varchar(10),repasse.data_criacao,103) as 'Data do Repasse'
from rl_repasse_lancamento repasseLancamento
inner join tb_repasse repasse on (repasseLancamento.fk_repasse = repasse.id and repasse.registro_ativo = 1 and repasseLancamento.registro_ativo = 1)
inner join tb_cooperado cooperado on (cooperado.id = repasseLancamento.fk_cooperado_lancamento and cooperado.registro_ativo = 1)
inner join rl_entidade_cooperado entidadeCooperado on (entidadeCooperado.fk_cooperado = cooperado.id and entidadeCooperado.fk_entidade = repasseLancamento.fk_entidade and entidadeCooperado.registro_ativo = 1)
left join rl_entidade_cooperado_conversao conversao on (conversao.fk_entidade = repasseLancamento.fk_entidade and cooperado.id = conversao.fk_cooperado_origem and conversao.registro_ativo = 1)
left join tb_cooperado cooperadoPJ on (conversao.fk_entidade = repasseLancamento.fk_entidade and cooperadoPJ.id = conversao.fk_cooperado_destino and conversao.registro_ativo = 1)
--inner join tb_pagamento_procedimento pagamentoProcedimento on (pagamentoProcedimento.id = repasseLancamento.fk_pagamento_procedimento and pagamentoProcedimento.registro_ativo = 1)
--inner join tb_procedimento procedimento on (procedimento.id = pagamentoProcedimento.fk_procedimento and procedimento.registro_ativo = 1 and cooperado.id = procedimento.fk_cooperado_executante_complemento and cooperadoPJ.id = procedimento.fk_cooperado_recebedor_cobranca)
cross apply (
	select (valor_honorario)
	from tb_procedimento procedimentoB
	where procedimentoB.fk_cooperado_recebedor_cobranca = cooperadoPJ.id and procedimentoB.registro_ativo = 1 
) as valorPJ
where repasseLancamento.fk_entidade = @IDCooperativa and CONVERT(DATE,repasse.data_criacao) between @DataInicial AND @DataFinal and entidadeCooperado.situacao_cooperado = 0
group by cooperado.nome, cooperado.numero_conselho, conversao.id, cooperadoPJ.nome, repasse.numero_repasse, repasse.data_criacao, cooperadoPJ.id, repasse.id
order by cooperado.nome