/**
* PROPOSITO: Ajustes Movimenta��o Cooperado Entidade Ginecoop
* COOPERADOS:  Centro de Repr Humana Prof Aroldo Fernando Camargos
* Cl�nica Ginecol�gica e Obst�trica Dr. Nazy Ibrahim Ltda
* IMCCORE-Instituto Mineiro de Cirurgia Colorretal Ltda
* Nucleo de V�deo Cirurgia S/C Ltd
* SMH Servi�os M�dicos Hospitalares S/C LTDA
* EMPRESA: 	Coop. de M�dicos Ginecologistas e Obstetras Ltda
* CNPJ: 	
* PER�ODO: 
* 
**/

update rl_cooperado_movimentacao set registro_ativo = 0,
 sql_update = ISNULL('',sql_update)+'#0419-000036' where id =109979
GO
update rl_cooperado_movimentacao set registro_ativo = 0,
 sql_update = ISNULL('',sql_update)+'#0419-000036' where id = 109981
GO
update rl_cooperado_movimentacao set valor_movimentacao = 50.00,fk_tipo_movimentacao = 8,
  sql_update = ISNULL('',sql_update)+'#0419-000036' where id = 110017
GO
update rl_entidade_cooperado set situacao_cooperado = 2,valor_capital = 0.00,
 sql_update = ISNULL('', sql_update)+'#0419-000036' where id = 3515
GO
update rl_cooperado_movimentacao set valor_movimentacao = 50.00,
 sql_update = ISNULL('',sql_update)+'#0419-000036' where id = 109983
GO
update rl_entidade_cooperado set valor_capital = 0.00,
 sql_update = ISNULL('', sql_update)+'#0419-000036' where id = 3369
GO
update rl_cooperado_movimentacao set valor_movimentacao = 50.00,
 sql_update = ISNULL('',sql_update)+'#0419-000036' where id = 109985
GO
update rl_entidade_cooperado set valor_capital = 0.00,
 sql_update = ISNULL('', sql_update)+'#0419-000036' where id = 3326

