/* output to "c:\temp\emitente.txt".

put "Client/Fornecedor;Nome Fornecedor;Tributa‡Æo PIS;Tributa‡Æo Cofins" skip.
def var ecount as int init 0.
  for each emitente :
        put emitente.cod-emitente               ";"
            cod-classif-fornec                  ";"
               nome-abrev                       ";"
            emitente.idi-tributac-cofins        ";"
            emitente.idi-tributac-pis           ";"
            emitente.identific                  ";"
            skip.
       ecount = ecount + 1.
   end.       
output close.
output to "c:\temp\em¡tente_alterar.txt".
put "Client/Fornecedor;Nome Fornecedor;Tributa‡Æo PIS;Tributa‡Æo Cofins" skip.
def var tcount as int init 0.   
   for each emitente
        where ( emitente.idi-tributac-cofins <> 1 or emitente.idi-tributac-pis <> 1 )
        and ( emitente.identific <> 1 ).
        
/*             assign emitente.idi-tributac-cofins = 1 */
/*                    emitente.idi-tributac-pis = 1. */

           put emitente.cod-emitente            ";"        
               nome-abrev                       ";"
               emitente.idi-tributac-cofins     ";"
               emitente.idi-tributac-pis        ";"
                skip.
                tcount = tcount + 1.
    end.                
output close. 
message "Total de emitentes a serem gerados : " + string(ecount) view-as alert-box.            
message "Total de emitentes com o cod 2 ( tributa‡Æo Isenta ) :" + string(tcount) view-as alert-box. */

def var pacount as int init 0.
output to "c:\temp\emitente_pos_altera‡Æo".
put "Cod Emitente;Nome Emitente;3-Ambos/2-Fornecedor;Tribucao Pis;Tributa‡Æo Cofins;".
for each emitente 
    where ( emitente.identific = 3 or emitente.identific = 2 ) :
        put emitente.cod-emitente   ";"
            emitente.nome-abrev     ";"
            emitente.identific      ";"
            emitente.idi-tributac-pis    ";"
            emitente.idi-tributac-cofins ";"
            skip.
            
           pacount = pacount + 1.
end.       
            put "Som torio Total dos fornecedores alterados : " pacount.
output close.
            message "Emitentes alterados : " + string(pacount) view-as alert-box.
