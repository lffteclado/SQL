SELECT	distinct RTRIM(LTRIM(l.CGCLocal)) AS concessao,
		RTRIM(LTRIM(rc.NomeRepresentante))AS representante,
		case
			WHEN rc.NomeRepresentante = 'CARLOS MAURICIO PAES CAMACHO' THEN 'mauricio@postoimperial.com.br'
			WHEN rc.NomeRepresentante = 'GERALDO MAGELA' THEN 'geraldomagela@postoimperial.com.br'
			WHEN rc.NomeRepresentante = 'GERALDO MENDONÇA' THEN 'geraldojunior@postoimperial.com.br'
		END AS email,
CASE
       --WHEN LEN(CONVERT(varchar(14),tf.CPFFisica)) <= 11 THEN 
       --REPLICATE('0', 11 - LEN(CONVERT(varchar(11), tf.CPFFisica))) + CONVERT(varchar(11), tf.CPFFisica)
       --WHEN LEN(CONVERT(varchar(14), tf.CPFFisica)) > 11 AND LEN(CONVERT(varchar(14), tf.CPFFisica)) <= 14 THEN 
       --REPLICATE ('0', 14 - LEN(CONVERT(varchar(14), tf.CPFFisica))) + CONVERT(varchar(14), tf.CPFFisica) 

	   WHEN LEN(CONVERT(varchar(14),tj.CGCJuridica)) <= 11 THEN 
       REPLICATE('0', 11 - LEN(CONVERT(varchar(11), tj.CGCJuridica))) + CONVERT(varchar(11), tj.CGCJuridica)
       WHEN LEN(CONVERT(varchar(14), tj.CGCJuridica)) > 11 AND LEN(CONVERT(varchar(14), tj.CGCJuridica)) <= 14 THEN 
       REPLICATE ('0', 14 - LEN(CONVERT(varchar(14), tj.CGCJuridica))) + CONVERT(varchar(14), tj.CGCJuridica) 

END AS cliente,   
			
	   RTRIM(LTRIM(tp.Categoria )) AS seguimento
FROM tbClienteRepresentanteTP AS tp
INNER JOIN tbLocal AS l ON tp.CodigoEmpresa = l.CodigoEmpresa 
--INNER JOIN tbClienteStarTruck AS st ON tp.CodigoClienteST = st.CodigoClienteST
INNER JOIN tbRepresentanteComplementar AS rc ON tp.CodigoRepresentante  = rc.CodigoRepresentante
INNER JOIN tbRepresentante AS tr ON rc.CodigoRepresentante = tr.CodigoRepresentante
INNER JOIN tbCliFor AS tc ON tp.CodigoClienteST = tc.CodigoCliFor
INNER JOIN tbCliForJuridica AS tj ON tc.CodigoCliFor = tj.CodigoCliFor where tr.RepresentanteBloqueado = 'F'
--INNER JOIN tbCliForFisica AS tf ON tc.CodigoCliFor = tf.CodigoCliFor where tr.RepresentanteBloqueado = 'F'
FOR XML PATH('carteira'),
ROOT('carteiras')

