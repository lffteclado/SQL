--select valor_cofins, numero_fatura, sum(valor_total_honorario + valor_total_custo_operacional + valor_total_filme + valor_total_acrescimo + valor_custeio - valor_total_desconto) as valor_total from tb_fatura where id = 61239 group by numero_fatura, tb_fatura.valor_cofins, id order by id

--select sum(valor_total_honorario + valor_total_custo_operacional + valor_total_filme + valor_total_acrescimo + valor_custeio - valor_total_desconto) as valor_bruto from tb_espelho where id = 61239

--select top 1 * from rl_repasse_lancamento

select top 1 * from tb_tabela_tiss

select * from tb_procedimento where fk_atendimento = 4682204

select top 1 * from tb_tabela_tiss

select * from tb_atendimento where numero_atendimento_automatico = 4682204

select * from tb_tabela_tiss
inner join tb_procedimento

-- tb_tabela_tiss acomodacao.id =  tb_procedimento procedimento.fk_acomodacao

--tb_tabela_tiss

--tb_atendimento

--tb_procedimento