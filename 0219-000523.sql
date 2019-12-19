select * from tb_atendimento
where numero_atendimento_automatico = '2998666' --22136189
and fk_entidade = 23

select * from tb_procedimento
where fk_atendimento = 22136189 --

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
 where fk_procedimento = 31868369

select fk_procedimento, * from tb_glosa
where fk_procedimento in (31868369) and registro_ativo = 1

select top 10 * from rl_conversao_glosa_devida_parcial where fk_glosa = 3355027

--update tb_glosa set registro_ativo = 1 where id = 3355026


--update tb_glosa set valor_honorario = 50.00 -- 50.00
--   ,valor_acrescimo = 0.00 --0.00
--   --,valor_custo_operacional = 0.00
--   --,valor_filme = 0.00
--where fk_procedimento = 31868369 and registro_ativo = 1

