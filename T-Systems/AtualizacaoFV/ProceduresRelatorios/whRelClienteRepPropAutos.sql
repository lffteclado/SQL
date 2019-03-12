go
IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('whRelClienteRepPropAutos')) 
BEGIN 
	DROP PROCEDURE dbo.whRelClienteRepPropAutos
END
GO
CREATE PROCEDURE dbo.whRelClienteRepPropAutos
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda.
 PROJETO......: Força de Vendas
 AUTOR.... ...: Paulo Henrique Mauri
 DATA.........: 27/11/2008
 UTILIZADO EM : Força de Vendas - Automóveis
 OBJETIVO.....: Relatório de Clientes Por Representante / Propensão
 whRelClienteRepPropAutos 1608, 0, NULL, NULL, 'R','V'
 whRelClienteRepPropAutos 1608, 0, 1, 4, 'P','V',NULL
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/
@CodigoEmpresa numeric(4),
@CodigoLocal numeric(4),
@DoRepresentante numeric(4),
@DaPropensao numeric(4) = NULL,
@TipoRelatorio char(1),
@ImprimeEncerrado char(1), --(V) imprime encerrado, falso imprime tudo
@CodigoFabricante char(5) = NULL

AS

SET NOCOUNT ON


update tbMonitoramento set CodigoFabricanteVeiculo = null where ltrim(rtrim(CodigoFabricanteVeiculo)) = ''


