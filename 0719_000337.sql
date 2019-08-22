select hospital.cnpj,
       hospital.nome,
	   atendimento.matricula_paciente,
	   atendimento.paciente, 
       atendimento.data_internacao as dataInternacao,
	   atendimento.data_alta as dataAlta, 
       cooperado.cpf_cnpj,
	   procedimento.quantidade,
	   procedimento.data_realizacao as dtaRealizacao,
	   procedimento.valor_total,
	   tipoGuia.descricao as tipo_guia,
       atendimento.numero_atendimento_automatico,
	   atendimento.id,
	   itemDepesa.codigo,
	   deParaTussConvenio.codigo as codigoAtuacao,
	   atendimento.hora_internacao as horaInternacao,
	   atendimento.hora_alta as horaAlta
from tb_atendimento as atendimento 
     inner join tb_procedimento as procedimento on (atendimento.id = procedimento.fk_atendimento and procedimento.registro_ativo = 1) 
	 left join tb_tabela_tiss_tipo_guia_temp tipoGuia on procedimento.fk_tipo_guia = tipoGuia.id
     inner join rl_entidade_hospital as entidadeHospital on (entidadeHospital.id = atendimento.fk_entidade_hospital and entidadeHospital.registro_ativo = 1) 
     inner join tb_hospital as hospital on (entidadeHospital.fk_hospital = hospital.id and hospital.registro_ativo = 1) 
     inner join tb_cooperado as cooperado on (procedimento.fk_cooperado_executante_complemento = cooperado.id and cooperado.registro_ativo = 1) 
     left join tb_espelho as espelho on (atendimento.fk_espelho = espelho.id and espelho.registro_ativo = 1) 
     inner join tb_item_despesa as itemDepesa on (itemDepesa.id = procedimento.fk_item_despesa and itemDepesa.registro_ativo = 1) 
     inner join rl_entidade_convenio as entidadeConvenio on (entidadeConvenio.id = atendimento.fk_convenio and entidadeConvenio.registro_ativo = 1 ) 
     inner join tb_convenio as convenio on (convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1 ) 
     left join rl_entidade_grau_participacao entidadeGrauParticipacao on (procedimento.fk_grau_participacao = entidadeGrauParticipacao.id and entidadeGrauParticipacao.registro_ativo = 1 ) 
     left join tb_tabela_tiss as grauParticipacao on (grauParticipacao.id = entidadeGrauParticipacao.fk_grau_participacao and grauParticipacao.registro_ativo = 1) 
     left join tb_de_para_tuss_convenio deParaTussConvenio on (deParaTussConvenio.fk_tabela_tiss = entidadeGrauParticipacao.fk_grau_participacao and deParaTussConvenio.registro_ativo = 1 and deParaTussConvenio.fk_convenio = convenio.id)
     left join tb_pagamento_procedimento as pagamento on (pagamento.fk_procedimento = procedimento.id and pagamento.registro_ativo = 1) 
where atendimento.fk_entidade = 2 and itemDepesa.codigo = 01010760 and tipoGuia.id in (110679,110680)