/*
* Script para exclusão das declarações da cooperada
* CRM/MG 28191 - Jacilea Regina Rodrigues E Rodrigues Pedrosa 
* Realizadas pelo usuário Maria Antonia de Carvalho dos Santos	
* no dia 15/04/2019 09:45 Mês 05/2019 a 12/2019
* CHAMADO: #0419-000341
* AUTOR: Luís Felipe Ferreira
* DATA: 15/04/2019
*/

UPDATE tb_declaracao_inss SET sincronizar=0,registro_ativo=0, sql_update=ISNULL(sql_update,'')+'#0419-000341' WHERE id in(
8120732,
8120733,
8120734,
8120735,
8120736,
8120737, 
8120738,
8120739
)

GO
                                                             
DELETE FROM  tb_data_sync_inss WHERE fk_declaracao_inss in(
8120732,
8120733,
8120734,
8120735,
8120736,
8120737, 
8120738,
8120739
)
and processado_web=0

GO

DELETE
FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 and fk_cooperado = 23286