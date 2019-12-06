/**
* PROPOSITO: EXCLUSÃO INSS BANCO SASC PRODUÇÃO
**/
UPDATE tb_declaracao_inss SET sincronizar=0,registro_ativo=0, sql_update=ISNULL(sql_update,'')+'#1119-000205' WHERE id IN(
8113803
)

GO
                                                             
DELETE FROM tb_data_sync_inss WHERE fk_declaracao_inss IN(
8113803
)
AND processado_web=0

GO

DELETE
FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 AND fk_cooperado = 14160 --FK_COOPERADO

/*
Forçar o repasse e conferir o log para ver a sincronização do INSS "Inicio e Fim"
*/