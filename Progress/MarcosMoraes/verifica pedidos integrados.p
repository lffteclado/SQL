/*cod-sit-ped 6  cancelado 5 supsenso 1 aberto  */
output to "c:\temp\pedidos_nao_integrados.txt".
put "integrado;nr-pedido;situa‡Æo do pedido;dt-implant".
FOR EACH ped-venda NO-LOCK
     WHERE (dt-implant >= 01/01/2014) and cod-sit-ped <> 6 and cod-sit-ped <> 3 :
            for each ht-ext-ped-venda where nr-pedido = ped-venda.nr-pedido 
            and log-integrado-sgt <> yes: 
disp log-integrado-sgt   ";"
    nr-pedido           ";"
    int(cod-sit-ped)";"
    dt-implant with width 300.   

end.
end.
output close.










