--Pra emiss�o da NF de devolu��o sem que o destaque do campo Desp.Acess�rias seja feito,
--acesse a tbParametro, localize o campo �NAOIMPRIMIRICMSSTIPIOUTRASDESP� e altere para TRUE.

select * from tbParametro  where Parametro = 'NAOIMPRIMIRICMSSTIPIOUTRASDESP' and CNPJ = '23338197000179'

--update tbParametro set Valor = 'TRUE' where Id_parametro = 55 and CNPJ = '23338197000179' and Parametro = 'NAOIMPRIMIRICMSSTIPIOUTRASDESP'