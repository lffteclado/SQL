DEF TEMP-TABLE tt-emitente LIKE emitente. /*cria tabela temporaria */
EMPTY TEMP-TABLE tt-emitente.  /* esvazia a tabela */
disable triggers for load of cont-emit.
FOR EACH nota-fiscal WHERE dt-emis-nota >= 05/01/2015:                                                                 
    FOR EACH emitente WHERE (emitente.cod-emitente = nota-fiscal.cod-emitente) and ( emitente.identific <> 2 ):        
          FIND FIRST tt-emitente WHERE                                                                                 
        tt-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-emitente THEN DO.                                                                              
            CREATE tt-emitente.
            BUFFER-COPY emitente TO tt-emitente.
        END.
    END.
  
END.

/* FIND FIRST EMITENTE WHERE EMITENTE.COD-EMITENTE = 34845. */
/*             CREATE tt-emitente. */
/*             BUFFER-COPY emitente TO tt-emitente. */

                                                                                                               
OUTPUT TO "c:\temp\clientes_2013.txt".

  FOR EACH tt-emitente where tt-emitente.e-mail <> "" :                       
  
  
      FIND FIRST cont-emit NO-ERROR. /* WHERE cont-emit.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.       */
      
          IF NOT AVAIL cont-emit THEN DO:
  
            CREATE cont-emit.
            ASSIGN cont-emit.cod-emitente = emitente.cod-emitente
                   cont-emit.e-mail       = tt-emitente.e-mail
                   cont-emit.sequencia    = 1
                   cont-emit.nome         = tt-emitente.nome-abrev.
  
      END.
      ELSE DO:
  
            IF cont-emit.e-mail = '' THEN
                cont-emit.e-mail = tt-emitente.e-mail.
                  END.

            DISP tt-emitente.cod-emitente   ";"                                                   
                 tt-emitente.nome-abrev     ";"
                 cont-emit.cod-emitente ";"
                 cont-emit.sequencia    ";"
                 cont-emit.e-mail with width 300.
                 
  
  /*
    FOR EACH cont-emit: /* where cont-emit.cod-emitente =  tt-emitente.cod-emitente : */
            if cont-emit.e-mail = "" then do:
            disp 'vazio'.
        end.
         DISP tt-emitente.e-mail       ";"
               tt-emitente.nome-abrev   ";"
                        tt-emitente.cod-emitente .

  END.
  */
  
END.

OUTPUT CLOSE.
