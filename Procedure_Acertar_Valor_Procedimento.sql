DECLARE @RC int
DECLARE @idEspelho bigint = 772967
DECLARE @idAtendimento bigint
DECLARE @idCartaDeGlosa bigint
DECLARE @usuario bigint = 1

-- TODO: Defina valores de parāmetros aqui.

EXECUTE @RC = [dbo].[gerarPagamentoProcedimentoPorEspelho] 
   @idEspelho
  ,@idAtendimento
  ,@idCartaDeGlosa
  ,@usuario
GO


