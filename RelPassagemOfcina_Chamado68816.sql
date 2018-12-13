/* INICIO_CABEC_REL
-----------------------------------------------------------------------------------------------
 EMPRESA......: Grupo VDL Ltda
 PROJETO......: Relatório Passagem Oficna - Chamado 68816
 AUTOR........: Luís Felipe Ferreira
 DATA.........: 21/11/2017
 OBJETIVO.....: Gerar Relatório de Passagem pela Oficina, Customizado conforme solicitação do chamado 68816
 PRÉ REQUISITO: RODAR O SCRIPT whRelOSNrPassagensAgend_TEXT PARA POVOAR AS TABELAS QUE ALIMENTARAM O RELATORIO
 ALTERACAO....: N/A
 OBJETIVO.....: N/A
-----------------------------------------------------------------------------------------------
FIM_CABEC_REL */

SELECT distinct Chassi,
       Cliente,
	   MarcaVeiculoOS,
	   ModeloVeiculoOS,
	   DescricaoCategoriaVeiculoOS AS 'Tipo',
	   NumeroOS,
	   CodigoCIT,
	   CASE
	   WHEN SUBSTRING(Periodo,5,6) = '01' THEN 'JAN'
	   WHEN SUBSTRING(Periodo,5,6) = '02' THEN 'FEV'
	   WHEN SUBSTRING(Periodo,5,6) = '03' THEN 'MAR'
	   WHEN SUBSTRING(Periodo,5,6) = '04' THEN 'ABR'
	   WHEN SUBSTRING(Periodo,5,6) = '05' THEN 'MAI'
	   WHEN SUBSTRING(Periodo,5,6) = '06' THEN 'JUN'
	   WHEN SUBSTRING(Periodo,5,6) = '07' THEN 'JUL'
	   WHEN SUBSTRING(Periodo,5,6) = '08' THEN 'AGO'
	   WHEN SUBSTRING(Periodo,5,6) = '09' THEN 'SET'
	   WHEN SUBSTRING(Periodo,5,6) = '10' THEN 'OUT'
	   WHEN SUBSTRING(Periodo,5,6) = '11' THEN 'NOV'
	   WHEN SUBSTRING(Periodo,5,6) = '12' THEN 'DEZ'
	   END AS Periodo,
	   CONVERT(VARCHAR,DataAbertura,3) AS 'Data Abertura',
	   CONVERT(VARCHAR,DataEncerramento,3) AS 'Data Encerramento'
 FROM tmpAnaliticoRel2016_2017 ana
 INNER JOIN tbVeiculoOS veic
 ON ana.Chassi collate Latin1_General_CS_AS = veic.ChassiVeiculoOS
 INNER JOIN tbCategoriaVeiculoOS cat
 ON veic.CodigoCategoriaVeiculoOS = cat.CodigoCategoriaVeiculoOS
 INNER JOIN tbOROSCIT cit
 ON ana.NumeroOS = cit.NumeroOROS WHERE substring(cit.CodigoCIT,1,2) = 'C1'


 --sp_helptext whRelOSNrPassagensAgend

/*
select * from sysobjects where name like 'tb%CategoriaVeiculo%'

select top 10 * from tbVeiculoOS

select * from tbCategoriaVeiculoOS

select * from tmpAnaliticoRel

select top 10 * from  tbOROSCIT
*/