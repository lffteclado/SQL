SELECT DISTINCT(Chassi),
		DescricaoCategoriaVeiculoOS,
		ModeloVeiculoOS
FROM tmpAnaliticoRel2015 ana
INNER JOIN tbVeiculoOS veic
ON ana.Chassi collate Latin1_General_CS_AS = veic.ChassiVeiculoOS
INNER JOIN tbCategoriaVeiculoOS cat
ON veic.CodigoCategoriaVeiculoOS = cat.CodigoCategoriaVeiculoOS
INNER JOIN tbOROSCIT cit
ON ana.NumeroOS = cit.NumeroOROS 
where  substring(cit.CodigoCIT,1,1) = 'C' and Chassi not in (SELECT distinct  Chassi from tmpAnaliticoRel2017)


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