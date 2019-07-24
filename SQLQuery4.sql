SELECT 
  entidadeConvenio.id as ENTIDADEAAAAAAA,
  itemDespesa.tipo_item_despesa as TIPOITEMAAAAA,
  entidade.id AS id_entidade, 
  entidade.sigla AS sigla_entidade, 
  entidade.nome AS nome_entidade, 
  convenio.id AS id_convenio, 
  convenio.sigla AS sigla_convenio, 
  convenio.nome AS nome_convenio, 
  complemento.id AS id_complemento, 
  complemento.descricao AS descricao_complemento, 
  entidadeConvenio.id AS id_entidade_convenio, 
  hospital.id AS id_hospital, 
  hospital.sigla AS sigla_hospital, 
  hospital.nome AS nome_hospital, 
  atendimento.id AS id_atendimento, 
  atendimento.numero_atendimento_automatico, 
  atendimento.senha, 
  atendimento.paciente, 
  atendimento.matricula_paciente, 
  atendimento.data_entrega, 
  atendimento.numero_guia, 
  atendimento.data_internacao, 
  atendimento.data_alta, 
  atendimento.plano, 
  atendimento.hora_digitacao, 
  atendimento.fk_tipo_atendimento, 
  tipoAtendimento.descricao AS descricao_tipo_atendimento, 
  atendimento.fk_motivo_alta, 
  motivoAlta.descricao AS descricao_motivo_alta, 
  dadosComplementares.id AS id_dados_complementares, 
  dadosComplementares.matricula_segurado, 
  dadosComplementares.nome_segurado, 
  dadosComplementares.data_validade_senha, 
  dadosComplementares.data_autorizacao, 
  atendimento.data_validade, 
  dadosComplementares.fk_indicador_acidente, 
  indicadorAcidente.descricao AS descricao_indicador_acidente, 
  cooperadoExecutor.numero_conselho AS numero_conselho_cooperado_executante, 
  cooperadoExecutor.nome AS nome_cooperado_executante, 
  itemDespesa.id AS id_item_despesa, 
  itemDespesa.codigo AS codigo_item_despesa, 
  itemDespesa.descricao AS descricao_item_despesa, 
  procedimentoTUSSVersao.id AS id_procedimento_tuss_versao, 
  procedimentoTUSSVersao.codigo AS codigo_procedimento_tuss, 
  procedimentoTUSS.id AS id_procedimento_tuss, 
  procedimentoTUSS.descricao AS descricao_procedimento_tuss, 
  procedimento.id AS id_procedimento, 
  procedimento.tuss, 
  procedimento.guia_procedimento, 
  procedimento.autorizado_unimed, 
  procedimento.data_inicio, 
  procedimento.data_fim, 
  procedimento.hora_inicio, 
  procedimento.hora_fim, 
  procedimento.urgencia, 
  procedimento.quantidade AS quantidade_procedimento, 
  procedimento.quantidade_ch AS quantidade_ch, 
  procedimento.valor_honorario AS 'valor_honorario_procedimento', 
  procedimento.valor_acrescimo_convenio AS 'valor_acrescimo_convenio_procedimento', 
  procedimento.valor_desconto AS 'valor_desconto_procedimento', 
  procedimento.valor_custo_operacional AS 'valor_custo_operacional_procedimento', 
  procedimento.valor_filme AS 'valor_filme_procedimento', 
  procedimento.valor_acrescimo AS 'valor_acrescimo_procedimento', 
  procedimento.valor_percentual AS valorPercentual, 
  procedimento.valor_total AS 'valor_total_procedimento', 
  procedimento.fk_acomodacao, 
  acomodacao.descricao AS descricao_acomodacao, 
  procedimento.fk_grau_participacao AS 'fk_entidade_grau_participacao', 
  grauParticipacao.descricao AS descricao_grau_participacao, 
  procedimento.fk_entidade_cooperado_especialidade, 
  especialidade.id AS fk_especialidade, 
  especialidade.descricao AS descricao_especialidade, 
  procedimento.fk_tipo_guia, 
  tipoGuia.descricao AS descricao_tipo_guia, 
  procedimento.fk_tecnica, 
  tecnica.descricao AS descricao_tecnica, 
  procedimento.fk_via_acesso, 
  viaDeAcesso.descricao AS descricao_via_de_acesso, 
  valorEspelhado.id AS id_pagamento_procedimento, 
  valorEspelhado.valor_honorario AS 'valor_honorario_pagamento', 
  valorEspelhado.valor_acrescimo_convenio AS 'valor_acrescimo_convenio_pagamento', 
  valorEspelhado.valor_desconto AS 'valor_desconto_pagamento', 
  valorEspelhado.valor_custo_operacional AS 'valor_custo_operacional_pagamento', 
  valorEspelhado.valor_filme AS 'valor_filme_pagamento', 
  valorEspelhado.valor_acrescimo AS 'valor_acrescimo_pagamento', 
  glosa.id AS id_glosa, 
  glosa.valor_honorario AS 'valor_honorario_glosa', 
  glosa.valor_desconto AS 'valor_desconto_glosa', 
  glosa.valor_custo_operacional AS 'valor_custo_operacional_glosa', 
  glosa.valor_filme AS 'valor_filme_glosa', 
  glosa.valor_acrescimo AS 'valor_acrescimo_glosa', 
  glosa.fk_motivo_glosa AS 'motivo_glosa', 
  espelho.id AS id_espelho, 
  espelho.numero_espelho, 
  valorFaturado.fk_fatura AS id_fatura, 
  (
    SELECT 
      top 1 numero_fatura 
    FROM 
      tb_fatura WITH (nolock) 
    WHERE 
      id = valorFaturado.fk_fatura 
      AND registro_ativo = 1
  ) AS numeroFatura, 
  convenio.codigo_ans AS codigo_ans, 
  atendimento.guia_principal AS guia_principal, 
  atendimento.rn AS rn, 
  hospital.cnpj AS cnpj_hospital, 
  conselhoProfissional.descricao AS nome_conselho_cooperado_executante, 
  uf.sigla AS sigla_uf, 
  coalesce(
    codigoCBO.codigo, codigoCBOPrincipal.codigo
  ) AS codigoCBO, 
  procedimento.data_realizacao AS data_realizacao, 
  entidade.cnpj AS entidade_cnpj, 
  entidade.cnes AS entidade_cnes, 
  tipoConsulta.descricao AS tipo_consulta, 
  dadosComplementares.observacao AS dados_complementares_observacao, 
  CASE WHEN (codigoExcecao.codigo is not null) THEN codigoExcecao.codigo ELSE codigoTabela.codigo END AS codigo_ans_tabela, 
  cooperadoExecutor.cpf_cnpj AS cooperado_executante_cpf_cnpj, 
  conselhoProfissional.sigla AS conselho_profissional_sigla, 
  itemDespesa.tipo_item_despesa AS tipo_item_despesa, 
  dadosComplementares.fk_tipo_consulta AS fk_tipo_consulta, 
  atendimento.data_validade AS atendiemnto_data_validade, 
  cooperadoExecutor.cns AS codigo_cns, 
  complementoHospital.sigla AS siglaComplemento, 
  complementoHospital.nome_razao_social AS nomeComplemento, 
  valorFaturado.valor_honorario, 
  valorFaturado.valor_acrescimo_convenio, 
  valorFaturado.valor_desconto, 
  valorFaturado.valor_custo_operacional, 
  valorFaturado.valor_filme, 
  valorFaturado.valor_acrescimo 
