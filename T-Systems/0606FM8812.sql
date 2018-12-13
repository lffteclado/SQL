Alter Table tbColaborador add PercentualComissao numeric(5,2)
GO
update tbColaborador set PercentualComissao = 0
GO
ALTER TABLE tbColaborador ALTER COLUMN PercentualComissao numeric(5,2) not null;
go
Alter Table tbColaborador add ObsLivreColaborador varchar(500);
go
DROP PROCEDURE dbo.spAColaborador
GO
CREATE PROCEDURE dbo.spAColaborador
   @CodigoEmpresa numeric(4) ,
   @CodigoLocal numeric(4) ,
   @TipoColaborador char(1) ,
   @NumeroRegistro numeric(8) ,
   @NumeroCTPS numeric(8) ,
   @SerieCTPS char(6) ,
   @DataExpedicaoCTPS datetime ,
   @DataValidadeCTPS datetime = Null,
   @CPFColaborador char(14) = Null,
   @NumeroRGColaborador char(15) = Null,
   @OrgaoExpedicaoRGColaborador char(4) = Null,
   @DataExpedicaoRGColaborador datetime = Null,
   @DataValidadeRGColaborador datetime = Null,
   @NumeroPIS numeric(12) = Null,
   @DataCadastroPIS datetime = Null,
   @NumeroTituloEleitor char(15) = Null,
   @ZonaTituloEleitor char(3) = Null,
   @SecaoTituloEleitor char(4) = Null,
   @EmissaoTituloEleitor datetime = Null,
   @ValidadeHabilitacao datetime = Null,
   @NomePai char(30) = Null,
   @NomeMae char(30) ,
   @SexoColaborador char(1) ,
   @RegHabilitacaoProfissional numeric(10) = Null,
   @DataNascimentoColaborador datetime ,
   @NaturalidadeColaborador char(30) ,
   @TipoVistoEstrangeiro char(15) = Null,
   @AnoChegada numeric(4) = Null,
   @DataAdmissao datetime ,
   @DataDemissao datetime = Null,
   @HorasMensaisColaborador numeric(6,2) = 0,
   @CaptaPonto char(1) = 'F',
   @Chapa numeric(8) = Null,
   @FotoColaborador varchar(255) = Null,
   @NumeroCarteiraHabilitacao char(15) = Null,
   @CategoriaHabilitacao char(3) = Null,
   @ExpedicaoHabilitacao datetime = Null,
   @UFExpedicaoRGColaborador char(2) = Null,
   @UFNascimentoColaborador char(2) ,
   @UFTituloEleitor char(2) = Null,
   @UFCTPS char(2) ,
   @CodigoConselhoRegional numeric(4) = Null,
   @CodigoNacionalidade numeric(2) ,
   @CodigoEstadoCivil numeric(2) ,
   @CodigoCargo numeric(6) ,
   @CodigoGrauInstrucao numeric(2) ,
   @CodigoMaoObra numeric(2) ,
   @CodigoRacaCor numeric(2) = Null,
   @DeficienteFisico char(1) = 'F',
   @AlvaraJuridico char(1) = 'F',
   @BRPDHColaborador char(1) = Null,
   @RegimeRevezamento char(15) = Null,
   @ObservacaoColaborador varchar(400) = Null,
   @DataFimContratoEstagio datetime = Null,
   @TipoDeficiencia numeric(2) = 0,
   @PercentualComissao numeric(5,2) = 0,
   @ObsLivreColaborador Varchar(500) = NULL
