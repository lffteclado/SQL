output to "c:\temp\cre.txt".
def var i as int.
assign i = 0.
put "Listagem de Clientes X Representantes - E-mail".

for each emitente where emitente.identific <> 2 and emitente.e-mail = "" :
    for each repres where repres.cod-rep = emitente.cod-rep :
        disp i
             emitente.cod-emitente
             emitente.nome-abrev
             emitente.e-mail
             emitente.cod-rep
             repres.nome
             repres.e-mail with width 300.
        i = 1 + i.     
                     
