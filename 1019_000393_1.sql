GO

INSERT INTO [dbo].[tb_item_despesa_integracao]
           ([pk_importacao]
           ,[resolveu_dependencia]
           ,[codigo]
           ,[consulta]
           ,[descricao]
           ,[id_item_despesa]
           ,[situacao]
           ,[tipo_item_despesa]
           ,[tipo_procedimento]
           ,[sql_update]
           ,[id_procedimento_integracao])
     VALUES
           (null
           ,null
           ,'161161'
           ,null
           ,'Lançamento Eventual'
           ,278970
           ,1
           ,0
           ,null
           ,'1019-000393'
           ,null)
GO

update tb_procedimento_integracao set codigo_procedimento_tuss = 161161,
                                      fk_item_despesa = (select id from tb_item_despesa_integracao where codigo = '161161' and sql_update = '1019-000393'),
									  item_despesa_inconsitente = null,
									  tuss = 0,
									  sql_update = ISNULL(sql_update,'')+'1019-000393'
where fk_integracao in (89860, 89862, 89863) and fk_item_despesa is null


