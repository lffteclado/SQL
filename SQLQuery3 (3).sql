select * from tb_tabela_tiss_versao_codigo where id in (

	select fk_tecnica from tb_procedimento where fk_atendimento in (
	
		select id from tb_atendimento
		 where numero_atendimento_automatico = 9627173
		  and fk_entidade in (select id from tb_entidade where sigla = 'COOPERCON')
	
	)
)

select * from tb_convenio where id in (
37
,194
,1746
,858
,1344
,1330
)

select versao_tiss, fk_convenio, * from rl_entidade_convenio where fk_entidade = 10 and versao_tiss in (5)

select * from tb_tabela_tiss where id = 110587

select * from tb_tabela_tiss where id = 30

select * from tb_tabela_tiss where registro_ativo = 1 and fk_relacao_tuss = 30

select versaoCodigo.id
from tb_tabela_tiss_versao_codigo versaoCodigo
inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
where versaoCodigo.fk_tabela_tiss not in(
	select * from tb_tabela_tiss_versao_codigo versaoCodigo
		inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
	where tiss.fk_relacao_tuss = 30 and versaoCodigo.versao_tiss = 5
) and tiss.fk_relacao_tuss = 30

/*
select distinct tiss.id from tb_tabela_tiss_versao_codigo versaoCodigo
inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
where tiss.fk_relacao_tuss = 30 and versaoCodigo.versao_tiss = 5*/