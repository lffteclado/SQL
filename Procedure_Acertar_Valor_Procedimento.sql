DECLARE @RC int
DECLARE @idEspelho bigint
DECLARE @idAtendimento bigint = 28623960
DECLARE @idCartaDeGlosa bigint
DECLARE @usuario bigint = 1

-- TODO: Defina valores de parāmetros aqui.

EXECUTE @RC = [dbo].[gerarPagamentoProcedimentoPorEspelho] 
   @idEspelho
  ,@idAtendimento
  ,@idCartaDeGlosa
  ,@usuario
GO


