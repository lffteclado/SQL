select cooperado.nome,
	   cooperado.id,
	   especialidade.descricao as 'Especialidade',
       count(atendimento.id) as 'Numero Guias Faturadas',
	   sum(pagamentoProcedimento.valor_honorario + pagamentoProcedimento.valor_custo_operacional + pagamentoProcedimento.valor_acrescimo + pagamentoProcedimento.valor_filme - pagamentoProcedimento.valor_desconto) as 'Valor Procedimentos',
	   sum(repasseLancamento.valor_lancamento) as 'Valor Repassado',
	   hospital.sigla as 'Hospital'
 from tb_fatura fatura
inner join tb_pagamento_procedimento pagamentoProcedimento on (fatura.id = pagamentoProcedimento.fk_fatura and pagamentoProcedimento.registro_ativo = 1 and fatura.registro_ativo = 1 and pagamentoProcedimento.fk_fatura is not null)
inner join tb_procedimento procedimento on (pagamentoProcedimento.fk_procedimento = procedimento.id and procedimento.registro_ativo = 1)
inner join tb_atendimento atendimento on (atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1)
inner join tb_cooperado cooperado on (procedimento.fk_cooperado_executante_complemento = cooperado.id)
inner join rl_entidade_cooperado entidadeCooperado on (entidadeCooperado.fk_cooperado = cooperado.id and entidadeCooperado.fk_entidade = atendimento.fk_entidade and entidadeCooperado.registro_ativo = 1)
inner join rl_entidadecooperado_especialidade entidadeEspecialidade on (entidadeEspecialidade.fk_entidade_cooperado = entidadeCooperado.id and entidadeEspecialidade.principal = 1 and entidadeEspecialidade.registro_ativo = 1)
inner join tb_tabela_tiss especialidade on (especialidade.id = entidadeEspecialidade.fk_especialidade and especialidade.registro_ativo = 1)
inner join tb_hospital hospital on (hospital.id = atendimento.fk_hospital and hospital.registro_ativo = 1)
inner join tb_pagamento_fatura pagamentoFatura on (pagamentoFatura.fk_fatura = fatura.id and pagamentoFatura.registro_ativo = 1)
inner join rl_repasse_lancamento repasseLancamento on (repasseLancamento.fk_pagamento_fatura = pagamentoFatura.id and repasseLancamento.registro_ativo = 1)
inner join .tb_repasse repasse on (repasse.id = repasseLancamento.fk_repasse and repasse.registro_ativo = 1)
where atendimento.fk_entidade = 63 and CONVERT(DATE,repasse.data_criacao) between '2019-01-01' AND '2019-01-20' and repasseLancamento.fk_cooperado_lancamento = 27491
group by cooperado.nome, hospital.sigla, especialidade.descricao, cooperado.id

/*
rl_entidade_cooperado entidadeCooperado on (atendimento.fk_entidade = entidadeCooperado.fk_entidade and entidadeCooperado.fk_cooperado = cooperado.id and entidadeCooperado.registro_ativo = 1 and entidadeCooperado.situacao_cooperado = 0)
rl_entidadecooperado_especialidade cooperadoEspecialidade on (cooperadoEspecialidade.fk_entidade_cooperado = entidadeCooperado.id and cooperadoEspecialidade.registro_ativo = 1 and cooperadoEspecialidade.principal = 1)
tb_tabela_tiss especialidade on (especialidade.id = cooperadoEspecialidade.fk_especialidade)*/
