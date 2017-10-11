if exists(select 1 from sysobjects where id = object_id('whNFeBH'))
	DROP PROCEDURE dbo.whNFeBH
GO
CREATE PROCEDURE dbo.whNFeBH
			@CodigoEmpresa dtInteiro04 ,
	  		@CodigoLocal dtInteiro04 , 
			@DataInicial datetime,
			@DataFinal datetime,
            @DocumentoInicial numeric(6),
            @DocumentoFinal numeric(6),
            @ItemListaServico char(5) = '',
			@Cancelada char(1) = 'F'

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: Livros Fiscais
 AUTOR........: Condez
 DATA.........: 08/10/2009
 UTILIZADO EM : 
 OBJETIVO.....: Gerar Arquivo XML RPS(Recibo Provisório de Serviços) Municipal - BH

 whNFeBH 1608,0,'2010-01-14','2010-01-14',5068,5068
select * from tbDocumentoFT where NumeroDocumento = 5068

-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

WITH ENCRYPTION
AS 

DECLARE @CodigoServico varchar(5)

/*
SELECT @CodigoServico = (SELECT MAX(tbItemDocumento.CodigoServicoISSItemDocto) 
						FROM tbItemDocumento  
						WHERE tbItemDocumento.CodigoEmpresa = @CodigoEmpresa
						AND	tbItemDocumento.CodigoLocal = @CodigoLocal
						AND	tbItemDocumento.EntradaSaidaDocumento = 'S'
						AND	tbItemDocumento.NumeroDocumento = @DocumentoInicial 
						AND	tbItemDocumento.DataDocumento = @DataInicial
						AND	tbItemDocumento.TipoLancamentoMovimentacao = 7 
						AND tbItemDocumento.CodigoServicoISSItemDocto IS NOT NULL)
*/
SELECT @CodigoServico = 1401
SELECT @CodigoServico = LEFT(@CodigoServico,2) + '.' + RIGHT(@CodigoServico,2)

SET NOCOUNT ON

