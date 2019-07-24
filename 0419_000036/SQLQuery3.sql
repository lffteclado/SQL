select sigla, nome, * from tb_cooperado where nome like 'Clínica Ginecológica e Obstétrica Dr. Nazy Ibrahim Ltda%' -- 23519

select nome, * from tb_entidade where sigla like '%GINECOOP%' --6

select * from rl_entidade_cooperado where fk_cooperado = 23519 and fk_entidade = 6 --3515

select * from rl_cooperado_movimentacao where fk_entidade_cooperado = 3515 --

--update rl_cooperado_movimentacao set valor_movimentacao = 50.00,fk_tipo_movimentacao = 8,  sql_update = ISNULL('',sql_update)+'#0419-000036' where id = 110017

--update rl_entidade_cooperado set situacao_cooperado = 2,valor_capital = 0.00, sql_update = ISNULL('', sql_update)+'#0419-000036' where id = 3515

select top 100 * from tb_tipo_movimentacao