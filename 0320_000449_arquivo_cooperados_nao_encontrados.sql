select REPLACE(REPLACE(SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)),
	   CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))+1, LEN(
	   SUBSTRING(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))),'.',''),'-','') AS cpf
from tb_linha_importacao_base linha
where linha.fk_importacao_base = 140489
and not exists (
select  integracao.cpf
from tb_cooperado cooperado
cross apply(
select SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)), 0,
       CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))) as nome,
	   REPLACE(REPLACE(SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)),
	   CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))+1, LEN(
	   SUBSTRING(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))),'.',''),'-','') AS cpf
from tb_linha_importacao_base linha
where linha.fk_importacao_base = 140489) as integracao
where LOWER(cooperado.nome) = LOWER(integracao.nome)
and cooperado.cpf_cnpj = integracao.cpf
)


/*


SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)), 0,
       CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))) as nome,

CONVERT(bigint,REPLACE(REPLACE(SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)),
	   CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))+1, LEN(
	   SUBSTRING(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))),'.',''),'-','')) not in (
select  integracao.cpf
from tb_cooperado cooperado
cross apply(
select SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)), 0,
       CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))) as nome,
	   REPLACE(REPLACE(SUBSTRING(substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)),
	   CHARINDEX(';', substring(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))+1, LEN(
	   SUBSTRING(linha.linha,CHARINDEX(';',linha.linha)+1, LEN(linha.linha)))),'.',''),'-','') AS cpf
from tb_linha_importacao_base linha
where linha.fk_importacao_base = 140489) as integracao
where LOWER(cooperado.nome) = LOWER(integracao.nome)
and cooperado.cpf_cnpj = integracao.cpf
)
and linha.fk_importacao_base = 140489


*/