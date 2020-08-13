select * from rl_repasse_credito repasseCredito
inner join rl_entidade_cooperado_dados_bancarios dadosBancariosCooperados
           on (dadosBancariosCooperados.fk_banco = repasseCredito.fk_banco
               and dadosBancariosCooperados.agencia = repasseCredito.agencia
			   and dadosBancariosCooperados.conta = repasseCredito.conta
			   and repasseCredito.registro_ativo = 1)
where dadosBancariosCooperados.fk_entidade_cooperado = 40259
      and dadosBancariosCooperados.id = 38146
      and repasseCredito.fk_cooperado = 8624
      and repasseCredito.fk_entidade = 23

