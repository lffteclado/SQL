    /* db.agencia,
    db.conta,
    db.tipo,
    banco.numero_banco,
    banco.descricao,
    db.valor_desconto_cnab,*/
	
	select calculado.data_ultima_alteracao as data_ultima_alteracao,
                 1 as registro_ativo,
                 null as foi_gerado_CNAB,
                 calculado.valor_lancamento as valor_credito,
                 calculado.fk_usuario_ultima_alteracao as fk_usuario_ultima_alteracao,
                 calculado.fk_cooperado_lancamento as fk_cooperado,
                 calculado.fk_entidade as fk_entidade,
                 calculado.fk_repasse as fk_repasse,
                 calculado.data_ultima_alteracao as data_pagamento,
				 dadosBancarios.fk_banco,
				 dadosBancarios.agencia,
				 dadosBancarios.conta,
				 dadosBancarios.tipo,
				 dadosBancarios.valor_desconto_cnab
            from rl_repasse_calculado calculado
      inner join rl_entidade_lancamento_repasse entidadeLancamentoLiquido on (entidadeLancamentoLiquido.fk_entidade = calculado.fk_entidade 
                                                                          and calculado.fk_lancamento_repasse = entidadeLancamentoLiquido.fk_lancamento_repasse
                                                                          and entidadeLancamentoLiquido.tipo_calculo_sistema = 0 
                                                                          and entidadeLancamentoLiquido.registro_ativo = 1)
      inner join tb_cooperado cooperado on(calculado.fk_cooperado_lancamento=cooperado.id and cooperado.discriminator <> 'se' and cooperado.registro_ativo=1)
	  inner join rl_entidade_cooperado entidadeCooperado on (entidadeCooperado.fk_cooperado = cooperado.id
	                                                     and entidadeCooperado.fk_entidade = calculado.fk_entidade
														 and entidadeCooperado.registro_ativo = 1 )
	  inner join rl_entidade_cooperado_dados_bancarios dadosBancarios on (dadosBancarios.fk_entidade_cooperado = entidadeCooperado.id and dadosBancarios.situacao = 1)
           where calculado.fk_repasse = 17710
             and calculado.valor_lancamento > 0