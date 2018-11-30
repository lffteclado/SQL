--exec dbCardiesel_I.dbo.whRelOSNrPassagensAgend 930,0,'2017-11-01 00:00:00:000','2017-11-30 00:00:00:000','V'

--sp_helptext whRelOSNrPassagensAgend

select * from tmpAnaliticoRelOut2017

select * from sysobjects where name like '%tmpAnaliticoRel%'

drop table tmpAnaliticoRelOut2017