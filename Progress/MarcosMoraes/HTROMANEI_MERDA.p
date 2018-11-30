FOR EACH ht-romaneio where  ht-romaneio.nr-pedido = 691742 : 
if cod-refer = "" then do :
 disp nr-pedido 
       it-codigo 
       cod-refer.
 update ht-romaneio.cod-refer.       
       end.
           
END.       
           
