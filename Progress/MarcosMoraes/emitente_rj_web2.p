output to "c:\temp\emitente_114_quarta_18horas.txt".
    /* Defini‡äs de vari veis */
    def var ecount as int init 0.
    def var rjcount as int init 0.
    def var oucount as int init 0.
    def var total as int init 0.


        put "Cod-Cliente;Nome-Cliente;Estado-Cliente;Cidade-Cliente;Micro-Regiao-Cliente;Transportadora".
                    
                    FOR EACH emitente WHERE (emitente.identific = 1 or emitente.identific = 3) AND (emitente.cod-transp = 556  OR emitente.cod-transp = 268 ):
                             disp cod-emitente        ";"
                                  emitente.nome-abrev ";"
                                  emitente.estado     ";"
                                  emitente.cidade    ";"
                                  emitente.nome-mic-reg  ";"
                                  emitente.cod-transp with width 330.
                                  ecount = 1 + ecount.

                            assign emitente.cod-transp = 114.
  
end.         
output close.
            
/* message "Numero de cliente cidade BARUERI - RISSO :" + string(rjcount) view-as alert-box. */
message "Total :" + string(ecount) view-as alert-box.
