DECLARE @RC int
DECLARE @idEspelho bigint
DECLARE @idAtendimento bigint
DECLARE @idCartaDeGlosa bigint = 241082
DECLARE @usuario bigint = 1

-- TODO: Defina valores de par�metros aqui.

EXECUTE @RC = [dbo].[gerarPagamentoProcedimentoPorEspelho] 
   @idEspelho
  ,@idAtendimento
  ,@idCartaDeGlosa
  ,@usuario
GO


