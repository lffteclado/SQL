SELECT DISTINCT tbpt.CodigoEmpresa,
	   tbpt.CodigoLocal,
	   tbpt.TipoColaborador,
	   tbpe.NumeroRegistro,
	   tbpt.NomePessoal,
	   tbpt.CodigoHorario,
	   tbpe.CondicaoColaborador	   
FROM tbFuncionarioForPonto tbpt
INNER JOIN tbPessoal tbpe
on tbpt.NumeroRegistro = tbpe.NumeroRegistro
WHERE tbpe.CondicaoColaborador in (1, 2) and tbpt.CodigoLocal = 2 order by tbpe.NumeroRegistro