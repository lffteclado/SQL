select distinct e.id, e.numero_espelho espelho, 
             t.descricao tipoGuia, t.id, 
             c.sigla convenio, ec.id, c.id,
             CONVERT (VARCHAR, e.data_emissao, 103) emissao, 
             CONVERT (VARCHAR, e.data_vencimento, 103) vencimento, 
             --isnull((e.valor_total_honorario +e.valor_total_acrescimo+e.valor_total_filme+e.valor_total_custo_operacional-e.valor_total_desconto),0) valorEspelho,
			 isnull((select sum(valor_total_atendimento) from tb_atendimento with (nolock) where e.id = fk_espelho),0) as valorEspelho, 
			 isnull((select sum(valor_total_atendimento) from tb_atendimento with (nolock) where e.id = fk_espelho and fk_hospital = hosp.id),0) as valorHospital, 
             isnull((select count (distinct at.id)
                             from tb_atendimento at with (nolock), tb_procedimento pr with (nolock), 
                                     tb_pagamento_procedimento ppr with (nolock), 
                                     tb_convenio co with (nolock), tb_espelho es with (nolock)
                           where at.fk_espelho = es.id
                              and pr.fk_atendimento = at.id
                              and ppr.fk_procedimento = pr.id
                              and pr.fk_tipo_guia = t.id
                              and co.id = c.id
                              and at.fk_convenio = ec.id 
                              and at.registro_ativo = 1 and es.registro_ativo = 1
                              and pr.registro_ativo = 1 and es.id = e.id and hosp.id = at.fk_hospital),0) quantAtend, 
             isnull((select count (distinct pr.id)
                             from tb_atendimento at with (nolock), tb_procedimento pr with (nolock), 
                                     tb_pagamento_procedimento ppr with (nolock), 
                                     tb_convenio co with (nolock), tb_espelho es with (nolock)
                           where at.fk_espelho = es.id
                              and pr.fk_atendimento = at.id
                              and ppr.fk_procedimento = pr.id
                              and pr.fk_tipo_guia = t.id
                              and co.id = c.id
                              and at.fk_convenio = ec.id 
                              and at.registro_ativo = 1 and es.registro_ativo = 1
                              and pr.registro_ativo = 1 and es.id = e.id and hosp.id = at.fk_hospital),0) quantProced, 
             u.nome colaborador,
			 hosp.sigla
             from tb_atendimento a with (nolock),
             tb_procedimento p with (nolock),
             tb_pagamento_procedimento pp with (nolock),
             rl_entidade_convenio ec with (nolock),
             rl_entidade_convenio ecEspelho with (nolock),
             tb_convenio c with (nolock),
             tb_espelho e with (nolock),
             tb_tabela_tiss t with (nolock),
             rl_entidade_usuario usu with (nolock),
             tb_usuario u with (nolock),
			 tb_hospital hosp with (nolock)
  where e.fk_entidade_usuario_criacao = usu.id
       and usu.fk_usuario = u.id 
       and a.fk_espelho = e.id
       and p.fk_atendimento = a.id
       and pp.fk_procedimento = p.id
       and p.fk_tipo_guia = t.id
       and a.fk_convenio = ec.id
       and ec.fk_convenio = c.id 
       and a.registro_ativo = 1
       and e.registro_ativo = 1
       and p.registro_ativo = 1
       and t.registro_ativo = 1
       and u.registro_ativo = 1
       and ecEspelho.id = e.fk_entidade_convenio
       and ecEspelho.fk_entidade = 63 
	   and hosp.id = a.fk_hospital
       --and e.data_emissao between '2019-04-01' and '2019-04-30'
       and e.id in (554556)
  group by e.id, e.numero_espelho, t.descricao, c.sigla, e.data_emissao, e.data_vencimento,
                u.nome, t.id, ec.id, c.id,
                e.valor_total_honorario, e.valor_total_acrescimo, e.valor_total_filme, 
                e.valor_total_custo_operacional, e.valor_total_desconto,hosp.sigla, hosp.id
union
select distinct e.id, e.numero_espelho espelho, 
             '', 0, 
             c.sigla convenio, ecEspelho.id, c.id,
             CONVERT (VARCHAR, e.data_emissao, 103) emissao, 
             CONVERT (VARCHAR, e.data_vencimento, 103) vencimento, 
             isnull((e.valor_total_honorario +e.valor_total_acrescimo+e.valor_total_filme+e.valor_total_custo_operacional-e.valor_total_desconto),0) valorEspelho,
			 0 valorHospital,
             0 quantAtend,
             0 quantProced,
             u.nome colaborador,''
  from tb_espelho e with (nolock),
          rl_entidade_convenio ecEspelho with (nolock),
          tb_convenio c with (nolock),
          rl_entidade_usuario usu with (nolock),
          tb_usuario u with (nolock)
where ecEspelho.id = e.fk_entidade_convenio
   and c.id = ecEspelho.fk_convenio
   and e.fk_entidade_usuario_criacao = usu.id
   and usu.fk_usuario = u.id 
   and ecEspelho.fk_entidade = 63 
   and e.data_emissao between '2019-04-01' and '2019-04-10'
   and not exists (select 1 from tb_atendimento a where a.fk_espelho = e.id) order by e.numero_espelho desc

