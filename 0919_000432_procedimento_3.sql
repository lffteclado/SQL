INSERT INTO [dbo].[tb_procedimento]
           ([pk_importacao]
           ,[resolveu_dependencia]
           ,[data_ultima_alteracao]
           ,[registro_ativo]
           ,[data_fim]
           ,[data_inicio]
           ,[data_realizacao]
           ,[desconto_hospitalar]
           ,[faturar]
           ,[forcar_atendimento]
           ,[forma_execucao]
           ,[guia_procedimento]
           ,[hora_fim]
           ,[hora_inicio]
           ,[percentual_desconto_hospitalar]
           ,[quantidade]
           ,[quantidade_ch]
           ,[quantidade_porte]
           ,[tuss]
           ,[urgencia]
           ,[valor_acrescimo]
           ,[valor_ch]
           ,[valor_custo_operacional]
           ,[valor_desconto]
           ,[valor_filme]
           ,[valor_honorario]
           ,[valor_percentual]
           ,[valor_total]
           ,[fk_usuario_ultima_alteracao]
           ,[fk_acomodacao]
           ,[fk_atendimento]
           ,[fk_complexidade]
           ,[fk_cooperado_executante_complemento]
           ,[fk_cooperado_recebedor_cobranca]
           ,[fk_cooperado_recebedor_cobranca_anterior]
           ,[fk_entidade_cooperado_especialidade]
           ,[fk_grau_participacao]
           ,[fk_item_despesa]
           ,[fk_procedimento_detalhar_unimed]
           ,[fk_procedimento_tuss]
           ,[fk_tecnica]
           ,[fk_tipo_guia]
           ,[fk_unidade_medida]
           ,[fk_via_acesso]
           ,[descricao_acomodacao_temp]
           ,[descricao_grau_Participacao_temp]
           ,[codigo_item_despesa_temp]
           ,[descricao_item_despesa_temp]
           ,[NumSeqPrd_temp]
           ,[sendo_importado_temp]
           ,[pk_importacao_fk_cooperado_recebedor_cobranca]
           ,[fk_tipo_tabela_tiss_fk_tecnica]
           ,[pk_importacao_fk_tecnica]
           ,[codigo_fk_procedimento_tuss]
           ,[pk_importacao_fk_procedimento_tuss]
           ,[fk_cooperado_fk_entidade_cooperado_especialidade]
           ,[fk_entidade_fk_entidade_cooperado_especialidade]
           ,[principal_fk_entidade_cooperado_especialidade]
           ,[fk_entidade_fk_grau_participacao]
           ,[pk_importacao_fk_grau_participacao]
           ,[codigo_ans_duplicado_fk_grau_participacao]
           ,[pk_importacao_fk_cooperado_executante_complemento]
           ,[pk_importacao_fk_atendimento]
           ,[fk_tipo_tabela_tiss_fk_acomodacao]
           ,[pk_importacao_fk_acomodacao]
           ,[codigo_ans_duplicado_fk_acomodacao]
           ,[fk_tipo_tabela_tiss_fk_via_acesso]
           ,[pk_importacao_fk_via_acesso]
           ,[fk_tipo_tabela_tiss_fk_tipo_guia]
           ,[pk_importacao_fk_tipo_guia]
           ,[sigla_fk_unidade_medida]
           ,[fk_tipo_tabela_tiss_fk_unidade_medida]
           ,[autorizado_unimed]
           ,[foiAlterado]
           ,[numero_guia]
           ,[registro_adequecao]
           ,[fk_fatura_temp]
           ,[pk_importacao_fk_fatura_temp]
           ,[procedimentoConvertidoServicoEspecialRepasse]
           ,[procedimentoConvertidoCooperadoRepassado]
           ,[valor_acrescimo_convenio]
           ,[pk_importacao_fk_fatura]
           ,[sql_update]
           ,[cbo]
           ,[cbo_temp]
           ,[pk_importacao_fk_unidade_medida]
           ,[codPes_temp_fk_atendimento]
           ,[fk_num_aten_fk_atendimento]
           ,[pk_importacao_fk_entidade_fk_fatura_temp]
           ,[fk_item_porte_anestesia]
           ,[referencia_procedimento_integracao]
           ,[valor_desconto_anterior]
           ,[valor_honorario_anterior]
           ,[valor_acrescimo_convenio_anterior]
           ,[data_criacao_rateio]
           ,[referencia_procedimento_rateio]
           ,[fk_tecnica_anterior_tmp]
           ,[desconto_hospitalar_bkp]
           ,[data_separacao_uco]
           ,[referencia_separacao_uco]
           ,[referencia_procedimento_integracao_entidade]
           ,[fk_procedimento_tuss_anterior]
           ,[referencia_procedimento_unimed]
           ,[referencia_procedimento_prontuario]
           ,[fk_procedimento_origem]
           ,[fk_entidade_cooperado_conversao_desconvertida]
           ,[foi_convertido]
           ,[fk_item_despesa_anterior_conversao]
           ,[fk_despesa_selecionada])
     SELECT
            null as pk_importacao
           ,null as resolveu_dependencia
           ,getdate() as data_ultima_alteracao
           ,1 as registro_ativo
           ,planilha.data_reali_ini_ter as data_fim
           ,planilha.data_reali_ini_ter as data_inicio
           ,planilha.data_reali_ini_ter as data_realizacao
           ,0 as desconto_hospitalar
           ,null as faturar
           ,1 as forcar_atendimento
           ,0 as forma_execucao
           ,null as guia_procedimento
           ,null as hora_fim
           ,null as hora_inicio
           ,null as percentual_desconto_hospitalar
           ,1 as quantidade
           ,null as quantidade_ch
           ,0.00 as quantidade_porte
           ,0 as tuss
           ,0 as urgencia
           ,0.00 as valor_acrescimo
           ,0.00 as valor_ch
           ,0.00 as valor_custo_operacional
           ,0.00 as valor_desconto
           ,0.00 as valor_filme
           ,planilha.valor as valor_honorario
           ,100.00 as valor_percentual
           ,planilha.valor as valor_total
           ,12 as fk_usuario_ultima_alteracao
           ,110635 as fk_acomodacao
           ,atendimento.id as fk_atendimento
           ,null as fk_complexidade
           ,cooperado.id as fk_cooperado_executante_complemento
           ,cooperado.id as fk_cooperado_recebedor_cobranca
           ,null as fk_cooperado_recebedor_cobranca_anterior
           ,especialidade.id as fk_entidade_cooperado_especialidade
           ,449 as fk_grau_participacao
           ,itemDespesa.id as fk_item_despesa
           ,null as fk_procedimento_detalhar_unimed
           ,null as fk_procedimento_tuss
           ,null as fk_tecnica
           ,110681 as fk_tipo_guia
           ,null as fk_unidade_medida
           ,110778 as fk_via_acesso
           ,null as descricao_acomodacao_temp
           ,null as descricao_grau_Participacao_temp
           ,itemDespesa.codigo as codigo_item_despesa_temp
           ,itemDespesa.descricao as descricao_item_despesa_temp
           ,null as NumSeqPrd_temp
           ,null as sendo_importado_temp
           ,null as pk_importacao_fk_cooperado_recebedor_cobranca
           ,null as fk_tipo_tabela_tiss_fk_tecnica
           ,null as pk_importacao_fk_tecnica
           ,null as codigo_fk_procedimento_tuss
           ,null as pk_importacao_fk_procedimento_tuss
           ,null as fk_cooperado_fk_entidade_cooperado_especialidade
           ,null as fk_entidade_fk_entidade_cooperado_especialidade
           ,null as principal_fk_entidade_cooperado_especialidade
           ,null as fk_entidade_fk_grau_participacao
           ,null as pk_importacao_fk_grau_participacao
           ,null as codigo_ans_duplicado_fk_grau_participacao
           ,null as pk_importacao_fk_cooperado_executante_complemento
           ,null as pk_importacao_fk_atendimento
           ,null as fk_tipo_tabela_tiss_fk_acomodacao
           ,null as pk_importacao_fk_acomodacao
           ,null as codigo_ans_duplicado_fk_acomodacao
           ,null as fk_tipo_tabela_tiss_fk_via_acesso
           ,null as pk_importacao_fk_via_acesso
           ,null as fk_tipo_tabela_tiss_fk_tipo_guia
           ,null as pk_importacao_fk_tipo_guia
           ,null as sigla_fk_unidade_medida
           ,null as fk_tipo_tabela_tiss_fk_unidade_medida
           ,1 as autorizado_unimed
           ,null as foiAlterado
           ,null as numero_guia
           ,null as registro_adequecao
           ,null as fk_fatura_temp
           ,null as pk_importacao_fk_fatura_temp
           ,null as procedimentoConvertidoServicoEspecialRepasse
           ,null as procedimentoConvertidoCooperadoRepassado
           ,0.00 as valor_acrescimo_convenio
           ,null as pk_importacao_fk_fatura
           ,'0919-000432' as sql_update
           ,null as cbo
           ,null as cbo_temp
           ,null as pk_importacao_fk_unidade_medida
           ,null as codPes_temp_fk_atendimento
           ,null as fk_num_aten_fk_atendimento
           ,null as pk_importacao_fk_entidade_fk_fatura_temp
           ,null as fk_item_porte_anestesia
           ,null as referencia_procedimento_integracao
           ,null as valor_desconto_anterior
           ,null as valor_honorario_anterior
           ,null as valor_acrescimo_convenio_anterior
           ,null as data_criacao_rateio
           ,null as referencia_procedimento_rateio
           ,null as fk_tecnica_anterior_tmp
           ,null as desconto_hospitalar_bkp
           ,null as data_separacao_uco
           ,null as referencia_separacao_uco
           ,null as referencia_procedimento_integracao_entidade
           ,null as fk_procedimento_tuss_anterior
           ,null as referencia_procedimento_unimed
           ,null as referencia_procedimento_prontuario
           ,null as fk_procedimento_origem
           ,null as fk_entidade_cooperado_conversao_desconvertida
           ,null as foi_convertido
           ,null as fk_item_despesa_anterior_conversao
           ,null as fk_despesa_selecionada
