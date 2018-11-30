output to "c:\temp\periodo_atrado_gurpo_1_grupo_2.txt".
FOR EACH emitente where (cod-gr-cli = 1) or (cod-gr-cli = 4):
  assign nr-peratr = 12.
  disp cod-emitente
       cod-gr-cli
       nome-abrev
       nr-peratr with width 300 .
END.       
output close.
       
