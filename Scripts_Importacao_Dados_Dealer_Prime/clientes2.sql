SELECT distinct RTRIM(LTRIM(l.CGCLocal)) AS concessao,
	CASE
		WHEN c.CodigoEmpresa = 2890 THEN '' END AS regiao,
	  CASE
       --WHEN LEN(CONVERT(varchar(14), cf.CPFFisica)) <= 11 THEN 
       --REPLICATE('0', 11 - LEN(CONVERT(varchar(11), cf.CPFFisica))) + CONVERT(varchar(11), cf.CPFFisica)
       WHEN LEN(CONVERT(varchar(14), j.CGCJuridica)) > 11 AND LEN(CONVERT(varchar(14), j.CGCJuridica)) <= 14 THEN 
       REPLICATE ('0', 14 - LEN(CONVERT(varchar(14), j.CGCJuridica))) + CONVERT(varchar(14), j.CGCJuridica) 
       END AS cpfCnpj,
	 --  RTRIM(LTRIM(cf.RGFisica))  AS rg,
	 --  CASE
		--WHEN (cf.RGFisica) is null THEN ''
		--WHEN (cf.RGFisica) = '' THEN ''
		--END AS rg,
	   RTRIM(LTRIM(j.InscricaoEstadualJuridica)) AS inscricaoEstadual,
	   CASE
		WHEN (j.InscricaoEstadualJuridica) is null THEN ''
		WHEN (j.InscricaoEstadualJuridica) = '' THEN ''
		END AS inscricaoEstadual,
	   RTRIM(LTRIM(c.NomeCliFor)) AS nome,
	   RTRIM(LTRIM(c.NomeUsualCliFor)) AS nomeFantasia,
	   RTRIM(LTRIM(c.CodigoEmpresa)) AS tipoLogradouro,
	   RTRIM(LTRIM(c.RuaCliFor)) AS logradouro,
	   RTRIM(LTRIM(c.NumeroEndCliFor)) AS numero,
	   --CASE
		--WHEN (c.NumeroEndCliFor) is null THEN '' END AS numero,
	   RTRIM(LTRIM(c.ComplementoEndCliFor)) AS complemento,
	   CASE
		WHEN (c.ComplementoEndCliFor) is null THEN '' END AS complemento,
	   RTRIM(LTRIM(c.BairroCliFor)) AS bairro,
	   RTRIM(LTRIM(c.CEPCliFor)) AS cep,
	   RTRIM(LTRIM(c.MunicipioCliFor)) AS cidade,
	   RTRIM(LTRIM(c.UFCliFor)) AS uf,
	   '('+ Substring(c.DDDTelefoneCliFor,1,2) + ')' 
       + Substring(c.TelefoneCliFor,1,4)+ '-'
	   + Substring(c.TelefoneCliFor,5,4) AS 'telefonePrincipal',
	   --CASE
		--WHEN (c.TelefoneCliFor) is null THEN ''
		--WHEN (c.TelefoneCliFor) = '' THEN ''
		--END AS telefonePrincipal,
	   '('+ Substring(c.DDDTelefoneCliFor,1,2) + ')' 
       + Substring(c.TelefoneCliFor,1,4)+ '-'
	   + Substring(c.TelefoneCliFor,5,4) AS 'telefoneSecundario',
	   --CASE
		--WHEN (c.TelefoneCliFor) is null THEN ''
		--WHEN (c.TelefoneCliFor) = '' THEN ''
		--END AS telefoneSecundario,
	   '('+ Substring(c.DDDCelularCliFor,1,2) + ')' 
       + Substring(c.CelularCliFor,1,4)+ '-'
	   + Substring(c.CelularCliFor,5,4) AS 'celular',
	   CASE
		WHEN (c.CelularCliFor) is null THEN ''
		WHEN (c.CelularCliFor) = '' THEN ''
		END AS celular,
       '('+ Substring(c.DDDFaxCliFor,1,2) + ')' 
       + Substring(c.FaxCliFor,1,4)+ '-'
	   + Substring(c.FaxCliFor,5,4) AS 'fax',
	    CASE
		WHEN (c.FaxCliFor) is null THEN ''
		WHEN (c.FaxCliFor) = '' THEN ''
		END AS fax,
	   RTRIM(LTRIM(c.EmailCliFor)) AS eMail,
	    CASE
		WHEN (c.EmailCliFor) is null THEN ''
		WHEN (c.EmailCliFor) = '' THEN ''
		END AS eMail,
	   CASE
	    WHEN j.InscricaoEstadualJuridica is null THEN 'N'
	    WHEN j.InscricaoEstadualJuridica = '' THEN 'N'
	    WHEN j.InscricaoEstadualJuridica = 'ISENTO' THEN 'N'
	   ELSE 'S' END AS contribuinteIcms,
	   CASE
	    WHEN c.InscrEstadualProdutorRural is null THEN 'N'
	    WHEN c.InscrEstadualProdutorRural = '' THEN 'N'
	    WHEN c.InscrEstadualProdutorRural = 'ISENTO' THEN 'N'
	   ELSE 'S' END AS produtorRural,
	   RTRIM(LTRIM(c.CodigoEmpresa)) AS ramoAtividade,
	CASE WHEN st.ClienteProspeccao  = 'V' THEN 'S'
         WHEN st.ClienteProspeccao  = 'F' THEN 'N'
	     ELSE NULL
	END AS prospeccao,
	RTRIM(LTRIM(c.CodigoEmpresa)) AS fonteProspeccao,
	RTRIM(LTRIM(convert (varchar(10),st.DataCadastroTP,103))) AS dataCadastro   			   	
FROM tbClienteStarTruck AS st
INNER JOIN tbLocal AS l on st.CodigoEmpresa = l.CodigoEmpresa 
INNER JOIN tbCliFor AS c on st.CodigoClienteST = c.CodigoCliFor
--INNER JOIN tbCliForFisica AS cf on c.CodigoCliFor = cf.CodigoCliFor WHERE cf.CPFFisica NOT LIKE 'ISENTO' AND cf.CPFFisica IS NOT NULL
INNER JOIN tbCliForJuridica as j on c.CodigoCliFor = j.CodigoCliFor
WHERE l.CodigoLocal = 0
	--FOR XML PATH('cliente'),
	--ROOT('clientes')


	 --j.CGCJuridica NOT LIKE 'ISENTO' OR j.CGCJuridica NOT LIKE '111111111111'

