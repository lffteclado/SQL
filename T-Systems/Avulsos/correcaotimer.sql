



alter table tbControleConexao  trigger tnd_DSPa_ConnectionControl
go
delete  tbControleConexao
where ProgramName = 'DSP - TIMERPROGRAMACAOOFICINA'
go
alter table tbControleConexao  trigger tnd_DSPa_ConnectionControl
