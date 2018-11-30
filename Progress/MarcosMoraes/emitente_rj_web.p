output to "c:\temp\emitente_rj.txt".
def var ecount as int init 0.
def var rjcount as int init 0.
def var oucount as int init 0.
def var total as int init 0.
put "Cod-Cliente;Nome-Cliente;Estado-Cliente;Cidade-Cliente;Micro-Regiao-Cliente;Transportadora".
for each emitente where (emitente.identific = 1 or emitente.identific = 3) and (emitente.estado = 'rj') :
    disp cod-emitente        ";"
         emitente.nome-abrev ";"
         emitente.estado     ";"
         emitente.cidade    ";"
         emitente.nome-mic-reg  ";"
         emitente.cod-transp with width 330.
       ecount = 1 + ecount.
    if emitente.cidade = "Rio de Janeiro" or emitente.cidade = "Belford Roxo" or emitente.cidade = "Duque de Caxias" or emitente.cidade = "Niteroi" or emitente.cidade = "Nova Igua‡u" or emitente.cidade = "SÆo Gon‡alo" or emitente.cidade = "SÆo JoÆo de Meriti" or emitente.cidade = "Queimados"
      then
      assign rjcount = rjcount + 1
             emitente.cod-transp = 350.
      else
      assign oucount =  oucount + 1
             emitente.cod-transp = 253.
  
  
total = rjcount + oucount.
  
end.         
output close.
message "Numero de cliente RJ :" + string(ecount) view-as alert-box.              
message "Numero de cliente cidade Rio de Janeiro :" + string(rjcount) view-as alert-box.
message "Total :" + string(total) view-as alert-box.
