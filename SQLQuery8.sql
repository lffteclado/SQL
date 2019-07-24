 SELECT processamento.id   ,processamento.ambiente_esocial   ,processamento.tipo_evento_esocial   ,processamento.codigo_resposta   ,processamento.codigo_resposta_consulta   ,processamento.codigo_resposta_servico   ,processamento.numero_recibo_consulta   ,processamento.data_processamento   ,processamento.data_competencia,      NULL AS 'xmlEnvio',      NULL AS 'xmlResposta',      NULL AS 'xmlRespostaConsulta'   ,processamento.descricaoocorrencias   ,processamento.ocorrencias_consulta   ,tb_cooperado.id AS 'id_cooperado'   ,tb_cooperado.nome AS 'nome_cooperado'  FROM tb_controle_esocial_processamento processamento WITH(NOLOCK)   INNER JOIN tb_cooperado  WITH(NOLOCK) ON (tb_cooperado.id = processamento.fk_cooperado_do_evento)  WHERE processamento.registro_ativo = 1   AND processamento.fk_entidade = :entidade   AND processamento.tipo_evento_esocial = :tipoEventoESocial  AND tb_cooperado.nome = :nome  ORDER BY (CASE WHEN processamento.codigo_resposta = 8 THEN 0            WHEN processamento.codigo_resposta_consulta = 8 THEN 1                 WHEN ((processamento.codigo_resposta <> 0 AND processamento.codigo_resposta <> 1)              OR (processamento.codigo_resposta_consulta <> 0 AND processamento.codigo_resposta_consulta <> 1)) THEN 2 ELSE 3 END),            tb_cooperado.nome 