FOR EACH wpv-pedido where wpv-pedido.nr_pedido = 691413 :
    FIND first ped-venda WHERE ped-venda.nr-pedido = wpv-pedido.nr_pedido NO-LOCK NO-ERROR.
         disp ped-venda.nr-pedido
              wpv-pedido.nr_pedido
              ped-venda.nr-pedcli.
FOR EACH nota-fiscal WHERE nota-fiscal.nr-pedcli = ped-venda.nr-pedcli
                      AND nota-fiscal.cod-emitente = ped-venda.cod-emitente:
    disp ped-venda.nr-pedcli
         nota-fiscal.nr-pedcli
         nota-fiscal.nr-nota-fis.
         
 FOR EACH wpv-pedido-item OF wpv-pedido NO-LOCK.
 
 FOR EACH it-nota-fisc WHERE it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis 
                                AND it-nota-fisc.it-codigo = wpv-pedido-item.item :


      FIND FIRST ped-item WHERE ped-item.it-codigo = wpv-pedido-item.item 
                    AND ped-item.nr-pedcli = wpv-pedido-item.nr-pedcli
                    AND ped-item.nome-abrev = wpv-pedido-item.nome-abrev
                    AND ped-item.nr-sequencia = wpv-pedido-item.nr-sequencia
                    NO-LOCK NO-ERROR.

                                                                                    

        disp ped-item.it-codigo
        it-nota-fisc.it-codigo  .
             

                    
         
         






/*     FOR EACH wpv-pedido NO-LOCK */
/*         WHERE wpv-pedido.cod-estab     >= tt-param.cod-estabel-ini */
/*         AND   wpv-pedido.cod-estab     <= tt-param.cod-estabel-fim */
/*         AND   wpv-pedido.nr_pedido     >= tt-param.nr-pedido-ini */
/*         AND   wpv-pedido.nr_pedido     <= tt-param.nr-pedido-fim */
/*         AND   wpv-pedido.dt-implant    >= tt-param.dt-implant-ini */
/*         AND   wpv-pedido.dt-implant    <= tt-param.dt-implant-fim */
/*         AND   wpv-pedido.cod-emitente  >= tt-param.cod-emitente-ini */
/*         AND   wpv-pedido.cod-emitente  <= tt-param.cod-emitente-fim */
/*         AND   wpv-pedido.tp-pedido     >= tt-param.tp-pedido-ini */
/*         AND   wpv-pedido.tp-pedido     <= tt-param.tp-pedido-fim */
/*         AND   wpv-pedido.perc-desco1   >= tt-param.perc-desco1-ini */
/*         AND   wpv-pedido.perc-desco1   <= tt-param.perc-desco1-fim: */
/*    */
/*         FIND FIRST emitente WHERE emitente.cod-emitente = wpv-pedido.cod-emitente NO-LOCK NO-ERROR. */
/*         FIND FIRST ped-venda WHERE ped-venda.nr-pedido = wpv-pedido.nr_pedido NO-LOCK NO-ERROR. */
/*         FOR EACH nota-fiscal WHERE nota-fiscal.nr-pedcli = ped-venda.nr-pedcli */
/*                                AND nota-fiscal.dt-cancela = ? */
/*                                AND nota-fiscal.dt-emis-nota >= tt-param.dt-fat-ini */
/*                                AND nota-fiscal.dt-emis-nota <= tt-param.dt-fat-fim  NO-LOCK: */
/*         FIND FIRST it-nota-fisc WHERE it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis */
/*                                 AND it-nota-fisc.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR. */


/*  FIND FIRST ped-item WHERE ped-item.it-codigo = wpv-pedido-item.item */
/*                     AND ped-item.nr-pedcli = wpv-pedido-item.nr-pedcli */
/*                     AND ped-item.nome-abrev = wpv-pedido-item.nome-abrev */
/*                     AND ped-item.nr-sequencia = wpv-pedido-item.nr-sequencia */
/*                     NO-LOCK NO-ERROR. */
                    
