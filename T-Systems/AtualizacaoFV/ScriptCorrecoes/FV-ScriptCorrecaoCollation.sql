if exists (select * from sysobjects where name = 'tbClienteEntrevistaConsult_SCH') begin
	drop table tbClienteEntrevistaConsult_SCH	end
GO
CREATE TABLE [dbo].[tbClienteEntrevistaConsult_SCH](
	[CodigoEmpresa] [numeric](4, 0) NOT NULL,
	[PotencialEfetivo] [char](1)   NOT NULL,
	[CodigoCliente] [numeric](14, 0) NOT NULL,
	[TipoCliente] [char](1)   NOT NULL,
	[FormaPrimeiroContato] [varchar](20)   NOT NULL,
	[PrincipalCondutorProprio] [dbo].[dtBooleano] NOT NULL,
	[PrincipalCondutorMarido] [dbo].[dtBooleano] NOT NULL,
	[PrincipalCondutorEsposa] [dbo].[dtBooleano] NOT NULL,
	[PrincipalCondutorFilho] [dbo].[dtBooleano] NOT NULL,
	[PrincipalCondutorFuncionario] [dbo].[dtBooleano] NOT NULL,
	[PrincipalCondutorOutros] [dbo].[dtBooleano] NOT NULL,
	[PrincipalCondutorOutrosDescricao] [char](15)   NULL,
	[VeiculoUtilizadoLazer] [dbo].[dtBooleano] NOT NULL,
	[VeiculoUtilizadoTrabalho] [dbo].[dtBooleano] NOT NULL,
	[VeiculoUtilizadoViagens] [dbo].[dtBooleano] NOT NULL,
	[VeiculoUtilizadoUsoEsporadico] [dbo].[dtBooleano] NOT NULL,
	[VeiculoUtilizadoOutros] [dbo].[dtBooleano] NOT NULL,
	[VeiculoUtilizadoOutrosDescricao] [char](15)   NULL,
	[MidiasMaisUtilizadasTV] [dbo].[dtBooleano] NOT NULL,
	[MidiasMaisUtilizadasInternet] [dbo].[dtBooleano] NOT NULL,
	[MidiasMaisUtilizadasRevistas] [dbo].[dtBooleano] NOT NULL,
	[MidiasMaisUtilizadasJornais] [dbo].[dtBooleano] NOT NULL,
	[MidiasMaisUtilizadasRadio] [dbo].[dtBooleano] NOT NULL,
	[MidiasMaisUtilizadasOutros] [dbo].[dtBooleano] NOT NULL,
	[MidiasMaisUtilizadasOutrosDescricao] [char](15)   NULL,
	[AtributosValorizaDesempenho] [char](1)   NULL,
	[AtributosValorizaConforto] [char](1)   NULL,
	[AtributosValorizaEstilo] [char](1)   NULL,
	[AtributosValorizaDesign] [char](1)   NULL,
	[AtributosValorizaSeguranca] [char](1)   NULL,
	[AtributosValorizaPreco] [char](1)   NULL,
	[AtributosValorizaOutros] [char](1)   NULL,
	[AtributosValorizaoutrosDescricao] [char](15)   NULL,
	[TipoVeicPreferidoSedan] [dbo].[dtBooleano] NOT NULL,
	[TipoVeicPreferidoAMG] [dbo].[dtBooleano] NOT NULL,
	[TipoVeicPreferidoAllroad] [dbo].[dtBooleano] NOT NULL,
	[TipoVeicPreferidoRoadster] [dbo].[dtBooleano] NOT NULL,
	[TipoVeicPreferidoCoupe] [dbo].[dtBooleano] NOT NULL,
	[TipoVeicPreferidoSportourer] [dbo].[dtBooleano] NOT NULL,
	[ObservacoesEntrevistaConsultiva] [varchar](200)   NULL,
	[PrincipaisAtividades] [varchar](100)   NULL,
	[HobbiesGostos] [varchar](100)   NULL,
	[MidiaAtracaoPrimeiroContato] [dbo].[dtInteiro03] NULL,
	[TimeFutebol] [varchar](60)   NULL,
	[DataAtualizacao] [datetime] NULL)
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[PrincipalCondutorProprio]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[PrincipalCondutorProprio]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[PrincipalCondutorMarido]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[PrincipalCondutorMarido]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[PrincipalCondutorEsposa]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[PrincipalCondutorEsposa]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[PrincipalCondutorFilho]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[PrincipalCondutorFilho]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[PrincipalCondutorFuncionario]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[PrincipalCondutorFuncionario]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[PrincipalCondutorOutros]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[PrincipalCondutorOutros]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[VeiculoUtilizadoLazer]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[VeiculoUtilizadoLazer]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[VeiculoUtilizadoTrabalho]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[VeiculoUtilizadoTrabalho]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[VeiculoUtilizadoViagens]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[VeiculoUtilizadoViagens]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[VeiculoUtilizadoUsoEsporadico]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[VeiculoUtilizadoUsoEsporadico]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[VeiculoUtilizadoOutros]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[VeiculoUtilizadoOutros]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[MidiasMaisUtilizadasTV]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[MidiasMaisUtilizadasTV]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[MidiasMaisUtilizadasInternet]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[MidiasMaisUtilizadasInternet]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[MidiasMaisUtilizadasRevistas]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[MidiasMaisUtilizadasRevistas]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[MidiasMaisUtilizadasJornais]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[MidiasMaisUtilizadasJornais]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[MidiasMaisUtilizadasRadio]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[MidiasMaisUtilizadasRadio]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[MidiasMaisUtilizadasOutros]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[MidiasMaisUtilizadasOutros]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[AtributosValorizaDesempenho]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[AtributosValorizaDesempenho]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[AtributosValorizaConforto]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[AtributosValorizaConforto]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[AtributosValorizaEstilo]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[AtributosValorizaEstilo]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[AtributosValorizaDesign]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[AtributosValorizaDesign]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[AtributosValorizaSeguranca]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[AtributosValorizaSeguranca]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[AtributosValorizaPreco]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[AtributosValorizaPreco]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[AtributosValorizaOutros]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[AtributosValorizaOutros]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[TipoVeicPreferidoSedan]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[TipoVeicPreferidoSedan]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[TipoVeicPreferidoAMG]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[TipoVeicPreferidoAMG]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[TipoVeicPreferidoAllroad]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[TipoVeicPreferidoAllroad]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[TipoVeicPreferidoRoadster]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[TipoVeicPreferidoRoadster]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[TipoVeicPreferidoCoupe]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[TipoVeicPreferidoCoupe]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[TipoVeicPreferidoSportourer]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbClienteEntrevistaConsult_SCH].[TipoVeicPreferidoSportourer]' , @futureonly='futureonly'
GO


