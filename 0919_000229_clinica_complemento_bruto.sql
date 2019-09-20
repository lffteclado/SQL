select repasse.numero_repasse, itemdespesa.codigo, cooperadoPJ.nome as nomePJ, cooperadoPF.nome as nomePF, procedimento.data_realizacao,
    atendimento.numero_atendimento_automatico, atendimento.paciente, convenio.sigla as convenio, hospital.sigla as hospital,
    procedimento.desconto_hospitalar, fatura.numero_fatura, sum(lancamento.valor_lancamento) as valor_lancamento , cooperadoPF.numero_conselho as crm, repasse.data_criacao as dataRepasse, procedimento.quantidade as quantidade,
      complementoHospital.sigla AS siglaComplemento, acomodacao.descricao, cooperadoPJ.id
    from tb_repasse repasse  with(nolock) 
    inner join rl_repasse_lancamento lancamento with(nolock)  on (lancamento.fk_repasse = repasse.id and lancamento.registro_ativo = 1 and repasse.fk_entidade=lancamento.fk_entidade)
    inner join tb_pagamento_fatura pagto_fatura with(nolock)  on (pagto_fatura.id = lancamento.fk_pagamento_fatura and pagto_fatura.registro_ativo = 1)
    inner join tb_fatura fatura with(nolock)  on (fatura.id = pagto_fatura.fk_fatura and fatura.registro_ativo = 1)
    inner join tb_pagamento_procedimento pagamentoprocedimento with(nolock)  on (pagamentoprocedimento.id = lancamento.fk_pagamento_procedimento and pagamentoprocedimento.registro_ativo = 1)
    inner join tb_procedimento procedimento with(nolock)  on (procedimento.id = pagamentoprocedimento.fk_procedimento and procedimento.fk_cooperado_recebedor_cobranca = lancamento.fk_cooperado_lancamento and procedimento.registro_ativo = 1)
    inner join tb_atendimento atendimento with(nolock)  on (atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1)
    left join rl_entidade_hospital_complemento complementoHospital with(nolock)  ON (atendimento.fk_complemento_hospital = complementoHospital.id AND complementoHospital.registro_ativo = 1)
    left join tb_espelho espelho with(nolock)  on (espelho.id = atendimento.fk_espelho and espelho.registro_ativo = 1)
    inner join rl_entidade_convenio entidadeConvenio with(nolock)  on (entidadeConvenio.id = atendimento.fk_convenio and entidadeConvenio.registro_ativo = 1 and entidadeConvenio.fk_entidade = repasse.fk_entidade)
    inner join tb_convenio convenio with(nolock)  on (convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1)
    inner join tb_hospital hospital with(nolock)  on (hospital.id = atendimento.fk_hospital and hospital.registro_ativo = 1)
    inner join tb_cooperado cooperadoPF with(nolock)  on (cooperadoPF.id = procedimento.fk_cooperado_executante_complemento and cooperadoPF.registro_ativo = 1)
    inner join tb_cooperado cooperadoPJ with(nolock)  on (cooperadoPJ.id = procedimento.fk_cooperado_recebedor_cobranca and cooperadoPJ.registro_ativo = 1)
    inner join tb_item_despesa itemdespesa with(nolock)  on (itemdespesa.id = procedimento.fk_item_despesa and itemdespesa.registro_ativo = 1)
    inner join tb_tabela_tiss acomodacao with(nolock) on (acomodacao.id = procedimento.fk_acomodacao AND acomodacao.registro_ativo = 1)

    where repasse.registro_ativo = 1 and repasse.fk_entidade = 23 and procedimento.fk_cooperado_executante_complemento <> procedimento.fk_cooperado_recebedor_cobranca
      and (convert(date,repasse.data_criacao) <= '2019-08-27')
      and (convert(date,repasse.data_criacao) >= '2019-08-27')
	  --and cooperadoPF.nome = 'Vinicius Almeida Soares Maia'

    group by repasse.numero_repasse, itemdespesa.codigo, cooperadoPJ.nome, cooperadoPF.nome, procedimento.data_realizacao,
    atendimento.numero_atendimento_automatico, atendimento.paciente, convenio.sigla, hospital.sigla,
    procedimento.desconto_hospitalar, fatura.numero_fatura, cooperadoPF.numero_conselho, repasse.data_criacao, procedimento.quantidade,
      complementoHospital.sigla,acomodacao.descricao, cooperadoPJ.id

    UNION ALL

    select repasse1.numero_repasse,
	 'N�o Informado' as codigo,
    cooperadoLancamentoEventualPJ.nome as nomePJ,
    cooperadoLancamentoEventualPF.nome as nomePF,
    lancamentoRepasseEventual.data_lancamento as data_realizacao,
    lancamentoRepasseEventual.numero_lancamento as numero_atendimento_automatico,
    lancamentoRepasseEventual.descricao as paciente,
    'N�o Informado'   as convenio,
    'N�o Informado'   as hospital,
    null  as desconto_hospitalar,
    null  as numero_fatura, 
     case when lancamentoRepasse.natureza_contabil<>1 then lancamentoRepasseEventual.valor_lancamento else -1*(lancamentoRepasseEventual.valor_lancamento) end AS valor_lancamento,
     null as crm, 
     repasse1.data_criacao as dataRepasse, 
     1  as quantidade, 
     'N�o Informado' AS siglaComplemento, 
     'N�o Informado' AS descricao, 
     cooperadoLancamentoEventualPJ.id  
      from tb_repasse repasse1  with(nolock) 
     inner join rl_repasse_lancamento lancamento with(nolock)  on (lancamento.fk_repasse = repasse1.id and lancamento.registro_ativo = 1 and repasse1.fk_entidade=lancamento.fk_entidade) 
     inner join tb_lancamento_repasse_eventual lancamentoRepasseEventual with(nolock) on (lancamentoRepasseEventual.fk_repasse = repasse1.id and lancamentoRepasseEventual.registro_ativo = 1) 
     inner join tb_cooperado cooperadoLancamentoEventualPJ with(nolock)  on (lancamentoRepasseEventual.fk_cooperado_recebedor_cobranca = cooperadoLancamentoEventualPJ.id and cooperadoLancamentoEventualPJ.registro_ativo = 1) 
     inner join tb_cooperado cooperadoLancamentoEventualPF with(nolock)  on (lancamentoRepasseEventual.fk_cooperado_executante = cooperadoLancamentoEventualPF.id and cooperadoLancamentoEventualPF.registro_ativo = 1) 
     inner join tb_lancamento_repasse lancamentoRepasse  with(nolock)  on (lancamentoRepasse.id = lancamentoRepasseEventual.fk_lancamento_repasse and lancamentoRepasse.registro_ativo =1) 

     where repasse1.registro_ativo = 1 and repasse1.fk_entidade = 23  and cooperadoLancamentoEventualPF.id <> cooperadoLancamentoEventualPJ.id 
      and (convert(date,repasse1.data_criacao) <= '2019-08-27')
      and (convert(date,repasse1.data_criacao) >= '2019-08-27')
	  --and cooperadoLancamentoEventualPF.nome = 'Vinicius Almeida Soares Maia'

         group by repasse1.numero_repasse, cooperadoLancamentoEventualPJ.nome, 
       cooperadoLancamentoEventualPF.nome, 
       cooperadoLancamentoEventualPJ.id,
       lancamentoRepasse.natureza_contabil,
       lancamentoRepasseEventual.valor_lancamento,
       repasse1.data_criacao,
	   lancamentoRepasseEventual.descricao,
	   lancamentoRepasseEventual.data_lancamento,
	   lancamentoRepasseEventual.numero_lancamento
     order by cooperadoPJ.nome, cooperadoPF.nome 