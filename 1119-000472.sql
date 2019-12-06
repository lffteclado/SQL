select top 10 * from tb_participantes_composicao_servico_especial order by id desc

select top 10 * from tb_composicao_servico_especial
 where (data_final >= GETDATE() or data_final is null)
        and data_inicial <= GETDATE()

select * from tb_entidade where sigla = 'BELCOOP' --25

--SELECT * FROM tb_composicao_servico_especial where id =1710

--select * from tb_cooperado where id = 31169

select getdate()

select cooperado.nome from tb_composicao_servico_especial comp
inner join tb_participantes_composicao_servico_especial part on (part.fk_composicao_servico_especial = comp.id and comp.registro_ativo = 1 and part.registro_ativo = 1)
inner join tb_cooperado cooperado on (cooperado.id = part.fk_cooperado)
 where comp.fk_servico_especial = 31169
and comp.data_inicial <= '2019-12-03'
and (comp.data_final is null or comp.data_final >= '2019-12-03')




select top 10 * from tb_cooperado