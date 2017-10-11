select * from tbContatoClienteTP where CodigoCliFor is null

select CodigoClientePotencial from tbContatoClienteTP where CodigoCliFor is null

select * from tbClienteStarTruck where CodigoClienteST = '36'

select * from tbClienteStarTruck where CodigoClienteST in (select CodigoCliFor from tbCliFor)

select * from tbCliFor where CodigoCliFor not in (select CodigoClienteST from tbClienteStarTruck)

select * from tbCliForFisica where CodigoCliFor in (select CodigoClienteST from tbClienteStarTruck)

select * from tbCliForJuridica where CodigoCliFor in (select CodigoClienteST from tbClienteStarTruck) CGCJuridica = 21846043000162

select * from tbCliForJuridica where CGCJuridica = '21846043000162' --1 21846043000162

select * from tbCliFor where CodigoCliFor = 21846043000162

select * from tbClienteComplementar

select * from tbFrotaCliente WHERE NumeroClientePotencialEfetivo IN (select CodigoCliFor from tbCliFor)

select PossuiOnus, PossuiSeguro, * from tbFrotaCliente

INNER JOIN tbCliForJuridica AS tj ON tc.CodigoCliFor = tj.CodigoCliFor
INNER JOIN tbCliForFisica AS tf ON tc.CodigoCliFor = tf.CodigoCliFor

CASE
		WHEN (j.InscricaoEstadualJuridica) is null THEN ''
		WHEN (j.InscricaoEstadualJuridica) = '' THEN ''
		END AS inscricaoEstadual,

		RTRIM(LTRIM(j.InscricaoEstadualJuridica)) AS inscricaoEstadual,
	   CASE
		WHEN (j.InscricaoEstadualJuridica) is null THEN ''
		WHEN (j.InscricaoEstadualJuridica) = '' THEN ''
		END AS inscricaoEstadual,
		
		tbClienteRepresentanteTP

select CodigoClienteST from tbClienteRepresentanteTP where CodigoRepresentante = 35

select * from tbClienteStarTruck where CodigoClienteST in (select CodigoClienteST from tbClienteRepresentanteTP where CodigoRepresentante = 35)

select * from tbClienteRepresentanteTP where CodigoClienteST in (select CodigoClienteST from tbClienteRepresentanteTP where CodigoRepresentante = 35)

select * from tbCliFor where CodigoCliFor in (select CodigoClienteST from tbClienteRepresentanteTP where CodigoRepresentante = 35)

select * from tbCliForFisica where CodigoCliFor in (select CodigoClienteST from tbClienteRepresentanteTP where CodigoRepresentante = 35)

select * from tbCliForJuridica where CodigoCliFor in (select CodigoClienteST from tbClienteRepresentanteTP where CodigoRepresentante = 35)


select * from tbRepresentanteComplementar where NomeRepresentante like 'GERALDO%'

select * from tbRepresentante where RepresentanteBloqueado = 'V' and CodigoRepresentante = 35

