select * from sysobjects where name like 'tb%ItemDoc%'

/*
select * from tbDuplicataNotaDigitada

delete from tbDuplicataNotaDigitada where DocumentoNotaDigitada = 19709

select * from tbItemNotaDigitada

delete from tbItemNotaDigitada where DocumentoNotaDigitada = 19709

select * from tbNotaDigitada

delete from tbNotaDigitada where DocumentoNotaDigitada = 19709

select * from tbRateioNotaDigitada
*/

-- Documento j� captado e encerrado se j� estiver no livro excluir pelo livro.
-- Sen�o excluir via banco
select * from tbItemDocumentoContaContabil where NumeroDocumento = 19709 and CodigoLocal = 0