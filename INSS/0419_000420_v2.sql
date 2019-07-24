/*
* Exclusão INSS Banco SASC
* UNICOOPER	CRM/MG 20604 - João Cláudio Parreiras Barbosa UNIMED BH
* 16513178000176 05/04/2019	R$ 4.276,70	R$ 855,34 R$ 0,00 20.00
* Alice Aparecida Rufino dos Santos	05/04/2019 10:00
*/

UPDATE tb_declaracao_inss SET sincronizar=0,registro_ativo=0, sql_update=ISNULL(sql_update,'')+'#0419-000420'
WHERE id IN (8114369)

GO
	                                                         
DELETE FROM  tb_data_sync_inss
WHERE fk_declaracao_inss IN (8114369) AND processado_web=0

GO

DELETE
FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 AND fk_cooperado = 14954