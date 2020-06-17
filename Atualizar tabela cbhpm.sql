
update cbhpm set percentualFator = percentualFator * 100

update despesa set
despesa.percentual_fator = tabelaCodigoFator.percentualFator,
despesa.sql_update = ISNULL(despesa.sql_update,'')+'#0320-000366'
FROM tb_despesa despesa
INNER JOIN cbhpm tabelaCodigoFator ON (despesa.pk_importacao = tabelaCodigoFator.codigo)
WHERE despesa.fk_edicao_tabela_honorarios = 164
AND despesa.registro_ativo = 1


drop table TabelaCodigoFator$
