select nome, sigla, * from tb_entidade
 where sigla like '%RAJA%' -- 13

select id, nome, * from tb_cooperado
 where nome like '%Jorge Antônio de Menezes%' -- 2820

select fk_cooperado, fk_entidade, valor_capital, sql_update, * from rl_entidade_cooperado
 where fk_entidade = 6 and fk_cooperado = 2820 -- 3610
GO
select fk_entidade_cooperado, valor_movimentacao, * from rl_cooperado_movimentacao
 where fk_entidade_cooperado = 3610 and data_movimentacao = '2012-04-03 00:00:00.0000000'

select codigo_resposta, codigo_resposta_consulta, * from tb_controle_esocial_processamento
where codigo_resposta_servico = '1.1.201902.0000000000322635549' and codigo_resposta_consulta like ('2,3,4,5,6,7')
