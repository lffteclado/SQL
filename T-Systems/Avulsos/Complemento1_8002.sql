ALTER TABLE tbCaracteristicaImpressoraECF ALTER COLUMN NumeroSerieFabricacaoECF CHAR(20)
GO
DROP PROCEDURE dbo.spICaracteristicaImpressoraECF
GO
CREATE PROCEDURE dbo.spICaracteristicaImpressoraECF
   @CodigoEmpresa numeric(4) ,
   @CodigoLocal numeric(4) ,
   @CodigoImpressoraECF char(8) ,
   @DescricaoImpressoraECF char(30) = Null,
   @NumeroMaquinaGeracaoECF char(4) ,
   @NumeroSerieFabricacaoECF char(20) ,
   @NumeroColunasImpressoraECF numeric(2) ,
   @FamiliaImpressoraECF numeric(1) = Null,
   @CaminhoRedeECF varchar(255) = Null,
   @CaminhoRedeRCF varchar(255) = Null,
   @NomeArquivoECF varchar(255) = Null,
   @NomeArquivoRCF varchar(255) = Null
AS 
INSERT tbCaracteristicaImpressoraECF
   (CodigoEmpresa,
   CodigoLocal,
   CodigoImpressoraECF,
   DescricaoImpressoraECF,
   NumeroMaquinaGeracaoECF,
   NumeroSerieFabricacaoECF,
   NumeroColunasImpressoraECF,
   FamiliaImpressoraECF,
   CaminhoRedeECF,
   CaminhoRedeRCF,
   NomeArquivoECF,
   NomeArquivoRCF)
VALUES
   (@CodigoEmpresa,
   @CodigoLocal,
   @CodigoImpressoraECF,
   @DescricaoImpressoraECF,
   @NumeroMaquinaGeracaoECF,
   @NumeroSerieFabricacaoECF,
   @NumeroColunasImpressoraECF,
   @FamiliaImpressoraECF,
   @CaminhoRedeECF,
   @CaminhoRedeRCF,
   @NomeArquivoECF,
   @NomeArquivoRCF)
GO

DROP PROCEDURE dbo.spACaracteristicaImpressoraECF
GO
CREATE PROCEDURE dbo.spACaracteristicaImpressoraECF
   @CodigoEmpresa numeric(4) ,
   @CodigoLocal numeric(4) ,
   @CodigoImpressoraECF char(8) ,
   @DescricaoImpressoraECF char(30) = Null,
   @NumeroMaquinaGeracaoECF char(4) ,
   @NumeroSerieFabricacaoECF char(20) ,
   @NumeroColunasImpressoraECF numeric(2) ,
   @FamiliaImpressoraECF numeric(1) = Null,
   @CaminhoRedeECF varchar(255) = Null,
   @CaminhoRedeRCF varchar(255) = Null,
   @NomeArquivoECF varchar(255) = Null,
   @NomeArquivoRCF varchar(255) = Null
AS 
UPDATE tbCaracteristicaImpressoraECF
SET
   DescricaoImpressoraECF = @DescricaoImpressoraECF,
   NumeroMaquinaGeracaoECF = @NumeroMaquinaGeracaoECF,
   NumeroSerieFabricacaoECF = @NumeroSerieFabricacaoECF,
   NumeroColunasImpressoraECF = @NumeroColunasImpressoraECF,
   FamiliaImpressoraECF = @FamiliaImpressoraECF,
   CaminhoRedeECF = @CaminhoRedeECF,
   CaminhoRedeRCF = @CaminhoRedeRCF,
   NomeArquivoECF = @NomeArquivoECF,
   NomeArquivoRCF = @NomeArquivoRCF
WHERE 
   CodigoEmpresa = @CodigoEmpresa AND
   CodigoLocal = @CodigoLocal AND
   CodigoImpressoraECF = @CodigoImpressoraECF 
GO

ALTER TABLE tbPedidoComplementar ALTER COLUMN SerieECFPed CHAR(20) NULL
GO

DROP PROCEDURE dbo.spIPedidoComplementar
GO
CREATE PROCEDURE dbo.spIPedidoComplementar
   @CodigoEmpresa numeric(4) ,
   @CodigoLocal numeric(4) ,
   @CentroCusto numeric(8) ,
   @NumeroPedido numeric(6) ,
   @SequenciaPedido numeric(2) = 0,
   @NumeroNFTemporaria numeric(6) = Null,
   @SerieECFPed char(20) = Null,
   @CodigoCFO numeric(5) = Null,
   @CodigoCliFor numeric(14) = Null,
   @EntradaSaidaDocumento char(1) = Null,
   @NumeroDocumento numeric(6) = Null,
   @DataDocumento datetime = Null,
   @TipoLancamentoMovimentacao numeric(2) = Null,
   @CodigoEmbalComercial1 numeric(2) = Null,
   @CodigoEmbalComercial2 numeric(2) = Null,
   @CodigoEmbalComercial3 numeric(2) = Null,
   @CodigoEmbalComercial4 numeric(2) = Null,
   @CodigoEmbalComercial5 numeric(2) = Null,
   @NumeroECFPed char(6) = Null,
   @TipoArquivoTEF char(3) = Null,
   @IdentificacaoTEF numeric(10) = Null,
   @NotaFiscalOriginal numeric(6) = Null,
   @DataEmissaoNFOriginal datetime = Null
AS 
INSERT tbPedidoComplementar
   (CodigoEmpresa,
   CodigoLocal,
   CentroCusto,
   NumeroPedido,
   SequenciaPedido,
   NumeroNFTemporaria,
   SerieECFPed,
   CodigoCFO,
   CodigoCliFor,
   EntradaSaidaDocumento,
   NumeroDocumento,
   DataDocumento,
   TipoLancamentoMovimentacao,
   CodigoEmbalComercial1,
   CodigoEmbalComercial2,
   CodigoEmbalComercial3,
   CodigoEmbalComercial4,
   CodigoEmbalComercial5,
   NumeroECFPed,
   TipoArquivoTEF,
   IdentificacaoTEF,
   NotaFiscalOriginal,
   DataEmissaoNFOriginal)
VALUES
   (@CodigoEmpresa,
   @CodigoLocal,
   @CentroCusto,
   @NumeroPedido,
   @SequenciaPedido,
   @NumeroNFTemporaria,
   @SerieECFPed,
   @CodigoCFO,
   @CodigoCliFor,
   @EntradaSaidaDocumento,
   @NumeroDocumento,
   @DataDocumento,
   @TipoLancamentoMovimentacao,
   @CodigoEmbalComercial1,
   @CodigoEmbalComercial2,
   @CodigoEmbalComercial3,
   @CodigoEmbalComercial4,
   @CodigoEmbalComercial5,
   @NumeroECFPed,
   @TipoArquivoTEF,
   @IdentificacaoTEF,
   @NotaFiscalOriginal,
   @DataEmissaoNFOriginal)
GO

DROP PROCEDURE dbo.spAPedidoComplementar
GO
CREATE PROCEDURE dbo.spAPedidoComplementar
   @CodigoEmpresa numeric(4) ,
   @CodigoLocal numeric(4) ,
   @CentroCusto numeric(8) ,
   @NumeroPedido numeric(6) ,
   @SequenciaPedido numeric(2) = 0,
   @NumeroNFTemporaria numeric(6) = Null,
   @SerieECFPed char(20) = Null,
   @CodigoCFO numeric(5) = Null,
   @CodigoCliFor numeric(14) = Null,
   @EntradaSaidaDocumento char(1) = Null,
   @NumeroDocumento numeric(6) = Null,
   @DataDocumento datetime = Null,
   @TipoLancamentoMovimentacao numeric(2) = Null,
   @CodigoEmbalComercial1 numeric(2) = Null,
   @CodigoEmbalComercial2 numeric(2) = Null,
   @CodigoEmbalComercial3 numeric(2) = Null,
   @CodigoEmbalComercial4 numeric(2) = Null,
   @CodigoEmbalComercial5 numeric(2) = Null,
   @NumeroECFPed char(6) = Null,
   @TipoArquivoTEF char(3) = Null,
   @IdentificacaoTEF numeric(10) = Null,
   @NotaFiscalOriginal numeric(6) = Null,
   @DataEmissaoNFOriginal datetime = null
AS 
UPDATE tbPedidoComplementar
SET
   NumeroNFTemporaria = @NumeroNFTemporaria,
   SerieECFPed = @SerieECFPed,
   CodigoCFO = @CodigoCFO,
   CodigoCliFor = @CodigoCliFor,
   EntradaSaidaDocumento = @EntradaSaidaDocumento,
   NumeroDocumento = @NumeroDocumento,
   DataDocumento = @DataDocumento,
   TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao,
   CodigoEmbalComercial1 = @CodigoEmbalComercial1,
   CodigoEmbalComercial2 = @CodigoEmbalComercial2,
   CodigoEmbalComercial3 = @CodigoEmbalComercial3,
   CodigoEmbalComercial4 = @CodigoEmbalComercial4,
   CodigoEmbalComercial5 = @CodigoEmbalComercial5,
   NumeroECFPed = @NumeroECFPed,
   TipoArquivoTEF = @TipoArquivoTEF,
   IdentificacaoTEF = @IdentificacaoTEF,
   NotaFiscalOriginal = @NotaFiscalOriginal,
   DataEmissaoNFOriginal = @DataEmissaoNFOriginal
WHERE 
   CodigoEmpresa = @CodigoEmpresa AND
   CodigoLocal = @CodigoLocal AND
   CentroCusto = @CentroCusto AND
   NumeroPedido = @NumeroPedido AND
   SequenciaPedido = @SequenciaPedido 
GO



declare @Script			varchar(255)
declare @login			varchar(255)
select @login = (select distinct nt_username from master..sysprocesses where spid = @@spid)
select @Script = '0434FM007142.sql'

insert into tbControleScript 
(NomeScript, DataExecucaoScript, LoginUsuario)
values 
(@Script, getdate(), @login)
go

go

DROP PROCEDURE dbo.spISequenciaDocumento
GO
CREATE PROCEDURE dbo.spISequenciaDocumento
   @CodigoEmpresa numeric(4) ,
   @CodigoLocal numeric(4) ,
   @CodigoModeloNotaFiscal numeric(2),
   @SerieModeloNotaFiscal char(4),
   @SequenciaDocumentoEntrada numeric(6) = 0,
   @SequenciaDocumentoSaida numeric(6) = 0,
   @SequenciaDocumentoUnificado numeric(6) = 0,
   @NumeroSequencialUnico numeric(10) = 0
AS 
INSERT tbSequenciaDocumento
   (CodigoEmpresa,
   CodigoLocal,
   CodigoModeloNotaFiscal,
   SerieModeloNotaFiscal,
   SequenciaDocumentoEntrada,
   SequenciaDocumentoSaida,
   SequenciaDocumentoUnificado,
   NumeroSequencialUnico)
VALUES
   (@CodigoEmpresa,
   @CodigoLocal,
   @CodigoModeloNotaFiscal,
   @SerieModeloNotaFiscal,
   @SequenciaDocumentoEntrada,
   @SequenciaDocumentoSaida,
   @SequenciaDocumentoUnificado,
   @NumeroSequencialUnico)


GO
DROP PROCEDURE dbo.spASequenciaDocumento
GO
CREATE PROCEDURE dbo.spASequenciaDocumento
   @CodigoEmpresa numeric(4) ,
   @CodigoLocal numeric(4) ,
   @CodigoModeloNotaFiscal numeric(2),
   @SerieModeloNotaFiscal char(4),
   @SequenciaDocumentoEntrada numeric(6) = 0,
   @SequenciaDocumentoSaida numeric(6) = 0,
   @SequenciaDocumentoUnificado numeric(6) = 0,
   @NumeroSequencialUnico numeric(10) = 0
AS 
UPDATE tbSequenciaDocumento
SET
   SequenciaDocumentoEntrada = @SequenciaDocumentoEntrada,
   SequenciaDocumentoSaida = @SequenciaDocumentoSaida,
   SequenciaDocumentoUnificado = @SequenciaDocumentoUnificado,
   NumeroSequencialUnico = @NumeroSequencialUnico
WHERE 
   CodigoEmpresa = @CodigoEmpresa AND
   CodigoLocal = @CodigoLocal AND
   CodigoModeloNotaFiscal = @CodigoModeloNotaFiscal AND
   SerieModeloNotaFiscal = @SerieModeloNotaFiscal


GO
DROP PROCEDURE dbo.spESequenciaDocumento 
GO
CREATE PROCEDURE dbo.spESequenciaDocumento 
   @CodigoEmpresa numeric(4) ,
   @CodigoLocal numeric(4) ,
   @CodigoModeloNotaFiscal numeric(2),
   @SerieModeloNotaFiscal char(4)
AS
DELETE tbSequenciaDocumento
WHERE 
   CodigoEmpresa = @CodigoEmpresa AND
   CodigoLocal = @CodigoLocal AND
   CodigoModeloNotaFiscal = @CodigoModeloNotaFiscal AND
   SerieModeloNotaFiscal = @SerieModeloNotaFiscal


GO
DROP PROCEDURE dbo.spLSequenciaDocumento
GO
CREATE PROCEDURE dbo.spLSequenciaDocumento
   @CodigoEmpresa numeric(4) = Null,
   @CodigoLocal numeric(4) = Null,
   @CodigoModeloNotaFiscal numeric(2) = Null,
   @SerieModeloNotaFiscal char(4) = Null
AS 
   SELECT 'DHDADOS', 'SELECT * FROM tbSequenciaDocumento (NOLOCK)
   WHERE ',  CASE
   WHEN  @CodigoEmpresa IS NULL THEN ''
   ELSE
   'CodigoEmpresa = ' + convert(varchar,@CodigoEmpresa)
+' AND' END , CASE
   WHEN  @CodigoLocal IS NULL THEN ''
   ELSE
   'CodigoLocal = ' + convert(varchar,@CodigoLocal)
+' AND' END , CASE
   WHEN  @CodigoModeloNotaFiscal IS NULL THEN ''
   ELSE
   'CodigoModeloNotaFiscal = ' + convert(varchar,@CodigoModeloNotaFiscal)
+' AND' END , CASE
   WHEN  @SerieModeloNotaFiscal IS NULL THEN ''
   ELSE
   'SerieModeloNotaFiscal = ' + convert(varchar,@SerieModeloNotaFiscal)
END

GO
DROP PROCEDURE dbo.spPSequenciaDocumento
GO
CREATE PROCEDURE dbo.spPSequenciaDocumento
   @CodigoEmpresa numeric(4),
   @CodigoLocal numeric(4),
   @CodigoModeloNotaFiscal numeric(2),
   @SerieModeloNotaFiscal char(4)
AS 
   SELECT * FROM tbSequenciaDocumento
   WHERE 
      CodigoEmpresa = @CodigoEmpresa AND
      CodigoLocal = @CodigoLocal AND
      CodigoModeloNotaFiscal = @CodigoModeloNotaFiscal AND
      SerieModeloNotaFiscal = @SerieModeloNotaFiscal


GO
drop proc dbo.spIFormularioDocumentos
GO
CREATE PROCEDURE dbo.spIFormularioDocumentos
   @CodigoEmpresa numeric(4) ,
   @CodigoSistema char(2) ,
   @CodigoFormLayOutDoc char(15) ,
   @DescricaoFormLayOutDoc char(60) ,
   @CaracteristicaFormLayOutDoc char(1) ,
   @CompactacaoFormLayOutDoc numeric(2) ,
   @PortaLocalFormLayOutDoc char(5) = Null,
   @DispositivoSaidaFormLayOutDoc char(60) = Null,
   @QtdeColunasFormLayOutDoc numeric(4) = 0,
   @QtdeFormPaginaFormLayOutDoc numeric(2) = 1,
   @CodigoImpressora char(8) ,
   @NumeroLinhasDuplicata numeric(3) = 0,
   @CodigoModeloNotaFiscal numeric(2) = Null,
   @SerieModeloNotaFiscal char(4) = Null,
   @EspecieModeloNotaFiscal char(3) = Null
AS 
INSERT tbFormularioDocumentos
   (CodigoEmpresa,
   CodigoSistema,
   CodigoFormLayOutDoc,
   DescricaoFormLayOutDoc,
   CaracteristicaFormLayOutDoc,
   CompactacaoFormLayOutDoc,
   PortaLocalFormLayOutDoc,
   DispositivoSaidaFormLayOutDoc,
   QtdeColunasFormLayOutDoc,
   QtdeFormPaginaFormLayOutDoc,
   CodigoImpressora,
   NumeroLinhasDuplicata,
   CodigoModeloNotaFiscal,
   SerieModeloNotaFiscal,
   EspecieModeloNotaFiscal)
VALUES
   (@CodigoEmpresa,
   @CodigoSistema,
   @CodigoFormLayOutDoc,
   @DescricaoFormLayOutDoc,
   @CaracteristicaFormLayOutDoc,
   @CompactacaoFormLayOutDoc,
   @PortaLocalFormLayOutDoc,
   @DispositivoSaidaFormLayOutDoc,
   @QtdeColunasFormLayOutDoc,
   @QtdeFormPaginaFormLayOutDoc,
   @CodigoImpressora,
   @NumeroLinhasDuplicata,
   @CodigoModeloNotaFiscal,
   @SerieModeloNotaFiscal,
   @EspecieModeloNotaFiscal)

GO
drop proc dbo.spAFormularioDocumentos
GO
CREATE PROCEDURE dbo.spAFormularioDocumentos
   @CodigoEmpresa numeric(4) ,
   @CodigoSistema char(2) ,
   @CodigoFormLayOutDoc char(15) ,
   @DescricaoFormLayOutDoc char(60) ,
   @CaracteristicaFormLayOutDoc char(1) ,
   @CompactacaoFormLayOutDoc numeric(2) ,
   @PortaLocalFormLayOutDoc char(5) = Null,
   @DispositivoSaidaFormLayOutDoc char(60) = Null,
   @QtdeColunasFormLayOutDoc numeric(4) = 0,
   @QtdeFormPaginaFormLayOutDoc numeric(2) = 1,
   @CodigoImpressora char(8) ,
   @NumeroLinhasDuplicata numeric(3) = 0,
   @CodigoModeloNotaFiscal numeric(2) = Null,
   @SerieModeloNotaFiscal char(4) = Null,
   @EspecieModeloNotaFiscal char(3) = Null
AS 
UPDATE tbFormularioDocumentos
SET
   DescricaoFormLayOutDoc = @DescricaoFormLayOutDoc,
   CaracteristicaFormLayOutDoc = @CaracteristicaFormLayOutDoc,
   CompactacaoFormLayOutDoc = @CompactacaoFormLayOutDoc,
   PortaLocalFormLayOutDoc = @PortaLocalFormLayOutDoc,
   DispositivoSaidaFormLayOutDoc = @DispositivoSaidaFormLayOutDoc,
   QtdeColunasFormLayOutDoc = @QtdeColunasFormLayOutDoc,
   QtdeFormPaginaFormLayOutDoc = @QtdeFormPaginaFormLayOutDoc,
   CodigoImpressora = @CodigoImpressora,
   NumeroLinhasDuplicata = @NumeroLinhasDuplicata,
   CodigoModeloNotaFiscal = @CodigoModeloNotaFiscal,
   SerieModeloNotaFiscal = @SerieModeloNotaFiscal,
   EspecieModeloNotaFiscal = @EspecieModeloNotaFiscal
WHERE 
   CodigoEmpresa = @CodigoEmpresa AND
   CodigoSistema = @CodigoSistema AND
   CodigoFormLayOutDoc = @CodigoFormLayOutDoc 






execute sp_unbindrule 'tbFormularioDocumentos.CaracteristicaFormLayOutDoc'

GO
DROP RULE rlTipoBCDEFGINORS

GO
CREATE RULE rlTipoBCDEFGILNORS
	AS @col IN ('B', 'C', 'D', 'E', 'F', 'G', 'I', 'L', 'N', 'O', 'R', 'S')

GO
execute sp_bindrule rlTipoBCDEFGILNORS, 'tbFormularioDocumentos.CaracteristicaFormLayOutDoc'

GO
IF NOT EXISTS (SELECT 1 FROM tbModeloNotaFiscal WHERE CodigoModeloNotaFiscal = 1)
	EXEC spIModeloNotaFiscal 1, 'NOTA FISCAL'
ELSE
	EXEC spAModeloNotaFiscal 1, 'NOTA FISCAL'

GO
IF NOT EXISTS (SELECT 1 FROM tbModeloNotaFiscal WHERE CodigoModeloNotaFiscal = 55)
	EXEC spIModeloNotaFiscal 55, 'NOTA FISCAL ELETRONICA'
ELSE
	EXEC spAModeloNotaFiscal 55, 'NOTA FISCAL ELETRONICA'

GO
IF NOT EXISTS (SELECT 1 FROM tbModeloNotaFiscal WHERE CodigoModeloNotaFiscal = 99)
	EXEC spIModeloNotaFiscal 99, 'RECIBO DE LOCACAO'
ELSE
	EXEC spAModeloNotaFiscal 99, 'RECIBO DE LOCACAO'

GO
UPDATE	tbFormularioDocumentos
SET	CaracteristicaFormLayOutDoc = 'L'
WHERE	CodigoSistema		= 'FT'
AND	CodigoFormLayOutDoc	LIKE '%REC%LOC%'


go

INSERT tbParametro 
SELECT DISTINCT
	CNPJ,
	'USACRYPTODEALER',
	'TRUE', 
	getdate()
from tbParametro (NOLOCK)




go

SELECT * INTO deleted FROM tbOROSCIT WHERE 1 = 2
SELECT * INTO inserted FROM tbOROSCIT WHERE 1 = 2
GO
IF OBJECT_ID('tnu_DSPa_OROSCIT') IS NOT NULL
	DROP TRIGGER dbo.tnu_DSPa_OROSCIT
GO

CREATE TRIGGER dbo.tnu_DSPa_OROSCIT ON tbOROSCIT
WITH ENCRYPTION
FOR UPDATE AS
SET NOCOUNT ON

IF UPDATE(StatusOSCIT) OR UPDATE(CodigoCliFor)
BEGIN

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda.
 PROJETO......: Controle de Oficina
 AUTOR........: Carlos JSC
 DATA.........: 13/11/2008
 OBJETIVO.....: Ao alterar STATUS na tbOROSCIT dispara trigger acima para
		atualizar a tbRegistroMovtoEstoque com a movimentação do chassi 
		caso a OS esteja sendo cancelada.

-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

DECLARE @IDataOROS			DATETIME
DECLARE @IPeriodoMovtoEstoque		CHAR(6)
DECLARE @PeriodoEmpresaCE		CHAR(6)
DECLARE @QuantidadeDiferenca		NUMERIC(16,4)
DECLARE @ErrNo				INT
DECLARE	@ErrMsg				VARCHAR(255)
DECLARE @MarcaFabricanteEmpresa		INT
DECLARE @ConjuntoMaior			CHAR(1)
DECLARE @CodigoChassi			CHAR(30)
DECLARE @QuantidadeRegistros		INT
DECLARE @StatusOSCITA			CHAR(1)
DECLARE @StatusOSCITN			CHAR(1)
DECLARE @CodigoCliForAnterior           NUMERIC(14)
DECLARE @CodigoCliForNovo               NUMERIC(14)

-- Variaveis do Cursor
DECLARE @CodigoEmpresa			dtInteiro04
DECLARE	@CodigoLocal			dtInteiro04
DECLARE @NumeroOROS			dtInteiro06
DECLARE @FlagOROS			CHAR(1)
DECLARE @CodigoCIT			CHAR(4)
DECLARE	@CodigoProduto			dtCharacter30
DECLARE @QuantidadeOROS			numeric(4)
DECLARE	@CodigoAlmoxarifadoOrigem	CHAR(6)
DECLARE	@CodigoAlmoxarifadoDestino	CHAR(6)

IF EXISTS ( SELECT 1 FROM master.dbo.sysprocesses WHERE spid = @@Spid AND program_name LIKE '%SQL%' )
BEGIN
	IF EXISTS (SELECT 1 FROM inserted i
			INNER JOIN deleted d
			ON	d.CodigoEmpresa			= i.CodigoEmpresa
			AND	d.CodigoLocal			= i.CodigoLocal
			AND	d.FlagOROS			= i.FlagOROS
			AND	d.NumeroOROS			= i.NumeroOROS
			AND	d.CodigoCIT			= i.CodigoCIT
			WHERE	d.StatusOSCIT			= 'U'
			AND	i.StatusOSCIT			IN ('A', 'E'))
	BEGIN
		SELECT @ErrNo = 64557
		SELECT @ErrMsg = 'Tentativa de violação de integridade(OS). Voce esta sendo monitorado!'
		GOTO ERROR
	END
END

SELECT	@IDataOROS = CONVERT(DATETIME,(CONVERT(VARCHAR(20),GETDATE(),112)),114)

SELECT	@IPeriodoMovtoEstoque = CONVERT(NUMERIC(6), CONVERT(CHAR(6), @IDataOROS,112))

SELECT	@MarcaFabricanteEmpresa = tbEmpresa.MarcaFabricanteEmpresa
FROM	inserted
	inner join tbEmpresa (nolock)
		on tbEmpresa.CodigoEmpresa = inserted.CodigoEmpresa

--------------  Processar somente para marca fabricante = aeronaltica  --------------------------------
--------------  Verifica se o Veiculo é um conjunto maior  --------------------------------------------

SELECT	@ConjuntoMaior = tbVeiculoOS.ConjuntoMaior,
	@CodigoChassi  = tbOROS.ChassiVeiculoOS,
	@CodigoEmpresa = inserted.CodigoEmpresa,
	@CodigoLocal = inserted.CodigoLocal,
	@FlagOROS = inserted.FlagOROS,
	@NumeroOROS = inserted.NumeroOROS,
	@CodigoCIT  = inserted.CodigoCIT
	FROM inserted (nolock)

	inner join tbOROS
		on  tbOROS.CodigoEmpresa = inserted.CodigoEmpresa
		and tbOROS.CodigoLocal 	 = inserted.CodigoLocal
		and tbOROS.FlagOROS 	 = inserted.FlagOROS
		and tbOROS.NumeroOROS 	 = inserted.NumeroOROS
		
	inner join tbVeiculoOS 
		on  tbVeiculoOS.CodigoEmpresa   = tbOROS.CodigoEmpresa
		and tbVeiculoOS.ChassiVeiculoOS = tbOROS.ChassiVeiculoOS

---------------  Pega status antigo da OROSCIT  -------------------
SELECT	@StatusOSCITA = deleted.StatusOSCIT,
	@CodigoCliForAnterior = deleted.CodigoCliFor
	FROM deleted (nolock)

---------------  Pega status novo da OROSCIT  ---------------------
SELECT	@StatusOSCITN = inserted.StatusOSCIT,
	@CodigoCliForNovo = inserted.CodigoCliFor
	FROM inserted (nolock)

-------------------------------------------------------------------

---SELECT @MarcaFabricanteEmpresa , @ConjuntoMaior 

IF @MarcaFabricanteEmpresa = 37 AND @ConjuntoMaior = 'V' 
BEGIN

----------------  Verifica se esta sendo alterado o codigo do cliente faturar, se o mesmo somente pode ser alterado
----------------  se não existir itens de terceiro requisitados, pois o almoxarifado de origem pode ser diferente
----------------  e neste caso o usuario deverá devolver as peças de terceiro, alterar o cliente e requisitar 
----------------  novamente no novo cliente.

IF @CodigoCliForAnterior <> @CodigoCliForNovo
BEGIN
	IF EXISTS (SELECT 1 FROM tbItemOROS
				WHERE tbItemOROS.CodigoEmpresa = @CodigoEmpresa
				AND   tbItemOROS.CodigoLocal = @CodigoLocal
				AND   tbItemOROS.FlagOROS = @FlagOROS
				AND   tbItemOROS.NumeroOROS = @NumeroOROS
				AND   tbItemOROS.CodigoCIT = @CodigoCIT
				AND   tbItemOROS.TipoItemOS = 'T')

	BEGIN
		SELECT @ErrNo = 72998
		SELECT @ErrMsg = 'Alteração não permitida, primeiro deverá devolver os Itens de Terceiros Requisitados para o Cliente.'
		GOTO ERROR
	END
END
------------------------------------------------------------------------------------------------------------------------

-- Retorno do Periodo Empresa CG
SELECT	@PeriodoEmpresaCE	= CONVERT(NUMERIC(6), tbEmpresaCE.PeriodoAtualEstoque),
	@CodigoEmpresa		= inserted.CodigoEmpresa,
	@CodigoLocal		= inserted.CodigoLocal
FROM	tbEmpresaCE, inserted
WHERE	tbEmpresaCE.CodigoEmpresa = inserted.CodigoEmpresa


-- Checa o Periodo da Insercao
IF  @IPeriodoMovtoEstoque > @PeriodoEmpresaCE
	BEGIN
		SELECT @IDataOROS = DATEADD(dd,-1,(DATEADD(mm,1,(@PeriodoEmpresaCE + '01'))))
		SELECT @IDataOROS = dbo.fnUltimoDiaUtil(	@CodigoEmpresa,
								@CodigoLocal,
								@IDataOROS)
	END

IF  @IPeriodoMovtoEstoque < @PeriodoEmpresaCE
	BEGIN
		SELECT @ErrNo = 88164
		SELECT @ErrMsg = 'Data de Movimento do Estoque não condiz com o Período do Estoque.'
		GOTO ERROR
	END

IF EXISTS (SELECT 1 FROM inserted i
		INNER JOIN deleted d
		ON	d.CodigoEmpresa			= i.CodigoEmpresa
		AND	d.CodigoLocal			= i.CodigoLocal
		AND	d.FlagOROS			= i.FlagOROS
		AND	d.NumeroOROS			= i.NumeroOROS
		AND	d.CodigoCIT			= i.CodigoCIT
		WHERE	d.StatusOSCIT			!= i.StatusOSCIT)

BEGIN

/*	select @QuantidadeRegistros = (select count(tbOROSCIT.NumeroOROS) 
				from tbOROSCIT
				inner join tbOROS
					on  tbOROS.CodigoEmpresa = tbOROSCIT.CodigoEmpresa
					and tbOROS.CodigoLocal 	 = tbOROSCIT.CodigoLocal
					and tbOROS.FlagOROS 	 = tbOROSCIT.FlagOROS
					and tbOROS.NumeroOROS 	 = tbOROSCIT.NumeroOROS
				where tbOROSCIT.CodigoEmpresa = @CodigoEmpresa
				and   tbOROSCIT.CodigoLocal   = @CodigoLocal
				and   tbOROSCIT.FlagOROS      = @FlagOROS
				and   tbOROS.ChassiVeiculoOS  = @CodigoChassi)
*/
	---------------  Se cancelou a OS extorna a requisição do componente  ---------------------------------
SELECT @StatusOSCITA, @StatusOSCITN 
	IF  @StatusOSCITA = 'A' AND @StatusOSCITN = 'C'
	BEGIN
		-- Devolvendo as Pecas para o Almoxarifado de Origem
		DECLARE cur_OROSDes INSENSITIVE CURSOR FOR
		SELECT	deleted.CodigoEmpresa,
			deleted.CodigoLocal,
			deleted.FlagOROS,
			deleted.NumeroOROS,
			deleted.CodigoCIT,
			tbOROS.ChassiVeiculoOS,
			1,
			tbClienteAlmoxarifado.CodigoAlmoxarifado,
			tbAlmoxarifado.CodigoAlmoxarifado
		
		FROM	deleted
	
		inner join tbOROS (nolock) on
			tbOROS.CodigoEmpresa 	= deleted.CodigoEmpresa and
			tbOROS.CodigoLocal 	= deleted.CodigoLocal and
			tbOROS.FlagOROS 	= deleted.FlagOROS and
			tbOROS.NumeroOROS 	= deleted.NumeroOROS
	
		inner join tbClienteAlmoxarifado (nolock) on
			tbClienteAlmoxarifado.CodigoEmpresa = deleted.CodigoEmpresa and
			tbClienteAlmoxarifado.CodigoLocal = deleted.CodigoLocal and
			tbClienteAlmoxarifado.CodigoCliFor = deleted.CodigoCliFor
	
		inner join tbAlmoxarifado (nolock) on
			tbAlmoxarifado.CodigoEmpresa = deleted.CodigoEmpresa and
			tbAlmoxarifado.CodigoLocal = deleted.CodigoLocal and
			tbAlmoxarifado.TipoAlmoxarifadoConsumo = 'M'
		
		WHERE   rtrim(tbOROS.ChassiVeiculoOS) <> ''
		AND     deleted.FlagOROS = 'S'
		
		OPEN cur_OROSDes
		FETCH NEXT FROM cur_OROSDes INTO
			    	@CodigoEmpresa,
				@CodigoLocal,
				@FlagOROS,
				@NumeroOROS,
				@CodigoCIT,
				@CodigoProduto,
				@QuantidadeOROS,
				@CodigoAlmoxarifadoOrigem,
				@CodigoAlmoxarifadoDestino
		
		WHILE @@FETCH_STATUS <> -1
		BEGIN 
		
			EXECUTE whIRegistroMovtoEstoque
				@CodigoEmpresa,
				@CodigoLocal,
				0,
				@IDataOROS,
				'S', 
				@QuantidadeOROS,
				@NumeroOROS,
				6,
				@CodigoAlmoxarifadoDestino,
				@CodigoProduto
		
				IF @@ERROR <> 0
					BEGIN
						CLOSE cur_OROSDes
						DEALLOCATE cur_OROSDes
						GOTO ERROR
					END
		
		
			EXECUTE whIRegistroMovtoEstoque
				@CodigoEmpresa,
				@CodigoLocal,
				0,
				@IDataOROS,
				'E', 
				@QuantidadeOROS,
				@NumeroOROS,
				6,
				@CodigoAlmoxarifadoOrigem,
				@CodigoProduto
		
				IF @@ERROR <> 0
					BEGIN
						CLOSE cur_OROSDes
						DEALLOCATE cur_OROSDes
						GOTO ERROR
					END
		
		
			FETCH NEXT FROM cur_OROSDes INTO
				    	@CodigoEmpresa,
					@CodigoLocal,
					@FlagOROS,
					@NumeroOROS,
					@CodigoCIT,
					@CodigoProduto,
					@QuantidadeOROS,
					@CodigoAlmoxarifadoOrigem,
					@CodigoAlmoxarifadoDestino
		
		END

		CLOSE cur_OROSDes
		DEALLOCATE cur_OROSDes 
	END

	---------------  Se cancelou a OS extorna a requisição do componente  ---------------------------------
	IF  @StatusOSCITA = 'C' AND @StatusOSCITN = 'A'
	BEGIN
		-- Devolvendo as Pecas para o Almoxarifado de Origem
		DECLARE cur_OROSIns INSENSITIVE CURSOR FOR
		SELECT	deleted.CodigoEmpresa,
			deleted.CodigoLocal,
			deleted.FlagOROS,
			deleted.NumeroOROS,
			deleted.CodigoCIT,
			tbOROS.ChassiVeiculoOS,
			1,
			tbClienteAlmoxarifado.CodigoAlmoxarifado,
			tbAlmoxarifado.CodigoAlmoxarifado
		
		FROM	deleted
	
		inner join tbOROS (nolock) on
			tbOROS.CodigoEmpresa 	= deleted.CodigoEmpresa and
			tbOROS.CodigoLocal 	= deleted.CodigoLocal and
			tbOROS.FlagOROS 	= deleted.FlagOROS and
			tbOROS.NumeroOROS 	= deleted.NumeroOROS
	
		inner join tbClienteAlmoxarifado (nolock) on
			tbClienteAlmoxarifado.CodigoEmpresa = deleted.CodigoEmpresa and
			tbClienteAlmoxarifado.CodigoLocal = deleted.CodigoLocal and
			tbClienteAlmoxarifado.CodigoCliFor = deleted.CodigoCliFor
	
		inner join tbAlmoxarifado (nolock) on
			tbAlmoxarifado.CodigoEmpresa = deleted.CodigoEmpresa and
			tbAlmoxarifado.CodigoLocal = deleted.CodigoLocal and
			tbAlmoxarifado.TipoAlmoxarifadoConsumo = 'M'
		
		WHERE   rtrim(tbOROS.ChassiVeiculoOS) <> ''
		AND     deleted.FlagOROS = 'S'

		OPEN cur_OROSIns
		FETCH NEXT FROM cur_OROSIns INTO
			    	@CodigoEmpresa,
				@CodigoLocal,
				@FlagOROS,
				@NumeroOROS,
				@CodigoCIT,
				@CodigoProduto,
				@QuantidadeOROS,
				@CodigoAlmoxarifadoOrigem,
				@CodigoAlmoxarifadoDestino
		
		WHILE @@FETCH_STATUS <> -1
		BEGIN 
		
			EXECUTE whIRegistroMovtoEstoque
				@CodigoEmpresa,
				@CodigoLocal,
				0,
				@IDataOROS,
				'S', 
				@QuantidadeOROS,
				@NumeroOROS,
				6,
				@CodigoAlmoxarifadoOrigem,
				@CodigoProduto
		
				IF @@ERROR <> 0
					BEGIN
						CLOSE cur_OROSIns
						DEALLOCATE cur_OROSIns
						GOTO ERROR
					END
		
		
			EXECUTE whIRegistroMovtoEstoque
				@CodigoEmpresa,
				@CodigoLocal,
				0,
				@IDataOROS,
				'E', 
				@QuantidadeOROS,
				@NumeroOROS,
				6,
				@CodigoAlmoxarifadoDestino,
				@CodigoProduto
		
				IF @@ERROR <> 0
					BEGIN
						CLOSE cur_OROSIns
						DEALLOCATE cur_OROSIns
						GOTO ERROR
					END
		
		
			FETCH NEXT FROM cur_OROSIns INTO
				    	@CodigoEmpresa,
					@CodigoLocal,
					@FlagOROS,
					@NumeroOROS,
					@CodigoCIT,
					@CodigoProduto,
					@QuantidadeOROS,
					@CodigoAlmoxarifadoOrigem,
					@CodigoAlmoxarifadoDestino
		
		END 

		CLOSE cur_OROSIns
		DEALLOCATE cur_OROSIns 
	END

    END	

END

RETURN

--Controle de Erros
ERROR:
	ROLLBACK TRANSACTION
	RAISERROR @ErrNo @ErrMsg

END

SET NOCOUNT OFF

GO
DROP TABLE deleted
GO
DROP TABLE inserted
GO

go

IF OBJECT_ID('tnu_DSPa_Pedido') IS NOT NULL
	DROP TRIGGER dbo.tnu_DSPa_Pedido
GO

CREATE TRIGGER dbo.tnu_DSPa_Pedido ON tbPedido
WITH ENCRYPTION
FOR UPDATE AS
SET NOCOUNT ON
IF UPDATE (StatusPedidoPed)
BEGIN

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda.
 PROJETO......: Controle de Estoque
 AUTOR........: Edvaldo Ragassi
 DATA.........: 19/06/2007
 UTILIZADO EM : tnu_DSPa_Pedido
 OBJETIVO.....: Ao alterar StatusPedidoPed para 4 na tbPedido dispara trigger acima para
		atualizacoes diversas.

 ALTERACAO....: Edvaldo Ragassi - 26/03/2008
 OBJETIVO.....: Nao atualizar numero da nota fiscal na tbOROSCIT.
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

	DECLARE @CodigoEmpresa			dtInteiro04
	DECLARE @CodigoLocal			dtInteiro04
	DECLARE @CentroCusto			dtInteiro08
	DECLARE @NumeroPedido			dtInteiro06
	DECLARE @SequenciaPedido		dtInteiro02
	DECLARE @OrigemPedido			CHAR(2)
	DECLARE @CodigoNaturezaOperacao		dtInteiro06
	DECLARE @StatusPedidoPed		dtInteiro01
	DECLARE @NumeroNotaFiscalPed		dtInteiro06
	DECLARE @DataEmissaoNotaFiscalPed	DATETIME
	DECLARE @CodigoCliForFat		NUMERIC(14)
	DECLARE @ValorContabilPed		dtValorMonetario
	DECLARE @ValorTotalOS			dtValorMonetario
	DECLARE @AtendimentoOS			CHAR(1)
	DECLARE @NumeroOROS			dtInteiro06
	DECLARE @FlagOROS			CHAR(1)
	DECLARE @CodigoCIT			CHAR(4)
	DECLARE @NumeroVeiculoCV		dtInteiro08
	DECLARE @NumeroChassisCV		CHAR(21)
	DECLARE	@NovoUsado			CHAR(1)
	DECLARE @CustoVeiculoApurado		dtValorMonetario
	DECLARE @CodigoModalidadeCompra		NUMERIC(4)
	DECLARE @ErrNo				INT
	DECLARE	@ErrMsg				VARCHAR(255)
	DECLARE @Recapagem			CHAR(1)
	DECLARE	@TipoTratamento			CHAR(1)


	IF EXISTS	(SELECT 1 FROM deleted d
				INNER JOIN inserted i
				ON	i.CodigoEmpresa			= d.CodigoEmpresa
				AND	i.CodigoLocal			= d.CodigoLocal
				AND	i.CentroCusto			= d.CentroCusto
				AND	i.NumeroPedido			= d.NumeroPedido
				AND	i.SequenciaPedido		= d.SequenciaPedido
				WHERE	i.StatusPedidoPed		= 5
				AND	d.StatusPedidoPed		IN (1, 2, 3, 4, 8)
			)
	AND EXISTS	( SELECT 1 FROM master.dbo.sysprocesses WHERE spid = @@Spid AND program_name LIKE '%SQL%' )
	BEGIN
		SELECT @ErrNo = 70321
		SELECT @ErrMsg = 'Tentativa de violação de integridade! Alteração para Status (5) não permitida.'
		GOTO ERROR
	END

	IF EXISTS	(SELECT 1 FROM deleted d
				INNER JOIN inserted i
				ON	i.CodigoEmpresa			= d.CodigoEmpresa
				AND	i.CodigoLocal			= d.CodigoLocal
				AND	i.CentroCusto			= d.CentroCusto
				AND	i.NumeroPedido			= d.NumeroPedido
				AND	i.SequenciaPedido		= d.SequenciaPedido
				WHERE	i.StatusPedidoPed		= 4
				AND	d.StatusPedidoPed		= 5
			)
	BEGIN
		SELECT @ErrNo = 70321
		SELECT @ErrMsg = 'Tentativa de violação de integridade! Alteração para Status (4) não permitida.'
		GOTO ERROR
	END

	IF EXISTS	(SELECT 1 FROM deleted d
				INNER JOIN inserted i
				ON	i.CodigoEmpresa			= d.CodigoEmpresa
				AND	i.CodigoLocal			= d.CodigoLocal
				AND	i.CentroCusto			= d.CentroCusto
				AND	i.NumeroPedido			= d.NumeroPedido
				AND	i.SequenciaPedido		= d.SequenciaPedido
				WHERE	i.StatusPedidoPed		< 4
				AND	d.StatusPedidoPed		IN (4, 5, 8)
			)
	AND EXISTS	(SELECT 1 FROM	tbDocumento a	(NOLOCK)
					INNER JOIN deleted d
					ON	d.CodigoEmpresa			= a.CodigoEmpresa
					AND	d.CodigoLocal			= a.CodigoLocal
					AND	d.NumeroPedido			= a.NumeroPedidoDocumento
					AND	d.SequenciaPedido		= a.NumeroSequenciaPedidoDocumento
					WHERE 	a.CondicaoNFCancelada		= 'F'
					AND	a.TipoLancamentoMovimentacao	IN (7, 13)
					AND	a.NumeroPedidoDocumento		!= a.NumeroDocumento)
	BEGIN
		SELECT @ErrNo = 70477
		SELECT @ErrMsg = 'Pedido já possui Nota Fiscal emitida. Status não pode ser alterado.'
		GOTO ERROR
	END

	IF EXISTS	(SELECT 1 FROM deleted d
				INNER JOIN inserted i
				ON	i.CodigoEmpresa			= d.CodigoEmpresa
				AND	i.CodigoLocal			= d.CodigoLocal
				AND	i.CentroCusto			= d.CentroCusto
				AND	i.NumeroPedido			= d.NumeroPedido
				AND	i.SequenciaPedido		= d.SequenciaPedido
				WHERE	i.StatusPedidoPed		= 4
				AND	d.StatusPedidoPed		!= 4
			)
	BEGIN
		SELECT @ErrNo = 0
		SELECT @ErrMsg = ''
		-- Pedidos de Vendas
		DECLARE cur_Pedido INSENSITIVE CURSOR FOR
		SELECT	i.CodigoEmpresa,
			i.CodigoLocal,
			i.CentroCusto,
			i.NumeroPedido,
			i.SequenciaPedido,
			i.OrigemPedido,
			i.CodigoNaturezaOperacao,
			i.StatusPedidoPed,
			i.NumeroNotaFiscalPed,
			i.DataEmissaoNotaFiscalPed,
			i.ValorContabilPed,
			v.CodigoCliForFat,
			i.Recapagem,
			i.TipoTratamentoNFDigitadaPedido
		FROM	inserted i
		INNER JOIN deleted d
		ON	d.CodigoEmpresa			= i.CodigoEmpresa
		AND	d.CodigoLocal			= i.CodigoLocal
		AND	d.CentroCusto			= i.CentroCusto
		AND	d.NumeroPedido			= i.NumeroPedido
		AND	d.SequenciaPedido		= i.SequenciaPedido
		INNER JOIN tbPedidoVenda v	(NOLOCK)
		ON	v.CodigoEmpresa			= i.CodigoEmpresa
		AND	v.CodigoLocal			= i.CodigoLocal
		AND	v.CentroCusto			= i.CentroCusto
		AND	v.NumeroPedido			= i.NumeroPedido
		AND	v.SequenciaPedido		= i.SequenciaPedido
		WHERE	i.StatusPedidoPed		= 4
		AND	d.StatusPedidoPed		!= 4

		OPEN cur_Pedido
		FETCH NEXT FROM cur_Pedido INTO
		    	@CodigoEmpresa,
			@CodigoLocal,
			@CentroCusto,
			@NumeroPedido,
			@SequenciaPedido,
			@OrigemPedido,
			@CodigoNaturezaOperacao,
			@StatusPedidoPed,
			@NumeroNotaFiscalPed,
			@DataEmissaoNotaFiscalPed,
			@ValorContabilPed,
			@CodigoCliForFat,
			@Recapagem,
			@TipoTratamento

	
		WHILE @@FETCH_STATUS <> -1
		BEGIN 
			-- Atualizar Cliente Centro Custo
			IF NOT EXISTS (SELECT 1 FROM tbClienteCentroCusto (NOLOCK)
					WHERE	CodigoEmpresa	= @CodigoEmpresa
					AND	CodigoCliFor	= @CodigoCliForFat
					AND	CentroCusto	= @CentroCusto)
			BEGIN
				EXECUTE spIClienteCentroCusto
					@CodigoEmpresa,
					@CodigoCliForFat,
					@CentroCusto

				IF @@ERROR <> 0
				BEGIN
					CLOSE cur_Pedido
					DEALLOCATE cur_Pedido
					SELECT @ErrNo = 70321
					GOTO ERROR
				END
			END
			
			UPDATE	tbClienteCentroCusto
			SET	DataUltimaVendaClienteCC	= @DataEmissaoNotaFiscalPed
			WHERE	CodigoEmpresa			= @CodigoEmpresa
			AND	CodigoCliFor			= @CodigoCliForFat
			AND	CentroCusto			= @CentroCusto

			IF @@ERROR <> 0
			BEGIN
				CLOSE cur_Pedido
				DEALLOCATE cur_Pedido
				SELECT @ErrNo = 70321
				GOTO ERROR
			END

			IF @OrigemPedido = 'TK'
			BEGIN
				UPDATE	tbPedidoTK
				SET	StatusPedidoTK	= 3
				WHERE	CodigoEmpresa	= @CodigoEmpresa
				AND	CodigoLocal	= @CodigoLocal
				AND	CentroCusto	= @CentroCusto
				AND	NumeroPedido	= @NumeroPedido
				AND	SequenciaPedido	= @SequenciaPedido

				IF @@ERROR <> 0
				BEGIN
					CLOSE cur_Pedido
					DEALLOCATE cur_Pedido
					SELECT @ErrNo = 70321
					GOTO ERROR
				END
			END

			IF @OrigemPedido = 'OS'
			BEGIN

				SELECT	@ValorTotalOS	= 0
				SELECT	@AtendimentoOS	= 'F'
				SELECT	@NumeroOROS	= 0
				SELECT	@FlagOROS	= 'S'
				SELECT	@CodigoCIT	= ''

				IF EXISTS (SELECT 1 FROM tbOROSCIT osc (NOLOCK)
						INNER JOIN tbPedidoOS pos (NOLOCK)
						ON	pos.CodigoEmpresa		= osc.CodigoEmpresa
						AND	pos.CodigoLocal			= osc.CodigoLocal
						AND	pos.CodigoOrdemServicoPedidoOS	= osc.NumeroOROS
						WHERE	pos.CodigoEmpresa		= @CodigoEmpresa
						AND	pos.CodigoLocal			= @CodigoLocal
						AND	pos.CentroCusto			= @CentroCusto
						AND	pos.NumeroPedido		= @NumeroPedido
						AND	pos.SequenciaPedido		= @SequenciaPedido
						AND	osc.FlagOROS			= 'S'
						AND	osc.AtendimentoOS		= 'V')
				BEGIN
					SELECT	@AtendimentoOS = 'V'
				END

				SELECT	@ValorTotalOS		= osc.ValorTotalOS,
					@NumeroOROS		= osc.NumeroOROS,
					@CodigoCIT		= osc.CodigoCIT
				FROM	tbPedidoOS pos		(NOLOCK)
				INNER JOIN tbOROSCIT osc	(NOLOCK)
				ON	osc.CodigoEmpresa	= pos.CodigoEmpresa
				AND	osc.CodigoLocal		= pos.CodigoLocal
				AND	osc.FlagOROS		= 'S'
				AND	osc.NumeroOROS		= pos.CodigoOrdemServicoPedidoOS
				AND	osc.CodigoCIT		= pos.CodigoCIT
				WHERE	pos.CodigoEmpresa	= @CodigoEmpresa
				AND	pos.CodigoLocal		= @CodigoLocal
				AND	pos.CentroCusto		= @CentroCusto
				AND	pos.NumeroPedido	= @NumeroPedido
				AND	pos.SequenciaPedido	= @SequenciaPedido

				-- Verifica se existe Ficha de Seguimento
				IF NOT EXISTS (SELECT 1 FROM tbFichaSeguimento
						WHERE	CodigoEmpresa	= @CodigoEmpresa
						AND	CodigoLocal	= @CodigoLocal
						AND	FlagOROS	= 'S'
						AND	NumeroOROS	= @NumeroOROS)
				BEGIN
					EXECUTE spIFichaSeguimento
						@CodigoEmpresa			= @CodigoEmpresa,
						@CodigoLocal			= @CodigoLocal,
						@FlagOROS			= @FlagOROS,
						@NumeroOROS			= @NumeroOROS,
						@DataEmissaoOSFichaSegto	= @DataEmissaoNotaFiscalPed,
						@TempoGastoFichaSegto		= 0,
						@ValorGastoFichaSegto		= 0,
						@KmVeiculoFichaSegto		= 0,
						@RevisaoRealizadaFichaSegto	= 'F',
						@MotorVerificadoFichaSegto	= 'F',
						@EmbreagemReparadaFichaSegto	= 'F',
						@CaixaMudancaFichaSegto		= 'F',
						@TransmissaoFichaSegto		= 'F',
						@FreiosFichaSegto		= 'F',
						@DirecaoFichaSegto		= 'F',
						@RodasFichaSegto		= 'F',
						@PneusFichaSegto		= 'F',
						@EletricidadeFichaSegto		= 'F',
						@FunilariaFichaSegto		= 'F',
						@LavagemFichaSegto		= 'F',
						@LubrificanteFichaSegto		= 'F',
						@PinturaFichaSegto		= 'F',
						@EstofamentoFichaSegto		= 'F',
						@DiferencialFichaSegto		= 'F',
						@SuspensaoDianteiraFichaSegto	= 'F',
						@SuspensaoTraseiraFichaSegto	= 'F',
						@OutrosServicosFichaSegto	= 'F',
						@ObservacaoFichaSegto		= NULL,
						@CanceladaFichaSegto		= 'F',
						@AtendimentoOSFichaSegto	= @AtendimentoOS

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_Pedido
						DEALLOCATE cur_Pedido
						SELECT @ErrNo = 70321
						GOTO ERROR
					END
				END

				-- Atualiza Ficha de Seguimento
				UPDATE	tbFichaSeguimento
				SET	ValorGastoFichaSegto	= (SELECT ISNULL(SUM(ValorLiquidoItemOS), 0)
									FROM	tbItemOROS itoros	(NOLOCK)
									INNER JOIN tbOROSCIT oroscit	(NOLOCK)
									ON	oroscit.CodigoEmpresa	= itoros.CodigoEmpresa
									AND	oroscit.CodigoLocal	= itoros.CodigoLocal
									AND	oroscit.FlagOROS	= itoros.FlagOROS
									AND	oroscit.NumeroOROS	= itoros.NumeroOROS
									AND	oroscit.CodigoCIT	= itoros.CodigoCIT
									WHERE	itoros.CodigoEmpresa	= tbFichaSeguimento.CodigoEmpresa
									AND	itoros.CodigoLocal	= tbFichaSeguimento.CodigoLocal
									AND	itoros.FlagOROS		= tbFichaSeguimento.FlagOROS
									AND	itoros.NumeroOROS	= tbFichaSeguimento.NumeroOROS
									AND	oroscit.StatusOSCIT	IN ('N', 'U')),
					TempoGastoFichaSegto	= (SELECT ISNULL(SUM(QuantidadeItemOS), 0)
									FROM	tbItemOROS itoros	(NOLOCK)
									INNER JOIN tbOROSCIT oroscit	(NOLOCK)
									ON	oroscit.CodigoEmpresa	= itoros.CodigoEmpresa
									AND	oroscit.CodigoLocal	= itoros.CodigoLocal
									AND	oroscit.FlagOROS	= itoros.FlagOROS
									AND	oroscit.NumeroOROS	= itoros.NumeroOROS
									AND	oroscit.CodigoCIT	= itoros.CodigoCIT
									WHERE	itoros.CodigoEmpresa	= tbFichaSeguimento.CodigoEmpresa
									AND	itoros.CodigoLocal	= tbFichaSeguimento.CodigoLocal
									AND	itoros.FlagOROS		= tbFichaSeguimento.FlagOROS
									AND	itoros.NumeroOROS	= tbFichaSeguimento.NumeroOROS
									AND	itoros.TipoItemOS	= 'M'
									AND	oroscit.StatusOSCIT	IN ('N', 'U')),
					AtendimentoOSFichaSegto	= @AtendimentoOS
				WHERE	CodigoEmpresa		= @CodigoEmpresa
				AND	CodigoLocal		= @CodigoLocal
				AND	FlagOROS		= @FlagOROS
				AND	NumeroOROS		= @NumeroOROS

				IF @@ERROR <> 0
				BEGIN
					CLOSE cur_Pedido
					DEALLOCATE cur_Pedido
					SELECT @ErrNo = 70321
					GOTO ERROR
				END

				-- Atualiza dados da OS CIT
				UPDATE	tbOROSCIT
				SET	StatusOSCIT		= 'N',
					NumeroNotaFiscalOS	= @NumeroNotaFiscalPed,
					DataEncerramentoOSCIT	= (CASE 
									WHEN DataEncerramentoOSCIT IS NULL
									THEN @DataEmissaoNotaFiscalPed + ' ' + CONVERT(CHAR(5), GETDATE(), 114)
									ELSE	CASE
											WHEN	@TipoTratamento = 'N'
											THEN	@DataEmissaoNotaFiscalPed + ' ' + CONVERT(CHAR(5), GETDATE(), 114)
											ELSE	CONVERT(DATETIME, CONVERT(CHAR(12), DataEncerramentoOSCIT, 112) + ' ' + CONVERT(CHAR(5), GETDATE(), 114))
										END
									END),
					DataEmissaoNotaFiscalOS	= @DataEmissaoNotaFiscalPed + ' ' + CONVERT(CHAR(5), GETDATE(), 114)
				FROM	tbOROSCITPedido op
				WHERE	op.CodigoEmpresa	= tbOROSCIT.CodigoEmpresa
				AND	op.CodigoLocal		= tbOROSCIT.CodigoLocal
				AND	op.FlagOROS		= tbOROSCIT.FlagOROS
				AND	op.NumeroOROS		= tbOROSCIT.NumeroOROS
				AND	op.CodigoCIT		= tbOROSCIT.CodigoCIT
				AND	op.CodigoEmpresa	= @CodigoEmpresa
				AND	op.CodigoLocal		= @CodigoLocal
				AND	op.CentroCusto		= @CentroCusto
				AND	op.NumeroPedido		= @NumeroPedido
				AND	op.SequenciaPedido	= @SequenciaPedido

				IF @@ERROR <> 0
				BEGIN
					CLOSE cur_Pedido
					DEALLOCATE cur_Pedido
					SELECT @ErrNo = 70321
					GOTO ERROR
				END

				-- Atualiza dados da OS
				IF NOT EXISTS (SELECT 1 FROM tbOROSCIT (NOLOCK)
						WHERE	CodigoEmpresa	= @CodigoEmpresa
						AND	CodigoLocal	= @CodigoLocal
						AND	FlagOROS	= @FlagOROS
						AND	NumeroOROS	= @NumeroOROS
						AND	StatusOSCIT	IN ('A', 'U'))
				BEGIN
					UPDATE	tbOROS
					SET	DataEncerramentoOS	= @DataEmissaoNotaFiscalPed + ' ' + CONVERT(CHAR(5), GETDATE(), 114)
					FROM	tbOROSCITPedido op
					WHERE	op.CodigoEmpresa	= tbOROS.CodigoEmpresa
					AND	op.CodigoLocal		= tbOROS.CodigoLocal
					AND	op.FlagOROS		= tbOROS.FlagOROS
					AND	op.NumeroOROS		= tbOROS.NumeroOROS
					AND	op.CodigoEmpresa	= @CodigoEmpresa
					AND	op.CodigoLocal		= @CodigoLocal
					AND	op.CentroCusto		= @CentroCusto
					AND	op.NumeroPedido		= @NumeroPedido
					AND	op.SequenciaPedido	= @SequenciaPedido

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_Pedido
						DEALLOCATE cur_Pedido
						SELECT @ErrNo = 70321
						GOTO ERROR
					END

					UPDATE	tbOS
					SET	StatusOS		= 'N'
					FROM	tbOROSCITPedido op
					WHERE	op.CodigoEmpresa	= tbOS.CodigoEmpresa
					AND	op.CodigoLocal		= tbOS.CodigoLocal
					AND	op.FlagOROS		= tbOS.FlagOROS
					AND	op.NumeroOROS		= tbOS.NumeroOROS
					AND	op.CodigoEmpresa	= @CodigoEmpresa
					AND	op.CodigoLocal		= @CodigoLocal
					AND	op.CentroCusto		= @CentroCusto
					AND	op.NumeroPedido		= @NumeroPedido
					AND	op.SequenciaPedido	= @SequenciaPedido

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_Pedido
						DEALLOCATE cur_Pedido
						SELECT @ErrNo = 70321
						GOTO ERROR
					END
				END
			END	-- Origem 'OS'

			IF @OrigemPedido = 'CV'
			BEGIN
				SELECT	@NumeroVeiculoCV	= 0
				SELECT	@NumeroChassisCV	= ''
				SELECT	@NovoUsado		= ''

				-- Se for compra de veiculo usado
				IF	EXISTS (SELECT 1 FROM tbNaturezaOperacao (NOLOCK)
							WHERE	CodigoEmpresa		= @CodigoEmpresa
							AND	CodigoNaturezaOperacao	= @CodigoNaturezaOperacao
							AND	CodigoTipoOperacao	IN (2, 80)) 
				AND 	EXISTS (SELECT 1 FROM tbPedidoCV (NOLOCK)
							WHERE	CodigoEmpresa		= @CodigoEmpresa
							AND	CodigoLocal		= @CodigoLocal
							AND	CentroCusto		= @CentroCusto
							AND	NumeroPedido		= @NumeroPedido
							AND	SequenciaPedido		= @SequenciaPedido
							AND	NovoUsadoPedidoCV	= 'U')
				BEGIN
					SELECT	@NumeroVeiculoCV	= pcv.NumeroVeiculoCV,
						@NovoUsado		= pcv.NovoUsadoPedidoCV
					FROM	tbPedidoCV pcv	(NOLOCK)
					WHERE	pcv.CodigoEmpresa	= @CodigoEmpresa
					AND	pcv.CodigoLocal		= @CodigoLocal
					AND	pcv.CentroCusto		= @CentroCusto
					AND	pcv.NumeroPedido	= @NumeroPedido
					AND	pcv.SequenciaPedido	= @SequenciaPedido

					SELECT	@NumeroChassisCV	= vcv.NumeroChassisCV
					FROM	tbVeiculoCV vcv	(NOLOCK)
					WHERE	vcv.CodigoEmpresa	= @CodigoEmpresa
					AND	vcv.CodigoLocal		= @CodigoLocal
					AND	vcv.NumeroVeiculoCV	= @NumeroVeiculoCV

					-- Apura o Custo do Veiculo.
					EXECUTE	whApurarCustoVeiculo
						@CodigoEmpresa,
						@CodigoLocal,
						@NumeroVeiculoCV,
						@CustoVeiculoApurado OUTPUT

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_Pedido
						DEALLOCATE cur_Pedido
						SELECT @ErrNo = 70321
						GOTO ERROR
					END

					-- Atualiza o Custo do Veiculo no Pedido.
					UPDATE	tbItemPedido
					SET	ValorCustoMovimentoItemPed	= @CustoVeiculoApurado
					WHERE	CodigoEmpresa	= @CodigoEmpresa
					AND	CodigoLocal	= @CodigoLocal
					AND	CentroCusto	= @CentroCusto
					AND	NumeroPedido	= @NumeroPedido
					AND	SequenciaPedido	= @SequenciaPedido

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_Pedido
						DEALLOCATE cur_Pedido
						SELECT @ErrNo = 70321
						GOTO ERROR
					END

					-- Atualizacao do Veiculo Gerado
					UPDATE	tbVeiculoCV
					SET	ValorCustoVeiculo		= @CustoVeiculoApurado,
						NumeroNotaFiscalEntradaVeic	= @NumeroNotaFiscalPed,
						DataEntradaVeiculoCV		= @DataEmissaoNotaFiscalPed
					WHERE	CodigoEmpresa	= @CodigoEmpresa
					AND	CodigoLocal	= @CodigoLocal
					AND	NumeroVeiculoCV	= @NumeroVeiculoCV

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_Pedido
						DEALLOCATE cur_Pedido
						SELECT @ErrNo = 70321
						GOTO ERROR
					END

					-- Atualizar o Laudo
					IF EXISTS (SELECT 1 FROM tbLaudoVeiculoUsadoCV	(NOLOCK)
							WHERE	CodigoEmpresa		= @CodigoEmpresa
							AND	CodigoLocal		= @CodigoLocal
							AND	NumeroChassisVeicUsado	= @NumeroChassisCV
							AND	NumeroVeiculoCV		IS NULL)
					BEGIN
						UPDATE	tbLaudoVeiculoUsadoCV
						SET	SituacaoVeiculoLaudoCV	= 1,
							CodigoLocalVeiculoCV	= @CodigoLocal,
							NumeroVeiculoCV		= @NumeroVeiculoCV,
							ValorCompradoVeic	= @ValorContabilPed
						WHERE	CodigoEmpresa		= @CodigoEmpresa
						AND	CodigoLocal		= @CodigoLocal
						AND	NumeroChassisVeicUsado	= @NumeroChassisCV
						AND	NumeroVeiculoCV		IS NULL
						AND	SequenciaLaudoUsado	= (SELECT MAX(SequenciaLaudoUsado)
											FROM	tbLaudoVeiculoUsadoCV	(NOLOCK)
											WHERE	CodigoEmpresa		= @CodigoEmpresa
											AND	CodigoLocal		= @CodigoLocal
											AND	NumeroChassisVeicUsado	= @NumeroChassisCV
											AND	NumeroVeiculoCV		IS NULL)

						IF @@ERROR <> 0
						BEGIN
							CLOSE cur_Pedido
							DEALLOCATE cur_Pedido
							SELECT @ErrNo = 70321
							GOTO ERROR
						END
					END

					SELECT	@CodigoModalidadeCompra	= CodigoModalidadeCompraCV
					FROM	tbModalidadeCompraCV	(NOLOCK)
					WHERE	CodigoEmpresa		= @CodigoEmpresa
					AND	TipoModalidadeCompra	= 'V'

					-- Inclui Modalidade de Compras
					EXECUTE spIModalidadeCompraNFEntradaCV
						@CodigoEmpresa,
						@CodigoLocal,
						@NumeroVeiculoCV,
						@CodigoModalidadeCompra,
						@ValorContabilPed,
						@DataEmissaoNotaFiscalPed,
						@DataEmissaoNotaFiscalPed

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_Pedido
						DEALLOCATE cur_Pedido
						SELECT @ErrNo = 70321
						GOTO ERROR
					END

					-- Excluir Opcionais e Nota Fiscal Entrada de Usados
					DELETE	tbNFEntradaVeicUsadoOpcional
					WHERE	CodigoEmpresa		= @CodigoEmpresa
					AND	ChassiEntradaUsado	= @NumeroChassisCV

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_Pedido
						DEALLOCATE cur_Pedido
						SELECT @ErrNo = 70321
						GOTO ERROR
					END

					DELETE	tbNFEntradaVeiculoUsado
					WHERE	CodigoEmpresa		= @CodigoEmpresa
					AND	ChassiEntradaUsado	= @NumeroChassisCV

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_Pedido
						DEALLOCATE cur_Pedido
						SELECT @ErrNo = 70321
						GOTO ERROR
					END
				END	-- Compra de Veiculo Usado

				-- Se for venda de veiculo
				IF EXISTS(SELECT 1 FROM sysobjects WHERE id = OBJECT_ID('tbPreVendaCV'))
				BEGIN
					IF	EXISTS (SELECT 1 FROM tbNaturezaOperacao (NOLOCK)
								WHERE	CodigoEmpresa		= @CodigoEmpresa
								AND	CodigoNaturezaOperacao	= @CodigoNaturezaOperacao
								AND	CodigoTipoOperacao	= 4)
					AND 	EXISTS (SELECT 1 FROM tbPedidoCV (NOLOCK)
								WHERE	CodigoEmpresa		= @CodigoEmpresa
								AND	CodigoLocal		= @CodigoLocal
								AND	CentroCusto		= @CentroCusto
								AND	NumeroPedido		= @NumeroPedido
								AND	SequenciaPedido		= @SequenciaPedido)
					BEGIN
						SELECT	@NumeroVeiculoCV	= 0
						SELECT	@NumeroVeiculoCV	= pcv.NumeroVeiculoCV
						FROM	tbPedidoCV pcv	(NOLOCK)
						WHERE	pcv.CodigoEmpresa	= @CodigoEmpresa
						AND	pcv.CodigoLocal		= @CodigoLocal
						AND	pcv.CentroCusto		= @CentroCusto
						AND	pcv.NumeroPedido	= @NumeroPedido
						AND	pcv.SequenciaPedido	= @SequenciaPedido

						UPDATE	tbPreVendaCV
						SET	FaturadoNFEmitida	= 'V'
						WHERE	CodigoEmpresa		= @CodigoEmpresa
						AND	CodigoLocalVeiculo	= @CodigoLocal
						AND	NumeroVeiculoCV		= @NumeroVeiculoCV

						IF @@ERROR <> 0
						BEGIN
							CLOSE cur_Pedido
							DEALLOCATE cur_Pedido
							SELECT @ErrNo = 70321
							GOTO ERROR
						END
					END
				END
			END	-- Origem 'CV'

			IF @Recapagem = 'V'
			BEGIN

				UPDATE	tbFichaControleProducao
				SET	NotaFiscalVenda		= @NumeroNotaFiscalPed,
					DataNotaFiscalVenda	= @DataEmissaoNotaFiscalPed,
					Status			    = 5
				WHERE	CodigoEmpresa	= @CodigoEmpresa
				AND	CodigoLocal		    = @CodigoLocal
				AND	NotaFiscalVenda		= @NumeroPedido
				AND	Status				= 4

				IF @@ERROR <> 0
				BEGIN
					CLOSE cur_Pedido
					DEALLOCATE cur_Pedido
					SELECT @ErrNo = 70321
					GOTO ERROR
				END

				UPDATE	tbFichaControlePedidoCapa
				SET	NotaFiscal			= @NumeroNotaFiscalPed,
					DataNotaFiscal		= @DataEmissaoNotaFiscalPed
				WHERE	CodigoEmpresa	= @CodigoEmpresa
				AND		CodigoLocal		= @CodigoLocal
				AND		NumeroPedido	= @NumeroPedido

				IF @@ERROR <> 0
				BEGIN
					CLOSE cur_Pedido
					DEALLOCATE cur_Pedido
					SELECT @ErrNo = 70321
					GOTO ERROR
				END
			END	-- Recapagem

			IF EXISTS(SELECT 1 FROM sysobjects WHERE id = OBJECT_ID('tbPedidoComprasDN'))
			BEGIN
				IF EXISTS (SELECT 1 FROM tbPedidoComprasDN (NOLOCK)
						WHERE	CodigoEmpresa	= @CodigoEmpresa
						AND	CodigoLocal	= @CodigoLocal
						AND	CentroCustoFat	= @CentroCusto
						AND	NumPedidoFat	= @NumeroPedido
						AND	SequenciaPedido	= @SequenciaPedido)
				BEGIN
					UPDATE	tbPedidoComprasDN
					SET	StatusPedido	= 3
					WHERE	CodigoEmpresa	= @CodigoEmpresa
					AND	CodigoLocal	= @CodigoLocal
					AND	CentroCustoFat	= @CentroCusto
					AND	NumPedidoFat	= @NumeroPedido
					AND	SequenciaPedido	= @SequenciaPedido

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_Pedido
						DEALLOCATE cur_Pedido
						SELECT @ErrNo = 70321
						GOTO ERROR
					END
				END
			END	-- Pedido Compras DN

			IF EXISTS(SELECT 1 FROM sysobjects WHERE id = OBJECT_ID('tbRequisicaoFrota'))
			BEGIN
				IF EXISTS (SELECT 1 FROM tbRequisicaoFrota (NOLOCK)
						WHERE	CodigoEmpresa	= @CodigoEmpresa
						AND	CodigoLocal	= @CodigoLocal
						AND	NumeroPedido	= @NumeroPedido
						AND	SequenciaPedido	= @SequenciaPedido)
				BEGIN
					UPDATE	tbRequisicaoFrota
					SET	NumeroNotaFiscal	= @NumeroNotaFiscalPed,
						DataNotaFiscal		= @DataEmissaoNotaFiscalPed,
						Status			= 'E'
					WHERE	CodigoEmpresa		= @CodigoEmpresa
					AND	CodigoLocal		= @CodigoLocal
					AND	NumeroPedido		= @NumeroPedido
					AND	SequenciaPedido		= @SequenciaPedido

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_Pedido
						DEALLOCATE cur_Pedido
						SELECT @ErrNo = 70321
						GOTO ERROR
					END
				END
			END
			
			FETCH NEXT FROM cur_Pedido INTO
			    	@CodigoEmpresa,
				@CodigoLocal,
				@CentroCusto,
				@NumeroPedido,
				@SequenciaPedido,
				@OrigemPedido,
				@CodigoNaturezaOperacao,
				@StatusPedidoPed,
				@NumeroNotaFiscalPed,
				@DataEmissaoNotaFiscalPed,
				@ValorContabilPed,
				@CodigoCliForFat,
				@Recapagem,
				@TipoTratamento
		END 
	
		CLOSE cur_Pedido
		DEALLOCATE cur_Pedido


		-- Pedidos de Compras
		DECLARE cur_PedidoCompra INSENSITIVE CURSOR FOR
		SELECT	i.CodigoEmpresa,
			i.CodigoLocal,
			i.CentroCusto,
			i.NumeroPedido,
			i.SequenciaPedido,
			i.OrigemPedido,
			i.CodigoNaturezaOperacao,
			i.StatusPedidoPed,
			i.NumeroNotaFiscalPed,
			i.DataEmissaoNotaFiscalPed,
			i.ValorContabilPed
		FROM	inserted i
		INNER JOIN deleted d
		ON	d.CodigoEmpresa			= i.CodigoEmpresa
		AND	d.CodigoLocal			= i.CodigoLocal
		AND	d.CentroCusto			= i.CentroCusto
		AND	d.NumeroPedido			= i.NumeroPedido
		AND	d.SequenciaPedido		= i.SequenciaPedido
		WHERE	i.StatusPedidoPed		= 4
		AND	d.StatusPedidoPed		!= 4

		OPEN cur_PedidoCompra
		FETCH NEXT FROM cur_PedidoCompra INTO
		    	@CodigoEmpresa,
			@CodigoLocal,
			@CentroCusto,
			@NumeroPedido,
			@SequenciaPedido,
			@OrigemPedido,
			@CodigoNaturezaOperacao,
			@StatusPedidoPed,
			@NumeroNotaFiscalPed,
			@DataEmissaoNotaFiscalPed,
			@ValorContabilPed

	
		WHILE @@FETCH_STATUS <> -1
		BEGIN 
			IF @OrigemPedido = 'CV'
			BEGIN
				SELECT	@NumeroVeiculoCV	= 0
				SELECT	@NumeroChassisCV	= ''
				SELECT	@NovoUsado		= ''

				-- Se for compra de veiculo usado
				IF	EXISTS (SELECT 1 FROM tbNaturezaOperacao (NOLOCK)
							WHERE	CodigoEmpresa		= @CodigoEmpresa
							AND	CodigoNaturezaOperacao	= @CodigoNaturezaOperacao
							AND	CodigoTipoOperacao	IN (2, 80)) 
				AND 	EXISTS (SELECT 1 FROM tbPedidoCV (NOLOCK)
							WHERE	CodigoEmpresa		= @CodigoEmpresa
							AND	CodigoLocal		= @CodigoLocal
							AND	CentroCusto		= @CentroCusto
							AND	NumeroPedido		= @NumeroPedido
							AND	SequenciaPedido		= @SequenciaPedido
							AND	NovoUsadoPedidoCV	= 'U')
				BEGIN
					SELECT	@NumeroVeiculoCV	= pcv.NumeroVeiculoCV,
						@NovoUsado		= pcv.NovoUsadoPedidoCV
					FROM	tbPedidoCV pcv	(NOLOCK)
					WHERE	pcv.CodigoEmpresa	= @CodigoEmpresa
					AND	pcv.CodigoLocal		= @CodigoLocal
					AND	pcv.CentroCusto		= @CentroCusto
					AND	pcv.NumeroPedido	= @NumeroPedido
					AND	pcv.SequenciaPedido	= @SequenciaPedido

					SELECT	@NumeroChassisCV	= vcv.NumeroChassisCV
					FROM	tbVeiculoCV vcv	(NOLOCK)
					WHERE	vcv.CodigoEmpresa	= @CodigoEmpresa
					AND	vcv.CodigoLocal		= @CodigoLocal
					AND	vcv.NumeroVeiculoCV	= @NumeroVeiculoCV

					-- Apura o Custo do Veiculo.
					EXECUTE	whApurarCustoVeiculo
						@CodigoEmpresa,
						@CodigoLocal,
						@NumeroVeiculoCV,
						@CustoVeiculoApurado OUTPUT

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_PedidoCompra
						DEALLOCATE cur_PedidoCompra
						SELECT @ErrNo = 70321
						GOTO ERROR
					END

					-- Atualiza o Custo do Veiculo no Pedido.
					UPDATE	tbItemPedido
					SET	ValorCustoMovimentoItemPed	= @CustoVeiculoApurado
					WHERE	CodigoEmpresa	= @CodigoEmpresa
					AND	CodigoLocal	= @CodigoLocal
					AND	CentroCusto	= @CentroCusto
					AND	NumeroPedido	= @NumeroPedido
					AND	SequenciaPedido	= @SequenciaPedido

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_PedidoCompra
						DEALLOCATE cur_PedidoCompra
						SELECT @ErrNo = 70321
						GOTO ERROR
					END

					-- Atualizacao do Veiculo Gerado
					UPDATE	tbVeiculoCV
					SET	ValorCustoVeiculo		= @CustoVeiculoApurado,
						NumeroNotaFiscalEntradaVeic	= @NumeroNotaFiscalPed,
						DataEntradaVeiculoCV		= @DataEmissaoNotaFiscalPed
					WHERE	CodigoEmpresa	= @CodigoEmpresa
					AND	CodigoLocal	= @CodigoLocal
					AND	NumeroVeiculoCV	= @NumeroVeiculoCV

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_PedidoCompra
						DEALLOCATE cur_PedidoCompra
						SELECT @ErrNo = 70321
						GOTO ERROR
					END

					-- Atualizar o Laudo
					IF EXISTS (SELECT 1 FROM tbLaudoVeiculoUsadoCV	(NOLOCK)
							WHERE	CodigoEmpresa		= @CodigoEmpresa
							AND	CodigoLocal		= @CodigoLocal
							AND	NumeroChassisVeicUsado	= @NumeroChassisCV
							AND	NumeroVeiculoCV		IS NULL)
					BEGIN
						UPDATE	tbLaudoVeiculoUsadoCV
						SET	SituacaoVeiculoLaudoCV	= 1,
							CodigoLocalVeiculoCV	= @CodigoLocal,
							NumeroVeiculoCV		= @NumeroVeiculoCV,
							ValorCompradoVeic	= @ValorContabilPed
						WHERE	CodigoEmpresa		= @CodigoEmpresa
						AND	CodigoLocal		= @CodigoLocal
						AND	NumeroChassisVeicUsado	= @NumeroChassisCV
						AND	NumeroVeiculoCV		IS NULL
						AND	SequenciaLaudoUsado	= (SELECT MAX(SequenciaLaudoUsado)
											FROM	tbLaudoVeiculoUsadoCV	(NOLOCK)
											WHERE	CodigoEmpresa		= @CodigoEmpresa
											AND	CodigoLocal		= @CodigoLocal
											AND	NumeroChassisVeicUsado	= @NumeroChassisCV
											AND	NumeroVeiculoCV		IS NULL)

						IF @@ERROR <> 0
						BEGIN
							CLOSE cur_PedidoCompra
							DEALLOCATE cur_PedidoCompra
							SELECT @ErrNo = 70321
							GOTO ERROR
						END
					END

					SELECT	@CodigoModalidadeCompra	= CodigoModalidadeCompraCV
					FROM	tbModalidadeCompraCV	(NOLOCK)
					WHERE	CodigoEmpresa		= @CodigoEmpresa
					AND	TipoModalidadeCompra	= 'V'

					-- Inclui Modalidade de Compras
					EXECUTE spIModalidadeCompraNFEntradaCV
						@CodigoEmpresa,
						@CodigoLocal,
						@NumeroVeiculoCV,
						@CodigoModalidadeCompra,
						@ValorContabilPed,
						@DataEmissaoNotaFiscalPed,
						@DataEmissaoNotaFiscalPed

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_PedidoCompra
						DEALLOCATE cur_PedidoCompra
						SELECT @ErrNo = 70321
						GOTO ERROR
					END

					-- Excluir Opcionais e Nota Fiscal Entrada de Usados
					DELETE	tbNFEntradaVeicUsadoOpcional
					WHERE	CodigoEmpresa		= @CodigoEmpresa
					AND	ChassiEntradaUsado	= @NumeroChassisCV

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_PedidoCompra
						DEALLOCATE cur_PedidoCompra
						SELECT @ErrNo = 70321
						GOTO ERROR
					END

					DELETE	tbNFEntradaVeiculoUsado
					WHERE	CodigoEmpresa		= @CodigoEmpresa
					AND	ChassiEntradaUsado	= @NumeroChassisCV

					IF @@ERROR <> 0
					BEGIN
						CLOSE cur_PedidoCompra
						DEALLOCATE cur_PedidoCompra
						SELECT @ErrNo = 70321
						GOTO ERROR
					END
				END	-- Compra de Veiculo Usado
			END	-- Origem 'CV'

			FETCH NEXT FROM cur_PedidoCompra INTO
			    	@CodigoEmpresa,
				@CodigoLocal,
				@CentroCusto,
				@NumeroPedido,
				@SequenciaPedido,
				@OrigemPedido,
				@CodigoNaturezaOperacao,
				@StatusPedidoPed,
				@NumeroNotaFiscalPed,
				@DataEmissaoNotaFiscalPed,
				@ValorContabilPed
		END 
	
		CLOSE cur_PedidoCompra
		DEALLOCATE cur_PedidoCompra
	END

	RETURN


	--Controle de Erros
	ERROR:
	IF @ErrNo IN (70321, 70477)
	BEGIN
		ROLLBACK TRANSACTION
	END
	RAISERROR (@ErrMsg, 10, 1)

END

SET NOCOUNT OFF
GO

go

IF OBJECT_ID('tnu_DSPa_VeiculoCV') IS NOT NULL
	DROP TRIGGER dbo.tnu_DSPa_VeiculoCV
GO

CREATE TRIGGER dbo.tnu_DSPa_VeiculoCV ON dbo.tbVeiculoCV
WITH ENCRYPTION
FOR UPDATE AS
SET NOCOUNT ON
IF UPDATE (StatusVeiculoCV)
BEGIN

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda.
 PROJETO......: Controle de Estoque
 AUTOR........: Edvaldo Ragassi
 DATA.........: 19/06/2007
 UTILIZADO EM : tnu_DSPa_VeiculoCV
 OBJETIVO.....: Ao alterar StatusVeiculoCV para 'NFE' na tbVeiculoCV dispara trigger acima para
		atualizacoes diversas.

 ALTERACAO....: Edvaldo Ragassi - 26/03/2008
 OBJETIVO.....: Nao atualizar numero da nota fiscal na tbOROSCIT.
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

	DECLARE @CodigoEmpresa			dtInteiro04
	DECLARE @CodigoLocal			dtInteiro04
	DECLARE @NumeroVeiculoCV		dtInteiro08
	DECLARE @ErrNo				INT
	DECLARE	@ErrMsg				VARCHAR(255)


	IF EXISTS	(SELECT 1 FROM deleted d
				INNER JOIN inserted i
				ON	i.CodigoEmpresa			= d.CodigoEmpresa
				AND	i.CodigoLocal			= d.CodigoLocal
				AND	i.NumeroVeiculoCV		= d.NumeroVeiculoCV
				WHERE	i.StatusVeiculoCV		IN ('DIS', 'NLI')
				AND	d.StatusVeiculoCV		= 'NFE'
			)
	BEGIN
		SELECT @ErrNo = 0
		SELECT @ErrMsg = ''
		-- Pedidos de Vendas
		DECLARE cur_Pedido INSENSITIVE CURSOR FOR
		SELECT	i.CodigoEmpresa,
			i.CodigoLocal,
			i.NumeroVeiculoCV
		FROM	inserted i
		INNER JOIN deleted d
		ON	d.CodigoEmpresa			= i.CodigoEmpresa
		AND	d.CodigoLocal			= i.CodigoLocal
		AND	d.NumeroVeiculoCV		= i.NumeroVeiculoCV
		WHERE	i.StatusVeiculoCV		IN ('DIS', 'NLI')
		AND	d.StatusVeiculoCV		= 'NFE'

		OPEN cur_Pedido
		FETCH NEXT FROM cur_Pedido INTO
		    	@CodigoEmpresa,
			@CodigoLocal,
			@NumeroVeiculoCV

		WHILE @@FETCH_STATUS <> -1
		BEGIN 
			IF EXISTS(SELECT 1 FROM sysobjects WHERE id = OBJECT_ID('tbPreVendaCV'))
			BEGIN
				UPDATE	dbo.tbPreVendaCV
				SET	FaturadoNFEmitida	= 'F'
				WHERE	CodigoEmpresa		= @CodigoEmpresa
				AND	CodigoLocalVeiculo	= @CodigoLocal
				AND	NumeroVeiculoCV		= @NumeroVeiculoCV

				IF @@ERROR <> 0
				BEGIN
					CLOSE cur_Pedido
					DEALLOCATE cur_Pedido
					SET @ErrMsg = 'Não foi possível atualizar tbPreVendaCV.'
					GOTO ERROR
				END
			END
			FETCH NEXT FROM cur_Pedido INTO
		    		@CodigoEmpresa,
				@CodigoLocal,
				@NumeroVeiculoCV
		END 
		CLOSE cur_Pedido
		DEALLOCATE cur_Pedido
	END

	RETURN


	--Controle de Erros
	ERROR:
		ROLLBACK TRANSACTION
		RAISERROR (@ErrMsg, 10, 1)

END

SET NOCOUNT OFF

GO

go

IF EXISTS (SELECT 1 FROM sysobjects WHERE id = OBJECT_ID('vwDocumentosPendentes'))
	DROP VIEW dbo.vwDocumentosPendentes
GO

CREATE VIEW dbo.vwDocumentosPendentes
WITH ENCRYPTION

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda.
 PROJETO......: Faturamento
 AUTOR........: Edvaldo Ragassi
 DATA.........: 08/01/2008
 UTILIZADO EM : whLPedPendIntegracao
 OBJETIVO.....: Filtrar Documentos Pendentes de Integracao

 ALTERACAO....: 
 OBJETIVO.....: 
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

AS

SELECT	TOP 100 PERCENT
	PED.CodigoEmpresa,
	PED.CodigoLocal,
	PED.CentroCusto,
	PED.NumeroPedido,
	PED.SequenciaPedido,
	PED.DataPedidoPed,
	PED.ValorContabilPed,
	PED.AtualizadoEstoquePed	AS CE,
	PED.AtualizadoLivroFiscalPed	AS LF,
	PED.AtualizadoContasReceberPed	AS CR,
	PED.AtualizadoContasPagarPed	AS CP,
	PED.AtualizadoComissoesPed	AS CO,
	PED.AtualizadoEstatisticaPed	AS ES,
	PED.AtualizadoContabilidadePed	AS CG,
	PED.AtualizadoFaturamentoPed	AS FT , 
	PED.NumeroNotaFiscalPed,
	PED.Recapagem

FROM 	tbPedido PED

WHERE	PED.StatusPedidoPed	< 4 
AND	PED.NumeroPedido	IN (SELECT b.NumeroPedidoDocumento FROM NFDocumento b
					WHERE	b.CodigoEmpresa			= PED.CodigoEmpresa
					AND	b.CodigoLocal			= PED.CodigoLocal
--					AND	b.TipoLancamentoMovimentacao	= 13
					AND	b.NumeroPedidoDocumento		= PED.NumeroPedido
					AND	b.NumeroSequenciaPedidoDocumento= PED.SequenciaPedido
					AND	b.NumeroDocumento		!= b.NumeroPedidoDocumento)

ORDER BY
	PED.CodigoEmpresa,
	PED.CodigoLocal,
	PED.NumeroPedido

GO
GRANT ALL ON dbo.vwDocumentosPendentes TO SQLUsers
GO

go

if exists(select 1 from sysobjects where id = object_id('whCancelaNFeDealers'))
DROP PROCEDURE dbo.whCancelaNFeDealers
GO

CREATE PROCEDURE dbo.whCancelaNFeDealers
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda
 PROJETO......: NFe
 AUTOR........: Edvaldo Ragassi
 DATA.........: 12/03/2009
 UTILIZADO EM : modDocumentoNFe.CancelarNFe
 OBJETIVO.....: Cancelar Nota Fiscal Eletronica não enviada ao SEFAZ
		Alterar o Status do Pedido envolvido, deixando-o apto para manutenção.
		
 ALTERACAO....:	
 OBJETIVO.....:	
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa			dtInteiro04,
@CodigoLocal			dtInteiro04,
@EntradaSaidaDocumento		Char(1),
@NumeroDocumento		dtInteiro06,
@DataDocumento			DateTime,
@CodigoCliFor			Numeric(14),
@TipoLancamentoMovimentacao	dtInteiro02

WITH ENCRYPTION
AS

SET NOCOUNT ON


DECLARE	@NumeroPedido		dtInteiro06
DECLARE	@SequenciaPedido	dtInteiro02
DECLARE	@CentroCusto		dtInteiro08
DECLARE @NumeroVeiculoCV	dtInteiro08
DECLARE @OrigemDocumento	Char(2)

SELECT	@NumeroPedido		= doc.NumeroPedidoDocumento,
	@SequenciaPedido	= doc.NumeroSequenciaPedidoDocumento,
	@CentroCusto		= dft.CentroCusto,
	@OrigemDocumento	= dft.OrigemDocumentoFT
FROM	NFDocumento doc		(NOLOCK)
INNER JOIN NFDocumentoFT dft	(NOLOCK)
ON	dft.CodigoEmpresa		= doc.CodigoEmpresa
AND	dft.CodigoLocal			= doc.CodigoLocal
AND	dft.EntradaSaidaDocumento	= doc.EntradaSaidaDocumento
AND	dft.NumeroDocumento		= doc.NumeroDocumento
AND	dft.DataDocumento		= doc.DataDocumento
AND	dft.CodigoCliFor		= doc.CodigoCliFor
AND	dft.TipoLancamentoMovimentacao	= doc.TipoLancamentoMovimentacao
WHERE	doc.CodigoEmpresa		= @CodigoEmpresa
AND	doc.CodigoLocal			= @CodigoLocal
AND	doc.EntradaSaidaDocumento	= @EntradaSaidaDocumento
AND	doc.NumeroDocumento		= @NumeroDocumento
AND	doc.DataDocumento		= @DataDocumento
AND	doc.CodigoCliFor		= @CodigoCliFor
AND	doc.TipoLancamentoMovimentacao	= @TipoLancamentoMovimentacao


-- Processo de Cancelamento do Documento Anterior
-- NFDocumento
UPDATE	NFDocumento
SET	CondicaoNFCancelada		= 'V',
	NumeroFaturaDocumento		= 0,
	ValorICMSDocumento		= 0,
	CodigoContaContabil		= NULL,
	ValorContabilDocumento		= 0,
	ValorBaseICMS1Documento		= 0,
	ValorBaseICMS2Documento		= 0,
	ValorBaseICMS3Documento		= 0,
	ValorIPIDocumento		= 0,
	ValorBaseIPI1Documento		= 0,
	ValorBaseIPI2Documento		= 0,
	ValorBaseIPI3Documento		= 0,
	ValorBaseISSDocumento		= 0,
	ValorISSDocumento		= 0,
	ValorBasePISDocumento		= 0,
	ValorPISDocumento		= 0,
	ValorICMSRetidoDocumento	= 0,
	ValorDespAcesDocumento		= 0,
	NumeroNFDocumento		= NULL,
	SerieNFDocumento		= NULL,
	EspecieNFDocumento		= NULL,
	ValorICMSSubstTribDocto		= 0,
	ValorICMSDiferidoDocto		= 0,
	BasePISSTDocumento		= 0,
	ValorPISSTDocumento		= 0,
	BaseCofinsSTDocumento		= 0,
	ValorCofinsSTDocumento		= 0,
	Recapagem			= 'F'
WHERE	CodigoEmpresa			= @CodigoEmpresa
AND	CodigoLocal			= @CodigoLocal
AND	EntradaSaidaDocumento		= @EntradaSaidaDocumento
AND	NumeroDocumento			= @NumeroDocumento
AND	DataDocumento			= @DataDocumento
AND	CodigoCliFor			= @CodigoCliFor
AND	TipoLancamentoMovimentacao	= @TipoLancamentoMovimentacao

-- NFDocumentoTextos
UPDATE	NFDocumentoTextos
SET	ObservacaoDocumento		= 'NOTA FISCAL ELETRONICA CANCELADA ANTES DO ENVIO AO SEFAZ.',
	ObservacaoCapaDocFT		= '',
	ObservacaoOrdemSeparacaoDocT	= '',
	MotivoCancelamento		= 'DOCUMENTO CANCELADO ANTES DE SER ENVIADO AO SEFAZ.',
	TextoCorpoNF			= ''
WHERE	CodigoEmpresa			= @CodigoEmpresa
AND	CodigoLocal			= @CodigoLocal
AND	EntradaSaidaDocumento		= @EntradaSaidaDocumento
AND	NumeroDocumento			= @NumeroDocumento
AND	DataDocumento			= @DataDocumento
AND	CodigoCliFor			= @CodigoCliFor
AND	TipoLancamentoMovimentacao	= @TipoLancamentoMovimentacao

-- NFItemDocumento
UPDATE	NFItemDocumento
SET	PercentualICMSItemDocto		= 0,
	ValorBaseICMS1ItemDocto		= 0,
	ValorICMSItemDocto		= 0,
	ValorBaseICMS2ItemDocto		= 0,
	ValorBaseICMS3ItemDocto		= 0,
	PercentualIPIItemDocto		= 0,
	ValorBaseIPI1ItemDocto		= 0,
	ValorIPIItemDocto		= 0,
	ValorBaseIPI2ItemDocto		= 0,
	ValorContabilItemDocto		= 0,
	ValorBaseIPI3ItemDocto		= 0,
	ValorBaseISSItemDocto		= 0,
	ValorISSItemDocto		= 0,
	ValorBasePISItemDocto		= 0,
	ValorPISItemDocto		= 0,
	BaseICMSSubstTribItemDocto	= 0,
	ValorICMSSubstTribItemDocto	= 0,
	ValorICMSRetidoItemDocto	= 0,
	ValorDifAliquotaICMSItemDocto	= 0,
	ValorDespAcesItemDocto		= 0,
	ValorFreteItemDocto		= 0,
	ValorSeguroItemDocto		= 0,
	CodigoClassificacaoFiscal	= NULL,
	CodigoMaoObraOS			= NULL,
	QtdeLancamentoItemDocto		= 0,
	ValorLancamentoItemDocto	= 0,
	PesoTotal			= 0,
	CodigoItemDocto			= NULL,
	QuantidadeDIPI			= NULL,
	CodigoSituacaoTributaria	= NULL,
	CodigoUnidadeDIPI		= NULL,
	NumeroVeiculoCV			= NULL,
	CodigoServicoISSItemDocto	= 0,
	ValorICMSOriginal		= 0,
	PercICMSOriginal		= 0,
	ValorICMSDiferidoItemDocto	= 0,
	CodigoProdutoReclassificacao	= NULL,
	FatorReclassificacao		= 0,
	BasePISSTItemDocto		= 0,
	ValorPISSTItemDocto		= 0,
	PercPISItemDocto		= 0,
	PercPISSTItemDocto		= 0
WHERE	CodigoEmpresa			= @CodigoEmpresa
AND	CodigoLocal			= @CodigoLocal
AND	EntradaSaidaDocumento		= @EntradaSaidaDocumento
AND	NumeroDocumento			= @NumeroDocumento
AND	DataDocumento			= @DataDocumento
AND	CodigoCliFor			= @CodigoCliFor
AND	TipoLancamentoMovimentacao	= @TipoLancamentoMovimentacao

-- NFItemDocumentoFT
UPDATE	NFItemDocumentoFT
SET	BaseCOFINSItDocFT		= 0,
	ValorCOFINSItDocFT		= 0
WHERE	CodigoEmpresa			= @CodigoEmpresa
AND	CodigoLocal			= @CodigoLocal
AND	EntradaSaidaDocumento		= @EntradaSaidaDocumento
AND	NumeroDocumento			= @NumeroDocumento
AND	DataDocumento			= @DataDocumento
AND	CodigoCliFor			= @CodigoCliFor
AND	TipoLancamentoMovimentacao	= @TipoLancamentoMovimentacao

-- Duplicatas e Comissoes
-------------------------------- Remove registro da NFDoctoReceberRepresentante
IF EXISTS(	SELECT * FROM NFDoctoReceberRepresentante (NOLOCK)
		WHERE	CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @CodigoLocal 
		AND EntradaSaidaDocumento = @EntradaSaidaDocumento AND NumeroDocumento = @NumeroDocumento
		AND DataDocumento = @DataDocumento AND CodigoCliFor = @CodigoCliFor AND TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao)
BEGIN
	DELETE	NFDoctoReceberRepresentante
	WHERE	CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @CodigoLocal
	AND EntradaSaidaDocumento = @EntradaSaidaDocumento AND NumeroDocumento = @NumeroDocumento
	AND DataDocumento = @DataDocumento AND CodigoCliFor = @CodigoCliFor AND TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao
	
	IF @@ERROR <> 0
	BEGIN
		RAISERROR ('Erro na eliminacao da NFDoctoReceberRepresentante', 16, 1)
	END
END


-------------------------------------------- Remove registros da NFDoctoReceber
IF EXISTS(	SELECT * FROM NFDoctoReceber (NOLOCK)
		WHERE	CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @CodigoLocal
		AND EntradaSaidaDocumento = @EntradaSaidaDocumento AND NumeroDocumento = @NumeroDocumento
		AND DataDocumento = @DataDocumento AND CodigoCliFor = @CodigoCliFor AND TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao)
BEGIN
	DELETE	NFDoctoReceber
	WHERE	CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @CodigoLocal
	AND EntradaSaidaDocumento = @EntradaSaidaDocumento AND NumeroDocumento = @NumeroDocumento
	AND DataDocumento = @DataDocumento AND CodigoCliFor = @CodigoCliFor AND TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao
	
	IF @@ERROR <> 0
	BEGIN
		RAISERROR ('Erro na eliminacao da NFDoctoReceber', 16, 1)
	END
END


---------------------------------- Remove registro da NFDoctoRecPagComplementar
IF EXISTS(	SELECT * FROM NFDoctoRecPagComplementar (NOLOCK)
		WHERE	CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @CodigoLocal
		AND EntradaSaidaDocumento = @EntradaSaidaDocumento AND NumeroDocumento = @NumeroDocumento
		AND DataDocumento = @DataDocumento AND CodigoCliFor = @CodigoCliFor AND TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao)
BEGIN
	DELETE	NFDoctoRecPagComplementar
	WHERE	CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @CodigoLocal
	AND EntradaSaidaDocumento = @EntradaSaidaDocumento AND NumeroDocumento = @NumeroDocumento
	AND DataDocumento = @DataDocumento AND CodigoCliFor = @CodigoCliFor AND TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao
	
	IF @@ERROR <> 0
	BEGIN
		RAISERROR ('Erro na eliminacao da NFDoctoRecPagComplementar', 16, 1)
	END
END


-------------------------------------------- Remove registros da NFDoctoPagar
IF EXISTS (	SELECT * FROM NFDocumentoPagar (NOLOCK)
		WHERE	CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @CodigoLocal
		AND EntradaSaidaDocumento = @EntradaSaidaDocumento AND NumeroDocumento = @NumeroDocumento
		AND DataDocumento = @DataDocumento AND CodigoCliFor = @CodigoCliFor AND TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao)
BEGIN
	DELETE	NFDocumentoPagar
	WHERE	CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @CodigoLocal
	AND EntradaSaidaDocumento = @EntradaSaidaDocumento AND NumeroDocumento = @NumeroDocumento
	AND DataDocumento = @DataDocumento AND CodigoCliFor = @CodigoCliFor AND TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao
	
	IF @@ERROR <> 0
	BEGIN
		RAISERROR ('Erro na eliminacao da NFDocumentoPagar', 16, 1)
	END
END

------------------------------------------------- Remove registros da NFDoctoRecPag
IF EXISTS (	SELECT * FROM NFDoctoRecPag (NOLOCK)
		WHERE	CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @CodigoLocal
		AND EntradaSaidaDocumento = @EntradaSaidaDocumento AND NumeroDocumento = @NumeroDocumento
		AND DataDocumento = @DataDocumento AND CodigoCliFor = @CodigoCliFor AND TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao)
BEGIN
	DELETE	NFDoctoRecPag
	WHERE	CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @CodigoLocal
	AND EntradaSaidaDocumento = @EntradaSaidaDocumento AND NumeroDocumento = @NumeroDocumento
	AND DataDocumento = @DataDocumento AND CodigoCliFor = @CodigoCliFor AND TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao
	
	IF @@ERROR <> 0
	BEGIN
		RAISERROR ('Erro na eliminacao da NFDoctoRecPag', 16, 1)
	END
END

-------------------------------------------- Remove registro da NFComissaoDocumento
IF EXISTS (	SELECT * FROM NFComissaoDocumento (NOLOCK)
		WHERE	CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @CodigoLocal
		AND EntradaSaidaDocumento = @EntradaSaidaDocumento AND NumeroDocumento = @NumeroDocumento
		AND DataDocumento = @DataDocumento AND CodigoCliFor = @CodigoCliFor AND TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao)
BEGIN
	DELETE	NFComissaoDocumento
	WHERE	CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @CodigoLocal
	AND EntradaSaidaDocumento = @EntradaSaidaDocumento AND NumeroDocumento = @NumeroDocumento
	AND DataDocumento = @DataDocumento AND CodigoCliFor = @CodigoCliFor AND TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao
	
	IF @@ERROR <> 0
	BEGIN
		RAISERROR ('Erro na eliminacao da NFComissaoDocumento', 16, 1)
	END
END

-- Efetivar Documento anterior
EXECUTE whEfetivarDoctoTemporario
	@CodigoEmpresa,
	@CodigoLocal,
	@EntradaSaidaDocumento,
	@NumeroDocumento,
	@DataDocumento,
	@CodigoCliFor

-- Eliminar DocumentoNFe
IF EXISTS (	SELECT 1 FROM tbDocumentoNFe (NOLOCK)
		WHERE	CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @CodigoLocal
		AND EntradaSaidaDocumento = @EntradaSaidaDocumento AND NumeroDocumento = @NumeroDocumento
		AND DataDocumento = @DataDocumento AND CodigoCliFor = @CodigoCliFor AND TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao)
BEGIN
	DELETE	tbDocumentoNFe
	WHERE	CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @CodigoLocal
	AND EntradaSaidaDocumento = @EntradaSaidaDocumento AND NumeroDocumento = @NumeroDocumento
	AND DataDocumento = @DataDocumento AND CodigoCliFor = @CodigoCliFor AND TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao

	IF @@ERROR <> 0
	BEGIN
		RAISERROR ('Erro na eliminacao da tbDocumentoNFe', 16, 1)
	END
END

-- tbPedido
IF EXISTS (SELECT 1 FROM tbPedido (NOLOCK)
		WHERE	CodigoEmpresa	= @CodigoEmpresa
		AND	CodigoLocal	= @CodigoLocal
		AND	CentroCusto	= @CentroCusto
		AND	NumeroPedido	= @NumeroPedido
		AND	SequenciaPedido	= @SequenciaPedido
		AND	StatusPedidoPed	= 8)
BEGIN
	UPDATE	tbPedido
	SET	StatusPedidoPed	= 1
	WHERE	CodigoEmpresa	= @CodigoEmpresa
	AND	CodigoLocal	= @CodigoLocal
	AND	CentroCusto	= @CentroCusto
	AND	NumeroPedido	= @NumeroPedido
	AND	SequenciaPedido	= @SequenciaPedido
	AND	StatusPedidoPed	= 8

	IF @@ERROR <> 0
	BEGIN
		RAISERROR ('Erro na atualizacao do Status do Pedido.', 16, 1)
	END
END

-- tbPedidoCV
IF @OrigemDocumento = 'CV'
BEGIN
	SET @NumeroVeiculoCV = 0
	SELECT	@NumeroVeiculoCV = ISNULL(NumeroVeiculoCV, 0)
	FROM	tbPedidoCV (NOLOCK)
	WHERE	CodigoEmpresa	= @CodigoEmpresa
	AND	CodigoLocal	= @CodigoLocal
	AND	CentroCusto	= @CentroCusto
	AND	NumeroPedido	= @NumeroPedido
	AND	SequenciaPedido	= @SequenciaPedido

	IF @NumeroVeiculoCV > 0
	BEGIN
		UPDATE	tbVeiculoCV
		SET	StatusVeiculoCV = 'NLI'
		WHERE	CodigoEmpresa	= @CodigoEmpresa
		AND	CodigoLocal	= @CodigoLocal
		AND	NumeroVeiculoCV	= @NumeroVeiculoCV

		DELETE tbPedidoCV
		WHERE	CodigoEmpresa	= @CodigoEmpresa
		AND	CodigoLocal	= @CodigoLocal
		AND	CentroCusto	= @CentroCusto
		AND	NumeroPedido	= @NumeroPedido
		AND	SequenciaPedido	= @SequenciaPedido
	END
END

-- tbOROSCIT
IF @OrigemDocumento = 'OS'
BEGIN
	IF EXISTS (SELECT 1 FROM tbOROSCITPedido (NOLOCK)
			WHERE	CodigoEmpresa	= @CodigoEmpresa
			AND	CodigoLocal	= @CodigoLocal
			AND	CentroCusto	= @CentroCusto
			AND	NumeroPedido	= @NumeroPedido
			AND	SequenciaPedido	= @SequenciaPedido)
	BEGIN
		UPDATE	tbOROSCIT
		SET	StatusOSCIT	= 'E'
		FROM	tbOROSCITPedido	(NOLOCK)
		WHERE	tbOROSCITPedido.CodigoEmpresa	= tbOROSCIT.CodigoEmpresa
		AND	tbOROSCITPedido.CodigoLocal	= tbOROSCIT.CodigoLocal
		AND	tbOROSCITPedido.FlagOROS	= tbOROSCIT.FlagOROS
		AND	tbOROSCITPedido.NumeroOROS	= tbOROSCIT.NumeroOROS
		AND	tbOROSCITPedido.CodigoCIT	= tbOROSCIT.CodigoCIT
		AND	tbOROSCITPedido.CodigoEmpresa	= @CodigoEmpresa
		AND	tbOROSCITPedido.CodigoLocal	= @CodigoLocal
		AND	tbOROSCITPedido.CentroCusto	= @CentroCusto
		AND	tbOROSCITPedido.NumeroPedido	= @NumeroPedido
		AND	tbOROSCITPedido.SequenciaPedido	= @SequenciaPedido

		IF @@ERROR <> 0
		BEGIN
			RAISERROR ('Erro na atualizacao do Status da Ordem de Servico.', 16, 1)
		END
	END
END


SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whCancelaNFeDealers TO SQLUsers
GO

go

if exists (select * from sysobjects where id = object_id('whEliminarEstruturaPedido') and sysstat & 0xf = 4)
DROP PROCEDURE dbo.whEliminarEstruturaPedido
GO

CREATE PROCEDURE dbo.whEliminarEstruturaPedido 
/*INICIO_CABEC_PROC
---------------------------------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: OS - Controle de Oficina
 AUTOR........: Edvaldo Ragassi
 DATA.........: 29/06/2007
 UTILIZADO EM : modEncerrarOS
 OBJETIVO.....: Esta procedure tem como finalidade eliminar a estrutura completa do pedido gerado
		para o encerramento da OS.

 DATA.........: 
 AUTOR........: 
 OBJETIVO.....: 
----------------------------------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa		NUMERIC(4),
@CodigoLocal		NUMERIC(4),
@CentroCusto 		NUMERIC(8),
@NumeroPedido 		NUMERIC(6),
@SequenciaPedido 	NUMERIC(2)


WITH ENCRYPTION
AS 

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


DECLARE	@NumeroOROS	dtInteiro06
DECLARE	@CodigoCIT	Char(4)

SELECT	@NumeroOROS	= 0
SELECT	@CodigoCIT	= ''

SELECT	@NumeroOROS	= NumeroOROS,
	@CodigoCIT	= CodigoCIT
FROM	tbOROSCITPedido
WHERE	CodigoEmpresa	= @CodigoEmpresa
AND	CodigoLocal	= @CodigoLocal
AND	CentroCusto	= @CentroCusto
AND	NumeroPedido	= @NumeroPedido
AND	SequenciaPedido	= @SequenciaPedido

IF NOT EXISTS (	SELECT	1
		FROM	tbOROSCITPedido
		WHERE	CodigoEmpresa	= @CodigoEmpresa
		AND	CodigoLocal	= @CodigoLocal
		AND	CentroCusto	= @CentroCusto
		AND	NumeroPedido	= @NumeroPedido
		AND	SequenciaPedido	!= @SequenciaPedido)
BEGIN
	UPDATE	tbOROSCIT
	SET	StatusOSCIT		= 'A',
		DataEncerramentoOSCIT	= NULL,
		DataEmissaoNotaFiscalOS	= NULL,
		NumeroNotaFiscalOS	= NULL
	WHERE	CodigoEmpresa		= @CodigoEmpresa
	AND	CodigoLocal		= @CodigoLocal
	AND	FlagOROS		= 'S'
	AND	NumeroOROS		= @NumeroOROS
	AND	CodigoCIT		= @CodigoCIT

	UPDATE	tbOROS
	SET	DataEncerramentoOS	= NULL
	WHERE	CodigoEmpresa		= @CodigoEmpresa
	AND	CodigoLocal		= @CodigoLocal
	AND	FlagOROS		= 'S'
	AND	NumeroOROS		= @NumeroOROS

	UPDATE	tbOS
	SET	StatusOS		= 'A'
	WHERE	CodigoEmpresa		= @CodigoEmpresa
	AND	CodigoLocal		= @CodigoLocal
	AND	FlagOROS		= 'S'
	AND	NumeroOROS		= @NumeroOROS
END

IF EXISTS (	SELECT	1
		FROM	tbOROSCITPedido
		WHERE	CodigoEmpresa	= @CodigoEmpresa
		AND	CodigoLocal	= @CodigoLocal
		AND	CentroCusto	= @CentroCusto
		AND	NumeroPedido	= @NumeroPedido
		AND	SequenciaPedido	!= @SequenciaPedido)
BEGIN
	UPDATE	tbOROSCIT
	SET	StatusOSCIT		= 'E'
	WHERE	CodigoEmpresa		= @CodigoEmpresa
	AND	CodigoLocal		= @CodigoLocal
	AND	FlagOROS		= 'S'
	AND	NumeroOROS		= @NumeroOROS
	AND	CodigoCIT		= @CodigoCIT

	UPDATE	tbOS
	SET	StatusOS		= 'A'
	WHERE	CodigoEmpresa		= @CodigoEmpresa
	AND	CodigoLocal		= @CodigoLocal
	AND	FlagOROS		= 'S'
	AND	NumeroOROS		= @NumeroOROS
END


DELETE	tbOROSCITPedido
WHERE	CodigoEmpresa	= @CodigoEmpresa
AND	CodigoLocal	= @CodigoLocal
AND	CentroCusto	= @CentroCusto
AND	NumeroPedido	= @NumeroPedido
AND	SequenciaPedido	= @SequenciaPedido

DELETE	tbVendaPerdida
WHERE	CodigoEmpresa	= @CodigoEmpresa
AND	CodigoLocal	= @CodigoLocal
AND	CentroCusto	= @CentroCusto
AND	NumeroPedido	= @NumeroPedido
AND	SequenciaPedido	= @SequenciaPedido

DELETE	tbPedidoVenda
WHERE	CodigoEmpresa	= @CodigoEmpresa
AND	CodigoLocal	= @CodigoLocal
AND	CentroCusto	= @CentroCusto
AND	NumeroPedido	= @NumeroPedido
AND	SequenciaPedido	= @SequenciaPedido

DELETE	tbComissaoPedido
WHERE	CodigoEmpresa	= @CodigoEmpresa
AND	CodigoLocal	= @CodigoLocal
AND	CentroCusto	= @CentroCusto
AND	NumeroPedido	= @NumeroPedido
AND	SequenciaPedido	= @SequenciaPedido

DELETE	tbDuplicataPedido
WHERE	CodigoEmpresa	= @CodigoEmpresa
AND	CodigoLocal	= @CodigoLocal
AND	CentroCusto	= @CentroCusto
AND	NumeroPedido	= @NumeroPedido
AND	SequenciaPedido	= @SequenciaPedido

DELETE	tbItemPedido
WHERE	CodigoEmpresa	= @CodigoEmpresa
AND	CodigoLocal	= @CodigoLocal
AND	CentroCusto	= @CentroCusto
AND	NumeroPedido	= @NumeroPedido
AND	SequenciaPedido	= @SequenciaPedido

DELETE	tbRepresentantePedido
WHERE	CodigoEmpresa	= @CodigoEmpresa
AND	CodigoLocal	= @CodigoLocal
AND	CentroCusto	= @CentroCusto
AND	NumeroPedido	= @NumeroPedido
AND	SequenciaPedido	= @SequenciaPedido

DELETE	tbTextoPedido
WHERE	CodigoEmpresa	= @CodigoEmpresa
AND	CodigoLocal	= @CodigoLocal
AND	CentroCusto	= @CentroCusto
AND	NumeroPedido	= @NumeroPedido
AND	SequenciaPedido	= @SequenciaPedido

DELETE	tbPedidoComplementar
WHERE	CodigoEmpresa	= @CodigoEmpresa
AND	CodigoLocal	= @CodigoLocal
AND	CentroCusto	= @CentroCusto
AND	NumeroPedido	= @NumeroPedido
AND	SequenciaPedido	= @SequenciaPedido

DELETE	tbPedidoOS
WHERE	CodigoEmpresa	= @CodigoEmpresa
AND	CodigoLocal	= @CodigoLocal
AND	CentroCusto	= @CentroCusto
AND	NumeroPedido	= @NumeroPedido
AND	SequenciaPedido	= @SequenciaPedido

DELETE	tbPedido
WHERE	CodigoEmpresa	= @CodigoEmpresa
AND	CodigoLocal	= @CodigoLocal
AND	CentroCusto	= @CentroCusto
AND	NumeroPedido	= @NumeroPedido
AND	SequenciaPedido	= @SequenciaPedido



SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whEliminarEstruturaPedido TO SQLUsers
GO

go

if exists (select * from sysobjects where id = object_id('whEncerramentoMesEstoque') and sysstat & 0xf = 4)
DROP PROCEDURE dbo.whEncerramentoMesEstoque
GO

CREATE PROCEDURE dbo.whEncerramentoMesEstoque 

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: CDC - Consulters/Humaita
 PROJETO......: Controle de Estoque
 AUTOR........: Paulo Sergio Nobrega Vieira
 DATA.........: 25/11/1998
 UTILIZADO EM : clsProduto.EncerrarMesEstoque
 OBJETIVO.....: Stored Procedure responsavel pelo encerramento do estoque no periodo
		DealerStar - Sistema de Controle de Estoque - FrmCEEncerramento 

 ALTERACAO....: Edvaldo Ragassi - 23/10/2003
 OBJETIVO.....: Mudanca do Parametro para o Fim do Processo.
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa		dtInteiro04,
@Periodo		Char(6)

WITH ENCRYPTION
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


-- Variaveis usadas no decorrer desta Stored Procedure:

DECLARE @CodigoAlmoxarifado		CHAR(6)
DECLARE @CodigoProduto			dtCharacter30
DECLARE @DescricaoProduto		dtCharacter60
DECLARE @PeriodoSaldoAlmoxarifado	dtAnoMes
DECLARE @QtdeEntradaSaldoAlmoxarifado  	numeric(16,4)    
DECLARE @QtdeSaidaSaldoAlmoxarifado    	numeric(16,4)        
DECLARE @QtdeAnteriorSaldoAlmoxarifado 	numeric(16,4)        
DECLARE @SaldoAnteriorProduto	       	numeric(16,4)	
DECLARE @CodigoLinhaProduto 	       	dtInteiro04
DECLARE @QtdeAcumulada			numeric (16,4)
DECLARE @ProximoPeriodo 		varchar(8)
DECLARE @SaldoValorEstoque		dtValorMonetario
DECLARE @CustoUnitarioUltimaCompra 	dtValorMonetario
DECLARE @PeriodoValorEstoque		dtAnoMes
DECLARE @Mensagem			varchar(255)
DECLARE @CodigoLocal		        dtInteiro04
DECLARE @auxCodigoNaturezaOperacao 	dtInteiro06
DECLARE @DiaInicioAtual 		datetime
DECLARE	@DiaFimAtual			datetime
DECLARE @Almoxarifado                   CHAR(6) 
DECLARE @QtdeEntrada                    numeric(16,4)
DECLARE @QtdeSaida                      numeric(16,4)
DECLARE @SaldoAlmoxarifadoPeriodo       numeric(16,4)
DECLARE @SaldoValorRemessaPropria	dtValorMonetario
DECLARE @SaldoValorRemessaTerceiros	dtValorMonetario
DECLARE @SaldoValorPecasUsadas		dtValorMonetario
DECLARE	@SaldoValorPecasConsignadas	dtValorMonetario

-- Verificar se existem Notas Digitadas, cujo atributo DataNota pertenca ao
--  Periodo que esta sendo encerrado
IF EXISTS (
	SELECT	nd.DataNotaDigitada
	FROM 	tbNotaDigitada nd
	WHERE 	SubString(Convert(Varchar(20), nd.DataNotaDigitada, 112), 1, 6) = @Periodo AND
		nd.CodigoEmpresa = @CodigoEmpresa AND
		EstoqueAtualizadoNotaDigitada = 'F')
BEGIN
	RAISERROR ('65182', 16, 4)
	RETURN -2
END

-- Verificar se existem Requisicoes de Saida, cuja Data pertenca ao periodo que 
-- esta sendo encerrado
IF EXISTS (
	SELECT 	DataEmissaoRequisicaoSaida
	FROM 	tbRequisicaoSaida
	WHERE 	CodigoEmpresa = @CodigoEmpresa	AND
		SubString(Convert(Varchar(20),DataEmissaoRequisicaoSaida, 112), 1, 6) = @Periodo )
BEGIN
	RAISERROR ('65182', 16, 4)
	RETURN -2 
END


-- Verificar se existem pedidos com DataPedidoPed dentro do periodo de encerramento
-- e com o StatusPedidoPed <> 5 (Nao Processar)
IF EXISTS (
		SELECT 	DataPedidoPed			
		FROM	tbPedido
		WHERE   CodigoEmpresa = @CodigoEmpresa
		AND	SubString(Convert(Varchar(20),DataEmissaoNotaFiscalPed, 112), 1, 6) = @Periodo
		AND	StatusPedidoPed NOT IN (1, 2, 3, 5)
	  )
BEGIN
	IF EXISTS (
			SELECT 	AtualizaEstoqueNaturezaOper
			FROM 	tbNaturezaOperacao
			INNER JOIN tbPedido
			ON	tbPedido.CodigoEmpresa		= tbNaturezaOperacao.CodigoEmpresa
			AND	tbPedido.CodigoNaturezaOperacao	= tbNaturezaOperacao.CodigoNaturezaOperacao 
			WHERE	tbPedido.CodigoEmpresa		= @CodigoEmpresa
			AND	SubString(Convert(Varchar(20),tbPedido.DataEmissaoNotaFiscalPed, 112), 1, 6) = @Periodo
			AND	StatusPedidoPed NOT IN (1, 2, 3, 5)
			AND	tbPedido.AtualizadoEstoquePed = 'F' 
			AND	tbNaturezaOperacao.AtualizaEstoqueNaturezaOper = 'V' 
		)
	BEGIN
		RAISERROR ('65182', 16, 4)
		RETURN -2 
	END
END

IF EXISTS	(
			SELECT 	DataDocumento
			FROM 	NFDocumento
			WHERE   CodigoEmpresa	= @CodigoEmpresa
			AND	SubString(Convert(Varchar(20),DataDocumento, 112), 1, 6) = @Periodo
			AND	NumeroDocumento	!= NumeroPedidoDocumento
		)
BEGIN
	RAISERROR ('65182', 16, 4)
	RETURN -2 
END


-- Calcular o novo periodo da tabela tbEmpresaCE
SELECT @ProximoPeriodo =  @Periodo + '01'
SELECT @ProximoPeriodo = SUBSTRING(CONVERT(VARCHAR(8),DATEADD(mm, 1, @ProximoPeriodo),112),1,6)

SELECT @DiaInicioAtual = @ProximoPeriodo + '01'

SELECT @DiaFimAtual = CONVERT(VARCHAR(8),DATEADD(mm, 1, @DiaInicioAtual),112)
SELECT @DiaFimAtual = CONVERT(VARCHAR(8),DATEADD(dd, -1, @DiaFimAtual),112)

-- Desabilita TRIGGER das tabelas
ALTER TABLE tbSaldoAlmoxarifadoPeriodo DISABLE TRIGGER tnu_DSPa_SaldoAlmoxarifadoPeriodo
ALTER TABLE tbSaldoAtualAlmoxarifado DISABLE TRIGGER tnu_DSPa_SaldoAtualAlmoxarifado

-- Cursor para todos os locais da empresa
DECLARE Cur_LocalEmpresa INSENSITIVE CURSOR FOR
SELECT	CodigoLocal
FROM	tbLocal
WHERE	CodigoEmpresa = @CodigoEmpresa

OPEN Cur_LocalEmpresa
FETCH NEXT FROM Cur_LocalEmpresa INTO @CodigoLocal
WHILE @@Fetch_Status <> -1
BEGIN
	-- Inserir todos os registros  da tabela tbSaldoAtualAlmoxarifado na tabela
	-- tbSaldoAlmoxarifadoPeriodo por Empresa / Local
	INSERT tbSaldoAlmoxarifadoPeriodo
		(CodigoEmpresa,
		CodigoLocal,
		CodigoAlmoxarifado,
		CodigoProduto,
		PeriodoSaldoAlmoxarifado,
		QtdeEntradaSaldoAlmoxarifado,
		QtdeSaidaSaldoAlmoxarifado,
		QtdeAnteriorSaldoAlmoxarifado )
	
	SELECT	CodigoEmpresa,
		CodigoLocal,
		CodigoAlmoxarifado,
		CodigoProduto,
		@Periodo,
		QtdeEntradaSaldoAtuAlmox,
		QtdeSaidaSaldoAtuAlmoxarifado,
		QtdeAntSaldoAtuAlmoxarifado
	FROM	tbSaldoAtualAlmoxarifado
	WHERE	CodigoEmpresa 	= @CodigoEmpresa
	AND	CodigoLocal	= @CodigoLocal


	-- Verifica a ocorrencia de erros
	IF (@@ERROR <> 0)
	BEGIN
		CLOSE Cur_LocalEmpresa
		DEALLOCATE Cur_LocalEmpresa
		RAISERROR ('65857', 16, 4)
		RETURN -2 
	END

        -- Atualizar a tabela tbSaldoAtualAlmoxarifado zerando os saldos atuais e recalculando
	-- o saldo anterior.
	UPDATE	tbSaldoAtualAlmoxarifado
	SET	QtdeAntSaldoAtuAlmoxarifado	= (QtdeAntSaldoAtuAlmoxarifado + QtdeEntradaSaldoAtuAlmox - QtdeSaidaSaldoAtuAlmoxarifado) ,
		QtdeEntradaSaldoAtuAlmox	= 0,
		QtdeSaidaSaldoAtuAlmoxarifado	= 0
	WHERE	CodigoEmpresa	= @CodigoEmpresa
	AND	CodigoLocal	= @CodigoLocal

	-- Verifica a ocorrencia de erros
	IF (@@ERROR <> 0)
	BEGIN
		CLOSE Cur_LocalEmpresa
		DEALLOCATE Cur_LocalEmpresa
		RETURN -1 
	END

	-- Declara Cursor para todos os registros da tabela tbValorEstoquePeriodo
	DECLARE Cur_ValorEstoque INSENSITIVE CURSOR FOR
	SELECT	CodigoEmpresa,
		CodigoLocal,
		CodigoProduto,
		PeriodoValorEstoque,
		SaldoValorEstoque,
		CustoUnitarioUltimaCompra,
		SaldoValorRemessaPropria,
		SaldoValorRemessaTerceiros,
		SaldoValorPecasUsadas,
		SaldoValorPecasConsignadas
	FROM	tbValorEstoquePeriodo
	WHERE	CodigoEmpresa		= @CodigoEmpresa
	AND	CodigoLocal		= @CodigoLocal
	AND	PeriodoValorEstoque	= @Periodo

	OPEN Cur_ValorEstoque
	FETCH NEXT FROM Cur_ValorEstoque INTO
			@CodigoEmpresa,
			@CodigoLocal,
			@CodigoProduto,
		 	@PeriodoValorEstoque,
			@SaldoValorEstoque,
			@CustoUnitarioUltimaCompra,
			@SaldoValorRemessaPropria,
			@SaldoValorRemessaTerceiros,
			@SaldoValorPecasUsadas,
			@SaldoValorPecasConsignadas

	-- Varrer todos os registros encontrados
	WHILE @@FETCH_STATUS <> -1
	BEGIN
		EXECUTE spIValorEstoquePeriodo
			@CodigoEmpresa 			= @CodigoEmpresa,
			@CodigoLocal 			= @CodigoLocal,
			@CodigoProduto 			= @CodigoProduto,
			@PeriodoValorEstoque 		= @ProximoPeriodo,
			@SaldoValorEstoque 		= @SaldoValorEstoque,
			@CustoUnitarioUltimaCompra 	= @CustoUnitarioUltimaCompra,
			@SaldoValorRemessaPropria	= @SaldoValorRemessaPropria,
			@SaldoValorRemessaTerceiros	= @SaldoValorRemessaTerceiros,
			@SaldoValorPecasUsadas		= @SaldoValorPecasUsadas,
			@SaldoValorPecasConsignadas	= @SaldoValorPecasConsignadas

		-- Verifica a ocorrencia de erros
		IF (@@ERROR <> 0)
		BEGIN
			CLOSE Cur_LocalEmpresa
			DEALLOCATE Cur_LocalEmpresa
			CLOSE Cur_ValorEstoque
			DEALLOCATE Cur_ValorEstoque
			RAISERROR ('65858', 16, 4)
			RETURN -2 
		END

		FETCH NEXT FROM Cur_ValorEstoque INTO
				@CodigoEmpresa,
				@CodigoLocal,
				@CodigoProduto,
			 	@PeriodoValorEstoque,
				@SaldoValorEstoque,
				@CustoUnitarioUltimaCompra,
				@SaldoValorRemessaPropria,
				@SaldoValorRemessaTerceiros,
				@SaldoValorPecasUsadas,
				@SaldoValorPecasConsignadas
	END
	
	-- Fecha o cursor
	CLOSE Cur_ValorEstoque
	-- Libera a memoria
	DEALLOCATE Cur_ValorEstoque
			
	FETCH NEXT FROM Cur_LocalEmpresa INTO @CodigoLocal
END	

-- Fecha o cursor
CLOSE Cur_LocalEmpresa
-- Libera a memoria
DEALLOCATE Cur_LocalEmpresa
	    

--*********************************************************************************	
-- Cursor para todos os Registros de Movimento do mes atual que foram inclusos 
-- indevidamente no fechamento
--*********************************************************************************
DECLARE Cur_RegistroMovto INSENSITIVE CURSOR FOR
SELECT	CodigoLocal,
	CodigoProduto,
	CodigoAlmoxarifado,	
	QtdeEntrada =	(CASE EntradaSaidaMovtoEstoque
			 WHEN 'E' THEN QuantidadeMovtoEstoque			
			 ELSE 0
			 END
			),
	QtdeSaida =	(CASE EntradaSaidaMovtoEstoque
			 WHEN 'S' THEN QuantidadeMovtoEstoque			
			 ELSE 0
			 END
			)		   
FROM	tbRegistroMovtoEstoque
WHERE	CodigoEmpresa		= @CodigoEmpresa
AND	DataMovtoEstoque	BETWEEN @DiaInicioAtual	AND @DiaFimAtual	   		  
ORDER BY
	CodigoEmpresa, 
	CodigoLocal,
	CodigoProduto,
	CodigoAlmoxarifado			

OPEN Cur_RegistroMovto
FETCH NEXT FROM Cur_RegistroMovto INTO
		@CodigoLocal,
		@CodigoProduto,
		@Almoxarifado,
		@QtdeEntrada,
		@QtdeSaida	

--Processo para acerto tbSaldoAlmoxarifadoPeriodo e tbSaldoAtualAlmoxarifado	
WHILE @@Fetch_Status <> -1
BEGIN	
	SELECT @SaldoAlmoxarifadoPeriodo = Null

	SELECT @SaldoAlmoxarifadoPeriodo =  
		(QtdeAnteriorSaldoAlmoxarifado + QtdeEntradaSaldoAlmoxarifado - QtdeSaidaSaldoAlmoxarifado - @QtdeEntrada + @QtdeSaida)
	FROM tbSaldoAlmoxarifadoPeriodo
	WHERE	CodigoEmpresa			= @CodigoEmpresa
	AND	CodigoLocal			= @CodigoLocal
	AND	CodigoAlmoxarifado		= @Almoxarifado
	AND	CodigoProduto			= @CodigoProduto
	AND	PeriodoSaldoAlmoxarifado	= @Periodo

	IF @SaldoAlmoxarifadoPeriodo >= 0 
	BEGIN
		-- Atualiza tbSaldoAlmoxarifado para QtdeEntrada QtdeSaida
		UPDATE tbSaldoAlmoxarifadoPeriodo
		SET	QtdeEntradaSaldoAlmoxarifado	= QtdeEntradaSaldoAlmoxarifado - @QtdeEntrada,
			QtdeSaidaSaldoAlmoxarifado	= QtdeSaidaSaldoAlmoxarifado - @QtdeSaida
		WHERE	CodigoEmpresa			= @CodigoEmpresa
		AND	CodigoLocal			= @CodigoLocal
		AND	CodigoAlmoxarifado		= @Almoxarifado
		AND	CodigoProduto			= @CodigoProduto
		AND	PeriodoSaldoAlmoxarifado	= @Periodo

		-- Verifica a ocorrencia de erros
		IF (@@ERROR <> 0)
		BEGIN
    			CLOSE Cur_RegistroMovto
				DEALLOCATE Cur_RegistroMovto
			RAISERROR ('65963', 16, 4)
			RETURN -1 
		END

		-- Atualiza tbSaldoAtualAlmoxarifado para QtdeEntrada QtdeSaida e SaldoAnterior
		UPDATE tbSaldoAtualAlmoxarifado
		SET	QtdeEntradaSaldoAtuAlmox	= (QtdeEntradaSaldoAtuAlmox + @QtdeEntrada),
			QtdeSaidaSaldoAtuAlmoxarifado	= (QtdeSaidaSaldoAtuAlmoxarifado + @QtdeSaida),
			QtdeAntSaldoAtuAlmoxarifado	= (QtdeAntSaldoAtuAlmoxarifado -  @QtdeEntrada + @QtdeSaida)
		WHERE	CodigoEmpresa			= @CodigoEmpresa
		AND	CodigoLocal			= @CodigoLocal
		AND	CodigoAlmoxarifado		= @Almoxarifado
		AND	CodigoProduto			= @CodigoProduto

		IF (@@ERROR <> 0)
		BEGIN
    			CLOSE Cur_RegistroMovto
				DEALLOCATE Cur_RegistroMovto
			RAISERROR ('65964', 16, 4)
			RETURN -1 
		END
	END

        FETCH NEXT FROM Cur_RegistroMovto INTO
		@CodigoLocal,
		@CodigoProduto,
		@Almoxarifado,
		@QtdeEntrada,
		@QtdeSaida	
END

-- Fecha o cursor
CLOSE Cur_RegistroMovto
-- Libera a memoria
DEALLOCATE Cur_RegistroMovto

-- Atualiza tabela tbEmpresaCE com o valor do Proximo Periodo
UPDATE	tbEmpresaCE 
SET	PeriodoAtualEstoque	= @ProximoPeriodo
WHERE	CodigoEmpresa		= @CodigoEmpresa

-- Verifica a ocorrencia de erros
IF (@@ERROR <> 0)
BEGIN
	RAISERROR ('65184', 16, 4)
	RETURN -2 
END

-- Habilita TRIGGER das tabelas.
ALTER TABLE tbSaldoAlmoxarifadoPeriodo ENABLE TRIGGER tnu_DSPa_SaldoAlmoxarifadoPeriodo
ALTER TABLE tbSaldoAtualAlmoxarifado ENABLE TRIGGER tnu_DSPa_SaldoAtualAlmoxarifado
	
-- Zerar Saldos em Valores de Itens com Estoque Zero.
UPDATE	tbValorEstoquePeriodo
SET	SaldoValorEstoque = 0
FROM	vwSaldoGeralProdutoPeriodo saldo
WHERE	tbValorEstoquePeriodo.CodigoEmpresa		= saldo.CodigoEmpresa
AND	tbValorEstoquePeriodo.CodigoLocal		= saldo.CodigoLocal
AND	tbValorEstoquePeriodo.CodigoProduto		= saldo.CodigoProduto
AND	tbValorEstoquePeriodo.PeriodoValorEstoque	= saldo.Periodo
AND	tbValorEstoquePeriodo.CodigoEmpresa		= @CodigoEmpresa
AND	tbValorEstoquePeriodo.PeriodoValorEstoque	= @ProximoPeriodo
AND	tbValorEstoquePeriodo.SaldoValorEstoque		!= 0
AND	saldo.EstoqueGeral				= 0

UPDATE	tbValorEstoquePeriodo
SET	SaldoValorEstoque				= 0
WHERE	CodigoEmpresa					= @CodigoEmpresa
AND	PeriodoValorEstoque				= @ProximoPeriodo
AND	tbValorEstoquePeriodo.SaldoValorEstoque		!= 0
AND	NOT EXISTS (SELECT 1 FROM vwSaldoGeralProdutoPeriodo saldo
			WHERE	saldo.CodigoEmpresa	= tbValorEstoquePeriodo.CodigoEmpresa
			AND	saldo.CodigoLocal	= tbValorEstoquePeriodo.CodigoLocal
			AND	saldo.CodigoProduto	= tbValorEstoquePeriodo.CodigoProduto
			AND	saldo.Periodo		= tbValorEstoquePeriodo.PeriodoValorEstoque)



RETURN 0


SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whEncerramentoMesEstoque TO SQLUsers
GO

go

if exists(SELECT 1 from sysobjects where id = object_id('whLDocumentoAgruparNFFatura'))
DROP PROCEDURE dbo.whLDocumentoAgruparNFFatura
GO

CREATE PROCEDURE dbo.whLDocumentoAgruparNFFatura
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: CDC - Consulters/Humaita
 PROJETO......: Faturamento
 AUTOR........: Paulo Eduardo Trombetta
 DATA.........: 04/03/1999
 UTILIZADO EM : objNotasFiscaisFaturasDuplicatas.AgruparNotasFiscaisEmFatura
 OBJETIVO.....: Selecionar Notas fiscais para geracao da fatura

 ALTERACAO....: 12/06/1999
 OBJETIVO.....: Rotina para verificar se Nota for do Veiculo, buscar Representante da
                tbRepresentantePedido, senao, da tbDoctoReceberRepresentante

 ALTERACAO....: 10/10/2002 - Marcio Schvartz
 OBJETIVO.....: Revisao para otimizacao de performance
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa 			dtInteiro04,
@CodigoLocal 			dtInteiro04,
@RegraEmissaoFatura		tinyint,
@DataFaturamento		datetime	= null,
@NumeroDocumentoInicial 	dtInteiro06 	= null,
@NumeroDocumentoFinal 		dtInteiro06 	= null,
@CodigoCliForInicial		numeric(14)	= null, 
@CodigoCliForFinal		numeric(14) 	= null,
@DataEmissaoDoctoFatura		datetime	= null,
@DataProcessamento		datetime        = null

WITH ENCRYPTION
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE	@MyGroupInvoices	TABLE
	(
		CodigoEmpresa			Numeric(4),
		CodigoLocal			Numeric(4),
		EntradaSaidaDocumento		Char(1),
		NumeroDocumento			Numeric(6),
		DataDocumento			DateTime,
		CodigoCliFor			Numeric(14),
		TipoLancamentoMovimentacao	Int,
		DataProvavelFaturamentoDocFT	DateTime,
		DataVencimentoDocFT		DateTime,
		CodigoPlanoPagamento		Char(4),
		CentroCusto			Numeric(8),
		OrigemDocumentoFT		Char(2),
		CodigoRepresentante		Int,
		NumeroFaturaDocumento		Numeric(6),
		PercentualDescFinDocumento	Numeric(4,2),
		DiasDescFinanceiroDocumento	Int,
		ValorAntecipadoDocumento	Numeric(19,4),
		ValorContabilDocumento		Numeric(19,4),
		TotalProdutosDocumento		Numeric(19,4),
		TotalEncargosFinDocumento	Numeric(19,4),
		TotalDescontoDocumento		Numeric(19,4),
		ValorICMSDocumento		Numeric(19,4),
		ValorIPIDocumento		Numeric(19,4),
		NumeroSequenciaPedidoDocumento	Int,
		NumeroPedidoDocumento		Numeric(6),
		CentroCusto1			Numeric(8),
		AgrupaNotaFaturamento		Char(1)
	)

-----------------------------------------------------------------------------------------------
-- Configuracao de variaveis
-----------------------------------------------------------------------------------------------
IF @CodigoCliForInicial IS NULL
BEGIN
	SELECT @CodigoCliForInicial = 0
END

IF @CodigoCliForFinal IS NULL
BEGIN
	SELECT @CodigoCliForFinal = 99999999999999
END

IF @NumeroDocumentoInicial IS NULL
BEGIN
	SELECT @NumeroDocumentoInicial = 0
END

IF @NumeroDocumentoFinal IS NULL
BEGIN
	SELECT @NumeroDocumentoFinal = 999999
END

-----------------------------------------------------------------------------------------------
-- Query base
-----------------------------------------------------------------------------------------------
INSERT @MyGroupInvoices
SELECT DISTINCT
	DFT.CodigoEmpresa,
	DFT.CodigoLocal,
	DFT.EntradaSaidaDocumento,
	DFT.NumeroDocumento,
	DFT.DataDocumento,
	DFT.CodigoCliFor,
	DFT.TipoLancamentoMovimentacao,
	DFT.DataProvavelFaturamentoDocFT,
	DFT.DataVencimentoDocFT,
	DFT.CodigoPlanoPagamento,
	DFT.CentroCusto,
	DFT.OrigemDocumentoFT,
	dbo.fnCodigoRepresentante(DOC.CodigoEmpresa, DOC.CodigoLocal, DOC.EntradaSaidaDocumento, DOC.NumeroDocumento, DOC.DataDocumento, DOC.CodigoCliFor, DOC.TipoLancamentoMovimentacao),
	DOC.NumeroFaturaDocumento,
	DOC.PercentualDescFinDocumento,
	DOC.DiasDescFinanceiroDocumento,
	DOC.ValorAntecipadoDocumento,
	CASE WHEN CFOR.CondicaoRetencaoISS <> 'D' THEN
		DOC.ValorContabilDocumento
	ELSE
		( DOC.ValorContabilDocumento - DOC.ValorISSDocumento )
	END, --as ValorContabilDocumento,
	CASE WHEN CFOR.CondicaoRetencaoISS <> 'D' THEN
		DOC.TotalProdutosDocumento
	ELSE
		CASE	WHEN ( DOC.TotalProdutosDocumento - DOC.ValorISSDocumento ) < 0
			THEN 0
			ELSE ( DOC.TotalProdutosDocumento - DOC.ValorISSDocumento )
		END
	END, --AS TotalProdutosDocumento,
	DOC.TotalEncargosFinDocumento,
	DOC.TotalDescontoDocumento,
	DOC.ValorICMSDocumento,
	DOC.ValorIPIDocumento,
	DOC.NumeroSequenciaPedidoDocumento,
	DOC.NumeroPedidoDocumento,
	CASE @RegraEmissaoFatura
		when 1 then DFT.CentroCusto
		when 3 then DFT.CentroCusto
	END, --CentroCusto1,
	COALESCE(CLI.AgrupaNotaFaturamento,'V') --as AgrupaNotaFaturamento

FROM	tbDocumento DOC

	INNER JOIN tbEmpresaFT EFT ON
	EFT.CodigoEmpresa 		= DOC.CodigoEmpresa 

	INNER JOIN tbDocumentoFT DFT  ON
	DFT.CodigoEmpresa 		= DOC.CodigoEmpresa AND
	DFT.CodigoLocal 		= DOC.CodigoLocal AND
	DFT.EntradaSaidaDocumento 	= DOC.EntradaSaidaDocumento AND 
	DFT.NumeroDocumento 		= DOC.NumeroDocumento AND
	DFT.DataDocumento 		= DOC.DataDocumento AND
	DFT.CodigoCliFor 		= DOC.CodigoCliFor AND
	DFT.TipoLancamentoMovimentacao 	= DOC.TipoLancamentoMovimentacao 

	INNER JOIN tbCliFor CFOR  on
	CFOR.CodigoEmpresa		= DOC.CodigoEmpresa AND
	CFOR.CodigoCliFor		= DOC.CodigoCliFor

	LEFT JOIN tbPlanoPagamento PLN  ON
	PLN.CodigoEmpresa 		= DFT.CodigoEmpresa AND
 	PLN.CodigoPlanoPagamento 	= DFT.CodigoPlanoPagamento 

	INNER JOIN tbNaturezaOperacao nop 
	ON nop.CodigoEmpresa = DFT.CodigoEmpresa
	AND nop.CodigoNaturezaOperacao = DFT.CodigoNaturezaOperacao

	LEFT JOIN tbClienteComplementar CLI 
	ON CLI.CodigoEmpresa = DFT.CodigoEmpresa
	AND CLI.CodigoCliFor = DFT.CodigoCliFor

WHERE	DFT.TipoPedidoDocFT 		= 1 
AND	(DFT.DataProvavelFaturamentoDocFT <= ISNULL(@DataFaturamento, DFT.DataProvavelFaturamentoDocFT) OR DFT.DataProvavelFaturamentoDocFT IS NULL) 

AND	DOC.TipoLancamentoMovimentacao 	= 7 
AND	DOC.EntradaSaidaDocumento 	= 'S'
AND	DOC.CondicaoNFCancelada 	<> 'V'
AND	(DOC.NumeroFaturaDocumento IS NULL OR DOC.NumeroFaturaDocumento = 0) 

AND	DOC.CodigoEmpresa 		= @CodigoEmpresa
AND	DOC.CodigoLocal 		= @CodigoLocal  
AND	DOC.CodigoCliFor 		BETWEEN @CodigoCliForInicial    AND @CodigoCliForFinal    
AND	DOC.NumeroDocumento 		BETWEEN @NumeroDocumentoInicial AND @NumeroDocumentoFinal 

AND
	((PLN.EmiteDuplicataPlanoPagamento= 'V' AND
	PLN.CondicaoCDCIPlanoPagamento	= 'F' AND
	PLN.PercentualAVistaPlanoPagamento <> 100 AND
	PLN.VendaCartaoCredito		= 'F') OR DFT.CodigoPlanoPagamento IS NULL)

AND	(
	 (nop.CodigoTipoOperacao <> 20)
	 OR
	 (nop.CodigoTipoOperacao = 20 AND ValorICMSSubstTribDocto != 0)
	)

AND    DOC.DataEmissaoDocumento >= ISNULL(@DataProcessamento, DOC.DataEmissaoDocumento)

IF @DataEmissaoDoctoFatura IS NULL
BEGIN
	SELECT	* 
	FROM	@MyGroupInvoices
	ORDER BY CodigoLocal,
		CodigoCliFor,
		DataProvavelFaturamentoDocFT,
		DataVencimentoDocFT,
		CodigoPlanoPagamento,
		CASE @RegraEmissaoFatura
			when 1 then CentroCusto
			when 3 then CentroCusto
		END
END
ELSE
BEGIN
	SELECT	* 
	FROM	@MyGroupInvoices
	WHERE	DataDocumento <= @DataEmissaoDoctoFatura
	ORDER BY CodigoLocal,
		CodigoCliFor,
		DataProvavelFaturamentoDocFT,
		DataVencimentoDocFT,
		CodigoPlanoPagamento,
		CASE @RegraEmissaoFatura
			when 1 then CentroCusto
			when 3 then CentroCusto
		END
END


SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whLDocumentoAgruparNFFatura TO SQLUsers
GO

go

if exists (select * from sysobjects where id = object_id('whLEncerramentoMesEstoque') and sysstat & 0xf = 4)
DROP PROCEDURE dbo.whLEncerramentoMesEstoque
GO

CREATE PROC dbo.whLEncerramentoMesEstoque 

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: CDC - Consulters/Humaita
 PROJETO......: Controle de Estoque
 AUTOR........: Marcelo Bueno
 DATA.........: 25/11/1998
 UTILIZADO EM : clsProduto.EncerrarMesEstoque
 OBJETIVO.....: Listar os documentos em aberto, módulo e empresa / local
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa		dtInteiro04,
@Periodo		Char(6)

WITH ENCRYPTION
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


-- Verificar se existem Notas Digitadas, cujo atributo DataNota pertenca ao Periodo que esta sendo encerrado	
SELECT	CodigoEmpresa, CodigoLocal, DocumentoNotaDigitada, DataNotaDigitada, 'CE' Modulo
FROM 	tbNotaDigitada nd
WHERE 	SubString(Convert(Varchar(20), nd.DataNotaDigitada, 112), 1, 6) = @Periodo AND
	nd.CodigoEmpresa = @CodigoEmpresa AND
	EstoqueAtualizadoNotaDigitada = 'F'


UNION
	

-- Verificar se existem Requisicoes de Saida, cuja Data pertenca ao periodo que 
-- esta sendo encerrado
SELECT 	CodigoEmpresa, CodigoLocal, DocumentoRequisicaoSaida, DataEmissaoRequisicaoSaida, 'CE' Modulo
FROM 	tbRequisicaoSaida
WHERE 	CodigoEmpresa = @CodigoEmpresa	AND
	SubString(Convert(Varchar(20),DataEmissaoRequisicaoSaida, 112), 1, 6) = @Periodo 

UNION
-- Verificar se existem pedidos com DataPedidoPed dentro do periodo de encerramento
-- e com o StatusPedidoPed <> 5 (N-o Processar)
SELECT 	tbPedido.CodigoEmpresa, tbPedido.CodigoLocal ,NumeroPedido, DataPedidoPed, 'FT'	Modulo		
FROM	tbPedido
WHERE   CodigoEmpresa = @CodigoEmpresa AND
	SubString(Convert(Varchar(20),DataEmissaoNotaFiscalPed, 112), 1, 6) = @Periodo AND
	StatusPedidoPed <> 5 AND  
	StatusPedidoPed <> 2 AND
	StatusPedidoPed <> 1

UNION

SELECT 	tbPedido.CodigoEmpresa, tbPedido.CodigoLocal, tbPedido.NumeroPedido, tbPedido.DataPedidoPed, 'FT' Modulo
FROM 	tbNaturezaOperacao
	INNER JOIN tbPedido ON
		tbPedido.CodigoEmpresa = tbNaturezaOperacao.CodigoEmpresa
		AND tbPedido.CodigoNaturezaOperacao = tbNaturezaOperacao.CodigoNaturezaOperacao 
WHERE   tbPedido.CodigoEmpresa = @CodigoEmpresa AND
	SubString(Convert(Varchar(20),tbPedido.DataEmissaoNotaFiscalPed, 112), 1, 6) = @Periodo AND
	tbPedido.StatusPedidoPed <> 5 AND  
	tbPedido.StatusPedidoPed <> 2 AND
	tbPedido.StatusPedidoPed <> 1 AND
	tbPedido.AtualizadoEstoquePed = 'F' AND	
      	tbNaturezaOperacao.AtualizaEstoqueNaturezaOper = 'V' 


UNION

SELECT 	CodigoEmpresa, CodigoLocal, NumeroPedidoDocumento, DataDocumento, 'FT' Modulo
FROM 	NFDocumento
WHERE   CodigoEmpresa	= @CodigoEmpresa
AND	SubString(Convert(Varchar(20),DataDocumento, 112), 1, 6) = @Periodo
AND	NumeroDocumento	!= NumeroPedidoDocumento

SET NOCOUNT OFF

GO
GRANT  EXECUTE  ON dbo.whLEncerramentoMesEstoque  TO SQLUsers
GO

go

if exists(select 1 from sysobjects where id = object_id('dbo.whLFNFEletronicaSP'))
DROP PROCEDURE dbo.whLFNFEletronicaSP
GO
CREATE PROCEDURE dbo.whLFNFEletronicaSP

/*INICIO_CABEC_PROC
----------------------------------------------------------------------------------------------- 
 EMPRESA......: T-Systems do Brasil Ltda
 PROJETO......: 
 AUTOR........: Alex Kmez
 DATA.........: 03/12/2007
 OBJETIVO.....: Nota Fiscal Eletronica Estadual - SP

 whLFNFEletronicaSP 1608, 0, '2008-01-01', '2008-01-31',1,999999
----------------------------------------------------------------------------------------------- 
FIM_CABEC_PROC*/ 

@CodigoEmpresa 			dtInteiro04, 
@CodigoLocal 			dtInteiro04, 
@DataInicial			datetime,
@DataFinal			datetime,
@DeDocumento			dtInteiro06 = 0,
@AteDocumento			dtInteiro06 = 999999

with encryption
as 

set nocount on

create table #tmp (TipoRegistro 	char(2), 
		   NumeroDocumento      numeric(6),
		   DataDocumento        datetime,
		   Linha 		varchar(2000) COLLATE SQL_Latin1_General_Cp1253_CI_AI)

create table #tmp2 (TipoRegistro 	char(2), 
		    NumeroDocumento      numeric(6),
		    DataDocumento        datetime,
		    Linha 		varchar(2000))
------------ Registro Tipo 10 -----------------------------------------------------------------------------------------
insert #tmp
select 
	'10',
	0,
	getdate(),
	'10'
+ '|' +	'1,00'
+ '|' +	coalesce(convert(varchar(14),tbLocal.CGCLocal),'')
+ '|' +	(select 
		coalesce(substring(convert(char(3),100 + datepart(day,min(tbDocumento.DataDocumento))),2,2) + '/' + 
		 substring(convert(char(3),100 + datepart(month,min(tbDocumento.DataDocumento))),2,2) + '/' +
		   	   convert(char(4),datepart(year,min(tbDocumento.DataDocumento))),'')

	 from tbDocumento
	 where 		
		tbDocumento.CodigoEmpresa = @CodigoEmpresa
	 and 	tbDocumento.CodigoLocal = @CodigoLocal
	 and 	tbDocumento.TipoLancamentoMovimentacao in (7,11)
	 and 	(tbDocumento.DataDocumento between @DataInicial and @DataFinal))
+ '|' +	(select 
		coalesce(substring(convert(char(3),100 + datepart(day,max(tbDocumento.DataDocumento))),2,2) + '/' + 
		 substring(convert(char(3),100 + datepart(month,max(tbDocumento.DataDocumento))),2,2) + '/' +
		   	   convert(char(4),datepart(year,max(tbDocumento.DataDocumento))),'')

	 from tbDocumento
	 where 
		tbDocumento.CodigoEmpresa = @CodigoEmpresa
	 and 	tbDocumento.CodigoLocal = @CodigoLocal
	 and 	tbDocumento.TipoLancamentoMovimentacao = 7
	 and 	tbDocumento.CondicaoNFCancelada = 'F'
	 and 	(tbDocumento.DataDocumento between @DataInicial and @DataFinal))
	
from tbLocal (nolock)

where
	tbLocal.CodigoEmpresa = @CodigoEmpresa
and	tbLocal.CodigoLocal = @CodigoLocal
------------ Fim - Registro Tipo 10 -------------------------------------------------------------------------------------

------------ Registro Tipo 20 -----------------------------------------------------------------------------------------
insert #tmp
select 
	'20',
   	tbDocumento.NumeroDocumento,
	tbDocumento.DataDocumento,
	'20'
+ '|' +	case when (tbDocumento.CondicaoNFCancelada = 'V' or tbDocumento.TipoLancamentoMovimentacao = 11) then
		'C'
	else
		'I'
	end
+ '|' +	case when (tbDocumento.CondicaoNFCancelada = 'V' or tbDocumento.TipoLancamentoMovimentacao = 11) then
		coalesce(rtrim(convert(varchar(255),dtx.MotivoCancelamento)),'CANCELAMENTO NF')
	else
		''
	end
+ '|' +	coalesce(rtrim(convert(varchar(60),tbNaturezaOperacao.DescricaoNaturezaOperacao)),'')
+ '|' +	coalesce(rtrim(convert(varchar(3),tbDocumento.SerieDocumento)),'')
+ '|' +	coalesce(rtrim(convert(varchar(9),tbDocumento.NumeroDocumento)),'')
+ '|' +	coalesce(substring(convert(char(3),100 + datepart(day,tbDocumento.DataDocumento)),2,2) + '/' + 
	 	 substring(convert(char(3),100 + datepart(month,tbDocumento.DataDocumento)),2,2) + '/' +
		   	   convert(char(4),datepart(year,tbDocumento.DataDocumento)),'') + ' '
+	case when tbDocumento.DataHoraNSU is null then
		'00:00:00'
	else
		substring(convert(char(3),100 + datepart(hh,tbDocumento.DataHoraNSU)),2,2) + ':' + 
	 	substring(convert(char(3),100 + datepart(mi,tbDocumento.DataHoraNSU)),2,2) + ':' +
		substring(convert(char(3),100 + datepart(ss,tbDocumento.DataHoraNSU)),2,2)
	end
+ '|' +	coalesce(substring(convert(char(3),100 + datepart(day,tbDocumento.DataDocumento)),2,2) + '/' + 
	 	 substring(convert(char(3),100 + datepart(month,tbDocumento.DataDocumento)),2,2) + '/' +
		   	   convert(char(4),datepart(year,tbDocumento.DataDocumento)),'') + ' '
+	case when tbDocumento.DataHoraNSU is null then
		'00:00:00'
	else
		substring(convert(char(3),100 + datepart(hh,tbDocumento.DataHoraNSU)),2,2) + ':' + 
	 	substring(convert(char(3),100 + datepart(mi,tbDocumento.DataHoraNSU)),2,2) + ':' +
		substring(convert(char(3),100 + datepart(ss,tbDocumento.DataHoraNSU)),2,2)
	end
+ '|' +	case tbDocumento.EntradaSaidaDocumento when 'E' then
		'0'
	else
		'1'
	end
+ '|' +	coalesce(rtrim(convert(varchar(4),tbDocumento.CodigoCFO)),'')
+ '|' +	coalesce(rtrim(coalesce(replace(replace(replace(coalesce(convert(VARCHAR(15),
		(select tbPercentualFT.NumInscrEstadSubsTributario 
		 from 	tbPercentualFT
		 where	tbPercentualFT.UFDestino = coalesce(tbClienteEventual.UnidadeFederacao,tbCliFor.UFCliFor)
		 and	tbPercentualFT.UFOrigem = tbLocal.UFLocal)),''),'.',''),'-',''),'/',''),'')),'')
+ '|' +	case tbDocumento.EntradaSaidaDocumento when 'E' then
		coalesce(replace(replace(replace(coalesce(rtrim(convert(VARCHAR(15),tbLocal.InscricaoMunicipalLocal)),''),'.',''),'-',''),'/',''),'')
	else
		case tbCliFor.TipoCliFor when 'F' then	
			''
		else
			coalesce(replace(replace(replace(coalesce(rtrim(convert(VARCHAR(15),tbCliForJuridica.InscricaoMunicipalJuridica)),''),'.',''),'-',''),'/',''),'')
		end	
	end
+ '|' +	case when tbCliFor.TipoCliFor = 'F' or (tbClienteEventual.CPFCliEven) is not null then	
		case coalesce(tbClienteEventual.CPFCliEven,tbCliForFisica.CPFFisica) when 'ISENTO' then
			''
		else
			coalesce(rtrim(convert(varchar(14),tbClienteEventual.CPFCliEven)),rtrim(convert(varchar(14),tbCliForFisica.CPFFisica)))
		end
	else
		case coalesce(tbClienteEventual.CGCCliEven,tbCliForJuridica.CGCJuridica) when 'ISENTO' then
			''
		else
			coalesce(rtrim(convert(varchar(14),tbClienteEventual.CGCCliEven)),rtrim(convert(varchar(14),tbCliForJuridica.CGCJuridica)))
		end
	end	
+ '|' +	coalesce(rtrim(convert(varchar(60),tbClienteEventual.NomeCliEven)),rtrim(convert(varchar(60),tbCliFor.NomeCliFor)))
+ '|' +	coalesce(rtrim(convert(varchar(60),tbClienteEventual.EnderecoCliEven)),rtrim(convert(varchar(60),tbCliFor.RuaCliFor)))
+ '|' +	coalesce(rtrim(convert(varchar(60),tbCliFor.NumeroEndCliFor)),'')
+ '|' +	coalesce(rtrim(convert(varchar(60),tbCliFor.ComplementoEndCliFor)),'')
+ '|' +	coalesce(coalesce(rtrim(convert(varchar(60),tbClienteEventual.BairroCliEven)),rtrim(convert(varchar(60),tbCliFor.BairroCliFor))),'')
+ '|' +	case coalesce(tbClienteEventual.UnidadeFederacao, tbCliFor.UFCliFor) when 'EX' then	
		'EXTERIOR'
	else
		coalesce(rtrim(convert(varchar(60),tbClienteEventual.MunicipioCliEven)),rtrim(convert(varchar(60),tbCliFor.MunicipioCliFor)))
	end
+ '|' +	coalesce(rtrim(convert(varchar(2),tbClienteEventual.UnidadeFederacao)),rtrim(convert(varchar(2),tbCliFor.UFCliFor)))
+ '|' +	coalesce(rtrim(convert(varchar(8),tbClienteEventual.CEPCliEven)),rtrim(convert(varchar(8),tbCliFor.CEPCliFor)))
+ '|' +	coalesce(rtrim(convert(varchar(60),tbPais.DescrPais)),'')
+ '|' +	coalesce(replace(replace(replace(replace(coalesce(right(rtrim(convert(char(4),tbCliFor.DDDTelefoneCliFor)),2),''),'.',''),'-',''),'/',''),' ',''),'')
+	coalesce(replace(replace(replace(replace(coalesce(convert(char(8),tbCliFor.TelefoneCliFor),''),'.',''),'-',''),'/',''),' ',''),'')
+ '|'

from tbDocumento (nolock)

inner join tbDocumentoFT (nolock)
on	tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa
and	tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal
and	tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor
and	tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
and	tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento
and	tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento
and	tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao

LEFT join tbDocumentoTextos dtx (nolock)
on	dtx.CodigoEmpresa = tbDocumento.CodigoEmpresa
and	dtx.CodigoLocal = tbDocumento.CodigoLocal
and	dtx.CodigoCliFor = tbDocumento.CodigoCliFor
and	dtx.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
and	dtx.NumeroDocumento = tbDocumento.NumeroDocumento
and	dtx.DataDocumento = tbDocumento.DataDocumento
and	dtx.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao

left join tbClienteEventual (nolock)
ON	tbClienteEventual.CodigoEmpresa	= tbDocumentoFT.CodigoEmpresa 
AND     tbClienteEventual.CodigoClienteEventual = tbDocumentoFT.CodigoClienteEventual

inner join tbCFO (nolock) 
on	tbCFO.CodigoCFO = tbDocumento.CodigoCFO

inner join tbLocal (nolock)
on	tbLocal.CodigoEmpresa = tbDocumento.CodigoEmpresa
and	tbLocal.CodigoLocal = tbDocumento.CodigoLocal

inner join tbCliFor (nolock)
on	tbCliFor.CodigoEmpresa = tbDocumento.CodigoEmpresa
and	tbCliFor.CodigoCliFor = tbDocumento.CodigoCliFor

left join tbCliForFisica (nolock)
on	tbCliForFisica.CodigoEmpresa = tbDocumento.CodigoEmpresa
and	tbCliForFisica.CodigoCliFor = tbDocumento.CodigoCliFor

left join tbCliForJuridica (nolock)
on	tbCliForJuridica.CodigoEmpresa = tbDocumento.CodigoEmpresa
and	tbCliForJuridica.CodigoCliFor = tbDocumento.CodigoCliFor

inner join tbNaturezaOperacao (nolock)
on	tbNaturezaOperacao.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa
and	tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao

left join tbPais (nolock)
on 	tbPais.IdPais = tbCliFor.IdPais

where 
	tbDocumento.CodigoEmpresa = @CodigoEmpresa
and 	tbDocumento.CodigoLocal = @CodigoLocal
and 	tbDocumento.TipoLancamentoMovimentacao = 7
and 	tbDocumento.CondicaoNFCancelada = 'F'
and 	(tbDocumento.DataDocumento between @DataInicial and @DataFinal)
and	tbDocumentoFT.TipoTratamentoNFDigitadaDocFT = 'P'
and tbDocumento.NumeroDocumento between @DeDocumento and @AteDocumento

------------ Fim - Registro Tipo 20 -------------------------------------------------------------------------------------

------------ Registro Tipo 30 -----------------------------------------------------------------------------------------
insert #tmp
select 
	'30',
   	tbItemDocumento.NumeroDocumento,
	tbItemDocumento.DataDocumento,
	'30'
+ '|' +	case 
	when tbItemDocumento.CodigoProduto is not null THEN
		coalesce(rtrim(convert(varchar(60),tbItemDocumento.CodigoProduto)),'')
	when tbItemDocumento.CodigoMaoObraOS is not null THEN
		coalesce(rtrim(convert(varchar(60),tbItemDocumento.CodigoMaoObraOS)),'')
	when tbVeiculoCV.NumeroChassisCV is not null THEN 
		coalesce(rtrim(convert(varchar(60),tbVeiculoCV.NumeroChassisCV)),'')
	when tbItemDocumento.CodigoItemDocto is not null THEN
		coalesce(rtrim(convert(varchar(60),tbItemDocumento.CodigoItemDocto)),'')
	else
		'USOCONSUMO'
	end
+ '|' +	coalesce(rtrim(convert(varchar(120),
	rtrim(CASE 
		WHEN tbItemDocumento.CodigoProduto IS NOT NULL THEN
			tbProduto.DescricaoProduto
		WHEN tbItemDocumento.CodigoMaoObraOS IS NOT NULL THEN
			convert(char(5),tbItemDocumento.CodigoMaoObraOS)
		WHEN tbVeiculoCV.NumeroChassisCV is not null THEN
			RTRIM(NumeroChassisCV) + ' ' + RTRIM(tbVeiculoCV.ModeloVeiculo)
		WHEN tbItemDocumento.CodigoItemDocto IS NOT NULL THEN
			tbItemDocumento.CodigoItemDocto
		ELSE
			'USOCONSUMO'
		END)
	+ ' CFOP : ' + convert(char(5),tbItemDocumento.CodigoCFO))),'')
+ '|' +	CASE coalesce(convert(varchar(10),tbItemDocumento.CodigoClassificacaoFiscal),'') WHEN '1' THEN
		''
	else
		coalesce(rtrim(substring(convert(varchar(10),tbItemDocumento.CodigoClassificacaoFiscal),1,8)),'')		
	end	
+ '|' +	CASE WHEN tbItemDocumento.CodigoProduto IS NOT null THEN
		coalesce(rtrim(convert(varchar(6),tbProdutoFT.CodigoUnidadeProduto)),'')
             WHEN tbItemDocumento.CodigoMaoObraOS IS NOT null THEN
                'HR'
             ELSE
                'UN'
             END
+ '|' +	coalesce(replace(rtrim(convert(varchar(17),convert(numeric(16,4),tbItemDocumento.QtdeLancamentoItemDocto))),'.',','),'0,0000')
+ '|' +	case coalesce(tbItemDocumento.QtdeLancamentoItemDocto,0) when 0 then
		'0,0000'
	else
		coalesce(replace(rtrim(convert(varchar(21),convert(numeric(18,4),( ( tbItemDocumento.ValorContabilItemDocto + CASE WHEN tbCliFor.CondicaoRetencaoISS = 'V' THEN tbItemDocumento.ValorISSItemDocto ELSE 0 END - tbItemDocumento.ValorICMSSubstTribItemDocto + tbItemDocumentoFT.ValorIRRFItDocFT ) / tbItemDocumento.QtdeLancamentoItemDocto)))),'.',','),'0,0000')
	end
+ '|' +	coalesce(replace(rtrim(convert(varchar(18),( tbItemDocumento.ValorContabilItemDocto + CASE WHEN tbCliFor.CondicaoRetencaoISS = 'V' THEN tbItemDocumento.ValorISSItemDocto ELSE 0 END - tbItemDocumento.ValorICMSSubstTribItemDocto + tbItemDocumentoFT.ValorIRRFItDocFT ))),'.',','),'0,00')

+ '|' +	case coalesce(tbProdutoFT.CodigoTributacaoProduto,'') when '' then
		'040'
	else
		right('0' + ltrim(rtrim(convert(varchar(3),tbProdutoFT.CodigoTributacaoProduto))),3)
	end
+ '|' +	coalesce(replace(rtrim(convert(varchar(7),tbItemDocumento.PercentualICMSItemDocto)),'.',','),'0,00')
+ '|' +	coalesce(replace(rtrim(convert(varchar(7),0.00)),'.',','),'0,00')
+ '|' +	coalesce(replace(rtrim(convert(varchar(17),0.00)),'.',','),'0,00')

from tbItemDocumento (nolock)

inner join tbCliFor (nolock)
on tbCliFor.CodigoEmpresa = @CodigoEmpresa AND
   tbCliFor.CodigoCliFor = tbItemDocumento.CodigoCliFor

inner join tbDocumento (nolock)
on	tbDocumento.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
and	tbDocumento.CodigoLocal = tbItemDocumento.CodigoLocal
and	tbDocumento.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento
and	tbDocumento.NumeroDocumento = tbItemDocumento.NumeroDocumento
and	tbDocumento.DataDocumento = tbItemDocumento.DataDocumento
and	tbDocumento.CodigoCliFor = tbItemDocumento.CodigoCliFor
and	tbDocumento.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao

inner join tbDocumentoFT (nolock)
on	tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa
and	tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal
and	tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor
and	tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
and	tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento
and	tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento
and	tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao

inner join tbItemDocumentoFT (nolock)
on	tbItemDocumentoFT.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
and	tbItemDocumentoFT.CodigoLocal = tbItemDocumento.CodigoLocal
and	tbItemDocumentoFT.CodigoCliFor = tbItemDocumento.CodigoCliFor
and	tbItemDocumentoFT.EntradaSaidaDocumento = tbItemDocumento.EntradaSaidaDocumento
and	tbItemDocumentoFT.NumeroDocumento = tbItemDocumento.NumeroDocumento
and	tbItemDocumentoFT.DataDocumento = tbItemDocumento.DataDocumento
and	tbItemDocumentoFT.TipoLancamentoMovimentacao = tbItemDocumento.TipoLancamentoMovimentacao
and tbItemDocumentoFT.SequenciaItemDocumento = tbItemDocumento.SequenciaItemDocumento


left join tbProduto (nolock)
on 	tbProduto.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
and	tbProduto.CodigoProduto = tbItemDocumento.CodigoProduto

left join tbProdutoFT (nolock)
on 	tbProdutoFT.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
and	tbProdutoFT.CodigoProduto = tbItemDocumento.CodigoProduto

left join tbVeiculoCV (nolock)
on	tbVeiculoCV.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
and	tbVeiculoCV.CodigoLocal = tbItemDocumento.CodigoLocal
and	tbVeiculoCV.NumeroVeiculoCV = tbItemDocumento.NumeroVeiculoCV

where 
	tbItemDocumento.CodigoEmpresa = @CodigoEmpresa
and 	tbItemDocumento.CodigoLocal = @CodigoLocal
and 	tbItemDocumento.TipoLancamentoMovimentacao = 7
and 	tbDocumento.CondicaoNFCancelada = 'F'
and 	(tbItemDocumento.DataDocumento between @DataInicial and @DataFinal)
and	tbDocumentoFT.TipoTratamentoNFDigitadaDocFT = 'P'
and tbItemDocumento.NumeroDocumento between @DeDocumento and @AteDocumento
------------ Fim - Registro Tipo 30 -------------------------------------------------------------------------------------

------------ Registro Tipo 40 -----------------------------------------------------------------------------------------
insert #tmp
select 
	'40',
   	tbDocumento.NumeroDocumento,
	tbDocumento.DataDocumento,
	'40'
+ '|' +	coalesce(replace(rtrim(convert(varchar(17),tbDocumento.ValorBaseICMS1Documento)),'.',','),'0,00')
+ '|' +	coalesce(replace(rtrim(convert(varchar(17),tbDocumento.ValorICMSDocumento)),'.',','),'0,00')
+ '|' +	coalesce(replace(rtrim(convert(varchar(17),tbDocumento.ValorBaseICMSSubstTribDocto)),'.',','),'0,00')
+ '|' +	coalesce(replace(rtrim(convert(varchar(17),tbDocumento.ValorICMSSubstTribDocto)),'.',','),'0,00')
+
CASE WHEN tbDocumentoFT.OrigemDocumentoFT = 'OS' AND tbDocumentoFT.ValorCSLLDocFT <> 0 THEN
	'|' +	coalesce(replace(rtrim(convert(varchar(17),(tbDocumento.ValorContabilDocumento + tbDocumentoFT.ValorIRRFDocFT ))),'.',','),'')
ELSE
	'|' +	coalesce(replace(rtrim(convert(varchar(17),(tbDocumento.ValorBaseICMS1Documento + tbDocumento.ValorBaseICMS2Documento + tbDocumento.ValorBaseICMS3Documento + tbDocumentoFT.ValorIRRFDocFT ))),'.',','),'')
END
+ '|' +	'0,00'
+ '|' +	'0,00'
+ '|' +	'0,00'
+ '|' +	'0,00'
+ '|' +	'0,00'
+
CASE WHEN tbDocumentoFT.OrigemDocumentoFT = 'OS' AND tbDocumentoFT.ValorCSLLDocFT <> 0 THEN
	'|' +	coalesce(replace(rtrim(convert(varchar(17),(tbDocumento.ValorContabilDocumento + tbDocumentoFT.ValorIRRFDocFT ))),'.',','),'')
ELSE
	'|' +	coalesce(replace(rtrim(convert(varchar(17),(tbDocumento.ValorBaseICMS1Documento + tbDocumento.ValorBaseICMS2Documento + tbDocumento.ValorBaseICMS3Documento + tbDocumentoFT.ValorIRRFDocFT ))),'.',','),'')
END
+ '|' +	coalesce(replace(rtrim(convert(varchar(17),tbDocumento.ValorBaseISSDocumento)),'.',','),'0,00')
+ '|' +	case when coalesce(tbDocumento.ValorBaseISSDocumento,0) <> 0 then
		case when coalesce(tbNaturezaOperacao.PercentualISSNaturezaOperacao,0) <> 0 then
			coalesce(replace(rtrim(convert(varchar(5),tbNaturezaOperacao.PercentualISSNaturezaOperacao)),'.',','),'0,00')
	       	else
			coalesce(replace(rtrim(convert(varchar(5),tbLocal.PercentualISSLocal)),'.',','),'0,00')
		end
	else
		'0,00'
	end
+ '|' +	coalesce(replace(rtrim(convert(varchar(17),tbDocumento.ValorISSDocumento)),'.',','),'0,00')

from tbDocumento (nolock)

inner join tbDocumentoFT (nolock)
on	tbDocumentoFT.CodigoEmpresa = tbDocumento.CodigoEmpresa
and	tbDocumentoFT.CodigoLocal = tbDocumento.CodigoLocal
and	tbDocumentoFT.CodigoCliFor = tbDocumento.CodigoCliFor
and	tbDocumentoFT.EntradaSaidaDocumento = tbDocumento.EntradaSaidaDocumento
and	tbDocumentoFT.NumeroDocumento = tbDocumento.NumeroDocumento
and	tbDocumentoFT.DataDocumento = tbDocumento.DataDocumento
and	tbDocumentoFT.TipoLancamentoMovimentacao = tbDocumento.TipoLancamentoMovimentacao

inner join tbNaturezaOperacao (nolock)
on	tbNaturezaOperacao.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa
and	tbNaturezaOperacao.CodigoNaturezaOperacao = tbDocumentoFT.CodigoNaturezaOperacao

inner join tbLocal (nolock)
on	tbLocal.CodigoEmpresa = tbDocumento.CodigoEmpresa
and	tbLocal.CodigoLocal = tbDocumento.CodigoLocal

where 
	tbDocumento.CodigoEmpresa = @CodigoEmpresa
and 	tbDocumento.CodigoLocal = @CodigoLocal
and 	tbDocumento.TipoLancamentoMovimentacao = 7
and 	tbDocumento.CondicaoNFCancelada = 'F'
and 	(tbDocumento.DataDocumento between @DataInicial and @DataFinal)
and	tbDocumentoFT.TipoTratamentoNFDigitadaDocFT = 'P'
and tbDocumento.NumeroDocumento between @DeDocumento and @AteDocumento
------------ Fim - Registro Tipo 40 -------------------------------------------------------------------------------------


------------ Registro Tipo 50 -----------------------------------------------------------------------------------------
insert #tmp
select 
	'50',
   	tbDocumentoFT.NumeroDocumento,
	tbDocumentoFT.DataDocumento,
	'50'
+ '|' +	case when coalesce(tbDocumentoFT.TipoFreteDocFT,0) <> 0 then
		case 
		when tbDocumentoFT.TipoFreteDocFT = 1 then
			'0'
		when tbDocumentoFT.TipoFreteDocFT = 2 then
			'1'
		end
	else
		''
	end
+ '|' +	case when tbCliFor.TipoCliFor = 'F' then	
		coalesce(rtrim(convert(varchar(14),tbCliForFisica.CPFFisica)),'')
	else
		coalesce(rtrim(convert(varchar(14),tbCliForJuridica.CGCJuridica)),'')
	end	
+ '|' +	coalesce(rtrim(convert(varchar(60),tbCliFor.NomeCliFor)),'')
+ '|' +	case when tbCliFor.TipoCliFor = 'F' then	
		coalesce(replace(replace(replace(coalesce(rtrim(convert(VARCHAR(14),tbCliForFisica.RGFisica)),''),'.',''),'-',''),'/',''),'')	
	else
		coalesce(replace(replace(replace(coalesce(rtrim(convert(VARCHAR(14),tbCliForJuridica.InscricaoEstadualJuridica)),''),'.',''),'-',''),'/',''),'')	
	end	
+ '|' +	case ltrim(rtrim(convert(varchar(60),coalesce(rtrim(convert(varchar(60),tbCliFor.RuaCliFor)),'') + ',' + 
			    coalesce(rtrim(convert(varchar(60),tbCliFor.NumeroEndCliFor)),'')+ ' ' + 
			    coalesce(rtrim(convert(varchar(60),tbCliFor.ComplementoEndCliFor)),'') + ' ' + 
			    coalesce(rtrim(convert(varchar(60),tbCliFor.BairroCliFor)),'')))) when ',' then
		''
	else
		convert(varchar(60),coalesce(rtrim(convert(varchar(60),tbCliFor.RuaCliFor)),'') + ',' + 
			    coalesce(rtrim(convert(varchar(60),tbCliFor.NumeroEndCliFor)),'')+ ' ' + 
			    coalesce(rtrim(convert(varchar(60),tbCliFor.ComplementoEndCliFor)),'') + ' ' + 
			    coalesce(rtrim(convert(varchar(60),tbCliFor.BairroCliFor)),''))
	end
+ '|' +	case coalesce(tbCliFor.UFCliFor,'') when 'EX' then	
		'EXTERIOR'
	else
		coalesce(rtrim(convert(varchar(60),tbCliFor.MunicipioCliFor)),'')
	end
+ '|' +	coalesce(rtrim(convert(varchar(2),tbCliFor.UFCliFor)),'')
+ '|' +	''
+ '|' +	''
+ '|' +	case coalesce(rtrim(convert(varchar(15),(tbDocumentoFT.QtdeVolume01DocFT + tbDocumentoFT.QtdeVolume02DocFT + tbDocumentoFT.QtdeVolume03DocFT + tbDocumentoFT.QtdeVolume04DocFT + tbDocumentoFT.QtdeVolume05DocFT))),'0') when '0' then
		'000000000000000'
	else
		coalesce(rtrim(substring(convert(varchar(16),1000000000000000 + (tbDocumentoFT.QtdeVolume01DocFT + tbDocumentoFT.QtdeVolume02DocFT + tbDocumentoFT.QtdeVolume03DocFT + tbDocumentoFT.QtdeVolume04DocFT + tbDocumentoFT.QtdeVolume05DocFT)),2,15)),'000000000000000')
	end
+ '|' +	''
+ '|' +	''
+ '|' +	''
+ '|' +	coalesce(replace(rtrim(convert(varchar(19),convert(numeric(16,3),tbDocumentoFT.PesoLiquidoPedidoDocFT))),'.',','),'0,000')
+ '|' +	coalesce(replace(rtrim(convert(varchar(19),convert(numeric(16,3),tbDocumentoFT.PesoBrutoPedidoDocFT))),'.',','),'0,000')

from tbDocumentoFT (nolock)

inner join tbDocumento (nolock)
on	tbDocumento.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa
and	tbDocumento.CodigoLocal = tbDocumentoFT.CodigoLocal
and	tbDocumento.EntradaSaidaDocumento = tbDocumentoFT.EntradaSaidaDocumento
and	tbDocumento.NumeroDocumento = tbDocumentoFT.NumeroDocumento
and	tbDocumento.DataDocumento = tbDocumentoFT.DataDocumento
and	tbDocumento.CodigoCliFor = tbDocumentoFT.CodigoCliFor
and	tbDocumento.TipoLancamentoMovimentacao = tbDocumentoFT.TipoLancamentoMovimentacao

left join tbCliFor (nolock)
on	tbCliFor.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa
and	tbCliFor.CodigoCliFor = tbDocumentoFT.TranspCodigoCliFor

left join tbCliForFisica (nolock)
on	tbCliForFisica.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa
and	tbCliForFisica.CodigoCliFor = tbDocumentoFT.TranspCodigoCliFor

left join tbCliForJuridica (nolock)
on	tbCliForJuridica.CodigoEmpresa = tbDocumentoFT.CodigoEmpresa
and	tbCliForJuridica.CodigoCliFor = tbDocumentoFT.TranspCodigoCliFor

where 
	tbDocumentoFT.CodigoEmpresa = @CodigoEmpresa
and 	tbDocumentoFT.CodigoLocal = @CodigoLocal
and 	tbDocumentoFT.TipoLancamentoMovimentacao = 7
and 	tbDocumento.CondicaoNFCancelada = 'F'
and 	(tbDocumentoFT.DataDocumento between @DataInicial and @DataFinal)
and		tbDocumentoFT.NumeroDocumento BETWEEN @DeDocumento AND @AteDocumento 
and		tbDocumentoFT.TipoTratamentoNFDigitadaDocFT = 'P'
------------ Fim - Registro Tipo 50 -------------------------------------------------------------------------------------

/*
------------ Registro Tipo 60 -----------------------------------------------------------------------------------------
insert #tmp
select 
	'60',
	'60'
+ '|' +	''
+ '|' +	''
------------ Fim - Registro Tipo 60 -------------------------------------------------------------------------------------
*/

------------ Registro Tipo 90 -----------------------------------------------------------------------------------------
insert #tmp
select 
	'90',
	999999,
	getdate(),
	'90'
+ '|' +	substring(convert(varchar(6),'100000' + (select count(*) from #tmp where TipoRegistro = '20')),2,5)
+ '|' +	substring(convert(varchar(6),'100000' + (select count(*) from #tmp where TipoRegistro = '30')),2,5)
+ '|' +	substring(convert(varchar(6),'100000' + (select count(*) from #tmp where TipoRegistro = '40')),2,5)
+ '|' +	substring(convert(varchar(6),'100000' + (select count(*) from #tmp where TipoRegistro = '50')),2,5)
+ '|' +	substring(convert(varchar(6),'100000' + (select count(*) from #tmp where TipoRegistro = '60')),2,5)
------------ Fim - Registro Tipo 90 -------------------------------------------------------------------------------------

insert #tmp2
select * from #tmp

select 
		Linha 
from #tmp2
Order by 
	#tmp2.NumeroDocumento,
	#tmp2.DataDocumento,
	#tmp2.TipoRegistro

drop table #tmp
drop table #tmp2

set nocount off
go
grant execute on dbo.whLFNFEletronicaSP to SQLUsers
go

go

if exists(select 1 from sysobjects where id = object_id('dbo.whLItemPedido'))
DROP PROCEDURE dbo.whLItemPedido
GO

CREATE PROCEDURE dbo.whLItemPedido
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda
 PROJETO......: FT - Faturamento
 AUTOR........: Marcio Simoes
 DATA.........: 30/03/1999
 UTILIZADO EM : clsPedido
 OBJETIVO.....: Listar o item de um Pedido e mais atributos utilizados no calculo do pedido.

 ALTERACAO....: Carlos JSC - 24/09/2002
 OBJETIVO.....: Calculo Imposto Debitado ECF

 ALTERACAO....: Marcio Schvartz - 05/11/2002
 OBJETIVO.....: Adicionado o retorno dos campos TributaPISProduto TributaCOFINSProduto da
                tabela tbProdutoFT

 ALTERACAO....: Edvaldo Ragassi - 17/04/2003
 OBJETIVO.....: Eliminacao da tbProdutoCE.

EXECUTE whLItemPedido @CodigoEmpresa = 1470,@CodigoLocal = 0,@CentroCusto = 21210,@NumeroPedido = 813,@SequenciaPedido = 0
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa		numeric(4) 	= Null,
@CodigoLocal		numeric(4) 	= Null,
@CentroCusto		numeric(8) 	= Null,
@NumeroPedido		numeric(6) 	= Null,
@SequenciaPedido	numeric(2) 	= Null,
@CodigoProduto		char(30)	= Null


WITH ENCRYPTION
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT	IP.CodigoEmpresa, IP.CodigoLocal, IP.CentroCusto, 
		IP.NumeroPedido, IP.SequenciaPedido, IP.ItemPedido,
		IP.CodigoItemPed, IP.TipoRegistroItemPed, IP.TipoMaoObraItemPed,
		IP.TextoItemPedido, IP.CodigoTributacao, IP.ItemNotaFiscalOriginalItemPed,
		IP.AtualizaPrecoReposicaoItemPed, IP.QuantidadeItemPed, IP.PercDescontoItemPed,
		IP.PrecoUnitarioItemPed, IP.PrecoBrutoItemPed, IP.ValorDescontoItemPed,
		IP.PrecoLiquidoUnitarioItemPed, IP.PrecoTotalItemPed, 	IP.PesoBrutoItemPed,
		IP.PesoLiquidoItemPed,
		IP.TextoNotaFiscal01ItemPed, 
		IP.TextoNotaFiscal02ItemPed, 
		IP.QtdeDevolucaoVendaItemPed, 
		IP.QtdeDevolucaoCompraItemPed, 
		ValorCustoMovimentoItemPed = CAST(ISNULL(dbo.fnApurarCustoUnitario(IP.CodigoEmpresa, IP.CodigoLocal, IP.CentroCusto, IP.NumeroPedido, IP.SequenciaPedido, IP.ItemPedido),0) AS MONEY),
		IP.CondicaoIPIItemPed, 
		IP.CondicaoICMSItemPed, 
		IP.BaseIRRFItemPed, 
		IP.ValorIRRFItemPed, 
		IP.ValorICMSRetidoFonteItemPed, 
		IP.PercICMSSubsTributariaItemPed, 
		IP.BaseICMSSubsTributariaItemPed, 
		IP.ValorICMSSubsTributariaItemPed, 
		IP.PercICMSItemPed, 
		IP.BaseICMS1ItemPed, 
		IP.BaseICMS2ItemPed, 
		IP.BaseICMS3ItemPed, 
		IP.ValorICMSItemPed, 
		IP.PercIPIItemPed, 
		IP.BaseIPI1ItemPed, 
		IP.BaseIPI2ItemPed, 
		IP.ValorIPIItemPed, 
		IP.PercISSItemPed, 
		IP.ValorBaseISSItemPed, 
		IP.ValorISSItemPed,
		IP.PercCofinsItemPed, 
		IP.BaseCOFINSItemPed, 
		IP.ValorCOFINSItemPed,
		IP.PercPISItemPed, 
		IP.BasePISItemPed, 
		IP.ValorPISItemPed,
		IP.PercCofinsSTItemPed,
		IP.BaseCofinsSTItemPed, 
		IP.ValorCofinsSTItemPed,
		IP.PercPISSTItemPed,
		IP.BasePISSTItemPed, 
		IP.ValorPISSTItemPed, 
		IP.ImpostoImportacaoItemPed, 
		IP.RateioFreteItemPed, 
		IP.RateioSeguroItemPed, 
		IP.RateioEncargoFinanItemPed, 
		IP.RateioDescontoItemPed, 
		IP.BaseICMSSTUltEntradaItemPed, 
		IP.ValorICMSSTUltEntradaItemPed, 
		IP.ValorReembolsoSTItemPed, 
		IP.UnidadeItemPed, 
		IP.UnidadeValorizacaoItemPed, 
		IP.BaseIPI3ItemPed, 
		IP.MercadoPecasItemPed, 
		IP.DataSeparacaoExpedicao, 
		IP.QtdeSeparadaExpedicao, 
		IP.ItemCargaEPC, 
		IP.FlagArmazenadoDevolucao, 
		IP.ValorDescInvisivelItemPed, 
		IP.PrecoUnitarioOriginalItemPed, 
		IP.CodigoAlmoxarifadoOrigem, 
		IP.ChassiVeiculoOS, 
		IP.CodigoMaoObraOS, 
		IP.CodigoAlmoxarifadoDestino, 
		IP.CodigoProduto, 
		IP.CodigoNaturezaOperacao, 
		IP.CentroCustoMaoObra, 
		IP.RateioDespAcessoriasItemPed, 
		IP.ProdVendPromocaoItemPed, 
		IP.DataLimitePromocaoItemPed, 
		IP.RateioSegSocialItemPed, 
		IP.OrdemSeparacaoImpressa, IP.ValorICMSDiferidoItemPed,
		IP.CodigoProdutoReclassificacao, IP.QuantidadeReclassificacao,
		PD.DescricaoProduto,
		CASE	WHEN IP.CodigoClassificacaoFiscal IS NOT NULL
				THEN CONVERT(CHAR(10),IP.CodigoClassificacaoFiscal)
			WHEN IP.TipoRegistroItemPed = 'VEC'
				THEN (SELECT MCV.CodigoClassificacaoFiscal FROM tbPedidoCV PCV
					INNER JOIN tbVeiculoCV VCV
					ON	VCV.CodigoEmpresa	= PCV.CodigoEmpresa
					AND	VCV.CodigoLocal		= PCV.CodigoLocal
					AND	VCV.NumeroVeiculoCV	= PCV.NumeroVeiculoCV
					INNER JOIN tbModeloVeiculoCV MCV
					ON	MCV.CodigoEmpresa	= VCV.CodigoEmpresa
					AND	MCV.ModeloVeiculo	= VCV.ModeloVeiculo
					WHERE	PCV.CodigoEmpresa	= IP.CodigoEmpresa
					AND	PCV.CodigoLocal		= IP.CodigoLocal
					AND	PCV.CentroCusto		= IP.CentroCusto
					AND	PCV.NumeroPedido	= IP.NumeroPedido
					AND	PCV.SequenciaPedido	= IP.SequenciaPedido)
			ELSE PD.CodigoClassificacaoFiscal
		END CodigoClassificacaoFiscal,
		PD.CodigoEditadoProduto, 
		PL.VendaBloqueada, PL.SugestaoBloqueada, PL.DataUltimaVenda, 
		PL.DataUltimaMovimentacao, PL.FrequenciaVenda, PL.DiasTempoReposicao, 
		PL.DiasRitmoAquisicao, PL.DiasEstoqueMinimo, PL.ConsumoMedioInformado, 
		PL.DataLimiteConsMedioInformado, PL.ConsumoMedioCalculado,
		PL.ConsumoMedioAnoAnterior, PL.PontoPedidoCalculado, 
		PL.QuantidadeInventarios, PL.PromocaoProduto, PL.QuantidadeLimitePromocao, 
		PL.SaldoItemPromocao, PL.DataLimitePromocao, PL.QuantidadeEstoqueMinimo, 
		PL.QuantidadeEstoqueMaximo, PL.ClassifABCValorVenda, 
		PL.ClassifABCValorEstoque, PL.ClassifABCValorCompras, 
		PL.ClassifABCValorReposicao, PL.DataApurABCValorVenda, 
		PL.DataApurABCValorEstoque, PL.DataApurABCValorCompras, 
		PL.DataApurABCValorReposicao, PL.ClassifABCQuantidadeVenda, 
		PL.ClassifABCQuantidadeEstoque, PL.ClassifABCQuantidadeCompras, 
		PL.ClassifABCFrequenciaVenda, PL.DataApurABCQuantidadeVenda, 
		PL.DataApurABCQuantidadeEstoque, PL.DataApurABCQuantidadeCompras, 
		PL.DataApurABCFrequenciaVenda, PL.DataUltimoInventario, 
		PL.DataUltimaVendaPerdida, PL.QuantidadeObjetivoVenda, 
		PL.DataUltimaCompra, PL.DataUltimoReajustePreco, 
		PL.DataInicioPromocao, PL.ClassificacaoPreco123,
		PFT.CodigoFormatadoProduto, PFT.CodigoBarrasProduto, 
		PFT.EmbalagemComercialProduto, PFT.MarcaProduto, PFT.DataCadastroProduto, 
		PFT.PrecoReposicaoIndiceProduto, PFT.PesoLiquidoProduto, 
		PFT.PesoBrutoProduto, PFT.CondicaoIPIProduto, PFT.CondicaoICMSProduto, 
		PFT.CondicaoRedICMSProduto, PFT.FatorConversaoDIPIProduto, 
		PFT.CodigoTributacaoProduto, PFT.PercRedBaseICMSProduto, 
		PFT.PercentualImportacaoProduto, PFT.QuantidadeAntecessoresProduto, 
		PFT.QuantidadeOpcionaisProduto, PFT.QuantidadeSucessoresProduto, 
		PFT.QuantidadeOutrasFontesProduto, PFT.SubstituicaoTributariaProduto, 
		PFT.EspecificacoesTecnicasProduto, PFT.CodigoCategoria, 
		PFT.CodigoLinhaProduto, PFT.CodigoUnidadeProduto, 
		PFT.CodigoFonteFornecimento, PFT.ItemForaListaProduto, PFT.Decreto31424RJ, 
		PFT.TributaPISProduto, PFT.TributaCOFINSProduto, 
		PFT.CodigoMargemComercializacao, PFT.ImunidadeICMSProduto, 
		PFT.IVADentroEstado, PFT.IVAForaEstado, PFT.ProdutoImportado, PFT.TipoUtilizacao,
		UNPROD.CodigoDIPIUnidadeProduto, UNPROD.DescricaoUnidadeProduto,	
		UNPROD.UsaCasasDecimaisUnidadeProduto, UNPROD.DescricaoUnidadeProdutoMBB,
		NATOP.DescricaoNaturezaOperacao, 
		NATOP.DescricaoNFNaturezaOperacao, NATOP.CodigoTributacaoNaturezaOper, 
		NATOP.GeraDuplicataNaturezaOperacao, NATOP.CondicaoIPINaturezaOperacao, 
		NATOP.CondicaoICMSNaturezaOperacao, NATOP.CondicaoReducaoICMSNatOper, 
		NATOP.PercentualICMSNaturezaOperacao, NATOP.PercReducaoICMSNaturezaOper, 
		NATOP.PercAproveitamentoIPINatOper, NATOP.CFONaturezaOperacao, 
		NATOP.AtualizaEstoqueNaturezaOper, NATOP.AtualizaLFNaturezaOperacao, 
		NATOP.AtualizaCRNaturezaOperacao, NATOP.AtualizaCPNaturezaOperacao, 
		NATOP.AtualizaComisNaturezaOperacao, NATOP.AtualizaEstatNaturezaOperacao, 
		NATOP.AtualizaCGNaturezaOperacao, NATOP.AtualizaAFNaturezaOperacao, 
		NATOP.ZonaFrancaNaturezaOperacao, NATOP.ObservacaoNaturezaOperacao, 
		NATOP.ConsumoImobilizadoNatOper, NATOP.SubstTributariaNaturezaOper, 
		CASE	WHEN (SELECT ISNULL(tmo.CodigoServicoFederal,'')
				FROM	tbMaoObraOS mob
				INNER JOIN tbTipoMaoObra tmo
				ON	tmo.CodigoEmpresa	= mob.CodigoEmpresa
				AND	tmo.CodigoTipoMaoObra	= mob.CodigoTipoMaoObra
				WHERE	mob.CodigoEmpresa	= IP.CodigoEmpresa
				AND	mob.CodigoMaoObraOS	= IP.CodigoMaoObraOS) = ''
			THEN	NATOP.CodigoServicoNaturezaOperacao
			ELSE (SELECT ISNULL(tmo.CodigoServicoFederal,'')
				FROM	tbMaoObraOS mob
				INNER JOIN tbTipoMaoObra tmo
				ON	tmo.CodigoEmpresa	= mob.CodigoEmpresa
				AND	tmo.CodigoTipoMaoObra	= mob.CodigoTipoMaoObra
				WHERE	mob.CodigoEmpresa	= IP.CodigoEmpresa
				AND	mob.CodigoMaoObraOS	= IP.CodigoMaoObraOS)
		END	AS CodigoServicoNaturezaOperacao,
		NATOP.CalculaPISNaturezaOperacao, NATOP.CalculaFinSocialNaturezaOper, 
		NATOP.PercentualISSNaturezaOperacao, NATOP.CodigoTipoOperacao, 
		NATOP.ICMSRetidoFonteNaturezaOper, NATOP.PercReducaoISSNaturezaOperacao, 
		NATOP.FreteTributadoNaturezaOperacao, NATOP.ImportacaoNaturezaOperacao, 
		NATOP.DiferencaICMSNaturezaOperacao, NATOP.IncideIRRFServNaturezaOperacao, 
		NATOP.PercReducaoIPINaturezaOperacao, NATOP.CondicaoReducaoIPINatOper, 
		NATOP.CFONaturezaOperacaoForaEstado, NATOP.DescricaoCFONFNaturezaOper, 
		NATOP.CalculaIPISobreBase3, NATOP.DeduzValorCompraBaseICMS, 
		NATOP.CodigoSituacaoTributaria, NATOP.CodigoTipoMovimentacao, 
		NATOP.CodigoModeloNotaFiscal, NATOP.CodigoSistemaTextoNF, 
		NATOP.CodigoTextoNotaFiscal, NATOP.CodigoSistemaTextoNF2, 
		NATOP.CodigoTextoNotaFiscal2, NATOP.CodigoFatoGeradorContato, 
		NATOP.CFONatOperInternoIN428, NATOP.CodigoCFO, NATOP.EntradaSaidaNaturezaOperacao,
		NATOP.CalculoAutomaticoIRRF, NATOP.CalculaSegSocial, NATOP.PercSegSocial,
		NATOP.MP135PercentualCSLL, NATOP.MP135RetemImpostosFonte,
 		NATOP.PercPIS, NATOP.PercCOFINS, NATOP.MP135DemonstraImpFonte, 
		NATOP.DemonstraISSPrefeitura, NATOP.RetemISSPrefeitura, NATOP.PercISSPrefeitura,
		NATOP.SomaIPIBase3LivroEntrada, NATOP.PercentualIRRF, NATOP.GeraContasPagarPISCOFINS,
		NATOP.CNOBloqueado, NATOP.TextoNFGS3,
		CLF.DescricaoClassificacaoFiscal, CLF.PercIPIClassificacaoFiscal, CLF.CodigoUnidadeDIPI,
		CASE	WHEN (LIP.RecapagemLinhaProduto = 'F' 
				AND LIP.TipoLinhaProduto IN (0,1,2)
				AND LFT.UtilizaDecreto43708 = 'V')
			THEN '060'
			ELSE CLF.CodigoTributacaoDentroEstado
		END	AS	CodigoTributacaoDentroEstado,
		CLF.CodigoTributacaoForaEstado AS CodigoTributacaoForaEstado, CLF.CodFiscalOperacao,
		CASE	WHEN (PED.UnidadeFederacaoOrigem = PED.UnidadeFederacaoDestino 
			AND LIP.RecapagemLinhaProduto = 'F' AND LIP.TipoLinhaProduto IN (0,1,2)
			AND LFT.UtilizaDecreto43708 = 'V')
				THEN	'V'
			WHEN ((PED.UnidadeFederacaoOrigem != PED.UnidadeFederacaoDestino) 
				AND NOT EXISTS (SELECT 1 FROM vwProtocoloICMS41AnexoUnico vw (NOLOCK)
				WHERE	vw.CodigoEmpresa = IP.CodigoEmpresa
				AND	vw.CodigoLocal = IP.CodigoLocal
				AND	vw.CodigoProduto = IP.CodigoProduto))
				THEN	'F'
			ELSE	CLF.ICMSIsento
		END	AS	ICMSIsento,
		LIP.CombustivelLinhaProduto, LIP.PneuLinhaProduto,
		CLF.PercPISImportacao, CLF.PercCOFINSImportacao, CLF.PercImpostoImportacao,
		CLF.CodigoNCM, CLF.PercPIS, CLF.PercCOFINS,
		NATOP.SomaPISCOFINSICMSValorContab,
		PL.CondicaoEstocagem

	FROM tbItemPedido IP 

	INNER JOIN tbPedido PED
	ON	PED.CodigoEmpresa		= IP.CodigoEmpresa
	AND	PED.CodigoLocal			= IP.CodigoLocal
	AND	PED.CentroCusto			= IP.CentroCusto
	AND	PED.NumeroPedido		= IP.NumeroPedido
	AND	PED.SequenciaPedido		= IP.SequenciaPedido

	INNER JOIN tbNaturezaOperacao NATOP
	ON	NATOP.CodigoEmpresa		= @CodigoEmpresa AND 
		NATOP.CodigoNaturezaOperacao	= IP.CodigoNaturezaOperacao 

	INNER JOIN tbLocalFT LFT
	ON	LFT.CodigoEmpresa		= IP.CodigoEmpresa
	AND	LFT.CodigoLocal			= IP.CodigoLocal

	LEFT JOIN tbProduto PD
	ON	PD.CodigoEmpresa		= @CodigoEmpresa AND 
		PD.CodigoProduto		= IP.CodigoProduto 

	LEFT JOIN tbPlanejamentoProduto PL
	ON	PL.CodigoEmpresa		= @CodigoEmpresa AND 
		PL.CodigoLocal			= @CodigoLocal and
		PL.CodigoProduto		= IP.CodigoProduto 

	LEFT JOIN tbProdutoFT PFT
	ON	PFT.CodigoEmpresa		= IP.CodigoEmpresa AND 
		PFT.CodigoProduto		= IP.CodigoProduto 

	LEFT JOIN tbClassificacaoFiscal CLF
	ON	CLF.CodigoEmpresa		= IP.CodigoEmpresa
	AND	CLF.CodigoLocal			= IP.CodigoLocal
	AND	CLF.CodigoClassificacaoFiscal	= CASE	WHEN CONVERT(CHAR(10),IP.CodigoClassificacaoFiscal) IS NOT NULL
								THEN CONVERT(CHAR(10),IP.CodigoClassificacaoFiscal)
							WHEN IP.TipoRegistroItemPed = 'VEC'
								THEN (SELECT MCV.CodigoClassificacaoFiscal FROM tbPedidoCV PCV
									INNER JOIN tbVeiculoCV VCV
									ON	VCV.CodigoEmpresa	= PCV.CodigoEmpresa
									AND	VCV.CodigoLocal		= PCV.CodigoLocal
									AND	VCV.NumeroVeiculoCV	= PCV.NumeroVeiculoCV
									INNER JOIN tbModeloVeiculoCV MCV
									ON	MCV.CodigoEmpresa	= VCV.CodigoEmpresa
									AND	MCV.ModeloVeiculo	= VCV.ModeloVeiculo
									WHERE	PCV.CodigoEmpresa	= IP.CodigoEmpresa
									AND	PCV.CodigoLocal		= IP.CodigoLocal
									AND	PCV.CentroCusto		= IP.CentroCusto
									AND	PCV.NumeroPedido	= IP.NumeroPedido
									AND	PCV.SequenciaPedido	= IP.SequenciaPedido)
							ELSE PD.CodigoClassificacaoFiscal
						END

	LEFT JOIN tbUnidadeProduto UNPROD
	ON	UNPROD.CodigoUnidadeProduto	= PFT.CodigoUnidadeProduto 

	LEFT JOIN tbLinhaProduto LIP
	ON	LIP.CodigoEmpresa		= @CodigoEmpresa
	AND	LIP.CodigoLinhaProduto		= PFT.CodigoLinhaProduto

	WHERE	IP.CodigoEmpresa		= @CodigoEmpresa
	AND	IP.CodigoLocal			= @CodigoLocal
	AND	IP.NumeroPedido			= @NumeroPedido
	AND	IP.SequenciaPedido		= @SequenciaPedido
	AND	IP.CentroCusto			= @CentroCusto


SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whLItemPedido TO SQLUsers
GO

go

IF EXISTS (SELECT 1 FROM sysobjects WHERE id = object_id('whNFeAtualizarStatusPed'))
	DROP PROCEDURE dbo.whNFeAtualizarStatusPed
GO
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
EMPRESA......: T-SYSTEMS
PROJETO......: NFE
AUTOR........: Alex Kmez
DATA.........: 28/12/2009
OBJETIVO.....: 

EXECUTE whNFeAtualizarStatusPed @CodigoEmpresa = 1608,@CodigoLocal = 0,@CentroCusto = 11310,@NumeroPedido = 62198,@SequenciaPedido = 0
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/
CREATE PROCEDURE dbo.whNFeAtualizarStatusPed
	@CodigoEmpresa numeric(4),
	@CodigoLocal numeric(4),
	@CentroCusto numeric(8),
	@NumeroPedido numeric(6),
	@SequenciaPedido numeric(2)
AS
    UPDATE  tbPedido Set StatusPedidoPed = 4
    WHERE CodigoEmpresa = @CodigoEmpresa
    AND CodigoLocal = @CodigoLocal
    AND CentroCusto = @CentroCusto
    AND NumeroPedido = @NumeroPedido
    AND SequenciaPedido = @SequenciaPedido
    AND StatusPedidoPed = 8
GO
GRANT EXECUTE ON dbo.whNFeAtualizarStatusPed TO SQLUsers
GO

go

if exists(select 1 from sysobjects where id = object_id('dbo.whPreItemDocumentoNFe'))
DROP PROCEDURE dbo.whPreItemDocumentoNFe
GO
CREATE PROCEDURE dbo.whPreItemDocumentoNFe
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil 
 PROJETO......: NFe
 AUTOR........: Edvaldo Ragassi
 DATA.........: 31/03/2009
 UTILIZADO EM : modDocumentoNFe.PesquisarDocumento
 OBJETIVO.....: Carregar rSet com dados necessario para geração do arquivo texto da NFe.
 
 ALTERACAO....:	
 OBJETIVO.....:	
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa			NUMERIC(4),
@CodigoLocal			NUMERIC(4),
@EntradaSaida			CHAR(1),
@NumeroDocumento		NUMERIC(6),
@DataDocumento			DATETIME,
@CodigoCliFor			NUMERIC(14),
@TipoLancamentoMovimentacao	NUMERIC(2)

WITH ENCRYPTION
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


DECLARE	@Complementar		CHAR(1)
DECLARE	@DocumentoOriginal	NUMERIC(6)
DECLARE @DataOriginal		DATETIME
DECLARE @ContribuinteIPI	CHAR(1)

SELECT	@Complementar		= 'F'
SELECT	@DocumentoOriginal	= 0
SELECT	@DataOriginal		= NULL

IF @TipoLancamentoMovimentacao = 13
BEGIN
	IF EXISTS (SELECT 1 FROM NFDocumentoFT d
			INNER JOIN tbNaturezaOperacao nat
			ON	nat.CodigoEmpresa		= d.CodigoEmpresa
			AND	nat.CodigoNaturezaOperacao	= d.CodigoNaturezaOperacao
			WHERE	d.CodigoEmpresa			= @CodigoEmpresa
			AND	d.CodigoLocal			= @CodigoLocal
			AND	d.EntradaSaidaDocumento		= @EntradaSaida
			AND	d.NumeroDocumento		= @NumeroDocumento
			AND	d.DataDocumento			= @DataDocumento
			AND	d.CodigoCliFor			= @CodigoCliFor
			AND	d.TipoLancamentoMovimentacao	= @TipoLancamentoMovimentacao
			AND	nat.CodigoTipoOperacao		= 20)
	BEGIN
		SELECT	@Complementar			= 'V'
		SELECT	@DocumentoOriginal		= NotaFiscalOriginalDocFT,
			@DataOriginal			= DataEmissaoNFOriginalDocFT
		FROM	NFDocumentoFT d
		WHERE	d.CodigoEmpresa			= @CodigoEmpresa
		AND	d.CodigoLocal			= @CodigoLocal
		AND	d.EntradaSaidaDocumento		= @EntradaSaida
		AND	d.NumeroDocumento		= @NumeroDocumento
		AND	d.DataDocumento			= @DataDocumento
		AND	d.CodigoCliFor			= @CodigoCliFor
		AND	d.TipoLancamentoMovimentacao	= @TipoLancamentoMovimentacao
	END
END

IF @TipoLancamentoMovimentacao = 7
BEGIN
	IF EXISTS (SELECT 1 FROM tbDocumentoFT d
			INNER JOIN tbNaturezaOperacao nat
			ON	nat.CodigoEmpresa		= d.CodigoEmpresa
			AND	nat.CodigoNaturezaOperacao	= d.CodigoNaturezaOperacao
			WHERE	d.CodigoEmpresa			= @CodigoEmpresa
			AND	d.CodigoLocal			= @CodigoLocal
			AND	d.EntradaSaidaDocumento		= @EntradaSaida
			AND	d.NumeroDocumento		= @NumeroDocumento
			AND	d.DataDocumento			= @DataDocumento
			AND	d.CodigoCliFor			= @CodigoCliFor
			AND	d.TipoLancamentoMovimentacao	= @TipoLancamentoMovimentacao
			AND	nat.CodigoTipoOperacao		= 20)
	BEGIN
		SELECT	@Complementar			= 'V'
		SELECT	@DocumentoOriginal		= NotaFiscalOriginalDocFT,
			@DataOriginal			= DataEmissaoNFOriginalDocFT
		FROM	tbDocumentoFT d
		WHERE	d.CodigoEmpresa			= @CodigoEmpresa
		AND	d.CodigoLocal			= @CodigoLocal
		AND	d.EntradaSaidaDocumento		= @EntradaSaida
		AND	d.NumeroDocumento		= @NumeroDocumento
		AND	d.DataDocumento			= @DataDocumento
		AND	d.CodigoCliFor			= @CodigoCliFor
		AND	d.TipoLancamentoMovimentacao	= @TipoLancamentoMovimentacao
	END
END

SELECT	@ContribuinteIPI	= CondicaoContribuinteIPI
FROM	tbLocalLF
WHERE	CodigoEmpresa		= @CodigoEmpresa
AND	CodigoLocal		= @CodigoLocal

IF @TipoLancamentoMovimentacao = 13
BEGIN
	IF @Complementar = 'F'
	BEGIN
		SELECT	idoc.SequenciaItemDocumento,
			idoc.CodigoItemDocto,
			idoc.CodigoNaturezaOperacao,
			idoc.CodigoProduto,
			idoc.CodigoServicoISSItemDocto,
			idoc.CodigoMaoObraOS,
			idoc.TipoRegistroItemDocto,
			idoc.QtdeLancamentoItemDocto,
			idoc.ValorDescontoItemDocto,
			idoc.ValorBaseICMS1ItemDocto,
			idoc.PercentualICMSItemDocto,
			idoc.ValorICMSItemDocto,
			idoc.BaseICMSSubstTribItemDocto,
			idoc.PercICMSSubsTributItemDocto,
			idoc.ValorICMSSubstTribItemDocto,
			idoc.ValorPISItemDocto,
			idoc.ValorBasePISItemDocto,
			idoc.ValorPISSTItemDocto,
			idoc.BasePISSTItemDocto,
			idoc.PercPISSTItemDocto,
			idoc.ValorBaseISSItemDocto,
			idoc.PercentualISSItemDocto,
			idoc.ValorISSItemDocto,
			idoc.CodigoCFO					AS 'CodigoCFOItemDoc', 
			idoc.CodigoClassificacaoFiscal			AS 'CodigoClassificacaoFiscalProd', 
			idoc.CodigoClassificacaoFiscal			AS 'CodigoClassificacaoFiscalVEC', 
			idoc.PercPISItemDocto				AS PercPIS,
			CAST(nop.PercReducaoICMSNaturezaOper AS MONEY)	AS PercReducaoICMSNaturezaOper,
			nop.CodigoServicoNaturezaOperacao,
			nop.CodigoTipoOperacao,
			idoctx.TextoItemDocumentoFT,
			idocft.UnidadeItDocFT,
			idocft.PrecoUnitarioItDocFT,
			idocft.PrecoLiquidoUnitarioItDocFT,
			idocft.CodigoTributacaoItDocFT,
			idocft.PercCofinsItDocFT			AS PercCOFINS,
			idocft.BaseCOFINSItDocFT,
			idocft.ValorCOFINSItDocFT,
			idocft.PercCofinsSTItDocFT,
			idocft.BaseCofinsSTItDocFT,
			idocft.ValorCofinsSTItDocFT,
			idocft.ImpostoImportacaoItDocFT,
			idocft.BaseICMSSTUltEntradaItDocFT		AS BaseICMSSTUltimaEntrada,
			idocft.ValorICMSSTUltEntradaItDocFT		AS ICMSSTUltimaEntrada,
			vcv.NumeroMotorVeiculo,
			vcv.VeiculoNovoCV,
			vcv.NumeroChassisCV,
			vcv.CodigoCorExternaVeiculoCV,
			vcv.NumeroRenavam,
			vcv.AnoModeloVeiculoCV,
			vcv.AnoFabricacaoVeic,
			mvcv.Potencia,
			mvcv.NumeroCilindros				AS cilin,
			mvcv.PesoLiquidoModelo,
			mvcv.Serie					AS nSerie,
			mvcv.CMT,
			mvcv.EntreEixos					AS dist,
			mvcv.CodigoMarcaModelo				AS cMod,
			mvcv.CodEspecieRenavam,
			tComb.CodCombustivelRenavam,
			CatVeicOS.CodTipoVeicRenavam,
			corveic.DescricaoCorVeic,
			condVeic = '1',
			VIN = 'N',
			prod.DescricaoProduto,
			CASE	WHEN	idoc.ValorICMSSubstTribItemDocto = 0
				THEN	0
				ELSE	CAST((((idoc.BaseICMSSubstTribItemDocto / idoc.ValorBaseICMS1ItemDocto) - 1) * 100) AS NUMERIC(6,2))
			END	AS 'MVA',
			CASE	WHEN	idoc.ValorBaseIPI1ItemDocto != 0
				THEN	idoc.ValorBaseIPI1ItemDocto
				ELSE	0
			END	AS 'VBCIPI',
			CASE	WHEN	(idoc.ValorBaseIPI1ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'E')
				THEN	'00'
				WHEN	(idoc.ValorBaseIPI1ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'50'
				WHEN	(idoc.ValorBaseIPI2ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'52'
				WHEN	(idoc.ValorBaseIPI3ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'53'
				WHEN	(nop.CondicaoIPINaturezaOperacao = 2 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'52'
				WHEN	(nop.CondicaoIPINaturezaOperacao = 3 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'53'
				ELSE	'53'
			END	AS 'CSTIPI',
			infAdProd = ''
		FROM	NFItemDocumento		idoc 
		INNER JOIN NFItemDocumentoFT	idocft 
		ON	idoc.CodigoEmpresa		= idocft.CodigoEmpresa
		AND	idoc.CodigoLocal		= idocft.CodigoLocal
		AND	idoc.EntradaSaidaDocumento	= idocft.EntradaSaidaDocumento
		AND	idoc.NumeroDocumento		= idocft.NumeroDocumento
		AND	idoc.DataDocumento		= idocft.DataDocumento
		AND	idoc.CodigoCliFor		= idocft.CodigoCliFor
		AND	idoc.TipoLancamentoMovimentacao	= idocft.TipoLancamentoMovimentacao
		AND	idoc.SequenciaItemDocumento	= idocft.SequenciaItemDocumento 
		INNER JOIN NFItemDocumentoTextos	idoctx
		ON	idoc.CodigoEmpresa		= idoctx.CodigoEmpresa
		AND	idoc.CodigoLocal		= idoctx.CodigoLocal
		AND	idoc.EntradaSaidaDocumento	= idoctx.EntradaSaidaDocumento
		AND	idoc.NumeroDocumento		= idoctx.NumeroDocumento
		AND	idoc.DataDocumento		= idoctx.DataDocumento
		AND	idoc.CodigoCliFor		= idoctx.CodigoCliFor
		AND	idoc.TipoLancamentoMovimentacao	= idoctx.TipoLancamentoMovimentacao
		AND	idoc.SequenciaItemDocumento	= idoctx.SequenciaItemDocumento 
		LEFT JOIN tbProduto prod 
		ON	prod.CodigoEmpresa		= idoc.CodigoEmpresa
		AND	prod.CodigoProduto		= idoc.CodigoProduto
		LEFT JOIN tbProdutoFT prodFT 
		ON	prod.CodigoEmpresa		= prodFT.CodigoEmpresa
		AND	prod.CodigoProduto		= prodFT.CodigoProduto
		LEFT JOIN tbVeiculoCV vcv 
		ON	vcv.CodigoEmpresa		= idoc.CodigoEmpresa 
		AND	vcv.CodigoLocal			= idoc.CodigoLocal 
		AND	vcv.NumeroVeiculoCV		= idoc.NumeroVeiculoCV 
		LEFT JOIN tbModeloVeiculoCV mvcv 
		ON	mvcv.CodigoEmpresa		= vcv.CodigoEmpresa
		AND	mvcv.ModeloVeiculo		= vcv.ModeloVeiculo
		LEFT JOIN tbTipoCombustivel tComb 
		ON	tComb.CodigoCombustivel		= mvcv.CodigoCombustivel 
		LEFT JOIN tbCategoriaVeiculoOS CatVeicOS 
		ON	mvcv.CodigoEmpresa		= CatVeicOS.CodigoEmpresa
		AND	mvcv.CodigoCategoriaVeiculoOS	= CatVeicOS.CodigoCategoriaVeiculoOS
		LEFT JOIN tbCoresVeiculos corveic 
		ON	corveic.CodigoEmpresa		= vcv.CodigoEmpresa 
		AND	corveic.AplicacaoCor		= 'E' 
		AND	corveic.CodigoCorVeic		= vcv.CodigoCorExternaVeiculoCV 
		LEFT JOIN tbMaoObraOS mos 
		ON	mos.CodigoEmpresa		= idoc.CodigoEmpresa 
		AND	mos.CodigoMaoObraOS		= idoc.CodigoMaoObraOS 
		INNER JOIN tbNaturezaOperacao nop 
		ON	nop.CodigoEmpresa		= idoc.CodigoEmpresa 
		AND	nop.CodigoNaturezaOperacao	= idoc.CodigoNaturezaOperacao 
		WHERE	idoc.CodigoEmpresa		= @CodigoEmpresa
		AND	idoc.CodigoLocal		= @CodigoLocal
		AND	idoc.EntradaSaidaDocumento	= @EntradaSaida
		AND	idoc.NumeroDocumento		= @NumeroDocumento
		AND	idoc.DataDocumento		= @DataDocumento
		AND	idoc.CodigoCliFor		= @CodigoCliFor
		AND	idoc.TipoLancamentoMovimentacao	= @TipoLancamentoMovimentacao
	END
	IF @Complementar = 'V'
	BEGIN
		SELECT	idoc.SequenciaItemDocumento,
			idoc.CodigoItemDocto,
			idoc.CodigoNaturezaOperacao,
			idoc.CodigoProduto,
			idoc.CodigoServicoISSItemDocto,
			idoc.CodigoMaoObraOS,
			idoc.TipoRegistroItemDocto,
			idoc.QtdeLancamentoItemDocto,
			idoc.ValorDescontoItemDocto,
			idoc.ValorBaseICMS1ItemDocto,
			idoc.PercentualICMSItemDocto,
			idoc.ValorICMSItemDocto,
			idoc.BaseICMSSubstTribItemDocto,
			idoc.PercICMSSubsTributItemDocto,
			idoc.ValorICMSSubstTribItemDocto,
			idoc.ValorPISItemDocto,
			idoc.ValorBasePISItemDocto,
			idoc.ValorPISSTItemDocto,
			idoc.BasePISSTItemDocto,
			idoc.PercPISSTItemDocto,
			idoc.ValorBaseISSItemDocto,
			idoc.PercentualISSItemDocto,
			idoc.ValorISSItemDocto,
			idoc.CodigoCFO					AS 'CodigoCFOItemDoc', 
			idoc.CodigoClassificacaoFiscal			AS 'CodigoClassificacaoFiscalProd', 
			idoc.CodigoClassificacaoFiscal			AS 'CodigoClassificacaoFiscalVEC', 
			idoc.PercPISItemDocto				AS PercPIS,
			CAST(nop.PercReducaoICMSNaturezaOper AS MONEY)	AS PercReducaoICMSNaturezaOper,
			nop.CodigoServicoNaturezaOperacao,
			nop.CodigoTipoOperacao,
			idoctx.TextoItemDocumentoFT,
			idocft.UnidadeItDocFT,
			idocft.PrecoUnitarioItDocFT,
			idocft.PrecoLiquidoUnitarioItDocFT,
			idocft.CodigoTributacaoItDocFT,
			idocft.PercCofinsItDocFT			AS PercCOFINS,
			idocft.BaseCOFINSItDocFT,
			idocft.ValorCOFINSItDocFT,
			idocft.PercCofinsSTItDocFT,
			idocft.BaseCofinsSTItDocFT,
			idocft.ValorCofinsSTItDocFT,
			idocft.ImpostoImportacaoItDocFT,
			idocft.BaseICMSSTUltEntradaItDocFT		AS BaseICMSSTUltimaEntrada,
			idocft.ValorICMSSTUltEntradaItDocFT		AS ICMSSTUltimaEntrada,
			vcv.NumeroMotorVeiculo,
			vcv.VeiculoNovoCV,
			vcv.NumeroChassisCV,
			vcv.CodigoCorExternaVeiculoCV,
			vcv.NumeroRenavam,
			vcv.AnoModeloVeiculoCV,
			vcv.AnoFabricacaoVeic,
			mvcv.Potencia,
			mvcv.NumeroCilindros				AS cilin,
			mvcv.PesoLiquidoModelo,
			mvcv.Serie					AS nSerie,
			mvcv.CMT,
			mvcv.EntreEixos					AS dist,
			mvcv.CodigoMarcaModelo				AS cMod,
			mvcv.CodEspecieRenavam,
			tComb.CodCombustivelRenavam,
			CatVeicOS.CodTipoVeicRenavam,
			corveic.DescricaoCorVeic,
			condVeic = '1',
			VIN = 'N',
			prod.DescricaoProduto,
			CASE	WHEN	idoc.ValorICMSSubstTribItemDocto = 0
				THEN	0
				ELSE	CAST((((idoc.BaseICMSSubstTribItemDocto / idoc.ValorBaseICMS1ItemDocto) - 1) * 100) AS NUMERIC(6,2))
			END	AS 'MVA',
			CASE	WHEN	idoc.ValorBaseIPI1ItemDocto != 0
				THEN	idoc.ValorBaseIPI1ItemDocto
				ELSE	0
			END	AS 'VBCIPI',
			CASE	WHEN	(idoc.ValorBaseIPI1ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'E')
				THEN	'00'
				WHEN	(idoc.ValorBaseIPI1ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'50'
				WHEN	(idoc.ValorBaseIPI2ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'52'
				WHEN	(idoc.ValorBaseIPI3ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'53'
				WHEN	(nop.CondicaoIPINaturezaOperacao = 2 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'52'
				WHEN	(nop.CondicaoIPINaturezaOperacao = 3 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'53'
				ELSE	'53'
			END	AS 'CSTIPI',
			infAdProd = ''
		FROM	tbItemDocumento		idoc 
		INNER JOIN tbItemDocumentoFT	idocft 
		ON	idoc.CodigoEmpresa		= idocft.CodigoEmpresa
		AND	idoc.CodigoLocal		= idocft.CodigoLocal
		AND	idoc.EntradaSaidaDocumento	= idocft.EntradaSaidaDocumento
		AND	idoc.NumeroDocumento		= idocft.NumeroDocumento
		AND	idoc.DataDocumento		= idocft.DataDocumento
		AND	idoc.CodigoCliFor		= idocft.CodigoCliFor
		AND	idoc.TipoLancamentoMovimentacao	= idocft.TipoLancamentoMovimentacao
		AND	idoc.SequenciaItemDocumento	= idocft.SequenciaItemDocumento 
		INNER JOIN tbItemDocumentoTextos	idoctx
		ON	idoc.CodigoEmpresa		= idoctx.CodigoEmpresa
		AND	idoc.CodigoLocal		= idoctx.CodigoLocal
		AND	idoc.EntradaSaidaDocumento	= idoctx.EntradaSaidaDocumento
		AND	idoc.NumeroDocumento		= idoctx.NumeroDocumento
		AND	idoc.DataDocumento		= idoctx.DataDocumento
		AND	idoc.CodigoCliFor		= idoctx.CodigoCliFor
		AND	idoc.TipoLancamentoMovimentacao	= idoctx.TipoLancamentoMovimentacao
		AND	idoc.SequenciaItemDocumento	= idoctx.SequenciaItemDocumento 
		LEFT JOIN tbProduto prod 
		ON	prod.CodigoEmpresa		= idoc.CodigoEmpresa
		AND	prod.CodigoProduto		= idoc.CodigoProduto
		LEFT JOIN tbProdutoFT prodFT 
		ON	prod.CodigoEmpresa		= prodFT.CodigoEmpresa
		AND	prod.CodigoProduto		= prodFT.CodigoProduto
		LEFT JOIN tbVeiculoCV vcv 
		ON	vcv.CodigoEmpresa		= idoc.CodigoEmpresa 
		AND	vcv.CodigoLocal			= idoc.CodigoLocal 
		AND	vcv.NumeroVeiculoCV		= idoc.NumeroVeiculoCV 
		LEFT JOIN tbModeloVeiculoCV mvcv 
		ON	mvcv.CodigoEmpresa		= vcv.CodigoEmpresa
		AND	mvcv.ModeloVeiculo		= vcv.ModeloVeiculo
		LEFT JOIN tbTipoCombustivel tComb 
		ON	tComb.CodigoCombustivel		= mvcv.CodigoCombustivel 
		LEFT JOIN tbCategoriaVeiculoOS CatVeicOS 
		ON	mvcv.CodigoEmpresa		= CatVeicOS.CodigoEmpresa
		AND	mvcv.CodigoCategoriaVeiculoOS	= CatVeicOS.CodigoCategoriaVeiculoOS
		LEFT JOIN tbCoresVeiculos corveic 
		ON	corveic.CodigoEmpresa		= vcv.CodigoEmpresa 
		AND	corveic.AplicacaoCor		= 'E' 
		AND	corveic.CodigoCorVeic		= vcv.CodigoCorExternaVeiculoCV 
		LEFT JOIN tbMaoObraOS mos 
		ON	mos.CodigoEmpresa		= idoc.CodigoEmpresa 
		AND	mos.CodigoMaoObraOS		= idoc.CodigoMaoObraOS 
		INNER JOIN tbNaturezaOperacao nop 
		ON	nop.CodigoEmpresa		= idoc.CodigoEmpresa 
		AND	nop.CodigoNaturezaOperacao	= idoc.CodigoNaturezaOperacao 
		WHERE	idoc.CodigoEmpresa		= @CodigoEmpresa
		AND	idoc.CodigoLocal		= @CodigoLocal
--		AND	idoc.EntradaSaidaDocumento	= @EntradaSaida
		AND	idoc.NumeroDocumento		= @DocumentoOriginal
		AND	idoc.DataDocumento		= @DataOriginal
		AND	idoc.CodigoCliFor		= @CodigoCliFor
		AND	idoc.TipoLancamentoMovimentacao	= 7
	END
END

IF @TipoLancamentoMovimentacao = 7
BEGIN
	IF @Complementar = 'F'
	BEGIN
		SELECT	idoc.SequenciaItemDocumento,
			idoc.CodigoItemDocto,
			idoc.CodigoNaturezaOperacao,
			idoc.CodigoProduto,
			idoc.CodigoServicoISSItemDocto,
			idoc.CodigoMaoObraOS,
			idoc.TipoRegistroItemDocto,
			idoc.QtdeLancamentoItemDocto,
			idoc.ValorDescontoItemDocto,
			idoc.ValorBaseICMS1ItemDocto,
			idoc.PercentualICMSItemDocto,
			idoc.ValorICMSItemDocto,
			idoc.BaseICMSSubstTribItemDocto,
			idoc.PercICMSSubsTributItemDocto,
			idoc.ValorICMSSubstTribItemDocto,
			idoc.ValorPISItemDocto,
			idoc.ValorBasePISItemDocto,
			idoc.ValorPISSTItemDocto,
			idoc.BasePISSTItemDocto,
			idoc.PercPISSTItemDocto,
			idoc.ValorBaseISSItemDocto,
			idoc.PercentualISSItemDocto,
			idoc.ValorISSItemDocto,
			idoc.CodigoCFO					AS 'CodigoCFOItemDoc', 
			idoc.CodigoClassificacaoFiscal			AS 'CodigoClassificacaoFiscalProd', 
			idoc.CodigoClassificacaoFiscal			AS 'CodigoClassificacaoFiscalVEC', 
			idoc.PercPISItemDocto				AS PercPIS,
			CAST(nop.PercReducaoICMSNaturezaOper AS MONEY)	AS PercReducaoICMSNaturezaOper,
			nop.CodigoServicoNaturezaOperacao,
			nop.CodigoTipoOperacao,
			idoctx.TextoItemDocumentoFT,
			idocft.UnidadeItDocFT,
			idocft.PrecoUnitarioItDocFT,
			idocft.PrecoLiquidoUnitarioItDocFT,
			idocft.CodigoTributacaoItDocFT,
			idocft.PercCofinsItDocFT			AS PercCOFINS,
			idocft.BaseCOFINSItDocFT,
			idocft.ValorCOFINSItDocFT,
			idocft.PercCofinsSTItDocFT,
			idocft.BaseCofinsSTItDocFT,
			idocft.ValorCofinsSTItDocFT,
			idocft.ImpostoImportacaoItDocFT,
			idocft.BaseICMSSTUltEntradaItDocFT		AS BaseICMSSTUltimaEntrada,
			idocft.ValorICMSSTUltEntradaItDocFT		AS ICMSSTUltimaEntrada,
			vcv.NumeroMotorVeiculo,
			vcv.VeiculoNovoCV,
			vcv.NumeroChassisCV,
			vcv.CodigoCorExternaVeiculoCV,
			vcv.NumeroRenavam,
			vcv.AnoModeloVeiculoCV,
			vcv.AnoFabricacaoVeic,
			mvcv.Potencia,
			mvcv.NumeroCilindros				AS cilin,
			mvcv.PesoLiquidoModelo,
			mvcv.Serie					AS nSerie,
			mvcv.CMT,
			mvcv.EntreEixos					AS dist,
			mvcv.CodigoMarcaModelo				AS cMod,
			mvcv.CodEspecieRenavam,
			tComb.CodCombustivelRenavam,
			CatVeicOS.CodTipoVeicRenavam,
			corveic.DescricaoCorVeic,
			condVeic = '1',
			VIN = 'N',
			prod.DescricaoProduto,
			CASE	WHEN	idoc.ValorICMSSubstTribItemDocto = 0
				THEN	0
				ELSE	CAST((((idoc.BaseICMSSubstTribItemDocto / idoc.ValorBaseICMS1ItemDocto) - 1) * 100) AS NUMERIC(6,2))
			END	AS 'MVA',
			CASE	WHEN	idoc.ValorBaseIPI1ItemDocto != 0
				THEN	idoc.ValorBaseIPI1ItemDocto
				ELSE	0
			END	AS 'VBCIPI',
			CASE	WHEN	(idoc.ValorBaseIPI1ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'E')
				THEN	'00'
				WHEN	(idoc.ValorBaseIPI1ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'50'
				WHEN	(idoc.ValorBaseIPI2ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'52'
				WHEN	(idoc.ValorBaseIPI3ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'53'
				WHEN	(nop.CondicaoIPINaturezaOperacao = 2 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'52'
				WHEN	(nop.CondicaoIPINaturezaOperacao = 3 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'53'
				ELSE	'53'
			END	AS 'CSTIPI',
			infAdProd = ''
		FROM	tbItemDocumento		idoc 
		INNER JOIN tbItemDocumentoFT	idocft 
		ON	idoc.CodigoEmpresa		= idocft.CodigoEmpresa
		AND	idoc.CodigoLocal		= idocft.CodigoLocal
		AND	idoc.EntradaSaidaDocumento	= idocft.EntradaSaidaDocumento
		AND	idoc.NumeroDocumento		= idocft.NumeroDocumento
		AND	idoc.DataDocumento		= idocft.DataDocumento
		AND	idoc.CodigoCliFor		= idocft.CodigoCliFor
		AND	idoc.TipoLancamentoMovimentacao	= idocft.TipoLancamentoMovimentacao
		AND	idoc.SequenciaItemDocumento	= idocft.SequenciaItemDocumento 
		INNER JOIN tbItemDocumentoTextos	idoctx
		ON	idoc.CodigoEmpresa		= idoctx.CodigoEmpresa
		AND	idoc.CodigoLocal		= idoctx.CodigoLocal
		AND	idoc.EntradaSaidaDocumento	= idoctx.EntradaSaidaDocumento
		AND	idoc.NumeroDocumento		= idoctx.NumeroDocumento
		AND	idoc.DataDocumento		= idoctx.DataDocumento
		AND	idoc.CodigoCliFor		= idoctx.CodigoCliFor
		AND	idoc.TipoLancamentoMovimentacao	= idoctx.TipoLancamentoMovimentacao
		AND	idoc.SequenciaItemDocumento	= idoctx.SequenciaItemDocumento 
		LEFT JOIN tbProduto prod 
		ON	prod.CodigoEmpresa		= idoc.CodigoEmpresa
		AND	prod.CodigoProduto		= idoc.CodigoProduto
		LEFT JOIN tbProdutoFT prodFT 
		ON	prod.CodigoEmpresa		= prodFT.CodigoEmpresa
		AND	prod.CodigoProduto		= prodFT.CodigoProduto
		LEFT JOIN tbVeiculoCV vcv 
		ON	vcv.CodigoEmpresa		= idoc.CodigoEmpresa 
		AND	vcv.CodigoLocal			= idoc.CodigoLocal 
		AND	vcv.NumeroVeiculoCV		= idoc.NumeroVeiculoCV 
		LEFT JOIN tbModeloVeiculoCV mvcv 
		ON	mvcv.CodigoEmpresa		= vcv.CodigoEmpresa
		AND	mvcv.ModeloVeiculo		= vcv.ModeloVeiculo
		LEFT JOIN tbTipoCombustivel tComb 
		ON	tComb.CodigoCombustivel		= mvcv.CodigoCombustivel 
		LEFT JOIN tbCategoriaVeiculoOS CatVeicOS 
		ON	mvcv.CodigoEmpresa		= CatVeicOS.CodigoEmpresa
		AND	mvcv.CodigoCategoriaVeiculoOS	= CatVeicOS.CodigoCategoriaVeiculoOS
		LEFT JOIN tbCoresVeiculos corveic 
		ON	corveic.CodigoEmpresa		= vcv.CodigoEmpresa 
		AND	corveic.AplicacaoCor		= 'E' 
		AND	corveic.CodigoCorVeic		= vcv.CodigoCorExternaVeiculoCV 
		LEFT JOIN tbMaoObraOS mos 
		ON	mos.CodigoEmpresa		= idoc.CodigoEmpresa 
		AND	mos.CodigoMaoObraOS		= idoc.CodigoMaoObraOS 
		INNER JOIN tbNaturezaOperacao nop 
		ON	nop.CodigoEmpresa		= idoc.CodigoEmpresa 
		AND	nop.CodigoNaturezaOperacao	= idoc.CodigoNaturezaOperacao 
		WHERE	idoc.CodigoEmpresa		= @CodigoEmpresa
		AND	idoc.CodigoLocal		= @CodigoLocal
		AND	idoc.EntradaSaidaDocumento	= @EntradaSaida
		AND	idoc.NumeroDocumento		= @NumeroDocumento
		AND	idoc.DataDocumento		= @DataDocumento
		AND	idoc.CodigoCliFor		= @CodigoCliFor
		AND	idoc.TipoLancamentoMovimentacao	= @TipoLancamentoMovimentacao
	END
	IF @Complementar = 'V'
	BEGIN
		SELECT	idoc.SequenciaItemDocumento,
			idoc.CodigoItemDocto,
			idoc.CodigoNaturezaOperacao,
			idoc.CodigoProduto,
			idoc.CodigoServicoISSItemDocto,
			idoc.CodigoMaoObraOS,
			idoc.TipoRegistroItemDocto,
			idoc.QtdeLancamentoItemDocto,
			idoc.ValorDescontoItemDocto,
			idoc.ValorBaseICMS1ItemDocto,
			idoc.PercentualICMSItemDocto,
			idoc.ValorICMSItemDocto,
			idoc.BaseICMSSubstTribItemDocto,
			idoc.PercICMSSubsTributItemDocto,
			idoc.ValorICMSSubstTribItemDocto,
			idoc.ValorPISItemDocto,
			idoc.ValorBasePISItemDocto,
			idoc.ValorPISSTItemDocto,
			idoc.BasePISSTItemDocto,
			idoc.PercPISSTItemDocto,
			idoc.ValorBaseISSItemDocto,
			idoc.PercentualISSItemDocto,
			idoc.ValorISSItemDocto,
			idoc.CodigoCFO					AS 'CodigoCFOItemDoc', 
			idoc.CodigoClassificacaoFiscal			AS 'CodigoClassificacaoFiscalProd', 
			idoc.CodigoClassificacaoFiscal			AS 'CodigoClassificacaoFiscalVEC', 
			idoc.PercPISItemDocto				AS PercPIS,
			CAST(nop.PercReducaoICMSNaturezaOper AS MONEY)	AS PercReducaoICMSNaturezaOper,
			nop.CodigoServicoNaturezaOperacao,
			nop.CodigoTipoOperacao,
			idoctx.TextoItemDocumentoFT,
			idocft.UnidadeItDocFT,
			idocft.PrecoUnitarioItDocFT,
			idocft.PrecoLiquidoUnitarioItDocFT,
			idocft.CodigoTributacaoItDocFT,
			idocft.PercCofinsItDocFT			AS PercCOFINS,
			idocft.BaseCOFINSItDocFT,
			idocft.ValorCOFINSItDocFT,
			idocft.PercCofinsSTItDocFT,
			idocft.BaseCofinsSTItDocFT,
			idocft.ValorCofinsSTItDocFT,
			idocft.ImpostoImportacaoItDocFT,
			idocft.BaseICMSSTUltEntradaItDocFT		AS BaseICMSSTUltimaEntrada,
			idocft.ValorICMSSTUltEntradaItDocFT		AS ICMSSTUltimaEntrada,
			vcv.NumeroMotorVeiculo,
			vcv.VeiculoNovoCV,
			vcv.NumeroChassisCV,
			vcv.CodigoCorExternaVeiculoCV,
			vcv.NumeroRenavam,
			vcv.AnoModeloVeiculoCV,
			vcv.AnoFabricacaoVeic,
			mvcv.Potencia,
			mvcv.NumeroCilindros				AS cilin,
			mvcv.PesoLiquidoModelo,
			mvcv.Serie					AS nSerie,
			mvcv.CMT,
			mvcv.EntreEixos					AS dist,
			mvcv.CodigoMarcaModelo				AS cMod,
			mvcv.CodEspecieRenavam,
			tComb.CodCombustivelRenavam,
			CatVeicOS.CodTipoVeicRenavam,
			corveic.DescricaoCorVeic,
			condVeic = '1',
			VIN = 'N',
			prod.DescricaoProduto,
			CASE	WHEN	idoc.ValorICMSSubstTribItemDocto = 0
				THEN	0
				ELSE	CAST((((idoc.BaseICMSSubstTribItemDocto / idoc.ValorBaseICMS1ItemDocto) - 1) * 100) AS NUMERIC(6,2))
			END	AS 'MVA',
			CASE	WHEN	idoc.ValorBaseIPI1ItemDocto != 0
				THEN	idoc.ValorBaseIPI1ItemDocto
				ELSE	0
			END	AS 'VBCIPI',
			CASE	WHEN	(idoc.ValorBaseIPI1ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'E')
				THEN	'00'
				WHEN	(idoc.ValorBaseIPI1ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'50'
				WHEN	(idoc.ValorBaseIPI2ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'52'
				WHEN	(idoc.ValorBaseIPI3ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'53'
				WHEN	(nop.CondicaoIPINaturezaOperacao = 2 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'52'
				WHEN	(nop.CondicaoIPINaturezaOperacao = 3 AND idoc.EntradaSaidaDocumento = 'S')
				THEN	'53'
				ELSE	'53'
			END	AS 'CSTIPI',
			infAdProd = ''
		FROM	tbItemDocumento		idoc 
		INNER JOIN tbItemDocumentoFT	idocft 
		ON	idoc.CodigoEmpresa		= idocft.CodigoEmpresa
		AND	idoc.CodigoLocal		= idocft.CodigoLocal
		AND	idoc.EntradaSaidaDocumento	= idocft.EntradaSaidaDocumento
		AND	idoc.NumeroDocumento		= idocft.NumeroDocumento
		AND	idoc.DataDocumento		= idocft.DataDocumento
		AND	idoc.CodigoCliFor		= idocft.CodigoCliFor
		AND	idoc.TipoLancamentoMovimentacao	= idocft.TipoLancamentoMovimentacao
		AND	idoc.SequenciaItemDocumento	= idocft.SequenciaItemDocumento 
		INNER JOIN tbItemDocumentoTextos	idoctx
		ON	idoc.CodigoEmpresa		= idoctx.CodigoEmpresa
		AND	idoc.CodigoLocal		= idoctx.CodigoLocal
		AND	idoc.EntradaSaidaDocumento	= idoctx.EntradaSaidaDocumento
		AND	idoc.NumeroDocumento		= idoctx.NumeroDocumento
		AND	idoc.DataDocumento		= idoctx.DataDocumento
		AND	idoc.CodigoCliFor		= idoctx.CodigoCliFor
		AND	idoc.TipoLancamentoMovimentacao	= idoctx.TipoLancamentoMovimentacao
		AND	idoc.SequenciaItemDocumento	= idoctx.SequenciaItemDocumento 
		LEFT JOIN tbProduto prod 
		ON	prod.CodigoEmpresa		= idoc.CodigoEmpresa
		AND	prod.CodigoProduto		= idoc.CodigoProduto
		LEFT JOIN tbProdutoFT prodFT 
		ON	prod.CodigoEmpresa		= prodFT.CodigoEmpresa
		AND	prod.CodigoProduto		= prodFT.CodigoProduto
		LEFT JOIN tbVeiculoCV vcv 
		ON	vcv.CodigoEmpresa		= idoc.CodigoEmpresa 
		AND	vcv.CodigoLocal			= idoc.CodigoLocal 
		AND	vcv.NumeroVeiculoCV		= idoc.NumeroVeiculoCV 
		LEFT JOIN tbModeloVeiculoCV mvcv 
		ON	mvcv.CodigoEmpresa		= vcv.CodigoEmpresa
		AND	mvcv.ModeloVeiculo		= vcv.ModeloVeiculo
		LEFT JOIN tbTipoCombustivel tComb 
		ON	tComb.CodigoCombustivel		= mvcv.CodigoCombustivel 
		LEFT JOIN tbCategoriaVeiculoOS CatVeicOS 
		ON	mvcv.CodigoEmpresa		= CatVeicOS.CodigoEmpresa
		AND	mvcv.CodigoCategoriaVeiculoOS	= CatVeicOS.CodigoCategoriaVeiculoOS
		LEFT JOIN tbCoresVeiculos corveic 
		ON	corveic.CodigoEmpresa		= vcv.CodigoEmpresa 
		AND	corveic.AplicacaoCor		= 'E' 
		AND	corveic.CodigoCorVeic		= vcv.CodigoCorExternaVeiculoCV 
		LEFT JOIN tbMaoObraOS mos 
		ON	mos.CodigoEmpresa		= idoc.CodigoEmpresa 
		AND	mos.CodigoMaoObraOS		= idoc.CodigoMaoObraOS 
		INNER JOIN tbNaturezaOperacao nop 
		ON	nop.CodigoEmpresa		= idoc.CodigoEmpresa 
		AND	nop.CodigoNaturezaOperacao	= idoc.CodigoNaturezaOperacao 
		WHERE	idoc.CodigoEmpresa		= @CodigoEmpresa
		AND	idoc.CodigoLocal		= @CodigoLocal
--		AND	idoc.EntradaSaidaDocumento	= @EntradaSaida
		AND	idoc.NumeroDocumento		= @DocumentoOriginal
		AND	idoc.DataDocumento		= @DataOriginal
		AND	idoc.CodigoCliFor		= @CodigoCliFor
		AND	idoc.TipoLancamentoMovimentacao	= 7
	END
END


SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whPreItemDocumentoNFe TO SQLUsers
GO

go

if exists(select 1 from sysobjects where name = 'whRelFTVendasDescontos')
begin  drop proc dbo.whRelFTVendasDescontos	end
go

create proc dbo.whRelFTVendasDescontos
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 Empresa......: T-Systems
 Projeto......: DealerStarPlus / Faturamento
 Analista.....: Alex Sandro Ribeiro
 Procedure....: whRelFTVendasDescontos
 Utilizada em.: relFTVendasDescontos - Relação de vendas com desconto

 ---Data--- -----Responsável----- -----Descricao-----
 11/03/2004 Alex Sandro Ribeiro   Desenvolvimento inicial
 18/10/2005 Marcio Schvartz	  Incluido Devolucoes de Venda no total do relatorio
 15/02/2006 Marcio Schvartz	  Filtrado Devoluções de Venda por vendedor com relacionamento
				  na tbRepresentantePedido porque tabelas do documento 
				  (tbComissaoDocumento ou tbDoctoReceberRepresentante) nao existem 
-----------------------------------------------------------------------------------------------
 exec dbo.whRelFTVendasDescontos 	@CodigoEmpresa=1608,
					@CodigoLocal=0,
					@DataInicial='2009-01-01',
					@DataFinal='2009-12-31',
					@ClienteInicial=2,
					@ClienteFinal=99999999999999,
					@CCustoInicial=0,
					@PlanoPagtoInicial='',
					@PlanoPagtoFinal='ZZZZ',
					@CCustoFinal=99999999,
					@RepresentanteInicial=0,
					@RepresentanteFinal=9999,
					@PEC='F',
					@CLO='F',
					@MOB='F',
					@VEC='V',
					@OUT='F',
					@ComDesconto='V',
					@SemDesconto='V',
					@SomenteClientePrimeiraCompra = 'V'
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

	@CodigoEmpresa					dtInteiro04,
	@CodigoLocal					dtInteiro04,
	@DataInicial					char(10),
	@DataFinal						char(10),
	@ClienteInicial					numeric(14),
	@ClienteFinal					numeric(14),
	@CCustoInicial					numeric(8),
	@CCustoFinal					numeric(8),
	@PlanoPagtoInicial				varchar(4),
	@PlanoPagtoFinal				varchar(4),
	@RepresentanteInicial			numeric(6),
	@RepresentanteFinal				numeric(6),
	@PEC							char(1),
	@CLO							char(1),
	@MOB							char(1),
	@VEC							char(1),
	@OUT							char(1),
	@ComDesconto					char(1),
	@SemDesconto					char(1),
	@SomenteClientePrimeiraCompra	char(1)

WITH ENCRYPTION
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	----------------------------------------------------------------------
	-- Vendas
	----------------------------------------------------------------------
	select 	 doc.CodigoEmpresa		as CodigoEmpresa
		,doc.CodigoLocal			as CodigoLocal
		,0 							as TipoTotalizacao
		,doc.DataDocumento			as DataDocumento
		,doc.NumeroDocumento		as NumeroDocumento
		,doc.CodigoCliFor			as CodigoCliFor
		,dft.CentroCusto			as CentroCusto
		,dft.CodigoPlanoPagamento	as CodigoPlanoPagamento
		,doc.ValorContabilDocumento	as ValorContabilDocumento
		,dft.OrigemDocumentoFT		as OrigemDocumentoFT
		
		,case	when 	(select count(*) from tbItemDocumento itd 
				where	itd.CodigoEmpresa		= doc.CodigoEmpresa
				and	itd.CodigoLocal			= doc.CodigoLocal
				and	itd.EntradaSaidaDocumento	= doc.EntradaSaidaDocumento
				and	itd.DataDocumento		= doc.DataDocumento
				and	itd.CodigoCliFor		= doc.CodigoCliFor
				and	itd.NumeroDocumento		= doc.NumeroDocumento
				and	itd.TipoLancamentoMovimentacao  = doc.TipoLancamentoMovimentacao
				and	itd.TipoRegistroItemDocto	= 'PEC') > 0
			then	'V'
			else	'F'
		end			as TipoPEC

		,case	when 	(select count(*) from tbItemDocumento itd 
				where	itd.CodigoEmpresa		= doc.CodigoEmpresa
				and	itd.CodigoLocal			= doc.CodigoLocal
				and	itd.EntradaSaidaDocumento	= doc.EntradaSaidaDocumento
				and	itd.DataDocumento		= doc.DataDocumento
				and	itd.CodigoCliFor		= doc.CodigoCliFor
				and	itd.NumeroDocumento		= doc.NumeroDocumento
				and	itd.TipoLancamentoMovimentacao  = doc.TipoLancamentoMovimentacao
				and	itd.TipoRegistroItemDocto	= 'CLO') > 0
			then	'V'
			else	'F'
		end			as TipoCLO

		,case	when 	(select count(*) from tbItemDocumento itd 
				where	itd.CodigoEmpresa		= doc.CodigoEmpresa
				and	itd.CodigoLocal			= doc.CodigoLocal
				and	itd.EntradaSaidaDocumento	= doc.EntradaSaidaDocumento
				and	itd.DataDocumento		= doc.DataDocumento
				and	itd.CodigoCliFor		= doc.CodigoCliFor
				and	itd.NumeroDocumento		= doc.NumeroDocumento
				and	itd.TipoLancamentoMovimentacao  = doc.TipoLancamentoMovimentacao
				and	itd.TipoRegistroItemDocto	= 'MOB') > 0
			then	'V'
			else	'F'
		end			as TipoMOB

		,case	when	dft.OrigemDocumentoFT = 'CV'
			then	'V'
			else	'F'
		end			as TipoVEC

		,case	when 	(select count(*) from tbItemDocumento itd 
				where	itd.CodigoEmpresa		= doc.CodigoEmpresa
				and	itd.CodigoLocal			= doc.CodigoLocal
				and	itd.EntradaSaidaDocumento	= doc.EntradaSaidaDocumento
				and	itd.DataDocumento		= doc.DataDocumento
				and	itd.CodigoCliFor		= doc.CodigoCliFor
				and	itd.NumeroDocumento		= doc.NumeroDocumento
				and	itd.TipoLancamentoMovimentacao  = doc.TipoLancamentoMovimentacao
				and	itd.TipoRegistroItemDocto	= 'OUT') > 0
			then	'V'
			else	'F'
		end			as TipoOUT

		,(select sum((idoc.QtdeLancamentoItemDocto * idft.PrecoUnitarioOriginalItDocFT) - (idoc.ValorContabilItemDocto - idoc.ValorICMSSubstTribItemDocto))

		 from	tbItemDocumento idoc 
		 inner 	join tbItemDocumentoFT idft 
		 on	idft.CodigoEmpresa		 = idoc.CodigoEmpresa
		 and	idft.CodigoLocal		 = idoc.CodigoLocal
		 and	idft.EntradaSaidaDocumento	 = idoc.EntradaSaidaDocumento
		 and	idft.CodigoCliFor		 = idoc.CodigoCliFor
		 and	idft.DataDocumento		 = idoc.DataDocumento
		 and	idft.NumeroDocumento		 = idoc.NumeroDocumento
		 and	idft.TipoLancamentoMovimentacao  = idoc.TipoLancamentoMovimentacao
		 and	idft.SequenciaItemDocumento	 = idoc.SequenciaItemDocumento

		 where	idoc.CodigoEmpresa		 = doc.CodigoEmpresa
		 and	idoc.CodigoLocal		 = doc.CodigoLocal
		 and	idoc.EntradaSaidaDocumento	 = doc.EntradaSaidaDocumento
		 and	idoc.DataDocumento		 = doc.DataDocumento
		 and	idoc.CodigoCliFor		 = doc.CodigoCliFor
		 and	idoc.NumeroDocumento		 = doc.NumeroDocumento
		 and	idoc.TipoLancamentoMovimentacao  = doc.TipoLancamentoMovimentacao) as ValorDesconto

	into	#tmpVendasDescontos

	from 	tbDocumento 			doc 

	inner	join tbDocumentoFT 		dft 
	on	dft.CodigoEmpresa		= doc.CodigoEmpresa
 	and	dft.CodigoLocal			= doc.CodigoLocal
 	and	dft.EntradaSaidaDocumento	= doc.EntradaSaidaDocumento
 	and	dft.DataDocumento		= doc.DataDocumento
 	and	dft.CodigoCliFor		= doc.CodigoCliFor
 	and	dft.NumeroDocumento		= doc.NumeroDocumento
	and	dft.TipoLancamentoMovimentacao  = 7
 	and	dft.CentroCusto			between @CCustoInicial and @CCustoFinal
 	and    ((dft.CodigoPlanoPagamento is null)
 		or (dft.CodigoPlanoPagamento between @PlanoPagtoInicial and @PlanoPagtoFinal))

 	-------------------------------------------- selecao dos parametros recebidos
 	where	doc.CodigoEmpresa		= @CodigoEmpresa
 	and	doc.CodigoLocal			= @CodigoLocal
 	and	doc.DataDocumento 		between @DataInicial 	and @DataFinal
 	and	doc.CodigoCliFor		between @ClienteInicial and @ClienteFinal
 	and	doc.EntradaSaidaDocumento	= 'S'
 	and	doc.CondicaoNFCancelada		= 'F'
 	and	doc.TipoLancamentoMovimentacao  in (7,11)

	------------------------------------------- selecao do range de representante
	and	((dft.OrigemDocumentoFT = 'CV')

	or	exists(select * from tbComissaoDocumento rep 
			where	rep.CodigoEmpresa		= doc.CodigoEmpresa
			and	rep.CodigoLocal			= doc.CodigoLocal
			and	rep.EntradaSaidaDocumento	= doc.EntradaSaidaDocumento
			and	rep.DataDocumento		= doc.DataDocumento
			and	rep.CodigoCliFor		= doc.CodigoCliFor
			and	rep.NumeroDocumento		= doc.NumeroDocumento
			and	rep.TipoLancamentoMovimentacao  = doc.TipoLancamentoMovimentacao
			and	rep.CodigoRepresentante		between @RepresentanteInicial and @RepresentanteFinal)

	or	exists(select * from tbDoctoReceberRepresentante rep 
			where	rep.CodigoEmpresa		= doc.CodigoEmpresa
			and	rep.CodigoLocal			= doc.CodigoLocal
			and	rep.EntradaSaidaDocumento	= doc.EntradaSaidaDocumento
			and	rep.DataDocumento		= doc.DataDocumento
			and	rep.CodigoCliFor		= doc.CodigoCliFor
			and	rep.NumeroDocumento		= doc.NumeroDocumento
			and	rep.TipoLancamentoMovimentacao  = doc.TipoLancamentoMovimentacao
			and	rep.CodigoRepresentante		between @RepresentanteInicial and @RepresentanteFinal)
	)

	----------------------------------------------------------------------
	-- Devolucao das Vendas
	----------------------------------------------------------------------
	select 	 doc.CodigoEmpresa		as CodigoEmpresa
		,doc.CodigoLocal		as CodigoLocal
		,0 				as TipoTotalizacao
		,doc.DataDocumento		as DataDocumento
		,doc.NumeroDocumento		as NumeroDocumento
		,doc.CodigoCliFor		as CodigoCliFor
		,dft.CentroCusto		as CentroCusto
		,dft.CodigoPlanoPagamento	as CodigoPlanoPagamento
		,doc.ValorContabilDocumento 	as ValorContabilDocumento
		,dft.OrigemDocumentoFT		as OrigemDocumentoFT
		
		,case	when 	(select count(*) from tbItemDocumento itd 
				where	itd.CodigoEmpresa		= doc.CodigoEmpresa
				and	itd.CodigoLocal			= doc.CodigoLocal
				and	itd.EntradaSaidaDocumento	= doc.EntradaSaidaDocumento
				and	itd.DataDocumento		= doc.DataDocumento
				and	itd.CodigoCliFor		= doc.CodigoCliFor
				and	itd.NumeroDocumento		= doc.NumeroDocumento
				and	itd.TipoLancamentoMovimentacao  = doc.TipoLancamentoMovimentacao
				and	itd.TipoRegistroItemDocto	= 'PEC') > 0
			then	'V'
			else	'F'
		end			as TipoPEC

		,case	when 	(select count(*) from tbItemDocumento itd 
				where	itd.CodigoEmpresa		= doc.CodigoEmpresa
				and	itd.CodigoLocal			= doc.CodigoLocal
				and	itd.EntradaSaidaDocumento	= doc.EntradaSaidaDocumento
				and	itd.DataDocumento		= doc.DataDocumento
				and	itd.CodigoCliFor		= doc.CodigoCliFor
				and	itd.NumeroDocumento		= doc.NumeroDocumento
				and	itd.TipoLancamentoMovimentacao  = doc.TipoLancamentoMovimentacao
				and	itd.TipoRegistroItemDocto	= 'CLO') > 0
			then	'V'
			else	'F'
		end			as TipoCLO

		,case	when 	(select count(*) from tbItemDocumento itd 
				where	itd.CodigoEmpresa		= doc.CodigoEmpresa
				and	itd.CodigoLocal			= doc.CodigoLocal
				and	itd.EntradaSaidaDocumento	= doc.EntradaSaidaDocumento
				and	itd.DataDocumento		= doc.DataDocumento
				and	itd.CodigoCliFor		= doc.CodigoCliFor
				and	itd.NumeroDocumento		= doc.NumeroDocumento
				and	itd.TipoLancamentoMovimentacao  = doc.TipoLancamentoMovimentacao
				and	itd.TipoRegistroItemDocto	= 'MOB') > 0
			then	'V'
			else	'F'
		end			as TipoMOB

		,case	when	dft.OrigemDocumentoFT = 'CV'
			then	'V'
			else	'F'
		end			as TipoVEC

		,case	when 	(select count(*) from tbItemDocumento itd 
				where	itd.CodigoEmpresa		= doc.CodigoEmpresa
				and	itd.CodigoLocal			= doc.CodigoLocal
				and	itd.EntradaSaidaDocumento	= doc.EntradaSaidaDocumento
				and	itd.DataDocumento		= doc.DataDocumento
				and	itd.CodigoCliFor		= doc.CodigoCliFor
				and	itd.NumeroDocumento		= doc.NumeroDocumento
				and	itd.TipoLancamentoMovimentacao  = doc.TipoLancamentoMovimentacao
				and	itd.TipoRegistroItemDocto	= 'OUT') > 0
			then	'V'
			else	'F'
		end			as TipoOUT
		
		,(select sum((idoc.QtdeLancamentoItemDocto * idft.PrecoUnitarioOriginalItDocFT) - (idoc.ValorContabilItemDocto - idoc.ValorICMSSubstTribItemDocto))

		 from	tbItemDocumento idoc 
		 inner 	join tbItemDocumentoFT idft 
		 on	idft.CodigoEmpresa		 = idoc.CodigoEmpresa
		 and	idft.CodigoLocal		 = idoc.CodigoLocal
		 and	idft.EntradaSaidaDocumento	 = idoc.EntradaSaidaDocumento
		 and	idft.CodigoCliFor		 = idoc.CodigoCliFor
		 and	idft.DataDocumento		 = idoc.DataDocumento
		 and	idft.NumeroDocumento		 = idoc.NumeroDocumento
		 and	idft.TipoLancamentoMovimentacao  = idoc.TipoLancamentoMovimentacao
		 and	idft.SequenciaItemDocumento	 = idoc.SequenciaItemDocumento

		 where	idoc.CodigoEmpresa		 = doc.CodigoEmpresa
		 and	idoc.CodigoLocal		 = doc.CodigoLocal
		 and	idoc.EntradaSaidaDocumento	 = doc.EntradaSaidaDocumento
		 and	idoc.DataDocumento		 = doc.DataDocumento
		 and	idoc.CodigoCliFor		 = doc.CodigoCliFor
		 and	idoc.NumeroDocumento		 = doc.NumeroDocumento
		 and	idoc.TipoLancamentoMovimentacao  = doc.TipoLancamentoMovimentacao) as ValorDesconto


	into	#tmpDevolucaoVendasDescontos

	from 	tbDocumento 			doc 

	inner	join tbDocumentoFT 		dft 
	on	dft.CodigoEmpresa		= doc.CodigoEmpresa
 	and	dft.CodigoLocal			= doc.CodigoLocal
 	and	dft.EntradaSaidaDocumento	= doc.EntradaSaidaDocumento
 	and	dft.DataDocumento		= doc.DataDocumento
 	and	dft.CodigoCliFor		= doc.CodigoCliFor
 	and	dft.NumeroDocumento		= doc.NumeroDocumento
	and	dft.TipoLancamentoMovimentacao  = 7
 	and	dft.CentroCusto			between @CCustoInicial and @CCustoFinal
 	and    ((dft.CodigoPlanoPagamento is null) or (dft.CodigoPlanoPagamento between @PlanoPagtoInicial and @PlanoPagtoFinal))

	inner join tbNaturezaOperacao natoper 
	on 	natoper.CodigoEmpresa 		= dft.CodigoEmpresa
	and 	natoper.CodigoNaturezaOperacao	= dft.CodigoNaturezaOperacao
	and	natoper.CodigoTipoOperacao	in (7, 8)	-- devolucao de venda
	and 	natoper.EntradaSaidaNaturezaOperacao = 'E'	-- devolucao de venda

	inner join tbRepresentantePedido reprped 
	on	reprped.CodigoEmpresa = doc.CodigoEmpresa
	and	reprped.CodigoLocal = doc.CodigoLocal
	and 	reprped.CentroCusto = dft.CentroCusto
	and 	reprped.NumeroPedido = doc.NumeroPedidoDocumento
	and	reprped.SequenciaPedido = doc.NumeroSequenciaPedidoDocumento
	and 	reprped.CodigoRepresentante	between @RepresentanteInicial and @RepresentanteFinal

 	-------------------------------------------- selecao dos parametros recebidos
 	where	doc.CodigoEmpresa		= @CodigoEmpresa
 	and	doc.CodigoLocal				= @CodigoLocal
 	and	doc.DataDocumento 			between @DataInicial 	and @DataFinal
 	and	doc.CodigoCliFor			between @ClienteInicial and @ClienteFinal
 	and	doc.EntradaSaidaDocumento	= 'E'
 	and	doc.CondicaoNFCancelada		= 'F'
 	and	doc.TipoLancamentoMovimentacao  in (7,11)

	update #tmpVendasDescontos				set ValorDesconto = 0 where ValorDesconto < 0
	update #tmpDevolucaoVendasDescontos 	set ValorDesconto = 0 where ValorDesconto < 0

	update #tmpDevolucaoVendasDescontos 	set ValorContabilDocumento = ValorContabilDocumento * -1 where ValorContabilDocumento <> 0
	update #tmpDevolucaoVendasDescontos 	set ValorDesconto = ValorDesconto * -1 where ValorDesconto <> 0

	insert into #tmpVendasDescontos select * from #tmpDevolucaoVendasDescontos

	----------------------------------------------------------------------
	-- Geração da temporária que serão feitas as totalizações
	----------------------------------------------------------------------
	select	*
	into	#tmpFinal
	from	#tmpVendasDescontos 
	where 	1 = 2

	if @ComDesconto = 'V'
	begin
		insert into #tmpFinal
		select	*
		from	#tmpVendasDescontos 
		where	(  (@PEC = 'V' and TipoPEC = 'V')
			or (@CLO = 'V' and TipoCLO = 'V')
			or (@MOB = 'V' and TipoMOB = 'V')
			or (@VEC = 'V' and TipoVEC = 'V')
			or (@OUT = 'V' and TipoOUT = 'V'))
			and (ValorDesconto > 0 or ValorDesconto < 0)
	end

	if @SemDesconto = 'V'
	begin
		insert into #tmpFinal
		select	*
		from	#tmpVendasDescontos 
		where	(  (@PEC = 'V' and TipoPEC = 'V')
			or (@CLO = 'V' and TipoCLO = 'V')
			or (@MOB = 'V' and TipoMOB = 'V')
			or (@VEC = 'V' and TipoVEC = 'V')
			or (@OUT = 'V' and TipoOUT = 'V'))
			and (ValorDesconto = 0)
	end

	----------------------------------------------------------------------
	-- Totalizações por Centro de Custo
	----------------------------------------------------------------------
	insert	#tmpFinal
	select	doc.CodigoEmpresa	as CodigoEmpresa
		,doc.CodigoLocal		as CodigoLocal
		,1 						as TipoTotalizacao
		,'2099/12/31'			as DataDocumento
		,999999					as NumeroDocumento
		,99999999999999			as CodigoCliFor
		,doc.CentroCusto		as CentroCusto
		,null					as CodigoPlanoPagamento
		,sum(doc.ValorContabilDocumento)	as ValorContabilDocumento
		,null					as OrigemDocumentoFT
		,'X'					as TipoPEC
		,'X'					as TipoCLO
		,'X'					as TipoMOB
		,'X'					as TipoVEC
		,'X'					as TipoOUT
		,sum(doc.ValorDesconto) as ValorDesconto
	from 	#tmpFinal doc 
	where	TipoTotalizacao = 0
	group	by doc.CodigoEmpresa
		,doc.CodigoLocal
		,doc.CentroCusto
	order	by doc.CodigoEmpresa
		,doc.CodigoLocal
		,doc.CentroCusto

	----------------------------------------------------------------------
	-- Totalizações por Plano de Pagamento
	----------------------------------------------------------------------

	insert	#tmpFinal

	select	doc.CodigoEmpresa		as CodigoEmpresa
		,doc.CodigoLocal			as CodigoLocal
		,2 							as TipoTotalizacao
		,'2099/12/31'				as DataDocumento
		,999999						as NumeroDocumento
		,99999999999999				as CodigoCliFor
		,99999999					as CentroCusto
		,doc.CodigoPlanoPagamento	as CodigoPlanoPagamento
		,sum(doc.ValorContabilDocumento)	as ValorContabilDocumento
		,null					as OrigemDocumentoFT
		,'X'					as TipoPEC
		,'X'					as TipoCLO
		,'X'					as TipoMOB
		,'X'					as TipoVEC
		,'X'					as TipoOUT
		,sum(doc.ValorDesconto) 		as ValorDesconto

	from 	#tmpFinal doc 

	where	TipoTotalizacao = 0

	group	by doc.CodigoEmpresa
		,doc.CodigoLocal
		,doc.CodigoPlanoPagamento

	order	by doc.CodigoEmpresa
		,doc.CodigoLocal
		,doc.CodigoPlanoPagamento


	----------------------------------------------------------------------
	-- retorno dos dados conforme parametros de tipo/desconto.
	----------------------------------------------------------------------
	select	 doc.CodigoEmpresa
		,doc.CodigoLocal
		,doc.TipoTotalizacao
		,doc.DataDocumento
		,doc.NumeroDocumento
		,doc.CodigoCliFor
		,cli.NomeCliFor
		,doc.CentroCusto
		,ccu.DescricaoCentroCusto
		,isnull(doc.CodigoPlanoPagamento,'----') 		as CodigoPlanoPagamento
		,isnull(ppg.DescricaoPlanoPagamento,'VENDA DE VEÍCULO') as DescricaoPlanoPagamento
		,convert(numeric(12,2),doc.ValorContabilDocumento)	as ValorContabilDocumento
		,doc.TipoPEC
		,doc.TipoCLO
		,doc.TipoMOB
		,doc.TipoVEC
		,doc.TipoOUT
		,convert(numeric(12,2),doc.ValorDesconto)		as ValorDesconto
		,doc.OrigemDocumentoFT
		,
		case 	when doc.TipoTotalizacao = 0 then 
							case when doc.ValorContabilDocumento = 0
							then 0
							else convert(numeric(12,2),(doc.ValorDesconto / (doc.ValorContabilDocumento + doc.ValorDesconto ) * 100))
							end
			when doc.TipoTotalizacao <> 0 then 0
		end as PercDesc

	from	#tmpFinal doc
	
	left	join tbCentroCusto ccu 
	on	ccu.CodigoEmpresa	= doc.CodigoEmpresa
	and	ccu.CentroCusto		= doc.CentroCusto

	left	join tbPlanoPagamento ppg 
	on	ppg.CodigoEmpresa	 = doc.CodigoEmpresa
	and	ppg.CodigoPlanoPagamento = doc.CodigoPlanoPagamento

	left	join tbCliFor cli 
	on	cli.CodigoEmpresa	 = doc.CodigoEmpresa
	and	cli.CodigoCliFor	 = doc.CodigoCliFor

	where (    (@SomenteClientePrimeiraCompra = 'F')
			or (@SomenteClientePrimeiraCompra = 'V' 
				and ((select count(CodigoCliFor) from tbDocumento
							where	tbDocumento.CodigoEmpresa		= doc.CodigoEmpresa
 								and	tbDocumento.CodigoLocal			= doc.CodigoLocal
 								and	tbDocumento.DataDocumento 		between @DataInicial 	and @DataFinal
 								and	tbDocumento.CodigoCliFor		= doc.CodigoCliFor
 								and	tbDocumento.EntradaSaidaDocumento	= 'S'
 								and	tbDocumento.CondicaoNFCancelada		= 'F'
 								and	tbDocumento.TipoLancamentoMovimentacao  in (7,11)) = 1 ))
			)

	order	by	doc.CodigoEmpresa,
				doc.CodigoLocal,
				doc.TipoTotalizacao,
				doc.CentroCusto,
				doc.DataDocumento,
				doc.NumeroDocumento


SET NOCOUNT OFF

GO
---------------------------------------------------------------------------------- fim da proc
grant exec on dbo.whRelFTVendasDescontos to SQLUsers
GO

go

if exists(select 1 from sysobjects where id = object_id('whRelLFNotasFiscaisCanceladas'))
DROP PROCEDURE dbo.whRelLFNotasFiscaisCanceladas
GO
-- whRelLFNotasFiscaisCanceladas 1608,0,0,'2007-01-01', '2007-07-31'

CREATE PROCEDURE dbo.whRelLFNotasFiscaisCanceladas

/*INICIO_CABEC_PROC
----------------------------------------------------------------------
 EMPRESA......: CDC - Consulters/Humaita
 PROJETO......: Livros Fiscais
 AUTOR........: Rubens Jose Soares Fortunato
 DATA.........: 07/07/1999
 UTILIZADO EM : LFNotasFiscaisCanceladas.rpt
 OBJETIVO.....: Trazer a relacao de Notas Ficais Canceladas

 ALTERACAO....: Fabiane - 06/10/1999
 OBJETIVO.....: Insercao do SELECT ref. aos registros TipoLanc. 11,
		com valores do respectivo docto. emitido (TipoLanc.7)
 ALTERACAO....: Fabiane - 08/10/1999
 OBJETIVO.....: Insercao do SELECT ref. aos registros TipoLanc. 12,
		com valores do respectivo docto. emitido (TipoLanc.10)
 ALTERACAO....: Carlos - 05/12/2006
 OBJETIVO.....: Possibilitar a impressao dos valores da NF canceladas na mesma data.

 ALTERACAO....: Marcelo Bueno - 01/03/2007
 OBJETIVO.....: Trazer motivo de cancelamento (GS3)

 dbo.whRelLFNotasFiscaisCanceladas 1608,0,0,'2009-04-01','2009-04-01'

select * from tbDocumento where ObservacaoDocumento 		LIKE 'CANC%' and CodigoEmpresa = 1608 and EntradaSaidaDocumento = 'S'
select * from tbDocumento where NumeroDocumento = 805357
select * from tbDocumentoFT where NumeroDocumento = 805357
select * from tbPedido where NumeroPedido = 52624
----------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa  dtInteiro04,
@DoCodigoLocal 	dtInteiro04,
@AteCodigoLocal dtInteiro04,
@DoDia		DATETIME,
@AteDia 	DATETIME

WITH ENCRYPTION

AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT  
	D.CodigoLocal,
	DescricaoLocal,
	D.NumeroDocumento,
	D.CodigoCliFor,
	NomeCliFor,
	DataEmissao = D.DataDocumento,
	DataCancelamento = ISNULL( (
				SELECT
					MIN( DataDocumento )
				FROM
					tbDocumento (NOLOCK)
				WHERE
					CodigoEmpresa 			= D.CodigoEmpresa
					AND CodigoLocal			= D.CodigoLocal
					AND EntradaSaidaDocumento	= D.EntradaSaidaDocumento
					AND NumeroDocumento		= D.NumeroDocumento
					AND CodigoCliFor		= D.CodigoCliFor
					AND TipoLancamentoMovimentacao	= 11
					AND EspecieDocumento = D.EspecieDocumento
				), D.DataDocumento ),
	ValorEmissao =0,
	ValorIPI = 0,
	ValorICMS = 0,
	ValorISS = 0,
	CodigoServico = ( 
			SELECT
				CodigoServicoISSItemDocto
			FROM
				tbItemDocumento ID (NOLOCK)
			WHERE
				CodigoEmpresa 			= D.CodigoEmpresa
				AND CodigoLocal			= D.CodigoLocal
				AND EntradaSaidaDocumento	= D.EntradaSaidaDocumento
				AND NumeroDocumento		= D.NumeroDocumento
				AND DataDocumento		= D.DataDocumento
				AND CodigoCliFor		= D.CodigoCliFor
				AND TipoLancamentoMovimentacao	= D.TipoLancamentoMovimentacao
				AND SequenciaItemDocumento	= (
								SELECT
									MIN(SequenciaItemDocumento)
								FROM
									tbItemDocumento(NOLOCK)
								WHERE
									CodigoEmpresa 			= ID.CodigoEmpresa
									AND CodigoLocal			= ID.CodigoLocal
									AND EntradaSaidaDocumento	= ID.EntradaSaidaDocumento
									AND NumeroDocumento		= ID.NumeroDocumento
									AND DataDocumento		= ID.DataDocumento
									AND CodigoCliFor		= ID.CodigoCliFor
									AND TipoLancamentoMovimentacao	= ID.TipoLancamentoMovimentacao
									AND CodigoServicoISSItemDocto 	<> 0
								)
				AND CodigoServicoISSItemDocto 	<> 0
			),
	CASE WHEN RTRIM(LTRIM(DTX.MotivoCancelamento)) <> '' AND DTX.MotivoCancelamento IS NOT NULL THEN
		MotivoCancelamento
	ELSE
		ObservacaoOrdemSeparacaoDocT
	END AS MotivoCancelamento,
	L.UtilizaGS3
FROM
	tbDocumento D (NOLOCK)
	INNER JOIN tbLocal L (NOLOCK)ON
		L.CodigoEmpresa 			= D.CodigoEmpresa 
		AND L.CodigoLocal 			= D.CodigoLocal
	INNER JOIN tbCliFor CF (NOLOCK)ON
		CF.CodigoEmpresa 			= D.CodigoEmpresa 
		AND CF.CodigoCliFor 			= D.CodigoCliFor
	LEFT JOIN tbPedido P (NOLOCK)ON
		P.CodigoEmpresa 			= D.CodigoEmpresa 
		AND P.CodigoLocal 			= D.CodigoLocal
		AND P.NumeroNotaFiscalPed		= D.NumeroDocumento
	LEFT JOIN tbPedidoVenda PV (NOLOCK)ON
		P.CodigoEmpresa 			= PV.CodigoEmpresa
		AND P.CodigoLocal 			= PV.CodigoLocal
		AND P.CentroCusto 			= PV.CentroCusto
		AND P.NumeroPedido 			= PV.NumeroPedido
		AND P.SequenciaPedido 			= PV.SequenciaPedido
	LEFT JOIN  tbDocumentoFT FT (NOLOCK)ON
		FT.CodigoEmpresa			= D.CodigoEmpresa
		AND FT.CodigoLocal			= D.CodigoLocal
		AND FT.CodigoCliFor			= D.CodigoCliFor	
		AND FT.EntradaSaidaDocumento		= D.EntradaSaidaDocumento
		AND FT.NumeroDocumento			= D.NumeroDocumento
		AND FT.DataDocumento			= D.DataDocumento
		AND FT.TipoLancamentoMovimentacao	= D.TipoLancamentoMovimentacao
	LEFT JOIN  tbDocumentoTextos DTX (NOLOCK)ON
		DTX.CodigoEmpresa			= D.CodigoEmpresa
		AND DTX.CodigoLocal			= D.CodigoLocal
		AND DTX.CodigoCliFor			= D.CodigoCliFor	
		AND DTX.EntradaSaidaDocumento		= D.EntradaSaidaDocumento
		AND DTX.NumeroDocumento			= D.NumeroDocumento
		AND DTX.DataDocumento			= D.DataDocumento
		AND DTX.TipoLancamentoMovimentacao	= D.TipoLancamentoMovimentacao

WHERE
	D.CodigoEmpresa 			= @CodigoEmpresa
	AND D.CodigoLocal 			BETWEEN @DoCodigoLocal AND @AteCodigoLocal
	AND D.DataDocumento 			BETWEEN @DoDia AND @AteDia 
	AND D.EntradaSaidaDocumento 		IN ('S','E')
	AND D.TipoLancamentoMovimentacao 	IN (7)
	AND DTX.ObservacaoDocumento 		LIKE 'CANC%'

	
/*ORDER BY
	D.CodigoLocal,
	D.NumeroDocumento,
	D.CodigoCliFor,
	D.DataDocumento*/

UNION

/* 	Registros cancelados (TipoLancamentoMovimentacao = 11) com valores retirados
	da tabela tbDocumento (TipoLancamentoMovimentacao = 7 -> para que n¦o venha zerado), 
	ao invés da tabela tbPedidos.*/
SELECT	
	D.CodigoLocal,
	DescricaoLocal,
	D.NumeroDocumento,
	D.CodigoCliFor,
	CF.NomeCliFor,
	DataEmissao = D.DataDocumento,
	DataCancelamento = ISNULL( (
				SELECT
					MIN( DataDocumento )
				FROM
					tbDocumento(NOLOCK)
				WHERE
					CodigoEmpresa 			= D.CodigoEmpresa
					AND CodigoLocal			= D.CodigoLocal
					AND EntradaSaidaDocumento	= D.EntradaSaidaDocumento
					AND NumeroDocumento		= D.NumeroDocumento
					AND CodigoCliFor		= D.CodigoCliFor					
					AND TipoLancamentoMovimentacao	= 11
					AND EspecieDocumento = D.EspecieDocumento
				), D.DataDocumento ),
	ValorEmissao = ISNULL(D.ValorContabilDocumento,0),
	ValorIPI = ISNULL(D.ValorIPIDocumento,0),
	ValorICMS = ISNULL(D.ValorICMSDocumento,0),
	--ValorISS = ISNULL(D.ValorISSDocumento,0),
	ValorISS = CASE
		WHEN	OP.RetemISSPrefeitura = 'V' THEN
			CASE
			WHEN	(LF.TipoImpressaoNFCancelada = 4) AND
				(D.CondicaoNFCancelada = 'V') THEN
					0
			ELSE
				ISNULL(D.ValorISSDocumento,0)
			END
		ELSE
				D.ValorISSDocumento
		END,
	CodigoServico = ( 
			SELECT
				CodigoServicoISSItemDocto
			FROM
				tbItemDocumento ID(NOLOCK)
			WHERE
				CodigoEmpresa 			= D.CodigoEmpresa
				AND CodigoLocal			= D.CodigoLocal
				AND EntradaSaidaDocumento	= D.EntradaSaidaDocumento
				AND NumeroDocumento		= D.NumeroDocumento
				AND DataDocumento		= D.DataDocumento
				AND CodigoCliFor		= D.CodigoCliFor
				AND TipoLancamentoMovimentacao	= D.TipoLancamentoMovimentacao
				AND SequenciaItemDocumento	= (
								SELECT
									MIN(SequenciaItemDocumento)
								FROM
									tbItemDocumento(NOLOCK)
								WHERE
									CodigoEmpresa 			= ID.CodigoEmpresa
									AND CodigoLocal			= ID.CodigoLocal
									AND EntradaSaidaDocumento	= ID.EntradaSaidaDocumento
									AND NumeroDocumento		= ID.NumeroDocumento
									AND DataDocumento		= ID.DataDocumento
									AND CodigoCliFor		= ID.CodigoCliFor
									AND TipoLancamentoMovimentacao	= ID.TipoLancamentoMovimentacao
									AND CodigoServicoISSItemDocto 	<> 0
								)
				AND CodigoServicoISSItemDocto 	<> 0
			),
	CASE WHEN ( RTRIM(LTRIM(DTX.MotivoCancelamento)) = '' OR DTX.MotivoCancelamento IS NULL ) AND
			  ( RTRIM(LTRIM(DTX.ObservacaoOrdemSeparacaoDocT)) = '' OR DTX.ObservacaoOrdemSeparacaoDocT IS NULL ) THEN
				( SELECT
					MIN(MotivoCancelamento)
				FROM
					tbDocumentoTextos(NOLOCK)
				WHERE
					CodigoEmpresa 			= D.CodigoEmpresa
					AND CodigoLocal			= D.CodigoLocal
					AND EntradaSaidaDocumento	= D.EntradaSaidaDocumento
					AND NumeroDocumento		= D.NumeroDocumento
					AND CodigoCliFor		= D.CodigoCliFor					
					AND TipoLancamentoMovimentacao	= 11
					AND EspecieDocumento = D.EspecieDocumento)
	ELSE
		CASE WHEN RTRIM(LTRIM(DTX.MotivoCancelamento)) <> '' AND DTX.MotivoCancelamento IS NOT NULL THEN
			MotivoCancelamento
		ELSE
			ObservacaoOrdemSeparacaoDocT
		END 
	END AS MotivoCancelamento,
	L.UtilizaGS3
FROM
	tbDocumento D(NOLOCK)
	INNER JOIN tbLocal L(NOLOCK) ON
		L.CodigoEmpresa 			= D.CodigoEmpresa 
		AND L.CodigoLocal 			= D.CodigoLocal
	INNER JOIN tbCliFor CF (NOLOCK)ON
		CF.CodigoEmpresa 			= D.CodigoEmpresa 
		AND CF.CodigoCliFor 			= D.CodigoCliFor
	INNER JOIN tbLocalLF LF (NOLOCK)ON
        	LF.CodigoEmpresa			= D.CodigoEmpresa
		AND LF.CodigoLocal 			= D.CodigoLocal
	LEFT JOIN  tbDocumentoFT FT (NOLOCK)ON
		FT.CodigoEmpresa			= D.CodigoEmpresa
		AND FT.CodigoLocal			= D.CodigoLocal
		AND FT.CodigoCliFor			= D.CodigoCliFor	
		AND FT.EntradaSaidaDocumento		= D.EntradaSaidaDocumento
		AND FT.NumeroDocumento			= D.NumeroDocumento
		AND FT.DataDocumento			= D.DataDocumento
		AND FT.TipoLancamentoMovimentacao	= D.TipoLancamentoMovimentacao
	LEFT JOIN  tbDocumentoTextos DTX (NOLOCK)ON
		DTX.CodigoEmpresa			= D.CodigoEmpresa
		AND DTX.CodigoLocal			= D.CodigoLocal
		AND DTX.CodigoCliFor			= D.CodigoCliFor	
		AND DTX.EntradaSaidaDocumento		= D.EntradaSaidaDocumento
		AND DTX.NumeroDocumento			= D.NumeroDocumento
		AND DTX.DataDocumento			= D.DataDocumento
		AND DTX.TipoLancamentoMovimentacao	= D.TipoLancamentoMovimentacao
	LEFT JOIN tbNaturezaOperacao OP (NOLOCK)ON
		OP.CodigoEmpresa = D.CodigoEmpresa AND
		OP.CodigoNaturezaOperacao = FT.CodigoNaturezaOperacao
	
WHERE
	D.CodigoEmpresa 			= @CodigoEmpresa
	AND D.CodigoLocal 			BETWEEN @DoCodigoLocal AND @AteCodigoLocal	
--	AND D.DataDocumento			BETWEEN @DoDia AND @AteDia 

	AND (EXISTS (SELECT 1 FROM tbDocumento (NOLOCK)
				WHERE 	CodigoEmpresa 			= D.CodigoEmpresa
					AND CodigoLocal			= D.CodigoLocal
					AND EntradaSaidaDocumento	= D.EntradaSaidaDocumento
					AND NumeroDocumento		= D.NumeroDocumento
					AND CodigoCliFor		= D.CodigoCliFor	
					AND DataDocumento		BETWEEN @DoDia AND @AteDia 
					AND TipoLancamentoMovimentacao	= 11
					AND EspecieDocumento = D.EspecieDocumento))
	AND 	(D.TipoLancamentoMovimentacao 	= 7
		AND (EXISTS (SELECT 1 FROM tbItemDocumento(NOLOCK) WHERE CodigoEmpresa 	= D.CodigoEmpresa
					AND CodigoLocal			= D.CodigoLocal
					AND EntradaSaidaDocumento	= D.EntradaSaidaDocumento
					AND NumeroDocumento		= D.NumeroDocumento
					AND CodigoCliFor		= D.CodigoCliFor					
					AND TipoLancamentoMovimentacao	= 11)))
	AND
	(NOT EXISTS (SELECT 1 FROM tbItemDocumento(NOLOCK) WHERE CodigoEmpresa 	= D.CodigoEmpresa
					AND CodigoLocal			= D.CodigoLocal
					AND EntradaSaidaDocumento	= D.EntradaSaidaDocumento
					AND NumeroDocumento		= D.NumeroDocumento
					AND CodigoCliFor		= D.CodigoCliFor					
					AND DataDocumento               = D.DataDocumento
					AND TipoLancamentoMovimentacao	= 11))


UNION

/* 	Registros cancelados (TipoLancamentoMovimentacao = 12) com valores retirados
	da tabela tbDocumento (TipoLancamentoMovimentacao = 10 -> para que n¦o venha zerado), 
	ao invés da tabela tbPedidos.*/
SELECT	
	D.CodigoLocal,
	DescricaoLocal,
	D.NumeroDocumento,
	D.CodigoCliFor,
	NomeCliFor,
	DataEmissao = D.DataDocumento,
	DataCancelamento = ISNULL( (
				SELECT
					MIN( DataDocumento )
				FROM
					tbDocumento(NOLOCK)
				WHERE
					CodigoEmpresa 			= D.CodigoEmpresa
					AND CodigoLocal			= D.CodigoLocal
					AND EntradaSaidaDocumento	= D.EntradaSaidaDocumento
					AND NumeroDocumento		= D.NumeroDocumento
					AND CodigoCliFor		= D.CodigoCliFor					
					AND TipoLancamentoMovimentacao	= 12
					AND EspecieDocumento = D.EspecieDocumento
				), D.DataDocumento ),
	ValorEmissao = ISNULL(D.ValorContabilDocumento,0),
	ValorIPI = ISNULL(D.ValorIPIDocumento,0),
	ValorICMS = ISNULL(D.ValorICMSDocumento,0),
--	ValorISS = ISNULL(D.ValorISSDocumento,0),
	ValorISS = CASE
		WHEN	OP.RetemISSPrefeitura = 'V' THEN
			CASE
			WHEN	(LF.TipoImpressaoNFCancelada = 4) AND
				(D.CondicaoNFCancelada = 'V') THEN
					0
			ELSE
				ISNULL(D.ValorISSDocumento,0)
			END
		ELSE
				0
		END,
	CodigoServico = ( 
			SELECT
				CodigoServicoISSItemDocto
			FROM
				tbItemDocumento ID(NOLOCK)
			WHERE
				CodigoEmpresa 			= D.CodigoEmpresa
				AND CodigoLocal			= D.CodigoLocal
				AND EntradaSaidaDocumento	= D.EntradaSaidaDocumento
				AND NumeroDocumento		= D.NumeroDocumento
				AND DataDocumento		= D.DataDocumento
				AND CodigoCliFor		= D.CodigoCliFor
				AND TipoLancamentoMovimentacao	= D.TipoLancamentoMovimentacao
				AND SequenciaItemDocumento	= (
								SELECT
									MIN(SequenciaItemDocumento)
								FROM
									tbItemDocumento(NOLOCK)
								WHERE
									CodigoEmpresa 			= ID.CodigoEmpresa
									AND CodigoLocal			= ID.CodigoLocal
									AND EntradaSaidaDocumento	= ID.EntradaSaidaDocumento
									AND NumeroDocumento		= ID.NumeroDocumento
									AND DataDocumento		= ID.DataDocumento
									AND CodigoCliFor		= ID.CodigoCliFor
									AND TipoLancamentoMovimentacao	= ID.TipoLancamentoMovimentacao
									AND CodigoServicoISSItemDocto 	<> 0
								)
				AND CodigoServicoISSItemDocto 	<> 0
			),
	CASE WHEN RTRIM(LTRIM(DTX.MotivoCancelamento)) <> '' AND DTX.MotivoCancelamento IS NOT NULL THEN
		MotivoCancelamento
	ELSE
		ObservacaoOrdemSeparacaoDocT
	END AS MotivoCancelamento,
	L.UtilizaGS3
FROM
	tbDocumento D(NOLOCK)
	INNER JOIN tbLocal L (NOLOCK)ON
		L.CodigoEmpresa 			= D.CodigoEmpresa 
		AND L.CodigoLocal 			= D.CodigoLocal
	INNER JOIN tbCliFor CF (NOLOCK)ON
		CF.CodigoEmpresa 			= D.CodigoEmpresa 
		AND CF.CodigoCliFor 			= D.CodigoCliFor
	INNER JOIN tbLocalLF LF (NOLOCK)ON
        	LF.CodigoEmpresa			= D.CodigoEmpresa
		AND LF.CodigoLocal 			= D.CodigoLocal
	LEFT JOIN  tbDocumentoFT FT (NOLOCK)ON
		FT.CodigoEmpresa			= D.CodigoEmpresa
		AND FT.CodigoLocal			= D.CodigoLocal
		AND FT.CodigoCliFor			= D.CodigoCliFor	
		AND FT.EntradaSaidaDocumento		= D.EntradaSaidaDocumento
		AND FT.NumeroDocumento			= D.NumeroDocumento
		AND FT.DataDocumento			= D.DataDocumento
		AND FT.TipoLancamentoMovimentacao	= D.TipoLancamentoMovimentacao
	LEFT JOIN  tbDocumentoTextos DTX (NOLOCK)ON
		DTX.CodigoEmpresa			= D.CodigoEmpresa
		AND DTX.CodigoLocal			= D.CodigoLocal
		AND DTX.CodigoCliFor			= D.CodigoCliFor	
		AND DTX.EntradaSaidaDocumento		= D.EntradaSaidaDocumento
		AND DTX.NumeroDocumento			= D.NumeroDocumento
		AND DTX.DataDocumento			= D.DataDocumento
		AND DTX.TipoLancamentoMovimentacao	= D.TipoLancamentoMovimentacao
	LEFT JOIN tbNaturezaOperacao OP (NOLOCK)ON
		OP.CodigoEmpresa = D.CodigoEmpresa AND
		OP.CodigoNaturezaOperacao = FT.CodigoNaturezaOperacao
	
WHERE
	D.CodigoEmpresa 			= @CodigoEmpresa
	AND D.CodigoLocal 			BETWEEN @DoCodigoLocal AND @AteCodigoLocal	
--	AND D.DataDocumento			BETWEEN @DoDia AND @AteDia 

	AND (EXISTS (SELECT 1 FROM tbDocumento (NOLOCK)
				WHERE 	CodigoEmpresa 			= D.CodigoEmpresa
					AND CodigoLocal			= D.CodigoLocal
					AND EntradaSaidaDocumento	= D.EntradaSaidaDocumento
					AND NumeroDocumento		= D.NumeroDocumento
					AND CodigoCliFor		= D.CodigoCliFor	
					AND DataDocumento		BETWEEN @DoDia AND @AteDia 
					AND TipoLancamentoMovimentacao	= 12
					AND EspecieDocumento = D.EspecieDocumento))
	AND D.EntradaSaidaDocumento 		= 'S'
	AND 	(D.TipoLancamentoMovimentacao 	= 10
		AND (EXISTS (SELECT 1 FROM tbDocumento(NOLOCK) WHERE CodigoEmpresa 	= D.CodigoEmpresa
					AND CodigoLocal			= D.CodigoLocal
					AND EntradaSaidaDocumento	= D.EntradaSaidaDocumento
					AND NumeroDocumento		= D.NumeroDocumento
					AND CodigoCliFor		= D.CodigoCliFor					
					AND TipoLancamentoMovimentacao	= 12
					AND EspecieDocumento = D.EspecieDocumento)))

ORDER BY
	D.CodigoLocal,
	D.NumeroDocumento,
	D.CodigoCliFor,
	D.DataDocumento

SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whRelLFNotasFiscaisCanceladas TO SQLUsers
GO

go

if exists(select 1 from sysobjects where id = object_id('rtRelOSSituacao'))
	drop TABLE dbo.rtRelOSSituacao
go
CREATE TABLE dbo.rtRelOSSituacao (	
				CodigoEmpresa		NUMERIC(4)		NULL,
				RazaoSocialEmpresa	char(60)		NULL,
				CodigoLocal			NUMERIC(4)		NULL,
				DescricaoLocal		char(30)		NULL,
				StatusOSCIT			CHAR(1)			NULL,
				StatusRel			CHAR(1)			NULL,
				CodigoCIT 			CHAR(4)			NULL,
				NumeroOROS			NUMERIC(6)		NULL, 
			    CodigoCliFor        NUMERIC(14)     NULL,
				NomeCliFor			char(60)		NULL, 		
				PlacaVeiculoOS		CHAR(10)		NULL,
				DataAberturaOS		DATETIME		NULL,
				NumeroNotaFiscalMOB	numeric(6)      NULL,
				NumeroNotaFiscalPEC	numeric(6)      NULL,
				DataEmissaoNotaFiscalOS DATETIME	NULL,
				ValorPecas			MONEY			NULL,
				ValorCombLub		MONEY			NULL,
				ValorMaoObra		MONEY			NULL,
                ValorIPIDocumento   MONEY			NULL,
				ValorLiquidoOS		MONEY			NULL,
				CodigoRepresentante	numeric(4)		NULL,
				NomeRepresentante	char(60)		NULL, 
				MotivoCancelamentoOS char(255)		NULL, 
				NumeroFrotaVeiculo 	CHAR(10)		NULL,
				DataEncerramentoOS	DATETIME		NULL,
				CentroCusto			NUMERIC(8)      NULL,
				ValorISSRetido		dtValorMonetario NULL,
				TipoRevisaoOS		char(3)			NULL,
				CondicaoRetencaoISS char(1)         NULL)

go
grant all on dbo.rtRelOSSituacao to SQLUsers
go
if exists(select 1 from sysobjects where id = object_id('whRelOSSituacao'))
DROP PROCEDURE dbo.whRelOSSituacao
GO
CREATE PROCEDURE dbo.whRelOSSituacao

/*INICIO_CABEC_PROC

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 EMPRESA......: CDC - Consulters/Humaita
 PROJETO......: Oficina
 AUTOR........: Siu Guin Moo
 DATA.........: 03/07/1998
 UTILIZADO EM : <classe/modulo>.<metodo>
 OBJETIVO.....: Lista campos para o relatorio Ordem de Servico por Situacao
 ALTERACAO....: Obede 21.07.1999/24.08.1999
 OBJETIVO.....: ajustes
 ALTERACAO....: Arnaldo 24.09.1999
 OBJETIVO.....: Agrupar por CIT e ordenar por NumeroOROS

 ALTERAÇÃO....: Carlos Cavalcanti
 DATA.........: 09/09/2009 - Impressão do Numero de todas as NF emitidas para a OS/CIT

 dbo.whRelOSSituacao 'A',null,null,null,null,' ','ZZZZ',1608,0,1,' ','ZZZZZZZZZ',0,9999999999999,'O',0,99999999,0,9999,0,9999999999999,'V','2009-09-30','2009-09-30','V','V'
 dbo.whRelOSSituacao 'A', 'Oct  1 2009 12:00:00:000AM', 'Oct 31 2009 11:59:59:000PM', 'Oct  1 2009 12:00:00:000AM', 'Oct 31 2009 11:59:59:000PM', '    ', 'ZZZZ', 1608, 0, 1, '          ', 'ZZZZZZZZZZ', '1             ', '99999999999999', 'S', 0, 99999999, 0, 9999, '1             ', '99999999999999', 'F', 'Jan  1 1900 12:00:00:000AM', 'Dec 31 2500 11:59:59:000PM', 'V', 'F'

 dbo.whRelOSSituacao 'T', 'Oct  1 2009 12:00:00:000AM', 'Oct 31 2009 11:59:59:000PM', 'Sep  1 2009 12:00:00:000AM', 'Sep 30 2009 11:59:59:000PM', '    ', 'ZZZZ', 1608, 0, 1, '          ', 'ZZZZZZZZZZ', '1             ', '99999999999999', 'S', 0, 99999999, 0, 9999, '1             ', '99999999999999', 'F', null, null, 'V', 'F'
 dbo.whRelOSSituacao 'T','2009-12-01 00:00:00:000','2009-12-22 23:59:59:000','2009-12-01 00:00:00:000','2009-12-22 23:59:59:000','    ','ZZZZ',1608,0,1,'          ','ZZZZZZZZZZ','1             ','99999999999999','S',0,99999999,0,9999,'1             ','99999999999999','F',NULL,NULL,'V','V','                      ','ZZZZZZZZZZZZZZZZZZZZZZ','                      ','ZZZZZZZZZZZZZZZZZZZZZZ'

 dbo.whRelOSSituacao 'A',NULL,NULL,NULL,NULL,'C100','C100',1608,0,1,'          ','ZZZZZZZZZZ','1             ','99999999999999','S',0,99999999,0,9999,'1             ','99999999999999','F',NULL,NULL,'V','V','                      ','ZZZZZZZZZZZZZZZZZZZZZZ','                      ','ZZZZZZZZZZZZZZZZZZZZZZ'

-----------------'-----------------------------------------------------------------------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@Status						dtCharacter01,
@DataAberturaPartir			datetime = Null,
@DataAberturaAte      		datetime = Null,
@DataEncerramentoPartir		datetime = Null,
@DataEncerramentoAte		datetime = Null,
@CITPartir					char(4) = '',
@CITAte   					char(4) = '',
@CodigoEmpresa				dtInteiro04,
@CodigoLocal   				dtInteiro04,
@Ordenacao					dtInteiro01,
@DaPlaca					char(10),
@AtePlaca					char(10),
@DoCliente					char(14),
@AteCliente					char(14),
@FlagOROS					char(1),
@DoCentroCusto				dtInteiro08 = NULL,
@AteCentroCusto				dtInteiro08 = NULL,
@RepresentantePartir		dtInteiro04 = null,
@RepresentanteAte			dtInteiro04 = null,
@DoClientePro				char(14) = null,
@AteClientePro				char(14) = null,
@PreOrdemServico			char(1),
@DaDataEntrada				datetime = Null,
@AteDataEntrada      		datetime = Null,
@ImprimePecaOS				char(1),
@ImprimeMaoObraOS			char(1),
@DoCLMA					    char(22) = Null,
@AteCLMA					char(22) = Null,
@DoCLMO					    char(22) = Null,
@AteCLMO					char(22) = Null

WITH ENCRYPTION
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @IntegradoMainframe	  char(1)
declare @NotaFiscalServico	  numeric(6)
declare @NotaFiscalPecas	  numeric(6)

--if @DaDataEntrada is null select @DaDataEntrada = @DataAberturaPartir
--if @AteDataEntrada is null select @AteDataEntrada = @DataAberturaAte

select @DataAberturaPartir = convert(char,@DataAberturaPartir,120)
select @DataAberturaAte = convert(char,@DataAberturaAte,120)
select @DataEncerramentoPartir = convert(char,@DataEncerramentoPartir,120)
select @DataEncerramentoAte = convert(char,@DataEncerramentoAte,120)
select @DaDataEntrada = convert(char,@DaDataEntrada,120)
select @AteDataEntrada = convert(char,@AteDataEntrada,120)

-------------  Setar da inicio e termino default quando não informado na tela.
if @DaDataEntrada				is null select @DaDataEntrada = '1900-01-01'
if @AteDataEntrada				is null select @AteDataEntrada = '2500-12-31'
if @DataAberturaPartir			is null select @DataAberturaPartir = '1900-01-01'
if @DataAberturaAte				is null select @DataAberturaAte = '2500-12-31'
if @DataEncerramentoPartir		is null select @DataEncerramentoPartir = '1900-01-01'
if @DataEncerramentoAte			is null select @DataEncerramentoAte = '2500-12-31'

IF @DoCentroCusto IS NULL SELECT @DoCentroCusto = 0 
IF @AteCentroCusto IS NULL SELECT @AteCentroCusto = 99999999 
IF @RepresentantePartir	is null select @RepresentantePartir = 0 
IF @RepresentanteAte is null select @RepresentanteAte = 9999 
IF @DoClientePro is null select @DoClientePro = 0 
IF @AteClientePro is null select @AteClientePro = 99999999999999 
if @DoCLMA is null select @DoCLMA = ''
if @AteCLMA is null select @AteCLMA = 'zzzzzzzzzzzzzzzzzzzzzz'
if @DoCLMO is null  select @DoCLMO = ''
if @AteCLMO is null  select @AteCLMO = 'zzzzzzzzzzzzzzzzzzzzzz'

SELECT @IntegradoMainframe = (  Select IntegradoMainframeFabrica 
				from tbLocalOS  (nolock)
				where tbLocalOS.CodigoEmpresa = @CodigoEmpresa
				And   tbLocalOS.CodigoLocal   = @CodigoLocal)

truncate table rtRelOSSituacao
 

---Crio tab. temporaria para fazer nela depois, um GROUPBY por OS e
---totalizar as colunas ValorPecas e ValorMaoObra.

--Para os tipos na combo do form = 'A'ndamento.
IF @Status = 'A' OR @Status = 'L' OR @Status = 'P' OR @Status = 'R'
BEGIN
	INSERT INTO rtRelOSSituacao
	
	SELECT 	emp.CodigoEmpresa,
			emp.RazaoSocialEmpresa,
			loc.CodigoLocal,
			loc.DescricaoLocal,
			oc.StatusOSCIT,
			@Status,
			oc.CodigoCIT, 
			oc.NumeroOROS,
			oc.CodigoCliFor,
   		        NomeCliFor = CASE WHEN @IntegradoMainframe = 'V' and cit.OSInternaCIT = 'V' and ce.NomeCliEven is not null
		   		     then ce.NomeCliEven
				     else 
			      		CASE WHEN @IntegradoMainframe = 'V' 
			      		then CASE ISNULL(oc.CodigoClienteEventualProp,0) WHEN 0
						  THEN  cp.NomeCliFor 
						  ELSE ce.NomeCliEven
					     END
			      		else CASE ISNULL(oc.CodigoClienteEventualProp,0)WHEN 0
						  THEN cp.NomeCliFor 
						  ELSE ce.NomeCliEven
					     END
			      		end
				     end,
			v.PlacaVeiculoOS,
			oro.DataAberturaOS,
			0,
			0,
			oc.DataEmissaoNotaFiscalOS,
			VrPecas = CASE WHEN (oct.TipoItemOS = 'P') 
				       THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  		  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE itos.ValorLiquidoItemOS
							END
			 	             END) 
				       ELSE 0 
				  END,		

			VrCombLub = CASE WHEN (oct.TipoItemOS = 'C') 
				       THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  		  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE itos.ValorLiquidoItemOS
							END
			 	             END) 
				       ELSE 0 
				  END,		

			VrMO = 	CASE WHEN oct.TipoItemOS = 'M' 
				     THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
						THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE itos.ValorLiquidoItemOS
							END
					   END) 
				     ELSE 0 
				END,

   		        CASE WHEN @IntegradoMainframe <> 'V'
				--------------------  Pesquisa Pelo Documento de NF
				THEN (SELECT coalesce(oc.ValorIPI, 0))

				--------------------  Pesquisa Pelo Documento de NF
				ELSE (	SELECT coalesce(SUM(I.ValorIPI), 0) 
					FROM tbItemOROS I (nolock)
					WHERE I.CodigoEmpresa = oc.CodigoEmpresa
					AND   I.CodigoLocal = oc.CodigoLocal						
					AND   I.FlagOROS = oc.FlagOROS
					AND   I.NumeroOROS = oc.NumeroOROS
					AND   I.CodigoCIT  = oc.CodigoCIT)
				END ValorIPIDocumento ,

			oc.ValorLiquidoOS,
			rep.CodigoRepresentante,
			rep.NomeRepresentante, 
			NULL, 
			NumeroFrotaVeiculo,
			oro.DataEncerramentoOS,
			oc.CentroCusto,
			oc.ValorISSRetido,
            oc.TipoRevisaoOS,
			cp.CondicaoRetencaoISS

	FROM 		tbOROSCIT oc (nolock)

	INNER JOIN	tbEmpresa emp (nolock)
	ON		(emp.CodigoEmpresa = oc.CodigoEmpresa)

	INNER JOIN	tbLocal loc (nolock)
	ON		(loc.CodigoEmpresa = oc.CodigoEmpresa 
	AND		 loc.CodigoLocal = oc.CodigoLocal)

	INNER JOIN	tbOROS oro (nolock)
	ON		(oc.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 oc.CodigoLocal = oro.CodigoLocal 
	AND		 oc.FlagOROS = oro.FlagOROS
	AND		 oc.NumeroOROS = oro.NumeroOROS)

	INNER JOIN	tbCliFor cp (nolock)
	ON		(oro.CodigoEmpresa = cp.CodigoEmpresa
	AND		 oro.CodigoCliFor = cp.CodigoCliFor)

	INNER JOIN	tbCliFor cf (nolock)
	ON		(oc.CodigoEmpresa = cf.CodigoEmpresa
	AND		 oc.CodigoCliFor = cf.CodigoCliFor)

	INNER JOIN	tbVeiculoOS v (nolock)
	ON		(oro.CodigoEmpresa = v.CodigoEmpresa
	AND		 oro.ChassiVeiculoOS = v.ChassiVeiculoOS)

	INNER JOIN	tbOROSCITTipo oct (nolock)
	ON		(oc.CodigoEmpresa = oct.CodigoEmpresa 
	AND		 oc.CodigoLocal = oct.CodigoLocal 
	AND		 oc.FlagOROS = oct.FlagOROS
	AND		 oc.NumeroOROS = oct.NumeroOROS
	AND		 oc.CodigoCIT = oct.CodigoCIT)

	INNER JOIN	tbCIT cit (nolock)
	ON		cit.CodigoEmpresa = oc.CodigoEmpresa 
	AND		cit.CodigoCIT = oc.CodigoCIT

	INNER JOIN	tbRepresentanteComplementar rep (nolock)
	ON		 oc.CodigoRepresentante = rep.CodigoRepresentante
	AND		 oc.CodigoEmpresa = rep.CodigoEmpresa 

	LEFT JOIN 	tbItemOROS itos (nolock)
	ON		oct.CodigoEmpresa = itos.CodigoEmpresa
	AND		oct.CodigoLocal = itos.CodigoLocal
	AND		oct.FlagOROS = itos.FlagOROS
	AND		oct.NumeroOROS = itos.NumeroOROS
	AND		oct.CodigoCIT = itos.CodigoCIT
	AND		oct.TipoItemOS = itos.TipoItemOS

	LEFT JOIN	tbClienteEventual ce (nolock)
	ON		ce.CodigoEmpresa = oc.CodigoEmpresa 
	AND		ce.CodigoClienteEventual = oc.CodigoClienteEventualProp

	LEFT JOIN	tbOROSPO orospo (NOLOCK)
	ON		(orospo.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 orospo.CodigoLocal = oro.CodigoLocal 
	AND		 orospo.FlagOROS = oro.FlagOROS
	AND		 orospo.NumeroOROS = oro.NumeroOROS)

	LEFT JOIN 	tbColaboradorOSPO colabospo (nolock) 
	ON 		colabospo.CodigoEmpresa = orospo.CodigoEmpresa 
	AND 		colabospo.CodigoLocal = orospo.CodigoLocal 
	AND 		colabospo.CodigoColaboradorOS = orospo.CodigoColaboradorOS 

	WHERE		oc.StatusOSCIT     = @Status
	AND		oc.FlagOROS        = @FlagOROS
	AND		emp.CodigoEmpresa  = @CodigoEmpresa 	
	AND		loc.CodigoLocal    = @CodigoLocal   	
	AND		oc.CodigoCIT BETWEEN @CITPartir AND @CITAte
	AND		convert(char(10),oro.DataAberturaOS,120) BETWEEN @DataAberturaPartir AND @DataAberturaAte
    AND     convert(char(10),oro.DataEntradaVeiculoOS,120) BETWEEN @DaDataEntrada AND @AteDataEntrada
	AND             ((v.PlacaVeiculoOS BETWEEN @DaPlaca AND @AtePlaca) OR (v.PlacaVeiculoOS Is Null))
	AND		oc.CodigoCliFor BETWEEN @DoCliente AND @AteCliente
	AND		oro.CodigoCliFor BETWEEN @DoClientePro AND @AteClientePro
	AND		oc.CentroCusto BETWEEN @DoCentroCusto AND @AteCentroCusto
	AND             ((emp.MarcaFabricanteEmpresa = '34' and oro.PreOrdemServico = @PreOrdemServico) or (emp.MarcaFabricanteEmpresa <> '34'))
	AND 		 ( 
                           ( orospo.CodigoColaboradorOS BETWEEN @RepresentantePartir AND @RepresentanteAte AND  		     
                             colabospo.CodigoEquipePO IS NOT NULL AND
			     colabospo.ConsultorTecnicoPO = 'V' ) or 
                           ( @RepresentantePartir = 0 and @RepresentanteAte = 9999)
                         )
	AND		oc.CLMA BETWEEN @DoCLMA AND @AteCLMA
	AND     oc.CLMO BETWEEN @DoCLMO AND @AteCLMO

END

--Para os tipos na combo do form = 'C'anceladas, 'E'ncerradas, 'R'eprovadas
IF @Status = 'C' OR @Status = 'E' 
BEGIN
	INSERT INTO 	rtRelOSSituacao

	SELECT 	emp.CodigoEmpresa,
			emp.RazaoSocialEmpresa,
			loc.CodigoLocal,
			loc.DescricaoLocal,
			oc.StatusOSCIT,
			@Status,
			oc.CodigoCIT, 
	 		oc.NumeroOROS,
			oc.CodigoCliFor, 
   		        NomeCliFor = CASE WHEN @IntegradoMainframe = 'V' and cit.OSInternaCIT = 'V' and ce.NomeCliEven is not null
		   		     then ce.NomeCliEven
				     else 
			      		CASE WHEN @IntegradoMainframe = 'V' 
			      		then cp.NomeCliFor 
			      		else cp.NomeCliFor 
			      		end
				     end,
			v.PlacaVeiculoOS,
			oro.DataAberturaOS,
			NumeroNotaFiscalMOB = coalesce((select max(tbPedido.NumeroNotaFiscalPed)
									 from tbOROSCITPedido
									 inner join tbPedido
											on  tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
											and tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
											and tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
											and tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
											and tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido

									 inner join tbNaturezaOperacao
											on  tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
											and tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									 where tbOROSCITPedido.CodigoEmpresa = oc.CodigoEmpresa
									 and   tbOROSCITPedido.CodigoLocal = oc.CodigoLocal
									 and   tbOROSCITPedido.FlagOROS = oc.FlagOROS
									 and   tbOROSCITPedido.NumeroOROS = oc.NumeroOROS
									 and   tbOROSCITPedido.CodigoCIT = oc.CodigoCIT
									 and   tbNaturezaOperacao.CodigoTipoOperacao = 10),0),
			NumeroNotaFiscalPEC = coalesce((select max(tbPedido.NumeroNotaFiscalPed)
									 from tbOROSCITPedido
									 inner join tbPedido
											on  tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
											and tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
											and tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
											and tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
											and tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido

									 inner join tbNaturezaOperacao
											on  tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
											and tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									 where tbOROSCITPedido.CodigoEmpresa = oc.CodigoEmpresa
									 and   tbOROSCITPedido.CodigoLocal = oc.CodigoLocal
									 and   tbOROSCITPedido.FlagOROS = oc.FlagOROS
									 and   tbOROSCITPedido.NumeroOROS = oc.NumeroOROS
									 and   tbOROSCITPedido.CodigoCIT = oc.CodigoCIT
									 and   tbNaturezaOperacao.CodigoTipoOperacao <> 10),0),
			oc.DataEmissaoNotaFiscalOS,

			VrPecas = CASE WHEN (oct.TipoItemOS = 'P') 
				       THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  		  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE itos.ValorLiquidoItemOS
							END
				    	     END) 
					ELSE 0 
				   END,

			VrCombLub = CASE WHEN (oct.TipoItemOS = 'C') 
				       THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  		  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE itos.ValorLiquidoItemOS
							END
				    	     END) 
					ELSE 0 
				   END,

			VrMO = 	CASE WHEN oct.TipoItemOS = 'M' 
				     THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	                THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE itos.ValorLiquidoItemOS
							END

			 	           END) 
 				     ELSE 0 
				END,
   		        CASE WHEN @IntegradoMainframe <> 'V'
				--------------------  Pesquisa Pelo Documento de NF
				THEN (SELECT coalesce(oc.ValorIPI, 0))
				--------------------  Pesquisa Pelo Documento de NF
				ELSE (  SELECT coalesce(SUM(I.ValorIPI), 0) 
					FROM tbItemOROS I (nolock)
					WHERE I.CodigoEmpresa = oc.CodigoEmpresa
					AND   I.CodigoLocal = oc.CodigoLocal						
					AND   I.FlagOROS = oc.FlagOROS
					AND   I.NumeroOROS = oc.NumeroOROS
					AND   I.CodigoCIT  = oc.CodigoCIT)
				END ValorIPIDocumento ,

			oc.ValorLiquidoOS,
			rep.CodigoRepresentante,
			rep.NomeRepresentante, 
			MotivoCancelamentoOS, 
			NumeroFrotaVeiculo,
			oc.DataEncerramentoOSCIT,
			oc.CentroCusto,
			oc.ValorISSRetido,
            oc.TipoRevisaoOS,
			cp.CondicaoRetencaoISS

	FROM 		tbOROSCIT oc (nolock)

	INNER JOIN	tbEmpresa emp (nolock)
	ON		(emp.CodigoEmpresa = oc.CodigoEmpresa)

	INNER JOIN	tbLocal loc (nolock)
	ON		(loc.CodigoEmpresa = oc.CodigoEmpresa 
	AND		 loc.CodigoLocal = oc.CodigoLocal)

	INNER JOIN	tbOROS oro (nolock)
	ON		(oc.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 oc.CodigoLocal = oro.CodigoLocal 
	AND		 oc.FlagOROS = oro.FlagOROS
	AND		 oc.NumeroOROS = oro.NumeroOROS)

	INNER JOIN	tbCliFor cp (nolock)
	ON		(oro.CodigoEmpresa = cp.CodigoEmpresa
	AND		 oro.CodigoCliFor = cp.CodigoCliFor)

	INNER JOIN	tbCliFor cf (nolock)
	ON		(oc.CodigoEmpresa = cf.CodigoEmpresa
	AND		 oc.CodigoCliFor = cf.CodigoCliFor)

	INNER JOIN	tbVeiculoOS v (nolock)
	ON		(oro.CodigoEmpresa = v.CodigoEmpresa
	AND		 oro.ChassiVeiculoOS = v.ChassiVeiculoOS)

	INNER JOIN	tbOROSCITTipo oct (nolock)
	ON		(oc.CodigoEmpresa = oct.CodigoEmpresa 
	AND		 oc.CodigoLocal = oct.CodigoLocal 
	AND		 oc.FlagOROS = oct.FlagOROS
	AND		 oc.NumeroOROS = oct.NumeroOROS
	AND		 oc.CodigoCIT = oct.CodigoCIT)

	INNER JOIN	tbCIT cit (nolock)
	ON		cit.CodigoEmpresa = oc.CodigoEmpresa 
	AND		cit.CodigoCIT = oc.CodigoCIT

	INNER JOIN	tbRepresentanteComplementar rep
	ON		 oc.CodigoRepresentante = rep.CodigoRepresentante
	AND		 oc.CodigoEmpresa = rep.CodigoEmpresa  

	LEFT JOIN 	tbItemOROS itos (nolock)
	ON		oct.CodigoEmpresa = itos.CodigoEmpresa
	AND		oct.CodigoLocal = itos.CodigoLocal
	AND		oct.FlagOROS = itos.FlagOROS
	AND		oct.NumeroOROS = itos.NumeroOROS
	AND		oct.CodigoCIT = itos.CodigoCIT
	AND		oct.TipoItemOS = itos.TipoItemOS

	LEFT JOIN	tbClienteEventual ce (nolock)
	ON		ce.CodigoEmpresa = oc.CodigoEmpresa 
	AND		ce.CodigoClienteEventual = oc.CodigoClienteEventualProp

	LEFT JOIN	tbOROSPO orospo (NOLOCK)
	ON		(orospo.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 orospo.CodigoLocal = oro.CodigoLocal 
	AND		 orospo.FlagOROS = oro.FlagOROS
	AND		 orospo.NumeroOROS = oro.NumeroOROS)

	LEFT JOIN 	tbColaboradorOSPO colabospo (nolock) 
	ON 		colabospo.CodigoEmpresa = orospo.CodigoEmpresa 
	AND 		colabospo.CodigoLocal = orospo.CodigoLocal 
	AND 		colabospo.CodigoColaboradorOS = orospo.CodigoColaboradorOS 

	WHERE		oc.FlagOROS        = @FlagOROS
	AND		oc.StatusOSCIT     = @Status
	AND		emp.CodigoEmpresa  = @CodigoEmpresa 	
	AND		loc.CodigoLocal    = @CodigoLocal   	
	AND		oc.CodigoCIT BETWEEN @CITPartir AND @CITAte
	AND		convert(char(10),oc.DataEncerramentoOSCIT,120) BETWEEN @DataEncerramentoPartir AND @DataEncerramentoAte 
	AND             ((v.PlacaVeiculoOS BETWEEN @DaPlaca AND @AtePlaca) OR (v.PlacaVeiculoOS Is Null) AND @DaPlaca = '' AND @AtePlaca = 'ZZZZZZZZZZ')
	AND		oc.CodigoCliFor BETWEEN @DoCliente AND @AteCliente
	AND		oro.CodigoCliFor BETWEEN @DoClientePro AND @AteClientePro
	AND             ((emp.MarcaFabricanteEmpresa = '34' and oro.PreOrdemServico = @PreOrdemServico) or (emp.MarcaFabricanteEmpresa <> '34'))
	and (not exists (select * from tbApontamentoMO apo (nolock)
			where apo.CodigoEmpresa = oct.CodigoEmpresa
			AND   apo.CodigoLocal = oct.CodigoLocal
			AND   apo.FlagOROS = oct.FlagOROS
			AND   apo.NumeroOROS = oct.NumeroOROS
			AND   apo.CodigoCIT = oct.CodigoCIT
			AND   apo.TipoItemOS = 'M') or 	oct.ValorLiquidoTipoOS <> 0
						    or  oc.ValorLiquidoOS <> 0)
	AND		oc.CentroCusto BETWEEN @DoCentroCusto AND @AteCentroCusto

	AND 		 ( 
                           ( orospo.CodigoColaboradorOS BETWEEN @RepresentantePartir AND @RepresentanteAte AND  		     
                             colabospo.CodigoEquipePO IS NOT NULL AND
			     colabospo.ConsultorTecnicoPO = 'V' ) or 
                           ( @RepresentantePartir = 0 and @RepresentanteAte = 9999)
                         ) 
	AND		oc.CLMA BETWEEN @DoCLMA AND @AteCLMA
	AND     oc.CLMO BETWEEN @DoCLMO AND @AteCLMO

--SQL2000 Order By emp.CodigoEmpresa
END

--Para os tipos na combo do form = 'C'anceladas, 'E'ncerradas 
IF @Status = 'Z' 
BEGIN
	INSERT INTO 	rtRelOSSituacao

	SELECT 		emp.CodigoEmpresa,
			emp.RazaoSocialEmpresa,
			loc.CodigoLocal,
			loc.DescricaoLocal,
			oc.StatusOSCIT,
			@Status,
			oc.CodigoCIT, 
	 		oc.NumeroOROS,
			oc.CodigoCliFor, 
   		        NomeCliFor = CASE WHEN @IntegradoMainframe = 'V' and cit.OSInternaCIT = 'V' and ce.NomeCliEven is not null
		   		     then ce.NomeCliEven
				     else 
			      		CASE WHEN @IntegradoMainframe = 'V' 
			      		then cp.NomeCliFor 
			      		else cp.NomeCliFor 
			      		end
				     end,
			v.PlacaVeiculoOS,
			oro.DataAberturaOS,
			NumeroNotaFiscalMOB = coalesce((select max(tbPedido.NumeroNotaFiscalPed)
									 from tbOROSCITPedido
									 inner join tbPedido
											on  tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
											and tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
											and tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
											and tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
											and tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido

									 inner join tbNaturezaOperacao
											on  tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
											and tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									 where tbOROSCITPedido.CodigoEmpresa = oc.CodigoEmpresa
									 and   tbOROSCITPedido.CodigoLocal = oc.CodigoLocal
									 and   tbOROSCITPedido.FlagOROS = oc.FlagOROS
									 and   tbOROSCITPedido.NumeroOROS = oc.NumeroOROS
									 and   tbOROSCITPedido.CodigoCIT = oc.CodigoCIT
									 and   tbNaturezaOperacao.CodigoTipoOperacao = 10),0),
			NumeroNotaFiscalPEC = coalesce((select max(tbPedido.NumeroNotaFiscalPed)
									 from tbOROSCITPedido
									 inner join tbPedido
											on  tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
											and tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
											and tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
											and tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
											and tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido

									 inner join tbNaturezaOperacao
											on  tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
											and tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									 where tbOROSCITPedido.CodigoEmpresa = oc.CodigoEmpresa
									 and   tbOROSCITPedido.CodigoLocal = oc.CodigoLocal
									 and   tbOROSCITPedido.FlagOROS = oc.FlagOROS
									 and   tbOROSCITPedido.NumeroOROS = oc.NumeroOROS
									 and   tbOROSCITPedido.CodigoCIT = oc.CodigoCIT
									 and   tbNaturezaOperacao.CodigoTipoOperacao <> 10),0),
			oc.DataEmissaoNotaFiscalOS,
			VrPecas = CASE WHEN (oct.TipoItemOS = 'P') 
				       THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  		  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE itos.ValorLiquidoItemOS
							END
				    	     END) 
					ELSE 0 
				   END,

			VrCombLub = CASE WHEN (oct.TipoItemOS = 'C') 
				       THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  		  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE itos.ValorLiquidoItemOS
							END
				    	     END) 
					ELSE 0 
				   END,

			VrMO = CASE WHEN oct.TipoItemOS = 'M' 
				       THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
					 	  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE itos.ValorLiquidoItemOS
							END
				     	     END) 
				       ELSE 0
			       END,
   		        CASE WHEN @IntegradoMainframe <> 'V'
				--------------------  Pesquisa Pelo Documento de NF
				THEN (SELECT coalesce(oc.ValorIPI, 0))
				--------------------  Pesquisa Pelo Documento de NF
 				ELSE (	SELECT coalesce(SUM(I.ValorIPI), 0) 
					FROM tbItemOROS I (nolock)
					WHERE I.CodigoEmpresa = oc.CodigoEmpresa
					AND   I.CodigoLocal = oc.CodigoLocal						
					AND   I.FlagOROS = oc.FlagOROS
					AND   I.NumeroOROS = oc.NumeroOROS
					AND   I.CodigoCIT  = oc.CodigoCIT)
				END ValorIPIDocumento ,

			oc.ValorLiquidoOS,
			rep.CodigoRepresentante,
			rep.NomeRepresentante, 
			MotivoCancelamentoOS, 
			NumeroFrotaVeiculo,
			oc.DataEncerramentoOSCIT,
			oc.CentroCusto,
			oc.ValorISSRetido,
            oc.TipoRevisaoOS,
			cp.CondicaoRetencaoISS

	FROM 		tbOROSCIT oc (nolock)

	INNER JOIN	tbEmpresa emp (nolock)
	ON		(emp.CodigoEmpresa = oc.CodigoEmpresa)

	INNER JOIN	tbLocal loc (nolock)
	ON		(loc.CodigoEmpresa = oc.CodigoEmpresa 
	AND		 loc.CodigoLocal = oc.CodigoLocal)

	INNER JOIN	tbOROS oro (nolock)
	ON		(oc.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 oc.CodigoLocal = oro.CodigoLocal 
	AND		 oc.FlagOROS = oro.FlagOROS
	AND		 oc.NumeroOROS = oro.NumeroOROS)

	INNER JOIN	tbCliFor cp (nolock)
	ON		(oro.CodigoEmpresa = cp.CodigoEmpresa
	AND		 oro.CodigoCliFor = cp.CodigoCliFor)

	INNER JOIN	tbCliFor cf (nolock)
	ON		(oc.CodigoEmpresa = cf.CodigoEmpresa
	AND		 oc.CodigoCliFor = cf.CodigoCliFor)

	INNER JOIN	tbVeiculoOS v (nolock)
	ON		(oro.CodigoEmpresa = v.CodigoEmpresa
	AND		 oro.ChassiVeiculoOS = v.ChassiVeiculoOS)

	INNER JOIN	tbOROSCITTipo oct (nolock)
	ON		(oc.CodigoEmpresa = oct.CodigoEmpresa 
	AND		 oc.CodigoLocal = oct.CodigoLocal 
	AND		 oc.FlagOROS = oct.FlagOROS
	AND		 oc.NumeroOROS = oct.NumeroOROS
	AND		 oc.CodigoCIT = oct.CodigoCIT)

	INNER JOIN	tbCIT cit (nolock)
	ON		cit.CodigoEmpresa = oc.CodigoEmpresa 
	AND		cit.CodigoCIT = oc.CodigoCIT

	INNER JOIN	tbRepresentanteComplementar rep (nolock)
	ON		 oc.CodigoRepresentante = rep.CodigoRepresentante
	AND		 oc.CodigoEmpresa = rep.CodigoEmpresa  

	LEFT JOIN 	tbItemOROS itos (nolock)
	ON		oct.CodigoEmpresa = itos.CodigoEmpresa
	AND		oct.CodigoLocal = itos.CodigoLocal
	AND		oct.FlagOROS = itos.FlagOROS
	AND		oct.NumeroOROS = itos.NumeroOROS
	AND		oct.CodigoCIT = itos.CodigoCIT
	AND		oct.TipoItemOS = itos.TipoItemOS

	LEFT JOIN	tbClienteEventual ce (nolock)
	ON		ce.CodigoEmpresa = oc.CodigoEmpresa 
	AND		ce.CodigoClienteEventual = oc.CodigoClienteEventualProp

	LEFT JOIN	tbOROSPO orospo (NOLOCK)
	ON		(orospo.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 orospo.CodigoLocal = oro.CodigoLocal 
	AND		 orospo.FlagOROS = oro.FlagOROS
	AND		 orospo.NumeroOROS = oro.NumeroOROS)

	LEFT JOIN 	tbColaboradorOSPO colabospo (nolock) 
	ON 		colabospo.CodigoEmpresa = orospo.CodigoEmpresa 
	AND 		colabospo.CodigoLocal = orospo.CodigoLocal 
	AND 		colabospo.CodigoColaboradorOS = orospo.CodigoColaboradorOS 

	WHERE		oc.StatusOSCIT = 'E'
	AND		oc.FlagOROS    = @FlagOROS
	AND		emp.CodigoEmpresa  = @CodigoEmpresa 	
	AND		loc.CodigoLocal    = @CodigoLocal   	
	AND		oc.CodigoCIT BETWEEN @CITPartir AND @CITAte
	AND		convert(char(10),oc.DataEncerramentoOSCIT,120) BETWEEN @DataEncerramentoPartir AND @DataEncerramentoAte 
	AND             ((v.PlacaVeiculoOS BETWEEN @DaPlaca AND @AtePlaca) OR (v.PlacaVeiculoOS Is Null) AND @DaPlaca = '' AND @AtePlaca = 'ZZZZZZZZZZ')
	AND		oc.CodigoCliFor BETWEEN @DoCliente AND @AteCliente
	AND		oro.CodigoCliFor BETWEEN @DoClientePro AND @AteClientePro
	AND             oct.ValorLiquidoTipoOS = 0
	AND 		oc.ValorLiquidoOS = 0
	AND		oc.CentroCusto BETWEEN @DoCentroCusto AND @AteCentroCusto
	AND             ((emp.MarcaFabricanteEmpresa = '34' and oro.PreOrdemServico = @PreOrdemServico) or (emp.MarcaFabricanteEmpresa <> '34'))
	AND 		 ( 
                           ( orospo.CodigoColaboradorOS BETWEEN @RepresentantePartir AND @RepresentanteAte AND  		     
                             colabospo.CodigoEquipePO IS NOT NULL AND
			     colabospo.ConsultorTecnicoPO = 'V' ) or 
                           ( @RepresentantePartir = 0 and @RepresentanteAte = 9999)
                         ) 
	AND		oc.CLMA BETWEEN @DoCLMA AND @AteCLMA
	AND     oc.CLMO BETWEEN @DoCLMO AND @AteCLMO

END

--Para os tipos na combo do form = 'N' NF. Emitida.
IF @Status = 'N' 
BEGIN
	INSERT INTO rtRelOSSituacao

	SELECT 	emp.CodigoEmpresa,
			emp.RazaoSocialEmpresa,
			loc.CodigoLocal,
			loc.DescricaoLocal,
			oc.StatusOSCIT,
			@Status,
			oc.CodigoCIT, 
			oc.NumeroOROS,
			oc.CodigoCliFor, 
   		        NomeCliFor = CASE WHEN @IntegradoMainframe = 'V' and cit.OSInternaCIT = 'V' and ce.NomeCliEven is not null
		   		     then ce.NomeCliEven
				     else 
			      		CASE WHEN @IntegradoMainframe = 'V' 
			      		then cp.NomeCliFor 
			      		else cp.NomeCliFor 
			      		end
				     end,
			v.PlacaVeiculoOS,
			oro.DataAberturaOS,
			NumeroNotaFiscalMOB = coalesce((select max(tbPedido.NumeroNotaFiscalPed)
									 from tbOROSCITPedido
									 inner join tbPedido
											on  tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
											and tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
											and tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
											and tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
											and tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido

									 inner join tbNaturezaOperacao
											on  tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
											and tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									 where tbOROSCITPedido.CodigoEmpresa = oc.CodigoEmpresa
									 and   tbOROSCITPedido.CodigoLocal = oc.CodigoLocal
									 and   tbOROSCITPedido.FlagOROS = oc.FlagOROS
									 and   tbOROSCITPedido.NumeroOROS = oc.NumeroOROS
									 and   tbOROSCITPedido.CodigoCIT = oc.CodigoCIT
									 and   tbNaturezaOperacao.CodigoTipoOperacao = 10),0),
			NumeroNotaFiscalPEC = coalesce((select max(tbPedido.NumeroNotaFiscalPed)
									 from tbOROSCITPedido
									 inner join tbPedido
											on  tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
											and tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
											and tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
											and tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
											and tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido

									 inner join tbNaturezaOperacao
											on  tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
											and tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									 where tbOROSCITPedido.CodigoEmpresa = oc.CodigoEmpresa
									 and   tbOROSCITPedido.CodigoLocal = oc.CodigoLocal
									 and   tbOROSCITPedido.FlagOROS = oc.FlagOROS
									 and   tbOROSCITPedido.NumeroOROS = oc.NumeroOROS
									 and   tbOROSCITPedido.CodigoCIT = oc.CodigoCIT
									 and   tbNaturezaOperacao.CodigoTipoOperacao <> 10),0),
			oc.DataEmissaoNotaFiscalOS,
			VrPecas = CASE WHEN (oct.TipoItemOS = 'P') 
				       THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  		  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE itos.ValorLiquidoItemOS
							END
				    	     END) 
					ELSE 0 
				   END,

			VrCombLub = CASE WHEN (oct.TipoItemOS = 'C') 
				       THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  		  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE itos.ValorLiquidoItemOS
							END
				    	     END) 
					ELSE 0 
				   END,
			VrMO = CASE WHEN oct.TipoItemOS = 'M' 
				THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
				 	  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE coalesce(itos.ValorLiquidoItemOS,0)
							END
				      END) 
				ELSE 0 
			       END,	
--Evandro - Soma do IPI
   		        CASE WHEN @IntegradoMainframe <> 'V'
				--------------------  Pesquisa Pelo Documento de NF
				THEN (SELECT coalesce(oc.ValorIPI, 0))
				--------------------  Pesquisa Pelo Documento de NF
				ELSE (	SELECT coalesce(SUM(I.ValorIPI), 0) 
					FROM tbItemOROS I (nolock)
					WHERE I.CodigoEmpresa = oc.CodigoEmpresa
					AND   I.CodigoLocal = oc.CodigoLocal						
					AND   I.FlagOROS = oc.FlagOROS
					AND   I.NumeroOROS = oc.NumeroOROS
					AND   I.CodigoCIT  = oc.CodigoCIT)
				END ValorIPIDocumento ,
			oc.ValorLiquidoOS,
			rep.CodigoRepresentante,
			rep.NomeRepresentante, 
			NULL, 
			NumeroFrotaVeiculo,
			oc.DataEncerramentoOSCIT,
			oc.CentroCusto,
			oc.ValorISSRetido,
            oc.TipoRevisaoOS,
			cp.CondicaoRetencaoISS

	FROM 		tbOROSCIT oc (nolock)

	INNER JOIN	tbEmpresa emp (nolock)
	ON		(emp.CodigoEmpresa = oc.CodigoEmpresa)

	INNER JOIN	tbLocal loc (nolock)
	ON		(loc.CodigoEmpresa = oc.CodigoEmpresa 
	AND		 loc.CodigoLocal = oc.CodigoLocal)

	INNER JOIN	tbOROS oro (nolock)
	ON		(oc.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 oc.CodigoLocal = oro.CodigoLocal 
	AND		 oc.FlagOROS = oro.FlagOROS
	AND		 oc.NumeroOROS = oro.NumeroOROS)

	INNER JOIN	tbCliFor cp (nolock)
	ON		(oro.CodigoEmpresa = cp.CodigoEmpresa
	AND		 oro.CodigoCliFor = cp.CodigoCliFor)

	INNER JOIN	tbCliFor cf (nolock)
	ON		(oc.CodigoEmpresa = cf.CodigoEmpresa
	AND		 oc.CodigoCliFor = cf.CodigoCliFor)

	INNER JOIN 	tbVeiculoOS v (nolock)
	ON		(oro.CodigoEmpresa = v.CodigoEmpresa
	AND		 oro.ChassiVeiculoOS = v.ChassiVeiculoOS)

	INNER JOIN	tbOROSCITTipo oct (nolock)
	ON		(oc.CodigoEmpresa = oct.CodigoEmpresa 
	AND		 oc.CodigoLocal = oct.CodigoLocal 
	AND		 oc.FlagOROS = oct.FlagOROS
	AND		 oc.NumeroOROS = oct.NumeroOROS
	AND		 oc.CodigoCIT = oct.CodigoCIT)

	INNER JOIN	tbCIT cit (nolock)
	ON		cit.CodigoEmpresa = oc.CodigoEmpresa 
	AND		cit.CodigoCIT = oc.CodigoCIT

	INNER JOIN	tbRepresentanteComplementar rep (nolock)
	ON		 oc.CodigoRepresentante = rep.CodigoRepresentante
	AND		 oc.CodigoEmpresa = rep.CodigoEmpresa  

	LEFT JOIN 	tbItemOROS itos (nolock)
	ON		oct.CodigoEmpresa = itos.CodigoEmpresa
	AND		oct.CodigoLocal = itos.CodigoLocal
	AND		oct.FlagOROS = itos.FlagOROS
	AND		oct.NumeroOROS = itos.NumeroOROS
	AND		oct.CodigoCIT = itos.CodigoCIT
	AND		oct.TipoItemOS = itos.TipoItemOS

	LEFT JOIN	tbClienteEventual ce (nolock)
	ON		ce.CodigoEmpresa = oc.CodigoEmpresa 
	AND		ce.CodigoClienteEventual = oc.CodigoClienteEventualProp

	LEFT JOIN	tbOROSPO orospo (NOLOCK)
	ON		(orospo.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 orospo.CodigoLocal = oro.CodigoLocal 
	AND		 orospo.FlagOROS = oro.FlagOROS
	AND		 orospo.NumeroOROS = oro.NumeroOROS)

	LEFT JOIN 	tbColaboradorOSPO colabospo (nolock) 
	ON 		colabospo.CodigoEmpresa = orospo.CodigoEmpresa 
	AND 		colabospo.CodigoLocal = orospo.CodigoLocal 
	AND 		colabospo.CodigoColaboradorOS = orospo.CodigoColaboradorOS 

	WHERE		oc.FlagOROS        = @FlagOROS
	AND		oc.StatusOSCIT 	   = @Status
	AND		emp.CodigoEmpresa  = @CodigoEmpresa 	
	AND		loc.CodigoLocal    = @CodigoLocal   	
	AND		oc.CodigoCIT BETWEEN @CITPartir AND @CITAte
	AND		convert(char(10),oc.DataEmissaoNotaFiscalOS,120) BETWEEN @DataEncerramentoPartir AND @DataEncerramentoAte 
	AND             ((v.PlacaVeiculoOS BETWEEN @DaPlaca AND @AtePlaca) OR (v.PlacaVeiculoOS Is Null) AND @DaPlaca = '' AND @AtePlaca = 'ZZZZZZZZZZ')
	AND		oc.CodigoCliFor BETWEEN @DoCliente AND @AteCliente
	AND		oro.CodigoCliFor BETWEEN @DoClientePro AND @AteClientePro
	AND		oc.CentroCusto BETWEEN @DoCentroCusto AND @AteCentroCusto
	AND             ((emp.MarcaFabricanteEmpresa = '34' and oro.PreOrdemServico = @PreOrdemServico) or (emp.MarcaFabricanteEmpresa <> '34'))
	AND 		 ( 
                           ( orospo.CodigoColaboradorOS BETWEEN @RepresentantePartir AND @RepresentanteAte AND  		     
                             colabospo.CodigoEquipePO IS NOT NULL AND
			     colabospo.ConsultorTecnicoPO = 'V' ) or 
                           ( @RepresentantePartir = 0 and @RepresentanteAte = 9999)
                         ) 
	AND		oc.CLMA BETWEEN @DoCLMA AND @AteCLMA
	AND     oc.CLMO BETWEEN @DoCLMO AND @AteCLMO

END

--Para os tipos na combo do form = 'T-Todos Status.
IF @Status = 'T'
BEGIN
	INSERT INTO rtRelOSSituacao

	SELECT 	emp.CodigoEmpresa,
			emp.RazaoSocialEmpresa,
			loc.CodigoLocal,
			loc.DescricaoLocal,
			oc.StatusOSCIT,
			@Status,
			oc.CodigoCIT, 
			oc.NumeroOROS,
			oc.CodigoCliFor, 
   		        NomeCliFor = CASE WHEN @IntegradoMainframe = 'V' and cit.OSInternaCIT = 'V' and ce.NomeCliEven is not null
		   		     then ce.NomeCliEven
				     else 
			      		CASE WHEN @IntegradoMainframe = 'V' 
			      		then cp.NomeCliFor 
			      		else cp.NomeCliFor 
			      		end
				     end,
			v.PlacaVeiculoOS,
			oro.DataAberturaOS,
			NumeroNotaFiscalMOB = coalesce((select max(tbPedido.NumeroNotaFiscalPed)
									 from tbOROSCITPedido
									 inner join tbPedido
											on  tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
											and tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
											and tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
											and tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
											and tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido

									 inner join tbNaturezaOperacao
											on  tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
											and tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									 where tbOROSCITPedido.CodigoEmpresa = oc.CodigoEmpresa
									 and   tbOROSCITPedido.CodigoLocal = oc.CodigoLocal
									 and   tbOROSCITPedido.FlagOROS = oc.FlagOROS
									 and   tbOROSCITPedido.NumeroOROS = oc.NumeroOROS
									 and   tbOROSCITPedido.CodigoCIT = oc.CodigoCIT
									 and   tbNaturezaOperacao.CodigoTipoOperacao = 10),0),
			NumeroNotaFiscalPEC = coalesce((select max(tbPedido.NumeroNotaFiscalPed)
									 from tbOROSCITPedido
									 inner join tbPedido
											on  tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
											and tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
											and tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
											and tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
											and tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido

									 inner join tbNaturezaOperacao
											on  tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
											and tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									 where tbOROSCITPedido.CodigoEmpresa = oc.CodigoEmpresa
									 and   tbOROSCITPedido.CodigoLocal = oc.CodigoLocal
									 and   tbOROSCITPedido.FlagOROS = oc.FlagOROS
									 and   tbOROSCITPedido.NumeroOROS = oc.NumeroOROS
									 and   tbOROSCITPedido.CodigoCIT = oc.CodigoCIT
									 and   tbNaturezaOperacao.CodigoTipoOperacao <> 10),0),
			oc.DataEmissaoNotaFiscalOS,
			VrPecas = CASE WHEN (oct.TipoItemOS = 'P') 
				       THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  		  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE itos.ValorLiquidoItemOS
							END
				    	     END) 
					ELSE 0 
				   END,

			VrCombLub = CASE WHEN (oct.TipoItemOS = 'C') 
				       THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  		  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE itos.ValorLiquidoItemOS
							END
				    	     END) 
					ELSE 0 
				   END,
			VrMO = CASE WHEN oct.TipoItemOS = 'M' 
				THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
				 	  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE coalesce(itos.ValorLiquidoItemOS,0)
							END
				      END) 
				ELSE 0 
			       END,	
--Evandro - Soma do IPI
   		        CASE WHEN @IntegradoMainframe <> 'V'
				--------------------  Pesquisa Pelo Documento de NF
				THEN (SELECT coalesce(oc.ValorIPI, 0))
				--------------------  Pesquisa Pelo Documento de NF
				ELSE (	SELECT coalesce(SUM(I.ValorIPI), 0) 
					FROM tbItemOROS I (nolock)
					WHERE I.CodigoEmpresa = oc.CodigoEmpresa
					AND   I.CodigoLocal = oc.CodigoLocal						
					AND   I.FlagOROS = oc.FlagOROS
					AND   I.NumeroOROS = oc.NumeroOROS
					AND   I.CodigoCIT  = oc.CodigoCIT)
				END ValorIPIDocumento ,
			oc.ValorLiquidoOS,
			rep.CodigoRepresentante,
			rep.NomeRepresentante, 
			NULL, 
			NumeroFrotaVeiculo,
			oc.DataEncerramentoOSCIT,
			oc.CentroCusto,
			oc.ValorISSRetido,
            oc.TipoRevisaoOS,
			cp.CondicaoRetencaoISS

	FROM 		tbOROSCIT oc (nolock)

	INNER JOIN	tbEmpresa emp (nolock)
	ON		(emp.CodigoEmpresa = oc.CodigoEmpresa)

	INNER JOIN	tbLocal loc (nolock)
	ON		(loc.CodigoEmpresa = oc.CodigoEmpresa 
	AND		 loc.CodigoLocal = oc.CodigoLocal)

	INNER JOIN	tbOROS oro (nolock)
	ON		(oc.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 oc.CodigoLocal = oro.CodigoLocal 
	AND		 oc.FlagOROS = oro.FlagOROS
	AND		 oc.NumeroOROS = oro.NumeroOROS)

	INNER JOIN	tbCliFor cp (nolock)
	ON		(oro.CodigoEmpresa = cp.CodigoEmpresa
	AND		 oro.CodigoCliFor = cp.CodigoCliFor)

	INNER JOIN	tbCliFor cf (nolock)
	ON		(oc.CodigoEmpresa = cf.CodigoEmpresa
	AND		 oc.CodigoCliFor = cf.CodigoCliFor)

	INNER JOIN	tbVeiculoOS v (nolock)
	ON		(oro.CodigoEmpresa = v.CodigoEmpresa
	AND		 oro.ChassiVeiculoOS = v.ChassiVeiculoOS)

	INNER JOIN	tbOROSCITTipo oct (nolock)
	ON		(oc.CodigoEmpresa = oct.CodigoEmpresa 
	AND		 oc.CodigoLocal = oct.CodigoLocal 
	AND		 oc.FlagOROS = oct.FlagOROS
	AND		 oc.NumeroOROS = oct.NumeroOROS
	AND		 oc.CodigoCIT = oct.CodigoCIT)

	INNER JOIN	tbCIT cit (nolock)
	ON		cit.CodigoEmpresa = oc.CodigoEmpresa 
	AND		cit.CodigoCIT = oc.CodigoCIT

	INNER JOIN	tbRepresentanteComplementar rep (nolock)
	ON		 oc.CodigoRepresentante = rep.CodigoRepresentante
	AND		 oc.CodigoEmpresa = rep.CodigoEmpresa 

	LEFT JOIN 	tbItemOROS itos (nolock)
	ON		oct.CodigoEmpresa = itos.CodigoEmpresa
	AND		oct.CodigoLocal = itos.CodigoLocal
	AND		oct.FlagOROS = itos.FlagOROS
	AND		oct.NumeroOROS = itos.NumeroOROS
	AND		oct.CodigoCIT = itos.CodigoCIT
	AND		oct.TipoItemOS = itos.TipoItemOS

	LEFT JOIN	tbClienteEventual ce (nolock)
	ON		ce.CodigoEmpresa = oc.CodigoEmpresa 
	AND		ce.CodigoClienteEventual = oc.CodigoClienteEventualProp

	LEFT JOIN	tbOROSPO orospo (NOLOCK)
	ON		(orospo.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 orospo.CodigoLocal = oro.CodigoLocal 
	AND		 orospo.FlagOROS = oro.FlagOROS
	AND		 orospo.NumeroOROS = oro.NumeroOROS)

	LEFT JOIN 	tbColaboradorOSPO colabospo (nolock) 
	ON 		colabospo.CodigoEmpresa = orospo.CodigoEmpresa 
	AND 		colabospo.CodigoLocal = orospo.CodigoLocal 
	AND 		colabospo.CodigoColaboradorOS = orospo.CodigoColaboradorOS 

	WHERE		oc.FlagOROS        = @FlagOROS
	AND		emp.CodigoEmpresa  = @CodigoEmpresa 	
	AND		loc.CodigoLocal    = @CodigoLocal   	
	AND		oc.CodigoCIT BETWEEN @CITPartir AND @CITAte
	AND		( (oc.StatusOSCIT = 'A' and convert(char(10),oro.DataAberturaOS,120) BETWEEN @DataAberturaPartir AND @DataAberturaAte) or
			  (oc.StatusOSCIT = 'A' and @DaDataEntrada <> '1900-01-01' and convert(char(10),oro.DataEntradaVeiculoOS,120) BETWEEN @DaDataEntrada AND @AteDataEntrada) or
			  (oc.StatusOSCIT = 'L' and convert(char(10),oro.DataAberturaOS,120) BETWEEN @DataAberturaPartir AND @DataAberturaAte) or
			  (oc.StatusOSCIT = 'R' and convert(char(10),oro.DataAberturaOS,120) BETWEEN @DataAberturaPartir AND @DataAberturaAte) or
			  (oc.StatusOSCIT = 'P' and convert(char(10),oro.DataAberturaOS,120) BETWEEN @DataAberturaPartir AND @DataAberturaAte) or
			  (oc.StatusOSCIT in ('E','C') and convert(char(10),oc.DataEncerramentoOSCIT,120) BETWEEN @DataEncerramentoPartir AND @DataEncerramentoAte) or 
	                  (oc.StatusOSCIT = 'N' and convert(char(10),oc.DataEmissaoNotaFiscalOS,120) BETWEEN @DataEncerramentoPartir AND @DataEncerramentoAte))
	AND             ((v.PlacaVeiculoOS BETWEEN @DaPlaca AND @AtePlaca) OR (v.PlacaVeiculoOS Is Null))
	AND		oc.CodigoCliFor BETWEEN @DoCliente AND @AteCliente
	AND		oro.CodigoCliFor BETWEEN @DoClientePro AND @AteClientePro
	AND		oc.CentroCusto BETWEEN @DoCentroCusto AND @AteCentroCusto
	AND             ((emp.MarcaFabricanteEmpresa = '34' and oro.PreOrdemServico = @PreOrdemServico) or (emp.MarcaFabricanteEmpresa <> '34'))
	AND 		 ( 
                           ( orospo.CodigoColaboradorOS BETWEEN @RepresentantePartir AND @RepresentanteAte AND  		     
                             colabospo.CodigoEquipePO IS NOT NULL AND
			     colabospo.ConsultorTecnicoPO = 'V' ) or 
                           ( @RepresentantePartir = 0 and @RepresentanteAte = 9999)
                         ) 
	AND		oc.CLMA BETWEEN @DoCLMA AND @AteCLMA
	AND     oc.CLMO BETWEEN @DoCLMO AND @AteCLMO

END


---------------------------------------------- Totalizatr OS´s - CAC 21579/2005
declare @TotalOSs numeric(6)
select @TotalOSs = count(distinct NumeroOROS) from rtRelOSSituacao (nolock)
-------------------------------------------------------------------------------

SET NOCOUNT OFF

--Verifica se é para imprimir somente pecas

	SELECT	CodigoEmpresa,
			RazaoSocialEmpresa,
			CodigoLocal,
			DescricaoLocal,
			StatusOSCIT,
			StatusRel,
			CodigoCIT, 
			NumeroOROS, 
			CodigoCliFor,
			NomeCliFor, 
			coalesce(PlacaVeiculoOS,'') as 'PlacaVeiculoOS',
			DataAberturaOS,
			NumeroNotaFiscalMOB,
			NumeroNotaFiscalPEC,
			coalesce(DataEmissaoNotaFiscalOS,'') as 'DataEmissaoNotaFiscalOS',

			ValorPecas = CASE WHEN @ImprimePecaOS = 'V' 
						THEN (coalesce(sum(ValorPecas),0))
						ELSE 0 
				END,	
			coalesce(sum(ValorCombLub), 0) ValorCombLub,

			ValorMaoObra = CASE WHEN @ImprimeMaoObraOS = 'V' 
						THEN (coalesce(sum(ValorMaoObra),0))
						ELSE 0 
				END,	

			ValorIPIDocumento as ValorIPIDocumento,
			ValorLiquidoOS + ValorIPIDocumento - ValorISSRetido as ValorLiquidoOS,
			CodigoRepresentante,
			NomeRepresentante, 
			coalesce(MotivoCancelamentoOS,'') as 'MotivoCancelamentoOS', 
			COALESCE(NumeroFrotaVeiculo,'') as 'NumeroFrotaVeiculo',
			DataEncerramentoOS,
			CentroCusto,
			ValorISSRetido = coalesce((case when rtRelOSSituacao.CondicaoRetencaoISS = 'V'
										  then (select ValorISSDocumento from tbDocumento
													 where tbDocumento.CodigoEmpresa = rtRelOSSituacao.CodigoEmpresa
												 and   tbDocumento.CodigoLocal = rtRelOSSituacao.CodigoLocal
												 and   tbDocumento.EntradaSaidaDocumento = 'S'
 				 								 and   tbDocumento.NumeroDocumento = rtRelOSSituacao.NumeroNotaFiscalMOB
 				 								 and   tbDocumento.DataDocumento = right(convert(char(10),rtRelOSSituacao.DataEmissaoNotaFiscalOS,103),4) + SUBSTRING(convert(char(10),rtRelOSSituacao.DataEmissaoNotaFiscalOS,103),4,2) + left(convert(char(10),rtRelOSSituacao.DataEmissaoNotaFiscalOS,103),2)
 				 								 and   tbDocumento.CodigoCliFor = rtRelOSSituacao.CodigoCliFor
 				 								 and   tbDocumento.TipoLancamentoMovimentacao in (7,13))
										  else 0
										  end),0),
			@TotalOSs as 'TotalOSs',
	        coalesce(TipoRevisaoOS,'') as 'TipoRevisaoOS',
			CondicaoRetencaoISS
	
		INTO #rtRelOSSituacao

	 FROM 		rtRelOSSituacao (nolock)               
	
	 GROUP BY 	CodigoEmpresa,
				RazaoSocialEmpresa,
				CodigoLocal,
				DescricaoLocal,
				StatusOSCIT,
				StatusRel,
				CodigoCIT, 
				NumeroOROS, 
				CodigoCliFor,
				NomeCliFor, 
				PlacaVeiculoOS,
				DataAberturaOS,
				NumeroNotaFiscalMOB,
				NumeroNotaFiscalPEC,
				DataEmissaoNotaFiscalOS,
				ValorIPIDocumento,
				ValorLiquidoOS,
				CodigoRepresentante,
				NomeRepresentante, 
				MotivoCancelamentoOS, 
				NumeroFrotaVeiculo,
				DataEncerramentoOS,
				CentroCusto,
				ValorISSRetido,
				TipoRevisaoOS,
			    CondicaoRetencaoISS

	 SELECT * FROM	#rtRelOSSituacao (nolock)               
	 WHERE 		(  (@ImprimeMaoObraOS = 'V' and coalesce(ValorMaoObra,0) > 0)
         		or (@ImprimePecaOS = 'V' and coalesce(ValorPecas,0) > 0)
         		or (@ImprimePecaOS = 'V' and @ImprimeMaoObraOS = 'V'))

	 ORDER BY	CASE @Ordenacao WHEN 1 THEN CodigoCIT
			ELSE Str(NumeroOROS) END,
			NumeroOROS,
			NomeRepresentante 

GO
GRANT EXECUTE ON dbo.whRelOSSituacao TO SQLUsers
GO

go

if exists(select 1 from sysobjects where id = object_id('rtOSSituacao'))
drop TABLE dbo.rtOSSituacao
go
CREATE TABLE dbo.rtOSSituacao (
       Spid                 dtSpid,
       CodigoEmpresa        dtInteiro04 NULL,
       RazaoSocialEmpresa   varchar(60) NULL,
       CodigoLocal          dtInteiro04 NULL,
       DescricaoLocal       varchar(30) NULL,
       StatusOSCIT          dtCharacter01 NULL,
	   StatusRel            dtCharacter01 NULL,
       CodigoCIT            dtCharacter30 NULL,
       NumeroOROS           dtInteiro06 NULL,
       CodigoCliFor         NUMERIC(14)     NULL,
       NomeCliFor           varchar(60) NULL,
	   MunicipioCliFor      varchar(30) NULL,
       PlacaVeiculoOS       dtCharacter30 NULL,
       DataAberturaOS       datetime NULL,
	   NumeroNotaFiscalMOB	numeric(6)      NULL,
	   NumeroNotaFiscalPEC	numeric(6)      NULL,
	   DataEmissaoNotaFiscalOS DATETIME	NULL,
       ValorPecas           money NULL,
       ValorCombLub         money NULL,
       ValorMaoObra         money NULL,
       ValorMOTerc          money NULL,
       ValorIPIDocumento    money NULL,
       ValorLiquidoOS       money NULL,
       CodigoRepresentante  dtInteiro04 NULL,
       NomeRepresentante    varchar(60) NULL,
       ValorCustoMovimentoItem money NULL,
       DataEncerramentoOS   datetime NULL)

go
grant all on dbo.rtOSSituacao to SQLUsers
go

if exists(select 1 from sysobjects where id = object_id('rtOSSituacaoTot'))
drop TABLE dbo.rtOSSituacaoTot
go
CREATE TABLE dbo.rtOSSituacaoTot (
       Spid                 dtSpid,
       CodigoEmpresa        dtInteiro04 NULL,
       RazaoSocialEmpresa   varchar(60) NULL,
       CodigoLocal          dtInteiro04 NULL,
       DescricaoLocal       varchar(30) NULL,
       StatusOSCIT          dtCharacter01 NULL,
       CodigoCIT            dtCharacter30 NULL,
       NumeroOROS           dtInteiro06 NULL,
       CodigoCliFor         NUMERIC(14) NULL,
       NomeCliFor           varchar(60) NULL,
	   MunicipioCliFor      varchar(30) NULL,
       PlacaVeiculoOS       dtCharacter30 NULL,
       DataAberturaOS       datetime NULL,
	   NumeroNotaFiscalMOB	numeric(6)      NULL,
	   NumeroNotaFiscalPEC	numeric(6)      NULL,
	   DataEmissaoNotaFiscalOS DATETIME	NULL,
       ValorPecas           money NULL,
       ValorCombLub         money NULL,
       ValorMaoObra         money NULL,
       ValorMOTerc          money NULL,
       ValorIPIDocumento    money NULL,
       ValorLiquidoOS       money NULL,
       CodigoRepresentante  dtInteiro04 NULL,
       NomeRepresentante    varchar(60) NULL,
       ValorCustoMovimentoItem money NULL,
       DataEncerramentoOS   datetime NULL,
	   CodigoMaoObraOS      char(5) NULL,
	   HorasReaisItemMOOS   numeric(6,2) NULL,
	   StatusRel            dtCharacter01 NULL)
       
go
grant all on dbo.rtOSSituacaoTot to SQLUsers
go

if exists(select 1 from sysobjects where id = object_id('dbo.whRelOSSituacaoComp'))
DROP PROCEDURE dbo.whRelOSSituacaoComp
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
CREATE PROCEDURE dbo.whRelOSSituacaoComp

/*INICIO_CABEC_PROC
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 EMPRESA......: CDC - Consulters/Humaita
 PROJETO......: Oficina
 AUTOR........: Siu Guin Moo
 DATA.........: 03/07/1998
 UTILIZADO EM : <classe/modulo>.<metodo>
 OBJETIVO.....: Lista campos para o relatorio Ordem de Servico por Situacao
 ALTERACAO....: Obede 21.07.1999/24.08.1999
 OBJETIVO.....: ajustes
 ALTERACAO....: Arnaldo 24.09.1999
 OBJETIVO.....: Agrupar por CIT e ordenar por NumeroOROS

 ALTERACAO....: Carlos JSC 14/09/2009
 OBJETIVO.....: Imprimir numero da nota fiscal de serviço e de peca

 whRelOSSituacaoComp 'N','2008-01-01','2009-09-14','2008-01-01','2009-09-14',' ','ZZZZ',1608,0,1,' ','ZZZZZZZZZZ','1','99999999999999','S', 0, 99999999,1,9999, '1', '99999999999999','F','2008-01-01','2009-09-14','V','V'
 dbo.whRelOSSituacaoComp 'A',null,null,null,null,' ','ZZZZ',1608,0,1,' ','ZZZZZZZZZ',0,9999999999999,'O',0,99999999,0,9999,0,9999999999999,'V','2009-09-30','2009-09-30','V','V'

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/ 


	@Status						dtCharacter01,
	@DataAberturaPartir			datetime = Null,
	@DataAberturaAte      		datetime = Null,
	@DataEncerramentoPartir		datetime = Null,
	@DataEncerramentoAte		datetime = Null,
	@CITPartir					char(4) = '',
	@CITAte   					char(4) = '',
	@CodigoEmpresa				dtInteiro04,
	@CodigoLocal   				dtInteiro04,
	@Ordenacao					dtInteiro01,
	@DaPlaca					char(10),
	@AtePlaca					char(10),
	@DoCliente					char(14),
	@AteCliente					char(14),
	@FlagOROS					char(1),
	@DoCentroCusto				dtInteiro08 = NULL,
	@AteCentroCusto				dtInteiro08 = NULL,
	@RepresentantePartir		dtInteiro04,
	@RepresentanteAte			dtInteiro04,
	@DoClientePro				char(14),
	@AteClientePro				char(14),
	@PreOrdemServico			char(1),
	@DaDataEntrada				datetime = Null,
	@AteDataEntrada      		datetime = Null,
	@ImprimePecaOS				char(1),
	@ImprimeMaoObraOS			char(1),
	@DoCLMA					    char(22) = Null,
	@AteCLMA					char(22) = Null,
	@DoCLMO					    char(22) = Null,
	@AteCLMO					char(22) = Null

WITH ENCRYPTION
AS 

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DELETE rtOSSituacao WHERE Spid = @@Spid               
DELETE rtOSSituacaoTot WHERE Spid = @@Spid  

DECLARE @IntegradoMainframe	    char(1),
		@Periodo				numeric

select @DataAberturaPartir = convert(char,@DataAberturaPartir,120)
select @DataAberturaAte = convert(char,@DataAberturaAte,120)
select @DataEncerramentoPartir = convert(char,@DataEncerramentoPartir,120)
select @DataEncerramentoAte = convert(char,@DataEncerramentoAte,120)
select @DaDataEntrada = convert(char,@DaDataEntrada,120)
select @AteDataEntrada = convert(char,@AteDataEntrada,120)

-------------  Setar da inicio e termino default quando não informado na tela.
if @DaDataEntrada				is null select @DaDataEntrada = '1900-01-01'
if @AteDataEntrada				is null select @AteDataEntrada = '2500-12-31'
if @DataAberturaPartir			is null select @DataAberturaPartir = '1900-01-01'
if @DataAberturaAte				is null select @DataAberturaAte = '2500-12-31'
if @DataEncerramentoPartir		is null select @DataEncerramentoPartir = '1900-01-01'
if @DataEncerramentoAte			is null select @DataEncerramentoAte = '2500-12-31'

IF @DoCentroCusto IS NULL BEGIN SELECT @DoCentroCusto = 0 END
IF @AteCentroCusto IS NULL BEGIN SELECT @AteCentroCusto = 99999999 END
if @DoCLMA is null select @DoCLMA = ''
if @AteCLMA is null select @AteCLMA = 'zzzzzzzzzzzzzzzzzzzzzz'
if @DoCLMO is null  select @DoCLMO = ''
if @AteCLMO is null  select @AteCLMO = 'zzzzzzzzzzzzzzzzzzzzzz'

SELECT @IntegradoMainframe = (Select IntegradoMainframeFabrica from tbLocalOS  (nolock)
					where tbLocalOS.CodigoEmpresa = @CodigoEmpresa
					And   tbLocalOS.CodigoLocal   = @CodigoLocal)

SELECT @Periodo = (Select PeriodoAtualEstoque from tbEmpresaCE  (nolock)
					where tbEmpresaCE.CodigoEmpresa = @CodigoEmpresa)

--Para os tipos na combo do form = 'A'ndamento.
IF @Status = 'A' or @Status = 'L' or @Status = 'P' or @Status = 'R'
BEGIN

	INSERT  rtOSSituacao( Spid,
			    CodigoEmpresa ,
				RazaoSocialEmpresa,
                CodigoLocal,
				DescricaoLocal,
		        StatusOSCIT,
				StatusRel,
				CodigoCIT,
		        NumeroOROS,
				CodigoCliFor,
				NomeCliFor,
				MunicipioCliFor,
	            PlacaVeiculoOS,                 
				DataAberturaOS,                                         
				NumeroNotaFiscalMOB, 
				NumeroNotaFiscalPEC,
				DataEmissaoNotaFiscalOS, 
				ValorPecas,            
				ValorCombLub,
				ValorMaoObra,          
				ValorMOTerc,           
				ValorIPIDocumento,     
				ValorLiquidoOS,        
				CodigoRepresentante, 
				NomeRepresentante,                                            
				ValorCustoMovimentoItem,
				DataEncerramentoOS
				)	

	SELECT 		@@Spid,
			emp.CodigoEmpresa,
			emp.RazaoSocialEmpresa,
			loc.CodigoLocal,
			loc.DescricaoLocal,
			oc.StatusOSCIT,
			@Status,
			oc.CodigoCIT, 
			oc.NumeroOROS,
			oc.CodigoCliFor, 
   		        NomeCliFor = CASE WHEN @IntegradoMainframe = 'V' and cit.OSInternaCIT = 'V' and ce.NomeCliEven is not null
		   		     then ce.NomeCliEven
				     else 
			      		CASE WHEN @IntegradoMainframe = 'V' 
			      		THEN CASE ISNULL(oc.CodigoClienteEventualProp,0) WHEN 0
						  THEN  cp.NomeCliFor 
						  ELSE ce.NomeCliEven
					     END
			      		ELSE CASE ISNULL(oc.CodigoClienteEventualProp,0)WHEN 0
						  THEN cp.NomeCliFor 
						  ELSE ce.NomeCliEven
					      END
					END
				     end,

   		        MunicipioCliFor = CASE WHEN @IntegradoMainframe = 'V' and cit.OSInternaCIT = 'V' and ce.MunicipioCliEven is not null
		   		     then ce.MunicipioCliEven
				     else 
			      		CASE WHEN @IntegradoMainframe = 'V' 
			      		THEN CASE ISNULL(oc.CodigoClienteEventualProp,0) WHEN 0
						  THEN  cp.MunicipioCliFor 
						  ELSE ce.MunicipioCliEven
					     END
			      		ELSE CASE ISNULL(oc.CodigoClienteEventualProp,0)WHEN 0
						  THEN cp.MunicipioCliFor 
						  ELSE ce.MunicipioCliEven
					      END
					END
				     end,

			v.PlacaVeiculoOS,
			oro.DataAberturaOS,
			0,
			0,
			oc.DataEmissaoNotaFiscalOS,
			VrPecas = CASE WHEN (oct.TipoItemOS = 'P') 
					THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
					 	  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE itos.ValorLiquidoItemOS
							END
					 	  END) ELSE 0 END,		
			VrCombLub = CASE WHEN (oct.TipoItemOS = 'C') 
					THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
					 	  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
							THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
							ELSE itos.ValorLiquidoItemOS
							END
					 	  END) ELSE 0 END,		

			ValorMaoObra = 0, 
			ValorMOTerc =  	0, 

   		        CASE WHEN @IntegradoMainframe <> 'V'
				--------------------  Pesquisa Pelo Documento de NF
				THEN (SELECT coalesce(oc.ValorIPI, 0))
				--------------------  Pesquisa Pelo Documento de NF
				ELSE (SELECT coalesce(SUM(I.ValorIPI), 0) FROM tbItemOROS I (nolock)
						WHERE I.CodigoEmpresa = oc.CodigoEmpresa
						AND   I.CodigoLocal = oc.CodigoLocal						
						AND   I.FlagOROS = oc.FlagOROS
						AND   I.NumeroOROS = oc.NumeroOROS
						AND   I.CodigoCIT  = oc.CodigoCIT)
				END ValorIPIDocumento ,

			coalesce(oc.ValorLiquidoOS, 0),
			rep.CodigoRepresentante,
			rep.NomeRepresentante, 
			0,
			oro.DataEncerramentoOS

	FROM 		tbOROSCIT oc (nolock)

	INNER JOIN	tbEmpresa emp (nolock)
	ON		(emp.CodigoEmpresa = oc.CodigoEmpresa)

	INNER JOIN	tbLocal loc (nolock)
	ON		(loc.CodigoEmpresa = oc.CodigoEmpresa 
	AND		 loc.CodigoLocal = oc.CodigoLocal)

	INNER JOIN	tbOROS oro (nolock)
	ON		(oc.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 oc.CodigoLocal = oro.CodigoLocal 
	AND		 oc.FlagOROS = oro.FlagOROS
	AND		 oc.NumeroOROS = oro.NumeroOROS)

	INNER JOIN	tbCliFor cp (nolock)
	ON		(oro.CodigoEmpresa = cp.CodigoEmpresa
	AND		 oro.CodigoCliFor = cp.CodigoCliFor)

	INNER JOIN	tbCliFor cf (nolock)
	ON		(oc.CodigoEmpresa = cf.CodigoEmpresa
	AND		 oc.CodigoCliFor = cf.CodigoCliFor)

	INNER JOIN	tbVeiculoOS v (nolock)
	ON		(oro.CodigoEmpresa = v.CodigoEmpresa
	AND		 oro.ChassiVeiculoOS = v.ChassiVeiculoOS)

	INNER JOIN	tbOROSCITTipo oct (nolock)
	ON		(oc.CodigoEmpresa = oct.CodigoEmpresa 
	AND		 oc.CodigoLocal = oct.CodigoLocal 
	AND		 oc.FlagOROS = oct.FlagOROS
	AND		 oc.NumeroOROS = oct.NumeroOROS
	AND		 oc.CodigoCIT = oct.CodigoCIT)

	INNER JOIN	tbCIT cit (nolock)
	ON		cit.CodigoEmpresa = oc.CodigoEmpresa 
	AND		cit.CodigoCIT = oc.CodigoCIT

	INNER JOIN	tbRepresentanteComplementar rep (nolock)
	ON		 oc.CodigoRepresentante = rep.CodigoRepresentante
	AND		 oc.CodigoEmpresa = rep.CodigoEmpresa  

	LEFT JOIN 	tbItemOROS itos (nolock)
	ON		oct.CodigoEmpresa = itos.CodigoEmpresa
	AND		oct.CodigoLocal = itos.CodigoLocal
	AND		oct.FlagOROS = itos.FlagOROS
	AND		oct.NumeroOROS = itos.NumeroOROS
	AND		oct.CodigoCIT = itos.CodigoCIT
	AND		oct.TipoItemOS = itos.TipoItemOS

	LEFT JOIN	tbClienteEventual ce (nolock)
	ON		ce.CodigoEmpresa = oc.CodigoEmpresa 
	AND		ce.CodigoClienteEventual = oc.CodigoClienteEventualProp

	LEFT JOIN	tbOROSPO orospo (NOLOCK)
	ON		(orospo.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 orospo.CodigoLocal = oro.CodigoLocal 
	AND		 orospo.FlagOROS = oro.FlagOROS
	AND		 orospo.NumeroOROS = oro.NumeroOROS)

	LEFT JOIN 	tbColaboradorOSPO colabospo (nolock) 
	ON 		colabospo.CodigoEmpresa = orospo.CodigoEmpresa 
	AND 		colabospo.CodigoLocal = orospo.CodigoLocal 
	AND 		colabospo.CodigoColaboradorOS = orospo.CodigoColaboradorOS 

	WHERE		oc.FlagOROS    =  @FlagOROS
	AND		oc.StatusOSCIT = @Status
	AND		emp.CodigoEmpresa  = @CodigoEmpresa 	
	AND		loc.CodigoLocal    = @CodigoLocal   	
	AND		oc.CodigoCIT BETWEEN @CITPartir AND @CITAte
	AND		convert(char(10),oro.DataAberturaOS,120) BETWEEN @DataAberturaPartir AND @DataAberturaAte 
    AND	    convert(char(10),oro.DataEntradaVeiculoOS,120) BETWEEN @DaDataEntrada AND @AteDataEntrada
	
	AND             ((v.PlacaVeiculoOS BETWEEN @DaPlaca AND @AtePlaca) OR (v.PlacaVeiculoOS Is Null))	
	AND		oc.CodigoCliFor BETWEEN @DoCliente AND @AteCliente
	AND		oro.CodigoCliFor BETWEEN @DoClientePro AND @AteClientePro
	AND		oc.CentroCusto BETWEEN @DoCentroCusto AND @AteCentroCusto
	AND             ((emp.MarcaFabricanteEmpresa = '34' and oro.PreOrdemServico = @PreOrdemServico) or (emp.MarcaFabricanteEmpresa <> '34'))
	AND 		 ( 
                           ( orospo.CodigoColaboradorOS BETWEEN @RepresentantePartir AND @RepresentanteAte AND  		     
                             colabospo.CodigoEquipePO IS NOT NULL AND
			     colabospo.ConsultorTecnicoPO = 'V' ) or 
                           ( @RepresentantePartir = 0 and @RepresentanteAte = 9999)
                         ) 
	AND		oc.CLMA BETWEEN @DoCLMA AND @AteCLMA
	AND     oc.CLMO BETWEEN @DoCLMO AND @AteCLMO
END

--Para os tipos na combo do form = 'C'anceladas, 'E'ncerradas 
IF @Status = 'C' OR @Status = 'E' 
BEGIN

	INSERT 	rtOSSituacao(Spid,
			CodigoEmpresa ,
			RazaoSocialEmpresa,
			CodigoLocal,
			DescricaoLocal,
			StatusOSCIT,
			StatusRel,
			CodigoCIT,
			NumeroOROS,
			CodigoCliFor,
			NomeCliFor,
		    MunicipioCliFor,
			PlacaVeiculoOS,                 
			DataAberturaOS,                                         
			NumeroNotaFiscalMOB, 
			NumeroNotaFiscalPEC,
			DataEmissaoNotaFiscalOS,
			ValorPecas,
			ValorCombLub,            
			ValorMaoObra,          
			ValorMOTerc,           
			ValorIPIDocumento,     
			ValorLiquidoOS,        
			CodigoRepresentante, 
			NomeRepresentante,                                            
			ValorCustoMovimentoItem,
			DataEncerramentoOS
				)	

	SELECT 		@@Spid,
			emp.CodigoEmpresa,
			emp.RazaoSocialEmpresa,
			loc.CodigoLocal,
			loc.DescricaoLocal,
			oc.StatusOSCIT,
			@Status,
			oc.CodigoCIT, 
	 		oc.NumeroOROS, 
			oc.CodigoCliFor,
   		        NomeCliFor = CASE WHEN @IntegradoMainframe = 'V' and cit.OSInternaCIT = 'V' and ce.NomeCliEven is not null
		   		     then ce.NomeCliEven
				     else 
			      		CASE WHEN @IntegradoMainframe = 'V' 
			      		then cp.NomeCliFor 
			      		else cp.NomeCliFor 
			      		end
				     end,

   		        MunicipioCliFor = CASE WHEN @IntegradoMainframe = 'V' and cit.OSInternaCIT = 'V' and ce.MunicipioCliEven is not null
		   		     then ce.MunicipioCliEven
				     else 
			      		CASE WHEN @IntegradoMainframe = 'V' 
			      		THEN CASE ISNULL(oc.CodigoClienteEventualProp,0) WHEN 0
						  THEN  cp.MunicipioCliFor 
						  ELSE ce.MunicipioCliEven
					     END
			      		ELSE CASE ISNULL(oc.CodigoClienteEventualProp,0)WHEN 0
						  THEN cp.MunicipioCliFor 
						  ELSE ce.MunicipioCliEven
					      END
					END
				     end,

			v.PlacaVeiculoOS,
			oro.DataAberturaOS,
			0,
			0,
			oc.DataEmissaoNotaFiscalOS,
			VrPecas = CASE WHEN (oct.TipoItemOS = 'P') 
			THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
					THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
					ELSE itos.ValorLiquidoItemOS
					END
			 	  END) ELSE 0 END,	
			VrCombLub = CASE WHEN (oct.TipoItemOS = 'C') 
			THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
			 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
					THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
					ELSE itos.ValorLiquidoItemOS
					END
			 	  END) ELSE 0 END,	
			ValorMaoObra = 0, 
			ValorMOTerc =  	0, 
   		        CASE WHEN @IntegradoMainframe <> 'V'
				--------------------  Pesquisa Pelo Documento de NF
				THEN (SELECT coalesce(oc.ValorIPI, 0))
				--------------------  Pesquisa Pelo Documento de NF
				ELSE (SELECT coalesce(SUM(I.ValorIPI), 0) FROM tbItemOROS I (nolock)
						WHERE I.CodigoEmpresa = oc.CodigoEmpresa
						AND   I.CodigoLocal = oc.CodigoLocal						
						AND   I.FlagOROS = oc.FlagOROS
						AND   I.NumeroOROS = oc.NumeroOROS
						AND   I.CodigoCIT  = oc.CodigoCIT)
				END ValorIPIDocumento ,
			coalesce(oc.ValorLiquidoOS, 0),
			rep.CodigoRepresentante,
			rep.NomeRepresentante, 
			ValorCustoMovimentoItem = (0),
			oro.DataEncerramentoOS

	FROM 		tbOROSCIT oc (nolock)

	INNER JOIN	tbEmpresa emp (nolock)
	ON		(emp.CodigoEmpresa = oc.CodigoEmpresa)

	INNER JOIN	tbLocal loc (nolock)
	ON		(loc.CodigoEmpresa = oc.CodigoEmpresa 
	AND		 loc.CodigoLocal = oc.CodigoLocal)

	INNER JOIN	tbOROS oro (nolock)
	ON		(oc.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 oc.CodigoLocal = oro.CodigoLocal 
	AND		 oc.FlagOROS = oro.FlagOROS
	AND		 oc.NumeroOROS = oro.NumeroOROS)

	INNER JOIN	tbCliFor cp (nolock)
	ON		(oro.CodigoEmpresa = cp.CodigoEmpresa
	AND		 oro.CodigoCliFor = cp.CodigoCliFor)

	INNER JOIN	tbCliFor cf (nolock)
	ON		(oc.CodigoEmpresa = cf.CodigoEmpresa
	AND		 oc.CodigoCliFor = cf.CodigoCliFor)

	INNER JOIN	tbVeiculoOS v (nolock)
	ON		(oro.CodigoEmpresa = v.CodigoEmpresa
	AND		 oro.ChassiVeiculoOS = v.ChassiVeiculoOS)

	INNER JOIN	tbOROSCITTipo oct (nolock)
	ON		(oc.CodigoEmpresa = oct.CodigoEmpresa 
	AND		 oc.CodigoLocal = oct.CodigoLocal 
	AND		 oc.FlagOROS = oct.FlagOROS
	AND		 oc.NumeroOROS = oct.NumeroOROS
	AND		 oc.CodigoCIT = oct.CodigoCIT)

	INNER JOIN	tbCIT cit (nolock)
	ON		cit.CodigoEmpresa = oc.CodigoEmpresa 
	AND		cit.CodigoCIT = oc.CodigoCIT

	INNER JOIN	tbRepresentanteComplementar rep (nolock)
	ON		 oc.CodigoRepresentante = rep.CodigoRepresentante
	AND		 oc.CodigoEmpresa = rep.CodigoEmpresa  

	LEFT JOIN 	tbItemOROS itos (nolock)
	ON		oct.CodigoEmpresa = itos.CodigoEmpresa
	AND		oct.CodigoLocal = itos.CodigoLocal
	AND		oct.FlagOROS = itos.FlagOROS
	AND		oct.NumeroOROS = itos.NumeroOROS
	AND		oct.CodigoCIT = itos.CodigoCIT
	AND		oct.TipoItemOS = itos.TipoItemOS

	LEFT JOIN	tbClienteEventual ce (nolock)
	ON		ce.CodigoEmpresa = oc.CodigoEmpresa 
	AND		ce.CodigoClienteEventual = oc.CodigoClienteEventualProp

	LEFT JOIN	tbOROSPO orospo (NOLOCK)
	ON		(orospo.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 orospo.CodigoLocal = oro.CodigoLocal 
	AND		 orospo.FlagOROS = oro.FlagOROS
	AND		 orospo.NumeroOROS = oro.NumeroOROS)

	LEFT JOIN 	tbColaboradorOSPO colabospo (nolock) 
	ON 		colabospo.CodigoEmpresa = orospo.CodigoEmpresa 
	AND 		colabospo.CodigoLocal = orospo.CodigoLocal 
	AND 		colabospo.CodigoColaboradorOS = orospo.CodigoColaboradorOS 

	WHERE	oc.FlagOROS    = @FlagOROS
	AND		oc.StatusOSCIT = @Status
	AND		emp.CodigoEmpresa  = @CodigoEmpresa 	
	AND		loc.CodigoLocal    = @CodigoLocal   	
	AND		oc.CodigoCIT BETWEEN @CITPartir AND @CITAte
	AND		convert(char(10),oc.DataEncerramentoOSCIT,120) BETWEEN @DataEncerramentoPartir AND @DataEncerramentoAte 
	AND             ((v.PlacaVeiculoOS BETWEEN @DaPlaca AND @AtePlaca) OR (v.PlacaVeiculoOS Is Null) AND @DaPlaca = '' AND @AtePlaca = 'ZZZZZZZZZZ')
	AND		oc.CodigoCliFor BETWEEN @DoCliente AND @AteCliente
	AND		oro.CodigoCliFor BETWEEN @DoClientePro AND @AteClientePro
	AND             ((emp.MarcaFabricanteEmpresa = '34' and oro.PreOrdemServico = @PreOrdemServico) or (emp.MarcaFabricanteEmpresa <> '34'))
	and (not exists (select * from tbApontamentoMO apo (nolock)
			where apo.CodigoEmpresa = oct.CodigoEmpresa
			AND   apo.CodigoLocal = oct.CodigoLocal
			AND   apo.FlagOROS = oct.FlagOROS
			AND   apo.NumeroOROS = oct.NumeroOROS
			AND   apo.CodigoCIT = oct.CodigoCIT
			AND   apo.TipoItemOS = 'M') or 	oct.ValorLiquidoTipoOS <> 0
						    or  oc.ValorLiquidoOS <> 0)
			AND   oc.CentroCusto BETWEEN @DoCentroCusto AND @AteCentroCusto

	AND 		 ( 
                           ( orospo.CodigoColaboradorOS BETWEEN @RepresentantePartir AND @RepresentanteAte AND  		     
                             colabospo.CodigoEquipePO IS NOT NULL AND
			     colabospo.ConsultorTecnicoPO = 'V' ) or 
                           ( @RepresentantePartir = 0 and @RepresentanteAte = 9999)
                         ) 
	AND		oc.CLMA BETWEEN @DoCLMA AND @AteCLMA
	AND     oc.CLMO BETWEEN @DoCLMO AND @AteCLMO
END

IF @Status = 'Z'
BEGIN

	INSERT 	rtOSSituacao(Spid,
			CodigoEmpresa ,
			RazaoSocialEmpresa,
			CodigoLocal,
			DescricaoLocal,
			StatusOSCIT,
			StatusRel,
			CodigoCIT,
			NumeroOROS,
			CodigoCliFor,
			NomeCliFor,
		    MunicipioCliFor,
			PlacaVeiculoOS,                 
			DataAberturaOS,                                         
			NumeroNotaFiscalMOB, 
			NumeroNotaFiscalPEC,
			DataEmissaoNotaFiscalOS,
			ValorPecas,
			ValorCombLub,            
			ValorMaoObra,          
			ValorMOTerc,           
			ValorIPIDocumento,     
			ValorLiquidoOS,        
			CodigoRepresentante, 
			NomeRepresentante,                                            
			ValorCustoMovimentoItem,
			DataEncerramentoOS
		)	

	SELECT 		@@Spid,
			emp.CodigoEmpresa,
			emp.RazaoSocialEmpresa,
			loc.CodigoLocal,
			loc.DescricaoLocal,
			oc.StatusOSCIT,
			@Status,
			oc.CodigoCIT, 
	 		oc.NumeroOROS, 
			oc.CodigoCliFor,
   		        NomeCliFor = CASE WHEN @IntegradoMainframe = 'V' and cit.OSInternaCIT = 'V' and ce.NomeCliEven is not null
		   		     then ce.NomeCliEven
				     else 
			      		CASE WHEN @IntegradoMainframe = 'V' 
			      		then cp.NomeCliFor 
			      		else cp.NomeCliFor 
			      		end
				     end,

   		        MunicipioCliFor = CASE WHEN @IntegradoMainframe = 'V' and cit.OSInternaCIT = 'V' and ce.MunicipioCliEven is not null
		   		     then ce.MunicipioCliEven
				     else 
			      		CASE WHEN @IntegradoMainframe = 'V' 
			      		THEN CASE ISNULL(oc.CodigoClienteEventualProp,0) WHEN 0
						  THEN  cp.MunicipioCliFor 
						  ELSE ce.MunicipioCliEven
					     END
			      		ELSE CASE ISNULL(oc.CodigoClienteEventualProp,0)WHEN 0
						  THEN cp.MunicipioCliFor 
						  ELSE ce.MunicipioCliEven
					      END
					END
				     end,

			v.PlacaVeiculoOS,
			oro.DataAberturaOS,
			0,
			0,
			oc.DataEmissaoNotaFiscalOS,

			VrPecas = CASE WHEN (oct.TipoItemOS = 'P') 
			THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
	     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
					THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
					ELSE itos.ValorLiquidoItemOS
					END
			 	  END) ELSE 0 END,		
			VrCombLub = CASE WHEN (oct.TipoItemOS = 'C') 
			THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
	     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
					THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
					ELSE itos.ValorLiquidoItemOS
					END
			 	  END) ELSE 0 END,		
			ValorMaoObra = 0, 
			ValorMOTerc =  	0, 
   		        CASE WHEN @IntegradoMainframe <> 'V'
				--------------------  Pesquisa Pelo Documento de NF
				THEN (SELECT coalesce(oc.ValorIPI, 0))
				--------------------  Pesquisa Pelo Documento de NF
				ELSE (SELECT coalesce(SUM(I.ValorIPI), 0) FROM tbItemOROS I (nolock)
						WHERE I.CodigoEmpresa = oc.CodigoEmpresa
						AND   I.CodigoLocal = oc.CodigoLocal						
						AND   I.FlagOROS = oc.FlagOROS
						AND   I.NumeroOROS = oc.NumeroOROS
						AND   I.CodigoCIT  = oc.CodigoCIT)
				END ValorIPIDocumento ,
			coalesce(oc.ValorLiquidoOS, 0),
			rep.CodigoRepresentante,
			rep.NomeRepresentante, 
			ValorCustoMovimentoItem = (0),
			oro.DataEncerramentoOS

	FROM 		tbOROSCIT oc (nolock)

	INNER JOIN	tbEmpresa emp (nolock)
	ON		(emp.CodigoEmpresa = oc.CodigoEmpresa)

	INNER JOIN	tbLocal loc (nolock)
	ON		(loc.CodigoEmpresa = oc.CodigoEmpresa 
	AND		 loc.CodigoLocal = oc.CodigoLocal)

	INNER JOIN	tbOROS oro (nolock)
	ON		(oc.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 oc.CodigoLocal = oro.CodigoLocal 
	AND		 oc.FlagOROS = oro.FlagOROS
	AND		 oc.NumeroOROS = oro.NumeroOROS)

	INNER JOIN	tbCliFor cp (nolock)
	ON		(oro.CodigoEmpresa = cp.CodigoEmpresa
	AND		 oro.CodigoCliFor = cp.CodigoCliFor)

	INNER JOIN	tbCliFor cf (nolock)
	ON		(oc.CodigoEmpresa = cf.CodigoEmpresa
	AND		 oc.CodigoCliFor = cf.CodigoCliFor)

	INNER JOIN	tbVeiculoOS v (nolock)
	ON		(oro.CodigoEmpresa = v.CodigoEmpresa
	AND		 oro.ChassiVeiculoOS = v.ChassiVeiculoOS)

	INNER JOIN	tbOROSCITTipo oct (nolock)
	ON		(oc.CodigoEmpresa = oct.CodigoEmpresa 
	AND		 oc.CodigoLocal = oct.CodigoLocal 
	AND		 oc.FlagOROS = oct.FlagOROS
	AND		 oc.NumeroOROS = oct.NumeroOROS
	AND		 oc.CodigoCIT = oct.CodigoCIT)

	INNER JOIN	tbCIT cit (nolock)
	ON		cit.CodigoEmpresa = oc.CodigoEmpresa 
	AND		cit.CodigoCIT = oc.CodigoCIT

	INNER JOIN	tbRepresentanteComplementar rep (nolock)
	ON		 oc.CodigoRepresentante = rep.CodigoRepresentante
	AND		 oc.CodigoEmpresa = rep.CodigoEmpresa  

	INNER JOIN      tbItemMOOROS imo (nolock)
	ON		 imo.CodigoEmpresa = oct.CodigoEmpresa
	AND		 imo.CodigoLocal = oct.CodigoLocal
	AND		 imo.FlagOROS = oct.FlagOROS
	AND		 imo.NumeroOROS = oct.NumeroOROS
	AND		 imo.CodigoCIT = oct.CodigoCIT
	AND		 imo.TipoItemOS = 'M'

	INNER JOIN      tbApontamentoMO apo (nolock)
	ON		 apo.CodigoEmpresa = imo.CodigoEmpresa
	AND		 apo.CodigoLocal = imo.CodigoLocal
	AND		 apo.FlagOROS = imo.FlagOROS
	AND		 apo.NumeroOROS = imo.NumeroOROS
	AND		 apo.CodigoCIT = imo.CodigoCIT
	AND		 apo.TipoItemOS = 'M'

	LEFT JOIN 	tbItemOROS itos (nolock)
	ON		oct.CodigoEmpresa = itos.CodigoEmpresa
	AND		oct.CodigoLocal = itos.CodigoLocal
	AND		oct.FlagOROS = itos.FlagOROS
	AND		oct.NumeroOROS = itos.NumeroOROS
	AND		oct.CodigoCIT = itos.CodigoCIT
	AND		oct.TipoItemOS = itos.TipoItemOS

	LEFT JOIN	tbClienteEventual ce (nolock)
	ON		ce.CodigoEmpresa = oc.CodigoEmpresa 
	AND		ce.CodigoClienteEventual = oc.CodigoClienteEventualProp

	LEFT JOIN	tbOROSPO orospo (NOLOCK)
	ON		(orospo.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 orospo.CodigoLocal = oro.CodigoLocal 
	AND		 orospo.FlagOROS = oro.FlagOROS
	AND		 orospo.NumeroOROS = oro.NumeroOROS)

	LEFT JOIN 	tbColaboradorOSPO colabospo (nolock) 
	ON 		colabospo.CodigoEmpresa = orospo.CodigoEmpresa 
	AND 		colabospo.CodigoLocal = orospo.CodigoLocal 
	AND 		colabospo.CodigoColaboradorOS = orospo.CodigoColaboradorOS 

	WHERE		oc.FlagOROS    = @FlagOROS
	AND		oc.StatusOSCIT = 'E'
	AND		emp.CodigoEmpresa  = @CodigoEmpresa 	
	AND		loc.CodigoLocal    = @CodigoLocal   	
	AND		oc.CodigoCIT BETWEEN @CITPartir AND @CITAte
	AND		convert(char(10),oc.DataEncerramentoOSCIT,120) BETWEEN @DataEncerramentoPartir AND @DataEncerramentoAte
	AND             ((v.PlacaVeiculoOS BETWEEN @DaPlaca AND @AtePlaca) OR (v.PlacaVeiculoOS Is Null) AND @DaPlaca = '' AND @AtePlaca = 'ZZZZZZZZZZ')
	AND		oc.CodigoCliFor BETWEEN @DoCliente AND @AteCliente
	AND		oro.CodigoCliFor BETWEEN @DoClientePro AND @AteClientePro
	AND             oct.ValorLiquidoTipoOS = 0
	AND 		oc.ValorLiquidoOS = 0
	AND		oc.CentroCusto BETWEEN @DoCentroCusto AND @AteCentroCusto
	AND             ((emp.MarcaFabricanteEmpresa = '34' and oro.PreOrdemServico = @PreOrdemServico) or (emp.MarcaFabricanteEmpresa <> '34'))
	AND 		 ( 
                           ( orospo.CodigoColaboradorOS BETWEEN @RepresentantePartir AND @RepresentanteAte AND  		     
                             colabospo.CodigoEquipePO IS NOT NULL AND
			     colabospo.ConsultorTecnicoPO = 'V' ) or 
                           ( @RepresentantePartir = 0 and @RepresentanteAte = 9999)
                         ) 
	AND		oc.CLMA BETWEEN @DoCLMA AND @AteCLMA
	AND     oc.CLMO BETWEEN @DoCLMO AND @AteCLMO
END

IF @Status = 'N' 
BEGIN

	INSERT 	rtOSSituacao(Spid,
			CodigoEmpresa ,
			RazaoSocialEmpresa,
			CodigoLocal,
			DescricaoLocal,
			StatusOSCIT,
			StatusRel,
			CodigoCIT,
			NumeroOROS,
			CodigoCliFor,
			NomeCliFor,
		    MunicipioCliFor,
			PlacaVeiculoOS,                 
			DataAberturaOS,                                         
			NumeroNotaFiscalMOB, 
			NumeroNotaFiscalPEC,
			DataEmissaoNotaFiscalOS,
			ValorPecas,
			ValorCombLub,            
			ValorMaoObra,          
			ValorMOTerc,           
			ValorIPIDocumento,     
			ValorLiquidoOS,        
			CodigoRepresentante, 
			NomeRepresentante,                                            
			ValorCustoMovimentoItem,
			DataEncerramentoOS
				)	

	SELECT 		@@Spid,
			emp.CodigoEmpresa,
			emp.RazaoSocialEmpresa,
			loc.CodigoLocal,
			loc.DescricaoLocal,
			oc.StatusOSCIT,
			@Status,
			oc.CodigoCIT, 
			oc.NumeroOROS, 
			oc.CodigoCliFor,
   		        NomeCliFor = CASE WHEN @IntegradoMainframe = 'V' and cit.OSInternaCIT = 'V' and ce.NomeCliEven is not null
		   		     then ce.NomeCliEven
				     else 
			      		CASE WHEN @IntegradoMainframe = 'V' 
			      		then cp.NomeCliFor 
			      		else cp.NomeCliFor 
			      		end
				     end,

   		        MunicipioCliFor = CASE WHEN @IntegradoMainframe = 'V' and cit.OSInternaCIT = 'V' and ce.MunicipioCliEven is not null
		   		     then ce.MunicipioCliEven
				     else 
			      		CASE WHEN @IntegradoMainframe = 'V' 
			      		THEN CASE ISNULL(oc.CodigoClienteEventualProp,0) WHEN 0
						  THEN  cp.MunicipioCliFor 
						  ELSE ce.MunicipioCliEven
					     END
			      		ELSE CASE ISNULL(oc.CodigoClienteEventualProp,0)WHEN 0
						  THEN cp.MunicipioCliFor 
						  ELSE ce.MunicipioCliEven
					      END
					END
				     end,

			v.PlacaVeiculoOS,
			oro.DataAberturaOS,
			NumeroNotaFiscalMOB = coalesce((select max(tbPedido.NumeroNotaFiscalPed)
									 from tbOROSCITPedido
									 inner join tbPedido
											on  tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
											and tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
											and tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
											and tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
											and tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido

									 inner join tbNaturezaOperacao
											on  tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
											and tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									 where tbOROSCITPedido.CodigoEmpresa = oc.CodigoEmpresa
									 and   tbOROSCITPedido.CodigoLocal = oc.CodigoLocal
									 and   tbOROSCITPedido.FlagOROS = oc.FlagOROS
									 and   tbOROSCITPedido.NumeroOROS = oc.NumeroOROS
									 and   tbOROSCITPedido.CodigoCIT = oc.CodigoCIT
									 and   tbNaturezaOperacao.CodigoTipoOperacao = 10),0),
			NumeroNotaFiscalPEC = coalesce((select max(tbPedido.NumeroNotaFiscalPed)
									 from tbOROSCITPedido
									 inner join tbPedido
											on  tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
											and tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
											and tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
											and tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
											and tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido

									 inner join tbNaturezaOperacao
											on  tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
											and tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									 where tbOROSCITPedido.CodigoEmpresa = oc.CodigoEmpresa
									 and   tbOROSCITPedido.CodigoLocal = oc.CodigoLocal
									 and   tbOROSCITPedido.FlagOROS = oc.FlagOROS
									 and   tbOROSCITPedido.NumeroOROS = oc.NumeroOROS
									 and   tbOROSCITPedido.CodigoCIT = oc.CodigoCIT
									 and   tbNaturezaOperacao.CodigoTipoOperacao <> 10),0),
			oc.DataEmissaoNotaFiscalOS,
			VrPecas = CASE WHEN (oct.TipoItemOS = 'P') 
			THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
	     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
					THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
					ELSE itos.ValorLiquidoItemOS
					END
			 	  END) ELSE 0 END,	
			VrCombLub = CASE WHEN (oct.TipoItemOS = 'C') 
			THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
	     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
					THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
					ELSE itos.ValorLiquidoItemOS
					END
			 	  END) ELSE 0 END,	
			ValorMaoObra = 0, 
			ValorMOTerc =  	0, 
--Evandro - Soma do IPI
   		        CASE WHEN @IntegradoMainframe <> 'V'
				--------------------  Pesquisa Pelo Documento de NF
				THEN (SELECT coalesce(oc.ValorIPI, 0))
				--------------------  Pesquisa Pelo Documento de NF
				ELSE (SELECT coalesce(SUM(I.ValorIPI), 0) FROM tbItemOROS I (nolock)
						WHERE I.CodigoEmpresa = oc.CodigoEmpresa
						AND   I.CodigoLocal = oc.CodigoLocal						
						AND   I.FlagOROS = oc.FlagOROS
						AND   I.NumeroOROS = oc.NumeroOROS
						AND   I.CodigoCIT  = oc.CodigoCIT)
				END ValorIPIDocumento ,
			coalesce(oc.ValorLiquidoOS, 0),
			rep.CodigoRepresentante,
			rep.NomeRepresentante, 
			0,	
			oro.DataEncerramentoOS

	FROM 		tbOROSCIT oc (nolock)

	INNER JOIN	tbEmpresa emp (nolock)
	ON		(emp.CodigoEmpresa = oc.CodigoEmpresa)

	INNER JOIN	tbLocal loc (nolock)
	ON		(loc.CodigoEmpresa = oc.CodigoEmpresa 
	AND		 loc.CodigoLocal = oc.CodigoLocal)

	INNER JOIN	tbOROS oro (nolock)
	ON		(oc.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 oc.CodigoLocal = oro.CodigoLocal 
	AND		 oc.FlagOROS = oro.FlagOROS
	AND		 oc.NumeroOROS = oro.NumeroOROS)

	INNER JOIN	tbCliFor cp (nolock)
	ON		(oro.CodigoEmpresa = cp.CodigoEmpresa
	AND		 oro.CodigoCliFor = cp.CodigoCliFor)

	INNER JOIN	tbCliFor cf (nolock)
	ON		(oc.CodigoEmpresa = cf.CodigoEmpresa
	AND		 oc.CodigoCliFor = cf.CodigoCliFor)

	INNER JOIN 	tbVeiculoOS v (nolock)
	ON		(oro.CodigoEmpresa = v.CodigoEmpresa
	AND		 oro.ChassiVeiculoOS = v.ChassiVeiculoOS)

	INNER JOIN	tbOROSCITTipo oct (nolock)
	ON		(oc.CodigoEmpresa = oct.CodigoEmpresa 
	AND		 oc.CodigoLocal = oct.CodigoLocal 
	AND		 oc.FlagOROS = oct.FlagOROS
	AND		 oc.NumeroOROS = oct.NumeroOROS
	AND		 oc.CodigoCIT = oct.CodigoCIT)

	INNER JOIN	tbCIT cit (nolock)
	ON		cit.CodigoEmpresa = oc.CodigoEmpresa 
	AND		cit.CodigoCIT = oc.CodigoCIT

	INNER JOIN	tbRepresentanteComplementar rep (nolock)
	ON		 oc.CodigoRepresentante = rep.CodigoRepresentante
	AND		 oc.CodigoEmpresa = rep.CodigoEmpresa  

	LEFT JOIN 	tbItemOROS itos (nolock)
	ON		oct.CodigoEmpresa = itos.CodigoEmpresa
	AND		oct.CodigoLocal = itos.CodigoLocal
	AND		oct.FlagOROS = itos.FlagOROS
	AND		oct.NumeroOROS = itos.NumeroOROS
	AND		oct.CodigoCIT = itos.CodigoCIT
	AND		oct.TipoItemOS = itos.TipoItemOS

	LEFT JOIN	tbClienteEventual ce (nolock)
	ON		ce.CodigoEmpresa = oc.CodigoEmpresa 
	AND		ce.CodigoClienteEventual = oc.CodigoClienteEventualProp

	LEFT JOIN	tbOROSPO orospo (NOLOCK)
	ON		(orospo.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 orospo.CodigoLocal = oro.CodigoLocal 
	AND		 orospo.FlagOROS = oro.FlagOROS
	AND		 orospo.NumeroOROS = oro.NumeroOROS)

	LEFT JOIN 	tbColaboradorOSPO colabospo (nolock) 
	ON 		colabospo.CodigoEmpresa = orospo.CodigoEmpresa 
	AND 		colabospo.CodigoLocal = orospo.CodigoLocal 
	AND 		colabospo.CodigoColaboradorOS = orospo.CodigoColaboradorOS 

	WHERE	oc.FlagOROS    = @FlagOROS
	AND		oc.StatusOSCIT = @Status
	AND		emp.CodigoEmpresa  = @CodigoEmpresa 	
	AND		loc.CodigoLocal    = @CodigoLocal   	
	AND		oc.CodigoCIT BETWEEN @CITPartir AND @CITAte
	AND		convert(char(10),oc.DataEmissaoNotaFiscalOS,120) BETWEEN @DataEncerramentoPartir AND @DataEncerramentoAte 
	AND             ((v.PlacaVeiculoOS BETWEEN @DaPlaca AND @AtePlaca) OR (v.PlacaVeiculoOS Is Null) AND @DaPlaca = '' AND @AtePlaca = 'ZZZZZZZZZZ')
	AND		oc.CodigoCliFor BETWEEN @DoCliente AND @AteCliente
	AND		oro.CodigoCliFor BETWEEN @DoClientePro AND @AteClientePro
	AND		oc.CentroCusto BETWEEN @DoCentroCusto AND @AteCentroCusto

	AND 		 ( 
                           ( orospo.CodigoColaboradorOS BETWEEN @RepresentantePartir AND @RepresentanteAte AND  		     
                             colabospo.CodigoEquipePO IS NOT NULL AND
			     colabospo.ConsultorTecnicoPO = 'V' ) or 
                           ( @RepresentantePartir = 0 and @RepresentanteAte = 9999)
	AND		oc.CLMA BETWEEN @DoCLMA AND @AteCLMA
	AND     oc.CLMO BETWEEN @DoCLMO AND @AteCLMO                         ) 
END

--Para os tipos na combo do form = 'T-Todos Status'.
IF @Status = 'T'
BEGIN
	INSERT 	rtOSSituacao(Spid,
			CodigoEmpresa ,
			RazaoSocialEmpresa,
			CodigoLocal,
			DescricaoLocal,
			StatusOSCIT,
			StatusRel,
			CodigoCIT,
			NumeroOROS,
			CodigoCliFor,
			NomeCliFor,
		    MunicipioCliFor,
			PlacaVeiculoOS,                 
			DataAberturaOS,                                         
			NumeroNotaFiscalMOB, 
			NumeroNotaFiscalPEC,
			DataEmissaoNotaFiscalOS,
			ValorPecas,
			ValorCombLub,            
			ValorMaoObra,          
			ValorMOTerc,           
			ValorIPIDocumento,     
			ValorLiquidoOS,        
			CodigoRepresentante, 
			NomeRepresentante,                                            
			ValorCustoMovimentoItem,
			DataEncerramentoOS
				)	

	SELECT 		@@Spid,
			emp.CodigoEmpresa,
			emp.RazaoSocialEmpresa,
			loc.CodigoLocal,
			loc.DescricaoLocal,
			oc.StatusOSCIT,
			@Status,
			oc.CodigoCIT, 
			oc.NumeroOROS, 
			oc.CodigoCliFor,
   		        NomeCliFor = CASE WHEN @IntegradoMainframe = 'V' and cit.OSInternaCIT = 'V' and ce.NomeCliEven is not null
		   		     then ce.NomeCliEven
				     else 
			      		CASE WHEN @IntegradoMainframe = 'V' 
			      		THEN CASE ISNULL(oc.CodigoClienteEventualProp,0) WHEN 0
						  THEN  cp.NomeCliFor 
						  ELSE ce.NomeCliEven
					     END
			      		ELSE CASE ISNULL(oc.CodigoClienteEventualProp,0)WHEN 0
						  THEN cp.NomeCliFor 
						  ELSE ce.NomeCliEven
					      END
					END
				     end,

   		        MunicipioCliFor = CASE WHEN @IntegradoMainframe = 'V' and cit.OSInternaCIT = 'V' and ce.MunicipioCliEven is not null
		   		     then ce.MunicipioCliEven
				     else 
			      		CASE WHEN @IntegradoMainframe = 'V' 
			      		THEN CASE ISNULL(oc.CodigoClienteEventualProp,0) WHEN 0
						  THEN  cp.MunicipioCliFor 
						  ELSE ce.MunicipioCliEven
					     END
			      		ELSE CASE ISNULL(oc.CodigoClienteEventualProp,0)WHEN 0
						  THEN cp.MunicipioCliFor 
						  ELSE ce.MunicipioCliEven
					      END
					END
				     end,

			v.PlacaVeiculoOS,
			oro.DataAberturaOS,
			NumeroNotaFiscalMOB = coalesce((select MAX(tbPedido.NumeroNotaFiscalPed)
									 from tbOROSCITPedido
									 inner join tbPedido
											on  tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
											and tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
											and tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
											and tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
											and tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido

									 inner join tbNaturezaOperacao
											on  tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
											and tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									 where tbOROSCITPedido.CodigoEmpresa = oc.CodigoEmpresa
									 and   tbOROSCITPedido.CodigoLocal = oc.CodigoLocal
									 and   tbOROSCITPedido.FlagOROS = oc.FlagOROS
									 and   tbOROSCITPedido.NumeroOROS = oc.NumeroOROS
									 and   tbOROSCITPedido.CodigoCIT = oc.CodigoCIT
									 and   tbNaturezaOperacao.CodigoTipoOperacao = 10),0),
			NumeroNotaFiscalPEC = coalesce((select MAX(tbPedido.NumeroNotaFiscalPed)
									 from tbOROSCITPedido
									 inner join tbPedido
											on  tbPedido.CodigoEmpresa = tbOROSCITPedido.CodigoEmpresa
											and tbPedido.CodigoLocal = tbOROSCITPedido.CodigoLocal
											and tbPedido.CentroCusto = tbOROSCITPedido.CentroCusto
											and tbPedido.NumeroPedido = tbOROSCITPedido.NumeroPedido
											and tbPedido.SequenciaPedido = tbOROSCITPedido.SequenciaPedido

									 inner join tbNaturezaOperacao
											on  tbNaturezaOperacao.CodigoEmpresa = tbPedido.CodigoEmpresa
											and tbNaturezaOperacao.CodigoNaturezaOperacao = tbPedido.CodigoNaturezaOperacao
									 where tbOROSCITPedido.CodigoEmpresa = oc.CodigoEmpresa
									 and   tbOROSCITPedido.CodigoLocal = oc.CodigoLocal
									 and   tbOROSCITPedido.FlagOROS = oc.FlagOROS
									 and   tbOROSCITPedido.NumeroOROS = oc.NumeroOROS
									 and   tbOROSCITPedido.CodigoCIT = oc.CodigoCIT
									 and   tbNaturezaOperacao.CodigoTipoOperacao <> 10),0),
			oc.DataEmissaoNotaFiscalOS,

			VrPecas = CASE WHEN (oct.TipoItemOS = 'P') 
			THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
	     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
					THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
					ELSE itos.ValorLiquidoItemOS
					END
			 	  END) ELSE 0 END,		
			VrCombLub = CASE WHEN (oct.TipoItemOS = 'C') 
			THEN (CASE WHEN itos.ValorLiquidoInvisivelItemOS <> 0 
			 	  THEN coalesce(itos.ValorLiquidoInvisivelItemOS, 0)
	     		 	  ELSE CASE WHEN itos.ValorDescontoRateadoItemOROS <> 0
					THEN coalesce(itos.ValorBrutoItemOS - itos.ValorDescontoRateadoItemOROS,0)
					ELSE itos.ValorLiquidoItemOS
					END
			 	  END) ELSE 0 END,		
			ValorMaoObra = 0, 
			ValorMOTerc =  	0, 

   		        CASE WHEN @IntegradoMainframe <> 'V'
				--------------------  Pesquisa Pelo Documento de NF
				THEN (SELECT coalesce(oc.ValorIPI, 0))
				--------------------  Pesquisa Pelo Documento de NF
				ELSE (SELECT coalesce(SUM(I.ValorIPI), 0) FROM tbItemOROS I (nolock)
						WHERE I.CodigoEmpresa = oc.CodigoEmpresa
						AND   I.CodigoLocal = oc.CodigoLocal						
						AND   I.FlagOROS = oc.FlagOROS
						AND   I.NumeroOROS = oc.NumeroOROS
						AND   I.CodigoCIT  = oc.CodigoCIT)
				END ValorIPIDocumento ,

			coalesce(oc.ValorLiquidoOS, 0),
			rep.CodigoRepresentante,
			rep.NomeRepresentante, 
			0,
			oro.DataEncerramentoOS

	FROM 		tbOROSCIT oc (nolock)

	INNER JOIN	tbEmpresa emp (nolock)
	ON		(emp.CodigoEmpresa = oc.CodigoEmpresa)

	INNER JOIN	tbLocal loc (nolock)
	ON		(loc.CodigoEmpresa = oc.CodigoEmpresa 
	AND		 loc.CodigoLocal = oc.CodigoLocal)

	INNER JOIN	tbOROS oro (nolock)
	ON		(oc.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 oc.CodigoLocal = oro.CodigoLocal 
	AND		 oc.FlagOROS = oro.FlagOROS
	AND		 oc.NumeroOROS = oro.NumeroOROS)

	INNER JOIN	tbCliFor cp (nolock)
	ON		(oro.CodigoEmpresa = cp.CodigoEmpresa
	AND		 oro.CodigoCliFor = cp.CodigoCliFor)

	INNER JOIN	tbCliFor cf (nolock)
	ON		(oc.CodigoEmpresa = cf.CodigoEmpresa
	AND		 oc.CodigoCliFor = cf.CodigoCliFor)

	INNER JOIN	tbVeiculoOS v (nolock)
	ON		(oro.CodigoEmpresa = v.CodigoEmpresa
	AND		 oro.ChassiVeiculoOS = v.ChassiVeiculoOS)

	INNER JOIN	tbOROSCITTipo oct (nolock)
	ON		(oc.CodigoEmpresa = oct.CodigoEmpresa 
	AND		 oc.CodigoLocal = oct.CodigoLocal 
	AND		 oc.FlagOROS = oct.FlagOROS
	AND		 oc.NumeroOROS = oct.NumeroOROS
	AND		 oc.CodigoCIT = oct.CodigoCIT)

	INNER JOIN	tbCIT cit (nolock)
	ON		cit.CodigoEmpresa = oc.CodigoEmpresa 
	AND		cit.CodigoCIT = oc.CodigoCIT

	INNER JOIN	tbRepresentanteComplementar rep (nolock)
	ON		 oc.CodigoRepresentante = rep.CodigoRepresentante
	AND		 oc.CodigoEmpresa = rep.CodigoEmpresa  

	LEFT JOIN 	tbItemOROS itos (nolock)
	ON		oct.CodigoEmpresa = itos.CodigoEmpresa
	AND		oct.CodigoLocal = itos.CodigoLocal
	AND		oct.FlagOROS = itos.FlagOROS
	AND		oct.NumeroOROS = itos.NumeroOROS
	AND		oct.CodigoCIT = itos.CodigoCIT
	AND		oct.TipoItemOS = itos.TipoItemOS

	LEFT JOIN	tbClienteEventual ce (nolock)
	ON		ce.CodigoEmpresa = oc.CodigoEmpresa 
	AND		ce.CodigoClienteEventual = oc.CodigoClienteEventualProp

	LEFT JOIN	tbOROSPO orospo (NOLOCK)
	ON		(orospo.CodigoEmpresa = oro.CodigoEmpresa 
	AND		 orospo.CodigoLocal = oro.CodigoLocal 
	AND		 orospo.FlagOROS = oro.FlagOROS
	AND		 orospo.NumeroOROS = oro.NumeroOROS)

	LEFT JOIN 	tbColaboradorOSPO colabospo (nolock) 
	ON 		colabospo.CodigoEmpresa = orospo.CodigoEmpresa 
	AND 		colabospo.CodigoLocal = orospo.CodigoLocal 
	AND 		colabospo.CodigoColaboradorOS = orospo.CodigoColaboradorOS 

	WHERE		oc.FlagOROS    =  @FlagOROS
	AND		emp.CodigoEmpresa  = @CodigoEmpresa 	
	AND		loc.CodigoLocal    = @CodigoLocal   	
	AND		oc.CodigoCIT BETWEEN @CITPartir AND @CITAte
	AND		( (oc.StatusOSCIT = 'A' and convert(char(10),oro.DataAberturaOS,120) BETWEEN @DataAberturaPartir AND @DataAberturaAte) or
			  (oc.StatusOSCIT = 'A' and @DaDataEntrada <> '1900-01-01' and convert(char(10),oro.DataEntradaVeiculoOS,120) BETWEEN @DaDataEntrada AND @AteDataEntrada) or
			  (oc.StatusOSCIT = 'L' and convert(char(10),oro.DataAberturaOS,120) BETWEEN @DataAberturaPartir AND @DataAberturaAte) or
			  (oc.StatusOSCIT = 'R' and convert(char(10),oro.DataAberturaOS,120) BETWEEN @DataAberturaPartir AND @DataAberturaAte) or
			  (oc.StatusOSCIT = 'P' and convert(char(10),oro.DataAberturaOS,120) BETWEEN @DataAberturaPartir AND @DataAberturaAte) or
			  (oc.StatusOSCIT in ('E','C') and convert(char(10),oc.DataEncerramentoOSCIT,120) BETWEEN @DataEncerramentoPartir AND @DataEncerramentoAte) or 
	                  (oc.StatusOSCIT = 'N' and convert(char(10),oc.DataEmissaoNotaFiscalOS,120) BETWEEN @DataEncerramentoPartir AND @DataEncerramentoAte))
	AND             ((v.PlacaVeiculoOS BETWEEN @DaPlaca AND @AtePlaca) OR (v.PlacaVeiculoOS Is Null))	
	AND		oc.CodigoCliFor BETWEEN @DoCliente AND @AteCliente
	AND		oro.CodigoCliFor BETWEEN @DoClientePro AND @AteClientePro
	AND		oc.CentroCusto BETWEEN @DoCentroCusto AND @AteCentroCusto
	AND             ((emp.MarcaFabricanteEmpresa = '34' and oro.PreOrdemServico = @PreOrdemServico) or (emp.MarcaFabricanteEmpresa <> '34'))
	AND 		 ( 
                           ( orospo.CodigoColaboradorOS BETWEEN @RepresentantePartir AND @RepresentanteAte AND  		     
                             colabospo.CodigoEquipePO IS NOT NULL AND
			     colabospo.ConsultorTecnicoPO = 'V' ) or 
                           ( @RepresentantePartir = 0 and @RepresentanteAte = 9999)
                         ) 
	AND		oc.CLMA BETWEEN @DoCLMA AND @AteCLMA
	AND     oc.CLMO BETWEEN @DoCLMO AND @AteCLMO
END

--Select na tab. temporaria!
	INSERT 	rtOSSituacaoTot(Spid,
			CodigoEmpresa ,
			RazaoSocialEmpresa,
			CodigoLocal,
			DescricaoLocal,
			StatusOSCIT,
			StatusRel,
			CodigoCIT,
			NumeroOROS,
			CodigoCliFor,
			NomeCliFor,
		    MunicipioCliFor,
			PlacaVeiculoOS,                 
			DataAberturaOS,                                         
			NumeroNotaFiscalMOB, 
			NumeroNotaFiscalPEC,
			DataEmissaoNotaFiscalOS,
			ValorPecas,
			ValorCombLub,            
			ValorMaoObra,          
			ValorMOTerc,           
			ValorIPIDocumento,     
			ValorLiquidoOS,        
			CodigoRepresentante, 
			NomeRepresentante,                                            
			ValorCustoMovimentoItem,
			DataEncerramentoOS
			)              

	SELECT		@@Spid,
			CodigoEmpresa,
			RazaoSocialEmpresa,
			CodigoLocal,
			DescricaoLocal,
			StatusOSCIT,
			StatusRel,
			CodigoCIT, 
			NumeroOROS, 		
			CodigoCliFor,
			NomeCliFor, 
			MunicipioCliFor,
			PlacaVeiculoOS,
			DataAberturaOS,
			NumeroNotaFiscalMOB,
			NumeroNotaFiscalPEC,
			DataEmissaoNotaFiscalOS,
			coalesce(Sum(ValorPecas), 0) ValorPecas,
			coalesce(Sum(ValorCombLub), 0) ValorCombLub,
			coalesce(Sum(ValorMaoObra), 0) ValorMaoObra,
			coalesce(Sum(ValorMOTerc), 0) ValorMOTerc, 
			coalesce(ValorIPIDocumento, 0),
			coalesce(ValorLiquidoOS + ValorIPIDocumento, 0),
			CodigoRepresentante,
			NomeRepresentante,
			coalesce(sum(ValorCustoMovimentoItem), 0),
			DataEncerramentoOS
	
	FROM 		rtOSSituacao (nolock)
	
	WHERE  		Spid =@@Spid 
	
	GROUP BY 	CodigoEmpresa,
			RazaoSocialEmpresa,
			CodigoLocal,
			DescricaoLocal,
			StatusOSCIT,
			StatusRel,
			CodigoCIT, 
			NumeroOROS, 
			CodigoCliFor,
			NomeCliFor, 
		    MunicipioCliFor,
			PlacaVeiculoOS,
			DataAberturaOS,
			NumeroNotaFiscalMOB,
			NumeroNotaFiscalPEC,
			DataEmissaoNotaFiscalOS,
			ValorIPIDocumento,
			ValorLiquidoOS,
			CodigoRepresentante,
			NomeRepresentante,
			DataEncerramentoOS
	
	ORDER BY	CASE @Ordenacao WHEN 1 THEN CodigoCIT
			ELSE Str(NumeroOROS) END,
			NomeRepresentante

---------------------------------------------- Totalizatr OS´s - CAC 21579/2005
declare @TotalOSs numeric(6)
select @TotalOSs = count(distinct NumeroOROS) from rtOSSituacaoTot
-------------------------------------------------------------------------------

set nocount off

SELECT	rtOSSituacaoTot.CodigoEmpresa,
		RazaoSocialEmpresa,
		rtOSSituacaoTot.CodigoLocal,
		DescricaoLocal,
		rtOSSituacaoTot.StatusOSCIT,
		StatusRel,
		rtOSSituacaoTot.CodigoCIT, 
		rtOSSituacaoTot.NumeroOROS, 
		rtOSSituacaoTot.CodigoCliFor, 
		rtOSSituacaoTot.NomeCliFor,
		rtOSSituacaoTot.MunicipioCliFor, 
		rtOSSituacaoTot.PlacaVeiculoOS,
		rtOSSituacaoTot.DataAberturaOS,
		rtOSSituacaoTot.NumeroNotaFiscalMOB,
		rtOSSituacaoTot.NumeroNotaFiscalPEC,
		rtOSSituacaoTot.DataEmissaoNotaFiscalOS,
		ValorPecas,
		ValorCombLub,
		ValorMaoObra = coalesce((select CASE WHEN sum(ValorDescontoRateadoItemOROS) <> 0
						THEN (sum(ValorBrutoItemOS - ValorDescontoRateadoItemOROS))
						ELSE sum(ValorLiquidoItemOS)
						END
					from tbItemOROS 
					inner join tbItemMOOROS  (nolock) on 	 
						tbItemOROS.CodigoEmpresa = tbItemMOOROS.CodigoEmpresa and 
						tbItemOROS.CodigoLocal = tbItemMOOROS.CodigoLocal and 
						tbItemOROS.FlagOROS = tbItemMOOROS.FlagOROS and
						tbItemOROS.NumeroOROS  = tbItemMOOROS.NumeroOROS and 
						tbItemOROS.CodigoCIT = tbItemMOOROS.CodigoCIT and 
						tbItemOROS.TipoItemOS = 'M' and 
						tbItemOROS.SequenciaItemOS = tbItemMOOROS.SequenciaItemOS 
					inner join tbMaoObraOS  (nolock) on 
						tbMaoObraOS.CodigoEmpresa = tbItemMOOROS.CodigoEmpresa and 
						tbMaoObraOS.CodigoMaoObraOS = tbItemMOOROS.CodigoMaoObraOS
					where 	rtOSSituacaoTot.CodigoEmpresa = tbItemMOOROS.CodigoEmpresa and 
						rtOSSituacaoTot.CodigoLocal = tbItemMOOROS.CodigoLocal and 
						tbItemMOOROS.FlagOROS = @FlagOROS and
						rtOSSituacaoTot.NumeroOROS  = tbItemMOOROS.NumeroOROS and 
						rtOSSituacaoTot.CodigoCIT = tbItemMOOROS.CodigoCIT and 
						AcumuladorMDO <> 5),0),

		ValorMOTer = coalesce((select CASE WHEN sum(ValorDescontoRateadoItemOROS) <> 0
						THEN (sum(ValorBrutoItemOS - ValorDescontoRateadoItemOROS))
						ELSE sum(ValorLiquidoItemOS)
						END
					from tbItemOROS 

					inner join tbItemMOOROS (nolock) on 	
						tbItemOROS.CodigoEmpresa = tbItemMOOROS.CodigoEmpresa and 
						tbItemOROS.CodigoLocal = tbItemMOOROS.CodigoLocal and 
						tbItemOROS.FlagOROS = tbItemMOOROS.FlagOROS and
						tbItemOROS.NumeroOROS  = tbItemMOOROS.NumeroOROS and 
						tbItemOROS.CodigoCIT = tbItemMOOROS.CodigoCIT and 
						tbItemOROS.TipoItemOS = 'M' and 
						tbItemOROS.SequenciaItemOS = tbItemMOOROS.SequenciaItemOS 
					inner join tbMaoObraOS(nolock) on  
						tbMaoObraOS.CodigoEmpresa = tbItemMOOROS.CodigoEmpresa and 
						tbMaoObraOS.CodigoMaoObraOS = tbItemMOOROS.CodigoMaoObraOS
					where 	rtOSSituacaoTot.CodigoEmpresa = tbItemMOOROS.CodigoEmpresa and 
						rtOSSituacaoTot.CodigoLocal = tbItemMOOROS.CodigoLocal and 
						tbItemMOOROS.FlagOROS = @FlagOROS and
						rtOSSituacaoTot.NumeroOROS  = tbItemMOOROS.NumeroOROS and 
						rtOSSituacaoTot.CodigoCIT = tbItemMOOROS.CodigoCIT and 
						AcumuladorMDO = 5),0), 
		coalesce(rtOSSituacaoTot.ValorIPIDocumento, 0) as 'ValorIPIDocumento', 
		coalesce(rtOSSituacaoTot.ValorLiquidoOS, 0) as 'ValorLiquidoOS',
		rtOSSituacaoTot.CodigoRepresentante,
		NomeRepresentante, 
		ModeloVeiculoOS, 
		tbVeiculoOS.ChassiVeiculoOS, 
		HorasReais = COALESCE((select sum(HorasReaisItemMOOS) from tbItemOROS 
					inner join tbItemMOOROS (nolock) on 	
						tbItemOROS.CodigoEmpresa = tbItemMOOROS.CodigoEmpresa and 
						tbItemOROS.CodigoLocal = tbItemMOOROS.CodigoLocal and 
						tbItemOROS.FlagOROS = tbItemMOOROS.FlagOROS and
						tbItemOROS.NumeroOROS  = tbItemMOOROS.NumeroOROS and 
						tbItemOROS.CodigoCIT = tbItemMOOROS.CodigoCIT and 
						tbItemOROS.TipoItemOS = 'M' and 
						tbItemOROS.SequenciaItemOS = tbItemMOOROS.SequenciaItemOS 
					where 	rtOSSituacaoTot.CodigoEmpresa = tbItemMOOROS.CodigoEmpresa and 
						rtOSSituacaoTot.CodigoLocal = tbItemMOOROS.CodigoLocal and 
						tbItemMOOROS.FlagOROS = @FlagOROS and
						rtOSSituacaoTot.NumeroOROS  = tbItemMOOROS.NumeroOROS and 
						rtOSSituacaoTot.CodigoCIT = tbItemMOOROS.CodigoCIT),0), 
		ValorCustoMovimentoItem = case when tbOROSCIT.StatusOSCIT = 'N' ----- Custo da Venda
					       then COALESCE((SELECT SUM (ValorCustoMovimentoItemPed * QuantidadeItemPed)
							FROM tbOROSCITPedido ocp (nolock)
							INNER  JOIN 	tbItemPedido ip (nolock)
							ON 		 ip.CodigoEmpresa = rtOSSituacaoTot.CodigoEmpresa 
							AND 		 ip.CodigoLocal = rtOSSituacaoTot.CodigoLocal 
							AND 		 ip.CentroCusto = ocp.CentroCusto 
							AND 		 ip.NumeroPedido = ocp.NumeroPedido 
							AND 		 ip.SequenciaPedido = ocp.SequenciaPedido
							WHERE 		 ocp.CodigoEmpresa = rtOSSituacaoTot.CodigoEmpresa 
							AND		 ocp.CodigoLocal = rtOSSituacaoTot.CodigoLocal 
							AND		 ocp.FlagOROS = @FlagOROS
							AND		 ocp.NumeroOROS = rtOSSituacaoTot.NumeroOROS and CodigoItemPed is null
							AND		 ocp.CodigoCIT = rtOSSituacaoTot.CodigoCIT ),0)
						else ---- Custo da OS em Aberto ou Encerrada sem Nota Fiscal;
							(COALESCE((select sum(tbValorEstoquePeriodo.SaldoValorEstoque) from tbItemOROS 
								inner join tbItemProdOROS (nolock) on 	
									tbItemOROS.CodigoEmpresa = tbItemProdOROS.CodigoEmpresa and 
									tbItemOROS.CodigoLocal = tbItemProdOROS.CodigoLocal and 
									tbItemOROS.FlagOROS = tbItemProdOROS.FlagOROS and
									tbItemOROS.NumeroOROS  = tbItemProdOROS.NumeroOROS and 
									tbItemOROS.CodigoCIT = tbItemProdOROS.CodigoCIT and 
									tbItemOROS.TipoItemOS = tbItemProdOROS.TipoItemOS and 
									tbItemOROS.SequenciaItemOS = tbItemProdOROS.SequenciaItemOS 

								inner join tbValorEstoquePeriodo (nolock) on
									tbItemProdOROS.CodigoEmpresa = tbValorEstoquePeriodo.CodigoEmpresa and 
									tbItemProdOROS.CodigoLocal = tbValorEstoquePeriodo.CodigoLocal and 
									tbItemProdOROS.CodigoProdutoItemOROS = tbValorEstoquePeriodo.CodigoProduto and
									@Periodo = tbValorEstoquePeriodo.PeriodoValorEstoque 

								where 	rtOSSituacaoTot.CodigoEmpresa = tbItemProdOROS.CodigoEmpresa and 
									rtOSSituacaoTot.CodigoLocal = tbItemProdOROS.CodigoLocal and 
									tbItemProdOROS.FlagOROS = @FlagOROS and
									rtOSSituacaoTot.NumeroOROS  = tbItemProdOROS.NumeroOROS and 
									rtOSSituacaoTot.CodigoCIT = tbItemProdOROS.CodigoCIT),0)
 							/   -------------- Valor Total de Estoque / Quantidade Saldo Atual Amoxarifado Produto
							COALESCE((select sum(vwSaldoGeralProdutoPeriodo.EstoqueGeral) from tbItemOROS 
								inner join tbItemProdOROS (nolock) on 	
									tbItemOROS.CodigoEmpresa = tbItemProdOROS.CodigoEmpresa and 
									tbItemOROS.CodigoLocal = tbItemProdOROS.CodigoLocal and 
									tbItemOROS.FlagOROS = tbItemProdOROS.FlagOROS and
									tbItemOROS.NumeroOROS  = tbItemProdOROS.NumeroOROS and 
									tbItemOROS.CodigoCIT = tbItemProdOROS.CodigoCIT and 
									tbItemOROS.TipoItemOS = tbItemProdOROS.TipoItemOS and 
									tbItemOROS.SequenciaItemOS = tbItemProdOROS.SequenciaItemOS 

								inner join vwSaldoGeralProdutoPeriodo (nolock) on
									tbItemProdOROS.CodigoEmpresa = vwSaldoGeralProdutoPeriodo.CodigoEmpresa and 
									tbItemProdOROS.CodigoLocal = vwSaldoGeralProdutoPeriodo.CodigoLocal and 
									tbItemProdOROS.CodigoProdutoItemOROS = vwSaldoGeralProdutoPeriodo.CodigoProduto and
									@Periodo = vwSaldoGeralProdutoPeriodo.Periodo

								where 	rtOSSituacaoTot.CodigoEmpresa = tbItemProdOROS.CodigoEmpresa and 
									rtOSSituacaoTot.CodigoLocal = tbItemProdOROS.CodigoLocal and 
									tbItemProdOROS.FlagOROS = @FlagOROS and
									rtOSSituacaoTot.NumeroOROS  = tbItemProdOROS.NumeroOROS and 
									rtOSSituacaoTot.CodigoCIT = tbItemProdOROS.CodigoCIT),1))
							* -------------- Custo Unitario * Quantidade do Produto da OS.
							COALESCE((select sum(QuantidadeItemOS) from tbItemOROS  (nolock)
								inner join tbItemProdOROS (nolock) on 	
									tbItemOROS.CodigoEmpresa = tbItemProdOROS.CodigoEmpresa and 
									tbItemOROS.CodigoLocal = tbItemProdOROS.CodigoLocal and 
									tbItemOROS.FlagOROS = tbItemProdOROS.FlagOROS and
									tbItemOROS.NumeroOROS  = tbItemProdOROS.NumeroOROS and 
									tbItemOROS.CodigoCIT = tbItemProdOROS.CodigoCIT and 
									tbItemOROS.TipoItemOS = tbItemProdOROS.TipoItemOS and 
									tbItemOROS.SequenciaItemOS = tbItemProdOROS.SequenciaItemOS 
								where 	rtOSSituacaoTot.CodigoEmpresa = tbItemProdOROS.CodigoEmpresa and 
									rtOSSituacaoTot.CodigoLocal = tbItemProdOROS.CodigoLocal and 
									tbItemProdOROS.FlagOROS = @FlagOROS and
									rtOSSituacaoTot.NumeroOROS  = tbItemProdOROS.NumeroOROS and 
									rtOSSituacaoTot.CodigoCIT = tbItemProdOROS.CodigoCIT),0)
						end,

		HorasFaturadas = COALESCE((	SELECT 	SUM(QuantidadeItemOS) 
					FROM	tbItemOROS  (nolock)
					WHERE 	tbItemOROS.CodigoEmpresa = rtOSSituacaoTot.CodigoEmpresa 
					AND 	tbItemOROS.CodigoLocal = rtOSSituacaoTot.CodigoLocal 
					AND 	tbItemOROS.FlagOROS = @FlagOROS 
					AND 	tbItemOROS.NumeroOROS = rtOSSituacaoTot.NumeroOROS
					AND 	tbItemOROS.CodigoCIT = rtOSSituacaoTot.CodigoCIT
					AND 	tbItemOROS.TipoItemOS = 'M'
				 ),0),
		tbOROS.KmVeiculoOS,
		rtOSSituacaoTot.DataEncerramentoOS,            -- CAC 26011/2002
		tbOROSCIT.CentroCusto,
		coalesce(tbOROSCIT.TipoRevisaoOS,' ') as 'TipoRevisaoOS',
		coalesce(CASE WHEN tbOROSCIT.StatusOSCIT <> 'N' 
			 then tbOROSCIT.ValorISSRetido
			 else case when tbCliFor.CondicaoRetencaoISS = 'V'
					   then (select ValorISSDocumento from tbDocumento
										 where tbDocumento.CodigoEmpresa = tbOROSCIT.CodigoEmpresa
									 and   tbDocumento.CodigoLocal = tbOROSCIT.CodigoLocal
									 and   tbDocumento.EntradaSaidaDocumento = 'S'
	 				 				 and   tbDocumento.NumeroDocumento = rtOSSituacaoTot.NumeroNotaFiscalMOB
	 				 				 and   tbDocumento.DataDocumento = right(convert(char(10),tbOROSCIT.DataEmissaoNotaFiscalOS,103),4) + SUBSTRING(convert(char(10),tbOROSCIT.DataEmissaoNotaFiscalOS,103),4,2) + left(convert(char(10),tbOROSCIT.DataEmissaoNotaFiscalOS,103),2)
	 				 				 and   tbDocumento.CodigoCliFor = tbOROSCIT.CodigoCliFor
	 				 				 and   tbDocumento.TipoLancamentoMovimentacao in (7,13))
					    else 0
						end
			 end,0) ValorISSRetido,

		@TotalOSs as 'TotalOSs'

into #rtOSSituacaoTot
FROM 		rtOSSituacaoTot (nolock)

INNER JOIN	tbOROS  (nolock)
ON		(rtOSSituacaoTot.CodigoEmpresa = tbOROS.CodigoEmpresa 
AND		 rtOSSituacaoTot.CodigoLocal = tbOROS.CodigoLocal 
AND		 tbOROS.FlagOROS = @FlagOROS
AND		 rtOSSituacaoTot.NumeroOROS = tbOROS.NumeroOROS)

INNER JOIN	tbOROSCIT (nolock)
ON		rtOSSituacaoTot.CodigoEmpresa = tbOROSCIT.CodigoEmpresa 
AND		rtOSSituacaoTot.CodigoLocal = tbOROSCIT.CodigoLocal 
AND		tbOROSCIT.FlagOROS = @FlagOROS
AND		rtOSSituacaoTot.NumeroOROS = tbOROSCIT.NumeroOROS
AND		rtOSSituacaoTot.CodigoCIT = tbOROSCIT.CodigoCIT

INNER JOIN 	tbVeiculoOS  (nolock)
ON		(tbOROS.CodigoEmpresa = tbVeiculoOS.CodigoEmpresa
AND		 tbOROS.ChassiVeiculoOS = tbVeiculoOS.ChassiVeiculoOS)

INNER JOIN 	tbCliFor  (nolock)
ON		(tbCliFor.CodigoEmpresa = tbOROSCIT.CodigoEmpresa
AND		 tbCliFor.CodigoCliFor = tbOROSCIT.CodigoCliFor)

WHERE rtOSSituacaoTot.Spid = @@Spid

ORDER BY rtOSSituacaoTot.CodigoEmpresa,
	 rtOSSituacaoTot.CodigoLocal,
	CASE @Ordenacao 
		WHEN 1 
		THEN rtOSSituacaoTot.CodigoCIT
		ELSE Str(rtOSSituacaoTot.NumeroOROS) 
	END,
	CASE @Ordenacao 
		WHEN 1 
		THEN Str(rtOSSituacaoTot.NumeroOROS)
		ELSE rtOSSituacaoTot.CodigoCIT 
	END

----------------------  Lista tabela temporaria  ---------------------

select * from #rtOSSituacaoTot 
where (    (@ImprimeMaoObraOS = 'V' and ValorMaoObra > 0)
        or (@ImprimePecaOS = 'V' and ValorPecas > 0)
        or (@ImprimePecaOS = 'V' and @ImprimeMaoObraOS = 'V'))

ORDER BY #rtOSSituacaoTot.CodigoEmpresa,
	 #rtOSSituacaoTot.CodigoLocal,
	CASE @Ordenacao 
		WHEN 1 
		THEN #rtOSSituacaoTot.CodigoCIT
		ELSE Str(#rtOSSituacaoTot.NumeroOROS) 
	END,
	CASE @Ordenacao 
		WHEN 1 
		THEN Str(#rtOSSituacaoTot.NumeroOROS)
		ELSE #rtOSSituacaoTot.CodigoCIT 
	END

SET NOCOUNT ON
DELETE rtOSSituacao WHERE Spid = @@Spid               
DELETE rtOSSituacaoTot WHERE Spid = @@Spid
SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whRelOSSituacaoComp TO SQLUsers
GO

go

if exists(select 1 from sysobjects where id = object_id('whVerificaPedidoComNFEmitida'))
DROP PROCEDURE dbo.whVerificaPedidoComNFEmitida
GO

CREATE PROCEDURE dbo.whVerificaPedidoComNFEmitida
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: Humaita
 PROJETO......: FT - Faturamento
 AUTOR........: Marcio Schvartz
 DATA.........: 10-06-2002
 UTILIZADO EM : clsPedido.ExisteNFEmitidaParaPedido
 OBJETIVO.....: Verifica se o pedido ja possui NF emitida
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

-- whVerificaPedidoComNFEmitida 1580, 0, 11310, 30123, 0


@CodigoEmpresa		numeric(4),
@CodigoLocal		numeric(4),
@CentroCusto		numeric(8),
@NumeroPedido		numeric(6),
@SequenciaPedido	numeric(2)


WITH ENCRYPTION
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


SELECT	a.NumeroDocumento, 
	a.DataDocumento, 
	a.CodigoCliFor

FROM	tbDocumento a
INNER JOIN tbDocumentoFT b
ON	b.CodigoEmpresa				= a.CodigoEmpresa
AND	b.CodigoLocal				= a.CodigoLocal
AND	b.EntradaSaidaDocumento			= a.EntradaSaidaDocumento
AND	b.NumeroDocumento			= a.NumeroDocumento
AND	b.DataDocumento				= a.DataDocumento
AND	b.CodigoCliFor				= a.CodigoCliFor
AND	b.TipoLancamentoMovimentacao		= a.TipoLancamentoMovimentacao
WHERE 	a.CodigoEmpresa				= @CodigoEmpresa
AND	a.CodigoLocal				= @CodigoLocal
AND	a.NumeroPedidoDocumento			= @NumeroPedido
AND	a.NumeroSequenciaPedidoDocumento	= @SequenciaPedido
AND	b.CentroCusto				= @CentroCusto
AND	a.CondicaoNFCancelada			= 'F'
AND	a.TipoLancamentoMovimentacao		= 7
AND	a.NumeroPedidoDocumento			!= a.NumeroDocumento

UNION ALL

SELECT	a.NumeroDocumento, 
	a.DataDocumento, 
	a.CodigoCliFor

FROM	NFDocumento a
INNER JOIN NFDocumentoFT b
ON	b.CodigoEmpresa				= a.CodigoEmpresa
AND	b.CodigoLocal				= a.CodigoLocal
AND	b.EntradaSaidaDocumento			= a.EntradaSaidaDocumento
AND	b.NumeroDocumento			= a.NumeroDocumento
AND	b.DataDocumento				= a.DataDocumento
AND	b.CodigoCliFor				= a.CodigoCliFor
AND	b.TipoLancamentoMovimentacao		= a.TipoLancamentoMovimentacao
WHERE 	a.CodigoEmpresa				= @CodigoEmpresa
AND	a.CodigoLocal				= @CodigoLocal
AND	a.NumeroPedidoDocumento			= @NumeroPedido
AND	a.NumeroSequenciaPedidoDocumento	= @SequenciaPedido
AND	b.CentroCusto				= @CentroCusto
AND	a.CondicaoNFCancelada			= 'F'
AND	a.TipoLancamentoMovimentacao		= 13
AND	a.NumeroPedidoDocumento			!= a.NumeroDocumento


SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whVerificaPedidoComNFEmitida TO SQLUsers
GO

go

if exists(select 1 from sysobjects where id = object_id('whRelTPFichaVisita'))
DROP PROCEDURE dbo.whRelTPFichaVisita
GO
CREATE PROCEDURE dbo.whRelTPFichaVisita

/*
------------------------------------------------------------------------------------------------------------------------------------
 Desenvolvedor.: Alex Kmez
 Data..........: 01/12/2004
 Sistema.......: CRM - Truck Plus      
 Motivo........: 

 whRelTPFichaVisita 1608, 0, 'P', '2006-12-04 00:00:00.000', '2006-12-08 00:00:00.000', 0, 9999, 0 , 99999999999999, 0, 99, 0, 99
 whRelTPFichaVisita 1470, 0, 'E', '2007-10-01 00:00:00.000', '2007-10-01 00:00:00.000', 21, 21, 0 , 99999999999999, 0, 99, 0, 99
 whRelTPFichaVisita 1608, 0, 'A', '2009-09-14 00:00:00.000', '2009-09-18 00:00:00.000', 0, 9999, 0, 99999999999999, 0, 99, 0, 99, 'F'
	
go
 whRelTPFichaVisita 1608, 0, 'A', '2009-09-14',				 '2009-09-18',			   '1','1',0,99999999999999,0,99,0,99,'F'

EXECUTE whRelTPFichaVisita @CodigoEmpresa = 1608,@CodigoLocal = 0,@TipoCliente = 'A',@DaData = '2009-09-14',@AteData = '2009-09-18',@DoRepresentante = '1',@AteRepresentante = '1',@DoCliente = 0,@AteCliente = 99999999999999,@DaPropensao = 0,@AtePropensao = 99,@DoCliFrota = 0,@AteCliFrota = 99,@ImprimeFollowUp = 'F'

EXECUTE whRelTPFichaVisita @CodigoEmpresa = 1608,@CodigoLocal = 0,@TipoCliente = 'A',@DaData = '2009-09-14',@AteData = '2009-09-18',@DoRepresentante = '0',@AteRepresentante = '9999',@DoCliente = 0,@AteCliente = 99999999999999,@DaPropensao = 0,@AtePropensao = 99,@DoCliFrota = 0,@AteCliFrota = 99,@ImprimirResultado = 'F',@ImprimeFollowUp = 'F'

------------------------------------------------------------------------------------------------------------------------------------
*/

	@CodigoEmpresa 			numeric(4),
   	@CodigoLocal 			numeric(4),
	@TipoCliente	        char(1),    --------> (E)fetivo/(P)otencial
	@DaData					datetime,
	@AteData				datetime,
   	@DoRepresentante        numeric(4),
    @AteRepresentante       numeric(4),
    @DoCliente              numeric(14),
    @AteCliente             numeric(14),
    @DaPropensao            numeric(2),
    @AtePropensao           numeric(2),
    @DoCliFrota             numeric(2),
    @AteCliFrota            numeric(2),
	@ImprimirResultado		char(1),
	@ImprimeFollowUp		char(1) = null

AS 

SET NOCOUNT ON

DECLARE	@DoClienteResultVis	numeric(14)
DECLARE	@AteClienteResultVis	numeric(14)
DECLARE @CodigoContatoCliente1	numeric(6)
DECLARE @CodigoContatoCliente2	numeric(6)

DELETE FROM rtContatoCliente
WHERE spID = @@spID

DELETE FROM rtResultadoVisita
WHERE spID = @@spID

if @TipoCliente = 'P' or @TipoCliente = 'A'
	BEGIN

 	INSERT rtFichaVisita
	SELECT  DISTINCT
		spID = @@spID,
		tbPreparacaoVisitaST.CodigoEmpresa,
		tbPreparacaoVisitaST.CodigoLocal,
		tbPreparacaoVisitaST.TipoCliEfetivoPotencial,
		-- DADOS GERAIS
		tbClienteStarTruck.ClienteTPCaminhoes,
		tbClienteStarTruck.ClienteTPOnibus,
		tbClienteStarTruck.ClienteTPSprinter,
		tbClienteStarTruck.ClienteTPOutros,
		tbClienteStarTruck.RecEmailPropag,
		case 	
			when tbClientePotencial.CGCCPFClientePotencial = null then
				'N'
			when len(tbClientePotencial.CGCCPFClientePotencial) > 11 then
				'J'
			else
				'F'
		end										as TipoCliFor,
		tbPreparacaoVisitaST.CodigoClienteST,
		tbClienteStarTruck.DataCadastroTP,
	        tbPreparacaoVisitaST.CodigoRepresentante,
		tbRepresentanteComplementar.NomeRepresentante,
		TamanhoFrota = coalesce((
					select sum(b.QtdeVeiculosFrotaCliente) 
					from tbCaracteristicaCliente a (NOLOCK)
					inner join tbFrotaCliente b (NOLOCK)
					on	a.CodigoEmpresa	= b.CodigoEmpresa
					and	a.CodigoClientePotencial = tbClienteStarTruck.CodigoClienteST
					WHERE	b.CodigoEmpresa	= @CodigoEmpresa
					and	b.NumeroClientePotencialEfetivo	= a.NumeroClientePotencialEfetivo
					),0),
		tbClienteRepresentanteTP.PropensaoCompra,
		tbPropensaoCompraST.DescrPropCompra, 
		tbClientePotencial.RazaoSocialClientePotencial 			as RazaoSocialCliente,
		tbClientePotencial.CGCCPFClientePotencial 			as CNPJ,
		tbClientePotencial.NomeUsualClientePotencial 			as NomeFantasiaCliente,
		tbClientePotencial.InscrEstadualClientePotencial 		as InscrEstadual,
		tbClientePotencial.RuaClientePotencial				as Rua,
		tbClientePotencial.NumeroClientePotencial			as Numero, 
		tbClientePotencial.BairroClientePotencial			as Bairro,
		tbClientePotencial.MunicipioClientePotencial			as Municipio,
		tbClientePotencial.UnidadeFederacao				as UF,
		tbClientePotencial.CEPClientePotencial				as CEP,
		case 	
			when (tbClientePotencial.DDDFoneComercialClientePot = '' or tbClientePotencial.DDDFoneComercialClientePot is null) then
				coalesce(tbClientePotencial.DDDFoneResidenciaClientePot,'')
		     	else
				coalesce(tbClientePotencial.DDDFoneComercialClientePot,'')
		end 	as DDD,
		case 	
			when (tbClientePotencial.FoneComercialClientePot = '' or tbClientePotencial.FoneComercialClientePot is null) then
				coalesce(tbClientePotencial.FoneResidenciaClientePot, '')
		     	else
				coalesce(tbClientePotencial.FoneComercialClientePot, '')
		end 	as Fone,
		coalesce(tbClientePotencial.DDDFaxClientePotencial, '') 	as DDDFax,
		coalesce(tbClientePotencial.FoneFaxClientePotencial, '')	as Fax,
		tbAtividade.DescricaoAtividade					as DescricaoAtividade,

		-- CONTATOS
		convert(varchar(50),'') as NomeContato1,    
		convert(varchar(50),'') as FuncaoContato1,
		convert(varchar(20),'') as DataAniversarioContato1,
		convert(varchar(50),'') as email1,
		convert(varchar(4),'') as DDDCelularContClienteTP1, 
		convert(varchar(15),'') as CelularContatoClienteTP1,
		convert(varchar(4),'') as DDDFoneContatoClienteTP1,  
		convert(varchar(15),'') as FoneContatoClienteTP1, 
		convert(varchar(20),'') as DescrTimeFutebol1,  
		convert(varchar(20),'') as DescrHobby1, 
		convert(varchar(50),'') as NomeContato2,    
		convert(varchar(50),'') as FuncaoContato2,
		convert(varchar(20),'') as DataAniversarioContato2,
		convert(varchar(50),'') as email2,
		convert(varchar(4),'') as DDDCelularContClienteTP2, 
		convert(varchar(15),'') as CelularContatoClienteTP2,
		convert(varchar(4),'') as DDDFoneContatoClienteTP2,  
		convert(varchar(15),'') as FoneContatoClienteTP2, 
		convert(varchar(20),'') as DescrTimeFutebol2,  
		convert(varchar(20),'') as DescrHobby2, 

		-- HISTORICO DE VISITAS
		convert(varchar(20),'') as DataResultadoVisita1,
		convert(varchar(30),'') as ContatoVisita1,
		convert(varchar(300),'') as ComentarioVisita1,
		convert(varchar(300),'') as PendenciaProxVisita1,
		convert(varchar(2),'') as PropCompraResultado1,
		convert(varchar(20),'') as DataResultadoVisita2,
		convert(varchar(30),'') as ContatoVisita2,
		convert(varchar(300),'') as ComentarioVisita2,
		convert(varchar(2),'') as PropCompraResultado2,
		convert(varchar(20),'') as DataResultadoVisita3,
		convert(varchar(30),'') as ContatoVisita3,
		convert(varchar(300),'') as ComentarioVisita3,
		convert(varchar(2),'') as PropCompraResultado3,

		QtdeTotalLeves = 0,
		QtdeTotalMedios = 0,
		QtdeTotalSemiPesados = 0,
		QtdeTotalPesados = 0,
		QtdeTotalExtraPesados = 0,
		QtdeTotalFrota = 0,
		QtdeMBLeves = 0,
		QtdeMBMedios = 0,
		QtdeMBSemiPesados = 0,
		QtdeMBPesados = 0,
		QtdeMBExtraPesados = 0,
		QtdeFrotaMB = 0,
		QtdeOutrosLeves = 0,
		QtdeOutrosMedios = 0,
		QtdeOutrosSemiPesados = 0,
		QtdeOutrosPesados = 0,
		QtdeOutrosExtraPesados = 0,
		QtdeFrotaOutros = 0,
		IdadeMediaLeves = 0,
		IdadeMediaMedios = 0,
		IdadeMediaSemiPesados = 0,
		IdadeMediaPesados = 0,
		IdadeMediaExtraPesados = 0,
		IdadeMediaTotal = 0,

		coalesce(tbSegurosTP.SeguroMBTotal, 'N'),
		coalesce(tbSegurosTP.SeguroMBTerceiros, 'N'),
		coalesce(tbSegurosTP.SeguroMBOutros, 'N'),
		coalesce(tbSegurosTP.SeguroTotal, 'N'),
		coalesce(tbSegurosTP.SeguroTerceiros, 'N'),
		coalesce(tbSegurosTP.SeguroOutros, 'N'),
		tbSegurosTP.QuantVeicSegurados,
		coalesce(tbPosVendaTP.PossuiOficinaPropria,'N'),
		coalesce(tbPosVendaTP.PossuiEstoquePecProprio,'N'),
		coalesce(tbPosVendaTP.PossuiContrManut,'N'),
		coalesce(tbPosVendaTP.PossuiContrManutMB,'N'),
		coalesce(tbPosVendaTP.PossuiContrManutOutros,'N'),
		coalesce(tbPosVendaTP.PossuiGarantEstend,'N'),
		coalesce(tbPosVendaTP.PossuiGarantEstendMB,'N'),
		coalesce(tbPosVendaTP.PossuiGarantEstendOutros,'N'),
		coalesce(tbPosVendaTP.FazRevisoes,'9'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoVista,'N'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoLeasing,'N'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoCDC,'N'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoFiname,'N'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoConsorcio,'N'),
		coalesce(tbDadosFinanceirosTP.AprovCredito,'9'),
		coalesce(tbDadosFinanceirosTP.BancoMB,'N'),
		coalesce(tbDadosFinanceirosTP.BancoOutros,'N'),
		coalesce(tbDadosFinanceirosTP.NaoPossuiCredito,'N'),

		-- VENDAS PERDIDAS
		QuantVendPerdLeves = 0,
		QuantVendPerdMedios = 0,
		QuantVendPerdSemiPesados = 0,
		QuantVendPerdPesados = 0,
		QuantVendPerdExtraPesados =0,

		-- HISTORICO DE VENDAS
		QuantVendNovosLeves = 0,
		QuantVendNovosMedios = 0,
		QuantVendNovosSemiPesados = 0,
		QuantVendNovosPesados = 0,
		QuantVendNovosExtraPesados = 0,
		QuantVendSemiNovosLeves = 0,
		QuantVendSemiNovosMedios = 0,
		QuantVendSemiNovosSemiPesados = 0,
		QuantVendSemiNovosPesados = 0,
		QuantVendSemiNovosExtraPesados = 0,
		DataUltCompNovosLeves = '1900-01-01',
		DataUltCompNovosMedios = '1900-01-01',
		DataUltCompNovosSemiPesados = '1900-01-01',
		DataUltCompNovosPesados = '1900-01-01',
		DataUltCompNovosExtPes = '1900-01-01',
		DataUltCompSemiNovLeves = '1900-01-01',
		DataUltCompSemiNovMedios = '1900-01-01',
		DataUltCompSemiNovSemiPes = '1900-01-01',
		DataUltCompSemiNovPesados = '1900-01-01',
		DataUltCompSemiNovExtPes = '1900-01-01',
		TipoClienteFrota = coalesce (( select max(TipoClienteFrota )
						from tbTipoCliFrotaST (NOLOCK)
						where tbTipoCliFrotaST.CodigoEmpresa = @CodigoEmpresa
						and   tbTipoCliFrotaST.CodigoLocal = @CodigoLocal
						and   (SELECT sum(b.QtdeVeiculosFrotaCliente)
					FROM	tbCaracteristicaCliente a (NOLOCK)
					INNER JOIN tbFrotaCliente b (NOLOCK)
					ON	a.CodigoEmpresa			= b.CodigoEmpresa AND 
						a.CodigoClientePotencial	= tbClienteStarTruck.CodigoClienteST
					WHERE	b.CodigoEmpresa			= @CodigoEmpresa AND 
						b.NumeroClientePotencialEfetivo	= a.NumeroClientePotencialEfetivo)
					between  tbTipoCliFrotaST.QtdeInicialFrota  
					and      tbTipoCliFrotaST.QtdeFinalFrota),0),
		VendaPerdida = 'F',
		tbPreparacaoVisitaST.ApresentConc,
		tbPreparacaoVisitaST.ApresentNovoProd,
		tbPreparacaoVisitaST.EntendSatisfProdServ,
		tbPreparacaoVisitaST.DespIntCompra,
		tbPreparacaoVisitaST.AtualizarInfFichaFrota,
		tbPreparacaoVisitaST.ConvidarEvento,
		tbPreparacaoVisitaST.ObjetivoOutros,
		convert(varchar(255),tbPreparacaoVisitaST.AbordagemVisita) as AbordagemVisita,
		tbClienteRepresentanteTP.Categoria,
		tbClienteRepresentanteTP.Segmento,
		tbPreparacaoVisitaST.FollowUp,
		tbPreparacaoVisitaST.PeriodoInicialVisita ,
		tbPreparacaoVisitaST.PeriodoFinalVisita,
		tbPreparacaoVisitaST.VisitaConfirmada

	FROM 
		tbPreparacaoVisitaST (NOLOCK)

	INNER JOIN tbClienteRepresentanteTP (NOLOCK)
	ON	tbClienteRepresentanteTP.CodigoEmpresa = tbPreparacaoVisitaST.CodigoEmpresa
	AND	tbClienteRepresentanteTP.CodigoLocal = tbPreparacaoVisitaST.CodigoLocal
	AND	tbClienteRepresentanteTP.CodigoClienteST = tbPreparacaoVisitaST.CodigoClienteST
	AND	tbClienteRepresentanteTP.TipoCliEfetivoPotencial = tbPreparacaoVisitaST.TipoCliEfetivoPotencial
	AND	tbClienteRepresentanteTP.CodigoRepresentante = tbPreparacaoVisitaST.CodigoRepresentante
	AND	tbClienteRepresentanteTP.Produto = 'VEICULOS'
	AND	tbClienteRepresentanteTP.Categoria = tbPreparacaoVisitaST.Categoria
	AND	tbClienteRepresentanteTP.Segmento = tbPreparacaoVisitaST.Segmento

	INNER JOIN tbClienteStarTruck (NOLOCK) ON
	tbClienteStarTruck.CodigoEmpresa 		= tbPreparacaoVisitaST.CodigoEmpresa 		AND
	tbClienteStarTruck.CodigoLocal			= tbPreparacaoVisitaST.CodigoLocal 		AND
	tbClienteStarTruck.CodigoClienteST		= tbPreparacaoVisitaST.CodigoClienteST		AND
	tbClienteStarTruck.TipoCliEfetivoPotencial	= tbPreparacaoVisitaST.TipoCliEfetivoPotencial

	INNER JOIN tbPropensaoCompraST (NOLOCK)
	ON	tbPropensaoCompraST.CodigoEmpresa 	= tbClienteRepresentanteTP.CodigoEmpresa
	AND	tbPropensaoCompraST.CodigoLocal		= tbClienteRepresentanteTP.CodigoLocal
	AND	tbPropensaoCompraST.PropensaoCompra	= tbClienteRepresentanteTP.PropensaoCompra

	INNER JOIN tbClientePotencial (NOLOCK)
	ON	tbClientePotencial.CodigoEmpresa  		= tbClienteStarTruck.CodigoEmpresa
	AND	tbClientePotencial.CodigoClientePotencial	= tbClienteStarTruck.CodigoClienteST
		
	INNER JOIN tbEmpresa (NOLOCK) ON
	tbEmpresa.CodigoEmpresa  = tbClienteStarTruck.CodigoEmpresa

	INNER JOIN tbRepresentanteComplementar (NOLOCK) ON
	tbRepresentanteComplementar.CodigoEmpresa  	= tbPreparacaoVisitaST.CodigoEmpresa	AND
	tbRepresentanteComplementar.CodigoRepresentante = tbPreparacaoVisitaST.CodigoRepresentante

	INNER JOIN tbAtividade (NOLOCK)
	ON	tbAtividade.CodigoAtividade = tbClientePotencial.CodigoAtividade

	LEFT JOIN tbSegurosTP (NOLOCK)
	ON	tbSegurosTP.CodigoEmpresa		= tbClienteStarTruck.CodigoEmpresa
	AND	tbSegurosTP.CodigoLocal			= tbClienteStarTruck.CodigoLocal
	AND	tbSegurosTP.CodigoClienteST		= tbClienteStarTruck.CodigoClienteST
	AND	tbSegurosTP.TipoCliEfetivoPotencial	= tbClienteStarTruck.TipoCliEfetivoPotencial
	
	LEFT JOIN tbPosVendaTP (NOLOCK) 
	ON	tbPosVendaTP.CodigoEmpresa		= tbClienteStarTruck.CodigoEmpresa
	AND	tbPosVendaTP.CodigoLocal		= tbClienteStarTruck.CodigoLocal
	AND 	tbPosVendaTP.CodigoClienteST		= tbClienteStarTruck.CodigoClienteST
	AND	tbPosVendaTP.TipoCliEfetivoPotencial	= tbClienteStarTruck.TipoCliEfetivoPotencial
	
	LEFT JOIN tbDadosFinanceirosTP (NOLOCK)
	ON	tbDadosFinanceirosTP.CodigoEmpresa		= tbClienteStarTruck.CodigoEmpresa
	AND	tbDadosFinanceirosTP.CodigoLocal		= tbClienteStarTruck.CodigoLocal
	AND 	tbDadosFinanceirosTP.CodigoClienteST		= tbClienteStarTruck.CodigoClienteST
	AND 	tbDadosFinanceirosTP.TipoCliEfetivoPotencial	= tbClienteStarTruck.TipoCliEfetivoPotencial
		
	WHERE 
	   	tbPreparacaoVisitaST.CodigoEmpresa = @CodigoEmpresa 
	AND   	tbPreparacaoVisitaST.CodigoLocal = @CodigoLocal 
	AND	tbPreparacaoVisitaST.TipoCliEfetivoPotencial = 'P'
	AND	tbPreparacaoVisitaST.PeriodoInicialVisita = @DaData
	AND	tbPreparacaoVisitaST.PeriodoFinalVisita = @AteData 
	AND     (tbPreparacaoVisitaST.CodigoRepresentante BETWEEN @DoRepresentante AND @AteRepresentante)
	AND	(tbPreparacaoVisitaST.CodigoClienteST BETWEEN @DoCliente AND @AteCliente)
	AND     (tbClienteRepresentanteTP.PropensaoCompra BETWEEN @DaPropensao AND @AtePropensao) 
	AND 	(	
			(
				tbClienteStarTruck.ClienteTPCaminhoes = 'V' 	OR
				tbClienteStarTruck.ClienteTPSprinter = 'V' 	OR
				tbClienteStarTruck.ClienteTPOutros = 'V'
			)
			OR
			(
				tbClienteStarTruck.ClienteTPCaminhoes = 'F' 	AND
				tbClienteStarTruck.ClienteTPOnibus = 'F' 	AND
				tbClienteStarTruck.ClienteTPSprinter = 'F' 	AND
				tbClienteStarTruck.ClienteTPOutros = 'F'
			)
		)
	AND	tbClienteRepresentanteTP.Categoria <> 'ONIBUS'
	AND (tbPreparacaoVisitaST.FollowUp = @ImprimeFollowUp OR @ImprimeFollowUp IS NULL)

	------------------------------  Gera 2 Primeiros Contatos do Cliente ---------------
	--	EXECUTE  whRelTPFichaVisContatoCli @CodigoEmpresa, @CodigoLocal, 'P', @DoRepresentante, @AteRepresentante, @DoCliente, @AteCliente
	INSERT	rtContatoCliente
	SELECT DISTINCT
		@@Spid as Spid,
		tbContatoClienteTP.CodigoEmpresa,
		tbClienteRepresentanteTP.CodigoLocal,
		tbClienteRepresentanteTP.CodigoClienteST,
		tbClienteRepresentanteTP.TipoCliEfetivoPotencial,
		tbClienteRepresentanteTP.CodigoRepresentante,
		tbContatoClienteTP.CodigoContatoClienteTP,
		tbContatoClienteTP.NomeContatoClienteTP,
		tbContatoClienteTP.FuncaoContato,
		tbContatoClienteTP.DataAniversarioContato,
		tbContatoClienteTP.EmailContatoClienteTP,
		tbContatoClienteTP.DDDCelularContClienteTP,
		tbContatoClienteTP.CelularContatoClienteTP,
		case 	
			when (tbContatoClienteTP.DDDFoneContatoClienteTP = '' or tbContatoClienteTP.DDDFoneContatoClienteTP is null) then
				coalesce(tbContatoClienteTP.DDDFoneResidContatoClienteTP, '')
		     	else
				coalesce(tbContatoClienteTP.DDDFoneContatoClienteTP, '')
		end 	as DDD,
		case 	
			when (tbContatoClienteTP.FoneContatoClienteTP = '' or tbContatoClienteTP.FoneContatoClienteTP is null) then
				coalesce(tbContatoClienteTP.FoneResidContatoClienteTP, '')
		     	else
				coalesce(tbContatoClienteTP.FoneContatoClienteTP, '')
		end 	as Fone,
		tbContatoClienteTP.DescrTimeFutebol,
		tbContatoClienteTP.DescrHobby,
		tbClienteRepresentanteTP.Categoria,
		tbClienteRepresentanteTP.Segmento,
		tbContatoClienteTP.OrdemContato,
		tbContatoClienteTP.timestamp
	FROM 
		tbClienteRepresentanteTP
	
	INNER JOIN tbContatoClienteTP (NOLOCK) 
	ON	tbClienteRepresentanteTP.CodigoEmpresa = tbContatoClienteTP.CodigoEmpresa
	AND	tbClienteRepresentanteTP.CodigoClienteST = convert(numeric(14),tbContatoClienteTP.CodigoClientePotencial)
	AND	tbClienteRepresentanteTP.CodigoContatoClienteTP = tbContatoClienteTP.CodigoContatoClienteTP
	AND	tbClienteRepresentanteTP.TipoCliEfetivoPotencial = 'P'
	AND   	tbContatoClienteTP.Categoria <> 'ONIBUS'

	WHERE 	
		tbClienteRepresentanteTP.CodigoEmpresa  = @CodigoEmpresa
	AND	tbClienteRepresentanteTP.CodigoLocal = @CodigoLocal
	AND	(tbClienteRepresentanteTP.CodigoClienteST BETWEEN @DoCliente AND @AteCliente)
	AND	tbClienteRepresentanteTP.TipoCliEfetivoPotencial = 'P'
	AND	(tbClienteRepresentanteTP.CodigoRepresentante BETWEEN @DoRepresentante AND @AteRepresentante)
	AND   	tbClienteRepresentanteTP.Categoria <> 'ONIBUS'
	AND	tbContatoClienteTP.OrdemContato in (1,2)

	ORDER BY tbContatoClienteTP.CodigoContatoClienteTP, 
		 tbContatoClienteTP.OrdemContato

	update rtFichaVisita
	set 
		NomeContato1 = (SELECT  max(NomeContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)), 
		FuncaoContato1 = (SELECT max(FuncaoContato)
 					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)), 
		DataAniversarioContato1 = (SELECT  CONVERT(varchar(20),max(DataAniversarioContato),103)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)), 
		email1 = (SELECT  max(EmailContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)), 
		DDDCelularContClienteTP1 = coalesce((SELECT max(DDDCelularContClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)),''), 
		CelularContatoClienteTP1 = coalesce((SELECT  max(CelularContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)),0), 
		DDDFoneContatoClienteTP1 = coalesce((SELECT max(DDDFoneContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)),''), 
		FoneContatoClienteTP1 = coalesce((SELECT  max(FoneContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)),''), 
		DescrTimeFutebol1 = (SELECT  max(DescrTimeFutebol)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)), 
		DescrHobby1 = (SELECT  max(DescrHobby)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)),
	
		@CodigoContatoCliente1 =	(SELECT  max(CodigoContatoClienteTP)
							FROM rtContatoCliente
							WHERE  	rtContatoCliente.spID = @@spID
							AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
							AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
							AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
							AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
							AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
							AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
							AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
							AND     rtContatoCliente.OrdemContato = 1
							AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
														FROM rtContatoCliente
														WHERE  	rtContatoCliente.spID = @@spID
														AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
														AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
														AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
														AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
														AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
														AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
														AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
														AND     rtContatoCliente.OrdemContato = 1))


	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'P'
 
	update rtFichaVisita
	set 
		NomeContato2 = (SELECT  max(NomeContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)), 
		FuncaoContato2 = (SELECT max(FuncaoContato)
 					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)), 
		DataAniversarioContato2 = (SELECT  CONVERT(varchar(20), max(DataAniversarioContato),103)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)),
		email2 = (SELECT  max(EmailContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)),
		DDDCelularContClienteTP2 = coalesce((SELECT  max(DDDCelularContClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)),''),
		CelularContatoClienteTP2 = coalesce((SELECT  max(CelularContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND     rtContatoCliente.OrdemContato = 2
						AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)),''), 
		DDDFoneContatoClienteTP2 = coalesce((SELECT  max(DDDFoneContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND     rtContatoCliente.OrdemContato = 2
						AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)),''),
		FoneContatoClienteTP2 = coalesce((SELECT max(FoneContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND     rtContatoCliente.OrdemContato = 2
						AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)),''), 
		DescrTimeFutebol2 = (SELECT  max(DescrTimeFutebol)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)),
		DescrHobby2 = (SELECT  max(DescrHobby)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)),


		@CodigoContatoCliente2 =	(SELECT  max(CodigoContatoClienteTP)
							FROM rtContatoCliente
							WHERE  	rtContatoCliente.spID = @@spID
							AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
							AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
							AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
							AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
							AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
							AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
							AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
							AND     rtContatoCliente.OrdemContato = 2
							AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
														FROM rtContatoCliente
														WHERE  	rtContatoCliente.spID = @@spID
														AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
														AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
														AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
														AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
														AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
														AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
														AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
														AND     rtContatoCliente.OrdemContato = 2))

	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	DELETE FROM rtContatoCliente
	WHERE spID = @@spID
	------------------------------  Fim Contatos do Cliente ----------------------------

	------------------------------  Gera 3 Ultimas Visitas -----------------------------
	--------------------------------   Carrega Ultima Visita  -----------------------
	SELECT @DoClienteResultVis = MIN(CodigoClienteST) FROM rtFichaVisita
     	WHERE rtFichaVisita.spID = @@spID
     	AND   rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
     	AND   rtFichaVisita.CodigoLocal = @CodigoLocal 
     	AND   rtFichaVisita.TipoCliEfetivoPotencial = 'P'
     	AND   (rtFichaVisita.CodigoRepresentante BETWEEN @DoRepresentante AND @AteRepresentante)

	SELECT @AteClienteResultVis = MAX(CodigoClienteST) FROM rtFichaVisita
	WHERE rtFichaVisita.spID = @@spID
	AND   rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
	AND   rtFichaVisita.CodigoLocal = @CodigoLocal 
	AND   rtFichaVisita.TipoCliEfetivoPotencial = 'P'
	AND   (rtFichaVisita.CodigoRepresentante BETWEEN @DoRepresentante AND @AteRepresentante)

	EXECUTE  whRelTPFichaVisResultado @CodigoEmpresa, @CodigoLocal, 'P', @DoRepresentante, @AteRepresentante, @DoClienteResultVis, @AteClienteResultVis, @DaData, @ImprimirResultado

	update rtFichaVisita
	set 
		DataResultadoVisita1 = (SELECT  convert(varchar(20),max(DataResultadoVisita), 103)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1), 
		ContatoVisita1 = (SELECT max(ContatoVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1), 
		ComentarioVisita1 = (SELECT max(ComentarioVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1), 
		PendenciaProxVisita1 = 	(SELECT  max(PendenciaProxVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1), 
		PropCompraResultado1 = (SELECT  max(PropCompraResultado)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1)
	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	--------------------------------   Fim Carrega Ultima Visita  ---------------------

	--------------------------------   Carrega Penultima Visita  ----------------------
	update rtFichaVisita
	set 
		DataResultadoVisita2 = (SELECT  convert(varchar(20),max(DataResultadoVisita), 103)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 2), 
		ContatoVisita2 = (SELECT  max(ContatoVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 2), 
		ComentarioVisita2 = (SELECT  max(ComentarioVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 2), 
		PropCompraResultado2 = (SELECT  max(PropCompraResultado)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 2)
	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'P'
	--------------------------------   Fim Carrega Penultima Visita  ------------------

	--------------------------------   Carrega anti - penultima Visita  ----------------------
	update rtFichaVisita
	set 
		DataResultadoVisita3 = (SELECT  convert(varchar(20),max(DataResultadoVisita), 103)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 3), 
		ContatoVisita3 = (SELECT  max(ContatoVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 3),
		ComentarioVisita3 = (SELECT  max(ComentarioVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 3),
		PropCompraResultado3 = (SELECT  max(PropCompraResultado)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 3)	
	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	--------------------------------   Fim Carrega anti - penultima Visita  ------------------
	DELETE FROM rtResultadoVisita
	WHERE spID = @@spID
	------------------------------  Fim 3 Ultimas Visitas ------------------------------

	------------------------------  Carrega Quantidades de Frota -----------------------
	INSERT rtFrotaCliente
	SELECT	DISTINCT
		@@spID,
		tbFrotaCliente.CodigoEmpresa,
		tbCaracteristicaCliente.CodigoClientePotencial,
		tbFrotaCliente.Categoria,
		tbFrotaCliente.SegmentoFrotaCliente,
		tbFabricanteVeiculo.DescricaoFabricanteVeic,
		0

	FROM	
		tbCaracteristicaCliente (NOLOCK)
	INNER JOIN tbFrotaCliente (NOLOCK)
	ON	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
	INNER JOIN tbFabricanteVeiculo (NOLOCK)
	ON	tbFabricanteVeiculo.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
	AND	tbFabricanteVeiculo.CodigoFabricante = tbFrotaCliente.CodigoFabricanteOutros
	WHERE			
		tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
	AND	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
	AND 	tbFrotaCliente.Categoria <> 'ONIBUS'
	AND	tbCaracteristicaCliente.CodigoClientePotencial IS NOT NULL
	
	UPDATE rtFrotaCliente
	SET TotalFrota = coalesce((   select sum(tbFrotaCliente.QtdeVeiculosFrotaCliente)
					from	tbCaracteristicaCliente (NOLOCK)
					inner join tbFrotaCliente (NOLOCK)
					on	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
				 	and	tbCaracteristicaCliente.CodigoClientePotencial = rtFrotaCliente.CodigoCliente
					inner join tbFabricanteVeiculo (NOLOCK)
					on	tbFabricanteVeiculo.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
					and	tbFabricanteVeiculo.CodigoFabricante = tbFrotaCliente.CodigoFabricanteOutros
					where	rtFrotaCliente.spID = @@spID
					and	tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
					and	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
					and 	tbFrotaCliente.Categoria = rtFrotaCliente.Categoria
					and 	tbFrotaCliente.SegmentoFrotaCliente = rtFrotaCliente.Segmento
					and 	rtFrotaCliente.DescricaoFabricanteVeic = tbFabricanteVeiculo.DescricaoFabricanteVeic),0)

	--- Total da Frota
	UPDATE rtFichaVisita
	SET    QtdeTotalLeves = ( SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
			 	  FROM   rtFrotaCliente
				  WHERE
				 	rtFrotaCliente.spID = @@spID
				  AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				  AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				  AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				  AND	rtFrotaCliente.Segmento = 'LEVES'
				  AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET    QtdeTotalMedios = ( SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				   FROM   rtFrotaCliente
				   WHERE
				 	rtFrotaCliente.spID = @@spID
				   AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				   AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				   AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				   AND	rtFrotaCliente.Segmento = 'MEDIOS'
				   AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET    QtdeTotalSemiPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'SEMI-PESADOS'
					AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET    QtdeTotalPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				   FROM   rtFrotaCliente
				   WHERE
				 	rtFrotaCliente.spID = @@spID
				   AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				   AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				   AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				   AND	rtFrotaCliente.Segmento = 'PESADOS'
				   AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET    QtdeTotalExtraPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'EXTRA-PESADOS'
					AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeTotalFrota = QtdeTotalLeves + QtdeTotalMedios + QtdeTotalSemiPesados + QtdeTotalPesados +  QtdeTotalExtraPesados
	WHERE spID = @@spID
	AND	rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
	AND	rtFichaVisita.CodigoLocal = @CodigoLocal	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	--- Frota MB
	UPDATE rtFichaVisita
	SET QtdeMBLeves = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
			   FROM   rtFrotaCliente
			   WHERE
			 	rtFrotaCliente.spID = @@spID
			   AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
			   AND	rtFichaVisita.CodigoLocal = @CodigoLocal
			   AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
			   AND	rtFrotaCliente.Segmento = 'LEVES'
			   AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
			   AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeMBMedios  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				FROM   rtFrotaCliente
				WHERE
				 	rtFrotaCliente.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				AND	rtFrotaCliente.Segmento = 'MEDIOS'
				AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
				AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')
		
	UPDATE rtFichaVisita
	SET QtdeMBSemiPesados  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'SEMI-PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
					AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeMBPesados  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				FROM   rtFrotaCliente
				WHERE
				 	rtFrotaCliente.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				AND	rtFrotaCliente.Segmento = 'PESADOS'
				AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
				AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeMBExtraPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'EXTRA-PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
					AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeFrotaMB = QtdeMBLeves + QtdeMBMedios + QtdeMBSemiPesados + QtdeMBPesados + QtdeMBExtraPesados
	WHERE spID = @@spID
	AND	rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
	AND	rtFichaVisita.CodigoLocal = @CodigoLocal	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	--- Frota Outros
	UPDATE rtFichaVisita
	SET QtdeOutrosLeves = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				FROM   rtFrotaCliente
				WHERE
				 	rtFrotaCliente.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				AND	rtFrotaCliente.Segmento = 'LEVES'
				AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
				AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeOutrosMedios  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				FROM   rtFrotaCliente
				WHERE
				 	rtFrotaCliente.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				AND	rtFrotaCliente.Segmento = 'MEDIOS'
				AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
				AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')
		
	UPDATE rtFichaVisita
	SET QtdeOutrosSemiPesados  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'SEMI-PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
					AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeOutrosPesados  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
					AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeOutrosExtraPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'EXTRA-PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
					AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeFrotaOutros = QtdeOutrosLeves + QtdeOutrosMedios + QtdeOutrosSemiPesados + QtdeOutrosPesados + QtdeOutrosExtraPesados
	WHERE spID = @@spID
	AND	rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
	AND	rtFichaVisita.CodigoLocal = @CodigoLocal
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	delete rtFrotaCliente
	where spID = @@spID
	------------------------------  FIM -  Quantidades de Frota -----------------------

	------------------------------  Carrega Idade Media Frota -----------------------
	--- Idade Media
	INSERT rtIdadeMediaFrota
	SELECT	DISTINCT
		@@spID,
		tbFrotaCliente.CodigoEmpresa,
		tbCaracteristicaCliente.CodigoClientePotencial,
		tbFrotaCliente.Categoria,
		tbFrotaCliente.SegmentoFrotaCliente,
		tbFrotaCliente.AnoFabricacaoFrotaCliente,
		0
	
	FROM	
		tbCaracteristicaCliente (NOLOCK)
	INNER JOIN tbFrotaCliente (NOLOCK)
	ON	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
	INNER JOIN tbFabricanteVeiculo (NOLOCK)
	ON	tbFabricanteVeiculo.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
	AND	tbFabricanteVeiculo.CodigoFabricante = tbFrotaCliente.CodigoFabricanteOutros
	
	WHERE	
		tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
	AND	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
	AND 	tbFrotaCliente.Categoria <> 'ONIBUS'
	AND	tbCaracteristicaCliente.CodigoClientePotencial IS NOT NULL

	UPDATE rtIdadeMediaFrota
	SET TotalFrota = coalesce((   select sum(tbFrotaCliente.QtdeVeiculosFrotaCliente)
					from	tbCaracteristicaCliente (NOLOCK)
					inner join tbFrotaCliente (NOLOCK)
					on	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
			 		and	tbCaracteristicaCliente.CodigoClientePotencial = rtIdadeMediaFrota.CodigoCliente
					inner join tbFabricanteVeiculo (NOLOCK)
					on	tbFabricanteVeiculo.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
					and	tbFabricanteVeiculo.CodigoFabricante = tbFrotaCliente.CodigoFabricanteOutros
					where	tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
					and	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
					and 	tbFrotaCliente.Categoria = rtIdadeMediaFrota.Categoria
					and 	tbFrotaCliente.SegmentoFrotaCliente = rtIdadeMediaFrota.Segmento
					and 	tbFrotaCliente.AnoFabricacaoFrotaCliente = rtIdadeMediaFrota.AnoFabricacaoFrotaCliente),0)

	UPDATE rtFichaVisita
	SET IdadeMediaLeves = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
				SUM(rtIdadeMediaFrota.TotalFrota)),0)
				FROM 	rtIdadeMediaFrota
				WHERE
					rtIdadeMediaFrota.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
				AND	rtIdadeMediaFrota.Segmento = 'LEVES')
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	UPDATE rtFichaVisita
	SET IdadeMediaMedios = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
				SUM(rtIdadeMediaFrota.TotalFrota)),0)
				FROM 	rtIdadeMediaFrota
				WHERE
					rtIdadeMediaFrota.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
				AND	rtIdadeMediaFrota.Segmento = 'MEDIOS')
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	UPDATE rtFichaVisita
	SET IdadeMediaSemiPesados = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
					SUM(rtIdadeMediaFrota.TotalFrota)),0)
					FROM 	rtIdadeMediaFrota
					WHERE
						rtIdadeMediaFrota.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
					AND	rtIdadeMediaFrota.Segmento = 'SEMI-PESADOS')
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'


	UPDATE rtFichaVisita
	SET IdadeMediaPesados = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
			      	 SUM(rtIdadeMediaFrota.TotalFrota)),0)
				 FROM 	rtIdadeMediaFrota
				 WHERE
				 	rtIdadeMediaFrota.spID = @@spID
				 AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
				 AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				 AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
				 AND	rtIdadeMediaFrota.Segmento = 'PESADOS')
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	UPDATE rtFichaVisita
	SET IdadeMediaExtraPesados = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
				      SUM(rtIdadeMediaFrota.TotalFrota)),0)
					FROM 	rtIdadeMediaFrota
					WHERE
					 	rtIdadeMediaFrota.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
					AND	rtIdadeMediaFrota.Segmento = 'EXTRA-PESADOS')
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	UPDATE rtFichaVisita
	SET IdadeMediaTotal = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
				       SUM(rtIdadeMediaFrota.TotalFrota)),0)
				FROM 	rtIdadeMediaFrota
				WHERE
				 	rtIdadeMediaFrota.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente))
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	delete rtIdadeMediaFrota
	where spID = @@spID
	------------------------------  FIM - Idade Media Frota -----------------------

	------------------------------  Carrega Vendas Perdidas -----------------------
	INSERT rtVendasPerdidasTP
	SELECT	@@spID,
		tbVendasPerdidasTP.CodigoEmpresa, 
		tbVendasPerdidasTP.CodigoLocal,
		tbVendasPerdidasTP.CodigoClienteST,
		tbVendasPerdidasTP.TipoCliEfetivoPotencial,
		tbVendasPerdidasTP.SegmentosConcorrente,
		SUM(tbVendasPerdidasTP.QuantidadeConcorrente)
	FROM 
		tbVendasPerdidasTP
	WHERE
		tbVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
	AND	tbVendasPerdidasTP.CodigoLocal = @CodigoLocal
	AND	tbVendasPerdidasTP.TipoCliEfetivoPotencial = 'P'

	GROUP BY
		tbVendasPerdidasTP.CodigoEmpresa, 
		tbVendasPerdidasTP.CodigoLocal,
		tbVendasPerdidasTP.CodigoClienteST,
		tbVendasPerdidasTP.TipoCliEfetivoPotencial,
		tbVendasPerdidasTP.SegmentosConcorrente

	UPDATE rtFichaVisita
	SET QuantVendPerdLeves = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
					   WHERE
					  	rtVendasPerdidasTP.spID = @@spID  
					   AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
					   AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
					   AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'P'
					   AND	rtVendasPerdidasTP.Segmento = 'LEVES'),0)
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'
	
	UPDATE rtFichaVisita
	SET QuantVendPerdMedios = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
					    WHERE
					   	rtVendasPerdidasTP.spID = @@spID  
					    AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
					    AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
					    AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
					    AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'P'
					    AND	rtVendasPerdidasTP.Segmento = 'MEDIOS'),0)
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	UPDATE rtFichaVisita
	SET QuantVendPerdSemiPesados = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
						  WHERE
						  	rtVendasPerdidasTP.spID = @@spID  
						  AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
						  AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
						  AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
						  AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'P'
						  AND	rtVendasPerdidasTP.Segmento = 'SEMI-PESADOS'),0)
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	UPDATE rtFichaVisita
	SET QuantVendPerdPesados = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
					     WHERE
					  		rtVendasPerdidasTP.spID = @@spID  
					     AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
					     AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
					     AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'P'
					     AND	rtVendasPerdidasTP.Segmento = 'PESADOS'),0)
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	UPDATE rtFichaVisita
	SET QuantVendPerdExtraPesados = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
					     	  WHERE
					  		rtVendasPerdidasTP.spID = @@spID  
					     	  AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
					     	  AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
					     	  AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     	  AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'P'
					     	  AND	rtVendasPerdidasTP.Segmento = 'EXTRA-PESADOS'),0)
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	UPDATE rtFichaVisita
	SET VendaPerdida = CASE WHEN ( QuantVendPerdLeves + QuantVendPerdMedios + QuantVendPerdSemiPesados + QuantVendPerdSemiPesados + QuantVendPerdPesados + QuantVendPerdExtraPesados ) > 0 THEN
                              		'V'
                           ELSE
                                      	'F'
                           END
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	DELETE rtVendasPerdidasTP
	WHERE spID = @@spID
	------------------------------  FIM - Vendas Perdidas -----------------------
	--------------------------  Carrega Cursor para Atualização  --------------------

	END

if @TipoCliente = 'E' or @TipoCliente = 'A'
	BEGIN

	INSERT rtFichaVisita
	SELECT 	DISTINCT
		spID = @@spID,
		tbPreparacaoVisitaST.CodigoEmpresa,
		tbPreparacaoVisitaST.CodigoLocal,
		tbPreparacaoVisitaST.TipoCliEfetivoPotencial,
		-- DADOS GERAIS
		tbClienteStarTruck.ClienteTPCaminhoes,
		tbClienteStarTruck.ClienteTPOnibus,
		tbClienteStarTruck.ClienteTPSprinter,
		tbClienteStarTruck.ClienteTPOutros,
		tbClienteStarTruck.RecEmailPropag,
		tbCliFor.TipoCliFor,
		tbPreparacaoVisitaST.CodigoClienteST,
		tbClienteStarTruck.DataCadastroTP,
	        tbPreparacaoVisitaST.CodigoRepresentante,
		tbRepresentanteComplementar.NomeRepresentante,
		TamanhoFrota = coalesce((	
						select sum(tbFrotaCliente.QtdeVeiculosFrotaCliente)
					 	from	tbCaracteristicaCliente (NOLOCK)
						inner join tbFrotaCliente (NOLOCK)
						on	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
						and	tbCaracteristicaCliente.CodigoCliFor = tbClienteStarTruck.CodigoClienteST
						where	tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
						and	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
					),0),
		tbClienteRepresentanteTP.PropensaoCompra,
        	tbPropensaoCompraST.DescrPropCompra, 
		tbCliFor.NomeCliFor 				as RazaoSocialCliente,
		CASE
		   WHEN (tbCliFor.TipoCliFor) = 'F' THEN
			tbCliForFisica.CPFFisica
	   	   ELSE
			tbCliForJuridica.CGCJuridica
		END 						as CNPJ,
		tbCliFor.NomeUsualCliFor 			as NomeFantasiaCliente,
		CASE
		   WHEN (tbCliFor.TipoCliFor) = 'F' THEN
			tbCliForFisica.RGFisica
	   	   ELSE
			tbCliForJuridica.InscricaoEstadualJuridica
		END 							as InscrEstadual,
		tbCliFor.RuaCliFor					as Rua,
		tbCliFor.NumeroEndCliFor 				as Numero,
		tbCliFor.BairroCliFor					as Bairro,
		tbCliFor.MunicipioCliFor				as Municipio,
		tbCliFor.UFCliFor					as UF,
		tbCliFor.CEPCliFor					as CEP,
		CASE
		   WHEN (tbCliFor.TipoCliFor) = 'F' THEN
			case 	
				when (tbCliForFisica.DDDComercialFisica = '' or tbCliForFisica.DDDComercialFisica is null) then
					coalesce(tbCliFor.DDDTelefoneCliFor,'')
		     		else
					coalesce(tbCliForFisica.DDDComercialFisica,'')
			end

	   	   ELSE
			coalesce(tbCliFor.DDDTelefoneCliFor,'')
		END 	as DDD,

		CASE
		   WHEN (tbCliFor.TipoCliFor) = 'F' THEN
			case 	
				when (tbCliForFisica.TelefoneComercialFisica = '' or tbCliForFisica.TelefoneComercialFisica is null) then
					coalesce(tbCliFor.TelefoneCliFor,'')
			     	else
					coalesce(tbCliForFisica.TelefoneComercialFisica,'')
			end

	   	   ELSE
			coalesce(tbCliFor.TelefoneCliFor,'')
		END 	as Fone,
		coalesce(tbCliFor.DDDFaxCliFor,'') as DDDFax,
		coalesce(tbCliFor.FaxCliFor,'') as Fax,
		tbAtividade.DescricaoAtividade					as DescricaoAtividade,

		-- CONTATOS
		convert(varchar(50),'') as NomeContato1,    
		convert(varchar(50),'') as FuncaoContato1,
		convert(varchar(20),'') as DataAniversarioContato1,
		convert(varchar(50),'') as email1,
		convert(varchar(4),'') as DDDCelularContClienteTP1, 
		convert(varchar(15),'') as CelularContatoClienteTP1,
		convert(varchar(4),'') as DDDFoneContatoClienteTP1,  
		convert(varchar(15),'') as FoneContatoClienteTP1, 
		convert(varchar(20),'') as DescrTimeFutebol1,  
		convert(varchar(20),'') as DescrHobby1, 
		convert(varchar(50),'') as NomeContato2,    
		convert(varchar(50),'') as FuncaoContato2,
		convert(varchar(20),'') as DataAniversarioContato2,
		convert(varchar(50),'') as email2,
		convert(varchar(4),'') as DDDCelularContClienteTP2, 
		convert(varchar(15),'') as CelularContatoClienteTP2,
		convert(varchar(4),'') as DDDFoneContatoClienteTP2,  
		convert(varchar(15),'') as FoneContatoClienteTP2, 
		convert(varchar(20),'') as DescrTimeFutebol2,  
		convert(varchar(20),'') as DescrHobby2, 

		-- HISTORICO DE VISITAS
		convert(varchar(20),'') as DataResultadoVisita1,
		convert(varchar(30),'') as ContatoVisita1,
		convert(varchar(300),'') as ComentarioVisita1,
		convert(varchar(300),'') as PendenciaProxVisita1,
		convert(varchar(2),'') as PropCompraResultado1,
		convert(varchar(20),'') as DataResultadoVisita2,
		convert(varchar(30),'') as ContatoVisita2,
		convert(varchar(300),'') as ComentarioVisita2,
		convert(varchar(2),'') as PropCompraResultado2,
		convert(varchar(20),'') as DataResultadoVisita3,
		convert(varchar(30),'') as ContatoVisita3,
		convert(varchar(300),'') as ComentarioVisita3,
		convert(varchar(2),'') as PropCompraResultado3,

		QtdeTotalLeves = 0,
		QtdeTotalMedios = 0,
		QtdeTotalSemiPesados = 0,
		QtdeTotalPesados = 0,
		QtdeTotalExtraPesados = 0,
		QtdeTotalFrota = 0,
		QtdeMBLeves = 0,
		QtdeMBMedios = 0,
		QtdeMBSemiPesados = 0,
		QtdeMBPesados = 0,
		QtdeMBExtraPesados = 0,
		QtdeFrotaMB = 0,
		QtdeOutrosLeves = 0,
		QtdeOutrosMedios = 0,
		QtdeOutrosSemiPesados = 0,
		QtdeOutrosPesados = 0,
		QtdeOutrosExtraPesados = 0,
		QtdeFrotaOutros = 0,
		IdadeMediaLeves = 0,
		IdadeMediaMedios = 0,
		IdadeMediaSemiPesados = 0,
		IdadeMediaPesados = 0,
		IdadeMediaExtraPesados = 0,
		IdadeMediaTotal = 0,

		coalesce(tbSegurosTP.SeguroMBTotal, 'N'),
		coalesce(tbSegurosTP.SeguroMBTerceiros, 'N'),
		coalesce(tbSegurosTP.SeguroMBOutros, 'N'),
		coalesce(tbSegurosTP.SeguroTotal, 'N'),
		coalesce(tbSegurosTP.SeguroTerceiros, 'N'),
		coalesce(tbSegurosTP.SeguroOutros, 'N'),
		tbSegurosTP.QuantVeicSegurados,
		coalesce(tbPosVendaTP.PossuiOficinaPropria,'N'),
		coalesce(tbPosVendaTP.PossuiEstoquePecProprio,'N'),
		coalesce(tbPosVendaTP.PossuiContrManut,'N'),
		coalesce(tbPosVendaTP.PossuiContrManutMB,'N'),
		coalesce(tbPosVendaTP.PossuiContrManutOutros,'N'),
		coalesce(tbPosVendaTP.PossuiGarantEstend,'N'),
		coalesce(tbPosVendaTP.PossuiGarantEstendMB,'N'),
		coalesce(tbPosVendaTP.PossuiGarantEstendOutros,'N'),
		coalesce(tbPosVendaTP.FazRevisoes,'9'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoVista,'N'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoLeasing,'N'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoCDC,'N'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoFiname,'N'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoConsorcio,'N'),
		coalesce(tbDadosFinanceirosTP.AprovCredito,'9'),
		coalesce(tbDadosFinanceirosTP.BancoMB,'N'),
		coalesce(tbDadosFinanceirosTP.BancoOutros,'N'),
		coalesce(tbDadosFinanceirosTP.NaoPossuiCredito,'N'),

		-- VENDAS PERDIDAS
		QuantVendPerdLeves = 0,
		QuantVendPerdMedios = 0,
		QuantVendPerdSemiPesados = 0,
		QuantVendPerdPesados = 0,
		QuantVendPerdExtraPesados = 0,


		-- HISTORICO DE VENDAS
		QuantVendNovosLeves =   0,
		QuantVendNovosMedios =  0,
		QuantVendNovosSemiPesados = 0,
		QuantVendNovosPesados =  0,
		QuantVendNovosExtraPesados = 0,
		QuantVendSemiNovosLeves =  0,
		QuantVendSemiNovosMedios = 0,
		QuantVendSemiNovosSemiPesados = 0,
		QuantVendSemiNovosPesados = 0,
		QuantVendSemiNovosExtraPesados = 0,

		DataUltCompNovosLeves = '1900-01-01',
		DataUltCompNovosMedios = '1900-01-01',
		DataUltCompNovosSemiPesados = '1900-01-01',
		DataUltCompNovosPesados = '1900-01-01',
		DataUltCompNovosExtPes = '1900-01-01',
		DataUltCompSemiNovLeves = '1900-01-01',
		DataUltCompSemiNovMedios = '1900-01-01',
		DataUltCompSemiNovSemiPes = '1900-01-01',
		DataUltCompSemiNovPesados = '1900-01-01',
		DataUltCompSemiNovExtPes = '1900-01-01',
		TipoClienteFrota = coalesce (( select max(TipoClienteFrota )
						from tbTipoCliFrotaST (NOLOCK)
						where tbTipoCliFrotaST.CodigoEmpresa = @CodigoEmpresa
						and   tbTipoCliFrotaST.CodigoLocal = @CodigoLocal
						and   (SELECT sum(b.QtdeVeiculosFrotaCliente)
					FROM	tbCaracteristicaCliente a (NOLOCK)
					INNER JOIN tbFrotaCliente b (NOLOCK)
					ON	a.CodigoEmpresa	= b.CodigoEmpresa AND 
						a.CodigoCliFor = tbClienteStarTruck.CodigoClienteST
					WHERE	b.CodigoEmpresa = @CodigoEmpresa AND 
						b.NumeroClientePotencialEfetivo	= a.NumeroClientePotencialEfetivo)
					between  tbTipoCliFrotaST.QtdeInicialFrota  
					and      tbTipoCliFrotaST.QtdeFinalFrota),0),
		VendaPerdida = 'F',
		tbPreparacaoVisitaST.ApresentConc,
		tbPreparacaoVisitaST.ApresentNovoProd,
		tbPreparacaoVisitaST.EntendSatisfProdServ,
		tbPreparacaoVisitaST.DespIntCompra,
		tbPreparacaoVisitaST.AtualizarInfFichaFrota,
		tbPreparacaoVisitaST.ConvidarEvento,
		tbPreparacaoVisitaST.ObjetivoOutros,
		convert(varchar(255),tbPreparacaoVisitaST.AbordagemVisita) as AbordagemVisita,
		tbClienteRepresentanteTP.Categoria,
		tbClienteRepresentanteTP.Segmento,
		tbPreparacaoVisitaST.FollowUp,
		tbPreparacaoVisitaST.PeriodoInicialVisita ,
		tbPreparacaoVisitaST.PeriodoFinalVisita,
		tbPreparacaoVisitaST.VisitaConfirmada


	FROM 
		tbPreparacaoVisitaST (NOLOCK)

	INNER JOIN tbClienteRepresentanteTP (NOLOCK)
	ON	tbClienteRepresentanteTP.CodigoEmpresa = tbPreparacaoVisitaST.CodigoEmpresa
	AND	tbClienteRepresentanteTP.CodigoLocal = tbPreparacaoVisitaST.CodigoLocal
	AND	tbClienteRepresentanteTP.CodigoClienteST = tbPreparacaoVisitaST.CodigoClienteST
	AND	tbClienteRepresentanteTP.TipoCliEfetivoPotencial = tbPreparacaoVisitaST.TipoCliEfetivoPotencial
	AND	tbClienteRepresentanteTP.CodigoRepresentante = tbPreparacaoVisitaST.CodigoRepresentante
	AND	tbClienteRepresentanteTP.Produto = 'VEICULOS'
	AND	tbClienteRepresentanteTP.Categoria = tbPreparacaoVisitaST.Categoria
	AND	tbClienteRepresentanteTP.Segmento = tbPreparacaoVisitaST.Segmento

	INNER JOIN tbClienteStarTruck (NOLOCK) ON
		tbClienteStarTruck.CodigoEmpresa 		= tbPreparacaoVisitaST.CodigoEmpresa 		AND
		tbClienteStarTruck.CodigoLocal			= tbPreparacaoVisitaST.CodigoLocal 		AND
		tbClienteStarTruck.CodigoClienteST		= tbPreparacaoVisitaST.CodigoClienteST		AND
        	tbClienteStarTruck.TipoCliEfetivoPotencial	= tbPreparacaoVisitaST.TipoCliEfetivoPotencial

	INNER JOIN tbPropensaoCompraST (NOLOCK) ON
		tbPropensaoCompraST.CodigoEmpresa 	= tbClienteRepresentanteTP.CodigoEmpresa	AND
		tbPropensaoCompraST.CodigoLocal		= tbClienteRepresentanteTP.CodigoLocal	AND
		tbPropensaoCompraST.PropensaoCompra	= tbClienteRepresentanteTP.PropensaoCompra
	
	INNER JOIN tbCliFor (NOLOCK) ON
		tbCliFor.CodigoEmpresa  		= tbClienteStarTruck.CodigoEmpresa	AND
		tbCliFor.CodigoCliFor			= tbClienteStarTruck.CodigoClienteST

	LEFT JOIN tbCliForFisica (NOLOCK) ON
		tbCliForFisica.CodigoEmpresa  		= tbClienteStarTruck.CodigoEmpresa	AND
		tbCliForFisica.CodigoCliFor		= tbClienteStarTruck.CodigoClienteST

	LEFT JOIN tbCliForJuridica (NOLOCK) ON
		tbCliForJuridica.CodigoEmpresa 		= tbClienteStarTruck.CodigoEmpresa	AND
		tbCliForJuridica.CodigoCliFor		= tbClienteStarTruck.CodigoClienteST

	INNER JOIN tbAtividade (NOLOCK)
	ON	tbAtividade.CodigoAtividade = COALESCE(tbCliForFisica.CodigoAtividade,tbCliForJuridica.CodigoAtividade)


	INNER JOIN tbEmpresa (NOLOCK) ON
		tbEmpresa.CodigoEmpresa  = tbClienteStarTruck.CodigoEmpresa
	
	INNER JOIN tbRepresentanteComplementar (NOLOCK) ON
		tbRepresentanteComplementar.CodigoEmpresa  	= tbPreparacaoVisitaST.CodigoEmpresa	AND
		tbRepresentanteComplementar.CodigoRepresentante = tbPreparacaoVisitaST.CodigoRepresentante

	LEFT JOIN tbSegurosTP (NOLOCK)
	ON	tbSegurosTP.CodigoEmpresa		= tbClienteStarTruck.CodigoEmpresa
	AND	tbSegurosTP.CodigoLocal			= tbClienteStarTruck.CodigoLocal
	AND	tbSegurosTP.CodigoClienteST		= tbClienteStarTruck.CodigoClienteST
	AND	tbSegurosTP.TipoCliEfetivoPotencial	= tbClienteStarTruck.TipoCliEfetivoPotencial
	
	LEFT JOIN tbPosVendaTP (NOLOCK) 
	ON	tbPosVendaTP.CodigoEmpresa		= tbClienteStarTruck.CodigoEmpresa
	AND	tbPosVendaTP.CodigoLocal		= tbClienteStarTruck.CodigoLocal
	AND 	tbPosVendaTP.CodigoClienteST		= tbClienteStarTruck.CodigoClienteST
	AND	tbPosVendaTP.TipoCliEfetivoPotencial	= tbClienteStarTruck.TipoCliEfetivoPotencial
	
	LEFT JOIN tbDadosFinanceirosTP (NOLOCK)
	ON	tbDadosFinanceirosTP.CodigoEmpresa		= tbClienteStarTruck.CodigoEmpresa
	AND	tbDadosFinanceirosTP.CodigoLocal		= tbClienteStarTruck.CodigoLocal
	AND 	tbDadosFinanceirosTP.CodigoClienteST		= tbClienteStarTruck.CodigoClienteST
	AND 	tbDadosFinanceirosTP.TipoCliEfetivoPotencial	= tbClienteStarTruck.TipoCliEfetivoPotencial
		
	WHERE 
	   	tbPreparacaoVisitaST.CodigoEmpresa = @CodigoEmpresa 
	AND   	tbPreparacaoVisitaST.CodigoLocal = @CodigoLocal 
	AND	tbPreparacaoVisitaST.TipoCliEfetivoPotencial = 'E'
	AND	tbPreparacaoVisitaST.PeriodoInicialVisita = @DaData
	AND	tbPreparacaoVisitaST.PeriodoFinalVisita = @AteData  
	AND     (tbPreparacaoVisitaST.CodigoRepresentante BETWEEN @DoRepresentante AND @AteRepresentante)
	AND	(tbPreparacaoVisitaST.CodigoClienteST BETWEEN @DoCliente AND @AteCliente)
	AND     (tbClienteRepresentanteTP.PropensaoCompra BETWEEN @DaPropensao AND @AtePropensao) 
	AND 	(	
			(
				tbClienteStarTruck.ClienteTPCaminhoes = 'V' 	OR
				tbClienteStarTruck.ClienteTPSprinter = 'V' 	OR
				tbClienteStarTruck.ClienteTPOutros = 'V'
			)
			OR
			(
				tbClienteStarTruck.ClienteTPCaminhoes = 'F' 	AND
				tbClienteStarTruck.ClienteTPOnibus = 'F' 	AND
				tbClienteStarTruck.ClienteTPSprinter = 'F' 	AND
				tbClienteStarTruck.ClienteTPOutros = 'F'
			)
		)
	AND	tbClienteRepresentanteTP.Categoria <> 'ONIBUS'
	AND (tbPreparacaoVisitaST.FollowUp = @ImprimeFollowUp OR @ImprimeFollowUp IS NULL)

	------------------------------  Gera 2 Primeiros Contatos do Cliente ---------------
	INSERT	rtContatoCliente
	SELECT DISTINCT
		@@Spid as Spid,
		tbContatoClienteTP.CodigoEmpresa,
		tbClienteRepresentanteTP.CodigoLocal,
		tbClienteRepresentanteTP.CodigoClienteST,
		tbClienteRepresentanteTP.TipoCliEfetivoPotencial,
		tbClienteRepresentanteTP.CodigoRepresentante,
		tbContatoClienteTP.CodigoContatoClienteTP,
		tbContatoClienteTP.NomeContatoClienteTP,
		tbContatoClienteTP.FuncaoContato,
		tbContatoClienteTP.DataAniversarioContato,
		tbContatoClienteTP.EmailContatoClienteTP,
		tbContatoClienteTP.DDDCelularContClienteTP,
		tbContatoClienteTP.CelularContatoClienteTP,
		case 	
			when (tbContatoClienteTP.DDDFoneContatoClienteTP = '' or tbContatoClienteTP.DDDFoneContatoClienteTP is null) then
				coalesce(tbContatoClienteTP.DDDFoneResidContatoClienteTP, '')
		     	else
				coalesce(tbContatoClienteTP.DDDFoneContatoClienteTP, '')
		end 	as DDD,
		case 	
			when (tbContatoClienteTP.FoneContatoClienteTP = '' or tbContatoClienteTP.FoneContatoClienteTP is null) then
				coalesce(tbContatoClienteTP.FoneResidContatoClienteTP, '')
		     	else
				coalesce(tbContatoClienteTP.FoneContatoClienteTP, '')
		end 	as Fone,
		tbContatoClienteTP.DescrTimeFutebol,
		tbContatoClienteTP.DescrHobby,
		tbClienteRepresentanteTP.Categoria,
		tbClienteRepresentanteTP.Segmento,
		tbContatoClienteTP.OrdemContato,
		tbContatoClienteTP.timestamp
	FROM 
		tbClienteRepresentanteTP
	
	INNER JOIN tbContatoClienteTP (NOLOCK) 
	ON	tbClienteRepresentanteTP.CodigoEmpresa = tbContatoClienteTP.CodigoEmpresa
	AND	tbClienteRepresentanteTP.CodigoClienteST = tbContatoClienteTP.CodigoCliFor
	AND	tbClienteRepresentanteTP.CodigoContatoClienteTP = tbContatoClienteTP.CodigoContatoClienteTP
	AND	tbClienteRepresentanteTP.TipoCliEfetivoPotencial = 'E'
	AND   	tbContatoClienteTP.Categoria <> 'ONIBUS'
	
	WHERE 	
		tbClienteRepresentanteTP.CodigoEmpresa  = @CodigoEmpresa
	AND	tbClienteRepresentanteTP.CodigoLocal = @CodigoLocal
	AND	(tbClienteRepresentanteTP.CodigoClienteST BETWEEN @DoCliente AND @AteCliente)
	AND	tbClienteRepresentanteTP.TipoCliEfetivoPotencial = 'E'
	AND	(tbClienteRepresentanteTP.CodigoRepresentante BETWEEN @DoRepresentante AND @AteRepresentante)
	AND   	tbClienteRepresentanteTP.Categoria <> 'ONIBUS'
	AND	tbContatoClienteTP.OrdemContato in (1,2)

	ORDER BY tbContatoClienteTP.CodigoContatoClienteTP, 
		 tbContatoClienteTP.OrdemContato

	update rtFichaVisita
	set 
		NomeContato1 = (SELECT  max(NomeContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)), 
		FuncaoContato1 = (SELECT max(FuncaoContato)
 					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),
		DataAniversarioContato1 = (SELECT  CONVERT(varchar(20), max(DataAniversarioContato),103)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),
		email1 = (SELECT  max(EmailContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),
		DDDCelularContClienteTP1 = coalesce((SELECT max(DDDCelularContClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND     rtContatoCliente.OrdemContato = 1
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),''),
		CelularContatoClienteTP1 = coalesce((SELECT max(CelularContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),''), 
		DDDFoneContatoClienteTP1 = coalesce((SELECT max(DDDFoneContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND     rtContatoCliente.OrdemContato = 1
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),''), 
		FoneContatoClienteTP1 = coalesce((SELECT max(FoneContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND     rtContatoCliente.OrdemContato = 1
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),''), 
		DescrTimeFutebol1 = (SELECT  max(DescrTimeFutebol)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),
		DescrHobby1 = (SELECT  max(DescrHobby)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),

			@CodigoContatoCliente1 =	(SELECT  max(CodigoContatoClienteTP)
								FROM rtContatoCliente
								WHERE  	rtContatoCliente.spID = @@spID
								AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
								AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
								AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
								AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
								AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
								AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
								AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
								AND     rtContatoCliente.OrdemContato = 1
								AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
															FROM rtContatoCliente
															WHERE  	rtContatoCliente.spID = @@spID
															AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
															AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
															AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
															AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
															AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
															AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
															AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
															AND     rtContatoCliente.OrdemContato = 1))


	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	update rtFichaVisita
	set 
		NomeContato2 = (SELECT  max(NomeContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)), 
		FuncaoContato2 = (SELECT max(FuncaoContato)
 					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)), 
		DataAniversarioContato2 = (SELECT  CONVERT(varchar(20), max(DataAniversarioContato),103)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)), 
		email2 = (SELECT  max(EmailContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)), 
		DDDCelularContClienteTP2 = coalesce((SELECT max(DDDCelularContClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND     rtContatoCliente.OrdemContato = 2
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
													FROM rtContatoCliente
													WHERE  	rtContatoCliente.spID = @@spID
													AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
													AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
													AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
													AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
													AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
													AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
													AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
													AND     rtContatoCliente.OrdemContato = 2)),''),
		CelularContatoClienteTP2 = coalesce((SELECT max(CelularContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND     rtContatoCliente.OrdemContato = 2
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
													FROM rtContatoCliente
													WHERE  	rtContatoCliente.spID = @@spID
													AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
													AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
													AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
													AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
													AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
													AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
													AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
													AND     rtContatoCliente.OrdemContato = 2)),''), 
		DDDFoneContatoClienteTP2 = coalesce((SELECT max(DDDFoneContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
													FROM rtContatoCliente
													WHERE  	rtContatoCliente.spID = @@spID
													AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
													AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
													AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
													AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
													AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
													AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
													AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
													AND     rtContatoCliente.OrdemContato = 2)),''),
		FoneContatoClienteTP2 = coalesce((SELECT max(FoneContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
													FROM rtContatoCliente
													WHERE  	rtContatoCliente.spID = @@spID
													AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
													AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
													AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
													AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
													AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
													AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
													AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
													AND     rtContatoCliente.OrdemContato = 2)),''), 
		DescrTimeFutebol2 = (SELECT  max(DescrTimeFutebol)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
													FROM rtContatoCliente
													WHERE  	rtContatoCliente.spID = @@spID
													AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
													AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
													AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
													AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
													AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
													AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
													AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
													AND     rtContatoCliente.OrdemContato = 2)),
		DescrHobby2 = (SELECT  max(DescrHobby)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
													FROM rtContatoCliente
													WHERE  	rtContatoCliente.spID = @@spID
													AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
													AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
													AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
													AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
													AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
													AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
													AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
													AND     rtContatoCliente.OrdemContato = 2)),
	
		@CodigoContatoCliente2 =	(SELECT  max(CodigoContatoClienteTP)
							FROM rtContatoCliente
							WHERE  	rtContatoCliente.spID = @@spID
							AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
							AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
							AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
							AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
							AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
							AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
							AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
							AND     rtContatoCliente.OrdemContato = 2
							AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
														FROM rtContatoCliente
														WHERE  	rtContatoCliente.spID = @@spID
														AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
														AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
														AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
														AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
														AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
														AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
														AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
														AND     rtContatoCliente.OrdemContato = 2))

	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	DELETE FROM rtContatoCliente
	WHERE spID = @@spID
	------------------------------  Fim Contatos do Cliente ----------------------------

	------------------------------  Gera 3 Ultimas Visitas -----------------------------
	--------------------------------   Carrega Ultima Visita  -----------------------
	SELECT @DoClienteResultVis = MIN(CodigoClienteST) FROM rtFichaVisita
     	WHERE rtFichaVisita.spID = @@spID
     	AND   rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
     	AND   rtFichaVisita.CodigoLocal = @CodigoLocal 
     	AND   rtFichaVisita.TipoCliEfetivoPotencial = 'E'
     	AND   (rtFichaVisita.CodigoRepresentante BETWEEN @DoRepresentante AND @AteRepresentante)

	SELECT @AteClienteResultVis = MAX(CodigoClienteST) FROM rtFichaVisita
	WHERE rtFichaVisita.spID = @@spID
	AND   rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
	AND   rtFichaVisita.CodigoLocal = @CodigoLocal 
	AND   rtFichaVisita.TipoCliEfetivoPotencial = 'E'
	AND   (rtFichaVisita.CodigoRepresentante BETWEEN @DoRepresentante AND @AteRepresentante)


	EXECUTE  whRelTPFichaVisResultado @CodigoEmpresa, @CodigoLocal, 'E', @DoRepresentante, @AteRepresentante, @DoClienteResultVis, @AteClienteResultVis, @DaData, @ImprimirResultado

	update rtFichaVisita
	set 
		DataResultadoVisita1 = (SELECT  convert(varchar(20),max(DataResultadoVisita), 103)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1), 
			ContatoVisita1 = (SELECT max(ContatoVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1), 
		ComentarioVisita1 = (SELECT max(ComentarioVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1), 
		PendenciaProxVisita1 = 	(SELECT  max(PendenciaProxVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1), 
		PropCompraResultado1 = (SELECT  max(PropCompraResultado)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1)
	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	--------------------------------   Fim Carrega Ultima Visita  ---------------------

	--------------------------------   Carrega Penultima Visita  ----------------------
	update rtFichaVisita
	set 
		DataResultadoVisita2 = (SELECT  convert(varchar(20),max(DataResultadoVisita), 103)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 2), 
		ContatoVisita2 = (SELECT  max(ContatoVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 2), 
		ComentarioVisita2 = (SELECT  max(ComentarioVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 2), 
		PropCompraResultado2 = (SELECT  max(PropCompraResultado)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 2)
	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'
	--------------------------------   Fim Carrega Penultima Visita  ------------------

	--------------------------------   Carrega anti - penultima Visita  ----------------------
	update rtFichaVisita
	set 
		DataResultadoVisita3 = (SELECT  convert(varchar(20),max(DataResultadoVisita), 103)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 3), 
		ContatoVisita3 = (SELECT  max(ContatoVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 3),
		ComentarioVisita3 = (SELECT  max(ComentarioVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 3),
		PropCompraResultado3 = (SELECT  max(PropCompraResultado)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 3)	
	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'
	--------------------------------   Fim Carrega anti - penultima Visita  ------------------

	DELETE FROM rtResultadoVisita
	WHERE spID = @@spID
	------------------------------  Fim 3 Ultimas Visitas ------------------------------

	------------------------------  Carrega Quantidades de Frota -----------------------
	INSERT rtFrotaCliente
	SELECT	DISTINCT
		@@spID,
		tbFrotaCliente.CodigoEmpresa,
		tbCaracteristicaCliente.CodigoCliFor,
		tbFrotaCliente.Categoria,
		tbFrotaCliente.SegmentoFrotaCliente,
		tbFabricanteVeiculo.DescricaoFabricanteVeic,
		0

	FROM	
		tbCaracteristicaCliente (NOLOCK)
	INNER JOIN tbFrotaCliente (NOLOCK)
	ON	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
	INNER JOIN tbFabricanteVeiculo (NOLOCK)
	ON	tbFabricanteVeiculo.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
	AND	tbFabricanteVeiculo.CodigoFabricante = tbFrotaCliente.CodigoFabricanteOutros
	WHERE			
		tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
	AND	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
	AND 	tbFrotaCliente.Categoria <> 'ONIBUS'
	AND	tbCaracteristicaCliente.CodigoCliFor IS NOT NULL
	
	UPDATE rtFrotaCliente
	SET TotalFrota = coalesce((   select sum(tbFrotaCliente.QtdeVeiculosFrotaCliente)
					from	tbCaracteristicaCliente (NOLOCK)
					inner join tbFrotaCliente (NOLOCK)
					on	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
				 	and	tbCaracteristicaCliente.CodigoCliFor = rtFrotaCliente.CodigoCliente
					inner join tbFabricanteVeiculo (NOLOCK)
					on	tbFabricanteVeiculo.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
					and	tbFabricanteVeiculo.CodigoFabricante = tbFrotaCliente.CodigoFabricanteOutros
					where	rtFrotaCliente.spID = @@spID
					and	tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
					and	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
					and 	tbFrotaCliente.Categoria = rtFrotaCliente.Categoria
					and 	tbFrotaCliente.SegmentoFrotaCliente = rtFrotaCliente.Segmento
					and 	rtFrotaCliente.DescricaoFabricanteVeic = tbFabricanteVeiculo.DescricaoFabricanteVeic),0)


	--- Total da Frota
	UPDATE rtFichaVisita
	SET    QtdeTotalLeves = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'LEVES'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET    QtdeTotalMedios = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'MEDIOS'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET    QtdeTotalSemiPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'SEMI-PESADOS'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET    QtdeTotalPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'PESADOS'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET    QtdeTotalExtraPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'EXTRA-PESADOS'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeTotalFrota = QtdeTotalLeves + QtdeTotalMedios + QtdeTotalSemiPesados + QtdeTotalPesados +  QtdeTotalExtraPesados
	WHERE spID = @@spID
	AND	rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
	AND	rtFichaVisita.CodigoLocal = @CodigoLocal
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	--- Frota MB
	UPDATE rtFichaVisita
	SET QtdeMBLeves = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				FROM   rtFrotaCliente
				WHERE
				 	rtFrotaCliente.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				AND	rtFrotaCliente.Segmento = 'LEVES'
				AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
				AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeMBMedios  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				FROM   rtFrotaCliente
				WHERE
				 	rtFrotaCliente.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				AND	rtFrotaCliente.Segmento = 'MEDIOS'
				AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
				AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')
		
	UPDATE rtFichaVisita
	SET QtdeMBSemiPesados  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'SEMI-PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeMBPesados  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				FROM   rtFrotaCliente
				WHERE
				 	rtFrotaCliente.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				AND	rtFrotaCliente.Segmento = 'PESADOS'
				AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
				AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeMBExtraPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'EXTRA-PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeFrotaMB = QtdeMBLeves + QtdeMBMedios + QtdeMBSemiPesados + QtdeMBPesados + QtdeMBExtraPesados
	WHERE spID = @@spID
	AND	rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
	AND	rtFichaVisita.CodigoLocal = @CodigoLocal
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	--- Frota Outros
	UPDATE rtFichaVisita
	SET QtdeOutrosLeves = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				FROM   rtFrotaCliente
				WHERE
				 	rtFrotaCliente.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				AND	rtFrotaCliente.Segmento = 'LEVES'
				AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
				AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeOutrosMedios  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'MEDIOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')
		
	UPDATE rtFichaVisita
	SET QtdeOutrosSemiPesados  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'SEMI-PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeOutrosPesados  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeOutrosExtraPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'EXTRA-PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeFrotaOutros = QtdeOutrosLeves + QtdeOutrosMedios + QtdeOutrosSemiPesados + QtdeOutrosPesados + QtdeOutrosExtraPesados
	WHERE spID = @@spID
	AND	rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
	AND	rtFichaVisita.CodigoLocal = @CodigoLocal
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	DELETE rtFrotaCliente
	WHERE spID = @@spID
	------------------------------  FIM -  Quantidades de Frota -----------------------

	------------------------------  Carrega Idade Media Frota -----------------------
	--- Idade Media
	INSERT rtIdadeMediaFrota
	SELECT	DISTINCT
		@@spID,
		tbFrotaCliente.CodigoEmpresa,
		tbCaracteristicaCliente.CodigoCliFor,
		tbFrotaCliente.Categoria,
		tbFrotaCliente.SegmentoFrotaCliente,
		tbFrotaCliente.AnoFabricacaoFrotaCliente,
		0
	FROM	
		tbCaracteristicaCliente (NOLOCK)
	INNER JOIN tbFrotaCliente (NOLOCK)
	ON	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
	INNER JOIN tbFabricanteVeiculo (NOLOCK)
	ON	tbFabricanteVeiculo.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
	AND	tbFabricanteVeiculo.CodigoFabricante = tbFrotaCliente.CodigoFabricanteOutros
	
	WHERE	
		tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
	AND	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
	AND 	tbFrotaCliente.Categoria <> 'ONIBUS'
	AND	tbCaracteristicaCliente.CodigoCliFor IS NOT NULL

	UPDATE rtIdadeMediaFrota
	SET TotalFrota = coalesce((   select sum(tbFrotaCliente.QtdeVeiculosFrotaCliente)
					from	tbCaracteristicaCliente (NOLOCK)
					inner join tbFrotaCliente (NOLOCK)
					on	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
				 	and	tbCaracteristicaCliente.CodigoCliFor = rtIdadeMediaFrota.CodigoCliente
					inner join tbFabricanteVeiculo (NOLOCK)
					on	tbFabricanteVeiculo.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
					and	tbFabricanteVeiculo.CodigoFabricante = tbFrotaCliente.CodigoFabricanteOutros
					where	tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
					and	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
					and 	tbFrotaCliente.Categoria = rtIdadeMediaFrota.Categoria
					and 	tbFrotaCliente.SegmentoFrotaCliente = rtIdadeMediaFrota.Segmento
					and 	tbFrotaCliente.AnoFabricacaoFrotaCliente = rtIdadeMediaFrota.AnoFabricacaoFrotaCliente),0)

	UPDATE rtFichaVisita
	SET IdadeMediaLeves = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
				SUM(rtIdadeMediaFrota.TotalFrota)),0)
				FROM 	rtIdadeMediaFrota
				WHERE
					rtIdadeMediaFrota.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
				AND	rtIdadeMediaFrota.Segmento = 'LEVES')
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET IdadeMediaMedios = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
				SUM(rtIdadeMediaFrota.TotalFrota)),0)
				FROM 	rtIdadeMediaFrota
				WHERE
					rtIdadeMediaFrota.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
				AND	rtIdadeMediaFrota.Segmento = 'MEDIOS')
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'


	UPDATE rtFichaVisita
	SET IdadeMediaSemiPesados = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
					SUM(rtIdadeMediaFrota.TotalFrota)),0)
					FROM 	rtIdadeMediaFrota
					WHERE
						rtIdadeMediaFrota.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
					AND	rtIdadeMediaFrota.Segmento = 'SEMI-PESADOS')
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET IdadeMediaPesados = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
			      	 SUM(rtIdadeMediaFrota.TotalFrota)),0)
				 FROM 	rtIdadeMediaFrota
				 WHERE
				 	rtIdadeMediaFrota.spID = @@spID
				 AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
				 AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				 AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
				 AND	rtIdadeMediaFrota.Segmento = 'PESADOS')
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET IdadeMediaExtraPesados = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
				      SUM(rtIdadeMediaFrota.TotalFrota)),0)
					FROM 	rtIdadeMediaFrota
					WHERE
					 	rtIdadeMediaFrota.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
					AND	rtIdadeMediaFrota.Segmento = 'EXTRA-PESADOS')
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET IdadeMediaTotal = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
				       SUM(rtIdadeMediaFrota.TotalFrota)),0)
				FROM 	rtIdadeMediaFrota
				WHERE
				 	rtIdadeMediaFrota.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente))
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'


	delete rtIdadeMediaFrota
	where spID = @@spID
	------------------------------  FIM - Idade Media Frota -----------------------

	------------------------------  Carrega Vendas Perdidas -----------------------
	INSERT rtVendasPerdidasTP
	SELECT	@@spID,
		tbVendasPerdidasTP.CodigoEmpresa, 
		tbVendasPerdidasTP.CodigoLocal,
		tbVendasPerdidasTP.CodigoClienteST,
		tbVendasPerdidasTP.TipoCliEfetivoPotencial,
		tbVendasPerdidasTP.SegmentosConcorrente,
		SUM(tbVendasPerdidasTP.QuantidadeConcorrente)
	FROM 
		tbVendasPerdidasTP
	WHERE
		tbVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
	AND	tbVendasPerdidasTP.CodigoLocal = @CodigoLocal
	AND	tbVendasPerdidasTP.TipoCliEfetivoPotencial = 'E'

	GROUP BY
		tbVendasPerdidasTP.CodigoEmpresa, 
		tbVendasPerdidasTP.CodigoLocal,
		tbVendasPerdidasTP.CodigoClienteST,
		tbVendasPerdidasTP.TipoCliEfetivoPotencial,
		tbVendasPerdidasTP.SegmentosConcorrente

	UPDATE rtFichaVisita
	SET QuantVendPerdLeves = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
					   WHERE
					  	rtVendasPerdidasTP.spID = @@spID  
					   AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
					   AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
					   AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'E'
					   AND	rtVendasPerdidasTP.Segmento = 'LEVES'),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'
	
	UPDATE rtFichaVisita
	SET QuantVendPerdMedios = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
					    WHERE
					   	rtVendasPerdidasTP.spID = @@spID  
					    AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
					    AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
					    AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
					    AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'E'
					    AND	rtVendasPerdidasTP.Segmento = 'MEDIOS'),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendPerdSemiPesados = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
						  WHERE
						  	rtVendasPerdidasTP.spID = @@spID  
						  AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
						  AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
						  AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
						  AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'E'
						  AND	rtVendasPerdidasTP.Segmento = 'SEMI-PESADOS'),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendPerdPesados = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
					     WHERE
					  		rtVendasPerdidasTP.spID = @@spID  
					     AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
					     AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
					     AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'E'
					     AND	rtVendasPerdidasTP.Segmento = 'PESADOS'),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendPerdExtraPesados = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
					     	  WHERE
					  		rtVendasPerdidasTP.spID = @@spID  
					     	  AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
					     	  AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
					     	  AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     	  AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'E'
					     	  AND	rtVendasPerdidasTP.Segmento = 'EXTRA-PESADOS'),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET VendaPerdida = CASE WHEN ( QuantVendPerdLeves + QuantVendPerdMedios + QuantVendPerdSemiPesados + QuantVendPerdSemiPesados + QuantVendPerdPesados + QuantVendPerdExtraPesados ) > 0 THEN
                              		'V'
                           ELSE
                                      	'F'
                           END
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'


	DELETE rtVendasPerdidasTP
	WHERE spID = @@spID
	------------------------------  FIM - Vendas Perdidas -----------------------

	------------------------------  Carrega Historico Vendas ----------------------------
	INSERT rtHistoricoVendas
	SELECT 
		@@spID,
		tbItemDocumento.CodigoEmpresa, 
		tbItemDocumento.CodigoLocal,
		tbItemDocumento.CodigoCliFor,
		tbNegociacaoCV.ClienteLeasing,
		tbNegociacaoCV.ClienteFaturado,
		tbItemDocumento.NumeroDocumento,
		-- coalesce(sum(tbFrotaCliente.QtdeVeiculosFrotaCliente),0), ---- Obs: retirado a soma de quantidade de veículos da frota do cliente, devido a este insert retornar uma linha por nota de veículo 
		1 as QtdeVeiculosFrotaCliente,								 ---- emitida, depois ira somar as nota, este histórico de vendas da concessão não mostra a quantidade total da frota.
		coalesce(max(tbItemDocumento.DataDocumento),'1900-01-01'),
		tbFrotaCliente.SegmentoFrotaCliente,
		MIN(tbVeiculoCV.VeiculoNovoCV)
	FROM 
		tbItemDocumento (NOLOCK)
	
	INNER JOIN tbNaturezaOperacao (NOLOCK)
	ON         tbNaturezaOperacao.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
	AND        tbNaturezaOperacao.CodigoNaturezaOperacao  = tbItemDocumento.CodigoNaturezaOperacao
	INNER JOIN tbVeiculoCV (NOLOCK)
	ON         tbVeiculoCV.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
	AND        tbVeiculoCV.CodigoLocal = tbItemDocumento.CodigoLocal
	AND	   tbVeiculoCV.NumeroVeiculoCV = tbItemDocumento.NumeroVeiculoCV
	INNER JOIN tbNegociacaoCV (NOLOCK)
	ON	   tbNegociacaoCV.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
	AND	   tbNegociacaoCV.CodigoLocal = tbItemDocumento.CodigoLocal
	AND	   tbNegociacaoCV.NumeroVeiculoCV = tbItemDocumento.NumeroVeiculoCV
	INNER JOIN tbCaracteristicaCliente (NOLOCK)
	ON	   tbCaracteristicaCliente.CodigoEmpresa = tbNegociacaoCV.CodigoEmpresa
	AND	   tbCaracteristicaCliente.CodigoCliFor = coalesce(tbNegociacaoCV.ClienteLeasing,tbNegociacaoCV.ClienteFaturado)
	INNER JOIN tbFrotaCliente (NOLOCK)
	ON         tbFrotaCliente.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
	AND        tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
	AND        tbFrotaCliente.ModeloVeiculo = tbVeiculoCV.ModeloVeiculo
	WHERE
		tbItemDocumento.CodigoEmpresa = @CodigoEmpresa and
		tbItemDocumento.CodigoLocal = @CodigoLocal and
		tbItemDocumento.EntradaSaidaDocumento = 'S' and
		tbItemDocumento.TipoRegistroItemDocto = 'VEC' and
		tbNaturezaOperacao.CodigoTipoOperacao = 4 and
		(
			(
				tbNegociacaoCV.ClienteLeasing is null and (tbNegociacaoCV.ClienteFaturado BETWEEN @DoCliente AND @AteCliente)
			)
			or
			(
				(tbNegociacaoCV.ClienteLeasing BETWEEN @DoCliente AND @AteCliente)
			)
		)
	GROUP BY
		tbItemDocumento.CodigoEmpresa, 
		tbItemDocumento.CodigoLocal,
		tbItemDocumento.CodigoCliFor,
		tbItemDocumento.NumeroDocumento,
		tbNegociacaoCV.ClienteLeasing,
		tbNegociacaoCV.ClienteFaturado,
		tbFrotaCliente.SegmentoFrotaCliente

	---- Novos
	UPDATE rtFichaVisita
	SET QuantVendNovosLeves = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID  
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'LEVES'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompNovosLeves = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
				  			rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'LEVES'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendNovosMedios = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'MEDIOS'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompNovosMedios = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
				  			rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'MEDIOS'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendNovosSemiPesados = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'SEMI-PESADOS'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompNovosSemiPesados = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
					  		rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'SEMI-PESADOS'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendNovosPesados = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'PESADOS'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompNovosPesados = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
					  		rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'PESADOS'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendNovosExtraPesados = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'EXTRA-PESADOS'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompNovosExtPes = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
					  		rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'EXTRA-PESADOS'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)

	--- Semi-Novos
	UPDATE rtFichaVisita
	SET QuantVendSemiNovosLeves = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID  
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'LEVES'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompSemiNovLeves = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
				  			rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'F'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'LEVES'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendSemiNovosMedios = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID  
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'MEDIOS'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompSemiNovMedios = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
				  			rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'F'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'MEDIOS'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)

	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendSemiNovosSemiPesados = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID  
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'SEMI-PESADOS'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompSemiNovSemiPes = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
				  			rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'F'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'SEMI-PESADOS'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)

	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendSemiNovosPesados = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID  
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'PESADOS'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompSemiNovPesados = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
				  			rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'F'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'PESADOS'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendSemiNovosExtraPesados = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID  
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'EXTRA-PESADOS'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompSemiNovExtPes = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
				  			rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'F'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'EXTRA-PESADOS'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)


	DELETE FROM rtHistoricoVendas
	WHERE spID = @@spID
	------------------------------  Fim - Historico Vendas --------------------------------

	END

SELECT 
	rtFichaVisita.CodigoEmpresa, rtFichaVisita.CodigoLocal, rtFichaVisita.TipoCliEfetivoPotencial, rtFichaVisita.ClienteTPCaminhoes, rtFichaVisita.ClienteTPOnibus, 
	rtFichaVisita.ClienteTPSprinter, rtFichaVisita.ClienteTPOutros, rtFichaVisita.RecEmailPropag, rtFichaVisita.TipoCliFor, rtFichaVisita.CodigoClienteST, 
	rtFichaVisita.DataCadastroTP, rtFichaVisita.CodigoRepresentante, rtFichaVisita.NomeRepresentante, rtFichaVisita.TamanhoFrota, rtFichaVisita.PropensaoCompra, 
	rtFichaVisita.DescrPropCompra, rtFichaVisita.RazaoSocialCliente, rtFichaVisita.CNPJ, rtFichaVisita.NomeFantasiaCliente, rtFichaVisita.InscrEstadual, rtFichaVisita.Rua, 
	rtFichaVisita.Numero, rtFichaVisita.Bairro, rtFichaVisita.Municipio, rtFichaVisita.UF, rtFichaVisita.CEP, rtFichaVisita.DDD, rtFichaVisita.Fone, rtFichaVisita.DDDFax, 
	rtFichaVisita.Fax, rtFichaVisita.DescricaoAtividade, rtFichaVisita.NomeContato1, rtFichaVisita.FuncaoContato1, rtFichaVisita.DataAniversarioContato1, rtFichaVisita.email1, 
	rtFichaVisita.DDDCelularContClienteTP1, rtFichaVisita.CelularContatoClienteTP1, rtFichaVisita.DDDFoneContatoClienteTP1, rtFichaVisita.FoneContatoClienteTP1, rtFichaVisita.DescrTimeFutebol1, 
	rtFichaVisita.DescrHobby1, rtFichaVisita.NomeContato2, rtFichaVisita.FuncaoContato2, rtFichaVisita.DataAniversarioContato2, rtFichaVisita.email2, rtFichaVisita.DDDCelularContClienteTP2, 
	rtFichaVisita.CelularContatoClienteTP2, rtFichaVisita.DDDFoneContatoClienteTP2, rtFichaVisita.FoneContatoClienteTP2, rtFichaVisita.DescrTimeFutebol2, rtFichaVisita.DescrHobby2, rtFichaVisita.DataResultadoVisita1, 
	rtFichaVisita.ContatoVisita1, rtFichaVisita.ComentarioVisita1, rtFichaVisita.PendenciaProxVisita1, rtFichaVisita.PropCompraResultado1, rtFichaVisita.DataResultadoVisita2, rtFichaVisita.ContatoVisita2, 
	rtFichaVisita.ComentarioVisita2, rtFichaVisita.PropCompraResultado2, rtFichaVisita.DataResultadoVisita3, rtFichaVisita.ContatoVisita3, rtFichaVisita.ComentarioVisita3, rtFichaVisita.PropCompraResultado3, 
	rtFichaVisita.QtdeTotalLeves, rtFichaVisita.QtdeTotalMedios, rtFichaVisita.QtdeTotalSemiPesados, rtFichaVisita.QtdeTotalPesados, rtFichaVisita.QtdeTotalExtraPesados, rtFichaVisita.QtdeTotalFrota, 
	rtFichaVisita.QtdeMBLeves, rtFichaVisita.QtdeMBMedios, rtFichaVisita.QtdeMBSemiPesados, rtFichaVisita.QtdeMBPesados, rtFichaVisita.QtdeMBExtraPesados, rtFichaVisita.QtdeFrotaMB, rtFichaVisita.QtdeOutrosLeves, 
	rtFichaVisita.QtdeOutrosMedios, rtFichaVisita.QtdeOutrosSemiPesados, rtFichaVisita.QtdeOutrosPesados, rtFichaVisita.QtdeOutrosExtraPesados, rtFichaVisita.QtdeFrotaOutros, rtFichaVisita.IdadeMediaLeves, 
	rtFichaVisita.IdadeMediaMedios, rtFichaVisita.IdadeMediaSemiPesados, rtFichaVisita.IdadeMediaPesados, rtFichaVisita.IdadeMediaExtraPesados, rtFichaVisita.IdadeMediaTotal, rtFichaVisita.SeguroMBTotal, 
	rtFichaVisita.SeguroMBTerceiros, rtFichaVisita.SeguroMBOutros, rtFichaVisita.SeguroTotal, rtFichaVisita.SeguroTerceiros, rtFichaVisita.SeguroOutros, rtFichaVisita.QuantVeicSegurados, rtFichaVisita.PossuiOficinaPropria, 
	rtFichaVisita.PossuiEstoquePecProprio, rtFichaVisita.PossuiContrManut, rtFichaVisita.PossuiContrManutMB, rtFichaVisita.PossuiContrManutOutros, rtFichaVisita.PossuiGarantEstend, rtFichaVisita.PossuiGarantEstendMB, 
	rtFichaVisita.PossuiGarantEstendOutros, rtFichaVisita.FazRevisoes, rtFichaVisita.FormaPagtoVista, rtFichaVisita.FormaPagtoLeasing, rtFichaVisita.FormaPagtoCDC, rtFichaVisita.FormaPagtoFiname, 
	rtFichaVisita.FormaPagtoConsorcio, rtFichaVisita.AprovCredito, rtFichaVisita.BancoMB, rtFichaVisita.BancoOutros, rtFichaVisita.NaoPossuiCredito, rtFichaVisita.QuantVendPerdLeves, rtFichaVisita.QuantVendPerdMedios, 
	rtFichaVisita.QuantVendPerdSemiPesados, rtFichaVisita.QuantVendPerdPesados, rtFichaVisita.QuantVendPerdExtraPesados, rtFichaVisita.QuantVendNovosLeves, rtFichaVisita.QuantVendNovosMedios, rtFichaVisita.QuantVendNovosSemiPesados, 
	rtFichaVisita.QuantVendNovosPesados, rtFichaVisita.QuantVendNovosExtraPesados, rtFichaVisita.QuantVendSemiNovosLeves, rtFichaVisita.QuantVendSemiNovosMedios, rtFichaVisita.QuantVendSemiNovosSemiPesados, 
	rtFichaVisita.QuantVendSemiNovosPesados, rtFichaVisita.QuantVendSemiNovosExtraPesados, rtFichaVisita.DataUltCompNovosLeves, rtFichaVisita.DataUltCompNovosMedios, rtFichaVisita.DataUltCompNovosSemiPesados, 
	rtFichaVisita.DataUltCompNovosPesados, rtFichaVisita.DataUltCompNovosExtPes, rtFichaVisita.DataUltCompSemiNovLeves, rtFichaVisita.DataUltCompSemiNovMedios, rtFichaVisita.DataUltCompSemiNovSemiPes, rtFichaVisita.DataUltCompSemiNovPesados, 
	rtFichaVisita.DataUltCompSemiNovExtPes, rtFichaVisita.TipoClienteFrota, rtFichaVisita.VendaPerdida, rtFichaVisita.ApresentConc, rtFichaVisita.ApresentNovoProd, rtFichaVisita.EntendSatisfProdServ, 
	rtFichaVisita.DespIntCompra, rtFichaVisita.AtualizarInfFichaFrota, rtFichaVisita.ConvidarEvento, rtFichaVisita.ObjetivoOutros, rtFichaVisita.AbordagemVisita, rtFichaVisita.Categoria, rtFichaVisita.Segmento,
	tbResultadoVisitaST.DataResultadoVisita, tbResultadoVisitaST.ContatoVisita, tbResultadoVisitaST.ComentarioVisita,
	tbResultadoVisitaST.TipoContatoVisita, tbResultadoVisitaST.PendenciaProxVisita, tbClienteStarTruck.OutrasInformacoes, rtFichaVisita.FollowUp,
	rtFichaVisita.PeriodoInicialVisita,rtFichaVisita.PeriodoFinalVisita,VisitaConfirmada, @CodigoContatoCliente1 CodigoContatoCliente1, @CodigoContatoCliente2 CodigoContatoCliente2

FROM 		
	rtFichaVisita

INNER JOIN tbClienteStarTruck (NOLOCK)
ON	tbClienteStarTruck.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
AND	tbClienteStarTruck.CodigoLocal = rtFichaVisita.CodigoLocal
AND	tbClienteStarTruck.CodigoClienteST = rtFichaVisita.CodigoClienteST
AND	tbClienteStarTruck.TipoCliEfetivoPotencial = rtFichaVisita.TipoCliEfetivoPotencial

LEFT JOIN tbResultadoVisitaST (NOLOCK)
ON	tbResultadoVisitaST.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
AND	tbResultadoVisitaST.CodigoLocal = rtFichaVisita.CodigoLocal
AND	tbResultadoVisitaST.CodigoClienteST = rtFichaVisita.CodigoClienteST
AND	tbResultadoVisitaST.TipoCliEfetivoPotencial = rtFichaVisita.TipoCliEfetivoPotencial
AND	tbResultadoVisitaST.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
AND	tbResultadoVisitaST.Categoria = rtFichaVisita.Categoria
AND	tbResultadoVisitaST.Segmento = rtFichaVisita.Segmento
AND	(tbResultadoVisitaST.DataResultadoVisita BETWEEN @DaData AND @AteData)

WHERE 
	rtFichaVisita.TipoClienteFrota BETWEEN @DoCliFrota AND @AteCliFrota
AND	rtFichaVisita.spID = @@spID	

AND	(
		(tbResultadoVisitaST.DataResultadoVisita BETWEEN @DaData AND @AteData)
	   OR
		(@ImprimirResultado = 'F')
	)

ORDER BY	
	rtFichaVisita.CodigoEmpresa,
	rtFichaVisita.CodigoLocal, 
	rtFichaVisita.CodigoRepresentante,
	rtFichaVisita.TipoCliEfetivoPotencial,
	rtFichaVisita.CodigoClienteST


DELETE FROM rtFichaVisita
WHERE spID = @@spID

SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whRelTPFichaVisita TO SQLUsers
GO
go

/*
------------------------------------------------------------------------------------------------------------------------------------
 Desenvolvedor.: Alex Kmez
 Data..........: 01/12/2004
 Sistema.......: CRM - Truck Plus      
 Motivo........: 

 whRelTPFVisitaAvulsa 1608, 0, 'E', '2008-03-24 00:00:00.000', '2008-03-24 00:00:00.000', 4, 4, 25990864850, 25990864850, 0, 99, 0, 99, 'F'
------------------------------------------------------------------------------------------------------------------------------------
*/

if exists(select 1 from sysobjects where id = object_id('whRelTPFVisitaAvulsa'))
DROP PROCEDURE dbo.whRelTPFVisitaAvulsa
GO
CREATE PROCEDURE dbo.whRelTPFVisitaAvulsa
	@CodigoEmpresa 		numeric(4),
   	@CodigoLocal 		numeric(4),
	@TipoCliente	        char(1),    --------> (E)fetivo/(P)otencial
	@DaData			datetime,
	@AteData		datetime,
   	@DoRepresentante        numeric(4),
        @AteRepresentante       numeric(4),
        @DoCliente              numeric(14),
        @AteCliente             numeric(14),
        @DaPropensao            numeric(2),
        @AtePropensao           numeric(2),
        @DoCliFrota             numeric(2),
        @AteCliFrota            numeric(2),
	@ImprimirResultado	char(1),
	@ImprimeFollowUp CHAR(1) = 'F'

AS 

SET NOCOUNT ON

DECLARE	@DoClienteResultVis	numeric(14)
DECLARE	@AteClienteResultVis	numeric(14)
DECLARE	@Data			datetime

SELECT @Data = getdate()

DELETE FROM rtContatoCliente
WHERE spID = @@spID

DELETE FROM rtResultadoVisita
WHERE spID = @@spID

if @TipoCliente = 'P' or @TipoCliente = 'A'
	BEGIN

 	INSERT rtFichaVisita
	SELECT  DISTINCT
		spID = @@spID,
		tbClienteRepresentanteTP.CodigoEmpresa,
		tbClienteRepresentanteTP.CodigoLocal,
		tbClienteRepresentanteTP.TipoCliEfetivoPotencial,
		-- DADOS GERAIS
		tbClienteStarTruck.ClienteTPCaminhoes,
		tbClienteStarTruck.ClienteTPOnibus,
		tbClienteStarTruck.ClienteTPSprinter,
		tbClienteStarTruck.ClienteTPOutros,
		tbClienteStarTruck.RecEmailPropag,
		case 	
			when tbClientePotencial.CGCCPFClientePotencial = null then
				'N'
			when len(tbClientePotencial.CGCCPFClientePotencial) > 11 then
				'J'
			else
				'F'
		end										as TipoCliFor,
		tbClienteRepresentanteTP.CodigoClienteST,
		tbClienteStarTruck.DataCadastroTP,
	        tbClienteRepresentanteTP.CodigoRepresentante,
		tbRepresentanteComplementar.NomeRepresentante,
		TamanhoFrota = coalesce((
					select sum(b.QtdeVeiculosFrotaCliente) 
					from tbCaracteristicaCliente a (NOLOCK)
					inner join tbFrotaCliente b (NOLOCK)
					on	a.CodigoEmpresa	= b.CodigoEmpresa
					and	a.CodigoClientePotencial = tbClienteStarTruck.CodigoClienteST
					WHERE	b.CodigoEmpresa	= @CodigoEmpresa
					and	b.NumeroClientePotencialEfetivo	= a.NumeroClientePotencialEfetivo
					),0),
		tbClienteRepresentanteTP.PropensaoCompra,
		tbPropensaoCompraST.DescrPropCompra, 
		tbClientePotencial.RazaoSocialClientePotencial 			as RazaoSocialCliente,
		tbClientePotencial.CGCCPFClientePotencial 			as CNPJ,
		tbClientePotencial.NomeUsualClientePotencial 			as NomeFantasiaCliente,
		tbClientePotencial.InscrEstadualClientePotencial 		as InscrEstadual,
		tbClientePotencial.RuaClientePotencial				as Rua,
		tbClientePotencial.NumeroClientePotencial			as Numero, 
		tbClientePotencial.BairroClientePotencial			as Bairro,
		tbClientePotencial.MunicipioClientePotencial			as Municipio,
		tbClientePotencial.UnidadeFederacao				as UF,
		tbClientePotencial.CEPClientePotencial				as CEP,
		case 	
			when (tbClientePotencial.DDDFoneComercialClientePot = '' or tbClientePotencial.DDDFoneComercialClientePot is null) then
				coalesce(tbClientePotencial.DDDFoneResidenciaClientePot,'')
		     	else
				coalesce(tbClientePotencial.DDDFoneComercialClientePot,'')
		end 	as DDD,
		case 	
			when (tbClientePotencial.FoneComercialClientePot = '' or tbClientePotencial.FoneComercialClientePot is null) then
				coalesce(tbClientePotencial.FoneResidenciaClientePot, '')
		     	else
				coalesce(tbClientePotencial.FoneComercialClientePot, '')
		end 	as Fone,
		coalesce(tbClientePotencial.DDDFaxClientePotencial, '') 	as DDDFax,
		coalesce(tbClientePotencial.FoneFaxClientePotencial, '')	as Fax,
		tbAtividade.DescricaoAtividade					as DescricaoAtividade,

		-- CONTATOS
		convert(varchar(50),'') as NomeContato1,    
		convert(varchar(50),'') as FuncaoContato1,
		convert(varchar(20),'') as DataAniversarioContato1,
		convert(varchar(50),'') as email1,
		convert(varchar(4),'') as DDDCelularContClienteTP1, 
		convert(varchar(15),'') as CelularContatoClienteTP1,
		convert(varchar(4),'') as DDDFoneContatoClienteTP1,  
		convert(varchar(15),'') as FoneContatoClienteTP1, 
		convert(varchar(20),'') as DescrTimeFutebol1,  
		convert(varchar(20),'') as DescrHobby1, 
		convert(varchar(50),'') as NomeContato2,    
		convert(varchar(50),'') as FuncaoContato2,
		convert(varchar(20),'') as DataAniversarioContato2,
		convert(varchar(50),'') as email2,
		convert(varchar(4),'') as DDDCelularContClienteTP2, 
		convert(varchar(15),'') as CelularContatoClienteTP2,
		convert(varchar(4),'') as DDDFoneContatoClienteTP2,  
		convert(varchar(15),'') as FoneContatoClienteTP2, 
		convert(varchar(20),'') as DescrTimeFutebol2,  
		convert(varchar(20),'') as DescrHobby2, 

		-- HISTORICO DE VISITAS
		convert(varchar(20),'') as DataResultadoVisita1,
		convert(varchar(30),'') as ContatoVisita1,
		convert(varchar(300),'') as ComentarioVisita1,
		convert(varchar(300),'') as PendenciaProxVisita1,
		convert(varchar(2),'') as PropCompraResultado1,
		convert(varchar(20),'') as DataResultadoVisita2,
		convert(varchar(30),'') as ContatoVisita2,
		convert(varchar(300),'') as ComentarioVisita2,
		convert(varchar(2),'') as PropCompraResultado2,
		convert(varchar(20),'') as DataResultadoVisita3,
		convert(varchar(30),'') as ContatoVisita3,
		convert(varchar(300),'') as ComentarioVisita3,
		convert(varchar(2),'') as PropCompraResultado3,

		QtdeTotalLeves = 0,
		QtdeTotalMedios = 0,
		QtdeTotalSemiPesados = 0,
		QtdeTotalPesados = 0,
		QtdeTotalExtraPesados = 0,
		QtdeTotalFrota = 0,
		QtdeMBLeves = 0,
		QtdeMBMedios = 0,
		QtdeMBSemiPesados = 0,
		QtdeMBPesados = 0,
		QtdeMBExtraPesados = 0,
		QtdeFrotaMB = 0,
		QtdeOutrosLeves = 0,
		QtdeOutrosMedios = 0,
		QtdeOutrosSemiPesados = 0,
		QtdeOutrosPesados = 0,
		QtdeOutrosExtraPesados = 0,
		QtdeFrotaOutros = 0,
		IdadeMediaLeves = 0,
		IdadeMediaMedios = 0,
		IdadeMediaSemiPesados = 0,
		IdadeMediaPesados = 0,
		IdadeMediaExtraPesados = 0,
		IdadeMediaTotal = 0,

		coalesce(tbSegurosTP.SeguroMBTotal, 'N'),
		coalesce(tbSegurosTP.SeguroMBTerceiros, 'N'),
		coalesce(tbSegurosTP.SeguroMBOutros, 'N'),
		coalesce(tbSegurosTP.SeguroTotal, 'N'),
		coalesce(tbSegurosTP.SeguroTerceiros, 'N'),
		coalesce(tbSegurosTP.SeguroOutros, 'N'),
		tbSegurosTP.QuantVeicSegurados,
		coalesce(tbPosVendaTP.PossuiOficinaPropria,'N'),
		coalesce(tbPosVendaTP.PossuiEstoquePecProprio,'N'),
		coalesce(tbPosVendaTP.PossuiContrManut,'N'),
		coalesce(tbPosVendaTP.PossuiContrManutMB,'N'),
		coalesce(tbPosVendaTP.PossuiContrManutOutros,'N'),
		coalesce(tbPosVendaTP.PossuiGarantEstend,'N'),
		coalesce(tbPosVendaTP.PossuiGarantEstendMB,'N'),
		coalesce(tbPosVendaTP.PossuiGarantEstendOutros,'N'),
		coalesce(tbPosVendaTP.FazRevisoes,'9'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoVista,'N'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoLeasing,'N'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoCDC,'N'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoFiname,'N'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoConsorcio,'N'),
		coalesce(tbDadosFinanceirosTP.AprovCredito,'9'),
		coalesce(tbDadosFinanceirosTP.BancoMB,'N'),
		coalesce(tbDadosFinanceirosTP.BancoOutros,'N'),
		coalesce(tbDadosFinanceirosTP.NaoPossuiCredito,'N'),

		-- VENDAS PERDIDAS
		QuantVendPerdLeves = 0,
		QuantVendPerdMedios = 0,
		QuantVendPerdSemiPesados = 0,
		QuantVendPerdPesados = 0,
		QuantVendPerdExtraPesados =0,

		-- HISTORICO DE VENDAS
		QuantVendNovosLeves = 0,
		QuantVendNovosMedios = 0,
		QuantVendNovosSemiPesados = 0,
		QuantVendNovosPesados = 0,
		QuantVendNovosExtraPesados = 0,
		QuantVendSemiNovosLeves = 0,
		QuantVendSemiNovosMedios = 0,
		QuantVendSemiNovosSemiPesados = 0,
		QuantVendSemiNovosPesados = 0,
		QuantVendSemiNovosExtraPesados = 0,
		DataUltCompNovosLeves = '1900-01-01',
		DataUltCompNovosMedios = '1900-01-01',
		DataUltCompNovosSemiPesados = '1900-01-01',
		DataUltCompNovosPesados = '1900-01-01',
		DataUltCompNovosExtPes = '1900-01-01',
		DataUltCompSemiNovLeves = '1900-01-01',
		DataUltCompSemiNovMedios = '1900-01-01',
		DataUltCompSemiNovSemiPes = '1900-01-01',
		DataUltCompSemiNovPesados = '1900-01-01',
		DataUltCompSemiNovExtPes = '1900-01-01',
		TipoClienteFrota = coalesce (( select max(TipoClienteFrota )
						from tbTipoCliFrotaST (NOLOCK)
						where tbTipoCliFrotaST.CodigoEmpresa = @CodigoEmpresa
						and   tbTipoCliFrotaST.CodigoLocal = @CodigoLocal
						and   (SELECT sum(b.QtdeVeiculosFrotaCliente)
					FROM	tbCaracteristicaCliente a (NOLOCK)
					INNER JOIN tbFrotaCliente b (NOLOCK)
					ON	a.CodigoEmpresa			= b.CodigoEmpresa AND 
						a.CodigoClientePotencial	= tbClienteStarTruck.CodigoClienteST
					WHERE	b.CodigoEmpresa			= @CodigoEmpresa AND 
						b.NumeroClientePotencialEfetivo	= a.NumeroClientePotencialEfetivo)
					between  tbTipoCliFrotaST.QtdeInicialFrota  
					and      tbTipoCliFrotaST.QtdeFinalFrota),0),
		VendaPerdida = 'F',
		'F',
		'F',
		'F',
		'F',
		'F',
		'F',
		'F',
		'',
		tbClienteRepresentanteTP.Categoria,
		tbClienteRepresentanteTP.Segmento,
		'F',
		'',
		'',
		''

	FROM 
		tbClienteRepresentanteTP (NOLOCK)

	INNER JOIN tbClienteStarTruck (NOLOCK) ON
		tbClienteStarTruck.CodigoEmpresa 		= tbClienteRepresentanteTP.CodigoEmpresa 	AND
		tbClienteStarTruck.CodigoLocal			= tbClienteRepresentanteTP.CodigoLocal 		AND
		tbClienteStarTruck.CodigoClienteST		= tbClienteRepresentanteTP.CodigoClienteST	AND
        	tbClienteStarTruck.TipoCliEfetivoPotencial	= tbClienteRepresentanteTP.TipoCliEfetivoPotencial

	INNER JOIN tbPropensaoCompraST (NOLOCK)
	ON	tbPropensaoCompraST.CodigoEmpresa 	= tbClienteRepresentanteTP.CodigoEmpresa
	AND	tbPropensaoCompraST.CodigoLocal		= tbClienteRepresentanteTP.CodigoLocal
	AND	tbPropensaoCompraST.PropensaoCompra	= tbClienteRepresentanteTP.PropensaoCompra

	INNER JOIN tbClientePotencial (NOLOCK)
	ON	tbClientePotencial.CodigoEmpresa  		= tbClienteStarTruck.CodigoEmpresa
	AND	tbClientePotencial.CodigoClientePotencial	= tbClienteStarTruck.CodigoClienteST
		
	INNER JOIN tbEmpresa (NOLOCK) ON
		tbEmpresa.CodigoEmpresa  = tbClienteStarTruck.CodigoEmpresa

	INNER JOIN tbRepresentanteComplementar (NOLOCK) ON
		tbRepresentanteComplementar.CodigoEmpresa  	= tbClienteRepresentanteTP.CodigoEmpresa	AND
		tbRepresentanteComplementar.CodigoRepresentante = tbClienteRepresentanteTP.CodigoRepresentante

	INNER JOIN tbAtividade (NOLOCK)
	ON	tbAtividade.CodigoAtividade = tbClientePotencial.CodigoAtividade

	LEFT JOIN tbSegurosTP (NOLOCK)
	ON	tbSegurosTP.CodigoEmpresa		= tbClienteStarTruck.CodigoEmpresa
	AND	tbSegurosTP.CodigoLocal			= tbClienteStarTruck.CodigoLocal
	AND	tbSegurosTP.CodigoClienteST		= tbClienteStarTruck.CodigoClienteST
	AND	tbSegurosTP.TipoCliEfetivoPotencial	= tbClienteStarTruck.TipoCliEfetivoPotencial
	
	LEFT JOIN tbPosVendaTP (NOLOCK) 
	ON	tbPosVendaTP.CodigoEmpresa		= tbClienteStarTruck.CodigoEmpresa
	AND	tbPosVendaTP.CodigoLocal		= tbClienteStarTruck.CodigoLocal
	AND 	tbPosVendaTP.CodigoClienteST		= tbClienteStarTruck.CodigoClienteST
	AND	tbPosVendaTP.TipoCliEfetivoPotencial	= tbClienteStarTruck.TipoCliEfetivoPotencial
	
	LEFT JOIN tbDadosFinanceirosTP (NOLOCK)
	ON	tbDadosFinanceirosTP.CodigoEmpresa		= tbClienteStarTruck.CodigoEmpresa
	AND	tbDadosFinanceirosTP.CodigoLocal		= tbClienteStarTruck.CodigoLocal
	AND 	tbDadosFinanceirosTP.CodigoClienteST		= tbClienteStarTruck.CodigoClienteST
	AND 	tbDadosFinanceirosTP.TipoCliEfetivoPotencial	= tbClienteStarTruck.TipoCliEfetivoPotencial
		
	WHERE 
	   	tbClienteRepresentanteTP.CodigoEmpresa = @CodigoEmpresa 
	AND   	tbClienteRepresentanteTP.CodigoLocal = @CodigoLocal 
	AND	tbClienteRepresentanteTP.TipoCliEfetivoPotencial = 'P'
	AND     tbClienteRepresentanteTP.CodigoRepresentante = @DoRepresentante
	AND	tbClienteRepresentanteTP.CodigoClienteST = @DoCliente
	AND 	(	
			(
				tbClienteStarTruck.ClienteTPCaminhoes = 'V' 	OR
				tbClienteStarTruck.ClienteTPSprinter = 'V' 	OR
				tbClienteStarTruck.ClienteTPOutros = 'V'
			)
			OR
			(
				tbClienteStarTruck.ClienteTPCaminhoes = 'F' 	AND
				tbClienteStarTruck.ClienteTPOnibus = 'F' 	AND
				tbClienteStarTruck.ClienteTPSprinter = 'F' 	AND
				tbClienteStarTruck.ClienteTPOutros = 'F'
			)
		)
	AND	tbClienteRepresentanteTP.Categoria <> 'ONIBUS'

	------------------------------  Gera 2 Primeiros Contatos do Cliente ---------------
	INSERT	rtContatoCliente
	SELECT DISTINCT
		@@Spid as Spid,
		tbContatoClienteTP.CodigoEmpresa,
		tbClienteRepresentanteTP.CodigoLocal,
		tbClienteRepresentanteTP.CodigoClienteST,
		tbClienteRepresentanteTP.TipoCliEfetivoPotencial,
		tbClienteRepresentanteTP.CodigoRepresentante,
		tbContatoClienteTP.CodigoContatoClienteTP,
		tbContatoClienteTP.NomeContatoClienteTP,
		tbContatoClienteTP.FuncaoContato,
		tbContatoClienteTP.DataAniversarioContato,
		tbContatoClienteTP.EmailContatoClienteTP,
		tbContatoClienteTP.DDDCelularContClienteTP,
		tbContatoClienteTP.CelularContatoClienteTP,
		case 	
			when (tbContatoClienteTP.DDDFoneContatoClienteTP = '' or tbContatoClienteTP.DDDFoneContatoClienteTP is null) then
				coalesce(tbContatoClienteTP.DDDFoneResidContatoClienteTP, '')
		     	else
				coalesce(tbContatoClienteTP.DDDFoneContatoClienteTP, '')
		end 	as DDD,
		case 	
			when (tbContatoClienteTP.FoneContatoClienteTP = '' or tbContatoClienteTP.FoneContatoClienteTP is null) then
				coalesce(tbContatoClienteTP.FoneResidContatoClienteTP, '')
		     	else
				coalesce(tbContatoClienteTP.FoneContatoClienteTP, '')
		end 	as Fone,
		tbContatoClienteTP.DescrTimeFutebol,
		tbContatoClienteTP.DescrHobby,
		tbClienteRepresentanteTP.Categoria,
		tbClienteRepresentanteTP.Segmento,
		tbContatoClienteTP.OrdemContato,
		tbContatoClienteTP.timestamp
	FROM 
		tbClienteRepresentanteTP
	
	INNER JOIN tbContatoClienteTP (NOLOCK) 
	ON	tbClienteRepresentanteTP.CodigoEmpresa = tbContatoClienteTP.CodigoEmpresa
	AND	tbClienteRepresentanteTP.CodigoClienteST = convert(numeric(14),tbContatoClienteTP.CodigoClientePotencial)
	AND	tbClienteRepresentanteTP.CodigoContatoClienteTP = tbContatoClienteTP.CodigoContatoClienteTP
	AND	tbClienteRepresentanteTP.TipoCliEfetivoPotencial = 'P'
	AND   	tbContatoClienteTP.Categoria <> 'ONIBUS'

	WHERE 	
		tbClienteRepresentanteTP.CodigoEmpresa  = @CodigoEmpresa
	AND	tbClienteRepresentanteTP.CodigoLocal = @CodigoLocal
	AND	tbClienteRepresentanteTP.CodigoClienteST = @DoCliente
	AND	tbClienteRepresentanteTP.TipoCliEfetivoPotencial = 'P'
	AND	tbClienteRepresentanteTP.CodigoRepresentante = @DoRepresentante
	AND   	tbClienteRepresentanteTP.Categoria <> 'ONIBUS'
	AND	tbContatoClienteTP.OrdemContato in (1,2)

	ORDER BY tbContatoClienteTP.CodigoContatoClienteTP, 
		 tbContatoClienteTP.OrdemContato

	update rtFichaVisita
	set 
		NomeContato1 = (SELECT  max(NomeContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)), 
		FuncaoContato1 = (SELECT max(FuncaoContato)
 					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)), 
		DataAniversarioContato1 = (SELECT  CONVERT(varchar(20),max(DataAniversarioContato),103)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)), 
		email1 = (SELECT  max(EmailContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)), 
		DDDCelularContClienteTP1 = coalesce((SELECT max(DDDCelularContClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)),''), 
		CelularContatoClienteTP1 = coalesce((SELECT  max(CelularContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)),0), 
		DDDFoneContatoClienteTP1 = coalesce((SELECT max(DDDFoneContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)),''), 
		FoneContatoClienteTP1 = coalesce((SELECT  max(FoneContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)),''), 
		DescrTimeFutebol1 = (SELECT  max(DescrTimeFutebol)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1)), 
		DescrHobby1 = (SELECT  max(DescrHobby)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
											FROM rtContatoCliente
											WHERE  	rtContatoCliente.spID = @@spID
											AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
											AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
											AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
											AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
											AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
											AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
											AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
											AND     rtContatoCliente.OrdemContato = 1))
		
	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	update rtFichaVisita
	set 
		NomeContato2 = (SELECT  max(NomeContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)), 
		FuncaoContato2 = (SELECT max(FuncaoContato)
 					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)), 
		DataAniversarioContato2 = (SELECT  CONVERT(varchar(20), max(DataAniversarioContato),103)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)),
		email2 = (SELECT  max(EmailContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)),
		DDDCelularContClienteTP2 = coalesce((SELECT  max(DDDCelularContClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)),''),
		CelularContatoClienteTP2 = coalesce((SELECT  max(CelularContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND     rtContatoCliente.OrdemContato = 2
						AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)),''), 
		DDDFoneContatoClienteTP2 = coalesce((SELECT  max(DDDFoneContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND     rtContatoCliente.OrdemContato = 2
						AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)),''),
		FoneContatoClienteTP2 = coalesce((SELECT max(FoneContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND     rtContatoCliente.OrdemContato = 2
						AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)),''), 
		DescrTimeFutebol2 = (SELECT  max(DescrTimeFutebol)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)),
		DescrHobby2 = (SELECT  max(DescrHobby)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND 	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'P'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2))

	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	DELETE FROM rtContatoCliente
	WHERE spID = @@spID
	------------------------------  Fim Contatos do Cliente ----------------------------

	------------------------------  Gera 3 Ultimas Visitas -----------------------------
	--------------------------------   Carrega Ultima Visita  -----------------------
	SELECT @DoClienteResultVis = MIN(CodigoClienteST) FROM rtFichaVisita
     	WHERE rtFichaVisita.spID = @@spID
     	AND   rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
     	AND   rtFichaVisita.CodigoLocal = @CodigoLocal 
     	AND   rtFichaVisita.TipoCliEfetivoPotencial = 'P'
     	AND   rtFichaVisita.CodigoRepresentante = @DoRepresentante

	SELECT @AteClienteResultVis = MAX(CodigoClienteST) FROM rtFichaVisita
	WHERE rtFichaVisita.spID = @@spID
	AND   rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
	AND   rtFichaVisita.CodigoLocal = @CodigoLocal 
	AND   rtFichaVisita.TipoCliEfetivoPotencial = 'P'
	AND   rtFichaVisita.CodigoRepresentante = @DoRepresentante

	EXECUTE  whRelTPFichaVisResultado @CodigoEmpresa, @CodigoLocal, 'P', @DoRepresentante, @DoRepresentante, @DoClienteResultVis, @AteClienteResultVis, @Data, 'F'

	update rtFichaVisita
	set 
		DataResultadoVisita1 = (SELECT  convert(varchar(20),max(DataResultadoVisita), 103)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1), 
		ContatoVisita1 = (SELECT max(ContatoVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1), 
		ComentarioVisita1 = (SELECT max(ComentarioVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1), 
		PendenciaProxVisita1 = 	(SELECT  max(PendenciaProxVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1), 
		PropCompraResultado1 = (SELECT  max(PropCompraResultado)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1)
	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	--------------------------------   Fim Carrega Ultima Visita  ---------------------

	--------------------------------   Carrega Penultima Visita  ----------------------
	update rtFichaVisita
	set 
		DataResultadoVisita2 = (SELECT  convert(varchar(20),max(DataResultadoVisita), 103)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 2), 
		ContatoVisita2 = (SELECT  max(ContatoVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 2), 
		ComentarioVisita2 = (SELECT  max(ComentarioVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 2), 
		PropCompraResultado2 = (SELECT  max(PropCompraResultado)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 2)
	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'P'
	--------------------------------   Fim Carrega Penultima Visita  ------------------

	--------------------------------   Carrega anti - penultima Visita  ----------------------
	update rtFichaVisita
	set 
		DataResultadoVisita3 = (SELECT  convert(varchar(20),max(DataResultadoVisita), 103)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 3), 
		ContatoVisita3 = (SELECT  max(ContatoVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 3),
		ComentarioVisita3 = (SELECT  max(ComentarioVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 3),
		PropCompraResultado3 = (SELECT  max(PropCompraResultado)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'P'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 3)	
	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	--------------------------------   Fim Carrega anti - penultima Visita  ------------------
	DELETE FROM rtResultadoVisita
	WHERE spID = @@spID
	------------------------------  Fim 3 Ultimas Visitas ------------------------------

	------------------------------  Carrega Quantidades de Frota -----------------------
	INSERT rtFrotaCliente
	SELECT	DISTINCT
		@@spID,
		tbFrotaCliente.CodigoEmpresa,
		tbCaracteristicaCliente.CodigoClientePotencial,
		tbFrotaCliente.Categoria,
		tbFrotaCliente.SegmentoFrotaCliente,
		tbFabricanteVeiculo.DescricaoFabricanteVeic,
		0

	FROM	
		tbCaracteristicaCliente (NOLOCK)
	INNER JOIN tbFrotaCliente (NOLOCK)
	ON	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
	INNER JOIN tbFabricanteVeiculo (NOLOCK)
	ON	tbFabricanteVeiculo.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
	AND	tbFabricanteVeiculo.CodigoFabricante = tbFrotaCliente.CodigoFabricanteOutros
	WHERE			
		tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
	AND	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
	AND 	tbFrotaCliente.Categoria <> 'ONIBUS'
	AND	tbCaracteristicaCliente.CodigoClientePotencial IS NOT NULL
	
	UPDATE rtFrotaCliente
	SET TotalFrota = coalesce((   select sum(tbFrotaCliente.QtdeVeiculosFrotaCliente)
					from	tbCaracteristicaCliente (NOLOCK)
					inner join tbFrotaCliente (NOLOCK)
					on	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
				 	and	tbCaracteristicaCliente.CodigoClientePotencial = rtFrotaCliente.CodigoCliente
					inner join tbFabricanteVeiculo (NOLOCK)
					on	tbFabricanteVeiculo.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
					and	tbFabricanteVeiculo.CodigoFabricante = tbFrotaCliente.CodigoFabricanteOutros
					where	rtFrotaCliente.spID = @@spID
					and	tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
					and	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
					and 	tbFrotaCliente.Categoria = rtFrotaCliente.Categoria
					and 	tbFrotaCliente.SegmentoFrotaCliente = rtFrotaCliente.Segmento
					and 	rtFrotaCliente.DescricaoFabricanteVeic = tbFabricanteVeiculo.DescricaoFabricanteVeic),0)

	--- Total da Frota
	UPDATE rtFichaVisita
	SET    QtdeTotalLeves = ( SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
			 	  FROM   rtFrotaCliente
				  WHERE
				 	rtFrotaCliente.spID = @@spID
				  AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				  AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				  AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				  AND	rtFrotaCliente.Segmento = 'LEVES'
				  AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET    QtdeTotalMedios = ( SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				   FROM   rtFrotaCliente
				   WHERE
				 	rtFrotaCliente.spID = @@spID
				   AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				   AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				   AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				   AND	rtFrotaCliente.Segmento = 'MEDIOS'
				   AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET    QtdeTotalSemiPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'SEMI-PESADOS'
					AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET    QtdeTotalPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				   FROM   rtFrotaCliente
				   WHERE
				 	rtFrotaCliente.spID = @@spID
				   AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				   AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				   AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				   AND	rtFrotaCliente.Segmento = 'PESADOS'
				   AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET    QtdeTotalExtraPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'EXTRA-PESADOS'
					AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeTotalFrota = QtdeTotalLeves + QtdeTotalMedios + QtdeTotalSemiPesados + QtdeTotalPesados +  QtdeTotalExtraPesados
	WHERE spID = @@spID
	AND	rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
	AND	rtFichaVisita.CodigoLocal = @CodigoLocal	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	--- Frota MB
	UPDATE rtFichaVisita
	SET QtdeMBLeves = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
			   FROM   rtFrotaCliente
			   WHERE
			 	rtFrotaCliente.spID = @@spID
			   AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
			   AND	rtFichaVisita.CodigoLocal = @CodigoLocal
			   AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
			   AND	rtFrotaCliente.Segmento = 'LEVES'
			   AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
			   AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeMBMedios  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				FROM   rtFrotaCliente
				WHERE
				 	rtFrotaCliente.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				AND	rtFrotaCliente.Segmento = 'MEDIOS'
				AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
				AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')
		
	UPDATE rtFichaVisita
	SET QtdeMBSemiPesados  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'SEMI-PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
					AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeMBPesados  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				FROM   rtFrotaCliente
				WHERE
				 	rtFrotaCliente.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				AND	rtFrotaCliente.Segmento = 'PESADOS'
				AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
				AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeMBExtraPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'EXTRA-PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
					AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeFrotaMB = QtdeMBLeves + QtdeMBMedios + QtdeMBSemiPesados + QtdeMBPesados + QtdeMBExtraPesados
	WHERE spID = @@spID
	AND	rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
	AND	rtFichaVisita.CodigoLocal = @CodigoLocal	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	--- Frota Outros
	UPDATE rtFichaVisita
	SET QtdeOutrosLeves = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				FROM   rtFrotaCliente
				WHERE
				 	rtFrotaCliente.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				AND	rtFrotaCliente.Segmento = 'LEVES'
				AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
				AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeOutrosMedios  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				FROM   rtFrotaCliente
				WHERE
				 	rtFrotaCliente.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				AND	rtFrotaCliente.Segmento = 'MEDIOS'
				AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
				AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')
		
	UPDATE rtFichaVisita
	SET QtdeOutrosSemiPesados  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'SEMI-PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
					AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeOutrosPesados  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
					AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeOutrosExtraPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'EXTRA-PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
					AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P')

	UPDATE rtFichaVisita
	SET QtdeFrotaOutros = QtdeOutrosLeves + QtdeOutrosMedios + QtdeOutrosSemiPesados + QtdeOutrosPesados + QtdeOutrosExtraPesados
	WHERE spID = @@spID
	AND	rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
	AND	rtFichaVisita.CodigoLocal = @CodigoLocal
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	delete rtFrotaCliente
	where spID = @@spID
	------------------------------  FIM -  Quantidades de Frota -----------------------

	------------------------------  Carrega Idade Media Frota -----------------------
	--- Idade Media
	INSERT rtIdadeMediaFrota
	SELECT	DISTINCT
		@@spID,
		tbFrotaCliente.CodigoEmpresa,
		tbCaracteristicaCliente.CodigoClientePotencial,
		tbFrotaCliente.Categoria,
		tbFrotaCliente.SegmentoFrotaCliente,
		tbFrotaCliente.AnoFabricacaoFrotaCliente,
		0
	
	FROM	
		tbCaracteristicaCliente (NOLOCK)
	INNER JOIN tbFrotaCliente (NOLOCK)
	ON	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
	INNER JOIN tbFabricanteVeiculo (NOLOCK)
	ON	tbFabricanteVeiculo.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
	AND	tbFabricanteVeiculo.CodigoFabricante = tbFrotaCliente.CodigoFabricanteOutros
	
	WHERE	
		tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
	AND	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
	AND 	tbFrotaCliente.Categoria <> 'ONIBUS'
	AND	tbCaracteristicaCliente.CodigoClientePotencial IS NOT NULL

	UPDATE rtIdadeMediaFrota
	SET TotalFrota = coalesce((   select sum(tbFrotaCliente.QtdeVeiculosFrotaCliente)
					from	tbCaracteristicaCliente (NOLOCK)
					inner join tbFrotaCliente (NOLOCK)
					on	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
			 		and	tbCaracteristicaCliente.CodigoClientePotencial = rtIdadeMediaFrota.CodigoCliente
					inner join tbFabricanteVeiculo (NOLOCK)
					on	tbFabricanteVeiculo.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
					and	tbFabricanteVeiculo.CodigoFabricante = tbFrotaCliente.CodigoFabricanteOutros
					where	tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
					and	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
					and 	tbFrotaCliente.Categoria = rtIdadeMediaFrota.Categoria
					and 	tbFrotaCliente.SegmentoFrotaCliente = rtIdadeMediaFrota.Segmento
					and 	tbFrotaCliente.AnoFabricacaoFrotaCliente = rtIdadeMediaFrota.AnoFabricacaoFrotaCliente),0)

	UPDATE rtFichaVisita
	SET IdadeMediaLeves = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
				SUM(rtIdadeMediaFrota.TotalFrota)),0)
				FROM 	rtIdadeMediaFrota
				WHERE
					rtIdadeMediaFrota.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
				AND	rtIdadeMediaFrota.Segmento = 'LEVES')
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	UPDATE rtFichaVisita
	SET IdadeMediaMedios = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
				SUM(rtIdadeMediaFrota.TotalFrota)),0)
				FROM 	rtIdadeMediaFrota
				WHERE
					rtIdadeMediaFrota.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
				AND	rtIdadeMediaFrota.Segmento = 'MEDIOS')
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	UPDATE rtFichaVisita
	SET IdadeMediaSemiPesados = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
					SUM(rtIdadeMediaFrota.TotalFrota)),0)
					FROM 	rtIdadeMediaFrota
					WHERE
						rtIdadeMediaFrota.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
					AND	rtIdadeMediaFrota.Segmento = 'SEMI-PESADOS')
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'


	UPDATE rtFichaVisita
	SET IdadeMediaPesados = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
			      	 SUM(rtIdadeMediaFrota.TotalFrota)),0)
				 FROM 	rtIdadeMediaFrota
				 WHERE
				 	rtIdadeMediaFrota.spID = @@spID
				 AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
				 AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				 AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
				 AND	rtIdadeMediaFrota.Segmento = 'PESADOS')
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	UPDATE rtFichaVisita
	SET IdadeMediaExtraPesados = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
				      SUM(rtIdadeMediaFrota.TotalFrota)),0)
					FROM 	rtIdadeMediaFrota
					WHERE
					 	rtIdadeMediaFrota.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
					AND	rtIdadeMediaFrota.Segmento = 'EXTRA-PESADOS')
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	UPDATE rtFichaVisita
	SET IdadeMediaTotal = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
				       SUM(rtIdadeMediaFrota.TotalFrota)),0)
				FROM 	rtIdadeMediaFrota
				WHERE
				 	rtIdadeMediaFrota.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente))
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	delete rtIdadeMediaFrota
	where spID = @@spID
	------------------------------  FIM - Idade Media Frota -----------------------

	------------------------------  Carrega Vendas Perdidas -----------------------
	INSERT rtVendasPerdidasTP
	SELECT	@@spID,
		tbVendasPerdidasTP.CodigoEmpresa, 
		tbVendasPerdidasTP.CodigoLocal,
		tbVendasPerdidasTP.CodigoClienteST,
		tbVendasPerdidasTP.TipoCliEfetivoPotencial,
		tbVendasPerdidasTP.SegmentosConcorrente,
		SUM(tbVendasPerdidasTP.QuantidadeConcorrente)
	FROM 
		tbVendasPerdidasTP
	WHERE
		tbVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
	AND	tbVendasPerdidasTP.CodigoLocal = @CodigoLocal
	AND	tbVendasPerdidasTP.TipoCliEfetivoPotencial = 'P'

	GROUP BY
		tbVendasPerdidasTP.CodigoEmpresa, 
		tbVendasPerdidasTP.CodigoLocal,
		tbVendasPerdidasTP.CodigoClienteST,
		tbVendasPerdidasTP.TipoCliEfetivoPotencial,
		tbVendasPerdidasTP.SegmentosConcorrente

	UPDATE rtFichaVisita
	SET QuantVendPerdLeves = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
					   WHERE
					  	rtVendasPerdidasTP.spID = @@spID  
					   AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
					   AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
					   AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'P'
					   AND	rtVendasPerdidasTP.Segmento = 'LEVES'),0)
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'
	
	UPDATE rtFichaVisita
	SET QuantVendPerdMedios = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
					    WHERE
					   	rtVendasPerdidasTP.spID = @@spID  
					    AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
					    AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
					    AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
					    AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'P'
					    AND	rtVendasPerdidasTP.Segmento = 'MEDIOS'),0)
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	UPDATE rtFichaVisita
	SET QuantVendPerdSemiPesados = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
						  WHERE
						  	rtVendasPerdidasTP.spID = @@spID  
						  AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
						  AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
						  AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
						  AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'P'
						  AND	rtVendasPerdidasTP.Segmento = 'SEMI-PESADOS'),0)
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	UPDATE rtFichaVisita
	SET QuantVendPerdPesados = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
					     WHERE
					  		rtVendasPerdidasTP.spID = @@spID  
					     AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
					     AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
					     AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'P'
					     AND	rtVendasPerdidasTP.Segmento = 'PESADOS'),0)
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	UPDATE rtFichaVisita
	SET QuantVendPerdExtraPesados = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
					     	  WHERE
					  		rtVendasPerdidasTP.spID = @@spID  
					     	  AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
					     	  AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
					     	  AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     	  AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'P'
					     	  AND	rtVendasPerdidasTP.Segmento = 'EXTRA-PESADOS'),0)
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	UPDATE rtFichaVisita
	SET VendaPerdida = CASE WHEN ( QuantVendPerdLeves + QuantVendPerdMedios + QuantVendPerdSemiPesados + QuantVendPerdSemiPesados + QuantVendPerdPesados + QuantVendPerdExtraPesados ) > 0 THEN
                              		'V'
                           ELSE
                                      	'F'
                           END
	WHERE 
		rtFichaVisita.spID = @@spID	
	AND	rtFichaVisita.TipoCliEfetivoPotencial = 'P'

	DELETE rtVendasPerdidasTP
	WHERE spID = @@spID
	------------------------------  FIM - Vendas Perdidas -----------------------
	--------------------------  Carrega Cursor para Atualização  --------------------

	END

if @TipoCliente = 'E' or @TipoCliente = 'A'
	BEGIN

	INSERT rtFichaVisita
	SELECT 	DISTINCT
		spID = @@spID,
		tbClienteRepresentanteTP.CodigoEmpresa,
		tbClienteRepresentanteTP.CodigoLocal,
		tbClienteRepresentanteTP.TipoCliEfetivoPotencial,
		-- DADOS GERAIS
		tbClienteStarTruck.ClienteTPCaminhoes,
		tbClienteStarTruck.ClienteTPOnibus,
		tbClienteStarTruck.ClienteTPSprinter,
		tbClienteStarTruck.ClienteTPOutros,
		tbClienteStarTruck.RecEmailPropag,
		tbCliFor.TipoCliFor,
		tbClienteRepresentanteTP.CodigoClienteST,
		tbClienteStarTruck.DataCadastroTP,
	        tbClienteRepresentanteTP.CodigoRepresentante,
		tbRepresentanteComplementar.NomeRepresentante,
		TamanhoFrota = coalesce((	
						select sum(tbFrotaCliente.QtdeVeiculosFrotaCliente)
					 	from	tbCaracteristicaCliente (NOLOCK)
						inner join tbFrotaCliente (NOLOCK)
						on	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
						and	tbCaracteristicaCliente.CodigoCliFor = tbClienteStarTruck.CodigoClienteST
						where	tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
						and	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
					),0),
		tbClienteRepresentanteTP.PropensaoCompra,
        	tbPropensaoCompraST.DescrPropCompra, 
		tbCliFor.NomeCliFor 				as RazaoSocialCliente,
		CASE
		   WHEN (tbCliFor.TipoCliFor) = 'F' THEN
			tbCliForFisica.CPFFisica
	   	   ELSE
			tbCliForJuridica.CGCJuridica
		END 						as CNPJ,
		tbCliFor.NomeUsualCliFor 			as NomeFantasiaCliente,
		CASE
		   WHEN (tbCliFor.TipoCliFor) = 'F' THEN
			tbCliForFisica.RGFisica
	   	   ELSE
			tbCliForJuridica.InscricaoEstadualJuridica
		END 							as InscrEstadual,
		tbCliFor.RuaCliFor					as Rua,
		tbCliFor.NumeroEndCliFor 				as Numero,
		tbCliFor.BairroCliFor					as Bairro,
		tbCliFor.MunicipioCliFor				as Municipio,
		tbCliFor.UFCliFor					as UF,
		tbCliFor.CEPCliFor					as CEP,
		CASE
		   WHEN (tbCliFor.TipoCliFor) = 'F' THEN
			case 	
				when (tbCliForFisica.DDDComercialFisica = '' or tbCliForFisica.DDDComercialFisica is null) then
					coalesce(tbCliFor.DDDTelefoneCliFor,'')
		     		else
					coalesce(tbCliForFisica.DDDComercialFisica,'')
			end

	   	   ELSE
			coalesce(tbCliFor.DDDTelefoneCliFor,'')
		END 	as DDD,

		CASE
		   WHEN (tbCliFor.TipoCliFor) = 'F' THEN
			case 	
				when (tbCliForFisica.TelefoneComercialFisica = '' or tbCliForFisica.TelefoneComercialFisica is null) then
					coalesce(tbCliFor.TelefoneCliFor,'')
			     	else
					coalesce(tbCliForFisica.TelefoneComercialFisica,'')
			end

	   	   ELSE
			coalesce(tbCliFor.TelefoneCliFor,'')
		END 	as Fone,
		coalesce(tbCliFor.DDDFaxCliFor,'') as DDDFax,
		coalesce(tbCliFor.FaxCliFor,'') as Fax,
		tbAtividade.DescricaoAtividade					as DescricaoAtividade,

		-- CONTATOS
		convert(varchar(50),'') as NomeContato1,    
		convert(varchar(50),'') as FuncaoContato1,
		convert(varchar(20),'') as DataAniversarioContato1,
		convert(varchar(50),'') as email1,
		convert(varchar(4),'') as DDDCelularContClienteTP1, 
		convert(varchar(15),'') as CelularContatoClienteTP1,
		convert(varchar(4),'') as DDDFoneContatoClienteTP1,  
		convert(varchar(15),'') as FoneContatoClienteTP1, 
		convert(varchar(20),'') as DescrTimeFutebol1,  
		convert(varchar(20),'') as DescrHobby1, 
		convert(varchar(50),'') as NomeContato2,    
		convert(varchar(50),'') as FuncaoContato2,
		convert(varchar(20),'') as DataAniversarioContato2,
		convert(varchar(50),'') as email2,
		convert(varchar(4),'') as DDDCelularContClienteTP2, 
		convert(varchar(15),'') as CelularContatoClienteTP2,
		convert(varchar(4),'') as DDDFoneContatoClienteTP2,  
		convert(varchar(15),'') as FoneContatoClienteTP2, 
		convert(varchar(20),'') as DescrTimeFutebol2,  
		convert(varchar(20),'') as DescrHobby2, 

		-- HISTORICO DE VISITAS
		convert(varchar(20),'') as DataResultadoVisita1,
		convert(varchar(30),'') as ContatoVisita1,
		convert(varchar(300),'') as ComentarioVisita1,
		convert(varchar(300),'') as PendenciaProxVisita1,
		convert(varchar(2),'') as PropCompraResultado1,
		convert(varchar(20),'') as DataResultadoVisita2,
		convert(varchar(30),'') as ContatoVisita2,
		convert(varchar(300),'') as ComentarioVisita2,
		convert(varchar(2),'') as PropCompraResultado2,
		convert(varchar(20),'') as DataResultadoVisita3,
		convert(varchar(30),'') as ContatoVisita3,
		convert(varchar(300),'') as ComentarioVisita3,
		convert(varchar(2),'') as PropCompraResultado3,

		QtdeTotalLeves = 0,
		QtdeTotalMedios = 0,
		QtdeTotalSemiPesados = 0,
		QtdeTotalPesados = 0,
		QtdeTotalExtraPesados = 0,
		QtdeTotalFrota = 0,
		QtdeMBLeves = 0,
		QtdeMBMedios = 0,
		QtdeMBSemiPesados = 0,
		QtdeMBPesados = 0,
		QtdeMBExtraPesados = 0,
		QtdeFrotaMB = 0,
		QtdeOutrosLeves = 0,
		QtdeOutrosMedios = 0,
		QtdeOutrosSemiPesados = 0,
		QtdeOutrosPesados = 0,
		QtdeOutrosExtraPesados = 0,
		QtdeFrotaOutros = 0,
		IdadeMediaLeves = 0,
		IdadeMediaMedios = 0,
		IdadeMediaSemiPesados = 0,
		IdadeMediaPesados = 0,
		IdadeMediaExtraPesados = 0,
		IdadeMediaTotal = 0,

		coalesce(tbSegurosTP.SeguroMBTotal, 'N'),
		coalesce(tbSegurosTP.SeguroMBTerceiros, 'N'),
		coalesce(tbSegurosTP.SeguroMBOutros, 'N'),
		coalesce(tbSegurosTP.SeguroTotal, 'N'),
		coalesce(tbSegurosTP.SeguroTerceiros, 'N'),
		coalesce(tbSegurosTP.SeguroOutros, 'N'),
		tbSegurosTP.QuantVeicSegurados,
		coalesce(tbPosVendaTP.PossuiOficinaPropria,'N'),
		coalesce(tbPosVendaTP.PossuiEstoquePecProprio,'N'),
		coalesce(tbPosVendaTP.PossuiContrManut,'N'),
		coalesce(tbPosVendaTP.PossuiContrManutMB,'N'),
		coalesce(tbPosVendaTP.PossuiContrManutOutros,'N'),
		coalesce(tbPosVendaTP.PossuiGarantEstend,'N'),
		coalesce(tbPosVendaTP.PossuiGarantEstendMB,'N'),
		coalesce(tbPosVendaTP.PossuiGarantEstendOutros,'N'),
		coalesce(tbPosVendaTP.FazRevisoes,'9'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoVista,'N'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoLeasing,'N'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoCDC,'N'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoFiname,'N'),
		coalesce(tbDadosFinanceirosTP.FormaPagtoConsorcio,'N'),
		coalesce(tbDadosFinanceirosTP.AprovCredito,'9'),
		coalesce(tbDadosFinanceirosTP.BancoMB,'N'),
		coalesce(tbDadosFinanceirosTP.BancoOutros,'N'),
		coalesce(tbDadosFinanceirosTP.NaoPossuiCredito,'N'),

		-- VENDAS PERDIDAS
		QuantVendPerdLeves = 0,
		QuantVendPerdMedios = 0,
		QuantVendPerdSemiPesados = 0,
		QuantVendPerdPesados = 0,
		QuantVendPerdExtraPesados = 0,


		-- HISTORICO DE VENDAS
		QuantVendNovosLeves =   0,
		QuantVendNovosMedios =  0,
		QuantVendNovosSemiPesados = 0,
		QuantVendNovosPesados =  0,
		QuantVendNovosExtraPesados = 0,
		QuantVendSemiNovosLeves =  0,
		QuantVendSemiNovosMedios = 0,
		QuantVendSemiNovosSemiPesados = 0,
		QuantVendSemiNovosPesados = 0,
		QuantVendSemiNovosExtraPesados = 0,

		DataUltCompNovosLeves = '1900-01-01',
		DataUltCompNovosMedios = '1900-01-01',
		DataUltCompNovosSemiPesados = '1900-01-01',
		DataUltCompNovosPesados = '1900-01-01',
		DataUltCompNovosExtPes = '1900-01-01',
		DataUltCompSemiNovLeves = '1900-01-01',
		DataUltCompSemiNovMedios = '1900-01-01',
		DataUltCompSemiNovSemiPes = '1900-01-01',
		DataUltCompSemiNovPesados = '1900-01-01',
		DataUltCompSemiNovExtPes = '1900-01-01',
		TipoClienteFrota = coalesce (( select max(TipoClienteFrota )
						from tbTipoCliFrotaST (NOLOCK)
						where tbTipoCliFrotaST.CodigoEmpresa = @CodigoEmpresa
						and   tbTipoCliFrotaST.CodigoLocal = @CodigoLocal
						and   (SELECT sum(b.QtdeVeiculosFrotaCliente)
					FROM	tbCaracteristicaCliente a (NOLOCK)
					INNER JOIN tbFrotaCliente b (NOLOCK)
					ON	a.CodigoEmpresa	= b.CodigoEmpresa AND 
						a.CodigoCliFor = tbClienteStarTruck.CodigoClienteST
					WHERE	b.CodigoEmpresa = @CodigoEmpresa AND 
						b.NumeroClientePotencialEfetivo	= a.NumeroClientePotencialEfetivo)
					between  tbTipoCliFrotaST.QtdeInicialFrota  
					and      tbTipoCliFrotaST.QtdeFinalFrota),0),
		VendaPerdida = 'F',
		'F',
		'F',
		'F',
		'F',
		'F',
		'F',
		'F',
		'',
		tbClienteRepresentanteTP.Categoria,
		tbClienteRepresentanteTP.Segmento,
		'F',
		'',
		'',
		''

	FROM 
		tbClienteRepresentanteTP (NOLOCK)

	INNER JOIN tbClienteStarTruck (NOLOCK) ON
		tbClienteStarTruck.CodigoEmpresa 		= tbClienteRepresentanteTP.CodigoEmpresa 	AND
		tbClienteStarTruck.CodigoLocal			= tbClienteRepresentanteTP.CodigoLocal 		AND
		tbClienteStarTruck.CodigoClienteST		= tbClienteRepresentanteTP.CodigoClienteST	AND
        	tbClienteStarTruck.TipoCliEfetivoPotencial	= tbClienteRepresentanteTP.TipoCliEfetivoPotencial

	INNER JOIN tbPropensaoCompraST (NOLOCK) ON
		tbPropensaoCompraST.CodigoEmpresa 	= tbClienteRepresentanteTP.CodigoEmpresa	AND
		tbPropensaoCompraST.CodigoLocal		= tbClienteRepresentanteTP.CodigoLocal	AND
		tbPropensaoCompraST.PropensaoCompra	= tbClienteRepresentanteTP.PropensaoCompra
	
	INNER JOIN tbCliFor (NOLOCK) ON
		tbCliFor.CodigoEmpresa  		= tbClienteStarTruck.CodigoEmpresa	AND
		tbCliFor.CodigoCliFor			= tbClienteStarTruck.CodigoClienteST

	LEFT JOIN tbCliForFisica (NOLOCK) ON
		tbCliForFisica.CodigoEmpresa  		= tbClienteStarTruck.CodigoEmpresa	AND
		tbCliForFisica.CodigoCliFor		= tbClienteStarTruck.CodigoClienteST

	LEFT JOIN tbCliForJuridica (NOLOCK) ON
		tbCliForJuridica.CodigoEmpresa 		= tbClienteStarTruck.CodigoEmpresa	AND
		tbCliForJuridica.CodigoCliFor		= tbClienteStarTruck.CodigoClienteST

	INNER JOIN tbAtividade (NOLOCK)
	ON	tbAtividade.CodigoAtividade = COALESCE(tbCliForFisica.CodigoAtividade,tbCliForJuridica.CodigoAtividade)


	INNER JOIN tbEmpresa (NOLOCK) ON
		tbEmpresa.CodigoEmpresa  = tbClienteStarTruck.CodigoEmpresa
	
	INNER JOIN tbRepresentanteComplementar (NOLOCK) ON
		tbRepresentanteComplementar.CodigoEmpresa  	= tbClienteRepresentanteTP.CodigoEmpresa	AND
		tbRepresentanteComplementar.CodigoRepresentante = tbClienteRepresentanteTP.CodigoRepresentante

	LEFT JOIN tbSegurosTP (NOLOCK)
	ON	tbSegurosTP.CodigoEmpresa		= tbClienteStarTruck.CodigoEmpresa
	AND	tbSegurosTP.CodigoLocal			= tbClienteStarTruck.CodigoLocal
	AND	tbSegurosTP.CodigoClienteST		= tbClienteStarTruck.CodigoClienteST
	AND	tbSegurosTP.TipoCliEfetivoPotencial	= tbClienteStarTruck.TipoCliEfetivoPotencial
	
	LEFT JOIN tbPosVendaTP (NOLOCK) 
	ON	tbPosVendaTP.CodigoEmpresa		= tbClienteStarTruck.CodigoEmpresa
	AND	tbPosVendaTP.CodigoLocal		= tbClienteStarTruck.CodigoLocal
	AND 	tbPosVendaTP.CodigoClienteST		= tbClienteStarTruck.CodigoClienteST
	AND	tbPosVendaTP.TipoCliEfetivoPotencial	= tbClienteStarTruck.TipoCliEfetivoPotencial
	
	LEFT JOIN tbDadosFinanceirosTP (NOLOCK)
	ON	tbDadosFinanceirosTP.CodigoEmpresa		= tbClienteStarTruck.CodigoEmpresa
	AND	tbDadosFinanceirosTP.CodigoLocal		= tbClienteStarTruck.CodigoLocal
	AND 	tbDadosFinanceirosTP.CodigoClienteST		= tbClienteStarTruck.CodigoClienteST
	AND 	tbDadosFinanceirosTP.TipoCliEfetivoPotencial	= tbClienteStarTruck.TipoCliEfetivoPotencial
		
	WHERE 
	   	tbClienteRepresentanteTP.CodigoEmpresa = @CodigoEmpresa 
	AND   	tbClienteRepresentanteTP.CodigoLocal = @CodigoLocal 
	AND	tbClienteRepresentanteTP.TipoCliEfetivoPotencial = 'E'
	AND     tbClienteRepresentanteTP.CodigoRepresentante = @DoRepresentante
	AND	tbClienteRepresentanteTP.CodigoClienteST = @DoCliente
	AND 	(	
			(
				tbClienteStarTruck.ClienteTPCaminhoes = 'V' 	OR
				tbClienteStarTruck.ClienteTPSprinter = 'V' 	OR
				tbClienteStarTruck.ClienteTPOutros = 'V'
			)
			OR
			(
				tbClienteStarTruck.ClienteTPCaminhoes = 'F' 	AND
				tbClienteStarTruck.ClienteTPOnibus = 'F' 	AND
				tbClienteStarTruck.ClienteTPSprinter = 'F' 	AND
				tbClienteStarTruck.ClienteTPOutros = 'F'
			)
		)
	AND	tbClienteRepresentanteTP.Categoria <> 'ONIBUS'

	------------------------------  Gera 2 Primeiros Contatos do Cliente ---------------
	INSERT	rtContatoCliente
	SELECT DISTINCT
		@@Spid as Spid,
		tbContatoClienteTP.CodigoEmpresa,
		tbClienteRepresentanteTP.CodigoLocal,
		tbClienteRepresentanteTP.CodigoClienteST,
		tbClienteRepresentanteTP.TipoCliEfetivoPotencial,
		tbClienteRepresentanteTP.CodigoRepresentante,
		tbContatoClienteTP.CodigoContatoClienteTP,
		tbContatoClienteTP.NomeContatoClienteTP,
		tbContatoClienteTP.FuncaoContato,
		tbContatoClienteTP.DataAniversarioContato,
		tbContatoClienteTP.EmailContatoClienteTP,
		tbContatoClienteTP.DDDCelularContClienteTP,
		tbContatoClienteTP.CelularContatoClienteTP,
		case 	
			when (tbContatoClienteTP.DDDFoneContatoClienteTP = '' or tbContatoClienteTP.DDDFoneContatoClienteTP is null) then
				coalesce(tbContatoClienteTP.DDDFoneResidContatoClienteTP, '')
		     	else
				coalesce(tbContatoClienteTP.DDDFoneContatoClienteTP, '')
		end 	as DDD,
		case 	
			when (tbContatoClienteTP.FoneContatoClienteTP = '' or tbContatoClienteTP.FoneContatoClienteTP is null) then
				coalesce(tbContatoClienteTP.FoneResidContatoClienteTP, '')
		     	else
				coalesce(tbContatoClienteTP.FoneContatoClienteTP, '')
		end 	as Fone,
		tbContatoClienteTP.DescrTimeFutebol,
		tbContatoClienteTP.DescrHobby,
		tbClienteRepresentanteTP.Categoria,
		tbClienteRepresentanteTP.Segmento,
		tbContatoClienteTP.OrdemContato,
		tbContatoClienteTP.timestamp
	FROM 
		tbClienteRepresentanteTP
	
	INNER JOIN tbContatoClienteTP (NOLOCK) 
	ON	tbClienteRepresentanteTP.CodigoEmpresa = tbContatoClienteTP.CodigoEmpresa
	AND	tbClienteRepresentanteTP.CodigoClienteST = tbContatoClienteTP.CodigoCliFor
	AND	tbClienteRepresentanteTP.CodigoContatoClienteTP = tbContatoClienteTP.CodigoContatoClienteTP
	AND	tbClienteRepresentanteTP.TipoCliEfetivoPotencial = 'E'
	AND   	tbContatoClienteTP.Categoria <> 'ONIBUS'
	
	WHERE 	
		tbClienteRepresentanteTP.CodigoEmpresa  = @CodigoEmpresa
	AND	tbClienteRepresentanteTP.CodigoLocal = @CodigoLocal
	AND	tbClienteRepresentanteTP.CodigoClienteST = @DoCliente
	AND	tbClienteRepresentanteTP.TipoCliEfetivoPotencial = 'E'
	AND	tbClienteRepresentanteTP.CodigoRepresentante = @DoRepresentante
	AND   	tbClienteRepresentanteTP.Categoria <> 'ONIBUS'
	AND	tbContatoClienteTP.OrdemContato in (1,2)

	ORDER BY tbContatoClienteTP.CodigoContatoClienteTP, 
		 tbContatoClienteTP.OrdemContato

	update rtFichaVisita
	set 
		NomeContato1 = (SELECT  max(NomeContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)), 
		FuncaoContato1 = (SELECT max(FuncaoContato)
 					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),
		DataAniversarioContato1 = (SELECT  CONVERT(varchar(20), max(DataAniversarioContato),103)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),
		email1 = (SELECT  max(EmailContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),
		DDDCelularContClienteTP1 = coalesce((SELECT max(DDDCelularContClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND     rtContatoCliente.OrdemContato = 1
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),''),
		CelularContatoClienteTP1 = coalesce((SELECT max(CelularContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),''), 
		DDDFoneContatoClienteTP1 = coalesce((SELECT max(DDDFoneContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND     rtContatoCliente.OrdemContato = 1
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),''), 
		FoneContatoClienteTP1 = coalesce((SELECT max(FoneContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND     rtContatoCliente.OrdemContato = 1
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),''), 
		DescrTimeFutebol1 = (SELECT  max(DescrTimeFutebol)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1)),
		DescrHobby1 = (SELECT  max(DescrHobby)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 1
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 1))
	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	update rtFichaVisita
	set 
		NomeContato2 = (SELECT  max(NomeContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)), 
		FuncaoContato2 = (SELECT max(FuncaoContato)
 					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)), 
		DataAniversarioContato2 = (SELECT  CONVERT(varchar(20), max(DataAniversarioContato),103)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)), 
		email2 = (SELECT  max(EmailContatoClienteTP)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
					AND     rtContatoCliente.OrdemContato = 2
					AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
												FROM rtContatoCliente
												WHERE  	rtContatoCliente.spID = @@spID
												AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
												AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
												AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
												AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
												AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
												AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
												AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
												AND     rtContatoCliente.OrdemContato = 2)), 
		DDDCelularContClienteTP2 = coalesce((SELECT max(DDDCelularContClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND     rtContatoCliente.OrdemContato = 2
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
													FROM rtContatoCliente
													WHERE  	rtContatoCliente.spID = @@spID
													AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
													AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
													AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
													AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
													AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
													AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
													AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
													AND     rtContatoCliente.OrdemContato = 2)),''),
		CelularContatoClienteTP2 = coalesce((SELECT max(CelularContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND     rtContatoCliente.OrdemContato = 2
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
													FROM rtContatoCliente
													WHERE  	rtContatoCliente.spID = @@spID
													AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
													AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
													AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
													AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
													AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
													AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
													AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
													AND     rtContatoCliente.OrdemContato = 2)),''), 
		DDDFoneContatoClienteTP2 = coalesce((SELECT max(DDDFoneContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
													FROM rtContatoCliente
													WHERE  	rtContatoCliente.spID = @@spID
													AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
													AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
													AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
													AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
													AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
													AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
													AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
													AND     rtContatoCliente.OrdemContato = 2)),''),
		FoneContatoClienteTP2 = coalesce((SELECT max(FoneContatoClienteTP)
						FROM rtContatoCliente
						WHERE  	rtContatoCliente.spID = @@spID
						AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
						AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
						AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
						AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
						AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
						AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
						AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
													FROM rtContatoCliente
													WHERE  	rtContatoCliente.spID = @@spID
													AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
													AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
													AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
													AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
													AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
													AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
													AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
													AND     rtContatoCliente.OrdemContato = 2)),''), 
		DescrTimeFutebol2 = (SELECT  max(DescrTimeFutebol)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
													FROM rtContatoCliente
													WHERE  	rtContatoCliente.spID = @@spID
													AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
													AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
													AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
													AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
													AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
													AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
													AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
													AND     rtContatoCliente.OrdemContato = 2)),
		DescrHobby2 = (SELECT  max(DescrHobby)
					FROM rtContatoCliente
					WHERE  	rtContatoCliente.spID = @@spID
					AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
					AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
					AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
					AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
						AND	rtContatoCliente.NomeContatoClienteTP = (SELECT  max(NomeContatoClienteTP)
													FROM rtContatoCliente
													WHERE  	rtContatoCliente.spID = @@spID
													AND     rtContatoCliente.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
													AND     rtContatoCliente.CodigoLocal = rtFichaVisita.CodigoLocal
													AND     rtContatoCliente.CodigoClienteST = rtFichaVisita.CodigoClienteST
													AND     rtContatoCliente.TipoCliEfetivoPotencial = 'E'
													AND     rtContatoCliente.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
													AND     rtContatoCliente.Categoria = rtFichaVisita.Categoria
													AND     rtContatoCliente.Segmento = rtFichaVisita.Segmento
													AND     rtContatoCliente.OrdemContato = 2))
	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	DELETE FROM rtContatoCliente
	WHERE spID = @@spID
	------------------------------  Fim Contatos do Cliente ----------------------------

	------------------------------  Gera 3 Ultimas Visitas -----------------------------
	--------------------------------   Carrega Ultima Visita  -----------------------
	SELECT @DoClienteResultVis = MIN(CodigoClienteST) FROM rtFichaVisita
     	WHERE rtFichaVisita.spID = @@spID
     	AND   rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
     	AND   rtFichaVisita.CodigoLocal = @CodigoLocal 
     	AND   rtFichaVisita.TipoCliEfetivoPotencial = 'E'
     	AND   rtFichaVisita.CodigoRepresentante = @DoRepresentante

	SELECT @AteClienteResultVis = MAX(CodigoClienteST) FROM rtFichaVisita
	WHERE rtFichaVisita.spID = @@spID
	AND   rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
	AND   rtFichaVisita.CodigoLocal = @CodigoLocal 
	AND   rtFichaVisita.TipoCliEfetivoPotencial = 'E'
	AND   rtFichaVisita.CodigoRepresentante = @DoRepresentante


	EXECUTE  whRelTPFichaVisResultado @CodigoEmpresa, @CodigoLocal, 'E', @DoRepresentante, @DoRepresentante, @DoClienteResultVis, @AteClienteResultVis, @Data, 'F'

	update rtFichaVisita
	set 
		DataResultadoVisita1 = (SELECT  convert(varchar(20),max(DataResultadoVisita), 103)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1), 
			ContatoVisita1 = (SELECT max(ContatoVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1), 
		ComentarioVisita1 = (SELECT max(ComentarioVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1), 
		PendenciaProxVisita1 = 	(SELECT  max(PendenciaProxVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1), 
		PropCompraResultado1 = (SELECT  max(PropCompraResultado)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 1)
	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	--------------------------------   Fim Carrega Ultima Visita  ---------------------

	--------------------------------   Carrega Penultima Visita  ----------------------
	update rtFichaVisita
	set 
		DataResultadoVisita2 = (SELECT  convert(varchar(20),max(DataResultadoVisita), 103)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 2), 
		ContatoVisita2 = (SELECT  max(ContatoVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 2), 
		ComentarioVisita2 = (SELECT  max(ComentarioVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 2), 
		PropCompraResultado2 = (SELECT  max(PropCompraResultado)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 2)
	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'
	--------------------------------   Fim Carrega Penultima Visita  ------------------

	--------------------------------   Carrega anti - penultima Visita  ----------------------
	update rtFichaVisita
	set 
		DataResultadoVisita3 = (SELECT  convert(varchar(20),max(DataResultadoVisita), 103)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 3), 
		ContatoVisita3 = (SELECT  max(ContatoVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 3),
		ComentarioVisita3 = (SELECT  max(ComentarioVisita)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 3),
		PropCompraResultado3 = (SELECT  max(PropCompraResultado)
					FROM rtResultadoVisita
					WHERE  	rtResultadoVisita.spID = @@spID
					AND     rtResultadoVisita.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
					AND     rtResultadoVisita.CodigoLocal = rtFichaVisita.CodigoLocal
					AND     rtResultadoVisita.CodigoClienteST = rtFichaVisita.CodigoClienteST
					AND     rtResultadoVisita.TipoCliEfetivoPotencial = 'E'
					AND	rtResultadoVisita.Categoria <> 'ONIBUS'
					AND     rtResultadoVisita.OrdemContato = 3)	
	where
		rtFichaVisita.spID = @@spID 
	and 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'
	--------------------------------   Fim Carrega anti - penultima Visita  ------------------

	DELETE FROM rtResultadoVisita
	WHERE spID = @@spID
	------------------------------  Fim 3 Ultimas Visitas ------------------------------

	------------------------------  Carrega Quantidades de Frota -----------------------
	INSERT rtFrotaCliente
	SELECT	DISTINCT
		@@spID,
		tbFrotaCliente.CodigoEmpresa,
		tbCaracteristicaCliente.CodigoCliFor,
		tbFrotaCliente.Categoria,
		tbFrotaCliente.SegmentoFrotaCliente,
		tbFabricanteVeiculo.DescricaoFabricanteVeic,
		0

	FROM	
		tbCaracteristicaCliente (NOLOCK)
	INNER JOIN tbFrotaCliente (NOLOCK)
	ON	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
	INNER JOIN tbFabricanteVeiculo (NOLOCK)
	ON	tbFabricanteVeiculo.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
	AND	tbFabricanteVeiculo.CodigoFabricante = tbFrotaCliente.CodigoFabricanteOutros
	WHERE			
		tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
	AND	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
	AND 	tbFrotaCliente.Categoria <> 'ONIBUS'
	AND	tbCaracteristicaCliente.CodigoCliFor IS NOT NULL
	
	UPDATE rtFrotaCliente
	SET TotalFrota = coalesce((   select sum(tbFrotaCliente.QtdeVeiculosFrotaCliente)
					from	tbCaracteristicaCliente (NOLOCK)
					inner join tbFrotaCliente (NOLOCK)
					on	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
				 	and	tbCaracteristicaCliente.CodigoCliFor = rtFrotaCliente.CodigoCliente
					inner join tbFabricanteVeiculo (NOLOCK)
					on	tbFabricanteVeiculo.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
					and	tbFabricanteVeiculo.CodigoFabricante = tbFrotaCliente.CodigoFabricanteOutros
					where	rtFrotaCliente.spID = @@spID
					and	tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
					and	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
					and 	tbFrotaCliente.Categoria = rtFrotaCliente.Categoria
					and 	tbFrotaCliente.SegmentoFrotaCliente = rtFrotaCliente.Segmento
					and 	rtFrotaCliente.DescricaoFabricanteVeic = tbFabricanteVeiculo.DescricaoFabricanteVeic),0)


	--- Total da Frota
	UPDATE rtFichaVisita
	SET    QtdeTotalLeves = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'LEVES'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET    QtdeTotalMedios = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'MEDIOS'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET    QtdeTotalSemiPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'SEMI-PESADOS'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET    QtdeTotalPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'PESADOS'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET    QtdeTotalExtraPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'EXTRA-PESADOS'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeTotalFrota = QtdeTotalLeves + QtdeTotalMedios + QtdeTotalSemiPesados + QtdeTotalPesados +  QtdeTotalExtraPesados
	WHERE spID = @@spID
	AND	rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
	AND	rtFichaVisita.CodigoLocal = @CodigoLocal
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	--- Frota MB
	UPDATE rtFichaVisita
	SET QtdeMBLeves = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				FROM   rtFrotaCliente
				WHERE
				 	rtFrotaCliente.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				AND	rtFrotaCliente.Segmento = 'LEVES'
				AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
				AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeMBMedios  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				FROM   rtFrotaCliente
				WHERE
				 	rtFrotaCliente.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				AND	rtFrotaCliente.Segmento = 'MEDIOS'
				AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
				AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')
		
	UPDATE rtFichaVisita
	SET QtdeMBSemiPesados  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'SEMI-PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeMBPesados  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				FROM   rtFrotaCliente
				WHERE
				 	rtFrotaCliente.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				AND	rtFrotaCliente.Segmento = 'PESADOS'
				AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
				AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeMBExtraPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'EXTRA-PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic like '%MERCEDES%'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeFrotaMB = QtdeMBLeves + QtdeMBMedios + QtdeMBSemiPesados + QtdeMBPesados + QtdeMBExtraPesados
	WHERE spID = @@spID
	AND	rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
	AND	rtFichaVisita.CodigoLocal = @CodigoLocal
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	--- Frota Outros
	UPDATE rtFichaVisita
	SET QtdeOutrosLeves = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
				FROM   rtFrotaCliente
				WHERE
				 	rtFrotaCliente.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
				AND	rtFrotaCliente.Segmento = 'LEVES'
				AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
				AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeOutrosMedios  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'MEDIOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')
		
	UPDATE rtFichaVisita
	SET QtdeOutrosSemiPesados  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'SEMI-PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeOutrosPesados  = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeOutrosExtraPesados = (SELECT coalesce(sum(rtFrotaCliente.TotalFrota),0)
					FROM   rtFrotaCliente
					WHERE
					 	rtFrotaCliente.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtFrotaCliente.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtFrotaCliente.CodigoCliente)
					AND	rtFrotaCliente.Segmento = 'EXTRA-PESADOS'
					AND	rtFrotaCliente.DescricaoFabricanteVeic not like '%MERCEDES%'
					AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E')

	UPDATE rtFichaVisita
	SET QtdeFrotaOutros = QtdeOutrosLeves + QtdeOutrosMedios + QtdeOutrosSemiPesados + QtdeOutrosPesados + QtdeOutrosExtraPesados
	WHERE spID = @@spID
	AND	rtFichaVisita.CodigoEmpresa = @CodigoEmpresa
	AND	rtFichaVisita.CodigoLocal = @CodigoLocal
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	DELETE rtFrotaCliente
	WHERE spID = @@spID
	------------------------------  FIM -  Quantidades de Frota -----------------------

	------------------------------  Carrega Idade Media Frota -----------------------
	--- Idade Media
	INSERT rtIdadeMediaFrota
	SELECT	DISTINCT
		@@spID,
		tbFrotaCliente.CodigoEmpresa,
		tbCaracteristicaCliente.CodigoCliFor,
		tbFrotaCliente.Categoria,
		tbFrotaCliente.SegmentoFrotaCliente,
		tbFrotaCliente.AnoFabricacaoFrotaCliente,
		0
	FROM	
		tbCaracteristicaCliente (NOLOCK)
	INNER JOIN tbFrotaCliente (NOLOCK)
	ON	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
	INNER JOIN tbFabricanteVeiculo (NOLOCK)
	ON	tbFabricanteVeiculo.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
	AND	tbFabricanteVeiculo.CodigoFabricante = tbFrotaCliente.CodigoFabricanteOutros
	
	WHERE	
		tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
	AND	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
	AND 	tbFrotaCliente.Categoria <> 'ONIBUS'
	AND	tbCaracteristicaCliente.CodigoCliFor IS NOT NULL

	UPDATE rtIdadeMediaFrota
	SET TotalFrota = coalesce((   select sum(tbFrotaCliente.QtdeVeiculosFrotaCliente)
					from	tbCaracteristicaCliente (NOLOCK)
					inner join tbFrotaCliente (NOLOCK)
					on	tbCaracteristicaCliente.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
				 	and	tbCaracteristicaCliente.CodigoCliFor = rtIdadeMediaFrota.CodigoCliente
					inner join tbFabricanteVeiculo (NOLOCK)
					on	tbFabricanteVeiculo.CodigoEmpresa = tbFrotaCliente.CodigoEmpresa
					and	tbFabricanteVeiculo.CodigoFabricante = tbFrotaCliente.CodigoFabricanteOutros
					where	tbFrotaCliente.CodigoEmpresa = @CodigoEmpresa
					and	tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
					and 	tbFrotaCliente.Categoria = rtIdadeMediaFrota.Categoria
					and 	tbFrotaCliente.SegmentoFrotaCliente = rtIdadeMediaFrota.Segmento
					and 	tbFrotaCliente.AnoFabricacaoFrotaCliente = rtIdadeMediaFrota.AnoFabricacaoFrotaCliente),0)

	UPDATE rtFichaVisita
	SET IdadeMediaLeves = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
				SUM(rtIdadeMediaFrota.TotalFrota)),0)
				FROM 	rtIdadeMediaFrota
				WHERE
					rtIdadeMediaFrota.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
				AND	rtIdadeMediaFrota.Segmento = 'LEVES')
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET IdadeMediaMedios = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
				SUM(rtIdadeMediaFrota.TotalFrota)),0)
				FROM 	rtIdadeMediaFrota
				WHERE
					rtIdadeMediaFrota.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
				AND	rtIdadeMediaFrota.Segmento = 'MEDIOS')
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'


	UPDATE rtFichaVisita
	SET IdadeMediaSemiPesados = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
					SUM(rtIdadeMediaFrota.TotalFrota)),0)
					FROM 	rtIdadeMediaFrota
					WHERE
						rtIdadeMediaFrota.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
					AND	rtIdadeMediaFrota.Segmento = 'SEMI-PESADOS')
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET IdadeMediaPesados = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
			      	 SUM(rtIdadeMediaFrota.TotalFrota)),0)
				 FROM 	rtIdadeMediaFrota
				 WHERE
				 	rtIdadeMediaFrota.spID = @@spID
				 AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
				 AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				 AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
				 AND	rtIdadeMediaFrota.Segmento = 'PESADOS')
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET IdadeMediaExtraPesados = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
				      SUM(rtIdadeMediaFrota.TotalFrota)),0)
					FROM 	rtIdadeMediaFrota
					WHERE
					 	rtIdadeMediaFrota.spID = @@spID
					AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
					AND	rtFichaVisita.CodigoLocal = @CodigoLocal
					AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente)
					AND	rtIdadeMediaFrota.Segmento = 'EXTRA-PESADOS')
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET IdadeMediaTotal = (SELECT COALESCE(CONVERT(NUMERIC(8,2),SUM(DATEPART(YEAR,GETDATE())- rtIdadeMediaFrota.AnoFabricacaoFrotaCliente)  /
				       SUM(rtIdadeMediaFrota.TotalFrota)),0)
				FROM 	rtIdadeMediaFrota
				WHERE
				 	rtIdadeMediaFrota.spID = @@spID
				AND	rtFichaVisita.CodigoEmpresa = rtIdadeMediaFrota.CodigoEmpresa
				AND	rtFichaVisita.CodigoLocal = @CodigoLocal
				AND	convert(numeric(14),rtFichaVisita.CodigoClienteST) = convert(numeric(14),rtIdadeMediaFrota.CodigoCliente))
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'


	delete rtIdadeMediaFrota
	where spID = @@spID
	------------------------------  FIM - Idade Media Frota -----------------------

	------------------------------  Carrega Vendas Perdidas -----------------------
	INSERT rtVendasPerdidasTP
	SELECT	@@spID,
		tbVendasPerdidasTP.CodigoEmpresa, 
		tbVendasPerdidasTP.CodigoLocal,
		tbVendasPerdidasTP.CodigoClienteST,
		tbVendasPerdidasTP.TipoCliEfetivoPotencial,
		tbVendasPerdidasTP.SegmentosConcorrente,
		SUM(tbVendasPerdidasTP.QuantidadeConcorrente)
	FROM 
		tbVendasPerdidasTP
	WHERE
		tbVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
	AND	tbVendasPerdidasTP.CodigoLocal = @CodigoLocal
	AND	tbVendasPerdidasTP.TipoCliEfetivoPotencial = 'E'

	GROUP BY
		tbVendasPerdidasTP.CodigoEmpresa, 
		tbVendasPerdidasTP.CodigoLocal,
		tbVendasPerdidasTP.CodigoClienteST,
		tbVendasPerdidasTP.TipoCliEfetivoPotencial,
		tbVendasPerdidasTP.SegmentosConcorrente

	UPDATE rtFichaVisita
	SET QuantVendPerdLeves = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
					   WHERE
					  	rtVendasPerdidasTP.spID = @@spID  
					   AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
					   AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
					   AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'E'
					   AND	rtVendasPerdidasTP.Segmento = 'LEVES'),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'
	
	UPDATE rtFichaVisita
	SET QuantVendPerdMedios = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
					    WHERE
					   	rtVendasPerdidasTP.spID = @@spID  
					    AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
					    AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
					    AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
					    AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'E'
					    AND	rtVendasPerdidasTP.Segmento = 'MEDIOS'),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendPerdSemiPesados = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
						  WHERE
						  	rtVendasPerdidasTP.spID = @@spID  
						  AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
						  AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
						  AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
						  AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'E'
						  AND	rtVendasPerdidasTP.Segmento = 'SEMI-PESADOS'),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendPerdPesados = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
					     WHERE
					  		rtVendasPerdidasTP.spID = @@spID  
					     AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
					     AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
					     AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'E'
					     AND	rtVendasPerdidasTP.Segmento = 'PESADOS'),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendPerdExtraPesados = coalesce((SELECT rtVendasPerdidasTP.QuantidadeConcorrente FROM rtVendasPerdidasTP
					     	  WHERE
					  		rtVendasPerdidasTP.spID = @@spID  
					     	  AND	rtVendasPerdidasTP.CodigoEmpresa = @CodigoEmpresa
					     	  AND	rtVendasPerdidasTP.CodigoLocal = @CodigoLocal
					     	  AND	rtVendasPerdidasTP.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     	  AND	rtVendasPerdidasTP.TipoCliEfetivoPotencial = 'E'
					     	  AND	rtVendasPerdidasTP.Segmento = 'EXTRA-PESADOS'),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET VendaPerdida = CASE WHEN ( QuantVendPerdLeves + QuantVendPerdMedios + QuantVendPerdSemiPesados + QuantVendPerdSemiPesados + QuantVendPerdPesados + QuantVendPerdExtraPesados ) > 0 THEN
                              		'V'
                           ELSE
                                      	'F'
                           END
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'


	DELETE rtVendasPerdidasTP
	WHERE spID = @@spID
	------------------------------  FIM - Vendas Perdidas -----------------------

	------------------------------  Carrega Historico Vendas ----------------------------
	INSERT rtHistoricoVendas
	SELECT 
		@@spID,
		tbItemDocumento.CodigoEmpresa, 
		tbItemDocumento.CodigoLocal,
		tbItemDocumento.CodigoCliFor,
		tbNegociacaoCV.ClienteLeasing,
		tbNegociacaoCV.ClienteFaturado,
		tbItemDocumento.NumeroDocumento,
		coalesce(sum(tbFrotaCliente.QtdeVeiculosFrotaCliente),0),
		coalesce(max(tbItemDocumento.DataDocumento),'1900-01-01'),
		tbFrotaCliente.SegmentoFrotaCliente,
		MIN(tbVeiculoCV.VeiculoNovoCV)
	FROM 
		tbItemDocumento (NOLOCK)
	
	INNER JOIN tbNaturezaOperacao (NOLOCK)
	ON         tbNaturezaOperacao.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
	AND        tbNaturezaOperacao.CodigoNaturezaOperacao  = tbItemDocumento.CodigoNaturezaOperacao
	INNER JOIN tbVeiculoCV (NOLOCK)
	ON         tbVeiculoCV.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
	AND        tbVeiculoCV.CodigoLocal = tbItemDocumento.CodigoLocal
	AND	   tbVeiculoCV.NumeroVeiculoCV = tbItemDocumento.NumeroVeiculoCV
	INNER JOIN tbNegociacaoCV (NOLOCK)
	ON	   tbNegociacaoCV.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
	AND	   tbNegociacaoCV.CodigoLocal = tbItemDocumento.CodigoLocal
	AND	   tbNegociacaoCV.NumeroVeiculoCV = tbItemDocumento.NumeroVeiculoCV
	INNER JOIN tbCaracteristicaCliente (NOLOCK)
	ON	   tbCaracteristicaCliente.CodigoEmpresa = tbNegociacaoCV.CodigoEmpresa
	AND	   tbCaracteristicaCliente.CodigoCliFor = coalesce(tbNegociacaoCV.ClienteLeasing,tbNegociacaoCV.ClienteFaturado)
	INNER JOIN tbFrotaCliente (NOLOCK)
	ON         tbFrotaCliente.CodigoEmpresa = tbItemDocumento.CodigoEmpresa
	AND        tbFrotaCliente.NumeroClientePotencialEfetivo = tbCaracteristicaCliente.NumeroClientePotencialEfetivo
	AND        tbFrotaCliente.ModeloVeiculo = tbVeiculoCV.ModeloVeiculo
	WHERE
		tbItemDocumento.CodigoEmpresa = @CodigoEmpresa and
		tbItemDocumento.CodigoLocal = @CodigoLocal and
		tbItemDocumento.EntradaSaidaDocumento = 'S' and
		tbItemDocumento.TipoRegistroItemDocto = 'VEC' and
		tbNaturezaOperacao.CodigoTipoOperacao = 4 and
		(
			(
				tbNegociacaoCV.ClienteLeasing is null and (tbNegociacaoCV.ClienteFaturado = @DoCliente)
			)
			or
			(
				(tbNegociacaoCV.ClienteLeasing = @DoCliente)
			)
		)
	GROUP BY
		tbItemDocumento.CodigoEmpresa, 
		tbItemDocumento.CodigoLocal,
		tbItemDocumento.CodigoCliFor,
		tbItemDocumento.NumeroDocumento,
		tbNegociacaoCV.ClienteLeasing,
		tbNegociacaoCV.ClienteFaturado,
		tbFrotaCliente.SegmentoFrotaCliente

	---- Novos
	UPDATE rtFichaVisita
	SET QuantVendNovosLeves = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID  
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'LEVES'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompNovosLeves = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
				  			rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'LEVES'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendNovosMedios = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'MEDIOS'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompNovosMedios = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
				  			rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'MEDIOS'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendNovosSemiPesados = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'SEMI-PESADOS'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompNovosSemiPesados = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
					  		rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'SEMI-PESADOS'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendNovosPesados = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'PESADOS'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompNovosPesados = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
					  		rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'PESADOS'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendNovosExtraPesados = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'EXTRA-PESADOS'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompNovosExtPes = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
					  		rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'EXTRA-PESADOS'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)

	--- Semi-Novos
	UPDATE rtFichaVisita
	SET QuantVendSemiNovosLeves = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID  
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'LEVES'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompSemiNovLeves = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
				  			rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'F'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'LEVES'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendSemiNovosMedios = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID  
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'MEDIOS'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompSemiNovMedios = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
				  			rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'F'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'MEDIOS'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)

	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendSemiNovosSemiPesados = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID  
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'SEMI-PESADOS'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompSemiNovSemiPes = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
				  			rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'F'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'SEMI-PESADOS'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)

	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendSemiNovosPesados = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID  
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'PESADOS'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompSemiNovPesados = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
				  			rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					     AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'F'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'PESADOS'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)
	WHERE
		rtFichaVisita.spID = @@spID 
	AND 	rtFichaVisita.TipoCliEfetivoPotencial = 'E'

	UPDATE rtFichaVisita
	SET QuantVendSemiNovosExtraPesados = COALESCE((SELECT sum(rtHistoricoVendas.QtdeVeiculosFrotaCliente) FROM rtHistoricoVendas
					   WHERE
				  		rtHistoricoVendas.spID = @@spID  
					   AND	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					   AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
--					   AND	rtHistoricoVendas.CodigoClienteST = rtFichaVisita.CodigoClienteST
					   AND	rtHistoricoVendas.VeiculoNovoCV = 'V'
					   AND	rtHistoricoVendas.SegmentoFrotaCliente = 'EXTRA-PESADOS'
					   AND	(
							(
								rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
							)
							or
							(
								rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
							)
						)),0),
	    DataUltCompSemiNovExtPes = COALESCE((SELECT max(rtHistoricoVendas.DataDocumento) FROM rtHistoricoVendas
					     WHERE
				  			rtHistoricoVendas.spID = @@spID
					     AND 	rtHistoricoVendas.CodigoEmpresa = @CodigoEmpresa
					     AND	rtHistoricoVendas.CodigoLocal = @CodigoLocal
					     AND	rtHistoricoVendas.VeiculoNovoCV = 'F'
					     AND	rtHistoricoVendas.SegmentoFrotaCliente = 'EXTRA-PESADOS'
					     AND	(
								(
									rtHistoricoVendas.ClienteLeasing is null and rtHistoricoVendas.ClienteFaturado = rtFichaVisita.CodigoClienteST
															
								)
								or
								(
									rtHistoricoVendas.ClienteLeasing = rtFichaVisita.CodigoClienteST
								)
							)),0)


	DELETE FROM rtHistoricoVendas
	WHERE spID = @@spID
	------------------------------  Fim - Historico Vendas --------------------------------

	END

SELECT 
	rtFichaVisita.CodigoEmpresa, rtFichaVisita.CodigoLocal, rtFichaVisita.TipoCliEfetivoPotencial, rtFichaVisita.ClienteTPCaminhoes, rtFichaVisita.ClienteTPOnibus, 
	rtFichaVisita.ClienteTPSprinter, rtFichaVisita.ClienteTPOutros, rtFichaVisita.RecEmailPropag, rtFichaVisita.TipoCliFor, rtFichaVisita.CodigoClienteST, 
	rtFichaVisita.DataCadastroTP, rtFichaVisita.CodigoRepresentante, rtFichaVisita.NomeRepresentante, rtFichaVisita.TamanhoFrota, rtFichaVisita.PropensaoCompra, 
	rtFichaVisita.DescrPropCompra, rtFichaVisita.RazaoSocialCliente, rtFichaVisita.CNPJ, rtFichaVisita.NomeFantasiaCliente, rtFichaVisita.InscrEstadual, rtFichaVisita.Rua, 
	rtFichaVisita.Numero, rtFichaVisita.Bairro, rtFichaVisita.Municipio, rtFichaVisita.UF, rtFichaVisita.CEP, rtFichaVisita.DDD, rtFichaVisita.Fone, rtFichaVisita.DDDFax, 
	rtFichaVisita.Fax, rtFichaVisita.DescricaoAtividade, rtFichaVisita.NomeContato1, rtFichaVisita.FuncaoContato1, rtFichaVisita.DataAniversarioContato1, rtFichaVisita.email1, 
	rtFichaVisita.DDDCelularContClienteTP1, rtFichaVisita.CelularContatoClienteTP1, rtFichaVisita.DDDFoneContatoClienteTP1, rtFichaVisita.FoneContatoClienteTP1, rtFichaVisita.DescrTimeFutebol1, 
	rtFichaVisita.DescrHobby1, rtFichaVisita.NomeContato2, rtFichaVisita.FuncaoContato2, rtFichaVisita.DataAniversarioContato2, rtFichaVisita.email2, rtFichaVisita.DDDCelularContClienteTP2, 
	rtFichaVisita.CelularContatoClienteTP2, rtFichaVisita.DDDFoneContatoClienteTP2, rtFichaVisita.FoneContatoClienteTP2, rtFichaVisita.DescrTimeFutebol2, rtFichaVisita.DescrHobby2, rtFichaVisita.DataResultadoVisita1, 
	rtFichaVisita.ContatoVisita1, rtFichaVisita.ComentarioVisita1, rtFichaVisita.PendenciaProxVisita1, rtFichaVisita.PropCompraResultado1, rtFichaVisita.DataResultadoVisita2, rtFichaVisita.ContatoVisita2, 
	rtFichaVisita.ComentarioVisita2, rtFichaVisita.PropCompraResultado2, rtFichaVisita.DataResultadoVisita3, rtFichaVisita.ContatoVisita3, rtFichaVisita.ComentarioVisita3, rtFichaVisita.PropCompraResultado3, 
	rtFichaVisita.QtdeTotalLeves, rtFichaVisita.QtdeTotalMedios, rtFichaVisita.QtdeTotalSemiPesados, rtFichaVisita.QtdeTotalPesados, rtFichaVisita.QtdeTotalExtraPesados, rtFichaVisita.QtdeTotalFrota, 
	rtFichaVisita.QtdeMBLeves, rtFichaVisita.QtdeMBMedios, rtFichaVisita.QtdeMBSemiPesados, rtFichaVisita.QtdeMBPesados, rtFichaVisita.QtdeMBExtraPesados, rtFichaVisita.QtdeFrotaMB, rtFichaVisita.QtdeOutrosLeves, 
	rtFichaVisita.QtdeOutrosMedios, rtFichaVisita.QtdeOutrosSemiPesados, rtFichaVisita.QtdeOutrosPesados, rtFichaVisita.QtdeOutrosExtraPesados, rtFichaVisita.QtdeFrotaOutros, rtFichaVisita.IdadeMediaLeves, 
	rtFichaVisita.IdadeMediaMedios, rtFichaVisita.IdadeMediaSemiPesados, rtFichaVisita.IdadeMediaPesados, rtFichaVisita.IdadeMediaExtraPesados, rtFichaVisita.IdadeMediaTotal, rtFichaVisita.SeguroMBTotal, 
	rtFichaVisita.SeguroMBTerceiros, rtFichaVisita.SeguroMBOutros, rtFichaVisita.SeguroTotal, rtFichaVisita.SeguroTerceiros, rtFichaVisita.SeguroOutros, rtFichaVisita.QuantVeicSegurados, rtFichaVisita.PossuiOficinaPropria, 
	rtFichaVisita.PossuiEstoquePecProprio, rtFichaVisita.PossuiContrManut, rtFichaVisita.PossuiContrManutMB, rtFichaVisita.PossuiContrManutOutros, rtFichaVisita.PossuiGarantEstend, rtFichaVisita.PossuiGarantEstendMB, 
	rtFichaVisita.PossuiGarantEstendOutros, rtFichaVisita.FazRevisoes, rtFichaVisita.FormaPagtoVista, rtFichaVisita.FormaPagtoLeasing, rtFichaVisita.FormaPagtoCDC, rtFichaVisita.FormaPagtoFiname, 
	rtFichaVisita.FormaPagtoConsorcio, rtFichaVisita.AprovCredito, rtFichaVisita.BancoMB, rtFichaVisita.BancoOutros, rtFichaVisita.NaoPossuiCredito, rtFichaVisita.QuantVendPerdLeves, rtFichaVisita.QuantVendPerdMedios, 
	rtFichaVisita.QuantVendPerdSemiPesados, rtFichaVisita.QuantVendPerdPesados, rtFichaVisita.QuantVendPerdExtraPesados, rtFichaVisita.QuantVendNovosLeves, rtFichaVisita.QuantVendNovosMedios, rtFichaVisita.QuantVendNovosSemiPesados, 
	rtFichaVisita.QuantVendNovosPesados, rtFichaVisita.QuantVendNovosExtraPesados, rtFichaVisita.QuantVendSemiNovosLeves, rtFichaVisita.QuantVendSemiNovosMedios, rtFichaVisita.QuantVendSemiNovosSemiPesados, 
	rtFichaVisita.QuantVendSemiNovosPesados, rtFichaVisita.QuantVendSemiNovosExtraPesados, rtFichaVisita.DataUltCompNovosLeves, rtFichaVisita.DataUltCompNovosMedios, rtFichaVisita.DataUltCompNovosSemiPesados, 
	rtFichaVisita.DataUltCompNovosPesados, rtFichaVisita.DataUltCompNovosExtPes, rtFichaVisita.DataUltCompSemiNovLeves, rtFichaVisita.DataUltCompSemiNovMedios, rtFichaVisita.DataUltCompSemiNovSemiPes, rtFichaVisita.DataUltCompSemiNovPesados, 
	rtFichaVisita.DataUltCompSemiNovExtPes, rtFichaVisita.TipoClienteFrota, rtFichaVisita.VendaPerdida, rtFichaVisita.ApresentConc, rtFichaVisita.ApresentNovoProd, rtFichaVisita.EntendSatisfProdServ, 
	rtFichaVisita.DespIntCompra, rtFichaVisita.AtualizarInfFichaFrota, rtFichaVisita.ConvidarEvento, rtFichaVisita.ObjetivoOutros, rtFichaVisita.AbordagemVisita, rtFichaVisita.Categoria, rtFichaVisita.Segmento,
	tbResultadoVisitaST.DataResultadoVisita, tbResultadoVisitaST.ContatoVisita, tbResultadoVisitaST.ComentarioVisita,
	tbResultadoVisitaST.TipoContatoVisita, tbResultadoVisitaST.PendenciaProxVisita, tbClienteStarTruck.OutrasInformacoes, rtFichaVisita.FollowUp,
	PeriodoInicialVisita,PeriodoFinalVisita, VisitaConfirmada, '' CodigoContatoCliente1, '' CodigoContatoCliente2
FROM 		
	rtFichaVisita

INNER JOIN tbClienteStarTruck (NOLOCK)
ON	tbClienteStarTruck.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
AND	tbClienteStarTruck.CodigoLocal = rtFichaVisita.CodigoLocal
AND	tbClienteStarTruck.CodigoClienteST = rtFichaVisita.CodigoClienteST
AND	tbClienteStarTruck.TipoCliEfetivoPotencial = rtFichaVisita.TipoCliEfetivoPotencial

LEFT JOIN tbResultadoVisitaST (NOLOCK)
ON	tbResultadoVisitaST.CodigoEmpresa = rtFichaVisita.CodigoEmpresa
AND	tbResultadoVisitaST.CodigoLocal = rtFichaVisita.CodigoLocal
AND	tbResultadoVisitaST.CodigoClienteST = rtFichaVisita.CodigoClienteST
AND	tbResultadoVisitaST.TipoCliEfetivoPotencial = rtFichaVisita.TipoCliEfetivoPotencial
AND	tbResultadoVisitaST.CodigoRepresentante = rtFichaVisita.CodigoRepresentante
AND	tbResultadoVisitaST.Categoria = rtFichaVisita.Categoria
AND	tbResultadoVisitaST.Segmento = rtFichaVisita.Segmento
AND	(tbResultadoVisitaST.DataResultadoVisita BETWEEN @DaData AND @AteData)

WHERE 
	rtFichaVisita.TipoClienteFrota BETWEEN @DoCliFrota AND @AteCliFrota
AND	rtFichaVisita.spID = @@spID	

AND	(
		(tbResultadoVisitaST.DataResultadoVisita BETWEEN @DaData AND @AteData)
	   OR
		(@ImprimirResultado = 'F')
	)

ORDER BY	
	rtFichaVisita.CodigoEmpresa,
	rtFichaVisita.CodigoLocal, 
	rtFichaVisita.CodigoRepresentante,
	rtFichaVisita.TipoCliEfetivoPotencial,
	rtFichaVisita.CodigoClienteST


DELETE FROM rtFichaVisita
WHERE spID = @@spID

SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whRelTPFVisitaAvulsa TO SQLUsers
GO
go

if exists(select 1 from sysobjects where id = object_id('whRelOSGarantiaVsOS'))
	DROP PROCEDURE dbo.whRelOSGarantiaVsOS
GO
                                                                                                                                                                                                                                                             
CREATE PROCEDURE dbo.whRelOSGarantiaVsOS

--INICIO_CABEC_PROC
-------------------------------------------------------------------------------------------------
-- EMPRESA......: T-Systems do Brasil.
-- PROJETO......: OS - Controle de Oficina 
-- AUTOR........: Narcizo
-- DATA.........: 18/08/2004
-- UTILIZADO EM : RelOSGarantiaVsOS
-- OBJETIVO.....: Seleciona os valores das sg's e das notas geradas pela os para comparacao dos valores
--		pagos.
-- Alterado ....: 01/12/2004 - Carlos JSC
--	        Inclusao de apuração do total de pecas e mão-de-obra com base em select
--	 	direto na ItemPedido.
-- Alterado ....: 31/07/2008 - Marcelo Nicolau
--	        Correção do calculo dos valor da TTR.
--
-- Alterado ....: 21/09/2009 - Daniel Lemes
--	        Retirada de dados duplicados na SG.
--
--whRelOSGarantiaVsOS 1608,0,'2000-01-01','2009-10-25',1562,1562,'2000-01-01','2009-10-25'
-- go
--whRelOSGarantiaVsOS 1160,0,'2000-01-01','2009-10-25',549,549,'2000-01-01','2009-10-25'
-------------------------------------------------------------------------------------------------                                                                                                                                                              
--FIM_CABEC_PROC	

@CodigoEmpresa	dtInteiro04,
@CodigoLocal	dtInteiro04,
@DataIni		datetime = null ,
@DataFim 		datetime =null ,
@SGDe			dtInteiro06 = 0,
@SGAte			dtInteiro06 = 999999,
@DataPagto		datetime = null,
@AteDataPagto	datetime = null

AS 

set nocount on

/* *************************************************************************************************** */ 
/* * Somar Valor das Pecas                                                                      * */ 
/* *************************************************************************************************** */ 

select 
	distinct 
	sg.CodigoEmpresa,
	sg.CodigoLocal,
	sg.FlagOROS,
	sg.NumeroOROS,
	sg.NumeroSolicitacaoGarantia,
	sg.DataPrevistaLiberacao,
	sg.DataStatusMainframe,

	SUM(coalesce(case 
				when isnumeric(pecasg.StatusPecaGarantia) = 1 then
					pecasg.ValorPecaGarantia
			end,0)) ValorPecaRecusado,

	SUM(coalesce(case
				when isnumeric(pecasg.StatusPecaGarantia) = 0 then
					pecasg.ValorPecaGarantia
			end,0)) ValorPecaAprovado


into #tmpPecasSG
from 
	tbSolicitacaoGarantia 		sg (nolock)

inner join
	tbPecaGarantia			pecasg (nolock)
on 
	sg.CodigoEmpresa		= pecasg.CodigoEmpresa 	and
	sg.CodigoLocal			= pecasg.CodigoLocal 	and 
	sg.NumeroSolicitacaoGarantia 	= pecasg.NumeroSolicitacaoGarantia 

where 
	sg.DataPrevistaLiberacao is not null 				and
	(sg.DataPrevistaLiberacao between @DataIni and @DataFim ) 	and 
	sg.CodigoEmpresa		= @CodigoEmpresa 		and 
	sg.CodigoLocal			= @CodigoLocal			and 
	(sg.NumeroSolicitacaoGarantia   between @SGDe and @SGAte )
	and (sg.DataPrevistaLiberacao between @DataPagto and @AteDataPagto)
	and pecasg.IdentificacaoRA = 'F'

GROUP BY
		sg.CodigoEmpresa,      
		sg.CodigoLocal,      
		sg.FlagOROS,      
		sg.NumeroOROS,
		sg.NumeroSolicitacaoGarantia,      
		sg.DataPrevistaLiberacao,
		sg.DataStatusMainframe
	

/* *************************************************************************************************** */ 
/*  Somar Valores de Mão de Obra                                                   * */ 
/* *************************************************************************************************** */ 

select distinct 
		sg.CodigoEmpresa,      
		sg.CodigoLocal,      
		sg.FlagOROS,      
		sg.NumeroOROS,      
		sg.NumeroSolicitacaoGarantia,      
		sg.DataPrevistaLiberacao,     
		sg.DataStatusMainframe,
		ValorMORecusado = (select sum(servsg.ValorTTR) from tbServicoGarantia       servsg (nolock)
							where sg.CodigoEmpresa        = servsg.CodigoEmpresa and
							sg.CodigoLocal               = servsg.CodigoLocal    and 
							sg.NumeroSolicitacaoGarantia = servsg.NumeroSolicitacaoGarantia
							and isnumeric(servsg.StatusTTR) > 0 ) ,


		ValorMOAprovado = (select sum(servsg.ValorTTR) from tbServicoGarantia       servsg (nolock)
							where sg.CodigoEmpresa        = servsg.CodigoEmpresa and
							sg.CodigoLocal               = servsg.CodigoLocal    and 
							sg.NumeroSolicitacaoGarantia = servsg.NumeroSolicitacaoGarantia
							and isnumeric(servsg.StatusTTR) = 0 ) 
into #tmpServicoSG

from tbSolicitacaoGarantia sg

where 
      sg.DataPrevistaLiberacao is not null                       and
      (sg.DataPrevistaLiberacao between @DataIni and @DataFim ) and 
      sg.CodigoEmpresa        = @CodigoEmpresa        and 
      sg.CodigoLocal               = @CodigoLocal               and 
      (sg.NumeroSolicitacaoGarantia   between @SGDe and @SGAte )
      and (sg.DataPrevistaLiberacao between @DataPagto and @AteDataPagto)

GROUP BY
		sg.CodigoEmpresa,      
		sg.CodigoLocal,      
		sg.FlagOROS,      
		sg.NumeroOROS,
		sg.NumeroSolicitacaoGarantia,      
		sg.DataPrevistaLiberacao,
		sg.DataStatusMainframe


/* *************************************************************************************************** */ 
/*  Incluir os dados das SGs						                                                 * */ 
/* *************************************************************************************************** */ 

select 
	distinct 
	sg.CodigoEmpresa,
	sg.CodigoLocal,
	sg.DataPrevistaLiberacao,
	pedido.NumeroNotaFiscalPed,
	sg.NumeroSolicitacaoGarantia,
	pedido.DataEmissaoNotaFiscalPed,
	pecasg.ValorPecaRecusado,
	pecasg.ValorPecaAprovado,
	servsg.ValorMOAprovado,
	servsg.ValorMORecusado,
	sg.ValorTotalLiberadoSG,
	sg.ValorTotalRecusadoSG,
	sg.DataStatusMainframe,
	sg.DataRecebimentoSG

into #tmpDadosSG

from tbSolicitacaoGarantia sg (nolock)
--
inner join
	tbOROSCITPedido 		orosped (nolock)
on 
	sg.CodigoEmpresa	= orosped.CodigoEmpresa 	and 
	sg.CodigoLocal 		= orosped.CodigoLocal 		and 				
	sg.FlagOROS			= orosped.FlagOROS 			and 
	sg.NumeroOROS 		= orosped.NumeroOROS 		

inner join 
	tbCIT 				cit (nolock)
on
	orosped.CodigoEmpresa 	= cit.CodigoEmpresa 		and 
	orosped.CodigoCIT 		= cit.CodigoCIT 
inner join
	tbPedido			pedido (nolock)
on
	sg.CodigoEmpresa		= pedido.CodigoEmpresa 		and 
	sg.CodigoLocal 			= pedido.CodigoLocal 		and
	orosped.CentroCusto  	= pedido.CentroCusto  		and
	orosped.NumeroPedido 	= pedido.NumeroPedido 		and
	orosped.SequenciaPedido = pedido.SequenciaPedido
inner join
	tbNaturezaOperacao		natoper	(nolock)
on	
	pedido.CodigoEmpresa 		= natoper.CodigoEmpresa	
and	pedido.CodigoNaturezaOperacao	= natoper.CodigoNaturezaOperacao 

inner join
	#tmpPecasSG		pecasg (nolock)
on 
	sg.CodigoEmpresa		= pecasg.CodigoEmpresa 	and
	sg.CodigoLocal			= pecasg.CodigoLocal 	and 
	sg.NumeroSolicitacaoGarantia 	= pecasg.NumeroSolicitacaoGarantia 

left join
	#tmpServicoSG		servsg (nolock)
on 
	servsg.CodigoEmpresa		= sg.CodigoEmpresa 	and
	servsg.CodigoLocal			= sg.CodigoLocal 	and 
	servsg.NumeroSolicitacaoGarantia 	= sg.NumeroSolicitacaoGarantia 

where 

	sg.DataPrevistaLiberacao is not null 				and
	(sg.DataPrevistaLiberacao between @DataIni and @DataFim ) 	and 
	sg.CodigoEmpresa		= @CodigoEmpresa 		and 
	sg.CodigoLocal			= @CodigoLocal			and 
	(sg.NumeroSolicitacaoGarantia   between @SGDe and @SGAte )
	and (sg.DataPrevistaLiberacao between @DataPagto and @AteDataPagto)
	AND cit.GarantiaCIT  = 'V'						and
	natoper.CodigoTipoOperacao = 3 



group by
	sg.CodigoEmpresa,
	sg.CodigoLocal,
	sg.DataPrevistaLiberacao,
	pedido.NumeroNotaFiscalPed,
	sg.NumeroSolicitacaoGarantia,
	pedido.DataEmissaoNotaFiscalPed,
	pecasg.ValorPecaRecusado,
	pecasg.ValorPecaAprovado,
	servsg.ValorMOAprovado,
	servsg.ValorMORecusado,
	sg.ValorTotalLiberadoSG,
	sg.ValorTotalRecusadoSG,
	sg.DataStatusMainframe,
	sg.DataRecebimentoSG


/* *************************************************************************************************** */ 
/* * selecao dos dados das Notas                                                                     * */ 
/* *************************************************************************************************** */ 


select 	distinct
	pedido.CodigoEmpresa	,
	pedido.CodigoLocal 	,
	pedido.CentroCusto 	,
	pedido.NumeroPedido 	,
	pedido.SequenciaPedido	,
	pedido.NumeroNotaFiscalPed,
	sg.NumeroSolicitacaoGarantia,
	sg.DataRecebimentoSG DataLiberacao,
	sg.DataStatusMainframe,
	ValorPecasPed = coalesce ((select sum(itpedido.PrecoTotalItemPed)
				   from tbItemPedido itpedido (nolock)
				   where itpedido.CodigoEmpresa		= pedido.CodigoEmpresa
				   and   itpedido.CodigoLocal 		= pedido.CodigoLocal
				   and   itpedido.CentroCusto  		= pedido.CentroCusto
				   and   itpedido.NumeroPedido 		= pedido.NumeroPedido
				   and   itpedido.SequenciaPedido	= pedido.SequenciaPedido
				   and   itpedido.TipoRegistroItemPed  = 'PEC'),0),

	ValorCLOPed = coalesce ((select sum(itpedido.PrecoTotalItemPed)
				   from tbItemPedido itpedido (nolock)
				   where itpedido.CodigoEmpresa		= pedido.CodigoEmpresa
				   and   itpedido.CodigoLocal 		= pedido.CodigoLocal
				   and   itpedido.CentroCusto  		= pedido.CentroCusto
				   and   itpedido.NumeroPedido 		= pedido.NumeroPedido
				   and   itpedido.SequenciaPedido	= pedido.SequenciaPedido
				   and   itpedido.TipoRegistroItemPed  = 'CLO'),0),

	ValorMOPed = coalesce ((select sum(itpedido.PrecoTotalItemPed)
				   from tbItemPedido itpedido (nolock)
				   where itpedido.CodigoEmpresa	 = pedido.CodigoEmpresa
				   and   itpedido.CodigoLocal 	 = pedido.CodigoLocal
				   and   itpedido.CentroCusto  	 = pedido.CentroCusto
				   and   itpedido.NumeroPedido 	 = pedido.NumeroPedido
				   and   itpedido.SequenciaPedido = pedido.SequenciaPedido
				   and   itpedido.TipoRegistroItemPed  = 'MOB'
				   and   itpedido.TipoMaoObraItemPed <> 5),0),

	ValorTERPed = coalesce ((select sum(itpedido.PrecoTotalItemPed)
				   from tbItemPedido itpedido (nolock)
				   where itpedido.CodigoEmpresa	 = pedido.CodigoEmpresa
				   and   itpedido.CodigoLocal 	 = pedido.CodigoLocal
				   and   itpedido.CentroCusto  	 = pedido.CentroCusto
				   and   itpedido.NumeroPedido 	 = pedido.NumeroPedido
				   and   itpedido.SequenciaPedido = pedido.SequenciaPedido
				   and   itpedido.TipoRegistroItemPed  = 'MOB'
				   and   itpedido.TipoMaoObraItemPed = 5),0)

into #tmpDadosNota

from tbSolicitacaoGarantia 		sg (nolock)

inner join
	tbPecaGarantia			pecasg (nolock)
on 
	sg.CodigoEmpresa		= pecasg.CodigoEmpresa 	and
	sg.CodigoLocal			= pecasg.CodigoLocal 	and 
	sg.NumeroSolicitacaoGarantia 	= pecasg.NumeroSolicitacaoGarantia 

LEFT join
	tbServicoGarantia		servsg (nolock)
on 
	sg.CodigoEmpresa		= servsg.CodigoEmpresa 	and
	sg.CodigoLocal			= servsg.CodigoLocal 	and 
	sg.NumeroSolicitacaoGarantia 	= servsg.NumeroSolicitacaoGarantia 

inner join
	tbOROSCITPedido 		orosped (nolock)
on 
	sg.CodigoEmpresa	= orosped.CodigoEmpresa 	and 
	sg.CodigoLocal 		= orosped.CodigoLocal 		and 				
	sg.FlagOROS			= orosped.FlagOROS 		and 
	sg.NumeroOROS 		= orosped.NumeroOROS			

inner join 
	tbCIT 				cit (nolock)
on
	orosped.CodigoEmpresa 	= cit.CodigoEmpresa 		and 
	orosped.CodigoCIT 		= cit.CodigoCIT 

inner join
	tbPedido			pedido (nolock)
on
	sg.CodigoEmpresa		= pedido.CodigoEmpresa 		and 
	sg.CodigoLocal 			= pedido.CodigoLocal 		and
	orosped.CentroCusto  	= pedido.CentroCusto  		and
	orosped.NumeroPedido 	= pedido.NumeroPedido 		and
	orosped.SequenciaPedido = pedido.SequenciaPedido

inner join 
	tbItemPedido			itpedido (nolock)
on
	pedido.CodigoEmpresa	= itpedido.CodigoEmpresa 	and 
	pedido.CodigoLocal 		= itpedido.CodigoLocal 		and
	pedido.CentroCusto  	= itpedido.CentroCusto  	and
	pedido.NumeroPedido 	= itpedido.NumeroPedido 	and
	pedido.SequenciaPedido	= itpedido.SequenciaPedido	

inner join
	tbNaturezaOperacao		natoper	(nolock)
on	
	pedido.CodigoEmpresa 			= natoper.CodigoEmpresa
and	pedido.CodigoNaturezaOperacao	= natoper.CodigoNaturezaOperacao

where 
	sg.DataPrevistaLiberacao is not null 				and
	(sg.DataPrevistaLiberacao between @DataIni and @DataFim ) 	and 
	sg.CodigoEmpresa		= @CodigoEmpresa 		and 
	sg.CodigoLocal			= @CodigoLocal			and 
	(sg.NumeroSolicitacaoGarantia   between @SGDe and @SGAte )
	and (sg.DataPrevistaLiberacao between @DataPagto and @AteDataPagto)
	AND cit.GarantiaCIT  = 'V'						and
	natoper.CodigoTipoOperacao = 3 

group by
	pedido.CodigoEmpresa	,
	pedido.CodigoLocal 	,
	pedido.CentroCusto  	,
	pedido.NumeroPedido 	,
	pedido.SequenciaPedido	,
	pedido.NumeroNotaFiscalPed,
	sg.NumeroSolicitacaoGarantia,
	sg.DataRecebimentoSG,
	sg.DataStatusMainframe,
	itpedido.TipoRegistroItemPed


/* *************************************************************************************************** */ 
/* * Calcula diferenças entre a nota fiscal e a SG                                                   * */ 
/* *************************************************************************************************** */ 

select 	
	sg.CodigoEmpresa ,
	sg.CodigoLocal,
	sg.NumeroSolicitacaoGarantia,
	nota.NumeroNotaFiscalPed,
	SUM(nota.ValorPecasPed) AS ValorPecasPed,              
	SUM(nota.ValorMOPed) AS ValorMOPed, 
	SUM(nota.ValorTERPed + nota.ValorCLOPed) ValrOutros,              
	SUM(nota.ValorPecasPed + nota.ValorMOPed + nota.ValorCLOPed + nota.ValorTERPed) ValorTotalPed ,
	SUM(sg.ValorPecaAprovado) AS ValorPecaAprovado,
	SUM(sg.ValorPecaRecusado) as ValorPecaRecusado,
	SUM(sg.ValorMOAprovado) as ValorMOAprovado,
	SUM(sg.ValorMORecusado) as ValorMORecusado,
	SUM(sg.ValorTotalRecusadoSG) as ValorTotalRecusadoSG,
	SUM(sg.ValorTotalLiberadoSG) as ValorTotalLiberadoSG,
	CONVERT (money,0) as  ValorPecaMaiorAprovado,
	CONVERT (money,0)  as  ValorPecaMaiorRecusado,
	CONVERT(money,0)  as  ValorPecaMenorAprovado,
	CONVERT(money,0)  as  ValorPecaMenorRecusado,
	CONVERT(money,0)  as  ValorMOMaiorAprovado,
	CONVERT(money,0)  as  ValorMOMenorAprovado,
	CONVERT(money,0)  as  ValorMOMaiorRecusado,
	CONVERT(money,0)  as  ValorMOMenorRecusado

into #tmpValoresMaiorMenor

from  
	#tmpDadosSG  sg ,
	#tmpDadosNota nota 




where 

		sg.CodigoEmpresa = nota.CodigoEmpresa and
		sg.CodigoLocal	 = nota.CodigoLocal   and 
		sg.NumeroNotaFiscalPed = nota.NumeroNotaFiscalPed and 
		sg.DataRecebimentoSG = nota.DataLiberacao 


GROUP BY
	sg.CodigoEmpresa ,
	sg.CodigoLocal,
	sg.NumeroSolicitacaoGarantia,
	sg.NumeroNotaFiscalPed,
	nota.NumeroNotaFiscalPed




ORDER BY sg.NumeroNotaFiscalPed,
	sg.NumeroSolicitacaoGarantia 




UPDATE #tmpValoresMaiorMenor SET 


ValorPecaMaiorAprovado = (case 
							when ValorPecaAprovado > ValorPecasPed then 
								ValorPecaAprovado - ValorPecasPed
						  else 
								0
						  end) ,

ValorPecaMenorAprovado = (case 
						  when ValorPecaAprovado < ValorPecasPed and ValorPecaAprovado > 0 then 
								ValorPecasPed - ValorPecaAprovado
						  else 
								0
						  end)  ,

ValorPecaMaiorRecusado = coalesce(case 
									when ValorPecaRecusado > ValorPecasPed then 
										 ValorPecaRecusado 
									else 0
									end,0) ,

ValorPecaMenorRecusado = coalesce(case 
									when ValorPecaRecusado < ValorPecasPed then 
										 ValorPecasPed - ValorPecaRecusado 
									else 0
									end,0),

ValorMOMaiorAprovado = (case 
							when ValorMOAprovado > ValorMOPed then 
								 ValorMOAprovado - ValorMOPed
							else 0
						end),

 ValorMOMenorAprovado = (case 
							when ValorMOAprovado < ValorMOPed and ValorMOAprovado > 0 then 
								 ValorMOPed - ValorMOAprovado 
							else 0
						 end),

ValorMOMaiorRecusado = coalesce(case 
									when ValorMORecusado > ValorMOPed then 
										 ValorMORecusado
									else 0
								END,0),

ValorMOMenorRecusado = coalesce(case 
									when ValorMORecusado < ValorMOPed then 
										 ValorMOPed - ValorMORecusado
									else 0
								end,0) 


/* *************************************************************************************************** */ 
/* * SELECT COM OS DADOS QUE IRAO PARA O RELATORIO                                                   * */ 
/* *************************************************************************************************** */

SELECT DISTINCT 
	sg.DataPrevistaLiberacao       ,
	nota.NumeroNotaFiscalPed ,
	sg.NumeroSolicitacaoGarantia ,                
	nota.DataLiberacao,	
	val.ValorPecasPed,
	val.ValorMOPed,
	val.ValrOutros,
	val.ValorTotalPed,
	(sg.ValorPecaAprovado) AS ValorPecaAprovado,
	(sg.ValorPecaRecusado) as ValorPecaRecusado,
	(sg.ValorMOAprovado) as ValorMOAprovado,
	(sg.ValorMORecusado) as ValorMORecusado,
	(sg.ValorTotalRecusadoSG) as ValorTotalRecusadoSG,
	(sg.ValorTotalLiberadoSG) as ValorTotalLiberadoSG,
	val.ValorPecaMaiorAprovado,
	val.ValorPecaMenorAprovado,
	val.ValorPecaMaiorRecusado,
	val.ValorPecaMenorRecusado,
	val.ValorMOMaiorAprovado,
	val.ValorMOMenorAprovado,
	val.ValorMOMaiorRecusado,
	val.ValorMOMenorRecusado,
	val.ValorMOMenorRecusado
-- 

FROM  #tmpDadosSG sg 

inner join #tmpDadosNota nota  (nolock)
on  nota.CodigoEmpresa = sg.CodigoEmpresa 
and nota.CodigoLocal = sg.CodigoLocal
and nota.NumeroSolicitacaoGarantia = sg.NumeroSolicitacaoGarantia
and nota.NumeroNotaFiscalPed = sg.NumeroNotaFiscalPed

inner join #tmpValoresMaiorMenor val (nolock)
on  val.CodigoEmpresa = sg.CodigoEmpresa 
and val.CodigoLocal = sg.CodigoLocal
and val.NumeroSolicitacaoGarantia = sg.NumeroSolicitacaoGarantia
and val.NumeroNotaFiscalPed = sg.NumeroNotaFiscalPed
	

order by nota.NumeroNotaFiscalPed,
	sg.NumeroSolicitacaoGarantia
	

drop table #tmpPecasSG
drop table #tmpServicoSG
drop table #tmpDadosSG
drop table #tmpDadosNota
drop table #tmpValoresMaiorMenor
set nocount off



GO
GRANT EXECUTE ON dbo.whRelOSGarantiaVsOS TO SQLUsers
GO 


go
if exists(select 1 from sysobjects where id = object_id('dbo.whLPedPendIntegracao'))
DROP PROCEDURE dbo.whLPedPendIntegracao
GO
CREATE PROCEDURE dbo.whLPedPendIntegracao

/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: CDC - Consulters/Humaita
 PROJETO......: Faturamento
 AUTOR........: Paulo Eduardo Trombetta
 DATA.........: 24/11/1998
 UTILIZADO EM : modIntegrarPedidoFaturamento.ListarPedidosPendentesIntegracao
 OBJETIVO.....: Listar os Pedidos que geraram Notas Fiscais e que estao pendentes
		na Integracao com outros Sistemas.

 ALTERACAO....: Marcio Schvartz - 19/01/1999
 OBJETIVO.....: Adicionado condicao de selecao 'ValorContabilPed > 0' na clausula where

 ALTERACAO....: Marcio Schvartz - 18/08/1999
 OBJETIVO.....: Comentado linhas finais da Stored que impediam a visualizacao total das 
		informacoes

 ALTERACAO....: Marcio Schvartz - 01/07/2003
 OBJETIVO.....: Acertos para contemplar CNO.CodigoTipoOperacao = 20 (Pedido Complementar) CAC 36037/2002
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/


@CodigoEmpresa 		dtInteiro04 = NULL,
@CodigoLocal    	dtInteiro04 = NULL,
@CentroCusto     	dtInteiro08 = NULL,
@PedidoInicial  	dtInteiro06 = NULL,
@PedidoFinal    	dtInteiro06 = NULL,
@SequenciaInicial      	dtInteiro02 = NULL,
@SequenciaFinal		dtInteiro02 = NULL

WITH ENCRYPTION
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


DECLARE	@DaEmpresa	dtInteiro04
DECLARE	@AteEmpresa	dtInteiro04
DECLARE @DoLocal	dtInteiro04
DECLARE	@AteLocal	dtInteiro04
DECLARE @DoCentroCusto	dtInteiro08
DECLARE @AteCentroCusto	dtInteiro08

-- Tratar @CodigoEmpresa
SET @DaEmpresa =	CASE	WHEN	@CodigoEmpresa IS NULL
				THEN	0
				ELSE	@CodigoEmpresa
			END
SET @AteEmpresa =	CASE	WHEN	@CodigoEmpresa IS NULL
				THEN	9999
				ELSE	@CodigoEmpresa
			END

-- Tratar @CodigoLocal
SET @DoLocal	=	CASE	WHEN	@CodigoLocal IS NULL
				THEN	0
				ELSE	@CodigoLocal
			END
SET @AteLocal	=	CASE	WHEN	@CodigoLocal IS NULL
				THEN	9999
				ELSE	@CodigoLocal
			END

-- Tratar @CentroCusto
SET @DoCentroCusto =	CASE	WHEN	@CentroCusto IS NULL
				THEN	0
				ELSE	@CentroCusto
			END
SET @AteCentroCusto =	CASE	WHEN	@CentroCusto IS NULL
				THEN	99999999
				ELSE	@CentroCusto
			END


IF @PedidoInicial IS NULL
	SET @PedidoInicial = 0
IF @PedidoFinal IS NULL
	SET @PedidoFinal = 999999
IF @SequenciaInicial IS NULL
	SET @SequenciaInicial = 0
IF @SequenciaFinal IS NULL
	SET @SequenciaFinal = 99


SELECT 	PED.CodigoEmpresa,
	PED.CodigoLocal,
	PED.CentroCusto,
	PED.NumeroPedido,
	PED.SequenciaPedido,
	PED.DataPedidoPed,
	PED.ValorContabilPed,
	PED.AtualizadoEstoquePed	AS CE,
	PED.AtualizadoLivroFiscalPed	AS LF,
	PED.AtualizadoContasReceberPed	AS CR,
	PED.AtualizadoContasPagarPed	AS CP,
	PED.AtualizadoComissoesPed	AS CO,
	PED.AtualizadoEstatisticaPed	AS ES,
	PED.AtualizadoContabilidadePed	AS CG,
	PED.AtualizadoFaturamentoPed	AS FT , 
	PED.NumeroNotaFiscalPed,
	PED.Recapagem

FROM 	tbPedido PED

INNER JOIN tbNaturezaOperacao CNO
ON	CNO.CodigoEmpresa		= PED.CodigoEmpresa
AND	CNO.CodigoNaturezaOperacao	= PED.CodigoNaturezaOperacao

WHERE	PED.StatusPedidoPed		= 4 
AND	(	((PED.ValorContabilPed > 0 and CNO.CodigoTipoOperacao <> 20) OR (PED.ValorContabilPed = 0 AND CNO.CodigoTipoOperacao = 20))
	OR	((PED.ValorContabilPed > 0 and CNO.CodigoTipoOperacao <> 21) OR (PED.ValorContabilPed = 0 AND CNO.CodigoTipoOperacao = 21))
	OR	((PED.ValorContabilPed > 0 and CNO.CodigoTipoOperacao <> 23) OR (PED.ValorContabilPed = 0 AND CNO.CodigoTipoOperacao = 23))
	)
AND	PED.CodigoEmpresa 	BETWEEN @DaEmpresa		AND	@AteEmpresa
AND	PED.CodigoLocal 	BETWEEN	@DoLocal		AND	@AteLocal
AND	PED.CentroCusto 	BETWEEN @DoCentroCusto		AND	@AteCentroCusto
AND	PED.NumeroPedido 	BETWEEN	@PedidoInicial		AND	@PedidoFinal
AND	PED.SequenciaPedido 	BETWEEN	@SequenciaInicial	AND	@SequenciaFinal

UNION ALL

SELECT	*
FROM	vwDocumentosPendentes
WHERE	CodigoEmpresa	BETWEEN @DaEmpresa	AND	@AteEmpresa
AND	CodigoLocal 	BETWEEN	@DoLocal	AND	@AteLocal



SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whLPedPendIntegracao TO SQLUsers
GO

go
if exists(select 1 from sysobjects where id = object_id('dbo.whPreItemDocumentoNFe'))
DROP PROCEDURE dbo.whPreItemDocumentoNFe
GO
CREATE PROCEDURE dbo.whPreItemDocumentoNFe
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil 
 PROJETO......: NFe
 AUTOR........: Edvaldo Ragassi
 DATA.........: 31/03/2009
 UTILIZADO EM : modDocumentoNFe.PesquisarDocumento
 OBJETIVO.....: Carregar rSet com dados necessario para geração do arquivo texto da NFe.
 
 ALTERACAO....:	
 OBJETIVO.....:	
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa			NUMERIC(4),
@CodigoLocal			NUMERIC(4),
@EntradaSaida			CHAR(1),
@NumeroDocumento		NUMERIC(6),
@DataDocumento			DATETIME,
@CodigoCliFor			NUMERIC(14),
@TipoLancamentoMovimentacao	NUMERIC(2)

WITH ENCRYPTION
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


IF @TipoLancamentoMovimentacao = 13
BEGIN
	SELECT	idoc.SequenciaItemDocumento,
		idoc.CodigoItemDocto,
		idoc.CodigoNaturezaOperacao,
		idoc.CodigoProduto,
		idoc.CodigoServicoISSItemDocto,
		idoc.CodigoMaoObraOS,
		idoc.TipoRegistroItemDocto,
		idoc.QtdeLancamentoItemDocto,
		idoc.ValorDescontoItemDocto,
		idoc.ValorBaseICMS1ItemDocto,
		idoc.PercentualICMSItemDocto,
		idoc.ValorICMSItemDocto,
		idoc.BaseICMSSubstTribItemDocto,
		idoc.PercICMSSubsTributItemDocto,
		idoc.ValorICMSSubstTribItemDocto,
		idoc.ValorPISItemDocto,
		idoc.ValorBasePISItemDocto,
		idoc.ValorPISSTItemDocto,
		idoc.BasePISSTItemDocto,
		idoc.PercPISSTItemDocto,
		idoc.ValorBaseISSItemDocto,
		idoc.PercentualISSItemDocto,
		idoc.ValorISSItemDocto,
		idoc.CodigoCFO					AS 'CodigoCFOItemDoc', 
		idoc.CodigoClassificacaoFiscal			AS 'CodigoClassificacaoFiscalProd', 
		idoc.CodigoClassificacaoFiscal			AS 'CodigoClassificacaoFiscalVEC', 
		idoc.PercPISItemDocto				AS PercPIS,
		CAST(nop.PercReducaoICMSNaturezaOper AS MONEY)	AS PercReducaoICMSNaturezaOper,
		nop.CodigoServicoNaturezaOperacao,
		nop.CodigoTipoOperacao,
		idoctx.TextoItemDocumentoFT,
		idocft.UnidadeItDocFT,
		idocft.PrecoUnitarioItDocFT,
		idocft.PrecoLiquidoUnitarioItDocFT,
		idocft.CodigoTributacaoItDocFT,
		idocft.PercCofinsItDocFT			AS PercCOFINS,
		idocft.BaseCOFINSItDocFT,
		idocft.ValorCOFINSItDocFT,
		idocft.PercCofinsSTItDocFT,
		idocft.BaseCofinsSTItDocFT,
		idocft.ValorCofinsSTItDocFT,
		idocft.ImpostoImportacaoItDocFT,
		idocft.BaseICMSSTUltEntradaItDocFT		AS BaseICMSSTUltimaEntrada,
		idocft.ValorICMSSTUltEntradaItDocFT		AS ICMSSTUltimaEntrada,
		vcv.NumeroMotorVeiculo,
		vcv.VeiculoNovoCV,
		vcv.NumeroChassisCV,
		vcv.CodigoCorExternaVeiculoCV,
		vcv.NumeroRenavam,
		vcv.AnoModeloVeiculoCV,
		vcv.AnoFabricacaoVeic,
		mvcv.Potencia,
		mvcv.NumeroCilindros				AS cilin,
		mvcv.PesoLiquidoModelo,
		mvcv.Serie					AS nSerie,
		mvcv.CMT,
		mvcv.EntreEixos					AS dist,
		mvcv.CodigoMarcaModelo				AS cMod,
		mvcv.CodEspecieRenavam,
		tComb.CodCombustivelRenavam,
		CatVeicOS.CodTipoVeicRenavam,
		corveic.DescricaoCorVeic,
		condVeic = '1',
		VIN = 'N',
		prod.DescricaoProduto,
		CASE	WHEN	idoc.ValorICMSSubstTribItemDocto = 0
			THEN	0
			ELSE	CAST((((idoc.BaseICMSSubstTribItemDocto / idoc.ValorBaseICMS1ItemDocto) - 1) * 100) AS NUMERIC(6,2))
		END	AS 'MVA',
		CASE	WHEN	idoc.ValorBaseIPI1ItemDocto != 0
			THEN	idoc.ValorBaseIPI1ItemDocto
			ELSE	0
		END	AS 'VBCIPI',
		CASE	WHEN	(idoc.ValorBaseIPI1ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'E')
			THEN	'00'
			WHEN	(idoc.ValorBaseIPI1ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
			THEN	'50'
			WHEN	(idoc.ValorBaseIPI2ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
			THEN	'52'
			WHEN	(idoc.ValorBaseIPI3ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
			THEN	'53'
			WHEN	(nop.CondicaoIPINaturezaOperacao = 2 AND idoc.EntradaSaidaDocumento = 'S')
			THEN	'52'
			WHEN	(nop.CondicaoIPINaturezaOperacao = 3 AND idoc.EntradaSaidaDocumento = 'S')
			THEN	'53'
			ELSE	'53'
		END	AS 'CSTIPI',
		infAdProd = ''
	FROM	NFItemDocumento		idoc 
	INNER JOIN NFItemDocumentoFT	idocft 
	ON	idoc.CodigoEmpresa		= idocft.CodigoEmpresa
	AND	idoc.CodigoLocal		= idocft.CodigoLocal
	AND	idoc.EntradaSaidaDocumento	= idocft.EntradaSaidaDocumento
	AND	idoc.NumeroDocumento		= idocft.NumeroDocumento
	AND	idoc.DataDocumento		= idocft.DataDocumento
	AND	idoc.CodigoCliFor		= idocft.CodigoCliFor
	AND	idoc.TipoLancamentoMovimentacao	= idocft.TipoLancamentoMovimentacao
	AND	idoc.SequenciaItemDocumento	= idocft.SequenciaItemDocumento 
	INNER JOIN NFItemDocumentoTextos	idoctx
	ON	idoc.CodigoEmpresa		= idoctx.CodigoEmpresa
	AND	idoc.CodigoLocal		= idoctx.CodigoLocal
	AND	idoc.EntradaSaidaDocumento	= idoctx.EntradaSaidaDocumento
	AND	idoc.NumeroDocumento		= idoctx.NumeroDocumento
	AND	idoc.DataDocumento		= idoctx.DataDocumento
	AND	idoc.CodigoCliFor		= idoctx.CodigoCliFor
	AND	idoc.TipoLancamentoMovimentacao	= idoctx.TipoLancamentoMovimentacao
	AND	idoc.SequenciaItemDocumento	= idoctx.SequenciaItemDocumento 
	LEFT JOIN tbProduto prod 
	ON	prod.CodigoEmpresa		= idoc.CodigoEmpresa
	AND	prod.CodigoProduto		= idoc.CodigoProduto
	LEFT JOIN tbProdutoFT prodFT 
	ON	prod.CodigoEmpresa		= prodFT.CodigoEmpresa
	AND	prod.CodigoProduto		= prodFT.CodigoProduto
	LEFT JOIN tbVeiculoCV vcv 
	ON	vcv.CodigoEmpresa		= idoc.CodigoEmpresa 
	AND	vcv.CodigoLocal			= idoc.CodigoLocal 
	AND	vcv.NumeroVeiculoCV		= idoc.NumeroVeiculoCV 
	LEFT JOIN tbModeloVeiculoCV mvcv 
	ON	mvcv.CodigoEmpresa		= vcv.CodigoEmpresa
	AND	mvcv.ModeloVeiculo		= vcv.ModeloVeiculo
	LEFT JOIN tbTipoCombustivel tComb 
	ON	tComb.CodigoCombustivel		= mvcv.CodigoCombustivel 
	LEFT JOIN tbCategoriaVeiculoOS CatVeicOS 
	ON	mvcv.CodigoEmpresa		= CatVeicOS.CodigoEmpresa
	AND	mvcv.CodigoCategoriaVeiculoOS	= CatVeicOS.CodigoCategoriaVeiculoOS
	LEFT JOIN tbCoresVeiculos corveic 
	ON	corveic.CodigoEmpresa		= vcv.CodigoEmpresa 
	AND	corveic.AplicacaoCor		= 'E' 
	AND	corveic.CodigoCorVeic		= vcv.CodigoCorExternaVeiculoCV 
	LEFT JOIN tbMaoObraOS mos 
	ON	mos.CodigoEmpresa		= idoc.CodigoEmpresa 
	AND	mos.CodigoMaoObraOS		= idoc.CodigoMaoObraOS 
	INNER JOIN tbNaturezaOperacao nop 
	ON	nop.CodigoEmpresa		= idoc.CodigoEmpresa 
	AND	nop.CodigoNaturezaOperacao	= idoc.CodigoNaturezaOperacao 
	WHERE	idoc.CodigoEmpresa		= @CodigoEmpresa
	AND	idoc.CodigoLocal		= @CodigoLocal
	AND	idoc.EntradaSaidaDocumento	= @EntradaSaida
	AND	idoc.NumeroDocumento		= @NumeroDocumento
	AND	idoc.DataDocumento		= @DataDocumento
	AND	idoc.CodigoCliFor		= @CodigoCliFor
	AND	idoc.TipoLancamentoMovimentacao	= @TipoLancamentoMovimentacao
END

IF @TipoLancamentoMovimentacao = 7
BEGIN
	SELECT	idoc.SequenciaItemDocumento,
		idoc.CodigoItemDocto,
		idoc.CodigoNaturezaOperacao,
		idoc.CodigoProduto,
		idoc.CodigoServicoISSItemDocto,
		idoc.CodigoMaoObraOS,
		idoc.TipoRegistroItemDocto,
		idoc.QtdeLancamentoItemDocto,
		idoc.ValorDescontoItemDocto,
		idoc.ValorBaseICMS1ItemDocto,
		idoc.PercentualICMSItemDocto,
		idoc.ValorICMSItemDocto,
		idoc.BaseICMSSubstTribItemDocto,
		idoc.PercICMSSubsTributItemDocto,
		idoc.ValorICMSSubstTribItemDocto,
		idoc.ValorPISItemDocto,
		idoc.ValorBasePISItemDocto,
		idoc.ValorPISSTItemDocto,
		idoc.BasePISSTItemDocto,
		idoc.PercPISSTItemDocto,
		idoc.ValorBaseISSItemDocto,
		idoc.PercentualISSItemDocto,
		idoc.ValorISSItemDocto,
		idoc.CodigoCFO					AS 'CodigoCFOItemDoc', 
		idoc.CodigoClassificacaoFiscal			AS 'CodigoClassificacaoFiscalProd', 
		idoc.CodigoClassificacaoFiscal			AS 'CodigoClassificacaoFiscalVEC', 
		idoc.PercPISItemDocto				AS PercPIS,
		CAST(nop.PercReducaoICMSNaturezaOper AS MONEY)	AS PercReducaoICMSNaturezaOper,
		nop.CodigoServicoNaturezaOperacao,
		nop.CodigoTipoOperacao,
		idoctx.TextoItemDocumentoFT,
		idocft.UnidadeItDocFT,
		idocft.PrecoUnitarioItDocFT,
		idocft.PrecoLiquidoUnitarioItDocFT,
		idocft.CodigoTributacaoItDocFT,
		idocft.PercCofinsItDocFT			AS PercCOFINS,
		idocft.BaseCOFINSItDocFT,
		idocft.ValorCOFINSItDocFT,
		idocft.PercCofinsSTItDocFT,
		idocft.BaseCofinsSTItDocFT,
		idocft.ValorCofinsSTItDocFT,
		idocft.ImpostoImportacaoItDocFT,
		idocft.BaseICMSSTUltEntradaItDocFT		AS BaseICMSSTUltimaEntrada,
		idocft.ValorICMSSTUltEntradaItDocFT		AS ICMSSTUltimaEntrada,
		vcv.NumeroMotorVeiculo,
		vcv.VeiculoNovoCV,
		vcv.NumeroChassisCV,
		vcv.CodigoCorExternaVeiculoCV,
		vcv.NumeroRenavam,
		vcv.AnoModeloVeiculoCV,
		vcv.AnoFabricacaoVeic,
		mvcv.Potencia,
		mvcv.NumeroCilindros				AS cilin,
		mvcv.PesoLiquidoModelo,
		mvcv.Serie					AS nSerie,
		mvcv.CMT,
		mvcv.EntreEixos					AS dist,
		mvcv.CodigoMarcaModelo				AS cMod,
		mvcv.CodEspecieRenavam,
		tComb.CodCombustivelRenavam,
		CatVeicOS.CodTipoVeicRenavam,
		corveic.DescricaoCorVeic,
		condVeic = '1',
		VIN = 'N',
		prod.DescricaoProduto,
		CASE	WHEN	idoc.ValorICMSSubstTribItemDocto = 0
			THEN	0
			ELSE	CAST((((idoc.BaseICMSSubstTribItemDocto / idoc.ValorBaseICMS1ItemDocto) - 1) * 100) AS NUMERIC(6,2))
		END	AS 'MVA',
		CASE	WHEN	idoc.ValorBaseIPI1ItemDocto != 0
			THEN	idoc.ValorBaseIPI1ItemDocto
			ELSE	0
		END	AS 'VBCIPI',
		CASE	WHEN	(idoc.ValorBaseIPI1ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'E')
			THEN	'00'
			WHEN	(idoc.ValorBaseIPI1ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
			THEN	'50'
			WHEN	(idoc.ValorBaseIPI2ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
			THEN	'52'
			WHEN	(idoc.ValorBaseIPI3ItemDocto != 0 AND idoc.EntradaSaidaDocumento = 'S')
			THEN	'53'
			WHEN	(nop.CondicaoIPINaturezaOperacao = 2 AND idoc.EntradaSaidaDocumento = 'S')
			THEN	'52'
			WHEN	(nop.CondicaoIPINaturezaOperacao = 3 AND idoc.EntradaSaidaDocumento = 'S')
			THEN	'53'
			ELSE	'53'
		END	AS 'CSTIPI',
		infAdProd = ''
	FROM	tbItemDocumento		idoc 
	INNER JOIN tbItemDocumentoFT	idocft 
	ON	idoc.CodigoEmpresa		= idocft.CodigoEmpresa
	AND	idoc.CodigoLocal		= idocft.CodigoLocal
	AND	idoc.EntradaSaidaDocumento	= idocft.EntradaSaidaDocumento
	AND	idoc.NumeroDocumento		= idocft.NumeroDocumento
	AND	idoc.DataDocumento		= idocft.DataDocumento
	AND	idoc.CodigoCliFor		= idocft.CodigoCliFor
	AND	idoc.TipoLancamentoMovimentacao	= idocft.TipoLancamentoMovimentacao
	AND	idoc.SequenciaItemDocumento	= idocft.SequenciaItemDocumento 
	INNER JOIN tbItemDocumentoTextos	idoctx
	ON	idoc.CodigoEmpresa		= idoctx.CodigoEmpresa
	AND	idoc.CodigoLocal		= idoctx.CodigoLocal
	AND	idoc.EntradaSaidaDocumento	= idoctx.EntradaSaidaDocumento
	AND	idoc.NumeroDocumento		= idoctx.NumeroDocumento
	AND	idoc.DataDocumento		= idoctx.DataDocumento
	AND	idoc.CodigoCliFor		= idoctx.CodigoCliFor
	AND	idoc.TipoLancamentoMovimentacao	= idoctx.TipoLancamentoMovimentacao
	AND	idoc.SequenciaItemDocumento	= idoctx.SequenciaItemDocumento 
	LEFT JOIN tbProduto prod 
	ON	prod.CodigoEmpresa		= idoc.CodigoEmpresa
	AND	prod.CodigoProduto		= idoc.CodigoProduto
	LEFT JOIN tbProdutoFT prodFT 
	ON	prod.CodigoEmpresa		= prodFT.CodigoEmpresa
	AND	prod.CodigoProduto		= prodFT.CodigoProduto
	LEFT JOIN tbVeiculoCV vcv 
	ON	vcv.CodigoEmpresa		= idoc.CodigoEmpresa 
	AND	vcv.CodigoLocal			= idoc.CodigoLocal 
	AND	vcv.NumeroVeiculoCV		= idoc.NumeroVeiculoCV 
	LEFT JOIN tbModeloVeiculoCV mvcv 
	ON	mvcv.CodigoEmpresa		= vcv.CodigoEmpresa
	AND	mvcv.ModeloVeiculo		= vcv.ModeloVeiculo
	LEFT JOIN tbTipoCombustivel tComb 
	ON	tComb.CodigoCombustivel		= mvcv.CodigoCombustivel 
	LEFT JOIN tbCategoriaVeiculoOS CatVeicOS 
	ON	mvcv.CodigoEmpresa		= CatVeicOS.CodigoEmpresa
	AND	mvcv.CodigoCategoriaVeiculoOS	= CatVeicOS.CodigoCategoriaVeiculoOS
	LEFT JOIN tbCoresVeiculos corveic 
	ON	corveic.CodigoEmpresa		= vcv.CodigoEmpresa 
	AND	corveic.AplicacaoCor		= 'E' 
	AND	corveic.CodigoCorVeic		= vcv.CodigoCorExternaVeiculoCV 
	LEFT JOIN tbMaoObraOS mos 
	ON	mos.CodigoEmpresa		= idoc.CodigoEmpresa 
	AND	mos.CodigoMaoObraOS		= idoc.CodigoMaoObraOS 
	INNER JOIN tbNaturezaOperacao nop 
	ON	nop.CodigoEmpresa		= idoc.CodigoEmpresa 
	AND	nop.CodigoNaturezaOperacao	= idoc.CodigoNaturezaOperacao 
	WHERE	idoc.CodigoEmpresa		= @CodigoEmpresa
	AND	idoc.CodigoLocal		= @CodigoLocal
	AND	idoc.EntradaSaidaDocumento	= @EntradaSaida
	AND	idoc.NumeroDocumento		= @NumeroDocumento
	AND	idoc.DataDocumento		= @DataDocumento
	AND	idoc.CodigoCliFor		= @CodigoCliFor
	AND	idoc.TipoLancamentoMovimentacao	= @TipoLancamentoMovimentacao
END


SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whPreItemDocumentoNFe TO SQLUsers
GO

go
if exists(select 1 from sysobjects where id = object_id('whDuplicataCTRCEntradaET'))
DROP PROCEDURE dbo.whDuplicataCTRCEntradaET
GO
CREATE PROCEDURE dbo.whDuplicataCTRCEntradaET 
--
-- Objetivo: Efetua a exclusao de todas Duplicatas de um CTRC.
-- 
-- Autor: Julio Cesar B. Duarte 
-- Data: (22/03/1998)
--
@CodigoEmpresa dtInteiro04
, @CodigoLocal dtInteiro04
, @CodigoCliForTransp numeric(14)
, @NumeroCTRC dtInteiro06

WITH ENCRYPTION
AS

SET NOCOUNT ON

	-- Remove todas as duplicatas de um determinado CTRC
	DELETE 	tbDuplicataCTRCEntrada
	WHERE 	CodigoEmpresa  		= @CodigoEmpresa AND
		CodigoLocal 		= @CodigoLocal AND
		CodigoCliForTransp 	= @CodigoCliForTransp AND
		NumeroCTRC 		= @NumeroCTRC

	-- Verifica a ocorrOncia de erros
	IF (@@ERROR <> 0)
		RETURN -1

	-- Execucao OK
	RETURN 0


SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whDuplicataCTRCEntradaET TO SQLUsers
GO

go
if exists(select 1 from sysobjects where id = object_id('whNotaCTRCEntradaET'))
DROP PROCEDURE dbo.whNotaCTRCEntradaET
GO
CREATE PROCEDURE dbo.whNotaCTRCEntradaET 
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: Controle de Estoque
 AUTOR........: 
 DATA.........: 
 UTILIZADO EM : clsCTRCEntrada.RatearCTRCEntrada
 OBJETIVO.....: 
 
 ALTERACAO....:	Edvaldo Ragassi - 25/09/2009
 OBJETIVO.....:	Antes de eliminar os dados da tabela, atualizar o numero do CTRC no documento
		de compra.
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa		dtInteiro04,
@CodigoLocal		dtInteiro04,
@CodigoCliForTransp	numeric(14),
@NumeroCTRC		dtInteiro06

WITH ENCRYPTION
AS

SET NOCOUNT ON

UPDATE	tbDocumento
SET	NumeroCTRC		= ctrc.NumeroCTRC,
	DataEmissaoCTRC		= ctrc.DataEntradaCTRC
FROM	tbNotaCTRCEntrada nctrc (NOLOCK)
INNER JOIN tbCTRCEntrada ctrc	(NOLOCK)
ON	ctrc.CodigoEmpresa	= nctrc.CodigoEmpresa
AND	ctrc.CodigoLocal	= nctrc.CodigoLocal
AND	ctrc.CodigoCliForTransp	= nctrc.CodigoCliForTransp
AND	ctrc.NumeroCTRC		= nctrc.NumeroCTRC
WHERE	tbDocumento.CodigoEmpresa		= nctrc.CodigoEmpresa
AND	tbDocumento.CodigoLocal			= nctrc.CodigoLocal
AND	tbDocumento.EntradaSaidaDocumento	= nctrc.EntradaSaidaDocumento
AND	tbDocumento.NumeroDocumento		= nctrc.NumeroDocumento
AND	tbDocumento.DataDocumento		= nctrc.DataDocumento
AND	tbDocumento.CodigoCliFor		= nctrc.CodigoCliFor
AND	tbDocumento.TipoLancamentoMovimentacao	= nctrc.TipoLancamentoMovimentacao
AND	nctrc.CodigoEmpresa			= @CodigoEmpresa
AND	nctrc.CodigoLocal			= @CodigoLocal
AND	nctrc.CodigoCliForTransp		= @CodigoCliForTransp
AND	nctrc.NumeroCTRC			= @NumeroCTRC


DELETE	tbNotaCTRCEntrada
WHERE	CodigoEmpresa		= @CodigoEmpresa
AND	CodigoLocal		= @CodigoLocal
AND	CodigoCliForTransp	= @CodigoCliForTransp
AND	NumeroCTRC		= @NumeroCTRC


SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whNotaCTRCEntradaET TO SQLUsers
GO

go
if exists(select 1 from sysobjects where id = object_id('dbo.whPreDuplicatasDoctoNFe'))
DROP PROCEDURE dbo.whPreDuplicatasDoctoNFe
GO
CREATE PROCEDURE dbo.whPreDuplicatasDoctoNFe
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil 
 PROJETO......: NFe
 AUTOR........: Alex Kmez
 DATA.........: 05/06/2009
 UTILIZADO EM : modDocumentoNFe.PesquisarDocumento
 OBJETIVO.....: Carregar rSet com dados necessario para geração do arquivo texto da NFe.
 
 ALTERACAO....:	
 OBJETIVO.....:	
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/
@CodigoEmpresa			NUMERIC(4),
@CodigoLocal			NUMERIC(4),
@EntradaSaida			CHAR(1),
@NumeroDocumento		NUMERIC(6),
@DataDocumento			DATETIME,
@CodigoCliFor			NUMERIC(14),
@TipoLancamentoMovimentacao	NUMERIC(2)

WITH ENCRYPTION
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF @TipoLancamentoMovimentacao = 13
BEGIN
	SELECT
		SequenciaDoctoRecPag		AS 'nDup', 
		DataVenctoDoctoRecPag		AS 'dVenc',
		ValorEmissaoDoctoRecPag		AS 'vDup'
	FROM
		NFDoctoRecPag
	WHERE
		CodigoEmpresa = @CodigoEmpresa
	AND	CodigoLocal = @CodigoLocal
	AND	EntradaSaidaDocumento = @EntradaSaida
	AND	NumeroDocumento = @NumeroDocumento
	AND	DataDocumento = @DataDocumento
	AND	CodigoCliFor = @CodigoCliFor
	AND	TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao
END

IF @TipoLancamentoMovimentacao = 7
BEGIN
	SELECT
		SequenciaDoctoRecPag		AS 'nDup', 
		DataVenctoDoctoRecPag		AS 'dVenc',
		ValorEmissaoDoctoRecPag		AS 'vDup'
	FROM 
		tbDoctoRecPag
	WHERE
		CodigoEmpresa = @CodigoEmpresa
	AND	CodigoLocal = @CodigoLocal
	AND	EntradaSaidaDocumento = @EntradaSaida
	AND	NumeroDocumento = @NumeroDocumento
	AND	DataDocumento = @DataDocumento
	AND	CodigoCliFor = @CodigoCliFor
	AND	TipoLancamentoMovimentacao = @TipoLancamentoMovimentacao
END


SET NOCOUNT OFF

GO
GRANT EXECUTE ON dbo.whPreDuplicatasDoctoNFe TO SQLUsers
GO

go