Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE  PROCEDURE [dbo].[consistirAtendimento] (
  @idEspelho  BIGINT,
  @idAtendimento  BIGINT,
  @idAtendimentoIN  VARCHAR(MAX),
  @idUsuario BIGINT,
  @idEntidade BIGINT,
  @idIntegracaoEntidade BIGINT,
  @idIntegracaoHospital bigint,
  @metodoAcionador VARCHAR(MAX))
  as
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY  
CREATE TABLE #TabelaTemporariaAtendimentos (id bigint, fk_entidade_convenio bigint)

IF(@idAtendimento is not null)
BEGIN
	
	INSERT INTO #TabelaTemporariaAtendimentos
	SELECT atendimento.id, atendimento.fk_convenio
	FROM tb_atendimento atendimento
	WHERE atendimento.situacaoAtendimento <> 6
		AND atendimento.registro_ativo = 1
		AND atendimento.id = @idAtendimento

END 
ELSE IF(@idEspelho is not null)
BEGIN

	INSERT INTO #TabelaTemporariaAtendimentos
	SELECT atendimento.id, atendimento.fk_convenio 
	FROM tb_atendimento atendimento
	WHERE atendimento.situacaoAtendimento <> 6
		AND 
		atendimento.registro_ativo = 1
		AND atendimento.fk_espelho = @idEspelho

END 
ELSE IF(@idAtendimentoIN is not null)
BEGIN

	INSERT INTO #TabelaTemporariaAtendimentos
	SELECT atendimento.id, atendimento.fk_convenio 
	FROM tb_atendimento atendimento
	WHERE atendimento.situacaoAtendimento <> 6
		AND atendimento.registro_ativo = 1
		AND CONVERT(VARCHAR(MAX),atendimento.id) IN(SELECT * FROM SplitString(@idAtendimentoIN, ','))

END 
ELSE IF(@idIntegracaoEntidade is not null)
BEGIN
	
	INSERT INTO #TabelaTemporariaAtendimentos
	SELECT atendimento.id, atendimento.fk_convenio 
	FROM tb_atendimento atendimento
	WHERE atendimento.situacaoAtendimento <> 6
		AND atendimento.registro_ativo = 1
		AND atendimento.fk_integracao_entidade = @idIntegracaoEntidade

END 
ELSE IF(@idIntegracaoHospital is not null)
BEGIN
	
	INSERT INTO #TabelaTemporariaAtendimentos
	SELECT atendimento.id, atendimento.fk_convenio 
	FROM tb_atendimento atendimento
	WHERE atendimento.situacaoAtendimento <> 6
		AND atendimento.registro_ativo = 1
		AND atendimento.fk_integracao_hospital = @idIntegracaoEntidade

END 
--SELECT 'Fim Atendimento', getDate()


