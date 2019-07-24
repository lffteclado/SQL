select nome, sigla, * from tb_cooperado
 where nome like '%Centro de Repr Humana%' --13324

select nome, sigla, * from tb_entidade
 where sigla like '%GINECOOP%' -- 6

select valor_capital, * from rl_entidade_cooperado
 where fk_cooperado = 13324 and fk_entidade = 6 -- 2898

--update rl_entidade_cooperado set valor_capital = 250.00, sql_update = ISNULL(sql_update,'')+'#0419-000036' where id = 2898

select * from rl_cooperado_movimentacao
where fk_entidade_cooperado = 2898

--IMCCORE-Instituto Mineiro de Cirurgia Colorretal Ltda -- Alterar saldo
--Clínica Ginecológica e Obstétrica Dr. Nazy Ibrahim Ltda -- Alterar status
--Centro de Repr Humana Prof Aroldo Fernando Camargos -- Alterar saldo