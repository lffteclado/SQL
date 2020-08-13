select atendimento.ano_atendimento as 'Ano Atendimento'
       ,atendimento.numero_atendimento_automatico as 'Número Atendimento'
	   ,convenio.sigla as 'Convênio'
	   ,procedimento.data_realizacao as 'Data Realização'
	   ,cooperadoExecutante.id as 'Id Cooperado Executante'
	   ,cooperadoExecutante.nome as 'Cooperado Executante'
	   ,cooperadoRecebedor.id as 'Id Cooperado Recebedor'
	   ,cooperadoRecebedor.nome as 'Cooperado Recebedor'
	   ,situacao.digitado as 'Digitado'
	   ,situacao.valorDigitado as 'Valor Digitado'
	   ,situacao.espelhado as 'Espelhado'
	   ,situacao.valorEspelhado as 'Valor Espelhado'
	   ,situacao.faturado as 'Faturado'   
	   ,situacao.valorFaturado as 'Valor Faturado'
	   ,situacao.repassado as 'Repassado'
	   ,situacao.valorRepassado as 'Valor Repassado'
	   ,situacao.glosado as 'Glosado'
	   ,situacao.valorGlosado as 'Valor Glosado'
	   ,case glosa.situacao
	   when 0 then 'Será Analisada'
	   when 1 then 'Será Reapresentada'
	   when 2 then 'Devida'
	   when 3 then 'Reapresentada'
	   when 4 then 'Recebida'
	   when 5 then 'Recebida Parcialmente'
	   when 6 then 'Negada'
	   when 7 then 'Reapresentada 2ª vez'
	   else 'Não Glosado'
	   end as 'Situação da Glosa'
	   ,procedimento.valor_total as 'Valor Total do Procedimento'
 from tb_atendimento atendimento
inner join tb_procedimento procedimento on(atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1 and procedimento.registro_ativo = 1)
inner join tb_cooperado cooperadoExecutante on(cooperadoExecutante.id = procedimento.fk_cooperado_executante_complemento and cooperadoExecutante.registro_ativo = 1)
inner join tb_cooperado cooperadoRecebedor on(cooperadoRecebedor.id  = procedimento.fk_cooperado_recebedor_cobranca and cooperadoRecebedor.registro_ativo = 1)
inner join rl_situacao_procedimento situacao on(situacao.fk_procedimento = procedimento.id)
inner join rl_entidade_convenio entidadeConvenio on(entidadeConvenio.id = atendimento.fk_convenio and entidadeConvenio.registro_ativo = 1)
inner join tb_convenio convenio on(convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1)
left join tb_glosa glosa on(glosa.fk_procedimento = procedimento.id and glosa.registro_ativo = 1)
where procedimento.data_realizacao >= '2019-04-01' -- Superior a 01/04/2019
--and procedimento.fk_cooperado_recebedor_cobranca <> procedimento.fk_cooperado_executante_complemento
and atendimento.fk_entidade in (select id from tb_entidade where sigla = 'COOPANEST')
and (situacao.glosado = 1 or situacao.digitado = 1 or situacao.espelhado = 1 or situacao.faturado = 1 /*or situacao.repassado = 1*/)
and (glosa.situacao not in (2,4,5))
and cooperadoRecebedor.id in (
	select id from tb_cooperado where nome in (
	'Andreia Santos Cardoso ME'
	,'Bruno de Oliveira Matos ME'
	,'Claudia Leal Ferreira Horiguchi ME'
	,'Elisa Duarte Candido ME'
	,'Fernanda Vilela Dias ME'
	,'Leandro Gomes Bittencourt ME'
	,'Lucas Rodrigues de Castro ME'
	,'Luiza Samarane Garretto ME'
	,'Marcella Carmem Silva Reginaldo ME'
	,'Matheus Leandro Lana Diniz ME'
	,'Nathalia Vasconcelos Ciotto ME'
	,'Paula de Siqueira Ramos ME')
)
order by procedimento.data_realizacao, cooperadoExecutante.nome