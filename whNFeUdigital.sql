CREATE PROCEDURE dbo.whNFeUdigital  
   @CodigoEmpresa dtInteiro04 ,  
     @CodigoLocal dtInteiro04 ,   
   @DataDocumento datetime,  
   @CodigoCliFor numeric(14),  
            @NumeroDocumento numeric(6)  
  
/*INICIO_CABEC_PROC  
-----------------------------------------------------------------------------------------------  
 EMPRESA......: T-Systems do Brasil  
 PROJETO......: Livros Fiscais  
 AUTOR........: Condez  
 DATA.........: 08/10/2009  
 UTILIZADO EM :   
 OBJETIVO.....: Gerar Arquivo XML RPS(Recibo Provisório de Serviços) Municipal - BH  
  
whNFeUdigital 1608,0,'2014-02-10',7459,61  
  
select * from   
update tbDocumentoTextos   
set ObservacaoCapaDocFT = 'MAC MAC MAC'  
where NumeroDocumento = 79 and DataDocumento = '2010-10-01'  
SELECT * from tbDocumentoRPS where CodigoEmpresa = 1608 and CodigoLocal = 0  
whNFeUdigital 1608,0,'2010-03-31',18850631804,21  
whNFeUdigital 1608,0,'2010-03-01',27699306805,5111  
2010-03-01  
  
03030660011NF   00000000506820100114T NN000000000113375000000000000000000000140118850631804   
00000006323NF   00000000511120100301T NN000000000032500000000000000000041204000000027699306805  
  
03030660011NF   00000000506820100114T NN000000000113375000000000000000000000140100035490179449       
  
00000317330NF   00000003866320090905T NN000000000001686000000000000000082997990008764130000102  
  
00000581800NF   NUMERORRPPSS20100329T NN000000000013600000000000000000045200010000035490179449  
00000581800NF   00000000000220100329T NN000000000001000000000000000000045200010000035490179449  
1b3acabf0a929588902bb197beaa03805df2ccd2  
1b3acabf0a929588902bb197beaa03805df2ccd2  
  
select * from tbItemDocumento where NumeroDocumento = 5111 and CodigoCliFor = 27699306805  
  
23338197000179  
-----------------------------------------------------------------------------------------------  
FIM_CABEC_PROC*/  
  
AS   
  
DECLARE @CodigoServico char(9)  
DECLARE @ValorServicos money  
DECLARE @Lote numeric(6)  
DECLARE @MunicipioPrestacao char(4)  
DECLARE @CGCMatriz char(14)  
  
SELECT @CGCMatriz = CGCLocal  
FROM tbLocal  
WHERE  
CodigoEmpresa = @CodigoEmpresa AND  
CodigoLocal = 0  
  
SELECT @MunicipioPrestacao = tbMunicipioSIAFI.CodigoMunicipio  
FROM tbLocal, tbMunicipioSIAFI  
WHERE  
tbLocal.CodigoEmpresa = @CodigoEmpresa AND  
tbLocal.CodigoLocal = @CodigoLocal AND  
tbMunicipioSIAFI.UF = tbLocal.UFLocal AND  
tbMunicipioSIAFI.NomeMunicipio LIKE LEFT(tbLocal.MunicipioLocal,8) + '%'  
  
SELECT @CodigoServico = '452000101'  
---- específico BAMAQ manutencao de maquinas era 466130000  
IF @CodigoEmpresa = 730 SELECT @CodigoServico = '331471700'  
  
IF EXISTS ( SELECT 1 FROM tbItemDocumento (NOLOCK) WHERE  
            CodigoEmpresa = @CodigoEmpresa AND  
            CodigoLocal = @CodigoLocal AND  
            DataDocumento = @DataDocumento AND  
            CodigoCliFor = @CodigoCliFor AND  
            NumeroDocumento = @NumeroDocumento AND  
            TipoLancamentoMovimentacao = 7 AND  
            CodigoMaoObraOS = 'RES' ) OR  
EXISTS ( SELECT 1 FROM tbDocumento (NOLOCK) WHERE  
            CodigoEmpresa = @CodigoEmpresa AND  
            CodigoLocal = @CodigoLocal AND  
            DataDocumento = @DataDocumento AND  
            CodigoCliFor = @CodigoCliFor AND  
            NumeroDocumento = @NumeroDocumento AND  
            TipoLancamentoMovimentacao = 7 AND  
            Recapagem = 'V' )  
BEGIN  
 SELECT @CodigoServico = '221290000'  
END  
  
SET NOCOUNT ON  
  
--criando tabela temporaria  
UPDATE tbLocalLF   
SET SequencialArquivo = SequencialArquivo + 1   
WHERE tbLocalLF.CodigoEmpresa = @CodigoEmpresa  
AND tbLocalLF.CodigoLocal = @CodigoLocal  
  
SELECT @Lote = SequencialArquivo  
FROM tbLocalLF (NOLOCK)  
WHERE  
tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND  
tbLocalLF.CodigoLocal = @CodigoLocal  
  
