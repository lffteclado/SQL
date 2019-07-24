-- select * from tb_atendimento where numero_atendimento_automatico = 174539 and fk_entidade in (select id from tb_entidade where sigla like '%GINECOOP%')--------------

SELECT situacaoAtendimento, * FROM tb_atendimento where id = 1406458

select situacao, fk_procedimento, * from tb_glosa where data_glosa = '2016-06-10 00:00:00.0000000' and id in (27191, 27196)

--update tb_glosa set situacao = 2, sql_update=ISNULL(sql_update,'')+'#0519-000015' where id in (27191, 27196)

select guia_procedimento, descricao_item_despesa_temp, codigo_item_despesa_temp, * from tb_procedimento where id in (1702314, 1702310)

--201500612801

select guia_procedimento, descricao_item_despesa_temp, codigo_item_despesa_temp, * from tb_procedimento where guia_procedimento = '201500612801'

select situacao, * from tb_glosa where fk_procedimento = 1702110