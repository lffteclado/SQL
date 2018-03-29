
CREATE PROCEDURE dbo.whGerarTabelaPreco

 
/*INICIO_CABEC_PROC  
--------------------------------------------------------------------------------------------  
 EMPRESA......: CDC - Consulters/Humaita  
 PROJETO......: Controle de Estoque  
 AUTOR........: Julio Cesar Bertolazzo Duarte  
 DATA.........: 31/03/1998  
 UTILIZADO EM : clsProduto.GerarTabelaPreco  
 OBJETIVO.....: Modulo utilizado para efetuar a Leitura do Arquivo Texto de Precos   
  Originais Mercedes-Benz ou Toyota, e atualizar os precos dos produtos.  
  Para a execucao desta procedure e necessario a execucao da procedure  
  whCriaTabelaTabelaPreco.  
  
 ALTERACAO....: Edvaldo Ragassi - 23/11/2002  
 OBJETIVO.....: Correcao do Metodo de Atualizacao de Precos, permitindo que Pedidos, Orcamentos   
  e Ordens de Servicos sejam atualizados.  
  
 ALTERACAO....: Edvaldo Ragassi - 16/04/2003  
 OBJETIVO.....: Eliminacao das tabelas tbReajustePreco e tbProdutoCE.  
  
 ALTERACAO....: Edvaldo Ragassi - 19/08/2003  
 OBJETIVO.....: Separar Processo de Atualizacao de Itens Auxiliares Por Tipo de Registro.  
  
 ALTERACAO....: Edvaldo Ragassi - 19/09/2003  
 OBJETIVO.....: Redefinicao da tabela de Produtos Auxiliar  
  
 ALTERACAO....: Edvaldo Ragassi - 21/10/2003  
 OBJETIVO.....: Nao excluir tbProdutoAuxiliar  
  
 ALTERACAO....: Marcelo Bueno - 02/09/2005  
 OBJETIVO.....: Inclusão da Coluna DataUltimoReajusteAuxiliar (tbProdutoAuxiliar)  
  
 ALTERACAO....: Edson Marson - 17/12/2012  
 OBJETIVO.....: Inclusao do prefixo do codigo de produto.  
    Arquivos serão iguais para MBB e Chrysler.  
    Ticket 128838/2012 - FM 11285/2012  
  
 ALTERACAO....: Edson Marson - 27/02/2013  
 OBJETIVO.....: Inclusao do FLAG para atualizar Descrição do Produto.  
    Ticket 135954/2013 - FM 11556/2013  
      
 ALTERACAO....: Talita Pastore - 27/05/2013  
 OBJETIVO.....: Inclusão Parametro @NaoAtualizarClassifFiscal  
    Ticket 121751/2013 - FM 11911/2013     
  
 ALTERACAO....: Edson Marson - 02/12/2014  
 OBJETIVO.....: Inclusao de campos novos na tbProdutoAuxiliar.  
    Ticket 200442/2014 - FM 14059/2014  

EXECUTE whGerarTabelaPreco 
		@ArquivoTexto = 'TICKET-260693-SEQ-5-25341100PRDADCAM2.TXT',
		@Atualizar = 'V',
		@CodigoEmpresa = 1608,
		@CodigoLocal = 0,
		@CodigoFonteFornecInicial = 1,
		@CodigoFonteFornecFinal = 9999,
		@CodigoLinhaInicial = 1,
		@CodigoLinhaFinal = 9999,
		@CodigoTabelaPreco = 1,
		@CodigoTabelaPromocao = 2,
		@CodigoTabelaGarantia = 3,
		@DataSistema = '2017-11-01 09:51',
		@DataValidadePreco = '2017-06-02 00:00',
		@IndexadorPrecoReposicao = 1,
		@IndexadorPrecoVenda = 1.804243,@IndexadorPrecoPromocao = 1.804243,@IndexadorPrecoGarantia = 1.804243,@NomeUsuario = 'FI007',
		@NomeMaquina = 'CTS08397707',@Relatorio = 'F',@AtualizaProdutos = 'F',@LinhaProdutoPadrao = 0,@FonteFornecPadrao = 0,
		@CondicaoIPIPadrao = 0,@CondicaoICMSPadrao = 0,@CondicaoICMSRedPadrao = 0,@SituacaoTributariaPadrao = 0,@PercRedICMSPadrao = 0,
		@DataUltimoReajusteAuxiliar = '2017-06-02 00:00',@IndexadorPrecoImportado = 1.804243,@IndexadorPrecoImportadoGarantia = 1.804243,
		@IndexadorPrecoReposicaoImportado = 1,@AtualizarDescrProd = 'F',@NaoAtualizarClassifFiscal = 'F',@NaoAtualizarPrecoMenor = 'F'
  
--------------------------------------------------------------------------------------------  
FIM_CABEC_PROC*/  
  
@ArquivoTexto    varchar(255),  
@Atualizar    dtBooleano,  
@CodigoEmpresa    dtInteiro04,  
@CodigoLocal     dtInteiro04,  
@CodigoFonteFornecInicial  dtInteiro04,  
@CodigoFonteFornecFinal   dtInteiro04,  
@CodigoLinhaInicial   dtInteiro04,  
@CodigoLinhaFinal   dtInteiro04,  
@CodigoTabelaPreco   dtInteiro04,  
@CodigoTabelaPromocao   dtInteiro04,  
@CodigoTabelaGarantia   dtInteiro04,  
@DataSistema    datetime   = null,  
@DataValidadePreco   datetime,  
@IndexadorPrecoReposicao  numeric(9,8),  
@IndexadorPrecoVenda   numeric(9,8),  
@IndexadorPrecoPromocao   numeric(9,8),  
@IndexadorPrecoGarantia   numeric(9,8),  
@NomeUsuario    char(30)  = null,  
@NomeMaquina    char(30)  = null,  
@Relatorio     dtBooleano  = 'F',  
@AtualizaProdutos   dtBooleano   = 'F',  
@LinhaProdutoPadrao   dtInteiro04  = 0,  
@FonteFornecPadrao   dtInteiro04  = Null,  
@ClassifFiscalPadrao   char(10)   = '1',  
@CondicaoIPIPadrao   dtInteiro01  = 1,  
@CondicaoICMSPadrao   dtInteiro01  = 1,  
@CondicaoICMSRedPadrao   dtInteiro01  = Null,  
@SituacaoTributariaPadrao  numeric(5,0) = Null,  
@PercRedICMSPadrao   dtPercentual = 0,  
@CodigoUnidadePadrao   char(3)   = Null,  
@DataUltimoReajusteAuxiliar  datetime  = NULL,  
@PrefixoCodProduto   char(4)   = NULL,  
@IndexadorPrecoImportado  numeric(9,8),  
@IndexadorPrecoImportadoGarantia numeric(9,8),  
@IndexadorPrecoReposicaoImportado numeric(9,8),  
@AtualizarDescrProd   dtBooleano  = 'F',  
@NaoAtualizarClassifFiscal  dtBooleano,
@NaoAtualizarPrecoMenor dtBooleano = 'F'					-- Impedir atualização de preço para valor menor que o atual
  
--WITH ENCRYPTION  
  
AS  
  
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SET NOCOUNT ON  

-- Variaveis auxiliares  
DECLARE @auxStringBCP   varchar(255)  
DECLARE @auxUtilizaItemAuxiliar  dtBooleano  
DECLARE @auxPrecoAtual   dtValorMonetario  
DECLARE @auxPrecoPromocao  dtValorMonetario  
DECLARE @auxPrecoGarantia  dtValorMonetario  
DECLARE @auxPrecoReposicao  dtIndiceMonetario  
DECLARE @auxPrecoAntigo   dtIndiceMonetario  
DECLARE @auxValorMoeda   dtIndiceMonetario  
DECLARE @auxCasasDecimais  dtInteiro01  
DECLARE @auxDiretorio   varchar(255)  
DECLARE @auxDataValidadeTabela  datetime  
DECLARE @auxCodigoEditadoProduto dtCharacter30  
DECLARE @auxProcReturn   int  
DECLARE @auxError   int  
DECLARE @auxLinhasAfetadas  int  
DECLARE @auxDenominacaoProduto  varchar(60)  
DECLARE @auxCodigoFormatadoProduto dtCharacter30  
DECLARE @auxNumRegs   int  
DECLARE @auxCodigoMoeda   dtInteiro02  
DECLARE @auxErroMargemComercializacao varchar(255)  
DECLARE @auxErroImportacao  varchar(255)  
DECLARE @ObservacaoReajustePreco varchar(255)  
DECLARE @AbreviaturaReajustePreco varchar(255)  
DECLARE @DescricaoUnidadeProduto varchar(255)  
DECLARE @DescricaoUnidadeProdutoMBB varchar(255)  
DECLARE @CodigoDIPIUnidadeProduto varchar(30)  
DECLARE @UsaCasasDecimaisUnidadeProdut char(1)  
DECLARE @ChecaParametro   dtBooleano
--          1         2         3         4         5         6         7  
--01234567890123456789012345678901234567890123456789012345678901234567890123456789  
  
-- Gerais  
DECLARE @auxTipoRegistro    dtInteiro01   -- 22 a 22  
DECLARE @auxCodigoProduto    varchar(22)  -- 1 a 21  
DECLARE @curLinhaArquivo    varchar(255)  
  
-- Registro do tipo 1 (Precos)  
DECLARE @auxUnidadeQtdeProduto   varchar(2)   -- 23 a 24  
DECLARE @auxUnidadePrecoProduto   tinyint   -- 25 a 25  
DECLARE @auxFiller1      varchar(1)  -- 26 a 26  
DECLARE @auxPrecoProduto    float   -- 27 a 39  
DECLARE @auxCodMargemComercializacao char(4)   -- 40 a 43  
DECLARE @auxVCPrecoProduto    Float  
  
-- Registro do tipo 2 (Descricao do Produto)  
DECLARE @auxDescricaoProduto   varchar(50)  -- 23 a 72  
  
-- Registro do tipo 3 (Embalagem/Peso do Produto)  
DECLARE @auxOrigem      dtCharacter01 -- 23 a 23  
DECLARE @auxPeso      NUMERIC(12,4) -- 24 a 34  
DECLARE @auxFiller3      varchar(4)  -- 35 a 38  
DECLARE @auxEmbalagem     dtInteiro04  -- 39 a 42  
DECLARE @auxAliquotaIPI     NUMERIC(8,4)    -- 46 a 58  
DECLARE @auxCodigoNCM     NUMERIC(8)  -- 59 a 66  
DECLARE @auxPosicaoIPI     CHAR(10)  -- 59 a 68  
DECLARE @auxIncidePIS     varchar(1)      -- 69 a 69   
DECLARE @auxIncideCOFINS    varchar(1)  -- 70 a 70  
DECLARE @auxIncidePIS_Atual    varchar(1)      -- 69 a 69   
DECLARE @auxIncideCOFINS_Atual   varchar(1)  -- 70 a 70  

declare @collationName varchar(256)
declare @sqlSTMT nvarchar(4000)
--DECLARE @TipoRegistro1FT  TABLE  
-- (  
--  auxCodigoProduto  VarChar(30),  
--  auxUnidadeQtdeProduto  VarChar(2),  
--  auxUnidadePrecoProduto  TinyInt,  
--  auxPrecoProduto   Float,  
--  auxCodMargemComercializacao VarChar(4)  
-- )  

SELECT @ChecaParametro = 'F'

if exists (select 1 from tbParametro 
   inner join tbLocal loc on 
   loc.CodigoEmpresa = @CodigoEmpresa and 
   loc.CodigoLocal = @CodigoLocal 
   
   where CNPJ = loc.CGCLocal and Parametro like 'PRECOLOCAL%') 
   SELECT @ChecaParametro = 'V'
else 
   SELECT @ChecaParametro = 'F'
   
