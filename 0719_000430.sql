update tb_espelho set data_cancelamento = null, motivo_cancelamento = null, sql_update = ISNULL(sql_update, '')+'#0719-000430'
 where id = 624744 and fk_entidade_convenio = 2876

 GO

 update tb_atendimento set situacaoAtendimento = 1, fk_espelho = 624744, sql_update = ISNULL(sql_update, '')+'#0719-000430' where id in(
 18973792
,18973800
,18973805
,18973821
,18973829
,18973884
,18973898
,18973911
,18973918
,18973929
,18973948
,18973961
,18973975
,18973994
,18974010
,18974039
,18974055
,18974063
,18974081
,18974088
,18974134
,18974144
,18974155
,18974178
,18974187
,18974198
,18974219
,18974230
,18974235
,18974244
,18974388
,18974398
,18974409
,18974435
,18974448
,18974454
,18974464
,18974470
,18974477
,18974481
,18974493
,18974502
,18974509
,18974526
,18974536
,18974547)

GO

DECLARE @RC int
DECLARE @idEspelho bigint = 624744
DECLARE @idAtendimento bigint
DECLARE @idCartaDeGlosa bigint
DECLARE @usuario bigint = 1

EXECUTE @RC = [dbo].[gerarPagamentoProcedimentoPorEspelho] 
   @idEspelho
  ,@idAtendimento
  ,@idCartaDeGlosa
  ,@usuario
GO