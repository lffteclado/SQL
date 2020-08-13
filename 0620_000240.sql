

update tb_atendimento set numero_atendimento_automatico = (select (numeroAtendimentoAtual + 1) from tb_entidade_numero_automatico where fk_entidade = 11),
                          sql_update = ISNULL(sql_update,'')+'#0620-000240'
where numero_atendimento_automatico = '76483'
and ano_atendimento = 2020
and situacaoAtendimento = 0
and fk_entidade in (select id from tb_entidade where sigla = 'BIOCOOP')
and id = 26183705

go

update tb_entidade_numero_automatico set numeroAtendimentoAtual = (select (numeroAtendimentoAtual + 1) from tb_entidade_numero_automatico where fk_entidade = 11),
                                         sql_update = ISNULL(sql_update,'')+'#0620-000240'
where id = 25