Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.whNFSESeteLagoas
			@CodigoEmpresa dtInteiro04 ,
	  		@CodigoLocal dtInteiro04 , 
			@DataInicial datetime,
			@DataFinal datetime,
            @DocumentoInicial numeric(12),
            @DocumentoFinal numeric(12)

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: Livros Fiscais
 AUTOR........: Condez
 DATA.........: 08/10/2009
 UTILIZADO EM : 
 OBJETIVO.....: Gerar Arquivo XML RPS(Recibo Provisório de Serviços) Municipal - BH

whNFSESeteLagoas 1608,0,'2015-05-29','2015-05-29',0,999999999999

SELECT * from tbDocumento where DataDocumento = '2015-05-29' and ValorBaseISSDocumento <> 0
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

AS 

SET NOCOUNT ON

DECLARE @QtdeRPS numeric(4)
DECLARE @CodigoMunicipio varchar(10)
DECLARE @SequencialArquivo numeric(12)

BEGIN TRANSACTION

SELECT @SequencialArquivo = SequencialArquivo
FROM tbLocalLF
WHERE tbLocalLF.CodigoEmpresa = @CodigoEmpresa
AND	tbLocalLF.CodigoLocal = @CodigoLocal

SELECT @SequencialArquivo = @SequencialArquivo + 1
IF @SequencialArquivo = 999999999999 SELECT @SequencialArquivo = 1

UPDATE tbLocalLF 
SET SequencialArquivo = @SequencialArquivo
WHERE tbLocalLF.CodigoEmpresa = @CodigoEmpresa
AND	tbLocalLF.CodigoLocal = @CodigoLocal

IF @@error <> 0 
BEGIN
	ROLLBACK TRANSACTION
	RETURN
END

COMMIT TRANSACTION

SELECT @CodigoMunicipio = COALESCE(tbCEP.NumeroMunicipio,0)
FROM tbLocal
INNER JOIN tbCEP ON
           tbCEP.NumeroCEP = tbLocal.CEPLocal
WHERE
CodigoEmpresa = @CodigoEmpresa AND
CodigoLocal = @CodigoLocal

SELECT 
@QtdeRPS = count(*)
FROM tbDocumento (NOLOCK)
WHERE 
tbDocumento.CodigoEmpresa = @CodigoEmpresa
AND	tbDocumento.CodigoLocal = @CodigoLocal
AND	tbDocumento.EntradaSaidaDocumento = 'S'
AND	tbDocumento.DataDocumento BETWEEN @DataInicial AND @DataFinal
AND tbDocumento.NumeroDocumento BETWEEN @DocumentoInicial AND @DocumentoFinal
AND	tbDocumento.ValorBaseISSDocumento > 0
AND tbDocumento.TipoLancamentoMovimentacao = 7
AND tbDocumento.EntradaSaidaDocumento = 'S'
AND tbDocumento.ValorContabilDocumento <> 0 
AND tbDocumento.CondicaoNFCancelada <> 'V' 

SET NOCOUNT ON

CREATE TABLE #tmpXML (Linha VARCHAR(8000), Ordem numeric(12)) 

