	SELECT *, ROW_NUMBER() OVER(PARTITION BY id_procedimento, id_linha ORDER BY id_procedimento) AS ordem, 1 AS situacao --Não Processado
		 INTO #tempProcedimento FROM (
			SELECT procedimento.id AS id_procedimento
	        ,linha.id AS id_linha
			,SUM(situacaoProcedimento.valorGlosado) AS valor_glosado
	FROM tb_atendimento atendimento
	INNER JOIN tb_procedimento procedimento ON( atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1 and procedimento.registro_ativo = 1)
	INNER JOIN tb_arquivo_retorno_glosa linha ON(atendimento.numero_guia = linha.campo_comparacao and linha.registro_ativo = 1)
	INNER JOIN tb_retorno_glosa arquivo ON(arquivo.id = linha.fk_retorno_glosa and arquivo.registro_ativo = 1)
	INNER JOIN tb_glosa glosa ON(glosa.fk_procedimento = procedimento.id and glosa.registro_ativo = 1)
	INNER JOIN tb_carta_glosa carta ON(glosa.fk_carta_glosa = carta.id and carta.registro_ativo = 1)
	INNER JOIN rl_situacao_procedimento situacaoProcedimento ON(situacaoProcedimento.fk_procedimento = procedimento.id and situacaoProcedimento.glosado = 1)
	INNER JOIN rl_entidade_convenio entidadeConvenio ON(entidadeConvenio.id = atendimento.fk_convenio and entidadeConvenio.fk_convenio = arquivo.fk_convenio)
	CROSS APPLY(
		SELECT item.id, item.codigo FROM tb_item_despesa item
		WHERE procedimento.fk_item_despesa = item.id
	) AS itemDespesa
	WHERE linha.fk_retorno_glosa = 36
      AND procedimento.data_realizacao = linha.data_realizacao
	  AND itemDespesa.codigo = linha.codigo_item_despesa
	  AND glosa.situacao in (3,7)
	  AND entidadeConvenio.fk_entidade = 6
	  AND situacaoProcedimento.valorGlosado BETWEEN (linha.valor_pago_recurso - arquivo.diferenca)
	       AND (linha.valor_pago_recurso + arquivo.diferenca)
	GROUP BY procedimento.id, linha.id) as tabela

	--Faz o update no final dos procedimentos encontrados porém não processados
	UPDATE linha
		SET linha.fk_procedimento = procedimento.id,
			linha.status_processamento = 3 --Encontrado e não processado
	FROM tb_arquivo_retorno_glosa linha
	INNER JOIN #tempProcedimento tmpProcedimento ON(tmpProcedimento.id_linha = linha.id)
	INNER JOIN tb_procedimento procedimento ON(tmpProcedimento.id_procedimento = procedimento.id)
	WHERE tmpProcedimento.ordem = 1

	--Tabela para procedimentos encontrados e processados, ou seja o valor glosado e pago estão dentro de range parametrizado
	SELECT tmpProcedimento.id_procedimento, 
		   tmpProcedimento.id_linha, 
		   tmpProcedimento.valor_glosado, 
		   linha.fk_retorno_glosa 
		   INTO #tempProcedimentoProcessado
	FROM #tempProcedimento tmpProcedimento
	INNER JOIN tb_arquivo_retorno_glosa linha ON(linha.id = tmpProcedimento.id_linha)
	INNER JOIN tb_retorno_glosa arquivo ON(arquivo.id = linha.fk_retorno_glosa)
	WHERE linha.valor_pago_recurso between (tmpProcedimento.valor_glosado - arquivo.diferenca)
	       and (tmpProcedimento.valor_glosado + arquivo.diferenca)

	 --Fazer update de processado na linha
	UPDATE linha 
		SET linha.fk_procedimento = procedimento.id,
			linha.status_processamento = 0 --Processado
	FROM tb_arquivo_retorno_glosa linha 
	INNER JOIN #tempProcedimentoProcessado tmpProcedimento ON(tmpProcedimento.id_linha = linha.id)
	INNER JOIN tb_procedimento procedimento ON(procedimento.id = tmpProcedimento.id_procedimento)

	--Fazer update das glosas dos procedimentos processados RECEBIDA("Recebida", "4"),
	UPDATE glosa 
		SET glosa.situacao = 4
	FROM #tempProcedimentoProcessado procedimentoProcessado
	INNER JOIN tb_glosa glosa ON(glosa.fk_procedimento = procedimentoProcessado.id_procedimento)

	--Remover os procedimentos processados
	DELETE tmpProcedimento
	FROM #tempProcedimento tmpProcedimento
	INNER JOIN #tempProcedimentoProcessado procedimentoProcessado ON(procedimentoProcessado.id_procedimento = tmpProcedimento.id_procedimento)

	--Fazer update de linhas com procedimentos não encontrados
	UPDATE linha 
		SET linha.status_processamento = 2 --Não encontrado
	FROM tb_arquivo_retorno_glosa linha 
	WHERE linha.fk_procedimento IS NULL
		AND linha.status_processamento = 1
		AND linha.fk_retorno_glosa = 36

select * from #tempProcedimento

select * from #tempProcedimentoProcessado

DROP TABLE #tempProcedimento
DROP TABLE #tempProcedimentoProcessado
