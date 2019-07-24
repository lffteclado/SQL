--select situacao, * from tb_cooperado where nome like '%Teste Erika%'.
--select * from tb_entidade where sigla like '%COMEDI%'
select servicoEspecial.nome from tb_composicao_servico_especial composicao
inner join tb_cooperado servicoEspecial on servicoEspecial.id = composicao.fk_servico_especial
where servicoEspecial.discriminator = 'se' and servicoEspecial.tipo_servico = 1
 and servicoEspecial.fk_entidade = 22
 and ((data_inicial <= '2019-06-11' and data_final >= '2019-06-11') or (data_inicial <= '2019-06-11' and data_final is null ) )
 order by servicoEspecial.nome

