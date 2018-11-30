go
IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('whRelInsatisfacaoCli')) begin
	DROP PROCEDURE dbo.whRelInsatisfacaoCli   end
GO

CREATE PROCEDURE dbo.whRelInsatisfacaoCli
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: Monitoramento
 AUTOR........: Paulo Henrique Mauri
 DATA.........: 06/Mar/2009
 UTILIZADO EM : 
 OBJETIVO.....: Emitir relatório de Insatisfação(Pós-Vendas) para Monitoramento
 
 whRelInsatisfacaoCli 1608, 0, 'PV', '2008-01-01', '2009-12-31', '039'
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/
@CodigoEmpresa 			NUMERIC(4),
@CodigoLocal 			NUMERIC(4),
@TipoMonitoramento 		CHAR(2),
@DataIni 			DATETIME,
@DataFim 			DATETIME,
@CodigoFabricante	CHAR(5) = NULL 

AS	

set nocount on

declare @LinhaQuestao1 varchar(30)
declare @LinhaQuestao2 varchar(30)
declare @LinhaQuestao3 varchar(30)
declare @RespostaQuestao1 numeric(4)
declare @RespostaQuestao2 numeric(4)
declare @RespostaQuestao3 numeric(4)


update tbMonitoramento set CodigoFabricanteVeiculo = null where ltrim(rtrim(CodigoFabricanteVeiculo)) = ''


if @TipoMonitoramento = 'VD' begin
	select 	@LinhaQuestao1 = 'Atendimento Vendedor', 
		@LinhaQuestao2 = 'Condições Entrega Veículo', 
		@LinhaQuestao3 = 'Orientações Entrega Veículo'
end

if @TipoMonitoramento = 'PV' begin
	select 	@LinhaQuestao1 = 'Qualidade do Serviço', 
		@LinhaQuestao2 = 'Data de Entrega', 
		@LinhaQuestao3 = 'Atendimento do Consultor'
end

select @RespostaQuestao1 = (	select count(*) from tbMonitoramento 
				where CodigoEmpresa = @CodigoEmpresa
				and CodigoLocal = @CodigoLocal
				and DataMonitoramento between @DataIni and @DataFim
--				and DataDocumento between @DataIni and @DataFim
				and TipoMonitoramento = @TipoMonitoramento
				and MonitoramentoFinalizado = 'V' 
				and StatusMonitoramento = 'CO' 
				and RespostaQuestao1 = 'F'
--				and ((tbMonitoramento.CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--				or  (tbMonitoramento.CodigoFabricanteVeiculo is  null and @CodigoFabricante is null)))
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

select @RespostaQuestao2 = (	select count(*) from tbMonitoramento 
				where CodigoEmpresa = @CodigoEmpresa
				and CodigoLocal = @CodigoLocal
				and DataMonitoramento between @DataIni and @DataFim
--				and DataDocumento between @DataIni and @DataFim
				and TipoMonitoramento = @TipoMonitoramento
				and MonitoramentoFinalizado = 'V' 
				and StatusMonitoramento = 'CO' 
				and RespostaQuestao2 = 'F'
--				and ((tbMonitoramento.CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--				or  (tbMonitoramento.CodigoFabricanteVeiculo is  null and @CodigoFabricante is null)))
/*				and (tbMonitoramento.CodigoFabricanteVeiculo is null 
				or   tbMonitoramento.CodigoFabricanteVeiculo =(case when @CodigoFabricante is null 
																then tbMonitoramento.CodigoFabricanteVeiculo
																else @CodigoFabricante
															end)))
*/
			and tbMonitoramento.CodigoFabricanteVeiculo = (case when @CodigoFabricante is null 
																then tbMonitoramento.CodigoFabricanteVeiculo
																else @CodigoFabricante
															end))

select @RespostaQuestao3 = (	select count(*) from tbMonitoramento 
				where CodigoEmpresa = @CodigoEmpresa
				and CodigoLocal = @CodigoLocal
				and DataMonitoramento between @DataIni and @DataFim
--				and DataDocumento between @DataIni and @DataFim
				and TipoMonitoramento = @TipoMonitoramento
				and MonitoramentoFinalizado = 'V' 
				and StatusMonitoramento = 'CO' 
				and RespostaQuestao3 = 'F'
--				and ((CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--				or  (CodigoFabricanteVeiculo is  null and @CodigoFabricante is null)))
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

create table #tmpInsatisfacaoCli (Linha varchar(30), Total numeric(4))

insert into #tmpInsatisfacaoCli (Linha, Total) values (@LinhaQuestao1, @RespostaQuestao1)
insert into #tmpInsatisfacaoCli (Linha, Total) values (@LinhaQuestao2, @RespostaQuestao2)
insert into #tmpInsatisfacaoCli (Linha, Total) values (@LinhaQuestao3, @RespostaQuestao3)

set nocount off
select * from #tmpInsatisfacaoCli



GO
GRANT EXECUTE ON dbo.whRelInsatisfacaoCli TO SQLUsers
GO