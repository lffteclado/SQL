IF exists (select * from sysobjects where name = 'whRelFichaVisitaAutomoveis') begin
	DROP PROCEDURE dbo.whRelFichaVisitaAutomoveis
END
go

CREATE PROCEDURE dbo.whRelFichaVisitaAutomoveis
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda.
 PROJETO......: Força de Vendas
 AUTOR.... ...: Paulo Henrique Mauri
 DATA.........: 20/10/2008
 UTILIZADO EM : Força de Vendas - Automóveis
 OBJETIVO.....: Ficha de Visita Automóveis

 whRelFichaVisitaAutomoveis 1608, 0, 2, 'E', 1431589888 , 9 
 whRelFichaVisitaAutomoveis 1608, 0, 5,'P',8154,5
 whRelFichaVisitaAutomoveis 1608, 0, 22,'P',8159, 1 
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/
	@CodigoEmpresa		numeric(4),
   	@CodigoLocal 		numeric(4),
	@NumeroFichaContato	numeric(6),
	@TipoCliente		char(1),    --------> (E)fetivo/(P)otencial
	@DoCliente			numeric(14),
	@DoRepresentante		numeric(4)
AS 

   SET NOCOUNT ON

------ Carrega temporaria Veiculos de Interesse
   SELECT tbFichaContatoVeicInteresse.* INTO #tmpFichaContatoVeicInteresse 
   FROM tbFichaContatoVeicInteresse (NOLOCK)
   LEFT JOIN tbFichaContato (NOLOCK)
   ON	 tbFichaContato.CodigoEmpresa = tbFichaContatoVeicInteresse.CodigoEmpresa
   AND tbFichaContato.CodigoLocal = tbFichaContatoVeicInteresse.CodigoLocal
   AND tbFichaContato.NumeroFichaContato = tbFichaContatoVeicInteresse.NumeroFichaContato
   WHERE tbFichaContatoVeicInteresse.CodigoEmpresa = @CodigoEmpresa
	AND tbFichaContatoVeicInteresse.CodigoLocal = @CodigoLocal
	AND tbFichaContatoVeicInteresse.NumeroFichaContato = @NumeroFichaContato

------ Carrega temporaria Veiculos que Possui
   SELECT tbClientePFVeicStarClass.* INTO #tmpClientePFVeicStarClass
   FROM tbClientePFVeicStarClass (NOLOCK)
   INNER JOIN tbFichaContato (NOLOCK)
   ON 	tbClientePFVeicStarClass.CodigoEmpresa = tbFichaContato.CodigoEmpresa
   AND 	tbClientePFVeicStarClass.CodigoClientePF = tbFichaContato.CodigoClientePF
   WHERE tbClientePFVeicStarClass.CodigoEmpresa = @CodigoEmpresa
	AND tbFichaContato.NumeroFichaContato = @NumeroFichaContato

------ Carrega temporaria Historico Contato
   SELECT TOP 5 tbFichaContatoHistorico.* , tbPropensaoCompraST.DescrPropCompra, tbObjetivoProspeccao.DescricaoObjetivoProspeccao 
	INTO #tmpHistoricoContatoDaniel
   FROM tbFichaContatoHistorico (NOLOCK)
   INNER JOIN tbPropensaoCompraST (NOLOCK)
   ON	  tbPropensaoCompraST.CodigoEmpresa = tbFichaContatoHistorico.CodigoEmpresa
   AND  tbPropensaoCompraST.CodigoLocal = tbFichaContatoHistorico.CodigoLocal
   AND  tbPropensaoCompraST.PropensaoCompra = tbFichaContatoHistorico.PropensaoCompra
   INNER JOIN tbObjetivoProspeccao (NOLOCK)
   ON	tbObjetivoProspeccao.CodigoObjetivoProspeccao = tbFichaContatoHistorico.CodigoObjetivoProspeccao
   WHERE tbFichaContatoHistorico.CodigoEmpresa = @CodigoEmpresa
	AND tbFichaContatoHistorico.CodigoLocal = @CodigoLocal
	AND tbFichaContatoHistorico.NumeroFichaContato = @NumeroFichaContato
   ORDER BY tbFichaContatoHistorico.ItemContatoHistorico desc
 
	SELECT * INTO #tmpHistoricoContato FROM #tmpHistoricoContatoDaniel 
	ORDER BY ItemContatoHistorico ASC
	
------ Carrega temporaria Midia Atracao
   SELECT tbFichaContatoMidiaAtracao.*, tbMidia.DescricaoMidia INTO #tmpMidiaAtracao
   FROM tbFichaContatoMidiaAtracao (NOLOCK)
   INNER JOIN tbMidia (NOLOCK) 
   ON tbMidia.CodigoMidia = tbFichaContatoMidiaAtracao.CodigoMidia
   WHERE tbFichaContatoMidiaAtracao.CodigoEmpresa = @CodigoEmpresa
	AND tbFichaContatoMidiaAtracao.CodigoLocal = @CodigoLocal
	AND tbFichaContatoMidiaAtracao.NumeroFichaContato = @NumeroFichaContato

-------- Montagem da Ficha
   SELECT DISTINCT
	tbFichaContato.NumeroFichaContato,
	tbFichaContato.CodigoRepresentante,
	tbRepresentanteComplementar.NomeRepresentante,
	--- case para pessoa Fisica ou Juridica, seja Efetivo ou Potencial
	CASE WHEN tbFichaContato.CodigoClientePF IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliFor.NomeCliFor
		ELSE
			tbClientePotencial.RazaoSocialClientePotencial
		END
	ELSE
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			tbCliFor.NomeCliFor
		ELSE
			tbClientePotencial.RazaoSocialClientePotencial
		END
	END AS Cliente,
	CASE WHEN tbFichaContato.CodigoClientePF IS NOT NULL THEN
		'X'
	END AS PessoaFisica,
	CASE WHEN tbFichaContato.CodigoClientePJ IS NOT NULL THEN
		'X'
	END AS PessoaJuridica,
