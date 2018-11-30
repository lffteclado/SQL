go
IF EXISTS (SELECT 1 FROM sysobjects WHERE id = object_id('whRelControleLigacoes')) begin
	DROP PROCEDURE dbo.whRelControleLigacoes end
GO
CREATE PROCEDURE dbo.whRelControleLigacoes
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: Monitoramento
 AUTOR........: Paulo Henrique Mauri
 DATA.........: 03/Mar/2009	
 UTILIZADO EM : 
 OBJETIVO.....: Emitir relatório de Controle de Ligacoes para Monitoramento

 whRelControleLigacoes 1608, 0, 'PV', '2009-01-01', '2009-01-31','039'

-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa		NUMERIC(4),
@CodigoLocal		NUMERIC(4),
@TipoMonitoramento	CHAR(2),
@DataIni			DATETIME,
@DataFim			DATETIME,
@CodigoFabricante	CHAR(5) = NULL

AS

	SET NOCOUNT ON

	
	update tbMonitoramento set CodigoFabricanteVeiculo = null where ltrim(rtrim(CodigoFabricanteVeiculo)) = ''


	DECLARE @TOTAL AS NUMERIC(4)

	CREATE TABLE #tmpRelControle (Linha VARCHAR(30), Valor NUMERIC(3), Perc NUMERIC(3))
	
	SET @TOTAL = (SELECT COUNT(tbMonitoramento.StatusMonitoramento)
			 FROM tbMonitoramento (NOLOCK)
			 WHERE	tbMonitoramento.CodigoEmpresa = @CodigoEmpresa
			 AND	tbMonitoramento.CodigoLocal = @CodigoLocal
			 AND	tbMonitoramento.DataMonitoramento BETWEEN @DataIni AND @DataFim
--			 AND	tbMonitoramento.DataDocumento BETWEEN @DataIni AND @DataFim
			 AND	tbMonitoramento.TipoMonitoramento = @TipoMonitoramento
			 AND	tbMonitoramento.MonitoramentoFinalizado = 'V'
--			 AND ((tbMonitoramento.CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--			 OR  (tbMonitoramento.CodigoFabricanteVeiculo is  null and @CodigoFabricante is null)) )

/*			and (tbMonitoramento.CodigoFabricanteVeiculo is null 
			or   tbMonitoramento.CodigoFabricanteVeiculo =(case when @CodigoFabricante is null 
																then tbMonitoramento.CodigoFabricanteVeiculo
																else @CodigoFabricante
															end)))
*/
			and tbMonitoramento.CodigoFabricanteVeiculo = (case when @CodigoFabricante is null 
																then tbMonitoramento.CodigoFabricanteVeiculo
																else @CodigoFabricante
															end))

	INSERT INTO #tmpRelControle
	SELECT 	'Pesquisas Realizadas' AS Texto,
		CASE WHEN COUNT(tbMonitoramento.StatusMonitoramento) > 0 THEN
			COUNT(tbMonitoramento.StatusMonitoramento)
		ELSE 	0
		END ,
		0
	FROM tbMonitoramento (NOLOCK)
	WHERE	tbMonitoramento.CodigoEmpresa = @CodigoEmpresa
	AND	tbMonitoramento.CodigoLocal = @CodigoLocal
	AND	tbMonitoramento.DataMonitoramento BETWEEN @DataIni AND @DataFim
--	AND	tbMonitoramento.DataDocumento BETWEEN @DataIni AND @DataFim
	AND	tbMonitoramento.TipoMonitoramento = @TipoMonitoramento
	AND	tbMonitoramento.StatusMonitoramento = 'CO'
	AND	tbMonitoramento.MonitoramentoFinalizado = 'V'
