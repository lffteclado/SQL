select * from  tb_horario_trabalho where data_ultima_alteracao > '2019-08-01 15:19:26.6680000' and fk_entidade = 25

--update tb_horario_trabalho set fk_usuario = null where id = 102

select * from rl_usuario_horario_trabalho where fk_horario_trabalho = 110 and fk_usuario = 12554 --data_ultima_alteracao > '2019-08-01 17:55:47.0900000'

select * from rl_usuario_horario_trabalho where registro_ativo = 1 and fk_usuario = 12554 -- fk_horario_trabalho = 107

select * from tb_horario_trabalho where id = 110 and GETDATE() between inicio and fim and liberar_bloquear = 0

select * from rl_dias_semana_horario_trabalho where fk_horario_trabalho = 110 and dia_semana = 0 --12606


select * from rl_entidade_usuario where id in (null)

select * from tb_entidade where sigla like '%BELCOOP%'

select nome, * from tb_usuario where id = 11

select * from rl_usuario_horario_trabalho order by id desc

select * from tb_horario_trabalho where id = 97

select us.nome from rl_usuario_horario_trabalho ht
inner join rl_entidade_usuario eu on ht.fk_usuario = eu.id and eu.registro_ativo = 1
inner join tb_usuario us on us.id = eu.fk_usuario and us .registro_ativo = 1
where eu.fk_entidade = 2 and ht.registro_ativo = 1

--update rl_usuario_horario_trabalho set registro_ativo = 0
 where fk_usuario <> 12555 and data_ultima_alteracao > '2019-07-01 11:14:14.5630000' and fk_horario_trabalho = 102

select * from rl_entidade_usuario where fk_usuario = 10414

select nome, * from tb_usuario where id in (
select fk_usuario from rl_entidade_usuario where id in (
12555
,12556
,11319
))

select * from tb_usuario where nome like '%Luis%' -- 10414

select * from tb_usuario where id = 17

select * from tb_caso_de_uso where nome like '%Horario%'

select * from tb_modulo where id = 2