CREATE TABLE #tmpXML            (Linha VARCHAR(8000), Ordem numeric(6), ValorServico money)   
CREATE TABLE #tmpXMLCrypto      (ChaveCrypto VARCHAR(94))  
CREATE TABLE #tmpXMLConsulta    (LinhaConsulta VARCHAR(2000))  
CREATE TABLE #tmpXMLConsultaRPS (LinhaConsultaRPS VARCHAR(2000))  
  
---- Itens  
  
INSERT #tmpXML  
SELECT  
'<Item>' +  
'<DiscriminacaoServico>' +    
CASE WHEN DescricaoMaoObraOS IS NULL THEN  
 (LTRIM(COALESCE(TextoItemDocumentoFT,'')))  
ELSE  
 RTRIM(LTRIM(DescricaoMaoObraOS)) + ' ' + RTRIM(LTRIM(COALESCE(TextoItemDocumentoFT,'')))  
END +   
'</DiscriminacaoServico>' +  
'<Quantidade>' + CONVERT(VARCHAR(10),CONVERT(numeric(10,4),tbItemDocumento.QtdeLancamentoItemDocto)) + '</Quantidade>' +  
--'<ValorUnitario>' +   
--CASE WHEN CONVERT(NUMERIC(1),SUBSTRING(CONVERT(CHAR(10),( convert(numeric(16,4),( ValorBaseISSItemDocto / QtdeLancamentoItemDocto )) * QtdeLancamentoItemDocto ) - ROUND(( convert(numeric(16,4),( ValorBaseISSItemDocto / QtdeLancamentoItemDocto )) * QtdeL
ancamentoItemDocto ),2,1)),5,1)) >=5 THEN  
 --CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,4), ( tbItemDocumento.ValorBaseISSItemDocto /tbItemDocumento.QtdeLancamentoItemDocto) + 0.001 ))  
--ELSE  
 --CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,4), ( tbItemDocumento.ValorBaseISSItemDocto /tbItemDocumento.QtdeLancamentoItemDocto)))  
--END + '</ValorUnitario>' +  
'<ValorUnitario>' +   
CASE WHEN CONVERT(NUMERIC(1),SUBSTRING(CONVERT(CHAR(10),( convert(numeric(16,4),( ValorBaseISSItemDocto / QtdeLancamentoItemDocto )) * QtdeLancamentoItemDocto ) - ROUND(( convert(numeric(16,4),( ValorBaseISSItemDocto / QtdeLancamentoItemDocto )) * QtdeLan
camentoItemDocto ),2,1)),5,1)) >= 5 THEN  
 CASE WHEN CONVERT(NUMERIC(1),SUBSTRING(CONVERT(CHAR(10),( convert(numeric(16,4),( ValorBaseISSItemDocto / QtdeLancamentoItemDocto )) * QtdeLancamentoItemDocto ) - ROUND(( convert(numeric(16,4),( ValorBaseISSItemDocto / QtdeLancamentoItemDocto )) * QtdeLa
ncamentoItemDocto ),2,1)),5,1)) <> 9 THEN  
  CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,4), ( tbItemDocumento.ValorBaseISSItemDocto /tbItemDocumento.QtdeLancamentoItemDocto) + 0.001 ))  
 ELSE  
  CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,4), ( tbItemDocumento.ValorBaseISSItemDocto /tbItemDocumento.QtdeLancamentoItemDocto) + 0.0001 ))  
 END  
ELSE  
 CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,4), ( tbItemDocumento.ValorBaseISSItemDocto /tbItemDocumento.QtdeLancamentoItemDocto)))  
END + '</ValorUnitario>' +  
---'<ValorUnitario>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,4), (tbItemDocumento.ValorBaseISSItemDocto / tbItemDocumento.QtdeLancamentoItemDocto))) + '</ValorUnitario>' +  
'<ValorTotal>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2), tbItemDocumento.ValorBaseISSItemDocto)) + '</ValorTotal>' +   
'</Item>',  
2,  
CASE WHEN CONVERT(NUMERIC(1),SUBSTRING(CONVERT(CHAR(10),( convert(numeric(16,4),( ValorBaseISSItemDocto / QtdeLancamentoItemDocto )) * QtdeLancamentoItemDocto ) - ROUND(( convert(numeric(16,4),( ValorBaseISSItemDocto / QtdeLancamentoItemDocto )) * QtdeLan
camentoItemDocto ),2,1)),5,1)) >=5 THEN  
 CASE WHEN CONVERT(NUMERIC(1),SUBSTRING(CONVERT(CHAR(10),( convert(numeric(16,4),( ValorBaseISSItemDocto / QtdeLancamentoItemDocto )) * QtdeLancamentoItemDocto ) - ROUND(( convert(numeric(16,4),( ValorBaseISSItemDocto / QtdeLancamentoItemDocto )) * QtdeLa
ncamentoItemDocto ),2,1)),5,1)) <> 9 THEN   
  ROUND(CONVERT(NUMERIC(16,4), ( tbItemDocumento.ValorBaseISSItemDocto /tbItemDocumento.QtdeLancamentoItemDocto) + 0.001 ) * QtdeLancamentoItemDocto,2,1)  
 ELSE  
 ROUND(CONVERT(NUMERIC(16,4), ( tbItemDocumento.ValorBaseISSItemDocto /tbItemDocumento.QtdeLancamentoItemDocto) + 0.0001 ) * QtdeLancamentoItemDocto,2,1)  
 END  
