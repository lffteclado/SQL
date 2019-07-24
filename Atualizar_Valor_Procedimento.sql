update procedimento set
procedimento.valor_honorario = pagamento.valor_honorario,
procedimento.valor_acrescimo = pagamento.valor_acrescimo,
procedimento.valor_filme = pagamento.valor_filme,
procedimento.valor_custo_operacional = pagamento.valor_custo_operacional,
procedimento.valor_desconto = pagamento.valor_desconto,
procedimento.valor_total = pagamento.valor_honorario+pagamento.valor_acrescimo+pagamento.valor_filme+pagamento.valor_custo_operacional-pagamento.valor_desconto,
procedimento.sql_update = ISNULL(procedimento.sql_update,'')+'#0619-000382'
FROM tb_procedimento procedimento
	CROSS APPLY (
	select sum(pagProcedSelect.valor_honorario) as valor_honorario,
	sum(pagProcedSelect.valor_acrescimo) as valor_acrescimo, 
	sum(pagProcedSelect.valor_filme) as valor_filme,
	sum(pagProcedSelect.valor_custo_operacional) as valor_custo_operacional,
	sum(pagProcedSelect.valor_desconto) as valor_desconto
	FROM tb_pagamento_procedimento pagProcedSelect
	WHERE pagProcedSelect.fk_procedimento = procedimento.id
	AND pagProcedSelect.registro_ativo = 1
	) pagamento
	inner join tb_atendimento atendimento on (procedimento.fk_atendimento = atendimento.id and atendimento.registro_ativo = 1)
WHERE atendimento.numero_atendimento_automatico in (112868, 112872, 113435, 119305, 120881, 131110, 68081)
AND atendimento.fk_entidade = 46
AND atendimento.ano_atendimento = 2018
AND procedimento.registro_ativo = 1
AND procedimento.valor_total = 0

update procedimento set
procedimento.valor_honorario = pagamento.valor_honorario,
procedimento.valor_acrescimo = pagamento.valor_acrescimo,
procedimento.valor_filme = pagamento.valor_filme,
procedimento.valor_custo_operacional = pagamento.valor_custo_operacional,
procedimento.valor_desconto = pagamento.valor_desconto,
procedimento.valor_total = pagamento.valor_honorario+pagamento.valor_acrescimo+pagamento.valor_filme+pagamento.valor_custo_operacional-pagamento.valor_desconto,
procedimento.sql_update = ISNULL(procedimento.sql_update,'')+'#0619-000327'
FROM tb_procedimento procedimento
	CROSS APPLY (
	select TOP 1 pagProcedSelect.valor_honorario, pagProcedSelect.valor_acrescimo, pagProcedSelect.valor_filme, pagProcedSelect.valor_custo_operacional, pagProcedSelect.valor_desconto
	FROM tb_pagamento_procedimento pagProcedSelect
	WHERE pagProcedSelect.fk_procedimento = procedimento.id
	AND pagProcedSelect.registro_ativo = 1
	order by pagProcedSelect.id desc
	)pagamento
	inner join tb_atendimento atendimento on (procedimento.fk_atendimento = atendimento.id and atendimento.registro_ativo = 1)
WHERE atendimento.numero_atendimento_automatico in (?,?,?,?,?,?)
AND atendimento.fk_entidade = ?
AND atendimento.ano_atendimento = ?
AND procedimento.registro_ativo = 1
AND procedimento.valor_total = 0










