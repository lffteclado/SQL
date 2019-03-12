SELECT distinct RTRIM(LTRIM(l.CGCLocal)) AS concessao,
	   RTRIM(LTRIM(cc.CodigoCliFor)) AS cliente ,		
	   RTRIM(LTRIM(fb.DescricaoFabricanteVeic)) AS marca,
	   RTRIM(LTRIM(fr.ModeloVeiculo))	AS modelo,
       RTRIM(LTRIM(fr.Categoria)) AS segmento,
	   RTRIM(LTRIM(fr.QtdeVeiculosFrotaCliente)) AS quantidade,
	   RTRIM(LTRIM(fr.AnoFabricacaoFrotaCliente)) AS ano,
	   CASE WHEN fr.PossuiOnus  = 'N' THEN 'NÃO'
	        ELSE NULL
	   END AS possuiOnus,
	   CASE WHEN fr.PossuiSeguro  = 'N' THEN 'F'
			ELSE NULL
	   END AS PossuiSeguro,
	   RTRIM(LTRIM(fr.KmMediaMensal)) AS kmMediaUnitaria   			   	
FROM tbFrotaCliente AS fr INNER JOIN tbLocal AS l on fr.CodigoEmpresa = l.CodigoEmpresa inner join tbClienteComplementar AS cc on
fr.NumeroClientePotencialEfetivo = cc.CodigoCliFor inner join tbFabricanteVeiculo AS fb on fr.CodigoFabricanteOutros = fb.CodigoFabricante
	FOR XML PATH('itemFrota'),
	ROOT('frotas')