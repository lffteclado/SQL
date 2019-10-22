select * from sysobjects where name like '%procedimento%'

select  * from tb_entidade where sigla like '%SANTACOOPMACEIO%'--46

select * from tb_convenio where sigla like '%GOLDEN S A%'--853

select * from rl_entidade_convenio where fk_entidade = 46 and fk_convenio = 853 and registro_ativo = 1

select * from tb_despesa where discriminator = 'EntidadeConvenioEspecialidade' and fk_entidade_convenio = 2086 and registro_ativo = 1 order by id desc

select * from tb_despesa where id =  966065 -- 30206014

select * from tb_despesa where fk_item_despesa = 11694 and fk_entidade_convenio = 2086

select top 10 * from  tb_item_despesa where codigo = '30202132' --item despesa
select * from tb_tabela_tiss where descricao like '%Cirurgiao Toracico%' and discriminator = 'especialidade' --Especialidade
select * from tb_tabela_tiss where descricao like '%Pneumologista%' and discriminator = 'especialidade'
select * from tb_tabela_tiss where descricao like '%cirurgião pediátrico%' and discriminator = 'especialidade'
select * from tb_tabela_tiss where descricao like '%Médico ortopedista%' and discriminator = 'especialidade'

select * from [0919_000642]


select despesa.id
	   --,despesa.data_inicio_vigencia
	   --,despesa.data_final_vigencia
       --,planilha.codigo as 'Codigo Planilha',
       --,itemDespesa.codigo as 'Codigo',
       --,despesa.fk_item_despesa,
	   --,planilha.item_despesa_descricao as 'Item Planilha',
	   --,itemDespesa.descricao,
	   --,despesa.fk_especialidade,
	   --,tabelaTiss.descricao,
	   --,planilha.fk_especialidade as 'Especialidade Planilha',
	   --,planilha.especialidade_descricao as 'Descrição Planilha'
from tb_despesa despesa
cross apply(
 select top 1 codigo,descricao from tb_item_despesa item
  where despesa.fk_item_despesa = item.id
        and item.registro_ativo = 1 order by id desc
) as itemDespesa
inner join [0919_000642] planilha on (planilha.codigo = itemDespesa.codigo)
inner join  tb_tabela_tiss tabelaTiss on (despesa.fk_especialidade = tabelaTiss.id and tabelaTiss.registro_ativo = 1 and despesa.fk_especialidade = planilha.fk_especialidade)
where despesa.discriminator = 'EntidadeConvenioEspecialidade' and fk_entidade_convenio = 2086