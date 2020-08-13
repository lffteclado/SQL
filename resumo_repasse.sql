 SELECT top 10 'Demonstrativo' AS tipo,
            RIGHT(CONVERT(CHAR(10),repasse.data_criacao,103),7) AS competencia,
            entidade.sigla+' - '+entidade.nome AS nome_entidade,
            lancamento.descricao AS descricao_lancamento,
            sum(calculado.valor_lancamento) AS valor,
            lancamento.id AS id_lancamento,
			tipoRepasse.descricao AS tipoRepasse,
			repasse.numero_repasse
     FROM rl_repasse_calculado calculado
     INNER JOIN tb_lancamento_repasse lancamento ON (lancamento.id = calculado.fk_lancamento_repasse)
     INNER JOIN tb_repasse repasse ON (repasse.id = calculado.fk_repasse)
     INNER JOIN tb_entidade entidade ON (entidade.id = repasse.fk_entidade)
     INNER JOIN tb_cooperado cooperado ON (cooperado.id = calculado.fk_cooperado_lancamento)
	 LEFT JOIN rl_entidade_tipo_repasse tipoRepasse ON (repasse.fk_entidade_tipo_repasse = tipoRepasse.id and tipoRepasse.registro_ativo = 1)
     WHERE calculado.registro_ativo=1
       AND calculado.tipo_lancamento_repasse=0
       AND calculado.tipo_demonstrativo<>0
       AND (cooperado.discriminator <> 'se' OR repasse.pk_importacao_web IS NOT NULL  or (cooperado.discriminator='se' and cooperado.tipo_servico=1))
       AND entidade.id = 46
	   AND repasse.numero_repasse = 122
	    GROUP BY RIGHT(CONVERT(CHAR(10),repasse.data_criacao,103),7),
              entidade.sigla,
              entidade.nome,
              lancamento.descricao,
              lancamento.id,
			  tipoRepasse.descricao,
			  repasse.numero_repasse
     ORDER BY lancamento.descricao, RIGHT(CONVERT(CHAR(10),repasse.data_criacao,103),7)

	/*select fk_entidade_tipo_repasse, * from tb_repasse where numero_repasse = 106 and fk_entidade = 46 and registro_ativo = 1
	union
	select fk_entidade_tipo_repasse, * from tb_repasse where numero_repasse = 122 and fk_entidade = 46 and registro_ativo = 1*/

	select * from rl_repasse_calculado where fk_repasse = 17679 and tipo_demonstrativo <> 0