ELSE  
 ROUND(CONVERT(NUMERIC(16,4), ( tbItemDocumento.ValorBaseISSItemDocto /tbItemDocumento.QtdeLancamentoItemDocto)) * QtdeLancamentoItemDocto,2,1)  
END  
  
FROM tbItemDocumento (NOLOCK)  
  
INNER JOIN tbEmpresa (NOLOCK) ON    
tbEmpresa.CodigoEmpresa = @CodigoEmpresa   
  
INNER JOIN tbLocalLF (NOLOCK)  
ON tbLocalLF.CodigoEmpresa = tbItemDocumento.CodigoEmpresa  
AND tbLocalLF.CodigoLocal = tbItemDocumento.CodigoLocal  
  
INNER JOIN tbLocal (NOLOCK)  
ON tbLocal.CodigoEmpresa = tbItemDocumento.CodigoEmpresa  
AND tbLocal.CodigoLocal = tbItemDocumento.CodigoLocal  
  
INNER JOIN tbCliFor (NOLOCK)  
ON tbCliFor.CodigoEmpresa = tbItemDocumento.CodigoEmpresa  
AND tbCliFor.CodigoCliFor = tbItemDocumento.CodigoCliFor  
  
LEFT JOIN tbCEP (NOLOCK)  
ON  tbCEP.NumeroCEP = tbCliFor.CEPCliFor  
  
LEFT JOIN tbCliForFisica (NOLOCK)  
ON tbCliForFisica.CodigoEmpresa = tbCliFor.CodigoEmpresa  
AND tbCliForFisica.CodigoCliFor = tbCliFor.CodigoCliFor  
  
LEFT JOIN tbCliForJuridica (NOLOCK)  
ON tbCliForJuridica.CodigoEmpresa = tbCliFor.CodigoEmpresa  
AND tbCliForJuridica.CodigoCliFor = tbCliFor.CodigoCliFor  
  
INNER JOIN tbDocumento (NOLOCK)  
ON tbDocumento.CodigoEmpresa = tbItemDocumento.CodigoEmpresa  
AND tbDocumento.CodigoLocal = tbItemDocumento.CodigoLocal  
AND tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento  
AND tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento  
AND tbDocumento.DataDocumento = tbItemDocumento.DataDocumento  
AND tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor  
AND tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao  
  
INNER JOIN tbDocumentoFT (NOLOCK)  
ON tbDocumentoFT.CodigoEmpresa = tbItemDocumento.CodigoEmpresa  
AND tbDocumentoFT.CodigoLocal = tbItemDocumento.CodigoLocal  
AND tbDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento  
AND tbDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento  
AND tbDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento  
AND tbDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor  
AND tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao  
  
INNER JOIN tbItemDocumentoFT (NOLOCK)  
ON tbItemDocumentoFT.CodigoEmpresa = tbItemDocumento.CodigoEmpresa  
AND tbItemDocumentoFT.CodigoLocal = tbItemDocumento.CodigoLocal  
AND tbItemDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento  
AND tbItemDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento  
AND tbItemDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento  
AND tbItemDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor  
AND tbItemDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao  
AND tbItemDocumentoFT.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento  
  
LEFT JOIN tbItemDocumentoTextos  
ON tbItemDocumentoTextos.CodigoEmpresa  = tbItemDocumento.CodigoEmpresa  and  
tbItemDocumentoTextos.CodigoLocal  = tbItemDocumento.CodigoLocal   and  
tbItemDocumentoTextos.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento   and  
tbItemDocumentoTextos.DataDocumento  = tbItemDocumento.DataDocumento and  
tbItemDocumentoTextos.NumeroDocumento  = tbItemDocumento.NumeroDocumento  and  
tbItemDocumentoTextos.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao  and  
tbItemDocumentoTextos.CodigoCliFor  = tbItemDocumento.CodigoCliFor  and  
tbItemDocumentoTextos.SequenciaItemDocumento= tbItemDocumento.SequenciaItemDocumento    
  
LEFT JOIN tbMaoObraOS  
ON  tbMaoObraOS.CodigoEmpresa  = tbItemDocumento.CodigoEmpresa  
AND tbMaoObraOS.CodigoMaoObraOS  = tbItemDocumento.CodigoMaoObraOS  
  
WHERE   
tbItemDocumento.CodigoEmpresa = @CodigoEmpresa  
AND tbItemDocumento.CodigoLocal = @CodigoLocal  
AND tbItemDocumento.EntradaSaidaDocumento = 'S'  
AND tbItemDocumento.DataDocumento = @DataDocumento  
AND tbItemDocumento.ValorBaseISSItemDocto > 0  
AND tbItemDocumento.TipoLancamentoMovimentacao = 7  
AND tbItemDocumento.EntradaSaidaDocumento = 'S'  
AND tbItemDocumento.ValorContabilItemDocto <> 0   
AND tbDocumento.CondicaoNFCancelada <> 'V'   
AND tbItemDocumento.NumeroDocumento = @NumeroDocumento   
AND tbItemDocumento.CodigoCliFor = @CodigoCliFor  
  
