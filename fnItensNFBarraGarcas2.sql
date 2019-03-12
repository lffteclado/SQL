IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('fnItensNFBarraGarcas'))
	DROP FUNCTION dbo.fnItensNFBarraGarcas
GO
CREATE FUNCTION dbo.fnItensNFBarraGarcas
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: NFSe - Barra do Garças
 AUTOR........: Edson Marson
 DATA.........: 06/04/2018
 UTILIZADO EM : whNFeBarraGarcas.sql e whRelNFSBarraGarcas
 OBJETIVO.....: Gerar Arquivo XML RPS(Recibo Provisório de Serviços) Municipal - Barra do Garças
 				Ticket 275844/2018

 SELECT dbo.fnItensNFBarraGarcas(1608, 0, 'S', 143191, '2014-07-18', 59104273001443, 7)
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

	(@CodigoEmpresa 			dtInteiro04,
	@CodigoLocal 				dtInteiro04,
	@EntradaSaidaDocumento		dtCharacter01,
	@NumeroDocumento			dtInteiro06,
	@DataDocumento  			DATETIME,
	@CodigoCliFor  				NUMERIC(14),
	@TipoLancamentoMovimentacao	NUMERIC(2))

RETURNS VARCHAR(8000)

AS
	
BEGIN
	
	DECLARE @curDescricaoMaoObraOS	VARCHAR(8000)
	DECLARE @DescricaoItens			VARCHAR(8000)
	DECLARE @MarcaFabricante		INTEGER
	DECLARE @CodigoServico			varchar(10)


	SELECT 
		@CodigoServico = COALESCE(ItemListaServico,'9999')
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
	AND tbItemDocumento.CodigoServicoISSItemDocto <> 0 

	SET @DescricaoItens = ''

	DECLARE curItensDocumento CURSOR READ_ONLY FOR
		SELECT
			'<servico>' +
				'<quantidade>' + '1' + '</quantidade>' +
				'<atividade>' +
					CASE WHEN RTRIM(LTRIM(COALESCE(tbItemDocumentoTextos.TextoItemDocumentoFT,''))) <> '' THEN
						RTRIM(LTRIM(COALESCE(tbItemDocumentoTextos.TextoItemDocumentoFT,'')))
					ELSE
						RTRIM(LTRIM(COALESCE(tbMaoObraOS.DescricaoMaoObraOS,'')))
					END +
				'</atividade>' +
				'<valor>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(tbItemDocumento.ValorBaseISSItemDocto,0))) + '</valor>' +
				'<deducao>' + '0.00' + '</deducao>' +
				'<codigoservico>' + @CodigoServico + '</codigoservico>' +
				--'<codigoservico>' + (	
				--						SELECT TOP 1 RTRIM(LTRIM(COALESCE(tbTipoServicoNFSE.CodigoTributacaoMunicipio,CONVERT(VARCHAR,tbItemDocumento.CodigoServicoISSItemDocto),'99.99'))) 
				--						FROM tbItemDocumento a (NOLOCK)

				--						LEFT JOIN tbTipoServicoNFSE (NOLOCK) ON
				--								  tbTipoServicoNFSE.CodigoEmpresa	= @CodigoEmpresa AND
				--								  tbTipoServicoNFSE.CodigoLocal		= @CodigoLocal AND
				--								  tbTipoServicoNFSE.CodigoServico	= a.CodigoServicoISSItemDocto 

				--						WHERE a.CodigoEmpresa				= @CodigoEmpresa
				--						AND	  a.CodigoLocal					= @CodigoLocal
				--						AND	  a.EntradaSaidaDocumento		= tbDocumentoFT.EntradaSaidaDocumento
				--						AND	  a.NumeroDocumento				= tbDocumentoFT.NumeroDocumento
				--						AND	  a.DataDocumento				= tbDocumentoFT.DataDocumento
				--						AND	  a.CodigoCliFor				= tbDocumentoFT.CodigoCliFor
				--						AND	  a.TipoLancamentoMovimentacao	= tbDocumentoFT.TipoLancamentoMovimentacao
				--						AND   a.CodigoServicoISSItemDocto	IS NOT NULL 
				--					) + 
				--'</codigoservico>' +
				'<aliquota>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(tbItemDocumento.PercentualISSItemDocto,0)/100)) + '</aliquota>' +
				'<inss>' + '0.00' + '</inss>' +
				'<total>' + CONVERT(VARCHAR(16),CONVERT(NUMERIC(16,2),COALESCE(tbItemDocumento.ValorBaseISSItemDocto,0))) + '</total>' + 
			'</servico>' 
		FROM tbItemDocumento (NOLOCK)

		INNER JOIN tbItemDocumentoTextos (NOLOCK) ON
			tbItemDocumentoTextos.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND
			tbItemDocumentoTextos.CodigoLocal = tbItemDocumento.CodigoLocal AND
			tbItemDocumentoTextos.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
			tbItemDocumentoTextos.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
			tbItemDocumentoTextos.DataDocumento = tbItemDocumento.DataDocumento AND
			tbItemDocumentoTextos.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			tbItemDocumentoTextos.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao AND
			tbItemDocumentoTextos.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento

		INNER JOIN tbDocumentoFT (NOLOCK) ON
			tbDocumentoFT.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND
			tbDocumentoFT.CodigoLocal = tbItemDocumento.CodigoLocal AND
			tbDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento AND
			tbDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento AND
			tbDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento AND
			tbDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor AND
			tbDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao

		LEFT JOIN tbTipoServicoNFSE (NOLOCK) ON
			tbTipoServicoNFSE.CodigoEmpresa = tbItemDocumento.CodigoEmpresa AND
			tbTipoServicoNFSE.CodigoLocal = tbItemDocumento.CodigoLocal AND
			tbTipoServicoNFSE.CodigoServico = tbItemDocumento.CodigoServicoISSItemDocto

		LEFT JOIN tbMaoObraOS (NOLOCK) ON
			tbItemDocumento.CodigoEmpresa = tbMaoObraOS.CodigoEmpresa AND
			tbItemDocumento.CodigoMaoObraOS = tbMaoObraOS.CodigoMaoObraOS

		WHERE tbItemDocumento.CodigoEmpresa = @CodigoEmpresa AND
			tbItemDocumento.CodigoLocal = @CodigoLocal AND
			tbItemDocumento.EntradaSaidaDocumento = @EntradaSaidaDocumento AND
			tbItemDocumento.DataDocumento = @DataDocumento AND
			tbItemDocumento.NumeroDocumento = @NumeroDocumento AND
			tbItemDocumento.TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao AND
			tbItemDocumento.CodigoCliFor = @CodigoCliFor
	
	OPEN curItensDocumento
	
	FETCH NEXT FROM curItensDocumento INTO @curDescricaoMaoObraOS
	WHILE (@@fetch_status <> -1)
	BEGIN
		
		IF @DescricaoItens = '' 
			SELECT @DescricaoItens = RTRIM(@curDescricaoMaoObraOS)
		ELSE
	 		SELECT @DescricaoItens = @DescricaoItens + ' ' + RTRIM(@curDescricaoMaoObraOS)
		
	FETCH NEXT FROM curItensDocumento INTO @curDescricaoMaoObraOS
	END
	
	CLOSE curItensDocumento
	DEALLOCATE curItensDocumento
	 
	RETURN  @DescricaoItens
END
GO
GRANT EXECUTE ON dbo.fnItensNFBarraGarcas TO SQLUsers
GO	 
