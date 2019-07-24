--select sigla, nome, * from tb_entidade where sigla LIKE '%COOPMEDRS%' --63

select data_envio, * from tb_espelho
 where data_criacao > '2019-04-01' and fk_entidade = 63 and numero_espelho = 16273 -- 553054 -- 2019-04-02 14:07:05.7950000

select sum(valor_total_atendimento) as valor_total from tb_atendimento
 where fk_espelho = 553054 and data_ultima_alteracao between '2019-04-02 08:40:52.6033333' and '2019-04-02 14:07:05.7950000'

select count(*) as totalAtendimento from tb_atendimento where fk_espelho = 554574

select * from tb_atendimento where fk_espelho = 552581

select * from rl_entidade_hospital where id = 224 -- 1203
select * from rl_entidade_hospital where id = 212 -- 1066

select nome, sigla, * from tb_hospital where id in (1203, 1066)

select * from tb_procedimento where fk_atendimento = 16855034

select top 1 valor_bruto_data_envio, * from tb_espelho

select data_envio, numero_espelho, * from tb_espelho where numero_espelho = 16364 and fk_entidade =63 

select (sum (valor_total_atendimento))  from tb_atendimento where fk_espelho = 552620

select numero_espelho, * from tb_espelho where id = 552581

select count(*) from tb_atendimento where fk_espelho = 552620

--isnull((e.valor_total_honorario +e.valor_total_acrescimo+e.valor_total_filme+e.valor_total_custo_operacional-e.valor_total_desconto),0) valorEspelho,

select top 10 numero_espelho, * from tb_espelho where valor_total_custo_operacional <> 0.00 and data_criacao > '2019-04-01 00:00:00.0000000' and fk_entidade = 63
