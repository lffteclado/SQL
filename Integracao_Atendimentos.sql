select * from tb_campos_integracao_hospitais_atendimentos where fk_entidade = (select id from tb_entidade where sigla like '%BIOCOOP%') -- 12 17

select * from tb_atendimento_integracao where numero_importacao = 50934


select data_entrega,  * from tb_atendimento where paciente like '%ABILIO DOS SANTOS%' and data_ultima_alteracao >= '2019-06-13 14:40:20.4000000'

select * from tb_convenio where id = 3707

select * from tb_campos_fixos_integracao