AS 
UPDATE tbColaborador
SET
   NumeroCTPS = @NumeroCTPS,
   SerieCTPS = @SerieCTPS,
   DataExpedicaoCTPS = @DataExpedicaoCTPS,
   DataValidadeCTPS = @DataValidadeCTPS,
   CPFColaborador = @CPFColaborador,
   NumeroRGColaborador = @NumeroRGColaborador,
   OrgaoExpedicaoRGColaborador = @OrgaoExpedicaoRGColaborador,
   DataExpedicaoRGColaborador = @DataExpedicaoRGColaborador,
   DataValidadeRGColaborador = @DataValidadeRGColaborador,
   NumeroPIS = @NumeroPIS,
   DataCadastroPIS = @DataCadastroPIS,
   NumeroTituloEleitor = @NumeroTituloEleitor,
   ZonaTituloEleitor = @ZonaTituloEleitor,
   SecaoTituloEleitor = @SecaoTituloEleitor,
   EmissaoTituloEleitor = @EmissaoTituloEleitor,
   ValidadeHabilitacao = @ValidadeHabilitacao,
   NomePai = @NomePai,
   NomeMae = @NomeMae,
   SexoColaborador = @SexoColaborador,
   RegHabilitacaoProfissional = @RegHabilitacaoProfissional,
   DataNascimentoColaborador = @DataNascimentoColaborador,
   NaturalidadeColaborador = @NaturalidadeColaborador,
   TipoVistoEstrangeiro = @TipoVistoEstrangeiro,
   AnoChegada = @AnoChegada,
   DataAdmissao = @DataAdmissao,
   DataDemissao = @DataDemissao,
   HorasMensaisColaborador = @HorasMensaisColaborador,
   CaptaPonto = @CaptaPonto,
   Chapa = @Chapa,
   FotoColaborador = @FotoColaborador,
   NumeroCarteiraHabilitacao = @NumeroCarteiraHabilitacao,
   CategoriaHabilitacao = @CategoriaHabilitacao,
   ExpedicaoHabilitacao = @ExpedicaoHabilitacao,
   UFExpedicaoRGColaborador = @UFExpedicaoRGColaborador,
   UFNascimentoColaborador = @UFNascimentoColaborador,
   UFTituloEleitor = @UFTituloEleitor,
   UFCTPS = @UFCTPS,
   CodigoConselhoRegional = @CodigoConselhoRegional,
   CodigoNacionalidade = @CodigoNacionalidade,
   CodigoEstadoCivil = @CodigoEstadoCivil,
   CodigoCargo = @CodigoCargo,
   CodigoGrauInstrucao = @CodigoGrauInstrucao,
   CodigoMaoObra = @CodigoMaoObra,
   CodigoRacaCor = @CodigoRacaCor,
   DeficienteFisico = @DeficienteFisico,
   AlvaraJuridico = @AlvaraJuridico,
   BRPDHColaborador = @BRPDHColaborador,
   RegimeRevezamento = @RegimeRevezamento,
   ObservacaoColaborador = @ObservacaoColaborador,
   DataFimContratoEstagio = @DataFimContratoEstagio,
   TipoDeficiencia = @TipoDeficiencia,
   PercentualComissao = @PercentualComissao,
   ObsLivreColaborador = @ObsLivreColaborador
WHERE 
   CodigoEmpresa = @CodigoEmpresa AND
   CodigoLocal = @CodigoLocal AND
   TipoColaborador = @TipoColaborador AND
   NumeroRegistro = @NumeroRegistro 
go
DROP PROCEDURE dbo.spIColaborador
GO
CREATE PROCEDURE dbo.spIColaborador
   @CodigoEmpresa numeric(4) ,
   @CodigoLocal numeric(4) ,
   @TipoColaborador char(1) ,
   @NumeroRegistro numeric(8) ,
   @NumeroCTPS numeric(8) ,
   @SerieCTPS char(6) ,
   @DataExpedicaoCTPS datetime ,
   @DataValidadeCTPS datetime = Null,
   @CPFColaborador char(14) = Null,
   @NumeroRGColaborador char(15) = Null,
   @OrgaoExpedicaoRGColaborador char(4) = Null,
   @DataExpedicaoRGColaborador datetime = Null,
   @DataValidadeRGColaborador datetime = Null,
   @NumeroPIS numeric(12) = Null,
   @DataCadastroPIS datetime = Null,
   @NumeroTituloEleitor char(15) = Null,
   @ZonaTituloEleitor char(3) = Null,
   @SecaoTituloEleitor char(4) = Null,
   @EmissaoTituloEleitor datetime = Null,
   @ValidadeHabilitacao datetime = Null,
   @NomePai char(30) = Null,
   @NomeMae char(30) ,
   @SexoColaborador char(1) ,
   @RegHabilitacaoProfissional numeric(10) = Null,
   @DataNascimentoColaborador datetime ,
   @NaturalidadeColaborador char(30) ,
   @TipoVistoEstrangeiro char(15) = Null,
   @AnoChegada numeric(4) = Null,
   @DataAdmissao datetime ,
   @DataDemissao datetime = Null,
   @HorasMensaisColaborador numeric(6,2) = 0,
   @CaptaPonto char(1) = 'F',
   @Chapa numeric(8) = Null,
   @FotoColaborador varchar(255) = Null,
   @NumeroCarteiraHabilitacao char(15) = Null,
   @CategoriaHabilitacao char(3) = Null,
   @ExpedicaoHabilitacao datetime = Null,
   @UFExpedicaoRGColaborador char(2) = Null,
   @UFNascimentoColaborador char(2) ,
   @UFTituloEleitor char(2) = Null,
   @UFCTPS char(2) ,
   @CodigoConselhoRegional numeric(4) = Null,
   @CodigoNacionalidade numeric(2) ,
   @CodigoEstadoCivil numeric(2) ,
   @CodigoCargo numeric(6) ,
   @CodigoGrauInstrucao numeric(2) ,
   @CodigoMaoObra numeric(2) ,
   @CodigoRacaCor numeric(2) = Null,
   @DeficienteFisico char(1) = 'F',
   @AlvaraJuridico char(1) = 'F',
   @BRPDHColaborador char(1) = Null,
   @RegimeRevezamento char(15) = Null,
   @ObservacaoColaborador varchar(400) = Null,
   @DataFimContratoEstagio datetime = Null,
   @TipoDeficiencia numeric(2) = 0,
   @PercentualComissao numeric(5,2) = 0,
   @ObsLivreColaborador Varchar(500) = NULL
