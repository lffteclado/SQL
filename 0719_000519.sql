select * from tb_configuracao_digitacao where fk_digitacao in (1132,1133,1167) and campo_digitacao = 0

select * from tb_configuracao_digitacao where sql_update = '0719-000519' order by id desc

select * from tb_configuracao_digitacao where fk_digitacao = 2600

select * from tb_configuracao_digitacao where fk_digitacao in (

	select * from tb_digitacao where fk_entidade_convenio = 1831

) and obrigatorio = 1 and ativo = 0



select * from tb_digitacao where id = 1127

select * from tb_usuario where id = 10280

select fk_entidade, fk_convenio, * from rl_entidade_convenio where fk_entidade = 12 and fk_convenio = 1140 --1864

select * from tb_digitacao where fk_entidade_convenio = 2266

select * from rl_entidade_convenio where id = 2266

select sigla, * from tb_entidade where sigla like '%FELICOOP%' --12

select sigla, * from tb_entidade where sigla like '%unicooper%' --43

select * from tb_convenio where sigla like '%AGROS%' --1140

select count(fk_entidade_convenio) as quantidade,
       fk_entidade_convenio from tb_digitacao where fk_entidade_convenio in (

	select id from rl_entidade_convenio where fk_entidade = 12 and registro_ativo = 1 and ativo = 1

)group by fk_entidade_convenio

select * from tb_entidade where id = 13
select * from tb_convenio where id = 41


select entidadeConvenio.id as 'Entidade Convenio',
       entidade.sigla as 'Entidade',
       convenio.sigla as 'Convênio',
	   count(digitacao.id) as QtdDigitacao
from tb_digitacao digitacao
inner join rl_entidade_convenio entidadeConvenio on (digitacao.fk_entidade_convenio = entidadeConvenio.id and entidadeConvenio.registro_ativo = 1 and digitacao.registro_ativo = 1 and entidadeConvenio.ativo = 1)
inner join tb_entidade entidade on (entidadeConvenio.fk_entidade = entidade.id and entidade.registro_ativo = 1)
inner join tb_convenio convenio on (entidadeConvenio.fk_convenio = convenio.id and convenio.registro_ativo = 1)
--where entidade.id = 12
group by entidadeConvenio.id, entidade.sigla, convenio.sigla
having count(digitacao.id) > 1

select * from tb_configuracao_digitacao where fk_digitacao = 1132

select * from tb_digitacao where id = 1132


select * from tb_digitacao where id = 1333

select * from tb_configuracao_digitacao where fk_digitacao = 1333