-----------------------------------------------------------------------------------------
-- Relatorio por Representante 
-----------------------------------------------------------------------------------------
IF @TipoRelatorio = 'R' BEGIN	
	SELECT tbFichaContato.CodigoEmpresa,
	tbFichaContato.CodigoLocal,
	tbFichaContato.NumeroFichaContato,
	tbFichaContato.StatusFichaContato,
	tbFichaContato.DataHoraInicioFichaContato,
	tbFichaContato.DataHoraTerminoFichaContato,
	tbFichaContato.CodigoClientePF,
	tbFichaContato.TipoClientePF,
	tbFichaContato.CodigoClientePJ,
	tbFichaContato.TipoClientePJ,
	tbFichaContato.CodigoRepresentante,
	tbFichaContato.ObservacaoFichaContato,
	(select top 1 tbFichaContatoHistorico.PropensaoCompra 
	from tbFichaContatoHistorico (nolock)
	where tbFichaContatoHistorico.CodigoEmpresa = tbFichaContato.CodigoEmpresa 
	and tbFichaContatoHistorico.CodigoLocal = tbFichaContato.CodigoLocal  
	and tbFichaContatoHistorico.NumeroFichaContato = tbFichaContato.NumeroFichaContato
	and tbFichaContatoHistorico.DataContatoHistorico = (select max(fch.DataContatoHistorico) 
							from tbFichaContatoHistorico fch (nolock)
							where fch.CodigoEmpresa = tbFichaContato.CodigoEmpresa 
							and fch.CodigoLocal = tbFichaContato.CodigoLocal  
							and fch.NumeroFichaContato = tbFichaContato.NumeroFichaContato)
							) as PropensaoCompra

	INTO #tmpFichaContatoRepres
	FROM tbFichaContato (NOLOCK)

	INNER JOIN tbFichaContatoVeicInteresse
	ON  tbFichaContatoVeicInteresse.CodigoEmpresa = tbFichaContato.CodigoEmpresa 
	AND tbFichaContatoVeicInteresse.CodigoLocal = tbFichaContato.CodigoLocal
	AND tbFichaContatoVeicInteresse.NumeroFichaContato = tbFichaContato.NumeroFichaContato
	AND tbFichaContatoVeicInteresse.ItemFichaContatoVeiculo = 1

	INNER JOIN tbFabricanteVeiculo 
	ON  tbFabricanteVeiculo.CodigoEmpresa = tbFichaContatoVeicInteresse.CodigoEmpresa
	AND tbFabricanteVeiculo.CodigoFabricante = tbFichaContatoVeicInteresse.CodigoFabricante

	WHERE tbFichaContato.CodigoEmpresa = @CodigoEmpresa
	AND tbFichaContato.CodigoLocal = @CodigoLocal
	AND  ((tbFichaContato.StatusFichaContato IS NOT NULL AND @ImprimeEncerrado = 'V')
	     OR (tbFichaContato.StatusFichaContato = 'EM ANDAMENTO' AND @ImprimeEncerrado = 'F'))
	AND (tbFichaContato.CodigoRepresentante = @DoRepresentante OR @DoRepresentante IS NULL)
	AND ((tbFabricanteVeiculo.CodigoFabricante = @CodigoFabricante AND @CodigoFabricante IS NOT NULL) 
			OR (tbFabricanteVeiculo.CodigoFabricante IS NOT NULL AND @CodigoFabricante IS NULL))
	


	-----------------------------------------------------------------------------------------
	SELECT DISTINCT 
	Contador = 1, 
	#tmpFichaContatoRepres.CodigoEmpresa,
	#tmpFichaContatoRepres.CodigoLocal,
	#tmpFichaContatoRepres.NumeroFichaContato,
	CASE WHEN #tmpFichaContatoRepres.CodigoClientePF IS NOT NULL THEN
		CASE WHEN #tmpFichaContatoRepres.TipoClientePF = 'E' THEN tbCliFor.CodigoCliFor
		ELSE tbClientePotencial.CodigoClientePotencial
		END
	ELSE
		CASE WHEN #tmpFichaContatoRepres.TipoClientePJ = 'E' THEN tbCliFor.CodigoCliFor
		ELSE tbClientePotencial.CodigoClientePotencial
		END
	END AS CodigoCliente,

	CASE WHEN #tmpFichaContatoRepres.CodigoClientePF IS NOT NULL THEN
		CASE WHEN #tmpFichaContatoRepres.TipoClientePF = 'E' THEN tbCliFor.NomeCliFor
		ELSE tbClientePotencial.RazaoSocialClientePotencial
		END
	ELSE
		CASE WHEN #tmpFichaContatoRepres.TipoClientePJ = 'E' THEN tbCliFor.NomeCliFor
		ELSE tbClientePotencial.RazaoSocialClientePotencial
		END
	END AS NomeCliente,

	#tmpFichaContatoRepres.CodigoRepresentante,
	tbRepresentanteComplementar.NomeRepresentante,
	--Municipio
	CASE WHEN #tmpFichaContatoRepres.CodigoClientePF IS NOT NULL THEN 
		CASE WHEN #tmpFichaContatoRepres.TipoClientePF = 'E' THEN tbCliFor.MunicipioCliFor
		ELSE tbClientePotencial.MunicipioClientePotencial
		END
	ELSE
		CASE WHEN #tmpFichaContatoRepres.TipoClientePJ = 'E' THEN tbCliFor.MunicipioCliFor
		ELSE tbClientePotencial.MunicipioClientePotencial
		END
	END AS Municipio,
	--UF
	CASE WHEN #tmpFichaContatoRepres.CodigoClientePF IS NOT NULL THEN
		CASE WHEN #tmpFichaContatoRepres.TipoClientePF = 'E' THEN tbCliFor.UFCliFor
		ELSE tbClientePotencial.UnidadeFederacao
		END
	ELSE
		CASE WHEN #tmpFichaContatoRepres.TipoClientePJ = 'E' THEN tbCliFor.UFCliFor
		ELSE tbClientePotencial.UnidadeFederacao
		END
	END AS UnidadeFederacao,

	#tmpFichaContatoRepres.PropensaoCompra, 
	(select DescrPropCompra from tbPropensaoCompraST pc (nolock)
	where pc.CodigoEmpresa = #tmpFichaContatoRepres.CodigoEmpresa
	and pc.CodigoLocal = #tmpFichaContatoRepres.CodigoLocal
	and pc.PropensaoCompra = #tmpFichaContatoRepres.PropensaoCompra) as DescricaoPropensao,

	(select Max(tbFichaContatoHistorico.DataContatoHistorico) 
	from tbFichaContatoHistorico (nolock)
	where tbFichaContatoHistorico.CodigoEmpresa = #tmpFichaContatoRepres.CodigoEmpresa 
	and tbFichaContatoHistorico.CodigoLocal = #tmpFichaContatoRepres.CodigoLocal  
	and tbFichaContatoHistorico.NumeroFichaContato = #tmpFichaContatoRepres.NumeroFichaContato) as 'DataContatoHistorico'

	FROM #tmpFichaContatoRepres (NOLOCK)
  
	LEFT JOIN tbClientePotencial (NOLOCK) 
	ON tbClientePotencial.CodigoEmpresa = #tmpFichaContatoRepres.CodigoEmpresa
	AND tbClientePotencial.CodigoClientePotencial = COALESCE(#tmpFichaContatoRepres.CodigoClientePF,#tmpFichaContatoRepres.CodigoClientePJ)
	
	LEFT JOIN tbCliFor (NOLOCK)
	ON tbCliFor.CodigoEmpresa = #tmpFichaContatoRepres.CodigoEmpresa
	AND tbCliFor.CodigoCliFor = COALESCE(#tmpFichaContatoRepres.CodigoClientePF,#tmpFichaContatoRepres.CodigoClientePJ)
	
	LEFT JOIN tbCliForFisica (NOLOCK)
	ON tbCliForFisica.CodigoEmpresa = tbCliFor.CodigoEmpresa
	AND tbCliForFisica.CodigoCliFor  = tbCliFor.CodigoCliFor
	
	LEFT JOIN tbCliForJuridica (NOLOCK)
	ON tbCliForJuridica.CodigoEmpresa = tbCliFor.CodigoEmpresa
	AND tbCliForJuridica.CodigoCliFor  = tbCliFor.CodigoCliFor

	LEFT JOIN tbPropensaoCompraST (NOLOCK)
	ON tbPropensaoCompraST.CodigoEmpresa = #tmpFichaContatoRepres.CodigoEmpresa
	AND   tbPropensaoCompraST.CodigoLocal = #tmpFichaContatoRepres.CodigoLocal
	AND tbPropensaoCompraST.PropensaoCompra = #tmpFichaContatoRepres.PropensaoCompra

	LEFT JOIN tbRepresentante (NOLOCK)
	ON tbRepresentante.CodigoEmpresa = #tmpFichaContatoRepres.CodigoEmpresa
	AND tbRepresentante.CodigoRepresentante = #tmpFichaContatoRepres.CodigoRepresentante
	
	LEFT JOIN tbRepresentanteComplementar (NOLOCK)
	ON tbRepresentanteComplementar.CodigoEmpresa = tbRepresentante.CodigoEmpresa
	AND tbRepresentanteComplementar.CodigoRepresentante = tbRepresentante.CodigoRepresentante

	WHERE #tmpFichaContatoRepres.CodigoEmpresa = @CodigoEmpresa
	AND #tmpFichaContatoRepres.CodigoLocal = @CodigoLocal
	AND #tmpFichaContatoRepres.PropensaoCompra = isnull(@DaPropensao, #tmpFichaContatoRepres.PropensaoCompra)

	ORDER BY #tmpFichaContatoRepres.PropensaoCompra desc, #tmpFichaContatoRepres.CodigoRepresentante
	DROP TABLE #tmpFichaContatoRepres
 
END

ELSE 

-----------------------------------------------------------------------------------------
-- P = Relatorio por Propensao
-----------------------------------------------------------------------------------------
BEGIN

	SELECT tbFichaContato.CodigoEmpresa,
	tbFichaContato.CodigoLocal,
	tbFichaContato.NumeroFichaContato,
	tbFichaContato.StatusFichaContato,
	tbFichaContato.DataHoraInicioFichaContato,
	tbFichaContato.DataHoraTerminoFichaContato,
	tbFichaContato.CodigoClientePF,
	tbFichaContato.TipoClientePF,
	tbFichaContato.CodigoClientePJ,
	tbFichaContato.TipoClientePJ,
	tbFichaContato.CodigoRepresentante,
	tbFichaContato.ObservacaoFichaContato,
	(select top 1 tbFichaContatoHistorico.PropensaoCompra 
	from tbFichaContatoHistorico (nolock)
	where tbFichaContatoHistorico.CodigoEmpresa = tbFichaContato.CodigoEmpresa 
	and tbFichaContatoHistorico.CodigoLocal = tbFichaContato.CodigoLocal  
	and tbFichaContatoHistorico.NumeroFichaContato = tbFichaContato.NumeroFichaContato
	and tbFichaContatoHistorico.DataContatoHistorico = (select max(fch.DataContatoHistorico) 
							from tbFichaContatoHistorico fch (nolock)
							where fch.CodigoEmpresa = tbFichaContato.CodigoEmpresa 
							and fch.CodigoLocal = tbFichaContato.CodigoLocal  
							and fch.NumeroFichaContato = tbFichaContato.NumeroFichaContato)
							) as PropensaoCompra

	INTO #tmpFichaContatoRepresP
	FROM tbFichaContato (NOLOCK)

	INNER JOIN tbFichaContatoVeicInteresse
	ON  tbFichaContatoVeicInteresse.CodigoEmpresa = tbFichaContato.CodigoEmpresa 
	AND tbFichaContatoVeicInteresse.CodigoLocal = tbFichaContato.CodigoLocal
	AND tbFichaContatoVeicInteresse.NumeroFichaContato = tbFichaContato.NumeroFichaContato
	AND tbFichaContatoVeicInteresse.ItemFichaContatoVeiculo = 1

	INNER JOIN tbFabricanteVeiculo 
	ON  tbFabricanteVeiculo.CodigoEmpresa = tbFichaContatoVeicInteresse.CodigoEmpresa
	AND tbFabricanteVeiculo.CodigoFabricante = tbFichaContatoVeicInteresse.CodigoFabricante

	WHERE tbFichaContato.CodigoEmpresa = @CodigoEmpresa
	AND tbFichaContato.CodigoLocal = @CodigoLocal
	AND  ((tbFichaContato.StatusFichaContato IS NOT NULL AND @ImprimeEncerrado = 'V')
	    OR (tbFichaContato.StatusFichaContato = 'EM ANDAMENTO' AND @ImprimeEncerrado = 'F'))
	AND (tbFichaContato.CodigoRepresentante = @DoRepresentante OR @DoRepresentante IS NULL)
	AND ((tbFabricanteVeiculo.CodigoFabricante = @CodigoFabricante AND @CodigoFabricante IS NOT NULL) 
			OR (tbFabricanteVeiculo.CodigoFabricante IS NOT NULL AND @CodigoFabricante IS NULL))


	-----------------------------------------------------------------------------------------
	SELECT DISTINCT 
	Contador = 1, 
	#tmpFichaContatoRepresP.CodigoEmpresa,
	#tmpFichaContatoRepresP.CodigoLocal,
	#tmpFichaContatoRepresP.NumeroFichaContato,
	CASE WHEN #tmpFichaContatoRepresP.CodigoClientePF IS NOT NULL THEN
		CASE WHEN #tmpFichaContatoRepresP.TipoClientePF = 'E' THEN tbCliFor.CodigoCliFor
		ELSE tbClientePotencial.CodigoClientePotencial
		END
	ELSE
		CASE WHEN #tmpFichaContatoRepresP.TipoClientePJ = 'E' THEN tbCliFor.CodigoCliFor
		ELSE tbClientePotencial.CodigoClientePotencial
		END
	END AS CodigoCliente,

	CASE WHEN #tmpFichaContatoRepresP.CodigoClientePF IS NOT NULL THEN
		CASE WHEN #tmpFichaContatoRepresP.TipoClientePF = 'E' THEN tbCliFor.NomeCliFor
		ELSE tbClientePotencial.RazaoSocialClientePotencial
		END
	ELSE
		CASE WHEN #tmpFichaContatoRepresP.TipoClientePJ = 'E' THEN tbCliFor.NomeCliFor
		ELSE tbClientePotencial.RazaoSocialClientePotencial
		END
	END AS NomeCliente,

	#tmpFichaContatoRepresP.CodigoRepresentante,
	tbRepresentanteComplementar.NomeRepresentante,

	--Municipio
	CASE WHEN #tmpFichaContatoRepresP.CodigoClientePF IS NOT NULL THEN
		CASE WHEN #tmpFichaContatoRepresP.TipoClientePF = 'E' THEN tbCliFor.MunicipioCliFor
		ELSE tbClientePotencial.MunicipioClientePotencial
		END
	ELSE
		CASE WHEN #tmpFichaContatoRepresP.TipoClientePJ = 'E' THEN tbCliFor.MunicipioCliFor
		ELSE tbClientePotencial.MunicipioClientePotencial
		END
	END AS Municipio,

	--UF
	CASE WHEN #tmpFichaContatoRepresP.CodigoClientePF IS NOT NULL THEN
		CASE WHEN #tmpFichaContatoRepresP.TipoClientePF = 'E' THEN tbCliFor.UFCliFor
		ELSE tbClientePotencial.UnidadeFederacao
		END
	ELSE
		CASE WHEN #tmpFichaContatoRepresP.TipoClientePJ = 'E' THEN tbCliFor.UFCliFor
		ELSE tbClientePotencial.UnidadeFederacao
		END
	END AS UnidadeFederacao,
	
	#tmpFichaContatoRepresP.PropensaoCompra, 
	(select DescrPropCompra from tbPropensaoCompraST pc (nolock)
	where pc.CodigoEmpresa = #tmpFichaContatoRepresP.CodigoEmpresa
	and pc.CodigoLocal = #tmpFichaContatoRepresP.CodigoLocal
	and pc.PropensaoCompra = #tmpFichaContatoRepresP.PropensaoCompra) as DescricaoPropensao,
	
	(select Max(tbFichaContatoHistorico.DataContatoHistorico) 
	from tbFichaContatoHistorico (nolock)
	where tbFichaContatoHistorico.CodigoEmpresa = #tmpFichaContatoRepresP.CodigoEmpresa 
	and tbFichaContatoHistorico.CodigoLocal = #tmpFichaContatoRepresP.CodigoLocal  
	and tbFichaContatoHistorico.NumeroFichaContato = #tmpFichaContatoRepresP.NumeroFichaContato) as 'DataContatoHistorico'


	FROM #tmpFichaContatoRepresP (NOLOCK)
	
	LEFT JOIN tbClientePotencial (NOLOCK) 
	ON tbClientePotencial.CodigoEmpresa = #tmpFichaContatoRepresP.CodigoEmpresa
	AND tbClientePotencial.CodigoClientePotencial = COALESCE(#tmpFichaContatoRepresP.CodigoClientePF,#tmpFichaContatoRepresP.CodigoClientePJ)
	
	LEFT JOIN tbCliFor (NOLOCK)
	ON tbCliFor.CodigoEmpresa = #tmpFichaContatoRepresP.CodigoEmpresa
	AND tbCliFor.CodigoCliFor = COALESCE(#tmpFichaContatoRepresP.CodigoClientePF,#tmpFichaContatoRepresP.CodigoClientePJ)
	
	LEFT JOIN tbCliForFisica (NOLOCK)
	ON tbCliForFisica.CodigoEmpresa = tbCliFor.CodigoEmpresa
	AND tbCliForFisica.CodigoCliFor  = tbCliFor.CodigoCliFor
	
	LEFT JOIN tbCliForJuridica (NOLOCK)
	ON tbCliForJuridica.CodigoEmpresa = tbCliFor.CodigoEmpresa
	AND tbCliForJuridica.CodigoCliFor  = tbCliFor.CodigoCliFor
	
	LEFT JOIN tbPropensaoCompraST (NOLOCK)
	ON tbPropensaoCompraST.CodigoEmpresa = #tmpFichaContatoRepresP.CodigoEmpresa
	AND   tbPropensaoCompraST.CodigoLocal = #tmpFichaContatoRepresP.CodigoLocal
	AND tbPropensaoCompraST.PropensaoCompra = #tmpFichaContatoRepresP.PropensaoCompra
	
	LEFT JOIN tbRepresentante (NOLOCK)
	ON tbRepresentante.CodigoEmpresa = #tmpFichaContatoRepresP.CodigoEmpresa
	AND tbRepresentante.CodigoRepresentante = #tmpFichaContatoRepresP.CodigoRepresentante
	
	LEFT JOIN tbRepresentanteComplementar (NOLOCK)
	ON tbRepresentanteComplementar.CodigoEmpresa = tbRepresentante.CodigoEmpresa
	AND tbRepresentanteComplementar.CodigoRepresentante = tbRepresentante.CodigoRepresentante
	
	WHERE #tmpFichaContatoRepresP.CodigoEmpresa = @CodigoEmpresa
	AND #tmpFichaContatoRepresP.CodigoLocal = @CodigoLocal
	AND #tmpFichaContatoRepresP.PropensaoCompra = isnull(@DaPropensao, #tmpFichaContatoRepresP.PropensaoCompra)
	
	ORDER BY #tmpFichaContatoRepresP.CodigoRepresentante, #tmpFichaContatoRepresP.PropensaoCompra desc
	DROP TABLE #tmpFichaContatoRepresP

END

SET NOCOUNT OFF


GO
GRANT EXECUTE ON dbo.whRelClienteRepPropAutos TO SQLUsers
GO