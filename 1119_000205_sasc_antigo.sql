/**
* PROPOSITO: EXCLUS�O INSS BANCO SASF_Pessoa (Sasc antigo).
**/

SELECT * FROM AD_Recolhimento_INSS WHERE codsascjava IN (
8113803
) AND codidesis=9

GO

DELETE FROM AD_Recolhimento_INSS WHERE codsascjava IN (
8113803
) AND codidesis=9