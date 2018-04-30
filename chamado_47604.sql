

select c.MunicipioCliFor,UFCliFor,c.NomeCliFor,c.DDDTelefoneCliFor,c.TelefoneCliFor,c.EmailCliFor,p.DataDocumento from tbCliFor  as c INNER JOIN tbPedidoComplementar as p 
on c.CodigoCliFor = p.CodigoCliFor where c.ClienteAtivo = 'V' order by c.MunicipioCliFor





