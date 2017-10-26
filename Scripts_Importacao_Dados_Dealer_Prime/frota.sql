SELECT distinct RTRIM(LTRIM(l.CGCLocal)) AS concessao,
 CASE
  WHEN LEN(CONVERT(varchar(14),f.CPFFisica)) <= 11 THEN 
  REPLICATE('0', 11 - LEN(CONVERT(varchar(11), f.CPFFisica))) + CONVERT(varchar(11), f.CPFFisica)
    --WHEN LEN(CONVERT(varchar(14), j.CGCJuridica)) > 11 AND LEN(CONVERT(varchar(14), j.CGCJuridica)) <= 14 THEN 
    --REPLICATE ('0', 14 - LEN(CONVERT(varchar(14), j.CGCJuridica))) + CONVERT(varchar(14), j.CGCJuridica) 
	--WHEN cf.CodigoCliFor is null THEN ''
	--WHEN cf.CodigoCliFor = '' THEN ''
    END AS cliente,		
	RTRIM(LTRIM(fb.DescricaoFabricanteVeic)) AS marca,
	RTRIM(LTRIM(fr.ModeloVeiculo)) AS modelo,
    RTRIM(LTRIM(fr.Categoria)) AS segmento,
	RTRIM(LTRIM(fr.SegmentoFrotaCliente)) AS subsegmento,
	RTRIM(LTRIM(fr.QtdeVeiculosFrotaCliente)) AS quantidade,
	RTRIM(LTRIM(fr.AnoFabricacaoFrotaCliente)) AS ano,
	CASE WHEN fr.PossuiOnus  = 'NAO' THEN 'N'
	    ELSE ''
	END AS possuiOnus,
	CASE WHEN fr.PossuiSeguro  = 'V' THEN 'S'
		ELSE 'N'
	END AS PossuiSeguro,
	RTRIM(LTRIM(fr.KmMediaMensal)) AS kmMediaUnitaria,
	RTRIM(LTRIM(fr.ValorAproximadoFrota)) AS valorMedioUnitario,
	CASE
	WHEN l.CodigoEmpresa = 2890 THEN '' END AS implemento		   	
FROM tbFrotaCliente AS fr
INNER JOIN tbLocal AS l on fr.CodigoEmpresa = l.CodigoEmpresa
INNER JOIN tbCliFor AS cc on fr.NumeroClientePotencialEfetivo = cc.CodigoCliFor
INNER JOIN tbCliForFisica AS f on cc.CodigoCliFor = f.CodigoCliFor
--INNER JOIN tbCliForJuridica as j on cc.CodigoCliFor = j.CodigoCliFor 
INNER JOIN tbFabricanteVeiculo AS fb on fr.CodigoFabricanteOutros = fb.CodigoFabricante
WHERE l.CodigoLocal = 0 AND f.CPFFisica NOT LIKE 'ISENTO'
FOR XML PATH('itemFrota'),
ROOT('frotas')

	--WHERE f.CPFFisica NOT LIKE 'ISENTO' AND f.CPFFisica IS NOT NULL