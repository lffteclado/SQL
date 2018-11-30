/* Relatorio Josi - Faturamento ( cliente - represetante - metros faturado - valor faturado ) */
def var contador as int.
output to "c:\temp\teste_josi.txt".
FOR EACH it-nota-fisc where (it-nota-fisc.dt-emis-nota >= 01/01/2014 ) and (it-nota-fisc.dt-emis-nota <= 12/31/2014 ) and ( it-nota-fisc.dt-cancela = ? )and ((substr(it-nota-fisc.it-codigo,1,1) = 'D') and 
(substr(it-nota-fisc.it-codigo,1,2) <> 'DD')):
    FOR EACH emitente WHERE emitente.cod-emitente = it-nota-fisc.cd-emitente :
        FOR EACH repres WHERE repres.cod-rep = emitente.cod-rep :
       disp contador ";"
            cd-emitente ";"
            emitente.nome-abrev ";"
            repres.nome         ";"
            it-nota-fisc.it-codigo ";"
            it-nota-fisc.qt-faturada ";"
            it-nota-fisc.vl-tot-item ";"
            it-nota-fisc.dt-emis-nota with width 300.
assign contador = 1 + contador.        
        END.
    END.
END.
output close.












/* DEF TEMP-TABLE tt-emitente LIKE emitente. /*cria tabela temporaria */ */
/* EMPTY TEMP-TABLE tt-emitente.  /* esvazia a tabela */ */
/*    */
/* FOR EACH nota-fiscal WHERE dt-emis-nota >= 01/01/2013: */
/*     FOR EACH emitente WHERE (emitente.cod-emitente = nota-fiscal.cod-emitente) and ( emitente.identific <> 2 ): */
/*           FIND FIRST tt-emitente WHERE */
/*         tt-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR. */
/*         IF NOT AVAIL tt-emitente THEN DO. */
/*             CREATE tt-emitente. */
/*             BUFFER-COPY emitente TO tt-emitente. */
/*         END. */
/*     END. */
/*    */
/* END. */
/*    */
/*    */
/*    */
/* OUTPUT TO "c:\temp\clientes_2013.txt". */
/*    */
/*   FOR EACH tt-emitente : */
/*     FOR EACH repres where repres.cod-rep =  tt-emitente.cod-rep: */
/*          DISP tt-emitente.cod-emitente ";" */
/*            tt-emitente.nome-abrev   ";" */
/*            tt-emitente.e-mail       ";" */
/*            tt-emitente.telefon[1]   ";" */
/*            tt-emitente.telefone[2]  ";" */
/*            tt-emitente.estado       ";" */
/*            repres.nome     ";" */
/*            tt-emitente.cidade WITH WIDTH 300. */
/*   END. */
/* END. */
/*    */
/* OUTPUT CLOSE. */
