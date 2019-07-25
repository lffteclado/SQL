select valorRepassados, valorFaturados, valor_total_atendimento,
 * from tb_atendimento
 where numero_atendimento_automatico in (
112868,
112872,
113435,
119305,
120881,
131110,
68081
) and fk_entidade = 46 -- 13888099 13987394 14218422 13888104 14037149 13899004

select valor_total, fk_atendimento, * from tb_procedimento
 where fk_atendimento in (13888104) and registro_ativo = 1 -- 20197609 20197610 20197611

select (valor_honorario + valor_acrescimo) as 'Valor Total', fk_fatura, * from tb_pagamento_procedimento
 where fk_procedimento in (24985963) and registro_ativo = 1 --and id in (47233178, 47233145, 47233271)

select * from tb_entidade where sigla like '%GINECOOP%' -- SANTACOOPMACEIO 46 / GINECOOP 6

select * from tb_fatura where id in (75177)



/**
112868
112872
113435
119305
120881
131110
68081

23697 Ginecoop



*/

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
	select sum(pagProcedSelect.valor_honorario) as valor_honorario , sum(pagProcedSelect.valor_acrescimo) as valor_acrescimo, 
	sum(pagProcedSelect.valor_filme) as valor_filme, sum(pagProcedSelect.valor_custo_operacional) as valor_custo_operacional, sum(pagProcedSelect.valor_desconto) as valor_desconto
	FROM tb_pagamento_procedimento pagProcedSelect
	WHERE pagProcedSelect.fk_procedimento = procedimento.id
	AND pagProcedSelect.registro_ativo = 1
	) pagamento
	inner join tb_atendimento atendimento on (procedimento.fk_atendimento = atendimento.id and atendimento.registro_ativo = 1)
WHERE atendimento.numero_atendimento_automatico in (112868)
AND atendimento.fk_entidade = 46
AND atendimento.ano_atendimento = ?
AND procedimento.registro_ativo = 1
AND procedimento.valor_total = 0



 	
	
	
