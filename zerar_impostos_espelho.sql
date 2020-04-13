update tb_espelho
 set   valor_cofins = 0.00
       ,valor_csll = 0.00
       ,valor_custeio= 0.00
       ,valor_ir= 0.00
       ,valor_iss= 0.00
       ,valor_liquido= 0.00
       ,valor_pis= 0.00
       ,valor_total= 0.00
       ,valor_total_acrescimo= 0.00
       ,valor_total_custo_operacional= 0.00
       ,valor_total_desconto= 0.00
       ,valor_total_filme= 0.00
       ,valor_total_honorario= 0.00
       ,valor_total_importado= 0.00
       ,valor_total_acrescimo_convenio= 0.00
       ,valor_acrescimo_pagamento= 0.00
       ,valor_cofins_pagamento= 0.00
       ,valor_csll_pagamento= 0.00
       ,valor_custeio_pagamento= 0.00
       ,valor_custo_operacional_pagamento= 0.00
       ,valor_desconto_pagamento= 0.00
       ,valor_diferenca= 0.00
       ,valor_filme_pagamento= 0.00
       ,valor_honorario_pagamento= 0.00
       ,valor_ir_pagamento= 0.00
       ,valor_iss_pagamento= 0.00
       ,valor_liquido_pagamento= 0.00
       ,valor_multa_pagamento= 0.00
       ,valor_pis_pagamento= 0.00
       ,valor_desconto_anterior= 0.00
       ,valor_honorario_anterior= 0.00
       ,valor_acrescimo_convenio_anterior= 0.00
       ,valor_bruto_data_envio= 0.00
	   ,base_iss = 0.00
where id in (
	SELECT id FROM tb_espelho WHERE numero_espelho IN (
		16619
		,16653
		,16643
		,16664
		,16654
		,16617
		,16607
		,16594
		,16631
		,16630
		,16652
		,16650
		,16649
		,16659
		,16609
		,16594
		,16593
		,16606
		,16613
		,16644
		,16598
		,16883
		,16608
		,16616
		,16635
		,17187
		,16747
		,16661
		,16448
		,16648
		,16642
		,16647
		,16646
		,16499
) AND fk_entidade = 6 AND registro_ativo = 1)