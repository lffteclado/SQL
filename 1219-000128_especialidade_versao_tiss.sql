INSERT INTO [dbo].[tb_tabela_tiss_versao_codigo]
           ([pk_importacao]
           ,[resolveu_dependencia]
           ,[data_ultima_alteracao]
           ,[registro_ativo]
           ,[codigo]
           ,[versao_tiss]
           ,[fk_usuario_ultima_alteracao]
           ,[fk_tabela_tiss]
           ,[codigo_ans_duplicado]
           ,[sql_update])
          (           
SELECT distinct NULL AS pk_importacao,
	   NULL AS resolveu_dependencia,
	   GETDATE() AS data_ultima_alteracao,
	   1 AS registro_ativo,
	   versaoCodigo.codigo AS codigo,
	   5 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   tiss.id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
from tb_tabela_tiss_versao_codigo versaoCodigo
inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
where versaoCodigo.fk_tabela_tiss not in(
	select tiss.id from tb_tabela_tiss_versao_codigo versaoCodigo
	inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
	 where versaoCodigo.versao_tiss = 5 and tiss.discriminator = 'especialidade'
) and tiss.discriminator = 'especialidade'
)

GO

INSERT INTO [dbo].[tb_tabela_tiss_versao_codigo]
           ([pk_importacao]
           ,[resolveu_dependencia]
           ,[data_ultima_alteracao]
           ,[registro_ativo]
           ,[codigo]
           ,[versao_tiss]
           ,[fk_usuario_ultima_alteracao]
           ,[fk_tabela_tiss]
           ,[codigo_ans_duplicado]
           ,[sql_update])
          (           
SELECT distinct NULL AS pk_importacao,
	   NULL AS resolveu_dependencia,
	   GETDATE() AS data_ultima_alteracao,
	   1 AS registro_ativo,
	   versaoCodigo.codigo AS codigo,
	   6 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   tiss.id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
from tb_tabela_tiss_versao_codigo versaoCodigo
inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
where versaoCodigo.fk_tabela_tiss not in(
	select tiss.id from tb_tabela_tiss_versao_codigo versaoCodigo
	inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
	 where versaoCodigo.versao_tiss = 6 and tiss.discriminator = 'especialidade'
) and tiss.discriminator = 'especialidade'
) 

GO

INSERT INTO [dbo].[tb_tabela_tiss_versao_codigo]
           ([pk_importacao]
           ,[resolveu_dependencia]
           ,[data_ultima_alteracao]
           ,[registro_ativo]
           ,[codigo]
           ,[versao_tiss]
           ,[fk_usuario_ultima_alteracao]
           ,[fk_tabela_tiss]
           ,[codigo_ans_duplicado]
           ,[sql_update])
          (           
SELECT distinct NULL AS pk_importacao,
	   NULL AS resolveu_dependencia,
	   GETDATE() AS data_ultima_alteracao,
	   1 AS registro_ativo,
	   versaoCodigo.codigo AS codigo,
	   7 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   tiss.id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
from tb_tabela_tiss_versao_codigo versaoCodigo
inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
where versaoCodigo.fk_tabela_tiss not in(
	select tiss.id from tb_tabela_tiss_versao_codigo versaoCodigo
	inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
	 where versaoCodigo.versao_tiss = 7 and tiss.discriminator = 'especialidade'
) and tiss.discriminator = 'especialidade'
) 

GO

INSERT INTO [dbo].[tb_tabela_tiss_versao_codigo]
           ([pk_importacao]
           ,[resolveu_dependencia]
           ,[data_ultima_alteracao]
           ,[registro_ativo]
           ,[codigo]
           ,[versao_tiss]
           ,[fk_usuario_ultima_alteracao]
           ,[fk_tabela_tiss]
           ,[codigo_ans_duplicado]
           ,[sql_update])
          (           
SELECT distinct NULL AS pk_importacao,
	   NULL AS resolveu_dependencia,
	   GETDATE() AS data_ultima_alteracao,
	   1 AS registro_ativo,
	   versaoCodigo.codigo AS codigo,
	   8 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   tiss.id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
from tb_tabela_tiss_versao_codigo versaoCodigo
inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
where versaoCodigo.fk_tabela_tiss not in(
	select tiss.id from tb_tabela_tiss_versao_codigo versaoCodigo
	inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
	 where versaoCodigo.versao_tiss = 8 and tiss.discriminator = 'especialidade'
) and tiss.discriminator = 'especialidade'
) 