select @collationName = collation_name from sys.databases where database_id = db_id()

if OBJECT_ID('tempdb..#TEMPTipoRegistro1FT') is not null
	drop table #TEMPTipoRegistro1FT

create table #TEMPTipoRegistro1FT
 (  
  auxCodigoProduto  VarChar(30) collate SQL_Latin1_General_CP1_CS_AS not null,  
  auxUnidadeQtdeProduto  VarChar(2) collate SQL_Latin1_General_CP1_CS_AS,  
  auxUnidadePrecoProduto  TinyInt,  
  auxPrecoProduto   Float,  
  auxCodMargemComercializacao VarChar(4) collate SQL_Latin1_General_CP1_CS_AS,
  CONSTRAINT pkTEMPTipoRegistro1FT_ primary key (auxCodigoProduto)
 )  
 
 if(@collationName!='SQL_Latin1_General_CP1_CS_AS')
 BEGIN
	 set @sqlSTMT = 'ALTER table #TEMPTipoRegistro1FT drop constraint pkTEMPTipoRegistro1FT_; ALTER table #TEMPTipoRegistro1FT alter column auxCodigoProduto  VarChar(30) collate ' + @collationName + ' not null; ALTER table #TEMPTipoRegistro1FT add constraint
 pkTEMPTipoRegistro1FT_ primary key (auxCodigoProduto); ALTER TABLE #TEMPTipoRegistro1FT ALTER COLUMN auxUnidadeQtdeProduto  VarChar(2) collate ' + @collationName + '; ALTER TABLE #TEMPTipoRegistro1FT ALTER COLUMN  auxCodMargemComercializacao VarChar(4) c
ollate ' + @collationName + ';'
	 execute sp_executesql @sqlSTMT
 END

--create index IX_TEMPTipoRegistro1FT_001 on #TEMPTipoRegistro1FT (auxCodigoProduto,auxPrecoProduto) 
----include (auxPrecoProduto) 

--create index IX_TEMPTipoRegistro1FT_002 on #TEMPTipoRegistro1FT (auxCodigoProduto,auxPrecoProduto) 
----where auxPrecoProduto > 0

--create index IX_TEMPTipoRegistro1FT_003 on #TEMPTipoRegistro1FT (auxUnidadeQtdeProduto) 

--create index IX_TEMPTipoRegistro1FT_004 on #TEMPTipoRegistro1FT (auxUnidadePrecoProduto)

--create index IX_TEMPTipoRegistro1FT_005 on #TEMPTipoRegistro1FT (auxCodMargemComercializacao)
 
--DECLARE @TipoRegistro1Aux  TABLE  
-- (  
--  auxCodigoProduto  VarChar(30),  
--  auxUnidadeQtdeProduto  VarChar(2),  
--  auxUnidadePrecoProduto  TinyInt,  
--  auxPrecoProduto   Float,  
--  auxCodMargemComercializacao VarChar(4)  
-- )  

if OBJECT_ID('tempdb..#TEMPTipoRegistro1Aux') is not null
	drop table #TEMPTipoRegistro1Aux
  
CREATE TABLE #TEMPTipoRegistro1Aux  
 (  
  auxCodigoProduto  VarChar(30) collate SQL_Latin1_General_CP1_CS_AS not null,  
  auxUnidadeQtdeProduto  VarChar(2) collate SQL_Latin1_General_CP1_CS_AS,  
  auxUnidadePrecoProduto  TinyInt,  
  auxPrecoProduto   Float,  
  auxCodMargemComercializacao VarChar(4) collate SQL_Latin1_General_CP1_CS_AS
  constraint pkTEMPTipoRegistro1Aux_ primary key (auxCodigoProduto)
 )  

 if(@collationName!='SQL_Latin1_General_CP1_CS_AS')
 BEGIN
	 set @sqlSTMT = 'ALTER TABLE #TEMPTipoRegistro1Aux drop constraint pkTEMPTipoRegistro1Aux_; ALTER TABLE #TEMPTipoRegistro1Aux alter column auxCodigoProduto VarChar(30) collate ' + @collationName + ' not null; ALTER TABLE #TEMPTipoRegistro1Aux ALTER COLUM
N auxUnidadeQtdeProduto  VarChar(2) collate ' + @collationName + '; ALTER TABLE #TEMPTipoRegistro1Aux ALTER COLUMN auxCodMargemComercializacao VarChar(4) collate ' + @collationName + '; ALTER TABLE #TEMPTipoRegistro1Aux ADD CONSTRAINT pkTEMPTipoRegistro1A
ux_ primary key (auxCodigoProduto);'
	 execute sp_executesql @sqlSTMT
 END
 
 --create index IX_TEMPTipoRegistro1Aux_001 on #TEMPTipoRegistro1Aux (auxCodigoProduto,auxPrecoProduto) 
 
 --create index IX_TEMPTipoRegistro1Aux_002 on #TEMPTipoRegistro1Aux (auxUnidadeQtdeProduto) 
 
--create index IX_TEMPTipoRegistro1Aux_003 on #TEMPTipoRegistro1Aux (auxUnidadePrecoProduto) 
 
 --create index IX_TEMPTipoRegistro1Aux_004 on #TEMPTipoRegistro1Aux (auxCodMargemComercializacao) 
 
--------------------------------------------------------------------------------------------------------------
-- TABELA DE PREÇOS AUXILIAR 
-- CONTÉM O PREÇO ATUAL (MAIS RECENTE) PRATICADO DE CADA PRODUTO / TABELA DE PREÇO
--------------------------------------------------------------------------------------------------------------
	CREATE TABLE #TEMPTabelaPrecoAuxiliar	(
		auxTPCodigoTipoTabelaPreco	NUMERIC(4),
		auxTPCodigoProduto			CHAR(30) collate SQL_Latin1_General_CP1_CS_AS,
		auxTPUltimoValorTabelaPreco	FLOAT
	 )  
	
	if(@collationName!='SQL_Latin1_General_CP1_CS_AS')
	BEGIN
		set @sqlSTMT = 
			'ALTER TABLE #TEMPTabelaPrecoAuxiliar alter column auxTPCodigoProduto VarChar(30) collate ' + @collationName + ' not null;'
		execute sp_executesql @sqlSTMT
	END
	
	IF @NaoAtualizarPrecoMenor = 'V'
	BEGIN
		INSERT #TEMPTabelaPrecoAuxiliar
		SELECT
		tp1.CodigoTipoTabelaPreco,
		tp1.CodigoProduto,
		tp1.ValorTabelaPreco
		FROM tbTabelaPreco tp1 with (nolock)
		WHERE	tp1.CodigoEmpresa = @CodigoEmpresa
			AND tp1.CodigoTipoTabelaPreco IN (@CodigoTabelaPreco, @CodigoTabelaPromocao, @CodigoTabelaGarantia)
			AND tp1.DataValidadeTabelaPreco = (	SELECT MAX(tp2.DataValidadeTabelaPreco)
												FROM tbTabelaPreco tp2 with (nolock)
												WHERE	tp2.CodigoEmpresa = tp1.CodigoEmpresa
													AND	tp2.CodigoTipoTabelaPreco = tp1.CodigoTipoTabelaPreco
													AND	tp2.CodigoProduto = tp1.CodigoProduto	)
	END
--------------------------------------------------------------------------------------------------------------

DECLARE @TipoRegistro2FT  TABLE  
 (  
  auxCodigoProduto VarChar(30),  
  auxDescricaoProduto VarChar(60)  
 )  
  
DECLARE @TipoRegistro2Aux  TABLE  
 (  
  auxCodigoProduto VarChar(30),  
  auxDescricaoProduto VarChar(60)  
 )  
  
DECLARE @TipoRegistro3FT  TABLE  
 (  
  auxCodigoProduto VarChar(30),  
  auxOrigem  Char(1),  
  auxPeso   Numeric(12,4),  
  auxEmbalagem  Numeric(4),  
  auxAliquotaIPI  Numeric(8,4),  
  auxPosicaoIPI  VarChar(10),  
  auxIncidePIS  Char(1),  
  auxIncideCOFINS  Char(1),  
  auxCodigoNCM  Numeric(8)  
 )  
  
DECLARE @TipoRegistro3Aux  TABLE  
 (  
  auxCodigoProduto VarChar(30),  
  auxOrigem  Char(1),  
  auxPeso   Numeric(12,4),  
  auxEmbalagem  Numeric(4),  
  auxAliquotaIPI  Numeric(8,4),  
  auxPosicaoIPI  VarChar(10),  
  auxIncidePIS  Char(1),  
  auxIncideCOFINS  Char(1),  
  auxCodigoNCM  Numeric(8)  
 )  
  
IF @Atualizar = 'F'  
 RETURN 0  
  
 -- Obtem Data do Sistema  
 IF @DataSistema IS NULL  
  SELECT @DataSistema = CONVERT(DATETIME, CONVERT(VARCHAR(12), GETDATE()))  
  
 IF @ClassifFiscalPadrao = ''  
  SELECT @ClassifFiscalPadrao = '1'  
  
 -- Obtem o Diretorio do Servidor para importacao de arquivo  
 SELECT @auxDiretorio = DiretorioImportacao  
 FROM tbEmpresa   with (nolock)
 WHERE CodigoEmpresa = @CodigoEmpresa  
  
  --- SQL_Latin1_General_CP1_CS_AS and SQL_Latin1_General_CP1_CS_AS

