select fk_cooperado_do_evento, * from tb_controle_esocial_processamento
 where fk_cooperado_do_evento = 11861 and codigo_resposta_servico = '1.1.201902.0000000000354234759'

--select * from tb_cooperado where nome like '%Adriana Magalhães Borel%' -- 11861

select codigo_resposta_servico, numero_recibo_consulta, codigo_resposta, codigo_resposta_consulta, * from tb_controle_esocial_processamento
 where codigo_resposta_servico = '1.1.201902.0000000000354234874'

 select codigo_resposta_servico, numero_recibo_consulta, * from tb_controle_esocial_processamento
 where numero_recibo_consulta is not null

 select codigo_resposta, codigo_resposta_consulta * from tb_controle_esocial_processamento where codigo_resposta in (8)
 where codigo_resposta_servico = '1.1.201902.0000000000354234759'

 select nome, cpf_cnpj, * from tb_cooperado where id = 11861

select top 10 situacao_cooperado, * from rl_entidade_cooperado

 select situacao, nome, cpf_cnpj, numero_conselho, * from tb_cooperado where nome in ('Alexandre Eustaquio Ribeiro de Almeida',
																			 'Ana Paula Paviotti', 'Antonio Carlos Vieira',
																			 'Bruna Pozzi Cesar',
	
	
																			 'Celina Nogueira de Lima')

 select nome, cpf_cnpj, numero_conselho, * from tb_cooperado where id in (18,42,337,437)

 select fk_cooperado_do_evento, * from tb_controle_esocial_processamento where codigo_resposta_servico = '1.1.201902.0000000000308456249' and id = 42686

 select codigo_resposta_consulta, * from tb_controle_esocial_processamento where tipo_evento_esocial = 4 and codigo_resposta_servico in ('1.1.201807.0000000000023300715',
																												'1.1.201807.0000000000023300748',
																												'1.1.201807.0000000000023300776')

/*
update tb_controle_esocial_processamento
 set codigo_resposta_consulta = 3, sql_update = ISNULL(sql_update,'')+'#0419-000061'
 where codigo_resposta_servico = '1.1.201807.0000000000023300715'