INSERT INTO [dbo].[tb_tabela_tiss_versao_codigo]
           ([pk_importacao]
           ,[resolveu_dependencia]
           ,[data_ultima_alteracao]
           ,[registro_ativo]
           ,[codigo]
           ,[versao_tiss]
           ,[fk_usuario_ultima_alteracao]
           ,[fk_tabela_tiss]
           ,[codigo_ans_duplicado]
           ,[sql_update])
          (           
SELECT distinct NULL AS pk_importacao,
	   NULL AS resolveu_dependencia,
	   GETDATE() AS data_ultima_alteracao,
	   1 AS registro_ativo,
	   versaoCodigo.codigo AS codigo,
	   9 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   tiss.id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
from tb_tabela_tiss_versao_codigo versaoCodigo
inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
where versaoCodigo.fk_tabela_tiss not in(
	select tiss.id from tb_tabela_tiss_versao_codigo versaoCodigo
	inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
	 where versaoCodigo.versao_tiss = 9 and tiss.discriminator = 'especialidade'
) and tiss.discriminator = 'especialidade'
) 

INSERT INTO [dbo].[tb_tabela_tiss_versao_codigo]
           ([pk_importacao]
           ,[resolveu_dependencia]
           ,[data_ultima_alteracao]
           ,[registro_ativo]
           ,[codigo]
           ,[versao_tiss]
           ,[fk_usuario_ultima_alteracao]
           ,[fk_tabela_tiss]
           ,[codigo_ans_duplicado]
           ,[sql_update])
          (           
SELECT distinct NULL AS pk_importacao,
	   NULL AS resolveu_dependencia,
	   GETDATE() AS data_ultima_alteracao,
	   1 AS registro_ativo,
	   versaoCodigo.codigo AS codigo,
	   10 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   tiss.id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
from tb_tabela_tiss_versao_codigo versaoCodigo
inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
where versaoCodigo.fk_tabela_tiss not in(
	select tiss.id from tb_tabela_tiss_versao_codigo versaoCodigo
	inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
	 where versaoCodigo.versao_tiss = 10 and tiss.discriminator = 'especialidade'
) and tiss.discriminator = 'especialidade'
) 

GO

INSERT INTO [dbo].[tb_tabela_tiss_versao_codigo]
           ([pk_importacao]
           ,[resolveu_dependencia]
           ,[data_ultima_alteracao]
           ,[registro_ativo]
           ,[codigo]
           ,[versao_tiss]
           ,[fk_usuario_ultima_alteracao]
           ,[fk_tabela_tiss]
           ,[codigo_ans_duplicado]
           ,[sql_update])
          (           
SELECT distinct NULL AS pk_importacao,
	   NULL AS resolveu_dependencia,
	   GETDATE() AS data_ultima_alteracao,
	   1 AS registro_ativo,
	   versaoCodigo.codigo AS codigo,
	   11 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   tiss.id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
from tb_tabela_tiss_versao_codigo versaoCodigo
inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
where versaoCodigo.fk_tabela_tiss not in(
	select tiss.id from tb_tabela_tiss_versao_codigo versaoCodigo
	inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
	 where versaoCodigo.versao_tiss = 11 and tiss.discriminator = 'especialidade'
) and tiss.discriminator = 'especialidade'
)

GO

INSERT INTO [dbo].[tb_tabela_tiss_versao_codigo]
           ([pk_importacao]
           ,[resolveu_dependencia]
           ,[data_ultima_alteracao]
           ,[registro_ativo]
           ,[codigo]
           ,[versao_tiss]
           ,[fk_usuario_ultima_alteracao]
           ,[fk_tabela_tiss]
           ,[codigo_ans_duplicado]
           ,[sql_update])
          (           
SELECT distinct NULL AS pk_importacao,
	   NULL AS resolveu_dependencia,
	   GETDATE() AS data_ultima_alteracao,
	   1 AS registro_ativo,
	   versaoCodigo.codigo AS codigo,
	   12 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   tiss.id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
from tb_tabela_tiss_versao_codigo versaoCodigo
inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
where versaoCodigo.fk_tabela_tiss not in(
	select tiss.id from tb_tabela_tiss_versao_codigo versaoCodigo
	inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
	 where versaoCodigo.versao_tiss = 12 and tiss.discriminator = 'especialidade'
) and tiss.discriminator = 'especialidade'
) 
