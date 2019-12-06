select convenio.sigla as 'Convênio'--0
       ,linha.campo_comparacao as 'Senha/Guia'--1
	   ,atendimento.numero_atendimento_automatico as 'Numero Atendimento'--2
	   ,linha.codigo_item_despesa as 'Procedimento'--3
	   ,procedimento.data_realizacao as 'Data Realização'--4
	   ,linha.valor_recursado as 'Valor Recursado'--5
	   ,linha.valor_pago_recurso as 'Valor Pago'--6
	   ,carta.numero_carta as 'Numero da Carta de Glosa'--7
	   ,espelho.numero_espelho as 'Numero do Espelho'--8
	   ,(linha.valor_recursado - linha.valor_pago_recurso) as 'Diferença'--9
	   ,linha.status_processamento
from tb_arquivo_retorno_glosa linha
inner join tb_retorno_glosa arquivo on(arquivo.id = linha.fk_retorno_glosa and linha.registro_ativo = 1 and arquivo.registro_ativo = 1)
inner join tb_procedimento procedimento on(procedimento.id = linha.fk_procedimento and procedimento.registro_ativo = 1)
inner join tb_atendimento atendimento on(atendimento.id = procedimento.fk_atendimento and atendimento.registro_ativo = 1)
inner join tb_glosa glosa on(glosa.fk_procedimento = procedimento.id)
inner join tb_carta_glosa carta on(carta.id = glosa.fk_carta_glosa)
inner join tb_convenio convenio on(convenio.id = arquivo.fk_convenio and convenio.registro_ativo = 1)
inner join tb_espelho espelho on(espelho.id = atendimento.fk_espelho and espelho.registro_ativo = 1)
where linha.status_processamento = 0 and arquivo.processado = 1 and arquivo.id = 2