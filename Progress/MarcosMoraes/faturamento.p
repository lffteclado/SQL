/* Relatorio gerado para Fagner */
def var contador as int.
output to "c:\temp\faturamento_maio.txt".
put "C¢digo do item ; N£mero da nota Fiscal ; Quantidade Faturada ; Data de EmissÆo ; data de cancelamento".
    for each it-nota-fisc where (it-nota-fisc.dt-emis-nota >= 05/01/2014) and (it-nota-fisc.dt-emis-nota <= 05/31/2014) and (it-nota-fisc.dt-cancela = ?) and ((substr(it-nota-fisc.it-codigo,1,1) = 'D') and 
    (substr(it-nota-fisc.it-codigo,1,2) <> 'DD')):
    disp contador   ';'
    it-nota-fisc.it-codigo  ';'
    nr-nota-fis     ';'
    qt-faturada[1]  ';'
    it-nota-fisc.vl-tot-item    ';'
    it-nota-fisc.dt-emis-nota   ';'
    it-nota-fisc.dt-cancela with width 300.
    contador = 1 + contador.
end.
message "Processamento conclu¡do" view-as alert-box.
