SELECT distinct RTRIM(LTRIM(l.CGCLocal)) AS concessao,
case
       WHEN LEN(CONVERT(varchar(14),tp.CodigoClienteST)) <= 11 THEN 
       REPLICATE('0', 11 - LEN(CONVERT(varchar(11), tp.CodigoClienteST))) + CONVERT(varchar(11), tp.CodigoClienteST)
       WHEN LEN(CONVERT(varchar(14), tp.CodigoClienteST)) > 11 AND LEN(CONVERT(varchar(14), tp.CodigoClienteST)) <= 14 THEN 
       REPLICATE ('0', 14 - LEN(CONVERT(varchar(14), tp.CodigoClienteST))) + CONVERT(varchar(14), tp.CodigoClienteST) 
       END AS cliente,
	   
	   RTRIM(LTRIM(tp.Categoria)) AS segmento ,		
	CASE WHEN st.PropensaoCompra  = '0' THEN 'BOLSAO'
         WHEN st.PropensaoCompra  = '1' THEN 'FRIA'
	     WHEN st.PropensaoCompra  = '2' THEN 'MORNA'
		 WHEN st.PropensaoCompra  = '3' THEN 'QUENTE'	
		 WHEN st.PropensaoCompra  = '4' THEN 'SUPER_QUENTE'
	     ELSE NULL
	END AS propensao,
		 RTRIM(LTRIM(max((convert(varchar,rv.DataResultadoVisita,103))))) AS dataUltimaVisita
FROM tbClienteRepresentanteTP AS tp INNER JOIN tbLocal AS l on tp.CodigoEmpresa = l.CodigoEmpresa 
inner join  tbRepresentanteComplementar AS rc on tp.CodigoRepresentante = rc.CodigoRepresentante inner join
tbClienteStarTruck AS st on tp.CodigoRepresentante = st.CodigoRepresentante inner join tbResultadoVisitaST AS rv on
tp.CodigoClienteST = rv.CodigoClienteST Group By l.CGCLocal,tp.CodigoClienteST,tp.Categoria,st.PropensaoCompra
	FOR XML PATH('propensao'),
	ROOT('propensoes')


