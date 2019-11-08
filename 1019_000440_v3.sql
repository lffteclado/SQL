select itemDespesa.codigo,
procedimento.id,
procedimento.data_realizacao,
linha.data_realizacao,
linha.id
 from tb_arquivo_retorno_glosa linha
 inner join tb_atendimento atendimento on(atendimento.numero_guia = linha.campo_comparacao and atendimento.registro_ativo = 1)
 INNER JOIN tb_procedimento procedimento
  ON(procedimento.fk_atendimento = atendimento.id and procedimento.data_realizacao = linha.data_realizacao and procedimento.registro_ativo = 1)
CROSS APPLY (
	 SELECT TOP 1 item.id, item.codigo FROM tb_item_despesa item
	 WHERE codigo = linha.codigo_item_despesa and item.id = procedimento.fk_item_despesa
	 ORDER BY id DESC
	) AS itemDespesa
where linha.fk_retorno_glosa = 20 and linha.registro_ativo = 1
