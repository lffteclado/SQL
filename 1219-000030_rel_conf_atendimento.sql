SELECT
      atendimento.id AS id_atendimento,
      atendimento.numero_atendimento_automatico AS numero_atendimento,
      hospital.sigla AS sigla_hospital,
      convenio.sigla AS sigla_convenio,
      atendimento.senha,
      dadosComplementares.data_validade_senha,
      solicitacao.cid_solicitacao AS cid,
      '' AS numero_boletim,
      dadosComplementares.data_autorizacao,
      atendimento.paciente,
      atendimento.matricula_paciente,
      dadosComplementares.nome_segurado,
      dadosComplementares.matricula_segurado,
      atendimento.plano,
      complemento.descricao AS descricao_complemento,
      atendimento.data_validade AS data_validade_carteira,
      atendimento.data_entrega,
      atendimento.numero_guia AS guia,
      tipoAtendimento.descricao AS tipo_atendimento,
      motivoAlta.descricao AS motivo_alta,
      acomodacaoAutorizada.descricao AS acomodacao_autorizada,
      tipoConsulta.descricao AS tipo_consulta,
      indicadorAcidente.descricao AS indicador_acidente,
      atendimento.data_cadastro AS data_digitacao,
      usuarioCadastro.nome AS nome_usuario,
      cooperadoExecucao.numero_conselho,
      cooperadoExecucao.nome AS nome_cooperado,
      procedimento.guia_procedimento,
      grauParticipacao.descricao AS funcao,
      especialidadeCooperado.descricao AS especialidade,
      case when procedimento.tuss = 1 then  procedimentoTussCodigoVersao.codigo+ ' - ' +procedimentoTuss.descricao
      else itemDespesa.codigo+ ' - '+itemDespesa.descricao   END AS procedimento,
      acomodacao.descricao AS acomodacao_procedimento,
      procedimento.data_inicio,
      procedimento.data_fim,
      procedimento.hora_inicio AS hora,
      tipoGuia.descricao AS tp,
      CASE WHEN procedimento.urgencia = 1 THEN 'S' ELSE 'N' END AS urgencia,  
      tecnicaProcedimento.codigo AS tecnica,
	  --tecnica.descricao AS tecnica,
      procedimento.valor_ch AS ch,
      procedimento.quantidade,
      case when pagamento.id is not null then pagamento.valor_custo_operacional + pagamento.valor_filme else procedimento.valor_custo_operacional + procedimento.valor_filme  end,
      case when pagamento.id is not null then pagamento.valor_honorario + pagamento.valor_acrescimo else procedimento.valor_honorario + procedimento.valor_acrescimo + procedimento.valor_acrescimo_convenio   end as valorHonorario,
      procedimento.valor_percentual, viaAcesso.descricao as viaAcesso,
      atendimento.data_internacao, atendimento.data_alta, case when pagamento.id is not null then pagamento.valor_desconto else procedimento.valor_desconto end AS valor_desconto,
      entidade.sigla, entidade.nome, complementoHospital.sigla AS siglaComplemento, atendimento.guia_principal, acomodacaoProcedimento.descricao, espelho.numero_espelho
    FROM tb_procedimento procedimento
    INNER JOIN tb_item_despesa itemDespesa ON (itemDespesa.id = procedimento.fk_item_despesa AND itemDespesa.registro_ativo = 1)
    INNER JOIN tb_cooperado cooperadoExecucao ON (cooperadoExecucao.id = procedimento.fk_cooperado_executante_complemento AND cooperadoExecucao.registro_ativo = 1)
    INNER JOIN tb_cooperado cooperadoRecebedor ON (cooperadoRecebedor.id = procedimento.fk_cooperado_recebedor_cobranca AND cooperadoRecebedor.registro_ativo = 1)
    INNER JOIN tb_atendimento atendimento ON (atendimento.id = procedimento.fk_atendimento AND atendimento.registro_ativo = 1)
    LEFT JOIN rl_entidade_hospital_complemento complementoHospital ON (atendimento.fk_complemento_hospital = complementoHospital.id AND complementoHospital.registro_ativo = 1)
    LEFT JOIN tb_dados_complementares dadosComplementares ON (dadosComplementares.fk_atendimento = atendimento.id AND dadosComplementares.registro_ativo = 1 AND dadosComplementares.id = (SELECT MAX(dc.id) FROM tb_dados_complementares dc where fk_atendimento = atendimento.id))
    LEFT JOIN tb_tabela_tiss tipoAtendimento ON (atendimento.fk_tipo_atendimento = tipoAtendimento.id AND tipoAtendimento.registro_ativo = 1)
    LEFT JOIN tb_tabela_tiss motivoAlta ON (atendimento.fk_motivo_alta = motivoAlta.id AND motivoAlta.registro_ativo = 1)
    LEFT JOIN rl_entidade_grau_participacao entidadeGrauParticipacao ON (procedimento.fk_grau_participacao = entidadeGrauParticipacao.id AND entidadeGrauParticipacao.registro_ativo = 1 )
    LEFT JOIN tb_tabela_tiss grauParticipacao ON (entidadeGrauParticipacao.fk_grau_participacao = grauParticipacao.id AND grauParticipacao.registro_ativo = 1)
    LEFT JOIN tb_tabela_tiss acomodacao ON (procedimento.fk_acomodacao = acomodacao.id AND acomodacao.registro_ativo = 1)
    LEFT JOIN tb_tabela_tiss tipoConsulta ON (dadosComplementares.fk_tipo_consulta = tipoConsulta.id AND tipoConsulta.registro_ativo = 1)
    LEFT JOIN tb_tabela_tiss indicadorAcidente ON (dadosComplementares.fk_indicador_acidente = indicadorAcidente.id AND indicadorAcidente.registro_ativo = 1)
    LEFT JOIN rl_entidadecooperado_especialidade entidadeCooperadoEspecialidade ON (entidadeCooperadoEspecialidade.id = procedimento.fk_entidade_cooperado_especialidade AND entidadeCooperadoEspecialidade.registro_ativo = 1)
    LEFT JOIN tb_tabela_tiss especialidadeCooperado ON (entidadeCooperadoEspecialidade.fk_especialidade = especialidadeCooperado.id AND especialidadeCooperado.registro_ativo = 1)
    LEFT JOIN rl_entidade_acomodacao entidadeAcomodacao ON (dadosComplementares.fk_acomodacao_autorizada = entidadeAcomodacao.id AND entidadeAcomodacao.registro_ativo = 1)
    LEFT JOIN tb_tabela_tiss acomodacaoAutorizada ON (entidadeAcomodacao.fk_acomodacao = acomodacaoAutorizada.id AND acomodacaoAutorizada.registro_ativo = 1)
    LEFT JOIN rl_entidade_usuario entidadeUsuarioCadastro ON (atendimento.fk_usuario = entidadeUsuarioCadastro.id AND entidadeUsuarioCadastro.registro_ativo = 1)
    LEFT JOIN tb_usuario usuarioCadastro ON (entidadeUsuarioCadastro.fk_usuario = usuarioCadastro.id AND usuarioCadastro.registro_ativo = 1)
    LEFT JOIN rl_entidadeconvenio_complemento complemento ON (atendimento.fk_complemento = complemento.id AND complemento.registro_ativo = 1)
    INNER JOIN rl_entidade_convenio entidadeConvenio ON (entidadeConvenio.id = atendimento.fk_convenio AND entidadeConvenio.registro_ativo = 1)
    INNER JOIN tb_convenio convenio ON (convenio.id = entidadeConvenio.fk_convenio AND convenio.registro_ativo = 1)
    INNER JOIN tb_entidade entidade ON (entidade.id = entidadeConvenio.fk_entidade AND entidade.registro_ativo = 1)
    INNER JOIN tb_hospital hospital ON (hospital.id = atendimento.fk_hospital AND hospital.registro_ativo = 1)
    LEFT JOIN tb_tabela_tiss tipoGuia ON (procedimento.fk_tipo_guia = tipoGuia.id AND tipoGuia.registro_ativo = 1)
    LEFT JOIN tb_tabela_tiss viaAcesso ON (procedimento.fk_via_acesso = viaAcesso.id AND viaAcesso.registro_ativo = 1)
	LEFT JOIN tb_tabela_tiss tecnica ON (procedimento.fk_tecnica = tecnica.id AND tecnica.registro_ativo = 1)
	LEFT JOIN tb_tabela_tiss_versao_codigo tecnicaProcedimento ON (tecnicaProcedimento.fk_tabela_tiss = tecnica.id AND tecnicaProcedimento.registro_ativo = 1 /*AND tecnicaProcedimento.versao_tiss = entidadeConvenio.versao_tiss*/)
    LEFT JOIN rl_atendimento_inconsistencia atendimentoInconsistencia on ( atendimentoInconsistencia.fk_atendimento = atendimento.id AND atendimentoInconsistencia.registro_ativo = 1)
    LEFT JOIN rl_atendimento_tipo_pendencia pendencia ON (pendencia.fk_atendimento = atendimento.id AND pendencia.registro_ativo = 1 )
    LEFT JOIN tb_espelho espelho ON (espelho.id = atendimento.fk_espelho AND espelho.registro_ativo = 1)
    LEFT JOIN tb_pagamento_procedimento pagamento ON (pagamento.fk_procedimento = procedimento.id AND pagamento.registro_ativo = 1)
    LEFT JOIN tb_fatura fatura ON (fatura.id = pagamento.fk_fatura AND fatura.registro_ativo = 1)
    LEFT JOIN tb_pagamento_fatura pagamentoFatura on ( pagamentoFatura.fk_fatura = fatura.id AND pagamentoFatura.registro_ativo = 1 )
    LEFT JOIN tb_repasse repasse ON (repasse.id = pagamentoFatura.fk_repasse AND repasse.registro_ativo = 1 )
    LEFT JOIN tb_tabela_tiss_versao_codigo procedimentoTussCodigoVersao ON (procedimento.fk_procedimento_tuss = procedimentoTussCodigoVersao.id AND procedimentoTussCodigoVersao.registro_ativo = 1)
    LEFT JOIN tb_tabela_tiss procedimentoTuss ON (procedimentoTussCodigoVersao.fk_tabela_tiss = procedimentoTuss.id AND procedimentoTuss.registro_ativo = 1)
    LEFT JOIN  tb_arquivo_integracao_hospitais integracaoWS on (integracaoWS.id = atendimento.fk_integracao_ws and integracaoWS.registro_ativo = 1)

    outer apply( select top 1 acomodacaoTiss.descricao from tb_procedimento proced with (nolock)
    LEFT JOIN tb_tabela_tiss acomodacaoTiss with (nolock) ON (acomodacaoTiss.id = proced.fk_acomodacao AND acomodacaoTiss.registro_ativo = 1)
    where proced.fk_atendimento = atendimento.id order by proced.id asc
    ) acomodacaoProcedimento
    LEFT JOIN tb_dados_solicitacao solicitacao with (nolock)  ON (solicitacao.fk_atendimento = atendimento.id and solicitacao.registro_ativo = 1)

    WHERE procedimento.registro_ativo = 1
    AND atendimento.autorizado_unimed = 1
    AND entidadeConvenio.fk_entidade = 10
	AND atendimento.numero_atendimento_automatico = 9627173

	GROUP BY
     atendimento.id,
     atendimento.numero_atendimento_automatico,
     hospital.sigla,
     convenio.sigla,
     atendimento.senha,
     dadosComplementares.data_validade_senha,
     dadosComplementares.data_autorizacao,
     atendimento.paciente,
     atendimento.matricula_paciente,
     dadosComplementares.nome_segurado,
     dadosComplementares.matricula_segurado,
     atendimento.plano,
     complemento.descricao,
     atendimento.data_validade, atendimento.guia_principal,
     atendimento.data_entrega,
     atendimento.numero_guia,
     tipoAtendimento.descricao,
     motivoAlta.descricao,
     acomodacaoAutorizada.descricao,
     tipoConsulta.descricao,
     indicadorAcidente.descricao,
     atendimento.data_cadastro,
     usuarioCadastro.nome,
     cooperadoExecucao.numero_conselho,
     cooperadoExecucao.nome,
     procedimento.guia_procedimento,
     grauParticipacao.descricao,
     especialidadeCooperado.descricao,
     procedimento.tuss,
     procedimentoTussCodigoVersao.codigo+ ' - ' +procedimentoTuss.descricao,
     itemDespesa.codigo +' - '+itemDespesa.descricao,
     acomodacao.descricao,
     procedimento.data_inicio,
     procedimento.data_fim,
     procedimento.hora_inicio,
     procedimento.data_realizacao,
     tipoGuia.descricao,
     procedimento.urgencia, 
     tecnicaProcedimento.codigo,
     procedimento.valor_ch,
     procedimento.quantidade,
     pagamento.id, pagamento.valor_custo_operacional,
     pagamento.valor_honorario, pagamento.valor_filme, pagamento.valor_acrescimo, pagamento.valor_acrescimo_convenio , pagamento.valor_desconto,
     procedimento.valor_custo_operacional,
     procedimento.valor_honorario, procedimento.valor_filme, procedimento.valor_acrescimo,procedimento.valor_acrescimo_convenio , procedimento.valor_desconto,
     procedimento.valor_percentual, viaAcesso.descricao,
     atendimento.data_internacao, atendimento.data_alta, atendimento.numero_guia,
     entidade.sigla, entidade.nome,
     procedimento.id,acomodacaoProcedimento.descricao, solicitacao.cid_solicitacao,
     complementoHospital.sigla, espelho.numero_espelho
	 --tecnica.descricao

