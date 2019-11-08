select * from tb_arquivo_retorno_glosa where registro_ativo = 1 and fk_retorno_glosa = 36

select top 100 * from tb_retorno_glosa  order by id desc

select * from rl_entidade_convenio where fk_convenio = 451 and fk_entidade = 46

select * from rl_entidade_convenio where id = 2172

select * from tb_convenio where id = 1343

select sigla, * from tb_entidade where id = 6

select * from sysobjects where name like '%glosa%'

sp_helptext processarRetornoConvenio

select top 10 * from tb_glosa where fk_procedimento = 27368052 order by id desc

select top 100 * from tb_glosa where situacao in (3,7) order by id desc

select fk_atendimento, fk_item_despesa, * from tb_procedimento where id in (27556512,27556511)
select * from rl_situacao_procedimento where fk_procedimento in (27556512,27556511)

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

--14389238	151

select * from tb_arquivo_retorno_glosa where id = 151	

select * from tb_atendimento where id = 14389238



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