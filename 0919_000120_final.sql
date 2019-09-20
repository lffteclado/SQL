update rl_cooperado_movimentacao set registro_ativo = 0, sql_update=ISNULL(sql_update,'')+'0919-000120'
       where fk_entidade_cooperado = 33980

GO

update rl_entidade_cooperado set data_cadastro = '1997-02-26', sql_update = ISNULL(sql_update,'')+'0919-000120' where id = 33980

GO

insert into rl_cooperado_movimentacao (data_ultima_alteracao, registro_ativo, data_movimentacao, matricula, valor_movimentacao, fk_usuario_ultima_alteracao, fk_entidade_cooperado, fk_tipo_movimentacao, sql_update)
							   values ('2019-09-05 11:14:26.4260000', 1,  '1997-02-26 00:00:00.0000000', 298,0.00, 1, 33980, 1, '0919-000120')

GO

insert into rl_cooperado_movimentacao (pk_importacao, resolveu_dependencia, data_ultima_alteracao, registro_ativo, data_movimentacao, matricula, valor_movimentacao, fk_usuario_ultima_alteracao, fk_entidade_cooperado, fk_tipo_movimentacao, pk_importacao_fk_tipo_movimentacao,fk_entidade_fk_entidade_cooperado,fk_cooperado_fk_entidade_cooperado, sql_update)
							   values (279530, 1, '2019-02-22 00:00:00.0000000', 1,  '2017-12-28 00:00:00.0000000', 298,0.00, 1, 33980, 9, 5, 21,4342, '0919-000120')

GO

insert into rl_cooperado_movimentacao (data_ultima_alteracao, registro_ativo, data_movimentacao, matricula, valor_movimentacao, fk_usuario_ultima_alteracao, fk_entidade_cooperado, fk_tipo_movimentacao, sql_update)
							   values ('2019-07-23 13:51:00.5740000', 1,  '2019-03-01 00:00:00.0000000', 298,0.00, 10355, 33980, 2, '0919-000120')
