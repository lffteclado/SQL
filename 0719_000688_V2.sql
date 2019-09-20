SELECT
    --Atendimento
        atendimento.id AS id_atendimento, --0
        atendimento.numero_atendimento_automatico, -- 1
        atendimento.ano_atendimento, --2
        atendimento.numero_guia, --3
        atendimento.guia_solicitacao_internacao, --4
        atendimento.senha, --5
        atendimento.matricula_paciente, --6
        atendimento.rn AS recem_nascido, --7
        atendimento.paciente, --8
        atendimento.data_internacao, --9
        atendimento.data_alta, --10
        atendimento.fk_tipo_atendimento, --11
        atendimento.fk_motivo_alta, --12
   
     --Cooperado Executante

        cooperadoExecutante.id AS id_cooperado_executante, --13
        cooperadoExecutante.nome AS nome_cooperado_executante, --14
        cooperadoExecutante.cpf_cnpj AS cpf_cnpj_cooperado_executante, --15
        cooperadoExecutante.numero_conselho AS numero_conselho_cooperado_executante, --16
        cooperadoExecutante.fk_conselho_profissional AS fk_conselho_profissional_cooperado_executante, --17
   
     --Cooperado Recebedor

        cooperadoRecebedor.id AS id_cooperado_recebedor, --18
        cooperadoRecebedor.nome AS nome_cooperado_recebedor, --19
        cooperadoRecebedor.cpf_cnpj AS cpf_cnpj_cooperado_recebedor, --20
        cooperadoRecebedor.numero_conselho AS numero_conselho_cooperado_recebedor, --21
        cooperadoRecebedor.fk_conselho_profissional AS fk_conselho_profissional_cooperado_recebedor, --22
       
     --Cooperado Solicitante

        cooperadoSolicitante.id AS id_cooperado_solicitante,--23
        case when TabelaTempDadosSolicitacao.id is not null then (
        case when  cooperadoSolicitante.id is not null then cooperadoSolicitante.nome --24
        else TabelaTempDadosSolicitacao.nome_solicitante end )
		else cooperadoSolicitante.nome end nome_cooperado_solicitante,--24
        cooperadoSolicitante.cpf_cnpj AS cpf_cnpj_cooperado_solicitante, --25
		case when TabelaTempDadosSolicitacao.id is not null then (
        case when  cooperadoSolicitante.id is not null then cooperadoSolicitante.numero_conselho --26
        else TabelaTempDadosSolicitacao.numero_conselho end ) else cooperadoSolicitante.numero_conselho --26
        end numero_conselho_cooperado_solicitante, --26
		case when TabelaTempDadosSolicitacao.id is not null then (
        case when  cooperadoSolicitante.id is not null then cooperadoSolicitante.fk_conselho_profissional --27
        else TabelaTempDadosSolicitacao.fk_conselho_profissional end ) --27
        else cooperadoSolicitante.fk_conselho_profissional end fk_conselho_profissional_cooperado_solicitante,--27
      
     --Procedimento

        procedimento.id AS id_procedimento, --28
        procedimento.data_realizacao, --29
        procedimento.hora_inicio, --30
    
        case when procedimento.hora_inicio is not null and  procedimento.hora_fim is null and entidadeConvenio.quantidade_minutos_hora_fim > 0--31
    
        then DATEADD(MINUTE, COALESCE(entidadeConvenio.quantidade_minutos_hora_fim,0) , hora_inicio) else procedimento.hora_fim end,--31
        procedimento.tuss,--32
        procedimento.fk_tecnica,--33
    
        COALESCE(procedimento.fk_unidade_medida, 110761) AS fk_unidade_medida,--34
        procedimento.fk_tipo_guia,--35
        procedimento.fk_entidade_cooperado_especialidade,--36
        procedimento.fk_acomodacao,--37
   
      --Pagamento Procedimento
                
          pagamentoProcedimento.id AS id_pagamento_procedimento,--38
          pagamentoProcedimento.valor_honorario,--39
          pagamentoProcedimento.valor_custo_operacional,--40
          pagamentoProcedimento.valor_filme,--41
          pagamentoProcedimento.valor_acrescimo,--42
          pagamentoProcedimento.valor_desconto,--43

   
    --Item Despesa
        itemDespesa.id AS id_item_despesa,--44
        itemDespesa.codigo AS codigo_item_despesa,--45
        itemDespesa.descricao AS descricao_item_despesa,--46
        itemDespesa.tipo_item_despesa AS tipo_item_despesa,--47
   
    --Procedimento TUSS
        procedimento.fk_procedimento_tuss,--48
        procedimentoTUSS.codigo AS codigo_procedimento_tuss,--49
   
    --DadosComplementares
        dadosComplementares.id AS id_dados_complementares,--50
        dadosComplementares.observacao AS observacao_dados_complementares,--51
        dadosComplementares.data_autorizacao,--52
        dadosComplementares.data_validade_senha,--53
        COALESCE(dadosComplementares.fk_indicador_acidente,109935) AS fk_indicador_acidente,--54
        dadosComplementares.fk_tipo_consulta,--55
   
    --Dados Solicitação
        TabelaTempDadosSolicitacao.id AS id_dados_solicitacao,--56
        TabelaTempDadosSolicitacao.data_solicitacao,--57
   
    --Convênio
           convenio.id AS id_convenio, --59
           convenio.cnpj AS cnpj_convenio, --60
           convenio.nome AS nome_convenio, --61
           convenio.codigo_ans AS codigo_ans_convenio, --62
   
     --Hospital
        hospital.id AS id_hospital, --63
        hospital.cnpj AS cnpj_hospital, --64
        hospital.nome AS nome_hospital, --65
   
     --Entidade
           entidade.id AS id_entidade, --66
           entidade.cnes AS cnes_entidade, --67
           entidade.cnpj AS cnpj_entidade, --68
           entidade.nome AS nome_entidade, --69
   
     --EntidadeConvênio
        entidadeConvenio.id AS id_entidade_convenio, --70
    
       entidadeConvenio.versao_tiss AS versao_tiss_convenio, --71
    
       entidadeConvenio.opcao_origem_contratado AS opcao_origem_contratado_executante, --72
       entidadeConvenio.codigo_do_prestador_na_operadora, --73
        entidadeConvenio.enviarTAGMembroEquipeSPSAPDTTISS,--74
   
     --Tabela do Item Despesa (Verificar se o Default é 22 mesmo)
    
    
        entidadeConvenioTipoDespesaCodigoTabelaANS.id AS id_entidade_convenio_tipo_despesa_codigo_tabela_ans,--75
    
        case
		  when TabelaTemporariaCodigoExcecaoTabelaANS.id is not null
		  then TabelaTemporariaCodigoExcecaoTabelaANS.codigo_excecao_ans --76
		  else entidadeConvenioTipoDespesaCodigoTabelaANS.codigo_tabela_ans --76
		  end codigo_tabela_ans_tipo_item_e_convenio,
          tipoTabelaTissHistoricoTabelaHonorario.id AS id_tipo_tabela_tiss_historico_tabela_honorario,    
          tipoTabelaTissHistoricoTabelaHonorario.numero_tabela AS codigo_tabela_ans_historico_tabela,
       
     --Número Prestador
        TabelaTempNumeroPrestador.numero_prestador,
       
     --Memória Cálculo
        TabelaTempMemoriaCalculo.id AS id_memoria_calculo,
    
        TabelaTempMemoriaCalculo.total AS total_memoria_calculo,
    
        TabelaTempMemoriaCalculo.adicionalApartamento AS adicional_apartamento_memoria_calculo,
    
        TabelaTempMemoriaCalculo.adicionalEnfermaria AS adicional_enfermaria_memoria_calculo,
    
        TabelaTempMemoriaCalculo.adicionalExterno AS adicional_externo_memoria_calculo,
    
        TabelaTempMemoriaCalculo.adicionalUrgencia AS adicional_urgencia_memoria_calculo,      

     --Cooperado
    
        cooperadoExecutante.fk_uf AS fk_uf_cooperado_executante,

    case when TabelaTempDadosSolicitacao.id is not null then (
    
        case when  cooperadoSolicitante.id is not null then cooperadoSolicitante.fk_uf
    else TabelaTempDadosSolicitacao.fk_uf end )
    
        else  cooperadoSolicitante.fk_uf end fk_uf_cooperado_solicitante,

        cooperadoRecebedor.fk_uf AS fk_uf_cooperado_recebedor,

    --Tiss
    
             coalesce(CASE WHEN conselhoProfissionalExecutanteVersao.id IS NOT NULL THEN conselhoProfissionalExecutanteVersao.codigo ELSE conselhoProfissionalExecutanteVersaoDefault.codigo END,6) AS codigo_tiss_conselho_profissional_executante,
    
             coalesce(CASE WHEN ufConselhoProfissionalExecutanteVersao.id IS NOT NULL THEN ufConselhoProfissionalExecutanteVersao.codigo ELSE ufConselhoProfissionalExecutanteVersaoDefault.codigo END,31) AS codigo_tiss_uf_conselho_profissional_executante,

    
            coalesce( case when TabelaTempDadosSolicitacao.id is not null then (
    
            case when ufConselhoProfissionalSolicitanteVersao.id is not null then conselhoProfissionalSolicitanteVersao.codigo
    
            else case when conselhoProfissionalSolicitanteNaoCooperadoVersao.codigo is not null
    
            then conselhoProfissionalSolicitanteNaoCooperadoVersao.codigo else conselhoProfissionalSolicitanteVersaoDefault.codigo end end )
    
            else  conselhoProfissionalSolicitanteVersaoDefault.codigo
       end , 6)codigo_tiss_conselho_profissional_solicitante,
    
         coalesce( case when TabelaTempDadosSolicitacao.id is not null then ( 
    
         case when ufConselhoProfissionalSolicitanteVersao.id is not null then ufConselhoProfissionalSolicitanteVersao.codigo
    
         else case when ufConselhoProfissionalSolicitanteNaoCooperadoVersao.codigo is not null
    
         then ufConselhoProfissionalSolicitanteNaoCooperadoVersao.codigo else ufConselhoProfissionalSolicitanteVersaoDefault.codigo end end )
    else  ufConselhoProfissionalSolicitanteVersaoDefault.codigo
    end , 31)codigo_tiss_uf_conselho_profissional_solicitante,

    
             coalesce(CASE WHEN ufConselhoProfissionalRecebedorVersao.id IS NOT NULL THEN ufConselhoProfissionalRecebedorVersao.codigo ELSE ufConselhoProfissionalRecebedorVersaoDefault.codigo END,31) AS codigo_tiss_uf_conselho_profissional_recebedor,
    
             coalesce(CASE WHEN tipoConsultaVersao.id IS NOT NULL THEN tipoConsultaVersao.codigo ELSE tipoConsultaVersaoDefault.codigo END,1) AS codigo_tiss_tipo_consulta,
    
             CASE WHEN tipoAtendimentoVersao.id IS NOT NULL THEN tipoAtendimentoVersao.codigo ELSE  tipoAtendimentoVersaoDefault.codigo END AS codigo_tiss_tipo_atendimento,
    
             CASE WHEN motivoAltaVersao.id IS NOT NULL THEN motivoAltaVersao.codigo ELSE motivoAltaVersaoDefault.codigo END AS codigo_tiss_motivo_alta,
    
             CASE WHEN viaAcessoVersao.id IS NOT NULL THEN viaAcessoVersao.codigo ELSE viaAcessoVersaoDefault.codigo END AS codigo_tiss_via_acesso,
    
             COALESCE(CASE WHEN especialidadeVersao.id IS NOT NULL THEN especialidadeVersao.codigo ELSE especialidadeVersaoDefault.codigo END,CASE WHEN especialidadeVersaoPrincipal.id IS NOT NULL THEN especialidadeVersaoPrincipal.codigo  ELSE especialidadeVersaoPrincipalDefault.codigo END ) AS codigo_tiss_especialidade,
    
          case when TabelaTempDadosSolicitacao.id is not null then (
    
          case when especialidadeSolicitanteVersao.id is not null then especialidadeSolicitanteVersao.codigo
    
          else case when especialidadeSolicitanteNaoCooperadoVersao.codigo is not null
    
          then especialidadeSolicitanteNaoCooperadoVersao.codigo else especialidadeSolicitanteNaoCooperadoVersaoDefault.codigo end end )
     else  especialidadeSolicitanteVersaoDefault.codigo
     end codigo_tiss_especialidade_solicitante,

    
             CASE WHEN indicadorAcidenteVersao.id IS NOT NULL THEN indicadorAcidenteVersao.codigo ELSE indicadorAcidenteVersaoDefault.codigo END AS codigo_tiss_indicador_acidente,
    
             CASE WHEN entidadeGrauParticipacao.id IS NOT NULL THEN grauParticipacaoVersaoDefault.codigo ELSE grauParticipacaoVersao.codigo END AS codigo_tiss_grau_participacao,
    
             CASE WHEN taxasAlugueisVersao.id IS NOT NULL THEN taxasAlugueisVersao.codigo ELSE taxasAlugueisVersaoDefault.codigo END AS codigo_tiss_taxas_alugueis,
    
             CASE WHEN unidadeDeMedidaVersao.id IS NOT NULL THEN unidadeDeMedidaVersao.codigo ELSE unidadeDeMedidaVersaoDefault.codigo END AS codigo_tiss_unidade_medida,
     --dados faltantes
    
             COALESCE(procedimento.fk_via_acesso, 110778) AS fk_via_acesso,
    
             procedimento.fk_grau_participacao AS fk_grau_participacao_procedimento,
    
             COALESCE(entidadeGrauParticipacao.fk_grau_participacao, 109929) AS fk_grau_participacao,
    
             entidadeCooperadoSolicitanteEspecialidade.id AS id_entidade_cooperado_solicitante_specialidade,
        procedimento.quantidade AS quantidade_procedimento,
    
             procedimentoTUSSDescricao.descricao AS descricao_procedimento_tuss,
        hospital.cnes AS cnes_hospital,
    
             entidadeConvenioAcomodacaoCaraterAtendimento.id AS id_entidade_convenio_acomodacao_carater_atendimento,
    
             entidadeConvenioAcomodacaoCaraterAtendimento.fk_carater_atendimento,
    
             TabelaTempMemoriaCalculo.fk_entidade_convenio_historico_tabela_honorario,
    
             CASE WHEN materialVersao.id IS NOT NULL THEN materialVersao.codigo ELSE materialVersaoDefault.codigo END AS codigo_tiss_materiais,
    
             CASE WHEN medicamentoVersao.id IS NOT NULL THEN medicamentoVersao.codigo ELSE medicamentoVersaoDefault.codigo END AS codigo_tiss_medicamentos,
        procedimento.urgencia AS urgencia_procedimento,
    
             entidadeConvenio.tipo_redutor_acrescimo, entidadeConvenio.enviar_grau_participacao_padrao , entidadeConvenio.enviar_numero_guia_operadora, atendimento.guia_principal,
    
         (select top 1 coalesce(valor_honorario,0)+coalesce(valor_custo_operacional,0)+coalesce(valor_filme,0)+coalesce(valor_acrescimo,0)-coalesce(valor_desconto,0)+coalesce(valor_acrescimoConvenio,0)  from tb_glosa as glosa where glosa.registro_ativo=1
    
         and glosa.situacao in (1,3,7) and glosa.fk_procedimento=procedimento.id order by id desc ) as valorGlosado,
   
     --EspecialidadeDescrica o,Datas
    
         CASE WHEN especialidadeTiss.id IS NOT NULL THEN especialidadeTiss.descricao ELSE especialidadeTissPrincipal.descricao END as especialidadeMedica,
    procedimento.data_inicio as procedimentoDtaIni,
    procedimento.data_fim as procedimentoDtaFim, -- 123
    procedimento.valor_percentual AS valorPercentual, -- 124
    itemPorteAnestesia.id AS fkItemPorteAnestesia, -- 125
    itemPorteAnestesia.codigo AS codigoItemPorteAnestesia, -- 126
	TabelaTempDadosSolicitacao.indicacao_clinica -- 127
    FROM tb_atendimento atendimento with(nolock)
    
         INNER JOIN tb_procedimento procedimento with(nolock) ON (procedimento.fk_atendimento = atendimento.id AND procedimento.registro_ativo=1)
    
         INNER JOIN tb_espelho espelho with(nolock) ON (espelho.id = atendimento.fk_espelho AND espelho.registro_ativo=1)
    
         INNER JOIN rl_entidade_convenio entidadeConvenio with(nolock) ON (entidadeConvenio.id = atendimento.fk_convenio AND entidadeConvenio.registro_ativo=1)
    
         INNER JOIN tb_entidade entidade with(nolock) ON (entidade.id = entidadeConvenio.fk_entidade AND entidade.registro_ativo=1)
    
         INNER JOIN tb_convenio convenio with(nolock) ON (convenio.id = entidadeConvenio.fk_convenio AND convenio.registro_ativo=1)
    
         INNER JOIN tb_hospital hospital with(nolock) ON (hospital.id = atendimento.fk_hospital AND hospital.registro_ativo=1)
    
         INNER JOIN tb_cooperado cooperadoExecutante with(nolock) ON (cooperadoExecutante.id = procedimento.fk_cooperado_executante_complemento AND cooperadoExecutante.registro_ativo=1)
    
         INNER JOIN tb_cooperado cooperadoRecebedor with(nolock) ON (cooperadoRecebedor.id = procedimento.fk_cooperado_recebedor_cobranca AND cooperadoRecebedor.registro_ativo=1)
      
         INNER JOIN tb_pagamento_procedimento pagamentoProcedimento with(nolock) ON (pagamentoProcedimento.fk_procedimento = procedimento.id AND pagamentoProcedimento.registro_ativo=1)
		     
         LEFT JOIN tb_glosa glosa with(nolock) ON (glosa.fk_procedimento = procedimento.id AND glosa.registro_ativo = 1)
    
         LEFT JOIN(SELECT memoriaCalculo.id, memoriaCalculo.fk_procedimento, fk_entidade_convenio_historico_tabela_honorario,total, adicionalApartamento, adicionalEnfermaria, adicionalExterno, adicionalUrgencia,
		           ROW_NUMBER() OVER (PARTITION BY memoriaCalculo.fk_procedimento ORDER BY memoriaCalculo.id DESC) AS rankTabela
				   FROM tb_memoria_calculo memoriaCalculo with(nolock)    
					INNER JOIN tb_procedimento procedimentoMemoria with(nolock) ON(procedimentoMemoria.id = memoriaCalculo.fk_procedimento and procedimentoMemoria.registro_ativo=1)
			        INNER JOIN tb_atendimento atendimentoMemoria with(nolock) ON(atendimentoMemoria.id = procedimentoMemoria.fk_atendimento and atendimentoMemoria.registro_ativo=1)
					INNER JOIN tb_pagamento_procedimento pagamentoProcedimentoMemoria with(nolock) ON(pagamentoProcedimentoMemoria.fk_procedimento = procedimentoMemoria.id AND pagamentoProcedimentoMemoria.registro_ativo=1 AND pagamentoProcedimentoMemoria.fk_fatura IS NULL)
		           WHERE memoriaCalculo.registro_ativo=1 AND atendimentoMemoria.fk_espelho=1    
                  ) AS TabelaTempMemoriaCalculo ON (TabelaTempMemoriaCalculo.fk_procedimento = procedimento.id AND TabelaTempMemoriaCalculo.rankTabela=1)    
         LEFT JOIN rl_entidadeconvenio_historico_tabela_honorario entidadeConvenioHistoricoTabelaHonorario with(nolock) ON (entidadeConvenioHistoricoTabelaHonorario.id = TabelaTempMemoriaCalculo.fk_entidade_convenio_historico_tabela_honorario AND entidadeConvenioHistoricoTabelaHonorario.registro_ativo=1)
         LEFT JOIN tb_tipo_tabela_tiss tipoTabelaTissHistoricoTabelaHonorario with(nolock) ON (tipoTabelaTissHistoricoTabelaHonorario.id = entidadeConvenioHistoricoTabelaHonorario.fk_tipo_tabela_tiss)
         LEFT JOIN tb_item_despesa itemDespesa with(nolock) ON (itemDespesa.id = procedimento.fk_item_despesa AND itemDespesa.registro_ativo=1)
         LEFT JOIN rl_entidadeconvenio_tipo_despesa_codigo_tabela_ans entidadeConvenioTipoDespesaCodigoTabelaANS with(nolock) ON(entidadeConvenioTipoDespesaCodigoTabelaANS.fk_entidade_convenio = entidadeConvenio.id AND entidadeConvenioTipoDespesaCodigoTabelaANS.tipo_item_despesa = itemDespesa.tipo_item_despesa AND entidadeConvenioTipoDespesaCodigoTabelaANS.registro_ativo=1)
         LEFT JOIN tb_tabela_tiss_versao_codigo taxasAlugueisVersao with(nolock) ON(taxasAlugueisVersao.fk_tabela_tiss = 109804 AND itemDespesa.tipo_item_despesa = 4 AND taxasAlugueisVersao.registro_ativo=1 AND taxasAlugueisVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
         LEFT JOIN tb_tabela_tiss_versao_codigo taxasAlugueisVersaoDefault with(nolock) ON(taxasAlugueisVersaoDefault.fk_tabela_tiss = 109804 AND itemDespesa.tipo_item_despesa = 4 AND taxasAlugueisVersaoDefault.registro_ativo=1 AND taxasAlugueisVersaoDefault.versao_tiss = 5)
         LEFT JOIN tb_tabela_tiss_versao_codigo materialVersao with(nolock) ON(materialVersao.fk_tabela_tiss = 109802 AND itemDespesa.tipo_item_despesa = 2 AND materialVersao.registro_ativo=1 AND materialVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
         LEFT JOIN tb_tabela_tiss_versao_codigo materialVersaoDefault with(nolock) ON(materialVersaoDefault.fk_tabela_tiss = 109802 AND itemDespesa.tipo_item_despesa = 2 AND materialVersaoDefault.registro_ativo=1 AND materialVersaoDefault.versao_tiss = 5)
         LEFT JOIN tb_tabela_tiss_versao_codigo medicamentoVersao with(nolock) ON(medicamentoVersao.fk_tabela_tiss = 109801 AND itemDespesa.tipo_item_despesa = 1 AND medicamentoVersao.registro_ativo=1 AND medicamentoVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
         LEFT JOIN tb_tabela_tiss_versao_codigo medicamentoVersaoDefault with(nolock) ON(medicamentoVersaoDefault.fk_tabela_tiss = 109801 AND itemDespesa.tipo_item_despesa = 1 AND medicamentoVersaoDefault.registro_ativo=1 AND medicamentoVersaoDefault.versao_tiss = 5)
         LEFT JOIN tb_tabela_tiss_versao_codigo procedimentoTUSS with(nolock) ON (procedimentoTUSS.id = procedimento.fk_procedimento_tuss
		     AND procedimentoTUSS.registro_ativo=1)
         LEFT JOIN tb_tabela_tiss procedimentoTUSSDescricao with(nolock) ON (procedimentoTUSSDescricao.id = procedimentoTUSS.fk_tabela_tiss
			AND procedimentoTUSSDescricao.registro_ativo=1)
         LEFT JOIN tb_dados_complementares dadosComplementares with(nolock) ON (dadosComplementares.fk_atendimento = atendimento.id AND dadosComplementares.registro_ativo=1)
         LEFT JOIN(SELECT dadosSolicitacao.id,
		                  dadosSolicitacao.fk_atendimento,
						  dadosSolicitacao.fk_cooperado_solicitante,
						  dadosSolicitacao.data_solicitacao,
						  dadosSolicitacao.indicacao_clinica,
	                      dadosSolicitacao.fk_conselho_profissional,
						  dadosSolicitacao.fk_uf,
						  dadosSolicitacao.numero_conselho,
						  dadosSolicitacao.nome_solicitante,
						  dadosSolicitacao.fk_especialidade,
                    ROW_NUMBER() OVER (PARTITION BY dadosSolicitacao.fk_atendimento ORDER BY dadosSolicitacao.id) AS rankTabela
		                    FROM tb_dados_solicitacao dadosSolicitacao  with(nolock)
                            INNER JOIN tb_atendimento atendimentoSolicitacao with(nolock) ON (atendimentoSolicitacao.id = dadosSolicitacao.fk_atendimento AND atendimentoSolicitacao.registro_ativo=1)
                            INNER JOIN tb_procedimento procedimentoSolicitacao with(nolock) ON (procedimentoSolicitacao.fk_atendimento = atendimentoSolicitacao.id AND procedimentoSolicitacao.registro_ativo=1)
                            INNER JOIN tb_pagamento_procedimento pagamentoProcedimentoSolicitacao with(nolock) ON (pagamentoProcedimentoSolicitacao.fk_procedimento = procedimentoSolicitacao.id AND pagamentoProcedimentoSolicitacao.registro_ativo=1 AND pagamentoProcedimentoSolicitacao.fk_fatura IS NULL)
      						 WHERE dadosSolicitacao.registro_ativo=1 AND atendimentoSolicitacao.fk_espelho = 627922) AS TabelaTempDadosSolicitacao ON (TabelaTempDadosSolicitacao.fk_atendimento = atendimento.id AND TabelaTempDadosSolicitacao.rankTabela=1)
         LEFT JOIN tb_cooperado cooperadoSolicitante with(nolock) ON (cooperadoSolicitante.id = TabelaTempDadosSolicitacao.fk_cooperado_solicitante AND cooperadoSolicitante.registro_ativo=1)
         LEFT JOIN(SELECT id, fk_entidade, fk_hospital, fk_convenio, numero_prestador,ROW_NUMBER() OVER (PARTITION BY fk_entidade, fk_hospital, fk_convenio ORDER BY numeroPrestador.id DESC) AS rankTabela FROM tb_numero_prestador numeroPrestador with(nolock) WHERE numeroPrestador.registro_ativo=1) AS TabelaTempNumeroPrestador ON (TabelaTempNumeroPrestador.fk_entidade = entidade.id AND TabelaTempNumeroPrestador.fk_hospital = hospital.id
			  AND TabelaTempNumeroPrestador.fk_convenio = convenio.id AND TabelaTempNumeroPrestador.rankTabela=1)
         LEFT JOIN tb_tabela_tiss_versao_codigo indicadorAcidenteVersao with(nolock) ON (indicadorAcidenteVersao.fk_tabela_tiss = COALESCE(dadosComplementares.fk_indicador_acidente,109935)
		     AND indicadorAcidenteVersao.registro_ativo=1 AND indicadorAcidenteVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
         LEFT JOIN tb_tabela_tiss_versao_codigo indicadorAcidenteVersaoDefault with(nolock) ON (indicadorAcidenteVersaoDefault.fk_tabela_tiss = COALESCE(dadosComplementares.fk_indicador_acidente,109935)
			AND indicadorAcidenteVersaoDefault.registro_ativo=1 AND indicadorAcidenteVersaoDefault.versao_tiss = 5)
         LEFT JOIN tb_tabela_tiss_versao_codigo tipoAtendimentoVersao with(nolock) ON (tipoAtendimentoVersao.fk_tabela_tiss = atendimento.fk_tipo_atendimento
			AND tipoAtendimentoVersao.registro_ativo=1 AND tipoAtendimentoVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
         LEFT JOIN tb_tabela_tiss_versao_codigo tipoAtendimentoVersaoDefault with(nolock) ON (tipoAtendimentoVersaoDefault.fk_tabela_tiss = atendimento.fk_tipo_atendimento
            AND tipoAtendimentoVersaoDefault.registro_ativo=1 AND tipoAtendimentoVersaoDefault.versao_tiss = 5)
         LEFT JOIN tb_tabela_tiss_versao_codigo motivoAltaVersao with(nolock) ON (motivoAltaVersao.fk_tabela_tiss = atendimento.fk_motivo_alta
            AND motivoAltaVersao.registro_ativo=1 AND motivoAltaVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
         LEFT JOIN tb_tabela_tiss_versao_codigo motivoAltaVersaoDefault with(nolock) ON (motivoAltaVersaoDefault.fk_tabela_tiss = atendimento.fk_motivo_alta
            AND motivoAltaVersaoDefault.registro_ativo=1 AND motivoAltaVersaoDefault.versao_tiss =5)
         LEFT JOIN tb_tabela_tiss_versao_codigo tipoConsultaVersao with(nolock) ON (tipoConsultaVersao.fk_tabela_tiss = dadosComplementares.fk_tipo_consulta
            AND tipoConsultaVersao.registro_ativo=1 AND tipoConsultaVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
         LEFT JOIN tb_tabela_tiss_versao_codigo tipoConsultaVersaoDefault with(nolock) ON (tipoConsultaVersaoDefault.fk_tabela_tiss = dadosComplementares.fk_tipo_consulta
            AND tipoConsultaVersaoDefault.registro_ativo=1 AND tipoConsultaVersaoDefault.versao_tiss = 5)
         LEFT JOIN tb_tabela_tiss_versao_codigo viaAcessoVersao with(nolock) ON (viaAcessoVersao.fk_tabela_tiss = COALESCE(procedimento.fk_via_acesso, 110778)
            AND viaAcessoVersao.registro_ativo=1 AND viaAcessoVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
         LEFT JOIN tb_tabela_tiss_versao_codigo viaAcessoVersaoDefault with(nolock) ON (viaAcessoVersaoDefault.fk_tabela_tiss = COALESCE(procedimento.fk_via_acesso, 110778)
            AND viaAcessoVersaoDefault.registro_ativo=1 AND viaAcessoVersaoDefault.versao_tiss = 5)
         LEFT JOIN tb_tabela_tiss_versao_codigo unidadeDeMedidaVersao with(nolock) ON (unidadeDeMedidaVersao.fk_tabela_tiss = COALESCE(procedimento.fk_unidade_medida, 110761)
            AND unidadeDeMedidaVersao.registro_ativo=1 AND unidadeDeMedidaVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
         LEFT JOIN tb_tabela_tiss_versao_codigo unidadeDeMedidaVersaoDefault with(nolock) ON (unidadeDeMedidaVersaoDefault.fk_tabela_tiss = COALESCE(procedimento.fk_unidade_medida, 110761)
            AND unidadeDeMedidaVersaoDefault.registro_ativo=1 AND unidadeDeMedidaVersaoDefault.versao_tiss = 5)
         LEFT JOIN rl_entidadecooperado_especialidade entidadeCooperadoEspecialidade with(nolock) ON (entidadeCooperadoEspecialidade.id = procedimento.fk_entidade_cooperado_especialidade AND entidadeCooperadoEspecialidade.registro_ativo=1)
         LEFT JOIN tb_tabela_tiss_versao_codigo especialidadeVersao with(nolock) ON (especialidadeVersao.fk_tabela_tiss = entidadeCooperadoEspecialidade.fk_especialidade AND especialidadeVersao.registro_ativo=1 AND especialidadeVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
    
         LEFT JOIN tb_tabela_tiss_versao_codigo especialidadeVersaoDefault with(nolock) ON (especialidadeVersaoDefault.fk_tabela_tiss = entidadeCooperadoEspecialidade.fk_especialidade AND especialidadeVersaoDefault.registro_ativo=1 AND especialidadeVersaoDefault.versao_tiss = 5)
    
         LEFT JOIN rl_entidade_cooperado entidadeCooperadoSolicitante with(nolock) ON (entidadeCooperadoSolicitante.fk_cooperado = TabelaTempDadosSolicitacao.fk_cooperado_solicitante AND entidadeCooperadoSolicitante.fk_entidade = entidade.id AND entidadeCooperadoSolicitante.registro_ativo=1)
    
         LEFT JOIN rl_entidadecooperado_especialidade entidadeCooperadoSolicitanteEspecialidade with(nolock) ON (entidadeCooperadoSolicitanteEspecialidade.fk_entidade_cooperado = entidadeCooperadoSolicitante.id AND entidadeCooperadoSolicitanteEspecialidade.principal=1 AND entidadeCooperadoSolicitanteEspecialidade.registro_ativo=1)
    
         LEFT JOIN tb_tabela_tiss_versao_codigo especialidadeSolicitanteVersao with(nolock) ON (especialidadeSolicitanteVersao.fk_tabela_tiss = entidadeCooperadoSolicitanteEspecialidade.fk_especialidade
    
         AND especialidadeSolicitanteVersao.registro_ativo=1 AND especialidadeSolicitanteVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))

    
         LEFT JOIN tb_tabela_tiss_versao_codigo especialidadeSolicitanteNaoCooperadoVersao with(nolock) ON (especialidadeSolicitanteNaoCooperadoVersao.fk_tabela_tiss = TabelaTempDadosSolicitacao.fk_especialidade
    
         AND especialidadeSolicitanteNaoCooperadoVersao.registro_ativo=1 AND especialidadeSolicitanteNaoCooperadoVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))

    
         LEFT JOIN tb_tabela_tiss_versao_codigo especialidadeSolicitanteVersaoDefault with(nolock) ON (especialidadeSolicitanteVersaoDefault.fk_tabela_tiss = entidadeCooperadoSolicitanteEspecialidade.fk_especialidade
    
         AND especialidadeSolicitanteVersaoDefault.registro_ativo=1 AND especialidadeSolicitanteVersaoDefault.versao_tiss = 5)
   
    
         LEFT JOIN tb_tabela_tiss_versao_codigo especialidadeSolicitanteNaoCooperadoVersaoDefault with(nolock) ON (especialidadeSolicitanteNaoCooperadoVersaoDefault.fk_tabela_tiss = TabelaTempDadosSolicitacao.fk_especialidade
    
         AND especialidadeSolicitanteNaoCooperadoVersaoDefault.registro_ativo=1 AND especialidadeSolicitanteNaoCooperadoVersaoDefault.versao_tiss = 5)
    
         LEFT JOIN rl_entidade_grau_participacao entidadeGrauParticipacao with(nolock) ON (entidadeGrauParticipacao.id = procedimento.fk_grau_participacao AND entidadeGrauParticipacao.registro_ativo=1)
    
         LEFT JOIN tb_tabela_tiss_versao_codigo grauParticipacaoVersao with(nolock) ON (grauParticipacaoVersao.fk_tabela_tiss = COALESCE(entidadeGrauParticipacao.fk_grau_participacao, 109929)
    
         AND grauParticipacaoVersao.registro_ativo=1 AND grauParticipacaoVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
    
         LEFT JOIN tb_tabela_tiss_versao_codigo grauParticipacaoVersaoDefault with(nolock) ON (grauParticipacaoVersaoDefault.fk_tabela_tiss = COALESCE(entidadeGrauParticipacao.fk_grau_participacao, 109929)
    
         AND grauParticipacaoVersaoDefault.registro_ativo=1 AND grauParticipacaoVersaoDefault.versao_tiss = 5)
   
         LEFT JOIN tb_tabela_tiss_versao_codigo conselhoProfissionalExecutanteVersao with(nolock) ON (conselhoProfissionalExecutanteVersao.fk_tabela_tiss = cooperadoExecutante.fk_conselho_profissional
    
         AND conselhoProfissionalExecutanteVersao.registro_ativo=1 AND conselhoProfissionalExecutanteVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
    
         LEFT JOIN tb_tabela_tiss_versao_codigo conselhoProfissionalExecutanteVersaoDefault with(nolock) ON (conselhoProfissionalExecutanteVersaoDefault.fk_tabela_tiss = cooperadoExecutante.fk_conselho_profissional
    
         AND conselhoProfissionalExecutanteVersaoDefault.registro_ativo=1 AND conselhoProfissionalExecutanteVersaoDefault.versao_tiss = 5)
    
         LEFT JOIN tb_tabela_tiss_versao_codigo ufConselhoProfissionalExecutanteVersao with(nolock) ON (ufConselhoProfissionalExecutanteVersao.fk_tabela_tiss = cooperadoExecutante.fk_uf AND ufConselhoProfissionalExecutanteVersao.registro_ativo=1 AND ufConselhoProfissionalExecutanteVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
    
         LEFT JOIN tb_tabela_tiss_versao_codigo ufConselhoProfissionalExecutanteVersaoDefault with(nolock) ON (ufConselhoProfissionalExecutanteVersaoDefault.fk_tabela_tiss = cooperadoExecutante.fk_uf AND ufConselhoProfissionalExecutanteVersaoDefault.registro_ativo=1 AND ufConselhoProfissionalExecutanteVersaoDefault.versao_tiss = 5)
    
         LEFT JOIN tb_tabela_tiss_versao_codigo conselhoProfissionalSolicitanteVersao with(nolock) ON (conselhoProfissionalSolicitanteVersao.fk_tabela_tiss = cooperadoSolicitante.fk_conselho_profissional
    
         AND conselhoProfissionalSolicitanteVersao.registro_ativo=1 AND conselhoProfissionalSolicitanteVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
    
         LEFT JOIN tb_tabela_tiss_versao_codigo conselhoProfissionalSolicitanteVersaoDefault with(nolock) ON (conselhoProfissionalSolicitanteVersaoDefault.fk_tabela_tiss = cooperadoSolicitante.fk_conselho_profissional
    
         AND conselhoProfissionalSolicitanteVersaoDefault.registro_ativo=1 AND conselhoProfissionalSolicitanteVersaoDefault.versao_tiss = 5)
    
         LEFT JOIN tb_tabela_tiss_versao_codigo conselhoProfissionalSolicitanteNaoCooperadoVersao with(nolock) on (conselhoProfissionalSolicitanteNaoCooperadoVersao.fk_tabela_tiss = TabelaTempDadosSolicitacao.fk_conselho_profissional AND
    
         conselhoProfissionalSolicitanteNaoCooperadoVersao.registro_ativo=1 AND conselhoProfissionalSolicitanteNaoCooperadoVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))

         LEFT JOIN tb_tabela_tiss_versao_codigo ufConselhoProfissionalSolicitanteVersao with(nolock) ON (ufConselhoProfissionalSolicitanteVersao.fk_tabela_tiss = cooperadoSolicitante.fk_uf AND ufConselhoProfissionalSolicitanteVersao.registro_ativo=1 AND ufConselhoProfissionalSolicitanteVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
    
         LEFT JOIN tb_tabela_tiss_versao_codigo ufConselhoProfissionalSolicitanteVersaoDefault with(nolock) ON (ufConselhoProfissionalSolicitanteVersaoDefault.fk_tabela_tiss = cooperadoSolicitante.fk_uf AND ufConselhoProfissionalSolicitanteVersaoDefault.registro_ativo=1 AND ufConselhoProfissionalSolicitanteVersaoDefault.versao_tiss =5)
   
         LEFT JOIN tb_tabela_tiss_versao_codigo ufConselhoProfissionalRecebedorVersao with(nolock) ON (ufConselhoProfissionalRecebedorVersao.fk_tabela_tiss = cooperadoRecebedor.fk_uf AND ufConselhoProfissionalRecebedorVersao.registro_ativo=1 AND ufConselhoProfissionalRecebedorVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
    
         LEFT JOIN tb_tabela_tiss_versao_codigo ufConselhoProfissionalRecebedorVersaoDefault with(nolock) ON (ufConselhoProfissionalRecebedorVersaoDefault.fk_tabela_tiss = cooperadoRecebedor.fk_uf AND ufConselhoProfissionalRecebedorVersaoDefault.registro_ativo=1 AND ufConselhoProfissionalRecebedorVersaoDefault.versao_tiss = 5)

         LEFT JOIN tb_tabela_tiss_versao_codigo ufConselhoProfissionalSolicitanteNaoCooperadoVersao with(nolock) on (ufConselhoProfissionalSolicitanteNaoCooperadoVersao.fk_tabela_tiss = TabelaTempDadosSolicitacao.fk_uf AND
    
          ufConselhoProfissionalSolicitanteNaoCooperadoVersao.registro_ativo=1 AND  ufConselhoProfissionalSolicitanteNaoCooperadoVersao.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))

         LEFT JOIN rl_entidadeconvenio_acomodacao_carater_atendimento entidadeConvenioAcomodacaoCaraterAtendimento with(nolock) ON (entidadeConvenioAcomodacaoCaraterAtendimento.fk_entidade_convenio = entidadeConvenio.id AND entidadeConvenioAcomodacaoCaraterAtendimento.fk_acomodacao = procedimento.fk_acomodacao AND entidadeConvenioAcomodacaoCaraterAtendimento.registro_ativo=1)
   
         LEFT JOIN  tb_tabela_tiss especialidadeTiss on (especialidadeTiss.id = COALESCE(especialidadeVersao.fk_tabela_tiss,especialidadeVersaoDefault.fk_tabela_tiss) and especialidadeTiss.registro_ativo =1)
    
         LEFT JOIN rl_entidade_cooperado entidadeCooperadoExecultantePrincipal with(nolock) ON (entidadeCooperadoExecultantePrincipal.fk_cooperado = procedimento.fk_cooperado_executante_complemento AND entidadeCooperadoExecultantePrincipal.registro_ativo=1 and entidadeCooperadoExecultantePrincipal.fk_entidade = entidade.id)
    
         LEFT JOIN rl_entidadecooperado_especialidade entidadeCooperadoEspecialidadePrincipal with(nolock) ON (entidadeCooperadoEspecialidadePrincipal.fk_entidade_cooperado = entidadeCooperadoExecultantePrincipal.id  AND entidadeCooperadoEspecialidadePrincipal.registro_ativo=1 and entidadeCooperadoEspecialidadePrincipal.principal = 1)
    
         LEFT JOIN tb_tabela_tiss_versao_codigo especialidadeVersaoPrincipal with(nolock) ON (especialidadeVersaoPrincipal.fk_tabela_tiss = entidadeCooperadoEspecialidadePrincipal.fk_especialidade   AND especialidadeVersaoPrincipal.registro_ativo=1 AND especialidadeVersaoPrincipal.versao_tiss = COALESCE(entidadeConvenio.versao_tiss,5))
    
         LEFT JOIN tb_tabela_tiss_versao_codigo especialidadeVersaoPrincipalDefault with(nolock) ON (especialidadeVersaoPrincipalDefault.fk_tabela_tiss = entidadeCooperadoEspecialidadePrincipal.fk_especialidade AND especialidadeVersaoPrincipalDefault.registro_ativo=1  AND especialidadeVersaoPrincipalDefault.versao_tiss = 5)
    
         LEFT JOIN  tb_tabela_tiss especialidadeTissPrincipal on (especialidadeTissPrincipal.id = COALESCE(especialidadeVersaoPrincipal.fk_tabela_tiss,especialidadeVersaoPrincipalDefault.fk_tabela_tiss) and especialidadeTissPrincipal.registro_ativo =1)
    
         LEFT JOIN tb_item_porte_anestesia itemPorteAnestesia on (itemPorteAnestesia.id = procedimento.fk_item_porte_anestesia and itemPorteAnestesia.registro_ativo = 1)
    
         outer apply( select top 1 codigoExcecaoTabelaANS.* from tb_codigo_excecao_ans codigoExcecaoTabelaANS 
    
         inner JOIN tb_item_despesa item with(nolock) on (item.id = codigoExcecaoTabelaANS.fk_item_despesa and item.registro_ativo = 1 and item.codigo = itemDespesa.codigo) 
    
         where  codigoExcecaoTabelaANS.fk_entidadeconvenio_tipo_despesa_codigo_tabela_ans = entidadeConvenioTipoDespesaCodigoTabelaANS.id and codigoExcecaoTabelaANS.registro_ativo = 1
    ) TabelaTemporariaCodigoExcecaoTabelaANS
   
    
         WHERE atendimento.registro_ativo=1 AND atendimento.situacaoAtendimento <> 6

       AND espelho.id = 627922
       AND pagamentoProcedimento.fk_fatura IS NULL
      
           AND (pagamentoProcedimento.valor_honorario + pagamentoProcedimento.valor_acrescimo + pagamentoProcedimento.valor_custo_operacional + pagamentoProcedimento.valor_filme - pagamentoProcedimento.valor_desconto) > 0
           ORDER BY atendimento.numero_atendimento_automatico,atendimento.id, procedimento.id