sp_helptext sp_AcertoPlanoVDL

select * from tbPlanoPagtoVDL

insert into tbPlanoPagtoVDL (Cont,CodPlano, PerPlano) values (22, '920', 14.40)

update tbPlanoPagtoVDL set PerPlano = 20.0 where CodPlano = '545'

sp_help tbPlanoPagtoVDL 

execute sp_AcertoPlanoVDL
