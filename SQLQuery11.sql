Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.whCalculaHorasFAMOPerdida

/*INICIO_CABEC_PROC
------------------------------------------------------------------------------------------------
 EMPRESA......: CDC - Consulters/Humaita
 PROJETO......: OS
 AUTOR........: Carlos JSC
 DATA.........: 03/07/2000
 UTILIZADO EM : FAMO
 OBJETIVO.....: Calculo de Horas Perdidas

 ALTERACAO....: Edvaldo Ragassi - 31/10/2002
 OBJETIVO.....: Inclusao de INNER JOIN

 ALTERACAO....: Edvaldo Ragassi - 10/08/2004
 OBJETIVO.....: Reestruturacao de CIT
------------------------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@CodigoEmpresa		dtInteiro04,
@CodigoLocal		dtInteiro04,
@CodigoColaboradorOS	dtInteiro06,
@TipoHoraFAMO		dtInteiro02,
@DataInicial		datetime,
@DataFinal		datetime,
@CITInicial		char(04),
@CITFinal		char(04), 
@CCustoInicial		dtInteiro08, 
@CCustoFinal		dtInteiro08 

AS

SET NOCOUNT ON

SELECT  sum(tbHorasColaboradorFAMOOS.TotalHorasFAMOS) HorasFAMO 

FROM 	tbHorasColaboradorFAMOOS  	(NOLOCK)

INNER JOIN tbCIT			(NOLOCK)
ON	tbHorasColaboradorFAMOOS.CodigoEmpresa 	= tbCIT.CodigoEmpresa
AND	tbHorasColaboradorFAMOOS.CodigoCIT 	= tbCIT.CodigoCIT

WHERE 	tbHorasColaboradorFAMOOS.CodigoEmpresa 		= @CodigoEmpresa			AND
	tbHorasColaboradorFAMOOS.CodigoLocal 		= @CodigoLocal	 			AND
	tbHorasColaboradorFAMOOS.CodigoColaboradorOS 	= @CodigoColaboradorOS			AND
	tbHorasColaboradorFAMOOS.DataReferenciaFAMOOS 	BETWEEN @DataInicial   AND @DataFinal 	AND
	tbHorasColaboradorFAMOOS.CodigoCIT 		BETWEEN @CITInicial    AND @CITFinal 	AND 
	tbHorasColaboradorFAMOOS.CentroCusto 		BETWEEN @CCustoInicial AND @CCustoFinal AND
	tbCIT.TipoHoraFAMO 				= @TipoHoraFAMO

SET NOCOUNT OFF


