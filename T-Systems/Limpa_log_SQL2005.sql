select * from sysprocesses 

sp_helpdb dbCalisto
F:\Microsoft SQL Server\MSSQL.1\MSSQL\LOG\dbCardiesel_I_log.ldf
select * from sysdatabases

select * from sysservers

checkpoint
go
backup log dbCalisto with truncate_only
go
dbcc shrinkfile (dbCalisto_log,100)