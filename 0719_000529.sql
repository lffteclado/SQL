update tb_procedimento set fk_item_despesa = 43741, sql_update = ISNULL(sql_update, '')+'#0719-000529' where id in (
select procedimento.id
from tb_procedimento procedimento
inner join tb_atendimento atendimento on procedimento.fk_atendimento = atendimento.id and procedimento.registro_ativo=1 and atendimento.registro_ativo = 1
inner join tb_espelho espelho on atendimento.fk_espelho = espelho.id and espelho.registro_ativo = 1 and atendimento.registro_ativo = 1
inner join tb_item_despesa despesa on procedimento.fk_item_despesa = despesa.id and despesa.registro_ativo = 1
inner join rl_entidadecooperado_especialidade especialidade on especialidade.id = procedimento.fk_entidade_cooperado_especialidade and especialidade.registro_ativo = 1
inner join tb_tabela_tiss tiss on especialidade.fk_especialidade = tiss.id and tiss.registro_ativo = 1
 where atendimento.fk_entidade = 25 and atendimento.fk_espelho = 625382 and tiss.descricao in ('Médico pediatra', 'Cardiologia Pediátrica', 'Neurologia Pediátrica')
)