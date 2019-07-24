select sigla, nome, * from tb_cooperado where nome like 'SMH   Serviços Médicos Hospitalares S/C LTDA' -- 10782

select * from tb_entidade where sigla like '%GINECOOP%' --6

select * from rl_entidade_cooperado where fk_cooperado = 10782 and fk_entidade = 6 --3326

select * from rl_cooperado_movimentacao where fk_entidade_cooperado = 3326  --109985

--update rl_cooperado_movimentacao set valor_movimentacao = 50.00, sql_update = ISNULL('',sql_update)+'#0419-000036' where id = 109985

--update rl_entidade_cooperado set valor_capital = 0.00, sql_update = ISNULL('', sql_update)+'#0419-000036' where id = 3326

select top 100 * from tb_tipo_movimentacao