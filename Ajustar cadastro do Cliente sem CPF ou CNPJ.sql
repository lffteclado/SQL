select top 10 * from tbCliFor where CodigoCliFor = 5371758658


select * 

select * into #tbCF from tbCliForFisica where CPFFisica like '%80262260017   %'

insert into tbCliForFisica select * from #tbCF

update #tbCF set CodigoCliFor = 5371758658,
				 CPFFisica = 05371758658
				
select * from tbCliFor 


--insert into tbCliForFisica (CodigoEmpresa,CodigoCliFor,CPFFisica) values (3140,5371758658,'05371758658')
sp_help tbCliForFisica

select * from tbCliForJuridica where CGCJuridica like '%5371758658%'
 where CodigoCliFor = 5371758658