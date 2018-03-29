if exists(select 1 from sysobjects where id = object_id('whNFeMontesClaros'))
	DROP PROCEDURE dbo.whNFeMontesClaros
GO
CREATE PROCEDURE dbo.whNFeMontesClaros
			@CodigoEmpresa dtInteiro04 ,
	  		@CodigoLocal dtInteiro04 , 
			@DataDocumento datetime,
			@NumeroDocumento numeric(6)

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: Livros Fiscais
 AUTOR........: Condez
 DATA.........: 08/10/2009
 UTILIZADO EM : 
 OBJETIVO.....: Gerar Arquivo XML RPS(Recibo Provisório de Serviços) Municipal - Xanxere - 4219507

Código de situação de lote de RPS
1 – Não Recebido
2 – Não Processado
3 – Processado com Erro
4 – Processado com Sucesso

EnviarLoteRpsEnvio xmlns="http://www.ginfes.com.br/servico_enviar_lote_rps_envio_v03.xsd" xmlns:tipos="http://www.ginfes.com.br/tipos_v03.xsd" xmlns:dsig="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
whNFeGINFEs 1608,0,'2010-09-08',29
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

AS 

DECLARE @CodigoMunicipio varchar(10)
DECLARE @CodigoServico varchar(10)
DECLARE @CodigoCnae varchar(10)
DECLARE @SerieDocumento varchar(4)
DECLARE @CodigoTributacaoMunicipio varchar(10)
DECLARE @PercentualISS dtPercentual

SELECT @PercentualISS = MAX(tbItemDocumento.PercentualISSItemDocto)
FROM tbItemDocumento
WHERE
CodigoEmpresa = @CodigoEmpresa AND
CodigoLocal = @CodigoLocal AND
EntradaSaidaDocumento = 'S' AND
NumeroDocumento = @NumeroDocumento AND
DataDocumento = @DataDocumento AND
TipoLancamentoMovimentacao = 7

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
TipoLancamentoMovimentacao = 7

SELECT 
@CodigoServico = COALESCE(ItemListaServico,'99.99'),
@CodigoCnae = COALESCE(CodigoCnae,'9999 '),
@CodigoTributacaoMunicipio = COALESCE(CodigoTributacaoMunicipio,'9') 
FROM tbItemDocumento (NOLOCK)
LEFT JOIN tbTipoServicoNFSE (NOLOCK) ON
          tbTipoServicoNFSE.CodigoEmpresa = @CodigoEmpresa AND
          tbTipoServicoNFSE.CodigoLocal = @CodigoLocal AND
          tbTipoServicoNFSE.CodigoServico = CodigoServicoISSItemDocto 
WHERE 
tbItemDocumento.CodigoEmpresa = @CodigoEmpresa
AND	tbItemDocumento.CodigoLocal = @CodigoLocal
AND	tbItemDocumento.EntradaSaidaDocumento = 'S'
AND	tbItemDocumento.NumeroDocumento = @NumeroDocumento 
AND	tbItemDocumento.DataDocumento = @DataDocumento
AND	tbItemDocumento.TipoLancamentoMovimentacao = 7 
AND tbItemDocumento.CodigoServicoISSItemDocto IS NOT NULL

SET NOCOUNT ON

CREATE TABLE #tmpXML (Linha VARCHAR(8000), Ordem numeric(6)) 

INSERT #tmpXML
SELECT
'<?xml version="1.0"?>' +
'<GerarNfseEnvio xmlns="http://www.abrasf.org.br/nfse.xsd">' +
'<Rps>' +
'<InfDeclaracaoPrestacaoServico Id="D' + RIGHT('000000' + LTRIM(RTRIM(CONVERT(VARCHAR(6),@NumeroDocumento))),6) + '">' +
'<Rps>' +
'<IdentificacaoRps>',
0
FROM tbLocal (NOLOCK)
WHERE
tbLocal.CodigoEmpresa = @CodigoEmpresa AND
tbLocal.CodigoLocal = @CodigoLocal 


--- outra temporaria

