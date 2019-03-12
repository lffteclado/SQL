SELECT  A.CodigoEmpresa,
        A.CodigoLocal,
        B.NumeroSolicitacaoGarantiaOS,
	    A.CodigoProduto,
	    A.QuantidadePecaGarantia,
		C.DescricaoProduto,
		C.CodigoClassificacaoFiscal,  '' as 'ENPESG',
		'P' as TipoPeca,
		(D.PesoLiquidoProduto * A.QuantidadePecaGarantia) PesoLiquidoProduto,
		(D.PesoBrutoProduto * A.QuantidadePecaGarantia) PesoBrutoProduto,
		E.ValorTabelaPreco,
		F.ChassiVeiculoOS, 
		B.NumeroOROS  FROM    tbPecasGarantia A (NOLOCK)
			   
		INNER JOIN tbGarantia B (NOLOCK)  ON  A.CodigoEmpresa = B.CodigoEmpresa
		AND A.CodigoLocal   = B.CodigoLocal
		And A.FlagOROS      = B.FlagOROS
		And A.NumeroOROS    = B.NumeroOROS
		And A.CodigoCIT     = B.CodigoCIT
		
		INNER JOIN tbProduto C (NOLOCK)  ON  A.CodigoEmpresa = C.CodigoEmpresa
		AND A.CodigoProduto = C.CodigoProduto 
		
		INNER JOIN tbProdutoFT D (NOLOCK)  ON  C.CodigoEmpresa = D.CodigoEmpresa
		AND C.CodigoProduto = D.CodigoProduto
		
		INNER JOIN tbTabelaPreco E (NOLOCK)  ON  C.CodigoEmpresa = E.CodigoEmpresa
		AND C.CodigoProduto = E.CodigoProduto
		AND E.CodigoTipoTabelaPreco = 3
	    INNER JOIN tbOROS F (NOLOCK)  ON F.CodigoEmpresa = B.CodigoEmpresa
		AND F.CodigoLocal = B.CodigoLocal  AND F.FlagOROS = B.FlagOROS
		AND F.NumeroOROS = B.NumeroOROS
			
		WHERE A.CodigoEmpresa = 2890
		AND A.CodigoLocal = 0
		AND  B.NumeroSolicitacaoGarantiaOS  = 12828785
		AND B.NrPedidoNFS is null
		AND E.DataValidadeTabelaPreco = (SELECT MAX(DataValidadeTabelaPreco) FROM tbTabelaPreco WHERE CodigoEmpresa = C.CodigoEmpresa AND CodigoProduto = C.CodigoProduto AND CodigoTipoTabelaPreco = 3 AND DataValidadeTabelaPreco <= F.DataAberturaOS) ORDER BY DataValidadeTabelaPreco DESC





		select NrPedidoNFS, * from tbGarantia where NumeroSolicitacaoGarantiaOS  = 12835385

		--update tbGarantia set NrPedidoNFS = null where  NumeroSolicitacaoGarantiaOS  = 12835385