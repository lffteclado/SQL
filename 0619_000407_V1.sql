select entidade.sigla as 'Entidade',
       convenio.sigla as 'Convênio',
	   convenio.cnpj as 'CNPJ',
	   banco.descricao as 'Nome Banco',
	   banco.numero_banco as 'Código Banco',
	   dadosBancarios.conta as 'Numero Conta',
	   dadosBancarios.agencia as 'Numero Agencia',
	   'Sim' as 'Principal'
 from rl_entidade_convenio entidadeConvenio
inner join tb_convenio convenio on convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1 and entidadeConvenio.ativo = 1
inner join tb_entidade entidade on entidade.id = entidadeConvenio.fk_entidade and entidade.registro_ativo = 1
inner join rl_entidade_convenio_dados_bancarios bancoConvenio on bancoConvenio.fk_entidade_convenio = entidadeConvenio.id and bancoConvenio.registro_ativo = 1
inner join rl_entidade_dados_bancarios dadosBancarios on dadosBancarios.id = bancoConvenio.fk_entidade_daddos_bancarios and dadosBancarios.registro_ativo = 1
inner join tb_banco banco on banco.id = dadosBancarios.fk_banco and banco.registro_ativo = 1
 where entidadeConvenio.fk_entidade = 25 and entidadeConvenio.registro_ativo = 1 order by convenio.sigla