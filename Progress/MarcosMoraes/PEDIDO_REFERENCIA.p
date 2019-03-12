FOR EACH PED-VENDA WHERE NR-PEDIDO = 691727:
   FOR EACH PED-ITEM WHERE PED-ITEM.nr-pedcli = PED-VENDA.nr-pedcli 
                            AND ped-item.it-codigo = "d56az.dn003.01" :
assign ped-item.cod-refer = "ROLO".                             
                            
                            
    disp ped-item.it-codigo
         ped-venda.nome-abrev
         cod-refer.
         
