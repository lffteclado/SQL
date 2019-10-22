select * from dbo.[0919_000432] where senha not in( 

select  planilha.senha
 from dbo.[0919_000432] planilha
inner join tb_cooperado cooperado with(nolock) on (cooperado.cpf_cnpj = case len(planilha.cpf_executante) when 10 then convert(varchar(255),'0'+planilha.cpf_executante) else planilha.cpf_executante end and cooperado.registro_ativo = 1)
inner join rl_entidade_cooperado entidadeCooperado with(nolock) on (entidadeCooperado.fk_cooperado = cooperado.id and entidadeCooperado.fk_entidade = 23 and entidadeCooperado.registro_ativo = 1)
inner join tb_hospital hospital with(nolock) on (hospital.cnpj = case len(planilha.cnpj_hospital) when 13 then convert(varchar(255),'0'+planilha.cnpj_hospital) else planilha.cnpj_hospital end and hospital.registro_ativo = 1 /*and hospital.id <> 91 and hospital.id <> 49*/)-- Hospital de Olhos de Minas Gerais e Hospital Madre Tereza
inner join rl_entidade_hospital entidadeHospital with(nolock) on (entidadeHospital.fk_hospital = hospital.id and entidadeHospital.fk_entidade = 23 and entidadeHospital.registro_ativo = 1 and entidadeHospital.ativo = 1 and entidadeHospital.id <> 568 and entidadeHospital.id <> 559)-- Hospital de Olhos de Minas Gerais e Hospital Madre Tereza
cross apply(
select top 1 codigo from tb_item_despesa where codigo = planilha.procedimento and registro_ativo = 1
)as itemDespesa
where entidadeHospital.fk_entidade = 23 and itemDespesa.codigo = planilha.procedimento)

select * from tb_cooperado where cpf_cnpj = 50966812620
select * from rl_entidade_cooperado where fk_entidade = 23 and fk_cooperado = 


select * from tb_hospital where id in (91, 49)

--and planilha.senha like '%K1L%'-- and planilha.hospital like '% CENTRO GASTROENTEREOLOGICO LTD%'
/*
planilha.valor,
       planilha.cooperado,
       cooperado.nome,
	   planilha.cpf_executante,
	   cooperado.cpf_cnpj,
	   planilha.hospital,
	   hospital.nome,
	   planilha.cnpj_hospital,
	   hospital.cnpj,
	   itemDespesa.codigo,
	   planilha.procedimento,

*/