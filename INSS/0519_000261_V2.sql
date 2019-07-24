/**
* PROPOSITO: EXCLUSÃO INSS BANCO SASC PRODUÇÃO
* COOPERADO: Pedro Augusto Teixeira Jorge
* COOPERATIVA: COPIMEF 
* EMPRESA: Prefeitura de BH	
* CNPJ: 11728239000107	
* PERÍODO: Junho/2019 a Dezembro/2019
* 
**/
UPDATE tb_declaracao_inss SET sincronizar=0,registro_ativo=0, sql_update=ISNULL(sql_update,'')+'#0519_000261' WHERE id IN(
8116296,
8116297,
8116298,
8116299,
8116300,
8116301,
8116302
)

GO
                                                             
DELETE FROM tb_data_sync_inss WHERE fk_declaracao_inss IN(
8116296,
8116297,
8116298,
8116299,
8116300,
8116301,
8116302
)
AND processado_web=0

GO

DELETE
FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 AND fk_cooperado = 19958 --FK_COOPERADO

/*
Forçar o repasse e conferir o log para ver a sincronização do INSS "Inicio e Fim"
*/