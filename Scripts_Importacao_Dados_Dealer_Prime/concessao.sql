SELECT distinct RTRIM(LTRIM(tbE.NomeFantasiaEmpresa)) AS nome,
	   RTRIM(LTRIM(tbE.RazaoSocialEmpresa)) AS razaoSocial,		
	   RTRIM(LTRIM(tbL.ContaConcessao)) AS ctcli,
	   RTRIM(LTRIM(tbE.DiretorioImportacao )) AS grupo,
	   RTRIM(LTRIM(tbL.CGCLocal))	AS cnpj,
       RTRIM(LTRIM(tbL.InscricaoEstadualLocal)) AS inscricaoEstadual,
	   RTRIM(LTRIM(tbE.DiretorioImportacao )) AS tipoLogradouro,
	   RTRIM(LTRIM(tbL.RuaLocal)) AS logradouro,
	   RTRIM(LTRIM(tbL.NumeroEndLocal)) AS numero,  
	   RTRIM(LTRIM(tbE.DiretorioImportacao )) AS complemento, 
	   RTRIM(LTRIM(tbL.BairroLocal)) AS bairro,
	   RTRIM(LTRIM(tbL.CEPLocal)) AS cep,
	   RTRIM(LTRIM(tbL.MunicipioLocal)) AS cidade,
	   RTRIM(LTRIM(tbL.UFLocal)) AS uf,
	   RTRIM(LTRIM(tbL.TelefoneLocal)) AS telefonePrincipal,
	   RTRIM(LTRIM(tbL.FaxLocal)) AS telefoneSecundario			   	
FROM tbLocal AS tbL INNER JOIN tbEmpresa AS tbE on tbL.CodigoEmpresa = tbE.CodigoEmpresa
	FOR XML PATH('concessao'),
	ROOT('concessoes')