/*
* EXCLUS�O INSS BANCO SASF_Pessoa. (Sasc antigo)
* Cooperado: CRM/MG 17764 - Gilberto Ant�nio Xavier J�nior 
* Felicoop 
* 04/2019 a 12/2019 
* Unimed HB	16513178000176	
*/

SELECT * FROM AD_Recolhimento_INSS WHERE codsascjava IN (
8038678,
8038679,
8038680,
8038681,
8038682,
8038683,
8038684,
8038685,
8038686
) AND codidesis=9

GO

DELETE FROM AD_Recolhimento_INSS WHERE codsascjava IN (
8038678,
8038679,
8038680,
8038681,
8038682,
8038683,
8038684,
8038685,
8038686
) AND codidesis=9