if exists(select 1 from sysobjects where id = object_id('whNFeItumbiara'))
	DROP PROCEDURE dbo.whNFeItumbiara
GO
CREATE PROCEDURE dbo.whNFeItumbiara
			@CodigoEmpresa dtInteiro04 ,
	  		@CodigoLocal dtInteiro04 , 
			@DataDocumento datetime,
			@NumeroDocumento numeric(12),
			@UsuarioWEB varchar(30) = '',
			@SenhaWEB varchar(30) = '',
			@ChavePrivada varchar(30) = ''

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
whNFePatos 1608,0,'2012-01-09',160
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
DECLARE @CancelarRPS char(1)
DECLARE @XMLCancelamento varchar(8000)
DECLARE @NumeroNFSE numeric(15)
DECLARE @CodigoVerificacao varchar(30)

SELECT @PercentualISS = MAX(tbItemDocumento.PercentualISSItemDocto)
FROM tbItemDocumento
INNER JOIN tbDocumentoRPS (NOLOCK)
ON	tbDocumentoRPS.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
AND	tbDocumentoRPS.CodigoLocal = tbItemDocumento.CodigoLocal
AND	tbDocumentoRPS.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento
AND	tbDocumentoRPS.NumeroDocumento = tbItemDocumento.NumeroDocumento
AND	tbDocumentoRPS.DataDocumento = tbItemDocumento.DataDocumento
AND	tbDocumentoRPS.CodigoCliFor = tbItemDocumento.CodigoCliFor
AND	tbDocumentoRPS.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
WHERE
tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbItemDocumento.CodigoLocal = @CodigoLocal AND
tbItemDocumento.EntradaSaidaDocumento = 'S' AND
tbItemDocumento.NumeroDocumento = @NumeroDocumento AND
tbItemDocumento.DataDocumento = @DataDocumento AND
tbItemDocumento.TipoLancamentoMovimentacao = 7 AND
tbDocumentoRPS.NumeroNFE = 0

SELECT @CodigoMunicipio = COALESCE(tbCEP.NumeroMunicipio,0)
FROM tbLocal
INNER JOIN tbCEP ON
           tbCEP.NumeroCEP = tbLocal.CEPLocal
WHERE
CodigoEmpresa = @CodigoEmpresa AND
CodigoLocal = @CodigoLocal

SELECT 
@SerieDocumento = RTRIM(LTRIM(SerieDocumento)),
@CancelarRPS = CASE WHEN tbDocumento.CondicaoNFCancelada = 'V' AND tbDocumentoRPS.NumeroNFE = 0 THEN 'V' ELSE 'F' END,
@NumeroNFSE = tbDocumentoRPS.NumeroNFE,
@CodigoVerificacao = tbDocumentoRPS.CodigoVerificacaoNFE
FROM tbDocumento
INNER JOIN tbDocumentoRPS (NOLOCK)
ON	tbDocumentoRPS.CodigoEmpresa = tbDocumento.CodigoEmpresa
AND	tbDocumentoRPS.CodigoLocal = tbDocumento.CodigoLocal
AND	tbDocumentoRPS.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
AND	tbDocumentoRPS.NumeroDocumento = tbDocumento.NumeroDocumento
AND	tbDocumentoRPS.DataDocumento = tbDocumento.DataDocumento
AND	tbDocumentoRPS.CodigoCliFor = tbDocumento.CodigoCliFor
AND	tbDocumentoRPS.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao
WHERE
tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
tbDocumento.CodigoLocal = @CodigoLocal AND
tbDocumento.EntradaSaidaDocumento = 'S' AND
tbDocumento.NumeroDocumento = @NumeroDocumento AND
tbDocumento.DataDocumento = @DataDocumento AND
tbDocumento.TipoLancamentoMovimentacao = 7

