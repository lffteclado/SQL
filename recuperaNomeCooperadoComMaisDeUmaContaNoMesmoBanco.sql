select  entidadeCooperadoDadosBancarios.fk_entidade_cooperado,
        repasseCredito.fk_banco,
		cooperado.nome,
		count(*) from rl_repasse_credito  repasseCredito
		inner join rl_entidade_cooperado entidadeCooperado on(repasseCredito.fk_cooperado=entidadeCooperado.fk_cooperado and repasseCredito.fk_entidade=entidadeCooperado.fk_entidade and repasseCredito.registro_ativo = 1)
		inner join rl_entidade_cooperado_dados_bancarios entidadeCooperadoDadosBancarios on(entidadeCooperadoDadosBancarios.fk_entidade_cooperado=entidadeCooperado.id and entidadeCooperadoDadosBancarios.registro_ativo=1)
		inner join tb_cooperado cooperado on(cooperado.id=entidadeCooperado.fk_cooperado and cooperado.registro_ativo=1)
		where fk_repasse= 18011
		group by entidadeCooperadoDadosBancarios.fk_entidade_cooperado, repasseCredito.fk_banco, cooperado.nome
		having count(*)>1



SELECT cooperado.nome,
count(cooperado.id)
FROM rl_repasse_credito repasseCredito WITH(NOLOCK)
INNER JOIN tb_cooperado cooperado WITH(NOLOCK) ON (cooperado.id = repasseCredito.fk_cooperado /*AND repasseCredito.registro_ativo = 1*/)
WHERE repasseCredito.fk_repasse = 18011
GROUP BY cooperado.id, cooperado.nome
HAVING COUNT(cooperado.id) > 1



