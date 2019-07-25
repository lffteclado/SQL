--update rl_cooperado_movimentacao set valor_movimentacao = 200.00, sql_update = ISNULL(sql_update,'')+'0719-000428' where id = 112853
--GO
--update rl_entidade_cooperado set valor_capital = 200.00, sql_update = ISNULL(sql_update,'')+'0719-000428' where id = 37391

select sigla, * from tb_entidade where sigla like '%UNICOOPER%' --43

select * from tb_cooperado where nome like '%Abel José Aguiar de Magalhães Júnior%' and numero_conselho = '51723' --934

select * from rl_entidade_cooperado where fk_entidade = 43 and fk_cooperado = 934

select * from rl_cooperado_movimentacao where fk_entidade_cooperado = 15198