if exists(select 1 from sysobjects where id = object_id('dbo.whfvaRelMonitFinalizados'))
DROP PROCEDURE dbo.whfvaRelMonitFinalizados
GO
CREATE PROCEDURE dbo.whfvaRelMonitFinalizados

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-SYSTEMS
 PROJETO......: FV Automóveis
 AUTOR........: Daniel Lemes
 DATA.........: 16/07/2009
 UTILIZADO EM : RelMonitoramentosFinalizados
 OBJETIVO.....: Listar os monitoramentos finalizados
 dbo.whfvaRelMonitoramentosFinalizados 1608,0,'200903','PV',NULL
 dbo.whfvaRelMonitoramentosFinalizados 1608,0,'200903','VD',NULL
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa		as numeric(4),
@CodigoLocal		as numeric(4),
@Periodo			as char(6),
@TipoMonitoramento	as char(2),	
@CodigoFabricante	as char(5)

AS 

SET NOCOUNT ON 

DECLARE @DataInicio   datetime
DECLARE @DataTermino  datetime

SET @DataInicio  = convert(datetime, substring(@Periodo,1,4) + substring(@Periodo,5,2) + '01')
SET @DataTermino = dateadd(day,-1,dateadd(month,+1,convert(datetime, substring(@Periodo,1,4) + substring(@Periodo,5,2) + '01')))

SELECT	mon.CodigoEmpresa,
		mon.CodigoLocal,
		mon.IdMonitoramento,
		mon.DataMonitoramento,

		CASE WHEN mon.StatusMonitoramento = 'CO' THEN 'CONCLUIDO'
			 WHEN mon.StatusMonitoramento = 'NC' THEN 'NAO CONTAT.'
			 WHEN mon.StatusMonitoramento = 'NR' THEN 'NAO RESP.'
		END AS StatusMonitoramento, 

		CASE WHEN mon.TipoCliente = 'EVENTUAL' THEN 
			coalesce(convert(varchar(14),cliEven.CodigoClienteEventual)  + ' - ' + convert(varchar(60),(cliEven.NomeCliEven)),'')
		ELSE
			coalesce(convert(varchar(14),cli.CodigoCliFor) + ' - ' +  convert(varchar(60),(cli.NomeCliFor)),'')
		END AS 'CLIENTE',

		coalesce(mon.DataDocumento,'') DataDocumento,
		mon.NumeroDocumento,

		CASE 
			WHEN mon.DataHoraLigacao5 is not null THEN 
				 convert(varchar(10), mon.DataHoraLigacao5, 103) + replicate('  ',2)
				+ ltrim(rtrim(usu.NomeUsuario)) + replicate('  ',2) + rtrim(ltrim(mon.ObservacaoLigacao5))
			 WHEN mon.DataHoraLigacao4 is not null THEN 
				 convert(varchar(10), mon.DataHoraLigacao4, 103) + replicate('  ',2)
				+ ltrim(rtrim(usu.NomeUsuario)) + replicate('  ',2) + rtrim(ltrim(mon.ObservacaoLigacao4))
			WHEN mon.DataHoraLigacao3 is not null THEN 
				 convert(varchar(10), mon.DataHoraLigacao3, 103) + replicate('  ',2)
				+ ltrim(rtrim(usu.NomeUsuario)) + replicate('  ',2) + rtrim(ltrim(mon.ObservacaoLigacao3))
			WHEN mon.DataHoraLigacao2 is not null THEN 
				 convert(varchar(10), mon.DataHoraLigacao2, 103) + replicate('  ',2)
			   + ltrim(rtrim(usu.NomeUsuario)) + replicate('  ',2) + rtrim(ltrim(mon.ObservacaoLigacao2))
			WHEN mon.DataHoraLigacao1 is not null THEN 
				 convert(varchar(10), mon.DataHoraLigacao1, 103) + replicate('  ',2)
				+ ltrim(rtrim(usu.NomeUsuario)) + replicate('  ',2) + rtrim(ltrim(mon.ObservacaoLigacao1))
			END AS 'Ultimo Atendimento',
			
			coalesce(mon.CodigoFabricanteVeiculo,'####')CodigoFabricanteVeiculo,
			fab.DescricaoFabricanteVeic
		 
FROM tbMonitoramento mon (nolock)

LEFT JOIN tbCliFor cli (nolock)
ON  cli.CodigoEmpresa = mon.CodigoEmpresa
AND cli.CodigoCliFor  = mon.CodigoCliFor

LEFT JOIN tbClienteEventual cliEven (nolock)
ON  cliEven.CodigoEmpresa = mon.CodigoEmpresa
AND cliEven.CodigoClienteEventual  = mon.CodigoClienteEventual

LEFT JOIN tbFabricanteVeiculo fab (nolock)
ON  fab.CodigoEmpresa = mon.CodigoEmpresa
AND fab.CodigoFabricante  = mon.CodigoFabricanteVeiculo

INNER JOIN tbUsuarios usu(nolock)
ON usu.CodigoUsuario  =  (select case 
									 when tbMonitoramento.UltimoAtendimento1 is not NULL then mon.UltimoAtendimento1  
									 when tbMonitoramento.UltimoAtendimento2 is not NULL then mon.UltimoAtendimento2 
									 when tbMonitoramento.UltimoAtendimento3 is not NULL then mon.UltimoAtendimento3  
									 when tbMonitoramento.UltimoAtendimento4 is not NULL then mon.UltimoAtendimento4 
									 when tbMonitoramento.UltimoAtendimento5 is not NULL then mon.UltimoAtendimento5 	
								 end 
							from tbMonitoramento  (nolock)
							where tbMonitoramento.CodigoEmpresa = @CodigoEmpresa
							and tbMonitoramento.CodigoLocal = @CodigoLocal
							and tbMonitoramento.IdMonitoramento = mon.IdMonitoramento)



WHERE mon.CodigoEmpresa = @CodigoEmpresa
AND   mon.CodigoLocal   = @CodigoLocal
AND   mon.TipoMonitoramento = @TipoMonitoramento
AND   mon.MonitoramentoFinalizado = 'V'
AND   mon.DataMonitoramento BETWEEN @DataInicio AND @DataTermino 
--AND ((mon.CodigoFabricanteVeiculo = @CodigoFabricante AND @CodigoFabricante IS NOT NULL) 
--		OR (mon.CodigoFabricanteVeiculo IS NOT NULL AND @CodigoFabricante IS NULL))

and mon.CodigoFabricanteVeiculo = (case when @CodigoFabricante is null 
													then mon.CodigoFabricanteVeiculo
													else @CodigoFabricante
												end)


ORDER BY mon.IdMonitoramento,
		 mon.DataMonitoramento

SET NOCOUNT OFF 

GO 
GRANT EXECUTE ON dbo.whfvaRelMonitFinalizados TO SQLUsers
GO 