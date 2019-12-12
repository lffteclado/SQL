select * from tb_tabela_tiss_versao_codigo where codigo = '225124' order by fk_tabela_tiss, versao_tiss

select distinct fk_tabela_tiss from tb_tabela_tiss_versao_codigo where registro_ativo = 1

select * from tb_tabela_tiss
 where discriminator = 'especialidade'
  and registro_ativo = 1
  and pk_importacao is not null
  and pk_importacao = '225180'
   order by id desc

   select distinct tiss.id from tb_tabela_tiss_versao_codigo versaoCodigo
	inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
	 where tiss.discriminator = 'especialidade' and tiss.pk_importacao is not null

select top 100 * from tb_tabela_tiss where id = 109695

--update tb_tabela_tiss_versao_codigo set registro_ativo = 0 where sql_update = '1219-000128'



select tissCodigo.codigo,
       tiss.descricao,
	   tissCodigo.versao_tiss
from tb_tabela_tiss_versao_codigo tissCodigo
inner join tb_tabela_tiss tiss on (tiss.id = tissCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and tissCodigo.registro_ativo = 1)
where tissCodigo.codigo = '225124' and tissCodigo.versao_tiss = 5 order by fk_tabela_tiss


select * from tb_tabela_tiss_versao_codigo versaoCodigo

cross apply (

	select tissCodigo.codigo,
	       tiss.descricao,
		   tissCodigo.versao_tiss
	from tb_tabela_tiss_versao_codigo tissCodigo
	inner join tb_tabela_tiss tiss on (tiss.id = tissCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and tissCodigo.registro_ativo = 1)
	where tissCodigo.versao_tiss = 5 and tiss.discriminator = 'especialidade'


) as tabela

 where registro_ativo = 1 and id not in (

 select tissCodigo.id
	from tb_tabela_tiss_versao_codigo tissCodigo
	inner join tb_tabela_tiss tiss on (tiss.id = tissCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and tissCodigo.registro_ativo = 1)
	where tissCodigo.versao_tiss = 5 and tiss.discriminator = 'especialidade'
 
 ) and tabela.codigo = versaoCodigo.codigo




select * from tb_tabela_tiss_versao_codigo where fk_tabela_tiss in (109793) and registro_ativo = 1

select * from tb_tabela_tiss_versao_codigo where sql_update = '1219-000128' and registro_ativo = 1 order by fk_tabela_tiss

select * from tb_tabela_tiss where id = 131510



select tissCodigo.codigo,
       tiss.descricao,
	   tissCodigo.versao_tiss
from tb_tabela_tiss_versao_codigo tissCodigo
inner join tb_tabela_tiss tiss on (tiss.id = tissCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and tissCodigo.registro_ativo = 1)
where tissCodigo.versao_tiss = 5 and tiss.discriminator = 'especialidade'






select * from tb_tabela_tiss where id not in (

	select tissCodigo.fk_tabela_tiss, *
	from tb_tabela_tiss_versao_codigo tissCodigo
	inner join tb_tabela_tiss tiss on (tiss.id = tissCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and tissCodigo.registro_ativo = 1)
	where tissCodigo.codigo = '225124' AND versao_tiss = 5

) and registro_ativo = 1 and discriminator = 'especialidade'


select * from tb_tabela_tiss where id not in (

	select fk_tabela_tiss from tb_tabela_tiss_versao_codigo where registro_ativo = 1 and versao_tiss = 5


) and registro_ativo = 1 and discriminator = 'especialidade'






select versaoCodigo.id,
       versaoCodigo.codigo,
       tiss.descricao,
	   versaoCodigo.versao_tiss
from tb_tabela_tiss tiss
cross apply (
 select versao.id,
        versao.codigo,
        versao.versao_tiss
 from tb_tabela_tiss_versao_codigo versao where versao.fk_tabela_tiss = tiss.id and versao.registro_ativo = 1
) as versaoCodigo
where tiss.discriminator = 'especialidade' and tiss.registro_ativo = 1 and versao_tiss in (

select distinct versaoCodigo.id
       --versaoCodigo.codigo
       --tiss.descricao
	   --versaoCodigo.versao_tiss
from tb_tabela_tiss tiss
cross apply (
 select versao.id,
        versao.codigo,
        versao.versao_tiss
 from tb_tabela_tiss_versao_codigo versao where versao.fk_tabela_tiss = tiss.id and versao.registro_ativo = 1
) as versaoCodigo
where tiss.discriminator = 'especialidade' and tiss.registro_ativo = 1
)



select * from tb_tabela_tiss tiss1
cross apply (
select tiss.id as tissID,
	   versaoCodigo.id,
       versaoCodigo.codigo,
       tiss.descricao,
	   versaoCodigo.versao_tiss
from tb_tabela_tiss tiss
cross apply (
	 select versao.id,
			versao.codigo,
			versao.versao_tiss
	 from tb_tabela_tiss_versao_codigo versao where versao.fk_tabela_tiss = tiss.id and versao.registro_ativo = 1
	) as versaoCodigo
	where tiss.discriminator = 'especialidade' and tiss.registro_ativo = 1

) as tabela2

where tiss1.id <> tabela2.tissID




select * from #tabelaVersao


select * from tb_tabela_tiss_versao_codigo
inner join #tabelaVersao tabela on (tabela.)

select versao.id,
        versao.codigo,
        versao.versao_tiss
 from tb_tabela_tiss_versao_codigo versao
 cross apply (
	
	select id from tb_tabela_tiss tiss where versao.fk_tabela_tiss = tiss.id

 ) as teste




select * from tb_tabela_tiss tiss
cross apply (
	SELECT distinct tiss.id,
	       tissCodigo.codigo
	FROM tb_tabela_tiss_versao_codigo tissCodigo
	INNER JOIN tb_tabela_tiss tiss ON (tiss.id = tissCodigo.fk_tabela_tiss AND tiss.registro_ativo = 1 AND tissCodigo.registro_ativo = 1)
	WHERE tiss.discriminator = 'especialidade'

) as tabela
where tiss.discriminator = 'especialidade' and tiss.registro_ativo = 1



select distinct --versaoCodigo.id,
       versaoCodigo.codigo,
       tiss.descricao
	   --versaoCodigo.versao_tiss
from tb_tabela_tiss tiss
cross apply (
 select versao.id,
        versao.codigo,
        versao.versao_tiss
 from tb_tabela_tiss_versao_codigo versao where versao.fk_tabela_tiss = tiss.id and versao.registro_ativo = 1
) as versaoCodigo
where tiss.discriminator = 'especialidade' and tiss.registro_ativo = 1


select distinct versaoCodigo.fk_tabela_tiss,
 versaoCodigo.codigo
from tb_tabela_tiss_versao_codigo versaoCodigo
inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
where versaoCodigo.fk_tabela_tiss not in(
	select tiss.id from tb_tabela_tiss_versao_codigo versaoCodigo
	inner join tb_tabela_tiss tiss on (tiss.id = versaoCodigo.fk_tabela_tiss and tiss.registro_ativo = 1 and versaoCodigo.registro_ativo = 1)
	 where versaoCodigo.versao_tiss = 6 and tiss.discriminator = 'especialidade'
) and tiss.discriminator = 'especialidade' order by versaoCodigo.fk_tabela_tiss 


