update procedimento set
procedimento.valor_honorario = (pagamentoRateio.valor_honorario),
procedimento.valor_acrescimo = (pagamentoRateio.valor_acrescimo),
procedimento.valor_filme = (pagamentoRateio.valor_filme),
procedimento.valor_custo_operacional = (pagamentoRateio.valor_custo_operacional),
procedimento.valor_desconto = (pagamentoRateio.valor_desconto),
procedimento.valor_total = (pagamentoRateio.valor_honorario)
                           + (pagamentoRateio.valor_acrescimo)
						   + (pagamentoRateio.valor_filme)
						   + (pagamentoRateio.valor_custo_operacional)
						   - (pagamentoRateio.valor_desconto),
procedimento.sql_update = ISNULL(procedimento.sql_update,'')+'#0619-000426'
FROM tb_procedimento procedimento
	CROSS APPLY (
	select (procedSelect.valor_honorario) as valor_honorario,
	(procedSelect.valor_acrescimo) as valor_acrescimo, 
	(procedSelect.valor_filme) as valor_filme,
	(procedSelect.valor_custo_operacional) as valor_custo_operacional,
	(procedSelect.valor_desconto) as valor_desconto
	FROM tb_procedimentoBKP28062019 procedSelect
	WHERE procedSelect.id = procedimento.id
	AND procedSelect.registro_ativo = 1
	) pagamentoRateio
inner join tb_atendimento atendimento on (procedimento.fk_atendimento = atendimento.id and atendimento.registro_ativo = 1)
WHERE atendimento.numero_atendimento_automatico in (
	select numero_atendimento_automatico from tb_atendimento
	where fk_espelho = 558443 and fk_entidade = 43 and registro_ativo = 1)
AND atendimento.fk_entidade = 43
AND atendimento.ano_atendimento = 2019
AND procedimento.registro_ativo = 1
AND procedimento.referencia_procedimento_rateio is null
AND procedimento.valor_honorario is null