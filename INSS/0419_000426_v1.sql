/*
* EXCLUSÃO INSS BANCO SASF_Pessoa (Sasc antigo).
* COOPMEDRS	CRM/RS 33309 - Luiza Nunes Lages
* IPERGS 92829100000143	16/04/2019
* R$ 2.430,00 R$ 267,30	R$ 0,00	11.00 Bruna Zortea Lencines	16/04/2019 11:05
*/

SELECT * FROM AD_Recolhimento_INSS WHERE codsascjava IN (
8121671
) AND codidesis=9

GO

DELETE FROM AD_Recolhimento_INSS WHERE codsascjava IN (
8121671
) AND codidesis=9