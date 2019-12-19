select top 100 * from tb_glosa where situacao in (3,7) order by id desc

select * from tb_retorno_convenio order by id desc

select * from tb_glosa where fk_carta_glosa = 138431 order by data_ultima_alteracao desc

select fk_entidade, * from tb_carta_glosa where id = 240714

select * from tb_carta_glosa where numero_carta = 2351 and fk_entidade = 46

select * from tb_glosa where fk_carta_glosa = 149086

select top 100 valor_recebido, * from tb_glosa where valor_recebido <> 0 order by id desc

--update tb_glosa set valor_recebido = 8.75 where  fk_carta_glosa = 149086 and situacao = 4

select sigla, * from tb_entidade where id = 24

select * from tb_arquivo_retorno_glosa where registro_ativo = 1 and fk_retorno_glosa = 34

select * from tb_glosa where fk_procedimento in (
33462783
,33462824
,33462856
,33462911
,33462944
,33463071
,33463114
)

select * from tb_procedimento where id = 23946931

select top 100 * from tb_retorno_glosa where registro_ativo = 1  order by id desc

--update tb_retorno_glosa set registro_ativo = 0 where id = 25

select * from tb_espelho where numero_espelho = 128582 and fk_entidade = 24

select * from tb_usuario where nome like '%Admi%'

--update tb_retorno_glosa set em_processamento = 0, processado = 1 where id = 1
--update tb_retorno_glosa set registro_ativo = 0 where id = 1

select * from rl_entidade_convenio where fk_convenio = 451 and fk_entidade = 46

select * from rl_entidade_convenio where id = 2172

select * from tb_convenio where id = 1343

select sigla, * from tb_entidade where id = 6

select * from sysobjects where name like '%glosa%'

select * from tb_atendimento where senha = 'EPYJGS8'

sp_helptext processarRetornoConvenio

select top 10 * from tb_glosa where fk_procedimento = 27520215 order by id desc

select * from tb_glosa where fk_carta_glosa = 216142

select fk_atendimento, fk_item_despesa, * from tb_procedimento where id in (23946931)
select * from rl_situacao_procedimento where fk_procedimento in (33493756)

select * from tb_item_despesa where id in (11566, 11566)

select * from tb_atendimento where id in (20527426,20527435)

select * from rl_entidade_convenio where id = 268

select * from tb_convenio where id = 613

select * from tb_carta_glosa where id = 216191 and fk_entidade = 46

--REAPRESENTADA("Reapresentada", "3"),

--REAPRESENTADA_2_VEZ("Reapresentada 2ª vez", "7");

select top 10 * from tb_procedimento where id = 27368052 order by id desc

select top 10 * from tb_carta_glosa order by id desc

select * from tb_atendimento where id = 14389238

select * from tb_atendimento where numero_guia =  '57722019'

select * from tb_carta_glosa where numero_carta = 2505 and fk_entidade in (select id from tb_entidade where sigla = 'SANTACOOPMACEIO')

select * from tb_glosa where fk_carta_glosa = 215992

select * from tb_procedimento where id = 29237989

select * from rl_situacao_procedimento where fk_procedimento = 29237989

--14389238	151

select * from tb_arquivo_retorno_glosa where id = 151	

select * from tb_atendimento where id = 14389238


select * from tb_atendimento where senha = '41205348' and fk_entidade = 6


select * from tb_espelho where id = 624688

select * from tb_item_despesa where codigo = '30704065'


IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('processarRetornoGlosa'))
BEGIN
	DROP PROCEDURE [dbo].[processarRetornoGlosa]
END
GO


SELECT *, ROW_NUMBER() OVER(PARTITION BY id_linha ORDER BY id_atendimento) AS ordem, 1 AS situacao --Não Processado
	 INTO #tempAtendimento FROM (
		SELECT atendimento.id AS id_atendimento  
	    FROM tb_atendimento as atendimento)


select top 10 * from tb_carta_glosa order by id desc
select top 10 * from tb_situacao_glosa order by id desc
select top 10 * from tb_arquivo_retorno_glosa order by id desc
select top 10 * from tb_retorno_glosa order by id desc
select top 10 * from rl_entidade_motivo_glosa order by id desc

select * from tb_atendimento where id in (
	select fk_atendimento from tb_procedimento where id in (
		select fk_procedimento from tb_glosa where fk_carta_glosa = 216027
	)
)

select top 100 * from tb_glosa where situacao in (3,7) order by id desc

/*Buscar Procedimentos Glosados*/
--Informe o numero da carta de glosa
declare @fk_carta_glosa bigint = 241090
select atendimento.numero_atendimento_automatico,
       atendimento.numero_guia,
	   atendimento.guia_principal,
	   atendimento.senha,
       procedimento.data_realizacao,
	   item.codigo,
	   situacao.valorGlosado,
	   espelho.numero_espelho,
	   entidade.sigla,
	   convenio.sigla
from tb_atendimento atendimento
inner join tb_procedimento procedimento on (procedimento.fk_atendimento = atendimento.id)
inner join tb_glosa glosa on (glosa.fk_procedimento = procedimento.id and glosa.fk_carta_glosa = @fk_carta_glosa)
inner join rl_situacao_procedimento situacao on (situacao.fk_procedimento = procedimento.id)
inner join tb_item_despesa item on (procedimento.fk_item_despesa = item.id)
inner join tb_espelho espelho on (espelho.id = atendimento.fk_espelho)
inner join tb_entidade entidade on (entidade.id = atendimento.fk_entidade)
inner join rl_entidade_convenio entidadeConvenio on (entidadeConvenio.fk_entidade = entidade.id and atendimento.fk_convenio = entidadeConvenio.id)
inner join tb_convenio convenio on (convenio.id = entidadeConvenio.fk_convenio)
where situacao.valorGlosado <> 0.00


--exec [dbo].[sp_retorno_glosa] 41, 12

--sp_helptext sp_retorno_glosa

select TOP 1 carta.id from tb_carta_glosa carta
inner join tb_glosa glosa on (glosa.fk_carta_glosa = carta.id and glosa.fk_procedimento = 27791657)


select * from tb_procedimento where fk_atendimento = 20492491



select * from tb_item_despesa where id in (
select fk_item_despesa from tb_procedimento where id in (
		select fk_procedimento from tb_glosa where fk_carta_glosa = 216027
))

select fk_item_despesa from tb_procedimento where id in (
		select fk_procedimento from tb_glosa where fk_carta_glosa = 216027
)

select * from rl_situacao_procedimento where fk_procedimento in (

select fk_procedimento from tb_glosa where fk_carta_glosa = 216027

)

select * from tb_pagamento_procedimento where fk_procedimento in (
select fk_procedimento from tb_glosa where fk_carta_glosa = 216027

)

select * from tb_procedimento where id = 27791657

select * from tb_entidade where id = 14 -- Copimef COPASSSAUDE

select * from tb_glosa where fk_carta_glosa = 216142
select * from tb_carta_glosa where id = 216142