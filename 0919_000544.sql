select itemdespesa.codigo as codigoDescricao, --0
       itemdespesa.descricao as itemDescricao, --1
	   cooperadoPJ.nome as nomePJ, --2
	   cooperadoPF.nome as nomePF, --3
	   procedimento.data_realizacao, --4
	   atendimento.paciente as paciente, --5
	   convenio.sigla as convenio, --6
	   hospital.sigla as hospital, --7
	   sum(lancamento.valor_lancamento) AS valorBrutoLancamento, --8
	   repasse.data_criacao as dataRepasse, --9
	   procedimento.quantidade as quantidade, --10
	   acomodacao.descricao as acomodacaoDescricao, --11
	   cooperadoPJ.id as idPj, --12
	   cooperadoPF.id as idPf, --13
	   repasse.id as idRepasse, --14
	   repasse.fk_entidade, --15
	   dadosComplementares.numero_atendimento_hospital, --16
	   cooperadoPF.numero_conselho --17
from tb_repasse repasse  with(nolock)
inner join rl_repasse_lancamento lancamento with(nolock)
 on (lancamento.fk_repasse = repasse.id and lancamento.registro_ativo = 1 and repasse.fk_entidade=lancamento.fk_entidade)
inner join tb_pagamento_procedimento pagamentoprocedimento with(nolock)
 on (pagamentoprocedimento.id = lancamento.fk_pagamento_procedimento and pagamentoprocedimento.registro_ativo = 1)
inner join tb_procedimento procedimento with(nolock)
 on (procedimento.id = pagamentoprocedimento.fk_procedimento and procedimento.fk_cooperado_recebedor_cobranca = lancamento.fk_cooperado_lancamento
      and procedimento.registro_ativo = 1)
inner join tb_atendimento atendimento with(nolock)
 on (atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1)
left join tb_espelho espelho with(nolock)
 on (espelho.id = atendimento.fk_espelho and espelho.registro_ativo = 1)
inner join rl_entidade_convenio entidadeConvenio with(nolock)
 on (entidadeConvenio.id = atendimento.fk_convenio and entidadeConvenio.registro_ativo = 1 and entidadeConvenio.fk_entidade = repasse.fk_entidade)
inner join tb_convenio convenio with(nolock)
 on (convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1)
inner join tb_hospital hospital with(nolock)
 on (hospital.id = atendimento.fk_hospital and hospital.registro_ativo = 1)
inner join tb_cooperado cooperadoPF with(nolock)
 on (cooperadoPF.id = procedimento.fk_cooperado_executante_complemento and cooperadoPF.registro_ativo = 1)
inner join tb_cooperado cooperadoPJ with(nolock)  on (cooperadoPJ.id = procedimento.fk_cooperado_recebedor_cobranca and cooperadoPJ.registro_ativo = 1)
inner join tb_item_despesa itemdespesa with(nolock)  on (itemdespesa.id = procedimento.fk_item_despesa and itemdespesa.registro_ativo = 1)
inner join tb_tabela_tiss acomodacao with(nolock) on (acomodacao.id = procedimento.fk_acomodacao and acomodacao.registro_ativo = 1)
inner join tb_dados_complementares dadosComplementares with(nolock) on (dadosComplementares.fk_atendimento = atendimento.id and dadosComplementares.registro_ativo = 1)
where  repasse.registro_ativo = 1
       and repasse.fk_entidade = 23
	   and procedimento.fk_cooperado_executante_complemento <> procedimento.fk_cooperado_recebedor_cobranca
	   and (convert(date,repasse.data_criacao) <= '2019-08-31')
	   and (convert(date,repasse.data_criacao) >= '2019-08-01')
	   --and (cooperadoPF.id in (18699) or cooperadoPJ.id in (18699))
group by itemdespesa.codigo,
         itemdespesa.descricao,
		 cooperadoPJ.nome,
		 cooperadoPF.nome,
		 procedimento.data_realizacao,
		 atendimento.paciente,
		 convenio.sigla,
		 hospital.sigla,
		 repasse.data_criacao,
		 procedimento.quantidade,
		 acomodacao.descricao,
		 cooperadoPJ.id,
		 cooperadoPF.id,
		 repasse.id,
		 repasse.fk_entidade,
		 dadosComplementares.numero_atendimento_hospital,
		 cooperadoPF.numero_conselho
		 
