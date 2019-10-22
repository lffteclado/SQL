UPDATE tb_declaracao_inss SET sincronizar=0,registro_ativo=0, sql_update=ISNULL(sql_update,'')+'#' WHERE id IN(
8190744
,8190745
,8190746
,8041749
,8041750
,8041751
,8051990
,8051991
,8051992
,8017563
,8017564
,8017565
,8287622
,8277759
)

GO
                                                             
DELETE FROM tb_data_sync_inss WHERE fk_declaracao_inss IN(
8190744
,8190745
,8190746
,8041749
,8041750
,8041751
,8051990
,8051991
,8051992
,8017563
,8017564
,8017565
,8287622
,8277759
)
AND processado_web=0

GO

DELETE
FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 AND fk_cooperado in (24753,12753,27454,7769,13975) --FK_COOPERADO

/*
Forçar o repasse e conferir o log para ver a sincronização do INSS "Inicio e Fim"
*/