FROM 
  tb_procedimento procedimento with (nolock) 
  INNER JOIN tb_atendimento atendimento with (nolock) ON (
    atendimento.id = procedimento.fk_atendimento 
    AND atendimento.registro_ativo = 1
  ) 
  INNER JOIN rl_entidade_convenio entidadeConvenio with (nolock) ON (
    entidadeConvenio.id = atendimento.fk_convenio 
    AND entidadeConvenio.registro_ativo = 1
  ) 
  INNER JOIN tb_convenio convenio with (nolock) ON (
    convenio.id = entidadeConvenio.fk_convenio 
    AND convenio.registro_ativo = 1
  ) 
  LEFT JOIN rl_entidadeconvenio_complemento complemento with (nolock) ON (
    complemento.id = atendimento.fk_complemento 
    AND complemento.registro_ativo = 1
  ) 
  INNER JOIN tb_entidade entidade with (nolock) ON (
    entidade.id = entidadeConvenio.fk_entidade 
    AND entidade.registro_ativo = 1
  ) 
  INNER JOIN tb_hospital hospital with (nolock) ON (
    hospital.id = atendimento.fk_hospital 
    AND hospital.registro_ativo = 1
  ) 
  INNER JOIN tb_item_despesa itemDespesa with (nolock) ON (
    itemDespesa.id = procedimento.fk_item_despesa 
    AND itemDespesa.registro_ativo = 1
  ) 
  LEFT JOIN rl_entidade_hospital_complemento complementoHospital with (nolock) ON (
    atendimento.fk_complemento_hospital = complementoHospital.id 
    AND complementoHospital.registro_ativo = 1
  ) Outer apply (
    SELECT 
      id, 
      valor_honorario, 
      valor_acrescimo, 
      valor_desconto, 
      valor_custo_operacional, 
      valor_filme, 
      valor_acrescimo_convenio, 
      fk_fatura 
    FROM 
      tb_pagamento_procedimento pagamento WITH (nolock) 
    WHERE 
      pagamento.fk_procedimento = procedimento.id 
      AND pagamento.registro_ativo = 1 
      AND pagamento.fk_fatura IS NULL
  ) AS valorEspelhado OUTER APPLY (
    SELECT 
      id, 
      valor_honorario, 
      valor_acrescimo, 
      valor_desconto, 
      valor_custo_operacional, 
      valor_filme, 
      valor_acrescimo_convenio, 
      fk_fatura 
    FROM 
      tb_pagamento_procedimento pagamento WITH (nolock) 
    WHERE 
      pagamento.fk_procedimento = procedimento.id 
      AND pagamento.registro_ativo = 1 
      AND pagamento.fk_fatura IS NOT NULL
  ) AS valorFaturado 
  LEFT JOIN tb_cooperado cooperadoExecutor with (nolock) ON (
    cooperadoExecutor.id = procedimento.fk_cooperado_executante_complemento 
    AND cooperadoExecutor.registro_ativo = 1
  ) 
  LEFT JOIN tb_cooperado cooperadoRecebedor with (nolock) ON (
    cooperadoRecebedor.id = procedimento.fk_cooperado_recebedor_cobranca 
    AND cooperadoRecebedor.registro_ativo = 1
  ) 
  LEFT JOIN tb_tabela_tiss_versao_codigo procedimentoTUSSVersao with (nolock) ON (
    procedimentoTUSSVersao.id = procedimento.fk_procedimento_tuss 
    AND procedimentoTUSSVersao.registro_ativo = 1
  ) 
  LEFT JOIN tb_espelho espelho with (nolock) ON (
    espelho.id = atendimento.fk_espelho 
    AND espelho.registro_ativo = 1
  ) 
  LEFT JOIN rl_entidade_grau_participacao entidadeGrauParticipacao with (nolock) ON(
    entidadeGrauParticipacao.id = procedimento.fk_grau_participacao 
    AND entidadeGrauParticipacao.registro_ativo = 1
  ) 
  LEFT JOIN rl_entidade_cooperado entidadeCooperado WITH (nolock) ON (
    entidadeCooperado.fk_cooperado = procedimento.fk_cooperado_executante_complemento 
    and entidadeCooperado.fk_entidade = entidade.id 
    and entidadeCooperado.registro_ativo = 1
  ) 
  LEFT JOIN rl_entidadecooperado_especialidade entidadeCooperadoEspecialidadePrincipal WITH (nolock) ON(
    entidadeCooperadoEspecialidadePrincipal.fk_entidade_cooperado = entidadeCooperado.id 
    AND entidadeCooperadoEspecialidadePrincipal.registro_ativo = 1 
    and principal = 1
  ) 
  LEFT JOIN tb_tabela_tiss especialidadePrincipal WITH (nolock) ON (
    especialidadePrincipal.id = entidadeCooperadoEspecialidadePrincipal.fk_especialidade 
    AND especialidadePrincipal.registro_ativo = 1
  ) 
  LEFT JOIN tb_tabela_tiss_versao_codigo codigoCBOPrincipal WITH (nolock) ON (
    codigoCBOPrincipal.fk_tabela_tiss = especialidadePrincipal.id 
    AND codigoCBOPrincipal.versao_tiss = 5 
    AND codigoCBOPrincipal.registro_ativo = 1
  ) 
  LEFT JOIN rl_entidadecooperado_especialidade entidadeCooperadoEspecialidade with (nolock) ON(
    entidadeCooperadoEspecialidade.id = procedimento.fk_entidade_cooperado_especialidade 
    AND entidadeCooperadoEspecialidade.registro_ativo = 1
  ) 
  LEFT JOIN tb_tabela_tiss procedimentoTUSS with (nolock) ON (
    procedimentoTUSS.id = procedimentoTUSSVersao.fk_tabela_tiss 
    AND procedimentoTUSS.registro_ativo = 1
  ) 
  LEFT JOIN tb_tabela_tiss grauParticipacao with (nolock) ON (
    grauParticipacao.id = entidadeGrauParticipacao.fk_grau_participacao 
    AND grauParticipacao.registro_ativo = 1
  ) 
  LEFT JOIN tb_tabela_tiss especialidade with (nolock) ON (
    especialidade.id = entidadeCooperadoEspecialidade.fk_especialidade 
    AND especialidade.registro_ativo = 1
  ) 
  LEFT JOIN tb_tabela_tiss tipoAtendimento with (nolock) ON (
    tipoAtendimento.id = atendimento.fk_tipo_atendimento 
    AND tipoAtendimento.registro_ativo = 1
  ) 
  LEFT JOIN tb_tabela_tiss motivoAlta with (nolock) ON (
    motivoAlta.id = atendimento.fk_motivo_alta 
    AND motivoAlta.registro_ativo = 1
  ) 
  LEFT JOIN tb_tabela_tiss acomodacao with (nolock) ON (
    acomodacao.id = procedimento.fk_acomodacao 
    AND acomodacao.registro_ativo = 1
  ) 
  LEFT JOIN tb_tabela_tiss tipoGuia with (nolock) ON (
    tipoGuia.id = procedimento.fk_tipo_guia 
    AND tipoGuia.registro_ativo = 1
  ) 
  LEFT JOIN tb_tabela_tiss viaDeAcesso with (nolock) ON (
    viaDeAcesso.id = procedimento.fk_via_acesso 
    AND viaDeAcesso.registro_ativo = 1
  ) 
  LEFT JOIN tb_tabela_tiss tecnica with (nolock) ON (
    tecnica.id = procedimento.fk_tecnica 
    AND tecnica.registro_ativo = 1
  ) 
  LEFT JOIN tb_tabela_tiss conselhoProfissional with (nolock) ON (
    cooperadoExecutor.fk_conselho_profissional = conselhoProfissional.id 
    AND conselhoProfissional.registro_ativo = 1
  ) 
  LEFT JOIN tb_tabela_tiss uf with (nolock) ON (
    cooperadoExecutor.fk_uf = uf.id 
    AND uf.registro_ativo = 1
  ) 
  LEFT JOIN tb_tabela_tiss_versao_codigo codigoCBO with (nolock) ON (
    codigoCBO.fk_tabela_tiss = especialidade.id 
    AND codigoCBO.versao_tiss = entidadeConvenio.versao_tiss 
    AND codigoCBO.registro_ativo = 1
  ) OUTER APPLY(
    select 
      top 1 tb_codigo_excecao_ans.codigo_excecao_ans as codigo 
    from 
      tb_codigo_excecao_ans 
      inner join rl_entidadeconvenio_tipo_despesa_codigo_tabela_ans on rl_entidadeconvenio_tipo_despesa_codigo_tabela_ans.id = tb_codigo_excecao_ans.fk_entidadeconvenio_tipo_despesa_codigo_tabela_ans 
    where 
      rl_entidadeconvenio_tipo_despesa_codigo_tabela_ans.fk_entidade_convenio = entidadeConvenio.id 
      AND rl_entidadeconvenio_tipo_despesa_codigo_tabela_ans.tipo_item_despesa = itemDespesa.tipo_item_despesa
  ) codigoExcecao OUTER APPLY(
    SELECT 
      TOP 1 codigo_tabela_ans AS codigo 
    FROM 
      rl_entidadeconvenio_tipo_despesa_codigo_tabela_ans AS tabela_codigo with (nolock) 
    WHERE 
      tabela_codigo.fk_entidade_convenio = entidadeConvenio.id 
      AND tabela_codigo.tipo_item_despesa = itemDespesa.tipo_item_despesa
  ) codigoTabela OUTER APPLY(
    SELECT 
      TOP 1 id, 
      matricula_segurado, 
      nome_segurado, 
      data_validade_senha, 
      data_autorizacao, 
      data_validade, 
      fk_indicador_acidente, 
      fk_tipo_consulta, 
      observacao 
    FROM 
      tb_dados_complementares with (nolock) 
    WHERE 
      registro_ativo = 1 
      and fk_atendimento = atendimento.id 
    ORDER BY 
      id DESC
  ) dadosComplementares OUTER APPLY(
    SELECT 
      TOP 1 glosaProcedimento.id, 
      glosaProcedimento.situacao, 
      glosaProcedimento.valor_honorario, 
      glosaProcedimento.valor_desconto, 
      glosaProcedimento.valor_custo_operacional, 
      glosaProcedimento.valor_filme, 
      glosaProcedimento.valor_acrescimo, 
      glosaProcedimento.fk_motivo_glosa 
    FROM 
      tb_glosa glosaProcedimento with (nolock) 
    WHERE 
      glosaProcedimento.fk_procedimento = procedimento.id 
      AND glosaProcedimento.registro_ativo = 1 
    ORDER BY 
      glosaProcedimento.id DESC
  ) glosa 
  LEFT JOIN tb_tabela_tiss indicadorAcidente ON (
    indicadorAcidente.id = dadosComplementares.fk_indicador_acidente 
    AND indicadorAcidente.registro_ativo = 1
  ) 
  LEFT JOIN tb_tabela_tiss tipoConsulta with (nolock) ON (
    dadosComplementares.fk_tipo_consulta = tipoConsulta.id 
    AND tipoConsulta.registro_ativo = 1
  ) 
