/*
* SCRIPT: Alterar tipo de movimenta��o Cooperados de Eliminidado para Demitido:
* ENTIDADE: GINECOOP
* COOPERADO: SMH Servi�os M�dicos Hospitalares S/C LTDA
* COOPERADO: Nucleo de V�deo Cirurgia S/C Ltd
* AUTOR: Lu�s Felipe
*/

--update rl_entidade_cooperado set situacao_cooperado = 2, sql_update=ISNULL(sql_update,'')+'#0419-000250' where id in (3326, 3369)
go
--update rl_cooperado_movimentacao set fk_tipo_movimentacao = 8, sql_update=ISNULL(sql_update,'')+'#0419-000250' where id in (109985, 109983)

