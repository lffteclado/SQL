/*
* SCRIPT: Alterar tipo de movimentação Cooperados de Eliminidado para Demitido:
* ENTIDADE: GINECOOP
* COOPERADO: SMH Serviços Médicos Hospitalares S/C LTDA
* COOPERADO: Nucleo de Vídeo Cirurgia S/C Ltd
* AUTOR: Luís Felipe
*/

--update rl_entidade_cooperado set situacao_cooperado = 2, sql_update=ISNULL(sql_update,'')+'#0419-000250' where id in (3326, 3369)
go
--update rl_cooperado_movimentacao set fk_tipo_movimentacao = 8, sql_update=ISNULL(sql_update,'')+'#0419-000250' where id in (109985, 109983)

select * from tb_cooperado where nome like '%Adriana Jardim de Almeida%' --19540

select * from tb_entidade where sigla like '%BHCOOP%' --17

select data_cadastro, * from rl_entidade_cooperado where fk_cooperado = 19540 and fk_entidade = 17 --33980 / 26/02/1997

--update rl_entidade_cooperado set data_cadastro = '1997-02-26', sql_update = ISNULL(sql_update,'')+'0919-000120' where id = 33980

--insert into rl_cooperado_movimentacao (data_ultima_alteracao, registro_ativo,data_movimentacao,matricula, fk_usuario_ultima_alteracao, fk_entidade_cooperado, fk_tipo_movimentacao, sql_update)
	--							values (getdate(),1,'2019-03-01 00:00:00.0000000',298,1,33980,2,'0919-000120')
--update rl_cooperado_movimentacao set data_ultima_alteracao = GETDATE(),
--                                     data_movimentacao = '2019-03-01 00:00:00.0000000',
--									 fk_usuario_ultima_alteracao = 10355,
--									 valor_movimentacao = 0.00
--							     where id = 119661

select * from rl_cooperado_movimentacao where fk_entidade_cooperado = 33980 and fk_tipo_movimentacao = 2

select * from rl_cooperado_movimentacao where fk_entidade_cooperado = 33980 and registro_ativo = 1


--update rl_cooperado_movimentacao set data_movimentacao = '1997-02-26 00:00:00.0000000', sql_update= ISNULL(sql_update,'')+'0919-000120' where id = 117031

select * from tb_tipo_movimentacao where id in (9,1,2)