/**
* PROPOSITO: EXCLUSÃO INSS BANCO SASC PRODUÇÃO
* COOPERADO: Victor Cardoso Rocha
* COOPERATIVA: SANTACOOPMACEIO	
* EMPRESA: SESAU		
* CNPJ: 	12200259000165	
* PERÍODO: MAIO/2019 a DEZEMBRO/2019 
* 
**/
UPDATE tb_declaracao_inss SET sincronizar=0,registro_ativo=0, sql_update=ISNULL(sql_update,'')+'#0519_000262' WHERE id IN(
8142925,
8142926,
8142927,
8142928,
8142929,
8142930,
8142931,
8142932
)

GO
                                                             
DELETE FROM tb_data_sync_inss WHERE fk_declaracao_inss IN(
8142925,
8142926,
8142927,
8142928,
8142929,
8142930,
8142931,
8142932
)
AND processado_web=0

GO

DELETE
FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 AND fk_cooperado = 27867 --FK_COOPERADO

/*
Forçar o repasse e conferir o log para ver a sincronização do INSS "Inicio e Fim"
*/