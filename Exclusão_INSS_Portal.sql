/*Exclusão INSS*/

--Consulta SASC ver origem e id's
select *from tb_declaracao_inss  where fk_cooperado=13806 and (data='2020-03-01' or data='2020-03-01') --and registro_ativo=1
and base_inss='1943.30'

select *from tb_cooperado where nome like '%joao tadeu leite dos reis%'

/*Consultar e Excluir Portal*/

select fk_situacao_declaracao, * from tb_declaracao_inss where id in(83492)


-- update tb_declaracao_inss set registro_ativo=0 where id in(83492)


/*Conferir se a origem é Sasc ou Portal */

--Sempre excluir no Portal, se a origem é no SASC pegar o id e pesquisar


/*Conferir no SASC Web*/

select *from ad_recolhimento_inss where CodSascJava in(8425928)

/***********************************************************************/
--SEMPRE CONFERIR O LOG