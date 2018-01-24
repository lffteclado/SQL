select * from usuario where id_empresa = 4
select * from usuario where dataCadastroSenha < '2017-01-01 00:00:00.000'
select * from empresa
select * from tipo_usuario
select * from Designados_por_empresa where id_empresa = 1 and id_usuario = 101 and id_tipo_usuario
select * from Designados_por_empresa where id_empresa = 5 and id_usuario = 28 and id_tipo_usuario
select * from Designados_por_empresa order by id desc

--update Designados_por_empresa set id_usuario = 62 where id = 60 and id_empresa = 12
--update usuario set email = 'antonio@goiascaminhoes.com.br' where nome_usuario = 'Antonio Lima' 
--update usuario set id_empresa = 12 where nome_usuario = 'João Alexandre' and id = 62
--update usuario set id_tipo_usuario = 5 where nome_usuario = 'João Alexandre' and id = 62
--Apos criar o usuario colocar essas informações na tabela Designados_por_empresa
--insert into Designados_por_empresa (id_empresa, id_usuario, id_tipo_usuario) values (4, 105, 1)

select * from usuario where nome_usuario like 'Lidya Lopes' --id 84 id_tipo_usuario 5 id_empresa 12
union all
select * from usuario where nome_usuario = 'João Alexandre' --id 62  id_tipo_usuario  4 id_empresa 5

--BA6F5319E1A220B1C3F9C3CD16FA2308

--update usuario set senha = 'F169D2F349791496310BDD7676180A08' where id_empresa = 5 and id = 28 and nome_usuario = 'Antonio Lima'

--update usuario set senha = 'F169D2F349791496310BDD7676180A08' where id_empresa = 1 and id = 102 and nome_usuario = 'Luis Felipe Ferreira'
--update usuario set senha = 'USERDESAT', login = 'USERDESAT' where id_empresa = 3 and id = 71 and nome_usuario = 'Assis Dantas'

--SELECT statusTransferencia, * FROM base
--inner join usuario
--on base.id_designado = usuario.id
--inner join cliente C on base.id_cliente = C.id_cliente
--WHERE base.id = 3150

--select * from Designados_por_empresa

--select statusTransferencia, * from base order by data desc

/*
* Ajustes Data do Cadastro da Senha
*/
--update usuario set dataCadastroSenha = '2017-11-27 00:00:00.000' where id_empresa = 4 and id = 105 and nome_usuario = 'Leticia Teixeira Domingos'
/*
select * from base B
inner join usuario U
on B.assinaturaAtendente = U.arquivoassinatura
inner join empresa E on B.id_empresa = E.id
inner join Designados_por_empresa D
on D.id_usuario = U.id where B.id = 3261

select * from base where id = 3261

select * from base order by id desc
*/
/*
select * from venda_mes order by id desc

insert into venda_mes (venda_mes) values ('janeiro-18')
insert into venda_mes (venda_mes) values ('fevereiro-18')
insert into venda_mes (venda_mes) values ('março-18')
insert into venda_mes (venda_mes) values ('abril-18')
insert into venda_mes (venda_mes) values ('maio-18')
insert into venda_mes (venda_mes) values ('junho-18')
insert into venda_mes (venda_mes) values ('julho-18')
insert into venda_mes (venda_mes) values ('agosto-18')
insert into venda_mes (venda_mes) values ('setembro-18')
insert into venda_mes (venda_mes) values ('outubro-18')
insert into venda_mes (venda_mes) values ('novembro-18')
insert into venda_mes (venda_mes) values ('dezembro-18')

select * from potica_mes order by id desc

insert into potica_mes (politica_mes) values ('janeiro-18')
insert into potica_mes (politica_mes) values ('fevereiro-18')
insert into potica_mes (politica_mes) values ('março-18')
insert into potica_mes (politica_mes) values ('abril-18')
insert into potica_mes (politica_mes) values ('maio-18')
insert into potica_mes (politica_mes) values ('junho-18')
insert into potica_mes (politica_mes) values ('julho-18')
insert into potica_mes (politica_mes) values ('agosto-18')
insert into potica_mes (politica_mes) values ('setembro-18')
insert into potica_mes (politica_mes) values ('outubro-18')
insert into potica_mes (politica_mes) values ('novembro-18')
insert into potica_mes (politica_mes) values ('dezembro-18')
*/