/**
* PROPOSITO: EXCLUS�O INSS BANCO SASC PRODU��O
* COOPERADO:  --
* COOPERATIVA: 
* EMPRESA: 	
* CNPJ: 	
* PER�ODO: 
* 
**/
UPDATE tb_declaracao_inss SET sincronizar=0,registro_ativo=0, sql_update=ISNULL(sql_update,'')+'#' WHERE id IN(
--ID
)

GO
                                                             
DELETE FROM tb_data_sync_inss WHERE fk_declaracao_inss IN(
--ID
)
AND processado_web=0

GO

DELETE
FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 AND fk_cooperado = --FK_COOPERADO

/*
For�ar o repasse e conferir o log para ver a sincroniza��o do INSS "Inicio e Fim"
*/