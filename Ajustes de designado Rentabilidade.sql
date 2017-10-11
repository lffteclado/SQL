select * from usuario where id_empresa = 5
select * from empresa
select * from tipo_usuario
select * from Designados_por_empresa where id_empresa = 12 and id_usuario = 28 and id_tipo_usuario
select * from Designados_por_empresa where id_empresa = 5 and id_usuario = 28 and id_tipo_usuario
select * from Designados_por_empresa

--update Designados_por_empresa set id_usuario = 62 where id = 60 and id_empresa = 12
--update usuario set email = 'antonio@goiascaminhoes.com.br' where nome_usuario = 'Antonio Lima' 
--update usuario set id_empresa = 12 where nome_usuario = 'João Alexandre' and id = 62
--update usuario set id_tipo_usuario = 5 where nome_usuario = 'João Alexandre' and id = 62

select * from usuario where nome_usuario like 'Harlen' --id 84 id_tipo_usuario 5 id_empresa 12
union all
select * from usuario where nome_usuario = 'João Alexandre' --id 62  id_tipo_usuario  4 id_empresa 5

--BA6F5319E1A220B1C3F9C3CD16FA2308

update usuario set login = 'BA6F5319E1A220B1C3F9C3CD16FA2308' where id_empresa = 5 and id = 63 and nome_usuario = 'Edimar Ferreira'

--update usuario set senha = 'F169D2F349791496310BDD7676180A08' where id_empresa = 5 and id = 63 and nome_usuario = 'Edimar Ferreira'
--update usuario set senha = 'USERDESAT', login = 'USERDESAT' where id_empresa = 1 and id = 20 and nome_usuario = 'Gleidson'

