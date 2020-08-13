select distinct atendimento.id, atendimento.ano_atendimento,atendimento.numero_atendimento_automatico, itemDespesa.codigo from tb_atendimento atendimento     
    inner join rl_entidade_convenio entidadeConvenio on (atendimento.fk_convenio = entidadeConvenio.id and entidadeConvenio.registro_ativo = 1)    
    inner join tb_procedimento procedimento on (atendimento.id = procedimento.fk_atendimento and procedimento.registro_ativo = 1)     
    inner join tb_item_despesa itemDespesa on (itemDespesa.id = procedimento.fk_item_despesa)    
    left join tb_dados_complementares dadosComplementares on (dadosComplementares.fk_atendimento = atendimento.id and dadosComplementares.registro_ativo = 1 )     
    left join TB_INTEGRACAO_UNIMED integracaoUnimed on (atendimento.fk_integracao_unimed = integracaoUnimed.id and integracaoUnimed.registro_ativo = 1)     
    inner join tb_tabela_tiss acomodacao on (acomodacao.id = procedimento.fk_acomodacao)     
    inner join rl_entidade_acomodacao entidadeAcomodacao on (acomodacao.id = entidadeAcomodacao.fk_acomodacao and entidadeAcomodacao.registro_ativo = 1)     
    inner join tb_cooperado coo on (coo.id = procedimento.fk_cooperado_executante_complemento)     
    left join rl_atendimento_inconsistencia inconsistencia on (atendimento.id = inconsistencia.fk_atendimento and inconsistencia.registro_ativo = 1)    
    left join rl_atendimento_tipo_pendencia pendencia on (atendimento.id = pendencia.fk_atendimento and pendencia.registro_ativo = 1)    
    where inconsistencia.id is null and pendencia.id is null 
    and atendimento.registro_ativo = 1
    and atendimento.fk_espelho is null     
    and atendimento.situacaoAtendimento = 0
    and entidadeAcomodacao.fk_entidade = 43
    and entidadeConvenio.fk_entidade = 43    
    and (procedimento.valor_honorario > 0  or  procedimento.valor_custo_operacional > 0  or procedimento.valor_filme > 0 or procedimento.valor_desconto > 0 or procedimento.valor_acrescimo > 0 ) 
	and itemDespesa.codigo in ('10101012')