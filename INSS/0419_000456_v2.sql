/**
* EXCLUSÃO INSS BANCO SASC PRODUÇÃO
* Cooperado: CRM/RS 24729 - Andre Luis Rosenhaim Monte --26258
* empresa: UNIMED PORTO ALEGRE	
* CNPJ: 87096616000196	
* Período: 05/2019 a 12/2019 
* 
*/
UPDATE tb_declaracao_inss SET sincronizar=0,registro_ativo=0, sql_update=ISNULL(sql_update,'')+'#0419-000456' WHERE id IN(
8123090,
8123091,
8123092,
8123093,
8123094,
8123095,
8123096,
8123097
)

GO
                                                             
DELETE FROM tb_data_sync_inss WHERE fk_declaracao_inss IN(
8123090,
8123091,
8123092,
8123093,
8123094,
8123095,
8123096,
8123097
)
AND processado_web=0

GO

DELETE
FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 AND fk_cooperado = 26258