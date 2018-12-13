Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_AcertoPlanoVDL        
AS        
BEGIN        
        
declare @Cont int        
declare @Perc Real        
  set @Cont = 0        
  set @Perc = (select PerPlano from tbPlanoPagtoVDL where Cont = @Cont)        
  while @Cont <= 101  
begin        
update tbPlanoPagamento set PercentualDescNFPlanoPagamento = @Perc,        
       PercentualDescMOPlanoPagamento = 0,        
       PercentualDescontoPEC = @Perc,        
       PercDescCLOPlanoPagamento = 0        
       where CodigoPlanoPagamento = (select CodPlano from tbPlanoPagtoVDL where Cont = @Cont)        
select CodigoPlanoPagamento,        
    PercentualDescNFPlanoPagamento,        
       PercentualDescMOPlanoPagamento,        
    PercentualDescontoPEC,        
    PercDescCLOPlanoPagamento from tbPlanoPagamento where CodigoPlanoPagamento = (select CodPlano from tbPlanoPagtoVDL where Cont = @Cont)        
set @Cont = 1 + @Cont        
set @Perc = (select PerPlano from tbPlanoPagtoVDL where Cont = @Cont)        
end      
    
  update tbClienteComplementar set CodigoPlanoPagamento = null     
-- select * from tbClienteComplementar    
 where CodigoCliFor  not in (17200072000185,    
 65305864000167,03662722000108,03662722000280,06084516000148,    
 16669681000115,03835650000145,03685110000122,20127759000147,    
 22447684000450,22447684000107,21256870000287,21256870000368,    
 08579947000291,21254180000108,21256870000449,12292478000111,    
 18752691000498,18752691000145,17195488000152,42958017000104,    
 42958017000287,71241731000177,02229411003102,02229411000189,    
 17210212000104,17277583000286,17277583000103,07941428000188,    
 17264144000158,24314643000178,71487466000101,71487433000161,    
 23452469000167,05743627000156,20136362000111,19564921000539,    
 16813461000466,16813461000890,16813461000113,05476099000116,    
 04535651000137,26275420000174,03353341000139,07325920000129,    
 16956443000190,17162637000187,17168634000150,17168634000231,    
 17168634000312,23266026000181,21091913000130,00975933000102,    
 08642410000148,17275140000175,17216672000131,17257916000124,    
 22690390000101,24987653000174,20960753000156,24996746000408,    
 24996746000165,76354281000142,17257916000205,24996746000246,    
 24987653000255,20848420000130,04820730000270,23143522000148,    
 23929979000182,04980610000150,65293383000189,22688303000181,    
 19265024000109,21706296000130,20848420002507,05440380000441,    
 18472288000162,18472288000162,04820730000190,71061923000100,    
 23929979001669,09535153000108,05440380000107,7930893000113,21040746000107) and (CodigoPlanoPagamento is not null and CodigoPlanoPagamento not in    
 ('800','801','802','803','804','OFC','ORC','799','726','PMM'))    
     
        
end 

