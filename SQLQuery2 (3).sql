insert into tb_despesa
(
	discriminator,
	pk_importacao,
	resolveu_dependencia,
	data_ultima_alteracao,
	registro_ativo,
	numero_auxiliares,
	percentual_fator,
	quantidade_filme,
	valor_custo_operacional,
	valor_honorario,
	grupo,
	sub_grupo,
	data_final_vigencia,
	data_inicio_vigencia,
	situacao,
	ch_moeda,
	desconsiderar_apartamento,
	desconsiderar_enfermaria,
	desconsiderar_externo,
	desconsiderar_urgencia,
	valor_acrescimo_tabela,
	valor_porte_anestesia,
	fk_usuario_ultima_alteracao,
	fk_item_despesa,
	fk_entidade_convenio,
	fk_complemento,
	fk_especialidade,
	fk_edicao_tabela_honorarios,
	fk_item_fator,
	fk_item_porte_anestesia,
	fk_ch,
	fk_entidade_cooperado,
	fk_entidade_hospital,


	 


) 
      select  
      atendimentoReal.id as fk_atendimento, 
      procedimento.id as idProcedimento, 
      procedimento.fk_acomodacao, 
      procedimento.fk_entidade_cooperado_especialidade, 
      procedimento.fk_cooperado_executante_complemento, 
      procedimento.fk_cooperado_recebedor_cobranca, 
      case when ( 'gerarEspelho' ='"
        + gerarEspelho
        + "' and (procedimento.fk_cooperado_recebedor_cobranca=23893 or entidadeConvenio.marcar_atendimento_espelhado_faturar = 1)) then 1 else 0 end as faturar, 
      case atendimento.fk_entidade when 17 then null else procedimento.data_fim end, 
      case atendimento.fk_entidade when 17 then null else  procedimento.data_inicio end, 
      procedimento.data_realizacao, 
      getdate() as data_ultima_alteracao, 
      procedimento.desconto_hospitalar, 
      procedimento.fk_grau_participacao, 
      procedimento.forma_execucao, 
      ltrim(rtrim(procedimento.guia_procedimento)) as guia_procedimento, 
      procedimento.hora_fim, 
      procedimento.hora_inicio, 
      procedimento.quantidade, 
      procedimento.quantidade_ch, 
      procedimento.fk_procedimento_tuss, 
      1 as 'registro_ativo', 
      procedimento.tuss, 
      case when procedimento.data_realizacao is not null and entidadeConvenio.realizar_calculo_urgencia=1 and (DATEPART(DW,procedimento.data_realizacao))=1 then 1 
      when procedimento.data_realizacao is not null and entidadeConvenio.realizar_calculo_urgencia=1 and 
      (select top 1 entidadeFeriado.id from rl_entidade_feriado entidadeFeriado inner join tb_feriado feriado on(entidadeFeriado.fk_feriado=feriado.id and entidadeFeriado.registro_ativo=1 and feriado.registro_ativo=1) where entidadeFeriado.fk_entidade=atendimento.fk_entidade and CONVERT(DATE,procedimento.data_realizacao)=CONVERT(DATE,feriado.data_feriado)) is not null then 1 
      when procedimento.data_realizacao is not null and entidadeConvenio.realizar_calculo_urgencia=1 and procedimento.hora_inicio is not null and (DATEPART(DW,procedimento.data_realizacao))=7 and ((historicoConvenio.hora_trabalho_inicial_sabado is not null and  procedimento.hora_inicio<CONVERT(TIME,historicoConvenio.hora_trabalho_inicial_sabado)) or ((historicoConvenio.hora_trabalho_final_sabado is not null and  procedimento.hora_inicio>CONVERT(TIME,historicoConvenio.hora_trabalho_final_sabado)))) then 1 
      when procedimento.data_realizacao is not null and entidadeConvenio.realizar_calculo_urgencia=1 and procedimento.hora_inicio is not null  and (DATEPART(DW,procedimento.data_realizacao)) not in(1,7)  and ((historicoConvenio.hora_trabalho_inicial_segunda_a_sexta is not null and  procedimento.hora_inicio<CONVERT(TIME,historicoConvenio.hora_trabalho_inicial_segunda_a_sexta)) or ((historicoConvenio.hora_trabalho_final_segunda_a_sexta is not null and  procedimento.hora_inicio>CONVERT(TIME,historicoConvenio.hora_trabalho_final_segunda_a_sexta)))) then 1 
      else 0 end as urgencia, 
      procedimento.fk_via_acesso, 
      procedimento.forcar_atendimento, 
      procedimento.fk_tipo_guia, 
      case when procedimento.forcar_atendimento=1 or 'gerarEspelho' = '"
        + gerarEspelho
        + "' or procedimento.valor_honorario>0 then coalesce(procedimento.valor_honorario,0) else 0 end as valor_honorario, 
      case when procedimento.forcar_atendimento=1 or 'gerarEspelho' = '"
        + gerarEspelho
        + "' or procedimento.valor_honorario>0  then coalesce(procedimento.valor_total + procedimento.valor_honorario,0) else 0 end as valor_total, 
      0 as resolveu_dependencia, 
      item.id_item_despesa, 
      procedimento.valor_percentual, 
      procedimento.quantidade_porte, 
      procedimento.valor_acrescimo, 
      procedimento.valor_ch, 
      procedimento.valor_custo_operacional, 
      procedimento.valor_desconto, 
      procedimento.valor_filme, 
      1 as 'autorizado_unimed', 
      0 as percentual_desconto_hospitalar, 
      0 as registro_adequacao, 
      0 as valor_acrescimo_convenio,");
    hql.append(entidadeUsuario.getUsuario().getId()).append(" as idUsuario, 
      case atendimento.fk_entidade when 17 then 110587 else null end as tecnica 
      from tb_procedimento_integracao  procedimento 
      inner join tb_atendimento_integracao atendimento on(atendimento.id=procedimento.fk_atendimento) 
    --   CROSS APPLY (select top 1 * from tb_ids_temporarios where
    -- atendimento.id=id_temporario and data_processamento=:dataProcessamento)
    -- AS TEMP 
      inner join tb_item_despesa_integracao item on(item.id=procedimento.fk_item_despesa )  
      inner join rl_entidade_convenio entidadeConvenio  
      on(entidadeConvenio.id = atendimento.fk_convenio and entidadeConvenio.registro_ativo=1) 
      inner join tb_convenio convenio  
      on(convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo=1) 
      left join tb_atendimento atendimentoReal on(atendimento.id=atendimentoReal.referencia_atendimento_integracao )  
      OUTER APPLY (select  top 1 historico.* 
      from rl_entidadeconvenio_historico_tabela_honorario historico 
      where historico.fk_entidade_convenio=entidadeConvenio.id 
      and historico.registro_ativo=1 
      and (historico.fk_entidade_convenio_complemento=atendimento.fk_complemento or historico.fk_entidade_convenio_complemento is null) 
      and (( procedimento.data_realizacao between historico.data_inicio_vigencia and historico.data_final_vigencia ) or ( procedimento.data_realizacao >= historico.data_inicio_vigencia and historico.data_final_vigencia is null )) 
      order by historico.fk_entidade_convenio_complemento desc 
      )  as historicoConvenio 
      where not exists(select id from tb_procedimento_integracao where fk_atendimento=atendimento.id and (item_despesa_inconsitente is not null or fk_item_despesa is null)) 
      and exists(select id from tb_procedimento_integracao where fk_atendimento=atendimento.id) 
      and exists(select id from tb_ids_temporarios where atendimento.id=id_temporario and data_processamento=:dataProcessamento) 