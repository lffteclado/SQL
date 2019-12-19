
UPDATE tb_declaracao_inss SET sincronizar=0,registro_ativo=0, sql_update=ISNULL(sql_update,'')+'#1219-000415' WHERE id IN(
8347499
)

GO
                                                             
DELETE FROM tb_data_sync_inss WHERE fk_declaracao_inss IN(
8347499
)
AND processado_web=0

GO

DELETE
FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 AND fk_cooperado = 4266 --FK_COOPERADO