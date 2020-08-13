
select SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)), 0,
       CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))) as nome,
	   REPLACE(REPLACE(SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)),
	   CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))+1, LEN(
	   SUBSTRING(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))),'.',''),'-','') AS cpf
from tb_linha_importacao_base linha
where linha.fk_importacao_base = 140491
and REPLACE(REPLACE(SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)),
	   CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))+1, LEN(
	   SUBSTRING(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))),'.',''),'-','') in (	   
	   select cpf_cnpj from tb_cooperado where registro_ativo = 1
	   )



select * from tb_cooperado where cpf_cnpj = '66666666666'

06004719692
06004719692

select  integracao.nome,
        integracao.cpf
from tb_cooperado cooperado
cross apply(
select TRIM(SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)), 0,
       CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha))))) as nome,
	   TRIM(REPLACE(REPLACE(SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)),
	   CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))+1, LEN(
	   SUBSTRING(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))),'.',''),'-','')) AS cpf
from tb_linha_importacao_base linha
where linha.fk_importacao_base = 140489) as integracao
where LOWER(cooperado.nome) = LOWER(integracao.nome)
and cooperado.cpf_cnpj = integracao.cpf

select cpf from #tmp2
where cpf not in (
select cpf from #tmp
)



select TRIM(SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)), 0,
       CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha))))) as nome,
	   TRIM(REPLACE(REPLACE(SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)),
	   CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))+1, LEN(
	   SUBSTRING(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))),'.',''),'-','')) AS cpf
from tb_linha_importacao_base linha
where fk_importacao_base = 140489
and TRIM(REPLACE(REPLACE(SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)),
	   CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))+1, LEN(
	   SUBSTRING(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))),'.',''),'-',''))  not in (
	   select integracao.cpf
from tb_cooperado cooperado
cross apply(
select TRIM(SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)), 0,
       CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha))))) as nome,
	   TRIM(REPLACE(REPLACE(SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)),
	   CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))+1, LEN(
	   SUBSTRING(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))),'.',''),'-','')) AS cpf
from tb_linha_importacao_base linha
where linha.fk_importacao_base = 140489) as integracao
where LOWER(cooperado.nome) = LOWER(integracao.nome)
and cooperado.cpf_cnpj = integracao.cpf
)