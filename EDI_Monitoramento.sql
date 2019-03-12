EXECUTE whLEDILogEnvioInicioFim @CodigoEmpresa = 930,@CodigoLocal  = 0,@CodigoProcessoEDI = 930,@DataHoraEnvioEDIInicial = '2019-02-01 00:00',@DataHoraEnvioEDIFinal = '2019-02-27 00:00'

sp_helptext whLEDILogEnvioInicioFim

select top 10 * from tbEDILogEnvio

select * from tbEDIProcesso where DescricaoProcessoEDI like '%BI%'

select top 10 * from tbEDIMeios

select top 10 * from tbEDILogEnvioLinhas

select edlog.CodigoEmpresa,
       ednom.CodigoProcessoEDI,
	   ednom.DescricaoProcessoEDI,
	   edlog.DataHoraEnvioEDI,
	   edlog.TextoLogEDI
from tbEDILogEnvioLinhas edlog
inner join tbEDIProcesso ednom
on edlog.CodigoProcessoEDI = ednom.CodigoProcessoEDI
where edlog.DataHoraEnvioEDI > '20180201' and ednom.CodigoProcessoEDI = 930
