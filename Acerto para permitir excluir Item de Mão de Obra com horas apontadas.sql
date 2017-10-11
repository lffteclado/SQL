select * from tbOROSCIT where NumeroOROS = 98063 and CodigoCIT = 'CCV'

select * from tbApontamentoMO where CodigoColaboradorOS = 53 NumeroOROS = 98063 and CodigoCIT = 'CCV'

--update tbApontamentoMO set HoraTerminoApontamentoMOOS = 8.30 where NumeroOROS = 183181 and CodigoCIT = 'I5NM' and DataApontamentoItemMOOS = '2017-07-06 00:00:00.000'

select * from tbItemOROS where NumeroOROS =  and CodigoCIT = 'I5NM'

select * from tbItemMOOROS where NumeroOROS = 162715 and CodigoCIT = 'C1N'
--update tbItemMOOROS set SituacaoItemMOOS = 'A', HorasReaisItemMOOS = 0.00 where NumeroOROS = 162820 and CodigoCIT = 'C1N'
--select * into tbItemMOOROS_162654 from tbItemMOOROS where NumeroOROS = 162654 and CodigoCIT = 'I5N'
--delete tbItemMOOROS where NumeroOROS = 162654 and CodigoCIT = 'I5N'
--insert into tbItemMOOROS select * from tbItemMOOROS_162654

select * from tbItensBlocoPO where NumeroOROS = 98063 and CodigoCIT = 'CCV'

select * from tbApontamentoMO where NumeroOROS = 98063 and CodigoCIT = 'CCV'

select * from sysobjects where name like 'tbApontamentoMO_BKP'

select * from tbApontamentoMO_BKP

select * into tbApontamentoMO_BKP from tbApontamentoMO where NumeroOROS = 162709 and CodigoCIT = 'C1N'

--select * into tbApontamentoMO_BKP from tbApontamentoMO where NumeroOROS = 183181 and CodigoCIT = 'I5NM'
select * from tbApontamentoMO where NumeroOROS = 162715 and CodigoCIT = 'C1N'
--delete tbApontamentoMO where NumeroOROS = 162715 and CodigoCIT = 'C1N'

SELECT CHASSIVEICULOOS, DATAPROGRAMACAOPO, * FROM TBPROGRAMACAOOFICINAPO
SELECT CHASSIVEICULOOS, DATAPROGRAMACAOPO, * FROM TBPARTICAOBLOCOPO
SELECT CHASSIVEICULOOS, DATAPROGRAMACAOPO, * FROM TBAPONTAMENTOPO

select ChassiVeiculoOS, DataProgramacaoPO, * from tbProgramacaoOficinaPO where DataProgramacaoPO = '2017-07-05 00:00:00.000' and ChassiVeiculoOS = '9BM958154GB039395'

SELECT ChassiVeiculoOS, DataProgramacaoPO, * FROM tbParticaoBlocoPO where DataProgramacaoPO = '2017-07-05 00:00:00.000' and ChassiVeiculoOS = '9BM958154GB039395'

SELECT ChassiVeiculoOS, DataProgramacaoPO, * FROM tbApontamentoPO  where DataProgramacaoPO = '2017-07-05 00:00:00.000' and ChassiVeiculoOS = '9BM958154GB039395'