from dbo.[0919_000432] planilha
inner join tb_cooperado cooperado with(nolock) on (cooperado.cpf_cnpj = planilha.cpf_executante and cooperado.registro_ativo = 1)
inner join rl_entidade_cooperado entidadeCooperado with(nolock) on (entidadeCooperado.fk_cooperado = cooperado.id and entidadeCooperado.fk_entidade = 23 and entidadeCooperado.registro_ativo = 1)
inner join rl_entidadecooperado_especialidade especialidade with(nolock) on (especialidade.fk_entidade_cooperado = entidadeCooperado.id and especialidade.registro_ativo = 1)
inner join tb_hospital hospital with(nolock) on (hospital.cnpj = case len(planilha.cnpj_hospital) when 13 then convert(varchar(255),'0'+planilha.cnpj_hospital) else planilha.cnpj_hospital end and hospital.registro_ativo = 1 /*and hospital.id <> 91 and hospital.id <> 49*/)-- Hospital de Olhos de Minas Gerais e Hospital Madre Tereza
inner join rl_entidade_hospital entidadeHospital with(nolock) on (entidadeHospital.fk_hospital = hospital.id and entidadeHospital.fk_entidade = 23 and entidadeHospital.registro_ativo = 1 and entidadeHospital.ativo = 1 and entidadeHospital.id <> 568 and entidadeHospital.id <> 559)-- Hospital de Olhos de Minas Gerais e Hospital Madre Tereza
cross apply(
select top 1 codigo, id, descricao from tb_item_despesa where codigo = planilha.procedimento and registro_ativo = 1
)as itemDespesa
cross apply(
select top 1 id,senha, pk_importacao from tb_atendimento
 where sql_update = '0919-000432'
  and tb_atendimento.registro_ativo = 1
  and tb_atendimento.senha = planilha.senha
  and tb_atendimento.paciente = planilha.paciente
  and tb_atendimento.valor_total_atendimento = planilha.valor
  and tb_atendimento.pk_importacao = planilha.pk_importacao
) as atendimento
where entidadeHospital.fk_entidade = 23
 and itemDespesa.codigo = planilha.procedimento
 and cooperado.cpf_cnpj = planilha.cpf_executante
 and atendimento.senha = planilha.senha
 and atendimento.pk_importacao = planilha.pk_importacao

 GO

 update tb_atendimento set pk_importacao = null where registro_ativo = 1 and sql_update = '0919-000432'

 GO

 drop table dbo.[0919_000432]

 GO

DECLARE @RC int
DECLARE @idEspelho bigint = 772967
DECLARE @idAtendimento bigint
DECLARE @idCartaDeGlosa bigint
DECLARE @usuario bigint = 1

-- TODO: Defina valores de parâmetros aqui.

EXECUTE @RC = [dbo].[gerarPagamentoProcedimentoPorEspelho] 
   @idEspelho
  ,@idAtendimento
  ,@idCartaDeGlosa
  ,@usuario

GO





