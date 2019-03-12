select * from tbApontamentoPendentePO


select * from tbMovimentoContabil where OrigemLancamentoMovtoContabil = 'CP' and DataLancamentoMovtoContabil = '2018-08-10 00:00:00.000'

select * from tbItemDocumentoContabil


select * from tbItemDocumentoContaContabil where NumeroDocumento=101381 DataDocumento = '2018-08-10 00:00:00.000' and CodigoCliFor = '22692928000117'


select * from sysobjects where name like 'tnu_DSPa_A%'

select * from sysobjects where name like '%tb%Integracao%'

select * from tbIntegracaoSistemaContabil where OrigemIntegracaoContabil = 'CP' 101851

/*
alter table tbIntegracaoSistemaContabil disable trigger tnu_DSPa_AcSyIn
GO
update tbIntegracaoSistemaContabil set UltimoNumeroControleContabil=UltimoNumeroControleContabil+1 where OrigemIntegracaoContabil='CP'
GO
alter table tbIntegracaoSistemaContabil enable trigger tnu_DSPa_AcSyIn
*/

select * from tbMovimentoContabil where OrigemLancamentoMovtoContabil='CP'