select  cooperado.numero_conselho as 'CRM'
        ,cooperado.cpf_cnpj as 'CPF'
        ,cooperado.nome as 'Nome Cooperado'
		,declaracao.cnpj as 'CNPJ'
        ,CONVERT(varchar(2),MONTH(declaracao.data))+'/'+CONVERT(varchar(4), YEAR(declaracao.data)) as 'Competência'
		,declaracao.base_inss as 'Base do Inss'
		,(coalesce(declaracao.valor_inss,0.0) - coalesce(declaracao.valor_devolucao,0.00)) as 'Valor Retido'
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
and declaracao.fk_repasse is null
and (coalesce(declaracao.valor_inss,0.00) - coalesce(declaracao.valor_devolucao,0.00)) > 0
and YEAR(declaracao.data) = YEAR(integracao.competencia_inss)
and MONTH(declaracao.data) = MONTH(integracao.competencia_inss)
and cooperado.nome = 'Abdiel Leite de Souza'