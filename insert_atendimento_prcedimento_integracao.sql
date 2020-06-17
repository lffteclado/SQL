insert into tb_atendimento (fk_entidade, data_cadastro, data_entrega, guia_principal, matricula_paciente, paciente, senha,
                               fk_usuario_ultima_alteracao, data_ultima_alteracao, fk_importacao_unimed, fk_espelho, situacaoAtendimento,
                               valor_total_atendimento, fk_entidade_hospital, fk_hospital, fk_convenio, ano_atendimento, faturar,
                               autorizado_unimed, referencia_atendimento_unimed, registro_ativo, resolveu_dependencia )
                        select fk_entidade, data_cadastro, data_entrega, guia_principal, matricula_paciente, paciente, senha, 
                               fk_usuario_ultima_alteracao, data_ultima_alteracao, fk_importacao_unimed, fk_espelho, situacaoAtendimento, 
                               valor_total_atendimento, fk_entidade_hospital, fk_hospital,
                               case when fk_convenio is null  then (select id from rl_entidade_convenio where fk_convenio = 773 and fk_entidade = tb_atendimento_unimed.fk_entidade) else fk_convenio end as fk_convenio,
                               ano_atendimento, faturar, autorizado_unimed, id, 1, 0
                          from tb_atendimento_unimed with (nolock)
                         where fk_importacao_unimed = :idImportacaoUnimed




 insert into tb_procedimento (fk_atendimento, fk_acomodacao, data_inicio, data_fim, hora_inicio, data_realizacao, urgencia,
                fk_cooperado_recebedor_cobranca, fk_cooperado_executante_complemento, fk_grau_participacao, forma_execucao,
                fk_item_despesa, quantidade, forcar_atendimento, valor_honorario, valor_ch,
                valor_custo_operacional, valor_filme, valor_desconto, valor_acrescimo, valor_percentual, valor_total,
                faturar, registro_adequecao, fk_usuario_ultima_alteracao, data_ultima_alteracao, desconto_hospitalar, 
                autorizado_unimed, fk_procedimento_detalhar_unimed, referencia_procedimento_unimed, registro_ativo, resolveu_dependencia, fk_entidade_cooperado_especialidade)
         select atendimento.id, procUnimed.fk_acomodacao, procUnimed.data_inicio, procUnimed.data_fim, procUnimed.hora_inicio, procUnimed.data_realizacao, procUnimed.urgencia,
                procUnimed.fk_cooperado_recebedor_cobranca, procUnimed.fk_cooperado_executante_complemento, procUnimed.fk_grau_participacao, procUnimed.forma_execucao,
                procUnimed.fk_item_despesa, procUnimed.quantidade, procUnimed.forcar_atendimento, procUnimed.valor_honorario, 0,
                0, 0, 0, 0, 100, procUnimed.valor_honorario,
                procUnimed.faturar, procUnimed.registro_adequecao, procUnimed.fk_usuario_ultima_alteracao, procUnimed.data_ultima_alteracao, procUnimed.desconto_hospitalar,
                procUnimed.autorizado_unimed, procUnimed.fk_procedimento_detalhar_unimed, procUnimed.id, 1, 0, especialidade.id as especialidade
           from tb_procedimento_unimed procUnimed with (nolock)
          inner join tb_atendimento_unimed atendUnimed with (nolock) on (atendUnimed.id = procUnimed.fk_atendimento)
          inner join tb_atendimento atendimento with (nolock) on (atendimento.referencia_atendimento_unimed = atendUnimed.id and atendimento.fk_importacao_unimed = atendUnimed.fk_importacao_unimed)
          left join rl_entidade_cooperado entidadeCooperado with (nolock) on (procUnimed.fk_cooperado_executante_complemento = entidadeCooperado.fk_cooperado and entidadeCooperado.registro_ativo = 1 and atendUnimed.fk_entidade = entidadeCooperado.fk_entidade)
          left join rl_entidadecooperado_especialidade especialidade with (nolock) on (especialidade.fk_entidade_cooperado = entidadeCooperado.id and especialidade.registro_ativo = 1 and especialidade.principal = 1)
          where atendUnimed.fk_importacao_unimed = :idImportacaoUnimed