AS 
INSERT tbColaborador
   (CodigoEmpresa,
   CodigoLocal,
   TipoColaborador,
   NumeroRegistro,
   NumeroCTPS,
   SerieCTPS,
   DataExpedicaoCTPS,
   DataValidadeCTPS,
   CPFColaborador,
   NumeroRGColaborador,
   OrgaoExpedicaoRGColaborador,
   DataExpedicaoRGColaborador,
   DataValidadeRGColaborador,
   NumeroPIS,
   DataCadastroPIS,
   NumeroTituloEleitor,
   ZonaTituloEleitor,
   SecaoTituloEleitor,
   EmissaoTituloEleitor,
   ValidadeHabilitacao,
   NomePai,
   NomeMae,
   SexoColaborador,
   RegHabilitacaoProfissional,
   DataNascimentoColaborador,
   NaturalidadeColaborador,
   TipoVistoEstrangeiro,
   AnoChegada,
   DataAdmissao,
   DataDemissao,
   HorasMensaisColaborador,
   CaptaPonto,
   Chapa,
   FotoColaborador,
   NumeroCarteiraHabilitacao,
   CategoriaHabilitacao,
   ExpedicaoHabilitacao,
   UFExpedicaoRGColaborador,
   UFNascimentoColaborador,
   UFTituloEleitor,
   UFCTPS,
   CodigoConselhoRegional,
   CodigoNacionalidade,
   CodigoEstadoCivil,
   CodigoCargo,
   CodigoGrauInstrucao,
   CodigoMaoObra,
   CodigoRacaCor,
   DeficienteFisico,
   AlvaraJuridico,
   BRPDHColaborador,
   RegimeRevezamento,
   ObservacaoColaborador,
   DataFimContratoEstagio,
   TipoDeficiencia,
   PercentualComissao,
   ObsLivreColaborador)
VALUES
   (@CodigoEmpresa,
   @CodigoLocal,
   @TipoColaborador,
   @NumeroRegistro,
   @NumeroCTPS,
   @SerieCTPS,
   @DataExpedicaoCTPS,
   @DataValidadeCTPS,
   @CPFColaborador,
   @NumeroRGColaborador,
   @OrgaoExpedicaoRGColaborador,
   @DataExpedicaoRGColaborador,
   @DataValidadeRGColaborador,
   @NumeroPIS,
   @DataCadastroPIS,
   @NumeroTituloEleitor,
   @ZonaTituloEleitor,
   @SecaoTituloEleitor,
   @EmissaoTituloEleitor,
   @ValidadeHabilitacao,
   @NomePai,
   @NomeMae,
   @SexoColaborador,
   @RegHabilitacaoProfissional,
   @DataNascimentoColaborador,
   @NaturalidadeColaborador,
   @TipoVistoEstrangeiro,
   @AnoChegada,
   @DataAdmissao,
   @DataDemissao,
   @HorasMensaisColaborador,
   @CaptaPonto,
   @Chapa,
   @FotoColaborador,
   @NumeroCarteiraHabilitacao,
   @CategoriaHabilitacao,
   @ExpedicaoHabilitacao,
   @UFExpedicaoRGColaborador,
   @UFNascimentoColaborador,
   @UFTituloEleitor,
   @UFCTPS,
   @CodigoConselhoRegional,
   @CodigoNacionalidade,
   @CodigoEstadoCivil,
   @CodigoCargo,
   @CodigoGrauInstrucao,
   @CodigoMaoObra,
   @CodigoRacaCor,
   @DeficienteFisico,
   @AlvaraJuridico,
   @BRPDHColaborador,
   @RegimeRevezamento,
   @ObservacaoColaborador,
   @DataFimContratoEstagio,
   @TipoDeficiencia,
   @PercentualComissao,
   @ObsLivreColaborador)
