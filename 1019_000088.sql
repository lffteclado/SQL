select top 10 * from tb_importacao_base order by id desc --where id = 79349

select top 10 * from tb_linha_importacao_base order by id desc

select top 100 * from tb_despesa where discriminator = 'EntidadeConvenioEspecialidade' and fk_entidade_convenio = 3663 order by id desc

select * from tb_item_despesa where tipo_item_despesa <> 0 order by id desc

select top 10 * from tb_item_despesa where tipo_item_despesa = 0 and codigo = 10101017 and registro_ativo = 1 order by id desc

select top 100 * from tb_item_despesa where tipo_item_despesa = 0 and registro_ativo = 1 order by id desc

select * from tb_entidade where sigla like '%BHCOOP%'
select * from tb_convenio where sigla like '%ABERTTASAUDE%'

select * from rl_entidade_convenio where fk_entidade = 17 and fk_convenio =  2

select * from tb_despesa
 where discriminator = 'EntidadeConvenioEspecialidade' and registro_ativo = 1
 and data_inicio_vigencia = '2020-04-20'
 and fk_especialidade = 109740
 and fk_item_despesa = 462396
 and fk_entidade_convenio = 3663
 and fk_entidade_hospital = 433
 and fk_complemento is null
 and data_final_vigencia is null


 select data_final_vigencia, * from tb_despesa
 where discriminator = 'EntidadeConvenioEspecialidade'
 and fk_especialidade = 109740
 and data_final_vigencia is null or data_final_vigencia > getdate(),


  select * from tb_despesa
 where fk_especialidade = 231681
 and fk_item_despesa = 538589
 and fk_entidade_convenio = 2611
 and discriminator = 'EntidadeConvenioEspecialidade'
 and data_final_vigencia is null
 and registro_ativo = 1