sp_helptext whPCodMunicipio


Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.whPCodMunicipio
/*INICIO_CABEC_PROC
--------------------------------------------------------------------------------
 EMPRESA......: T-Systems do Brasil Ltda.
 PROJETO......: FP - Folha de Pagamento
 AUTOR........: Edson Marson
 DATA.........: 07/02/2014
 UTILIZADO EM.: clsCEP.cls
 OBJETIVO.....: Pesquisar municipio por codigo. 
				Ticket 151764/2013 - FM 12950/2013

 ALTERAÇÃO....: Edson Marson - 11/03/2014
 OBJETIVO.....: Erro na execução do Grant da proc. 
				Sem Ticket - FM 13109/2014

 ALTERAÇÃO....: Edson Marson - 26/08/2014
 OBJETIVO.....: Buscar o codigo municipio da tbCEP. 
				Ticket 191501/2014 - FM 13740/2014

 whPCodMunicipio 1200013
--------------------------------------------------------------------------------
FIM_CABEC_PROC*/

@NumeroMunicipio	NUMERIC(8)

AS
SET NOCOUNT ON

   SELECT tbCEP.NumeroMunicipio, 
		  tbCEP.Cidade AS Municipio, 
		  tbCEP.UnidadeFederacao AS UF
   FROM tbCEP (NOLOCK)
   LEFT JOIN tbMunicipio (NOLOCK)
   ON	tbMunicipio.UF = tbCEP.UnidadeFederacao
   AND	tbMunicipio.Municipio = tbCEP.Cidade
   WHERE tbCEP.NumeroMunicipio = @NumeroMunicipio
   GROUP BY tbCEP.NumeroMunicipio, tbCEP.Cidade, tbCEP.UnidadeFederacao

SET NOCOUNT OFF


