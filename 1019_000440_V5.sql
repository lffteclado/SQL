SELECT procedimento.id AS id_procedimento
	        ,linha.id AS id_linha
			,SUM(situacaoProcedimento.valorGlosado) AS valor_glosado
	FROM tb_atendimento atendimento
	INNER JOIN tb_procedimento procedimento ON( atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1 and procedimento.registro_ativo = 1)
	INNER JOIN tb_arquivo_retorno_glosa linha ON(RTRIM(LTRIM(linha.campo_comparacao)) = atendimento.numero_guia and linha.registro_ativo = 1)
	INNER JOIN tb_retorno_glosa arquivo ON(arquivo.id = linha.fk_retorno_glosa and arquivo.registro_ativo = 1)
	INNER JOIN tb_glosa glosa ON(glosa.fk_procedimento = procedimento.id and glosa.registro_ativo = 1)
	INNER JOIN tb_carta_glosa carta ON(glosa.fk_carta_glosa = carta.id and carta.registro_ativo = 1)
	INNER JOIN rl_situacao_procedimento situacaoProcedimento ON(situacaoProcedimento.fk_procedimento = procedimento.id and situacaoProcedimento.glosado = 1)
	INNER JOIN rl_entidade_convenio entidadeConvenio ON(entidadeConvenio.id = atendimento.fk_convenio and entidadeConvenio.fk_convenio = arquivo.fk_convenio)
	CROSS APPLY(
		SELECT item.id, item.codigo FROM tb_item_despesa item
		WHERE procedimento.fk_item_despesa = item.id
	) AS itemDespesa
	WHERE linha.fk_retorno_glosa = 8
      AND procedimento.data_realizacao = linha.data_realizacao
	  AND itemDespesa.codigo = linha.codigo_item_despesa
	  AND glosa.situacao in (3,7)
	  AND arquivo.tipo_comparacao = 1 --guia
	  AND entidadeConvenio.fk_entidade = arquivo.fk_entidade
	  AND linha.valor_recursado = situacaoProcedimento.valorGlosado
	  --AND situacaoProcedimento.valorGlosado BETWEEN (linha.valor_pago_recurso - arquivo.diferenca)
	    --   AND (linha.valor_pago_recurso + arquivo.diferenca)
	GROUP BY procedimento.id, linha.id