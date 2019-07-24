select sigla, nome, * from tb_cooperado where nome like 'IMCCORE-Instituto Mineiro%' -- 5220

select * from tb_entidade where sigla like '%GINECOOP%' --6

select * from rl_entidade_cooperado where fk_cooperado = 5220 and fk_entidade = 6 --3046

select * from rl_cooperado_movimentacao where fk_entidade_cooperado = 3046 --109981

--update rl_cooperado_movimentacao set registro_ativo = 0, sql_update = ISNULL('',sql_update)+'#0419-000036' where id = 109981

select top 100 * from tb_tipo_movimentacao