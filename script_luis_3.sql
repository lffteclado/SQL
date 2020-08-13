
    select  entidadeCooperadoDadosBancarios.fk_entidade_cooperado,entidadeCooperadoDadosBancarios.fk_banco,cooperado.nome,count(*)
	 from rl_repasse_credito  repasseCredito
    inner join rl_entidade_cooperado entidadeCooperado on(repasseCredito.fk_cooperado=entidadeCooperado.fk_cooperado and repasseCredito.fk_entidade=entidadeCooperado.fk_entidade and repasseCredito.registro_ativo = 1)
    inner join rl_entidade_cooperado_dados_bancarios entidadeCooperadoDadosBancarios on(entidadeCooperadoDadosBancarios.fk_entidade_cooperado=entidadeCooperado.id and entidadeCooperadoDadosBancarios.registro_ativo=1)
    inner join tb_cooperado cooperado on(cooperado.id=entidadeCooperado.fk_cooperado and cooperado.registro_ativo=1)
    where fk_repasse in (select id from tb_repasse where numero_repasse = 126 and fk_entidade = 46)
    group by entidadeCooperadoDadosBancarios.fk_entidade_cooperado,entidadeCooperadoDadosBancarios.fk_banco,cooperado.nome
    having count(*)>1