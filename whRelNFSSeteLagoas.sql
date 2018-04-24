Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
EMPRESA......: T-SYSTEMS
PROJETO......: NFS-e SeteLagoas
AUTOR........: Mizael
DATA.........: 28/02/2018

whRelNFSSeteLagoas  1608, 0,0,'2018-01-03 00:00:00.000',0,1
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

CREATE PROCEDURE dbo.whRelNFSSeteLagoas
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
	COALESCE(tbClienteEventual.NomeCliEven,tbCliFor.NomeCliFor) as NomeCliFor,
	CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL THEN
		CASE WHEN tbCliFor.TipoCliFor = 'J' THEN
						COALESCE(LEFT(CGCJuridica,2) + '.' + SUBSTRING(CGCJuridica,3,3) + '.' +
						SUBSTRING(CGCJuridica,6,3) + '/' + SUBSTRING(CGCJuridica,9,4) + '-' + RIGHT(CGCJuridica,2),'')
		ELSE
						COALESCE( LEFT(CPFFisica,3) + '.' + SUBSTRING(CPFFisica,4,3) + '.' + 
							SUBSTRING(CPFFisica,7,3) + '-' + SUBSTRING(CPFFisica,10,2),'' )
		END 
	ELSE
		CASE WHEN tbClienteEventual.CGCCliEven IS NOT NULL THEN
						COALESCE(LEFT(tbClienteEventual.CGCCliEven,2) + '.' + SUBSTRING(tbClienteEventual.CGCCliEven,3,3) + '.' +
						SUBSTRING(tbClienteEventual.CGCCliEven,6,3) + '/' + SUBSTRING(tbClienteEventual.CGCCliEven,9,4) + '-' + RIGHT(tbClienteEventual.CGCCliEven,2),'')
		ELSE
						COALESCE( LEFT(CPFCliEven,3) + '.' + SUBSTRING(CPFCliEven,4,3) + '.' + 
							SUBSTRING(CPFCliEven,7,3) + '-' + SUBSTRING(CPFCliEven,10,2),'' )
		END 
	END	AS CGCCPF,
    tbCliForJuridica.InscricaoMunicipalJuridica,
    COALESCE(tbClienteEventual.EnderecoCliEven,tbCliFor.RuaCliFor) as RuaCliFor,
    CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL THEN
		tbCliFor.NumeroEndCliFor
	ELSE
		0
	END AS NumeroEndCliFor,
	CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL THEN
		tbCliFor.ComplementoEndCliFor
	ELSE
		''
	END AS ComplementoEndCliFor,
    COALESCE(tbClienteEventual.BairroCliEven,tbCliFor.BairroCliFor) as BairroCliFor,
    COALESCE(tbClienteEventual.MunicipioCliEven,tbCliFor.MunicipioCliFor) as MunicipioCliFor,
    COALESCE(tbClienteEventual.CEPCliEven,tbCliFor.CEPCliFor) AS CEPCliFor,
    COALESCE(tbClienteEventual.UnidadeFederacao,tbCliFor.UFCliFor) AS UFCliFor,
    CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL THEN
		tbCliFor.DDDTelefoneCliFor
	ELSE
		''
	END AS DDDTelefoneCliFor,
    CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL THEN
		tbCliFor.TelefoneCliFor
	ELSE
		''
	END as TelefoneCliFor,
    CASE WHEN tbClienteEventual.CodigoClienteEventual IS NULL THEN
		COALESCE(tbCliFor.EmailNFSE,tbCliFor.EmailCliFor)
	ELSE
		''
	END AS EmailCliFor,
	dbo.fnItensSeteLagoas(@CodigoEmpresa, @CodigoLocal, tbDocumentoRPS.NumeroDocumento, tbDocumentoRPS.DataDocumento, tbDocumentoRPS.CodigoCliFor) as Itens,
	tbDocumento.ValorBaseISSDocumento AS ValorServico,
    CASE WHEN tbDocumentoFT.cSitTribISS = 'R' THEN
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
	 AND	tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao) as	PercentualISSLocal,
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
	 tbTipoServicoNFSE.DescricaoServico as DescricaoServico,
	 CONVERT(VARCHAR(1000), 'P.Pagto : ' + tbDocumentoFT.CodigoPlanoPagamento + '-' + tbPlanoPagamento.DescricaoPlanoPagamento + CHAR(13) + CHAR(10) +
	 'Pedido: ' + CONVERT(VARCHAR(6), tbDocumento.NumeroPedidoDocumento) + '-' + CONVERT(VARCHAR(2),tbDocumento.NumeroSequenciaPedidoDocumento) + ' Vendedor: ' + LTRIM(RTRIM(dbo.fnRetNomeRepresNFe(@CodigoEmpresa, @CodigoLocal, tbDocumentoFT.CentroCusto, tbDo
cumento.NumeroPedidoDocumento, tbDocumento.NumeroSequenciaPedidoDocumento))) + CHAR(13) + CHAR(10) +
	 'Os : ' + CONVERT(VARCHAR(6),COALESCE(tbPedidoOS.CodigoOrdemServicoPedidoOS,0)) + CHAR(13) + CHAR(10) + 
	 'Placa : ' + CONVERT(VARCHAR(10),COALESCE(CONVERT(VARCHAR(10),tbVeiculoOS.PlacaVeiculoOS),'')) + ' KM : ' + CONVERT(VARCHAR(10),COALESCE(tbOROS.KmVeiculoOS,0)) + CHAR(13) + CHAR(10) + 
	 'Chassi : ' + RTRIM(LTRIM(COALESCE(tbVeiculoOS.ChassiVeiculoOS,''))) + CHAR(13) + CHAR(10) +
	 'Ano : ' + COALESCE(CONVERT(VARCHAR(4),tbVeiculoOS.AnoModeloVeiculoOS),'') + ' Modelo : ' + COALESCE(CONVERT(VARCHAR(30),tbVeiculoOS.ModeloVeiculoOS),'') + CHAR(13) + CHAR(10) +
	 'Origem da Venda : ' + CONVERT(VARCHAR(8),tbDocumentoFT.CentroCusto) + ' - ' + tbCentroCusto.DescricaoCentroCusto) + CHAR(13) + CHAR(10) + 
	 CASE WHEN tbDocumento.NumeroDuplicatasDocumento > 0 THEN
			'Duplicatas : ' + dbo.fnDuplicatasDANFE(tbDocumento.CodigoEmpresa,tbDocumento.CodigoLocal,tbDocumento.EntradaSaidaDocumento,tbDocumento.NumeroDocumento,tbDocumento.DataDocumento,tbDocumento.CodigoCliFor,tbDocumento.TipoLancamentoMovimentacao)
	 ELSE
			''
	 END + CHAR(13) + CHAR(10) +
	 dbo.fnSGNFGINFEs(@CodigoEmpresa, @CodigoLocal, tbDocumentoRPS.NumeroDocumento, tbDocumentoRPS.DataDocumento, tbDocumentoRPS.CodigoCliFor) as DadosAdicionais,
     tbNaturezaOperacao.CodigoTipoOperacao,
	 CONVERT(VARCHAR(300),'') as DescricaoCNAE,
     CASE WHEN tbDocumentoRPS.NumeroLote = 0 THEN
			tbDocumentoRPS.NumeroDocumento
	 ELSE
			tbDocumentoRPS.NumeroLote
	 END as NumeroLote,
     CodigoAtividadeEconomicaLocal,
	 ValorPIS = CASE WHEN tbDocumentoFT.vPISRetidoDocFT <> 0 THEN
					tbDocumentoFT.vPISRetidoDocFT
				ELSE
					0
				END,
	 ValorCOFINS = CASE WHEN tbDocumentoFT.vCOFINSRetidoDocFT <> 0 THEN
					tbDocumentoFT.vCOFINSRetidoDocFT
				ELSE
					0
				END,
	 ValorCSLL = CASE WHEN tbDocumentoFT.ValorCSLLDocFT <> 0 THEN
					tbDocumentoFT.ValorCSLLDocFT
				ELSE
					0
				END

