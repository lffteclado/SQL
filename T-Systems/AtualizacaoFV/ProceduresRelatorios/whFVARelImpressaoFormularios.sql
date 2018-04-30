go
if exists(select 1 from sysobjects where id = object_id('dbo.whFVARelImpressaoFormularios'))
DROP PROCEDURE dbo.whFVARelImpressaoFormularios
GO
CREATE PROCEDURE  dbo.whFVARelImpressaoFormularios 
	@CodigoEmpresa	dtInteiro04,
	@CodigoLocal	dtInteiro04,
	@FichaContato   numeric(6),
	@TipoCliente	char(1)

/*
-------------------------------------------------------------------------------------
EMPRESA......: T-SYSTEMS do Brasil
PROJETO......: Força Vendas Automóveis
AUTOR........: Daniel Lemes 
DATA.........: 21/05
UTILIZADO EM : Impressão de Formulários em StarClass Automóveis
 
EXECUTE dbo.whFVARelImpressaoFormularios 1608,0,15,'E'
GO
EXECUTE dbo.whFVARelImpressaoFormularios 1608,0,5,'P'
---------------------------------------------------------------------------------------
*/

AS 

SET NOCOUNT ON		

IF @TipoCliente = 'P'
BEGIN
	SELECT
		fic.CodigoEmpresa,
		fic.CodigoLocal,
		fic.NumeroFichaContato,
		fic.CodigoRepresentante,
		rep.NomeRepresentante,
		fic.CodigoClientePF,
		fic.NegociacaoIniciadaDataHora,
		fic.TestDriveRealizadoDataHora 'DataTesteDrive',
		coalesce(fic.EntregaRealizadaDataHoraFichaContato,'') 'DataEntregaDocumento',
		intess.ModeloVeiculo,
		rtrim(ltrim(cliPot.RazaoSocialClientePotencial)) 'NomeCliente',
		coalesce(rtrim(ltrim(cliPot.RuaClientePotencial)),'') + ', nº ' + convert(char(10),coalesce(cliPot.NumeroClientePotencial,'0'))+ ' - ' + coalesce(rtrim(ltrim(cliPot.BairroClientePotencial)),'') as 'Endereço',
		coalesce(cliPot.CEPClientePotencial,'') 'CEP',
		coalesce(cliPot.MunicipioClientePotencial,'')	 'MunicipioCliente',
		coalesce(cliPot.UnidadeFederacao,'')			 'UFCliente',
		coalesce(cliPot.DDDFoneResidenciaClientePot,'')  'DDDTeleFoneCliente',
		coalesce(cliPot.FoneResidenciaClientePot,'')	 'TeleFoneCliente',
		coalesce(cliPot.DDDFoneComercialClientePot,'')	 'DDDTelComercialCliente',
		coalesce(cliPot.FoneComercialClientePot,'')		 'TelefoneComercialCliente',
		coalesce(cliPot.EMailClientePotencial,'')		 'EmailCliente',
		coalesce(substring(coalesce(cliPot.CGCCPFClientePotencial,''),1,3) + '.'
		+ substring(coalesce(cliPot.CGCCPFClientePotencial,''),4,3) + '.' 
		+ substring(coalesce(cliPot.CGCCPFClientePotencial,''),7,3) +'-'
		+ substring(coalesce(cliPot.CGCCPFClientePotencial,''),10,2),'') 'CPF',
		coalesce(cliPot.DtNascClientePotencial,'')		 'DataNascimentoCliente',
		coalesce(case when cliPot.SexoClientePotencial = 'M' then 'MASCULINO' else 'FEMININO' end,'') 'SEXO',
		''												 'NomePais'
 
	FROM tbFichaContato fic (nolock)

	INNER JOIN tbRepresentanteComplementar rep (nolock)
	ON  fic.CodigoEmpresa = rep.CodigoEmpresa
	AND fic.CodigoRepresentante = rep.CodigoRepresentante

	INNER JOIN tbClientePotencial cliPot (nolock)
	ON  cliPot.CodigoEmpresa = fic.CodigoEmpresa
	AND cliPot.CodigoClientePotencial = fic.CodigoClientePF

	LEFT JOIN tbFichaContatoVeicInteresse intess (nolock)
	ON  intess.CodigoEmpresa = fic.CodigoEmpresa
	AND intess.CodigoLocal = fic.CodigoLocal
	AND intess.NumeroFichaContato = fic.NumeroFichaContato
	AND intess.ItemFichaContatoVeiculo = 1  

	WHERE fic.CodigoEmpresa = @CodigoEmpresa
	and   fic.CodigoLocal = @CodigoLocal
	and   fic.NumeroFichaContato = @FichaContato
