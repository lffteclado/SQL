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
SELECT NULL AS pk_importacao,
	   NULL AS resolveu_dependencia,
	   GETDATE() AS data_ultima_alteracao,
	   1 AS registro_ativo,
	   '225124' codigo,
	   5 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
FROM tb_tabela_tiss WHERE id NOT IN (

				SELECT tissCodigo.fk_tabela_tiss
				FROM tb_tabela_tiss_versao_codigo tissCodigo
				INNER JOIN tb_tabela_tiss tiss ON (tiss.id = tissCodigo.fk_tabela_tiss AND tiss.registro_ativo = 1 AND tissCodigo.registro_ativo = 1)
				WHERE tissCodigo.codigo = '225124' AND versao_tiss = 5

		   ) AND registro_ativo = 1 AND discriminator = 'especialidade'
)


/*
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
SELECT NULL AS pk_importacao,
	   NULL AS resolveu_dependencia,
	   GETDATE() AS data_ultima_alteracao,
	   1 AS registro_ativo,
	   '225124' codigo,
	   6 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
FROM tb_tabela_tiss WHERE id NOT IN (

				SELECT tissCodigo.fk_tabela_tiss
				FROM tb_tabela_tiss_versao_codigo tissCodigo
				INNER JOIN tb_tabela_tiss tiss ON (tiss.id = tissCodigo.fk_tabela_tiss AND tiss.registro_ativo = 1 AND tissCodigo.registro_ativo = 1)
				WHERE tissCodigo.codigo = '225124' AND versao_tiss = 6

		   ) AND registro_ativo = 1 AND discriminator = 'especialidade'
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
SELECT NULL AS pk_importacao,
	   NULL AS resolveu_dependencia,
	   GETDATE() AS data_ultima_alteracao,
	   1 AS registro_ativo,
	   '225124' codigo,
	   7 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
FROM tb_tabela_tiss WHERE id NOT IN (

				SELECT tissCodigo.fk_tabela_tiss
				FROM tb_tabela_tiss_versao_codigo tissCodigo
				INNER JOIN tb_tabela_tiss tiss ON (tiss.id = tissCodigo.fk_tabela_tiss AND tiss.registro_ativo = 1 AND tissCodigo.registro_ativo = 1)
				WHERE tissCodigo.codigo = '225124' AND versao_tiss = 7

		   ) AND registro_ativo = 1 AND discriminator = 'especialidade'
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
SELECT NULL AS pk_importacao,
	   NULL AS resolveu_dependencia,
	   GETDATE() AS data_ultima_alteracao,
	   1 AS registro_ativo,
	   '225124' codigo,
	   8 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
FROM tb_tabela_tiss WHERE id NOT IN (

				SELECT tissCodigo.fk_tabela_tiss
				FROM tb_tabela_tiss_versao_codigo tissCodigo
				INNER JOIN tb_tabela_tiss tiss ON (tiss.id = tissCodigo.fk_tabela_tiss AND tiss.registro_ativo = 1 AND tissCodigo.registro_ativo = 1)
				WHERE tissCodigo.codigo = '225124' AND versao_tiss = 8

		   ) AND registro_ativo = 1 AND discriminator = 'especialidade'
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
SELECT NULL AS pk_importacao,
	   NULL AS resolveu_dependencia,
	   GETDATE() AS data_ultima_alteracao,
	   1 AS registro_ativo,
	   '225124' codigo,
	   9 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
FROM tb_tabela_tiss WHERE id NOT IN (

				SELECT tissCodigo.fk_tabela_tiss
				FROM tb_tabela_tiss_versao_codigo tissCodigo
				INNER JOIN tb_tabela_tiss tiss ON (tiss.id = tissCodigo.fk_tabela_tiss AND tiss.registro_ativo = 1 AND tissCodigo.registro_ativo = 1)
				WHERE tissCodigo.codigo = '225124' AND versao_tiss = 9

		   ) AND registro_ativo = 1 AND discriminator = 'especialidade'
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
SELECT NULL AS pk_importacao,
	   NULL AS resolveu_dependencia,
	   GETDATE() AS data_ultima_alteracao,
	   1 AS registro_ativo,
	   '225124' codigo,
	   10 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
FROM tb_tabela_tiss WHERE id NOT IN (

				SELECT tissCodigo.fk_tabela_tiss
				FROM tb_tabela_tiss_versao_codigo tissCodigo
				INNER JOIN tb_tabela_tiss tiss ON (tiss.id = tissCodigo.fk_tabela_tiss AND tiss.registro_ativo = 1 AND tissCodigo.registro_ativo = 1)
				WHERE tissCodigo.codigo = '225124' AND versao_tiss = 10

		   ) AND registro_ativo = 1 AND discriminator = 'especialidade'
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
SELECT NULL AS pk_importacao,
	   NULL AS resolveu_dependencia,
	   GETDATE() AS data_ultima_alteracao,
	   1 AS registro_ativo,
	   '225124' codigo,
	   11 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
FROM tb_tabela_tiss WHERE id NOT IN (

				SELECT tissCodigo.fk_tabela_tiss
				FROM tb_tabela_tiss_versao_codigo tissCodigo
				INNER JOIN tb_tabela_tiss tiss ON (tiss.id = tissCodigo.fk_tabela_tiss AND tiss.registro_ativo = 1 AND tissCodigo.registro_ativo = 1)
				WHERE tissCodigo.codigo = '225124' AND versao_tiss = 11

		   ) AND registro_ativo = 1 AND discriminator = 'especialidade'
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
SELECT NULL AS pk_importacao,
	   NULL AS resolveu_dependencia,
	   GETDATE() AS data_ultima_alteracao,
	   1 AS registro_ativo,
	   '225124' codigo,
	   12 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
FROM tb_tabela_tiss WHERE id NOT IN (

				SELECT tissCodigo.fk_tabela_tiss
				FROM tb_tabela_tiss_versao_codigo tissCodigo
				INNER JOIN tb_tabela_tiss tiss ON (tiss.id = tissCodigo.fk_tabela_tiss AND tiss.registro_ativo = 1 AND tissCodigo.registro_ativo = 1)
				WHERE tissCodigo.codigo = '225124' AND versao_tiss = 12

		   ) AND registro_ativo = 1 AND discriminator = 'especialidade'
)