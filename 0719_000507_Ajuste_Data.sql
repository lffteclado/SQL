update rl_entidade_cooperado set data_cadastro = '2019-07-19', sql_update = ISNULL(sql_update,'')+'#0719-000507'
 where id = 38971 and data_cadastro = '2019-07-22'
GO
update rl_cooperado_movimentacao set data_movimentacao = '2019-07-19 00:00:00.0000000', sql_update = ISNULL(sql_update,'')+'#0719-000507'
 where id = 117017 and data_movimentacao = '2019-07-22 00:00:00.0000000' and fk_entidade_cooperado = 38971