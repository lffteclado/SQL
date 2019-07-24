/*
* Exclusão INSS Banco  SASF_Pessoa. (Sasc antigo)
* UNICOOPER	CRM/MG 20604 - João Cláudio Parreiras Barbosa	UNIMED BH
* 16513178000176	05/04/2019	R$ 4.276,70	R$ 855,34	R$ 0,00	20.00*
* Alice Aparecida Rufino dos Santos	05/04/2019 10:00
*/

SELECT * FROM AD_Recolhimento_INSS WHERE codsascjava IN (
8114369
) and codidesis=9

GO

DELETE FROM AD_Recolhimento_INSS WHERE codsascjava in (
8114369
) and codidesis=9