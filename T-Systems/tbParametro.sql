select top 100 * from tbLog order by 1 desc
LerArquivos :LerArquivoTXT: ProcessaArquivoTXT: Access to the path is denied.
ProcessaArquivoTXT Erro:Access to the path '\\192.168.1.19\NFE\NFEDEALERS\NFEXML\31110402618214000151550010000066381705547512-nfe.xml' is denied.
select * from tbParametro
select * into tbParametroNovo from tbParametro
select * into tbParametroNovo1 from tbParametro
select * into tbParametroNovo20_04_2011 from tbParametro
alter table tbParametro disable trigger tnu_DSPa_Parametro
alter table tbParametro enable trigger tnu_DSPa_Parametro
update tbParametro set Valor ='\\192.168.1.19\NFE\NFEDEALERS\NFEXML'where Parametro = 'NFEXML'
go
update tbParametro set Valor ='\\192.168.1.19\NFE\NFEDEALERS\NFETXT'where Parametro = 'NFETXT'
go
update tbParametro set Valor ='\\192.168.1.19\NFE\NFEDEALERS\NFEBACKUP'where Parametro = 'NFEBACKUP'
go
update tbParametro set Valor ='\\192.168.1.19\NFE\NFEDEALERS\NFESCHEMAS'where Parametro = 'NFESCHEMAS'
go
update tbParametro set Valor ='\\192.168.1.19\NFE\NFEDEALERS\NFERETORNOXML'where Parametro = 'NFERETORNOXML'

\\TMASTER\NFE\NFEDEALERS\NFEXML \\192.168.1.19\NFE\NFEDEALERS\NFEXML
\\TMASTER\NFE\NFEDEALERS\NFETXT  \\192.168.1.19\NFE\NFEDEALERS\NFETXT
\\TMASTER\NFE\NFEDEALERS\NFEBACKUP  \\192.168.1.19\NFE\NFEDEALERS\NFEBACKUP
\\TMASTER\NFE\NFEDEALERS\NFESCHEMAS  \\192.168.1.19\NFE\NFEDEALERS\NFESCHEMAS
\\TMASTER\NFE\NFEDEALERS\NFERETORNOXML \\192.168.1.19\NFE\NFEDEALERS\NFERETORNOXML 
select * from tbParametro
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
insert tbParametro select tbParametroNovo.CNPJ,tbParametroNovo.Parametro,
tbParametroNovo.Valor,tbParametroNovo.Dt_Atualizacao from tbParametroNovo











