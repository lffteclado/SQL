go
update tbEntradaXML 
		set DocumentoAtualizado = 'V'
		where NumeroDocumento in (select NumeroDocumento from tbItemEntradaXML where NumeroDocumento not in (select DocumentoNotaDigitada from tbNotaDigitada)) 
go	