UNION ALL

select lancamentoRepasseEventual.numero_lancamento as codigoDescricao, --0
       lancamentoRepasse.descricao as itemDescricao, --1
	   cooperadoLancamentoEventualPJ.nome as nomePJ, --2
	   cooperadoLancamentoEventualPF.nome as nomePF, --3
	   null, --4
	   lancamentoRepasseEventual.descricao as paciente, --5
	   convenio.sigla as convenio, --6
	   null as hospital, --7
	   case when lancamentoRepasse.natureza_contabil<>1 then lancamentoRepasseEventual.valor_lancamento else -1*(lancamentoRepasseEventual.valor_lancamento) end AS valorBrutoLancamento, --8
	   lancamentoRepasseEventual.data_lancamento as dataRepasse, --9
	   null as quantidade, --10
	   null as acomodacaoDescricao, --11
	   cooperadoLancamentoEventualPJ.id as idPj, --12
	   cooperadoLancamentoEventualPF.id as idPf, --13
	   repasse.id as idRepasse, --14
	   repasse.fk_entidade, --15
	   null, --16
	   cooperadoLancamentoEventualPF.numero_conselho --17
from tb_repasse repasse  with(nolock)
inner join rl_repasse_lancamento lancamento with(nolock)
  on (lancamento.fk_repasse = repasse.id and lancamento.registro_ativo = 1 and repasse.fk_entidade=lancamento.fk_entidade)
inner join tb_lancamento_repasse_eventual lancamentoRepasseEventual with(nolock)
  on (lancamentoRepasseEventual.fk_repasse = repasse.id and lancamentoRepasseEventual.registro_ativo = 1)
inner join tb_cooperado cooperadoLancamentoEventualPJ with(nolock)
  on (lancamentoRepasseEventual.fk_cooperado_recebedor_cobranca = cooperadoLancamentoEventualPJ.id and cooperadoLancamentoEventualPJ.registro_ativo = 1)
inner join tb_cooperado cooperadoLancamentoEventualPF with(nolock)
  on (lancamentoRepasseEventual.fk_cooperado_executante = cooperadoLancamentoEventualPF.id and cooperadoLancamentoEventualPF.registro_ativo = 1)
inner join tb_lancamento_repasse lancamentoRepasse  with(nolock)
  on (lancamentoRepasse.id = lancamentoRepasseEventual.fk_lancamento_repasse and lancamentoRepasse.registro_ativo =1)
inner join tb_convenio convenio with(nolock) on (convenio.id = lancamentoRepasseEventual.fk_convenio and convenio.registro_ativo = 1)
where repasse.registro_ativo = 1 and repasse.fk_entidade = 23 and cooperadoLancamentoEventualPF.id <> cooperadoLancamentoEventualPJ.id
  and (convert(date,repasse.data_criacao) <= '2019-08-31')  and (convert(date,repasse.data_criacao) >= '2019-08-01')
  --and (cooperadoLancamentoEventualPF.id in (18699) or cooperadoLancamentoEventualPJ.id in (18699))
group by cooperadoLancamentoEventualPJ.nome,
         cooperadoLancamentoEventualPF.nome,
		 repasse.id,
		 repasse.fk_entidade,
		 lancamentoRepasseEventual.valor_lancamento,repasse.data_criacao,
		 cooperadoLancamentoEventualPF.id,
		 cooperadoLancamentoEventualPJ.id,
		 lancamentoRepasse.descricao,
		 lancamentoRepasse.natureza_contabil,
		 cooperadoLancamentoEventualPF.numero_conselho,
		 lancamentoRepasseEventual.numero_lancamento,
		 lancamentoRepasseEventual.data_lancamento,
		 lancamentoRepasseEventual.descricao,
		 convenio.sigla
order by nomePJ