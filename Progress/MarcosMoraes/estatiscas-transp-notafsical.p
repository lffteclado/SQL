def var nr-transp-dest as int.
def var nr-transp-df as int.

FOR EACH mgmov.nota-fiscal WHERE dt-cancela = ? AND dt-emis-nota >= 08/07/2014 : 
    disp nr-nota-fis
         nome-transp 
/*          int(ind-tp-frete) */
/*          ind-tp-frete */ with width 330.
    if nome-transp = "DESTINATARIO"
        then 
        assign nr-transp-dest = 1 + nr-transp-dest.
        else 
        assign nr-transp-df = 1 + nr-transp-df.
        
END.        

MESSAGE "Nr-transportadora DESTINATARIO " + string(nr-transp-dest) view-as alert-box.                
MESSAGE "Nr-transportadora Diferente: " + string(nr-transp-df) view-as alert-box.                
