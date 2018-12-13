go
if exists(select 1 from sysobjects where id = object_id('whRelComentariosInsatisf')) begin
DROP PROCEDURE dbo.whRelComentariosInsatisf end

GO
CREATE PROCEDURE dbo.whRelComentariosInsatisf
/*INICIO_CABEC_PROC
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: StarClass Automoveis
 AUTOR........: Marcio Schvartz
 DATA.........: 05/03/2009
 UTILIZADO EM : frmfvaRelComentariosInsatisfacao
 OBJETIVO.....: Listar os clientes que fizeram comentarios
 ALTERACAO....: 
 OBJETIVO.....: 

EXECUTE whRelComentariosInsatisf 1608, 0,'2008-01-01', '2009-12-31','PV',3,'001'
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa          dtInteiro04,
@CodigoLocal   		  	dtInteiro04,
@DataDocumentoInicio	datetime,
@DataDocumentoFim		datetime,
@TipoMonitoramento		char(2),
@Questao				numeric(2),
@CodigoFabricante		char(5) = null

WITH ENCRYPTION
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

update tbMonitoramento set CodigoFabricanteVeiculo = null where ltrim(rtrim(CodigoFabricanteVeiculo)) = ''


if @Questao = 1 begin
	select @Questao as 'Questao', mon.IdMonitoramento, mon.DataDocumento, mon.TipoMonitoramento, 
	mon.TipoCliente, mon.CodigoCliFor, cf.NomeCliFor, mon.CodigoClienteEventual, cliev.NomeCliEven,
	mon.MotivoQuestao1 
	from tbMonitoramento mon (nolock)
	inner join tbCliFor cf (nolock)
	on cf.CodigoEmpresa = mon.CodigoEmpresa
	and cf.CodigoCliFor = mon.CodigoCliFor
	left join tbClienteEventual cliev (nolock)
	on cliev.CodigoEmpresa = mon.CodigoEmpresa
	and cliev.CodigoClienteEventual = mon.CodigoClienteEventual
	where mon.CodigoEmpresa = @CodigoEmpresa 
	and mon.CodigoLocal = @CodigoLocal
	and mon.TipoMonitoramento = @TipoMonitoramento
	and mon.DataMonitoramento between @DataDocumentoInicio and @DataDocumentoFim
	and mon.MonitoramentoFinalizado = 'V' 
	and mon.StatusMonitoramento = 'CO'
	and (MotivoQuestao1 <> '' or MotivoQuestao1 is null)
--	and mon.CodigoFabricanteVeiculo = isnull(@CodigoFabricante, mon.CodigoFabricanteVeiculo)

--	AND ((mon.CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--	OR  (mon.CodigoFabricanteVeiculo is  null and @CodigoFabricante is null)) 
	
	and mon.CodigoFabricanteVeiculo = (case when @CodigoFabricante is null 
														then mon.CodigoFabricanteVeiculo
														else @CodigoFabricante
													end)

end

if @Questao = 2 begin
	select @Questao as 'Questao', mon.IdMonitoramento, mon.DataDocumento, mon.TipoMonitoramento, 
	mon.TipoCliente, mon.CodigoCliFor, cf.NomeCliFor, mon.CodigoClienteEventual, cliev.NomeCliEven,
	mon.MotivoQuestao2
	from tbMonitoramento mon (nolock)
	inner join tbCliFor cf (nolock)
	on cf.CodigoEmpresa = mon.CodigoEmpresa
	and cf.CodigoCliFor = mon.CodigoCliFor
	left join tbClienteEventual cliev (nolock)
	on cliev.CodigoEmpresa = mon.CodigoEmpresa
	and cliev.CodigoClienteEventual = mon.CodigoClienteEventual
	where mon.CodigoEmpresa = @CodigoEmpresa 
	and mon.CodigoLocal = @CodigoLocal
	and mon.TipoMonitoramento = @TipoMonitoramento
	and mon.DataMonitoramento between @DataDocumentoInicio and @DataDocumentoFim
	and mon.MonitoramentoFinalizado = 'V' 
	and mon.StatusMonitoramento = 'CO' 
	and (MotivoQuestao2 <> '' or MotivoQuestao2 is null)
--	and mon.CodigoFabricanteVeiculo = isnull(@CodigoFabricante, mon.CodigoFabricanteVeiculo)

--	AND ((mon.CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--	OR  (mon.CodigoFabricanteVeiculo is  null and @CodigoFabricante is null)) 

	and mon.CodigoFabricanteVeiculo = (case when @CodigoFabricante is null 
														then mon.CodigoFabricanteVeiculo
														else @CodigoFabricante
													end)

end

if @Questao = 3 begin
	select @Questao as 'Questao', mon.IdMonitoramento, mon.DataDocumento, mon.TipoMonitoramento, 
	mon.TipoCliente, mon.CodigoCliFor, cf.NomeCliFor, mon.CodigoClienteEventual, cliev.NomeCliEven,
	mon.MotivoQuestao3
	from tbMonitoramento mon (nolock)
	inner join tbCliFor cf (nolock)
	on cf.CodigoEmpresa = mon.CodigoEmpresa
	and cf.CodigoCliFor = mon.CodigoCliFor
	left join tbClienteEventual cliev (nolock)
	on cliev.CodigoEmpresa = mon.CodigoEmpresa
	and cliev.CodigoClienteEventual = mon.CodigoClienteEventual
	where mon.CodigoEmpresa = @CodigoEmpresa 
	and mon.CodigoLocal = @CodigoLocal
	and mon.TipoMonitoramento = @TipoMonitoramento
	and mon.DataMonitoramento between @DataDocumentoInicio and @DataDocumentoFim
	and mon.MonitoramentoFinalizado = 'V' 
	and mon.StatusMonitoramento = 'CO' 
	and (MotivoQuestao3 <> '' or MotivoQuestao3 is null)
--	and mon.CodigoFabricanteVeiculo = isnull(@CodigoFabricante, mon.CodigoFabricanteVeiculo)

--	AND ((mon.CodigoFabricanteVeiculo = @CodigoFabricante and @CodigoFabricante is not null) 
--	OR  (mon.CodigoFabricanteVeiculo is  null and @CodigoFabricante is null)) 

	and mon.CodigoFabricanteVeiculo = (case when @CodigoFabricante is null 
														then mon.CodigoFabricanteVeiculo
														else @CodigoFabricante
													end)

end

SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whRelComentariosInsatisf TO SQLUsers
GO
