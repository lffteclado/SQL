select distinct top 100 --conv.sigla,
	   cooperado.nome,
	   tiss.descricao,
	   ate.numero_guia,
	   pro.valor_honorario,
	   enti.id as entID,
	   pro.id as proID,
	   ate.id as ateID
 from tb_atendimento ate
inner join tb_procedimento pro on pro.fk_atendimento = ate.id and ate.registro_ativo = 1
inner join tb_item_despesa itemDesp on pro.fk_item_despesa = itemDesp.id and pro.registro_ativo = 1
--inner join tb_atendimento_integracao ateInt on ate.numero_atendimento_automatico = ateInt.numero_atendimento_automatico
inner join tb_entidade enti on enti.id = ate.fk_entidade
--inner join rl_entidade_convenio entidadeConv on  entidadeConv.fk_entidade = enti.id
--inner join tb_convenio conv on entidadeConv.fk_convenio = conv.id
inner join rl_entidade_cooperado entidadeCooperado on entidadeCooperado.fk_entidade = enti.id
inner join rl_entidadecooperado_especialidade rlCoopEsp on rlCoopEsp.fk_entidade_cooperado = entidadeCooperado.id
inner join tb_tabela_tiss tiss on tiss.id = rlCoopEsp.fk_especialidade
inner join tb_cooperado cooperado on cooperado.id = entidadeCooperado.fk_cooperado
where ate.ano_atendimento = 2019 and pro.data_realizacao between '2019-05-01' and '2019-05-31' and ate.fk_entidade = 63 --and enti.id = 63

-- ate.fk_entidade = 63  and itemDesp.codigo = 10101012