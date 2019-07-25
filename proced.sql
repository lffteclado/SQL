select desconsiderar_urgencia, * from tb_despesa where discriminator = 'EntidadeConvenioEspecialidade' and registro_ativo = 1 and fk_entidade_convenio = 4336

select * from tb_convenio where id = (
select fk_convenio from rl_entidade_convenio where id = 4336)
 -- EntidadeConvenioDespesaEspecialidade

select convenio.sigla as 'Convênio',
	   entidadeConvenio.id,
       complemento.descricao as 'Complemento',
	   complemento.id,
	   hospital.sigla as 'Hospital',
	   entidadeHospital.id,
	   especialidade.descricao,
	   especialidade.id,
	   despesa.codigo_fk_item_despesa,
	   despesa.descricao_fk_item_despesa,
	   despesa.ch_moeda,
	   despesa.valor_honorario,
	   despesa.valor_custo_operacional,
	   complemento.valor_acrescimo_tabela,
	   despesa.data_inicio_vigencia,
	   despesa.data_final_vigencia,
	   despesa.desconsiderar_urgencia,
	   despesa.desconsiderar_enfermaria,
	   despesa.desconsiderar_apartamento,
	   despesa.desconsiderar_externo,
	   despesa.desconsiderar_uti
	    from tb_despesa despesa
inner join rl_entidade_convenio entidadeConvenio on despesa.fk_entidade_convenio = entidadeConvenio.id and entidadeConvenio.registro_ativo = 1
inner join tb_convenio convenio on convenio.id = entidadeConvenio.fk_convenio and convenio.registro_ativo = 1
inner join rl_entidadeconvenio_complemento complemento on complemento.fk_entidade_convenio = entidadeConvenio.id and  complemento.registro_ativo = 1
inner join rl_entidade_hospital entidadeHospital on entidadeHospital.fk_entidade = entidadeConvenio.fk_entidade and entidadeHospital.registro_ativo = 1
inner join tb_hospital hospital on hospital.id = entidadeHospital.fk_hospital and hospital.registro_ativo = 1
inner join tb_tabela_tiss especialidade on especialidade.id = despesa.fk_especialidade and especialidade.discriminator = 'especialidade' and especialidade.registro_ativo = 1
 where despesa.discriminator = 'EntidadeConvenioEspecialidade'
  and despesa.registro_ativo = 1
  and entidadeConvenio.fk_entidade = 25

select entConv.id,
	   conv.sigla,
	   conv.cnpj
 from rl_entidade_convenio entConv
inner join tb_convenio conv on entConv.fk_convenio = conv.id
where entConv.fk_entidade = 25 AND conv.sigla = '%%'


select entHosp.id,
       hosp.sigla from rl_entidade_hospital entHosp
inner join tb_hospital hosp on entHosp.fk_hospital = hosp.id
where entHosp.fk_entidade = 25 

select distinct especialidade.descricao,
       especialidade.id
       from tb_despesa despesa
inner join tb_tabela_tiss especialidade on despesa.fk_especialidade = especialidade.id and especialidade.discriminator = 'especialidade' and especialidade.registro_ativo = 1
inner join rl_entidade_convenio entidadeConvenio on entidadeConvenio.id = despesa.fk_entidade_convenio and entidadeConvenio.registro_ativo = 1
where entidadeConvenio.fk_entidade = 25



select * from tb_hospital where sigla like '%HOSP BH%'

select * from tb_despesa where discriminator = 'EntidadeConvenioEspecialidade'

select sigla, * from tb_entidade where sigla like '%BELCOOP%' --25

select * from rl_entidade_convenio where id in (4231,4293)

select top 10 * from rl_entidadeconvenio_complemento

select * from tb_tabela_tiss where id = 109739

select * from tb_tabela_tiss where discriminator = 'especialidade' and descricao like '%mulheres%'

select tipo_item_despesa, * from tb_item_despesa where id = 8942
select top 10 * from tb_procedimento
select * from tb_tipo_item_despesa 


/* Complemento */
Empresa 4452 (1722) 4485 (1744)
Individual 4452 (1727) 4485 (1749)
Superior 4366 (1783)
Intermedica 4294 (1759)
Notre Dame 4294 (1764)

select * from rl_entidadeconvenio_complemento where fk_entidade_convenio = 4485

select * from tb_0719_000194 where Complemento is not null

--update tb_0719_000194 set Complemento = 1722 where Complemento = 'Empresa' and [Convênio ] = '4452'
--update tb_0719_000402 set fk_item_despesa = 11416 where [Codigo procedimento] = 10101012 and [Descrição procedimento] = 'Em consultório (no horário normal ou preestabelecido)'


--ALTER TABLE tb_0719_000402
--	ADD fk_item_despesa bigint
--GO

select sum(CONVERT(numeric(19,2),[Valor Honorário]) + 0) as Soma from tb_0719_000194
select sum([Valor Honorário]) as Soma from tb_0719_000194


select *from tb_tabela_tiss where fk_tipo_tabela_tiss=6 and pk_importacao='225124'
select *from tb_tabela_tiss where fk_tipo_tabela_tiss=6 and pk_importacao='225250'

select CodCboManad, * from CB_Especialidade where DesEsp = 'Médico de criança'


