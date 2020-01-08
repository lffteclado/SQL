select * from tb_atendimento
where numero_atendimento_automatico = '599131'
and fk_entidade = 43

select * from tb_procedimento
where fk_atendimento = 21111150 --

select valor_honorario,
       valor_custo_operacional,
	   valor_filme,
	   valor_acrescimo
from tb_procedimento
where id = 31868369
union
select  valor_honorario
       ,valor_custo_operacional
	   ,valor_filme
	   ,valor_acrescimo
 from tb_pagamento_procedimento
where fk_procedimento = 31868369 and registro_ativo = 1
union
select  valor_honorario,
       valor_custo_operacional,
	   valor_filme,
	   valor_acrescimo from tb_glosa
where fk_procedimento = 31868369 and registro_ativo = 1

select * from rl_situacao_procedimento
 where fk_procedimento = 29180144

select fk_procedimento, * from tb_glosa
where fk_procedimento in (31868369) and registro_ativo = 1

select top 10 * from rl_conversao_glosa_devida_parcial where fk_glosa = 3355027

--update tb_glosa set registro_ativo = 1 where id = 3355026

select * from tb_glosa where fk_procedimento = 30197582


--update tb_glosa set valor_honorario = 107.03
--   ,valor_acrescimo = 0.00 --0.00
--   --,valor_custo_operacional = 0.00
--   --,valor_filme = 0.00
--where fk_procedimento = 30197582 and registro_ativo = 1


select * from sysobjects where name like '%tri%'

sp_helptext TRI_SITUACAO_ATENDIMENTO_PAGAMENTO_ESPELHO

select top 100 * from rl_conversao_glosa_devida_parcial_AUD

