select planilha.valor,
       planilha.cooperado,
       cooperado.nome,
	   planilha.cpf_executante,
	   cooperado.cpf_cnpj,
	   planilha.hospital,
	   hospital.nome,
	   planilha.cnpj_hospital,
	   hospital.cnpj,
	   itemDespesa.codigo,
	   planilha.procedimento
 from dbo.[0919_000432] planilha
inner join tb_cooperado cooperado with(nolock) on (cooperado.cpf_cnpj = planilha.cpf_executante and cooperado.registro_ativo = 1)
inner join rl_entidade_cooperado entidadeCooperado with(nolock) on (entidadeCooperado.fk_cooperado = cooperado.id and entidadeCooperado.fk_entidade = 23 and entidadeCooperado.registro_ativo = 1)
inner join tb_hospital hospital with(nolock) on (hospital.cnpj = planilha.cnpj_hospital and hospital.registro_ativo = 1 and hospital.id <> 91)
inner join rl_entidade_hospital entidadeHospital with(nolock) on (entidadeHospital.fk_hospital = hospital.id and entidadeHospital.fk_entidade = 23 and entidadeHospital.registro_ativo = 1 and entidadeHospital.ativo = 1 and entidadeHospital.id <> 568)
cross apply(
select top 1 codigo from tb_item_despesa where codigo = planilha.procedimento and registro_ativo = 1
)as itemDespesa
where entidadeHospital.fk_entidade = 23 and itemDespesa.codigo = planilha.procedimento and planilha.hospital like '%BIOCOR HOSP DOENCAS CARDIOVASC%'


select itemDespesa.codigo, planilha.procedimento from dbo.[0919_000432] planilha
cross apply(
select top 1 codigo from tb_item_despesa where codigo = planilha.procedimento and registro_ativo = 1
)as itemDespesa

select * from tb_item_despesa where codigo = '16040066'

select * from tb_cooperado where cpf_cnpj = '04241546684'

select * from rl_entidade_cooperado where fk_entidade = 23 and fk_cooperado = 8370

select * from tb_procedimento where sql_update = '0919-000432' and registro_ativo = 1

select * from rl_entidade_hospital where id = 568
select * from tb_hospital where id = 91

select * from tb_cooperado where cpf_cnpj in (
select cpf_executante from dbo.[0919_000432])


select * from dbo.[0919_000432] order by pk_importacao where senha = 'KZ2JF60'
select * from tb_atendimento where sql_update = '0919-000432' and registro_ativo = 1

select * from tb_procedimento where fk_atendimento in (
select * from tb_atendimento where sql_update = '0919-000432' and registro_ativo = 1 order by pk_importacao

--select * from update tb_procedimento set registro_ativo = 0 where sql_update = '0919-000432' and registro_ativo = 1

select * from tb_atendimento where numero_atendimento_automatico = 2899897 and fk_entidade = 23
select * from tb_procedimento where fk_atendimento = 20724670

--select * from update tb_atendimento set registro_ativo = 0 where sql_update like '%0919-000432%'

select * from tb_atendimento where id not in (
select id from tb_atendimento where id in (
select fk_atendimento from tb_procedimento where sql_update = '0919-000432' and registro_ativo = 1) and registro_ativo = 1
) and registro_ativo = 1 and sql_update = '0919-000432'


select * from tb_item_despesa where codigo = '50140035'

select * from tb_hospital where cnpj = 4510670000109

select * from tb_cooperado where cpf_cnpj = '01179885619'


select * from rl_entidade_hospital where fk_entidade = 23 and fk_hospital in (49)


select top 10 fk_hospital,plano, numero_guia, versao_tiss, guia_principal, * from tb_atendimento order by id desc

fk_entidade_hospital
REFERENCES sasc_producao_desenv.dbo.rl_entidade_hospital (id)

fk_hospital
REFERENCES sasc_producao_desenv.dbo.tb_hospital (id)

--select * from tb_item_despesa where codigo = '47010150'
select * from tb_convenio where sigla like '%PMMG/IPSM%' --270
select * from rl_entidade_convenio where fk_entidade = 23 and fk_convenio = 270 --4972