/**
* PROPOSITO: Alteração Saldo Valor Capital Cooperado.
* COOPERADOS:
* IMCCORE-Instituto Mineiro de Cirurgia Colorretal Ltda 
* Centro de Repr Humana Prof Aroldo Fernando Camargos
* EMPRESA: GINECOOP
* PERÍODO: 06/12/2018
* 
**/

UPDATE rl_entidade_cooperado SET valor_capital = 150.00, sql_update = ISNULL(sql_update,'')+'#0419-000036' WHERE id = 3046

GO

UPDATE rl_entidade_cooperado SET valor_capital = 250.00, sql_update = ISNULL(sql_update,'')+'#0419-000036' WHERE id = 2898