SELECT @ValorServicos = SUM(ValorServico) FROM #tmpXML  
  
INSERT #tmpXML  
SELECT  
'<?xml version="1.0" encoding="utf-8" ?>' +  
'<ns1:ReqEnvioLoteRPS xmlns:ns1="http://localhost:8080/WsNFe2/lote" xmlns:tipos="http://localhost:8080/WsNFe2/tp" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://localhost:8080/WsNFe2/lote http://localhost:8080/WsNFe2/xsd/
ReqEnvioLoteRPS.xsd">' +  
'<Cabecalho>' +  
'<CodCidade>' + @MunicipioPrestacao + '</CodCidade>' +  
'<CPFCNPJRemetente>'+ @CGCMatriz + '</CPFCNPJRemetente>' +  
'<RazaoSocialRemetente>' + RTRIM(LTRIM(tbEmpresa.RazaoSocialEmpresa)) + '</RazaoSocialRemetente>' +  
'<transacao></transacao>' +  
'<dtInicio>' +  SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,@DataDocumento)),2,4) + '-' + SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,@DataDocumento)),2,2) + '-' +  SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,@DataDocumento)),2,2) + '</dtInicio>' +
  
'<dtFim>' +  SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,@DataDocumento)),2,4) + '-' + SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,@DataDocumento)),2,2) + '-' +  SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,@DataDocumento)),2,2) + '</dtFim>' +  
'<QtdRPS>1</QtdRPS>' +  
'<ValorTotalServicos>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),@ValorServicos)) + '</ValorTotalServicos>' +  
'<ValorTotalDeducoes>0.00</ValorTotalDeducoes>' +   
'<Versao>1</Versao>' +  
'<MetodoEnvio>WS</MetodoEnvio>' +  
'</Cabecalho>',  
0,  
0  
FROM tbLocal (NOLOCK)  
INNER JOIN tbEmpresa (NOLOCK) ON  
     tbEmpresa.CodigoEmpresa = @CodigoEmpresa   
INNER JOIN tbLocalLF (NOLOCK) ON  
           tbLocalLF.CodigoEmpresa = @CodigoEmpresa AND  
           tbLocalLF.CodigoLocal = @CodigoLocal  
WHERE  
tbLocal.CodigoEmpresa = @CodigoEmpresa AND  
tbLocal.CodigoLocal = @CodigoLocal   
  
--- outra temporaria  
  
INSERT #tmpXML  
SELECT  
'<Lote Id="' + LTRIM(RTRIM(CONVERT(VARCHAR(6),tbLocalLF.SequencialArquivo))) + '">' +  
'<RPS>' + -- Id="' + + LTRIM(RTRIM(CONVERT(VARCHAR(6),1000 + tbDocumento.NumeroDocumento))) + '">' +  
'<Assinatura>' + 'CHAVECRYPTO' + '</Assinatura>' +  
'<InscricaoMunicipalPrestador>' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</InscricaoMunicipalPrestador>' +  
--'<InscricaoMunicipalPrestador>' + '00581800' + '</InscricaoMunicipalPrestador>' +  
'<RazaoSocialPrestador>' + RTRIM(LTRIM(tbEmpresa.RazaoSocialEmpresa)) + '</RazaoSocialPrestador>' +  
'<TipoRPS>RPS</TipoRPS>' +   
'<SerieRPS>NF</SerieRPS>' +  
'<NumeroRPS>' + 'TROCARNUMERORPS' + '</NumeroRPS>' +  
'<DataEmissaoRPS>' +  SUBSTRING(CONVERT(CHAR(5), 10000 + DATEPART(YYYY,tbDocumento.DataDocumento)),2,4) + '-' + SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,tbDocumento.DataDocumento)),2,2) + '-' +  SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,tbDocumento
.DataDocumento)),2,2) + 'T00:00:00' + '</DataEmissaoRPS>' +  
'<SituacaoRPS>' + 'N' + '</SituacaoRPS>' +  
--'<NumeroNFSeSubstituida></NumeroNFSeSubstituida>' +  
--'<NumeroRPSSubstituido></NumeroRPSSubstituido>' +  
--'<DataEmissaoNFSeSubstituida>1900-01-01</DataEmissaoNFSeSubstituida>' +  
'<SeriePrestacao>99</SeriePrestacao>' +  
CASE WHEN tbCliFor.TipoCliFor = 'J' AND RTRIM(LTRIM(tbCliForJuridica.InscricaoMunicipalJuridica)) <> 'ISENTO' AND tbCliForJuridica.InscricaoMunicipalJuridica IS NOT NULL AND RTRIM(LTRIM(tbCliForJuridica.InscricaoMunicipalJuridica)) <> '' AND RTRIM(LTRIM(t
bCliFor.MunicipioCliFor)) = 'BELO HORIZONTE' THEN  
 '<InscricaoMunicipalTomador>' + RTRIM(LTRIM(COALESCE(REPLACE(REPLACE(REPLACE(tbCliForJuridica.InscricaoMunicipalJuridica ,'.',''),'-',''),'/',''),''))) + '</InscricaoMunicipalTomador>'   
