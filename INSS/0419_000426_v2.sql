/*
* EXCLUSÃO INSS BANCO SASC PRODUÇÃO.
* COOPMEDRS	CRM/RS 33309 - Luiza Nunes Lages
* IPERGS 92829100000143	16/04/2019
* R$ 2.430,00 R$ 267,30	R$ 0,00	11.00 Bruna Zortea Lencines	16/04/2019 11:05
*/

UPDATE tb_declaracao_inss SET sincronizar=0,registro_ativo=0, sql_update=ISNULL(sql_update,'')+'#0419-000426'
WHERE id IN (8121671)

GO
	                                                         
DELETE FROM  tb_data_sync_inss
WHERE fk_declaracao_inss IN (8121671) AND processado_web=0

GO

DELETE
FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 AND fk_cooperado = 25369