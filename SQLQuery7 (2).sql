select * from tb_entidade where sigla = 'COOPERCON'

select * from sysobjects where name like '%repasse%'

select * from tb_repasse where numero_repasse in (3975) and fk_entidade = 10

select * from rl_repasse_credito where fk_repasse in (select id from tb_repasse where fk_entidade = 10 and numero_repasse = 3966)

select * from rl_repasse_credito where fk_repasse = 17720 -- 45547 Coop 22302

select * from rl_entidade_grupo_cooperado_vincular_cooperado

select * from rl_entidade_cooperado_dados_bancarios where id = 45547 -- 46379

select * from tb_banco where id = 33

select fk_entidade, fk_cooperado, * from rl_entidade_cooperado where id = 46379

select top 10 * from rl_entidade_cooperado_dados_bancarios order by id desc

select * from tb_cooperado where id = 22302