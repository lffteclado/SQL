go
IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('whRelSatisfacaoCli')) begin
	DROP PROCEDURE dbo.whRelSatisfacaoCli end
GO
CREATE PROCEDURE dbo.whRelSatisfacaoCli
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: Monitoramento
 AUTOR........: Paulo Henrique Mauri
 DATA.........: 05/Mar/2009	
 UTILIZADO EM : 
 OBJETIVO.....: Emitir relatório de Satisfação de Clientes para Monitoramento
 
whRelSatisfacaoCli 1608, 0, 'PV', '2009-01-01', '2009-03-31','001'
whRelSatisfacaoCli 1608, 0, 'PV', '2000-01-01', '2010-08-31',null

-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa		NUMERIC(4),
@CodigoLocal		NUMERIC(4),
@TipoMonitoramento	CHAR(2),
@DataIni		DATETIME,
@DataFim		DATETIME,
@CodigoFabricante CHAR(5)= null

AS 

SET NOCOUNT ON

declare @Total 			as numeric(4)	
declare @Satisfeitos		as numeric(4)
declare @PercSatisfeitos	as numeric(4)
declare @Insatisfeitos		as numeric(4)
declare @PercInsatisfeitos	as numeric(4)


update tbMonitoramento set CodigoFabricanteVeiculo = null where ltrim(rtrim(CodigoFabricanteVeiculo)) = ''


select @Total = 0, @Satisfeitos = 0, @PercSatisfeitos = 0, @Insatisfeitos = 0, @PercInsatisfeitos = 0

SELECT @Total = (SELECT coalesce(COUNT(tbMonitoramento.StatusMonitoramento), 0)
		 FROM tbMonitoramento (NOLOCK)
		 WHERE	tbMonitoramento.CodigoEmpresa = @CodigoEmpresa
		 AND	tbMonitoramento.CodigoLocal = @CodigoLocal
		 AND	tbMonitoramento.DataMonitoramento BETWEEN @DataIni AND @DataFim
--		 AND	tbMonitoramento.DataDocumento BETWEEN @DataIni AND @DataFim
		 AND	tbMonitoramento.TipoMonitoramento = @TipoMonitoramento
		 AND	tbMonitoramento.MonitoramentoFinalizado = 'V'
		 AND	tbMonitoramento.StatusMonitoramento = 'CO'
--        AND ((tbMonitoramento.CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--	    OR  (tbMonitoramento.CodigoFabricanteVeiculo is  null and @CodigoFabricante is null)))
/*			and (tbMonitoramento.CodigoFabricanteVeiculo is null 
			or   tbMonitoramento.CodigoFabricanteVeiculo =(case when @CodigoFabricante is null 
																then tbMonitoramento.CodigoFabricanteVeiculo
																else @CodigoFabricante
															end)))
*/			and tbMonitoramento.CodigoFabricanteVeiculo = (case when @CodigoFabricante is null 
																then tbMonitoramento.CodigoFabricanteVeiculo
																else @CodigoFabricante
															end))

select @Satisfeitos = (select coalesce(COUNT(tbMonitoramento.StatusMonitoramento), 0)
		FROM tbMonitoramento (NOLOCK)
		WHERE	tbMonitoramento.CodigoEmpresa = @CodigoEmpresa
		AND	tbMonitoramento.CodigoLocal = @CodigoLocal
		AND	tbMonitoramento.DataMonitoramento BETWEEN @DataIni AND @DataFim
--	 	AND	tbMonitoramento.DataDocumento BETWEEN @DataIni AND @DataFim
		AND	tbMonitoramento.TipoMonitoramento = @TipoMonitoramento
		AND	tbMonitoramento.MonitoramentoFinalizado = 'V'
		AND	tbMonitoramento.StatusMonitoramento = 'CO'
		AND	tbMonitoramento.RespostaQuestao1 = 'V'
		AND tbMonitoramento.RespostaQuestao2 = 'V'
		AND tbMonitoramento.RespostaQuestao3 = 'V'
--        AND ((tbMonitoramento.CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--	    OR  (tbMonitoramento.CodigoFabricanteVeiculo is  null and @CodigoFabricante is null)))
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


select @Insatisfeitos = (@Total - @Satisfeitos)

if @Total > 0 begin
	select @PercSatisfeitos   = (@Satisfeitos / @Total * 100)
	select @PercInsatisfeitos = (@Insatisfeitos / @Total * 100)
end

create table #tmpSatisfacaoCli (Linha varchar(30), Valor numeric(3), Perc numeric(3))
insert into #tmpSatisfacaoCli (Linha, Valor, Perc) values ('Satisfeitos',   @Satisfeitos, @PercSatisfeitos)
insert into #tmpSatisfacaoCli (Linha, Valor, Perc) values ('Insatisfeitos', @Insatisfeitos, @PercInsatisfeitos)

SET NOCOUNT OFF

SELECT * FROM #tmpSatisfacaoCli


GO
GRANT EXECUTE ON dbo.whRelSatisfacaoCli TO SQLUsers
GO