-- Limpar tabelas de relatorios  
TRUNCATE TABLE rtImportTabelaPreco  
TRUNCATE TABLE rtListaCaptacaoPreco  
TRUNCATE TABLE rtClassifPisCofins  
TRUNCATE TABLE rtRelCapPrecosOrig  
  
 -- Verifica a ocorrencia de erros  
 IF (@@ERROR <> 0)  
 BEGIN  
  RETURN -1  
 END  
  
  
 -- Gera string de execucao do BCP  
 SELECT @auxStringBCP = 'bcp ' + rtrim(DB_NAME()) + '..rtImportTabelaPreco in ' +  
     @auxDiretorio +   
    '\' + @ArquivoTexto + ' -cvarchar(255) -CRAW -T -S' + @@SERVERNAME + ' -h "TABLOCK"'  
  
 -- Carrega linhas do arquivo na tabela auxiliar de importacao  
 EXECUTE @auxError = master..xp_cmdshell @auxStringBCP  
  
 -- Verifica a ocorrencia de erros  
 IF (@@ERROR <> 0) OR (@auxError <> 0)  
 BEGIN  
  SELECT @auxErroImportacao = '65512-' + (select rtrim(TextoMensagem) from tbMensagens  with (nolock) where CodigoIdioma = 55 and NumeroMensagem = 65512)  
  RAISERROR (@auxErroImportacao, 2, 1)  
  RETURN -1  
 END  
  
 -- Obtem campo de flag UtilizaItemAuxiliar  
 SELECT  @auxUtilizaItemAuxiliar = UtilizaItemAuxiliar,  
  @auxCodigoMoeda = CodigoMoeda  
 FROM  tbEmpresaCE    with (nolock)
 WHERE CodigoEmpresa = @CodigoEmpresa  
  
        IF @auxCodigoMoeda <> 0  
   BEGIN  
  -- Obtem o Valor da Moeda para a empresa e data corrente  
  SELECT   
   @auxValorMoeda = hm.ValorDiarioMoeda,   
   @auxCasasDecimais = m.CasasDecimaisMoeda  
  FROM tbEmpresaCE ec   with (nolock)
   inner join tbMoeda m   with (nolock)
    on m.CodigoMoeda = ec.CodigoMoeda  
   inner join tbHistoricoMoeda hm   with (nolock)
    on hm.CodigoMoeda = m.CodigoMoeda AND  
       hm.DataValorMoeda <= @DataSistema  
  WHERE ec.CodigoEmpresa = @CodigoEmpresa  
   END  
 ELSE  
   BEGIN  
    -- Atribui um Valor para a Moeda Fixa Como Corrente.  
    SELECT @auxValorMoeda = 1  
    SELECT @auxCasasDecimais = 2  
   END  
  
 -----------------------------------------------------------------  
 -- Verifica se o padrao do arquivo tem prefixo no produto  
 -----------------------------------------------------------------   
 IF (@PrefixoCodProduto IS NULL) OR (@PrefixoCodProduto = ' ')  
  SELECT @PrefixoCodProduto = ''  
  
 DECLARE cur_TabelaPreco CURSOR LOCAL FAST_FORWARD FOR  
 SELECT LinhaArquivo FROM rtImportTabelaPreco   with (nolock)
  
 OPEN cur_TabelaPreco  
 FETCH NEXT FROM cur_TabelaPreco INTO  
      @curLinhaArquivo  
  
 WHILE @@FETCH_STATUS <> -1  
 BEGIN  
  -- Obtem o Tipo de Registro da linha  
  SELECT @auxTipoRegistro = CONVERT(SMALLINT, SUBSTRING(@curLinhaArquivo, 22, 1))  
  
  IF (@auxTipoRegistro = 1)  
   IF EXISTS ( SELECT 1  
     FROM tbProdutoFT (NOLOCK)  
     WHERE CodigoEmpresa = @CodigoEmpresa  
     AND CodigoProduto = /*RTRIM(LTRIM(@PrefixoCodProduto)) + RTRIM(LTRIM(SUBSTRING(@curLinhaArquivo, 1, 21))))*/dbo.fnLimpaBrancosCodigoMBB(RTRIM(LTRIM(@PrefixoCodProduto)) + RTRIM(LTRIM(SUBSTRING(@curLinhaArquivo, 1, 21)))))
    INSERT #TEMPTipoRegistro1FT  
    SELECT dbo.fnLimpaBrancosCodigoMBB(RTRIM(LTRIM(@PrefixoCodProduto)) + RTRIM(LTRIM(SUBSTRING(@curLinhaArquivo, 1, 21))))  
     , SUBSTRING(@curLinhaArquivo, 23, 2)  
     , CONVERT(TINYINT, SUBSTRING(@curLinhaArquivo, 25, 1))  
     , CASE CONVERT(TINYINT, SUBSTRING(@curLinhaArquivo, 25, 1))  
      WHEN 1 THEN ((CONVERT(FLOAT,SUBSTRING(@curLinhaArquivo, 27, 13)) / 100) / 1)  
      WHEN 2 THEN ((CONVERT(FLOAT,SUBSTRING(@curLinhaArquivo, 27, 13)) / 100) / 100)  
      WHEN 3 THEN ((CONVERT(FLOAT,SUBSTRING(@curLinhaArquivo, 27, 13)) / 100) / 1000) END  
     , RTRIM(LTRIM(SUBSTRING(@curLinhaArquivo, 40, 4)))
   ELSE  
    INSERT #TEMPTipoRegistro1Aux  
    SELECT dbo.fnLimpaBrancosCodigoMBB(RTRIM(LTRIM(@PrefixoCodProduto)) + RTRIM(LTRIM(SUBSTRING(@curLinhaArquivo, 1, 21))))  
     , SUBSTRING(@curLinhaArquivo, 23, 2)  
     , CONVERT(TINYINT, SUBSTRING(@curLinhaArquivo, 25, 1))  
     , CASE CONVERT(TINYINT, SUBSTRING(@curLinhaArquivo, 25, 1))  
      WHEN 1 THEN ((CONVERT(FLOAT,SUBSTRING(@curLinhaArquivo, 27, 13)) / 100) / 1)  
      WHEN 2 THEN ((CONVERT(FLOAT,SUBSTRING(@curLinhaArquivo, 27, 13)) / 100) / 100)  
      WHEN 3 THEN ((CONVERT(FLOAT,SUBSTRING(@curLinhaArquivo, 27, 13)) / 100) / 1000) END  
     , RTRIM(LTRIM(SUBSTRING(@curLinhaArquivo, 40, 4)))
    WHERE @auxUtilizaItemAuxiliar = 'V'  
  
  IF (@auxTipoRegistro = 2)  
   IF EXISTS ( SELECT 1  
     FROM tbProdutoFT (NOLOCK)  
     WHERE CodigoEmpresa = @CodigoEmpresa  
     AND CodigoProduto = dbo.fnLimpaBrancosCodigoMBB(RTRIM(LTRIM(@PrefixoCodProduto)) + RTRIM(LTRIM(SUBSTRING(@curLinhaArquivo, 1, 21)))))  
    INSERT @TipoRegistro2FT  
    SELECT dbo.fnLimpaBrancosCodigoMBB(RTRIM(LTRIM(@PrefixoCodProduto)) + RTRIM(LTRIM(SUBSTRING(@curLinhaArquivo, 1, 21))))  
     , UPPER(SUBSTRING(@curLinhaArquivo, 23, 72))  
   ELSE  
    INSERT @TipoRegistro2Aux  
    SELECT dbo.fnLimpaBrancosCodigoMBB(RTRIM(LTRIM(@PrefixoCodProduto)) + RTRIM(LTRIM(SUBSTRING(@curLinhaArquivo, 1, 21))))  
     , UPPER(SUBSTRING(@curLinhaArquivo, 23, 72))  
    WHERE @auxUtilizaItemAuxiliar = 'V'  
  
  
  IF (@auxTipoRegistro = 3)  
   IF EXISTS ( SELECT 1  
     FROM tbProdutoFT (NOLOCK)  
     WHERE CodigoEmpresa = @CodigoEmpresa  
     AND CodigoProduto = dbo.fnLimpaBrancosCodigoMBB(RTRIM(LTRIM(@PrefixoCodProduto)) + RTRIM(LTRIM(SUBSTRING(@curLinhaArquivo, 1, 21)))))  
    INSERT @TipoRegistro3FT  
    SELECT dbo.fnLimpaBrancosCodigoMBB(RTRIM(LTRIM(@PrefixoCodProduto)) + RTRIM(LTRIM(SUBSTRING(@curLinhaArquivo, 1, 21))))  
     , SUBSTRING(@curLinhaArquivo, 23, 1)  
     , CASE WHEN CONVERT(NUMERIC(12,4), STUFF(SUBSTRING(@curLinhaArquivo, 24, 11), 9, 0, '.')) = 0  
      THEN 1  
      ELSE CONVERT(NUMERIC(12,4), STUFF(SUBSTRING(@curLinhaArquivo, 24, 11), 9, 0, '.')) END  
     , CASE WHEN CONVERT(NUMERIC(4), SUBSTRING(@curLinhaArquivo, 39, 4)) = 0  
      THEN 1  
      ELSE CONVERT(NUMERIC(4), SUBSTRING(@curLinhaArquivo, 39, 4)) END  
     , CONVERT(NUMERIC(8,4),CONVERT(NUMERIC(8,2), SUBSTRING(@curLinhaArquivo, 52, 7)) / 10000)  
     , CASE WHEN RTRIM(LTRIM(SUBSTRING(@curLinhaArquivo, 59, 10))) = ''  
      THEN '1'  
      ELSE RTRIM(LTRIM(SUBSTRING(@curLinhaArquivo, 59, 10))) END  
     , CASE WHEN SUBSTRING(@curLinhaArquivo,69,1) = 'E'  
      THEN 'F'  
      ELSE 'V' END  
     , CASE WHEN SUBSTRING(@curLinhaArquivo,70,1) = 'E'  
      THEN 'F'  
      ELSE 'V' END  
     , CASE WHEN CONVERT(NUMERIC(8,0), SUBSTRING(@curLinhaArquivo, 59, 8)) = 0  
      THEN 1  
      ELSE CONVERT(NUMERIC(8,0), SUBSTRING(@curLinhaArquivo, 59, 8)) END  
   ELSE  
    INSERT @TipoRegistro3Aux  
    SELECT dbo.fnLimpaBrancosCodigoMBB(RTRIM(LTRIM(@PrefixoCodProduto)) + RTRIM(LTRIM(SUBSTRING(@curLinhaArquivo, 1, 21))))  
     , SUBSTRING(@curLinhaArquivo, 23, 1)  
     , CASE WHEN CONVERT(NUMERIC(12,4), STUFF(SUBSTRING(@curLinhaArquivo, 24, 11), 9, 0, '.')) = 0  
      THEN 1  
      ELSE CONVERT(NUMERIC(12,4), STUFF(SUBSTRING(@curLinhaArquivo, 24, 11), 9, 0, '.')) END  
     , CASE WHEN CONVERT(NUMERIC(4), SUBSTRING(@curLinhaArquivo, 39, 4)) = 0  
      THEN 1  
      ELSE CONVERT(NUMERIC(4), SUBSTRING(@curLinhaArquivo, 39, 4)) END  
     , CONVERT(NUMERIC(8,4),CONVERT(NUMERIC(8,2), SUBSTRING(@curLinhaArquivo, 52, 7)) / 10000)  
     , CASE WHEN RTRIM(LTRIM(SUBSTRING(@curLinhaArquivo, 59, 10))) = ''  
      THEN '1'  
      ELSE RTRIM(LTRIM(SUBSTRING(@curLinhaArquivo, 59, 10))) END  
     , CASE WHEN SUBSTRING(@curLinhaArquivo,69,1) = 'E'  
      THEN 'F'  
      ELSE 'V' END  
     , CASE WHEN SUBSTRING(@curLinhaArquivo,70,1) = 'E'  
      THEN 'F'  
      ELSE 'V' END  
     , CASE WHEN CONVERT(NUMERIC(8,0), SUBSTRING(@curLinhaArquivo, 59, 8)) = 0  
      THEN 1  
      ELSE CONVERT(NUMERIC(8,0), SUBSTRING(@curLinhaArquivo, 59, 8)) END  
    WHERE @auxUtilizaItemAuxiliar = 'V'  
  
 FETCH NEXT FROM cur_TabelaPreco INTO  
  @curLinhaArquivo  
 END   
 CLOSE cur_TabelaPreco  
 DEALLOCATE cur_TabelaPreco  
  
 -- Verifica se o Codigo de Unidade existe  
 IF EXISTS ( SELECT 1  
   FROM #TEMPTipoRegistro1FT  
   WHERE auxUnidadeQtdeProduto NOT IN (SELECT CodigoUnidadeProduto FROM tbUnidadeProduto (NOLOCK))  
   UNION  
   SELECT 1  
   FROM #TEMPTipoRegistro1Aux  
   WHERE auxUnidadeQtdeProduto NOT IN (SELECT CodigoUnidadeProduto FROM tbUnidadeProduto (NOLOCK)))  
 BEGIN  
  SELECT @DescricaoUnidadeProduto = 'CADASTRADO VIA TABELA PRECO',  
   @CodigoDIPIUnidadeProduto = 0,  
   @UsaCasasDecimaisUnidadeProdut = 'F',  
   @DescricaoUnidadeProdutoMBB = NULL  
  
  DECLARE curUnidade CURSOR LOCAL FAST_FORWARD FOR  
  SELECT DISTINCT   
   auxUnidadeQtdeProduto  
  FROM #TEMPTipoRegistro1FT  
  WHERE auxUnidadeQtdeProduto NOT IN (SELECT CodigoUnidadeProduto FROM tbUnidadeProduto with (nolock))  
  UNION  
  SELECT DISTINCT   
   auxUnidadeQtdeProduto  
  FROM #TEMPTipoRegistro1Aux  
  WHERE auxUnidadeQtdeProduto NOT IN (SELECT CodigoUnidadeProduto FROM tbUnidadeProduto with (nolock))  
    
  OPEN curUnidade  
  FETCH NEXT FROM curUnidade INTO  
   @auxUnidadeQtdeProduto  
  WHILE @@FETCH_STATUS <> -1  
  BEGIN  
   IF NOT EXISTS (SELECT 1 FROM tbUnidadeProduto  with (nolock) WHERE CodigoUnidadeProduto = @auxUnidadeQtdeProduto)  
    EXECUTE spIUnidadeProduto  
     @auxUnidadeQtdeProduto,  
     @DescricaoUnidadeProduto,  
     @CodigoDIPIUnidadeProduto,  
     @UsaCasasDecimaisUnidadeProdut,  
     @DescricaoUnidadeProdutoMBB  
  
   -- Verifica a ocorrencia de erros  
   IF @@ERROR <> 0  
   BEGIN  
    CLOSE curUnidade  
    DEALLOCATE curUnidade  
    SELECT @auxErroImportacao = 'Falha no cadastro de unidade de produto! => ' + @auxUnidadeQtdeProduto  
    RAISERROR (@auxErroImportacao, 16, 1)  
    RETURN -1  
   END  
  
   FETCH NEXT FROM curUnidade INTO  
    @auxUnidadeQtdeProduto  
  END  
  CLOSE curUnidade  
  DEALLOCATE curUnidade  
 END  
  
 -- Verifica se a Margem de Comercializacao existe  
 IF EXISTS ( SELECT 1  
   FROM #TEMPTipoRegistro1FT  
   WHERE LTRIM(RTRIM(auxCodMargemComercializacao)) != ''   
   AND auxCodMargemComercializacao IS NOT NULL  
   AND auxCodMargemComercializacao NOT IN ( SELECT CodigoMargemComercializacao  
         FROM tbMargemComercializacao (NOLOCK)   
         WHERE CodigoEmpresa = @CodigoEmpresa )  
   UNION  
   SELECT 1  
   FROM #TEMPTipoRegistro1Aux  
   WHERE LTRIM(RTRIM(auxCodMargemComercializacao)) != ''   
   AND auxCodMargemComercializacao IS NOT NULL  
   AND auxCodMargemComercializacao NOT IN ( SELECT CodigoMargemComercializacao  
         FROM tbMargemComercializacao (NOLOCK)   
         WHERE CodigoEmpresa = @CodigoEmpresa ))  
 BEGIN  
  SELECT @ObservacaoReajustePreco = 'CADASTRADO VIA TABELA PRECO',  
   @AbreviaturaReajustePreco = NULL  
  
  DECLARE curMargem CURSOR LOCAL FAST_FORWARD FOR  
  SELECT DISTINCT  
   auxCodMargemComercializacao  
  FROM #TEMPTipoRegistro1FT  
  WHERE LTRIM(RTRIM(auxCodMargemComercializacao)) != ''   
  AND auxCodMargemComercializacao IS NOT NULL  
  AND auxCodMargemComercializacao NOT IN ( SELECT CodigoMargemComercializacao  
        FROM tbMargemComercializacao (NOLOCK)   
        WHERE CodigoEmpresa = @CodigoEmpresa)  
  UNION  
  SELECT DISTINCT  
   auxCodMargemComercializacao  
  FROM #TEMPTipoRegistro1Aux  
  WHERE LTRIM(RTRIM(auxCodMargemComercializacao)) != ''   
  AND auxCodMargemComercializacao IS NOT NULL  
  AND auxCodMargemComercializacao NOT IN ( SELECT CodigoMargemComercializacao  
        FROM tbMargemComercializacao (NOLOCK)   
        WHERE CodigoEmpresa = @CodigoEmpresa)  
  
  OPEN curMargem  
  FETCH NEXT FROM curMargem INTO  
   @auxCodMargemComercializacao  
  WHILE @@FETCH_STATUS <> -1  
  BEGIN  
   IF NOT EXISTS ( SELECT 1  
     FROM tbMargemComercializacao (NOLOCK)  
     WHERE CodigoEmpresa = @CodigoEmpresa AND CodigoMargemComercializacao = @auxCodMargemComercializacao)  
   BEGIN  
	   IF @ChecaParametro = 'F' BEGIN
	    EXECUTE spIMargemComercializacao  
		 @CodigoEmpresa,
		 @auxCodMargemComercializacao,  
		 @IndexadorPrecoVenda,  
		 @ObservacaoReajustePreco,  
		 @AbreviaturaReajustePreco,  
		 @IndexadorPrecoImportado,
		 0,
		 '.',
		 '.',
		 0
		END 
	   IF @ChecaParametro = 'V' BEGIN
	    EXECUTE spIMargemComercializacao  
		 @CodigoEmpresa,
		 @auxCodMargemComercializacao,  
		 0,
		 '.',
		 '.',
		 0,
		 @IndexadorPrecoVenda,  
		 @ObservacaoReajustePreco,  
		 @AbreviaturaReajustePreco,  
		 @IndexadorPrecoImportado
	   END 
   END  
  
   -- Verifica a ocorrencia de erros  
   IF @@ERROR <> 0  
   BEGIN  
    CLOSE curMargem  
    DEALLOCATE curMargem  
    SELECT @auxErroImportacao = 'Falha no cadastro de margem de comercialização! => ' + @auxCodMargemComercializacao  
    RAISERROR (@auxErroImportacao, 16, 1)  
    RETURN -1  
   END  
  
   FETCH NEXT FROM curMargem INTO  
    @auxCodMargemComercializacao  
  END  
  CLOSE curMargem  
  DEALLOCATE curMargem  
 END  
  
 INSERT rtClassifPisCofins  
 SELECT DISTINCT  
  @CodigoEmpresa,  
  @CodigoLocal,  
  tr.auxCodigoProduto,  
  tr.auxCodigoNCM,  
  tr.auxPosicaoIPI,  
  cl.TributaCOFINS,  
  cl.TributaPIS,  
  tr.auxIncideCOFINS,  
  tr.auxIncidePIS,  
  @@SPID  
 FROM @TipoRegistro3Aux tr  
 INNER JOIN tbClassificacaoFiscal cl (NOLOCK)  
 ON cl.CodigoEmpresa  = @CodigoEmpresa  
 AND cl.CodigoLocal   = @CodigoLocal  
 AND cl.CodigoClassificacaoFiscal = tr.auxPosicaoIPI  
 WHERE (cl.TributaCOFINS  != tr.auxIncideCOFINS  
 OR cl.TributaPIS   != tr.auxIncideCOFINS)  
 UNION  
 SELECT DISTINCT  
  @CodigoEmpresa,  
  @CodigoLocal,  
  tr.auxCodigoProduto,  
  tr.auxCodigoNCM,  
  tr.auxPosicaoIPI,  
  cl.TributaCOFINS,  
  cl.TributaPIS,  
  tr.auxIncideCOFINS,  
  tr.auxIncidePIS,  
  @@SPID  
 FROM @TipoRegistro3FT tr  
 INNER JOIN tbClassificacaoFiscal cl (NOLOCK)  
 ON cl.CodigoEmpresa  = @CodigoEmpresa  
 AND cl.CodigoLocal   = @CodigoLocal  
 AND cl.CodigoClassificacaoFiscal = tr.auxPosicaoIPI  
 WHERE (cl.TributaCOFINS  != tr.auxIncideCOFINS  
 OR cl.TributaPIS   != tr.auxIncideCOFINS)  
  
 -- Classificacao Fiscal (Aux)  
 IF EXISTS ( SELECT 1  
   FROM @TipoRegistro3Aux tr  
   WHERE tr.auxPosicaoIPI != ''  
   AND NOT EXISTS (SELECT 1  
     FROM tbClassificacaoFiscal (NOLOCK)  
     WHERE CodigoEmpresa   = @CodigoEmpresa  
     AND CodigoLocal   = @CodigoLocal  
     AND CodigoClassificacaoFiscal = tr.auxPosicaoIPI))  
 BEGIN  
  ALTER TABLE tbClassificacaoFiscal DISABLE TRIGGER tni_DSPa_ClassificacaoFiscal  
  INSERT tbClassificacaoFiscal  
  SELECT DISTINCT  
   @CodigoEmpresa,  
   @CodigoLocal,  
   tr.auxPosicaoIPI,  
   tr.auxCodigoNCM,  
   '@',   
   1,  
   '',  
   '',  
   '',  
   tr.auxAliquotaIPI,  
   0,  
   0,  
   0,  
   'F',  
   tr.auxIncidePIS,  
   tr.auxIncideCOFINS,  
   0,  
   0,  
   'F',  
   'F',  
   '',  
   '',  
   '',  
   NULL,  
   NULL,  
   NULL,  
   0,  
   0,  
   'F',  
   'F',  
   'F',  
   NULL,
   0,
   0  
  FROM @TipoRegistro3Aux tr  
  WHERE tr.auxPosicaoIPI != ''  
  AND NOT EXISTS (SELECT 1  
    FROM tbClassificacaoFiscal (NOLOCK)  
    WHERE CodigoEmpresa   = @CodigoEmpresa  
    AND CodigoLocal   = @CodigoLocal  
    AND CodigoClassificacaoFiscal = tr.auxPosicaoIPI)  
  ALTER TABLE tbClassificacaoFiscal ENABLE TRIGGER tni_DSPa_ClassificacaoFiscal  
  
  -- tbCFxUFxUF  
  INSERT tbCFxUFxUF  
  SELECT DISTINCT  
   @CodigoEmpresa,  
   tr.auxPosicaoIPI,  
   LO.UFLocal,  
   UF.UnidadeFederacao,  
   '00',  
   '00',  
   'F',  
   0,  
   0,  
   GETDATE(),  
   '00',  
   'F',  
   0,  
   0  
  FROM @TipoRegistro3Aux tr,  
   tbLocal LO (NOLOCK),   
   tbUnidadeFederacao UF (NOLOCK)  
  WHERE tr.auxPosicaoIPI != ''  
  AND LO.CodigoEmpresa = @CodigoEmpresa  
  AND ((LO.UFLocal <> UF.UnidadeFederacao) OR (LO.UFLocal = UF.UnidadeFederacao))  
  AND NOT EXISTS (SELECT 1  
    FROM tbCFxUFxUF (NOLOCK)  
    WHERE CodigoEmpresa   = @CodigoEmpresa  
    AND CodigoClassificacaoFiscal = tr.auxPosicaoIPI  
    AND UFOrigem   = LO.UFLocal  
    AND UFDestino   = UF.UnidadeFederacao)  
 END  
  
 -- Classificacao Fiscal (FT)  
 IF EXISTS ( SELECT 1  
   FROM @TipoRegistro3FT tr  
   WHERE tr.auxPosicaoIPI != ''  
   AND NOT EXISTS (SELECT 1  
     FROM tbClassificacaoFiscal (NOLOCK)  
     WHERE CodigoEmpresa   = @CodigoEmpresa  
     AND CodigoLocal   = @CodigoLocal  
     AND CodigoClassificacaoFiscal = tr.auxPosicaoIPI))  
 BEGIN  
  ALTER TABLE tbClassificacaoFiscal DISABLE TRIGGER tni_DSPa_ClassificacaoFiscal  
  INSERT tbClassificacaoFiscal  
  SELECT DISTINCT  
   @CodigoEmpresa,  
   @CodigoLocal,  
   tr.auxPosicaoIPI,  
   tr.auxCodigoNCM,  
   '@',   
   1,  
   '',  
   '',  
   '',  
   tr.auxAliquotaIPI,  
   0,  
   0,  
   0,  
   'F',  
   tr.auxIncidePIS,  
   tr.auxIncideCOFINS,  
   0,  
   0,  
   'F',  
   'F',  
   '',  
   '',  
   '',  
   NULL,  
   NULL,  
   NULL,  
   0,  
   0,  
   'F',  
   'F',  
   'F',  
   NULL,
   0,
   0
  FROM @TipoRegistro3FT tr  
  WHERE tr.auxPosicaoIPI != ''  
  AND NOT EXISTS (SELECT 1  
    FROM tbClassificacaoFiscal (NOLOCK)  
    WHERE CodigoEmpresa   = @CodigoEmpresa  
    AND CodigoLocal   = @CodigoLocal  
    AND CodigoClassificacaoFiscal = tr.auxPosicaoIPI)  
  ALTER TABLE tbClassificacaoFiscal ENABLE TRIGGER tni_DSPa_ClassificacaoFiscal  
  
  -- tbCFxUFxUF  
  INSERT tbCFxUFxUF  
  SELECT DISTINCT  
   @CodigoEmpresa,  
   tr.auxPosicaoIPI,  
   LO.UFLocal,  
   UF.UnidadeFederacao,  
   '00',  
   '00',  
   'F',  
   0,  
   0,  
   GETDATE(),  
   '00',  
   'F',  
   0,  
   0  
  FROM @TipoRegistro3FT tr,  
   tbLocal LO (NOLOCK),   
   tbUnidadeFederacao UF (NOLOCK)  
  WHERE tr.auxPosicaoIPI != ''  
  AND LO.CodigoEmpresa = @CodigoEmpresa  
  AND ((LO.UFLocal <> UF.UnidadeFederacao) OR (LO.UFLocal = UF.UnidadeFederacao))  
  AND NOT EXISTS (SELECT 1  
    FROM tbCFxUFxUF (NOLOCK)  
    WHERE CodigoEmpresa   = @CodigoEmpresa  
    AND CodigoClassificacaoFiscal = tr.auxPosicaoIPI  
    AND UFOrigem   = LO.UFLocal  
    AND UFDestino   = UF.UnidadeFederacao)  
 END  
  
 -------------------------------------------------------  
 BEGIN TRANSACTION  
 -------------------------------------------------------  
  
 --------------------------- Atualizar tbProdutoAuxiliar  
 IF EXISTS ( SELECT 1  
   FROM #TEMPTipoRegistro1Aux tr)  
 BEGIN  
  INSERT tbProduto  
  SELECT DISTINCT  
   @CodigoEmpresa,  
   auxCodigoProduto,  
   '@',  
   (SELECT MIN(CodigoClassificacaoFiscal) FROM tbClassificacaoFiscal (NOLOCK) WHERE CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @CodigoLocal),  
   dbo.fnEditarCodigoProdutoMB(auxCodigoProduto),  
   GETDATE()  
  FROM #TEMPTipoRegistro1Aux  
  WHERE NOT EXISTS ( SELECT 1 FROM tbProdutoFT (NOLOCK)  
     WHERE CodigoEmpresa = @CodigoEmpresa  
     AND CodigoProduto = auxCodigoProduto)  
  AND NOT EXISTS ( SELECT 1 FROM tbProduto (NOLOCK)  
     WHERE CodigoEmpresa = @CodigoEmpresa  
     AND CodigoProduto = auxCodigoProduto)  
  
  IF @@ERROR <> 0  
  BEGIN  
   ROLLBACK TRANSACTION  
   SELECT @auxErroImportacao = 'Falha ao incluir produto do produto auxiliar (1).'  
   RAISERROR (@auxErroImportacao, 16, 1)  
   RETURN -1  
  END  
  
  INSERT tbProdutoAuxiliar (CodigoEmpresa, CodigoProdutoAuxiliar,EmbalagemProdutoAuxiliar,PesoProdutoAuxiliar,PrecoProdutoAuxiliar,CodigoUnidadeProduto,DataUltimoReajusteAuxiliar,CodigoAcabamentoPeca,ModeloAplicacao,QuantidadeMinimaVenda,Comprimento,
  Largura,Profundidade,CodigoLinhaProduto,CodigoFonteFornecimento,Importado,PrecoProdutoAuxiliarGO)   
  SELECT DISTINCT  
   @CodigoEmpresa,  
   auxCodigoProduto,  
   1,  
   1,  
   case when @ChecaParametro = 'F' then ROUND(auxPrecoProduto * @IndexadorPrecoVenda, 2)
   else 0 
   end ,  
   auxUnidadeQtdeProduto,  
   @DataUltimoReajusteAuxiliar,  
   NULL,  
   NULL,  
   0,  
   0,  
   0,  
   0,  
   0,  
   0,
   'F',
   case when @ChecaParametro = 'V' then ROUND(auxPrecoProduto * @IndexadorPrecoVenda, 2)
   else 0 
   end 
  FROM #TEMPTipoRegistro1Aux  
  WHERE NOT EXISTS ( SELECT 1 FROM tbProdutoFT (NOLOCK)  
     WHERE CodigoEmpresa = @CodigoEmpresa  
     AND CodigoProduto = auxCodigoProduto)  
  AND NOT EXISTS ( SELECT 1 FROM tbProdutoAuxiliar (NOLOCK)  
     WHERE CodigoEmpresa  = @CodigoEmpresa  
     AND CodigoProdutoAuxiliar = auxCodigoProduto)  
  
  IF @@ERROR <> 0  
  BEGIN  
   ROLLBACK TRANSACTION  
   SELECT @auxErroImportacao = 'Falha ao incluir produto auxiliar (1).'  
   RAISERROR (@auxErroImportacao, 16, 1)  
   RETURN -1  
  END  
  
  UPDATE tbProdutoAuxiliar  
  
  SET PrecoProdutoAuxiliar  =  case when @ChecaParametro = 'F' then
									  case when tbProdutoAuxiliar.Importado = 'V' 
										then ROUND(tr1.auxPrecoProduto * @IndexadorPrecoImportado, 2) 
										ELSE ROUND(tr1.auxPrecoProduto * @IndexadorPrecoVenda, 2) 
									end
                                else  PrecoProdutoAuxiliar 
                                end ,
   PrecoProdutoAuxiliarGO  =  case when @ChecaParametro = 'V' then
									  case when tbProdutoAuxiliar.Importado = 'V' 
										then ROUND(tr1.auxPrecoProduto * @IndexadorPrecoImportado, 2) 
										ELSE ROUND(tr1.auxPrecoProduto * @IndexadorPrecoVenda, 2) 
									end
								else PrecoProdutoAuxiliarGO
                                end ,                                
   CodigoUnidadeProduto  = tr1.auxUnidadeQtdeProduto,  
   DataUltimoReajusteAuxiliar = @DataUltimoReajusteAuxiliar  
  FROM #TEMPTipoRegistro1Aux tr1  
  WHERE CodigoEmpresa   = @CodigoEmpresa  
  AND CodigoProdutoAuxiliar  = tr1.auxCodigoProduto  
  
  IF @@ERROR <> 0  
  BEGIN  
   ROLLBACK TRANSACTION  
   SELECT @auxErroImportacao = 'Falha ao atualizar produto auxiliar (1).'  
   RAISERROR (@auxErroImportacao, 16, 1)  
   RETURN -1  
  END  
 END  
  
 IF EXISTS ( SELECT 1  
   FROM @TipoRegistro2Aux tr)  
 BEGIN  
  INSERT tbProduto  
  SELECT DISTINCT  
   @CodigoEmpresa,  
   auxCodigoProduto,  
   LTRIM(RTRIM(UPPER(auxDescricaoProduto))),  
   (SELECT MIN(CodigoClassificacaoFiscal) FROM tbClassificacaoFiscal (NOLOCK) WHERE CodigoEmpresa = @CodigoEmpresa AND CodigoLocal = @CodigoLocal),  
   dbo.fnEditarCodigoProdutoMB(auxCodigoProduto),  
   GETDATE()  
  FROM @TipoRegistro2Aux  
  WHERE NOT EXISTS ( SELECT 1 FROM tbProdutoFT (NOLOCK)  
     WHERE CodigoEmpresa = @CodigoEmpresa  
     AND CodigoProduto = auxCodigoProduto)  
  AND NOT EXISTS ( SELECT 1 FROM tbProduto (NOLOCK)  
     WHERE CodigoEmpresa = @CodigoEmpresa  
     AND CodigoProduto = auxCodigoProduto)  
  
  IF @@ERROR <> 0  
  BEGIN  
   ROLLBACK TRANSACTION  
   SELECT @auxErroImportacao = 'Falha ao incluir produto do produto auxiliar (2).'  
   RAISERROR (@auxErroImportacao, 16, 1)  
   RETURN -1  
  END  
  
  INSERT tbProdutoAuxiliar (CodigoEmpresa, CodigoProdutoAuxiliar,EmbalagemProdutoAuxiliar,PesoProdutoAuxiliar,PrecoProdutoAuxiliar,CodigoUnidadeProduto,DataUltimoReajusteAuxiliar,CodigoAcabamentoPeca,ModeloAplicacao,QuantidadeMinimaVenda,Comprimento,
  Largura,Profundidade,CodigoLinhaProduto,CodigoFonteFornecimento,Importado,PrecoProdutoAuxiliarGO)   
  SELECT DISTINCT  
   @CodigoEmpresa,  
   auxCodigoProduto,  
   1,  
   1,  
   0.01,  
   (SELECT MIN(CodigoUnidadeProduto) FROM tbUnidadeProduto (NOLOCK)),  
   @DataUltimoReajusteAuxiliar,  
   NULL,  
   NULL,  
   0,  
   0,  
   0,  
   0,  
   0,  
   0,
   'F',
   0.01
  FROM @TipoRegistro2Aux  
  WHERE NOT EXISTS ( SELECT 1 FROM tbProdutoFT (NOLOCK)  
     WHERE CodigoEmpresa = @CodigoEmpresa  
     AND CodigoProduto = auxCodigoProduto)  
  AND NOT EXISTS ( SELECT 1 FROM tbProdutoAuxiliar (NOLOCK)  
     WHERE CodigoEmpresa  = @CodigoEmpresa  
     AND CodigoProdutoAuxiliar = auxCodigoProduto)  
  
  IF @@ERROR <> 0  
  BEGIN  
   ROLLBACK TRANSACTION  
   SELECT @auxErroImportacao = 'Falha ao incluir produto auxiliar (2).'  
   RAISERROR (@auxErroImportacao, 16, 1)  
   RETURN -1  
  END  
  
  UPDATE tbProduto  
  SET DescricaoProduto = LTRIM(RTRIM(UPPER(auxDescricaoProduto)))  
  FROM @TipoRegistro2Aux  
  WHERE CodigoEmpresa  = @CodigoEmpresa  
  AND CodigoProduto  = auxCodigoProduto  
  AND @AtualizarDescrProd = 'V'  
  
  IF @@ERROR <> 0  
  BEGIN  
   ROLLBACK TRANSACTION  
   SELECT @auxErroImportacao = 'Falha ao atualizar produto auxiliar (2).'  
   RAISERROR (@auxErroImportacao, 16, 1)  
   RETURN -1  
  END  
 END  
  
 IF EXISTS ( SELECT 1  
   FROM @TipoRegistro3Aux tr)  
 BEGIN  
  INSERT tbProduto  
  SELECT DISTINCT  
   @CodigoEmpresa,  
   auxCodigoProduto,  
   '@',  
   auxPosicaoIPI,  
   dbo.fnEditarCodigoProdutoMB(auxCodigoProduto),  
   GETDATE()  
  FROM @TipoRegistro3Aux  
  WHERE NOT EXISTS ( SELECT 1 FROM tbProdutoFT (NOLOCK)  
     WHERE CodigoEmpresa = @CodigoEmpresa  
     AND CodigoProduto = auxCodigoProduto)  
  AND NOT EXISTS ( SELECT 1 FROM tbProduto (NOLOCK)  
     WHERE CodigoEmpresa = @CodigoEmpresa  
     AND CodigoProduto = auxCodigoProduto)  
  
  IF @@ERROR <> 0  
  BEGIN  
   ROLLBACK TRANSACTION  
   SELECT @auxErroImportacao = 'Falha ao incluir produto do produto auxiliar (3).'  
   RAISERROR (@auxErroImportacao, 16, 1)  
   RETURN -1  
  END  
  
  INSERT tbProdutoAuxiliar (CodigoEmpresa, CodigoProdutoAuxiliar,EmbalagemProdutoAuxiliar,PesoProdutoAuxiliar,PrecoProdutoAuxiliar,CodigoUnidadeProduto,DataUltimoReajusteAuxiliar,CodigoAcabamentoPeca,ModeloAplicacao,QuantidadeMinimaVenda,Comprimento,
  Largura,Profundidade,CodigoLinhaProduto,CodigoFonteFornecimento,Importado,PrecoProdutoAuxiliarGO)   
  SELECT DISTINCT  
   @CodigoEmpresa,  
   auxCodigoProduto,  
   auxEmbalagem,  
   auxPeso,  
   0.01,  
   (SELECT MIN(CodigoUnidadeProduto) FROM tbUnidadeProduto (NOLOCK)),  
   @DataUltimoReajusteAuxiliar,  
   NULL,  
   NULL,  
   0,  
   0,  
   0,  
   0,  
   0,  
   0,
   CASE WHEN @auxOrigem = 'G' THEN 'V' ELSE 'F' END,
   0.01
  FROM @TipoRegistro3Aux  
  WHERE NOT EXISTS ( SELECT 1 FROM tbProdutoFT (NOLOCK)  
     WHERE CodigoEmpresa = @CodigoEmpresa  
     AND CodigoProduto = auxCodigoProduto)  
  AND NOT EXISTS ( SELECT 1 FROM tbProdutoAuxiliar (NOLOCK)  
     WHERE CodigoEmpresa  = @CodigoEmpresa  
     AND CodigoProdutoAuxiliar = auxCodigoProduto)  
  
  IF @@ERROR <> 0  
  BEGIN  
   ROLLBACK TRANSACTION  
   SELECT @auxErroImportacao = 'Falha ao incluir produto auxiliar (3).'  
   RAISERROR (@auxErroImportacao, 16, 1)  
   RETURN -1  
  END  
  
  UPDATE tbProduto  
  SET CodigoClassificacaoFiscal = auxPosicaoIPI  
  FROM @TipoRegistro3Aux  
  WHERE CodigoEmpresa = @CodigoEmpresa  
  AND CodigoProduto = auxCodigoProduto  
  
  IF @@ERROR <> 0  
  BEGIN  
   ROLLBACK TRANSACTION  
   SELECT @auxErroImportacao = 'Falha ao atualizar produto auxiliar (3).'  
   RAISERROR (@auxErroImportacao, 16, 1)  
   RETURN -1  
  END  
  
  UPDATE tbProdutoAuxiliar  
  SET EmbalagemProdutoAuxiliar = auxEmbalagem,  
   PesoProdutoAuxiliar  = auxPeso,  
   DataUltimoReajusteAuxiliar = @DataUltimoReajusteAuxiliar,
   Importado = CASE WHEN auxOrigem = 'G' THEN 'V' ELSE 'F' END
  FROM @TipoRegistro3Aux  
  WHERE CodigoEmpresa   = @CodigoEmpresa  
  AND CodigoProdutoAuxiliar  = auxCodigoProduto  
  
  IF @@ERROR <> 0  
  BEGIN  
   ROLLBACK TRANSACTION  
   SELECT @auxErroImportacao = 'Falha ao atualizar produto auxiliar (3).'  
   RAISERROR (@auxErroImportacao, 16, 1)  
   RETURN -1  
  END  
 END  
  
 -- Atualiza o Preco de Reposicao  
 UPDATE tbProdutoFT  
 SET PrecoReposicaoIndiceProduto = CASE WHEN (ProdutoImportado = 'V' OR ProdutoImportadoDireto = 'V' OR NacionalMaior40Import = 'V' OR CodigoTributacaoProduto = 'V')  
       THEN ROUND(tr.auxPrecoProduto * @IndexadorPrecoReposicaoImportado / @auxValorMoeda, @auxCasasDecimais)  
       ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoReposicao / @auxValorMoeda, @auxCasasDecimais) END,  
  CodigoMargemComercializacao = CASE WHEN tr.auxCodMargemComercializacao != '' THEN tr.auxCodMargemComercializacao ELSE CodigoMargemComercializacao END,  
  ItemForaListaProduto  = 'F'  
 FROM #TEMPTipoRegistro1FT tr  
 WHERE CodigoEmpresa   = @CodigoEmpresa  
 AND CodigoProduto   = tr.auxCodigoProduto  
 AND CodigoLinhaProduto  BETWEEN @CodigoLinhaInicial AND @CodigoLinhaFinal  
 AND CodigoFonteFornecimento  BETWEEN @CodigoFonteFornecInicial AND @CodigoFonteFornecFinal  
  
 -- Verifica a ocorrencia de erros  
 IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  SELECT @auxErroImportacao = 'Falha ao atualizar preco de reposicao!'  
  RAISERROR (@auxErroImportacao, 16, 1)  
  RETURN -1  
 END  
  
 -- Atualiza tbProdutoFT  
 UPDATE tbProdutoFT  
 SET EmbalagemComercialProduto  = tr.auxEmbalagem  
  , PesoLiquidoProduto   = tr.auxPeso  
  , PesoBrutoProduto     = tr.auxPeso  
 FROM @TipoRegistro3FT tr  
 WHERE CodigoEmpresa    = @CodigoEmpresa  
 AND CodigoProduto    = tr.auxCodigoProduto  
 AND CodigoLinhaProduto  BETWEEN @CodigoLinhaInicial AND @CodigoLinhaFinal  
 AND CodigoFonteFornecimento  BETWEEN @CodigoFonteFornecInicial AND @CodigoFonteFornecFinal  
  
 -- Verifica a ocorrencia de erros  
 IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  SELECT @auxErroImportacao = 'Falha ao atualizar embalagem e peso!'  
  RAISERROR (@auxErroImportacao, 16, 1)  
  RETURN -1  
 END  
  
 IF (@NaoAtualizarClassifFiscal = 'F' )  
 BEGIN  
  -- Atualiza ClassificacaoFiscal no Produto Principal  
  UPDATE tbProduto  
  SET CodigoClassificacaoFiscal = tr.auxPosicaoIPI  
  FROM @TipoRegistro3Aux tr  
  WHERE CodigoEmpresa   = @CodigoEmpresa  
  AND CodigoProduto   = tr.auxCodigoProduto  
  
  -- Verifica a ocorrencia de erros  
  IF @@ERROR <> 0  
  BEGIN  
   ROLLBACK TRANSACTION  
   SELECT @auxErroImportacao = 'Falha ao atualizar classificação fiscal no item auxiliar!'  
   RAISERROR (@auxErroImportacao, 16, 1)  
   RETURN -1  
  END  
  
  UPDATE tbProduto  
  SET CodigoClassificacaoFiscal = tr.auxPosicaoIPI  
  FROM @TipoRegistro3FT tr  
  WHERE CodigoEmpresa   = @CodigoEmpresa  
  AND CodigoProduto   = tr.auxCodigoProduto  
  
  -- Verifica a ocorrencia de erros  
  IF @@ERROR <> 0  
  BEGIN  
   ROLLBACK TRANSACTION  
   SELECT @auxErroImportacao = 'Falha ao atualizar classificação fiscal no item efetivo!'  
   RAISERROR (@auxErroImportacao, 16, 1)  
   RETURN -1  
  END  
  
  --- Atualiza ClassificacaoFiscal nos Itens Alternativos  
  UPDATE tbProduto  
  SET CodigoClassificacaoFiscal = tr.auxPosicaoIPI  
  FROM @TipoRegistro3Aux tr  
  WHERE CodigoEmpresa   = @CodigoEmpresa  
  AND CodigoProduto   IN ( SELECT CodigoProdutoAlternativo  
        FROM tbProdutoAlternativo (NOLOCK)  
        WHERE CodigoEmpresa  = @CodigoEmpresa  
        AND CodigoProdutoPrincipal = tr.auxCodigoProduto)  
  
  -- Verifica a ocorrencia de erros  
  IF @@ERROR <> 0  
  BEGIN  
   ROLLBACK TRANSACTION  
   SELECT @auxErroImportacao = 'Falha ao atualizar classificação fiscal no item alternativo auxiliar!'  
   RAISERROR (@auxErroImportacao, 16, 1)  
   RETURN -1  
  END  
  
  UPDATE tbProduto  
  SET CodigoClassificacaoFiscal = tr.auxPosicaoIPI  
  FROM @TipoRegistro3FT tr  
  WHERE CodigoEmpresa   = @CodigoEmpresa  
  AND CodigoProduto   IN ( SELECT CodigoProdutoAlternativo  
        FROM tbProdutoAlternativo (NOLOCK)  
        WHERE CodigoEmpresa  = @CodigoEmpresa  
        AND CodigoProdutoPrincipal = tr.auxCodigoProduto)  
  
  -- Verifica a ocorrencia de erros  
  IF @@ERROR <> 0  
  BEGIN  
   ROLLBACK TRANSACTION  
   SELECT @auxErroImportacao = 'Falha ao atualizar classificação fiscal no item alternativo efetivo!'  
   RAISERROR (@auxErroImportacao, 16, 1)  
   RETURN -1  
  END  
 END  
  
 -- Atualiza descricao do Produto Auxiliar  
 UPDATE tbProduto  
 SET  DescricaoProduto  = tr.auxDescricaoProduto  
 FROM @TipoRegistro2Aux tr  
 WHERE CodigoEmpresa  = @CodigoEmpresa  
 AND CodigoProduto  = tr.auxCodigoProduto  
 AND @AtualizarDescrProd = 'V'  
  
 -- Verifica a ocorrencia de erros  
 IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  SELECT @auxErroImportacao = 'Falha ao atualizar descrição do produto auxiliar!'  
  RAISERROR (@auxErroImportacao, 16, 1)  
  RETURN -1  
 END  
  
 -- Atualiza descricao do Produto Efetivo  
 UPDATE tbProduto  
 SET  DescricaoProduto  = tr.auxDescricaoProduto  
