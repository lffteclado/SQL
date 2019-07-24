/*
* Script para exclusão das declarações da cooperada
* CRM/MG 28191 - Jacilea Regina Rodrigues E Rodrigues Pedrosa 
* Realizadas pelo usuário Maria Antonia de Carvalho dos Santos	
* no dia 15/04/2019 09:45 Mês 05/2019 a 12/2019
* CHAMADO: #0419-000341
* AUTOR: Luís Felipe Ferreira
* DATA: 15/04/2019
*/

SELECT * FROM AD_Recolhimento_INSS WHERE codsascjava in (
8120732,
8120733,
8120734,
8120735,
8120736,
8120737, 
8120738,
8120739  
) AND codidesis=9

GO

DELETE FROM AD_Recolhimento_INSS WHERE codsascjava IN (
8120732,
8120733,
8120734,
8120735,
8120736,
8120737, 
8120738,
8120739
) AND codidesis=9