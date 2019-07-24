--Correcao Acertar Movimento Valor Capital e Saldo #0419-000035

update rl_cooperado_movimentacao
 set valor_movimentacao = 300.00, sql_update = ISNULL(sql_update,'')+'#0419-000035'
  where id = 7862

GO

update rl_entidade_cooperado
 set valor_capital = 300.00, sql_update = ISNULL(sql_update,'')+'#0419-000035'
  where id = 3610