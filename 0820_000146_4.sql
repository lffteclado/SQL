select procedimento.id,
			coalesce(glosas.valor_honorario,CONVERT(NUMERIC(19,2),0.00)) as valor_honorario,
			coalesce(glosas.valor_acrescimo,CONVERT(NUMERIC(19,2),0.00)) as valor_acrescimo,
			coalesce(glosas.valor_custo_operacional,CONVERT(NUMERIC(19,2),0.00)) as valor_custo_operacional,
			coalesce(glosas.valor_filme,CONVERT(NUMERIC(19,2),0.00)) as valor_filme,
			coalesce(glosas.valor_desconto,CONVERT(NUMERIC(19,2),0.00))  as valor_desconto,

			coalesce(espelho.valor_honorario,CONVERT(NUMERIC(19,2),0.00)) as valor_honorario_espelho,
			coalesce(espelho.valor_acrescimo,CONVERT(NUMERIC(19,2),0.00)) as valor_acrescimo_espelho,
			coalesce(espelho.valor_custo_operacional,CONVERT(NUMERIC(19,2),0.00)) as valor_custo_operacional_espelho,
			coalesce(espelho.valor_filme,CONVERT(NUMERIC(19,2),0.00)) as valor_filme_espelho,
			coalesce(espelho.valor_desconto,CONVERT(NUMERIC(19,2),0.00))  as valor_desconto_espelho,

			entidadeCooperadoConversao.id
	from tb_procedimento 
	procedimento inner join tb_atendimento
	atendimento on(procedimento.fk_atendimento=atendimento.id and procedimento.registro_ativo=1 and atendimento.registro_ativo=1)
	inner join rl_entidade_cooperado_conversao entidadeCooperadoConversao on( atendimento.fk_entidade=entidadeCooperadoConversao.fk_entidade and entidadeCooperadoConversao.registro_ativo=1
		and procedimento.fk_cooperado_recebedor_cobranca=entidadeCooperadoConversao.fk_cooperado_destino and procedimento.fk_cooperado_recebedor_cobranca_anterior=entidadeCooperadoConversao.fk_cooperado_origem
		and ((procedimento.data_realizacao between entidadeCooperadoConversao.data_inicial and entidadeCooperadoConversao.data_final) or (entidadeCooperadoConversao.data_inicial<=procedimento.data_realizacao /*and entidadeCooperadoConversao.data_final is null*/)))


	CROSS apply(
		select 
			sum(coalesce(valor_honorario,0)) as valor_honorario,
			sum(coalesce(valor_acrescimo,0)) as valor_acrescimo,
			sum(coalesce(valor_custo_operacional,0)) as valor_custo_operacional,
			sum(coalesce(valor_filme,0)) as valor_filme,
			sum(coalesce(valor_desconto,0))  as valor_desconto
			from tb_glosa 
		where fk_procedimento=procedimento.id and registro_ativo=1 and situacao IN (0,1,2,3,7)
		and (coalesce(valor_honorario,0)+
			coalesce(valor_acrescimo,0)+
			coalesce(valor_custo_operacional,0)+
			coalesce(valor_filme,0)-
			coalesce(valor_desconto,0))>0
			group by fk_procedimento
	) as glosas
	OUTER apply(
		select sum(coalesce(valor_honorario,0)) as valor_honorario,
			sum(coalesce(valor_acrescimo,0)) as valor_acrescimo,
			sum(coalesce(valor_custo_operacional,0)) as valor_custo_operacional,
			sum(coalesce(valor_filme,0)) as valor_filme,
			sum(coalesce(valor_desconto,0))  as valor_desconto
			from tb_pagamento_procedimento 
		where fk_procedimento=procedimento.id and registro_ativo=1  and fk_fatura is null
		and (coalesce(valor_honorario,0)+
			coalesce(valor_acrescimo,0)+
			coalesce(valor_custo_operacional,0)+
			coalesce(valor_filme,0)-
			coalesce(valor_desconto,0))>0
			group by fk_procedimento
	) as espelho
	where entidadeCooperadoConversao.id=5982
	and exists(select id from tb_pagamento_procedimento where fk_fatura is not null and registro_ativo=1 and (coalesce(valor_honorario,0)+
			coalesce(valor_acrescimo,0)+
			coalesce(valor_custo_operacional,0)+
			coalesce(valor_filme,0)-
			coalesce(valor_desconto,0))>0 )