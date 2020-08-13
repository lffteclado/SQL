 SELECT 'Pagamento(s)' AS tipo,
            RIGHT(CONVERT(CHAR(10),repasse.data_criacao,103),7) AS competencia,
            entidade.sigla+' - '+entidade.nome AS nome_entidade,
            lancamento.descricao AS descricao_lancamento,
            sum(calculado.valor_lancamento) AS valor,
            lancamento.id AS id_lancamento
			--,tipoRepasse.descricao AS tipo_repasse
     FROM rl_repasse_calculado calculado
     INNER JOIN tb_lancamento_repasse lancamento ON (lancamento.id = calculado.fk_lancamento_repasse)
     INNER JOIN tb_repasse repasse ON (repasse.id = calculado.fk_repasse)
     INNER JOIN tb_entidade entidade ON (entidade.id = repasse.fk_entidade)
     INNER JOIN tb_cooperado cooperado ON (cooperado.id = calculado.fk_cooperado_lancamento)
	 LEFT JOIN rl_entidade_tipo_repasse tipoRepasse ON (repasse.fk_entidade_tipo_repasse = tipoRepasse.id and tipoRepasse.registro_ativo = 1)
     WHERE calculado.registro_ativo=1
       AND calculado.natureza_contabil=0
       AND calculado.tipo_lancamento_repasse=0
       AND calculado.tipo_demonstrativo=0
       AND (cooperado.discriminator <> 'se'  or (cooperado.discriminator='se' and cooperado.tipo_servico=1))
       AND entidade.id = 46
	   --AND repasse.numero_repasse = 122
	   AND CONVERT(DATE, repasse.data_criacao) >= '2020-03-01'
	   AND CONVERT(DATE,repasse.data_criacao) <= '2020-03-31'
	 GROUP BY RIGHT(CONVERT(CHAR(10),repasse.data_criacao,103),7),
              entidade.sigla,
              entidade.nome,
              lancamento.descricao,
              lancamento.id
			  --,tipoRepasse.descricao
     ORDER BY lancamento.descricao, RIGHT(CONVERT(CHAR(10),repasse.data_criacao,103),7)