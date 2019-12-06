SELECT atendimento.id AS id_atendimento -- 0
      ,convenio.sigla AS sigla_convenio -- 1
      ,convenio.codigo_ans -- 2
      ,atendimento.numero_guia -- 3
      ,entidade.cnpj AS codigo_na_operadora -- 4
      ,entidade.cnes -- 5
      ,itemDespesa.tipo_item_despesa AS codigo_item_despessa  -- 6
      ,procedimento.data_realizacao -- 7
      ,procedimento.hora_inicio -- 8
      ,procedimento.hora_fim -- 9
      ,historicoTabelaHonorarios.codigo_ans AS tabela -- 10
      ,itemDespesa.codigo AS codigo_item_despesa -- 11
      ,procedimento.quantidade -- 12
      ,unidadeMedida.codigo AS codigo_unidade_medida -- 13
      ,convert(numeric(19,2), 100.00) as fator_reducao -- 14
      ,convert(numeric(19,2),(case when coalesce(procedimento.quantidade,0) <> 0 then (coalesce(procedimento.valor_total,0) / coalesce(procedimento.quantidade,0)) else 0 end))  AS valor_unitario -- 15
      ,procedimento.valor_total -- 16
      ,itemDespesa.descricao -- 17
	  ,entidade.nome as nome_entidade --18
    FROM tb_procedimento procedimento 
    INNER JOIN tb_item_despesa itemDespesa ON (itemDespesa.id = procedimento.fk_item_despesa AND itemDespesa.registro_ativo = 1) 
    LEFT JOIN tb_tabela_tiss_versao_codigo unidadeMedida ON (unidadeMedida.fk_tabela_tiss = procedimento.fk_unidade_medida AND unidadeMedida.registro_ativo = 
    1 AND unidadeMedida.versao_tiss = 5) 
    INNER JOIN tb_atendimento atendimento ON (atendimento.id = procedimento.fk_atendimento AND atendimento.registro_ativo = 1) 
    INNER JOIN rl_entidade_convenio entidadeConvenio ON (entidadeConvenio.id = atendimento.fk_convenio AND entidadeConvenio.registro_ativo = 1) 
    INNER JOIN tb_convenio convenio ON (convenio.id = entidadeConvenio.fk_convenio AND convenio.registro_ativo = 1) 
    INNER JOIN tb_entidade entidade ON (entidade.id = entidadeConvenio.fk_entidade AND entidade.registro_ativo = 1) 
    INNER JOIN tb_espelho espelho ON (espelho.id = atendimento.fk_espelho AND espelho.registro_ativo = 1) 
    INNER JOIN tb_pagamento_procedimento pagamento ON (pagamento.fk_procedimento = procedimento.id AND pagamento.registro_ativo = 1) 
    LEFT JOIN tb_fatura fatura ON (fatura.id = pagamento.fk_fatura AND fatura.registro_ativo = 1)
	LEFT JOIN tb_glosa glosa ON (glosa.fk_procedimento = procedimento.id and glosa.registro_ativo = 1)
	LEFT JOIN tb_carta_glosa carta ON (carta.id = glosa.fk_carta_glosa and carta.registro_ativo = 1)
    LEFT JOIN (SELECT 
      memo1.fk_procedimento, 
      (SELECT TOP 1 
        COALESCE(adicionalEnfermaria, 0) + COALESCE(adicionalApartamento, 0) + COALESCE(adicionalUrgencia, 0) + COALESCE(adicionalExterno, 0) + 100 
      FROM tb_memoria_calculo 
      WHERE memo1.fk_procedimento = fk_procedimento 
      AND registro_ativo = 1 
      ORDER BY id DESC) 
      AS fator_reducao, 
      (SELECT TOP 1 
       fk_entidade_convenio_historico_tabela_honorario 
      FROM tb_memoria_calculo 
      WHERE memo1.fk_procedimento = fk_procedimento 
      AND registro_ativo = 1 
      ORDER BY id DESC)  
      AS fk_entidade_convenio_historico_tabela_honorario 
    FROM tb_memoria_calculo memo1 
    WHERE memo1.registro_ativo = 1 
    GROUP BY fk_procedimento) AS memoriaCalculo ON (memoriaCalculo.fk_procedimento = procedimento.id) 
    LEFT JOIN rl_entidadeconvenio_historico_tabela_honorario historicoTabelaHonorarios ON (historicoTabelaHonorarios.id = memoriaCalculo.fk_entidade_convenio_historico_tabela_honorario AND historicoTabelaHonorarios.registro_ativo=1) 
    WHERE procedimento.registro_ativo = 1 
    AND entidadeConvenio.fk_entidade IN (select id from tb_entidade where sigla like '%SANCOOP%')
    --AND procedimento.fk_tipo_guia = 
    AND itemDespesa.tipo_item_despesa IN (1,2,4)
	AND espelho.numero_espelho = 85856
	--and carta.numero_carta = 0
	and atendimento.numero_guia = '46460453'
    GROUP BY atendimento.id,
            procedimento.id,
            convenio.codigo_ans,
            convenio.sigla,
            atendimento.numero_guia,
            entidade.cnpj,
            entidade.cnes,
            itemDespesa.tipo_item_despesa,
            procedimento.data_realizacao,
            procedimento.hora_inicio,
            procedimento.hora_fim,
            itemDespesa.codigo,
            procedimento.quantidade,
            unidadeMedida.codigo,
            procedimento.quantidade,
            procedimento.valor_total,
            procedimento.valor_total,
            itemDespesa.descricao,
            memoriaCalculo.fator_reducao,
            historicoTabelaHonorarios.codigo_ans,
			entidade.nome
   ORDER BY atendimento.id, procedimento.id