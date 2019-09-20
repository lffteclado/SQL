select hospital.id,
       hospital.nome,
	   count(distinct atendimento.id) totalAtendimento,
	   --procedimento.id as idProced,
	   sum(coalesce(procedimento.valor_total - procedimento.valor_acrescimo, 0)) valor,
	   sum(procedimento.quantidade) totalProcedi ,
	   count (distinct procedimento.id) totalProcedimento,
	   year(espelho.data_emissao) as anoCad,
	   month(espelho.data_emissao) as mesCad
	   --espelho.numero_espelho,
	   --procedimento.valor_honorario
	   from tb_atendimento as atendimento with(nolock)
	   inner join tb_entidade as entidade with(nolock) on (atendimento.fk_entidade = entidade.id and entidade.registro_ativo = 1 and atendimento.registro_ativo = 1)
	   inner join tb_procedimento as procedimento with(nolock) on (atendimento.id = procedimento.fk_atendimento and procedimento.registro_ativo = 1)
	   left join tb_item_despesa itemDespesa with(nolock) on (itemDespesa.id = procedimento.fk_item_despesa and itemDespesa.registro_ativo=1)
	   inner join rl_entidade_convenio as entidadeConvenio with(nolock) on (entidadeConvenio.id = atendimento.fk_convenio and entidadeConvenio.registro_ativo = 1 and entidadeConvenio.ativo = 1)
	   inner join tb_convenio as convenio with(nolock) on (convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1) 
	   inner join tb_hospital as hospital with(nolock) on (hospital.id = atendimento.fk_hospital and hospital.registro_ativo = 1 and hospital.situacao = 1 )
	   --left join tb_pagamento_procedimento as pagamentoProcedimento with(nolock) on (pagamentoProcedimento.fk_procedimento = procedimento.id and pagamentoProcedimento.registro_ativo = 1)
	   --left join tb_fatura fatura  with(nolock) on ( fatura.id = pagamentoProcedimento.fk_fatura and fatura.registro_ativo = 1 )
	   --left join tb_pagamento_fatura pagamentoFatura with(nolock) on ( pagamentoFatura.fk_fatura = fatura.id and pagamentoFatura.registro_ativo = 1 )
	   left join tb_espelho espelho with(nolock) on ( espelho.id = atendimento.fk_espelho and espelho.registro_ativo = 1 )
	   where entidadeConvenio.fk_entidade = 46
	   --and entidade.id = 46
	   and atendimento.registro_ativo = 1
	   and atendimento.autorizado_unimed = 1
	   and isnull(atendimento.rateio,0) != 1
	   and convenio.id in (186)
	   and atendimento.situacaoAtendimento != 6
	   and hospital.id in (480)
	   and espelho.data_emissao between '2019-06-01' and '2019-06-30'-- and espelho.numero_espelho = 8938-- and procedimento.id = 26165617
	   group by hospital.id, hospital.nome, entidade.id, year(espelho.data_emissao), month(espelho.data_emissao) order by 2 asc