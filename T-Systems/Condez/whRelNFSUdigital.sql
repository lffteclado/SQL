IF EXISTS (SELECT 1 FROM sysobjects WHERE id = object_id('whRelNFSUdigital'))
	DROP PROCEDURE dbo.whRelNFSUdigital
GO
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
EMPRESA......: T-SYSTEMS
PROJETO......: NFS-e
AUTOR........: Condez
DATA.........: 20/11/2009
OBJETIVO.....: 

whRelNFSUdigital  1608, 0,0,'2010-03-29',0,2
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

CREATE PROCEDURE dbo.whRelNFSUdigital
	@CodigoEmpresa numeric(4),
	@CodigoLocal numeric(4),
    @NumeroDocumento numeric(6),
    @DataDocumento datetime, 
    @CodigoCliFor numeric(14),
	@NumeroNFE numeric(15) = 0

AS

SELECT 
	tbDocumentoRPS.CodigoEmpresa             ,              
	tbDocumentoRPS.CodigoLocal              ,               
	tbDocumentoRPS.CodigoCliFor            ,                
	tbDocumentoRPS.EntradaSaidaDocumento ,
	tbDocumentoRPS.NumeroDocumento        ,                 
	tbDocumentoRPS.DataDocumento           ,
	tbDocumentoRPS.TipoLancamentoMovimentacao              ,
	tbDocumentoRPS.TipoRPS ,
	tbDocumentoRPS.SerieRPS ,
	tbDocumentoRPS.NumeroNFE              ,                 
	tbDocumentoRPS.DataNFE               ,  
	tbDocumentoRPS.CodigoVerificacaoNFE ,
	tbDocumentoRPS.ValorCreditoNFE,
	tbEmpresa.RazaoSocialEmpresa,
	COALESCE(LEFT(tbLocal.CGCLocal,2) + '.' + SUBSTRING(tbLocal.CGCLocal,3,3) + '.' +
	SUBSTRING(tbLocal.CGCLocal,6,3) + '/' + SUBSTRING(tbLocal.CGCLocal,9,4) + '-' + RIGHT(tbLocal.CGCLocal,2),'') AS CGCLocal,
    tbLocal.InscricaoMunicipalLocal,
    tbLocal.RuaLocal, 
    tbLocal.NumeroEndLocal,
    tbLocal.BairroLocal,
    tbLocal.CEPLocal,
    tbLocal.MunicipioLocal,
    tbLocal.UFLocal,
    tbLocal.DDDLocal,
    tbLocal.TelefoneLocal,
    tbLocal.EmailLocal,
	tbCliFor.NomeCliFor,
	CASE WHEN tbCliFor.TipoCliFor = 'J' THEN
					COALESCE(LEFT(CGCJuridica,2) + '.' + SUBSTRING(CGCJuridica,3,3) + '.' +
					SUBSTRING(CGCJuridica,6,3) + '/' + SUBSTRING(CGCJuridica,9,4) + '-' + RIGHT(CGCJuridica,2),'')
	ELSE
					COALESCE( LEFT(CPFFisica,3) + '.' + SUBSTRING(CPFFisica,4,3) + '.' + 
						SUBSTRING(CPFFisica,7,3) + '-' + SUBSTRING(CPFFisica,10,2),'' )
	END AS CGCCPF,
    tbCliForJuridica.InscricaoMunicipalJuridica,
    tbCliFor.RuaCliFor,
    tbCliFor.NumeroEndCliFor,
    tbCliFor.ComplementoEndCliFor,
    tbCliFor.BairroCliFor,
    tbCliFor.MunicipioCliFor,
    tbCliFor.CEPCliFor,
    tbCliFor.UFCliFor,
    tbCliFor.DDDTelefoneCliFor,
    tbCliFor.TelefoneCliFor,
    tbCliFor.EmailCliFor,
	dbo.fnItensNFEletronicaBH(@CodigoEmpresa, @CodigoLocal, tbDocumentoRPS.NumeroDocumento, tbDocumentoRPS.DataDocumento, tbDocumentoRPS.CodigoCliFor) as Itens,
	tbDocumento.ValorBaseISSDocumento AS ValorServico,
    CASE WHEN tbCliFor.CondicaoRetencaoISS = 'V' THEN
		tbDocumento.ValorISSDocumento
	ELSE
		0.00
	END AS ValorISSRetido,
	(SELECT MAX(tbItemDocumento.PercentualISSItemDocto) 
	 FROM tbItemDocumento  
	 WHERE tbItemDocumento.CodigoEmpresa = @CodigoEmpresa
	 AND	tbItemDocumento.CodigoLocal = @CodigoLocal
	 AND	tbItemDocumento.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
	 AND	tbItemDocumento.NumeroDocumento = tbDocumento.NumeroDocumento
	 AND	tbItemDocumento.DataDocumento = tbDocumento.DataDocumento
	 AND	tbItemDocumento.CodigoCliFor = tbDocumento.CodigoCliFor
	 AND	tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao) as PercentualISSLocal,
	tbDocumento.ValorISSDocumento AS ValorISS,
	Logotipo,
	tbPedidoOS.CodigoOrdemServicoPedidoOS,
	tbDocumentoFT.ValorIRRFDocFT,
	tbDocumentoFT.ValorCSLLDocFT,
	tbDocumentoFT.ValorSegSocialDocFT,
	(SELECT MAX(tbItemDocumento.CodigoServicoISSItemDocto) 
	 FROM tbItemDocumento  
	 WHERE tbItemDocumento.CodigoEmpresa = @CodigoEmpresa
	 AND	tbItemDocumento.CodigoLocal = @CodigoLocal
	 AND	tbItemDocumento.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
	 AND	tbItemDocumento.NumeroDocumento = tbDocumento.NumeroDocumento
	 AND	tbItemDocumento.DataDocumento = tbDocumento.DataDocumento
	 AND	tbItemDocumento.CodigoCliFor = tbDocumento.CodigoCliFor
	 AND	tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao) as Servico,
	 CONVERT(VARCHAR(300),'') as DescricaoServico,
	 CONVERT(VARCHAR(1000), 'P.Pagto : ' + tbDocumentoFT.CodigoPlanoPagamento + '-' + tbPlanoPagamento.DescricaoPlanoPagamento + CHAR(13) + CHAR(10) +
	 dbo.fnGeraTextoInfCompDANFE(@CodigoEmpresa, @CodigoLocal,'S',tbDocumento.NumeroDocumento,tbDocumento.DataDocumento,tbDocumento.CodigoCliFor,7)) as DadosAdicionais,
     tbNaturezaOperacao.CodigoTipoOperacao,
	 CONVERT(VARCHAR(300),'') as DescricaoCNAE,
	 ObservacaoCapaDocFT,
	 CASE WHEN DescricaoMaoObraOS IS NULL THEN
 		 (LTRIM(COALESCE(TextoItemDocumentoFT,'')))
	 ELSE
		 RTRIM(LTRIM(DescricaoMaoObraOS)) + ' ' + RTRIM(LTRIM(COALESCE(TextoItemDocumentoFT,'')))
	 END as DescriminacaoServicos,
	tbItemDocumento.QtdeLancamentoItemDocto,
	(tbItemDocumento.ValorBaseISSItemDocto / tbItemDocumento.QtdeLancamentoItemDocto) as ValorUnitario,
	tbItemDocumento.ValorBaseISSItemDocto,
	CASE WHEN tbCliFor.CondicaoRetencaoISS = 'V' THEN 'Retido na Fonte' ELSE 'A Recolher' END as TipoRecolhimento,
	tbDocumento.Recapagem,
	tbDocumento.ValorPISDocumento,
	tbDocumento.ValorFinsocialDocumento