INSERT #tmpXML
SELECT
'<?xml version="1.0"?>' +
'<EnviarLoteRpsEnvio>' +
	'<LoteRps Id="L_' + LTRIM(RTRIM(CONVERT(VARCHAR(12),@SequencialArquivo))) + '" versao="2.02">' +
		'<NumeroLote>' + LTRIM(RTRIM(CONVERT(VARCHAR(12),@SequencialArquivo))) + '</NumeroLote>' +
		'<CpfCnpj>' +
			'<Cnpj>' + tbLocal.CGCLocal + '</Cnpj>' +
		'</CpfCnpj>' +
		'<InscricaoMunicipal>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</InscricaoMunicipal>' +
		'<QuantidadeRps>' + CONVERT(VARCHAR(8),@QtdeRPS) + '</QuantidadeRps>' +
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
	'<InfDeclaracaoPrestacaoServico>' +
		'<Rps Id="R_' + right('000000000'+LTRIM(RTRIM(CONVERT(VARCHAR(9),tbDocumento.NumeroDocumento))),9) + '">' +
			'<InfRps>' +
				'<IdentificacaoRps>' +
					'<Numero>' + LTRIM(RTRIM(CONVERT(VARCHAR(9),tbDocumento.NumeroDocumento))) + '</Numero>' +
					'<Serie>' + RTRIM(LTRIM(tbDocumento.SerieDocumento)) + '</Serie>' +
					'<Tipo>'  + '1' + '</Tipo>' +
				'</IdentificacaoRps>' +
				'<DataEmissao>' +  SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,COALESCE(tbDocumento.DataHoraNSU,tbDocumento.DataDocumento))),2,4) + '-' + SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,COALESCE(tbDocumento.DataHoraNSU,tbDocumento.DataDocumento))),2