-------------------------------------------------------------------------------------------

go
if exists (select * from sysobjects where name = 'tbObjetivoProspeccao_SCH') begin
	drop table tbObjetivoProspeccao_SCH		end
go
CREATE TABLE [dbo].[tbObjetivoProspeccao_SCH](
	[CodigoObjetivoProspeccao] [numeric](4, 0) NOT NULL,
	[DescricaoObjetivoProspeccao] [char](30) NULL) 
go

-------------------------------------------------------------------------------------------

go
if exists (select * from sysobjects where name = 'tbFichaAtendimento_SCH') begin
	drop table tbFichaAtendimento_SCH	end
GO
CREATE TABLE [dbo].[tbFichaAtendimento_SCH](
	[CodigoEmpresa] [numeric](4, 0) NOT NULL,
	[CodigoLocal] [numeric](4, 0) NOT NULL,
	[NumeroFichaAtendimento] [numeric](6, 0) NOT NULL,
	[StatusAtendimento] [varchar](25)   NOT NULL DEFAULT ('EM ANDAMENTO'),
	[DataInicioFichaAtendimento] [datetime] NOT NULL,
	[DataTerminoFichaAtendimento] [datetime] NULL,
	[CodigoClientePF] [numeric](14, 0) NULL,
	[TipoClientePF] [varchar](1)   NULL,
	[CodigoClientePJ] [numeric](14, 0) NULL,
	[TipoClientePJ] [varchar](1)   NULL,
	[NovoUsadoVeicInteresse] [varchar](1)   NULL,
	[FabricanteVeicInteresse] [varchar](5)   NULL,
	[GrupoModeloVeicInteresse] [numeric](5, 0) NULL,
	[ModeloVeicInteresse] [varchar](30)   NULL,
	[AnoFabricacaoVeicInteresse] [numeric](4, 0) NOT NULL DEFAULT (0),
	[AnoModeloVeicInteresse] [numeric](4, 0) NOT NULL DEFAULT (0),
	[CorVeicInteresse] [varchar](4)   NULL,
	[CombustivelVeicInteresse] [varchar](2)   NULL,
	[PrecoVendaVeicInteresse] [numeric](18, 2) NOT NULL DEFAULT (0),
	[PrecoNegociadoVeicInteresse] [numeric](18, 2) NOT NULL DEFAULT (0),
	[FabricanteVeicUsadoAvaliado] [varchar](5)   NULL,
	[GrupoModeloVeicUsadoAvaliado] [numeric](5, 0) NULL,
	[ModeloVeicUsadoAvaliado] [varchar](30)   NULL,
	[AnoFabricVeicUsadoAvaliado] [numeric](4, 0) NOT NULL DEFAULT (0),
	[AnoModeloVeicUsadoAvaliado] [numeric](4, 0) NOT NULL DEFAULT (0),
	[CorVeicUsadoAvaliado] [varchar](4)   NULL,
	[CombustivelVeicUsadoAvaliado] [varchar](2)   NULL,
	[PrecoVeicUsadoAvaliado] [numeric](18, 2) NOT NULL DEFAULT (0),
	[MidiaAtracao] [varchar](3)   NULL,
	[MidiaAtracaoOutra] [varchar](30)   NOT NULL DEFAULT (''),
	[FormaPrimeiroContato] [varchar](20)   NOT NULL,
	[CodigoRepresentante] [numeric](4, 0) NOT NULL,
	[ObservacaoFichaAtendimento] [varchar](1000)   NULL,
	[DataPesquisaSatisfacao] [datetime] NULL)
