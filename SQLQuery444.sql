 /*
 hql.append(
        " FROM tb_controle_esocial_processamento processamento WITH(NOLOCK)  ");
    hql.append(
        " INNER JOIN tb_cooperado  WITH(NOLOCK) ON (tb_cooperado.id = processamento.fk_cooperado_do_evento) ");
    hql.append(
        " INNER JOIN rl_entidade_cooperado situacao  WITH(NOLOCK) ON (tb_cooperado.id = situacao.fk_cooperado) ");
    hql.append(" WHERE processamento.registro_ativo = 1 ");
    hql.append("  AND processamento.fk_entidade = :entidade ");
    hql.append("  AND processamento.tipo_evento_esocial = :tipoEventoESocial ");
	
	 hql.append(
        " ORDER BY (CASE WHEN processamento.codigo_resposta = 8 THEN 0   ");
    hql.append(
        "         WHEN processamento.codigo_resposta_consulta = 8 THEN 1 ");
    hql.append(
        "                WHEN ((processamento.codigo_resposta <> 0 AND processamento.codigo_resposta <> 1)  ");
    hql.append(
        "            OR (processamento.codigo_resposta_consulta <> 0 AND processamento.codigo_resposta_consulta <> 1)) THEN 2 ELSE 3 END),  ");
    hql.append("          tb_cooperado.nome ");

	CODIGO_201("201", "Sucesso"), 0
  CODIGO_202("202", "Sucesso com advertência"), 1
  CODIGO_301("301", "Erro"), 2
  CODIGO_401("401", "Erro"), 3
  CODIGO_402("402", "Erro"), 4
  CODIGO_403("403", "Erro"), 5
  CODIGO_404("404", "Erro"), 6
  CODIGO_405("405", "Erro"), 7
  CODIGO_101("101", "Aguardando processamento")8

  primeiro Aguardando processamento, depois erro, depois advertência e por fim sucesso
	
	*/

	select processamento.fk_entidade,
		   situacao.situacao_cooperado,
		   processamento.fk_cooperado_do_evento,
		   processamento.codigo_resposta,
		   processamento.codigo_resposta_consulta,
		   *
	 from tb_controle_esocial_processamento processamento WITH(NOLOCK)
	INNER JOIN tb_cooperado  WITH(NOLOCK) ON (tb_cooperado.id = processamento.fk_cooperado_do_evento)
	INNER JOIN rl_entidade_cooperado situacao  WITH(NOLOCK) ON (tb_cooperado.id = situacao.fk_cooperado and processamento.fk_entidade = situacao.fk_entidade)
	WHERE processamento.registro_ativo = 1
	AND processamento.fk_entidade = 43
	AND processamento.tipo_evento_esocial = 1
	ORDER BY (CASE
	 WHEN processamento.codigo_resposta = 8 THEN 0
	 WHEN processamento.codigo_resposta_consulta = 8 THEN 1
	 WHEN ((processamento.codigo_resposta <> 0 AND processamento.codigo_resposta <> 1)
	 OR (processamento.codigo_resposta_consulta <> 0 AND processamento.codigo_resposta_consulta <> 1)) THEN 2
	 WHEN processamento.codigo_resposta = 1 THEN 3
	 WHEN processamento.codigo_resposta_consulta = 1 THEN 4
	  ELSE 5 END), tb_cooperado.nome