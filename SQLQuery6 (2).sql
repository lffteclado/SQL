select top 1 * from tb_glosa where fk

select nome, sigla, * from tb_entidade
 where sigla like '%RAJA%' -- 13

select fk_convenio, fk_entidade, * from rl_entidade_convenio
 where fk_convenio = 498 and fk_entidade = 13

select sigla, * from tb_convenio
 where sigla = 'BRADESCO S' -- 498