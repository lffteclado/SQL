select * from sysobjects where name like 'tb%ItemDoc%'

/*
select * from tbDuplicataNotaDigitada

delete from tbDuplicataNotaDigitada where DocumentoNotaDigitada = 310810

select * from tbItemNotaDigitada

delete from tbItemNotaDigitada where DocumentoNotaDigitada = 310810

select * from tbNotaDigitada

delete from tbNotaDigitada where DocumentoNotaDigitada = 310810

select * from tbRateioNotaDigitada
*/

-- Documento j� captado e encerrado se j� estiver no livro excluir pelo livro.
-- Sen�o excluir via banco
select * from tbItemDocumentoContaContabil where NumeroDocumento = 310810 and CodigoLocal = 0 and EntradaSaidaDocumento = 'E'