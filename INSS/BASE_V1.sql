/**
* PROPOSITO: EXCLUS�O INSS BANCO SASF_Pessoa (Sasc antigo).
* COOPERADO:  --
* COOPERATIVA: 
* EMPRESA: 	
* CNPJ: 	
* PER�ODO: 
* 
**/

SELECT * FROM AD_Recolhimento_INSS WHERE codsascjava IN (
--ID
) AND codidesis=9

GO

DELETE FROM AD_Recolhimento_INSS WHERE codsascjava IN (
--ID
) AND codidesis=9