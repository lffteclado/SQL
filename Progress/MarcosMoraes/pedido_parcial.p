OUTPUT TO "c:\temp\pedidos_abertos.txt".
def var i as int.
FOR EACH PED-VENDA where PED-VENDA.nr-pedido = 690942
                     

/* ASSIGN ped-venda.cod-estabel = "3".          */
ASSIGN i = i + 1.
        disp i
        ped-venda.cod-estabel
         ped-venda.nome-abrev
         ped-venda.nr-pedido
         string(ped-venda.nr-pedcli)
         string(ped-venda.cod-sit-ped).

  
END.
output close.
