	IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('sp_retorno_glosa'))
		BEGIN
			DROP PROCEDURE [dbo].[sp_retorno_glosa]
		END
	GO
	CREATE PROCEDURE [dbo].[sp_retorno_glosa] (
		@idArquivo BIGINT,
		@idUsuarioProcessamento  BIGINT )
	AS
	BEGIN

	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRY  

	SELECT *, ROW_NUMBER() OVER(PARTITION BY id_procedimento, id_linha ORDER BY id_procedimento) AS ordem, 1 AS situacao /*Não Processado*/
		 INTO #tempProcedimento FROM (
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
	WHERE linha.fk_retorno_glosa = @idArquivo
      AND procedimento.data_realizacao = linha.data_realizacao
	  AND itemDespesa.codigo = linha.codigo_item_despesa
	  AND glosa.situacao in (3,7)
	  AND arquivo.tipo_comparacao = 1 --guia
	  AND entidadeConvenio.fk_entidade = arquivo.fk_entidade
	  AND situacaoProcedimento.valorGlosado = linha.valor_recursado
	GROUP BY procedimento.id, linha.id

	UNION

	SELECT procedimento.id AS id_procedimento
	        ,linha.id AS id_linha
			,SUM(situacaoProcedimento.valorGlosado) AS valor_glosado
	FROM tb_atendimento atendimento
	INNER JOIN tb_procedimento procedimento ON( atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1 and procedimento.registro_ativo = 1)
	INNER JOIN tb_arquivo_retorno_glosa linha ON(RTRIM(LTRIM(linha.campo_comparacao)) = atendimento.senha and linha.registro_ativo = 1)
	INNER JOIN tb_retorno_glosa arquivo ON(arquivo.id = linha.fk_retorno_glosa and arquivo.registro_ativo = 1)
	INNER JOIN tb_glosa glosa ON(glosa.fk_procedimento = procedimento.id and glosa.registro_ativo = 1)
	INNER JOIN tb_carta_glosa carta ON(glosa.fk_carta_glosa = carta.id and carta.registro_ativo = 1)
	INNER JOIN rl_situacao_procedimento situacaoProcedimento ON(situacaoProcedimento.fk_procedimento = procedimento.id and situacaoProcedimento.glosado = 1)
	INNER JOIN rl_entidade_convenio entidadeConvenio ON(entidadeConvenio.id = atendimento.fk_convenio and entidadeConvenio.fk_convenio = arquivo.fk_convenio)
	CROSS APPLY(
		SELECT item.id, item.codigo FROM tb_item_despesa item
		WHERE procedimento.fk_item_despesa = item.id
	) AS itemDespesa
	WHERE linha.fk_retorno_glosa = @idArquivo
      AND procedimento.data_realizacao = linha.data_realizacao
	  AND itemDespesa.codigo = linha.codigo_item_despesa
	  AND glosa.situacao in (3,7)
	  AND entidadeConvenio.fk_entidade = arquivo.fk_entidade
	  AND arquivo.tipo_comparacao = 0 --senha
	  AND situacaoProcedimento.valorGlosado = linha.valor_recursado
	GROUP BY procedimento.id, linha.id
	
	UNION

	SELECT procedimento.id AS id_procedimento
	        ,linha.id AS id_linha
			,SUM(situacaoProcedimento.valorGlosado) AS valor_glosado
	FROM tb_atendimento atendimento
	INNER JOIN tb_procedimento procedimento ON( atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1 and procedimento.registro_ativo = 1)
	INNER JOIN tb_arquivo_retorno_glosa linha ON(RTRIM(LTRIM(linha.campo_comparacao)) = atendimento.guia_principal and linha.registro_ativo = 1)
	INNER JOIN tb_retorno_glosa arquivo ON(arquivo.id = linha.fk_retorno_glosa and arquivo.registro_ativo = 1)
	INNER JOIN tb_glosa glosa ON(glosa.fk_procedimento = procedimento.id and glosa.registro_ativo = 1)
	INNER JOIN tb_carta_glosa carta ON(glosa.fk_carta_glosa = carta.id and carta.registro_ativo = 1)
	INNER JOIN rl_situacao_procedimento situacaoProcedimento ON(situacaoProcedimento.fk_procedimento = procedimento.id and situacaoProcedimento.glosado = 1)
	INNER JOIN rl_entidade_convenio entidadeConvenio ON(entidadeConvenio.id = atendimento.fk_convenio and entidadeConvenio.fk_convenio = arquivo.fk_convenio)
	CROSS APPLY(
		SELECT item.id, item.codigo FROM tb_item_despesa item
		WHERE procedimento.fk_item_despesa = item.id
	) AS itemDespesa
	WHERE linha.fk_retorno_glosa = @idArquivo
      AND procedimento.data_realizacao = linha.data_realizacao
	  AND itemDespesa.codigo = linha.codigo_item_despesa
	  AND glosa.situacao in (3,7)
	  AND entidadeConvenio.fk_entidade = arquivo.fk_entidade
	  AND arquivo.tipo_comparacao = 1 --guia
	  AND situacaoProcedimento.valorGlosado = linha.valor_recursado
	GROUP BY procedimento.id, linha.id) as tabela

	--Tabela para procedimentos encontrados e processados, ou seja o valor glosado e pago estão dentro de range parametrizado
	SELECT tmpProcedimento.id_procedimento, 
		   tmpProcedimento.id_linha, 
		   tmpProcedimento.valor_glosado,
		   linha.valor_pago_recurso,
		   linha.fk_retorno_glosa 
		   INTO #tempProcedimentoProcessado
	FROM #tempProcedimento tmpProcedimento
	INNER JOIN tb_arquivo_retorno_glosa linha ON(linha.id = tmpProcedimento.id_linha and linha.registro_ativo = 1)
	INNER JOIN tb_retorno_glosa arquivo ON(arquivo.id = linha.fk_retorno_glosa and arquivo.registro_ativo = 1)
	WHERE linha.valor_pago_recurso between (tmpProcedimento.valor_glosado - arquivo.diferenca)
	       and (tmpProcedimento.valor_glosado + arquivo.diferenca)

	--Fazer update de processado na linha
	UPDATE linha 
		SET linha.fk_procedimento = procedimento.id,
			linha.status_processamento = 0, --Processado
			linha.fk_glosa = glosa.id
	FROM tb_arquivo_retorno_glosa linha 
	INNER JOIN #tempProcedimentoProcessado tmpProcedimento ON(tmpProcedimento.id_linha = linha.id)
	INNER JOIN tb_procedimento procedimento ON(procedimento.id = tmpProcedimento.id_procedimento and procedimento.registro_ativo = 1)
	INNER JOIN tb_glosa glosa ON(procedimento.id = glosa.fk_procedimento and glosa.registro_ativo = 1)

	--Faz o update no final dos procedimentos encontrados porém não processados
	UPDATE linha
		SET linha.fk_procedimento = procedimento.id,
			linha.status_processamento = 3 --Encontrado e não processado
	FROM tb_arquivo_retorno_glosa linha
	INNER JOIN #tempProcedimento tmpProcedimento ON(tmpProcedimento.id_linha = linha.id)
	INNER JOIN tb_procedimento procedimento ON(tmpProcedimento.id_procedimento = procedimento.id and procedimento.registro_ativo = 1)
	WHERE tmpProcedimento.ordem = 1	AND linha.status_processamento = 1	

	--Atualiza as glosas dos procedimentos processados RECEBIDA("Recebida", "4"):
	UPDATE glosa
		SET glosa.situacao = 4, -- Recebida
		glosa.valor_recebido = COALESCE(procedimentoProcessado.valor_pago_recurso,0),
		glosa.fk_usuario_ultima_alteracao = @idUsuarioProcessamento,
		glosa.sql_update = ISNULL(glosa.sql_update,'')+'Processado Via Retorno de Glosa',
		glosa.data_ultima_alteracao = GETDATE(),
		glosa.data_recebimento = CONVERT(DATE, GETDATE())
	FROM #tempProcedimentoProcessado procedimentoProcessado
	INNER JOIN tb_glosa glosa ON(glosa.fk_procedimento = procedimentoProcessado.id_procedimento and glosa.registro_ativo = 1)
	INNER JOIN tb_carta_glosa carta ON(carta.id = glosa.fk_carta_glosa and carta.registro_ativo = 1)
	WHERE glosa.situacao in (3,7)

	--Atualiza as carta de glosas dos procedimentos processados:
	UPDATE carta
		SET carta.data_ultima_alteracao = GETDATE(),
		carta.fk_usuario_ultima_alteracao = @idUsuarioProcessamento,
		carta.sql_update = ISNULL(carta.sql_update,'')+'Processado Via Retorno de Glosa'
	FROM #tempProcedimentoProcessado procedimentoProcessado
	INNER JOIN tb_glosa glosa ON(glosa.fk_procedimento = procedimentoProcessado.id_procedimento and glosa.registro_ativo = 1)
	INNER JOIN tb_carta_glosa carta ON(carta.id = glosa.fk_carta_glosa and carta.registro_ativo = 1)

	--Atualizando os Procedimentos Processados para Faturar
	UPDATE procedimento
	   SET procedimento.faturar = 1,
	       procedimento.data_ultima_alteracao = GETDATE(),
		   procedimento.fk_usuario_ultima_alteracao = @idUsuarioProcessamento,
		   procedimento.sql_update = ISNULL(procedimento.sql_update,'')+'Processado Via Retorno de Glosa'
	FROM tb_procedimento procedimento
	INNER JOIN #tempProcedimentoProcessado procedimentoProcessado ON(procedimentoProcessado.id_procedimento = procedimento.id and procedimento.registro_ativo = 1)

	--Atualizando os Atendimentos Processados para Faturar
	UPDATE atendimento
		SET atendimento.faturar = 1,
		    atendimento.data_ultima_alteracao = GETDATE(),
			atendimento.fk_usuario_ultima_alteracao = @idUsuarioProcessamento,
			atendimento.sql_update = ISNULL(atendimento.sql_update,'')+'Processado Via Retorno de Glosa'
	FROM tb_atendimento atendimento
	INNER JOIN tb_procedimento procedimentos ON(procedimentos.fk_atendimento = atendimento.id and atendimento.registro_ativo = 1)
	INNER JOIN #tempProcedimentoProcessado procedimentoProcessado ON(procedimentoProcessado.id_procedimento = procedimentos.id and procedimentos.registro_ativo = 1)

	--Fazer update de linhas com procedimentos não encontrados
	UPDATE linha 
		SET linha.status_processamento = 2 --Não encontrado
	FROM tb_arquivo_retorno_glosa linha 
	WHERE linha.fk_procedimento IS NULL
		AND linha.status_processamento = 1
		AND linha.fk_retorno_glosa = @idArquivo

	--Cartas de Glosas para atualizar a tabela pagamento procedimento
	SELECT carta.id AS id_numero_carta,
       0 AS 'finalizado'
	INTO #tempCartasGlosa
	FROM tb_carta_glosa carta
	INNER JOIN tb_glosa glosa on (glosa.fk_carta_glosa = carta.id and carta.registro_ativo = 1)
	INNER JOIN #tempProcedimentoProcessado processado on (processado.id_procedimento = glosa.fk_procedimento and glosa.registro_ativo = 1)

	BEGIN
		WHILE EXISTS(SELECT 1 FROM #tempCartasGlosa WHERE finalizado = 0)
			BEGIN

				DECLARE @RC int
				DECLARE @idEspelho bigint
				DECLARE @idAtendimento bigint
				DECLARE @idCartaDeGlosa bigint = (SELECT TOP 1 id_numero_carta FROM #tempCartasGlosa where finalizado = 0)

				DECLARE @usuario bigint = @idUsuarioProcessamento

				EXECUTE @RC = [dbo].[gerarPagamentoProcedimentoPorEspelho] 
				@idEspelho
				,@idAtendimento
				,@idCartaDeGlosa
				,@usuario

				UPDATE #tempCartasGlosa
					SET finalizado = 1
				WHERE id_numero_carta = @idCartaDeGlosa

			END;
	END;

	--Remover os procedimentos processados
	DELETE tmpProcedimento
	FROM #tempProcedimento tmpProcedimento
	INNER JOIN #tempProcedimentoProcessado procedimentoProcessado ON(procedimentoProcessado.id_procedimento = tmpProcedimento.id_procedimento)

	--Fazer update de arquivo Processado
	UPDATE arquivo 
		SET arquivo.processado = 1,
			arquivo.em_processamento = 0,
			arquivo.quantidade_processados = tabelaProcessado.quantidade,
			arquivo.valor_processado=tabelaProcessado.valor,
			arquivo.fk_usuario_processamento = @idUsuarioProcessamento,
			arquivo.data_processamento = GETDATE()
	FROM tb_retorno_glosa arquivo
	OUTER APPLY( 
		SELECT COUNT(*) AS quantidade, SUM(valor_glosado) AS valor
		FROM #tempProcedimentoProcessado procedimentoProcessado) tabelaProcessado
	WHERE arquivo.id= @idArquivo
		AND arquivo.processado = 0

	DROP TABLE #tempProcedimento
	DROP TABLE #tempProcedimentoProcessado
	DROP TABLE #tempCartasGlosa

	COMMIT TRANSACTION;  
	END TRY  
	BEGIN CATCH 

    IF (XACT_STATE()) = -1  
    BEGIN  
        ROLLBACK TRANSACTION;  
    END;  
    IF (XACT_STATE()) = 1  
    BEGIN  
        COMMIT TRANSACTION;     
    END;  

		END CATCH 

	END;