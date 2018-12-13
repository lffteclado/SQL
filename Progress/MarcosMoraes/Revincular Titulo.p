/* create ht-ext-titulo. */
/* assign ht-ext-titulo.ep-codigo = 1 */
/*        ht-ext-titulo.cod-estabel = "1" */
/*        ht-ext-titulo.cod-esp = "DP" */
/*        ht-ext-titulo.nr-docto = "0022719" */
/*        ht-ext-titulo.parcela = "01" */
/*        ht-ext-titulo.cod-emitente = 0 */
/*        ht-ext-titulo.serie = "2" */
/*        ht-ext-titulo.dt-envio = 10/10/2011 */
/*        ht-ext-titulo.usu-envio = "patricia" */
/*        ht-ext-titulo.cod-esp-dest = "DI". */

for each ht-ext-titulo no-lock
where ht-ext-titulo.nr-docto = "0022719"
and ht-ext-titulo.parcela = "01":
disp ht-ext-titulo with 1 col.
end.
