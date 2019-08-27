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

select cooperadoOrigem.nome as 'Nome',
       cooperadoOrigem.numero_conselho as 'CRM',
	   case (count(conversao.id))
	   when 0 then 'NÃO' else 'SIM' end as 'Conversão Ativa',
	   case when cooperadoDestino.id=cooperadoOrigem.id then '' else cooperadoDestino.nome end as 'Nome do Cooperado Destino',
	   format(sum(case when cooperadoDestino.id=cooperadoOrigem.id then 0.0 else isnull(pagamentoProcedimento.valor_honorario,0)+isnull(pagamentoProcedimento.valor_filme,0)+isnull(pagamentoProcedimento.valor_custo_operacional,0)-isnull(pagamentoProcedimento.valor_desconto,0)end), 'C', 'pt-br') as 'Valor repassado Cooperado Destino',
	   repasse.numero_repasse as ' Numero do Repasse',
	   repasse.id as idRepasse,
	   cooperadoOrigem.id as idCooperadoOrigem,
	   cooperadoDestino.id as idCooperadoDestino,
	   convert(varchar(10),repasse.data_criacao,103) as 'Data do Repasse'
	   into #temp
from  tb_repasse repasse
cross apply(select fk_pagamento_procedimento 
	from rl_repasse_lancamento 
	where registro_ativo=1 
	and fk_repasse=repasse.id
	group by fk_pagamento_procedimento) as repasseLancamento
inner join tb_pagamento_procedimento pagamentoProcedimento with(nolock) on(pagamentoProcedimento.id=repasseLancamento.fk_pagamento_procedimento and pagamentoProcedimento.registro_ativo=1)
inner join tb_procedimento procedimento with(nolock) on (procedimento.id = pagamentoProcedimento.fk_procedimento and procedimento.registro_ativo = 1)
--inner join tb_atendimento atendimento on(atendimento.id=procedimento.fk_atendimento and atendimento.registro_ativo=1 and atendimento.numero_atendimento_automatico=336369)
inner join tb_cooperado cooperadoDestino with(nolock) on (cooperadoDestino.id = procedimento.fk_cooperado_recebedor_cobranca and cooperadoDestino.registro_ativo=1)
inner join tb_cooperado cooperadoOrigem with(nolock) on (cooperadoOrigem.id = procedimento.fk_cooperado_executante_complemento)
inner join rl_entidade_cooperado entidadeCooperado with(nolock) on (entidadeCooperado.fk_cooperado = cooperadoOrigem.id and entidadeCooperado.fk_entidade=repasse.fk_entidade and entidadeCooperado.registro_ativo = 1)
left join rl_entidade_cooperado_conversao conversao with(nolock) on (conversao.fk_entidade = repasse.fk_entidade and cooperadoOrigem.id = conversao.fk_cooperado_origem and conversao.registro_ativo = 1)

where repasse.fk_entidade = @IDCooperativa and CONVERT(DATE,repasse.data_criacao) between @DataInicial AND @DataFinal and entidadeCooperado.situacao_cooperado = 0
group by cooperadoOrigem.nome, cooperadoOrigem.numero_conselho, conversao.id, cooperadoDestino.nome , repasse.numero_repasse, repasse.data_criacao, cooperadoDestino.id, cooperadoOrigem.id, repasse.id
order by cooperadoOrigem.nome

select distinct
	   temp.Nome,
       temp.CRM,
	   temp.[Conversão Ativa],
	   temp.[Nome do Cooperado Destino],
	   isnull(format(valorCooperadoOrigem.valor,'C', 'pt-br'),'') as 'Valor repassado Cooperado Origem',
       temp.[Valor repassado Cooperado Destino],
	   temp.[ Numero do Repasse],
	   --temp.idRepasse,
	   --temp.idCooperadoOrigem,
	   --temp.idCooperadoDestino,
	   temp.[Data do Repasse]
	   into #tmp
	   from #temp temp	   
outer apply (
select sum(isnull(pag.valor_honorario,0)+isnull(pag.valor_filme,0)+isnull(pag.valor_custo_operacional,0)-isnull(pag.valor_desconto,0)) as valor,fk_repasse,proced.fk_cooperado_executante_complemento
from rl_repasse_lancamento repasseLancamentoB 
inner join tb_pagamento_procedimento pag on( pag.registro_ativo=1 and pag.id=repasseLancamentoB.fk_pagamento_procedimento)
inner join tb_procedimento proced on(pag.registro_ativo=1 and proced.registro_ativo=1 and pag.fk_procedimento=proced.id)
where proced.fk_cooperado_executante_complemento=temp.idCooperadoOrigem and proced.fk_cooperado_recebedor_cobranca=temp.idCooperadoOrigem
and fk_repasse=temp.idRepasse
group by proced.fk_cooperado_executante_complemento,repasseLancamentoB.fk_repasse
)  valorCooperadoOrigem
	   order by nome

delete from #tmp where [Conversão Ativa] = 'SIM' and [Nome do Cooperado Destino] = '' and [Valor repassado Cooperado Destino] = 'R$ 0,00'

select distinct * from #tmp order by Nome

drop table #temp

drop table #tmp




