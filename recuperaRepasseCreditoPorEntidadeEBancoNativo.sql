 SELECT
     repasseCredito.id,--0
     repasseCredito.data_pagamento,--1
     repasseCredito.data_ultima_alteracao,--2
     cooperado.id AS idCooperado,--3 ok
     repasseCredito.fk_entidade,--4
     repasseCredito.fk_repasse,--5ok
     repasseCredito.foi_gerado_CNAB,--6
     repasseCredito.valor_credito,--7
     cooperado.nome,--8
     repasseCredito.fk_banco AS idBanco,--9
     banco.numero_banco AS numero_banco,--10
     banco.descricao,--11
     repasseCredito.agencia,--12
     repasseCredito.conta,--13
     repasseCredito.codigo_lancamento,--14
     repasseCredito.numero_convenio,--15
     repasseCredito.tipo,--16
     cooperado.discriminator,--17
     repasse.numero_repasse,--18
     enderecoEntidade.tipologradouro,--19
     enderecoEntidade.logradouro,--20
     enderecoEntidade.numero,--21
     enderecoEntidade.complemento,--22
     enderecoEntidade.cidade,--23
     enderecoEntidade.cep,--24
     enderecoEntidade.estado,--25
     enderecoCooperado.tipologradouro AS tipoLogradouroCooperado,--26
     enderecoCooperado.logradouro AS logradouroCooperado,--27
     enderecoCooperado.numero AS numeroCooperado,--28
     enderecoCooperado.complemento AS complementoCooperado,--29
     enderecoCooperado.cidade AS cidadeCooperado,--30
     enderecoCooperado.cep AS cepCooperado,--31
     enderecoCooperado.estado AS estadoCooperado,--32
     cooperado.cpf_cnpj,--33
     enderecoCooperado.bairro AS bairroCooperado,--34
     repasseCredito.valor_desconto_cnab--35
     FROM rl_repasse_credito repasseCredito
     INNER JOIN tb_entidade entidade ON (entidade.id=repasseCredito.fk_entidade AND entidade.registro_ativo=1 AND repasseCredito.registro_ativo=1)
     INNER JOIN tb_cooperado cooperado ON (repasseCredito.fk_cooperado=cooperado.id AND cooperado.registro_ativo=1)
     INNER JOIN rl_entidade_cooperado entidadeCooperado ON (cooperado.id=entidadeCooperado.fk_cooperado AND entidade.id=entidadeCooperado.fk_entidade AND entidadeCooperado.registro_ativo=1)
     INNER JOIN tb_repasse repasse ON (repasse.id=repasseCredito.fk_repasse AND repasse.registro_ativo=1)
	 INNER JOIN tb_banco banco ON (banco.id = repasseCredito.fk_banco and banco.registro_ativo = 1)
     OUTER APPLY (
		SELECT TOP 1
		tipoLogradouro.descricao AS tipoLogradouro,
		endereco.logradouro AS logradouro,
		endereco.numero,
		endereco.complemento,
		cidade.descricao AS cidade,
		endereco.cep,
		uf.sigla AS estado
		 FROM tb_endereco endereco
		INNER JOIN tb_tipo_logradouro tipoLogradouro ON(endereco.fk_tipo_logradouro=tipoLogradouro.id and endereco.registro_ativo=1 and tipoLogradouro.registro_ativo=1)
		INNER JOIN tb_cidade cidade ON(cidade.id=endereco.fk_cidade and cidade.registro_ativo=1)
		INNER JOIN tb_uf_fencom uf ON(cidade.fk_uf_fencom=uf.id and uf.registro_ativo=1)
		where endereco.fk_entidade=entidade.id and endereco.discriminator='Entidade' ) as enderecoEntidade 
     OUTER APPLY (
		SELECT TOP 1
		tipoLogradouroCooperado.descricao as tipoLogradouro,
		enderecoCooperado.logradouro as logradouro,
		enderecoCooperado.numero,
		enderecoCooperado.complemento,
		cidadeCooperado.descricao as cidade,
		enderecoCooperado.cep,
		ufCooperado.sigla as estado,
		enderecoCooperado.bairro as bairro
		 from tb_endereco enderecoCooperado
		inner join tb_tipo_logradouro tipoLogradouroCooperado on(enderecoCooperado.fk_tipo_logradouro=tipoLogradouroCooperado.id and enderecoCooperado.registro_ativo=1 and tipoLogradouroCooperado.registro_ativo=1)
		inner join tb_cidade cidadeCooperado on(cidadeCooperado.id=enderecoCooperado.fk_cidade and cidadeCooperado.registro_ativo=1)
		inner join tb_uf_fencom ufCooperado on(cidadeCooperado.fk_uf_fencom=ufCooperado.id and ufCooperado.registro_ativo=1)
		where enderecoCooperado.fk_cooperado=cooperado.id and enderecoCooperado.discriminator='Cooperado' ) as enderecoCooperado 
     where entidade.id = 23
	  and repasseCredito.fk_repasse = 17730
	   and banco.id = 33
	   and repasseCredito.agencia = 4027
	   and (repasseCredito.nao_enviar_cooperado_cnab is null
	    or repasseCredito.nao_enviar_cooperado_cnab = 0)
     order by repasseCredito.id asc


	 /*

	     cross apply (select top 1
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
     inner join tb_banco bancoCooperado on(bancoCooperado.id=entidadeCooperadoDadosBancarios.fk_banco and bancoCooperado.registro_ativo=1 and entidadeCooperadoDadosBancarios.registro_ativo=1)
     
	 where entidadeCooperadoDadosBancarios.situacao=1
     and  entidadeCooperadoDadosBancarios.fk_entidade_cooperado=entidadeCooperado.id

     and  entidadeCooperadoDadosBancarios.fk_banco= 0   

       and entidadeCooperadoDadosBancarios.agencia = 666

     and (entidadeCooperadoDadosBancarios.nao_enviar_cooperado_cnab is null
     or entidadeCooperadoDadosBancarios.nao_enviar_cooperado_cnab = 0)

     ) as dadosBancariosCooperado
	 */