INTO #tmp
FROM tbDocumentoRPS (NOLOCK)

INNER JOIN tbEmpresa (NOLOCK) ON
	tbEmpresa.CodigoEmpresa = @CodigoEmpresa

LEFT JOIN tbLogotipos (NOLOCK) ON
	tbLogotipos.CodigoEmpresa		= @CodigoEmpresa
	AND	tbLogotipos.CodigoLocal		= @CodigoLocal
	AND	tbLogotipos.CodigoLogotipo		= 'NF'

INNER JOIN tbDocumento (NOLOCK) ON
	tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
	tbDocumento.CodigoLocal = @CodigoLocal AND
	tbDocumento.EntradaSaidaDocumento = 'S' AND
	tbDocumento.NumeroDocumento = tbDocumentoRPS.NumeroDocumento AND
	tbDocumento.CodigoCliFor = tbDocumentoRPS.CodigoCliFor AND
	tbDocumento.DataDocumento = tbDocumentoRPS.DataDocumento AND
	tbDocumento.TipoLancamentoMovimentacao = tbDocumentoRPS.TipoLancamentoMovimentacao

INNER JOIN tbItemDocumento (NOLOCK) ON
	tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
	tbItemDocumento.CodigoLocal = @CodigoLocal AND
	tbItemDocumento.EntradaSaidaDocumento = 'S' AND
	tbItemDocumento.NumeroDocumento = tbDocumentoRPS.NumeroDocumento AND
	tbItemDocumento.CodigoCliFor = tbDocumentoRPS.CodigoCliFor AND
	tbItemDocumento.DataDocumento = tbDocumentoRPS.DataDocumento AND
	tbItemDocumento.TipoLancamentoMovimentacao = tbDocumentoRPS.TipoLancamentoMovimentacao

LEFT JOIN tbMaoObraOS
ON 	tbMaoObraOS.CodigoEmpresa		= tbItemDocumento.CodigoEmpresa
AND	tbMaoObraOS.CodigoMaoObraOS 	= tbItemDocumento.CodigoMaoObraOS

