select * from [0919_000642] planilha with(nolock)
inner join tb_tabela_tiss especialidade with(nolock) on (planilha.fk_especialidade = especialidade.id)
cross apply(
 select top 1 id,codigo,descricao from tb_item_despesa item
  where planilha.codigo = item.codigo
        and item.registro_ativo = 1 order by id desc
) as itemDespesa

select * from tb_despesa where sql_update = '0919-000642' and data_inicio_vigencia = '2018-10-01' and registro_ativo = 1

