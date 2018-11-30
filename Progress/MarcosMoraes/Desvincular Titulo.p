/***************************************************
** BUSCAR VINCULO - Comentar antes de deletar.
*****************************************************/
for each ht-ext-titulo no-lock
 where ht-ext-titulo.nr-docto = "0022719" /* Numero do titulo */
   and ht-ext-titulo.parcela = "01"       /* Parcela */
   and ht-ext-titulo.cod-estabel = "1"    /* Estabelecimento */
   and ht-ext-titulo.cod-esp = "DP"       /* Especie */
   and ht-ext-titulo.serie = "2" :        /* Serie */
  
       disp ht-ext-titulo with 1 col.
  
end.





/***************************************************
** DELTEAR VINCULO - Descomentar antes de deletar
****************************************************/
/* for each ht-ext-titulo */
/*  where ht-ext-titulo.nr-docto = "0022719" */
/*    and ht-ext-titulo.parcela = "01" */
/*    and ht-ext-titulo.cod-estabel = "1" */
/*    and ht-ext-titulo.cod-esp = "DP" */
/*    and ht-ext-titulo.serie = "2" : */
/*    */
/*        delete ht-ext-titulo. */
/*    */
/* end. */
