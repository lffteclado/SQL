UPDATE tb_declaracao_inss SET sincronizar=0,registro_ativo=0, sql_update=ISNULL(sql_update,'')+'#1019-000134' WHERE id IN(
8190744
,8190745
,8190746
)

GO
                                                             
DELETE FROM tb_data_sync_inss WHERE fk_declaracao_inss IN(
8190744
,8190745
,8190746
)
AND processado_web=0

GO

DELETE
FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 AND fk_cooperado = 24753 --FK_COOPERADO

/*
For�ar o repasse e conferir o log para ver a sincroniza��o do INSS "Inicio e Fim"
*/