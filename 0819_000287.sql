select top 100 * from rl_seguranca_entidade_perfil_acesso order by id desc

select top 10 * from rl_entidade_perfil_acesso order by id desc

select * from tb_usuario where usuario = 'eguinardportela' -- 10166

select * from tb_entidade where sigla like '%SANTACOOPMACEIO%' --46

select * from rl_entidade_usuario where fk_entidade = 46 and fk_usuario = 10166 --11853

select * from  rl_entidade_usuario_perfil_acesso where fk_entidade_usuario = 11853 -- 12021

select * from rl_seguranca_entidade_perfil_acesso where fk_entidade_perfil_acesso = 10085

select * from  rl_seguranca_entidade_perfil_acesso where id = 26125

select * from tb_perfil_acesso where id = 22

select * from rl_entidade_perfil_acesso where id = 10085 

select * from rl_entidade_perfil_acesso where id = 10080

select top 100 * from tb_caso_de_uso order by id desc

select * from tb_modulo

select * from tb_url

select * from tb_caso_de_uso where fk_modulo = 14

-- Nota Fiscal 14

select * from tb_url where url like '%/pages/modulos/atendimento%'


