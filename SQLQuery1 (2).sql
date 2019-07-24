select nome, * from tb_convenio where nome like '%Instituto de Previdencia dos Servidores Militares de Minas Gerais%' --270

select * from tb_entidade where sigla like '%COOPIMIMG%'

select * from tb_endereco where fk_convenio = 270

select * from rl_entidade_convenio where fk_convenio = 270 and fk_entidade = 2 --886

select top 10 * from tb_espelho
where fk_entidade = 2 and fk_entidade_convenio = 886