INTO #tmp
FROM tbDocumentoRPS (NOLOCK)

INNER JOIN tbEmpresa (NOLOCK) ON
	tbEmpresa.CodigoEmpresa = @CodigoEmpresa

LEFT JOIN tbLogotipos (NOLOCK) ON
	tbLogotipos.CodigoEmpresa		= @CodigoEmpresa
	AND	tbLogotipos.CodigoLocal		= @CodigoLocal
	AND	tbLogotipos.CodigoLogotipo		= 'NF'

INNER JOIN tbLocalFT (NOLOCK) ON
           tbLocalFT.CodigoEmpresa = @CodigoEmpresa AND
           tbLocalFT.CodigoLocal = @CodigoLocal

INNER JOIN tbDocumento (NOLOCK) ON
	tbDocumento.CodigoEmpresa = @CodigoEmpresa AND
	tbDocumento.CodigoLocal = @CodigoLocal AND
	tbDocumento.EntradaSaidaDocumento = 'S' AND
	tbDocumento.NumeroDocumento = tbDocumentoRPS.NumeroDocumento AND
	tbDocumento.CodigoCliFor = tbDocumentoRPS.CodigoCliFor AND
	tbDocumento.DataDocumento = tbDocumentoRPS.DataDocumento AND
	tbDocumento.TipoLancamentoMovimentacao = tbDocumentoRPS.TipoLancamentoMovimentacao

