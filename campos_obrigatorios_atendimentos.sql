INSERT INTO [dbo].[tb_atendimento]
           ([pk_importacao]
           ,[resolveu_dependencia]
           ,[data_ultima_alteracao]
           ,[registro_ativo]
           ,[ano_atendimento]
           ,[data_alta]
           ,[data_cadastro]
           ,[data_entrega]
           ,[data_internacao]
           ,[data_validade]
           ,[faturar]
           ,[guia_principal]
           ,[guia_solicitacao_internacao]
           ,[hora_alta]
           ,[hora_internacao]
           ,[hospital_dia]
           ,[matricula_paciente]
           ,[numero_atendimento_automatico]
           ,[numero_guia]
           ,[numero_importacao]
           ,[paciente]
           ,[plano]
           ,[rn]
           ,[senha]
           ,[situacaoAtendimento]
           ,[valor_total_atendimento]
           ,[versao_tiss]
           ,[fk_usuario_ultima_alteracao]
           ,[fk_complemento]
           ,[fk_entidade]
           ,[fk_convenio]
           ,[fk_entidade_hospital]
           ,[fk_usuario]
           ,[fk_espelho]
           ,[fk_hospital]
           ,[autorizado_unimed]
           ,[numero_guia_origem_tiss]
           ,[hora_digitacao]
           ,[sql_update]
           ,[rateio]
     SELECT 
	         planilha.pk_importacao as pk_importacao
            ,null as resolveu_dependencia
            ,getdate() as data_ultima_alteracao
            ,1 as registro_ativo
            ,2019 as ano_atendimento
            ,null as data_alta
            ,getdate() as data_cadastro
            ,getdate() as data_entrega
            ,null as data_internacao
            ,null as data_validade
            ,1 as faturar
            ,planilha.senha as guia_principal
            ,null as guia_solicitacao_internacao
            ,null as hora_alta
            ,null as hora_internacao
            ,0 as hospital_dia
            ,'' as matricula_paciente
            ,null as numero_atendimento_automatico
            ,planilha.senha as numero_guia
            ,0 as numero_importacao
            ,planilha.paciente as paciente
            ,null as plano
            ,0 as rn
            ,planilha.senha as senha
            ,1 as situacaoAtendimento--espelhado
            ,planilha.valor as valor_total_atendimento
            ,entidadeConvenio.versao_tiss as versao_tiss
            ,12 as fk_usuario_ultima_alteracao
            ,null as fk_complemento
            ,23 as fk_entidade
            ,entidadeConvenio.id as fk_convenio
            ,entidadeHospital.id as fk_entidade_hospital
            ,12 as fk_usuario
            ,772967 as fk_espelho-- 772967
            ,hospital.id as fk_hospital
            ,1 as autorizado_unimed
            ,0 as numero_guia_origem_tiss
            ,getdate() as hora_digitacao
            ,'0919-000432' as sql_update
            ,0 as rateio
FROM dbo.[0919_000432] planilha WITH(NOLOCK)
INNER JOIN rl_entidade_convenio entidadeConvenio WITH(NOLOCK) ON (entidadeConvenio.fk_convenio = 270 and entidadeConvenio.fk_entidade = 23)
INNER JOIN tb_cooperado cooperado WITH(NOLOCK) ON (cooperado.cpf_cnpj = planilha.cpf_executante and cooperado.registro_ativo = 1)
INNER JOIN rl_entidade_cooperado entidadeCooperado with(nolock) on (entidadeCooperado.fk_cooperado = cooperado.id and entidadeCooperado.fk_entidade = 23 and entidadeCooperado.registro_ativo = 1)
INNER JOIN tb_hospital hospital WITH(NOLOCK) ON (hospital.cnpj = case len(planilha.cnpj_hospital) when 13 then convert(varchar(255),'0'+planilha.cnpj_hospital) else planilha.cnpj_hospital end and hospital.registro_ativo = 1 and hospital.id <> 91 and hospital.id <> 49)-- Hospital de Olhos de Minas Gerais e Hospital Madre Tereza
INNER JOIN rl_entidade_hospital entidadeHospital WITH(NOLOCK) ON (entidadeHospital.fk_hospital = hospital.id and entidadeHospital.fk_entidade = 23 and entidadeHospital.registro_ativo = 1 and entidadeHospital.ativo = 1 and entidadeHospital.id <> 568 and entidadeHospital.id <> 559)-- Hospital de Olhos de Minas Gerais e Hospital Madre Tereza
where entidadeHospital.fk_entidade = 23 and entidadeConvenio.fk_convenio = 270



