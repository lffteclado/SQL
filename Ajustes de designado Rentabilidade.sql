select * from usuario where nome_usuario like '%Jessica%'
select * from usuario where dataCadastroSenha < '2017-01-01 00:00:00.000'
select * from empresa
select * from tipo_usuario
select * from Designados_por_empresa where id_empresa = 1 and id_usuario = 101 and id_tipo_usuario
select * from Designados_por_empresa where id_empresa = 5 and id_usuario = 104 and id_tipo_usuario = 1
select * from Designados_por_empresa order by id desc
select * from modelo_tipo
select * from modelo_seguimento

select * from usuario where nome_usuario = 'Wanda Maria'
union all
select * from usuario where nome_usuario = 'teste'

select * from usuario where id_tipo_usuario = 6
select * from usuario where id = 21 -- Renata Lucas 
select * from usuario where id = 23 -- Natalia Linhares

union all
select * from usuario where id = 47
union all
select * from usuario where id = 98
union all
select * from usuario where id = 32
union all
select * from usuario where id = 101
union all
select * from usuario where id = 106

select * from vendedor WHERE vendedor = 'HENDRIKUS FERREIRA'

--insert into vendedor (vendedor) values ('HENDRIKUS FERREIRA')

--delete from usuario where id = 110

--update usuario set email = 'luisfelipe@grupovdl.com.br'
--update usuario set senha = 'F169D2F349791496310BDD7676180A08' where nome_usuario = 'Fabíola Almeirda'

--update Designados_por_empresa set id_tipo_usuario = 1 where id = 18 and id_empresa = 1 and id_usuario = 32
--update Designados_por_empresa set id_tipo_usuario = 1 where id = 74 and id_empresa = 1 and id_usuario = 106
--update usuario set email = 'antonio@goiascaminhoes.com.br' where nome_usuario = 'Antonio Lima' 
--update usuario set id_empresa = 12 where nome_usuario = 'João Alexandre' and id = 62
--update usuario set id_tipo_usuario = 1 where nome_usuario = 'HECTORY FERNANDO BERNNARDINI' and id = 106
--Apos criar o usuario colocar essas informações na tabela Designados_por_empresa
--insert into Designados_por_empresa (id_empresa, id_usuario, id_tipo_usuario) values (1, 106, 2)

select nome_usuario, id_tipo_usuario, * from usuario where nome_usuario like 'Antonio Lima' --id 84 id_tipo_usuario 5 id_empresa 12
union all
select nome_usuario, id_tipo_usuario from usuario where nome_usuario = 'FERNANDO CYRINO' --id 62  id_tipo_usuario  4 id_empresa 5
union all
select nome_usuario, id_tipo_usuario from usuario where nome_usuario = 'HECTORY FERNANDO BERNNARDINI'

--update usuario set id_tipo_usuario = 2 where id = 113 and nome_usuario = 'HECTORY FERNANDO BERNNARDINI'

--AB2C642FF80DC76372E337EA09601920      hbernnardini

--BA6F5319E1A220B1C3F9C3CD16FA2308

-- senha Natalia AE14F0B5EB78F595A254065DDB36383F usuario 89A4F485D121483912276D2F464EE010

-- login teste 698DC19D489C4E4DB73E28A713EAB07B

--update usuario set senha = 'F169D2F349791496310BDD7676180A08' where id_empresa = 5 and id = 28 and nome_usuario = 'Antonio Lima'

--update usuario set login = '89A4F485D121483912276D2F464EE010' where id_empresa = 1 and id = 23 and nome_usuario = 'Natalia Linhares'

--update usuario set id_empresa = 1 where id_empresa = 3 and id = 100 and nome_usuario = 'Fabíola Almeirda'

3ED2516BFA8F3D985F06E3F35A30DDF4

6B84F40F8F956A76DA0D4C973D56AFDC

--update usuario set senha = 'F169D2F349791496310BDD7676180A08' where id_empresa = 1 and id = 102 and nome_usuario = 'Luis Felipe Ferreira'
--update usuario set senha = 'USERDESAT', login = 'USERDESAT' where id_empresa = 1 and id = 32 and nome_usuario = 'Carlos Alberto'

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
--update usuario set dataCadastroSenha = '2018-03-15 00:00:00.000' where id_empresa = 1 and id = 26 and nome_usuario = 'Adairson'
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

select * from Designados_por_empresa where id_empresa = 1

--update Designados_por_empresa set id_tipo_usuario = 2 where id_empresa = 1 and id_usuario = 113

*/

select * from base where nome like '%JUVERCINO GUIMARAES ALVES%'

select assinaturaGerencia, assinaturaGerenciaNova, * from base where assinaturaGerenciaNova = 'cristianot.jpg'

--update base set assinaturaGerenciaNova = 'cristianot.jpg' where assinaturaGerenciaNova = 'CristianoT.png'

select id, nome_usuario, email, cargo from usuario where arquivoassinatura = 'cristianot.jpg'
