
select cooperado.nome,
       tmp.cooperado,
	   hospital.nome,
	   hospital.cnpj,
	   hospital.id,
	   tmp.hospital,
	   tmp.cnpj_hospital
from tb_cooperado cooperado
inner join #tmpNaoEcontrado tmp on (tmp.cpf_cooperado = cooperado.cpf_cnpj)
inner join rl_entidade_cooperado entidadeCooperado
 on (cooperado.id = entidadeCooperado.fk_cooperado and entidadeCooperado.registro_ativo = 1 and entidadeCooperado.fk_entidade = 23 and cooperado.registro_ativo = 1)
inner join tb_hospital hospital on (hospital.cnpj = tmp.cnpj_hospital)
inner join rl_entidade_hospital entidadeHospital on (entidadeHospital.fk_hospital = hospital.id and entidadeHospital.fk_entidade = 23 and entidadeHospital.registro_ativo = 1)

select * from rl_entidade_hospital where fk_hospital = 445 and fk_entidade = 23 --915 500
select * from tb_hospital where id = 445


select * from #tmpNaoEcontrado

/*
select * into #tmpNaoEcontrado from [1019_000444] where pk_importacao not in (
 
 SELECT 
	         planilha.pk_importacao as pk_importacao
            --,null as resolveu_dependencia
            --,getdate() as data_ultima_alteracao
            --,1 as registro_ativo
            --,2019 as ano_atendimento
            --,null as data_alta
            --,getdate() as data_cadastro
            --,getdate() as data_entrega
            --,null as data_internacao
            --,null as data_validade
            --,1 as faturar
            --,planilha.num_guia as guia_principal
            --,null as guia_solicitacao_internacao
            --,null as hora_alta
            --,null as hora_internacao
            --,0 as hospital_dia
            --,'' as matricula_paciente
            --,null as numero_atendimento_automatico
            --,planilha.num_guia as numero_guia
            --,0 as numero_importacao
            --,planilha.paciente as paciente
            --,null as plano
            --,0 as rn
            --,planilha.num_guia as senha
            --,1 as situacaoAtendimento--espelhado
            --,planilha.valor as valor_total_atendimento
            --,entidadeConvenio.versao_tiss as versao_tiss
            --,12 as fk_usuario_ultima_alteracao
            --,null as fk_complemento
            --,23 as fk_entidade
            --,entidadeConvenio.id as fk_convenio
            --,entidadeHospital.id as fk_entidade_hospital
            --,12 as fk_usuario
            --,785158 as fk_espelho--785158 Numero: 151363
            --,hospital.id as fk_hospital
            --,null as fk_importacao_unimed
            --,null as fk_integracao_sus
            --,null as fk_motivo_alta
            --,null as fk_tipo_atendimento
            --,null as fk_num_aten_temp
            --,null as fk_entidade_temp
            --,null as fk_hospital_fk_entidade_hospital
            --,null as fk_entidade_fk_entidade_hospital
            --,null as pk_importacao_fk_complemento
            --,null as fk_tipo_tabela_tiss_fk_tipo_atendimento
            --,null as pk_importacao_fk_tipo_atendimento
            --,null as fk_entidade_fk_convenio
            --,null as fk_convenio_fk_convenio
            --,null as fk_tipo_tabela_tiss_fk_motivo_alta
            --,null as pk_importacao_fk_motivo_alta
            --,null as pk_importacao_fk_espelho
            --,null as pk_importacao_fk_hospital
            --,1 as autorizado_unimed
            --,null as pk_importacao_fk_entidade
            --,null as anoFoiAlterado
            --,null as valorDigitados
            --,null as valorEspelhados
            --,null as valorExcluidos
            --,null as valorFaturados
            --,null as valorPagos
            --,null as valorRepassados
            --,null as valorglosados
            --,0 as numero_guia_origem_tiss
            --,getdate() as hora_digitacao
            --,'1019-000444' as sql_update
            --,null as fk_integracao_unimed
            --,null as cid
            --,null as total_atendimento
            --,null as fk_entidade_fk_complemento
            --,null as fk_com_con_fk_complemento
            --,null as fk_convenio_fk_complemento
            --,null as fk_entidade_fk_espelho
            --,null as fk_num_fat_fk_espelho
            --,null as numero_atendimento_automatico_anterior
            --,null as matricula_anterior
            --,null as pendente_calculo_integracao
            --,null as referencia_atendimento_integracao
            --,null as fk_integracao_sus_valores
            --,null as fk_complemento_hospital
            --,null as atendimentoInconsistente
            --,null as fk_espelho_antigo
            --,0 as rateio
            --,null as fk_integracao_ws
            --,null as referencia_atendimento_integracao_entidade
            --,null as fk_integracao_entidade
            --,null as fk_integracao_hospital
            --,null as referencia_atendimento_unimed
            --,null as referencia_atendimento_prontuario
            --,null as num_esp_ori
            --,null as exibe_tag_guia_completa_tiss
            --,null as antigoNumeroImportacao
            --,null as fk_protocolo_agil
FROM dbo.[1019_000444] planilha WITH(NOLOCK)
INNER JOIN rl_entidade_convenio entidadeConvenio WITH(NOLOCK) ON (entidadeConvenio.fk_convenio = 270 and entidadeConvenio.fk_entidade = 23)--Convenio PMMG/IPSM
INNER JOIN tb_cooperado cooperado WITH(NOLOCK) ON (cooperado.cpf_cnpj = planilha.cpf_cooperado and cooperado.registro_ativo = 1)
INNER JOIN rl_entidade_cooperado entidadeCooperado with(nolock) on (entidadeCooperado.fk_cooperado = cooperado.id and entidadeCooperado.fk_entidade = 23 and entidadeCooperado.registro_ativo = 1)
INNER JOIN tb_hospital hospital WITH(NOLOCK) ON (hospital.cnpj = case len(planilha.cnpj_hospital) when 13 then convert(varchar(255),'0'+planilha.cnpj_hospital) else planilha.cnpj_hospital end and hospital.registro_ativo = 1 and hospital.id <> 91 and hospital.id <> 49)-- Hospital de Olhos de Minas Gerais e Hospital Madre Tereza
INNER JOIN rl_entidade_hospital entidadeHospital WITH(NOLOCK) ON (entidadeHospital.fk_hospital = hospital.id and entidadeHospital.fk_entidade = 23 and entidadeHospital.registro_ativo = 1 and entidadeHospital.ativo = 1 and entidadeHospital.id <> 568 and entidadeHospital.id <> 559)-- Hospital de Olhos de Minas Gerais e Hospital Madre Tereza
where entidadeHospital.fk_entidade = 23 and entidadeConvenio.fk_convenio = 270 --order by planilha.pk_importacao

)