FROM @TipoRegistro2FT tr  
 WHERE CodigoEmpresa  = @CodigoEmpresa  
 AND CodigoProduto  = tr.auxCodigoProduto  
 AND @AtualizarDescrProd = 'V'  
  
 -- Verifica a ocorrencia de erros  
 IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  SELECT @auxErroImportacao = 'Falha ao atualizar descrição do produto efetivo!'  
  RAISERROR (@auxErroImportacao, 16, 1)  
  RETURN -1  
 END  
  
 -- Atualiza Classificacao Fiscal  
 IF @NaoAtualizarClassifFiscal = 'F'  
 BEGIN  
  ALTER TABLE tbClassificacaoFiscal DISABLE TRIGGER tnu_DSPa_ClassificacaoFiscal  
  
  UPDATE  tbClassificacaoFiscal  
  SET  PercIPIClassificacaoFiscal  = tr.auxAliquotaIPI,  
   TributaCOFINS   = tr.auxIncideCOFINS,  
   TributaPIS   = tr.auxIncidePIS,  
   CodigoNCM   = tr.auxCodigoNCM  
  FROM @TipoRegistro3FT tr  
  WHERE  CodigoEmpresa   = @CodigoEmpresa  
  --AND CodigoLocal   = @CodigoLocal  
  AND CodigoClassificacaoFiscal  = tr.auxPosicaoIPI  
  
  ALTER TABLE tbClassificacaoFiscal ENABLE TRIGGER tnu_DSPa_ClassificacaoFiscal  
 END  
  
 -- Atualiza a Tabela de Venda  
 UPDATE tbTabelaPreco  
 SET ReajusteEfetuado = 'V',  
 
 ValorTabelaPreco =  CASE when @ChecaParametro = 'F' THEN 
		  CASE WHEN (pft.ProdutoImportado = 'V' OR pft.ProdutoImportadoDireto = 'V' OR pft.NacionalMaior40Import = 'V' OR pft.CodigoTributacaoProduto = 'V')  
		  THEN CASE WHEN COALESCE(mc.IndiceMargemComercializacaoImportado, 0) > 0  
			THEN ROUND(tr.auxPrecoProduto * mc.IndiceMargemComercializacaoImportado, 2)  
			ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoImportado, 2)  
		   END  
		  ELSE CASE WHEN COALESCE(mc.IndiceMargemComercializacao, 0) > 0  
			THEN ROUND(tr.auxPrecoProduto * mc.IndiceMargemComercializacao, 2)  
			ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoVenda, 2)  
		   END  
		 END  
     
     ELSE 
		  CASE WHEN (pft.ProdutoImportado = 'V' OR pft.ProdutoImportadoDireto = 'V' OR pft.NacionalMaior40Import = 'V' OR pft.CodigoTributacaoProduto = 'V')  
		  THEN CASE WHEN COALESCE(mc.IndiceMargemComercializacaoImportadoGO, 0) > 0  
			THEN ROUND(tr.auxPrecoProduto * mc.IndiceMargemComercializacaoImportadoGO, 2)  
			ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoImportado, 2)  
		   END  
		  ELSE CASE WHEN COALESCE(mc.IndiceMargemComercializacaoGO, 0) > 0  
			THEN ROUND(tr.auxPrecoProduto * mc.IndiceMargemComercializacaoGO, 2)  
			ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoVenda, 2)  
		   END  
		 END     
     END
 FROM tbProdutoFT pft  with (nolock)
 INNER JOIN #TEMPTipoRegistro1FT tr  
 ON tr.auxCodigoProduto   = pft.CodigoProduto  
 LEFT JOIN tbMargemComercializacao mc  with (nolock)
 ON mc.CodigoEmpresa   = pft.CodigoEmpresa  
 AND mc.CodigoMargemComercializacao  = pft.CodigoMargemComercializacao  
 WHERE tbTabelaPreco.CodigoEmpresa  = pft.CodigoEmpresa  
 AND tbTabelaPreco.CodigoProduto  = pft.CodigoProduto  
 AND tbTabelaPreco.CodigoEmpresa  = @CodigoEmpresa  
 AND tbTabelaPreco.CodigoTipoTabelaPreco = @CodigoTabelaPreco  
 AND tbTabelaPreco.DataValidadeTabelaPreco = @DataValidadePreco  
 AND pft.CodigoLinhaProduto   BETWEEN @CodigoLinhaInicial AND @CodigoLinhaFinal  
 AND pft.CodigoFonteFornecimento  BETWEEN @CodigoFonteFornecInicial AND @CodigoFonteFornecFinal  
 AND tr.auxPrecoProduto   > 0
 AND (	@NaoAtualizarPrecoMenor = 'F' OR
		ValorTabelaPreco < (	CASE when @ChecaParametro = 'F' THEN 
									  CASE WHEN (pft.ProdutoImportado = 'V' OR pft.ProdutoImportadoDireto = 'V' OR pft.NacionalMaior40Import = 'V' OR pft.CodigoTributacaoProduto = 'V')  
									  THEN CASE WHEN COALESCE(mc.IndiceMargemComercializacaoImportado, 0) > 0  
										THEN ROUND(tr.auxPrecoProduto * mc.IndiceMargemComercializacaoImportado, 2)  
										ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoImportado, 2)  
									   END  
									  ELSE CASE WHEN COALESCE(mc.IndiceMargemComercializacao, 0) > 0  
										THEN ROUND(tr.auxPrecoProduto * mc.IndiceMargemComercializacao, 2)  
										ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoVenda, 2)  
									   END  
									 END  
							     
								 ELSE 
									  CASE WHEN (pft.ProdutoImportado = 'V' OR pft.ProdutoImportadoDireto = 'V' OR pft.NacionalMaior40Import = 'V' OR pft.CodigoTributacaoProduto = 'V')  
									  THEN CASE WHEN COALESCE(mc.IndiceMargemComercializacaoImportadoGO, 0) > 0  
										THEN ROUND(tr.auxPrecoProduto * mc.IndiceMargemComercializacaoImportadoGO, 2)  
										ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoImportado, 2)  
									   END  
									  ELSE CASE WHEN COALESCE(mc.IndiceMargemComercializacaoGO, 0) > 0  
										THEN ROUND(tr.auxPrecoProduto * mc.IndiceMargemComercializacaoGO, 2)  
										ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoVenda, 2)  
									   END  
									 END     
								 END )
	 )
  
 -- Verifica a ocorrencia de erros  
 IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  SELECT @auxErroImportacao = 'Falha ao atualizar preco de venda!'  
  RAISERROR (@auxErroImportacao, 16, 1)  
  RETURN -1  
 END  
 
 -- Insere registros na Tabela de Venda  
 INSERT tbTabelaPreco  
 SELECT @CodigoEmpresa,  
  @CodigoTabelaPreco,  
  tr.auxCodigoProduto,  
  @DataValidadePreco,  
  CASE when @ChecaParametro = 'F' THEN 
	  CASE WHEN (pft.ProdutoImportado = 'V' OR pft.ProdutoImportadoDireto = 'V' OR pft.NacionalMaior40Import = 'V' OR pft.CodigoTributacaoProduto = 'V')  
	   THEN CASE WHEN COALESCE(mc.IndiceMargemComercializacaoImportado, 0) > 0  
		 THEN ROUND(tr.auxPrecoProduto * mc.IndiceMargemComercializacaoImportado, 2)  
		 ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoImportado, 2)  
		END  
	   ELSE CASE WHEN COALESCE(mc.IndiceMargemComercializacao, 0) > 0  
		 THEN ROUND(tr.auxPrecoProduto * mc.IndiceMargemComercializacao, 2)  
		 ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoVenda, 2)  
		END  
	  END  
	ELSE 
	  CASE WHEN (pft.ProdutoImportado = 'V' OR pft.ProdutoImportadoDireto = 'V' OR pft.NacionalMaior40Import = 'V' OR pft.CodigoTributacaoProduto = 'V')  
	   THEN CASE WHEN COALESCE(mc.IndiceMargemComercializacaoImportadoGO, 0) > 0  
		 THEN ROUND(tr.auxPrecoProduto * mc.IndiceMargemComercializacaoImportadoGO, 2)  
		 ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoImportado, 2)  
		END  
	   ELSE CASE WHEN COALESCE(mc.IndiceMargemComercializacaoGO, 0) > 0  
		 THEN ROUND(tr.auxPrecoProduto * mc.IndiceMargemComercializacaoGO, 2)  
		 ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoVenda, 2)  
		END  
	  END  
	END,	
  'V',  
  GETDATE()  