IF @CancelarRPS = 'V' 
BEGIN
	SELECT @XMLCancelamento = '<p:CancelarRpsEnvio xsi:schemaLocation="http://www.abrasf.org.br/nfse.xsd nfse-v2.xsd " xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.abrasf.org.br/nfse.xsd" xmlns:ds="http://www.w3.org/2000/09/xmldsig#">' +
	'<p:credenciais>' +
	'<p:usuario>' + @UsuarioWEB + '</p:usuario>' +
	'<p:senha>' + @SenhaWEB + '</p:senha>' +
	'<p:chavePrivada>' + @ChavePrivada + '</p:chavePrivada>' +
	'</p:credenciais>' + 
	'<p:Pedido>' + 
	'<p:InfPedidoCancelamento>' +	
	'<p:IdentificacaoRps>' +
	'<p:Numero>' + CONVERT(VARCHAR(12),@NumeroDocumento) + '</p:Numero>' +
	'<p:Tipo>'  + 'R1' + '</p:Tipo>' +
	'</p:IdentificacaoRps>' +
	'<p:CodigoCancelamento>EE</p:CodigoCancelamento>' +
	'<p:DescricaoCancelamento>CANCELADA POR ERRO DE EMISSAO</p:DescricaoCancelamento>' +
	'<p:CpfCnpj>' +
	'<p:Cnpj>' + tbLocal.CGCLocal + '</p:Cnpj>' +
	'</p:CpfCnpj>' +
	'<p:InscricaoMunicipal>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</p:InscricaoMunicipal>' +
	'</p:InfPedidoCancelamento>' +
	'</p:Pedido>' +
	'</p:CancelarRpsEnvio>'
	FROM tbLocal
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal
END
ELSE
BEGIN
	SELECT @XMLCancelamento = '<p:CancelarNfseEnvio xsi:schemaLocation="http://www.abrasf.org.br/nfse.xsd nfse-v2.xsd " xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.abrasf.org.br/nfse.xsd" xmlns:ds="http://www.w3.org/2000/09/xmldsig#">' +
	'<p:credenciais>' +
	'<p:usuario>' + @UsuarioWEB + '</p:usuario>' +
	'<p:senha>' + @SenhaWEB + '</p:senha>' +
	'<p:chavePrivada>' + @ChavePrivada + '</p:chavePrivada>' +
	'</p:credenciais>' + 
	'<p:Pedido>' + 
	'<p:InfPedidoCancelamento>' +	
	'<p:IdentificacaoNfse>' +
	'<p:Numero>' + CONVERT(VARCHAR(12),@NumeroNFSE) + '</p:Numero>' +
	'<p:CpfCnpj>' +
	'<p:Cnpj>' + tbLocal.CGCLocal + '</p:Cnpj>' +
	'</p:CpfCnpj>' +
	'<p:InscricaoMunicipal>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</p:InscricaoMunicipal>' +
	'<p:CodigoVerificacao>' + @CodigoVerificacao + '</p:CodigoVerificacao>' +
	'</p:IdentificacaoNfse>' +
	'<p:CodigoCancelamento>EE</p:CodigoCancelamento>' +
	'<p:DescricaoCancelamento>CANCELADA POR ERRO DE EMISSAO</p:DescricaoCancelamento>' +
	'</p:InfPedidoCancelamento>' +
	'</p:Pedido>' +
	'</p:CancelarNfseEnvio>'
	FROM tbLocal
	WHERE
	CodigoEmpresa = @CodigoEmpresa AND
	CodigoLocal = @CodigoLocal
END

SELECT 
@CodigoServico = COALESCE(ItemListaServico,'99.99'),
@CodigoCnae = COALESCE(CodigoCnae,'9999 '),
@CodigoTributacaoMunicipio = COALESCE(CodigoTributacaoMunicipio,'9') 
FROM tbItemDocumento (NOLOCK)
INNER JOIN tbDocumentoRPS (NOLOCK)
ON	tbDocumentoRPS.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
AND	tbDocumentoRPS.CodigoLocal = tbItemDocumento.CodigoLocal
AND	tbDocumentoRPS.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento
AND	tbDocumentoRPS.NumeroDocumento = tbItemDocumento.NumeroDocumento
AND	tbDocumentoRPS.DataDocumento = tbItemDocumento.DataDocumento
AND	tbDocumentoRPS.CodigoCliFor = tbItemDocumento.CodigoCliFor
AND	tbDocumentoRPS.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
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
AND tbDocumentoRPS.NumeroNFE = 0 

SET NOCOUNT ON

CREATE TABLE #tmpXML (Linha VARCHAR(8000), Ordem numeric(6)) 