INSERT #tmpXML
SELECT
'<Numero>' + LTRIM(RTRIM(CONVERT(VARCHAR(6),tbDocumento.NumeroDocumento))) + '</Numero>' +
'<Serie>' + RTRIM(LTRIM(@SerieDocumento)) + '</Serie>' +
'<Tipo>'  + '1' + '</Tipo>' +
'</IdentificacaoRps>' +
'<DataEmissao>' +  SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,COALESCE(tbDocumento.DataHoraNSU,tbDocumento.DataDocumento))),2,4) + '-' + SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,COALESCE(tbDocumento.DataHoraNSU,tbDocumento.DataDocumento))),2,2) + '-' + 	SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,COALESCE(tbDocumento.DataHoraNSU,tbDocumento.DataDocumento))),2,2) + '</DataEmissao>' +
'<Status>1</Status>' +
'</Rps>' +
'<Competencia>' +  SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,COALESCE(tbDocumento.DataHoraNSU,tbDocumento.DataDocumento))),2,4) + '-' + SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,COALESCE(tbDocumento.DataHoraNSU,tbDocumento.DataDocumento))),2,2) + '-' + 	SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,COALESCE(tbDocumento.DataHoraNSU,tbDocumento.DataDocumento))),2,2) + '</Competencia>' +
'<Servico>' +
'<Valores>' +
'<ValorServicos>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumento.ValorBaseISSDocumento)) + '</ValorServicos>' +
CASE WHEN PercReducaoISSNaturezaOperacao <> 0 THEN
	'<ValorDeducoes>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),( tbDocumento.ValorBaseISSDocumento * (PercReducaoISSNaturezaOperacao / 100) ))) + '</ValorDeducoes>'
ELSE
	''
END +
CASE WHEN tbDocumentoFT.vPISRetidoDocFT > 0 AND tbDocumentoFT.cDeduzPisCofinsCsllDupDocFT = 'V' THEN
	'<ValorPis>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.vPISRetidoDocFT))  + '</ValorPis>'
ELSE
	'<ValorPis>' + '0.00' + '</ValorPis>'
END +
CASE WHEN tbDocumentoFT.vCOFINSRetidoDocFT > 0 AND tbDocumentoFT.cDeduzPisCofinsCsllDupDocFT = 'V' THEN
	'<ValorCofins>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.vCOFINSRetidoDocFT)) + '</ValorCofins>'
ELSE
	'<ValorCofins>' + '0.00' + '</ValorCofins>'
END +
'<ValorInss>0.00</ValorInss>' +
'<ValorIr>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.ValorIRRFDocFT))  + '</ValorIr>' +
CASE WHEN tbDocumentoFT.ValorCSLLDocFT <> 0 AND tbDocumentoFT.cDeduzPisCofinsCsllDupDocFT = 'V' THEN
	'<ValorCsll>' + + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.ValorCSLLDocFT)) + '</ValorCsll>' 
ELSE
	'<ValorCsll>0.00</ValorCsll>' 
END +
'<ValorIss>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumento.ValorISSDocumento)) + '</ValorIss>' +
'<Aliquota>' + COALESCE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2), (SELECT MAX(tbItemDoc.PercentualISSItemDocto) 
							FROM tbItemDocumento tbItemDoc 
							WHERE tbItemDoc.CodigoEmpresa = @CodigoEmpresa
							AND	tbItemDoc.CodigoLocal = @CodigoLocal
							AND	tbItemDoc.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
							AND	tbItemDoc.NumeroDocumento = tbDocumento.NumeroDocumento
							AND	tbItemDoc.DataDocumento = tbDocumento.DataDocumento
							AND	tbItemDoc.CodigoCliFor = tbDocumento.CodigoCliFor
							AND	tbItemDoc.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao))),'0') + '</Aliquota>' +
'<DescontoIncondicionado>0.00</DescontoIncondicionado>' +
---CASE WHEN PercReducaoISSNaturezaOperacao <> 0 THEN
	---'<BaseCalculo>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumento.ValorBaseISSDocumento - CONVERT(NUMERIC(16,2),( tbDocumento.ValorBaseISSDocumento * (PercReducaoISSNaturezaOperacao / 100) )))) + '</BaseCalculo>'
---ELSE
	---'<BaseCalculo>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumento.ValorBaseISSDocumento)) + '</BaseCalculo>'
