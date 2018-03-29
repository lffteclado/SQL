if exists(select 1 from sysobjects where id = object_id('whNFeContagem'))
	DROP PROCEDURE dbo.whNFeContagem
GO
CREATE PROCEDURE dbo.whNFeContagem
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
whNFeContagem 1608,0,'2014-11-17',301

select * from NFDocumento where NumeroDocumento = 3055
whLRPSContagem 1608,0,'2014-11-14'
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

WITH ENCRYPTION
AS 

DECLARE @CodigoMunicipio varchar(10)
DECLARE @CodigoServico varchar(10)
DECLARE @CodigoCnae varchar(10)
DECLARE @SerieDocumento varchar(4)
DECLARE @CodigoTributacaoMunicipio varchar(10)
DECLARE @PercentualISS dtPercentual
DECLARE @Substituicao char(1)
DECLARE @NumeroNFAnterior numeric(12)
DECLARE @DataNFAnterior datetime
DECLARE @RPSSubstituido numeric(12)
DECLARE @NumeroNFSE numeric(15)

SELECT
@NumeroNFSE = NumeroNFE
FROM tbDocumentoRPS
WHERE
CodigoEmpresa = @CodigoEmpresa AND
CodigoLocal = @CodigoLocal AND
EntradaSaidaDocumento = 'S' AND
NumeroDocumento = @NumeroDocumento AND
DataDocumento = @DataDocumento AND
TipoLancamentoMovimentacao = 7

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

SELECT @SerieDocumento = 'RPS'

--- ajusta centavos
UPDATE tbDocumento
SET ValorISSDocumento = CONVERT(NUMERIC(16,2),( ValorBaseISSDocumento * @PercentualISS ) / 100)
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

SELECT @Substituicao = 'F'

IF EXISTS ( SELECT 1 FROM tbOROSCIT 
			WHERE
			tbOROSCIT.CodigoEmpresa = @CodigoEmpresa AND
			tbOROSCIT.CodigoLocal = @CodigoLocal AND
			tbOROSCIT.NumeroNotaFiscalOS = @NumeroDocumento AND
			DATEPART(day,DataEmissaoNotaFiscalOS) = DATEPART(day,@DataDocumento) AND
			DATEPART(month,DataEmissaoNotaFiscalOS) = DATEPART(month,@DataDocumento) AND
			DATEPART(year,DataEmissaoNotaFiscalOS) = DATEPART(year,@DataDocumento) AND
			NumeroSegVoo IS NOT NULL AND
			NumeroSegVoo <> 0 ) SELECT @Substituicao = 'V'

IF @Substituicao = 'V' 
BEGIN

	SELECT 
	@NumeroNFAnterior = NumeroSegVoo,
	@DataNFAnterior = DataNFEntradaConjuntoMaior
	FROM tbOROSCIT 
	WHERE
	tbOROSCIT.CodigoEmpresa = @CodigoEmpresa AND
	tbOROSCIT.CodigoLocal = @CodigoLocal AND
	tbOROSCIT.NumeroNotaFiscalOS = @NumeroDocumento AND
	DATEPART(day,DataEmissaoNotaFiscalOS) = DATEPART(day,@DataDocumento) AND
	DATEPART(month,DataEmissaoNotaFiscalOS) = DATEPART(month,@DataDocumento) AND
	DATEPART(year,DataEmissaoNotaFiscalOS) = DATEPART(year,@DataDocumento) AND
	NumeroSegVoo IS NOT NULL AND
	NumeroSegVoo <> 0 
			
	SELECT @RPSSubstituido = NumeroLote
	FROM tbDocumentoRPS
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal AND
	EntradaSaidaDocumento = 'S' AND
	NumeroDocumento = @NumeroNFAnterior AND
	DataDocumento = @DataNFAnterior AND
	TipoLancamentoMovimentacao = 7

END

IF @Substituicao = 'F' 
BEGIN

	IF EXISTS ( SELECT 1 FROM tbPedido 
			    WHERE
			    tbPedido.CodigoEmpresa = @CodigoEmpresa AND
			    tbPedido.CodigoLocal = @CodigoLocal AND
			    tbPedido.NumeroNotaFiscalPed = @NumeroDocumento AND
			    tbPedido.DataEmissaoNotaFiscalPed = @DataDocumento AND
			    tbPedido.xContratoEmpenhoPed IS NOT NULL AND
			    RTRIM(LTRIM(tbPedido.xContratoEmpenhoPed)) <> '' ) SELECT @Substituicao = 'V'
			   
	IF @Substituicao = 'V'
	BEGIN

		SELECT 
		@NumeroNFAnterior = xContratoEmpenhoPed,
		@DataNFAnterior = DataValidadePrecoPed
		FROM tbPedido (NOLOCK) 
		WHERE
	    tbPedido.CodigoEmpresa = @CodigoEmpresa AND
	    tbPedido.CodigoLocal = @CodigoLocal AND
	    tbPedido.NumeroNotaFiscalPed = @NumeroDocumento AND
	    tbPedido.DataEmissaoNotaFiscalPed = @DataDocumento AND
	    tbPedido.xContratoEmpenhoPed IS NOT NULL AND
	    RTRIM(LTRIM(tbPedido.xContratoEmpenhoPed)) <> '' 
				
		SELECT @RPSSubstituido = NumeroLote
		FROM tbDocumentoRPS
		WHERE
		CodigoEmpresa = @CodigoEmpresa AND
		CodigoLocal = @CodigoLocal AND
		EntradaSaidaDocumento = 'S' AND
		NumeroDocumento = @NumeroNFAnterior AND
		DataDocumento = @DataNFAnterior AND
		TipoLancamentoMovimentacao = 7
	
	END
