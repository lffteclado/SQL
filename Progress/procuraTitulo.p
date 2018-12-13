/*select count(*) from tit_acr.*/


FOR EACH tit_acr WHERE cod_empresa = 'GRU' AND cod_estab = '104' and cod_tit_acr = '12345678':
DISP cod_empresa cod_estab cod_tit_acr.
END.

