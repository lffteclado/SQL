def var i-total as dec.

						FOR EACH ped-venda NO-LOCK
							WHERE (ped-venda.tp-pedido = "4" OR
								 ped-venda.tp-pedido = "1") AND
							(ped-venda.cod-sit-ped = 5 OR
							 ped-venda.cod-sit-ped = 1 OR
							 ped-venda.cod-sit-ped = 2) AND
							 ped-venda.cod-priori = 01 :
						
						
						
						FOR EACH ped-item
					          WHERE ped-item.nr-pedcli = ped-venda.nr-pedcli AND
						         ped-item.nome-abrev = ped-venda.nome-abrev AND
							  ped-item.it-codigo = 'D01AZ.DNT03.02' AND
						        (ped-item.cod-sit-item = 1 OR ped-item.cod-sit-item = 2 OR ped-item.cod-sit-item = 5) NO-LOCK:

							ASSIGN i-total = i-total + qt-pedida.
					
					           DISP PED-VENDA.NOME-ABREV PED-VENDA.NR-PEDCLI .
							
						END.
						
 END.
 
 MESSAGE I-TOTAL VIEW-AS ALERT-BOX.