END
ELSE
BEGIN
	SELECT 
		fic.CodigoEmpresa,
		fic.CodigoLocal,
		fic.NumeroFichaContato,
		fic.CodigoRepresentante,
		rep.NomeRepresentante,
		fic.CodigoClientePF,
		fic.NegociacaoIniciadaDataHora,
		fic.TestDriveRealizadoDataHora 'DataTesteDrive',
		coalesce(fic.EntregaRealizadaDataHoraFichaContato,'') 'DataEntregaDocumento',
		intess.ModeloVeiculo,
		coalesce(cli.NomeCliFor,'') 'NomeCliente',
		coalesce(rtrim(ltrim(cli.RuaCliFor)),'') + ', nº ' + convert(char(10),coalesce(cli.NumeroEndCliFor,'0')) + ' - ' + rtrim(ltrim(cli.BairroCliFor))as 'Endereço',
		coalesce(cli.CEPCliFor,'')			 'CEP',
		rtrim(ltrim(cli.MunicipioCliFor))			 'MunicipioCliente',
		rtrim(ltrim(cli.UFCliFor))					 'UFCliente',
		coalesce(cli.DDDTelefoneCliFor,'')			 'DDDTeleFoneCliente',
		coalesce(cli.TelefoneCliFor,'')				 'TeleFoneCliente',
		coalesce(cli.DDDRefComercialFornecedor,'')	 'DDDTelComercialCliente',
		coalesce(cli.FoneRefComercialFornecedor,'')  'TelefoneComercialCliente',
		coalesce(cli.EmailCliFor,'')				 'EmailCliente',
		coalesce(substring(coalesce(clif.CPFFisica,''),1,3)+ '.' 
		+ substring(coalesce(clif.CPFFisica,''),4,3) + '.' 
		+ substring(coalesce(clif.CPFFisica,''),7,3) +'-'
		+ substring(coalesce(clif.CPFFisica,''),10,2),'') 'CPF',
		coalesce(clif.DataNascimentoFisica,'')		 'DataNascimentoCliente',
		coalesce(case when clif.SexoCliente = 'M' then 'MASCULINO' else 'FEMININO' end,'') 'SEXO',
		coalesce(pa.DescrPais,'')					 'NomePais'

	FROM tbFichaContato fic (nolock)

	INNER JOIN tbRepresentanteComplementar rep (nolock)
	ON  fic.CodigoEmpresa = rep.CodigoEmpresa
	AND fic.CodigoRepresentante = rep.CodigoRepresentante

	INNER JOIN tbCliFor cli (nolock)
	ON  cli.CodigoEmpresa = fic.CodigoEmpresa
	AND cli.CodigoCliFor = fic.CodigoClientePF

	INNER JOIN tbCliForFisica clif (nolock)
	ON  clif.CodigoEmpresa = fic.CodigoEmpresa
	AND clif.CodigoCliFor = fic.CodigoClientePF

	LEFT JOIN tbFichaContatoVeicInteresse intess (nolock)
	ON  intess.CodigoEmpresa = fic.CodigoEmpresa
	AND intess.CodigoLocal = fic.CodigoLocal
	AND intess.NumeroFichaContato = fic.NumeroFichaContato
	AND intess.ItemFichaContatoVeiculo = 1  

	LEFT JOIN tbPais pa (nolock)
	ON pa.IdPais = cli.IdPais

	WHERE fic.CodigoEmpresa = @CodigoEmpresa
	and   fic.CodigoLocal = @CodigoLocal
	and   fic.NumeroFichaContato = @FichaContato
END 

SET NOCOUNT OFF 

GO 
GRANT EXECUTE ON dbo.whFVARelImpressaoFormularios TO SQLUsers 
GO
