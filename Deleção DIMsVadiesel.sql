select * from tbEncomenda where CodigoProduto = 'A9412683278' and NumeroDocumentoEncomenda = 'TESTE AMOSTRA .' and CodigoEmpresa = 2630 and CodigoLocal = 0

update 

select * from tbEncomenda where NumeroDocumentoEncomenda like '%0000081964%'

select * from tbEDIATProcesso  where SequenciaProcessoAT = 100

select NomeArquivoProcessado from tbProtocoloDIMS where CodigoEmpresa = 2630 and   CodigoLocal = 0 and   EnvioRecebimento = 'R' and   EDIProcesso = 751 and   upper(NomeArquivoProcessado) = 'DMS.22031300.20170626182844.TXT'

sp_helptext spEEDIATProcesso

sp_helptext spAEDIATProcesso

sp_helptext spPEDIProcesso

--delete from tbEncomenda where CodigoProduto = 'A9412683278' and NumeroDocumentoEncomenda = 'PROT 4534/4682' and CodigoEmpresa = 2630 and CodigoLocal = 0
