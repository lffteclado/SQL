/**
* PROPOSITO: EXCLUSÃO INSS BANCO SASC PRODUÇÃO
* COOPERADO: Cooperado CRM/MG 12628 - Adelanir Antônio Barroso	--19467
* EMPRESA: Unimed Juiz de Fora	
* CNPJ: 17689407000170	
* PERÍODO: Maio/2019 a Dezembro/2019  
* 
**/
UPDATE tb_declaracao_inss SET sincronizar=0,registro_ativo=0, sql_update=ISNULL(sql_update,'')+'#0419-000460' WHERE id IN(
8037505,
8037506,
8037507,
8037508,
8037509,
8037510,
8037511,
8037512
)

GO
                                                             
DELETE FROM tb_data_sync_inss WHERE fk_declaracao_inss IN(
8037505,
8037506,
8037507,
8037508,
8037509,
8037510,
8037511,
8037512
)
AND processado_web=0

GO

DELETE
FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 AND fk_cooperado = 19467