INSERT #tmpXML
SELECT
--'<?xml version="1.0"?>' +
'<p:GerarNfseEnvio xsi:schemaLocation="http://www.abrasf.org.br/nfse.xsd nfse-v2.xsd " xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.abrasf.org.br/nfse.xsd" xmlns:ds="http://www.w3.org/2000/09/xmldsig#">' +
'<p:credenciais>' +
'<p:usuario>' + @UsuarioWEB + '</p:usuario>' +
'<p:senha>' + @SenhaWEB + '</p:senha>' +
'<p:chavePrivada>' + @ChavePrivada + '</p:chavePrivada>' +
'</p:credenciais>' +
'<p:Rps>' +
'<p:InfDeclaracaoPrestacaoServico>' +
'<p:Rps>' +
'<p:IdentificacaoRps>',
0
FROM tbLocal (NOLOCK)
WHERE
tbLocal.CodigoEmpresa = @CodigoEmpresa AND
tbLocal.CodigoLocal = @CodigoLocal 


--- outra temporaria

INSERT #tmpXML
SELECT
'<p:Numero>' + CONVERT(VARCHAR(12),tbDocumento.NumeroDocumento) + '</p:Numero>' +
--'<p:Serie>' + RTRIM(LTRIM(@SerieDocumento)) + '</p:Serie>' +
'<p:Tipo>'  + 'R1' + '</p:Tipo>' +
'</p:IdentificacaoRps>' +
'<p:DataEmissao>' +  SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,tbDocumento.DataHoraNSU)),2,4) + '-' + SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,tbDocumento.DataHoraNSU)),2,2) + '-' + 	SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,tbDocumento.DataHoraNSU)),2,2) + 'T' + RIGHT(100 + DATEPART(HOUR,tbDocumento.DataHoraNSU),2) + ':' + RIGHT(100 + DATEPART(MINUTE,tbDocumento.DataHoraNSU),2) + ':' + RIGHT(100 + DATEPART(SECOND,tbDocumento.DataHoraNSU),2) + '</p:DataEmissao>' +
'<p:Status>CO</p:Status>' +
'</p:Rps>' +
--'<p:Competencia>' +  SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,tbDocumento.DataHoraNSU)),2,4) + '-' + SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,tbDocumento.DataHoraNSU)),2,2) + '-' + 	SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,tbDocumento.DataHoraNSU)),2,2) + '</Competencia>' +
'<p:Servico>' +
'<p:Valores>' +
'<p:ValorServicos>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumento.ValorBaseISSDocumento)) + '</p:ValorServicos>' +
CASE WHEN tbDocumentoFT.vPISRetidoDocFT <> 0 THEN
	'<p:ValorPis>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.vPISRetidoDocFT))  + '</p:ValorPis>'
ELSE
	'<p:ValorPis>' + '0.00' + '</p:ValorPis>'
END +
CASE WHEN tbDocumentoFT.vCOFINSRetidoDocFT <> 0 THEN
	'<p:ValorCofins>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.vCOFINSRetidoDocFT)) + '</p:ValorCofins>'
ELSE
	'<p:ValorCofins>' + '0.00' + '</p:ValorCofins>'
END +
'<p:ValorInss>0.00</p:ValorInss>' +
'<p:ValorIr>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.ValorIRRFDocFT))  + '</p:ValorIr>' +
CASE WHEN tbDocumentoFT.ValorCSLLDocFT <> 0 THEN
	'<p:ValorCsll>' + + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.ValorCSLLDocFT)) + '</p:ValorCsll>' 
ELSE
	'<p:ValorCsll>0.00</p:ValorCsll>' 
END +
'<p:OutrasRetencoes>0.00</p:OutrasRetencoes>' +
--'<p:ValorIss>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumento.ValorISSDocumento)) + '</ValorIss>' +
'<p:Aliquota>' + COALESCE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2), (SELECT MAX(tbItemDoc.PercentualISSItemDocto) 
							FROM tbItemDocumento tbItemDoc 
							WHERE tbItemDoc.CodigoEmpresa = @CodigoEmpresa
							AND	tbItemDoc.CodigoLocal = @CodigoLocal
							AND	tbItemDoc.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
							AND	tbItemDoc.NumeroDocumento = tbDocumento.NumeroDocumento
							AND	tbItemDoc.DataDocumento = tbDocumento.DataDocumento
							AND	tbItemDoc.CodigoCliFor = tbDocumento.CodigoCliFor
							AND	tbItemDoc.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao))),'0') + '</p:Aliquota>' +
