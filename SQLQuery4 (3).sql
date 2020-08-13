entidadeCooperadoDadosBancarios.agencia--
entidadeCooperadoDadosBancarios.conta--
entidadeCooperadoDadosBancarios.data_vinculo
entidadeCooperadoDadosBancarios.codigo_lancamento
entidadeCooperadoDadosBancarios.numero_convenio
entidadeCooperadoDadosBancarios.situacao
entidadeCooperadoDadosBancarios.tipo--
entidadeCooperadoDadosBancarios.valor_desconto_cnab--


bancoCooperado.id as idBanco
bancoCooperado.numero_banco as numero_banco
bancoCooperado.descricao as descricao_banco



agencia
conta
tipo
valor_desconto_CNAB

Falta

entidadeCooperadoDadosBancarios.data_vinculo
entidadeCooperadoDadosBancarios.codigo_lancamento
entidadeCooperadoDadosBancarios.numero_convenio
entidadeCooperadoDadosBancarios.situacao


fk_banco

 coopmed-rs 371

 select * from tb_entidade where sigla = 'BHCOOP' --17

select * from tb_repasse where numero_repasse = 1881 and fk_entidade = 23

	select numero_repasse, * from tb_repasse where numero_repasse in (3970,3976) and fk_entidade = 10

	select * from tb_cooperado where nome = 'Felipe Millen Azevedo'

	select fk_cooperado, * from rl_repasse_credito where fk_repasse in (17732) and fk_cooperado = 18482

	select * from rl_entidade_cooperado where fk_cooperado = 18482 and fk_entidade = 23

	select * from rl_entidade_cooperado_dados_bancarios where fk_entidade_cooperado = 39866