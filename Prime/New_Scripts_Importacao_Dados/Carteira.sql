SELECT	distinct RTRIM(LTRIM(l.CGCLocal)) AS concessao,
		RTRIM(LTRIM(rc.NomeRepresentante))AS representante,	
case
       WHEN LEN(CONVERT(varchar(14),tp.CodigoClienteST)) <= 11 THEN 
       REPLICATE('0', 11 - LEN(CONVERT(varchar(11), tp.CodigoClienteST))) + CONVERT(varchar(11), tp.CodigoClienteST)
       WHEN LEN(CONVERT(varchar(14), tp.CodigoClienteST)) > 11 AND LEN(CONVERT(varchar(14), tp.CodigoClienteST)) <= 14 THEN 
       REPLICATE ('0', 14 - LEN(CONVERT(varchar(14), tp.CodigoClienteST))) + CONVERT(varchar(14), tp.CodigoClienteST) 
       END AS cliente,   
			
	CASE WHEN st.ClienteTPCaminhoes  = 'V' THEN 'CAMINHAO'
         WHEN st.ClienteTPOnibus = 'V' THEN 'ONIBUS'
	     WHEN st.ClienteTPSprinter = 'V' THEN 'SPRINTER'
	     ELSE NULL
	END AS segmento
FROM tbClienteRepresentanteTP AS tp INNER JOIN tbLocal AS l on tp.CodigoEmpresa = l.CodigoEmpresa 
inner join tbClienteStarTruck AS st on tp.CodigoClienteST = st.CodigoClienteST inner join 
tbRepresentanteComplementar as rc on st.CodigoRepresentante  = rc.CodigoRepresentante 
	FOR XML PATH('carteira'),
	ROOT('carteiras')



