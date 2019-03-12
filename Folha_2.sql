select top 1 * from tbFuncionario

select * from sysobjects where name like 'tb%%' 

sp_helptext spIFuncionarioForPonto

select CodigoEmpresa, CodigoLocal, TipoColaborador, NomePessoal, CodigoHorario from tbFuncionarioForPonto where CodigoLocal = 0