CREATE TABLE #TabelaTemporariaInconsistentes (fk_atendimento bigint, fk_usuario_ultima_alteracao bigint, descricao varchar(255), data_ultima_alteracao datetime, registro_ativo bit)
	

	--Processa Inconsistência Cooperado Padrão
	INSERT INTO #TabelaTemporariaInconsistentes
	           (data_ultima_alteracao,
	           registro_ativo,
	           descricao,
	           fk_usuario_ultima_alteracao,
	           fk_atendimento)
	SELECT 
		getDate() AS 'data_ultima_alteracao',
		1 AS 'registro_ativo',
		'Atendimento para um cooperado padrão.' AS 'descricao',
		@idUsuario AS 'fk_usuario_ultima_alteracao',
		procedimento.fk_atendimento AS 'fk_atendimento'
	FROM tb_procedimento procedimento
	INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentos ON(TabelaTemporariaAtendimentos.id = procedimento.fk_atendimento)
	WHERE procedimento.registro_ativo=1
		AND COALESCE(procedimento.fk_cooperado_executante_complemento,23893) = 23893
	GROUP BY procedimento.fk_atendimento



	--Processa Inconsistência Cooperado Pessoa Jurídica Recebedor Anterior
	INSERT INTO #TabelaTemporariaInconsistentes
	           (data_ultima_alteracao,
	           registro_ativo,
	           descricao,
	           fk_usuario_ultima_alteracao,
	           fk_atendimento)
	SELECT 
		getDate() AS 'data_ultima_alteracao',
		1 AS 'registro_ativo',
		'Convênio não permite faturamento para cooperados do tipo pessoa jurídica.' AS 'descricao',
		@idUsuario AS 'fk_usuario_ultima_alteracao',
		procedimento.fk_atendimento AS 'fk_atendimento'
	FROM tb_procedimento procedimento
	INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentos ON(TabelaTemporariaAtendimentos.id = procedimento.fk_atendimento)
	INNER JOIN tb_cooperado cooperado ON(cooperado.id = procedimento.fk_cooperado_recebedor_cobranca_anterior AND cooperado.registro_ativo=1)
	INNER JOIN tb_atendimento atendimento ON(atendimento.id = procedimento.fk_atendimento AND atendimento.registro_ativo=1)
	INNER JOIN rl_entidade_convenio entidadeConvenio ON(entidadeConvenio.id = atendimento.fk_convenio AND entidadeConvenio.registro_ativo=1)
	WHERE procedimento.registro_ativo=1
		AND cooperado.discriminator='pj'
		AND COALESCE(entidadeConvenio.permitir_digitacao_atendimento_pj,0) = 0
	GROUP BY procedimento.fk_atendimento


	--Processa Inconsistência Cooperado Pessoa Jurídica Recebedor
	INSERT INTO #TabelaTemporariaInconsistentes
	           (data_ultima_alteracao,
	           registro_ativo,
	           descricao,
	           fk_usuario_ultima_alteracao,
	           fk_atendimento)
	SELECT 
		getDate() AS 'data_ultima_alteracao',
		1 AS 'registro_ativo',
		'Convênio não permite faturamento para cooperados do tipo pessoa jurídica.' AS 'descricao',
		@idUsuario AS 'fk_usuario_ultima_alteracao',
		procedimento.fk_atendimento AS 'fk_atendimento'
	FROM tb_procedimento procedimento
	INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentos ON(TabelaTemporariaAtendimentos.id = procedimento.fk_atendimento)
	INNER JOIN tb_cooperado cooperado ON(cooperado.id = procedimento.fk_cooperado_recebedor_cobranca AND cooperado.registro_ativo=1)
	INNER JOIN tb_atendimento atendimento ON(atendimento.id = procedimento.fk_atendimento AND atendimento.registro_ativo=1)
	INNER JOIN rl_entidade_convenio entidadeConvenio ON(entidadeConvenio.id = atendimento.fk_convenio AND entidadeConvenio.registro_ativo=1)
	WHERE procedimento.registro_ativo=1
		AND cooperado.discriminator='pj'
		AND procedimento.fk_cooperado_recebedor_cobranca IS NULL
		AND COALESCE(entidadeConvenio.permitir_digitacao_atendimento_pj,0) = 0
	GROUP BY procedimento.fk_atendimento

	--Processa Inconsistência Procedimento Zerado
	INSERT INTO #TabelaTemporariaInconsistentes
	           (data_ultima_alteracao,
	           registro_ativo,
	           descricao,
	           fk_usuario_ultima_alteracao,
	           fk_atendimento)
	SELECT 
		getDate() AS 'data_ultima_alteracao',
		1 AS 'registro_ativo',
		'Valor total do procedimento no atendimento está zerado.' AS 'descricao',
		@idUsuario AS 'fk_usuario_ultima_alteracao',
		procedimento.fk_atendimento AS 'fk_atendimento'
	FROM tb_procedimento procedimento
	INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentos ON(TabelaTemporariaAtendimentos.id = procedimento.fk_atendimento)
	INNER JOIN tb_atendimento atendimento ON (atendimento.id = procedimento.fk_atendimento AND atendimento.registro_ativo=1)
	INNER JOIN rl_entidade_convenio entidadeConvenio 
		ON(entidadeConvenio.id = atendimento.fk_convenio AND entidadeConvenio.registro_ativo=1)
	WHERE procedimento.registro_ativo=1
		AND procedimento.valor_total = 0.00
		AND entidadeConvenio.fk_convenio <> 773
	GROUP BY procedimento.fk_atendimento

	--Processa Inconsistência Cooperado Executante sem Especialidade Principal
	INSERT INTO #TabelaTemporariaInconsistentes
	           (data_ultima_alteracao,
	           registro_ativo,
	           descricao,
	           fk_usuario_ultima_alteracao,
	           fk_atendimento)
	SELECT 
		getDate() AS 'data_ultima_alteracao',
		1 AS 'registro_ativo',
		'Cooperado do atendimento não possui uma especialidade principal definida.' AS 'descricao',
		@idUsuario AS 'fk_usuario_ultima_alteracao',
		procedimento.fk_atendimento AS 'fk_atendimento'
	FROM tb_procedimento procedimento
	INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentos ON(TabelaTemporariaAtendimentos.id = procedimento.fk_atendimento)
	INNER JOIN tb_atendimento atendimento ON (atendimento.id = procedimento.fk_atendimento AND atendimento.registro_ativo=1)
	INNER JOIN rl_entidade_convenio entidadeConvenio ON (entidadeConvenio.id = atendimento.fk_convenio AND entidadeConvenio.registro_ativo=1)
	WHERE procedimento.registro_ativo=1
		AND NOT EXISTS(
			SELECT entidadeCooperado.id 
			FROM rl_entidade_cooperado entidadeCooperado
			INNER JOIN rl_entidadecooperado_especialidade especialidade 
				ON (especialidade.fk_entidade_cooperado = entidadeCooperado.id 
				AND especialidade.registro_ativo=1 
				AND especialidade.principal=1)
			WHERE entidadeCooperado.registro_ativo=1 
			AND entidadeCooperado.fk_cooperado = procedimento.fk_cooperado_executante_complemento
			AND entidadeCooperado.fk_entidade = entidadeConvenio.fk_entidade)
	GROUP BY procedimento.fk_atendimento

	--Processa Inconsistência Cooperado Executante vinculado ao Hospital
	INSERT INTO #TabelaTemporariaInconsistentes
	           (data_ultima_alteracao,
	           registro_ativo,
	           descricao,
	           fk_usuario_ultima_alteracao,
	           fk_atendimento)
	SELECT 
		getDate() AS 'data_ultima_alteracao',
		1 AS 'registro_ativo',
		'O cooperado '+ cooperadoExecutante.nome+' não está vinculado ao Hospital '+hospital.nome AS 'descricao',
		@idUsuario AS 'fk_usuario_ultima_alteracao',
		procedimento.fk_atendimento AS 'fk_atendimento'
	FROM tb_procedimento procedimento
	INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentos ON(TabelaTemporariaAtendimentos.id = procedimento.fk_atendimento)
	INNER JOIN tb_atendimento atendimento ON (atendimento.id = procedimento.fk_atendimento AND atendimento.registro_ativo=1)
	INNER JOIN rl_entidade_convenio entidadeConvenio ON (entidadeConvenio.id = atendimento.fk_convenio AND entidadeConvenio.registro_ativo=1)
	INNER JOIN tb_cooperado cooperadoExecutante ON(cooperadoExecutante.id = procedimento.fk_cooperado_executante_complemento)
	INNER JOIN tb_hospital hospital ON (hospital.id = atendimento.fk_hospital AND hospital.registro_ativo=1)
	WHERE procedimento.registro_ativo=1
		AND NOT EXISTS(
			SELECT entidadeCooperado.id 
			FROM rl_entidade_cooperado entidadeCooperado
			INNER JOIN rl_entidadecooperado_hospital entidadeCooperadoHospital 
				ON (entidadeCooperadoHospital.fk_entidade_cooperado = entidadeCooperado.id 
					AND entidadeCooperadoHospital.fk_entidade_hospital = atendimento.fk_entidade_hospital
					AND entidadeCooperadoHospital.registro_ativo=1)
			WHERE entidadeCooperado.registro_ativo=1 
				AND entidadeCooperado.fk_cooperado = procedimento.fk_cooperado_executante_complemento
				AND entidadeCooperado.fk_entidade = entidadeConvenio.fk_entidade)
	GROUP BY procedimento.fk_atendimento, cooperadoExecutante.nome, hospital.nome


	--Processa Inconsistência Verifica digitos guia	
	INSERT INTO #TabelaTemporariaInconsistentes
	           (data_ultima_alteracao,
	           registro_ativo,
	           descricao,
	           fk_usuario_ultima_alteracao,
	           fk_atendimento)
	SELECT 
		getDate() AS 'data_ultima_alteracao',
		1 AS 'registro_ativo',
		'A quantidade de dígitos da guia é inválida para o convênio.' AS 'descricao',
		@idUsuario AS 'fk_usuario_ultima_alteracao',
		atendimento.id AS 'fk_atendimento'
	FROM #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentos
	INNER JOIN tb_atendimento atendimento ON (atendimento.id = TabelaTemporariaAtendimentos.id AND atendimento.registro_ativo=1)
	INNER JOIN rl_entidade_convenio entidadeConvenio ON (entidadeConvenio.id = atendimento.fk_convenio AND entidadeConvenio.registro_ativo=1)
	WHERE atendimento.registro_ativo=1
		AND COALESCE(entidadeConvenio.numero_digitos_guia,0) > 0
		AND COALESCE(entidadeConvenio.numero_digitos_guia,0) <> LEN(COALESCE(atendimento.numero_guia,''))
	GROUP BY atendimento.id


	--Processa Inconsistência Verifica digitos matricula
	INSERT INTO #TabelaTemporariaInconsistentes
	           (data_ultima_alteracao,
	           registro_ativo,
	           descricao,
	           fk_usuario_ultima_alteracao,
	           fk_atendimento)
	SELECT 
		getDate() AS 'data_ultima_alteracao',
		1 AS 'registro_ativo',
		'A quantidade de dígitos da matrícula é inválida para o convênio.' AS 'descricao',
		@idUsuario AS 'fk_usuario_ultima_alteracao',
		atendimento.id AS 'fk_atendimento'
	FROM #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentos
	INNER JOIN tb_atendimento atendimento ON (atendimento.id = TabelaTemporariaAtendimentos.id AND atendimento.registro_ativo=1)
	INNER JOIN rl_entidade_convenio entidadeConvenio ON (entidadeConvenio.id = atendimento.fk_convenio AND entidadeConvenio.registro_ativo=1)
	WHERE atendimento.registro_ativo=1
		AND COALESCE(entidadeConvenio.numero_digitos_matricula,0) > 0
		AND COALESCE(entidadeConvenio.numero_digitos_matricula,0) <> LEN(COALESCE(atendimento.matricula_paciente,''))
	GROUP BY atendimento.id



	--Processa Inconsistência Verifica quantidade auxilares
	INSERT INTO #TabelaTemporariaInconsistentes
	           (data_ultima_alteracao,
	           registro_ativo,
	           descricao,
	           fk_usuario_ultima_alteracao,
	           fk_atendimento)
	SELECT 
		getDate() AS 'data_ultima_alteracao',
		1 AS 'registro_ativo',
		'Quantidade de auxiliares para o procedimento '''+ ISNULL(codigo_item_procedimento_tuss, codigo_item_despesa)+''' excedida.' AS 'descricao',
		@idUsuario AS 'fk_usuario_ultima_alteracao',
		fk_atendimento AS 'fk_atendimento'
		FROM (
		SELECT 
			procedimento.fk_atendimento AS 'fk_atendimento',
			itemDespesa.codigo AS 'codigo_item_despesa',
			procedimentoTUSS.codigo AS 'codigo_item_procedimento_tuss',
			(CASE WHEN grauParticipacao.id = 109918
			THEN 1
		  WHEN grauParticipacao.id = 109919
		    THEN 2
		  WHEN grauParticipacao.id = 109920
			THEN 3
			WHEN grauParticipacao.id = 109921
			THEN 4
			ELSE 0 END) AS 'quantidade_auxiliares',
			memoriaCalculo.quantidade_auxiliares_autorizado AS 'quantidade_auxiliares_autorizado'
		FROM tb_procedimento procedimento
		INNER JOIN rl_entidade_grau_participacao entGrauParticipacao ON(procedimento.fk_grau_participacao = entGrauParticipacao.id and entGrauParticipacao.registro_ativo = 1)
		INNER JOIN tb_tabela_tiss grauParticipacao ON(entGrauParticipacao.fk_grau_participacao = grauParticipacao.id and grauParticipacao.registro_ativo = 1)
		INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentos ON(TabelaTemporariaAtendimentos.id = procedimento.fk_atendimento)
		INNER JOIN tb_item_despesa itemDespesa ON (itemDespesa.id = procedimento.fk_item_despesa AND itemDespesa.registro_ativo=1)
		LEFT JOIN tb_tabela_tiss_versao_codigo procedimentoTUSS ON (procedimentoTUSS.id = procedimento.fk_procedimento_tuss AND procedimentoTUSS.registro_ativo=1)
		INNER JOIN rl_entidade_grau_participacao entidadeGrauParticipacao 
				ON(entidadeGrauParticipacao.id = procedimento.fk_grau_participacao AND entidadeGrauParticipacao.registro_ativo=1)
		CROSS APPLY(
			SELECT TOP 1 
				(CASE 
					WHEN memoria.fk_entidade_cooperado_despesa IS NOT NULL
						THEN COALESCE(despesaComEdicaoTabelaConvenio.numero_auxiliares,0)
					WHEN memoria.fk_entidade_convenio_despesa_especialidade IS NOT NULL
						THEN COALESCE(despesaComEdicaoTabelaConvenio.numero_auxiliares,0)
					 WHEN despesaEntidadeConvenio.id IS NOT NULL
						THEN COALESCE(despesaEntidadeConvenio.numero_auxiliares,0)	
					 WHEN despesaComEdicaoTabelaConvenio.id IS NOT NULL
						THEN COALESCE(despesaComEdicaoTabelaConvenio.numero_auxiliares,0)
						ELSE 0 END) AS 'quantidade_auxiliares_autorizado',
						historicoTabelaHonorario.gerar_inconsistencia_quantidade_auxiliares_excedida,
						historicoTabelaHonorario.validar_numero_auxiliares,
						ISNULL(historicoTabelaHonorario.validar_procedimento_maior_auxilio,0) AS 'validar_procedimento_maior_auxilio'
			FROM tb_memoria_calculo memoria
			INNER JOIN tb_procedimento procedimentoMemoria ON(procedimentoMemoria.id = memoria.fk_procedimento AND procedimentoMemoria.registro_ativo=1)
		INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentosMemoria ON(TabelaTemporariaAtendimentosMemoria.id = procedimentoMemoria.fk_atendimento)
			INNER JOIN rl_entidadeconvenio_historico_tabela_honorario historicoTabelaHonorario 
				ON(historicoTabelaHonorario.id= memoria.fk_entidade_convenio_historico_tabela_honorario
					AND historicoTabelaHonorario.registro_ativo=1)
			INNER JOIN tb_item_despesa itemDespesaMemoria 
				ON (itemDespesaMemoria.id = procedimentoMemoria.fk_item_despesa AND itemDespesaMemoria.registro_ativo=1) 
			LEFT JOIN tb_tabela_tiss_versao_codigo procedimentoTUSSMemoria 
				ON (procedimentoTUSSMemoria.id = procedimentoMemoria.fk_procedimento_tuss AND procedimentoTUSSMemoria.registro_ativo=1)

			LEFT JOIN tb_despesa despesaComEdicaoTabelaConvenio 
				ON(despesaComEdicaoTabelaConvenio.id = memoria.fk_despesa_edicao_tabela_convenio 
					AND despesaComEdicaoTabelaConvenio.registro_ativo=1)		
			LEFT JOIN tb_despesa despesaComEdicaoTabelaCooperado
				ON(despesaComEdicaoTabelaCooperado.id = memoria.fk_despesa_edicao_tabela_cooperado 
					AND despesaComEdicaoTabelaCooperado.registro_ativo=1)
			LEFT JOIN tb_despesa despesaEntidadeConvenio
				ON(despesaEntidadeConvenio.id = memoria.fk_entidade_cconvenio_despesa 
					AND despesaEntidadeConvenio.registro_ativo=1)

			WHERE memoria.registro_ativo=1
				AND ISNULL(procedimentoTUSS.codigo,itemDespesa.codigo) = ISNULL(procedimentoTUSSMemoria.codigo,itemDespesaMemoria.codigo)
				AND procedimentoMemoria.fk_atendimento = TabelaTemporariaAtendimentos.id
			ORDER BY memoria.id DESC				
		) AS memoriaCalculo 
		WHERE procedimento.registro_ativo=1
			AND entidadeGrauParticipacao.fk_grau_participacao IN(109918, 109919,  109920, 109921)
			AND memoriaCalculo.validar_numero_auxiliares = 1
			AND memoriaCalculo.gerar_inconsistencia_quantidade_auxiliares_excedida = 1
			AND memoriaCalculo.validar_procedimento_maior_auxilio = 0
		GROUP BY procedimento.fk_atendimento, itemDespesa.codigo, grauParticipacao.id, procedimentoTUSS.codigo,memoriaCalculo.quantidade_auxiliares_autorizado, procedimento.data_realizacao, procedimento.hora_inicio)
		TabelaTemporaria
		WHERE TabelaTemporaria.quantidade_auxiliares >	TabelaTemporaria.quantidade_auxiliares_autorizado
		
	UNION ALL

	SELECT 
		getDate() AS 'data_ultima_alteracao',
		1 AS 'registro_ativo',
		'Quantidade de auxiliares para o procedimento '''+ ISNULL(codigo_item_procedimento_tuss, codigo_item_despesa)+''' excedida.' AS 'descricao',
		@idUsuario AS 'fk_usuario_ultima_alteracao',
		fk_atendimento AS 'fk_atendimento'
		FROM (
		SELECT 
			procedimento.fk_atendimento AS 'fk_atendimento',
			itemDespesa.codigo AS 'codigo_item_despesa',
			procedimentoTUSS.codigo AS 'codigo_item_procedimento_tuss',
			0 AS 'quantidade_auxiliares',
			memoriaCalculo.quantidade_auxiliares_autorizado AS 'quantidade_auxiliares_autorizado'
		FROM tb_procedimento procedimento
		INNER JOIN rl_entidade_grau_participacao entGrauParticipacao ON(procedimento.fk_grau_participacao = entGrauParticipacao.id and entGrauParticipacao.registro_ativo = 1)
		INNER JOIN tb_tabela_tiss grauParticipacao ON(entGrauParticipacao.fk_grau_participacao = grauParticipacao.id and grauParticipacao.registro_ativo = 1)
		INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentos ON(TabelaTemporariaAtendimentos.id = procedimento.fk_atendimento)
		INNER JOIN tb_item_despesa itemDespesa ON (itemDespesa.id = procedimento.fk_item_despesa AND itemDespesa.registro_ativo=1)
		LEFT JOIN tb_tabela_tiss_versao_codigo procedimentoTUSS ON (procedimentoTUSS.id = procedimento.fk_procedimento_tuss AND procedimentoTUSS.registro_ativo=1)
		INNER JOIN rl_entidade_grau_participacao entidadeGrauParticipacao 
				ON(entidadeGrauParticipacao.id = procedimento.fk_grau_participacao AND entidadeGrauParticipacao.registro_ativo=1)
		CROSS APPLY(
			SELECT
				MAX(CASE 
					WHEN memoria.fk_entidade_cooperado_despesa IS NOT NULL
						THEN COALESCE(despesaComEdicaoTabelaConvenio.numero_auxiliares,0)
					WHEN memoria.fk_entidade_convenio_despesa_especialidade IS NOT NULL
						THEN COALESCE(despesaComEdicaoTabelaConvenio.numero_auxiliares,0)
					 WHEN despesaEntidadeConvenio.id IS NOT NULL
						THEN COALESCE(despesaEntidadeConvenio.numero_auxiliares,0)	
					 WHEN despesaComEdicaoTabelaConvenio.id IS NOT NULL
						THEN COALESCE(despesaComEdicaoTabelaConvenio.numero_auxiliares,0)
						ELSE 0 END) AS 'quantidade_auxiliares_autorizado',
						historicoTabelaHonorario.gerar_inconsistencia_quantidade_auxiliares_excedida,
						historicoTabelaHonorario.validar_numero_auxiliares,
						ISNULL(historicoTabelaHonorario.validar_procedimento_maior_auxilio,0) AS 'validar_procedimento_maior_auxilio'
			FROM tb_memoria_calculo memoria
			INNER JOIN tb_procedimento procedimentoMemoria ON(procedimentoMemoria.id = memoria.fk_procedimento AND procedimentoMemoria.registro_ativo=1)
		INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentosMemoria ON(TabelaTemporariaAtendimentosMemoria.id = procedimentoMemoria.fk_atendimento)
			INNER JOIN rl_entidadeconvenio_historico_tabela_honorario historicoTabelaHonorario 
				ON(historicoTabelaHonorario.id= memoria.fk_entidade_convenio_historico_tabela_honorario
					AND historicoTabelaHonorario.registro_ativo=1)
			INNER JOIN tb_item_despesa itemDespesaMemoria 
				ON (itemDespesaMemoria.id = procedimentoMemoria.fk_item_despesa AND itemDespesaMemoria.registro_ativo=1) 
			LEFT JOIN tb_tabela_tiss_versao_codigo procedimentoTUSSMemoria 
				ON (procedimentoTUSSMemoria.id = procedimentoMemoria.fk_procedimento_tuss AND procedimentoTUSSMemoria.registro_ativo=1)

			LEFT JOIN tb_despesa despesaComEdicaoTabelaConvenio 
				ON(despesaComEdicaoTabelaConvenio.id = memoria.fk_despesa_edicao_tabela_convenio 
					AND despesaComEdicaoTabelaConvenio.registro_ativo=1)		
			LEFT JOIN tb_despesa despesaComEdicaoTabelaCooperado
				ON(despesaComEdicaoTabelaCooperado.id = memoria.fk_despesa_edicao_tabela_cooperado 
					AND despesaComEdicaoTabelaCooperado.registro_ativo=1)
			LEFT JOIN tb_despesa despesaEntidadeConvenio
				ON(despesaEntidadeConvenio.id = memoria.fk_entidade_cconvenio_despesa 
					AND despesaEntidadeConvenio.registro_ativo=1)

			WHERE memoria.registro_ativo=1
				AND procedimentoMemoria.fk_atendimento = TabelaTemporariaAtendimentos.id
			GROUP BY historicoTabelaHonorario.gerar_inconsistencia_quantidade_auxiliares_excedida,
				historicoTabelaHonorario.validar_numero_auxiliares,
				ISNULL(historicoTabelaHonorario.validar_procedimento_maior_auxilio,0)			
		) AS memoriaCalculo 
		WHERE procedimento.registro_ativo=1
			AND entidadeGrauParticipacao.fk_grau_participacao IN(109918, 109919,  109920, 109921)
			AND memoriaCalculo.validar_numero_auxiliares = 1
			AND memoriaCalculo.gerar_inconsistencia_quantidade_auxiliares_excedida = 1
			AND memoriaCalculo.validar_procedimento_maior_auxilio = 1
		GROUP BY procedimento.fk_atendimento, itemDespesa.codigo, procedimentoTUSS.codigo,memoriaCalculo.quantidade_auxiliares_autorizado, procedimento.data_realizacao, procedimento.hora_inicio)
		TabelaTemporaria
		WHERE TabelaTemporaria.quantidade_auxiliares >	TabelaTemporaria.quantidade_auxiliares_autorizado
	


	
	--Processa Inconsistência Verifica sem Tabela honorário

	INSERT INTO #TabelaTemporariaInconsistentes
	           (data_ultima_alteracao,
	           registro_ativo,
	           descricao,
	           fk_usuario_ultima_alteracao,
	           fk_atendimento)
	SELECT 
		getDate() AS 'data_ultima_alteracao',
		1 AS 'registro_ativo',
		'Nenhuma tabela de honorário vigente foi encontrada.' AS 'descricao',
		@idUsuario AS 'fk_usuario_ultima_alteracao',
		procedimento.fk_atendimento AS 'fk_atendimento'
	FROM tb_procedimento procedimento
	INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentos ON(TabelaTemporariaAtendimentos.id = procedimento.fk_atendimento)
	CROSS APPLY(
		SELECT TOP 1 
			memoria.valorHonorario AS 'valorHonorario'		 
		FROM tb_memoria_calculo memoria
		INNER JOIN tb_procedimento procedimentoMemoria ON(procedimentoMemoria.id = memoria.fk_procedimento AND procedimentoMemoria.registro_ativo=1)
		INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentosMemoria ON(TabelaTemporariaAtendimentosMemoria.id = procedimentoMemoria.fk_atendimento)
		WHERE memoria.registro_ativo=1
			AND procedimentoMemoria.fk_atendimento = procedimento.fk_atendimento
		ORDER BY memoria.id DESC				
	) AS memoriaCalculo
	WHERE procedimento.registro_ativo=1
			AND memoriaCalculo.valorHonorario IS NULL
	GROUP BY procedimento.fk_atendimento


	--Processa Inconsistência Verifica sem Valor Porte
	INSERT INTO #TabelaTemporariaInconsistentes
	           (data_ultima_alteracao,
	           registro_ativo,
	           descricao,
	           fk_usuario_ultima_alteracao,
	           fk_atendimento)
	SELECT 
		getDate() AS 'data_ultima_alteracao',
		1 AS 'registro_ativo',
		'Procedimento não possui porte anestesia.' AS 'descricao',
		@idUsuario AS 'fk_usuario_ultima_alteracao',
		procedimento.fk_atendimento AS 'fk_atendimento'
	FROM tb_procedimento procedimento
	INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentos ON(TabelaTemporariaAtendimentos.id = procedimento.fk_atendimento)
	CROSS APPLY(
		SELECT TOP 1 
			memoria.valorPorte AS 'valorPorte', memoria.fk_entidade_convenio_despesa_especialidade, memoria.fk_entidade_cooperado_despesa		 
		FROM tb_memoria_calculo memoria
		INNER JOIN tb_procedimento procedimentoMemoria ON(procedimentoMemoria.id = memoria.fk_procedimento AND procedimentoMemoria.registro_ativo=1)
		INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentosMemoria ON(TabelaTemporariaAtendimentosMemoria.id = procedimentoMemoria.fk_atendimento)
		WHERE memoria.registro_ativo=1
			AND procedimentoMemoria.id = procedimento.id
		ORDER BY memoria.id DESC				
	) AS memoriaCalculo
	INNER JOIN rl_entidade_grau_participacao entidadeGrauParticipacao 
		ON(entidadeGrauParticipacao.id = procedimento.fk_grau_participacao AND entidadeGrauParticipacao.registro_ativo=1)
	WHERE procedimento.registro_ativo=1
			AND (entidadeGrauParticipacao.fk_grau_participacao=109923 OR entidadeGrauParticipacao.fk_grau_participacao=109924)
			AND memoriaCalculo.valorPorte IS NULL
			AND procedimento.forcar_atendimento=0
			AND memoriaCalculo.fk_entidade_convenio_despesa_especialidade IS NULL
			AND memoriaCalculo.fk_entidade_cooperado_despesa IS NULL
	GROUP BY procedimento.fk_atendimento	

	
	
	--Processa Inconsistência Verifica sem Valor Porte
	INSERT INTO #TabelaTemporariaInconsistentes
	           (data_ultima_alteracao,
	           registro_ativo,
	           descricao,
	           fk_usuario_ultima_alteracao,
	           fk_atendimento)
	SELECT 
		getDate() AS 'data_ultima_alteracao',
		1 AS 'registro_ativo',
		'Procedimento não possui porte anestesia.' AS 'descricao',
		@idUsuario AS 'fk_usuario_ultima_alteracao',
		procedimento.fk_atendimento AS 'fk_atendimento'
	FROM tb_procedimento procedimento
	INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentos ON(TabelaTemporariaAtendimentos.id = procedimento.fk_atendimento)
	CROSS APPLY(
		SELECT TOP 1 
			memoria.valorPorte AS 'valorPorte', memoria.fk_entidade_convenio_despesa_especialidade, memoria.fk_entidade_cooperado_despesa		 
		FROM tb_memoria_calculo memoria
		INNER JOIN tb_procedimento procedimentoMemoria ON(procedimentoMemoria.id = memoria.fk_procedimento AND procedimentoMemoria.registro_ativo=1)
		INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentosMemoria ON(TabelaTemporariaAtendimentosMemoria.id = procedimentoMemoria.fk_atendimento)
		WHERE memoria.registro_ativo=1
			AND procedimentoMemoria.id = procedimento.id
		ORDER BY memoria.id DESC				
	) AS memoriaCalculo
	INNER JOIN rl_entidade_grau_participacao entidadeGrauParticipacao 
		ON(entidadeGrauParticipacao.id = procedimento.fk_grau_participacao AND entidadeGrauParticipacao.registro_ativo=1)
	WHERE procedimento.registro_ativo=1
			AND (entidadeGrauParticipacao.fk_grau_participacao=109923 OR entidadeGrauParticipacao.fk_grau_participacao=109924)
			AND memoriaCalculo.valorPorte IS NULL
			AND procedimento.forcar_atendimento=0
			AND memoriaCalculo.fk_entidade_convenio_despesa_especialidade IS NULL
			AND memoriaCalculo.fk_entidade_cooperado_despesa IS NULL
	GROUP BY procedimento.fk_atendimento


	
	--Processa Inconsistência Convenio Cooperado Digitacao
	INSERT INTO #TabelaTemporariaInconsistentes
	           (data_ultima_alteracao,
	           registro_ativo,
	           descricao,
	           fk_usuario_ultima_alteracao,
	           fk_atendimento)
	SELECT 
		getDate() AS 'data_ultima_alteracao',
		1 AS 'registro_ativo',
		'Cooperado '+ISNULL(cooperado.nome,'')+' bloqueado para este convênio.' AS 'descricao',
		@idUsuario AS 'fk_usuario_ultima_alteracao',
		procedimento.fk_atendimento AS 'fk_atendimento'
	FROM tb_procedimento procedimento
	INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentos ON(TabelaTemporariaAtendimentos.id = procedimento.fk_atendimento)
	INNER JOIN rl_entidade_convenio entidadeConvenio
		ON (entidadeConvenio.id = TabelaTemporariaAtendimentos.fk_entidade_convenio and entidadeConvenio.registro_ativo = 1)
	INNER JOIN rl_entidade_cooperado entidadeCooperado 
		ON (entidadeCooperado.fk_cooperado = procedimento.fk_cooperado_executante_complemento 
			AND entidadeCooperado.fk_entidade = entidadeConvenio.fk_entidade 
			AND entidadeCooperado.registro_ativo = 1)
	INNER JOIN tb_cooperado cooperado ON(cooperado.id = procedimento.fk_cooperado_executante_complemento)
	INNER JOIN tb_cooperado_convenio_digitacao cooperadoConvenioDigitacao 
		ON (cooperadoConvenioDigitacao.fk_entidade_cooperado = entidadeCooperado.id 
			AND cooperadoConvenioDigitacao.fk_entidade_convenio = entidadeConvenio.id 
			AND cooperadoConvenioDigitacao.registro_ativo = 1)
	WHERE procedimento.registro_ativo=1
		AND NOT EXISTS(
			SELECT excecaoTipoGuia.registro_ativo
			FROM tb_cooperado_convenio_tipo_guia_digitacao excecaoTipoGuia
			WHERE excecaoTipoGuia.registro_ativo = 1
				AND excecaoTipoGuia.fk_cooperado_convenio_digitacao = cooperadoConvenioDigitacao.id
		)
	GROUP BY procedimento.fk_atendimento, ISNULL(cooperado.nome,'')

	--Processa Inconsistência Convenio Cooperado Digitacao com exceção de tipo de guia
	INSERT INTO #TabelaTemporariaInconsistentes
	           (data_ultima_alteracao,
	           registro_ativo,
	           descricao,
	           fk_usuario_ultima_alteracao,
	           fk_atendimento)
	SELECT 
		getDate() AS 'data_ultima_alteracao',
		1 AS 'registro_ativo',
		'Cooperado '+ISNULL(cooperado.nome,'')+' bloqueado para este convênio/tipo guia.' AS 'descricao',
		@idUsuario AS 'fk_usuario_ultima_alteracao',
		procedimento.fk_atendimento AS 'fk_atendimento'
	FROM tb_procedimento procedimento
	INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentos ON(TabelaTemporariaAtendimentos.id = procedimento.fk_atendimento)
	INNER JOIN rl_entidade_convenio entidadeConvenio
		ON (entidadeConvenio.id = TabelaTemporariaAtendimentos.fk_entidade_convenio and entidadeConvenio.registro_ativo = 1)
	INNER JOIN rl_entidade_cooperado entidadeCooperado 
		ON (entidadeCooperado.fk_cooperado = procedimento.fk_cooperado_executante_complemento 
			AND entidadeCooperado.fk_entidade = entidadeConvenio.fk_entidade 
			AND entidadeCooperado.registro_ativo = 1)
	INNER JOIN tb_cooperado cooperado ON(cooperado.id = procedimento.fk_cooperado_executante_complemento)
	INNER JOIN tb_cooperado_convenio_digitacao cooperadoConvenioDigitacao 
		ON (cooperadoConvenioDigitacao.fk_entidade_cooperado = entidadeCooperado.id 
			AND cooperadoConvenioDigitacao.fk_entidade_convenio = entidadeConvenio.id and cooperadoConvenioDigitacao.registro_ativo = 1)
	INNER JOIN tb_cooperado_convenio_tipo_guia_digitacao excecaoTipoGuia 
		ON (excecaoTipoGuia.fk_cooperado_convenio_digitacao = cooperadoConvenioDigitacao.id
			AND excecaoTipoGuia.fk_tipo_guia = procedimento.fk_tipo_guia
			AND excecaoTipoGuia.registro_ativo=1)
	WHERE procedimento.registro_ativo=1
	GROUP BY procedimento.fk_atendimento, ISNULL(cooperado.nome,'')

	

BEGIN TRANSACTION; 

	--Apaga todas as Consistências do atendimento
	UPDATE inconsistencia 
		SET registro_ativo = 0,	
			data_ultima_alteracao = getDate(),
			fk_usuario_ultima_alteracao = @idUsuario
	FROM rl_atendimento_inconsistencia inconsistencia
	INNER JOIN #TabelaTemporariaAtendimentos TabelaTemporariaAtendimentos ON (TabelaTemporariaAtendimentos.id = inconsistencia.fk_atendimento)
	WHERE inconsistencia.registro_ativo=1

	--Insere inconsistencias
	INSERT INTO rl_atendimento_inconsistencia
	          (data_ultima_alteracao,
	          registro_ativo,
	          descricao,
	          fk_usuario_ultima_alteracao,
	          fk_atendimento)
	SELECT getDate(),
	1,
	descricao,
	fk_usuario_ultima_alteracao,
	fk_atendimento
	FROM #TabelaTemporariaInconsistentes


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