---END +
'</Valores>' +
'<IssRetido>' + CASE WHEN tbDocumentoFT.cSitTribISS = 'R' THEN '1' ELSE '2' END + '</IssRetido>' +
'<ItemListaServico>' + @CodigoServico + '</ItemListaServico>' +
'<CodigoCnae>' + @CodigoCnae + '</CodigoCnae>' + 
'<CodigoTributacaoMunicipio>' + @CodigoTributacaoMunicipio + '</CodigoTributacaoMunicipio>' +
'<Discriminacao>' + COALESCE(LTRIM(RTRIM(dbo.fnItensNFMontesClaros(@CodigoEmpresa, @CodigoLocal, tbDocumento.NumeroDocumento, tbDocumento.DataDocumento, tbDocumento.CodigoCliFor))),' ') + '</Discriminacao>' +
'<CodigoMunicipio>' + @CodigoMunicipio + '</CodigoMunicipio>' +
'<ExigibilidadeISS>' + '1' + '</ExigibilidadeISS>' +
'<MunicipioIncidencia>' + @CodigoMunicipio + '</MunicipioIncidencia>' +
'</Servico>' +
'<Prestador>' +
'<CpfCnpj>' +
'<Cnpj>' + tbLocal.CGCLocal + '</Cnpj>' +
'</CpfCnpj>' +
'<InscricaoMunicipal>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</InscricaoMunicipal>' +
'</Prestador>' +
'<Tomador>' +
'<IdentificacaoTomador>' +
'<CpfCnpj>' + 
CASE WHEN tbCliFor.TipoCliFor = 'J' OR tbClienteEventual.CGCCliEven IS NOT NULL THEN
	CASE WHEN RTRIM(LTRIM(COALESCE(tbClienteEventual.CGCCliEven,tbCliForJuridica.CGCJuridica))) LIKE 'ISENT%' THEN
		'<Cnpj>' + '00000000000000' + '</Cnpj>'	
	ELSE
		'<Cnpj>' + COALESCE(COALESCE(tbClienteEventual.CGCCliEven,tbCliForJuridica.CGCJuridica),'') + '</Cnpj>'	
	END
ELSE
	CASE WHEN RTRIM(LTRIM(COALESCE(COALESCE(tbClienteEventual.CPFCliEven,tbCliForFisica.CPFFisica),''))) LIKE 'ISENT%' THEN
		'<Cpf>' + '00000000000' + '</Cpf>'
	ELSE
		'<Cpf>' + RTRIM(LTRIM(COALESCE(COALESCE(tbClienteEventual.CPFCliEven,tbCliForFisica.CPFFisica),''))) + '</Cpf>'
	END
END +
'</CpfCnpj>' +
CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND tbCliFor.TipoCliFor = 'J' AND RTRIM(LTRIM(tbCliForJuridica.InscricaoMunicipalJuridica)) <> 'ISENTO' AND tbCliForJuridica.InscricaoMunicipalJuridica IS NOT NULL AND RTRIM(LTRIM(tbCliForJuridica.InscricaoMunicipalJuridica)) <> '' AND RTRIM(LTRIM(tbCliFor.MunicipioCliFor)) = RTRIM(LTRIM(tbLocal.MunicipioLocal)) THEN
	'<InscricaoMunicipal>' + RTRIM(LTRIM(COALESCE(REPLACE(REPLACE(REPLACE(tbCliForJuridica.InscricaoMunicipalJuridica ,'.',''),'-',''),'/',''),''))) + '</InscricaoMunicipal>' 
ELSE
	''
END +
'</IdentificacaoTomador>' +
'<RazaoSocial>' + RTRIM(LTRIM(COALESCE(tbClienteEventual.NomeCliEven,tbCliFor.NomeCliFor))) + '</RazaoSocial>' +
'<Endereco>' +
'<Endereco>' + RTRIM(LTRIM(COALESCE(tbClienteEventual.EnderecoCliEven,tbCliFor.RuaCliFor))) + '</Endereco>' +
CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND NumeroEndCliFor IS NOT NULL AND NumeroEndCliFor <> 0 THEN
	'<Numero>' + COALESCE(CONVERT(VARCHAR(5),NumeroEndCliFor),'') + '</Numero>'
ELSE
	'<Numero>0</Numero>'
