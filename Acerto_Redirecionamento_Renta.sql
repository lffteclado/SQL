select * from Designados_por_empresa where id_empresa = 1 and id_usuario in (32, 101, 106)



select * from usuario where nome_usuario in ('FERNANDO CYRINO', 'HECTORY FERNANDO BERNNARDINI')


select nome_usuario, id_tipo_usuario from usuario where nome_usuario like 'Carlos Alberto' --id 84 id_tipo_usuario 5 id_empresa 12
union all
select nome_usuario, id_tipo_usuario from usuario where nome_usuario = 'FERNANDO CYRINO' --id 62  id_tipo_usuario  4 id_empresa 5
union all
select nome_usuario, id_tipo_usuario from usuario where nome_usuario = 'HECTORY FERNANDO BERNNARDINI'

--update usuario set senha = 'F169D2F349791496310BDD7676180A08' where id_empresa = 1 and id = 101 and nome_usuario = 'FERNANDO CYRINO'

--update usuario set login = 'AB2C642FF80DC76372E337EA09601920' where id_empresa = 1 and id = 113 and nome_usuario = 'HECTORY FERNANDO BERNNARDINI'

--update usuario set id_tipo_usuario = 2 where nome_usuario = 'HECTORY FERNANDO BERNNARDINI' and id_empresa = 1


--AB2C642FF80DC76372E337EA09601920      hbernnardini
