def var est as CHARACTER FORMAT "x(3)".
def var ser as CHARACTER FORMAT "x(2)".
DEF VAR nt AS CHARACTER FORMAT "x(7)".
DEF VAR sit-e AS INT.

disp "Estabelecimento | Serie | Nota".
    update est.
    update ser.
    update nt.

for each nota-fiscal where nota-fiscal.cod-estabel = est
                       and nota-fiscal.serie = ser
                       and nota-fiscal.nr-nota-fis = nt.
    for each sit-nf-eletro where sit-nf-eletro.cod-estabel = nota-fiscal.cod-estabel
                                and sit-nf-eletro.cod-serie = nota-fiscal.serie
                                and sit-nf-eletro.cod-nota-fisc = nota-fiscal.nr-nota-fis:

                        disp nota-fiscal.cod-estabel
                             nota-fiscal.serie
                             nota-fiscal.nr-nota-fis
                             nota-fiscal.dt-cancela
                             int(sit-nf-eletro.idi-sit-nf-eletro) with width 300.

disp "situcao 1 - ? | 2 - ? | 3 - Autorizado | 4 - ? | 5 - Rejeitado | 6 - Cancealdo | 7 - Inutilizado ".
update sit-e.
 assign sit-nf-eletro.idi-sit-nf-eletro = sit-e. 
        if idi-sit-nf-eletro = 3
            then
                       assign nota-fiscal.dt-cancela = ?.
                       end.
                       end.
    


