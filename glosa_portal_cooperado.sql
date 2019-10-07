select atendimento.numero_atendimento_automatico, convenio.sigla Convenio,
     (glosa.valor_acrescimo + glosa.valor_custo_operacional + 
     glosa.valor_filme + glosa.valor_honorario - glosa.valor_desconto) ValGlo, 
     (procedimento.valor_acrescimo + procedimento.valor_custo_operacional 
     + procedimento.valor_filme + procedimento.valor_honorario + procedimento.valor_acrescimo_convenio -
     procedimento.valor_desconto) ValCob,
     glosa.data_glosa, glosa.situacao, glosa.quantidadeCobrado, procedimento.data_realizacao,
     item.codigo, item.descricao, 
     atendimento.paciente, glosa.quantidadeGlosado, motivo.descricao DesMotGloGer, glosa.observacao 
     from tb_glosa glosa 
     left join tb_tabela_tiss motivo on (motivo.id = glosa.fk_motivo_glosa and motivo.registro_ativo = 1) 
     join tb_procedimento procedimento on glosa.fk_procedimento = procedimento.id and procedimento.registro_ativo = 1 
     join tb_atendimento atendimento on procedimento.fk_atendimento = atendimento.id and atendimento.registro_ativo = 1 
     join tb_cooperado cooperado on cooperado.id = procedimento.fk_cooperado_recebedor_cobranca and cooperado.registro_ativo = 1 
     join tb_item_despesa item on item.id = procedimento.fk_item_despesa and item.registro_ativo = 1 
     join rl_entidade_convenio entConvenio on (entConvenio.id = atendimento.fk_convenio and entConvenio.registro_ativo = 1) 
     join tb_convenio convenio on (convenio.id = entConvenio.fk_convenio and convenio.registro_ativo = 1) 
     where (procedimento.fk_cooperado_recebedor_cobranca = 18443 or procedimento.fk_cooperado_executante_complemento = 18443)
     and glosa.data_glosa between '2019-07-30' and '2019-08-01'
     and glosa.registro_ativo = 1 and glosa.situacao in (0,1,2,3,7) 
     and entConvenio.fk_entidade = 63
     and glosa.autorizado_unimed = 1
     and procedimento.autorizado_unimed = 1
     and atendimento.autorizado_unimed = 1
     order by convenio.sigla, glosa.data_glosa, atendimento.paciente