/*
update teste set [Convênio ] = fkConvenio.id
 from tb_0719_000194 teste
cross apply (
select id from rl_entidade_convenio where fk_convenio in (
select id from tb_convenio where sigla in (
select [Convênio ] from tb_0719_000194 teste2 where teste.[Convênio ] = teste2.[Convênio ])) and fk_entidade = 25
) as fkConvenio


update teste set Complemento = fkComplemento.id
  from tb_0719_000194 teste
cross apply (
select id from rl_entidadeconvenio_complemento where descricao in (
		select Complemento from tb_0719_000194 teste2 where teste.Complemento = teste2.Complemento 
) and fk_entidade_convenio in ( select [Convênio ] from tb_0719_000194)
) as fkComplemento

update teste set [Especialidade (ANS)] = especialidade.id
 from tb_0719_000194 teste
CROSS APPLY(
	select id from tb_tabela_tiss where fk_tipo_tabela_tiss = 6 and pk_importacao in (
		select CodCboManad from CB_Especialidade teste2 where DesEsp in (
			select [Especialidade (ANS)] from tb_0719_000194
		) and teste.[Especialidade (ANS)] = teste2.DesEsp
	)
) as especialidade

select web.DesEsp,
       sasc.descricao,
	   sasc.id
	   from tb_tabela_tiss sasc
inner join CB_Especialidade web on sasc.pk_importacao = web.CodCboManad
where sasc.fk_tipo_tabela_tiss = 6 and sasc.id in (
select [Especialidade (ANS)] from tb_0719_000194 where SUBSTRING([Especialidade (ANS)],0,3) = '10'
*/

select * from tb_convenio where id = 18906

select count(*) from tb_0719_000194 where [Convênio ] = 4409

select descricao, * from rl_entidadeconvenio_complemento where descricao in (
		select Complemento from tb_0719_000194
) and fk_entidade_convenio in ( select [Convênio ] from tb_0719_000194)

select id from rl_entidade_hospital where fk_hospital in (
select id,  from tb_hospital where sigla = 'HOSP BH'
) and fk_entidade = 25

--update tb_0719_000194 set Hospital = 458 where Hospital = 'HBH'

select * from tb_0719_000194 where Complemento is not null

select * from CB_Especialidade

--update teste set [Especialidade (ANS)] = especialidade.id
-- from tb_0719_000194 teste
--CROSS APPLY(
--	select id from tb_tabela_tiss where fk_tipo_tabela_tiss = 6 and pk_importacao in (
--		select CodCboManad from CB_Especialidade teste2 where DesEsp in (
--			select [Especialidade (ANS)] from tb_0719_000194
--		) and teste.[Especialidade (ANS)] = teste2.DesEsp
--	)
--) as especialidade


select * from tb_tabela_tiss where fk_tipo_tabela_tiss = 6 and descricao in (
	select distinct [Especialidade (ANS)] from tb_0719_000194 
)

select * from tb_tabela_tiss where fk_tipo_tabela_tiss = 6 and pk_importacao in (
	select CodCboManad from CB_Especialidade
)

select web.DesEsp,
       sasc.descricao,
	   sasc.id
	   from tb_tabela_tiss sasc
inner join CB_Especialidade web on sasc.pk_importacao = web.CodCboManad
where sasc.fk_tipo_tabela_tiss = 6 and sasc.id in (
select [Especialidade (ANS)] from tb_0719_000194 where SUBSTRING([Especialidade (ANS)],0,3) = '10'
)
Convert(Integer,[Especialidade (ANS)])
select * from CB_Especialidade where CodCboManad = 225124

select id from tb_tabela_tiss where fk_tipo_tabela_tiss = 6 and descricao in (
select [Especialidade (ANS)] from tb_0719_000194
)

--update teste set [Especialidade (ANS)] = especialidade.id from tb_0719_000194 teste
--CROSS APPLY(
	
--	select id from tb_tabela_tiss teste2 where fk_tipo_tabela_tiss = 6 and descricao in (
--	select [Especialidade (ANS)] from tb_0719_000194 
--) and teste2.descricao = teste.[Especialidade (ANS)]

--) as especialidade


select * from tb_0719_000194 where [Especialidade (ANS)] = 'Pneumologia  Pediátrica' -- 355 27 

select fk_tipo_tabela_tiss, * from tb_tabela_tiss where descricao = 'Pneumologia  Pediátrica' and fk_tipo_tabela_tiss = 6

select CodCboManad, * from CB_Especialidade where DesEsp = 'Pneumologia Pediátrica' -- 225127

select * from tb_tabela_tiss where pk_importacao = '225127'

select * from tb_0719_000194 where [CH/MOEDA] = 'Moeda'

select * from tb_ch

select top 10 ch_moeda, tipo_ch_moeda, * from tb_despesa where discriminator = 'EntidadeConvenioEspecialidade' and registro_ativo = 1 and ch_moeda is not null

select * from tb_item_despesa where codigo in (
	
	select [Codigo procedimento] from tb_0719_000194
) and tipo_procedimento is not null

select distinct
       sasc.id,
       sasc.codigo,
       sasc.descricao,
	   web.[Codigo procedimento],
       web.[Descrição procedimento]
from tb_item_despesa sasc
inner join tb_0719_000194 web on sasc.descricao = web.[Descrição procedimento] and sasc.registro_ativo = 1

select * from tb_0719_000194 where Complemento is not null

/*
select id from rl_entidade_convenio where fk_convenio in (
select id from tb_convenio where sigla in (
select * from tb_0719_000194 where C)) and fk_entidade = 25 and [Convênio ] = )

 drop table tb_0719_000194