IF @Cancelada = 'F' 
BEGIN
 
	--criando tabela temporaria
	UPDATE tbLocalLF 
	SET SequencialArquivo = SequencialArquivo + 1 
	WHERE tbLocalLF.CodigoEmpresa = @CodigoEmpresa
	AND	tbLocalLF.CodigoLocal = @CodigoLocal

	CREATE TABLE #tmpXML (Linha VARCHAR(8000), Ordem numeric(6)) 

	--INSERT #tmpXML
	--SELECT
	--'<?xml version="1.0" encoding="UTF-8"?><cabecalho xmlns="http://www.abrasf.org.br/nfse.xsd" versao="1.00"><versaoDados>1.00</versaoDados></cabecalho>',
	---1


	INSERT #tmpXML
	SELECT
	'<?xml version="1.0" encoding="utf-8" ?>' +
	'<GerarNfseEnvio xmlns="http://www.abrasf.org.br/nfse.xsd">' +
	'<LoteRps Id="'+ LTRIM(RTRIM(CONVERT(VARCHAR(6),tbLocalLF.SequencialArquivo))) + '" versao="1.00">' +
	'<NumeroLote>' + LTRIM(RTRIM(CONVERT(VARCHAR(6),tbLocalLF.SequencialArquivo))) + '</NumeroLote>' +
	'<Cnpj>'+ tbLocal.CGCLocal + '</Cnpj>' +
	'<InscricaoMunicipal>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</InscricaoMunicipal>' +
	'<QuantidadeRps>1</QuantidadeRps>' + 
	'<ListaRps>',
	0
	FROM tbLocal (NOLOCK)
	INNER JOIN tbLocalLF (NOLOCK) ON
			   tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND
			   tbLocalLF.CodigoLocal = @CodigoLocal 
	WHERE
	tbLocal.CodigoEmpresa = @CodigoEmpresa AND
	tbLocal.CodigoLocal = @CodigoLocal 


	--- outra temporaria

	INSERT #tmpXML
	SELECT
	'<Rps xmlns="http://www.abrasf.org.br/nfse.xsd">' + 
	'<InfRps Id="rps_' + LTRIM(RTRIM(CONVERT(VARCHAR(6),1000 + tbDocumento.NumeroDocumento))) + '">' +
	'<IdentificacaoRps>' +
	'<Numero>' + LTRIM(RTRIM(CONVERT(VARCHAR(6),1000 + tbDocumento.NumeroDocumento))) + '</Numero>' +
	'<Serie>' + RTRIM(LTRIM(tbDocumento.SerieDocumento)) + '</Serie>' +
	'<Tipo>'  + '1' + '</Tipo>' +
	'</IdentificacaoRps>' +
	'<DataEmissao>' +  SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,tbDocumento.DataDocumento)),2,4) + '-' + SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,tbDocumento.DataDocumento)),2,2) + '-' + 	SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,tbDocumento.DataDocumento)),2,2) + 'T00:00:00' + '</DataEmissao>' +
	'<NaturezaOperacao>1</NaturezaOperacao> ' +
	'<OptanteSimplesNacional>2</OptanteSimplesNacional>' +
	'<IncentivadorCultural>2</IncentivadorCultural>' +
	'<Status>1</Status>' +
	'<Servico>' +
	'<Valores>' +
	'<ValorServicos>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumento.ValorBaseISSDocumento)) + '</ValorServicos>' +
	'<ValorDeducoes>0.00</ValorDeducoes>' +
	'<ValorPis>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.vPISRetidoDocFT))  + '</ValorPis>' +
	'<ValorCofins>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.vCOFINSRetidoDocFT))  + '</ValorCofins>' +
	'<ValorInss>0.00</ValorInss>' +
	'<ValorIr>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.ValorIRRFDocFT))  + '</ValorIr>' +
	'<ValorCsll>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.ValorCSLLDocFT)) + '</ValorCsll>' +
	'<IssRetido>' + CASE WHEN tbDocumentoFT.cSitTribISS = 'R' THEN '1' ELSE '2' END + '</IssRetido>' +
	CASE WHEN tbDocumentoFT.cSitTribISS = 'R' THEN
		'<ValorIssRetido>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumento.ValorISSDocumento)) + '</ValorIssRetido>'
	ELSE
		'<ValorIss>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumento.ValorISSDocumento)) + '</ValorIss>'
	END +
	'<OutrasRetencoes>0.00</OutrasRetencoes>' +
	'<BaseCalculo>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumento.ValorBaseISSDocumento)) + '</BaseCalculo>' +
	'<Aliquota>' + COALESCE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2), (SELECT MAX(tbItemDoc.PercentualISSItemDocto) 
							FROM tbItemDocumento tbItemDoc 
							WHERE tbItemDoc.CodigoEmpresa = @CodigoEmpresa
							AND	tbItemDoc.CodigoLocal = @CodigoLocal
							AND	tbItemDoc.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
							AND	tbItemDoc.NumeroDocumento = tbDocumento.NumeroDocumento
							AND	tbItemDoc.DataDocumento = tbDocumento.DataDocumento
							AND	tbItemDoc.CodigoCliFor = tbDocumento.CodigoCliFor
							AND	tbItemDoc.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao)/100 )),'0') + '</Aliquota>' +

	'</Valores>' +
	CASE WHEN tbNaturezaOperacao.CodigoTipoOperacao <> 12 THEN
		CASE WHEN RTRIM(LTRIM(@ItemListaServico)) = '' THEN
		'<ItemListaServico>' + @CodigoServico + '</ItemListaServico>'  
		ELSE
		'<ItemListaServico>' + RTRIM(LTRIM(@ItemListaServico)) + '</ItemListaServico>' 
		END 
	ELSE 
		CASE WHEN @CodigoEmpresa <> 1918 THEN
			'<ItemListaServico>' + '14.01' + '</ItemListaServico>' 
		ELSE
			CASE WHEN @CodigoLocal = 0 THEN
				'<ItemListaServico>' + '10.09' + '</ItemListaServico>' 
			ELSE
				'<ItemListaServico>' + '14.01' + '</ItemListaServico>' 
			END
		END
	END + 
	CASE WHEN tbNaturezaOperacao.CodigoTipoOperacao <> 12 THEN
		CASE WHEN tbDocumento.DataDocumento <= '2012-03-31' THEN
			'<CodigoTributacaoMunicipio>452000101</CodigoTributacaoMunicipio>'
		ELSE
			'<CodigoTributacaoMunicipio>140100288</CodigoTributacaoMunicipio>'
		END
	ELSE
		CASE WHEN @CodigoLocal = 0 THEN
			'<CodigoTributacaoMunicipio>140100288</CodigoTributacaoMunicipio>'
		ELSE
			'<CodigoTributacaoMunicipio>452000101</CodigoTributacaoMunicipio>'
		END
	END + 
	'<Discriminacao>' + COALESCE(LTRIM(RTRIM(dbo.fnItensNFEletronicaBH(@CodigoEmpresa, @CodigoLocal, tbDocumento.NumeroDocumento, tbDocumento.DataDocumento, tbDocumento.CodigoCliFor))),' ') + '</Discriminacao>' +
	'<CodigoMunicipio>3106200</CodigoMunicipio>' +
	'</Servico>' +
	'<Prestador>' +
	'<Cnpj>' + tbLocal.CGCLocal + '</Cnpj>' +
	'<InscricaoMunicipal>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</InscricaoMunicipal>' +
	'</Prestador>' +
	'<Tomador>' +
	'<IdentificacaoTomador>' +
	CASE WHEN tbCliFor.UFCliFor <> 'EX' THEN
		'<CpfCnpj>' + 
		CASE WHEN tbCliFor.TipoCliFor = 'J' THEN
			'<Cnpj>' + COALESCE(tbCliForJuridica.CGCJuridica,'') + '</Cnpj>' 
		ELSE
			'<Cpf>' + COALESCE(tbCliForFisica.CPFFisica,'') + '</Cpf>'
		END +
		'</CpfCnpj>'
	ELSE
		''
	END +
	CASE WHEN tbCliFor.TipoCliFor = 'J' AND RTRIM(LTRIM(tbCliForJuridica.InscricaoMunicipalJuridica)) <> 'ISENTO' AND tbCliForJuridica.InscricaoMunicipalJuridica IS NOT NULL AND RTRIM(LTRIM(tbCliForJuridica.InscricaoMunicipalJuridica)) <> '' AND RTRIM(LTRIM(tbCliFor.MunicipioCliFor)) = 'BELO HORIZONTE' THEN
		'<InscricaoMunicipal>' + RTRIM(LTRIM(COALESCE(REPLACE(REPLACE(REPLACE(tbCliForJuridica.InscricaoMunicipalJuridica ,'.',''),'-',''),'/',''),''))) + '</InscricaoMunicipal>' 
	ELSE
		''
	END +
	'</IdentificacaoTomador>' +
	'<RazaoSocial>' + RTRIM(LTRIM(tbCliFor.NomeCliFor)) + '</RazaoSocial>' +
	'<Endereco>' +
	'<Endereco>' + RTRIM(LTRIM(tbCliFor.RuaCliFor)) + '</Endereco>' +
	CASE WHEN NumeroEndCliFor IS NOT NULL AND NumeroEndCliFor <> 0 THEN
		'<Numero>' + COALESCE(CONVERT(VARCHAR(5),NumeroEndCliFor),'') + '</Numero>'
	ELSE
		'<Numero>SN</Numero>'
	END + 
	CASE WHEN tbCliFor.ComplementoEndCliFor IS NOT NULL AND RTRIM(LTRIM(tbCliFor.ComplementoEndCliFor)) <> '' THEN
		'<Complemento>' + COALESCE(RTRIM(LTRIM(tbCliFor.ComplementoEndCliFor)),'') + '</Complemento>'
	ELSE
		''
	END + 
	'<Bairro>' + COALESCE(RTRIM(LTRIM(tbCliFor.BairroCliFor)),'') + '</Bairro>' +
	CASE WHEN tbCliFor.UFCliFor <> 'EX' THEN
		'<CodigoMunicipio>' + COALESCE(CONVERT(VARCHAR(7),tbCEP.NumeroMunicipio),'') + '</CodigoMunicipio>'
	ELSE
		'<CodigoMunicipio>9999999</CodigoMunicipio>'
	END +
	'<Uf>' + tbCliFor.UFCliFor + '</Uf>' +
	CASE WHEN tbCliFor.UFCliFor <> 'EX' THEN 
		'<Cep>' + tbCliFor.CEPCliFor + '</Cep>'
	ELSE
		''
	END +
	'</Endereco>' +
	'</Tomador>' +
	'</InfRps>' + 
	'</Rps>',
	tbDocumento.NumeroDocumento
	FROM tbDocumento (NOLOCK)
	INNER JOIN tbLocal (NOLOCK)
	ON	tbLocal.CodigoEmpresa = tbDocumento.CodigoEmpresa
	AND	tbLocal.CodigoLocal = tbDocumento.CodigoLocal

	INNER JOIN tbCliFor (NOLOCK)
	ON	tbCliFor.CodigoEmpresa = tbDocumento.CodigoEmpresa
	AND	tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor

	LEFT JOIN tbCEP (NOLOCK)
	ON  tbCEP.NumeroCEP = tbCliFor.CEPCliFor

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

	INNER JOIN tbNaturezaOperacao (NOLOCK)
    ON tbNaturezaOperacao.CodigoEmpresa = @CodigoEmpresa AND
    tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao

	LEFT JOIN tbClienteEventual (NOLOCK)
	ON	tbClienteEventual.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa
	AND	tbClienteEventual.CodigoClienteEventual = tbDocumentoFT.CodigoClienteEventual

	WHERE tbDocumento.CodigoEmpresa = @CodigoEmpresa
	AND	tbDocumento.CodigoLocal = @CodigoLocal
	AND	tbDocumento.EntradaSaidaDocumento = 'S'
	AND	(tbDocumento.DataDocumento BETWEEN @DataInicial AND @DataFinal)
	AND	tbDocumento.ValorBaseISSDocumento > 0
	AND 	tbDocumento.TipoLancamentoMovimentacao = 7
	AND 	tbDocumento.EntradaSaidaDocumento = 'S'
	AND 	tbDocumento.ValorContabilDocumento <> 0 --- não pegar canceladas
	AND 	tbDocumento.CondicaoNFCancelada <> 'V' --- não pegar canceladas
	AND tbDocumento.NumeroDocumento between @DocumentoInicial AND @DocumentoFinal

	INSERT #tmpXML
	SELECT
	'</ListaRps>' +
	'</LoteRps>' + 
	'</GerarNfseEnvio>',
	999999

	END