END
			
SET NOCOUNT ON

IF @CodigoEmpresa = 3610 SELECT @Substituicao = 'F'

CREATE TABLE #tmpXML (Linha VARCHAR(8000), Ordem numeric(6)) 

INSERT #tmpXML
SELECT
'<?xml version="1.0" encoding="UTF-8" ?>' +
'<EnviarLoteRpsEnvio xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">' +
--'<LoteRps Id="Lote' + LTRIM(RTRIM(CONVERT(VARCHAR(6),@NumeroDocumento))) + '">' +
'<LoteRps>' +
'<NumeroLote>' + LTRIM(RTRIM(CONVERT(VARCHAR(6),@NumeroDocumento))) + '</NumeroLote>' +
'<Cnpj>'+ tbLocal.CGCLocal + '</Cnpj>' +
'<InscricaoMunicipal>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</InscricaoMunicipal>' +
'<QuantidadeRps>1</QuantidadeRps>' + 
'<ListaRps>',
0
FROM tbLocal (NOLOCK)
WHERE
tbLocal.CodigoEmpresa = @CodigoEmpresa AND
tbLocal.CodigoLocal = @CodigoLocal 


--- outra temporaria

INSERT #tmpXML
SELECT
'<Rps>' + 
'<InfRps>' +
'<IdentificacaoRps>' +
'<Numero>' + LTRIM(RTRIM(CONVERT(VARCHAR(6),tbDocumento.NumeroDocumento))) + '</Numero>' +
'<Serie>' + RTRIM(LTRIM(@SerieDocumento)) + '</Serie>' +
'<Tipo>'  + '1' + '</Tipo>' +
'</IdentificacaoRps>' +
'<DataEmissao>' +  SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,tbDocumento.DataHoraNSU)),2,4) + '-' + SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,tbDocumento.DataHoraNSU)),2,2) + '-' + 	SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,tbDocumento.DataHoraNSU)),2,2) + 'T' + RIGHT(100 + DATEPART(HOUR,tbDocumento.DataHoraNSU),2) + ':' + RIGHT(100 + DATEPART(MINUTE,tbDocumento.DataHoraNSU),2) + ':' + RIGHT(100 + DATEPART(SECOND,tbDocumento.DataHoraNSU),2) + '</DataEmissao>' +
'<NaturezaOperacao>1</NaturezaOperacao> ' +
'<RegimeEspecialTributacao>1</RegimeEspecialTributacao>' +
'<OptanteSimplesNacional>2</OptanteSimplesNacional>' +
'<IncentivadorCultural>2</IncentivadorCultural>' +
'<Status>1</Status>' +
CASE WHEN @Substituicao = 'V' THEN
	'<RpsSubstituido><Numero>' + LTRIM(RTRIM(CONVERT(VARCHAR(6),@RPSSubstituido))) + '</Numero><Serie>' + + RTRIM(LTRIM(@SerieDocumento)) + '</Serie><Tipo>1</Tipo></RpsSubstituido>'
ELSE
    ''
END +       
'<Servico>' +
'<Valores>' +
'<ValorServicos>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),(tbDocumento.ValorBaseISSDocumento + tbDocumento.TotalDescontoDocumento))) + '</ValorServicos>' +
'<ValorDeducoes>' + '0.00' + '</ValorDeducoes>' +
'<ValorPis>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.vPISRetidoDocFT))  + '</ValorPis>' +
'<ValorCofins>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.vCOFINSRetidoDocFT)) + '</ValorCofins>' +
'<ValorInss>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.ValorSegSocialDocFT)) + '</ValorInss>' +
'<ValorIr>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.ValorIRRFDocFT))  + '</ValorIr>' +
'<ValorCsll>' + + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.ValorCSLLDocFT)) + '</ValorCsll>' +
'<IssRetido>' + CASE WHEN tbDocumentoFT.cSitTribISS = 'R' THEN '1' ELSE '2' END + '</IssRetido>' +
CASE WHEN tbDocumentoFT.cSitTribISS = 'R' THEN
	''
