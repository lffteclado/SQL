select esp.numero_espelho,
esp.data_criacao,
esp.data_envio,
(select count (distinct ate.id) from tb_atendimento where id = ate.id ) as totalAten
from tb_espelho esp
 inner join tb_atendimento ate on ate.fk_espelho = esp.id
 where esp.id in (553883)
 group by esp.numero_espelho, esp.data_criacao, esp.data_envio, ate.id

select distinct esp.id,
        numero_espelho,
		hos.sigla,
        (select count (distinct id) from tb_atendimento where esp.id = fk_espelho) as total,
		(select sum(valor_total_atendimento) from tb_atendimento where esp.id = fk_espelho) as valorTotal,
		(select count (distinct id) from tb_procedimento where fk_atendimento = ate.id) as quantAte
from tb_espelho esp
inner join tb_atendimento ate on ate.fk_espelho = esp.id
inner join tb_procedimento pro on pro.fk_atendimento = ate.id
inner join tb_hospital hos on ate.fk_hospital = hos.id
where esp.id in (554574)

select sigla, * from tb_hospital where sigla = 'HOSPDOMJOAOBECK'

select * from tb_espelho where id = 554574

select valor_total_atendimento, * from tb_atendimento where fk_espelho = 553401

select COUNT(*) from tb_atendimento where fk_espelho = 554556 and fk_hospital = 897

select count(*) from tb_procedimento where fk_atendimento in (select id from tb_atendimento where fk_espelho = 554556 and fk_hospital = 897) and registro_ativo = 1

select sum(valor_total_atendimento) from tb_atendimento where fk_espelho = 554556 and fk_hospital = 957 and registro_ativo = 1

select top 1 * from tb_pagamento_procedimento

 --,553892,553893,553894,553917,553940,553054,553056

--select count (*) from tb_atendimento where fk_espelho = 553940
/*
select count (distinct atend.id) from tb_atendimento atend
inner join tb_espelho espe on atend.fk_espelho = espe.id
where espe.id = 553054*/

--56398.93 // 59405.29
select e.valor_total_honorario,
       e.valor_total_acrescimo,
	   e.valor_total_filme,
	   e.valor_total_custo_operacional,
	   e.valor_total_desconto,
       isnull((e.valor_total_honorario +e.valor_total_acrescimo+e.valor_total_filme+e.valor_total_custo_operacional-e.valor_total_desconto),0) valorEspelho
from tb_espelho e where id = 553401 AND registro_ativo = 1


select * from tb_atendimento where fk_espelho = 554574


 --isnull((e.valor_total_honorario +e.valor_total_acrescimo+e.valor_total_filme+e.valor_total_custo_operacional-e.valor_total_desconto),0) valorEspelho,
