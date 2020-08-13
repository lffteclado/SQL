select * from tb_atendimento
 where numero_atendimento_automatico = '76483'
  and ano_atendimento = 2020
  and fk_entidade in (select id from tb_entidade where sigla = 'BIOCOOP')

select * from tb_atendimento
 where numero_atendimento_automatico = '68574'
  and ano_atendimento = 2020
  and fk_entidade in (select id from tb_entidade where sigla = 'BIOCOOP')

  select numeroAtendimentoAtual, * from tb_entidade_numero_automatico where fk_entidade = 11