go

-------------------------------------------------------------------------------------------

go
if exists (select * from sysobjects where name = 'tbFichaAtendimentoHistorico_SCH') begin
	drop table tbFichaAtendimentoHistorico_SCH		end
GO
CREATE TABLE [dbo].[tbFichaAtendimentoHistorico_SCH](
	[CodigoEmpresa] [numeric](4, 0) NOT NULL,
	[CodigoLocal] [numeric](4, 0) NOT NULL,
	[NumeroFichaAtendimento] [numeric](6, 0) NOT NULL,
	[SeqHistoricoFichaAtendHist] [numeric](6, 0) NOT NULL,
	[DataHistoricoFichaAtendHist] [datetime] NOT NULL,
	[FormaContatoFichaAtendHist] [char](20)   NOT NULL,
	[PotencialNegociacao] [numeric](2, 0) NOT NULL,
	[AcompanhamentoFichaAtendHist] [dbo].[dtBooleano] NOT NULL,
	[PrecoFornecidoFichaAtendHist] [dbo].[dtBooleano] NOT NULL,
	[TestDriveFichaAtendHist] [dbo].[dtBooleano] NOT NULL,
	[PedidoFechadoFichaAtendHist] [dbo].[dtBooleano] NOT NULL,
	[FaturadoFichaAtendHist] [dbo].[dtBooleano] NOT NULL,
	[EntregaFichaAtendHist] [dbo].[dtBooleano] NOT NULL,
	[VendaPerdidaFichaAtendHist] [dbo].[dtBooleano] NOT NULL,
	[ObservacoesFichaAtendHist] [char](200)   NULL,
	[ProximoContatoFichaAtendHist] [datetime] NULL)
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaAtendimentoHistorico_SCH].[AcompanhamentoFichaAtendHist]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaAtendimentoHistorico_SCH].[AcompanhamentoFichaAtendHist]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaAtendimentoHistorico_SCH].[PrecoFornecidoFichaAtendHist]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaAtendimentoHistorico_SCH].[PrecoFornecidoFichaAtendHist]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaAtendimentoHistorico_SCH].[TestDriveFichaAtendHist]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaAtendimentoHistorico_SCH].[TestDriveFichaAtendHist]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaAtendimentoHistorico_SCH].[PedidoFechadoFichaAtendHist]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaAtendimentoHistorico_SCH].[PedidoFechadoFichaAtendHist]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaAtendimentoHistorico_SCH].[FaturadoFichaAtendHist]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaAtendimentoHistorico_SCH].[FaturadoFichaAtendHist]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaAtendimentoHistorico_SCH].[EntregaFichaAtendHist]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaAtendimentoHistorico_SCH].[EntregaFichaAtendHist]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaAtendimentoHistorico_SCH].[VendaPerdidaFichaAtendHist]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaAtendimentoHistorico_SCH].[VendaPerdidaFichaAtendHist]' , @futureonly='futureonly'
go

