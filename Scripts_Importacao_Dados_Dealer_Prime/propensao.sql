SELECT distinct RTRIM(LTRIM(l.CGCLocal)) AS concessao,
CASE
       WHEN LEN(CONVERT(varchar(14),f.CPFFisica)) <= 11 THEN 
       REPLICATE('0', 11 - LEN(CONVERT(varchar(11), f.CPFFisica))) + CONVERT(varchar(11), f.CPFFisica)
       --WHEN LEN(CONVERT(varchar(14), j.CGCJuridica)) > 11 AND LEN(CONVERT(varchar(14), j.CGCJuridica)) <= 14 THEN 
       --REPLICATE ('0', 14 - LEN(CONVERT(varchar(14), j.CGCJuridica))) + CONVERT(varchar(14), j.CGCJuridica) 
       END AS cliente,	   
	   RTRIM(LTRIM(tp.Categoria)) AS segmento ,		
		CASE
			 WHEN tp.PropensaoCompra  = '0' THEN 'BOLSAO'
			 WHEN tp.PropensaoCompra  = '1' THEN 'FRIA'
			 WHEN tp.PropensaoCompra  = '2' THEN 'MORNA'
			 WHEN tp.PropensaoCompra  = '3' THEN 'QUENTE'	
			 WHEN tp.PropensaoCompra  = '4' THEN 'SUPER_QUENTE'
	    ELSE NULL
	END AS propensao,
		 RTRIM(LTRIM(max((convert(varchar,rv.DataResultadoVisita,103))))) AS dataUltimaVisita
FROM tbClienteRepresentanteTP AS tp
INNER JOIN tbLocal AS l on tp.CodigoEmpresa = l.CodigoEmpresa 
--INNER JOIN tbRepresentanteComplementar AS rc on tp.CodigoRepresentante = rc.CodigoRepresentante
INNER JOIN tbClienteStarTruck AS st on tp.CodigoRepresentante = st.CodigoRepresentante
INNER JOIN tbCliFor AS cf on tp.CodigoClienteST = cf.CodigoCliFor
INNER JOIN tbCliForFisica AS f on cf.CodigoCliFor = f.CodigoCliFor
--INNER JOIN tbCliForJuridica as j on cf.CodigoCliFor = j.CodigoCliFor 
INNER JOIN tbResultadoVisitaST AS rv on tp.CodigoClienteST = rv.CodigoClienteST WHERE f.CPFFisica NOT LIKE 'ISENTO' AND f.CPFFisica IS NOT NULL Group By l.CGCLocal,tp.Categoria,tp.PropensaoCompra, f.CPFFisica
	--FOR XML PATH('propensao'),
	--ROOT('propensoes')