,2) + '-' + 	SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,COALESCE(tbDocumento.DataHoraNSU,tbDocumento.DataDocumento))),2,2) + '</DataEmissao>' +
				'<Status>1</Status>' +
				--'<RpsSubstituido>' + 
				--	'<Numero></Numero>' +
				--	'<Serie></Serie>' + 
				--	'<Tipo></Tipo>' +
				--	--'<Motivo></Motivo>' + 
				--'</RpsSubstituido>' +
			'</InfRps>' +
		'</Rps>' +
		'<Competencia>' +  SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,COALESCE(tbDocumento.DataHoraNSU,tbDocumento.DataDocumento))),2,4) + '-' + SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,COALESCE(tbDocumento.DataHoraNSU,tbDocumento.DataDocumento))),2,2
) + '-' + 	SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,COALESCE(tbDocumento.DataHoraNSU,tbDocumento.DataDocumento))),2,2) + '</Competencia>' +
		'<Servico>' +
			'<Valores>' +
				'<ValorServicos>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumento.ValorBaseISSDocumento)) + '</ValorServicos>' +
				'<ValorDeducoes>0.00</ValorDeducoes>' +
				CASE WHEN tbDocumentoFT.vPISRetidoDocFT <> 0 THEN
					'<ValorPis>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.vPISRetidoDocFT))  + '</ValorPis>'
				ELSE
					'<ValorPis>' + '0.00' + '</ValorPis>'
				END +
				CASE WHEN tbDocumentoFT.vCOFINSRetidoDocFT <> 0 THEN
					'<ValorCofins>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.vCOFINSRetidoDocFT)) + '</ValorCofins>'
				ELSE
					'<ValorCofins>' + '0.00' + '</ValorCofins>'
				END +
				'<ValorInss>0.00</ValorInss>' +
				'<ValorIr>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.ValorIRRFDocFT)) + '</ValorIr>' +
				CASE WHEN tbDocumentoFT.ValorCSLLDocFT <> 0 THEN
					'<ValorCsll>' + + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.ValorCSLLDocFT)) + '</ValorCsll>' 
				ELSE
					'<ValorCsll>0.00</ValorCsll>' 
				END +
				'<OutrasRetencoes>0.00</OutrasRetencoes>' +
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
				'<DescontoCondicionado>0.00</DescontoCondicionado>' +
			'</Valores>' +
			'<IssRetido>' + CASE WHEN tbDocumentoFT.cSitTribISS = 'R' THEN '1' ELSE '2' END + '</IssRetido>' +
			'<ResponsavelRetencao>' + '</ResponsavelRetencao>' + 
			'<ItemListaServico>' + COALESCE(tbTipoServicoNFSE.ItemListaServico,'') + '</ItemListaServico>' +
			'<CodigoCnae>' + COALESCE(tbTipoServicoNFSE.CodigoCnae,'') + '</CodigoCnae>' + 
			'<CodigoTributacaoMunicipio>' + COALESCE(tbTipoServicoNFSE.CodigoTributacaoMunicipio,'') + '</CodigoTributacaoMunicipio>' +
			'<Discriminacao>' + COALESCE(LTRIM(RTRIM(dbo.fnItensNFSeteLagoas(@CodigoEmpresa, @CodigoLocal, tbDocumento.NumeroDocumento, tbDocumento.DataDocumento, tbDocumento.CodigoCliFor))),' ') + '</Discriminacao>' +
			'<CodigoMunicipio>' + @CodigoMunicipio + '</CodigoMunicipio>' +
			--'<CodigoPais>' + '</CodigoPais>' + 
			'<ExigibilidadeISS>' + '1' + '</ExigibilidadeISS>' +
			'<MunicipioIncidencia>' + @CodigoMunicipio + '</MunicipioIncidencia>' +
			--'<NumeroProcesso>' + '</NumeroProcesso>' + 
		'</Servico>' +
		'<Prestador>' +
			'<CpfCnpj>' +
				'<Cnpj>' + tbLocal.CGCLocal + '</Cnpj>' +
			'</CpfCnpj>' +
			'<InscricaoMunicipal>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</InscricaoMunicipal>' +
		'</Prestador>' +
		'<TomadorServico>' +
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
				CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND tbCliFor.TipoCliFor = 'J' AND RTRIM(LTRIM(tbCliForJuridica.InscricaoMunicipalJuridica)) <> 'ISENTO' AND tbCliForJuridica.InscricaoMunicipalJuridica IS NOT NULL AND RTRIM(LTRIM(tbCliForJurid
ica.InscricaoMunicipalJuridica)) <> '' AND RTRIM(LTRIM(tbCliFor.MunicipioCliFor)) = RTRIM(LTRIM(tbLocal.MunicipioLocal)) THEN
					'<InscricaoMunicipal>' + RTRIM(LTRIM(COALESCE(REPLACE(REPLACE(REPLACE(tbCliForJuridica.InscricaoMunicipalJuridica ,'.',''),'-',''),'/',''),''))) + '</InscricaoMunicipal>' 
				ELSE
					'<InscricaoMunicipal>' + '' + '</InscricaoMunicipal>' 
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
					'<Complemento>' + '' + '</Complemento>'
				END + 
				'<Bairro>' + COALESCE(RTRIM(LTRIM(COALESCE(tbClienteEventual.BairroCliEven,tbCliFor.BairroCliFor))),'') + '</Bairro>' +
				'<CodigoMunicipio>' + RIGHT('0000000' + COALESCE(CONVERT(VARCHAR(7),tbCEP.NumeroMunicipio),''),7) + '</CodigoMunicipio>' +
				'<Uf>' + COALESCE(tbClienteEventual.UnidadeFederacao,tbCliFor.UFCliFor) + '</Uf>' +
				CASE WHEN tbCliFor.UFCliFor <> 'EX' THEN
					'<CodigoPais>1058</CodigoPais>'
				ELSE
					'<CodigoPais>' + COALESCE(CONVERT(VARCHAR(10),tbCliFor.IdPais),'') + '</CodigoPais>'
				END + 
				'<Cep>' + COALESCE(tbClienteEventual.CEPCliEven,tbCliFor.CEPCliFor) + '</Cep>' +
			'</Endereco>' +
			'<Contato>' +
				CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND ( RTRIM(LTRIM(tbCliFor.TelefoneCliFor)) <> '' AND tbCliFor.TelefoneCliFor IS NOT NULL ) THEN
					'<Telefone>' + RTRIM(LTRIM(COALESCE(DDDTelefoneCliFor,''))) + RTRIM(LTRIM(TelefoneCliFor)) + '</Telefone>'
				ELSE
					'<Telefone></Telefone>'
				END + 
				CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND ( RTRIM(LTRIM(tbCliFor.EmailCliFor)) <> '' AND tbCliFor.EmailCliFor IS NOT NULL ) THEN
					'<Email>' + RTRIM(LTRIM(tbCliFor.EmailCliFor)) + '</Email>'
				ELSE
					'<Email></Email>'
				END +
			'</Contato>' +
		'</TomadorServico>' +
		--'<Intermediario>' + 
		--	'<IdentificacaoIntermediario>' +
		--	'<CpfCnpj>' +
		--	'<Cpf></Cpf>' +
		--	'<InscricaoMunicipal></InscricaoMunicipal>' + 
		--	'</CpfCnpj>' +
		--	'</IdentificacaoIntermediario>' +
		--	'<RazaoSocial></RazaoSocial>' +  
		--'</Intermediario>' +
		--'<ConstrucaoCivil>' + 
		--	'<CodigoObra></CodigoObra>' +
		--	'<Art></Art>' + 
		--'</ConstrucaoCivil>' +
		--'<RegimeEspecialTributacao></RegimeEspecialTributacao>' +
		'<OptanteSimplesNacional>2</OptanteSimplesNacional>' +
		'<IncentivoFiscal>2</IncentivoFiscal>' +
	'</InfDeclaracaoPrestacaoServico>' + 
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

