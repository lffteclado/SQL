/**
* Chamado #0619-000293
* Relatório: Consultas eletivas do período de 01/2019 á 05/2019.
* Ou Seja, procedimentos gerados no sistema através da integração hospitais, com o código 10101012
*/

select distinct convenio.sigla as 'Convênio',
       cooperado.nome as 'Nome do Médico',
	   tiss.descricao as 'Especialidade',
       atendimento.numero_guia as 'Número de Guias',
	   --itemDespesa.codigo,
	   (pagamentoProcedimento.valor_honorario + pagamentoProcedimento.valor_acrescimo - pagamentoProcedimento.valor_desconto) as 'Valor',
	   --procedimento.id,
	   atendimento.numero_atendimento_automatico
	   --cooperado.id as cooperadoId
from  tb_atendimento atendimento with (nolock)
inner join tb_procedimento procedimento with (nolock) on procedimento.fk_atendimento = atendimento.id and atendimento.registro_ativo = 1
inner join tb_cooperado cooperado with(nolock) on cooperado.id = procedimento.fk_cooperado_executante_complemento and cooperado.registro_ativo = 1
inner join tb_pagamento_procedimento pagamentoProcedimento with (nolock) on pagamentoProcedimento.fk_procedimento = procedimento.id and pagamentoProcedimento.registro_ativo = 1
inner join tb_item_despesa itemDespesa with (nolock) on itemDespesa.id = procedimento.fk_item_despesa and itemDespesa.registro_ativo = 1
inner join rl_entidade_convenio entidadeConvenio with (nolock) on atendimento.fk_convenio = entidadeConvenio.id and entidadeConvenio.registro_ativo = 1
inner join tb_convenio convenio with (nolock) on convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1
inner join rl_entidade_cooperado entidadeCooperado with (nolock) on entidadeCooperado.fk_entidade = atendimento.fk_entidade and entidadeCooperado.fk_cooperado = procedimento.fk_cooperado_executante_complemento and entidadeCooperado.registro_ativo = 1
inner join rl_entidadecooperado_especialidade cooperadoEspecialidade with(nolock) on cooperadoEspecialidade.fk_entidade_cooperado = entidadeCooperado.id and cooperadoEspecialidade.principal = 1 and  cooperadoEspecialidade.registro_ativo = 1
inner join tb_tabela_tiss tiss with(nolock) on tiss.id = cooperadoEspecialidade.fk_especialidade and tiss.registro_ativo = 1
where atendimento.fk_integracao_hospital is not null
 and atendimento.data_cadastro between '2019-01-01' and '2019-05-31' and itemDespesa.codigo = '10101012' and atendimento.fk_entidade = 63 and procedimento.urgencia = 0