END + 
CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND tbCliFor.ComplementoEndCliFor IS NOT NULL AND RTRIM(LTRIM(tbCliFor.ComplementoEndCliFor)) <> '' THEN
	'<Complemento>' + COALESCE(RTRIM(LTRIM(tbCliFor.ComplementoEndCliFor)),'') + '</Complemento>'
ELSE
	''
END + 
'<Bairro>' + COALESCE(RTRIM(LTRIM(COALESCE(tbClienteEventual.BairroCliEven,tbCliFor.BairroCliFor))),'') + '</Bairro>' +
'<CodigoMunicipio>' + RIGHT('0000000' + RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(7),tbCEP.NumeroMunicipio),''))),7) + '</CodigoMunicipio>' +
'<Uf>' + COALESCE(tbClienteEventual.UnidadeFederacao,tbCliFor.UFCliFor) + '</Uf>' +
'<Cep>' + COALESCE(tbClienteEventual.CEPCliEven,tbCliFor.CEPCliFor) + '</Cep>' +
'</Endereco>' +
CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND (( RTRIM(LTRIM(tbCliFor.EmailCliFor)) <> '' AND tbCliFor.EmailCliFor IS NOT NULL ) OR ( RTRIM(LTRIM(tbCliFor.TelefoneCliFor)) <> '' AND tbCliFor.TelefoneCliFor IS NOT NULL )) THEN
	'<Contato>'
ELSE
	''
END +
CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND ( RTRIM(LTRIM(tbCliFor.TelefoneCliFor)) <> '' AND tbCliFor.TelefoneCliFor IS NOT NULL ) THEN
	'<Telefone>' + RTRIM(LTRIM(COALESCE(DDDTelefoneCliFor,''))) + RTRIM(LTRIM(TelefoneCliFor)) + '</Telefone>'
ELSE
	''
END + 
CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND ( RTRIM(LTRIM(tbCliFor.EmailCliFor)) <> '' AND tbCliFor.EmailCliFor IS NOT NULL ) THEN
	'<Email>' + RTRIM(LTRIM(tbCliFor.EmailCliFor)) + '</Email>'
ELSE
	''
END +
CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND (( RTRIM(LTRIM(tbCliFor.EmailCliFor)) <> '' AND tbCliFor.EmailCliFor IS NOT NULL ) OR ( RTRIM(LTRIM(tbCliFor.TelefoneCliFor)) <> '' AND tbCliFor.TelefoneCliFor IS NOT NULL )) THEN
	'</Contato>'
ELSE
	''
END +
'</Tomador>' +
'<OptanteSimplesNacional>2</OptanteSimplesNacional>' +
'<IncentivoFiscal>2</IncentivoFiscal>' +
'</InfDeclaracaoPrestacaoServico>',
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

WHERE tbDocumento.CodigoEmpresa = @CodigoEmpresa
AND	tbDocumento.CodigoLocal = @CodigoLocal
AND	tbDocumento.EntradaSaidaDocumento = 'S'
AND	tbDocumento.DataDocumento = @DataDocumento
AND	tbDocumento.ValorBaseISSDocumento > 0
AND 	tbDocumento.TipoLancamentoMovimentacao = 7
AND 	tbDocumento.EntradaSaidaDocumento = 'S'
AND 	tbDocumento.ValorContabilDocumento <> 0 --- não pegar canceladas
AND 	tbDocumento.CondicaoNFCancelada <> 'V' --- não pegar canceladas
AND tbDocumento.NumeroDocumento = @NumeroDocumento

INSERT #tmpXML
SELECT
'</Rps>' +
'</GerarNfseEnvio>',
999999

SELECT 
Linha,
'<cabecalho xmlns="http://www.abrasf.org.br/nfse.xsd" versao="2.00"><versaoDados>2.00</versaoDados></cabecalho>' as Cabecalho,
tbLocal.CGCLocal,
3151800 as NumeroMunicipio
FROM #tmpXML
inner join tbLocal (nolock) on
           tbLocal.CodigoEmpresa = @CodigoEmpresa and
           tbLocal.CodigoLocal = @CodigoLocal
order by Ordem

SET NOCOUNT OFF

GO

GRANT EXECUTE ON dbo.whNFeMontesClaros TO SQLUsers
GO