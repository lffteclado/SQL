EXECUTE whProcessaRazaoGeralN @CodEmp = 930,@CodLoc = 0,@CodLocF = 9999,@Periodo = '201701',@DataI = '2017-01-01',@DataF = '2017-01-10',@TextoHistorico = '',@TipoSintet = 'N',@ContaI = '3103019901',@ContaF = '3103019980',@CCustoI = 1,@CCustoF = 99999999,@Ordem = 'DIRET',@PlCtSldCta = 'P',@TodosLocais = 'V',@TodosCCustos = 'V',@NomeMaquina = 'SRVCARD02',@NomeUsuario = 'LUIS3'

EXECUTE whListaStoredsProcedures @NomeSP = whRelCGRazaoGeral

exec dbCardiesel_I.dbo.whRelCGRazaoGeral 930,'201701','3103019901  ','3103019980  ',1,99999999,' ','V','DIRET','V',' ','SRVCARD02                     ','LUIS3                         ',0,357

--Delete from rtRazaoLancContabil where Spid=@@spid


sp_helptext whProcessaRazaoGeralN

sp_help rtRazaoLancContabil

sp_help tbMovimentoContabil

select * from tbMovimentoContabil
where	
			CodigoEmpresa = '930' and
			DataLancamentoMovtoContabil between '2017-01-01' and '2017-01-10' and 
			CodigoContaMovtoContabil between '3103019901' and '3103019980' and 
			(
					(
					CodigoOperacaoBancaria is null			
					)
					or
					(
					CodigoOperacaoBancaria in (select CodigoOperacaoBancaria
									from tbOperacaoBancaria (nolock)
									where ContabilOperacaoBancaria = 'V'
									and CodigoEmpresa = '930')				
					)
				)		