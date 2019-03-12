DEF TEMP-TABLE tt-emitente LIKE emitente.
EMPTY TEMP-TABLE tt-emitente.

   FOR EACH pedido-compr where data-pedido >= 01/01/2014:
        FOR EACH emitente WHERE (emitente.cod-emitente = pedido-compr.cod-emitente ) and ( emitente.identific <> 1 ):
            FIND FIRST tt-emitente WHERE 
                tt-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
                    IF NOT AVAIL tt-emitente THEN DO.
                        CREATE tt-emitente.
                        BUFFER-COPY emitente to tt-emitente.
            END.                        
END.
END.

OUTPUT TO "c:\temp\fornecedor_2014.txt".
    FOR EACH tt-emitente :  
        DISP tt-emitente.cod-emitente   ";"
             tt-emitente.nome-abrev     ";"
             tt-emitente.e-mail         ";"
             tt-emitente.telefone[1]     ";"
             tt-emitente.telefone[2]    ";"
             tt-emitente.estado WITH WIDTH 300.
    END.
