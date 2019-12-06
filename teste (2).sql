    SELECT repasse.numero_repasse,
        servicoEspecial.nome AS cooperadoPessoaJuridica,
        procedimento.data_realizacao,
        atendimento.numero_atendimento_automatico,
        atendimento.paciente,
        convenio.sigla as convenio,
        hospital.sigla as hospital,
        fatura.numero_fatura,
           SUM(repasseLancamento.valor_lancamento) AS valor_lancamento,
        repasse.data_criacao as dataRepasse,
           entidade.sigla +' - ' +entidade.nome AS nomeEntidade,
           acomodacao.descricao,
           item.codigo,
           servicoEspecial.id,
           sum(movimentacaoNaEpocaDoRepasse.valor_saldo)-sum(movimentacao.valor_saldo) as saldo_inicial,
           sum(movimentacaoNaEpocaDoRepasse.valor_saldo) as saldo_final,
           sum(movimentacao.valor_saldo) as valor_movimentacao

    FROM rl_repasse_lancamento repasseLancamento
    INNER JOIN tb_repasse repasse ON repasse.id = repasseLancamento.fk_repasse
    AND repasse.registro_ativo=1
    INNER JOIN tb_pagamento_procedimento pagamento ON pagamento.id = repasseLancamento.fk_pagamento_procedimento
    AND pagamento.registro_ativo=1
    INNER JOIN tb_fatura fatura on(fatura.id=pagamento.fk_fatura and fatura.registro_ativo=1)
    INNER JOIN tb_procedimento procedimento ON procedimento.id = pagamento.fk_procedimento
    AND procedimento.registro_ativo=1
    INNER JOIN tb_cooperado servicoEspecial on(repasseLancamento.fk_cooperado_lancamento=servicoEspecial.id
    AND servicoEspecial.registro_ativo=1 and servicoEspecial.tipo_servico=1)
    INNER JOIN tb_item_despesa item ON item.id = procedimento.fk_item_despesa
    AND item.registro_ativo=1
    INNER JOIN tb_atendimento atendimento ON atendimento.id = procedimento.fk_atendimento
    AND atendimento.registro_ativo=1
    INNER JOIN tb_cooperado cooperadoExecutanteComplemento ON cooperadoExecutanteComplemento.id = procedimento.fk_cooperado_executante_complemento
    AND cooperadoExecutanteComplemento.registro_ativo=1
    INNER JOIN tb_entidade entidade on(entidade.id=repasse.fk_entidade
                                       AND entidade.registro_ativo=1)
    INNER JOIN rl_entidade_convenio entidadeConvenio on (entidadeConvenio.id = atendimento.fk_convenio and entidadeConvenio.registro_ativo = 1 and entidadeConvenio.fk_entidade = repasse.fk_entidade)
    INNER JOIN tb_convenio convenio on (convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1)
    INNER JOIN tb_hospital hospital on (hospital.id = atendimento.fk_hospital and hospital.registro_ativo = 1)
    INNER JOIN tb_tabela_tiss acomodacao on (acomodacao.id = procedimento.fk_acomodacao AND acomodacao.registro_ativo = 1)
    LEFT JOIN rl_movimentacao_saldo_repasse_fixo movimentacaoNaEpocaDoRepasse on (movimentacaoNaEpocaDoRepasse.fk_servico_especial = servicoEspecial.id and movimentacaoNaEpocaDoRepasse.registro_ativo=1 and movimentacaoNaEpocaDoRepasse.fk_repasse=repasse.id and movimentacaoNaEpocaDoRepasse.natureza_contabil is null)
    outer apply (select fk_servico_especial,fk_repasse,sum(valor_saldo) as valor_saldo from rl_movimentacao_saldo_repasse_fixo where repasse.id=fk_repasse and servicoEspecial.id=fk_servico_especial and registro_ativo=1 and natureza_contabil=0
    group by fk_servico_especial,fk_repasse) as movimentacao
    where repasse.registro_ativo = 1 and repasse.fk_entidade = :idEntidade and servicoEspecial.id<>cooperadoExecutanteComplemento.id

   
      and cooperado.id in (
      select cooperado.id from rl_entidade_grupo_cooperado_vincular_cooperado vincularCooperado
      inner join rl_entidade_cooperado entidadeCooperado on (entidadeCooperado.id = vincularCooperado.fk_entidade_cooperado and entidadeCooperado.registro_ativo = 1)
      inner join tb_cooperado cooperado on (cooperado.id = entidadeCooperado.fk_cooperado and cooperado.registro_ativo = 1)
      inner join rl_entidade_grupo_cooperado grupoCooperado on (grupoCooperado.id = vincularCooperado.fk_entidade_grupo_cooperado and grupoCooperado.registro_ativo = 1 )
      where vincularCooperado.fk_entidade_grupo_cooperado = :grupoCooperado and vincularCooperado.registro_ativo = 1)
