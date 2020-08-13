--substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha))


select  cooperado.numero_conselho as 'CRM'
        ,cooperado.cpf_cnpj as 'CPF'
        ,cooperado.nome as 'Nome Cooperado'
		,declaracao.cnpj as 'CNPJ'
        ,CONVERT(varchar(2),MONTH(declaracao.data))+'/'+CONVERT(varchar(4), YEAR(declaracao.data)) as 'Competência'
		,declaracao.base_inss as 'Base do Inss'
		,(coalesce(declaracao.valor_inss,0.00) - coalesce(declaracao.valor_devolucao,0.0)) as 'Valor Retido'
		,declaracao.numero_repasse_web
		,declaracao.id_declaracao_web
		,declaracao.fk_repasse_devolucao_inss
		,declaracao.tipo_declaracao
from tb_declaracao_inss declaracao
inner join tb_cooperado cooperado on(cooperado.id = declaracao.fk_cooperado and declaracao.registro_ativo = 1)
cross apply(
select SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)), 0,
       CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))) as nome,
	   REPLACE(REPLACE(SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)),
	   CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))+1, LEN(
	   SUBSTRING(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))),'.',''),'-','') AS cpf,
	   importacao.competencia_inss
from tb_linha_importacao_base linha
inner join tb_importacao_base importacao on(linha.fk_importacao_base = importacao.id and linha.registro_ativo = 1 and importacao.registro_ativo = 1)
where importacao.id = 140490) as integracao
where LOWER(cooperado.nome) = LOWER(integracao.nome)
and cooperado.cpf_cnpj = integracao.cpf
and declaracao.fk_repasse is not null
--and declaracao.tipo_declaracao = 2
--and declaracao.id_declaracao_web is null
and (coalesce(declaracao.valor_inss, 0.00) - coalesce(declaracao.valor_devolucao,0.0)) > 0
and YEAR(declaracao.data) = YEAR(integracao.competencia_inss)
and MONTH(declaracao.data) = MONTH(integracao.competencia_inss)
and cooperado.nome = 'Fernando Antonio Roquette Reis Filho'




/*
set @String = (select substring('2;ALDEMIR BRANT DRUMMOND;000.467.956-34',CHARINDEX(';','2;ALDEMIR BRANT DRUMMOND;000.467.956-34')+1, LEN('2;ALDEMIR BRANT DRUMMOND;000.467.956-34')))

set @NomeCooperado = (select SUBSTRING(@String, 0, CHARINDEX(';', @String)))

set @CPFCooperado = (select SUBSTRING(@String, CHARINDEX(';', @String)+1, LEN(@String)))

select @NomeCooperado as nome_cooperado, @CPFCooperado as cpf_ooperado into #tmp




SELECT value FROM STRING_SPLIT('2;ALDEMIR BRANT DRUMMOND;000.467.956-34', ';')
where value <> (select substring('2;ALDEMIR BRANT DRUMMOND;000.467.956-34',0, CHARINDEX(';','2;ALDEMIR BRANT DRUMMOND;000.467.956-34')))

select SUBSTRING(linha.linha, CHARINDEX(';',linha.linha)+1, LEN(linha.linha))

from tb_linha_importacao_base linha
inner join tb_importacao_base importacao on(linha.fk_importacao_base = importacao.id and linha.registro_ativo = 1 and importacao.registro_ativo = 1)
where importacao.id = 137030



select top 10 * from tb_declaracao_inss order by id desc



SUBSTRING(
				SUBSTRING(
				linha.linha, CHARINDEX(';',linha.linha)+1, len(linha.linha)
				), CHARINDEX(';',linha.linha)+1,CHARINDEX(';',SUBSTRING(linha.linha, CHARINDEX(';',linha.linha)+1, len(linha.linha))))


CREATE FUNCTION [dbo].[f_split] (@String NVARCHAR(4000), @Delimiter NCHAR(1)) RETURNS TABLE
AS
RETURN
(
    WITH Split(stpos,endpos)
    AS(
        SELECT 0 AS stpos, CHARINDEX(@Delimiter,@String) AS endpos
        UNION ALL
        SELECT endpos+1, CHARINDEX(@Delimiter,@String,endpos+1)
            FROM Split
            WHERE endpos > 0
    )
    SELECT 'Id' = ROW_NUMBER() OVER (ORDER BY (SELECT 1)),
        'Data' = SUBSTRING(@String,stpos,COALESCE(NULLIF(endpos,0),LEN(@String)+1)-stpos)
    FROM Split
)*/