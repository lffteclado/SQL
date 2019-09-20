declare @entidade bigint,
        @convenio bigint,
        @dataInicio varchar(11),
		@dataFim varchar(11)


/* Informar os valores */

select @entidade = 20,
       @convenio = 117,
       @dataInicio = '2019-07-01',
	   @dataFim = '2019-07-31'


   select consulta.cnpj_convenio,
          consulta.inscricao_inss,
		  consulta.repasse,
		  consulta.idCalculado,
		  consulta.valor_base_inss,
          consulta.valor_inss_por_convenio,
		  consulta.valor_devolucao_por_convenio,
		  consulta.idCooperado, consulta.idRepasse,
          consulta.baseINSS,
		  consulta.valor_inss_calculado,
		  consulta.pk_importacao,
		  consulta.natureza_contabil,
		  consulta.cnpj_entidade,
          consulta.pk_importacao_web,
		  consulta.tipo,
		  consulta.idConvenio,
		  consulta.percentual
    from
   (SELECT convenio.cnpj as cnpj_convenio, 
             cooperado.inscricao_inss AS inscricao_inss, 
             repasse.numero_repasse as repasse, 
             calculado.id as idCalculado, 
             coalesce(calculado.valor_lancamento,0) AS valor_base_inss, 
             coalesce(cast(calculado.valor_lancamento * ((tabelaLancamentoINSS.valor_lancamento - coalesce(tabelaDeclaracao.valor_devolucao,0))/tabelaConvenio.valor_lancamento_bruto) as numeric(19,2)),0) AS valor_inss_por_convenio, 
             coalesce(cast(calculado.valor_lancamento * ((coalesce(tabelaDeclaracao.valor_devolucao,0))/tabelaConvenio.valor_lancamento_bruto) as numeric(19,2)),0) AS valor_devolucao_por_convenio, 
             cooperado.id AS idCooperado, 
             repasse.id AS idRepasse, 
             tabelaDeclaracao.base_inss AS baseINSS, 
             cast(coalesce(calculado.valor_lancamento/(select coalesce(sum(calc.valor_lancamento),0) from rl_repasse_calculado calc 
              inner join tb_repasse rep on (rep.id = calc.fk_repasse and rep.registro_ativo = 1) 
              inner join rl_entidade_lancamento_repasse entidadeLancPrincipal on (entidadeLancPrincipal.fk_lancamento_repasse = calc.fk_lancamento_repasse and entidadeLancPrincipal.registro_ativo = 1 and entidadeLancPrincipal.situacao = 1  AND entidadeLancPrincipal.fk_entidade = calc.fk_entidade) 
              inner join tb_lancamento_repasse lancamentoRepPrincipal on (lancamentoRepPrincipal.id = calc.fk_lancamento_repasse and lancamentoRepPrincipal.registro_ativo = 1 and lancamentoRepPrincipal.situacao = 1) 
              inner join tb_incidencia_lancamento_repasse incide on (incide.fk_lancamento_repasse_principal = lancamentoRepPrincipal.id and incide.registro_ativo = 1) 
              inner join tb_lancamento_repasse lancamentoRepIncidente on (lancamentoRepIncidente.id = incide.fk_lancamento_repasse_incidente and lancamentoRepIncidente.registro_ativo = 1 and lancamentoRepIncidente.situacao = 1) 
              inner join rl_entidade_lancamento_repasse entidadeLancInss on (entidadeLancInss.fk_lancamento_repasse = lancamentoRepIncidente.id and entidadeLancInss.registro_ativo = 1 and entidadeLancInss.situacao = 1 and entidadeLancInss.fk_entidade = calc.fk_entidade and entidadeLancInss.tipo_calculo_lancamento = 3 and (entidadeLancInss.tipo_calculo_sistema = 6 or entidadeLancInss.tipo_calculo_sistema = 16)) 
          where calc.registro_ativo = 1 and  rep.fk_entidade = @entidade
             and rep.data_criacao between @dataInicio and @dataFim
             and calc.fk_cooperado_lancamento = cooperado.id 
             and calc.tipo_lancamento_repasse = 0 
             and calc.fk_repasse = repasse.id 
             and calc.tipo_demonstrativo = 0  
             and calc.fk_convenio is not null)*tabelaDeclaracao.base_inss*tabelaDeclaracao.percentual - (cast(calculado.valor_lancamento * ((coalesce(tabelaDeclaracao.valor_devolucao,0))/tabelaConvenio.valor_lancamento_bruto) AS numeric(19,2))),0)as numeric(19,2)) as valor_inss_calculado, 
				repasse.pk_importacao, calculado.natureza_contabil, entidade.cnpj as cnpj_entidade, repasse.pk_importacao_web, 0 as tipo, convenio.id as idConvenio,
				tabelaDeclaracao.percentual As Percentual FROM rl_repasse_calculado calculado 
             INNER JOIN tb_entidade entidade ON (entidade.id = calculado.fk_entidade AND entidade.registro_ativo=1) 
             INNER JOIN tb_convenio convenio ON (convenio.id = calculado.fk_convenio AND convenio.registro_ativo=1) 
             INNER JOIN tb_cooperado cooperado ON (cooperado.id = calculado.fk_cooperado_lancamento AND cooperado.registro_ativo=1 AND cooperado.discriminator = 'pf') 
             INNER JOIN tb_repasse repasse ON (repasse.id = calculado.fk_repasse AND repasse.registro_ativo=1) 
             LEFT JOIN ( select declaracaoINSS.valor_devolucao, declaracaoINSS.fk_cooperado, declaracaoINSS.fk_repasse, declaracaoINSS.base_inss  ,declaracaoINSS.numero_repasse_web,declaracaoINSS.fk_entidade, 
							isnull(declaracaoINSS.percentual_calculo,20)/100 percentual from tb_declaracao_inss declaracaoINSS where declaracaoINSS.registro_ativo=1 ) tabelaDeclaracao 
							ON repasse.registro_ativo = 1 and ((tabelaDeclaracao.fk_repasse = repasse.id and cooperado.id = tabelaDeclaracao.fk_cooperado and repasse.pk_importacao is null and repasse.pk_importacao_web is null) or (tabelaDeclaracao.fk_repasse is null and repasse.numero_repasse=tabelaDeclaracao.numero_repasse_web and tabelaDeclaracao.fk_entidade=calculado.fk_entidade and cooperado.id = tabelaDeclaracao.fk_cooperado and (repasse.pk_importacao is not null or repasse.pk_importacao_web is not null))) 
							inner join rl_entidade_lancamento_repasse entidadeLancamentoPrincipal on (entidadeLancamentoPrincipal.fk_lancamento_repasse = calculado.fk_lancamento_repasse and entidadeLancamentoPrincipal.registro_ativo = 1 and entidadeLancamentoPrincipal.situacao = 1  AND entidadeLancamentoPrincipal.fk_entidade = repasse.fk_entidade)   
							inner join tb_lancamento_repasse lancamentoRepassePrincipal on (lancamentoRepassePrincipal.id = calculado.fk_lancamento_repasse and lancamentoRepassePrincipal.registro_ativo = 1 and lancamentoRepassePrincipal.situacao = 1)   
							inner join tb_incidencia_lancamento_repasse incidencia on (incidencia.fk_lancamento_repasse_principal = lancamentoRepassePrincipal.id and incidencia.registro_ativo = 1)   
							inner join tb_lancamento_repasse lancamentoRepasseIncidente on (lancamentoRepasseIncidente.id = incidencia.fk_lancamento_repasse_incidente and lancamentoRepasseIncidente.registro_ativo = 1 and lancamentoRepasseIncidente.situacao = 1)   
							inner join rl_entidade_lancamento_repasse entidadeLancamentoInss on (entidadeLancamentoInss.fk_lancamento_repasse = lancamentoRepasseIncidente.id and entidadeLancamentoInss.registro_ativo = 1   
                                                                                    and entidadeLancamentoInss.situacao = 1   
                                                                                    and entidadeLancamentoInss.fk_entidade = repasse.fk_entidade    
                                                                                    and entidadeLancamentoInss.tipo_calculo_lancamento = 3    
                                                                                    and (entidadeLancamentoInss.tipo_calculo_sistema = 6 or entidadeLancamentoInss.tipo_calculo_sistema = 16)) 
			 LEFT JOIN (SELECT calculadoINSS.fk_repasse, 
								calculadoINSS.fk_cooperado_lancamento, 
								calculadoINSS.valor_lancamento, 
								entidadeLancamentoRepasse.fk_entidade 
						FROM rl_repasse_calculado calculadoINSS 
						INNER JOIN rl_entidade_lancamento_repasse entidadeLancamentoRepasse
						 ON (calculadoINSS.fk_lancamento_repasse = entidadeLancamentoRepasse.fk_lancamento_repasse AND entidadeLancamentoRepasse.registro_ativo = 1) 
						WHERE (entidadeLancamentoRepasse.tipo_calculo_sistema=6 or entidadeLancamentoRepasse.tipo_calculo_sistema=16)
						AND entidadeLancamentoRepasse.tipo_calculo_lancamento=3
						AND calculadoINSS.registro_ativo=1 AND entidadeLancamentoRepasse.registro_ativo=1
						AND calculadoINSS.fk_saldo_devedor IS NULL
						AND isnull(calculadoINSS.processa_saldo_devedor,0) != 1 ) tabelaLancamentoINSS
						 ON (tabelaLancamentoINSS.fk_repasse = repasse.id AND tabelaLancamentoINSS.fk_cooperado_lancamento = cooperado.id AND tabelaLancamentoINSS.fk_entidade = repasse.fk_entidade) 
			LEFT JOIN (SELECT count(calculadoConvenio.id) AS quantidade_convenio_repasse, 
						sum (calculadoConvenio.valor_lancamento) AS valor_lancamento_bruto, 
						     calculadoConvenio.fk_repasse, 
						     calculadoConvenio.fk_cooperado_lancamento 
							FROM rl_repasse_calculado calculadoConvenio 
							WHERE calculadoConvenio.tipo_lancamento_repasse=0 
						AND calculadoConvenio.registro_ativo=1  
						AND calculadoConvenio.natureza_contabil=0  
						AND calculadoConvenio.tipo_demonstrativo = 0  
						GROUP BY calculadoConvenio.fk_repasse, 
								 calculadoConvenio.fk_cooperado_lancamento 
						) tabelaConvenio ON (tabelaConvenio.fk_repasse = repasse.id AND tabelaConvenio.fk_cooperado_lancamento = cooperado.id) 
						WHERE calculado.registro_ativo = 1 
						AND calculado.tipo_lancamento_repasse = 0 
						AND calculado.tipo_demonstrativo = 0     
						AND repasse.fk_entidade =  @entidade
                        and repasse.data_criacao between @dataInicio and @dataFim
                        and convenio.id = @convenio

   GROUP BY convenio.cnpj, 
               cooperado.inscricao_inss, 
               calculado.valor_lancamento, 
               tabelaLancamentoINSS.valor_lancamento, 
               tabelaConvenio.quantidade_convenio_repasse, 
               repasse.numero_repasse, 
               calculado.id, 
               tabelaConvenio.valor_lancamento_bruto, 
               tabelaDeclaracao.valor_devolucao, 
               cooperado.id, 
               repasse.id, 
               tabelaDeclaracao.base_inss, 
        repasse.pk_importacao, 
        calculado.natureza_contabil, 
        entidade.cnpj, 
        repasse.pk_importacao_web, convenio.id, tabelaDeclaracao.percentual
    UNION 
    select convenio.cnpj as cnpj_convenio,
     cooperado.inscricao_inss as inscricao_inss,
     null as repasse, 
     null as idCalculado, 
     0.01 as valor_base_inss,
     0.00 as valor_inss_por_convenio, 
     0.00 as valor_devolucao_por_convenio, 
     cooperado.id as idCooperado,
     null as idRepasse,
     0.01 as baseINSS,
     0.00 as valor_inss_calculado,
     null as pk_importacao,
     0 as natureza_contabil,
     entidade.cnpj as cnpj_entidade,
     null as pk_importacao_web,
     1 as tipo, convenio.id as idConvenio, 0.2 as percentual
   from tb_fatura fatura,
     tb_entidade entidade, tb_convenio convenio,
     tb_cooperado cooperado, tb_entidade_sefip eSefip
    where entidade.id         = fatura.fk_entidade
    and convenio.id         = fatura.fk_convenio
    and eSefip.fk_cooperado     = cooperado.id 
    and eSefip.fk_entidade        = entidade.id 
    and eSefip.registro_ativo   = 1    
    and cooperado.registro_ativo    = 1
    and fatura.registro_ativo   = 1
    and entidade.registro_ativo   = 1
    and convenio.registro_ativo   = 1   
    and entidade.id         =  @entidade
    and fatura.data_emissao between @dataInicio and @dataFim
    and convenio.id = @convenio
   
   -- Verifica se não houve pagto parcial
    and not exists (select 1
           from tb_pagamento_fatura pagtoFat, tb_repasse repa 
          where pagtoFat.fk_fatura = fatura.id 
            and pagtoFat.fk_repasse = repa.id 
            and pagtoFat.registro_ativo = 1
            and repa.registro_ativo = 1
            and repa.data_criacao between @dataInicio and @dataFim)
    group by convenio.cnpj,
      cooperado.inscricao_inss,
      cooperado.id,
      entidade.cnpj, convenio.id) consulta
      where not exists (select 1
                          from rl_entidade_cooperado entCoop,
                               rl_repasse_calculado repCal,
                               tb_repasse rep
                         where entCoop.fk_entidade=repCal.fk_entidade
                           and entCoop.fk_cooperado=repCal.fk_cooperado_lancamento
                           and repCal.fk_repasse=rep.id
                           and repCal.registro_ativo=1
                           and repCal.fk_entidade=  @entidade
                           and repCal.fk_cooperado_lancamento=consulta.idCooperado
                           and rep.id = consulta.idRepasse
                           and entCoop.registro_ativo=1
                           and isnull(rep.repasse_diretor_conselheiro,0)=1
                           and (entCoop.diretor=1 or entCoop.conselheiro=1))
    order by isnull(consulta.cnpj_convenio, consulta.cnpj_entidade) asc,
           consulta.inscricao_inss asc, consulta.tipo asc, consulta.natureza_contabil desc, consulta.repasse asc
