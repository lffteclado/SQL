IF OBJECT_ID('tni_DSPa_ESocial_TomadorServico') IS NOT NULL
	DROP TRIGGER tni_DSPa_ESocial_TomadorServico
GO
CREATE TRIGGER dbo.tni_DSPa_ESocial_TomadorServico ON tbTomadorServico
/*INICIO_CABEC_PROC
------------------------------------------------------------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda.
 PROJETO......: Folha de Pagamento
 AUTOR........: Edson Marson
 DATA.........: 02/12/2013
 UTILIZADO EM : tni_DSPa_ESocial_TomadorServico
 OBJETIVO.....: Ao inserir registro na tbTomadorServico dispara trigger para criar eventos do eSocial na tbLogCargaInicialESocial.
				Ticket 151764/2013 - FM 12733/2013

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
------------------------------------------------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/
WITH ENCRYPTION
FOR INSERT AS
SET NOCOUNT ON
BEGIN
	DECLARE	@ErrMsg			 VARCHAR(255)
	DECLARE @ESocialIniciado CHAR(1)
	DECLARE @Usuario		 CHAR(30)
	DECLARE @Computador		 CHAR(15)
	DECLARE @LocalMatriz	 NUMERIC(4)

	SELECT @ESocialIniciado = (SELECT a.ESocialIniciado FROM tbEmpresaFP a, inserted i WHERE a.CodigoEmpresa = i.CodigoEmpresa AND a.DataESocialIniciado <= GETDATE())

	IF COALESCE(@ESocialIniciado,'F') = 'V'
	BEGIN
		SELECT @Usuario = (	CASE WHEN RTRIM(LTRIM(UPPER((SELECT nt_username FROM master.dbo.sysprocesses WHERE spid = @@Spid)))) <> '' THEN
								LEFT(RTRIM(LTRIM(UPPER((SELECT nt_username FROM master.dbo.sysprocesses WHERE spid = @@Spid)))),30)
							ELSE
								RTRIM(LTRIM(UPPER((SELECT loginame FROM master.dbo.sysprocesses WHERE spid = @@Spid))))
							END )
		SELECT @Computador = HOST_NAME()
		
		SELECT @LocalMatriz = (SELECT a.CodigoLocal FROM tbLocalFP a, inserted i WHERE a.CodigoEmpresa = i.CodigoEmpresa AND a.Matriz = 'V')

		-- Insere Log Inclusao 
		INSERT tbLogCargaInicialESocial
		SELECT	i.CodigoEmpresa,
				'S-1020' AS CodigoArquivo,
				'I' AS TipoOperacaoArquivo,
				GETDATE() AS DataHoraArquivo,
				i.CodigoLocal AS CodigoLocal,
				'INCLUINDO TOMADOR SERVIÇO ' + CONVERT(VARCHAR(15),i.CodigoCliFor) AS DescricaoOperacaoArquivo,
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
		-- exclui log 
		UPDATE 	tbLogCargaInicialESocial
		SET  	tbLogCargaInicialESocial.ExcluidoLog				= 'V', 
				tbLogCargaInicialESocial.DataExcluidoLog			= GETDATE(),
				tbLogCargaInicialESocial.UsuarioExcluidoLog			= 'tni_DSPa_ESocial_TomadorServico', 
				tbLogCargaInicialESocial.ComputadorExcluidoLog		= @Computador, 
				tbLogCargaInicialESocial.RecuperadoLog				= 'F', 
				tbLogCargaInicialESocial.DataRecuperadoLog			= NULL,
				tbLogCargaInicialESocial.UsuarioRecuperadoLog		= NULL, 
				tbLogCargaInicialESocial.ComputadorRecuperadoLog	= NULL 
		FROM	inserted i
		WHERE   i.CodigoEmpresa 								= tbLogCargaInicialESocial.CodigoEmpresa
		AND     i.CodigoLocal									= tbLogCargaInicialESocial.CodigoLocal
		AND  	i.CodigoCliFor									= tbLogCargaInicialESocial.CodigoEvento
		AND     tbLogCargaInicialESocial.CodigoArquivo			= 'S-1020'
		AND     tbLogCargaInicialESocial.TipoOperacaoArquivo	IN ('E','A')
		AND		tbLogCargaInicialESocial.ExcluidoLog			= 'F'
		AND		tbLogCargaInicialESocial.GeradoXML				= 'F'
		-- Verifica a ocorrencia de erros
		IF (@@ERROR <> 0) OR (@ErrMsg <> 0)
		BEGIN
			SELECT @ErrMsg = 'Inclusão não permitida.'
			GOTO ERROR
		END
	END
	RETURN
	--Controle de Erros
	ERROR:
		ROLLBACK TRANSACTION
		RAISERROR (@ErrMsg, 16, 4)
END
