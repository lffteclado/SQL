select distinct entidade.sigla as 'Entidade'
       ,cooperado.nome as 'Cooperado'
	   ,cooperado.numero_conselho as 'CRM'
	   ,case entidadeCooperado.situacao_cooperado
	    when 0 then 'Ativo'
		when 1 then 'Excluído'
		when 2 then 'Demitido'
		when 3 then 'Falecido'
		when 4 then 'Inativo'
		when 5 then 'Exclusivo Unimed'
		when 6 then 'A verificar'
		when 7 then 'Eliminado'
		when 8 then 'Vinculado de Outro Prestador'
		when 9 then 'A Integralizar'
		when 10 then 'Licenciado'
		when 11 then 'Suspenso'
		when 12 then 'Adesão à Cooperativa'
		else 'Indeterminada'
		end as 'Situação do Cooperado na Entidade'
from rl_entidade_cooperado entidadeCooperado with(nolock)
inner join tb_cooperado cooperado with(nolock) on(cooperado.id = entidadeCooperado.fk_cooperado and cooperado.registro_ativo = 1 and entidadeCooperado.registro_ativo = 1)
inner join tb_entidade entidade with(nolock) on(entidade.id = entidadeCooperado.fk_entidade and entidade.registro_ativo = 1)
inner join tb_integracao_inss_unimed inss with(nolock) on(lower(inss.nome_cooperado) = lower(cooperado.nome)
                                                          and inss.cpf_cooperado = cooperado.cpf_cnpj
														  and inss.registro_ativo = 1)
where inss.fk_importacao_base = 141438
and entidade.id = 43
order by entidade.sigla, cooperado.nome