-------------------------------------------------------------------------------------------

go
if exists (select * from sysobjects where name = 'tbFichaAtendPesqSatisfacao_SCH') begin
	drop table tbFichaAtendPesqSatisfacao_SCH		end
GO
CREATE TABLE [dbo].[tbFichaAtendPesqSatisfacao_SCH](
	[CodigoEmpresa] [numeric](4, 0) NOT NULL,
	[CodigoLocal] [numeric](4, 0) NOT NULL,
	[NumeroFichaAtendimento] [numeric](6, 0) NOT NULL,
	[DataPesquisa] [datetime] NOT NULL,
	[Resposta1] [dbo].[dtBooleano] NOT NULL,
	[Resposta2] [dbo].[dtBooleano] NOT NULL,
	[Resposta3] [dbo].[dtBooleano] NOT NULL,
	[Resposta4] [dbo].[dtBooleano] NOT NULL,
	[Resposta5] [dbo].[dtBooleano] NOT NULL,
	[Resposta6] [dbo].[dtBooleano] NOT NULL,
	[Resposta7] [dbo].[dtBooleano] NOT NULL)
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaAtendPesqSatisfacao_SCH].[Resposta1]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaAtendPesqSatisfacao_SCH].[Resposta1]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaAtendPesqSatisfacao_SCH].[Resposta2]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaAtendPesqSatisfacao_SCH].[Resposta2]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaAtendPesqSatisfacao_SCH].[Resposta3]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaAtendPesqSatisfacao_SCH].[Resposta3]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaAtendPesqSatisfacao_SCH].[Resposta4]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaAtendPesqSatisfacao_SCH].[Resposta4]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaAtendPesqSatisfacao_SCH].[Resposta5]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaAtendPesqSatisfacao_SCH].[Resposta5]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaAtendPesqSatisfacao_SCH].[Resposta6]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaAtendPesqSatisfacao_SCH].[Resposta6]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaAtendPesqSatisfacao_SCH].[Resposta7]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaAtendPesqSatisfacao_SCH].[Resposta7]' , @futureonly='futureonly'
go

-------------------------------------------------------------------------------------------

go
if exists (select * from sysobjects where name = 'tbFichaContato_SCH') begin
	drop table tbFichaContato_SCH	end