FROM tbProdutoFT pft (NOLOCK)  
INNER JOIN #TEMPTipoRegistro1FT tr  
ON tr.auxCodigoProduto   = pft.CodigoProduto  
LEFT JOIN tbMargemComercializacao mc (NOLOCK)  
ON mc.CodigoEmpresa   = pft.CodigoEmpresa  
AND mc.CodigoMargemComercializacao  = pft.CodigoMargemComercializacao  
WHERE pft.CodigoEmpresa   = @CodigoEmpresa  
AND pft.CodigoLinhaProduto   BETWEEN @CodigoLinhaInicial AND @CodigoLinhaFinal  
AND pft.CodigoFonteFornecimento  BETWEEN @CodigoFonteFornecInicial AND @CodigoFonteFornecFinal  
AND tr.auxPrecoProduto   > 0  
AND (	@NaoAtualizarPrecoMenor = 'F' OR
		(	SELECT COALESCE(auxTPUltimoValorTabelaPreco,0)
			FROM #TEMPTabelaPrecoAuxiliar tpAux
			WHERE tpAux.auxTPCodigoTipoTabelaPreco = @CodigoTabelaPreco  
			AND tpAux.auxTPCodigoProduto  = tr.auxCodigoProduto
		) < (	CASE when @ChecaParametro = 'F' THEN 
					CASE WHEN (pft.ProdutoImportado = 'V' OR pft.ProdutoImportadoDireto = 'V' OR pft.NacionalMaior40Import = 'V' OR pft.CodigoTributacaoProduto = 'V')  
					THEN CASE WHEN COALESCE(mc.IndiceMargemComercializacaoImportado, 0) > 0  
						THEN ROUND(tr.auxPrecoProduto * mc.IndiceMargemComercializacaoImportado, 2)  
						ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoImportado, 2)  
						END  
					ELSE CASE WHEN COALESCE(mc.IndiceMargemComercializacao, 0) > 0  
						THEN ROUND(tr.auxPrecoProduto * mc.IndiceMargemComercializacao, 2)  
						ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoVenda, 2)  
						END  
					END  
					ELSE 
					CASE WHEN (pft.ProdutoImportado = 'V' OR pft.ProdutoImportadoDireto = 'V' OR pft.NacionalMaior40Import = 'V' OR pft.CodigoTributacaoProduto = 'V')  
					THEN CASE WHEN COALESCE(mc.IndiceMargemComercializacaoImportadoGO, 0) > 0  
						THEN ROUND(tr.auxPrecoProduto * mc.IndiceMargemComercializacaoImportadoGO, 2)  
						ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoImportado, 2)  
						END  
					ELSE CASE WHEN COALESCE(mc.IndiceMargemComercializacaoGO, 0) > 0  
						THEN ROUND(tr.auxPrecoProduto * mc.IndiceMargemComercializacaoGO, 2)  
						ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoVenda, 2)  
						END  
					END  
				END
			)
	)