WHERE 
  procedimento.registro_ativo = 1 
  AND entidade.id = 43 
  AND convenio.id = 2 
  AND atendimento.situacaoAtendimento <> 6 
  AND tipoGuia.descricao = 'Consulta' 
  and (
    atendimento.numero_atendimento_automatico = 6127865
  ) 
GROUP BY 
  entidade.id, 
  entidade.sigla, 
  entidade.nome, 
  convenio.id, 
  convenio.sigla, 
  convenio.nome, 
  complemento.id, 
  complemento.descricao, 
  entidadeConvenio.id, 
  hospital.id, 
  hospital.sigla, 
  hospital.nome, 
  atendimento.id, 
  atendimento.numero_atendimento_automatico, 
  atendimento.senha, 
  atendimento.paciente, 
  atendimento.matricula_paciente, 
  atendimento.data_entrega, 
  atendimento.numero_guia, 
  atendimento.data_internacao, 
  atendimento.data_alta, 
  atendimento.plano, 
  atendimento.hora_digitacao, 
  atendimento.fk_tipo_atendimento, 
  tipoAtendimento.descricao, 
  atendimento.fk_motivo_alta, 
  motivoAlta.descricao, 
  dadosComplementares.id, 
  dadosComplementares.matricula_segurado, 
  dadosComplementares.nome_segurado, 
  dadosComplementares.data_validade_senha, 
  dadosComplementares.data_autorizacao, 
  atendimento.data_validade, 
  dadosComplementares.fk_indicador_acidente, 
  indicadorAcidente.descricao, 
  cooperadoExecutor.numero_conselho, 
  cooperadoExecutor.nome, 
  itemDespesa.id, 
  itemDespesa.codigo, 
  itemDespesa.descricao, 
  procedimentoTUSSVersao.id, 
  procedimentoTUSSVersao.codigo, 
  procedimentoTUSS.id, 
  procedimentoTUSS.descricao, 
  procedimento.id, 
  procedimento.tuss, 
  procedimento.guia_procedimento, 
  procedimento.autorizado_unimed, 
  procedimento.data_inicio, 
  procedimento.data_fim, 
  procedimento.hora_inicio, 
  procedimento.hora_fim, 
  procedimento.urgencia, 
  procedimento.quantidade, 
  procedimento.quantidade_ch, 
  procedimento.valor_honorario, 
  procedimento.valor_acrescimo_convenio, 
  procedimento.valor_desconto, 
  procedimento.valor_custo_operacional, 
  procedimento.valor_filme, 
  procedimento.valor_acrescimo, 
  procedimento.valor_percentual, 
  procedimento.valor_total, 
  procedimento.fk_acomodacao, 
  acomodacao.descricao, 
  procedimento.fk_grau_participacao, 
  grauParticipacao.descricao, 
  procedimento.fk_entidade_cooperado_especialidade, 
  especialidade.id, 
  especialidade.descricao, 
  procedimento.fk_tipo_guia, 
  tipoGuia.descricao, 
  procedimento.fk_tecnica, 
  tecnica.descricao, 
  procedimento.fk_via_acesso, 
  viaDeAcesso.descricao, 
  valorEspelhado.id, 
  valorEspelhado.valor_honorario, 
  valorEspelhado.valor_acrescimo_convenio, 
  valorEspelhado.valor_desconto, 
  valorEspelhado.valor_custo_operacional, 
  valorEspelhado.valor_filme, 
  valorEspelhado.valor_acrescimo, 
  glosa.id, 
  glosa.valor_honorario, 
  glosa.valor_desconto, 
  glosa.valor_custo_operacional, 
  glosa.valor_filme, 
  glosa.valor_acrescimo, 
  glosa.fk_motivo_glosa, 
  espelho.id, 
  espelho.numero_espelho, 
  valorFaturado.fk_fatura, 
  convenio.codigo_ans, 
  atendimento.guia_principal, 
  atendimento.rn, 
  hospital.cnpj, 
  conselhoProfissional.descricao, 
  uf.sigla, 
  codigoCBO.codigo, 
  procedimento.data_realizacao, 
  entidade.cnpj, 
  entidade.cnes, 
  tipoConsulta.descricao, 
  dadosComplementares.observacao, 
  codigoTabela.codigo, 
  codigoExcecao.codigo, 
  cooperadoExecutor.cpf_cnpj, 
  conselhoProfissional.sigla, 
  itemDespesa.tipo_item_despesa, 
  dadosComplementares.fk_tipo_consulta, 
  atendimento.data_validade, 
  cooperadoExecutor.cns, 
  complementoHospital.sigla, 
  complementoHospital.nome_razao_social, 
  codigoCBOPrincipal.codigo, 
  valorFaturado.valor_honorario, 
  valorFaturado.valor_acrescimo_convenio, 
  valorFaturado.valor_desconto, 
  valorFaturado.valor_custo_operacional, 
  valorFaturado.valor_filme, 
  valorFaturado.valor_acrescimo 
order by 
  atendimento.numero_atendimento_automatico asc;


select 
*
    from 
      tb_codigo_excecao_ans 
      inner join rl_entidadeconvenio_tipo_despesa_codigo_tabela_ans on rl_entidadeconvenio_tipo_despesa_codigo_tabela_ans.id = tb_codigo_excecao_ans.fk_entidadeconvenio_tipo_despesa_codigo_tabela_ans 
    where 
      rl_entidadeconvenio_tipo_despesa_codigo_tabela_ans.fk_entidade_convenio = 2611 
      AND rl_entidadeconvenio_tipo_despesa_codigo_tabela_ans.tipo_item_despesa = 3 

-- AND entidade.id = 43 
-- AND convenio.id = 2 

select * from rl_entidadeconvenio_tipo_despesa_codigo_tabela_ans;