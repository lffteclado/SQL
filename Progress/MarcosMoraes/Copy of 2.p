DEF TEMP-TABLE tt-emitenteM like emitente.    
EMPTY TEMP-TABLE tt-emitenteM.
DEF VAR i as INT.
DEF VAR CONT-CONT as INT.
DEF VAR CN as INT.

   FOR EACH nota-fiscal WHERE dt-emis-nota >= 01/01/2013:
        FOR EACH emitente WHERE 
                         emitente.cod-emitente = nota-fiscal.cod-emitente
                         AND emitente.identific <> 2 
                         AND emitente.e-mail <> "" :
            FIND FIRST tt-emitenteM WHERE 
                            tt-emitenteM.cod-emitente = emitente.cod-emitente
                             NO-LOCK NO-ERROR.
                IF NOT AVAIL tt-emitenteM THEN DO.
                    CREATE tt-emitenteM.
                    BUFFER-COPY emitente TO tt-emitenteM.
                    assign i = i + 1.
                END.
            END.
        END.

message "FIM DA TEMP TABLE" view-as alert-box.
message "NUMERO DE REGISTROS CRIADOS: " + string(i) view-as alert-box.
OUTPUT TO "c:\temp\emitente_antes_da_inclusao_dos_contatos.txt".
                FOR EACH tt-emitenteM :
                FOR EACH transporte WHERE transporte.cod-emitente = tt-emitenteM.cod-emitente :
                disp tt-emitenteM.cod-emitente ";"
                tt-emitenteM.nome-abrev ";"                        
                tt-emitenteM.e-mail ";"
                transporte.cod-emitente ";"
                transporte.nome ";"
                transporte.e-mail with width 300.
                END.        
                END.
OUTPUT CLOSE.                

MESSAGE "INICIO DE ANALISE DE CONTATOS" view-as alert-box.
    FOR EACH tt-emitenteM :
        FIND FIRST transporte WHERE transporte.cod-emitente = tt-emitenteM.cod-emitente NO-ERROR.
            IF NOT AVAIL transporte THEN DO:
                   ASSIGN CONT-CONT = CONT-CONT + 1.
                   CREATE transporte.
                   ASSIGN transporte.cod-emitente = tt-emitenteM.cod-emitente
                            transporte.sequencia = 10
                            transporte.nome = tt-emitenteM.nome-abrev
                            transporte.e-mail = tt-emitenteM.e-mail.
                END.   
                ELSE DO:
                    IF transporte.e-mail = "" THEN
                        ASSIGN CN = CN + 1.
                        ASSIGN transporte.e-mail = tt-emitenteM.e-mail.
                    END.                     


        END.                            
        MESSAGE "REGISTROS INCLUIDOS :" + string(CONT-CONT) view-as alert-box.
        MESSAGE "CONTATOS SEM EMAIL : " + string (CN) view-as alert-box.

MESSAGE "Lista Alteracoes" VIEW-AS ALERT-BOX.
   
OUTPUT TO "c:\temp\alteracoes_contatos_email.txt".   
FOR EACH tt-emitenteM:
    FOR EACH transporte WHERE transporte.cod-emitente = tt-emitenteM.cod-emitente:
        DISP tt-emitenteM.cod-emitente ";"
            tt-emitenteM.nome-abrev ";"
            tt-emitenteM.e-mail ";"
            transporte.cod-emitente ";"
            transporte.nome ";"
            transporte.e-mail WITH WIDTH 300.
    END.
END.                
OUTPUT CLOSE.
        
    
                           
                    
