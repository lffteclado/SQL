go
IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('whRelInsatisfacaoCliPerg1'))
	DROP PROCEDURE dbo.whRelInsatisfacaoCliPerg1
GO	
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: Monitoramento
 AUTOR........: Paulo Henrique Mauri
 DATA.........: 09/Mar/2009
 UTILIZADO EM : sub-report
 OBJETIVO.....: Totalizar as Respostas de Qualidade de Serviço
 
 whRelInsatisfacaoCliPerg1 1608, 0, 'PV', '2008-01-01', '2009-12-31',null
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/
CREATE PROCEDURE dbo.whRelInsatisfacaoCliPerg1
@CodigoEmpresa NUMERIC(4),
@CodigoLocal NUMERIC(4),
@TipoMonitoramento CHAR(2),
@DataIni DATETIME,
@DataFim DATETIME,
@CodigoFabricante CHAR(5) = NULL

AS	
	SET NOCOUNT ON


	update tbMonitoramento set CodigoFabricanteVeiculo = null where ltrim(rtrim(CodigoFabricanteVeiculo)) = ''


	DECLARE @INTI NUMERIC(2)
	DECLARE @TOTAL NUMERIC(4)
	
	SET @INTI = 65

	CREATE TABLE #tmpInsatisfacaoPerg1
	(
		Linha VARCHAR(30),
		Total NUMERIC(4),
		TotalPerc NUMERIC(4)
	)
	
	SELECT @TOTAL = (SELECT COUNT(tbMonitoramento.RespostaQuestao1) 
					FROM tbMonitoramento (NOLOCK)
					WHERE	tbMonitoramento.CodigoEmpresa = @CodigoEmpresa
					AND		tbMonitoramento.CodigoLocal = @CodigoLocal
					AND		tbMonitoramento.DataMonitoramento BETWEEN @DataIni AND @DataFim
--					AND		tbMonitoramento.DataDocumento BETWEEN @DataIni AND @DataFim					
					AND		tbMonitoramento.TipoMonitoramento = @TipoMonitoramento  -- PV - Pos-Venda
					AND		tbMonitoramento.StatusMonitoramento = 'CO' -- CONTATADOS
					AND		tbMonitoramento.MonitoramentoFinalizado = 'V'
					AND		(tbMonitoramento.RespostaQuestao1 = 'F')
--					AND((tbMonitoramento.CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--						OR  (tbMonitoramento.CodigoFabricanteVeiculo is  null and @CodigoFabricante is null)))
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


	WHILE @INTI <= 73
	BEGIN
		INSERT INTO #tmpInsatisfacaoPerg1
		SELECT 
			LOWER(CHAR(@INTI)) + '.',
			CASE WHEN COUNT(tbMonitoramento.PossiveisMotivos1) > 0 THEN
				COUNT(tbMonitoramento.PossiveisMotivos1)
			END AS TotalQ1, 
			0 -- TotalPerc
		FROM tbMonitoramento (NOLOCK)
		WHERE tbMonitoramento.CodigoEmpresa = @CodigoEmpresa
			AND		tbMonitoramento.CodigoLocal = @CodigoLocal
			AND		tbMonitoramento.DataMonitoramento BETWEEN @DataIni AND @DataFim
--			AND		tbMonitoramento.DataDocumento BETWEEN @DataIni AND @DataFim			
			AND		tbMonitoramento.TipoMonitoramento = @TipoMonitoramento  -- PV - Pos-Venda
			AND		tbMonitoramento.StatusMonitoramento = 'CO' -- CONTATADOS
			AND		tbMonitoramento.MonitoramentoFinalizado = 'V'
			AND		(tbMonitoramento.RespostaQuestao1 = 'F')
--			AND((tbMonitoramento.CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--				OR(tbMonitoramento.CodigoFabricanteVeiculo is  null and @CodigoFabricante is null))
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


			AND		tbMonitoramento.PossiveisMotivos1 = CHAR(@INTI) 
		HAVING COUNT(tbMonitoramento.PossiveisMotivos1) > 0 
		
		SET @INTI = @INTI + 1
		
	END 

	UPDATE #tmpInsatisfacaoPerg1 SET TotalPerc = ((Total / @TOTAL) * 100) WHERE @TOTAL <> 0

	SELECT Linha, Linha + ' ' + CONVERT(VARCHAR(4),TotalPerc) + '%, ' + CONVERT(VARCHAR(4),Total) AS LinhaPercA, Total FROM #tmpInsatisfacaoPerg1
	
	SET NOCOUNT OFF
	DROP TABLE #tmpInsatisfacaoPerg1
GO

GRANT EXECUTE ON dbo.whRelInsatisfacaoCliPerg1 TO SQLUsers
GO

