def var w-tp-de-para as char no-undo.
def var c-empresa as char initial "104" no-undo.

for each emitente no-lock /* where emitente.cgc = "" */ :

    for each estabelecimento no-lock:
        
        FIND FIRST trad_org_ext NO-LOCK
             WHERE trad_org_ext.cod_matriz_trad_org_ext = "EMS2"
               AND trad_org_ext.cod_tip_unid_organ      = "999"
               AND trad_org_ext.cod_unid_organ_ext      = estabelecimento.cod_estab NO-ERROR.
        
        IF emitente.identific = 1 THEN DO:
            ASSIGN w-tp-de-para = 'cliente'.
            FIND FIRST es_de_para_edifact NO-LOCK
                 WHERE es_de_para_edifact.tp_de_para     = w-tp-de-para
                   AND es_de_para_edifact.cod_empresa    = (IF AVAIL trad_org_ext THEN trad_org_ext.cod_unid_organ ELSE c-empresa)
                   AND es_de_para_edifact.DESC_de        = emitente.cgc NO-ERROR.
            IF NOT AVAIL es_de_para_edifact AND AVAIL emitente THEN DO:
                CREATE es_de_para_edifact.
                ASSIGN es_de_para_edifact.tp_de_para    = w-tp-de-para
                       es_de_para_edifact.cod_empresa   = (IF AVAIL trad_org_ext THEN trad_org_ext.cod_unid_organ ELSE c-empresa)
                       es_de_para_edifact.DESC_de       = emitente.cgc
                       es_de_para_edifact.DESC_para     = string(emitente.cod-emitente).
            END.
        END.
        ELSE IF emitente.identific = 2 THEN DO:
            ASSIGN w-tp-de-para = 'fornecedor'.
            FIND FIRST es_de_para_edifact NO-LOCK
                 WHERE es_de_para_edifact.tp_de_para     = w-tp-de-para
                   AND es_de_para_edifact.cod_empresa    = (IF AVAIL trad_org_ext THEN trad_org_ext.cod_unid_organ ELSE c-empresa)
                   AND es_de_para_edifact.DESC_de        = emitente.cgc NO-ERROR.
            IF NOT AVAIL es_de_para_edifact AND AVAIL emitente THEN DO:
                CREATE es_de_para_edifact.
                ASSIGN es_de_para_edifact.tp_de_para    = w-tp-de-para
                       es_de_para_edifact.cod_empresa   = (IF AVAIL trad_org_ext THEN trad_org_ext.cod_unid_organ ELSE c-empresa)
                       es_de_para_edifact.DESC_de       = emitente.cgc
                       es_de_para_edifact.DESC_para     = string(emitente.cod-emitente).
            END.    
        END.
        ELSE DO:
            ASSIGN w-tp-de-para = 'cliente'.
            FIND FIRST es_de_para_edifact NO-LOCK
                 WHERE es_de_para_edifact.tp_de_para     = w-tp-de-para
                   AND es_de_para_edifact.cod_empresa    = (IF AVAIL trad_org_ext THEN trad_org_ext.cod_unid_organ ELSE c-empresa)
                   AND es_de_para_edifact.DESC_de        = emitente.cgc NO-ERROR.
            IF NOT AVAIL es_de_para_edifact AND AVAIL emitente THEN DO:
                CREATE es_de_para_edifact.
                ASSIGN es_de_para_edifact.tp_de_para    = w-tp-de-para
                       es_de_para_edifact.cod_empresa   = (IF AVAIL trad_org_ext THEN trad_org_ext.cod_unid_organ ELSE c-empresa)
                       es_de_para_edifact.DESC_de       = emitente.cgc
                       es_de_para_edifact.DESC_para     = string(emitente.cod-emitente).
            END.    
            ASSIGN w-tp-de-para = 'fornecedor'.
            FIND FIRST es_de_para_edifact NO-LOCK
                 WHERE es_de_para_edifact.tp_de_para     = w-tp-de-para
                   AND es_de_para_edifact.cod_empresa    = (IF AVAIL trad_org_ext THEN trad_org_ext.cod_unid_organ ELSE c-empresa)
                   AND es_de_para_edifact.DESC_de        = emitente.cgc NO-ERROR.
            IF NOT AVAIL es_de_para_edifact AND AVAIL emitente THEN DO:
                CREATE es_de_para_edifact.
                ASSIGN es_de_para_edifact.tp_de_para    = w-tp-de-para
                       es_de_para_edifact.cod_empresa   = (IF AVAIL trad_org_ext THEN trad_org_ext.cod_unid_organ ELSE c-empresa)
                       es_de_para_edifact.DESC_de       = emitente.cgc
                       es_de_para_edifact.DESC_para     = string(emitente.cod-emitente).
            END.    
        END.        
        
    end.
    
end.
