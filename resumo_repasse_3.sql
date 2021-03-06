 SELECT 'Cr�dito(s)' AS tipo,
            RIGHT(CONVERT(CHAR(10),repasse.data_criacao,103),7) AS competencia,
            entidade.sigla+' - '+entidade.nome AS nome_entidade,
            lancamento.descricao AS descricao_lancamento,
            sum(CASE
                    WHEN calculado.natureza_contabil = 0 THEN calculado.valor_lancamento
                    ELSE calculado.valor_lancamento *-1
                END) AS valor,
            lancamento.id AS id_lancamento,
			tipoRepasse.descricao AS tipo_repasse
     FROM rl_repasse_calculado calculado
     INNER JOIN tb_lancamento_repasse lancamento ON (lancamento.id = calculado.fk_lancamento_repasse)
     INNER JOIN tb_repasse repasse ON (repasse.id = calculado.fk_repasse)
     INNER JOIN tb_entidade entidade ON (entidade.id = repasse.fk_entidade)
     INNER JOIN tb_cooperado cooperado ON (cooperado.id = calculado.fk_cooperado_lancamento)
	 LEFT JOIN rl_entidade_tipo_repasse tipoRepasse ON (repasse.fk_entidade_tipo_repasse = tipoRepasse.id and tipoRepasse.registro_ativo = 1)
     WHERE calculado.registro_ativo=1
       AND calculado.fk_saldo_devedor IS NULL
       AND calculado.tipo_lancamento_repasse=1
       AND calculado.tipo_demonstrativo=0
       AND (cooperado.discriminator <> 'se' or (cooperado.discriminator='se' and cooperado.tipo_servico=1))
       AND entidade.id = 46
	   AND repasse.numero_repasse = 122
       AND NOT EXISTS
       (SELECT id
        FROM rl_repasse_calculado
        WHERE fk_lancamento_repasse = calculado.fk_lancamento_repasse
          AND fk_repasse = calculado.fk_repasse
          AND natureza_contabil = 1)
		  GROUP BY RIGHT(CONVERT(CHAR(10),repasse.data_criacao,103),7),
             entidade.sigla,
             entidade.nome,
             lancamento.descricao,
             lancamento.id,
			 tipoRepasse.descricao
    HAVING SUM(CASE
                   WHEN calculado.natureza_contabil = 0 THEN calculado.valor_lancamento
                   ELSE calculado.valor_lancamento *-1
               END) >= 0
    ORDER BY lancamento.descricao, RIGHT(CONVERT(CHAR(10),repasse.data_criacao,103),7)