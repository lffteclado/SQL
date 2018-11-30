if exists(select 1 from sysobjects where id = object_id('whRelCEListaProdutosVDL'))
DROP PROCEDURE dbo.whRelCEListaProdutosVDL
GO
CREATE PROCEDURE dbo.whRelCEListaProdutosVDL
@CodigoEmpresa		dtInteiro04,
@CodigoLocal 		dtInteiro04,
@DaLinha		dtInteiro04,
@AteLinha		dtInteiro04,
@DoProduto		dtCharacter30,
@AteProduto		dtCharacter30,
@DaFonteFornecimento 	dtInteiro04,
@AteFonteFornecimento	dtInteiro04,
@PesquisaDescricao	char(1) = 'F',
@DaDescProduto		dtCharacter60 = NULL,
@AteDescProduto    	dtCharacter60 = NULL

---whRelCEListaProdutosVDL 1608,0,0,9999,'','ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ',0,9999,'F',NULL,NULL

/*
 Deselvolvedor : Paulo Sérgio Nóbrega Vieira
 Data          : 07/04/1999
 Relatório     : RelProdutos1.rpt
 Motivo        : Listagem de Produtos
*/

-- dbo.whRelCEListaProdutos 1608,0,2,2,' ','ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ',1,9999,'V',NULL,NULL

WITH ENCRYPTION

AS

IF @PesquisaDescricao = 'F'

