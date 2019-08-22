select top 10 * from tb_repasse where fk_entidade = 63 and id = 6920

select sum(valor_lancamento) as Valor from rl_repasse_lancamento
 where fk_entidade = 63 and fk_cooperado_lancamento = 13539 and CONVERT(DATE,data_lancamento) between '2019-01-01' AND '2019-12-31'

select * from tb_cooperado where nome like '%A & C Medicos Associados Sociedade Simple%'

select * from tb_cooperado where id = 12266

select * from tb_entidade where sigla like '%COOPMEDR%'

select top 10 * from rl_entidade_cooperado where fk_cooperado = 63 and fk_cooperado = 1160

select * from rl_entidade_cooperado_conversao where fk_entidade = 63 and fk_cooperado_origem = 1160 and registro_ativo = 1

select top 10 * from tb_pagamento_fatura where id = 62463

case (count(conversao.id))
	   when 1 then 'SIM' else 'NÃO' end as 'Vinculado PJ',

select * from tb_fatura where id = 67248

select top 10 * from tb_espelho order by id desc

select top 10 * from tb_atendimento where id = 12961404 order by id desc

select top 10 * from tb_pagamento_fatura

select top 10 * from tb_pagamento_espelho

select * from tb_pagamento_procedimento where fk_fatura = 67248 order by id desc

select * from tb_procedimento where id = 19188958

select * from sysobjects where name like '%espelho%'