INNER JOIN tbDocumentoFT (NOLOCK) ON
	tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa AND
	tbDocumentoFT.CodigoLocal = @CodigoLocal AND
	tbDocumentoFT.EntradaSaidaDocumento = 'S' AND
	tbDocumentoFT.NumeroDocumento = tbDocumentoRPS.NumeroDocumento AND
	tbDocumentoFT.CodigoCliFor = tbDocumentoRPS.CodigoCliFor AND
	tbDocumentoFT.DataDocumento = tbDocumentoRPS.DataDocumento AND
	tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumentoRPS.TipoLancamentoMovimentacao

LEFT JOIN tbClienteEventual (NOLOCK) ON
    tbClienteEventual.CodigoEmpresa = @CodigoEmpresa AND
    tbClienteEventual.CodigoClienteEventual = tbDocumentoFT.CodigoClienteEventual

INNER JOIN tbCentroCusto (NOLOCK) ON
           tbCentroCusto.CodigoEmpresa = @CodigoEmpresa AND
           tbCentroCusto.CentroCusto = tbDocumentoFT.CentroCusto 
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

LEFT JOIN tbOROS (NOLOCK)
ON	tbOROS.CodigoEmpresa	= tbPedidoOS.CodigoEmpresa
AND	tbOROS.CodigoLocal		= tbPedidoOS.CodigoLocal
AND	tbOROS.FlagOROS		= 'S'
AND	tbOROS.NumeroOROS		= tbPedidoOS.CodigoOrdemServicoPedidoOS

LEFT JOIN tbVeiculoOS (NOLOCK)
ON	tbVeiculoOS.CodigoEmpresa	= tbOROS.CodigoEmpresa
AND	tbVeiculoOS.ChassiVeiculoOS	= tbOROS.ChassiVeiculoOS

LEFT JOIN tbTipoServicoNFSE (NOLOCK)
ON	tbTipoServicoNFSE.CodigoEmpresa = @CodigoEmpresa AND
    tbTipoServicoNFSE.CodigoLocal = @CodigoLocal AND
    tbTipoServicoNFSE.CodigoServico =	(SELECT MAX(tbItemDocumento.CodigoServicoISSItemDocto) 
										FROM tbItemDocumento (NOLOCK)
										WHERE tbItemDocumento.CodigoEmpresa = @CodigoEmpresa
										AND	tbItemDocumento.CodigoLocal = @CodigoLocal
										AND	tbItemDocumento.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
										AND	tbItemDocumento.NumeroDocumento = tbDocumento.NumeroDocumento
										AND	tbItemDocumento.DataDocumento = tbDocumento.DataDocumento
										AND	tbItemDocumento.CodigoCliFor = tbDocumento.CodigoCliFor
										AND	tbItemDocumento.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao)


WHERE 
	tbDocumentoRPS.CodigoEmpresa = @CodigoEmpresa AND
    tbDocumentoRPS.CodigoLocal = @CodigoLocal  AND
	( tbDocumentoRPS.CodigoCliFor = @CodigoCliFor OR @CodigoCliFor = 0 ) AND
	( tbDocumentoRPS.NumeroDocumento = @NumeroDocumento OR @NumeroDocumento = 0 ) AND 
    tbDocumentoRPS.NumeroNFE <> 0 AND
	( tbDocumentoRPS.NumeroNFE = @NumeroNFE OR @NumeroNFE = 0 ) AND
	tbDocumentoRPS.DataDocumento >= '2018-01-01' -- Data Implantação Prefeitura SeteLagoas

---

SELECT * FROM #tmp
ORDER BY
	NumeroDocumento,
	DataDocumento