ELSE  
 '<InscricaoMunicipalTomador>0000000</InscricaoMunicipalTomador>'  
END +  
CASE WHEN tbCliFor.TipoCliFor = 'J' THEN  
 '<CPFCNPJTomador>' + RTRIM(LTRIM(COALESCE(tbCliForJuridica.CGCJuridica,''))) + '</CPFCNPJTomador>'   
ELSE  
 '<CPFCNPJTomador>' + RTRIM(LTRIM(COALESCE(tbCliForFisica.CPFFisica,''))) + '</CPFCNPJTomador>'  
END +  
'<RazaoSocialTomador>' + RTRIM(LTRIM(tbCliFor.NomeCliFor)) +  '</RazaoSocialTomador>' +  
'<TipoLogradouroTomador></TipoLogradouroTomador>' +  
'<LogradouroTomador>' + RTRIM(LTRIM(tbCliFor.RuaCliFor)) + '</LogradouroTomador>' +  
CASE WHEN NumeroEndCliFor IS NOT NULL AND NumeroEndCliFor <> 0 THEN  
 '<NumeroEnderecoTomador>' + COALESCE(CONVERT(VARCHAR(5),NumeroEndCliFor),'') + '</NumeroEnderecoTomador>'  
ELSE  
 '<NumeroEnderecoTomador>SN</NumeroEnderecoTomador>'  
END +   
CASE WHEN tbCliFor.ComplementoEndCliFor IS NOT NULL AND RTRIM(LTRIM(tbCliFor.ComplementoEndCliFor)) <> '' THEN  
 '<ComplementoEnderecoTomador>' + COALESCE(RTRIM(LTRIM(tbCliFor.ComplementoEndCliFor)),'') + '</ComplementoEnderecoTomador>'  
ELSE  
 ''  
END +   
'<TipoBairroTomador>BAIRRO</TipoBairroTomador>' +  
'<BairroTomador>' + COALESCE(RTRIM(LTRIM(tbCliFor.BairroCliFor)),'') + '</BairroTomador>' +  
'<CidadeTomador>' + COALESCE(RTRIM(LTRIM(tbMunicipioSIAFI.CodigoMunicipio)),'') + '</CidadeTomador>' +  
'<CidadeTomadorDescricao>' + COALESCE(RTRIM(LTRIM(tbCliFor.MunicipioCliFor)),'') + '</CidadeTomadorDescricao>' +  
'<CEPTomador>' + tbCliFor.CEPCliFor + '</CEPTomador>' +  
'<EmailTomador>' + COALESCE(RTRIM(LTRIM(tbCliFor.EmailCliFor)),'') + '</EmailTomador>' +  
CASE WHEN tbNaturezaOperacao.CodigoTipoOperacao <> 12 OR tbDocumento.Recapagem = 'V' THEN  
 '<CodigoAtividade>' + @CodigoServico + '</CodigoAtividade>'    
ELSE   
 CASE WHEN @CodigoEmpresa = 730 THEN --- ESPECIFICO PARA BAMAQ (MAQUINAS)  
  '<CodigoAtividade>' + '331471700' + '</CodigoAtividade>'   
 ELSE  
  '<CodigoAtividade>' + '749010401' + '</CodigoAtividade>'   
 END  
END +   
'<AliquotaAtividade>' + COALESCE(CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2), (SELECT MAX(tbItemDoc.PercentualISSItemDocto)   
      FROM tbItemDocumento tbItemDoc   
      WHERE tbItemDoc.CodigoEmpresa = @CodigoEmpresa  
      AND tbItemDoc.CodigoLocal = @CodigoLocal  
      AND tbItemDoc.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento  
      AND tbItemDoc.NumeroDocumento = tbDocumento.NumeroDocumento  
      AND tbItemDoc.DataDocumento = tbDocumento.DataDocumento  
      AND tbItemDoc.CodigoCliFor = tbDocumento.CodigoCliFor  
      AND tbItemDoc.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao))),'0') + '</AliquotaAtividade>' +  
'<TipoRecolhimento>' + CASE WHEN tbDocumentoFT.cSitTribISS = 'R' THEN 'R' ELSE 'A' END + '</TipoRecolhimento>' +  
'<MunicipioPrestacao>' + @MunicipioPrestacao + '</MunicipioPrestacao>' +  
'<MunicipioPrestacaoDescricao>' + RTRIM(LTRIM(tbLocal.MunicipioLocal)) + '</MunicipioPrestacaoDescricao>' +  
'<Operacao>' + 'A' + '</Operacao>' +  
'<Tributacao>' + 'T' + '</Tributacao>' +  
CASE WHEN tbDocumento.ValorBaseISSDocumento > tbLocalFT.ValorMinimoMP135 AND tbNaturezaOperacao.MP135RetemImpostosFonte = 'V' AND tbDocumentoFT.vPISRetidoDocFT <> 0 THEN  
 '<ValorPIS>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.vPISRetidoDocFT)) + '</ValorPIS>'  
