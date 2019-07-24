select espelho.numero_espelho,
convenio.nome as convenio,
espelho.data_emissao,
espelho.data_vencimento,
atendimento.numero_atendimento_automatico,
atendimento.paciente,
atendimento.matricula_paciente,
atendimento.numero_guia,
(select top 1 data_realizacao from tb_procedimento where fk_atendimento = atendimento.id order by data_realizacao asc) as dataAtendimento,
sum (pagamentoProcedimento.valor_honorario + pagamentoProcedimento.valor_acrescimo + pagamentoProcedimento.valor_custo_operacional + pagamentoProcedimento.valor_filme - pagamentoProcedimento.valor_desconto) as valorEmEspelho,
sum (procedimento.valor_honorario + procedimento.valor_acrescimo + procedimento.valor_custo_operacional + procedimento.valor_filme - procedimento.valor_desconto) as valorProcedimento
from tb_espelho espelho with(nolock)
inner join tb_atendimento atendimento with(nolock) on (atendimento.fk_espelho = espelho.id and atendimento.autorizado_unimed = 1 and atendimento.registro_ativo = 1)
inner join tb_procedimento procedimento with(nolock) on (procedimento.fk_atendimento = atendimento.id and procedimento.registro_ativo = 1)
inner join tb_pagamento_procedimento pagamentoProcedimento with(nolock) on (pagamentoProcedimento.fk_procedimento = procedimento.id and pagamentoProcedimento.registro_ativo = 1)
inner join rl_entidade_convenio entidadeConvenio with(nolock) on (entidadeConvenio.id = espelho.fk_entidade_convenio and entidadeConvenio.registro_ativo =1)
inner join tb_convenio convenio with(nolock) on (convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1)
where espelho.registro_ativo = 1 and fk_fatura is null and entidadeConvenio.id = 886 and atendimento.paciente = 'Micaelle Porto de Sa'
group by espelho.numero_espelho,convenio.sigla, convenio.nome ,espelho.data_emissao,
espelho.data_vencimento,atendimento.numero_atendimento_automatico,atendimento.paciente,
atendimento.matricula_paciente,atendimento.numero_guia,atendimento.id

--and atendimento.fk_espelho in(22862)

select * from tb_espelho where id = 75166

select * from tb_atendimento where senha = 'KDGBA20' --3862097

select paciente, * from tb_atendimento where fk_espelho = 75166

select * from tb_endereco where fk_entidade = 2

select valor_honorario, * from tb_procedimento where fk_atendimento = 3862097

--tb_espelho espelho
-- tb_procedimento procedimento

select distinct atendimento.senha as autorizacao,
       procedimento.data_realizacao as dataAtendimento,
	   atendimento.paciente as nomeBeneficiario,
	   procedimento.valor_honorario as valorTotal,
	   espelho.numero_espelho as numeroEpelho,
	   entidade.nome,
	   convenio.nome,
	   endereco.logradouro
from tb_procedimento procedimento
inner join tb_atendimento atendimento on atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1
inner join tb_espelho espelho on espelho.id = atendimento.fk_espelho and espelho.registro_ativo = 1
inner join tb_entidade entidade on espelho.fk_entidade = entidade.id and entidade.registro_ativo = 1
inner join rl_entidade_convenio entidadeConvenio on entidade.id = entidadeConvenio.fk_entidade and entidadeConvenio.registro_ativo = 1
inner join tb_convenio convenio on convenio.id = entidadeConvenio.fk_convenio and convenio .registro_ativo = 1
inner join tb_endereco endereco on endereco.fk_convenio = convenio.id and endereco.in_endereco_correspondencia = 1
where espelho.numero_espelho=26912 and entidade.id = 2 and convenio.id = 270