/**
* EXCLUSÃO INSS- BANCO SASF_Pessoa (Sasc antigo).
* Maio/2019 a Dezembro/2019 
* Cooperado CRM/MG 12628 - Adelanir Antônio Barroso	
* Cnpj: 17689407000170	
*
**/

SELECT * FROM AD_Recolhimento_INSS WHERE codsascjava IN (
8037505,
8037506,
8037507,
8037508,
8037509,
8037510,
8037511,
8037512
) AND codidesis=9

DELETE FROM AD_Recolhimento_INSS WHERE codsascjava IN (
8037505,
8037506,
8037507,
8037508,
8037509,
8037510,
8037511,
8037512
) AND codidesis=9