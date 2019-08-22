select * from tb_atendimento where numero_atendimento_automatico = 71433 and fk_entidade = 2

select * from tb_convenio where id =  270

select * from rl_entidade_convenio where id = 886

select top 10 fk_tipo_guia, * from tb_procedimento where fk_tipo_guia is not null and registro_ativo = 1

select * from sysobjects where name like '%tipo_guia%'

select * from tb_tabela_tiss_tipo_guia_temp where id = 110680

 168294

select * from tb_item_despesa where codigo = 01010760 

and atendimento.numero_atendimento_automatico = 71567

select top 10 * from tb_despesa where discriminator = 'EntidadeConvenioEspecialidade' and registro_ativo = 1 and fk_entidade_convenio = 4336

select top 10 * from rl_entidade_grau_participacao

select * from tb_cooperado where id = 22171
select * from rl_entidade_cooperado where id = 22171
select * from rl_entidade_coop