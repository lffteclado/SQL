 select
    --repasseCredito.id,
    --repasseCredito.data_pagamento,
    --repasseCredito.data_ultima_alteracao,
    --cooperado.id as idCooperado,
    --repasseCredito.fk_entidade,
    --repasseCredito.fk_repasse,
    --repasseCredito.foi_gerado_CNAB,
    --repasseCredito.valor_credito,
    cooperado.nome,
    dadosBancariosCooperado.id idDadosBancarios,
    --dadosBancariosCooperado.fk_entidade_cooperado as idEntidadeCooperado1,
	entidadeCooperado.id as idEntidadeCooperado,
    dadosBancariosCooperado.id as idBanco,
    dadosBancariosCooperado.numero_banco as numero_banco,
    dadosBancariosCooperado.descricao_banco,
    dadosBancariosCooperado.agencia,
    dadosBancariosCooperado.conta,
    dadosBancariosCooperado.data_vinculo,
    dadosBancariosCooperado.codigo_lancamento,
    dadosBancariosCooperado.numero_convenio,
    dadosBancariosCooperado.situacao,
    dadosBancariosCooperado.tipo,

	repasseCredito.agencia as repasseCreditoAgencia,
	repasseCredito.conta as repasseCreditoConta,
	repasseCredito.tipo as repasseCreditoTipo,
	repasseCredito.valor_desconto_CNAB as repasseCreditoValor_desconto_CNAB,
	bancoRepasseCredito.id as repasseCreditoIdBanco,
	bancoRepasseCredito.numero_banco as repasseCreditoNumero_banco,
	bancoRepasseCredito.descricao as repasseCreditoBancoDescricao,

    --cooperado.discriminator,
    repasse.numero_repasse
    --enderecoEntidade.tipologradouro,
    --enderecoEntidade.logradouro,
    --enderecoEntidade.numero,
    --enderecoEntidade.complemento,
    --enderecoEntidade.cidade,
    --enderecoEntidade.cep,
    --enderecoEntidade.estado,
    --enderecoCooperado.tipologradouro as tipoLogradouroCooperado,
    --enderecoCooperado.logradouro as logradouroCooperado,
    --enderecoCooperado.numero as numeroCooperado,
    --enderecoCooperado.complemento as complementoCooperado,
    --enderecoCooperado.cidade as cidadeCooperado,
    --enderecoCooperado.cep as cepCooperado,
    --enderecoCooperado.estado  as estadoCooperado,
    --cooperado.cpf_cnpj,
    --enderecoCooperado.bairro as bairroCooperado,
    --dadosBancariosCooperado.valor_desconto_cnab
    from rl_repasse_credito repasseCredito
	inner join tb_entidade entidade on(entidade.id=repasseCredito.fk_entidade and entidade.registro_ativo=1 and repasseCredito.registro_ativo=1)
    inner join tb_cooperado cooperado on(repasseCredito.fk_cooperado=cooperado.id and cooperado.registro_ativo=1)
    inner join rl_entidade_cooperado entidadeCooperado on(cooperado.id=entidadeCooperado.fk_cooperado and entidade.id=entidadeCooperado.fk_entidade and entidadeCooperado.registro_ativo=1)
    inner join tb_repasse repasse on(repasse.id=repasseCredito.fk_repasse and repasse.registro_ativo=1)
	left join tb_banco bancoRepasseCredito on (bancoRepasseCredito.id = repasseCredito.fk_banco and bancoRepasseCredito.registro_ativo = 1)
    cross apply (
				select top 1
					entidadeCooperadoDadosBancarios.id,
					entidadeCooperadoDadosBancarios.fk_entidade_cooperado,
					bancoCooperado.id as idBanco,
					bancoCooperado.numero_banco as numero_banco,
					bancoCooperado.descricao as descricao_banco,
					entidadeCooperadoDadosBancarios.agencia,
					entidadeCooperadoDadosBancarios.conta,
					entidadeCooperadoDadosBancarios.data_vinculo,
					entidadeCooperadoDadosBancarios.codigo_lancamento,
					entidadeCooperadoDadosBancarios.numero_convenio,
					entidadeCooperadoDadosBancarios.situacao,
					entidadeCooperadoDadosBancarios.tipo,
					entidadeCooperadoDadosBancarios.valor_desconto_cnab
				from rl_entidade_cooperado_dados_bancarios entidadeCooperadoDadosBancarios
				inner join tb_banco bancoCooperado on(bancoCooperado.id=entidadeCooperadoDadosBancarios.fk_banco
													 and bancoCooperado.registro_ativo=1 and entidadeCooperadoDadosBancarios.registro_ativo=1)
				where entidadeCooperadoDadosBancarios.situacao=1
				and  entidadeCooperadoDadosBancarios.fk_entidade_cooperado=entidadeCooperado.id
				--and  entidadeCooperadoDadosBancarios.fk_banco IN  (42566)
				and (entidadeCooperadoDadosBancarios.nao_enviar_cooperado_cnab is null
				or entidadeCooperadoDadosBancarios.nao_enviar_cooperado_cnab = 0)) as dadosBancariosCooperado
    outer apply (
				select top 1
					tipoLogradouro.descricao as tipoLogradouro,
					endereco.logradouro as logradouro,
					endereco.numero,
					endereco.complemento,
					cidade.descricao as cidade,
					endereco.cep,
					uf.sigla as estado
				from tb_endereco endereco
				inner join tb_tipo_logradouro tipoLogradouro on(endereco.fk_tipo_logradouro=tipoLogradouro.id
																 and endereco.registro_ativo=1 and tipoLogradouro.registro_ativo=1)
				inner join tb_cidade cidade on(cidade.id=endereco.fk_cidade and cidade.registro_ativo=1)
				inner join tb_uf_fencom uf on(cidade.fk_uf_fencom=uf.id and uf.registro_ativo=1)
				where endereco.fk_entidade=entidade.id and endereco.discriminator='Entidade' ) as enderecoEntidade 
	outer apply (
				select top 1
					tipoLogradouroCooperado.descricao as tipoLogradouro,
					enderecoCooperado.logradouro as logradouro,
					enderecoCooperado.numero,
					enderecoCooperado.complemento,
					cidadeCooperado.descricao as cidade,
					enderecoCooperado.cep,
					ufCooperado.sigla as estado,
					enderecoCooperado.bairro as bairro
				from tb_endereco enderecoCooperado
				inner join tb_tipo_logradouro tipoLogradouroCooperado on(enderecoCooperado.fk_tipo_logradouro=tipoLogradouroCooperado.id
																		 and enderecoCooperado.registro_ativo=1 and tipoLogradouroCooperado.registro_ativo=1)
				inner join tb_cidade cidadeCooperado on(cidadeCooperado.id=enderecoCooperado.fk_cidade and cidadeCooperado.registro_ativo=1)
				inner join tb_uf_fencom ufCooperado on(cidadeCooperado.fk_uf_fencom=ufCooperado.id and ufCooperado.registro_ativo=1)
				where enderecoCooperado.fk_cooperado=cooperado.id and enderecoCooperado.discriminator='Cooperado' ) as enderecoCooperado 
	where entidade.id = 10 and repasseCredito.fk_repasse in (17677, 17721)
	
	/*
	order by case when dadosBancariosCooperado.numero_banco  = 666
    then 0 else 1 end, dadosBancariosCooperado.numero_banco asc*/