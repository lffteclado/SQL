select	RegMovto.CodigoEmpresa,
		RegMovto.CodigoLocal,		
		RegMovto.NumeroDocumentoMovtoEstoque,
		RegMovto.DataMovtoEstoque,
		RegMovto.CodigoProduto,
		RegMovto.QuantidadeMovtoEstoque

			 from tbDocumento Doc

				INNER JOIN tbRegistroMovtoEstoque RegMovto
				On Doc.CodigoEmpresa = RegMovto.CodigoEmpresa
				And  Doc.CodigoLocal = RegMovto.CodigoLocal
				And  Doc.NumeroDocumento = RegMovto.NumeroDocumentoMovtoEstoque

				INNER JOIN tbItemDocumento ItDoc
				On Doc.CodigoEmpresa = ItDoc.CodigoEmpresa
				AND Doc.CodigoLocal = ItDoc.CodigoLocal
				AND Doc.NumeroDocumento = ItDoc.NumeroDocumento
				AND Doc.DataDocumento = ItDoc.DataDocumento
				AND Doc.EntradaSaidaDocumento = ItDoc.EntradaSaidaDocumento 
				And ItDoc.CodigoProduto = RegMovto.CodigoProduto

		where Doc.CodigoEmpresa = 3140
		AND Doc.CodigoLocal = 0
		AND RegMovto.CodigoProduto = '9 BZY'
		AND RegMovto.EntradaSaidaMovtoEstoque = 'S'
		AND RegMovto.CodigoAlmoxarifado  = 'V'
		AND Doc.CondicaoNFCancelada  = 'V'
		AND RegMovto.NumeroDocumentoMovtoEstoque not in (select CapFicha.NotaFiscalPecas from tbFichaControlePedidoCapa CapFicha
														where Doc.CodigoEmpresa = CapFicha.CodigoEmpresa
														AND Doc.CodigoLocal = CapFicha.CodigoLocal
														AND Doc.NumeroDocumento = CapFicha.NotaFiscalPecas
														AND Doc.DataDocumento = CapFicha.DataNotaFiscalPecas)

