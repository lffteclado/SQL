 SELECT DISTINCT
     entidadeDadosBancarios.id,
     bancoEntidade.descricao,
     bancoEntidade.numero_banco,
     entidadeDadosBancarios.agencia,
     entidadeDadosBancarios.conta,
     bancoEntidade.id AS idBancoEntidade,
     entidade.id AS idEntidade,
     entidadeDadosBancarios.tipoCNAB AS idTipoCNAB,
     entidade.nome,
     entidade.sigla siglaEntidade,
     entidade.cnpj,
     entidadeDadosBancarios.codigo_lancamento
     FROM rl_repasse_credito repasseCredito
     INNER JOIN tb_entidade entidade ON(entidade.id=repasseCredito.fk_entidade AND entidade.registro_ativo=1 AND repasseCredito.registro_ativo=1)
     INNER JOIN tb_cooperado cooperado ON(repasseCredito.fk_cooperado=cooperado.id AND cooperado.registro_ativo=1)
     INNER JOIN rl_entidade_dados_bancarios entidadeDadosBancarios ON(entidadeDadosBancarios.fk_entidade=entidade.id AND entidadeDadosBancarios.registro_ativo=1)
     INNER JOIN tb_banco bancoEntidade ON(bancoEntidade.id=entidadeDadosBancarios.fk_banco AND bancoEntidade.registro_ativo=1)
	 WHERE repasseCredito.fk_repasse=18020--1896
     AND repasseCredito.fk_banco=entidadeDadosBancarios.fk_banco
     AND entidadeDadosBancarios.tipoCNAB IS NOT NULL

	 --select * from rl_entidade_dados_bancarios where fk_entidade = 23

	 SELECT repasseCredito.id
	  FROM tb_repasse repasse
	 INNER JOIN rl_repasse_credito repasseCredito ON (repasse.id = repasseCredito.fk_repasse AND repasse.registro_ativo = 1 AND repasseCredito.registro_ativo = 1)
	 WHERE repasse.id = 17020 AND repasseCredito.fk_banco IS NOT NULL

	 select top 1000 fk_banco, * from rl_repasse_credito order by id desc