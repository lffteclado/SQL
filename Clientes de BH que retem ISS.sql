select * from sysobjects where name like 'tb%Cli%'

select * from tbCliFor where MunicipioCliFor = 'BELO HORIZONTE' and ClienteAtivo = 'V'

--CodigoCliFor - NomeCliFor 

select * from tbCliForJuridica
select * from tbCliForLocal
select * from tbLogCliForComplementar 
select * from tbClienteComplementar

select tbCJ.CodigoCliFor, 
		tbCJ.NomeCliFor,
		tbCJ.MunicipioCliFor,
		tbCFJ.InscricaoMunicipalJuridica,
		tbL.CondicaoRetencaoISS as TBCliForLocal
		from tbCliFor tbCJ
		inner join tbCliForJuridica tbCFJ on
		tbCFJ.CodigoCliFor = tbCJ.CodigoCliFor
		inner join tbCliForLocal tbL on
		tbCJ.CodigoCliFor = tbL.CodigoCliFor
		where tbCJ.MunicipioCliFor = 'BELO HORIZONTE' and tbCJ.ClienteAtivo = 'V' and tbL.CondicaoRetencaoISS = 'V'