GO
CREATE TABLE [dbo].tbFichaContato_SCH(
	[CodigoEmpresa] [numeric](4, 0) NOT NULL,
	[CodigoLocal] [numeric](4, 0) NOT NULL,
	[NumeroFichaContato] [numeric](6, 0) NOT NULL,
	[StatusFichaContato] [varchar](25)   NOT NULL,
	[DataHoraInicioFichaContato] [datetime] NULL,
	[DataHoraTerminoFichaContato] [datetime] NULL,
	[CodigoClientePF] [numeric](14, 0) NULL,
	[TipoClientePF] [varchar](1)   NULL,
	[CodigoClientePJ] [numeric](14, 0) NULL,
	[TipoClientePJ] [varchar](1)   NULL,
	[CodigoRepresentante] [numeric](4, 0) NOT NULL,
	[ObservacaoFichaContato] [varchar](500)   NULL,
	[TestDriveAgendado] [dbo].[dtBooleano] NOT NULL,
	[TestDriveAgendadoDataHora] [datetime] NULL,
	[TestDriveRealizado] [dbo].[dtBooleano] NOT NULL,
	[TestDriveRealizadoDataHora] [datetime] NULL,
	[TestDriveObservacoes] [varchar](150)   NULL,
	[NegociacaoIniciadaFichaContato] [dbo].[dtBooleano] NOT NULL,
	[NegociacaoIniciadaDataHora] [datetime] NULL,
	[NegociacaoFechadaFichaContato] [dbo].[dtBooleano] NOT NULL,
	[NegociacaoFechadaDataHora] [datetime] NULL,
	[MotivoVendaPerdidaFichaContato] [dbo].[dtInteiro02] NULL,
	[NegociacaoObservacoes] [varchar](150)   NULL,
	[EntregaAgendadaFichaContato] [dbo].[dtBooleano] NOT NULL,
	[EntregaAgendadaDataHoraFichaContato] [datetime] NULL,
	[EntregaRealizadaFichaContato] [dbo].[dtBooleano] NOT NULL,
	[EntregaRealizadaDataHoraFichaContato] [datetime] NULL,
	[EntregaDocumentosFichaContato] [dbo].[dtBooleano] NOT NULL,
	[EntregaTecnicaFichaContato] [dbo].[dtBooleano] NOT NULL,
	[EntregaNoPrazoFichaContato] [dbo].[dtBooleano] NOT NULL,
	[EntregaObservacoes] [varchar](150)   NULL,
	[FollowUpAgendadoFichaContato] [dbo].[dtBooleano] NOT NULL,
	[FollowUpAgendadoDataHoraFichaContato] [datetime] NULL,
	[FollowUpRealizadoFichaContato] [dbo].[dtBooleano] NOT NULL,
	[FollowUpRealizadoDataHoraFichaContato] [datetime] NULL,
	[FollowUpContatoNoPrazo] [dbo].[dtBooleano] NOT NULL,
	[FollowUpObservacoes] [varchar](150)   NULL,
	[OrigemFichaContato] [varchar](1)   NULL,
	[RecepcaoDataHora] [datetime] NULL,
	[RecepcaoRetornoDataHora] [datetime] NULL,
	[RecepcaoOrigemContato] [varchar](20)   NULL,
	[RecepcaoInformExtras] [varchar](500)   NULL,
	[CodigoObjetivoProspeccao] [numeric](4, 0) NULL,
	[ProspeccaoFormaContato] [varchar](20)   NULL,
	[ProspeccaoAgendouVisita] [dbo].[dtBooleano] NULL,
	[ProspeccaoObservacoes] [varchar](500)   NULL,
	[CodigoMotivoTestDrive] [dbo].[dtInteiro04] NULL,
	[VeiculoFaturado] [dbo].[dtBooleano] NULL,
	[DataFaturamento] [datetime] NULL)
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaContato_SCH].[TestDriveAgendado]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaContato_SCH].[TestDriveAgendado]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaContato_SCH].[TestDriveRealizado]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaContato_SCH].[TestDriveRealizado]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaContato_SCH].[NegociacaoIniciadaFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaContato_SCH].[NegociacaoIniciadaFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaContato_SCH].[NegociacaoFechadaFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaContato_SCH].[NegociacaoFechadaFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaContato_SCH].[EntregaAgendadaFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaContato_SCH].[EntregaAgendadaFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaContato_SCH].[EntregaRealizadaFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaContato_SCH].[EntregaRealizadaFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaContato_SCH].[EntregaDocumentosFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaContato_SCH].[EntregaDocumentosFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaContato_SCH].[EntregaTecnicaFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaContato_SCH].[EntregaTecnicaFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaContato_SCH].[EntregaNoPrazoFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaContato_SCH].[EntregaNoPrazoFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaContato_SCH].[FollowUpAgendadoFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaContato_SCH].[FollowUpAgendadoFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaContato_SCH].[FollowUpRealizadoFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaContato_SCH].[FollowUpRealizadoFichaContato]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaContato_SCH].[FollowUpContatoNoPrazo]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaContato_SCH].[FollowUpContatoNoPrazo]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaContato_SCH].[ProspeccaoAgendouVisita]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaContato_SCH].[ProspeccaoAgendouVisita]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbFichaContato_SCH].[VeiculoFaturado]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbFichaContato_SCH].[VeiculoFaturado]' , @futureonly='futureonly'
go

-------------------------------------------------------------------------------------------

go
if exists (select * from sysobjects where name = 'tbFichaContatoHistorico_SCH') begin
	drop table tbFichaContatoHistorico_SCH		end
GO
CREATE TABLE [dbo].[tbFichaContatoHistorico_SCH](
	[CodigoEmpresa] [dbo].[dtInteiro04] NOT NULL,
	[CodigoLocal] [dbo].[dtInteiro04] NOT NULL,
	[NumeroFichaContato] [dbo].[dtInteiro06] NOT NULL,
	[ItemContatoHistorico] [dbo].[dtInteiro04] NOT NULL,
	[DataContatoHistorico] [datetime] NULL,
	[FormaContatoHistorico] [varchar](20)  NOT NULL,
	[NomeContatoHistorico] [varchar](30)  NULL,
	[HistoricoVisita] [varchar](200)  NULL,
	[PropensaoCompra] [dbo].[dtInteiro02] NOT NULL,
	[DataProximoContato] [datetime] NULL,
	[CodigoObjetivoProspeccao] [numeric](4, 0) NULL,
	[FaseNegociacao] [numeric](1, 0) NULL,
	[AssinaturaGerente] [char](30)  NULL)