BEGIN
	SELECT
		tbProduto.CodigoEmpresa,                  
		tbProduto.CodigoProduto,                  
		tbProduto.DescricaoProduto,               
		tbProduto.CodigoClassificacaoFiscal,      
		tbProduto.CodigoEditadoProduto,
		tbProdutoFT.CodigoFormatadoProduto,         
		tbProdutoFT.CodigoBarrasProduto,            
		tbProdutoFT.EmbalagemComercialProduto,      
		tbProdutoFT.MarcaProduto,                   
		tbProdutoFT.DataCadastroProduto,            
		tbProdutoFT.PrecoReposicaoIndiceProduto,    
		tbProdutoFT.PesoLiquidoProduto,             
		tbProdutoFT.PesoBrutoProduto,               
		tbProdutoFT.CondicaoIPIProduto,             
		tbProdutoFT.CondicaoICMSProduto,            
		tbProdutoFT.CondicaoRedICMSProduto,         
		tbProdutoFT.FatorConversaoDIPIProduto,      
		tbProdutoFT.CodigoTributacaoProduto,        
		tbProdutoFT.PercRedBaseICMSProduto,         
		tbProdutoFT.PercentualImportacaoProduto,    
		tbProdutoFT.QuantidadeAntecessoresProduto,  
		tbProdutoFT.QuantidadeOpcionaisProduto,     
		tbProdutoFT.QuantidadeSucessoresProduto,    
		tbProdutoFT.QuantidadeOutrasFontesProduto,  
		tbProdutoFT.SubstituicaoTributariaProduto,  
		tbProdutoFT.EspecificacoesTecnicasProduto,  
		tbProdutoFT.CodigoCategoria,                
		tbProdutoFT.CodigoLinhaProduto,             
		tbProdutoFT.CodigoUnidadeProduto,           
		tbProdutoFT.CodigoFonteFornecimento,        
		tbProdutoFT.CodigoSituacaoTributaria,       
		tbPlanejamentoProduto.CodigoLocal,                    
		tbPlanejamentoProduto.VendaBloqueada,                 
		tbPlanejamentoProduto.SugestaoBloqueada,              
		tbPlanejamentoProduto.DataUltimaVenda,                
		tbPlanejamentoProduto.DataUltimaMovimentacao,         
		tbPlanejamentoProduto.FrequenciaVenda,                
		tbPlanejamentoProduto.DiasTempoReposicao,             
		tbPlanejamentoProduto.DiasRitmoAquisicao,             
		tbPlanejamentoProduto.DiasEstoqueMinimo,              
		tbPlanejamentoProduto.ConsumoMedioInformado,          
		tbPlanejamentoProduto.DataLimiteConsMedioInformado,   
		tbPlanejamentoProduto.ConsumoMedioCalculado,          
		tbPlanejamentoProduto.ConsumoMedioAnoAnterior,        
		tbPlanejamentoProduto.PontoPedidoCalculado,           
		tbPlanejamentoProduto.QuantidadeInventarios,          
		tbPlanejamentoProduto.PromocaoProduto,                
		tbPlanejamentoProduto.QuantidadeLimitePromocao,       
		tbPlanejamentoProduto.DataLimitePromocao,             
		tbPlanejamentoProduto.QuantidadeEstoqueMinimo,        
		tbPlanejamentoProduto.QuantidadeEstoqueMaximo,        
		tbPlanejamentoProduto.ClassifABCValorVenda,           
		tbPlanejamentoProduto.ClassifABCValorEstoque,         
		tbPlanejamentoProduto.ClassifABCValorCompras,         
		tbPlanejamentoProduto.ClassifABCValorReposicao,       
		tbPlanejamentoProduto.DataApurABCValorVenda,          
		tbPlanejamentoProduto.DataApurABCValorEstoque,        
		tbPlanejamentoProduto.DataApurABCValorCompras,        
		tbPlanejamentoProduto.DataApurABCValorReposicao,      
		tbPlanejamentoProduto.ClassifABCQuantidadeVenda,      
		tbPlanejamentoProduto.ClassifABCQuantidadeEstoque,    
		tbPlanejamentoProduto.ClassifABCQuantidadeCompras,    
		tbPlanejamentoProduto.ClassifABCFrequenciaVenda,      
		tbPlanejamentoProduto.DataApurABCQuantidadeVenda,     
		tbPlanejamentoProduto.DataApurABCQuantidadeEstoque,   
		tbPlanejamentoProduto.DataApurABCQuantidadeCompras,   
		tbPlanejamentoProduto.DataApurABCFrequenciaVenda,     
		tbPlanejamentoProduto.DataUltimoInventario,           
		tbPlanejamentoProduto.DataUltimaVendaPerdida,         
		tbPlanejamentoProduto.QuantidadeObjetivoVenda,        
		tbPlanejamentoProduto.DataUltimaCompra,               
		tbPlanejamentoProduto.DataUltimoReajustePreco,
		tbClassificacaoFiscal.DescricaoClassificacaoFiscal,
		tbClassificacaoFiscal.PercIPIClassificacaoFiscal,
		tbClassificacaoFiscal.CodigoTributacaoDentroEstado AS 'CodigoCEST',
		tbClassificacaoFiscal.CodigoTributacaoForaEstado,
		tbClassificacaoFiscal.CodigoUnidadeDIPI,
		tbFonteFornecimento.CodigoEmpresa,                             
		tbFonteFornecimento.CodigoFonteFornecimento,                   
		tbFonteFornecimento.DescricaoFonteFornecimento,
		tbLinhaProduto.AbreviaturaLinhaProduto,
		tbLinhaProduto.DescricaoLinhaProduto,
		tbClassificacaoFiscal.TributaPIS,
		tbClassificacaoFiscal.PercPIS,
		tbClassificacaoFiscal.TributaCOFINS,
		tbClassificacaoFiscal.PercCOFINS
		
	
	FROM
	
		tbProdutoFT (NOLOCK)
	
		INNER JOIN tbProduto (NOLOCK) ON
		tbProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa AND
		tbProduto.CodigoProduto = tbProdutoFT.CodigoProduto
	
		INNER JOIN tbPlanejamentoProduto (NOLOCK) ON
		tbProdutoFT.CodigoEmpresa = tbPlanejamentoProduto.CodigoEmpresa AND
		tbProdutoFT.CodigoProduto = tbPlanejamentoProduto.CodigoProduto AND
		tbPlanejamentoProduto.CodigoLocal = @CodigoLocal
	
		INNER JOIN tbClassificacaoFiscal (NOLOCK) ON
		tbClassificacaoFiscal.CodigoEmpresa = @CodigoEmpresa AND
		tbClassificacaoFiscal.CodigoLocal = @CodigoLocal AND
		tbClassificacaoFiscal.CodigoClassificacaoFiscal = tbProduto.CodigoClassificacaoFiscal 
	
		INNER JOIN tbFonteFornecimento (NOLOCK) ON
		tbProdutoFT.CodigoEmpresa = tbFonteFornecimento.CodigoEmpresa AND
		tbProdutoFT.CodigoFonteFornecimento = tbFonteFornecimento.CodigoFonteFornecimento
	
	
		INNER JOIN tbLinhaProduto (NOLOCK) ON
		tbProdutoFT.CodigoEmpresa = tbLinhaProduto.CodigoEmpresa AND
		tbProdutoFT.CodigoLinhaProduto = tbLinhaProduto.CodigoLinhaProduto
	
	WHERE
	
		tbProdutoFT.CodigoEmpresa = @CodigoEmpresa AND
		tbProduto.CodigoEditadoProduto BETWEEN  @DoProduto AND @AteProduto AND
		tbProdutoFT.CodigoLinhaProduto between @DaLinha AND @AteLinha AND
		tbProdutoFT.CodigoFonteFornecimento between @DaFonteFornecimento AND @AteFonteFornecimento
 END

