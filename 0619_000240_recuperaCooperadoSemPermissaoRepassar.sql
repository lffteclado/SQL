  SELECT cooperado.nome + '- CRM: ' + cooperado.numero_conselho + ' está com situação ' + CASE  
        WHEN entidadeCooperado.situacao_cooperado = 0 
          THEN 'Ativo ' 
        WHEN entidadeCooperado.situacao_cooperado = 1 
          THEN 'Excluído ' 
        WHEN entidadeCooperado.situacao_cooperado = 2 
          THEN 'Demitido ' 
        WHEN entidadeCooperado.situacao_cooperado = 3 
          THEN 'Falecido ' 
        WHEN entidadeCooperado.situacao_cooperado = 4 
          THEN 'Inativo ' 
        WHEN entidadeCooperado.situacao_cooperado = 5 
          THEN 'Exclusivo Unimed ' 
        WHEN entidadeCooperado.situacao_cooperado = 6 
          THEN 'A verificar ' 
        WHEN entidadeCooperado.situacao_cooperado = 7 
          THEN 'Eliminado ' 
        WHEN entidadeCooperado.situacao_cooperado = 8 
          THEN 'Vinculado de Outro Prestador ' 
        WHEN entidadeCooperado.situacao_cooperado = 9 
          THEN 'A Integralizar ' 
        WHEN entidadeCooperado.situacao_cooperado = 10 
          THEN 'Licenciado ' 
        WHEN entidadeCooperado.situacao_cooperado = 11 
          THEN 'Suspenso ' 
        WHEN entidadeCooperado.situacao_cooperado = 12 
          THEN 'Adesão à Cooperativa ' 
        ELSE '' 
        END +' Bloqueada para Repasse ' +  CASE  
        WHEN espelho.numero_espelho IS NOT NULL 
          THEN 'ESPELHO: ' + CONVERT(VARCHAR(20), espelho.numero_espelho) 
        ELSE '' END 
     FROM tb_espelho espelho 
     INNER JOIN tb_atendimento atendimento ON (atendimento.fk_espelho = espelho.id AND atendimento.registro_ativo = 1) 
     INNER JOIN tb_procedimento procedimento ON (procedimento.fk_atendimento = atendimento.id AND procedimento.registro_ativo = 1) 
     INNER JOIN rl_situacao_procedimento situacao ON (situacao.fk_procedimento = procedimento.id AND situacao.espelhado = 1) 
     INNER JOIN tb_cooperado cooperado ON (procedimento.fk_cooperado_recebedor_cobranca = cooperado.id AND cooperado.discriminator <> 'SE') 
     INNER JOIN rl_entidade_cooperado entidadeCooperado ON (espelho.fk_entidade = entidadeCooperado.fk_entidade AND cooperado.id = entidadeCooperado.fk_cooperado) 
     WHERE espelho.registro_ativo = 1
	 and espelho.id = 979065
	 and atendimento.faturar = 1
	 and atendimento.situacaoAtendimento = 1
      AND EXISTS ( 
        SELECT id 
        FROM rl_entidade_cooperado_situacao_repasse 
        WHERE rl_entidade_cooperado_situacao_repasse.fk_entidade = entidadeCooperado.fk_entidade 
          AND rl_entidade_cooperado_situacao_repasse.registro_ativo = 1 
          AND rl_entidade_cooperado_situacao_repasse.situacaoRepasse = entidadeCooperado.situacao_cooperado 
          AND situacao = 0) 
     GROUP BY cooperado.nome 
      ,cooperado.numero_conselho 
      ,entidadeCooperado.situacao_cooperado 
      ,espelho.numero_espelho 
     ORDER BY cooperado.nome ASC 