--	AND ((tbMonitoramento.CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--	OR  (tbMonitoramento.CodigoFabricanteVeiculo is  null and @CodigoFabricante is null))

/*			and (tbMonitoramento.CodigoFabricanteVeiculo is null 
			or   tbMonitoramento.CodigoFabricanteVeiculo =(case when @CodigoFabricante is null 
																then tbMonitoramento.CodigoFabricanteVeiculo
																else @CodigoFabricante
															end))
*/
			and tbMonitoramento.CodigoFabricanteVeiculo = (case when @CodigoFabricante is null 
																then tbMonitoramento.CodigoFabricanteVeiculo
																else @CodigoFabricante
															end)
	
	--------
	INSERT INTO #tmpRelControle
	SELECT 	'Não quis Responder' AS Texto,
		CASE WHEN COUNT(tbMonitoramento.StatusMonitoramento) > 0 THEN
			COUNT(tbMonitoramento.StatusMonitoramento)
		ELSE	0
		END ,
		0
	FROM tbMonitoramento (NOLOCK)
	WHERE	tbMonitoramento.CodigoEmpresa = @CodigoEmpresa
	AND	tbMonitoramento.CodigoLocal = @CodigoLocal
	AND	tbMonitoramento.DataMonitoramento BETWEEN @DataIni AND @DataFim
--	AND	tbMonitoramento.DataDocumento BETWEEN @DataIni AND @DataFim
	AND	tbMonitoramento.TipoMonitoramento = @TipoMonitoramento
	AND	tbMonitoramento.StatusMonitoramento = 'NR'
	AND	tbMonitoramento.MonitoramentoFinalizado = 'V'
--	AND ((tbMonitoramento.CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--	OR  (tbMonitoramento.CodigoFabricanteVeiculo is  null and @CodigoFabricante is null))
/*			and (tbMonitoramento.CodigoFabricanteVeiculo is null 
			or   tbMonitoramento.CodigoFabricanteVeiculo =(case when @CodigoFabricante is null 
																then tbMonitoramento.CodigoFabricanteVeiculo
																else @CodigoFabricante
															end))
*/
			and tbMonitoramento.CodigoFabricanteVeiculo = (case when @CodigoFabricante is null 
																then tbMonitoramento.CodigoFabricanteVeiculo
																else @CodigoFabricante
															end)
	
	-------
	INSERT INTO #tmpRelControle
	SELECT 	'Contato não Realizado',
		CASE WHEN COUNT(tbMonitoramento.StatusMonitoramento) > 0 THEN
			COUNT(tbMonitoramento.StatusMonitoramento)
		ELSE	0
		END,
		0
	FROM tbMonitoramento (NOLOCK)
	WHERE	tbMonitoramento.CodigoEmpresa = @CodigoEmpresa
	AND	tbMonitoramento.CodigoLocal = @CodigoLocal
	AND	tbMonitoramento.DataMonitoramento BETWEEN @DataIni AND @DataFim
--	AND	tbMonitoramento.DataDocumento BETWEEN @DataIni AND @DataFim
	AND	tbMonitoramento.TipoMonitoramento = @TipoMonitoramento
	AND	tbMonitoramento.StatusMonitoramento = 'NC'
	AND	tbMonitoramento.MonitoramentoFinalizado = 'V'
--	AND ((tbMonitoramento.CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--	OR  (tbMonitoramento.CodigoFabricanteVeiculo is  null and @CodigoFabricante is null))
/*			and (tbMonitoramento.CodigoFabricanteVeiculo is null 
			or   tbMonitoramento.CodigoFabricanteVeiculo =(case when @CodigoFabricante is null 
																then tbMonitoramento.CodigoFabricanteVeiculo
																else @CodigoFabricante
															end))
*/
			and tbMonitoramento.CodigoFabricanteVeiculo = (case when @CodigoFabricante is null 
																then tbMonitoramento.CodigoFabricanteVeiculo
																else @CodigoFabricante
															end)

	UPDATE #tmpRelControle SET Perc = ((Valor / @TOTAL) * 100) WHERE @TOTAL <> 0

	SELECT * FROM #tmpRelControle
	
	SET NOCOUNT OFF
--	DROP TABLE #tmpRelControle

GO

GRANT EXECUTE ON dbo.whRelControleLigacoes TO SQLUsers
GO