ELSE  
 '<ValorPIS>' + '0.00' + '</ValorPIS>'  
END +  
CASE WHEN tbDocumento.ValorBaseISSDocumento > tbLocalFT.ValorMinimoMP135 AND tbNaturezaOperacao.MP135RetemImpostosFonte = 'V' AND tbDocumentoFT.vCOFINSRetidoDocFT <> 0 THEN  
 '<ValorCOFINS>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.vCOFINSRetidoDocFT)) + '</ValorCOFINS>'  
ELSE  
 '<ValorCOFINS>' + '0.00' + '</ValorCOFINS>'  
END +  
'<ValorINSS>' + '0.00'  + '</ValorINSS>' +  
'<ValorIR>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.ValorIRRFDocFT))  + '</ValorIR>' +  
CASE WHEN tbDocumento.ValorBaseISSDocumento > tbLocalFT.ValorMinimoMP135 AND tbNaturezaOperacao.MP135RetemImpostosFonte = 'V' AND tbDocumentoFT.ValorCSLLDocFT <> 0 THEN  
 '<ValorCSLL>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),tbDocumentoFT.ValorCSLLDocFT)) + '</ValorCSLL>'  
ELSE  
 '<ValorCSLL>' + '0.00' + '</ValorCSLL>'  
END +  
'<AliquotaPIS>' + '0.00' + '</AliquotaPIS>' +  
'<AliquotaCOFINS>' + '0.00' + '</AliquotaCOFINS>' +  
'<AliquotaINSS>' + '0.00' + '</AliquotaINSS>' +  
'<AliquotaIR>' + '0.00' + '</AliquotaIR>' +  
'<AliquotaCSLL>' + '0.00' + '</AliquotaCSLL>' +  
'<DescricaoRPS>' + RTRIM(LTRIM(COALESCE(ObservacaoCapaDocFT,''))) +   
  CASE WHEN tbDocumento.NumeroDuplicatasDocumento > 0 THEN  
   ' Duplicatas : ' + dbo.fnDuplicatasDANFE(tbDocumento.CodigoEmpresa,tbDocumento.CodigoLocal,tbDocumento.EntradaSaidaDocumento,tbDocumento.NumeroDocumento,tbDocumento.DataDocumento,tbDocumento.CodigoCliFor,tbDocumento.TipoLancamentoMovimentacao)  
  ELSE  
   ''  
  END + '</DescricaoRPS>' +  
'<DDDPrestador>' + COALESCE(RIGHT(RTRIM(LTRIM(tbLocal.DDDLocal)),2),'00') + '</DDDPrestador>' +  
'<TelefonePrestador>' + COALESCE(RTRIM(LTRIM(tbLocal.TelefoneLocal)),'00000000') + '</TelefonePrestador>' +  
'<DDDTomador>' + COALESCE(RIGHT(RTRIM(LTRIM(tbCliFor.DDDTelefoneCliFor)),2),'00') + '</DDDTomador>' +  
'<TelefoneTomador>' + COALESCE(RTRIM(LTRIM(tbCliFor.TelefoneCliFor)),'00000000') + '</TelefoneTomador>' +  
'<Itens>',  
1,  
0  
  
FROM tbDocumento (NOLOCK)  
  
INNER JOIN tbEmpresa (NOLOCK) ON    
tbEmpresa.CodigoEmpresa = @CodigoEmpresa   
  
INNER JOIN tbLocalLF (NOLOCK)  
ON tbLocalLF.CodigoEmpresa = tbDocumento.CodigoEmpresa  
AND tbLocalLF.CodigoLocal = tbDocumento.CodigoLocal  
  
INNER JOIN tbLocalFT (NOLOCK)  
ON tbLocalFT.CodigoEmpresa = tbDocumento.CodigoEmpresa  
AND tbLocalFT.CodigoLocal = tbDocumento.CodigoLocal  
  
INNER JOIN tbLocal (NOLOCK)  
ON tbLocal.CodigoEmpresa = tbDocumento.CodigoEmpresa  
AND tbLocal.CodigoLocal = tbDocumento.CodigoLocal  
  
INNER JOIN tbCliFor (NOLOCK)  
ON tbCliFor.CodigoEmpresa = tbDocumento.CodigoEmpresa  
AND tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor  
  
LEFT JOIN tbCEP (NOLOCK)  
ON  tbCEP.NumeroCEP = tbCliFor.CEPCliFor  
  
LEFT JOIN tbCliForFisica (NOLOCK)  
ON tbCliForFisica.CodigoEmpresa = tbCliFor.CodigoEmpresa  
AND tbCliForFisica.CodigoCliFor = tbCliFor.CodigoCliFor  
  
LEFT JOIN tbCliForJuridica (NOLOCK)  
ON tbCliForJuridica.CodigoEmpresa = tbCliFor.CodigoEmpresa  
AND tbCliForJuridica.CodigoCliFor = tbCliFor.CodigoCliFor  
  
INNER JOIN tbDocumentoFT (NOLOCK)  
ON tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa  
AND tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal  
AND tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento  
AND tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento  
AND tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento  
AND tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor  
AND tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao  
  