AND NOT EXISTS (SELECT 1  
	FROM tbTabelaPreco tp1 (NOLOCK)  
	WHERE tp1.CodigoEmpresa  = @CodigoEmpresa  
	AND tp1.CodigoTipoTabelaPreco = @CodigoTabelaPreco  
	AND tp1.CodigoProduto  = tr.auxCodigoProduto  
	AND tp1.DataValidadeTabelaPreco = @DataValidadePreco)

  
 -- Verifica a ocorrencia de erros  
 IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  SELECT @auxErroImportacao = 'Falha ao incluir preco de venda!'  
  RAISERROR (@auxErroImportacao, 16, 1)  
  RETURN -1  
 END  
  
 -- Atualiza a Tabela de Promocao  
	 UPDATE tbTabelaPreco  
	 SET ReajusteEfetuado = 'V',  
	  ValorTabelaPreco = ROUND(tr.auxPrecoProduto * @IndexadorPrecoPromocao, 2)  
	 FROM tbProdutoFT pft (NOLOCK)  
	 INNER JOIN #TEMPTipoRegistro1FT tr  
	 ON tr.auxCodigoProduto   = pft.CodigoProduto  
	 LEFT JOIN tbMargemComercializacao mc (NOLOCK)  
	 ON mc.CodigoEmpresa   = pft.CodigoEmpresa  
	 AND mc.CodigoMargemComercializacao  = pft.CodigoMargemComercializacao  
	 WHERE tbTabelaPreco.CodigoEmpresa  = pft.CodigoEmpresa  
	 AND tbTabelaPreco.CodigoProduto  = pft.CodigoProduto  
	 AND tbTabelaPreco.CodigoEmpresa  = @CodigoEmpresa  
	 AND tbTabelaPreco.CodigoTipoTabelaPreco = @CodigoTabelaPromocao  
	 AND tbTabelaPreco.DataValidadeTabelaPreco = @DataValidadePreco  
	 AND pft.CodigoLinhaProduto   BETWEEN @CodigoLinhaInicial AND @CodigoLinhaFinal  
	 AND pft.CodigoFonteFornecimento  BETWEEN @CodigoFonteFornecInicial AND @CodigoFonteFornecFinal  
	 AND tr.auxPrecoProduto   > 0  
	 AND @IndexadorPrecoPromocao   > 0  
	 AND (	@NaoAtualizarPrecoMenor = 'F' OR
			ValorTabelaPreco < ROUND(tr.auxPrecoProduto * @IndexadorPrecoPromocao, 2)
		 )
  
 -- Verifica a ocorrencia de erros  
 IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  SELECT @auxErroImportacao = 'Falha ao atualizar preco de promocao!'  
  RAISERROR (@auxErroImportacao, 16, 1)  
  RETURN -1  
 END  
  
  
  
 -- Insere registros na Tabela de Promocao  
 INSERT tbTabelaPreco  
 SELECT @CodigoEmpresa,  
  @CodigoTabelaPromocao,  
  tr.auxCodigoProduto,  
  @DataValidadePreco,  
  ROUND(tr.auxPrecoProduto * @IndexadorPrecoPromocao, 2),  
  'V',  
  GETDATE()  
