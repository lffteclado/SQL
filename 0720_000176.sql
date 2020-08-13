select sigla, * from tb_convenio where sigla like '%S.BRADESCO%' -- 503

select sigla, * from tb_entidade where sigla = 'SANTACOOPMACEIO'--46

select * from rl_entidade_convenio where fk_entidade = 46 and fk_convenio in (
select id from tb_convenio where sigla = 'BRADESCOOPERA'
) 


select fk_item_despesa, * from tb_despesa
 where discriminator = 'EntidadeConvenio' and fk_entidade_convenio = 2173 and registro_ativo = 1

 select * from tb_despesa where sql_update like '%#0720-000176%' and registro_ativo = 1

 select * from tb_despesa where sql_update = '#0720-000176' and registro_ativo = 1

 update tb_despesa set registro_ativo = 0 where sql_update = '#0720-000176' and registro_ativo = 1

 select * from tb_item_despesa where id = 11851

 select itemDespesa.id,
        itemDespesa.codigo,
		tabela.codigo_procedimento,
		tabela.descricao as 'descricao tabela',
		itemDespesa.descricao		
		from tb_procedimentos_bradescoopera tabela
 cross apply(select distinct top 1 despesa.id,
                    despesa.codigo,
					despesa.descricao
		     from tb_item_despesa despesa
			 where despesa.codigo = tabela.codigo_procedimento
			 and despesa.descricao = tabela.descricao
			 and despesa.registro_ativo = 1
			 order by despesa.id desc ) as itemDespesa




select * from tb_item_despesa where descricao in (

select descricao from tb_procedimentos_bradescoopera tabela) and registro_ativo = 1
