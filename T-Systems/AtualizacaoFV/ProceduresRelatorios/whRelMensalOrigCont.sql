go
if exists (select * from sysobjects where name = 'whRelMensalOrigCont') begin
	drop procedure dbo.whRelMensalOrigCont
end
go
create procedure dbo.whRelMensalOrigCont
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda.
 PROJETO......: DealerPlus
 AUTOR.... ...: Paulo Henrique Mauri
 DATA.........: 23/12/2008
 UTILIZADO EM : Força de Vendas - Automóveis
 OBJETIVO.....: Relatório Mensal por Origem de Contato

 whRelMensalOrigCont 1608, 0, '2007-12-16', '2008-12-23', '006'
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa			numeric(4),
@CodigoLocal			numeric(4),
@DataInicial			datetime,
@DataFinal				datetime,
@CodigoFabricante		char(5) = null

AS
	SET NOCOUNT ON

	update tbMonitoramento set CodigoFabricanteVeiculo = null where ltrim(rtrim(CodigoFabricanteVeiculo)) = ''


	SELECT --DISTINCT 
		CASE	WHEN LTRIM(RTRIM(RecepcaoOrigemContato)) = '' THEN ''
				WHEN RecepcaoOrigemContato IS NULL THEN ''
				ELSE LTRIM(RTRIM(RecepcaoOrigemContato))
		END AS RecepcaoOrigemContato,
		CodigoRepresentante

	INTO #TMP_RECEPCAO
	FROM tbFichaContato (NOLOCK)
	inner join tbFichaContatoVeicInteresse veic (nolock)
	on veic.CodigoEmpresa = tbFichaContato.CodigoEmpresa
	and veic.CodigoLocal = tbFichaContato.CodigoLocal
	and veic.NumeroFichaContato = tbFichaContato.NumeroFichaContato
	and veic.ItemFichaContatoVeiculo = 1
	and veic.CodigoFabricante = isnull(@CodigoFabricante, veic.CodigoFabricante)

	WHERE tbFichaContato.CodigoEmpresa = @CodigoEmpresa
	AND	tbFichaContato.CodigoLocal = @CodigoLocal
	AND	tbFichaContato.OrigemFichaContato = 'R'	--(R)Recepção
	AND	(tbFichaContato.RecepcaoDataHora BETWEEN @DataInicial AND @DataFinal)
	


	SELECT RecepcaoOrigemContato, COUNT(CodigoRepresentante) AS Quantidade
	FROM #TMP_RECEPCAO 
	GROUP BY RecepcaoOrigemContato

	DROP TABLE #TMP_RECEPCAO

go
grant execute on dbo.whRelMensalOrigCont to SQLUsers
go