/* Relatorio gerado para Fagner */
def var contador as int.
def var soma as int.
output to "c:\temp\faturamento_D47DB.txt".
put "C¢digo do item ; N£mero da nota Fiscal ; Quantidade Faturada ; Data de EmissÆo ; data de cancelamento".
    for each it-nota-fisc where (it-nota-fisc.dt-emis-nota >= 01/01/2012) and (it-nota-fisc.dt-emis-nota <= 06/09/2014) and (it-nota-fisc.dt-cancela = ?) and ((substr(it-nota-fisc.it-codigo,1,5) = 'D47DB') and 
    (substr(it-nota-fisc.it-codigo,1,2) <> 'DD')):
    disp contador   ';'
    it-nota-fisc.it-codigo  ';'
    nr-nota-fis     ';'
    qt-faturada[1]  ';'
/*     it-nota-fisc.vl-tot-item    ';' */
    it-nota-fisc.dt-emis-nota   ';'
    it-nota-fisc.dt-cancela with width 300.
    assign contador = 1 + contador
           soma = soma + qt-faturada[1].
end.
put "TOTAL : " soma.
message "Processamento conclu¡do" view-as alert-box.
