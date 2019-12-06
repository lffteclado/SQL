CREATE PROCEDURE [dbo].[gerarPagamentoProcedimentoPorEspelho] (
	@idEspelho BIGINT
	,@idAtendimento BIGINT
	,@idCartaDeGlosa BIGINT
	,@usuario BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRY
		BEGIN TRANSACTION;

		DECLARE @table table(id bigint);

		WITH CTEEspelho(id)
		AS(
			SELECT atendimento.id
			FROM tb_atendimento atendimento
			WHERE @idEspelho IS NOT NULL
				AND atendimento.registro_ativo = 1
				AND atendimento.fk_espelho = @idEspelho
		
		),CTEAtendimento(id)
		AS(
			SELECT atendimento.id
			FROM tb_atendimento atendimento
			WHERE @idAtendimento IS NOT NULL
				AND atendimento.registro_ativo = 1
				AND atendimento.id = @idAtendimento
		
		),CTECartaDeGlosa(id)
		AS(
			SELECT atendimento.id
			FROM tb_atendimento atendimento
			WHERE @idCartaDeGlosa IS NOT NULL
				AND atendimento.registro_ativo = 1
				AND atendimento.fk_espelho IS NOT NULL
				AND EXISTS (
					SELECT 1
					FROM tb_procedimento procedimento
					INNER JOIN tb_glosa glosa ON (
							glosa.fk_procedimento = procedimento.id
							AND glosa.registro_ativo = 1
							)
					WHERE procedimento.fk_atendimento = atendimento.id
						AND procedimento.registro_ativo = 1
						AND glosa.fk_carta_glosa = @idCartaDeGlosa
					)
		
		), CTETodos(id)
		AS(
			SELECT * FROM CTEEspelho
			UNION ALL
			SELECT * FROM CTEAtendimento
			UNION ALL
			SELECT * FROM CTECartaDeGlosa)
		 

		INSERT INTO @table
		SELECT * FROM CTETodos

		-- Cria registros de pagamento procedimento com valor zerado caso não existam
		INSERT INTO tb_pagamento_procedimento (
			resolveu_dependencia
			,data_criacao
			,data_ultima_alteracao
			,fk_procedimento
			,fk_usuario_ultima_alteracao
			,registro_ativo
			,valor_honorario
			,valor_acrescimo
			,valor_custo_operacional
			,valor_desconto
			,valor_filme
			,fk_fatura
			,sql_update,
			valor_acrescimo_convenio
			)

		SELECT 0, getDate(), getDate(), procedimento.id, 1, 1,

			0 AS 'valorHonorario',
			0 AS 'valorAcrescimo',
			0 AS 'valorCustoOperacional',
			0 AS 'valorDesconto',
			0 AS 'valorFilme',
			NULL,
			'3780',
			0 as 'valorAcrescimoConvenio'
		
		FROM tb_procedimento procedimento
		INNER JOIN tb_atendimento atendimento 
			ON (atendimento.id = procedimento.fk_atendimento AND atendimento.registro_ativo = 1 
				AND atendimento.fk_espelho IS NOT NULL)
		INNER JOIN @table TabelaTemporariaAtendimentos 
			ON (TabelaTemporariaAtendimentos.id = atendimento.id)
	    WHERE NOT EXISTS (
			select id from tb_pagamento_procedimento where registro_ativo = 1 and fk_procedimento = procedimento.id and fk_fatura is null)
		

		-- Cria Tabela Temporária para receber os novos valores de pagamento
		
		CREATE TABLE #TabelaTemporariaPagamentos (idProcedimento BIGINT , valorHonorario NUMERIC(19,2), valorAcrescimo NUMERIC(19,2), valorCustoOperacional NUMERIC(19,2),
		valorFilme NUMERIC(19,2))
		BEGIN
			INSERT INTO #TabelaTemporariaPagamentos
			SELECT procedimento.id,
			SUM(COALESCE(procedimento.valor_honorario, 0)) +
			SUM(COALESCE(procedimento.valor_acrescimo_convenio, 0)) - 
			SUM(COALESCE(procedimento.valor_desconto,0)) - 
			(COALESCE(pagamento.valor_honorario, 0) +
			COALESCE(pagamento.valor_acrescimo_convenio, 0) - 
			ABS(COALESCE(pagamento.valor_desconto, 0)))-
			(COALESCE(glosa.valor_honorario, 0) - 
			COALESCE(glosa.valor_desconto,0))
			 AS 'valorHonorario',
			SUM(COALESCE(procedimento.valor_acrescimo, 0)) - 
			COALESCE(pagamento.valor_acrescimo, 0) - 
			COALESCE(glosa.valor_acrescimo, 0) 
			AS 'valorAcrescimo',
			SUM(COALESCE(procedimento.valor_custo_operacional, 0)) - 
			COALESCE(pagamento.valor_custo_operacional, 0) - 
			COALESCE(glosa.valor_custo_operacional, 0) 
			AS 'valorCustoOperacional',
			SUM(COALESCE(procedimento.valor_filme, 0)) - 
			COALESCE(pagamento.valor_filme, 0) - 
			COALESCE(glosa.valor_filme, 0) 
			AS 'valorFilme'
		
		FROM tb_procedimento procedimento
		INNER JOIN tb_atendimento atendimento 
			ON (atendimento.id = procedimento.fk_atendimento AND atendimento.registro_ativo = 1 
				AND atendimento.fk_espelho IS NOT NULL)
		INNER JOIN @table TabelaTemporariaAtendimentos 
			ON (TabelaTemporariaAtendimentos.id = atendimento.id)
		OUTER APPLY (
			SELECT 
				  SUM(COALESCE(pagamentoFaturado.valor_honorario,0)) AS 'valor_honorario',
				  SUM(ABS(COALESCE(pagamentoFaturado.valor_desconto, 0))) AS 'valor_desconto',
				  SUM(COALESCE(pagamentoFaturado.valor_custo_operacional,0)) AS 'valor_custo_operacional',
				  SUM(COALESCE(pagamentoFaturado.valor_filme,0)) AS 'valor_filme',
				  SUM(COALESCE(pagamentoFaturado.valor_acrescimo,0)) AS 'valor_acrescimo',
				  SUM(COALESCE(pagamentoFaturado.valor_acrescimo_convenio,0)) AS 'valor_acrescimo_convenio',
				  pagamentoFaturado.fk_procedimento
			FROM tb_pagamento_procedimento pagamentoFaturado
			WHERE pagamentoFaturado.fk_procedimento = procedimento.id
				AND pagamentoFaturado.registro_ativo = 1
				AND fk_fatura IS NOT NULL
			GROUP BY pagamentoFaturado.fk_procedimento
			HAVING 
				  (SUM(COALESCE(pagamentoFaturado.valor_honorario,0)) -
				  SUM(ABS(COALESCE(pagamentoFaturado.valor_desconto, 0))) +
				  SUM(COALESCE(pagamentoFaturado.valor_custo_operacional,0)) +
				  SUM(COALESCE(pagamentoFaturado.valor_filme,0)) +
				  SUM(COALESCE(pagamentoFaturado.valor_acrescimo,0))) > 0
			) pagamento
		OUTER APPLY (
			SELECT sum(coalesce(valor_honorario,0)) as valor_honorario,
			sum(coalesce(valor_acrescimo,0)) as valor_acrescimo,
			sum(coalesce(valor_custo_operacional,0)) as valor_custo_operacional,
			sum(coalesce(valor_filme,0)) as valor_filme,
			sum(coalesce(valor_desconto,0))as valor_desconto		   
			FROM tb_glosa ultimaGlosa
			WHERE ultimaGlosa.fk_procedimento = procedimento.id
				AND ultimaGlosa.registro_ativo = 1
				AND ultimaGlosa.situacao IN (0,1,2,3,7)
			) glosa
		WHERE procedimento.registro_ativo = 1
			AND atendimento.situacaoAtendimento IN (1,2,3,4)
		GROUP BY procedimento.id
			,glosa.valor_honorario
			,glosa.valor_desconto
			,glosa.valor_acrescimo
			,glosa.valor_custo_operacional
			,glosa.valor_filme
			,procedimento.forcar_atendimento
			,pagamento.valor_honorario
			,pagamento.valor_acrescimo
			,pagamento.valor_custo_operacional
			,pagamento.valor_filme
			,pagamento.valor_desconto
			,pagamento.valor_acrescimo_convenio
		END

		select * from #TabelaTemporariaPagamentos

		-- Atualiza os registros de pagamento com os novos valores

		UPDATE pagProced
		 SET pagProced.fk_procedimento = TabelaTemporariaPagamentos.idProcedimento,
		     pagProced.valor_honorario = TabelaTemporariaPagamentos.valorHonorario,		 
		     pagProced.valor_acrescimo = TabelaTemporariaPagamentos.valorAcrescimo,
		     pagProced.valor_custo_operacional = TabelaTemporariaPagamentos.valorCustoOperacional,
		     pagProced.valor_desconto = 0,		
		     pagProced.valor_filme = TabelaTemporariaPagamentos.valorFilme,
		     pagProced.valor_acrescimo_convenio = 0
		
		FROM tb_pagamento_procedimento pagProced
		INNER JOIN #TabelaTemporariaPagamentos TabelaTemporariaPagamentos 
			ON (TabelaTemporariaPagamentos.idProcedimento = pagProced.fk_procedimento)

			WHERE pagProced.fk_fatura IS NULL
			AND pagProced.registro_ativo = 1	


		COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		IF (XACT_STATE()) = - 1
		BEGIN
			ROLLBACK TRANSACTION;
		END;

		IF (XACT_STATE()) = 1
		BEGIN
			COMMIT TRANSACTION;
		END;
	END CATCH
END