LEFT JOIN tbDocumentoTextos (NOLOCK)  
ON tbDocumentoTextos.CodigoEmpresa = tbDocumento.CodigoEmpresa  
AND tbDocumentoTextos.CodigoLocal = tbDocumento.CodigoLocal  
AND tbDocumentoTextos.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento  
AND tbDocumentoTextos.NumeroDocumento = tbDocumento.NumeroDocumento  
AND tbDocumentoTextos.DataDocumento = tbDocumento.DataDocumento  
AND tbDocumentoTextos.CodigoCliFor = tbDocumento.CodigoCliFor  
AND tbDocumentoTextos.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao  
  
INNER JOIN tbNaturezaOperacao (NOLOCK)  
ON tbNaturezaOperacao.CodigoEmpresa = @CodigoEmpresa AND  
tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao  
  
LEFT JOIN tbClienteEventual (NOLOCK)  
ON tbClienteEventual.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa  
AND tbClienteEventual.CodigoClienteEventual = tbDocumentoFT.CodigoClienteEventual  
  
LEFT JOIN tbMunicipioSIAFI (NOLOCK)  
ON  tbMunicipioSIAFI.UF = tbCliFor.UFCliFor   
AND tbMunicipioSIAFI.NomeMunicipio = tbCliFor.MunicipioCliFor  
  
WHERE   
tbDocumento.CodigoEmpresa = @CodigoEmpresa  
AND tbDocumento.CodigoLocal = @CodigoLocal  
AND tbDocumento.EntradaSaidaDocumento = 'S'  
AND tbDocumento.DataDocumento = @DataDocumento  
AND tbDocumento.ValorBaseISSDocumento > 0  
AND tbDocumento.TipoLancamentoMovimentacao = 7  
AND tbDocumento.EntradaSaidaDocumento = 'S'  
AND tbDocumento.ValorContabilDocumento <> 0   
AND tbDocumento.CondicaoNFCancelada <> 'V'   
AND tbDocumento.NumeroDocumento = @NumeroDocumento   
AND tbDocumento.CodigoCliFor = @CodigoCliFor  
  
INSERT #tmpXMLCrypto  
SELECT  
RIGHT('00000000' + RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))),11) +  
'NF   ' +  
'NUMERORRPPSS' +   
--RIGHT('000000000000' + CONVERT(VARCHAR(6),tbDocumento.NumeroDocumento),12) +  
CONVERT(CHAR(4),DATEPART(YYYY,@DataDocumento)) + SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(MM,@DataDocumento)),2,2) + SUBSTRING(CONVERT(CHAR(3), 100 + DATEPART(DD,@DataDocumento)),2,2) +  
'T ' +  
'N' +  
CASE WHEN tbDocumentoFT.cSitTribISS = 'R' THEN 'S' ELSE 'N' END +  
RIGHT('0000000000000000' + REPLACE(CONVERT(VARCHAR(16),@ValorServicos),'.',''),15) +  
'000000000000000' +  
RIGHT('0000000000' + CASE WHEN tbNaturezaOperacao.CodigoTipoOperacao <> 12 OR tbDocumento.Recapagem = 'V' THEN  
 REPLACE(@CodigoServico,'.','')  
ELSE   
 CASE WHEN @CodigoEmpresa = 730 THEN --- ESPECIFICO PARA BAMAQ (MAQUINAS)  
  '331471700'  
 ELSE  
  '749010401'  
 END  
END,10) +  
RIGHT('000' +  
RTRIM(LTRIM(CASE WHEN tbCliFor.TipoCliFor = 'J' THEN  
 COALESCE(tbCliForJuridica.CGCJuridica,'')  
ELSE  
 COALESCE(tbCliForFisica.CPFFisica,'')  
END)),14)  
FROM tbDocumento (NOLOCK)  
  
INNER JOIN tbEmpresa (NOLOCK) ON    
tbEmpresa.CodigoEmpresa = @CodigoEmpresa   
  
INNER JOIN tbLocalLF (NOLOCK)  
ON tbLocalLF.CodigoEmpresa = tbDocumento.CodigoEmpresa  
AND tbLocalLF.CodigoLocal = tbDocumento.CodigoLocal  
  
INNER JOIN tbLocal (NOLOCK)  
ON tbLocal.CodigoEmpresa = tbDocumento.CodigoEmpresa  
AND tbLocal.CodigoLocal = tbDocumento.CodigoLocal  
  
INNER JOIN tbCliFor (NOLOCK)  
ON tbCliFor.CodigoEmpresa = tbDocumento.CodigoEmpresa  
AND tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor  
  
LEFT JOIN tbCEP (NOLOCK)  
ON  tbCEP.NumeroCEP = tbCliFor.CEPCliFor  
  
LEFT JOIN tbCliForFisica (NOLOCK)  
ON tbCliForFisica.CodigoEmpresa = tbCliFor.CodigoEmpresa  
AND tbCliForFisica.CodigoCliFor = tbCliFor.CodigoCliFor  
  
LEFT JOIN tbCliForJuridica (NOLOCK)  
ON tbCliForJuridica.CodigoEmpresa = tbCliFor.CodigoEmpresa  
AND tbCliForJuridica.CodigoCliFor = tbCliFor.CodigoCliFor  
  
