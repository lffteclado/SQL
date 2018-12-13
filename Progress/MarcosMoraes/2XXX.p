DEF TEMP-TABLE tt-emitente LIKE emitente.
EMPTY TEMP-TABLE tt-emitente.
/*    */
FOR EACH nota-fiscal WHERE dt-emis-nota >= 05/01/2015 :
    FOR EACH emitente WHERE (emitente.cod-emitente = nota-fiscal.cod-emitente) and ( emitente.identific <> 2 )
              AND emitente.e-mail <> "" :
          FIND FIRST tt-emitente WHERE
        tt-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-emitente THEN DO.
            CREATE tt-emitente.
            BUFFER-COPY emitente TO tt-emitente.
        END.
    END.
  
END.

/* FIND FIRST EMITENTE. */
/*             CREATE tt-emitente. */
/*             BUFFER-COPY emitente TO tt-emitente. */

                                                                                                               
/* OUTPUT TO "c:\temp\clientes_2013.txt". */
    

      message "to entrando" view-as alert-box.

FOR EACH tt-emitente :
      message "to entrei" view-as alert-box.

/*       FIND FIRST cont-emit WHERE cont-emit.cod-emitente = tt-emitente.cod-emitente NO-LOCK NO-ERROR.    */

      FIND FIRST cont-emit WHERE cont-emit.cod-emitente = tt-emitente.cod-emitente NO-LOCK NO-ERROR.   

          IF NOT AVAIL cont-emit THEN DO:
  
            CREATE cont-emit.
            ASSIGN cont-emit.cod-emitente = emitente.cod-emitente
                   cont-emit.e-mail       = tt-emitente.e-mail
                   cont-emit.sequencia    = 1
                   cont-emit.nome         = tt-emitente.nome-abrev.
                   
                     message "teste" + string(cont-emit.e-mail) view-as alert-box.

  
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
                 
  
 
  
END.
/* OUTPUT CLOSE. */
