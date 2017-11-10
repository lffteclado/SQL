--Aqui pega a Chave de acesso da nota
select * from tbDocumentoNFe where NumeroDocumento = 304477

--aqui confere a tblog da nota com a chave informada que consta na tbDocumentoNfe 
select * from tbLog where NomeArquivo = '\31171123338197000179550010003044771780016830-NFE.TXT' -- \31170923338197000179550010002996051491074602-nfe.txt

--Aqui atualiza o campo Tipo da tblog para o botão cancelar Habilitar
--update tbLog set Tipo = 'ERRO' where NomeArquivo = '\31171123338197000179550010003044771780016830-NFE.TXT'

