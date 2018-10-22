SELECT distinct RTRIM(LTRIM(l.CGCLocal)) AS concessao,
  case
  WHEN LEN(CONVERT(varchar(14),cc.CodigoCliFor)) <= 11 THEN 
       REPLICATE('0', 11 - LEN(CONVERT(varchar(11), cc.CodigoCliFor))) + CONVERT(varchar(11), cc.CodigoCliFor)
       WHEN LEN(CONVERT(varchar(14), cc.CodigoCliFor)) > 11 AND LEN(CONVERT(varchar(14), cc.CodigoCliFor)) <= 14 THEN 
       REPLICATE ('0', 14 - LEN(CONVERT(varchar(14), cc.CodigoCliFor))) + CONVERT(varchar(14), cc.CodigoCliFor) 
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
FROM tbContatoClienteTP AS cc INNER JOIN tbLocal AS l on cc.CodigoEmpresa = l.CodigoEmpresa
	FOR XML PATH('contato'),
	ROOT('contatos')



