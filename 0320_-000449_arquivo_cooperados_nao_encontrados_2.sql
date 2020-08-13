select inss.nome_cooperado,
       inss.cpf_cooperado from tb_integracao_inss_unimed inss with(nolock)
where inss.cpf_cooperado not in (
select cooperado.cpf_cnpj
from tb_cooperado cooperado with(nolock)
inner join tb_integracao_inss_unimed inss with(nolock) on(cooperado.cpf_cnpj = inss.cpf_cooperado
                                             and lower(cooperado.nome) = lower(inss.nome_cooperado)
											 and cooperado.registro_ativo = 1 and inss.registro_ativo = 1)
where inss.fk_importacao_base = 141439
)and inss.fk_importacao_base = 141439