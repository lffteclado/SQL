DEF VAR sit as int.
DEF VAR sit-ped as int.
DEF VAR cod as CHARACTER FORMAT "x(30)".
DEF VAR emit as int.
DEF VAR pedido as int.
update emit.
update pedido.
FOR EACH ped-venda where cod-emitente = emit and nr-pedido = pedido :
    disp ped-venda.cod-sit-ped with width 300.
        if int(ped-venda.cod-sit-ped) <> 3 then do:
        update sit-ped.
        assign ped-venda.cod-sit-ped = sit-ped.
        end.
    update cod.
    FOR EACH ped-item where ped-item.nr-pedcli = ped-venda.nr-pedcli 
                            AND ped-item.it-codigo = cod :
        disp ped-item.it-codigo
            ped-item.qt-pedida.
            update ped-item.qt-atendida.
            
            disp ped-item.cod-sit-item with width 300.
        if int(ped-item.cod-sit-item) <> 3 then do :
            update sit.
            assign ped-item.cod-sit-item = sit.
            end.     
END.
END.       
