Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[processarRetornoConvenio] (
  @idArquivo BIGINT,
  @idUsuarioProcessamento  BIGINT )
  as
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY  
	
	SELECT *, ROW_NUMBER() OVER(PARTITION BY id_linha ORDER BY id_atendimento) AS ordem, 1 AS situacao --Não Processado
	 INTO #tempAtendimento FROM (
	SELECT atendimento.id AS id_atendimento, linha.id AS id_linha, SUM(situacaoProcedimento.valorEspelhado) AS valor_espelhado
	FROM tb_retorno_convenio arquivo
	INNER JOIN tb_arquivo_retorno_convenio linha 
		ON(linha.fk_retorno_convenio = arquivo.id AND linha.registro_ativo=1 AND linha.fk_atendimento IS NULL AND linha.status_processamento = 1)
	INNER JOIN rl_entidade_convenio entidadeConvenio 
		ON(entidadeConvenio.fk_convenio = arquivo.fk_convenio 
			AND entidadeConvenio.fk_entidade = arquivo.fk_entidade 
			AND entidadeConvenio.registro_ativo = 1)
	INNER JOIN tb_atendimento atendimento 
		ON(atendimento.fk_convenio = entidadeConvenio.id 
			AND atendimento.faturar = 0
			AND atendimento.fk_espelho IS NOT NULL
			AND atendimento.registro_ativo=1)
	INNER JOIN tb_procedimento procedimento 
		ON(procedimento.fk_atendimento = atendimento.id 
			AND procedimento.registro_ativo=1)
	INNER JOIN rl_situacao_procedimento situacaoProcedimento ON (situacaoProcedimento.fk_procedimento = procedimento.id AND situacaoProcedimento.espelhado = 1)
	WHERE arquivo.registro_ativo=1
		AND arquivo.processado = 0
		AND arquivo.tipo_comparacao = 0 --senha
		AND linha.campo_comparacao = atendimento.senha
		AND arquivo.id = @idArquivo
	GROUP BY atendimento.id,linha.id
	
	UNION 
	
	SELECT atendimento.id, linha.id AS id_linha, SUM(situacaoProcedimento.valorEspelhado) AS valor_espelhado
	FROM tb_retorno_convenio arquivo
	INNER JOIN tb_arquivo_retorno_convenio linha 
		ON(linha.fk_retorno_convenio = arquivo.id AND linha.registro_ativo=1 AND linha.fk_atendimento IS NULL AND linha.status_processamento = 1)
	INNER JOIN rl_entidade_convenio entidadeConvenio 
		ON(entidadeConvenio.fk_convenio = arquivo.fk_convenio 
			AND entidadeConvenio.fk_entidade = arquivo.fk_entidade 
			AND entidadeConvenio.registro_ativo = 1)
	INNER JOIN tb_atendimento atendimento 
		ON(atendimento.fk_convenio = entidadeConvenio.id 
			AND atendimento.faturar = 0
			AND atendimento.fk_espelho IS NOT NULL
			AND atendimento.registro_ativo=1)
	INNER JOIN tb_procedimento procedimento 
		ON(procedimento.fk_atendimento = atendimento.id 
			AND procedimento.registro_ativo=1)
	INNER JOIN rl_situacao_procedimento situacaoProcedimento ON (situacaoProcedimento.fk_procedimento = procedimento.id AND situacaoProcedimento.espelhado = 1)
	WHERE arquivo.registro_ativo=1
		AND arquivo.processado = 0
		AND arquivo.tipo_comparacao = 1 --Guia
		AND RTRIM(LTRIM(linha.campo_comparacao)) = atendimento.numero_guia
		AND arquivo.id = @idArquivo
	GROUP BY atendimento.id,linha.id
	
	UNION 
	
	SELECT atendimento.id, linha.id AS id_linha, SUM(situacaoProcedimento.valorEspelhado) AS valor_espelhado
	FROM tb_retorno_convenio arquivo
	INNER JOIN tb_arquivo_retorno_convenio linha 
		ON(linha.fk_retorno_convenio = arquivo.id AND linha.registro_ativo=1 AND linha.fk_atendimento IS NULL AND linha.status_processamento = 1)
	INNER JOIN rl_entidade_convenio entidadeConvenio 
		ON(entidadeConvenio.fk_convenio = arquivo.fk_convenio 
			AND entidadeConvenio.fk_entidade = arquivo.fk_entidade 
			AND entidadeConvenio.registro_ativo = 1)
	INNER JOIN tb_atendimento atendimento 
		ON(atendimento.fk_convenio = entidadeConvenio.id 
			AND atendimento.faturar = 0
			AND atendimento.fk_espelho IS NOT NULL
			AND atendimento.registro_ativo=1)
	INNER JOIN tb_procedimento procedimento 
		ON(procedimento.fk_atendimento = atendimento.id 
			AND procedimento.registro_ativo=1)
	INNER JOIN rl_situacao_procedimento situacaoProcedimento ON (situacaoProcedimento.fk_procedimento = procedimento.id AND situacaoProcedimento.espelhado = 1)
	WHERE arquivo.registro_ativo=1
		AND arquivo.processado = 0
		AND arquivo.tipo_comparacao = 1 --Guia
		AND RTRIM(LTRIM(linha.campo_comparacao))= atendimento.guia_principal
		AND arquivo.id = @idArquivo
	GROUP BY atendimento.id,linha.id) tabela
	
	
	-- Tabela para salvar mais de um atendimento por linha do arquivo
	SELECT id_linha INTO #tempMaisDeUmAtendimentoPorLinha
	FROM #tempAtendimento
	WHERE situacao = 1
	AND ordem > 1
	GROUP BY id_linha
	
	
	
	
	-- Cria uma novo registro de linha para os atendimento em segunda ordem em diante
	SELECT linha.campo_comparacao, 
		   linha.valor, 
		   3 AS 'status_processamento', 
		   atendimento.id_atendimento, 
		   linha.fk_retorno_convenio 
		INTO #tempNovosRegistroDeLinha
	FROM #tempAtendimento atendimento
	INNER JOIN #tempMaisDeUmAtendimentoPorLinha linhaTemp ON(linhaTemp.id_linha = atendimento.id_linha)
	INNER JOIN tb_arquivo_retorno_convenio linha ON(linha.id = linhaTemp.id_linha)
	WHERE atendimento.ordem > 1
	
	--Faz o insert no final dos novos registros de linha - atendimentos encontrados porém não processados
	INSERT INTO tb_arquivo_retorno_convenio (campo_comparacao, valor, status_processamento, fk_atendimento, fk_retorno_convenio)
	SELECT campo_comparacao,
		   valor,
		   status_processamento,
		   id_atendimento, 
		   fk_retorno_convenio
	FROM #tempNovosRegistroDeLinha
	
	
	--Faz o update no final dos atendimentos encontrados porém não processados
	UPDATE linha 
		SET linha.fk_atendimento = atendimento.id_atendimento,
			linha.status_processamento = 3 --Encontrado e não processado		
	FROM tb_arquivo_retorno_convenio linha 
	INNER JOIN #tempMaisDeUmAtendimentoPorLinha linhaTemp ON(linhaTemp.id_linha = linha.id)
	INNER JOIN #tempAtendimento atendimento ON(atendimento.id_linha = linhaTemp.id_linha)
	WHERE atendimento.ordem = 1
	
	
	DELETE atendimento
	FROM #tempAtendimento atendimento
	INNER JOIN #tempMaisDeUmAtendimentoPorLinha linha ON(linha.id_linha = atendimento.id_linha)
	
	
	
	SELECT atendimento.id_atendimento, 
		   atendimento.id_linha, 
		   atendimento.valor_espelhado, 
		   linha.fk_retorno_convenio 
		   INTO #tempAtendimentosProcessado
	FROM #tempAtendimento atendimento
	INNER JOIN tb_arquivo_retorno_convenio linha ON(linha.id = atendimento.id_linha)
	INNER JOIN tb_retorno_convenio arquivo ON(arquivo.id = linha.fk_retorno_convenio)
	WHERE linha.valor BETWEEN (atendimento.valor_espelhado + arquivo.valor_intervalo_inicial) AND (atendimento.valor_espelhado + arquivo.valor_intervalo_final)
	
	--Fazer update de processado na linha
	UPDATE linha 
		SET linha.fk_atendimento = atendimento.id_atendimento,
			linha.status_processamento = 0 --Processado
	FROM tb_arquivo_retorno_convenio linha 
	INNER JOIN #tempAtendimentosProcessado atendimento ON(atendimento.id_linha = linha.id)
	
	--Fazer update de faturar dos atendimentos processados
	UPDATE atendimento 
		SET atendimento.faturar = 1
	FROM #tempAtendimentosProcessado atendimentoProcessado 
	INNER JOIN tb_atendimento atendimento ON(atendimento.id = atendimentoProcessado.id_atendimento)
	
	--Deletar itens Processados
	DELETE atendimento
	FROM #tempAtendimento atendimento
	INNER JOIN #tempAtendimentosProcessado atendimentoProcessado ON(atendimentoProcessado.id_atendimento = atendimento.id_atendimento)
	
	
	--Fazer o update de linhas Encontradas, porém não processadas porque não está dentro do range de valor
	UPDATE linha 
		SET linha.fk_atendimento = atendimento.id_atendimento,
			linha.status_processamento = 3 --Encontrado e não processado
	FROM tb_arquivo_retorno_convenio linha 
	INNER JOIN #tempAtendimento atendimento ON(atendimento.id_linha = linha.id)
	
	
	--Fazer update de linhas com atendimentos não encontrados
	UPDATE linha 
		SET linha.status_processamento = 2 --Não encontrado
	FROM tb_arquivo_retorno_convenio linha 
	WHERE linha.fk_atendimento IS NULL
		AND linha.status_processamento = 1
		AND linha.fk_retorno_convenio = @idArquivo
	
	--Fazer update de arquivo Processado
	UPDATE arquivo 
		SET arquivo.processado = 1,
			arquivo.em_processamento = 0,
			arquivo.quantidade_processados = tabelaProcessado.quantidade,
			arquivo.valor_processado=tabelaProcessado.valor,
			arquivo.fk_usuario_processamento = @idUsuarioProcessamento,
			arquivo.data_processamento = getdate()
	FROM tb_retorno_convenio arquivo
	OUTER APPLY( 
		SELECT COUNT(*) AS quantidade, SUM(valor_espelhado) AS valor
		FROM #tempAtendimentosProcessado atendimentoProcessado) tabelaProcessado
	WHERE arquivo.id=@idArquivo
		AND arquivo.processado = 0
	
	
	
	drop table #tempAtendimento
	drop table #tempMaisDeUmAtendimentoPorLinha
	drop table #tempNovosRegistroDeLinha
	drop table #tempAtendimentosProcessado

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

END


-- Tabela para salvar procedimentos duplicados
	SELECT id_linha INTO #tempMaisDeUmProcedimentoPorLinha
	FROM #tempProcedimento
	WHERE situacao = 1
	AND ordem > 1
	GROUP BY id_linha

	-- Cria uma novo registro de linha para os atendimento em segunda ordem em diante
	SELECT linha.campo_comparacao, 
		   linha.valor_pago_recurso,
		   linha.valor_recursado, 
		   3 AS 'status_processamento', 
		   procedimento.id_procedimento, 
		   linha.fk_retorno_glosa
		INTO #tempNovosRegistroDeLinha
	FROM #tempProcedimento procedimento
	INNER JOIN #tempMaisDeUmProcedimentoPorLinha linhaTemp ON(linhaTemp.id_linha = procedimento.id_linha)
	INNER JOIN tb_arquivo_retorno_glosa linha ON(linha.id = linhaTemp.id_linha)
	WHERE procedimento.ordem > 1

	--Faz o insert no final dos novos registros de linha - procedimentos encontrados porém não processados
	INSERT INTO tb_arquivo_retorno_glosa (campo_comparacao, valor_pago_recurso, valor_recursado, status_processamento, fk_procedimento, fk_retorno_glosa)
	SELECT tempRegistro.campo_comparacao,
		   tempRegistro.valor_pago_recurso,
		   tempRegistro.valor_recursado,
		   tempRegistro.status_processamento,
		   procedimento.id, 
		   tempRegistro.fk_retorno_glosa
	FROM #tempNovosRegistroDeLinha tempRegistro
	INNER JOIN tb_procedimento procedimento ON(procedimento.id = tempRegistro.id_procedimento)






