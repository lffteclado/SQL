/**
* PROPOSITO: EXCLUSÃO INSS BANCO SASC PRODUÇÃO
* COOPERADO: Paulo Victor de Barros Lima Santos
* COOPERATIVA: SANTACOOPMACEIO	
* EMPRESA: 	SESAU	
* CNPJ: 12200259000165		
* PERÍODO: MAIO/2019 a DEZ/2019 
* 
**/
UPDATE tb_declaracao_inss SET sincronizar=0,registro_ativo=0, sql_update=ISNULL(sql_update,'')+'#0519_000265' WHERE id IN(
8142933,
8142934,
8142935,
8142936,
8142937,
8142938,
8142939,
8142940
)

GO
                                                             
DELETE FROM tb_data_sync_inss WHERE fk_declaracao_inss IN(
8142933,
8142934,
8142935,
8142936,
8142937,
8142938,
8142939,
8142940
)
AND processado_web=0

GO

DELETE
FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 AND fk_cooperado = 27982 --FK_COOPERADO

/*
Forçar o repasse e conferir o log para ver a sincronização do INSS "Inicio e Fim"
*/