'<p:DescontoIncondicionado>0.00</p:DescontoIncondicionado>' +
'<p:DescontoCondicionado>0.00</p:DescontoCondicionado>' +
'</p:Valores>' +
--'<p:IssRetido>' + CASE WHEN tbDocumentoFT.cSitTribISS = 'R' THEN '1' ELSE '2' END + '</p:IssRetido>' +
'<p:ItemListaServico>' + @CodigoServico + '</p:ItemListaServico>' +
'<p:CodigoCnae>' + @CodigoCnae + '</p:CodigoCnae>' + 
'<p:CodigoTributacaoMunicipio>' + @CodigoTributacaoMunicipio + '</p:CodigoTributacaoMunicipio>' +
'<p:Discriminacao>' + COALESCE(LTRIM(RTRIM(dbo.fnItensNFItumbiara(@CodigoEmpresa, @CodigoLocal, tbDocumento.NumeroDocumento, tbDocumento.DataDocumento, tbDocumento.CodigoCliFor))),' ') + '</p:Discriminacao>' +
'<p:InformacoesImportantes>' +
	 CONVERT(VARCHAR(400), 'P.Pagto : ' + tbDocumentoFT.CodigoPlanoPagamento + '-' + tbPlanoPagamento.DescricaoPlanoPagamento + ' ' +
	 'Pedido: ' + CONVERT(VARCHAR(6), tbDocumento.NumeroPedidoDocumento) + '-' + CONVERT(VARCHAR(2),tbDocumento.NumeroSequenciaPedidoDocumento) + ' Vendedor: ' + LTRIM(RTRIM(dbo.fnRetNomeRepresNFe(@CodigoEmpresa, @CodigoLocal, tbDocumentoFT.CentroCusto, tbDocumento.NumeroPedidoDocumento, tbDocumento.NumeroSequenciaPedidoDocumento))) + ' ' +
	 'Os : ' + CONVERT(VARCHAR(6),COALESCE(tbPedidoOS.CodigoOrdemServicoPedidoOS,0)) + ' ' + 
	 'Placa : ' + CONVERT(VARCHAR(10),COALESCE(CONVERT(VARCHAR(10),tbVeiculoOS.PlacaVeiculoOS),'')) + ' KM : ' + CONVERT(VARCHAR(10),COALESCE(tbOROS.KmVeiculoOS,0)) + ' ' + 
	 'Chassi : ' + RTRIM(LTRIM(COALESCE(tbVeiculoOS.ChassiVeiculoOS,''))) + ' ' +
	 'Ano : ' + COALESCE(CONVERT(VARCHAR(4),tbVeiculoOS.AnoModeloVeiculoOS),'') + ' Modelo : ' + COALESCE(CONVERT(VARCHAR(30),tbVeiculoOS.ModeloVeiculoOS),'') + ' ' +
	 'Origem da Venda : ' + CONVERT(VARCHAR(8),tbDocumentoFT.CentroCusto) + ' - ' + tbCentroCusto.DescricaoCentroCusto) + ' ' + 
	 CASE WHEN tbDocumento.NumeroDuplicatasDocumento > 0 THEN
			'Duplicatas : ' + dbo.fnDuplicatasDANFE(tbDocumento.CodigoEmpresa,tbDocumento.CodigoLocal,tbDocumento.EntradaSaidaDocumento,tbDocumento.NumeroDocumento,tbDocumento.DataDocumento,tbDocumento.CodigoCliFor,tbDocumento.TipoLancamentoMovimentacao)
	 ELSE
			''
	 END + ' ' + 
