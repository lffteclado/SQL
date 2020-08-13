select * from tb_usuario where nome = 'teste' and registro_ativo = 1

select sigla, * from tb_entidade where sigla = 'COOPANEST' -- 23

select sigla, * from tb_entidade where id = 43

select id, nome from tb_modulo

select * from rl_entidade_usuario where id = 13000

select * from rl_entidade_usuario where fk_entidade = 23 and fk_usuario = 10581 and registro_ativo = 1 --13001

select * from rl_entidade_perfil_acesso where fk_entidade = 23 and fk_perfil_acesso = 56 --10238

select * from rl_entidade_usuario_perfil_acesso where fk_entidade_usuario = 13001 and registro_ativo = 1

select * from rl_entidade_usuario_perfil_acesso where data_ultima_alteracao > '2020-04-16' order by id desc

select * from tb_perfil_acesso where nome = 'Faturamento'

select * from tb_perfil_acesso where nome = 'Repasse'

select * from rl_seguranca_entidade_perfil_acesso where fk_entidade_perfil_acesso in (10237, 10238)

select * from rl_entidade_perfil_acesso_caso_uso

select * from rl_seguranca_entidade_perfil_acesso where fk_entidade_perfil_acesso = 10238 and tipoFuncao = 'URL' and idFuncao = 251

--13116