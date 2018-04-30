go
IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('whRelInsatisfacaoCliPerg3'))
	DROP PROCEDURE dbo.whRelInsatisfacaoCliPerg3
GO	
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: Monitoramento
 AUTOR........: Paulo Henrique Mauri
 DATA.........: 09/Mar/2009
 UTILIZADO EM : sub-report
 OBJETIVO.....: Totalizar as Respostas de Atendimento do Consultor Tecnico
 
 whRelInsatisfacaoCliPerg3 1608, 0, 'PV', '2008-01-01', '2009-12-31',null
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/
CREATE PROCEDURE dbo.whRelInsatisfacaoCliPerg3
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

	CREATE TABLE #tmpInsatisfacaoPerg3
	(
		Linha VARCHAR(30),
		Total NUMERIC(4),
		TotalPerc NUMERIC(4)
	)
	
	SELECT @TOTAL = (SELECT COUNT(tbMonitoramento.RespostaQuestao3) 
					FROM tbMonitoramento (NOLOCK)
					WHERE	tbMonitoramento.CodigoEmpresa = @CodigoEmpresa
					AND		tbMonitoramento.CodigoLocal = @CodigoLocal
					AND		tbMonitoramento.DataMonitoramento BETWEEN @DataIni AND @DataFim
--					AND		tbMonitoramento.DataDocumento BETWEEN @DataIni AND @DataFim
					AND		tbMonitoramento.TipoMonitoramento = @TipoMonitoramento  -- PV - Pos-Venda
					AND		tbMonitoramento.StatusMonitoramento = 'CO' -- CONTATADOS
					AND		tbMonitoramento.MonitoramentoFinalizado = 'V'
					AND		(tbMonitoramento.RespostaQuestao3 = 'F')
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


	WHILE @INTI <= 69
	BEGIN
		INSERT INTO #tmpInsatisfacaoPerg3
		SELECT 
			LOWER(CHAR(@INTI)) + '.',
			CASE WHEN COUNT(tbMonitoramento.PossiveisMotivos3) > 0 THEN
				COUNT(tbMonitoramento.PossiveisMotivos3)
			END AS TotalQ3, 
			0 -- TotalPerc
		FROM tbMonitoramento (NOLOCK)
		WHERE tbMonitoramento.CodigoEmpresa = @CodigoEmpresa
			AND		tbMonitoramento.CodigoLocal = @CodigoLocal
			AND		tbMonitoramento.DataMonitoramento BETWEEN @DataIni AND @DataFim
--			AND		tbMonitoramento.DataDocumento BETWEEN @DataIni AND @DataFim
			AND		tbMonitoramento.TipoMonitoramento = @TipoMonitoramento  -- PV - Pos-Venda
			AND		tbMonitoramento.StatusMonitoramento = 'CO' -- CONTATADOS
			AND		tbMonitoramento.MonitoramentoFinalizado = 'V'
			AND		(tbMonitoramento.RespostaQuestao3 = 'F')
--			AND((tbMonitoramento.CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--				OR  (tbMonitoramento.CodigoFabricanteVeiculo is  null and @CodigoFabricante is null))
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

			AND		tbMonitoramento.PossiveisMotivos3 = CHAR(@INTI) 
		HAVING COUNT(tbMonitoramento.PossiveisMotivos3) > 0

		SET @INTI = @INTI + 1
		
	END 

	UPDATE #tmpInsatisfacaoPerg3 SET TotalPerc = ((Total / @TOTAL) * 100) WHERE @TOTAL <> 0

	SELECT Linha, Linha + ' ' + CONVERT(VARCHAR(4),TotalPerc) + '%, ' + CONVERT(VARCHAR(4),Total) AS LinhaPercA, Total FROM #tmpInsatisfacaoPerg3
	
	SET NOCOUNT OFF
	DROP TABLE #tmpInsatisfacaoPerg3
GO

GRANT EXECUTE ON dbo.whRelInsatisfacaoCliPerg3 TO SQLUsers
GO
