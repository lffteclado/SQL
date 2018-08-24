IF object_id('tnu_DSPa_ESocial_TomadorServico') IS NOT NULL
	DROP TRIGGER tnu_DSPa_ESocial_TomadorServico
GO
CREATE TRIGGER dbo.tnu_DSPa_ESocial_TomadorServico ON tbTomadorServico
/*INICIO_CABEC_PROC
-----------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil
 PROJETO......: FP
 AUTOR........: Edson Marson
 DATA.........: 27/11/2013
 UTILIZADO EM : tbTomadorServico
 OBJETIVO.....: Gravar no Log do eSocial alteraçoes feitas na tabela tbTomadorServico
				Ticket 151764/2013 - FM 12633/2013

 ALTERAÇÃO....: Edson Marson - 20/12/2013
 OBJETIVO.....: Campo novo na tabela tbLogEventoTrabalhistaESocial.
				Ticket 151764/2013 - FM 12802/2013

 ALTERACAO....: Edson Marson - 16/01/2014
 OBJETIVO.....: Tratar Ferias como Afastamento Temporario(S-2320).
 				Ticket 151764/2013 - FM 12876/2014

 ALTERACAO....: Edson Marson - 30/09/2017
 OBJETIVO.....: Adequação da legislação do eSocial versao 2.4 Etapa 4 
                Ticket 257863/2017 - FM 16360/2017	

 ALTERACAO....: Edson Marson - 05/12/2017
 OBJETIVO.....: Os arquivos do eSocial serão gerados em fases diferentes, conforme legislação.
 				Ticket 270511/2017

 ALTERACAO....: Edson Marson - 11/12/2017
 OBJETIVO.....: Foi considerado invertido a comparação de datas para o início do eSocial.
 				Ticket 270977/2017

 ALTERACAO....: Edson Marson - 19/02/2018
 OBJETIVO.....: Melhoria nas telas de geração dos XMLs.
 				Ticket 273014/2018
-----------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/ 
WITH ENCRYPTION 
FOR UPDATE AS 
SET NOCOUNT ON
IF EXISTS (SELECT 1 FROM inserted i 
			INNER JOIN deleted d 
			ON  d.CodigoEmpresa = i.CodigoEmpresa
			AND d.CodigoLocal   = i.CodigoLocal
			AND d.CodigoCliFor  = i.CodigoCliFor
			WHERE i.CodigoCliFor					!= d.CodigoCliFor
			OR    i.DataIniValidade					!= d.DataIniValidade
			OR    i.DataFimValidade					!= d.DataFimValidade
			OR    i.TipoLotacao						!= d.TipoLotacao
			OR    i.TipoInscricaoESocial			!= d.TipoInscricaoESocial
			OR    i.NumeroInscricaoESocial			!= d.NumeroInscricaoESocial
			OR    i.CodigoFpasESocial				!= d.CodigoFpasESocial			
			OR    i.CodigoTerceirosESocial			!= d.CodigoTerceirosESocial			
			OR    i.TipoInscricaoContratante		!= d.TipoInscricaoContratante			
			OR    i.NumeroInscricaoContratante		!= d.NumeroInscricaoContratante			
			OR    i.TipoInscricaoProprietario		!= d.TipoInscricaoProprietario			
			OR    i.NumeroInscricaoProprietario		!= d.NumeroInscricaoProprietario)
BEGIN
	DECLARE @ESocialIniciado CHAR(1)
	DECLARE @Usuario		 CHAR(30)
	DECLARE @Computador		 CHAR(15)
	DECLARE @LocalMatriz	 NUMERIC(4)

	SELECT @ESocialIniciado = (SELECT 'V' AS ESocialIniciado FROM tbEmpresaFP a, inserted i WHERE a.CodigoEmpresa = i.CodigoEmpresa AND a.DataESocialIniciado <= GETDATE())

	IF COALESCE(@ESocialIniciado,'F') = 'V'
	BEGIN
		SELECT @Usuario = (	CASE WHEN RTRIM(LTRIM(UPPER((SELECT nt_username FROM master.dbo.sysprocesses WHERE spid = @@Spid)))) <> '' THEN
								LEFT(RTRIM(LTRIM(UPPER((SELECT nt_username FROM master.dbo.sysprocesses WHERE spid = @@Spid)))),30)
							ELSE
								RTRIM(LTRIM(UPPER((SELECT loginame FROM master.dbo.sysprocesses WHERE spid = @@Spid))))
							END )
		SELECT @Computador = HOST_NAME()
		
		SELECT @LocalMatriz = (SELECT a.CodigoLocal FROM tbLocalFP a, inserted i WHERE a.CodigoEmpresa = i.CodigoEmpresa AND a.Matriz = 'V')

		-- Insere Log Alteracao se alterou qualquer campo acima 
		INSERT tbLogCargaInicialESocial
		SELECT	i.CodigoEmpresa,
				'S-1020' AS CodigoArquivo,
				'A' AS TipoOperacaoArquivo,
				GETDATE() AS DataHoraArquivo,
				i.CodigoLocal AS CodigoLocal,
				'ALTERANDO TOMADOR SERVICO ' + CONVERT(VARCHAR(15),i.CodigoCliFor) AS DescricaoOperacaoArquivo,
				@Usuario AS UsuarioArquivo, 
				@Computador AS ComputadorArquivo,
				'F' AS GeradoXML,
				NULL AS DataHoraXML,
				NULL AS UsuarioGeradoXML, 
				NULL AS ComputadorGeradoXML,
				'F' AS ExcluidoLog,
				NULL AS DataExcluidoLog,
				NULL AS UsuarioExcluidoLog, 
				NULL AS ComputadorExcluidoLog,
				'F' AS RecuperadoLog,
				NULL AS DataRecuperadoLog,
				NULL AS UsuarioRecuperadoLog, 
				NULL AS ComputadorRecuperadoLog,
				@LocalMatriz AS CodigoLocalMatriz,
				i.CodigoCliFor AS CodigoEvento,
				'F' AS Producao
		FROM	inserted i
	END
END