IF @Cancelada = 'V'
BEGIN

	INSERT #tmp
	SELECT
	'<InfPedidoCancelamento Id="rps_' + LTRIM(RTRIM(CONVERT(VARCHAR(6),tbDocumentoRPS.NumeroDocumento))) + '">' +
	'<IdentificacaoNfse>' +
	'<NumeroNfse>' + CONVERT(VARCHAR(15),NumeroNFE) + '<\NumeroNfse>' +
	'<Cnpj>'+ '17161241000468' + '</Cnpj>' +
	'<InscricaoMunicipal>' + '3454710016' + '</InscricaoMunicipal>' +
	'<CodigoMunicipio>3106200</CodigoMunicipio>' +
	'</IdentificacaoNfse>' + 
	'<CodigoCancelamento>2</CodigoCancelamento>' +
	'</InfPedidoCancelamento>'
	FROM tbDocumentoRPS (NOLOCK)
	WHERE
	tbDocumentoRPS.CodigoEmpresa = @CodigoEmpresa AND
	tbDocumentoRPS.CodigoLocal = @CodigoLocal AND
	tbDocumentoRPS.TipoRPS = 'CAN' AND
	tbDocumentoRPS.NumeroDocumento = @DocumentoInicial AND
	tbDocumentoRPS.DataDocumento = @DataInicial 

END

SELECT Linha FROM #tmpXML order by Ordem

SET NOCOUNT OFF
GO

GRANT EXECUTE ON dbo.whNFeBH TO SQLUsers
GO