ELSE
	'<ValorIss>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumento.ValorISSDocumento)) + '</ValorIss>'
END +
'<BaseCalculo>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumento.ValorBaseISSDocumento)) + '</BaseCalculo>' +
'<Aliquota>' + COALESCE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,4), (SELECT MAX(tbItemDoc.PercentualISSItemDocto / 100) 
						FROM tbItemDocumento tbItemDoc 
						WHERE tbItemDoc.CodigoEmpresa = @CodigoEmpresa
						AND	tbItemDoc.CodigoLocal = @CodigoLocal
						AND	tbItemDoc.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
						AND	tbItemDoc.NumeroDocumento = tbDocumento.NumeroDocumento
						AND	tbItemDoc.DataDocumento = tbDocumento.DataDocumento
						AND	tbItemDoc.CodigoCliFor = tbDocumento.CodigoCliFor
						AND	tbItemDoc.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao))),'0') + '</Aliquota>' +
'<ValorLiquidoNfse>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumento.ValorBaseISSDocumento - tbDocumentoFT.ValorIRRFDocFT - tbDocumentoFT.ValorCSLLDocFT - tbDocumentoFT.vPISRetidoDocFT - tbDocumentoFT.vCOFINSRetidoDocFT - tbDocumentoFT.ValorSegSocialDocFT )) + '</ValorLiquidoNfse>' +
CASE WHEN tbDocumentoFT.cSitTribISS = 'R' THEN
	'<ValorIssRetido>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumento.ValorISSDocumento)) + '</ValorIssRetido>'
ELSE
	''
END +
'<DescontoCondicionado>0</DescontoCondicionado>' +
'<DescontoIncondicionado>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumento.TotalDescontoDocumento)) + '</DescontoIncondicionado>' + 
'</Valores>' +
'<ItemListaServico>' + @CodigoServico + '</ItemListaServico>' + 
'<CodigoCnae>' + @CodigoCnae + '</CodigoCnae>' + 
'<CodigoTributacaoMunicipio>' + @CodigoTributacaoMunicipio + '</CodigoTributacaoMunicipio>' +
'<Discriminacao>' + COALESCE(LTRIM(RTRIM(dbo.fnItensNFContagem(@CodigoEmpresa, @CodigoLocal, tbDocumento.NumeroDocumento, tbDocumento.DataDocumento, tbDocumento.CodigoCliFor))),' ') + '</Discriminacao>' +
CASE WHEN tbDocumentoFT.cMunFGServicos IS NOT NULL AND tbDocumentoFT.cMunFGServicos <> 0 AND tbDocumentoFT.cMunFGServicos <> 3118601 THEN
	'<CodigoMunicipio>' + CONVERT(VARCHAR(7),tbDocumentoFT.cMunFGServicos) + '</CodigoMunicipio>' 
ELSE
	'<CodigoMunicipio>' + @CodigoMunicipio + '</CodigoMunicipio>' 
END +
'</Servico>' +
'<Prestador>' +
'<Cnpj>' + tbLocal.CGCLocal + '</Cnpj>' +
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
	CASE WHEN tbCliFor.UFCliFor = 'EX' THEN
		'<Cnpj>' + 'EST000001' + '</Cnpj>'
	ELSE
		CASE WHEN RTRIM(LTRIM(COALESCE(COALESCE(tbClienteEventual.CPFCliEven,tbCliForFisica.CPFFisica),''))) LIKE 'ISENT%' THEN
			'<Cpf>' + '00000000000' + '</Cpf>'
		ELSE
			'<Cpf>' + RTRIM(LTRIM(COALESCE(COALESCE(tbClienteEventual.CPFCliEven,tbCliForFisica.CPFFisica),''))) + '</Cpf>'
		END
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
	'<Numero>SN</Numero>'
END + 
CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND tbCliFor.ComplementoEndCliFor IS NOT NULL AND RTRIM(LTRIM(tbCliFor.ComplementoEndCliFor)) <> '' THEN
	'<Complemento>' + COALESCE(RTRIM(LTRIM(tbCliFor.ComplementoEndCliFor)),'') + '</Complemento>'
ELSE
	''
END + 
'<Bairro>' + COALESCE(RTRIM(LTRIM(COALESCE(tbClienteEventual.BairroCliEven,tbCliFor.BairroCliFor))),'') + '</Bairro>' +
'<CodigoMunicipio>' + COALESCE(CONVERT(VARCHAR(7),COALESCE(tbCEPEventual.NumeroMunicipio,tbCEP.NumeroMunicipio)),'') + '</CodigoMunicipio>' +
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
'</InfRps>' + 
'</Rps>',
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

