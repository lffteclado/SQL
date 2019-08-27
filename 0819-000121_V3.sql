select fk_cooperado_executante_complemento, fk_cooperado_recebedor_cobranca, fk_cooperado_recebedor_cobranca_anterior, * from tb_procedimento where id in (

	select fk_procedimento from tb_pagamento_procedimento where id in (

		select fk_pagamento_procedimento from rl_repasse_lancamento where fk_entidade = 43 and fk_repasse = 11514 and fk_cooperado_lancamento = 14441 and registro_ativo = 1

	) and registro_ativo = 1

) --group by fk_cooperado_executante_complemento, fk_cooperado_recebedor_cobranca

--select * from tb_procedimento