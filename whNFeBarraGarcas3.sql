IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('whNFeBarraGarcas3'))
	DROP PROCEDURE whNFeBarraGarcas3
GO
CREATE PROCEDURE dbo.whNFeBarraGarcas3
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: Gerenciador NFSe
 AUTOR........: Marson
 DATA.........: 06/04/2018
 UTILIZADO EM : frmNFGerenciador.frm
 OBJETIVO.....: Gerar Arquivo XML RPS(Recibo Provisório de Serviços) Municipal - Barra do Garças
 				Ticket 275844/2018

EXECUTE whNFeBarraGarcas3 @CodigoEmpresa = 1608,@CodigoLocal = 0,@DataDocumento = '2016-09-23 00:00',@NumeroDocumento = 124
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

	@CodigoEmpresa		dtInteiro04 ,
	@CodigoLocal		dtInteiro04 , 
	@DataDocumento		DATETIME,
	@NumeroDocumento	NUMERIC(6)

AS 

BEGIN
	DECLARE @CodigoMunicipio varchar(10)
	DECLARE @SerieDocumento varchar(4)

	SELECT @CodigoMunicipio = COALESCE(tbCEP.NumeroMunicipio,0)
	FROM tbLocal
	INNER JOIN tbCEP ON
			   tbCEP.NumeroCEP = tbLocal.CEPLocal
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal

	SELECT @SerieDocumento = RTRIM(LTRIM(SerieDocumento))
	FROM tbDocumento
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	EntradaSaidaDocumento = 'S' AND
	NumeroDocumento = @NumeroDocumento AND
	DataDocumento = @DataDocumento AND
	--CodigoCliFor = @CodigoCliFor AND
	TipoLancamentoMovimentacao = 7

	SET NOCOUNT ON

	CREATE TABLE #tmpXML (Linha VARCHAR(8000), Ordem numeric(6)) 

	INSERT #tmpXML
	SELECT
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<nota>' +
		'<cpfcnpj>' + tbLocal.CGCLocal + '</cpfcnpj>' +
		'<inscricao>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</inscricao>' +
		'<chave>' + 'bAJeNoDE7FqDMSblyM46f53xHNXfRfsqqOc=' + '</chave>' +
		'<cep>' + COALESCE(tbLocal.CEPLocal,'00000000') + '</cep>' +
		'<data>' +  SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,COALESCE(tbDocumento.DataHoraNSU,tbDocumento.DataDocumento))),2,4) + '-' + 
					SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,COALESCE(tbDocumento.DataHoraNSU,tbDocumento.DataDocumento))),2,2)	+ '-' +
					SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,COALESCE(tbDocumento.DataHoraNSU,tbDocumento.DataDocumento))),2,2) + 
		'</data>' +
		'<modelo>' + 'Eletronica' + '</modelo>' +
		'<Serie>' + RTRIM(LTRIM(@SerieDocumento)) + '</Serie>' +
		--'<fatura>' + '' + '</fatura>' +
		--'<orcamento>' + '' + '</orcamento>' +
		--'<vencimento>' + '' + '</vencimento>' +
		CASE WHEN tbDocumentoFT.vPISRetidoDocFT > 0 THEN
			'<pis>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.vPISRetidoDocFT))  + '</pis>'
		ELSE
			'<pis>' + '0.00' + '</pis>'
		END +
		CASE WHEN tbDocumentoFT.ValorCSLLDocFT <> 0 THEN
			'<csll>' + + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.ValorCSLLDocFT)) + '</csll>' 
		ELSE
			'<csll>' + '0.00' + '</csll>' 
		END +
		CASE WHEN tbDocumentoFT.vCOFINSRetidoDocFT > 0 THEN
			'<cofins>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.vCOFINSRetidoDocFT)) + '</cofins>'
		ELSE
			'<cofins>' + '0.00' + '</cofins>'
		END +
		'<irff>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.ValorIRRFDocFT))  + '</irff>' +
		'<situacao>' + 'Emitida' + '</situacao>' +
		'<optante>' + 'Nao' + '</optante>' +
		'<aliquota>' + '0' + '</aliquota>' +
		--'<texto>' + '' + '</texto>' +
		'<servicos>' +
			dbo.fnItensNFBarraGarcas(
										@CodigoEmpresa,
										@CodigoLocal,
										tbDocumento.EntradaSaidaDocumento,
										tbDocumento.NumeroDocumento,
										tbDocumento.DataDocumento,
										tbDocumento.CodigoCliFor,
										tbDocumento.TipoLancamentoMovimentacao
									  ) +
		'</servicos>' +
		'<tomador>' +
			'<endereco>' + RTRIM(LTRIM(COALESCE(tbClienteEventual.EnderecoCliEven,tbCliFor.RuaCliFor))) + '</endereco>' +
			CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND NumeroEndCliFor IS NOT NULL AND NumeroEndCliFor <> 0 THEN
				'<numero>' + COALESCE(CONVERT(VARCHAR(5),NumeroEndCliFor),'') + '</numero>'
			ELSE
				'<numero>' + 'SN' + '</numero>'
			END + 
			CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND tbCliFor.ComplementoEndCliFor IS NOT NULL AND RTRIM(LTRIM(tbCliFor.ComplementoEndCliFor)) <> '' THEN
				'<complemento>' + COALESCE(RTRIM(LTRIM(tbCliFor.ComplementoEndCliFor)),'') + '</complemento>'
			ELSE
				''
			END + 
			'<bairro>' + COALESCE(RTRIM(LTRIM(COALESCE(tbClienteEventual.BairroCliEven,tbCliFor.BairroCliFor))),'') + '</bairro>' +
			CASE WHEN COALESCE(tbClienteEventual.UnidadeFederacao,tbCliFor.UFCliFor) = 'EX' THEN
				''
			ELSE
				'<cep>' + COALESCE(tbClienteEventual.CEPCliEven,tbCliFor.CEPCliFor) + '</cep>'
			END +
			'<cidade>' + RTRIM(LTRIM(COALESCE(tbClienteEventual.MunicipioCliEven,tbCliFor.MunicipioCliFor))) + '</cidade>' +
			'<uf>' + COALESCE(tbClienteEventual.UnidadeFederacao,tbCliFor.UFCliFor) + '</uf>' +
			'<nome>' + RTRIM(LTRIM(COALESCE(tbClienteEventual.NomeCliEven,tbCliFor.NomeCliFor))) + '</nome>' +
			--'<nomefantasia>' + '' + '</nomefantasia>' +
			CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND tbCliFor.TipoCliFor = 'J' 
						AND RTRIM(LTRIM(tbCliForJuridica.InscricaoMunicipalJuridica)) <> 'ISENTO' 
						AND tbCliForJuridica.InscricaoMunicipalJuridica IS NOT NULL 
						AND RTRIM(LTRIM(tbCliForJuridica.InscricaoMunicipalJuridica)) <> '' 
						AND RTRIM(LTRIM(tbCliFor.MunicipioCliFor)) = RTRIM(LTRIM(tbLocal.MunicipioLocal)) THEN
				'<inscricao>' + RTRIM(LTRIM(COALESCE(REPLACE(REPLACE(REPLACE(tbCliForJuridica.InscricaoMunicipalJuridica,'.',''),'-',''),'/',''),''))) + '</inscricao>' 
			ELSE
				''
			END +
			CASE WHEN COALESCE(tbClienteEventual.UnidadeFederacao,tbCliFor.UFCliFor) = 'EX' THEN
				''
			ELSE
				CASE WHEN tbCliFor.TipoCliFor = 'J' OR tbClienteEventual.CGCCliEven IS NOT NULL THEN
					CASE WHEN RTRIM(LTRIM(COALESCE(tbClienteEventual.CGCCliEven,tbCliForJuridica.CGCJuridica))) LIKE 'ISENT%' THEN
						'<cpfcnpj>' + '00000000000000' + '</cpfcnpj>'	
					ELSE
						'<cpfcnpj>' + COALESCE(COALESCE(tbClienteEventual.CGCCliEven,tbCliForJuridica.CGCJuridica),'') + '</cpfcnpj>'	
					END
				ELSE
					CASE WHEN RTRIM(LTRIM(COALESCE(COALESCE(tbClienteEventual.CPFCliEven,tbCliForFisica.CPFFisica),''))) LIKE 'ISENT%' THEN
						'<cpfcnpj>' + '00000000000' + '</cpfcnpj>'
					ELSE
						'<cpfcnpj>' + RTRIM(LTRIM(COALESCE(COALESCE(tbClienteEventual.CPFCliEven,tbCliForFisica.CPFFisica),''))) + '</cpfcnpj>'
					END
				END 
			END +
			CASE WHEN tbClienteEventual.RGCliEven IS NOT NULL OR tbClienteEventual.InscricaoEstadualCliEven IS NOT NULL THEN
				'<rgie>' + RTRIM(LTRIM(COALESCE(tbClienteEventual.RGCliEven,tbClienteEventual.InscricaoEstadualCliEven))) + '</rgie>' 
			ELSE
				''
			END +
			CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND ( RTRIM(LTRIM(COALESCE(tbCliFor.EmailNFSE,tbCliFor.EmailCliFor))) <> '' ) THEN
				'<email>' + RTRIM(LTRIM(COALESCE(tbCliFor.EmailNFSE,tbCliFor.EmailCliFor))) + '</email>'
			ELSE
				''
			END +
			CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND ( RTRIM(LTRIM(tbCliFor.TelefoneCliFor)) <> '' AND tbCliFor.TelefoneCliFor IS NOT NULL ) THEN
				'<ddd>' + RTRIM(LTRIM(COALESCE(DDDTelefoneCliFor,''))) + '</ddd>' +
				'<fone>' + RTRIM(LTRIM(TelefoneCliFor)) + '</fone>'
			ELSE
				''
			END + 
		'</tomador>' +
	'</nota>',
	tbDocumento.NumeroDocumento
	FROM tbDocumento (NOLOCK)

	INNER JOIN tbLocal (NOLOCK)
	ON	tbLocal.CodigoEmpresa = tbDocumento.CodigoEmpresa
	AND	tbLocal.CodigoLocal = tbDocumento.CodigoLocal

	INNER JOIN tbLocalFT (NOLOCK)
	ON	tbLocalFT.CodigoEmpresa = tbDocumento.CodigoEmpresa
	AND	tbLocalFT.CodigoLocal = tbDocumento.CodigoLocal

	INNER JOIN tbCliFor (NOLOCK)
	ON	tbCliFor.CodigoEmpresa = tbDocumento.CodigoEmpresa
	AND	tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor

	LEFT JOIN tbCliForFisica (NOLOCK)
	ON	tbCliForFisica.CodigoEmpresa = tbCliFor.CodigoEmpresa
	AND	tbCliForFisica.CodigoCliFor = tbCliFor.CodigoCliFor

	LEFT JOIN tbCliForJuridica (NOLOCK)
	ON	tbCliForJuridica.CodigoEmpresa = tbCliFor.CodigoEmpresa
	AND	tbCliForJuridica.CodigoCliFor = tbCliFor.CodigoCliFor

	INNER JOIN tbDocumentoFT (NOLOCK)
	ON	tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa
	AND	tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal
	AND	tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
	AND	tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento
	AND	tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento
	AND	tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor
	AND	tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao

	INNER JOIN tbDocumentoRPS (NOLOCK)
	ON	tbDocumentoRPS.CodigoEmpresa = tbDocumento.CodigoEmpresa
	AND	tbDocumentoRPS.CodigoLocal = tbDocumento.CodigoLocal
	AND	tbDocumentoRPS.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
	AND	tbDocumentoRPS.NumeroDocumento = tbDocumento.NumeroDocumento
	AND	tbDocumentoRPS.DataDocumento = tbDocumento.DataDocumento
	AND	tbDocumentoRPS.CodigoCliFor = tbDocumento.CodigoCliFor
	AND	tbDocumentoRPS.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao

	INNER JOIN tbNaturezaOperacao (NOLOCK)
	ON tbNaturezaOperacao.CodigoEmpresa = @CodigoEmpresa AND
	tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao

	LEFT JOIN tbClienteEventual (NOLOCK)
	ON	tbClienteEventual.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa
	AND	tbClienteEventual.CodigoClienteEventual = tbDocumentoFT.CodigoClienteEventual

	LEFT JOIN tbCEP (NOLOCK)
	ON  tbCEP.NumeroCEP = tbCliFor.CEPCliFor

	WHERE tbDocumento.CodigoEmpresa					= @CodigoEmpresa
	AND	tbDocumento.CodigoLocal						= @CodigoLocal
	AND	tbDocumento.EntradaSaidaDocumento			= 'S'
	AND	tbDocumento.DataDocumento					= @DataDocumento
	AND	tbDocumento.ValorBaseISSDocumento			> 0
	AND tbDocumento.TipoLancamentoMovimentacao		= 7
	AND tbDocumento.EntradaSaidaDocumento			= 'S'
	AND tbDocumento.ValorContabilDocumento			<> 0	--- não pegar canceladas
	AND tbDocumento.CondicaoNFCancelada				<> 'V'	--- não pegar canceladas
	AND tbDocumento.NumeroDocumento					= @NumeroDocumento

	-- descarrega dados obtidos
	SELECT 
	Linha,
--	'<?xml version="1.0" encoding="utf-8"?>' AS Cabecalho,
	tbLocal.CGCLocal,
	@CodigoMunicipio as NumeroMunicipio
	FROM #tmpXML
	INNER JOIN tbLocal on
			   tbLocal.CodigoEmpresa = @CodigoEmpresa and
			   tbLocal.CodigoLocal = @CodigoLocal
	ORDER BY Ordem
END
GO
GRANT EXECUTE ON dbo.whNFeBarraGarcas3 TO SQLUsers
GO