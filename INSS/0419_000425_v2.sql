/*
* EXCLUSÃO INSS BANCO SASC PRODUÇÃO
* Cooperado: CRM/MG 17764 - Gilberto Antônio Xavier Júnior 
* Felicoop 
* 04/2019 a 12/2019 
* Unimed BH	16513178000176	
*/

UPDATE tb_declaracao_inss SET sincronizar=0,registro_ativo=0, sql_update=ISNULL(sql_update,'')+'0419-000425'
WHERE id IN (
8038678,
8038679,
8038680,
8038681,
8038682,
8038683,
8038684,
8038685,
8038686
)

GO
	                                                         
DELETE FROM  tb_data_sync_inss
WHERE fk_declaracao_inss IN (
8038678,
8038679,
8038680,
8038681,
8038682,
8038683,
8038684,
8038685,
8038686) AND processado_web=0

GO

DELETE
FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 AND fk_cooperado = 6594