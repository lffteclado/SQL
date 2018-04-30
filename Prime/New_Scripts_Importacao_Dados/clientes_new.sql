SELECT distinct RTRIM(LTRIM(l.CGCLocal)) AS concessao,
	  case
       WHEN LEN(CONVERT(varchar(14), c.CodigoCliFor)) <= 11 THEN 
       REPLICATE('0', 11 - LEN(CONVERT(varchar(11), c.CodigoCliFor))) + CONVERT(varchar(11), c.CodigoCliFor)
       WHEN LEN(CONVERT(varchar(14), c.CodigoCliFor)) > 11 AND LEN(CONVERT(varchar(14), c.CodigoCliFor)) <= 14 THEN 
       REPLICATE ('0', 14 - LEN(CONVERT(varchar(14), c.CodigoCliFor))) + CONVERT(varchar(14), c.CodigoCliFor) 
       END AS CPFCNPJ,

	   RTRIM(LTRIM(cf.RGFisica))  AS rg,
	   RTRIM(LTRIM(c.NomeCliFor)) AS nome,
	   RTRIM(LTRIM(c.NomeUsualCliFor)) AS nomeFantasia,
	   RTRIM(LTRIM(c.RuaCliFor)) AS logradouro,
	   RTRIM(LTRIM(c.NumeroEndCliFor)) AS numero,
	   RTRIM(LTRIM(c.ComplementoEndCliFor)) AS complemento,
	   RTRIM(LTRIM(c.BairroCliFor)) AS bairro,
	   RTRIM(LTRIM(c.CEPCliFor)) AS cep,
	   RTRIM(LTRIM(c.MunicipioCliFor)) AS cidade,
	   '('+ Substring(c.DDDTelefoneCliFor,1,2) + ')' 
       + Substring(c.TelefoneCliFor,1,4)+ '-'
	   + Substring(c.TelefoneCliFor,5,4) AS 'telefonePrincipal',
       '('+ Substring(c.DDDFaxCliFor,1,2) + ')' 
       + Substring(c.FaxCliFor,1,4)+ '-'
	   + Substring(c.FaxCliFor,5,4) AS 'fax',
	   RTRIM(LTRIM(c.EmailCliFor)) AS eMail,
	   RTRIM(LTRIM(c.EmailCliFor)) AS eMail,
  RTRIM(LTRIM( st.ClienteProspeccao))AS prospeccao,
	CASE WHEN st.ClienteProspeccao  = 'S' THEN 'V'
         WHEN st.ClienteProspeccao  = 'N' THEN 'F'
	     ELSE NULL
	END AS prospeccao,
	  RTRIM(LTRIM(convert (varchar(10),st.DataCadastroTP,103))) AS dataCadastro   			   	
FROM tbClienteStarTruck AS st INNER JOIN tbLocal AS l on st.CodigoEmpresa = l.CodigoEmpresa 
inner join tbCliForFisica AS cf on st.CodigoClienteST = cf.CodigoCliFor 
inner join tbCliFor AS c on st.CodigoClienteST = c.CodigoCliFor
	 
	FOR XML PATH('cliente'),
	ROOT('clientes')

