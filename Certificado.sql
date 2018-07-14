CN=MONTES CLAROS DIESEL SA:16922601000191, OU=Certificado PJ A1, OU=AC SOLUTI Multipla, OU=AC SOLUTI, OU=Autoridade Certificadora Raiz Brasileira v2, O=ICP-Brasil, C=BR                                                                                                                                                                                                                                                                                                                                            
CN=MONTES CLAROS DIESEL SA:16922601000191, OU=AR LG CERTIFICADO DIGITAL, OU=RFB e-CNPJ A1, OU=Secretaria da Receita Federal do Brasil - RFB, O=ICP-Brasil, L=MONTES CLAROS, S=MG, C=BR

select top 20 * from  tbLog order by 1 desc

alter table tbParametro disable trigger tnu_DSPa_Parametro
go
UPDATE tbParametro set Valor ='CN=MONTES CLAROS DIESEL SA:16922601000191, OU=AR LG CERTIFICADO DIGITAL, OU=RFB e-CNPJ A1, OU=Secretaria da Receita Federal do Brasil - RFB, O=ICP-Brasil, L=MONTES CLAROS, S=MG, C=BR' where Parametro = 'CERTIFICADO' and CNPJ like '16922601%'
go
UPDATE tbParametro set Valor ='2019-07-05' where Parametro = 'DATAVALCERTIFICADO' and CNPJ like '16922601%'
go
alter table tbParametro enable trigger tnu_DSPa_Parametro

select * from tbParametro
16922601000191
select * from tbParametro where Parametro = 'CERTIFICADO' and CNPJ like '16922601%'
select * from tbParametro where Parametro = 'DATAVALCERTIFICADO' and CNPJ like '16922601%'    
‎Friday, ‎July ‎5, ‎2019 2:50:15 PM
      
select * into tbCertificadoNovo2018_M
FROM tbParametro
--select * from tbCertificadoNovo
--copia de seguranca do antigo
select * into tbCertificado2018_M
FROM tbParametro