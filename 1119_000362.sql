select top 10 * from rl_entidadecooperado_especialidade

select * from tb_tabela_tiss where descricao like '%Médico anestesiologista%'

select * from tb_tabela_tiss where descricao like '%anestesista%'

select * from tb_de_para_especialidade_codigo_atuacao

select * from tb_item_despesa where id in (

select fk_item_despesa from tb_procedimento where fk_atendimento in (
select id from tb_atendimento where fk_espelho in (

select id from tb_espelho where numero_espelho = 85516 and fk_entidade in (select id from tb_entidade where sigla like '%SANCOOP%')

)
))

select * from tb_procedimento where fk_atendimento in (

	select id from tb_atendimento where numero_atendimento_automatico in (5564683) and fk_entidade in (select id from tb_entidade where sigla like '%SANCOOP%')

) and registro_ativo = 1


select atendimento.numero_atendimento_automatico,
       procedimento.id,
	   procedimento.valor_honorario,
	   item.descricao,
	   item.tipo_item_despesa
from tb_procedimento procedimento
inner join tb_atendimento atendimento on (atendimento.id = procedimento.fk_atendimento and procedimento.registro_ativo = 1 and atendimento.registro_ativo = 1)
inner join tb_espelho espelho on(espelho.id = atendimento.fk_espelho and espelho.registro_ativo = 1)
inner join tb_item_despesa item on(item.id = procedimento.fk_item_despesa and item.registro_ativo = 1)
where item.tipo_item_despesa in (1,2,4) and espelho.numero_espelho = 85516 and espelho.fk_entidade in (select id from tb_entidade where sigla like '%SANCOOP%')
order by atendimento.numero_atendimento_automatico