INNER JOIN tbDocumentoFT (NOLOCK)  
ON tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa  
AND tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal  
AND tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento  
AND tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento  
AND tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento  
AND tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor  
AND tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao  
  
LEFT JOIN tbDocumentoTextos (NOLOCK)  
ON tbDocumentoTextos.CodigoEmpresa = tbDocumento.CodigoEmpresa  
AND tbDocumentoTextos.CodigoLocal = tbDocumento.CodigoLocal  
AND tbDocumentoTextos.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento  
AND tbDocumentoTextos.NumeroDocumento = tbDocumento.NumeroDocumento  
AND tbDocumentoTextos.DataDocumento = tbDocumento.DataDocumento  
AND tbDocumentoTextos.CodigoCliFor = tbDocumento.CodigoCliFor  
AND tbDocumentoTextos.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao  
  
INNER JOIN tbNaturezaOperacao (NOLOCK)  
ON tbNaturezaOperacao.CodigoEmpresa = @CodigoEmpresa AND  
tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao  
  
LEFT JOIN tbClienteEventual (NOLOCK)  
ON tbClienteEventual.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa  
AND tbClienteEventual.CodigoClienteEventual = tbDocumentoFT.CodigoClienteEventual  
  
LEFT JOIN tbMunicipioSIAFI (NOLOCK)  
ON  tbMunicipioSIAFI.UF = tbCliFor.UFCliFor   
AND tbMunicipioSIAFI.NomeMunicipio = tbCliFor.MunicipioCliFor  
  
WHERE   
tbDocumento.CodigoEmpresa = @CodigoEmpresa  
AND tbDocumento.CodigoLocal = @CodigoLocal  
AND tbDocumento.EntradaSaidaDocumento = 'S'  
AND tbDocumento.DataDocumento = @DataDocumento  
AND tbDocumento.ValorBaseISSDocumento > 0  
AND tbDocumento.TipoLancamentoMovimentacao = 7  
AND tbDocumento.EntradaSaidaDocumento = 'S'  
AND tbDocumento.ValorContabilDocumento <> 0   
AND tbDocumento.CondicaoNFCancelada <> 'V'   
AND tbDocumento.NumeroDocumento = @NumeroDocumento   
AND tbDocumento.CodigoCliFor = @CodigoCliFor  
  
INSERT #tmpXML  
SELECT  
'</Itens>' +  
'</RPS>' +  
'</Lote>' +  
'</ns1:ReqEnvioLoteRPS>',  
999999,  
0  
  
--- XML de Consulta  
  
INSERT #tmpXMLConsulta  
SELECT  
'<?xml version="1.0" encoding="UTF-8" ?>' +  
'<ns1:ReqConsultaLote xmlns:ns1="http://localhost:8080/WsNFe2/lote" xmlns:tipos="http://localhost:8080/WsNFe2/tp" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://localhost:8080/WsNFe2/lote http://localhost:8080/WsNFe2/xsd/
ReqConsultaLote.xsd">' +  
'<Cabecalho>' +  
'<CodCidade>' + @MunicipioPrestacao + '</CodCidade>' +  
'<CPFCNPJRemetente>' + @CGCMatriz + '</CPFCNPJRemetente>' +  
'<Versao>1</Versao>' +  
'<NumeroLote>' + 'NRLOTE' + '</NumeroLote>' +  
'</Cabecalho>' +  
'</ns1:ReqConsultaLote>'  
FROM tbLocal (NOLOCK)  
WHERE  
CodigoEmpresa = @CodigoEmpresa AND  
CodigoLocal = @CodigoLocal  
  
--- XML de Consulta RPS  
  
INSERT #tmpXMLConsultaRPS  
SELECT  
'<?xml version="1.0" encoding="UTF-8" ?>' +  
'<ns1:ConsultaSeqRps xmlns:ns1="http://localhost:8080/WsNFe2/lote" xmlns:tipos="http://localhost:8080/WsNFe2/tp" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://localhost:8080/WsNFe2/lote http://localhost:8080/WsNFe2/xsd/C
onsultaSeqRps.xsd">' +  
'<Cabecalho>' +  
'<CodCid>' + @MunicipioPrestacao + '</CodCid>' +  
'<IMPrestador>' +  RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(tbLocal.InscricaoMunicipalLocal,'-',''),'/',''),'.',''))) + '</IMPrestador>' +  
'<CPFCNPJRemetente>' + @CGCMatriz + '</CPFCNPJRemetente>' +  
'<Versao>1</Versao>' +  
'</Cabecalho>' +  
'</ns1:ConsultaSeqRps>'  
FROM tbLocal (NOLOCK)  
WHERE  
CodigoEmpresa = @CodigoEmpresa AND  
CodigoLocal = @CodigoLocal  
  
---  
  
SELECT Linha, ChaveCrypto, LinhaConsulta, LinhaConsultaRPS FROM #tmpXML , #tmpXMLCrypto, #tmpXMLConsulta, #tmpXMLConsultaRPS  
order by Ordem  
  
SET NOCOUNT OFF  
  