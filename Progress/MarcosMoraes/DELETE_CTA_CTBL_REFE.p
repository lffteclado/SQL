disable triggers for load of cta-ctbl-refer.
   for each cta-ctbl-refer:
   delete cta-ctbl-refe.
   end.
  

disable triggers for load of dwf-cta-ctbl-refer.
   
for each dwf-cta-ctbl-refer where cod-empresa = '1' :
   delete dwf-cta-ctbl-refe.
   disp dwf-cta-ctbl-refer.cod-empresa
        dwf-cta-ctbl-refer.cod-cta-ctbl.

   end.
   

