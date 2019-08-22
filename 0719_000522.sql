select endereco.id,
       endereco.discriminator,
       entidade.sigla,
       cooperado.nome,
       endereco.registro_ativo,
       CONVERT(VARCHAR(23),endereco.data_ultima_alteracao, 113),
	   usuario.nome 
 from tb_endereco endereco
 inner join tb_usuario usuario on (usuario.id = endereco.fk_usuario_ultima_alteracao)
 inner join tb_cooperado cooperado on (endereco.fk_cooperado = cooperado.id)
 inner join tb_entidade entidade on (endereco.fk_entidade = entidade.id)
 where endereco.discriminator = 'Cooperado' and endereco.fk_entidade = 6 and fk_cooperado in (26254, 29597, 30473)




--select * from tb_usuario where id = 10128

--select * from tb_endereco_AUD where id = 93147

--select * from tb_cooperado where nome like '%Larissa Oliveira de Aquino%' and numero_conselho = '58803' -- 26254

--select * from tb_cooperado where nome like '%Mayne Cardoso Cani%' and numero_conselho = '59385' --29597

--select * from tb_cooperado where nome like '%Patricia Primo de Alvarenga%' and numero_conselho = '61100' --30473

--select * from tb_entidade where sigla like '%GINECOOP%' -- 6

--select * from rl_entidade_cooperado where fk_entidade = 6 and fk_cooperado = 26254 -- 29177