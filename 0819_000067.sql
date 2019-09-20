select validar_cooperados_honorarios_parados, * from tb_entidade where sigla like '%GINECOOP%'

select * from tb_cooperado where nome like '%Adilson Quintela Soares%' --9233

select * from tb_entidade where sigla like '%GINECOOP%' --6

select * from rl_entidade_cooperado where fk_entidade = 6 and fk_cooperado = 9233 -- 3215

select top 10 * from tb_procedimento where fk_cooperado_executante_complemento = 9233 order by id desc

select * from tb_atendimento where id = 19069598

select * from tb_glosa 