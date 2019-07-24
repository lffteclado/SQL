--Ajustar o valor de saldo da cooperada Ana Luiza Pimenta Brandão - CRM / 28124

update rl_cooperado_movimentacao
 set valor_movimentacao = 0.00, sql_update = ISNULL(sql_update,'')+'#0419-000008'
 where id = 22928