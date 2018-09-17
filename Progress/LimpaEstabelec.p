DEFINE VARIABLE c-cod-estabel AS CHARACTER 
LABEL "Estabel a Ser Eliminado (Config TSS - CD0403b)" FORMAT "x(3)" NO-UNDO.
UPDATE c-cod-estabel.

FOR EACH param-nf-estab EXCLUSIVE-LOCK
WHERE param-nf-estab.cod-estabel = c-cod-estabel:
DELETE param-nf-estab.

END.

MESSAGE 'Processo Conclu¡do!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
