go
IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('whRelSatisfacaoCliMensal')) begin
	DROP PROCEDURE dbo.whRelSatisfacaoCliMensal end
GO
CREATE PROCEDURE dbo.whRelSatisfacaoCliMensal
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: Monitoramento
 AUTOR........: Paulo Henrique Mauri
 DATA.........: 05/Mar/2009	
 UTILIZADO EM : 
 OBJETIVO.....: Emitir relatório de Satisfação de Clientes para Monitoramento
 
whRelSatisfacaoCliMensal 1608, 0, 'VD', '2009-01-01', '2009-12-31','039'
whRelSatisfacaoCliMensal 1608, 0, 'PV', '2009-01-01', '2009-12-31',null
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa		NUMERIC(4),
@CodigoLocal		NUMERIC(4),
@TipoMonitoramento	CHAR(2),
@DataIni		DATETIME,
@DataFim		DATETIME,
@CodigoFabricante CHAR(5) = NULL

AS

SET NOCOUNT ON

DECLARE @Mes  			numeric(2)
declare @TotalMonitMes 		numeric(4)
DECLARE @TotalSatisfeitosMes 	numeric(4)
declare @Perc			numeric(6,2)


update tbMonitoramento set CodigoFabricanteVeiculo = null where ltrim(rtrim(CodigoFabricanteVeiculo)) = ''


----------------------------------------------------------------- Criar Tabela temporaria
CREATE TABLE #tmpSatisfacaoCliMensal (	Mes NUMERIC(2), 
					TotalMes NUMERIC(4), 
					Perc NUMERIC(3), 
					TotalSatisfeitosMes numeric(4))

SET @Mes = 1

WHILE @Mes <= 12
BEGIN
	select @TotalMonitMes = 0, @TotalSatisfeitosMes = 0

	--------------------------------------------- Calcular Total de Satisfeitos do Mes
	select @TotalSatisfeitosMes = (	select count(*) from tbMonitoramento (nolock)
				 	where 	CodigoEmpresa = @CodigoEmpresa
				 	and 	CodigoLocal = @CodigoLocal
				 	and 	TipoMonitoramento = @TipoMonitoramento
				 	and 	MonitoramentoFinalizado = 'V'
				 	and 	StatusMonitoramento = 'CO'
					and	month(DataMonitoramento) = @Mes
					and	year(DataMonitoramento) = year(@DataIni)
				 	and 	(RespostaQuestao1 = 'V' and RespostaQuestao2 = 'V' and RespostaQuestao3 = 'V')
--					and		((CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--					or		(CodigoFabricanteVeiculo is  null and @CodigoFabricante is null)))
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

	----------------------------------------- Calcular Total de Monitoramentos do Mes
	select @TotalMonitMes = (	select count(*) from tbMonitoramento (nolock)
				 	where 	CodigoEmpresa = @CodigoEmpresa
				 	and 	CodigoLocal = @CodigoLocal
				 	and 	TipoMonitoramento = @TipoMonitoramento
				 	and 	MonitoramentoFinalizado = 'V'
				 	and 	StatusMonitoramento = 'CO'
					and	month(DataMonitoramento) = @Mes
					and	year(DataMonitoramento) = year(@DataIni)
--					and		((CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--					or		(CodigoFabricanteVeiculo is  null and @CodigoFabricante is null)))
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

	---------------------------------------- Calcular Percentual de Satisfacao do Mes
	set @Perc = 0
	if @TotalMonitMes > 0 begin
		set @Perc = (@TotalSatisfeitosMes / @TotalMonitMes * 100)
	end

	------------------------------------------------------- Incluir tabela temporaria
	insert into #tmpSatisfacaoCliMensal (Mes, TotalMes, Perc, TotalSatisfeitosMes)
	values (@Mes, @TotalMonitMes, @Perc, @TotalSatisfeitosMes)

	--------------------------------------------------------------------- Proximo Mes
	select @Mes = @Mes + 1

END

---------------------------------------------------------------------- Retornar resultado
select Mes, TotalMes, Perc from #tmpSatisfacaoCliMensal


GO
GRANT EXECUTE ON dbo.whRelSatisfacaoCliMensal TO SQLUsers
GO