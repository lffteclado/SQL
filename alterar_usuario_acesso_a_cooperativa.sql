select * from tb_usuario where usuario like '%camilasilveira%' -- 51

select * from rl_entidade_usuario where fk_usuario = 58 and fk_entidade = 17 --BHCOOP

--update rl_entidade_usuario set registro_ativo = 1, fk_entidade = null, sql_update = ISNULL(sql_update,'')+'#0619-000087' where fk_usuario = 10257 and fk_entidade = 43

update rl_entidade_usuario set fk_entidade = null where id = 832 --7

select nome, * from tb_entidade where id = 43

select * from tb_perfil_acesso where id  in (
0,
2,
22,
20,
1
)

select top 100 * from rl_seguranca_entidade_perfil_acesso

select top 100 * from rl_entidade_usuario_perfil_acesso where fk_entidade_usuario = 832

select * from sysobjects where name like '%acesso%'

select * from rl_entidade_perfil_acesso where id in (
10159,
10160,
10151,
10156,
10133
)

10161
10197
10148
10135
10146

select fk_entidade_usuario_criacao, * from tb_espelho where fk_entidade_usuario_criacao = 832 and registro_ativo = 1

DECLARE  @return_value int

EXEC  @return_value = [dbo].[ConsultaRelacionamentos]
@Tabela = N'" + tb_espelho + "',
@id = N'" + tb_espelho.id + "'
				
SELECT  'Return Value' = @return_value


sp_help rl_entidade_usuario