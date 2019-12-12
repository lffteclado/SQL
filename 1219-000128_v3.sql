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
	   tabela.codigo,
	   5 AS versao_tiss,
	   12 AS fk_usuario_ultima_alteracao,
	   id AS fk_tabela_tiss,
	   NULL AS codigo_ans_duplicado,
	   '1219-000128' AS sql_update
from tb_tabela_tiss_versao_codigo versaoCodigo
	cross apply (	
		select tissCodigo.codigo,
		       tiss.descricao,
			   tissCodigo.versao_tiss
		from tb_tabela_tiss_versao_codigo tissCodigo
		inner join tb_tabela_tiss tiss on (tiss.id = tissCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and tissCodigo.registro_ativo = 1)
		where tissCodigo.versao_tiss = 5 and tiss.discriminator = 'especialidade'	
	) as tabela
where registro_ativo = 1 and id not in (
 select tissCodigo.id
	from tb_tabela_tiss_versao_codigo tissCodigo
	inner join tb_tabela_tiss tiss on (tiss.id = tissCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and tissCodigo.registro_ativo = 1)
	where tissCodigo.versao_tiss = 5 and tiss.discriminator = 'especialidade' 
) and tabela.codigo = versaoCodigo.codigo

) 