----- Veiculo de Interesse 1
	(SELECT TOP 1 COALESCE(ModeloVeiculo,'') FROM #tmpFichaContatoVeicInteresse) AS VeicInterMod1,		
	(SELECT TOP 1 COALESCE(PrecoVeiculo,'') FROM #tmpFichaContatoVeicInteresse) AS VeicInterPrec1,
	CASE WHEN (SELECT TOP 1 ZeroKM FROM #tmpFichaContatoVeicInteresse) = 'V' THEN 'X' ELSE '' END AS VeicInterZeroKM1,
	CASE WHEN (SELECT TOP 1 ZeroKM FROM #tmpFichaContatoVeicInteresse) = 'F' THEN 'X' ELSE '' END AS VeicInterSemi1 ,
----- Veiculo de Interesse 2 
	(SELECT TOP 1 COALESCE(ModeloVeiculo,'')
	 FROM #tmpFichaContatoVeicInteresse 
       WHERE #tmpFichaContatoVeicInteresse.ItemFichaContatoVeiculo > (SELECT MIN(tempVeicInt.ItemFichaContatoVeiculo) 
												FROM #tmpFichaContatoVeicInteresse tempVeicInt
												WHERE tempVeicInt.ItemFichaContatoVeiculo <> #tmpFichaContatoVeicInteresse.ItemFichaContatoVeiculo)) AS VeicInterMod2,
	(SELECT TOP 1 COALESCE(PrecoVeiculo,'') 
	  FROM #tmpFichaContatoVeicInteresse 
	  WHERE #tmpFichaContatoVeicInteresse.ItemFichaContatoVeiculo > (SELECT MIN(tempVeicInt.ItemFichaContatoVeiculo)
												FROM #tmpFichaContatoVeicInteresse tempVeicInt 
												WHERE tempVeicInt.ItemFichaContatoVeiculo <> #tmpFichaContatoVeicInteresse.ItemFichaContatoVeiculo)) AS VeicInterPrec2,
	CASE WHEN (SELECT TOP 1 ZeroKM 
			FROM #tmpFichaContatoVeicInteresse 
			WHERE #tmpFichaContatoVeicInteresse.ItemFichaContatoVeiculo > (SELECT MIN(tempVeicInt.ItemFichaContatoVeiculo)
													   FROM #tmpFichaContatoVeicInteresse tempVeicInt
													   WHERE tempVeicInt.ItemFichaContatoVeiculo <> #tmpFichaContatoVeicInteresse.ItemFichaContatoVeiculo)) = 'V' THEN 'X' ELSE '' END AS VeicInterZeroKM2,
	CASE WHEN (SELECT TOP 1 ZeroKM 
		     FROM #tmpFichaContatoVeicInteresse 
		     WHERE #tmpFichaContatoVeicInteresse.ItemFichaContatoVeiculo > (SELECT MIN(tempVeicInt.ItemFichaContatoVeiculo) 
													 FROM #tmpFichaContatoVeicInteresse tempVeicInt
												 	 WHERE tempVeicInt.ItemFichaContatoVeiculo <> #tmpFichaContatoVeicInteresse.ItemFichaContatoVeiculo)) = 'F' THEN 'X' ELSE '' END AS VeicInterSemi2,
----- Veiculo que Possui 1
	CASE WHEN tbFichaContato.CodigoClientePF IS NOT NULL THEN
				(SELECT TOP 1 COALESCE(ModeloVeiculo,'') FROM #tmpClientePFVeicStarClass)
			  ELSE '' END AS VeicPossui1,
	CASE WHEN tbFichaContato.CodigoClientePF IS NOT NULL THEN
			(SELECT TOP 1 COALESCE(CONVERT(VARCHAR(5),#tmpClientePFVeicStarClass.AnoFabricacaoVeiculo),'') 
						+ ' ' + COALESCE(CONVERT(VARCHAR(5),#tmpClientePFVeicStarClass.AnoModeloVeiculo),'')
					FROM #tmpClientePFVeicStarClass)
			  ELSE '' END AS VeicPossui1Ano,
	CASE WHEN tbFichaContato.CodigoClientePF IS NOT NULL THEN
			(SELECT TOP 1 COALESCE(PrecoVeiculo,'') FROM #tmpClientePFVeicStarClass)
		ELSE '' END AS VeicPossuiPreco1,
----- Veiculo que Possui 2
	CASE WHEN tbFichaContato.CodigoClientePF IS NOT NULL THEN
		(SELECT TOP 1 COALESCE(ModeloVeiculo,'') 
				   FROM #tmpClientePFVeicStarClass
				   WHERE #tmpClientePFVeicStarClass.ItemSequencia > (SELECT MIN(tmpCliVeic.ItemSequencia) 
													FROM #tmpClientePFVeicStarClass tmpCliVeic
													WHERE tmpCliVeic.ItemSequencia <> #tmpClientePFVeicStarClass.ItemSequencia)) 
	  ELSE '' END AS VeicPossui2 ,
	CASE WHEN tbFichaContato.CodigoClientePF IS NOT NULL THEN
			(SELECT TOP 1 COALESCE(CONVERT(VARCHAR(5),#tmpClientePFVeicStarClass.AnoFabricacaoVeiculo),'') 
						+ ' ' + COALESCE(CONVERT(VARCHAR(5),#tmpClientePFVeicStarClass.AnoModeloVeiculo),'')
				   FROM #tmpClientePFVeicStarClass
				   WHERE #tmpClientePFVeicStarClass.ItemSequencia > (SELECT MIN(tmpCliVeic.ItemSequencia) 
													FROM #tmpClientePFVeicStarClass tmpCliVeic
													WHERE tmpCliVeic.ItemSequencia <> #tmpClientePFVeicStarClass.ItemSequencia))
			     ELSE '' END AS VeicPossuiAno2 ,
	CASE WHEN tbFichaContato.CodigoClientePF IS NOT NULL THEN
		(SELECT TOP 1 COALESCE(PrecoVeiculo,'')
			   FROM #tmpClientePFVeicStarClass
			   WHERE #tmpClientePFVeicStarClass.ItemSequencia > (SELECT MIN(tmpCliVeic.ItemSequencia) 
												FROM #tmpClientePFVeicStarClass tmpCliVeic
												WHERE tmpCliVeic.ItemSequencia <> #tmpClientePFVeicStarClass.ItemSequencia))
	ELSE '' END AS VeicPossuiPreco2,

/*
-----Empresa
	CASE WHEN tbFichaContato.CodigoClientePF IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliFor.NomeCliFor
		ELSE
			tbClientePotencial.RazaoSocialClientePotencial
		END
	ELSE
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			tbCliFor.NomeCliFor
		ELSE
			tbClientePotencial.RazaoSocialClientePotencial
		END
	END AS Empresa,
*/

-----Empresa
	CASE WHEN tbFichaContato.CodigoClientePJ IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			tbCliForJ.NomeCliFor	--tbCliFor.NomeCliFor
		ELSE
			tbClientePotencial.RazaoSocialClientePotencial
		END
	else ''
	END AS Empresa,


----- CNPJ OU CPF
	CASE WHEN tbFichaContato.CodigoClientePF IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliForFisica.CPFFisica
		ELSE
			tbClientePotencial.CGCCPFClientePotencial
		END
	ELSE
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			tbCliForJuridica.CGCJuridica
		ELSE
			tbClientePotencial.CGCCPFClientePotencial
		END
	END AS CNPJCPF,
----- Rua
	CASE WHEN tbFichaContato.CodigoClientePF IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliFor.RuaCliFor
		ELSE
			tbClientePotencial.RuaClientePotencial
		END
	ELSE
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			tbCliFor.RuaCliFor
		ELSE
			tbClientePotencial.RuaClientePotencial
		END
	END AS Endereco,
----- Bairro
	CASE WHEN tbFichaContato.CodigoClientePF IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliFor.BairroCliFor
		ELSE
			tbClientePotencial.BairroClientePotencial
		END
	ELSE
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			tbCliFor.BairroCliFor
		ELSE
			tbClientePotencial.BairroClientePotencial
		END
	END AS Bairro,
----- Cidade
	CASE WHEN tbFichaContato.CodigoClientePF IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliFor.MunicipioCliFor
		ELSE
			tbClientePotencial.MunicipioClientePotencial
		END
	ELSE
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			tbCliFor.MunicipioCliFor
		ELSE
			tbClientePotencial.MunicipioClientePotencial
		END
	END AS Municipio,
----- UF
	CASE WHEN tbFichaContato.CodigoClientePF IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliFor.UFCliFor
		ELSE
			tbClientePotencial.UnidadeFederacao
		END
	ELSE
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			tbCliFor.UFCliFor
		ELSE
			tbClientePotencial.UnidadeFederacao
		END
	END AS UF,
------------Dados dos Contato se PJ ou PF
	CASE WHEN tbFichaContato.CodigoClientePJ IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			''
		ELSE
			''
		END
	ELSE '' END AS ContatoPJ,
------Cargo	
	CASE WHEN tbFichaContato.CodigoClientePJ IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			tbCliFor.FuncaoContatoCliFor
		ELSE
			''
		END
	ELSE 
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliFor.FuncaoContatoCliFor
		ELSE
			''
		END 
	END AS Cargo,
---------Estado Civil
	CASE WHEN tbFichaContato.CodigoClientePJ IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			''	
		ELSE
			''
		END
	ELSE 
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliForFisica.EstadoCivilPessoaFisica
		ELSE
			tbClientePotencial.EstadoCivilClientePotencial
		END
	END AS EstadoCivil,
-------- Aniversario
	CASE WHEN tbFichaContato.CodigoClientePF IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliForFisica.DataNascimentoFisica
		ELSE
			tbClientePotencial.DtNascClientePotencial
		END
	ELSE 
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliForFisica.DataNascimentoFisica
		ELSE
			tbClientePotencial.DtNascClientePotencial
		END
	END AS Aniversario,
------Time Futebol
	CASE WHEN tbFichaContato.CodigoClientePJ IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			tbClienteEntrevistaConsult.TimeFutebol
		ELSE
			tbClienteEntrevistaConsult.TimeFutebol
		END
	ELSE 
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbClienteEntrevistaConsult.TimeFutebol
		ELSE
			tbClienteEntrevistaConsult.TimeFutebol
		END
	END AS TimeFutebol,
------ DDD Fone resid
	CASE WHEN tbFichaContato.CodigoClientePJ IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			''
		ELSE
			''
		END
	ELSE 
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliFor.DDDTelefoneCliFor
		ELSE
			tbClientePotencial.DDDFoneResidenciaClientePot
		END
	END AS DDDFoneResid,
----- Fone resid	
	CASE WHEN tbFichaContato.CodigoClientePJ IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			''	
		ELSE
			''
		END
	ELSE 
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliFor.TelefoneCliFor
		ELSE
			tbClientePotencial.FoneResidenciaClientePot
		END
	END AS FoneResid,
----- DDD Fone Comercial
	CASE WHEN tbFichaContato.CodigoClientePJ IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			''	
		ELSE
			''
		END
	ELSE 
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliForFisica.DDDComercialFisica
		ELSE
			tbClientePotencial.DDDFoneComercialClientePot
		END
	END AS DDDFoneComercial,
----- Fone Comercial
	CASE WHEN tbFichaContato.CodigoClientePJ IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			''	
		ELSE
			''
		END
	ELSE 
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliForFisica.TelefoneComercialFisica
		ELSE
			tbClientePotencial.FoneComercialClientePot
		END
	END AS FoneComercial,
----- DDD Fone Cel
	CASE WHEN tbFichaContato.CodigoClientePJ IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			''
		ELSE
			''
		END
	ELSE 
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliFor.DDDCelularCliFor
		ELSE
			tbClientePotencial.DDDCelularClientePotencial
		END
	END AS DDDCelular,
----- Fone Cel
	CASE WHEN tbFichaContato.CodigoClientePJ IS NOT NULL THEN
		CASE WHEN tbFichaContato.TipoClientePJ = 'E' THEN
			''
		ELSE
			''
		END
	ELSE 
		CASE WHEN tbFichaContato.TipoClientePF = 'E' THEN
			tbCliFor.CelularCliFor
		ELSE
			tbClientePotencial.FoneCelularClientePotencial
		END
	END AS Celular,
----- PROSPECÇAO
	'X' AS OutrosObjetivosProspX,
	COALESCE(tbObjetivoProspeccao.DescricaoObjetivoProspeccao,'') AS DescricaoObjetivoProspeccao,
	CASE tbObjetivoProspeccao.DescricaoObjetivoProspeccao 
		WHEN 'Outro' THEN
			'X'
		WHEN 'OUTRO' THEN
			'X'
		ELSE ''
		END AS Outros,
	tbFichaContato.ProspeccaoObservacoes,
	COALESCE(tbFichaContato.ProspeccaoFormaContato,'') AS ProspeccaoFormaContato,
	AgendadoVisitaSIM = CASE WHEN (tbFichaContato.ProspeccaoAgendouVisita) = 'V' THEN 'X' ELSE '' END,
	AgendadoVisitaNAO = CASE WHEN (tbFichaContato.ProspeccaoAgendouVisita) = 'F' THEN 'X' ELSE '' END,
	AgendadoTestDriveSIM = CASE WHEN tbFichaContato.TestDriveAgendado = 'V' THEN 'X' ELSE '' END,
	AgendadoTestDriveNAO = CASE WHEN tbFichaContato.TestDriveAgendado = 'F' THEN 'X' ELSE '' END,
----- Propensao de Compra
--	BOLSAO
	CASE WHEN (SELECT TOP 1 (DescrPropCompra) FROM #tmpHistoricoContato 
			 WHERE #tmpHistoricoContato.DataContatoHistorico = (SELECT MAX(tmpHist.DataContatoHistorico) 
										FROM #tmpHistoricoContato tmpHist
										WHERE tmpHist.ItemContatoHistorico = #tmpHistoricoContato.ItemContatoHistorico)) = 'BOLSAO' THEN 'X' ELSE '' END AS PropBolsao,
--	FRIO
	CASE WHEN (SELECT TOP 1 (DescrPropCompra) FROM #tmpHistoricoContato 
			 WHERE #tmpHistoricoContato.DataContatoHistorico = (SELECT MAX(tmpHist.DataContatoHistorico) 
										FROM #tmpHistoricoContato tmpHist
										WHERE tmpHist.ItemContatoHistorico = #tmpHistoricoContato.ItemContatoHistorico)) = 'FRIO' THEN 'X' ELSE '' END AS PropFrio,
--	MORNO
	CASE WHEN (SELECT TOP 1 (DescrPropCompra) FROM #tmpHistoricoContato 
			 WHERE #tmpHistoricoContato.DataContatoHistorico = (SELECT MAX(tmpHist.DataContatoHistorico) 
										FROM #tmpHistoricoContato tmpHist
										WHERE tmpHist.ItemContatoHistorico = #tmpHistoricoContato.ItemContatoHistorico)) = 'MORNO' THEN 'X' ELSE '' END AS PropMorno,
--	QUENTE
	CASE WHEN (SELECT TOP 1 (DescrPropCompra) FROM #tmpHistoricoContato 
			 WHERE #tmpHistoricoContato.DataContatoHistorico = (SELECT MAX(tmpHist.DataContatoHistorico) 
										FROM #tmpHistoricoContato tmpHist
										WHERE tmpHist.ItemContatoHistorico = #tmpHistoricoContato.ItemContatoHistorico)) = 'QUENTE' THEN 'X' ELSE '' END AS PropQuente,
--	SUPERQUENTE
	CASE WHEN (SELECT TOP 1 (DescrPropCompra) FROM #tmpHistoricoContato 
			 WHERE #tmpHistoricoContato.DataContatoHistorico = (SELECT MAX(tmpHist.DataContatoHistorico) 
										FROM #tmpHistoricoContato tmpHist
										WHERE tmpHist.ItemContatoHistorico = #tmpHistoricoContato.ItemContatoHistorico)) = 'SUPERQUENTE' THEN 'X' ELSE '' END AS PropSupQuente,
----- Recepcao
	tbFichaContato.RecepcaoDataHora AS DataAtendimento,
	tbFichaContato.RecepcaoRetornoDataHora AS RecepcaoRetornoDataHora,

	HoraAtendimento = CASE WHEN DATEPART(hh ,tbFichaContato.RecepcaoDataHora) = 0 THEN '' 
				ELSE CONVERT(CHAR(2),DATEPART(hh ,tbFichaContato.RecepcaoDataHora)) + ':' + CONVERT(CHAR(2),DATEPART(mi ,tbFichaContato.RecepcaoDataHora)) END,

	HoraProxAtendimento = CASE WHEN DATEPART(hh ,tbFichaContato.RecepcaoRetornoDataHora) = 0 THEN '' 
					ELSE CONVERT(CHAR(2),DATEPART(hh ,tbFichaContato.RecepcaoRetornoDataHora)) + ':' + CONVERT(CHAR(2),DATEPART(mi ,tbFichaContato.RecepcaoRetornoDataHora)) END,

	CASE WHEN (SELECT COUNT(ItemContatoHistorico) FROM #tmpHistoricoContato ) = 1 THEN
				'X' ELSE '' END AS PrimContato, 
	CASE WHEN (SELECT COUNT(ItemContatoHistorico) FROM #tmpHistoricoContato ) > 1 THEN
				'X' ELSE '' END AS ContiContato,

	OrigContatoShowRomm = CASE WHEN tbFichaContato.RecepcaoOrigemContato = 'VISITA SHOWROOM' THEN 'X' 
				WHEN tbFichaContato.RecepcaoOrigemContato = 'EVENTO' THEN 'X' ELSE '' END,
	OrigContatoEmail = CASE WHEN tbFichaContato.RecepcaoOrigemContato = 'E-MAIL' THEN 'X' ELSE '' END,
	OrigContatoTelefone = CASE WHEN tbFichaContato.RecepcaoOrigemContato = 'TELEFONE' THEN 'X' ELSE '' END,
	RecepcaoInformExtras = CASE WHEN tbFichaContato.RecepcaoOrigemContato = 'EVENTO' THEN 'CONTATO REALIZADO EM EVENTO - ' + COALESCE(tbFichaContato.RecepcaoInformExtras,'')
				ELSE COALESCE(tbFichaContato.RecepcaoInformExtras,'') END,

-----MidiaAtracao
	MidiaAtracao = (SELECT TOP 1 (DescricaoMidia) FROM #tmpMidiaAtracao WHERE DataAtualizacao = (SELECT MAX(DataAtualizacao) FROM #tmpMidiaAtracao)),

----- EntrevistaConsultiva 
----- Principal Condutor
	PrinpCondProprioComp = CASE WHEN tbClienteEntrevistaConsult.PrincipalCondutorProprio = 'V' THEN 'X' ELSE '' END,
	PrinpCondMarido = CASE WHEN tbClienteEntrevistaConsult.PrincipalCondutorMarido = 'V' THEN 'X' ELSE '' END,
	PrinpCondEsposa = CASE WHEN tbClienteEntrevistaConsult.PrincipalCondutorEsposa = 'V' THEN 'X' ELSE '' END,
	PrinpCondFilho = CASE WHEN tbClienteEntrevistaConsult.PrincipalCondutorFilho = 'V' THEN 'X' ELSE '' END,
	PrinpCondFunc = CASE WHEN tbClienteEntrevistaConsult.PrincipalCondutorFuncionario = 'V' THEN 'X' ELSE '' END,
	PrinpCondOutros = CASE WHEN tbClienteEntrevistaConsult.PrincipalCondutorOutros = 'V' THEN 'X' ELSE '' END,
	PrincipaisAtividades = COALESCE(tbClienteEntrevistaConsult.PrincipaisAtividades,''),
	HobbiesGostos = COALESCE(tbClienteEntrevistaConsult.HobbiesGostos,''),
------ Veic mais utilizado
	VeicUtiLazer = CASE WHEN tbClienteEntrevistaConsult.VeiculoUtilizadoLazer = 'V' THEN 'X' ELSE '' END,
	VeicUtiTrabalho = CASE WHEN tbClienteEntrevistaConsult.VeiculoUtilizadoTrabalho = 'V' THEN 'X' ELSE '' END,
	VeicUtiViagem = CASE WHEN tbClienteEntrevistaConsult.VeiculoUtilizadoViagens = 'V' THEN 'X' ELSE '' END,
	VeicUtiEsporadico = CASE WHEN tbClienteEntrevistaConsult.VeiculoUtilizadoUsoEsporadico = 'V' THEN 'X' ELSE '' END,
	VeicUtiOutros = CASE WHEN tbClienteEntrevistaConsult.VeiculoUtilizadoOutros = 'V' THEN 'X' ELSE '' END,
	VeiculoUtilizadoOutrosDescricao = COALESCE(tbClienteEntrevistaConsult.VeiculoUtilizadoOutrosDescricao,''),
------ Tipo Veic Preferido
	TipoVeicSedan = CASE WHEN tbClienteEntrevistaConsult.TipoVeicPreferidoSedan = 'V' THEN 'X' ELSE '' END,
	TipoVeicAMG = CASE WHEN tbClienteEntrevistaConsult.TipoVeicPreferidoAMG = 'V' THEN 'X' ELSE '' END,
	TipoVeicPreferidoAllroad = CASE WHEN tbClienteEntrevistaConsult.TipoVeicPreferidoAllroad = 'V' THEN 'X' ELSE '' END,
	TipoVeicPreferidoRoadster = CASE WHEN tbClienteEntrevistaConsult.TipoVeicPreferidoRoadster = 'V' THEN 'X' ELSE '' END,
	TipoVeicPreferidoCoupe = CASE WHEN tbClienteEntrevistaConsult.TipoVeicPreferidoCoupe = 'V' THEN 'X' ELSE '' END,
	TipoVeicPreferidoSportourer = CASE WHEN tbClienteEntrevistaConsult.TipoVeicPreferidoSportourer = 'V' THEN 'X' ELSE '' END,
------ Midia Mais utilizadas
	MidiasMaisUtilizadasTV = CASE WHEN tbClienteEntrevistaConsult.MidiasMaisUtilizadasTV = 'V' THEN 'X' ELSE '' END,
	MidiasMaisUtilizadasInternet = CASE WHEN tbClienteEntrevistaConsult.MidiasMaisUtilizadasInternet = 'V' THEN 'X' ELSE '' END,
	MidiasMaisUtilizadasRevistas = CASE WHEN tbClienteEntrevistaConsult.MidiasMaisUtilizadasRevistas = 'V' THEN 'X' ELSE '' END,
	MidiasMaisUtilizadasJornais = CASE WHEN tbClienteEntrevistaConsult.MidiasMaisUtilizadasJornais = 'V' THEN 'X' ELSE '' END,
	MidiasMaisUtilizadasRadio = CASE WHEN tbClienteEntrevistaConsult.MidiasMaisUtilizadasRadio = 'V' THEN 'X' ELSE '' END,
	MidiasMaisUtilizadasOutros = CASE WHEN tbClienteEntrevistaConsult.MidiasMaisUtilizadasOutros = 'V' THEN 'X' ELSE '' END,
	MidiasMaisUtilizadasOutrosDescricao = COALESCE(tbClienteEntrevistaConsult.MidiasMaisUtilizadasOutrosDescricao,''),
----- Atributos Mais Valorizados
	AtributosValorizaDesempenho = CASE WHEN tbClienteEntrevistaConsult.AtributosValorizaDesempenho IS NOT NULL THEN '( ' + tbClienteEntrevistaConsult.AtributosValorizaDesempenho + ' )' ELSE '(  )' END,
	AtributosValorizaConforto = CASE WHEN tbClienteEntrevistaConsult.AtributosValorizaConforto IS NOT NULL THEN '( ' + tbClienteEntrevistaConsult.AtributosValorizaConforto + ' )'  ELSE '(  )' END,
	AtributosValorizaEstilo = CASE WHEN tbClienteEntrevistaConsult.AtributosValorizaEstilo IS NOT NULL THEN '( ' + tbClienteEntrevistaConsult.AtributosValorizaEstilo + ' )' ELSE '(  )' END,
	AtributosValorizaDesign = CASE WHEN tbClienteEntrevistaConsult.AtributosValorizaDesign IS NOT NULL THEN '( ' + tbClienteEntrevistaConsult.AtributosValorizaDesign + ' )' ELSE '(  )' END,
	AtributosValorizaSeguranca = CASE WHEN tbClienteEntrevistaConsult.AtributosValorizaSeguranca IS NOT NULL THEN '( ' + tbClienteEntrevistaConsult.AtributosValorizaSeguranca + ' )' ELSE '(  )' END,
	AtributosValorizaPreco = CASE WHEN tbClienteEntrevistaConsult.AtributosValorizaPreco IS NOT NULL THEN '( ' + tbClienteEntrevistaConsult.AtributosValorizaPreco + ' )' ELSE '(  )' END,
	AtributosValorizaOutros = CASE WHEN tbClienteEntrevistaConsult.AtributosValorizaOutros IS NOT NULL THEN '( ' + tbClienteEntrevistaConsult.AtributosValorizaOutros + ' )' ELSE '(  )' END,
	AtributosValorizaoutrosDescricao = COALESCE(tbClienteEntrevistaConsult.AtributosValorizaoutrosDescricao,''),
	ObservacoesEntrevistaConsultiva = COALESCE(tbClienteEntrevistaConsult.ObservacoesEntrevistaConsultiva,''),
----- TEST DRIVE
	TestDriveAgendadoSIM = CASE WHEN tbFichaContato.TestDriveAgendado = 'V' THEN 'X' ELSE '' END,
	TestDriveAgendadoNAO = CASE WHEN tbFichaContato.TestDriveAgendado = 'F' THEN 'X' ELSE '' END,
	TestDriveAgendadoDataHora = CASE WHEN tbFichaContato.TestDriveAgendadoDataHora IS NOT NULL THEN tbFichaContato.TestDriveAgendadoDataHora END,
	TestDriveRealizadoSIM = CASE WHEN tbFichaContato.TestDriveRealizado = 'V' THEN 'X' ELSE '' END,
	TestDriveRealizadoNAO = CASE WHEN tbFichaContato.TestDriveRealizado = 'F' THEN 'X' ELSE '' END,
	TestDriveRealizadoDataHora = CASE WHEN tbFichaContato.TestDriveRealizadoDataHora IS NOT NULL THEN tbFichaContato.TestDriveRealizadoDataHora END,
	TestDriveObservacoes = COALESCE(tbFichaContato.TestDriveObservacoes,''),
----- NEGOCIACAO
	NegociacaoIniciadaSIM = CASE WHEN tbFichaContato.NegociacaoIniciadaFichaContato = 'V' THEN 'X' ELSE '' END,
	NegociacaoIniciadaNAO = CASE WHEN tbFichaContato.NegociacaoIniciadaFichaContato = 'F' THEN 'X' ELSE '' END,
	NegociacaoIniciadaDataHora = CASE WHEN tbFichaContato.NegociacaoIniciadaDataHora IS NOT NULL THEN tbFichaContato.NegociacaoIniciadaDataHora END,
	NegociacaoFechadaFichaContatoSIM = CASE WHEN tbFichaContato.NegociacaoFechadaFichaContato = 'V' THEN 'X' ELSE '' END,
	NegociacaoFechadaFichaContatoNAO = CASE WHEN tbFichaContato.NegociacaoFechadaFichaContato = 'F' THEN 'X' ELSE '' END,
	NegociacaoFechadaDataHora = CASE WHEN tbFichaContato.NegociacaoFechadaDataHora IS NOT NULL THEN tbFichaContato.NegociacaoFechadaDataHora END,
	VendaPerdida = COALESCE(tbMotivoVendaPerdida.DescricaoVendaPerdida,''),  ---- tbMotivoVendaPerdida
	NegociacaoObservacoes = COALESCE(tbFichaContato.NegociacaoObservacoes,''),
----- Entrega
	EntregaAgendadaFichaContatoSIM = CASE WHEN tbFichaContato.EntregaAgendadaFichaContato = 'V' THEN 'X' ELSE '' END,
	EntregaAgendadaFichaContatoNAO = CASE WHEN tbFichaContato.EntregaAgendadaFichaContato = 'F' THEN 'X' ELSE '' END,
	EntregaAgendadaDataHoraFichaContato = CASE WHEN tbFichaContato.EntregaAgendadaDataHoraFichaContato IS NOT NULL THEN tbFichaContato.EntregaAgendadaDataHoraFichaContato END,
	EntregaRealizadaFichaContatoSIM = CASE WHEN tbFichaContato.EntregaRealizadaFichaContato = 'V' THEN 'X' ELSE '' END,
	EntregaRealizadaFichaContatoNAO = CASE WHEN tbFichaContato.EntregaRealizadaFichaContato = 'F' THEN 'X' ELSE '' END,
	EntregaRealizadaDataHoraFichaContato = CASE WHEN tbFichaContato.EntregaRealizadaDataHoraFichaContato IS NOT NULL THEN tbFichaContato.EntregaRealizadaDataHoraFichaContato END,
	EntregaDocumentosFichaContatoSIM = CASE WHEN tbFichaContato.EntregaDocumentosFichaContato = 'V' THEN 'X' ELSE '' END,
	EntregaDocumentosFichaContatoNAO = CASE WHEN tbFichaContato.EntregaDocumentosFichaContato = 'F' THEN 'X' ELSE '' END,
	EntregaTecnicaFichaContatoSIM = CASE WHEN tbFichaContato.EntregaTecnicaFichaContato = 'V' THEN 'X' ELSE '' END,
	EntregaTecnicaFichaContatoNAO = CASE WHEN tbFichaContato.EntregaTecnicaFichaContato = 'F' THEN 'X' ELSE '' END,
	EntregaNoPrazoFichaContatoSIM = CASE WHEN tbFichaContato.EntregaNoPrazoFichaContato = 'V' THEN 'X' ELSE '' END,
	EntregaNoPrazoFichaContatoNAO = CASE WHEN tbFichaContato.EntregaNoPrazoFichaContato = 'F' THEN 'X' ELSE '' END,
	EntregaObservacoes = COALESCE(tbFichaContato.EntregaObservacoes,''),
----- Follow UP Vendas
	FollowUpAgendadoFichaContatoSIM = CASE WHEN tbFichaContato.FollowUpAgendadoFichaContato = 'V' THEN 'X' ELSE '' END,
	FollowUpAgendadoFichaContatoNAO = CASE WHEN tbFichaContato.FollowUpAgendadoFichaContato = 'F' THEN 'X' ELSE '' END,
	FollowUpAgendadoDataHoraFichaContato,

	FollowUpRealizadoFichaContatoSIM = CASE WHEN tbFichaContato.FollowUpRealizadoFichaContato = 'V' THEN 'X' ELSE '' END,
	FollowUpRealizadoFichaContatoNAO = CASE WHEN tbFichaContato.FollowUpRealizadoFichaContato = 'F' THEN 'X' ELSE '' END,
	FollowUpRealizadoDataHoraFichaContato = CASE WHEN tbFichaContato.FollowUpRealizadoDataHoraFichaContato IS NOT NULL THEN tbFichaContato.FollowUpRealizadoDataHoraFichaContato END,
	FollowUpContatoNoPrazoSIM = CASE WHEN tbFichaContato.FollowUpContatoNoPrazo = 'V' THEN 'X' ELSE '' END,
	FollowUpContatoNoPrazoNAO = CASE WHEN tbFichaContato.FollowUpContatoNoPrazo = 'F' THEN 'X' ELSE '' END,
	FollowUpObservacoes = COALESCE(tbFichaContato.FollowUpObservacoes,''),
----- Contatos Mais Recentes
----------------------
	ItemHistData1 = (SELECT TOP 1 (ItemContatoHistorico) FROM #tmpHistoricoContato ), 
	ContatoHistData1 = (SELECT TOP 1 (DataContatoHistorico) FROM #tmpHistoricoContato ),
	ContaotHistObs1 = (SELECT TOP 1 (HistoricoVisita) FROM #tmpHistoricoContato ),
----------------------
	ItemHistData2 = (SELECT TOP 1 (ItemContatoHistorico) 
				FROM #tmpHistoricoContato 
				WHERE #tmpHistoricoContato.ItemContatoHistorico > (SELECT TOP 1 (tmpHist.ItemContatoHistorico) 
													 FROM #tmpHistoricoContato tmpHist 
													 WHERE tmpHist.ItemContatoHistorico != #tmpHistoricoContato.ItemContatoHistorico )), 
	ContatoHistData2 = (SELECT TOP 1 (DataContatoHistorico) 
				   FROM #tmpHistoricoContato
				   WHERE #tmpHistoricoContato.ItemContatoHistorico > (SELECT TOP 1 (tmpHist.ItemContatoHistorico) 
													 FROM #tmpHistoricoContato tmpHist 
													 WHERE tmpHist.ItemContatoHistorico != #tmpHistoricoContato.ItemContatoHistorico )), 
				
	ContaotHistObs2 = (SELECT TOP 1 (HistoricoVisita) 
				  FROM #tmpHistoricoContato
				  WHERE #tmpHistoricoContato.ItemContatoHistorico > (SELECT TOP 1 (tmpHist.ItemContatoHistorico) 
													 FROM #tmpHistoricoContato tmpHist 
													 WHERE tmpHist.ItemContatoHistorico != #tmpHistoricoContato.ItemContatoHistorico )), 
----------------------
	ItemHistData3 = (SELECT TOP 1 (ItemContatoHistorico) 
			     FROM #tmpHistoricoContato 
			     WHERE #tmpHistoricoContato.ItemContatoHistorico > (SELECT TOP 1 (tmpHist.ItemContatoHistorico) 
								 			        FROM #tmpHistoricoContato tmpHist 
												  WHERE tmpHist.ItemContatoHistorico > (SELECT TOP 1 (tmpHistA.ItemContatoHistorico) 
																		    FROM #tmpHistoricoContato tmpHistA 
																		    WHERE tmpHistA.ItemContatoHistorico != tmpHist.ItemContatoHistorico ))),
	ContatoHistData3 = (SELECT TOP 1 (DataContatoHistorico) 
				  FROM #tmpHistoricoContato 
			        WHERE #tmpHistoricoContato.ItemContatoHistorico > (SELECT TOP 1 (tmpHist.ItemContatoHistorico) 
								 			           FROM #tmpHistoricoContato tmpHist 
												     WHERE tmpHist.ItemContatoHistorico > (SELECT TOP 1 (tmpHistA.ItemContatoHistorico) 
																			 FROM #tmpHistoricoContato tmpHistA 
																			WHERE tmpHistA.ItemContatoHistorico != tmpHist.ItemContatoHistorico ))),
	ContaotHistObs3 = (SELECT TOP 1 (HistoricoVisita)
				 FROM #tmpHistoricoContato 
			       WHERE #tmpHistoricoContato.ItemContatoHistorico > (SELECT TOP 1 (tmpHist.ItemContatoHistorico) 
								 			          FROM #tmpHistoricoContato tmpHist 
												    WHERE tmpHist.ItemContatoHistorico > (SELECT TOP 1 (tmpHistA.ItemContatoHistorico) 
																			FROM #tmpHistoricoContato tmpHistA 
																			WHERE tmpHistA.ItemContatoHistorico != tmpHist.ItemContatoHistorico ))),
----------------------
	ItemHistData4 = (SELECT TOP 1 (ItemContatoHistorico) 
				FROM #tmpHistoricoContato
				WHERE #tmpHistoricoContato.ItemContatoHistorico > (SELECT TOP 1 (tmpHist.ItemContatoHistorico) 
												   FROM #tmpHistoricoContato tmpHist
												   WHERE tmpHist.ItemContatoHistorico > (SELECT TOP 1 (tmpHistA.ItemContatoHistorico) 
								 			         									FROM #tmpHistoricoContato tmpHistA WHERE tmpHistA.ItemContatoHistorico > (SELECT TOP 1 (tmpHistB.ItemContatoHistorico) 
																							  			 							FROM #tmpHistoricoContato tmpHistB 
																																	WHERE tmpHistB.ItemContatoHistorico != tmpHistA.ItemContatoHistorico )))),
	ContatoHistData4 = (SELECT TOP 1 (DataContatoHistorico) 
				  FROM #tmpHistoricoContato
				  WHERE #tmpHistoricoContato.ItemContatoHistorico > (SELECT TOP 1 (tmpHist.ItemContatoHistorico) 
												   FROM #tmpHistoricoContato tmpHist
												   WHERE tmpHist.ItemContatoHistorico > (SELECT TOP 1 (tmpHistA.ItemContatoHistorico) 
								 			         									FROM #tmpHistoricoContato tmpHistA WHERE tmpHistA.ItemContatoHistorico > (SELECT TOP 1 (tmpHistB.ItemContatoHistorico) 
																							  			 							FROM #tmpHistoricoContato tmpHistB 
																																	WHERE tmpHistB.ItemContatoHistorico != tmpHistA.ItemContatoHistorico )))),
	ContaotHistObs4 = (SELECT TOP 1 (HistoricoVisita) 
				FROM #tmpHistoricoContato
				WHERE #tmpHistoricoContato.ItemContatoHistorico > (SELECT TOP 1 (tmpHist.ItemContatoHistorico) 
												   FROM #tmpHistoricoContato tmpHist
												   WHERE tmpHist.ItemContatoHistorico > (SELECT TOP 1 (tmpHistA.ItemContatoHistorico) 
								 			         									FROM #tmpHistoricoContato tmpHistA WHERE tmpHistA.ItemContatoHistorico > (SELECT TOP 1 (tmpHistB.ItemContatoHistorico) 
																							  			 							FROM #tmpHistoricoContato tmpHistB 
																																	WHERE tmpHistB.ItemContatoHistorico != tmpHistA.ItemContatoHistorico )))),
----------------------
	ItemHistData5 = ( SELECT TOP 1 (ItemContatoHistorico)
				FROM #tmpHistoricoContato
				WHERE #tmpHistoricoContato.ItemContatoHistorico > (SELECT TOP 1 (tmpHist.ItemContatoHistorico) 
													FROM #tmpHistoricoContato tmpHist
													WHERE tmpHist.ItemContatoHistorico > (SELECT TOP 1 (tmpHistA.ItemContatoHistorico) 
																					   FROM #tmpHistoricoContato tmpHistA
																					   WHERE tmpHistA.ItemContatoHistorico > (SELECT TOP 1 (tmpHistB.ItemContatoHistorico) 
																	 			         									FROM #tmpHistoricoContato tmpHistB WHERE tmpHistB.ItemContatoHistorico > (SELECT TOP 1 (tmpHistC.ItemContatoHistorico) 
																																  			 							FROM #tmpHistoricoContato tmpHistC 
																																										WHERE tmpHistC.ItemContatoHistorico != tmpHistB.ItemContatoHistorico ))))),
	ContatoHistData5 = ( SELECT TOP 1 (DataContatoHistorico)
				FROM #tmpHistoricoContato
				WHERE #tmpHistoricoContato.ItemContatoHistorico > (SELECT TOP 1 (tmpHist.ItemContatoHistorico) 
													FROM #tmpHistoricoContato tmpHist
													WHERE tmpHist.ItemContatoHistorico > (SELECT TOP 1 (tmpHistA.ItemContatoHistorico) 
																					   FROM #tmpHistoricoContato tmpHistA
																					   WHERE tmpHistA.ItemContatoHistorico > (SELECT TOP 1 (tmpHistB.ItemContatoHistorico) 
																	 			         									FROM #tmpHistoricoContato tmpHistB WHERE tmpHistB.ItemContatoHistorico > (SELECT TOP 1 (tmpHistC.ItemContatoHistorico) 
																																  			 							FROM #tmpHistoricoContato tmpHistC 
																																										WHERE tmpHistC.ItemContatoHistorico != tmpHistB.ItemContatoHistorico ))))), 
	ContaotHistObs5 = ( SELECT TOP 1 (HistoricoVisita)
				FROM #tmpHistoricoContato
				WHERE #tmpHistoricoContato.ItemContatoHistorico > (SELECT TOP 1 (tmpHist.ItemContatoHistorico) 
													FROM #tmpHistoricoContato tmpHist
													WHERE tmpHist.ItemContatoHistorico > (SELECT TOP 1 (tmpHistA.ItemContatoHistorico) 
																					   FROM #tmpHistoricoContato tmpHistA
																					   WHERE tmpHistA.ItemContatoHistorico > (SELECT TOP 1 (tmpHistB.ItemContatoHistorico) 
																	 			         									FROM #tmpHistoricoContato tmpHistB WHERE tmpHistB.ItemContatoHistorico > (SELECT TOP 1 (tmpHistC.ItemContatoHistorico) 
																																  			 							FROM #tmpHistoricoContato tmpHistC 
																																						WHERE tmpHistC.ItemContatoHistorico != tmpHistB.ItemContatoHistorico )))))
----------------------
   FROM tbFichaContato (NOLOCK)

	LEFT JOIN #tmpHistoricoContato (NOLOCK)
	ON 	#tmpHistoricoContato.CodigoEmpresa = tbFichaContato.CodigoEmpresa
	AND	#tmpHistoricoContato.CodigoLocal = tbFichaContato.CodigoLocal
	AND	#tmpHistoricoContato.NumeroFichaContato = tbFichaContato.NumeroFichaContato

	LEFT JOIN tbMotivoVendaPerdida (NOLOCK)
	ON	tbMotivoVendaPerdida.MotivoVendaPerdida = tbFichaContato.MotivoVendaPerdidaFichaContato

	LEFT JOIN tbClientePotencial (NOLOCK) 
	ON	tbClientePotencial.CodigoEmpresa = tbFichaContato.CodigoEmpresa
	AND	tbClientePotencial.CodigoClientePotencial = COALESCE(tbFichaContato.CodigoClientePF,tbFichaContato.CodigoClientePJ)

--	LEFT JOIN tbClientePotencialJ (NOLOCK) 
--	ON	tbClientePotencialJ.CodigoEmpresa = tbFichaContato.CodigoEmpresa
--	AND	tbClientePotencialJ.CodigoClientePotencial = tbFichaContato.CodigoClientePJ

	LEFT JOIN tbCliFor (NOLOCK)
	ON	tbCliFor.CodigoEmpresa = tbFichaContato.CodigoEmpresa
	AND	tbCliFor.CodigoCliFor = COALESCE(tbFichaContato.CodigoClientePF, tbFichaContato.CodigoClientePJ)

	LEFT JOIN tbCliFor tbCliForJ (NOLOCK)
	ON	tbCliForJ.CodigoEmpresa = tbFichaContato.CodigoEmpresa
	AND	tbCliForJ.CodigoCliFor = tbFichaContato.CodigoClientePJ

	LEFT JOIN tbClienteEntrevistaConsult (NOLOCK)
	ON	tbClienteEntrevistaConsult.CodigoEmpresa = tbFichaContato.CodigoEmpresa
	AND	tbClienteEntrevistaConsult.CodigoCliente = COALESCE(tbFichaContato.CodigoClientePF,tbFichaContato.CodigoClientePJ)

	LEFT JOIN tbCliForFisica (NOLOCK)
	ON	tbCliForFisica.CodigoEmpresa = tbCliFor.CodigoEmpresa
	AND	tbCliForFisica.CodigoCliFor  = tbCliFor.CodigoCliFor

	LEFT JOIN tbCliForJuridica (NOLOCK)
	ON	tbCliForJuridica.CodigoEmpresa = tbCliFor.CodigoEmpresa
	AND	tbCliForJuridica.CodigoCliFor  = tbCliFor.CodigoCliFor

	LEFT JOIN tbObjetivoProspeccao (NOLOCK)
	ON	tbObjetivoProspeccao.CodigoObjetivoProspeccao = tbFichaContato.CodigoObjetivoProspeccao

	INNER JOIN tbRepresentante (NOLOCK)
	ON	tbRepresentante.CodigoEmpresa = tbFichaContato.CodigoEmpresa
	and	tbRepresentante.CodigoRepresentante = tbFichaContato.CodigoRepresentante

	INNER JOIN tbRepresentanteComplementar (NOLOCK)
	ON	tbRepresentanteComplementar.CodigoEmpresa = tbRepresentante.CodigoEmpresa
	AND	tbRepresentanteComplementar.CodigoRepresentante = tbRepresentante.CodigoRepresentante

WHERE 	tbFichaContato.CodigoEmpresa = @CodigoEmpresa 
AND	tbFichaContato.CodigoLocal = @CodigoLocal
AND	tbFichaContato.NumeroFichaContato = @NumeroFichaContato
AND	( (tbFichaContato.TipoClientePF = @TipoCliente AND tbFichaContato.TipoClientePF IS NOT NULL) 
		OR 
	  (tbFichaContato.TipoClientePJ = @TipoCliente AND tbFichaContato.TipoClientePJ IS NOT NULL)
	)
AND	( (tbFichaContato.CodigoClientePF = @DoCliente AND tbFichaContato.CodigoClientePF IS NOT NULL)
		OR
	  (tbFichaContato.CodigoClientePJ = @DoCliente AND tbFichaContato.CodigoClientePJ IS NOT NULL)
	)
AND	(tbFichaContato.CodigoRepresentante = @DoRepresentante)


DROP TABLE #tmpFichaContatoVeicInteresse
DROP TABLE #tmpClientePFVeicStarClass
DROP TABLE #tmpHistoricoContato

go
grant execute on dbo.whRelFichaVisitaAutomoveis to SQLUsers
