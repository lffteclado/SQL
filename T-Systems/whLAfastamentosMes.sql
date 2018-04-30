if exists(select 1 from sysobjects where id = object_id('dbo.whLAfastamentosMes'))
begin
  drop proc dbo.whLAfastamentosMes
end
go

create proc dbo.whLAfastamentosMes
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 Projeto...: Folha de Pagamento
 Analista..: Condez
 Procedure.: whLAfastamentosMes
 Objetivo..: Calcular o numero de dias de afastamento dentro de um periodo

whLAfastamentosMes 1608,0,'F',1231,'F'
EXECUTE whLAfastamentosMes @CodigoEmpresa = 1608,@CodigoLocal = 0,@TipoColaborador = 'F',@NumeroRegistro = 4555
select * from tbHistAfastamento where CodigoEmpresa = 1608 AND NumeroRegistro = 1104
-----------------------------------------------------------------------------------------------
ALTERAÇÃO: Usei esta proc que seria eliminada, o conteudo é totalmente novo
 Desenvolvedor: Edson Marson
 Data: 27/09/2010
 Classe ou Relatorio: clsPessoal
 Sistema: Folha de Pagamento
 Motivo: Controlar 2 afastamentos no mesmo mês

ALTERAÇÃO: Edson Marson - 11/02/2011
OBJETIVO : Não Trazia rotinas com 'S' de afastamento único.
			Ticket 58151/2011 FM 8717/2011

whLAfastamentosMes 1608,0,'F',1231,'201007'
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

	@CodigoEmpresa 			dtInteiro04 = Null,
	@CodigoLocal		    dtInteiro04 = Null,	
	@TipoColaborador		varchar(01) = Null,
	@NumeroRegistro			dtInteiro08 = Null,
	@PeriodoFolha			varchar(06) = Null

AS 
select a.CodigoEmpresa, a.Rotina
from tbRotAutomaticas a, tbHistAfastamento b
where a.CodigoEmpresa           = b.CodigoEmpresa
and   a.TipoMovimentacaoColab   = b.TipoMovimentacaoColab
and   a.CodigoMovimentacaoColab = b.CodigoMovimentacaoColab
and	  b.CodigoEmpresa           = @CodigoEmpresa
and   b.CodigoLocal             = @CodigoLocal
and	  b.TipoColaborador         = @TipoColaborador
and   b.NumeroRegistro          = @NumeroRegistro
and ((CONVERT(CHAR(4),DATEPART(YEAR,b.DataInicioAfastamentoHist)) + 
	  RIGHT(100 + CONVERT(CHAR(2),DATEPART(MONTH,b.DataInicioAfastamentoHist)),2) = @PeriodoFolha) OR 
	 (CONVERT(CHAR(4),DATEPART(YEAR,b.DataTerminoAfastamentoHist)) + 
	  RIGHT(100 + CONVERT(CHAR(2),DATEPART(MONTH,b.DataTerminoAfastamentoHist)),2) = @PeriodoFolha) OR
	 (b.DataTerminoAfastamentoHist IS NULL))
and   a.CalculaRotina LIKE (case when CONVERT(CHAR(4),DATEPART(YEAR,b.DataInicioAfastamentoHist)) + 
							    		RIGHT(100 + CONVERT(CHAR(2),DATEPART(MONTH,b.DataInicioAfastamentoHist)),2) = @PeriodoFolha 
								 Then '["SIA"]'
							     when CONVERT(CHAR(4),DATEPART(YEAR,b.DataTerminoAfastamentoHist)) + 
										RIGHT(100 + CONVERT(CHAR(2),DATEPART(MONTH,b.DataTerminoAfastamentoHist)),2) = @PeriodoFolha
								 Then '["SFA"]'
							     when CONVERT(CHAR(4),DATEPART(YEAR,b.DataInicioAfastamentoHist)) + 
										RIGHT(100 + CONVERT(CHAR(2),DATEPART(MONTH,b.DataInicioAfastamentoHist)),2) = (@PeriodoFolha - 1)
								 Then '["SIA"]' 
								 else '["S"]' end )
group by a.CodigoEmpresa, a.Rotina
order by a.CodigoEmpresa, a.Rotina

go
GRANT EXECUTE ON dbo.whLAfastamentosMes TO SQLUsers
go