FROM tbProdutoFT pft (NOLOCK)  
INNER JOIN #TEMPTipoRegistro1FT tr  
ON tr.auxCodigoProduto   = pft.CodigoProduto  
LEFT JOIN tbMargemComercializacao mc (NOLOCK)  
ON mc.CodigoEmpresa   = pft.CodigoEmpresa  
AND mc.CodigoMargemComercializacao  = pft.CodigoMargemComercializacao  
WHERE pft.CodigoEmpresa   = @CodigoEmpresa  
AND pft.CodigoLinhaProduto   BETWEEN @CodigoLinhaInicial AND @CodigoLinhaFinal  
AND pft.CodigoFonteFornecimento  BETWEEN @CodigoFonteFornecInicial AND @CodigoFonteFornecFinal  
AND tr.auxPrecoProduto   > 0  
AND @IndexadorPrecoPromocao   > 0  
AND (	@NaoAtualizarPrecoMenor = 'F' OR
		(	SELECT COALESCE(auxTPUltimoValorTabelaPreco,0)
			FROM #TEMPTabelaPrecoAuxiliar tpAux
			WHERE tpAux.auxTPCodigoTipoTabelaPreco = @CodigoTabelaPromocao  
			AND tpAux.auxTPCodigoProduto  = tr.auxCodigoProduto
		) < ROUND(tr.auxPrecoProduto * @IndexadorPrecoPromocao, 2)
	)
