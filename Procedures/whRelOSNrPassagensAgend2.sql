SELECT DISTINCT(Chassi),
		DescricaoCategoriaVeiculoOS,
		ModeloVeiculoOS,
		Cliente,
		NumeroOS
FROM tmpAnaliticoRelNov2017 ana
INNER JOIN tbVeiculoOS veic
ON ana.Chassi collate Latin1_General_CS_AS = veic.ChassiVeiculoOS
INNER JOIN tbCategoriaVeiculoOS cat
ON veic.CodigoCategoriaVeiculoOS = cat.CodigoCategoriaVeiculoOS
INNER JOIN tbOROSCIT cit
ON ana.NumeroOS = cit.NumeroOROS
where substring(cit.CodigoCIT,1,1) = 'C' and Chassi not in (SELECT distinct Chassi from tmpAnaliticoRelOut2017)

select * from tbVeiculoOS
select * from tbCliFor
select * from tmpAnaliticoRel2017

select * from tmpAnaliticoRelOut2017 order by Periodo
select * from tmpAnaliticoRelNov2017 order by DataEncerramento
tmpAnaliticoRel2015
tmpAnaliticoRel2016

select * into tmpAnaliticoRelOut2017 from tmpAnaliticoRel2015


/*
				(cat.DescricaoCategoriaVeiculoOS like '%CAMIN%' or 
			     cat.DescricaoCategoriaVeiculoOS like '%LEVES%' or
			     cat.DescricaoCategoriaVeiculoOS like '%MISTO%' or
				 cat.DescricaoCategoriaVeiculoOS like '%PESA%' or 
				 cat.DescricaoCategoriaVeiculoOS like '%MEDIO%' or 
				 cat.DescricaoCategoriaVeiculoOS like '%TRAT%' or
				 cat.DescricaoCategoriaVeiculoOS like '%OUT%' )

SELECT distinct Chassi from tmpAnaliticoRel2015 where Chassi not in (SELECT distinct  Chassi from tmpAnaliticoRel2017)

SELECT distinct Chassi from tmpAnaliticoRel2016 where Chassi not in (SELECT distinct  Chassi from tmpAnaliticoRel2017)

*/