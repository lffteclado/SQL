select * from sysobjects where name like '%VDL%'

exec sp_AcertoPlanoVDL


select * from tbPlanoPagtoVDL

--update tbPlanoPagtoVDL set PerPlano = 30 where CodPlano = 716