--select top 1 * from rl_entidade_cooperado

select nome, sigla, * from tb_entidade
 where sigla like 'COOPIMIMG' -- 2

select id, nome, * from tb_cooperado
 where nome like '%Ana Luiza Pimenta Brandão%' -- 23110

select fk_cooperado, fk_entidade, * from rl_entidade_cooperado
 where fk_entidade = 2 and fk_cooperado = 23110 -- 10045

select fk_entidade_cooperado, * from rl_cooperado_movimentacao
 where fk_entidade_cooperado = 10045 and data_movimentacao = '2001-07-25 00:00:00.0000000'
 /*
--update rl_cooperado_movimentacao
 set valor_movimentacao = 0.00, sql_update = ISNULL(sql_update,'')+'#0419-000008'
 where id = 22928 

select valor_capital, fk_cooperado, fk_entidade, * from rl_entidade_cooperado
 where fk_entidade = 2 and fk_cooperado = 23110