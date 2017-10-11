select * from tbProgramacaoOficinaPO where ChassiVeiculoOS = '9BM958441EB964683'
select * from tbParticaoBlocoPO where ChassiVeiculoOS = '9BM958441EB964683' order by DataParticaoPO
select * from tbApontamentoPO where ChassiVeiculoOS = '9BM958441EB964683' order by DataParticaoPO

select * from tbProgramacaoOficinaPO where ChassiVeiculoOS = '9BM958441EB964683'

select DataParticaoPO,BlocoVeiculoPO,HoraInicioRealParticaoPO, HoraFimRealParticaoPO,CodigoColaboradorOS 
from tbParticaoBlocoPO where ChassiVeiculoOS = '9BM958441EB964683' and DataParticaoPO = '2016-08-19 00:00:00.000'

select DataParticaoPO,BlocoVeiculoPO,DataHoraInicioApontamentoPO,DataHoraFimApontamentoPO,CodigoCIT,CodigoColaboradorOS 
from tbApontamentoPO where ChassiVeiculoOS = '9BM958441EB964683' and DataParticaoPO = '2016-08-19 00:00:00.000'
order by DataParticaoPO




--delete tbParticaoBlocoPO where ChassiVeiculoOS = '9BM958441EB964683' and DataParticaoPO = '2016-08-16 00:00:00.000' and HoraInicioRealParticaoPO is null
--update tbParticaoBlocoPO set HoraInicioRealParticaoPO = 8.00,HoraFimRealParticaoPO = 16.09
where ChassiVeiculoOS = '9BM958441EB964683' and DataParticaoPO = '2016-08-19 00:00:00.000'