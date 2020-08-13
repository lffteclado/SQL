select * from tb_entidade where sigla = 'SANCOOP' -- 24

select * from tb_atendimento where numero_atendimento_automatico = '118836' and fk_entidade = 24

select * from tb_procedimento where fk_atendimento = 25790015

select * from tb_pagamento_procedimento where fk_procedimento = 36174830

select * from rl_situacao_procedimento where fk_procedimento = 36174830

select valor_honorario, * from tb_procedimento where id = 36174830

/*update tb_procedimento set valor_honorario = 30.68,
                           sql_update = ISNULL(sql_update,'')+'#0520-000350'
					   where id = 36174830*/