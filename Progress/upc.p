/* for each emsfnd.prog_dtsul where nom_prog_upc = 'upc-del-wt-it-docto.p': */
/* disp cod_prog_dtsul nom_prog_upc with width 300.320. */
/* end. */


for each prog_dtsul where nom_prog_upc MATCHES ("*upc*"):
disp cod_prog_dtsul nom_prog_upc with width 300.320.
end.
