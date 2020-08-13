select top 100 * from tb_item_despesa where tipo_item_despesa = 1 order by id desc

select top 100 * from tb_tabela_tiss where fk_tipo_tabela_tiss = 3 and descricao = '8Y' order by id desc

select top 100 * from tb_tipo_tabela_tiss

select * from rl_entidadeconvenio_tipo_despesa_codigo_tabela_ans where codigo_tabela_ans = 20

select * from tb_entidade where sigla = 'SANCOOP'

select * from rl_entidadeconvenio_tipo_despesa_codigo_tabela_ans where fk_entidade_convenio IN (

select id from rl_entidade_convenio where fk_entidade = 24) AND codigo_tabela_ans = 20 order by id desc

select fk_entidade, fk_convenio from rl_entidade_convenio where id = 5182

select * from tb_convenio where id = 6 324192 324193

--delete from tb_aviso_sistema where id in (324192, 324193)

 
select * from tb_codigo_excecao_ans order by id desc


select top 10 * from tb_procedimento

select top 10 * from tb_aviso_sistema order by id desc

select * from rl_entidadeconvenio_tipo_despesa_codigo_tabela_ans where id = 30722