/* Expira a conta e a senha de todos os usuarios com excessao ao usuario super
   
   -----------------------------------------------------------------------------*/
   
FOR EACH usuar_mestre WHERE 
         usuar_mestre.cod_usuario <> "super":

    ASSIGN usuar_mestre.dat_valid_senha     = TODAY - 1
           usuar_mestre.dat_fim_valid  		= TODAY - 1.

END.




