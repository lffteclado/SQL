/*
select * from tb_entidade where sigla = 'UNICOOPER' -- 43
select * from tb_convenio where sigla = 'Premium' and cnpj = '12682451000135' --1112
select * from rl_entidade_convenio where fk_entidade = 43 and fk_convenio = 1112 -- 3656
*/

select distinct atendimento.ano_atendimento as 'Ano Atendimento'
       ,atendimento.numero_atendimento_automatico as 'Numero Atendimento'
	   ,atendimento.paciente as 'Nome do Paciente'
	   ,itemDespesa.codigo as 'Código do Procedimento'
	   ,itemDespesa.descricao as 'Descrição do Procedimento'
	   ,convert(varchar(10), procedimento.data_realizacao, 103) as 'Data de Realização do Procedimento'
	   ,acomodacao.descricao as 'Acomodação'
	   ,espelho.numero_espelho as 'Numero do Espelho'
	   ,convert(varchar(10), espelho.data_emissao, 103) as 'Data de Emissão do Espelho'
	   ,convert(varchar(10), espelho.data_envio, 103) as 'Data em que o Espelho foi marcado como enviado'
	   ,procedimento.valor_total as 'Valor Total do Procedimento'
	   ,situacao.valorDigitado as 'Valor digitado (caso nao tenha espelho)'
	   ,situacao.valorEspelhado as 'Valor Espelhado'
	   ,situacao.valorGlosado as 'Valor Glosado'	   
	   ,situacao.valorFaturado as 'Valor Faturado'
	   ,situacao.valorRepassado as 'Valor Repassado'
	    from tb_atendimento atendimento
inner join tb_procedimento procedimento on(atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1 and procedimento.registro_ativo = 1)
inner join tb_item_despesa itemDespesa on(itemDespesa.id = procedimento.fk_item_despesa)
inner join tb_tabela_tiss acomodacao on(acomodacao.id = procedimento.fk_acomodacao)
left join tb_espelho espelho on(atendimento.fk_espelho = espelho.id and espelho.registro_ativo = 1)
left join rl_situacao_procedimento situacao on(procedimento.id = situacao.fk_procedimento)
 where atendimento.situacaoAtendimento <> 6
       and  atendimento.fk_convenio = 3656 -- Id Entidade Convênio Uniccoper/Premium
 order by atendimento.ano_atendimento, atendimento.numero_atendimento_automatico