select * from tb_fatura where fk_entidade in (select id from tb_entidade where sigla like '%GINECOOP%') AND numero_fatura = 24418

select * from tb_pagamento_fatura where fk_fatura = 112832


    select fatura.numero_fatura,
	       convenio.sigla,
		   data_emissao,
		   data_vencimento,
		   case fatura.status_fatura
		   when 0 then
				sum(valor_total_honorario
					+ valor_total_custo_operacional
					+ valor_total_filme
					+ valor_total_acrescimo
					+ valor_custeio
					- valor_total_desconto)
			 when 1 then
				(fatura.valor_liquido - pagamento.valor_pagamento)
			 end as valor_total,
		   fatura.texto_acompanhamento_cobranca,'Fatura' as tipo,
		   2 as numeroTipo
    from tb_fatura fatura with(nolock)
    inner join tb_entidade entidade with(nolock) on (entidade.id = fatura.fk_entidade and entidade.registro_ativo = 1)
    inner join tb_convenio convenio with(nolock) on (convenio.id = fatura.fk_convenio  and convenio.registro_ativo =1 and convenio.situacao = 1 )
    left join tb_pagamento_fatura pagamento with(nolock) on (pagamento.fk_fatura = fatura.id and pagamento.registro_ativo=1)
    where fatura.valor_total > 0 and fatura.registro_ativo = 1 and entidade.id = 6 and fatura.status_fatura in (0,1) and data_cancelamento is null
    and fatura.autorizado_unimed = 1 --and pagamento.fk_fatura = 112832
    group by fatura.numero_fatura,
	 convenio.sigla,
	 fatura.data_emissao,
	 fatura.data_vencimento,
	 fatura.texto_acompanhamento_cobranca,
	 pagamento.valor_pagamento,
	 fatura.status_fatura,
	 fatura.valor_liquido