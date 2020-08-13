 SELECT 
        CONVERT(BIT, CASE WHEN declaracao.fk_repasse IS NOT NULL
            THEN 0
           WHEN COALESCE(declaracao.numero_repasse_web, '0') <> '0'
            THEN 0
           WHEN MONTH(getdate()) = MONTH(declaracao.data) AND YEAR(getdate()) = YEAR(declaracao.data)
            THEN 0
           WHEN getdate() > declaracao.data
            THEN 0
            ELSE 1 END)
        AS 'permitido_deletar',
        declaracao.id,
        declaracao.cnpj,
        declaracao.nome_empresa,
        declaracao.base_inss,
        declaracao.valor_inss,
        declaracao.percentual_calculo,
        declaracao.data,
        declaracao.data_hora_criacao,
        declaracao.data_ultima_alteracao,
        declaracao.tipo_declaracao,
        cooperado.id AS 'id_cooperado',
        cooperado.nome,
        cooperado.cpf_cnpj,
        cooperado.numero_conselho,
        cooperado.conselho,
        cooperado.uf,
        entidade.id AS 'id_entidade',
        entidade.sigla,
        usuarioCriacao.nome AS 'nome_usuario_criacao',
        entidade.bloquear_exclusao_inss,
       CONVERT(BIT, CASE WHEN declaracao.fk_repasse IS NOT NULL
           THEN 0
           WHEN COALESCE(declaracao.numero_repasse_web, '0') <> '0'
            THEN 0
            ELSE 1 END)
        AS 'permitido_fencom_deletar',
        declaracao.valor_devolucao,
		declaracao.fk_repasse,
		declaracao.numero_repasse_web
       FROM tb_declaracao_inss declaracao
       INNER JOIN tb_dados_cooperado_fencom_temp cooperado ON(cooperado.id = declaracao.fk_cooperado)
      
	  /*if (!ValidatorUtil.isEmpty(filtroPesquisa.getEntidadeLogada())) {
         INNER JOIN rl_entidade_cooperado entidadeCooperado ON(entidadeCooperado.fk_cooperado = cooperado.id 
                                  AND entidadeCooperado.registro_ativo=1 )
      }*/

       INNER JOIN tb_entidade entidade ON(entidade.id = declaracao.fk_entidade AND entidade.registro_ativo=1)
       LEFT JOIN tb_usuario usuarioCriacao ON(usuarioCriacao.id = declaracao.fk_usuario_criacao AND usuarioCriacao.registro_ativo=1)
       WHERE declaracao.registro_ativo=1
	   AND entidade.id = 43
	   and declaracao.fk_repasse IS NULL
	   and COALESCE(declaracao.numero_repasse_web, '0') = '0'
	   and getdate() > declaracao.data