'</p:InformacoesImportantes>' +
'<p:CodigoMunicipio>' + @CodigoMunicipio + '</p:CodigoMunicipio>' +
'<p:ExigibilidadeISS>' + '01' + '</p:ExigibilidadeISS>' +
--'<MunicipioIncidencia>' + @CodigoMunicipio + '</MunicipioIncidencia>' +
'</p:Servico>' +
'<p:Prestador>' +
'<p:CpfCnpj>' +
'<p:Cnpj>' + tbLocal.CGCLocal + '</p:Cnpj>' +
'</p:CpfCnpj>' +
'<p:InscricaoMunicipal>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</p:InscricaoMunicipal>' +
'</p:Prestador>' +
'<p:Tomador>' +
'<p:IdentificacaoTomador>' +
'<p:CpfCnpj>' + 
CASE WHEN tbCliFor.TipoCliFor = 'J' OR tbClienteEventual.CGCCliEven IS NOT NULL THEN
	CASE WHEN RTRIM(LTRIM(COALESCE(tbClienteEventual.CGCCliEven,tbCliForJuridica.CGCJuridica))) LIKE 'ISENT%' THEN
		'<p:Cnpj>' + '00000000000000' + '</p:Cnpj>'	
	ELSE
		'<p:Cnpj>' + COALESCE(COALESCE(tbClienteEventual.CGCCliEven,tbCliForJuridica.CGCJuridica),'') + '</p:Cnpj>'	
	END
ELSE
	CASE WHEN RTRIM(LTRIM(COALESCE(COALESCE(tbClienteEventual.CPFCliEven,tbCliForFisica.CPFFisica),''))) LIKE 'ISENT%' THEN
		'<p:Cpf>' + '00000000000' + '</p:Cpf>'
	ELSE
		'<p:Cpf>' + RTRIM(LTRIM(COALESCE(COALESCE(tbClienteEventual.CPFCliEven,tbCliForFisica.CPFFisica),''))) + '</p:Cpf>'
	END
END +
'</p:CpfCnpj>' +
CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND tbCliFor.TipoCliFor = 'J' AND RTRIM(LTRIM(tbCliForJuridica.InscricaoMunicipalJuridica)) <> 'ISENTO' AND tbCliForJuridica.InscricaoMunicipalJuridica IS NOT NULL AND RTRIM(LTRIM(tbCliForJuridica.InscricaoMunicipalJuridica)) <> '' AND RTRIM(LTRIM(tbCliFor.MunicipioCliFor)) = RTRIM(LTRIM(tbLocal.MunicipioLocal)) THEN
	'<p:InscricaoMunicipal>' + RTRIM(LTRIM(COALESCE(REPLACE(REPLACE(REPLACE(tbCliForJuridica.InscricaoMunicipalJuridica ,'.',''),'-',''),'/',''),''))) + '</p:InscricaoMunicipal>' 
ELSE
	''
END +
'</p:IdentificacaoTomador>' +
'<p:RazaoSocial>' + RTRIM(LTRIM(COALESCE(tbClienteEventual.NomeCliEven,tbCliFor.NomeCliFor))) + '</p:RazaoSocial>' +
'<p:Endereco>' +
'<p:TipoLogradouro>' + RTRIM(LTRIM(COALESCE(tbCEP.TipoLogradouro,'RUA'))) + '</p:TipoLogradouro>' + 
'<p:Logradouro>' + RTRIM(LTRIM(COALESCE(tbClienteEventual.EnderecoCliEven,tbCliFor.RuaCliFor))) + '</p:Logradouro>' +
CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND NumeroEndCliFor IS NOT NULL AND NumeroEndCliFor <> 0 THEN
	'<p:Numero>' + COALESCE(CONVERT(VARCHAR(5),NumeroEndCliFor),'') + '</p:Numero>'
ELSE
	'<p:Numero>SN</p:Numero>'
END + 
CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND tbCliFor.ComplementoEndCliFor IS NOT NULL AND RTRIM(LTRIM(tbCliFor.ComplementoEndCliFor)) <> '' THEN
	'<p:Complemento>' + COALESCE(RTRIM(LTRIM(tbCliFor.ComplementoEndCliFor)),'') + '</p:Complemento>'
ELSE
	''
END + 
'<p:Bairro>' + COALESCE(RTRIM(LTRIM(COALESCE(tbClienteEventual.BairroCliEven,tbCliFor.BairroCliFor))),'') + '</p:Bairro>' +
'<p:CodigoMunicipio>' + RIGHT('0000000' + RTRIM(LTRIM(COALESCE(CONVERT(VARCHAR(7),tbCEP.NumeroMunicipio),''))),7) + '</p:CodigoMunicipio>' +
'<p:Uf>' + COALESCE(tbClienteEventual.UnidadeFederacao,tbCliFor.UFCliFor) + '</p:Uf>' +
'<p:Cep>' + COALESCE(tbClienteEventual.CEPCliEven,tbCliFor.CEPCliFor) + '</p:Cep>' +
'</p:Endereco>' +
CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND (( RTRIM(LTRIM(tbCliFor.EmailCliFor)) <> '' AND tbCliFor.EmailCliFor IS NOT NULL ) OR ( RTRIM(LTRIM(tbCliFor.TelefoneCliFor)) <> '' AND tbCliFor.TelefoneCliFor IS NOT NULL )) THEN
	'<p:Contato>'
