select * from tb_0719_000402

select desconsiderar_urgencia, * from tb_despesa where discriminator = 'EntidadeConvenioEspecialidade' and registro_ativo = 1 and fk_entidade_convenio = 4336

select * from tb_tabela_tiss where discriminator = 'especialidade' and descricao like '%Gastroenterologia Pediátrica%'

select * from tb_despesa where registro_ativo = 1 and fk_entidade_convenio = 4336 and discriminator = 'EntidadeConvenioEspecialidade' 

--update tb_tabela_tiss set fk_tipo_tabela_tiss=6,fk_relacao_tuss=6 where discriminator = 'especialidade' and fk_tipo_tabela_tiss is null 

select * from tb_tabela_tiss where id = 109739

/* Complemento */
Empresa 4452 (1722) 4485 (1744)
Individual 4452 (1727) 4485 (1749)
Superior 4366 (1783)
Intermedica 4294 (1759)
Notre Dame 4294 (1764)

--update tb_0719_000402 set Complemento = 1744 where Complemento = 'Empresa' and [Convênio ] = '4485'
--update tb_0719_000402 set fk_item_despesa = 11416 where [Codigo procedimento] = 10101012 and [Descrição procedimento] = 'Em consultório (no horário normal ou preestabelecido)'
--update tb_0719_000402 set fk_item_despesa = 9683 where [Codigo procedimento] = 10101039 and [Descrição procedimento] = 'Em pronto socorro'

select * from tb_0719_000402 where Complemento is not null

select * from tb_0719_000402 where [CH/MOEDA] = 'Moeda'

--update tb_0719_000402 set [CH/MOEDA] = 'M' where [CH/MOEDA] = 'Moeda'

--update teste set [Convênio ] = fkConvenio.id
-- from tb_0719_000402 teste
--cross apply (
--select id from rl_entidade_convenio where fk_convenio in (
--select id from tb_convenio where sigla in (
--select [Convênio ] from tb_0719_000402 teste2 where teste.[Convênio ] = teste2.[Convênio ])) and fk_entidade = 25
--) as fkConvenio

--update teste set Complemento = fkComplemento.id
--  from tb_0719_000402 teste
--cross apply (
--select id from rl_entidadeconvenio_complemento where descricao in (
--		select Complemento from tb_0719_000402 teste2 where teste.Complemento = teste2.Complemento 
--) and fk_entidade_convenio in ( select [Convênio ] from tb_0719_000402)
--) as fkComplemento

--update tb_0719_000402 set Hospital = 458 where Hospital = 'HBH'



--update teste set [Especialidade (ANS)] = especialidade.id
-- from tb_0719_000402 teste
--CROSS APPLY(
--	select id from tb_tabela_tiss where descricao in (
--		select [Especialidade (ANS)] from tb_0719_000402 teste2 where teste.[Especialidade (ANS)] = teste2.[Especialidade (ANS)]
--		)
--) as especialidade

--select * from tb_tabela_tiss where descricao in (
--		select [Especialidade (ANS)] from tb_0719_000402
--		)

select * from tb_0719_000402