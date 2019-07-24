/*
hql.append(
        " ORDER BY (CASE WHEN processamento.codigo_resposta = 8 THEN 0   ");
    hql.append(
        "         WHEN processamento.codigo_resposta_consulta = 8 THEN 1 ");
    hql.append(
        "                WHEN ((processamento.codigo_resposta <> 0 AND processamento.codigo_resposta <> 1)  ");
    hql.append(
        "            OR (processamento.codigo_resposta_consulta <> 0 AND processamento.codigo_resposta_consulta <> 1)) THEN 2 ELSE 3 END),  ");
    hql.append("          especialidade.descricao ");

	FROM tb_controle_esocial_processamento processamento WITH(NOLOCK) ");
    hql.append(
        " INNER JOIN tb_entidade entidade WITH(NOLOCK)  ON (entidade.id = processamento.fk_entidade AND entidade.registro_ativo=1) ");
    hql.append(" LEFT JOIN tb_tabela_tiss especialidade WITH(NOLOCK)   ");
    hql.append(
        "  ON (especialidade.id = processamento.fk_especialidade_do_evento AND especialidade.registro_ativo = 1) ");
    hql.append(
        " LEFT JOIN tb_usuario usuario WITH(NOLOCK)  ON (usuario.id = processamento.fk_usuario AND usuario.registro_ativo=1) ");
    hql.append(" WHERE processamento.fk_entidade = :entidade ");
    hql.append("  AND processamento.tipo_evento_esocial = :tipoEventoESocial ");
    hql.append("  AND processamento.registro_ativo = 1 ");
*/


select processamento.codigo_resposta,
 processamento.codigo_resposta_consulta,
 * 
from tb_controle_esocial_processamento processamento WITH(NOLOCK)
INNER JOIN tb_entidade entidade WITH(NOLOCK)  ON (entidade.id = processamento.fk_entidade AND entidade.registro_ativo=1)
LEFT JOIN tb_tabela_tiss especialidade WITH(NOLOCK)
ON (especialidade.id = processamento.fk_especialidade_do_evento AND especialidade.registro_ativo = 1)
LEFT JOIN tb_usuario usuario WITH(NOLOCK)  ON (usuario.id = processamento.fk_usuario AND usuario.registro_ativo=1)
WHERE processamento.fk_entidade = 43
 AND processamento.tipo_evento_esocial = 1
 AND processamento.registro_ativo = 1
 ORDER BY (CASE WHEN processamento.codigo_resposta = 8 THEN 0
  WHEN processamento.codigo_resposta_consulta = 8 THEN 1
   WHEN ((processamento.codigo_resposta <> 0 AND processamento.codigo_resposta <> 1)
   OR (processamento.codigo_resposta_consulta <> 0 AND processamento.codigo_resposta_consulta <> 1)) THEN 2
    WHEN processamento.codigo_resposta = 1 THEN 3
	 WHEN processamento.codigo_resposta_consulta = 1 THEN 4
    ELSE 5 END),
    especialidade.descricao