LEFT JOIN tbCEP (NOLOCK)
ON  tbCEP.NumeroCEP = tbCliFor.CEPCliFor

LEFT JOIN tbTipoServicoNFSE (NOLOCK) ON
          tbTipoServicoNFSE.CodigoEmpresa = @CodigoEmpresa AND
          tbTipoServicoNFSE.CodigoLocal = @CodigoLocal AND
          tbTipoServicoNFSE.CodigoServico = (SELECT MAX(tbItemDoc.CodigoServicoISSItemDocto) 
							FROM tbItemDocumento tbItemDoc 
							WHERE tbItemDoc.CodigoEmpresa = @CodigoEmpresa
							AND	tbItemDoc.CodigoLocal = @CodigoLocal
							AND	tbItemDoc.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
							AND	tbItemDoc.NumeroDocumento = tbDocumento.NumeroDocumento
							AND	tbItemDoc.DataDocumento = tbDocumento.DataDocumento
							AND	tbItemDoc.CodigoCliFor = tbDocumento.CodigoCliFor
							AND	tbItemDoc.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao)

WHERE tbDocumento.CodigoEmpresa = @CodigoEmpresa
AND	tbDocumento.CodigoLocal = @CodigoLocal
AND	tbDocumento.EntradaSaidaDocumento = 'S'
AND	tbDocumento.DataDocumento between @DataInicial AND @DataFinal
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
'</EnviarLoteRpsEnvio>',
999999

UPDATE #tmpXML
SET Linha = REPLACE(Linha,'Ç','C')

UPDATE #tmpXML
SET Linha = REPLACE(Linha,'&','')

UPDATE #tmpXML
SET Linha = REPLACE(Linha,'º','')

UPDATE #tmpXML
SET Linha = REPLACE(Linha,'Ã','A')

UPDATE #tmpXML
SET Linha = REPLACE(Linha,'Õ','O')

UPDATE #tmpXML
SET Linha = REPLACE(Linha,'Á','A')

UPDATE #tmpXML
SET Linha = REPLACE(Linha,'Ó','O')

UPDATE #tmpXML
SET Linha = REPLACE(Linha,'É','E')

UPDATE #tmpXML
SET Linha = REPLACE(Linha,'Í','I')

UPDATE #tmpXML
SET Linha = REPLACE(Linha,'Â','A')

SELECT 
Linha,
CGCLocal,
NumeroMunicipio
FROM #tmpXML
INNER JOIN tbLocal (NOLOCK) ON
           tbLocal.CodigoEmpresa = @CodigoEmpresa AND
           tbLocal.CodigoLocal = @CodigoLocal
INNER JOIN tbCEP (NOLOCK) ON
           tbCEP.NumeroCEP = tbLocal.CEPLocal
order by Ordem

SET NOCOUNT OFF

