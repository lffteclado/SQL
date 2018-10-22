SELECT distinct RTRIM(LTRIM(l.CGCLocal)) AS concessao,
  case
  --WHEN LEN(CONVERT(varchar(14),f.CPFFisica)) <= 11 THEN 
  --     REPLICATE('0', 11 - LEN(CONVERT(varchar(11), f.CPFFisica))) + CONVERT(varchar(11), f.CPFFisica)
       WHEN LEN(CONVERT(varchar(14), j.CGCJuridica)) > 11 AND LEN(CONVERT(varchar(14), j.CGCJuridica)) <= 14 THEN 
       REPLICATE ('0', 14 - LEN(CONVERT(varchar(14), j.CGCJuridica))) + CONVERT(varchar(14), j.CGCJuridica) 
	   --WHEN cf.CodigoCliFor is null THEN ''
	   --WHEN cf.CodigoCliFor = '' THEN ''
       END AS cliente,
	   RTRIM(LTRIM(cc.NomeContatoClienteTP)) AS nome,
	   '('+ Substring(cc.DDDFoneContatoClienteTP,1,2) + ')' 
       + Substring(cc.FoneContatoClienteTP,1,4)+ '-'
	   + Substring(cc.FoneContatoClienteTP,5,4) AS 'telefone',
	   '('+ Substring(cc.DDDFoneContatoClienteTP,1,2) + ')' 
       + Substring(cc.CelularContatoClienteTP,1,4)+ '-'
	   + Substring(cc.CelularContatoClienteTP,5,4) AS 'celular',
	   RTRIM(LTRIM(cc.EmailContatoClienteTP)) AS eMail,	
	   RTRIM(LTRIM(cc.FuncaoContato)) AS cargo   			   	
FROM tbContatoClienteTP AS cc
     INNER JOIN tbLocal AS l on cc.CodigoEmpresa = l.CodigoEmpresa
	 INNER JOIN tbCliFor AS cf on cc.CodigoCliFor = cf.CodigoCliFor
	 --INNER JOIN tbCliForFisica AS f on cf.CodigoCliFor = f.CodigoCliFor
	 INNER JOIN tbCliForJuridica as j on cf.CodigoCliFor = j.CodigoCliFor 
	FOR XML PATH('contato'),
	ROOT('contatos')


	--WHERE cf.CPFFisica NOT LIKE 'ISENTO' AND cf.CPFFisica IS NOT NULL