ELSE
	''
END +
CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND ( RTRIM(LTRIM(tbCliFor.TelefoneCliFor)) <> '' AND tbCliFor.TelefoneCliFor IS NOT NULL ) THEN
	'<p:Telefone>' + RTRIM(LTRIM(TelefoneCliFor)) + '</p:Telefone>' +
	'<p:Ddd>' + RIGHT('0' + RTRIM(LTRIM(COALESCE(DDDTelefoneCliFor,''))),3) + '</p:Ddd>' +
	'<p:TipoTelefone>' + 'CE' + '</p:TipoTelefone>' 
ELSE
	''
END + 
CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND ( RTRIM(LTRIM(tbCliFor.EmailCliFor)) <> '' AND tbCliFor.EmailCliFor IS NOT NULL ) THEN
	'<p:Email>' + RTRIM(LTRIM(tbCliFor.EmailCliFor)) + '</p:Email>'
ELSE
	''
END +
CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL AND (( RTRIM(LTRIM(tbCliFor.EmailCliFor)) <> '' AND tbCliFor.EmailCliFor IS NOT NULL ) OR ( RTRIM(LTRIM(tbCliFor.TelefoneCliFor)) <> '' AND tbCliFor.TelefoneCliFor IS NOT NULL )) THEN
	'</p:Contato>'
ELSE
	''
END +
'</p:Tomador>' +
--'<OptanteSimplesNacional>2</OptanteSimplesNacional>' +
--'<IncentivoFiscal>2</IncentivoFiscal>' +
'</p:InfDeclaracaoPrestacaoServico>',
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

INNER JOIN tbCentroCusto (NOLOCK) ON
           tbCentroCusto.CodigoEmpresa = @CodigoEmpresa AND
           tbCentroCusto.CentroCusto = tbDocumentoFT.CentroCusto 

INNER JOIN tbPlanoPagamento (NOLOCK) ON  
    tbPlanoPagamento.CodigoEmpresa = @CodigoEmpresa AND
    tbPlanoPagamento.CodigoPlanoPagamento = tbDocumentoFT.CodigoPlanoPagamento


LEFT JOIN tbPedidoOS (NOLOCK) ON
          tbPedidoOS.CodigoEmpresa = @CodigoEmpresa AND
          tbPedidoOS.CodigoLocal = @CodigoLocal AND
          tbPedidoOS.CentroCusto = tbDocumentoFT.CentroCusto AND
          tbPedidoOS.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND
          tbPedidoOS.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento

LEFT JOIN tbOROS (NOLOCK)
ON	tbOROS.CodigoEmpresa	= tbPedidoOS.CodigoEmpresa
AND	tbOROS.CodigoLocal		= tbPedidoOS.CodigoLocal
AND	tbOROS.FlagOROS		= 'S'
AND	tbOROS.NumeroOROS		= tbPedidoOS.CodigoOrdemServicoPedidoOS

LEFT JOIN tbVeiculoOS (NOLOCK)
ON	tbVeiculoOS.CodigoEmpresa	= tbOROS.CodigoEmpresa
AND	tbVeiculoOS.ChassiVeiculoOS	= tbOROS.ChassiVeiculoOS
    
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
AND tbDocumentoRPS.NumeroNFE = 0

INSERT #tmpXML
SELECT
'</p:Rps>' +
'</p:GerarNfseEnvio>',
999999

SELECT 
Linha,
@XMLCancelamento as XMLCancelamento,
@CancelarRPS as CancelarRPS
FROM #tmpXML
inner join tbLocal (nolock) on
           tbLocal.CodigoEmpresa = @CodigoEmpresa and
           tbLocal.CodigoLocal = @CodigoLocal
order by Ordem

SET NOCOUNT OFF

GO

GRANT EXECUTE ON dbo.whNFeItumbiara TO SQLUsers
GO