ELSE
	BEGIN
	
	SELECT
		tbProduto.CodigoEmpresa,                  
		tbProduto.CodigoProduto,                  
		tbProduto.DescricaoProduto,               
		tbProduto.CodigoClassificacaoFiscal,      
		tbProduto.CodigoEditadoProduto,
		tbProdutoFT.CodigoFormatadoProduto,         
		tbProdutoFT.CodigoBarrasProduto,            
		tbProdutoFT.EmbalagemComercialProduto,      
		tbProdutoFT.MarcaProduto,                   
		tbProdutoFT.DataCadastroProduto,            
		tbProdutoFT.PrecoReposicaoIndiceProduto,    
		tbProdutoFT.PesoLiquidoProduto,             
		tbProdutoFT.PesoBrutoProduto,               
		tbProdutoFT.CondicaoIPIProduto,             
		tbProdutoFT.CondicaoICMSProduto,            
		tbProdutoFT.CondicaoRedICMSProduto,         
		tbProdutoFT.FatorConversaoDIPIProduto,      
		tbProdutoFT.CodigoTributacaoProduto,        
		tbProdutoFT.PercRedBaseICMSProduto,         
		tbProdutoFT.PercentualImportacaoProduto,    
		tbProdutoFT.QuantidadeAntecessoresProduto,  
		tbProdutoFT.QuantidadeOpcionaisProduto,     
		tbProdutoFT.QuantidadeSucessoresProduto,    
		tbProdutoFT.QuantidadeOutrasFontesProduto,  
		tbProdutoFT.SubstituicaoTributariaProduto,  
		tbProdutoFT.EspecificacoesTecnicasProduto,  
		tbProdutoFT.CodigoCategoria,                
		tbProdutoFT.CodigoLinhaProduto,             
		tbProdutoFT.CodigoUnidadeProduto,           
		tbProdutoFT.CodigoFonteFornecimento,        
		tbProdutoFT.CodigoSituacaoTributaria,       
		tbPlanejamentoProduto.CodigoLocal,                    
		tbPlanejamentoProduto.VendaBloqueada,                 
		tbPlanejamentoProduto.SugestaoBloqueada,              
		tbPlanejamentoProduto.DataUltimaVenda,                
		tbPlanejamentoProduto.DataUltimaMovimentacao,         
		tbPlanejamentoProduto.FrequenciaVenda,                
		tbPlanejamentoProduto.DiasTempoReposicao,             
		tbPlanejamentoProduto.DiasRitmoAquisicao,             
		tbPlanejamentoProduto.DiasEstoqueMinimo,              
		tbPlanejamentoProduto.ConsumoMedioInformado,          
		tbPlanejamentoProduto.DataLimiteConsMedioInformado,   
		tbPlanejamentoProduto.ConsumoMedioCalculado,          
		tbPlanejamentoProduto.ConsumoMedioAnoAnterior,        
		tbPlanejamentoProduto.PontoPedidoCalculado,           
		tbPlanejamentoProduto.QuantidadeInventarios,          
		tbPlanejamentoProduto.PromocaoProduto,                
		tbPlanejamentoProduto.QuantidadeLimitePromocao,       
		tbPlanejamentoProduto.DataLimitePromocao,             
		tbPlanejamentoProduto.QuantidadeEstoqueMinimo,        
		tbPlanejamentoProduto.QuantidadeEstoqueMaximo,        
		tbPlanejamentoProduto.ClassifABCValorVenda,           
		tbPlanejamentoProduto.ClassifABCValorEstoque,         
		tbPlanejamentoProduto.ClassifABCValorCompras,         
		tbPlanejamentoProduto.ClassifABCValorReposicao,       
		tbPlanejamentoProduto.DataApurABCValorVenda,          
		tbPlanejamentoProduto.DataApurABCValorEstoque,        
		tbPlanejamentoProduto.DataApurABCValorCompras,        
		tbPlanejamentoProduto.DataApurABCValorReposicao,      
		tbPlanejamentoProduto.ClassifABCQuantidadeVenda,      
		tbPlanejamentoProduto.ClassifABCQuantidadeEstoque,    
		tbPlanejamentoProduto.ClassifABCQuantidadeCompras,    
		tbPlanejamentoProduto.ClassifABCFrequenciaVenda,      
		tbPlanejamentoProduto.DataApurABCQuantidadeVenda,     
		tbPlanejamentoProduto.DataApurABCQuantidadeEstoque,   
		tbPlanejamentoProduto.DataApurABCQuantidadeCompras,   
		tbPlanejamentoProduto.DataApurABCFrequenciaVenda,     
		tbPlanejamentoProduto.DataUltimoInventario,           
		tbPlanejamentoProduto.DataUltimaVendaPerdida,         
		tbPlanejamentoProduto.QuantidadeObjetivoVenda,        
		tbPlanejamentoProduto.DataUltimaCompra,               
		tbPlanejamentoProduto.DataUltimoReajustePreco,
		tbClassificacaoFiscal.DescricaoClassificacaoFiscal,
		tbClassificacaoFiscal.PercIPIClassificacaoFiscal,
		tbClassificacaoFiscal.CodigoTributacaoDentroEstado AS 'CodigoCEST',
		tbClassificacaoFiscal.CodigoTributacaoForaEstado,
		tbClassificacaoFiscal.CodigoUnidadeDIPI,
		tbFonteFornecimento.CodigoEmpresa,                             
		tbFonteFornecimento.CodigoFonteFornecimento,                   
		tbFonteFornecimento.DescricaoFonteFornecimento,
		tbLinhaProduto.AbreviaturaLinhaProduto,
		tbLinhaProduto.DescricaoLinhaProduto,
		tbClassificacaoFiscal.TributaPIS,
		tbClassificacaoFiscal.PercPIS,
		tbClassificacaoFiscal.TributaCOFINS,
		tbClassificacaoFiscal.PercCOFINS
	
	FROM
	
		tbProdutoFT (NOLOCK)
	
		INNER JOIN tbProduto (NOLOCK) ON
		tbProduto.CodigoEmpresa = tbProdutoFT.CodigoEmpresa AND
		tbProduto.CodigoProduto = tbProdutoFT.CodigoProduto
	
		INNER JOIN tbPlanejamentoProduto (NOLOCK) ON
		tbProdutoFT.CodigoEmpresa = tbPlanejamentoProduto.CodigoEmpresa AND
		tbProdutoFT.CodigoProduto = tbPlanejamentoProduto.CodigoProduto AND
		tbPlanejamentoProduto.CodigoLocal = @CodigoLocal
	
		INNER JOIN tbClassificacaoFiscal (NOLOCK) ON
		tbClassificacaoFiscal.CodigoEmpresa = @CodigoEmpresa AND
		tbClassificacaoFiscal.CodigoLocal = @CodigoLocal AND
		tbClassificacaoFiscal.CodigoClassificacaoFiscal = tbProduto.CodigoClassificacaoFiscal 
	
		INNER JOIN tbFonteFornecimento (NOLOCK) ON
		tbProdutoFT.CodigoEmpresa = tbFonteFornecimento.CodigoEmpresa AND
		tbProdutoFT.CodigoFonteFornecimento = tbFonteFornecimento.CodigoFonteFornecimento
	
	
		INNER JOIN tbLinhaProduto ON
		tbProdutoFT.CodigoEmpresa = tbLinhaProduto.CodigoEmpresa AND
		tbProdutoFT.CodigoLinhaProduto = tbLinhaProduto.CodigoLinhaProduto
	
	WHERE
	
		tbProdutoFT.CodigoEmpresa = @CodigoEmpresa AND
		tbProduto.CodigoEditadoProduto BETWEEN  @DoProduto AND @AteProduto AND
		tbProduto.DescricaoProduto between ISNULL(@DaDescProduto,tbProduto.DescricaoProduto) AND ISNULL(@AteDescProduto,tbProduto.DescricaoProduto) AND
		tbProdutoFT.CodigoFonteFornecimento between @DaFonteFornecimento AND @AteFonteFornecimento AND
		tbProdutoFT.CodigoLinhaProduto between @DaLinha AND @AteLinha

		ORDER BY tbProduto.DescricaoProduto
	 END
GO
GRANT EXECUTE ON dbo.whRelCEListaProdutos TO SQLUsers
GO