AND NOT EXISTS (SELECT 1  
	FROM tbTabelaPreco tp1 (NOLOCK)  
	WHERE tp1.CodigoEmpresa  = @CodigoEmpresa  
	AND tp1.CodigoTipoTabelaPreco = @CodigoTabelaPromocao  
	AND tp1.CodigoProduto  = tr.auxCodigoProduto  
	AND tp1.DataValidadeTabelaPreco = @DataValidadePreco)  

   -- Verifica a ocorrencia de erros  
 IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  SELECT @auxErroImportacao = 'Falha ao incluir preco de promocao!'  
  RAISERROR (@auxErroImportacao, 16, 1)  
  RETURN -1  
 END  
 -- Atualiza a Tabela de Garantia  
 UPDATE tbTabelaPreco  
 SET ReajusteEfetuado = 'V',  
  ValorTabelaPreco = CASE WHEN (pft.ProdutoImportado = 'V' OR pft.ProdutoImportadoDireto = 'V' OR pft.NacionalMaior40Import = 'V' OR pft.CodigoTributacaoProduto = 'V')  
      THEN ROUND(tr.auxPrecoProduto * @IndexadorPrecoImportadoGarantia, 2)  
      ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoGarantia, 2)  
     END  
 FROM tbProdutoFT pft (NOLOCK)  
 INNER JOIN #TEMPTipoRegistro1FT tr  
 ON tr.auxCodigoProduto   = pft.CodigoProduto  
 LEFT JOIN tbMargemComercializacao mc (NOLOCK)  
 ON mc.CodigoEmpresa   = pft.CodigoEmpresa  
 AND mc.CodigoMargemComercializacao  = pft.CodigoMargemComercializacao  
 WHERE tbTabelaPreco.CodigoEmpresa  = pft.CodigoEmpresa  
 AND tbTabelaPreco.CodigoProduto  = pft.CodigoProduto  
 AND tbTabelaPreco.CodigoEmpresa  = @CodigoEmpresa  
 AND tbTabelaPreco.CodigoTipoTabelaPreco = @CodigoTabelaGarantia  
 AND tbTabelaPreco.DataValidadeTabelaPreco = @DataValidadePreco  
 AND pft.CodigoLinhaProduto   BETWEEN @CodigoLinhaInicial AND @CodigoLinhaFinal  
 AND pft.CodigoFonteFornecimento  BETWEEN @CodigoFonteFornecInicial AND @CodigoFonteFornecFinal  
 AND tr.auxPrecoProduto   > 0  
 AND @IndexadorPrecoGarantia   > 0  
 AND (	@NaoAtualizarPrecoMenor = 'F' OR
		ValorTabelaPreco < (	CASE WHEN (pft.ProdutoImportado = 'V' OR pft.ProdutoImportadoDireto = 'V' OR pft.NacionalMaior40Import = 'V' OR pft.CodigoTributacaoProduto = 'V')  
								THEN ROUND(tr.auxPrecoProduto * @IndexadorPrecoImportadoGarantia, 2)  
								ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoGarantia, 2)  
								END
							)
	 )

 -- Verifica a ocorrencia de erros  
 IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  SELECT @auxErroImportacao = 'Falha ao atualizar preco de garantia!'  
  RAISERROR (@auxErroImportacao, 16, 1)  
  RETURN -1  
 END  
 -- Insere registros na Tabela de Garantia  
 INSERT tbTabelaPreco  
 SELECT @CodigoEmpresa,  
  @CodigoTabelaGarantia,  
  tr.auxCodigoProduto,  
  @DataValidadePreco,  
  CASE WHEN (pft.ProdutoImportado = 'V' OR pft.ProdutoImportadoDireto = 'V' OR pft.NacionalMaior40Import = 'V' OR pft.CodigoTributacaoProduto = 'V')  
   THEN ROUND(tr.auxPrecoProduto * @IndexadorPrecoImportadoGarantia, 2)  
   ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoGarantia, 2)  
  END,  
  'V',  
  GETDATE()  
FROM tbProdutoFT pft (NOLOCK)  
INNER JOIN #TEMPTipoRegistro1FT tr  
ON tr.auxCodigoProduto   = pft.CodigoProduto  
LEFT JOIN tbMargemComercializacao mc (NOLOCK)  
ON mc.CodigoEmpresa   = pft.CodigoEmpresa  
AND mc.CodigoMargemComercializacao  = pft.CodigoMargemComercializacao  
WHERE pft.CodigoEmpresa   = @CodigoEmpresa  
AND pft.CodigoLinhaProduto   BETWEEN @CodigoLinhaInicial AND @CodigoLinhaFinal  
AND pft.CodigoFonteFornecimento  BETWEEN @CodigoFonteFornecInicial AND @CodigoFonteFornecFinal  
AND tr.auxPrecoProduto   > 0  
AND @IndexadorPrecoGarantia   > 0
AND (	@NaoAtualizarPrecoMenor = 'F' OR
		(	SELECT COALESCE(auxTPUltimoValorTabelaPreco,0)
			FROM #TEMPTabelaPrecoAuxiliar tpAux
			WHERE tpAux.auxTPCodigoTipoTabelaPreco = @CodigoTabelaGarantia  
			AND tpAux.auxTPCodigoProduto  = tr.auxCodigoProduto
		) < (	CASE WHEN (pft.ProdutoImportado = 'V' OR pft.ProdutoImportadoDireto = 'V' OR pft.NacionalMaior40Import = 'V' OR pft.CodigoTributacaoProduto = 'V')  
				   THEN ROUND(tr.auxPrecoProduto * @IndexadorPrecoImportadoGarantia, 2)  
				   ELSE ROUND(tr.auxPrecoProduto * @IndexadorPrecoGarantia, 2)  
				  END
			)
	 )
AND NOT EXISTS (SELECT 1  
	FROM tbTabelaPreco tp1 (NOLOCK)  
	WHERE tp1.CodigoEmpresa  = @CodigoEmpresa  
	AND tp1.CodigoTipoTabelaPreco = @CodigoTabelaGarantia  
	AND tp1.CodigoProduto  = pft.CodigoProduto  
	AND tp1.DataValidadeTabelaPreco = @DataValidadePreco)  
  
 -- Verifica a ocorrencia de erros  
 IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  SELECT @auxErroImportacao = 'Falha ao incluir preco de garantia!'  
  RAISERROR (@auxErroImportacao, 16, 1)  
  RETURN -1  
 END  
  
 ---------- Efetiva transacao ------------------------------------------------------  
 COMMIT TRANSACTION  
 -----------------------------------------------------------------------------------  

 -----------------------------------------------------------------  
 -- Tipo de Registro 1  
 -----------------------------------------------------------------  
 IF (@Relatorio = 'V')  
 BEGIN  
  INSERT rtListaCaptacaoPreco  
  SELECT @NomeUsuario  
   , @NomeMaquina  
   , dbo.fnEditarCodigoProdutoMB(ft.CodigoProduto)  
   , 1  
   , COALESCE(tr2.auxDescricaoProduto, '@')  
   , ( SELECT ValorTabelaPreco  
    FROM tbTabelaPreco tp (NOLOCK)  
    WHERE CodigoEmpresa  = @CodigoEmpresa  
    AND CodigoProduto  = ft.CodigoProduto  
    AND CodigoTipoTabelaPreco = @CodigoTabelaPreco  
    AND DataValidadeTabelaPreco = ( SELECT MIN(DataValidadeTabelaPreco)  
         FROM tbTabelaPreco tp1 (NOLOCK)  
         WHERE tp1.CodigoEmpresa  = tp.CodigoEmpresa  
         AND tp1.CodigoProduto  = tp.CodigoProduto  
         AND tp1.CodigoTipoTabelaPreco = tp.CodigoTipoTabelaPreco  
         AND tp1.DataValidadeTabelaPreco >= @DataSistema))  
   , COALESCE(tr1.auxPrecoProduto, 0)  
   , ( SELECT ValorTabelaPreco  
    FROM tbTabelaPreco tp (NOLOCK)  
    WHERE CodigoEmpresa  = @CodigoEmpresa  
    AND CodigoProduto  = ft.CodigoProduto  
    AND CodigoTipoTabelaPreco = @CodigoTabelaPreco  
    AND DataValidadeTabelaPreco = @DataValidadePreco)  
   , COALESCE(tr1.auxCodMargemComercializacao, '')  
   , COALESCE(tr3.auxPeso, 0)  
   , COALESCE(tr3.auxEmbalagem, 0)  
  FROM tbProdutoFT ft   with (nolock)
  LEFT JOIN #TEMPTipoRegistro1FT tr1  
  ON tr1.auxCodigoProduto = ft.CodigoProduto  
  LEFT JOIN @TipoRegistro2FT tr2  
  ON tr2.auxCodigoProduto = ft.CodigoProduto  
  LEFT JOIN @TipoRegistro3FT tr3  
  ON tr3.auxCodigoProduto = ft.CodigoProduto  
  WHERE CodigoEmpresa  = @CodigoEmpresa  
  AND CodigoLinhaProduto BETWEEN @CodigoLinhaInicial AND @CodigoLinhaFinal  
  AND CodigoFonteFornecimento BETWEEN @CodigoFonteFornecInicial AND @CodigoFonteFornecFinal  
  
 END   
 
 -- Execucao OK  
RETURN 0  
  
  GRANT EXECUTE ON dbo.whGerarTabelaPreco TO SQLUsers

