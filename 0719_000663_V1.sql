/* Correção dos espelhos com valores negativos | GINECOOP */

update tb_pagamento_procedimento
   set valor_honorario = 0.00,
       valor_acrescimo = 0.00,
	   sql_update = ISNULL(sql_update, '')+'#0719-000663'
   where fk_procedimento in (
   select id from tb_procedimento where fk_atendimento in ( 
		select id from tb_atendimento where fk_espelho in (
			 30580
			,26547
			,24795
			,23935
			,40166
			,40807
			,19778
			,22608
			,26009
			,27421
			,38848
			,19223
			,19599
			,41314
			,41385
			,24235
		)
	)
)and registro_ativo = 1

GO

update tb_espelho
 set valor_acrescimo_convenio_anterior = 0.00,
     valor_acrescimo_pagamento = 0.00,
	 valor_bruto_data_envio = 0.00,
	 valor_cofins = 0.00,
	 valor_cofins_pagamento = 0.00,
	 valor_csll = 0.00,
	 valor_csll_pagamento = 0.00,
	 valor_custeio = 0.00,
	 valor_custeio_pagamento = 0.00,
	 valor_custo_operacional_pagamento = 0.00,
	 valor_desconto_anterior = 0.00,
	 valor_desconto_pagamento = 0.00,
	 valor_diferenca = 0.00,
	 valor_filme_pagamento = 0.00,
	 valor_honorario_anterior = 0.00,
	 valor_honorario_pagamento = 0.00,
	 valor_ir = 0.00,
	 valor_ir_pagamento = 0.00,
	 valor_iss = 0.00,
	 valor_iss_pagamento = 0.00,
	 valor_liquido = 0.00,
	 valor_liquido_pagamento = 0.00,
	 valor_multa_pagamento = 0.00,
	 valor_pis = 0.00,
	 valor_pis_pagamento = 0.00,
	 valor_total = 0.00,
	 valor_total_acrescimo = 0.00,
	 valor_total_acrescimo_convenio = 0.00,
	 valor_total_custo_operacional = 0.00,
	 valor_total_desconto = 0.00,
	 valor_total_filme = 0.00,
	 valor_total_honorario = 0.00,
	 valor_total_importado = 0.00,
	 sql_update = ISNULL(sql_update,'')+'#0719-000663'
where id in (
             30580
			,26547
			,24795
			,23935
			,40166
			,40807
			,19778
			,22608
			,26009
			,27421
			,38848
			,19223
			,19599
			,41314
			,41385
			,24235
)