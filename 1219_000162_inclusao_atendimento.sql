UPDATE tb_atendimento
   SET situacaoAtendimento = 2,
   fk_espelho = 727002,
   data_ultima_alteracao = GETDATE(),
   fk_usuario_ultima_alteracao = 1,
   sql_update = ISNULL(sql_update,'')+'1219-000162'
WHERE id = 19806119

GO

DECLARE @RC int
DECLARE @idEspelho bigint
DECLARE @idAtendimento bigint = 19806119
DECLARE @idCartaDeGlosa bigint
DECLARE @usuario bigint = 1

-- TODO: Defina valores de parâmetros aqui.

EXECUTE @RC = [dbo].[gerarPagamentoProcedimentoPorEspelho] 
   @idEspelho
  ,@idAtendimento
  ,@idCartaDeGlosa
  ,@usuario
GO