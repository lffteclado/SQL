        SELECT 'Estorno' AS tipo
           ,entidade.sigla + ' - ' + entidade.nome AS nome_entidade
           ,lancamento.descricao + CASE
             WHEN (calculado.fk_saldo_devedor IS NOT NULL)
               THEN ' (Origem Saldo Devedor - Outros Repasses)'
             ELSE CONCAT(CONCAT(' (Repasse: ', repasse.numero_repasse), ') ')
             END AS descricao_lancamento
           ,sum(coalesce(calculado.valor_lancamento, 0)) AS valor_saldo_devedor
           ,lancamento.id AS id_lancamento
           ,RIGHT(CONVERT(CHAR(10), repasse.data_criacao, 103), 7) AS competencia
		   ,tipoRepasse.descricao
         FROM rl_repasse_calculado calculado
         INNER JOIN tb_lancamento_repasse lancamento ON (lancamento.id = calculado.fk_lancamento_repasse)
         INNER JOIN tb_repasse repasse ON (repasse.id = calculado.fk_repasse)
         INNER JOIN tb_entidade entidade ON (entidade.id = repasse.fk_entidade)
		 LEFT JOIN rl_entidade_tipo_repasse tipoRepasse ON (repasse.fk_entidade_tipo_repasse = tipoRepasse.id and tipoRepasse.registro_ativo = 1)
         WHERE calculado.registro_ativo = 1
           AND calculado.natureza_contabil = 2
           AND calculado.tipo_demonstrativo = 0
           AND entidade.id = 46
		   AND repasse.numero_repasse = 122
		        GROUP BY RIGHT(CONVERT(CHAR(10), repasse.data_criacao, 103), 7)
           ,entidade.sigla
           ,entidade.nome
           ,lancamento.descricao + CASE
             WHEN (calculado.fk_saldo_devedor IS NOT NULL)
               THEN ' (Origem Saldo Devedor - Outros Repasses)'
             ELSE CONCAT(CONCAT(' (Repasse: ', repasse.numero_repasse), ') ')
             END
           ,lancamento.id
           ,calculado.natureza_contabil
           ,case when calculado.fk_saldo_devedor is not null then 0 else 1 end
           ,repasse.numero_repasse
		   ,tipoRepasse.descricao
         ORDER BY lancamento.descricao + CASE
             WHEN (calculado.fk_saldo_devedor IS NOT NULL)
               THEN ' (Origem Saldo Devedor - Outros Repasses)'
             ELSE CONCAT(CONCAT(' (Repasse: ', repasse.numero_repasse), ') ')
             END
           ,RIGHT(CONVERT(CHAR(10), repasse.data_criacao, 103), 7)
		  
