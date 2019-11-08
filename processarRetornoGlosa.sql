/*IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('processarRetornoGlosa'))
BEGIN
	DROP PROCEDURE [dbo].[processarRetornoGlosa]
END
GO
CREATE PROCEDURE [dbo].[processarRetornoGlosa] (
  @idArquivo BIGINT,
  @idUsuarioProcessamento  BIGINT )
  as
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY  

*/

	SELECT *, ROW_NUMBER() OVER(PARTITION BY id_linha ORDER BY id_procedimento) AS ordem, 1 AS situacao --Não Processado
	 INTO #tempProcedimento FROM (
		SELECT procedimento.id AS id_procedimento
	       ,linha.id AS id_linha
		   ,SUM(situacaoProcedimento.valorEspelhado) AS valor_espelhado
	FROM tb_retorno_glosa arquivo
	INNER JOIN tb_arquivo_retorno_glosa linha
		ON(linha.fk_retorno_glosa = arquivo.id AND linha.registro_ativo=1 AND linha.fk_procedimento IS NULL AND linha.status_processamento = 1)
	INNER JOIN rl_entidade_convenio entidadeConvenio
		ON(entidadeConvenio.fk_convenio = arquivo.fk_convenio
			AND entidadeConvenio.fk_entidade = arquivo.fk_entidade
			AND entidadeConvenio.registro_ativo = 1)
	CROSS APPLY (
	 SELECT TOP 1 item.id FROM tb_item_despesa item
	 INNER JOIN tb_procedimento pro ON (pro.fk_item_despesa = item.id)
	 WHERE codigo = linha.codigo_item_despesa and pro.data_realizacao = linha.data_realizacao
	 ORDER BY id DESC
	) AS itemDespesa
	INNER JOIN tb_procedimento procedimento
		ON(procedimento.fk_item_despesa = itemDespesa.id
		    AND procedimento.data_realizacao = linha.data_realizacao
			AND procedimento.registro_ativo=1)
    INNER JOIN tb_atendimento atendimento
		ON(atendimento.fk_convenio = entidadeConvenio.id 
			AND atendimento.faturar = 0
			AND atendimento.fk_espelho IS NOT NULL
			AND atendimento.registro_ativo=1)
	INNER JOIN rl_situacao_procedimento situacaoProcedimento ON (situacaoProcedimento.fk_procedimento = procedimento.id) --AND situacaoProcedimento.espelhado = 1
	WHERE arquivo.registro_ativo=1
	AND arquivo.processado = 0
	AND arquivo.tipo_comparacao = 1 --senha
	AND linha.campo_comparacao = atendimento.numero_guia
	AND arquivo.id = 20
	GROUP BY procedimento.id,linha.id
	
	UNION 
	
	SELECT atendimento.id AS id_atendimento
	       ,linha.id AS id_linha
		   ,SUM(situacaoProcedimento.valorEspelhado) AS valor_espelhado
	FROM tb_retorno_glosa arquivo
	INNER JOIN tb_arquivo_retorno_glosa linha 
		ON(linha.fk_retorno_glosa = arquivo.id AND linha.registro_ativo=1 AND linha.fk_procedimento IS NULL AND linha.status_processamento = 1)	
	INNER JOIN rl_entidade_convenio entidadeConvenio 
		ON(entidadeConvenio.fk_convenio = arquivo.fk_convenio
			AND entidadeConvenio.fk_entidade = arquivo.fk_entidade 
			AND entidadeConvenio.registro_ativo = 1)
	CROSS APPLY (
		 SELECT TOP 1 item.id FROM tb_item_despesa item
			INNER JOIN tb_procedimento pro ON (pro.fk_item_despesa = item.id)
		WHERE codigo = linha.codigo_item_despesa and pro.data_realizacao = linha.data_realizacao
		ORDER BY id DESC
	) AS itemDespesa
	INNER JOIN tb_atendimento atendimento 
		ON(atendimento.fk_convenio = entidadeConvenio.id 
			--AND atendimento.faturar = 0
			AND atendimento.fk_espelho IS NOT NULL
			AND atendimento.registro_ativo=1)
	INNER JOIN tb_procedimento procedimento 
		ON(procedimento.fk_atendimento = atendimento.id 
		    AND procedimento.data_realizacao = linha.data_realizacao
			AND procedimento.registro_ativo=1)
	INNER JOIN rl_situacao_procedimento situacaoProcedimento ON (situacaoProcedimento.fk_procedimento = procedimento.id) --AND situacaoProcedimento.espelhado = 1
	--INNER JOIN tb_item_despesa itemDespesa ON (procedimento.fk_item_despesa = itemDespesa.id and itemDespesa.registro_ativo = 1) 
	WHERE arquivo.registro_ativo=1
	AND arquivo.processado = 0
	AND arquivo.tipo_comparacao = 1 --guia
	AND RTRIM(LTRIM(linha.campo_comparacao)) = atendimento.numero_guia
	--AND linha.codigo_item_despesa = itemDespesa.codigo
	AND arquivo.id = 20
	GROUP BY atendimento.id,linha.id

	UNION 
	
	SELECT atendimento.id AS id_atendimento
	       ,linha.id AS id_linha
		   ,SUM(situacaoProcedimento.valorEspelhado) AS valor_espelhado
	FROM tb_retorno_glosa arquivo
	INNER JOIN tb_arquivo_retorno_glosa linha 
		ON(linha.fk_retorno_glosa = arquivo.id AND linha.registro_ativo=1 AND linha.fk_procedimento IS NULL AND linha.status_processamento = 1)	
	INNER JOIN rl_entidade_convenio entidadeConvenio 
		ON(entidadeConvenio.fk_convenio = arquivo.fk_convenio
			AND entidadeConvenio.fk_entidade = arquivo.fk_entidade 
			AND entidadeConvenio.registro_ativo = 1)
	CROSS APPLY (
		 SELECT TOP 1 item.id FROM tb_item_despesa item
			INNER JOIN tb_procedimento pro ON (pro.fk_item_despesa = item.id)
		WHERE codigo = linha.codigo_item_despesa and pro.data_realizacao = linha.data_realizacao
		ORDER BY id DESC
	) AS itemDespesa
	INNER JOIN tb_atendimento atendimento 
		ON(atendimento.fk_convenio = entidadeConvenio.id 
			--AND atendimento.faturar = 0
			AND atendimento.fk_espelho IS NOT NULL
			AND atendimento.registro_ativo=1)
	INNER JOIN tb_procedimento procedimento 
		ON(procedimento.fk_atendimento = atendimento.id 
		    AND procedimento.data_realizacao = linha.data_realizacao
			AND procedimento.registro_ativo=1)
	INNER JOIN rl_situacao_procedimento situacaoProcedimento ON (situacaoProcedimento.fk_procedimento = procedimento.id) --AND situacaoProcedimento.espelhado = 1
	--INNER JOIN tb_item_despesa itemDespesa ON (procedimento.fk_item_despesa = itemDespesa.id and itemDespesa.registro_ativo = 1) 
	WHERE arquivo.registro_ativo=1
	AND arquivo.processado = 0
	AND arquivo.tipo_comparacao = 1 --guia
	AND RTRIM(LTRIM(linha.campo_comparacao)) = atendimento.guia_principal
	--AND linha.codigo_item_despesa = itemDespesa.codigo
	AND arquivo.id = 20
	GROUP BY atendimento.id,linha.id) as tabela	

	select * from #tempProcedimento

	select * from #tempMaisDeUmProcedimentoPorLinha

	select * from #tempNovosRegistroDeLinha

	select * from #tempProcedimentoProcessado
	
	
	-- Tabela para salvar mais de um procedimento por linha do arquivo
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
	
	--Faz o insert no final dos novos registros de linha - atendimentos encontrados porém não processados
	INSERT INTO tb_arquivo_retorno_glosa (campo_comparacao, valor_pago_recurso, valor_recursado, status_processamento, fk_procedimento, fk_retorno_glosa)
	SELECT tempRegistro.campo_comparacao,
		   tempRegistro.valor_pago_recurso,
		   tempRegistro.valor_recursado,
		   tempRegistro.status_processamento,
		   procedimento.id, 
		   tempRegistro.fk_retorno_glosa
	FROM #tempNovosRegistroDeLinha tempRegistro
	INNER JOIN tb_procedimento procedimento ON(procedimento.fk_atendimento = tempRegistro.id_procedimento)
	
	--Faz o update no final dos procedimentos encontrados porém não processados
	UPDATE linha 
		SET linha.fk_procedimento = procedimento.id,
			linha.status_processamento = 3 --Encontrado e não processado			
	FROM tb_arquivo_retorno_glosa linha 
	INNER JOIN #tempMaisDeUmProcedimentoPorLinha linhaTemp ON(linhaTemp.id_linha = linha.id)
	INNER JOIN #tempProcedimento TmpProcedimento ON(TmpProcedimento.id_linha = linhaTemp.id_linha)
	INNER JOIN tb_procedimento procedimento ON(TmpProcedimento.id_procedimento = procedimento.fk_atendimento)
	WHERE TmpProcedimento.ordem = 1	
	
	DELETE procedimento
	FROM #tempProcedimento procedimento
	INNER JOIN #tempMaisDeUmProcedimentoPorLinha linha ON(linha.id_linha = procedimento.id_linha)	
	
	SELECT procedimento.id_procedimento, 
		   procedimento.id_linha, 
		   procedimento.valor_espelhado, 
		   linha.fk_retorno_glosa 
		   INTO #tempProcedimentoProcessado
	FROM #tempProcedimento procedimento
	INNER JOIN tb_arquivo_retorno_glosa linha ON(linha.id = procedimento.id_linha)
	INNER JOIN tb_retorno_glosa arquivo ON(arquivo.id = linha.fk_retorno_glosa)
	WHERE linha.valor_pago_recurso = (procedimento.valor_espelhado + arquivo.diferenca) --AND (atendimento.valor_espelhado + arquivo.valor_intervalo_final)
	
	--Fazer update de processado na linha
	UPDATE linha 
		SET linha.fk_procedimento = procedimento.id,
			linha.status_processamento = 0 --Processado
	FROM tb_arquivo_retorno_glosa linha 
	INNER JOIN #tempProcedimentoProcessado TmpProcedimento ON(TmpProcedimento.id_linha = linha.id)
	INNER JOIN tb_procedimento procedimento ON(procedimento.fk_atendimento = TmpProcedimento.id_procedimento)
	
	--Fazer update de faturar dos atendimentos processados
	UPDATE atendimento 
		SET atendimento.faturar = 1
	FROM #tempProcedimentoProcessado procedimentoProcessado
	INNER JOIN tb_procedimento procedimento ON(procedimentoProcessado.id_procedimento = procedimento.id)
	INNER JOIN tb_atendimento atendimento ON(atendimento.id = procedimento.fk_atendimento)
	
	--Deletar itens Processados
	DELETE procedimento
	FROM #tempProcedimento procedimento
	INNER JOIN #tempProcedimentoProcessado procedimentoProcessado ON(procedimentoProcessado.id_procedimento = procedimento.id_procedimento)
	
	
	--Fazer o update de linhas Encontradas, porém não processadas porque não está dentro do range de valor
	UPDATE linha 
		SET linha.fk_procedimento = procedimento.id,
			linha.status_processamento = 3 --Encontrado e não processado
	FROM tb_arquivo_retorno_glosa linha
	INNER JOIN #tempProcedimento tmpProcedimento ON(tmpProcedimento.id_linha = linha.id)
	INNER JOIN tb_procedimento procedimento ON(procedimento.id = tmpProcedimento.id_procedimento)
	
	
	--Fazer update de linhas com atendimentos não encontrados
	UPDATE linha 
		SET linha.status_processamento = 2 --Não encontrado
	FROM tb_arquivo_retorno_glosa linha 
	WHERE linha.fk_procedimento IS NULL
		AND linha.status_processamento = 1
		AND linha.fk_retorno_glosa = 12
	
	--Fazer update de arquivo Processado
	UPDATE arquivo 
		SET arquivo.processado = 1,
			arquivo.em_processamento = 0,
			arquivo.quantidade_processados = tabelaProcessado.quantidade,
			arquivo.valor_processado=tabelaProcessado.valor,
			arquivo.fk_usuario_processamento = 12,
			arquivo.data_processamento = getdate()
	FROM tb_retorno_convenio arquivo
	OUTER APPLY( 
		SELECT COUNT(*) AS quantidade, SUM(valor_espelhado) AS valor
		FROM #tempProcedimentoProcessado procedimentoProcessado) tabelaProcessado
	WHERE arquivo.id=12
		AND arquivo.processado = 0
	
	
	
	drop table #tempProcedimento
	GO
	drop table #tempMaisDeUmProcedimentoPorLinha
	GO
	drop table #tempNovosRegistroDeLinha
	GO
	drop table #tempProcedimentoProcessado

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