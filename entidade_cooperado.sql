--select * from sysobjects where name like '%movi%'

select nome, sigla, * from tb_entidade
 where sigla like 'COOPIMIMG' -- 2

select id, nome, * from tb_cooperado
 where nome like '%Ana Luiza Pimenta Brandão%' -- 23110

select fk_cooperado, fk_entidade, * from rl_entidade_cooperado
 where fk_entidade = 2 and fk_cooperado = 23110 -- 10045

select fk_entidade_cooperado, * from rl_cooperado_movimentacao
where fk_entidade_cooperado = (
select id from rl_entidade_cooperado where
fk_entidade = (select id from tb_entidade where sigla = ' COOPIMIMG')
and fk_cooperado =  (select id from tb_cooperado where nome = 'Ana Luiza Pimenta Brandão'))
--and id = 7862 and data_movimentacao = '2012-04-03 00:00:00.0000000' and matricula = 835