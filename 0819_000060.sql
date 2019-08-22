   select espelho.numero_espelho,
   convenio.sigla +' - '+ convenio.nome as convenio,
   espelho.data_emissao,
   espelho.data_vencimento,
   atendimento.numero_atendimento_automatico,
   atendimento.paciente,
   atendimento.matricula_paciente,
   atendimento.numero_guia,
   (select top 1 data_realizacao from tb_procedimento where fk_atendimento = atendimento.id order by data_realizacao asc) as dataAtendimento,
   sum (pagamentoProcedimento.valor_honorario + pagamentoProcedimento.valor_acrescimo + pagamentoProcedimento.valor_custo_operacional + pagamentoProcedimento.valor_filme - pagamentoProcedimento.valor_desconto) as valorEmEspelho,
   sum (procedimento.valor_honorario + procedimento.valor_acrescimo + procedimento.valor_custo_operacional + procedimento.valor_filme - procedimento.valor_desconto) as valorProcedimento,
   hospital.sigla
   from tb_espelho espelho with(nolock)
   inner join tb_atendimento atendimento with(nolock) on (atendimento.fk_espelho = espelho.id and atendimento.autorizado_unimed = 1 and atendimento.registro_ativo = 1)
   inner join tb_procedimento procedimento with(nolock) on (procedimento.fk_atendimento = atendimento.id and procedimento.registro_ativo = 1)
   inner join tb_pagamento_procedimento pagamentoProcedimento with(nolock) on (pagamentoProcedimento.fk_procedimento = procedimento.id and pagamentoProcedimento.registro_ativo = 1)
   inner join rl_entidade_convenio entidadeConvenio with(nolock) on (entidadeConvenio.id = espelho.fk_entidade_convenio and entidadeConvenio.registro_ativo =1)
   inner join tb_convenio convenio with(nolock) on (convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1)
   inner join tb_hospital hospital with(nolock) on (hospital.id = atendimento.fk_hospital and hospital.registro_ativo = 1)
   where espelho.registro_ativo = 1 and atendimento.fk_espelho in(628311) and fk_fatura is null
   group by espelho.numero_espelho,convenio.sigla, convenio.nome ,espelho.data_emissao,
   espelho.data_vencimento,atendimento.numero_atendimento_automatico,atendimento.paciente,
   atendimento.matricula_paciente,atendimento.numero_guia,atendimento.id,hospital.sigla
   order by espelho.numero_espelho asc