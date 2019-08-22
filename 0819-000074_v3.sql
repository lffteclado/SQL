/*
* Relatório Valores repassados por especialidade
* Chamado 0819-000074
*/

/* Declaração de Variáveis */
DECLARE
    @DataInicial varchar(10),
	@DataFinal varchar(10),
    @IDCooperativa int



/* INFORME OS PARAMETROS */

select @DataInicial = '2018-01-01',
       @DataFinal = '2018-12-31',
	   @IDCooperativa = 63

select cooperado.nome as 'Nome',
       cooperado.numero_conselho as 'CRM',
	   especialidade.descricao as 'Especialidade',
	   case (count(conversao.id))
	   when 0 then 'NÃO' else 'SIM' end as 'Vinculado PJ',
       count(atendimento.id) as 'Número de Guias Faturadas',
       format(sum(repasseLancamento.valor_lancamento), 'C', 'pt-br') as 'Valor Repassado',
	   hospital.sigla as 'Local de Atendimento'
from rl_repasse_lancamento repasseLancamento
inner join tb_repasse repasse on (repasseLancamento.fk_repasse = repasse.id and repasse.registro_ativo = 1 and repasseLancamento.registro_ativo = 1)
inner join tb_pagamento_procedimento pagamentoProcedimento on (pagamentoProcedimento.id = repasseLancamento.fk_pagamento_procedimento and pagamentoProcedimento.registro_ativo = 1)
inner join tb_procedimento procedimento on (procedimento.id = pagamentoProcedimento.fk_procedimento and procedimento.registro_ativo = 1)
inner join tb_atendimento atendimento on (atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1)
inner join tb_cooperado cooperado on (cooperado.id = repasseLancamento.fk_cooperado_lancamento and cooperado.registro_ativo = 1)
inner join rl_entidade_cooperado entidadeCooperado on (entidadeCooperado.fk_cooperado = cooperado.id and entidadeCooperado.fk_entidade = atendimento.fk_entidade and entidadeCooperado.registro_ativo = 1)
inner join rl_entidadecooperado_especialidade entidadeEspecialidade on (entidadeEspecialidade.fk_entidade_cooperado = entidadeCooperado.id and entidadeEspecialidade.principal = 1 and entidadeEspecialidade.registro_ativo = 1)
inner join tb_tabela_tiss especialidade on (especialidade.id = entidadeEspecialidade.fk_especialidade and especialidade.registro_ativo = 1)
inner join tb_hospital hospital on (hospital.id = atendimento.fk_hospital and hospital.registro_ativo = 1)
left join rl_entidade_cooperado_conversao conversao on (conversao.fk_entidade = repasseLancamento.fk_entidade and cooperado.id = conversao.fk_cooperado_origem and conversao.registro_ativo = 1)
where repasseLancamento.fk_entidade = @IDCooperativa and CONVERT(DATE,repasse.data_criacao) between @DataInicial AND @DataFinal
group by cooperado.nome, cooperado.numero_conselho, especialidade.descricao, hospital.sigla, conversao.id
order by cooperado.nome