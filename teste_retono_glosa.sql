--select top 100 * from tb_glosa where situacao in (3,7) and registro_ativo = 1 order by id desc
--select * from tb_carta_glosa where id = 256741
--select * from tb_glosa where fk_carta_glosa = 256741

/*Buscar Procedimentos Glosados*/
--Informe o numero da carta de glosa
declare @fk_carta_glosa bigint = 256741
select atendimento.numero_atendimento_automatico,
       atendimento.numero_guia,
	   atendimento.guia_principal,
	   atendimento.senha,
       procedimento.data_realizacao,
	   procedimento.id as id_procedimento,
	   item.codigo,
	   situacao.valorGlosado,
	   espelho.numero_espelho,
	   entidade.sigla as 'Entidade',
	   convenio.sigla as 'Convenio'
	   --into #tempProcedimentoProcessado
from tb_atendimento atendimento
inner join tb_procedimento procedimento on (procedimento.fk_atendimento = atendimento.id and atendimento.registro_ativo = 1)
inner join tb_glosa glosa on (glosa.fk_procedimento = procedimento.id and glosa.fk_carta_glosa = @fk_carta_glosa and procedimento.registro_ativo = 1)
inner join rl_situacao_procedimento situacao on (situacao.fk_procedimento = procedimento.id)
inner join tb_item_despesa item on (procedimento.fk_item_despesa = item.id and item.registro_ativo = 1)
inner join tb_espelho espelho on (espelho.id = atendimento.fk_espelho and espelho.registro_ativo = 1)
inner join tb_entidade entidade on (entidade.id = atendimento.fk_entidade)
inner join rl_entidade_convenio entidadeConvenio on (entidadeConvenio.fk_entidade = entidade.id and atendimento.fk_convenio = entidadeConvenio.id)
inner join tb_convenio convenio on (convenio.id = entidadeConvenio.fk_convenio)
where situacao.valorGlosado <> 0.00 and glosa.registro_ativo = 1
