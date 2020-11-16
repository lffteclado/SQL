INSERT INTO tb_conversao_convenio (
	discriminator
	,resolveu_dependencia
	,data_ultima_alteracao
	,registro_ativo
	,fk_usuario_ultima_alteracao
	,fk_entidade_convenio
	,fk_entidade_cooperado_conversao
	,sql_update								
)
SELECT 'Regra' AS discriminator
       ,0 AS resolveu_dependencia
	   ,getdate() AS data_ultima_alteracao
	   ,1 AS registro_ativo
	   ,12 AS fk_usuario_ultima_alteracao
	   ,5827 AS fk_entidade_convenio
	   ,cooperadoConversao.id AS fk_entidade_cooperado_conversao
	   ,'#1020-000496' AS sql_update
FROM rl_entidade_cooperado_conversao cooperadoConversao
 WHERE fk_entidade = 2
  AND registro_ativo = 1 AND
   id NOT IN (
	SELECT fk_entidade_cooperado_conversao FROM tb_conversao_convenio
	 WHERE discriminator = 'Regra'
	  AND fk_entidade_convenio = 5827
	  AND registro_ativo = 1
) AND (data_final IS NULL
  OR data_final > GETDATE())