select * from sysobjects where name like '%integra%'


select top 10 * from tb_integracao_hospital where fk_entidade = 12 and id = 88250 order by id desc

select top 100 * from tb_importacao_base where fk_entidade = 12 and id = 84169 order by id desc

select top 10 codigo_procedimento_tuss, fk_item_despesa, * from tb_procedimento_integracao where fk_integracao = 88250 order by id desc

select * from tb_item_despesa where codigo = '161161' --Lançamento Eventual 278970

select * from tb_item_despesa where codigo = '10101039'