INNER JOIN tbDocumentoFT (NOLOCK) ON
	tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
	tbDocumentoFT.CodigoLocal = @CodigoLocal AND
	tbDocumentoFT.EntradaSaidaDocumento = 'S' AND
	tbDocumentoFT.NumeroDocumento = tbDocumentoRPS.NumeroDocumento AND
	tbDocumentoFT.CodigoCliFor = tbDocumentoRPS.CodigoCliFor AND
	tbDocumentoFT.DataDocumento = tbDocumentoRPS.DataDocumento AND
	tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumentoRPS.TipoLancamentoMovimentacao

LEFT JOIN tbDocumentoTextos (NOLOCK)
ON	tbDocumentoTextos.CodigoEmpresa = tbDocumento.CodigoEmpresa
AND	tbDocumentoTextos.CodigoLocal = tbDocumento.CodigoLocal
AND	tbDocumentoTextos.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
AND	tbDocumentoTextos.NumeroDocumento = tbDocumento.NumeroDocumento
AND	tbDocumentoTextos.DataDocumento = tbDocumento.DataDocumento
AND	tbDocumentoTextos.CodigoCliFor = tbDocumento.CodigoCliFor
AND	tbDocumentoTextos.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao

INNER JOIN tbNaturezaOperacao (NOLOCK) ON
           tbNaturezaOperacao.CodigoEmpresa = @CodigoEmpresa AND
           tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao

INNER JOIN tbCliFor (NOLOCK) ON	
	tbCliFor.CodigoEmpresa = tbDocumentoRPS.CodigoEmpresa AND
	tbCliFor.CodigoCliFor = tbDocumentoRPS.CodigoCliFor

INNER JOIN tbLocal (NOLOCK) ON 
	tbLocal.CodigoEmpresa = @CodigoEmpresa AND
    tbLocal.CodigoLocal = @CodigoLocal

INNER JOIN tbPlanoPagamento (NOLOCK) ON  
    tbPlanoPagamento.CodigoEmpresa = @CodigoEmpresa AND
    tbPlanoPagamento.CodigoPlanoPagamento = tbDocumentoFT.CodigoPlanoPagamento

LEFT JOIN tbCliForJuridica (NOLOCK) ON
          tbCliForJuridica.CodigoEmpresa = @CodigoEmpresa AND
          tbCliForJuridica.CodigoCliFor = tbDocumentoRPS.CodigoCliFor

LEFT JOIN tbCliForFisica (NOLOCK) ON
          tbCliForFisica.CodigoEmpresa = @CodigoEmpresa AND
          tbCliForFisica.CodigoCliFor = tbDocumentoRPS.CodigoCliFor


LEFT JOIN tbPedidoOS (NOLOCK) ON
          tbPedidoOS.CodigoEmpresa = @CodigoEmpresa AND
          tbPedidoOS.CodigoLocal = @CodigoLocal AND
          tbPedidoOS.CentroCusto = tbDocumentoFT.CentroCusto AND
          tbPedidoOS.NumeroPedido = tbDocumento.NumeroPedidoDocumento AND
          tbPedidoOS.SequenciaPedido = tbDocumento.NumeroSequenciaPedidoDocumento

LEFT JOIN tbItemDocumentoTextos
ON	tbItemDocumentoTextos.CodigoEmpresa 	= tbItemDocumento.CodigoEmpresa 	and
tbItemDocumentoTextos.CodigoLocal		= tbItemDocumento.CodigoLocal 		and
tbItemDocumentoTextos.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento			and
tbItemDocumentoTextos.DataDocumento 	= tbItemDocumento.DataDocumento	and
tbItemDocumentoTextos.NumeroDocumento 	= tbItemDocumento.NumeroDocumento 	and
tbItemDocumentoTextos.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao		and
tbItemDocumentoTextos.CodigoCliFor		= tbItemDocumento.CodigoCliFor		and
tbItemDocumentoTextos.SequenciaItemDocumento= tbItemDocumento.SequenciaItemDocumento  
 
WHERE 
	tbDocumentoRPS.CodigoEmpresa = @CodigoEmpresa AND
    tbDocumentoRPS.CodigoLocal = @CodigoLocal  AND
	( tbDocumentoRPS.NumeroDocumento = @NumeroDocumento OR @NumeroDocumento = 0 ) AND 
    tbDocumentoRPS.NumeroNFE <> 0 AND
	( tbDocumentoRPS.NumeroNFE = @NumeroNFE OR @NumeroNFE = 0 )

UPDATE #tmp
SET DescricaoServico = '452000100 / Servicos de manutencao e reparacao mecanica de veiculos'

UPDATE #tmp
SET
DescricaoServico = '749010400 / Atividades de Intermediacao e Agenciamento de Serv'
WHERE
CodigoTipoOperacao = 12 

UPDATE #tmp
SET
DescricaoServico = '221290000 / Reforma de Pneumaticos Usados'
WHERE
Recapagem = 'V'

SELECT * FROM #tmp
ORDER BY
	tbDocumentoRPS.NumeroDocumento,
	tbDocumentoRPS.DataDocumento
GO
GRANT EXECUTE ON dbo.whRelNFSUdigital TO SQLUsers
GO