go

-------------------------------------------------------------------------------------------

go
if exists (select * from sysobjects where name = 'tbFichaContatoVeicInteresse_SCH') begin
	drop table tbFichaContatoVeicInteresse_SCH		end
GO
CREATE TABLE [dbo].[tbFichaContatoVeicInteresse_SCH](
	[CodigoEmpresa] [numeric](4, 0) NOT NULL,
	[CodigoLocal] [numeric](4, 0) NOT NULL,
	[NumeroFichaContato] [numeric](6, 0) NOT NULL,
	[ItemFichaContatoVeiculo] [numeric](1, 0) NOT NULL,
	[ZeroKM] [dbo].[dtBooleano] NOT NULL,
	[CodigoFabricante] [char](5)   NULL,
	[ModeloVeiculo] [varchar](21)   NULL,
	[AnoFabricacaoVeiculo] [numeric](4, 0) NULL,
	[AnoModeloVeiculo] [numeric](4, 0) NULL,
	[CodigoCombustivel] [char](2)   NULL,
	[AplicacaoCor] [char](1)   NULL,
	[CodigoCorVeic] [char](4)   NULL,
	[PrecoVeiculo] [numeric](18, 2) NULL)
go

-------------------------------------------------------------------------------------------

go
if exists (select * from sysobjects where name = 'tbFichaContatoMidiaAtracao_SCH') begin
	drop table tbFichaContatoMidiaAtracao_SCH		end
GO
CREATE TABLE [dbo].[tbFichaContatoMidiaAtracao_SCH](
	[CodigoEmpresa] [numeric](4, 0) NOT NULL,
	[CodigoLocal] [numeric](4, 0) NOT NULL,
	[NumeroFichaContato] [numeric](6, 0) NOT NULL,
	[DataAtualizacao] [datetime] NOT NULL,
	[CodigoMidia] [dbo].[dtInteiro03] NOT NULL)
go

-------------------------------------------------------------------------------------------

go
if exists (select * from sysobjects where name = 'tbObjetivoRepresentante_SCH') begin
	drop table tbObjetivoRepresentante_SCH		end
GO
CREATE TABLE [dbo].[tbObjetivoRepresentante_SCH](
	[CodigoEmpresa] [dbo].[dtInteiro04] NOT NULL,
	[CodigoLocal] [dbo].[dtInteiro04] NOT NULL,
	[CodigoRepresentante] [dbo].[dtInteiro04] NOT NULL,
	[PeriodoObjetivo] [varchar](6) NOT NULL,
	[QuantidadeProspeccao] [numeric](5, 0) NULL,
	[MetaContatosGestaoCarteira] [numeric](5, 0) NULL)
go

-------------------------------------------------------------------------------------------

go
if exists (select * from sysobjects where name = 'tbMotivosTestDrive_SCH') begin
	drop table tbMotivosTestDrive_SCH			end
GO
CREATE TABLE [dbo].[tbMotivosTestDrive_SCH](
	[CodigoMotivoTestDrive] [dbo].[dtInteiro04] NOT NULL,
	[DescricaoMotivoTestDrive] [varchar](30) NOT NULL)
go

-------------------------------------------------------------------------------------------

go
if exists (select * from sysobjects where name = 'tbClientePFVeicStarClass_SCH') begin
	drop table tbClientePFVeicStarClass_SCH		end
GO
CREATE TABLE [dbo].[tbClientePFVeicStarClass_SCH](
	[CodigoEmpresa] [numeric](4, 0) NOT NULL,
	[CodigoClientePF] [numeric](14, 0) NOT NULL,
	[TipoClientePF] [varchar](1)   NULL,
	[ItemSequencia] [numeric](2, 0) NOT NULL,
	[CodigoFabricante] [char](5)   NULL,
	[ModeloVeiculo] [varchar](21)   NULL,
	[AnoFabricacaoVeiculo] [numeric](4, 0) NULL,
	[AnoModeloVeiculo] [numeric](4, 0) NULL,
	[CodigoCombustivel] [char](2)   NULL,
	[AplicacaoCor] [char](1)   NULL,
	[CodigoCorVeic] [char](4)   NULL,
	[PrecoVeiculo] [numeric](18, 2))
