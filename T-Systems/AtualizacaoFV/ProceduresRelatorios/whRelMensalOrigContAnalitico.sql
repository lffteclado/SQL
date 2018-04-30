go
if exists (select * from sysobjects where name = 'whRelMensalOrigContAnalitico') begin
	drop procedure dbo.whRelMensalOrigContAnalitico
end
go
create procedure dbo.whRelMensalOrigContAnalitico
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda.
 PROJETO......: DealerPlus
 AUTOR.... ...: Paulo Henrique Mauri
 DATA.........: 23/12/2008
 UTILIZADO EM : Força de Vendas - Automóveis
 OBJETIVO.....: Relatório Mensal por Origem de Contato Analitico

 whRelMensalOrigContAnalitico 1608, 0, '2007-12-16', '2009-12-23'
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa			numeric(4),
@CodigoLocal			numeric(4),
@DataInicial			datetime,
@DataFinal				datetime,
@CodigoFabricante		char(5) = null

AS
	
	set nocount on 

	update tbMonitoramento set CodigoFabricanteVeiculo = null where ltrim(rtrim(CodigoFabricanteVeiculo)) = ''

	set nocount off


	SELECT --DISTINCT 
	--- case para pessoa Fisica ou Juridica, seja Efetivo ou Potencial
	CASE WHEN tbFichaContato.CodigoClientePF IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliFor.NomeCliFor
		ELSE
			tbClientePotencial.RazaoSocialClientePotencial
		END
	ELSE
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			tbCliFor.NomeCliFor
		ELSE
			tbClientePotencial.RazaoSocialClientePotencial
		END
	END AS Cliente,
	tbFichaContato.RecepcaoDataHora,
	tbFichaContato.NumeroFichaContato,
	COALESCE(tbFichaContato.RecepcaoOrigemContato,'') AS RecepcaoOrigemContato

	FROM tbFichaContato (NOLOCK)

	inner join tbFichaContatoVeicInteresse veic (nolock)
	on veic.CodigoEmpresa = tbFichaContato.CodigoEmpresa
	and veic.CodigoLocal = tbFichaContato.CodigoLocal
	and veic.NumeroFichaContato = tbFichaContato.NumeroFichaContato
	and veic.ItemFichaContatoVeiculo = 1
	and veic.CodigoFabricante = isnull(@CodigoFabricante, veic.CodigoFabricante)

	LEFT JOIN tbClientePotencial (NOLOCK) 
	ON	tbClientePotencial.CodigoEmpresa = tbFichaContato.CodigoEmpresa
	AND	tbClientePotencial.CodigoClientePotencial = COALESCE(tbFichaContato.CodigoClientePF,tbFichaContato.CodigoClientePJ)

	LEFT JOIN tbCliFor (NOLOCK)
	ON	tbCliFor.CodigoEmpresa = tbFichaContato.CodigoEmpresa
	AND	tbCliFor.CodigoCliFor = COALESCE(tbFichaContato.CodigoClientePF,tbFichaContato.CodigoClientePJ)

	LEFT JOIN tbCliForFisica (NOLOCK)
	ON	tbCliForFisica.CodigoEmpresa = tbCliFor.CodigoEmpresa
	AND	tbCliForFisica.CodigoCliFor  = tbCliFor.CodigoCliFor

	LEFT JOIN tbCliForJuridica (NOLOCK)
	ON	tbCliForJuridica.CodigoEmpresa = tbCliFor.CodigoEmpresa
	AND	tbCliForJuridica.CodigoCliFor  = tbCliFor.CodigoCliFor
		
	WHERE tbFichaContato.CodigoEmpresa = @CodigoEmpresa
	AND	tbFichaContato.CodigoLocal = @CodigoLocal
	AND	tbFichaContato.OrigemFichaContato = 'R'	--(R)Recepção
	AND	(tbFichaContato.RecepcaoDataHora BETWEEN @DataInicial AND @DataFinal)


go
grant execute on dbo.whRelMensalOrigContAnalitico to SQLUsers
go