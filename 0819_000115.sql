select * from sysobjects where name like '%sefip%'

select * from tb_sefip where fk_entidade = 20 order by id desc

select * from tb_entidade_sefip where fk_entidade = 20 order by id desc

select * from tb_validacao_sefip order by id desc


select * from tb_entidade where sigla like '%SANTACOOP%' -- 20

select * from tb_convenio where sigla like '%PROMED%' --858

select * from tb_convenio where sigla like '%FUNCEF%' --184

select * from tb_convenio where sigla like '%PLANCEL%' --117

select * from tb_convenio where sigla like '%UNIMEDBHNAOCOOP%' --773

select id, nome from tb_cooperado where id in (
22245
,8930
,20532
,17814
,25474
,21271)

--tb_entidade_sefip
--tb_sefip
--tb_validacao_sefip

select status_fatura, * from tb_fatura where id in (104105 ,112371 ,104130)

-- 14055 e 14099 Cancelada e 14056 OK

--14001,13950 

--SELECT isnull(sum(fatura.valor_total),0) as valor_base_inss, 'x' as controle

select fatura.id, 
      fatura.valor_total
      FROM tb_fatura fatura,
           tb_entidade entidade,
           tb_convenio convenio,
           tb_cooperado cooperado,
           tb_entidade_sefip eSefip
     WHERE entidade.id = fatura.fk_entidade
       AND convenio.id = fatura.fk_convenio
       AND eSefip.fk_cooperado = cooperado.id
       AND eSefip.fk_entidade = entidade.id
       AND eSefip.registro_ativo = 1
       AND cooperado.registro_ativo = 1
       AND fatura.registro_ativo = 1
	   AND fatura.status_fatura in (1,2)
	   AND fatura.motivo_cancelamento is null
	   AND fatura.data_cancelamento is null
       AND entidade.registro_ativo = 1
       AND convenio.registro_ativo = 1
       AND entidade.id = 20
       AND fatura.data_emissao BETWEEN '2019-08-01' AND '2019-08-31'
       AND convenio.id = 773