go


-------------------------------------------------------------------------------------------

go
if exists (select * from sysobjects where name = 'tbMonitoramento_SCH') begin
	drop table tbMonitoramento_SCH		end
GO
CREATE TABLE [dbo].[tbMonitoramento_SCH](
	[CodigoEmpresa] [dbo].[dtInteiro04] NOT NULL,
	[CodigoLocal] [dbo].[dtInteiro04] NOT NULL,
	[IdMonitoramento] [numeric](6, 0) NOT NULL,
	[DataMonitoramento] [datetime] NOT NULL,
	[TipoMonitoramento] [char](2)   NOT NULL,
	[StatusMonitoramento] [char](2)   NOT NULL,
	[MonitoramentoFinalizado] [dbo].[dtBooleano] NOT NULL,
	[TipoCliente] [char](10)   NOT NULL,
	[CodigoCliFor] [numeric](14, 0) NOT NULL,
	[CodigoClienteEventual] [numeric](14, 0) NULL,
	[NumeroFichaContato] [numeric](6, 0) NULL,
	[DataDocumento] [datetime] NOT NULL,
	[UsuarioEmUtilizacao] [varchar](30)   NULL,
	[DataHoraLigacao1] [datetime] NULL,
	[ObservacaoLigacao1] [varchar](100)   NULL,
	[UltimoAtendimento1] [varchar](30)   NULL,
	[DataHoraLigacao2] [datetime] NULL,
	[ObservacaoLigacao2] [varchar](100)   NULL,
	[UltimoAtendimento2] [varchar](30)   NULL,
	[DataHoraLigacao3] [datetime] NULL,
	[ObservacaoLigacao3] [varchar](100)   NULL,
	[UltimoAtendimento3] [varchar](30)   NULL,
	[DataHoraLigacao4] [datetime] NULL,
	[ObservacaoLigacao4] [varchar](100)   NULL,
	[UltimoAtendimento4] [varchar](30)   NULL,
	[DataHoraLigacao5] [datetime] NULL,
	[ObservacaoLigacao5] [varchar](100)   NULL,
	[UltimoAtendimento5] [varchar](30)   NULL,
	[RespostaQuestao1] [dbo].[dtBooleano] NOT NULL,
	[RespostaQuestao2] [dbo].[dtBooleano] NOT NULL,
	[RespostaQuestao3] [dbo].[dtBooleano] NOT NULL,
	[RespostaQuestao4] [dbo].[dtBooleano] NOT NULL,
	[RespostaQuestao5] [dbo].[dtBooleano] NOT NULL,
	[MotivoQuestao1] [char](1000)   NULL,
	[MotivoQuestao2] [char](1000)   NULL,
	[MotivoQuestao3] [char](1000)   NULL,
	[MotivoQuestao4] [char](700)   NULL,
	[MotivoQuestao5] [char](1000)   NULL,
	[PossiveisMotivos1] [varchar](1)   NULL,
	[PossiveisMotivos2] [varchar](1)   NULL,
	[PossiveisMotivos3] [varchar](1)   NULL,
	[PossiveisMotivos4] [varchar](1)   NULL,
	[PossiveisMotivos5] [varchar](1)   NULL,
	[AnaliseProcedencia] [dbo].[dtBooleano] NOT NULL,
	[MotivoAnaliseProcedencia] [char](1000)   NULL,
	[PossiveisMotivosAnProced] [varchar](1)   NULL,
	[AcaoPontual] [varchar](12)   NULL,
	[MotivoOutrosAcaoPontual] [char](700)   NULL,
	[DataContatoAcaoPontual] [datetime] NULL,
	[ComentariosAcaoPontual] [char](700)   NULL,
	[AcaoCorretiva] [dbo].[dtBooleano] NOT NULL,
	[CodigoFabricanteVeiculo] [char](5)   NULL,
	[NumeroDocumento] [numeric](6, 0) NULL)

GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbMonitoramento_SCH].[MonitoramentoFinalizado]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbMonitoramento_SCH].[MonitoramentoFinalizado]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbMonitoramento_SCH].[RespostaQuestao1]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbMonitoramento_SCH].[RespostaQuestao1]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbMonitoramento_SCH].[RespostaQuestao2]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbMonitoramento_SCH].[RespostaQuestao2]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbMonitoramento_SCH].[RespostaQuestao3]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbMonitoramento_SCH].[RespostaQuestao3]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbMonitoramento_SCH].[RespostaQuestao4]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbMonitoramento_SCH].[RespostaQuestao4]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbMonitoramento_SCH].[RespostaQuestao5]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbMonitoramento_SCH].[RespostaQuestao5]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbMonitoramento_SCH].[AnaliseProcedencia]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbMonitoramento_SCH].[AnaliseProcedencia]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[dfF]', @objname=N'[dbo].[tbMonitoramento_SCH].[AcaoCorretiva]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[rlTipoFV]', @objname=N'[dbo].[tbMonitoramento_SCH].[AcaoCorretiva]' , @futureonly='futureonly'

-------------------------------------------------------------------------------------------

go
insert into tbClienteEntrevistaConsult_SCH	select * from tbClienteEntrevistaConsult
go
insert into tbObjetivoProspeccao_SCH		select * from tbObjetivoProspeccao 
go
insert into tbFichaAtendimento_SCH			select * from tbFichaAtendimento
go
insert into tbFichaAtendimentoHistorico_SCH	select * from tbFichaAtendimentoHistorico
go
insert into tbFichaAtendPesqSatisfacao_SCH	select * from tbFichaAtendPesqSatisfacao
go
insert into tbMonitoramento_SCH				select * from tbMonitoramento
go
insert into tbFichaContato_SCH				select * from tbFichaContato
go
insert into tbFichaContatoHistorico_SCH		select * from tbFichaContatoHistorico
go
insert into tbFichaContatoVeicInteresse_SCH	select * from tbFichaContatoVeicInteresse
go
insert into tbFichaContatoMidiaAtracao_SCH	select * from tbFichaContatoMidiaAtracao
go
insert into tbClientePFVeicStarClass_SCH	select * from tbClientePFVeicStarClass
go
insert into tbObjetivoRepresentante_SCH		select * from tbObjetivoRepresentante
go
insert into tbMotivosTestDrive_SCH			select * from tbMotivosTestDrive
go



-------------------------------------------------------------------------------------------

go
DROP TABLE tbClienteEntrevistaConsult
go
DROP TABLE tbClientePFVeicStarClass
go
DROP TABLE tbFichaAtendimentoHistorico
go
DROP TABLE tbFichaAtendPesqSatisfacao
go
DROP TABLE tbFichaAtendimento
go
DROP TABLE tbFichaContatoMidiaAtracao
go
DROP TABLE tbFichaContatoVeicInteresse
go
DROP TABLE tbFichaContatoHistorico
go
DROP TABLE tbObjetivoRepresentante
go
DROP TABLE tbMonitoramento
go
DROP TABLE tbFichaContato
go
DROP TABLE tbMotivosTestDrive
go
DROP TABLE tbObjetivoProspeccao
go

-------------------------------------------------------------------------------------------

go
select * into tbObjetivoProspeccao			from tbObjetivoProspeccao_SCH
go
select * into tbMotivosTestDrive			from tbMotivosTestDrive_SCH
go
select * into tbObjetivoRepresentante		from tbObjetivoRepresentante_SCH
go
select * into tbFichaContato				from tbFichaContato_SCH
go
select * into tbFichaContatoHistorico		from tbFichaContatoHistorico_SCH
go
select * into tbFichaContatoVeicInteresse	from tbFichaContatoVeicInteresse_SCH
go
select * into tbFichaContatoMidiaAtracao	from tbFichaContatoMidiaAtracao_SCH
go
select * into tbMonitoramento				from tbMonitoramento_SCH				
go
select * into tbFichaAtendimento			from tbFichaAtendimento_SCH
go
select * into tbFichaAtendimentoHistorico	from tbFichaAtendimentoHistorico_SCH
go
select * into tbFichaAtendPesqSatisfacao	from tbFichaAtendPesqSatisfacao_SCH
go
select * into tbClientePFVeicStarClass		from tbClientePFVeicStarClass_SCH
go
select * into tbClienteEntrevistaConsult	from tbClienteEntrevistaConsult_SCH
go