LEFT JOIN tbCEP tbCEPEventual (NOLOCK)
ON
tbCEP.NumeroCEP = tbClienteEventual.CEPCliEven

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
'</ListaRps>' +
'</LoteRps>' + 
'</EnviarLoteRpsEnvio>',
999999

SELECT 
Linha,
--'<tc:?xml version="1.0" encoding="utf-8" ?><tc:ConsultarLoteRpsEnvio xmlns="http://www.issnetonline.com.br/webserviceabrasf/vsd/servico_consultar_lote_rps_envio.xsd" xmlns:ts="http://www.issnetonline.com.br/webserviceabrasf/vsd/tipos_simples.xsd" xmlns:tc="http://www.issnetonline.com.br/webserviceabrasf/vsd/tipos_complexos.xsd"><tc:Prestador><tc:CpfCnpj><tc:Cnpj>' + tbLocal.CGCLocal + '</tc:tipos:Cnpj></tc:tipos:CpfCnpj>' + '<tc:InscricaoMunicipal>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</tc:tipos:InscricaoMunicipal>' + '</tc:tipos:Prestador><tc:Protocolo>NUMEROPROTOCOLO</tc:tipos:Protocolo></tc:tipos:ConsultarLoteRpsEnvio>' AS ConsultaLote,
'<?xml version="1.0" encoding="UTF-8" ?><ConsultarLoteRpsEnvio xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><Prestador><Cnpj>' + tbLocal.CGCLocal + '</Cnpj><InscricaoMunicipal>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</InscricaoMunicipal></Prestador><Protocolo>NUMEROPROTOCOLO</Protocolo></ConsultarLoteRpsEnvio>' AS ConsultaLote,
'<?xml version="1.0" encoding="UTF-8" ?><ConsultarSituacaoLoteRpsEnvio xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><Prestador><Cnpj>' + tbLocal.CGCLocal + '</Cnpj><InscricaoMunicipal>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</InscricaoMunicipal></Prestador><Protocolo>NUMEROPROTOCOLO</Protocolo></ConsultarSituacaoLoteRpsEnvio>' AS ConsultaSituacaoLote,
--'<tc:?xml version="1.0" encoding="utf-8"?><tc:ConsultarSituacaoLoteRpsEnvio xmlns="http://www.issnetonline.com.br/webserviceabrasf/vsd/servico_consultar_situacao_lote_rps_envio.xsd" xmlns:tc="http://www.issnetonline.com.br/webserviceabrasf/vsd/tipos_complexos.xsd"><tc:Prestador><tc:tipos:CpfCnpj><tc:Cnpj>' + tbLocal.CGCLocal + '</tc:tipos:Cnpj></tc:tipos:CpfCnpj>' + '<tc:InscricaoMunicipal>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</tc:tipos:InscricaoMunicipal>' + '</tc:tipos:Prestador><tc:Protocolo>1212112</tc:tipos:Protocolo></tc:tipos:ConsultarSituacaoLoteRpsEnvio>' AS ConsultaSituacaoLote
'<?xml version="1.0" encoding="utf-8" ?><ConsultarNfseRpsEnvio xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><IdentificacaoRps><Numero>' + CONVERT(VARCHAR(6),@NumeroDocumento) + '</Numero><Serie>' + @SerieDocumento + '</Serie><Tipo>1</Tipo></IdentificacaoRps><Prestador><Cnpj>' + tbLocal.CGCLocal + '</Cnpj>' + '<InscricaoMunicipal>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</InscricaoMunicipal></Prestador></ConsultarNfseRpsEnvio>' AS ConsultaNFSE,
'<CancelarNfseEnvio xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">' +
'<Pedido>' +
'<InfPedidoCancelamento Id="' + CONVERT(VARCHAR(15),@NumeroNFSE) + '">' +
'<IdentificacaoNfse>' +
'<Numero>' + LTRIM(RTRIM(CONVERT(VARCHAR(15),@NumeroNFSE))) + '</Numero>' +
'<Cnpj>' + RTRIM(LTRIM(tbLocal.CGCLocal)) + '</Cnpj>' +
'<InscricaoMunicipal>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</InscricaoMunicipal>' +
'<CodigoMunicipio>' + CONVERT(VARCHAR(7),@CodigoMunicipio) + '</CodigoMunicipio>' +
'</IdentificacaoNfse>' +
'<CodigoCancelamento>' + CONVERT(VARCHAR(4),'1') + '</CodigoCancelamento>' +
'</InfPedidoCancelamento>' + 
'</Pedido>' +
'</CancelarNfseEnvio>' as XMLCancelamento
FROM #tmpXML
INNER JOIN tbLocal ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal
order by Ordem

SET NOCOUNT OFF
GO

GRANT EXECUTE ON dbo.whNFeContagem TO SQLUsers
GO