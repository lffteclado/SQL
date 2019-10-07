select sum(valor_total - valor_acrescimo) from tb_procedimento where fk_atendimento in (


select atendimento.id
       --convenio.id,
       --convenio.sigla,
	   --count(distinct atendimento.id) totalAtendimento,
	   --sum( coalesce (procedimento.valor_total - procedimento.valor_acrescimo, 0)) valor,
	   --procedimento.id as idProced,
	   --sum(procedimento.quantidade) totalProcedi,
	   --count (distinct procedimento.id) totalProcedimento,
	   --year(espelho.data_emissao) as anoCad, month(espelho.data_emissao) as mesCad,
	   --atendimento.numero_atendimento_automatico
	   from tb_atendimento as atendimento with(nolock)
	     inner join tb_entidade as entidade with(nolock) on (atendimento.fk_entidade = entidade.id and entidade.registro_ativo = 1 and atendimento.registro_ativo = 1)
		 inner join tb_procedimento as procedimento with(nolock) on (atendimento.id = procedimento.fk_atendimento and procedimento.registro_ativo = 1)
		 left join tb_item_despesa itemDespesa with(nolock) on (itemDespesa.id = procedimento.fk_item_despesa and itemDespesa.registro_ativo=1)
		 inner join rl_entidade_convenio as entidadeConvenio with(nolock) on (entidadeConvenio.id = atendimento.fk_convenio and entidadeConvenio.registro_ativo = 1 and entidadeConvenio.ativo = 1)
		 inner join tb_convenio as convenio with(nolock) on (convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1)
		 inner join tb_hospital as hospital with(nolock) on (hospital.id = atendimento.fk_hospital and hospital.registro_ativo = 1 and hospital.situacao = 1 )
		 left join tb_espelho espelho with(nolock) on ( espelho.id = atendimento.fk_espelho and espelho.registro_ativo = 1 )
		 where entidadeConvenio.fk_entidade = 46
		 and atendimento.registro_ativo = 1
		 and atendimento.autorizado_unimed = 1
		 and isnull(atendimento.rateio,0) != 1 
		 and entidadeConvenio.fk_convenio in (1343)
		 and atendimento.situacaoAtendimento != 6
		 --and hospital.id in (480)
		 and espelho.data_emissao between '2019-06-01' and '2019-06-30'
		 group by atendimento.id
		 -- convenio.id, convenio.sigla, entidade.id,  year(espelho.data_emissao),  month(espelho.data_emissao), atendimento.numero_atendimento_automatico order by 2 asc

) and registro_ativo = 1