select * from tbEDIATProcesso
where CodigoProcessoEDI = 19 and CodigoEmpresa = 930 and CodigoLocal = 0

--update tbEDIATProcesso set HorarioProcessoAT = 13.54 
--where CodigoProcessoEDI = 19 and CodigoEmpresa = 930 and CodigoLocal = 0

 
select * from tbEDIATProcesso where CodigoProcessoEDI = 19 and CodigoEmpresa = 930 and CodigoLocal = 0

select * from tbIntegracaoTOTVS

select * from tbEmpresa where CodigoEmpresa = 930

--insert tbEDIProcessoTipoEmpresa values (6,19)
--insert tbEDIProcessoGrupoMeios values (19,17,4,NULL,'I',999,null,null,null,null,NULL,NULL,NULL)

select * from tbEDIProcessoGrupoMeios

select * from tbEDIProcessoTipoEmpresa where CodigoProcessoEDI = 19



select ContaConcessao,* from tbLocal

select * from tbMQConta where CodigoMQConta = '26415000'
select * from tbEDIATProcesso where CodigoProcessoEDI = 19
select * from tbEDIProcessoGrupoMeios where CodigoMeioEDI = 4 CodigoProcessoEDI = 19
--update tbEDIProcessoGrupoMeios set EnderecoIPEDI = '',ChaveFTPEDI = '',SenhaFTPEDI= '',CaminhoDestinoFTPEDI = '\\192.168.0.58\import_cardiesel\'  where CodigoMeioEDI = 4 and CodigoProcessoEDI = 19

--\\192.168.0.58\import_cardiesel                 

--update tbEDIProcessoGrupoMeios set CodigoMQGrupo = 10 where CodigoProcessoEDI = 19
 --update tbEDIATProcesso set CodigoMQGrupo = 10 where CodigoProcessoEDI = 19


EXECUTE whLIntegracaoTOTVS @CodigoEmpresa = 930,@CodigoLocal = 0

sp_helptext whLIntegracaoTOTVS