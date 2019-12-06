/**
* PROPOSITO: EXCLUSÃO INSS BANCO SASF_Pessoa (Sasc antigo).
**/

SELECT * FROM AD_Recolhimento_INSS WHERE codsascjava IN (
8252590
,8252591
) AND codidesis=9

GO

DELETE FROM AD_Recolhimento_INSS WHERE codsascjava IN (
8252590
,8252591
) AND codidesis=9