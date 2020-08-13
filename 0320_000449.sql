select top 10 * from tb_importacao_base where registro_ativo = 1 order by id desc

select top 100 * from tb_importacao_base_AUD where registro_ativo = 1 order by id desc

--update tb_importacao_base set registro_ativo = 0 where tipo_importacao_base = 27

select * from tb_linha_importacao_base where fk_importacao_base = 141430 order by id desc

--update tb_linha_importacao_base set registro_ativo = 0 where fk_importacao_base = 141431

--delete from tb_linha_importacao_base where fk_importacao_base = 141436

select * from tb_integracao_inss_unimed where registro_ativo = 1

--select * from drop table tb_linha_integracao_inss_unimed

select * from tb_linha_importacao_base where linha like '%;Joao Tadeu Leite dos Reis;%' and fk_importacao_base = 137030

select top 10 * from tb_declaracao_inss
where registro_ativo = 1
--and tipo_declaracao <> 2
and fk_repasse is not null
--and numero_repasse_web is null
 order by id desc

select cooperado.nome as 'Nome'
       ,declaracao.cnpj as 'Cnpj'
	   ,declaracao.base_inss as 'Base Inss'
	   ,declaracao.data as 'Competencia'  
	   ,declaracao.valor_inss as 'Valor Inss'
	   ,declaracao.valor_devolucao as 'Valor Devolução'   
	   ,(coalesce(declaracao.valor_inss,0.0) - coalesce(declaracao.valor_devolucao,0.0)) as 'Valor Real'
	   ,declaracao.numero_repasse_web
	   ,declaracao.id_declaracao_web
	   ,declaracao.fk_repasse_devolucao_inss
	   ,declaracao.tipo_declaracao
from tb_declaracao_inss declaracao
inner join tb_cooperado cooperado on(declaracao.fk_cooperado = cooperado.id and declaracao.registro_ativo = 1)
where cooperado.nome in (
'Adauto Francisco Lara Junior',
 'Aline Souza Costa Teixeira Moreno',
  'Ana Clara de Souza Campolina',
  'Bernardo Aramuni Mariano',
  'Heli Teodomiro de Paula Freitas',
  'Joao Tadeu Leite dos Reis'
  )
--and cooperado.cpf_cnpj = ''
and declaracao.data >= '2020-07-01'
and declaracao.data <= '2020-07-31'
--and declaracao.fk_repasse is not null
--and declaracao.id_declaracao_web is not null
and (coalesce(declaracao.valor_inss,0.0) - coalesce(declaracao.valor_devolucao,0.0)) > 0
order by cooperado.nome