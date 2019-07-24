
select top 10 situacao, * from tb_glosa where situacao = 0 and fk_convenio_temp = 498

select top 10 codigo_item_despesa_temp, descricao_item_despesa_temp, *
 from tb_procedimento where codigo_item_despesa_temp = 31309038 and data_realizacao = '2018-11-04' 

select top 10 * from tb_carta_glosa where fk_convenio

select sigla, * from tb_convenio where sigla = 'BRADESCO S'

Esta consulta foi glosada pelo convênio , pois a mesma foi retorno . 