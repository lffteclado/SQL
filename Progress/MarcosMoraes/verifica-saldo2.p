FOR EACH ped-venda NO-LOCK
    where PED-VENDA.NR-PEDIDO = 689813:
        disp PED-VENDA.NR-PEDIDO PED-VENDA.cod-sit-aval PED-VENDA.cod-sit-com int(PED-VENDA.cod-sit-ped).



/* def var i-total as dec. */
/*    */
/* 						FOR EACH ped-venda NO-LOCK */
/* 							WHERE (ped-venda.tp-pedido = "4" OR */
/* 								 ped-venda.tp-pedido = "1") AND */
/* 							(ped-venda.cod-sit-ped = 5 OR */
/* 							 ped-venda.cod-sit-ped = 1 OR */
/* 							 ped-venda.cod-sit-ped = 2) AND */
/* 							 ped-venda.cod-priori = 01 : */
/*    */
/*    */
/*                                            FOR EACH ht-ext-ped-venda */
/*                                                where ht-ext-ped-venda.nr-pedido = ped-venda.nr-pedido and */
/*                                                ht-ext-ped-venda.log-integrado-sgt <> yes : */
/*    */
/*    */
/*    */
/*    */
/* 						FOR EACH ped-item */
/* 					          WHERE ped-item.nr-pedcli = ped-venda.nr-pedcli AND */
/* 						         ped-item.nome-abrev = ped-venda.nome-abrev AND */
/* 							  ped-item.it-codigo = 'D01DB.DNT03.02' AND */
/* 						        (ped-item.cod-sit-item = 1 OR ped-item.cod-sit-item = 2 OR ped-item.cod-sit-item = 5) NO-LOCK: */
/*    */
/* 							ASSIGN i-total = i-total + qt-pedida. */
/*    */
/*    */
/* 					           DISP PED-VENDA.NOME-ABREV PED-VENDA.NR-PEDCLI PED-VENDA.cod-sit-aval PED-VENDA.cod-sit-com PED-VENDA.NR-PEDIDO ht-ext-ped-venda.log-integrado. */
/*    */
/*    */
/* 						END. */
/*    */
/* 						END. */
/*    */
/*    */
/*    */
/*  END. */
/*    */
/*  MESSAGE I-TOTAL VIEW-AS ALERT-BOX. */
