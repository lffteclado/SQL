FOR EACH ped-venda WHERE ped-venda.nome-abrev = "OUSADO M CEN" AND ped-venda.nr-pedcli = "060-00011X15" :
    FOR EACH ped-item where ped-item.nr-pedcli = ped-venda.nr-pedcli
                        AND ped-item.it-codigo = "D56AZ.DN003.01":
        disp ped-item.it-codigo.
          update ped-item.cod-refer.
          
END.
END.                                  
