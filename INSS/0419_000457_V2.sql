/**
* EXCLUSÃO INSS BANCO SASC PRODUÇÃO
* Cooperado:  Dra Lys Beatriz Brandao Lopes CRM: 62556 --25537
* Empresa: Hospital Nossa Senhora das Graças	
* CNPJ: 24.993.560/0001-52	
* Período: Abril/2019 a dezembro/2019
* 
*/
UPDATE tb_declaracao_inss SET sincronizar=0,registro_ativo=0, sql_update=ISNULL(sql_update,'')+'#0419-000457' WHERE id IN(
7986776,
7986777,
7986778,
7986779,
7986780,
7986781,
7986782,
7986783,
7986784,
8012088,
8012089,
8012090,
8012091,
8012092,
8012093,
8012094,
8012095,
8012096
)

GO
                                                             
DELETE FROM tb_data_sync_inss WHERE fk_declaracao_inss IN(
7986776,
7986777,
7986778,
7986779,
7986780,
7986781,
7986782,
7986783,
7986784,
8012088,
8012089,
8012090,
8012091,
8012092,
8012093,
8012094,
8012095,
8012096
)
AND processado_web=0

GO

DELETE
FROM tb_total_inss_cooperado
WHERE year(mes_ano) = 2019 AND fk_cooperado = 25537