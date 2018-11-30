DEF TEMP-TABLE tt-emitente LIKE emitente. /*cria tabela temporaria */
EMPTY TEMP-TABLE tt-emitente. /* esvazia a tabela */

FOR EACH nota-fiscal WHERE dt-emis-nota >= 07/14/2011:
    FOR EACH emitente WHERE emitente.cod-emitente = nota-fiscal.cod-emitente :
        FIND FIRST tt-emitente WHERE
                   tt-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-emitente THEN DO.
            CREATE tt-emitente.
            BUFFER-COPY emitente TO tt-emitente.
        END.
    END.
END.

    

OUTPUT TO "c:\temp\clientes_2013.txt".

  FOR EACH tt-emitente NO-LOCK.
       DISP tt-emitente.cod-emitente ";"
           tt-emitente.nome-abrev   ";"
           tt-emitente.estado       ";"
           tt-emitente.cidade       ";"
           tt-emitente.endereco     ";"
           tt-emitente.bairro       ";"
           tt-emitente.cep          ";"
           tt-emitente.e-mail       ";"
           tt-emitente.telefon[1]   ";"
           tt-emitente.telefone[2]  ";"
           tt-emitente.cod-rep WITH WIDTH 300.
  END.


OUTPUT CLOSE.
