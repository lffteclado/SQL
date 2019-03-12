def var dt as date.
FOR each emitente where emitente.cod-emitente = 34085 and emitente.ind-aval <> 1:
    disp ind-aval.
assign dt = today.    
 FOR EACH titulo where titulo.cod-emitente = 34085 :
        if titulo.dt-vecto-orig < dt and dt-ult-pagto = ? then
        disp titulo.dt-vecto-orig 
             titulo.dt-ult-pagto
              today.
