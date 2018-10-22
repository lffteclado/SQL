-- lista os monitoramentos
SELECT CodigoFabricanteVeiculo, count(*) as 'Qtd'	--, TipoMonitoramento
FROM tbMonitoramento (NOLOCK)
where tbMonitoramento.MonitoramentoFinalizado = 'V'
group by CodigoFabricanteVeiculo					--, TipoMonitoramento
order by CodigoFabricanteVeiculo					--, TipoMonitoramento

-- tem documento e nao tem fabricante
SELECT count(*) FROM tbMonitoramento (NOLOCK)
where tbMonitoramento.MonitoramentoFinalizado = 'V'
and NumeroDocumento > 0
and CodigoFabricanteVeiculo is null

-- tem fabricante e nao tem documento
SELECT count(*) FROM tbMonitoramento (NOLOCK)
where tbMonitoramento.MonitoramentoFinalizado = 'V'
and NumeroDocumento = 0
and CodigoFabricanteVeiculo is not null



select veicos.CodigoFabricante, veicos.ChassiVeiculoOS, veicos.MarcaVeiculoOS, * 
from tbDocumento doc -- where doc.NumeroDocumento = 608360
		inner join tbDocumentoFT docft (nolock) on docft.CodigoEmpresa = doc.CodigoEmpresa and docft.CodigoLocal = doc.CodigoLocal and docft.EntradaSaidaDocumento = doc.EntradaSaidaDocumento and docft.NumeroDocumento = doc.NumeroDocumento and docft.DataDocumento = doc.DataDocumento and docft.CodigoCliFor = doc.CodigoCliFor and docft.TipoLancamentoMovimentacao = doc.TipoLancamentoMovimentacao
		inner join tbPedidoOS pedos (nolock) on docft.CodigoEmpresa = pedos.CodigoEmpresa and docft.CodigoLocal = pedos.CodigoLocal and docft.CentroCusto = pedos.CentroCusto and doc.NumeroPedidoDocumento = pedos.NumeroPedido and doc.NumeroSequenciaPedidoDocumento = pedos.SequenciaPedido 
		inner join tbOROS oros (nolock) on oros.CodigoEmpresa = pedos.CodigoEmpresa and oros.CodigoLocal = pedos.CodigoLocal and oros.FlagOROS = 'S' and oros.NumeroOROS = pedos.CodigoOrdemServicoPedidoOS 
		inner join tbVeiculoOS veicos (nolock) on veicos.CodigoEmpresa = oros.CodigoEmpresa and veicos.ChassiVeiculoOS = oros.ChassiVeiculoOS 
		inner join tbNaturezaOperacao nop (nolock) on nop.CodigoEmpresa = docft.CodigoEmpresa and nop.CodigoNaturezaOperacao = docft.CodigoNaturezaOperacao 
where doc.NumeroDocumento in (608498)


select CodigoFabricante, * from tbVeiculoOS where ChassiVeiculoOS = (
select ChassiVeiculoOS from tbOROS where NumeroOROS = (
select CodigoOrdemServicoPedidoOS from tbPedidoOS where NumeroPedido = (
select NumeroPedidoDocumento from tbDocumento where NumeroDocumento = 608498)))

select distinct '''' + ltrim(rtrim(MarcaVeiculoOS)) + ''', ' from tbVeiculoOS where ChassiVeiculoOS like '9BM%'-- '8AC9036616A933007'
AND CodigoFabricante is null

select * into tbVeiculoOSBKP20090916 from tbVeiculoOS




-- 23263
begin transaction
select COUNT(*) from tbVeiculoOS where MarcaVeiculoOS in (
--UPDATE tbVeiculoOS set CodigoFabricante = '1' where MarcaVeiculoOS in (
'MERCEDES BNEZ', 'MERCDES BENZ', 'MB.', 'BM', 'MERCEDES BENS', '.B', 'NERCEDES BENZ', 
'MERCDES-BENZ', 'MBBMB', 'MBBB', 'MBBRAS.', 'L=1214', 'MERCEDEWS-BENS', 'MERCEDES  BENZ', 'MERCEDES - BENZ', 
'MERCEDES BEN', 'L710', 'MERCEDE BENZ', 'MERC', '.MB', 'MERCEDEZ-BENZ', 'M.B.B', 'MBB', 'M B', 'MERCEDS-BENZ', 
'MEREDES-BENZ', 'MBB BENZ', 'MERCEDES BEMZ', 'BMMERCEDES BENZ', 'MERECDES BENZ', 'MERCEDES BENZ', 'MERCEDES -BENZ', 
'MERCEDES BENZZ', 'MMB', 'MB929514', 'M. BENZ', 'MERCERDES BENS', 'MERCEDES MENS', 'MERCEDES-BENS', 'L1620', 
'MERCEDES-BEZ', 'MD', 'MERCEDES-BENZ', 'MERCEDESBENZ', 'M BB', 'MERDECES BENZ', 'MERC. BENZ', 'BBRAS', 'MERCEDES BENZL', 
'MMBBRAS', 'MB', 'MB-', 'MERECEDES BENZ', 'MBRAS', 'M.B', 'L 1518', 'MEREDES BENZ', 'MERCEDEZ BENZ', 'MERDES BENZ', 
'MERCEDES BNES', 'MM', 'MERCEDSE BENZ', 'MBBAS', 'BMM', 'M BENZ', 'MERCERDES BENZ', 'MERCEDESB ENZ', 'MERCEDESBNEZ', 
'MERCEDE-BENZ', 'MBB 608', 'M.BEMZ', 'MERCES-BENZ', 'MBBRAS', 'MB        B', 'MMBRAS', 'M', 'L 1620', 'MERCEDSE BENS', 
'MERECEDS BENZ', 'MERCRDES BENS', 'M.BENZ', '9BM6953013B348772', 'MERCEDS BENZ', 'MBB.', 'MERCEDS BENS', 
'MERCEDESS BENZ', 'MERCDEES BENZ', 'MMRAS','SPRINTER')
AND CodigoFabricante is null

select COUNT(*) from tbVeiculoOS where MarcaVeiculoOS in ('FIAT')
--UPDATE tbVeiculoOS set CodigoFabricante = '2' where MarcaVeiculoOS in ('FIAT')
AND CodigoFabricante is null

select COUNT(*) from tbVeiculoOS where MarcaVeiculoOS in ('VW', 'VOLKS')
--UPDATE tbVeiculoOS set CodigoFabricante = '10' where MarcaVeiculoOS in ('VW', 'VOLKS')
AND CodigoFabricante is null

select COUNT(*) from tbVeiculoOS where MarcaVeiculoOS in ('SCANIA')
--UPDATE tbVeiculoOS set CodigoFabricante = '9' where MarcaVeiculoOS in ('SCANIA')
AND CodigoFabricante is null

select COUNT(*) from tbVeiculoOS where MarcaVeiculoOS in ('FORD')
--UPDATE tbVeiculoOS set CodigoFabricante = '7' where MarcaVeiculoOS in ('FORD')
AND CodigoFabricante is null

select COUNT(*) from tbVeiculoOS where MarcaVeiculoOS like ('%AGRALE%')
--UPDATE tbVeiculoOS set CodigoFabricante = '11' where MarcaVeiculoOS like ('%AGRALE%')
AND CodigoFabricante is null

select COUNT(*) from tbVeiculoOS where MarcaVeiculoOS in ('VOLVO')
--UPDATE tbVeiculoOS set CodigoFabricante = '4' where MarcaVeiculoOS in ('VOLVO')
AND CodigoFabricante is null


rollback transaction
commit transaction


'WOLKSVAGEM', 
'SCANIA', 
'VOLKSWAGEM', 
'@', 
'FORD', 
'VW', 


select * from tbCategoriaVeiculoOS
select * from sysobjects where name like 'tb%Veiculo%'
SELECT * FROM tbFabricanteVeiculo WHERE CodigoEmpresa = 1470

select * from tbGrupoVeiculo
EXECUTE whLocalizarVeiculoOS @CodigoEmpresa = 1470,@ChassiVeiculoOS = '8AC9036616A933007'


select CodigoFabricante, MarcaVeiculoOS, * from tbVeiculoOS 
where DataEntradaConcesVeiculoOS >= '2008-01-01'
and CodigoFabricante is null
where MarcaVeiculoOS not in ('SCANIA', 'WOLKSVAGEM', 'VW', 'VOLKSWAGEM', 'FIAT', 'BMM', 'FORD')

and DataEntradaConcesVeiculoOS >= '2009-01-01'

select distinct MarcaVeiculoOS from tbVeiculoOS where ChassiVeiculoOS like '9BM%' and CodigoFabricante is null
select CodigoFabricante, * from tbVeiculoOS where ChassiVeiculoOS like '9BM%' and CodigoFabricante is null

select NumeroPedidoDocumento from tbDocumento where NumeroDocumento = 608360
select CodigoOrdemServicoPedidoOS, CodigoCIT from tbPedidoOS where NumeroPedido = 114702
select ChassiVeiculoOS from tbOROS where NumeroOROS = 200386
select * from tbVeiculoOS where ChassiVeiculoOS = '9BM388054RB038056'


		select	veicos.CodigoFabricante
		from tbDocumento doc (nolock)
		inner join tbDocumentoFT docft (nolock) on docft.CodigoEmpresa = doc.CodigoEmpresa and docft.CodigoLocal = doc.CodigoLocal and docft.EntradaSaidaDocumento = doc.EntradaSaidaDocumento and docft.NumeroDocumento = doc.NumeroDocumento and docft.DataDocumento = doc.DataDocumento and docft.CodigoCliFor = doc.CodigoCliFor and docft.TipoLancamentoMovimentacao = doc.TipoLancamentoMovimentacao
		inner join tbPedidoOS pedos (nolock) on docft.CodigoEmpresa = pedos.CodigoEmpresa and docft.CodigoLocal = pedos.CodigoLocal and docft.CentroCusto = pedos.CentroCusto and doc.NumeroPedidoDocumento = pedos.NumeroPedido and doc.NumeroSequenciaPedidoDocumento = pedos.SequenciaPedido 
		inner join tbOROS oros (nolock) on oros.CodigoEmpresa = pedos.CodigoEmpresa and oros.CodigoLocal = pedos.CodigoLocal and oros.FlagOROS = 'S' and oros.NumeroOROS = pedos.CodigoOrdemServicoPedidoOS 
		inner join tbVeiculoOS veicos (nolock) on veicos.CodigoEmpresa = oros.CodigoEmpresa and veicos.ChassiVeiculoOS = oros.ChassiVeiculoOS 
		where docft.OrigemDocumentoFT = 'OS'
		and doc.CodigoEmpresa = 1470
		and doc.CodigoLocal = 0
--		and doc.CodigoCliFor = @CodigoCliFor			-- Pesquisa ultima tbDocumento pelo tbMonitoramento.CodigoCliFor
--		and doc.DataDocumento <= @DataMonitoramento		-- com a tbDocumento.DataDocumento <= tbMonitoramento.DataMonitoramento
		and doc.EntradaSaidaDocumento = 'S'
		and doc.TipoLancamentoMovimentacao = 7
		and doc.NumeroSequenciaPedidoDocumento = 1		-- Somente NF de Serviços Oficina (conf. NFe)
		and pedos.SequenciaPedido = 1					-- Somente Pedidos de Serviços Oficina (conf. NFe)

and doc.NumeroDocumento in (
608360 ,
608498 ,
608452 ,
608389 ,
608257 ,
608513 ,
609668 ,
609668 ,
609509 ,
608176 ,
608259 ,
608152 ,
608079 ,
608462 ,
609654 ,
608365 ,
609215 ,
608663 ,
608717 ,
608577 ,
608568 ,
608271 ,
608415 ,
608492 ,
609009 ,
608688 ,
608702 ,
608219 ,
608192 ,
608470 ,
608376 ,
609847 ,
608155 ,
608567 ,
608363 ,
608668 ,
609952 ,
608772 ,
608752 ,
608873 ,
608765 ,
608831 ,
608814 ,
609342 ,
608771 ,
610397 ,
609506 ,
609056 ,
609347 ,
609331 ,
609050 ,
610397 ,
610397 ,
610397 ,
608911 ,
608986 ,
608972 ,
609179 ,
609285 ,
609085 ,
609110 ,
609375 ,
609390 ,
609460 ,
609404 ,
609372 ,
609087 ,
608839 ,
610227 ,
609391 ,
609454 ,
609007 ,
609523 ,
608871 ,
610393 ,
610941 ,
609595 ,
609673 ,
609700 ,
609650 ,
609687 ,
609662 ,
609645 ,
609582 ,
609593 ,
609647 ,
609654 ,
610560 ,
610947 ,
609829 ,
609863 ,
610658 ,
610523 ,
609943 ,
610038 ,
610078 ,
610006 ,
609794 ,
610461 ,
610075 ,
610993 ,
610028 ,
610742 ,
609799 ,
610502 ,
609952 ,
610227 ,
610155 ,
609791 ,
610356 ,
609801 ,
611203 ,
609843 ,
609847 ,
609795 ,
611082 ,
610109 ,
610409 ,
610110 ,
610177 ,
610170 ,
611181 ,
609962 ,
611181 ,
610346 ,
610251 ,
611663 ,
610289 ,
610349 ,
610796 ,
611689 ,
610372 ,
610375 ,
611256 ,
610235 ,
610705 ,
610230 ,
611720 ,
610675 ,
610892 ,
610472 ,
610645 ,
610404 ,
610664 ,
611410 ,
610747 ,
610653 ,
611690 ,
610573 ,
610577 ,
611003 ,
610863 ,
610809 ,
610936 ,
610534 ,
610731 ,
612087 ,
610785 ,
610601 ,
610957 ,
610413 ,
610911 ,
610355 ,
610660 ,
610696 ,
610661 ,
610795 ,
610431 ,
610393 ,
610529 ,
610511 ,
610659 ,
610587 ,
610360 ,
610120 ,
610724 ,
611087 ,
610984 ,
612228 ,
611848 ,
610861 ,
610968 ,
611048 ,
611116 ,
611744 ,
611117 ,
611408 ,
611173 ,
611453 ,
611211 ,
611383 ,
611391 ,
611511 ,
611185 ,
611402 ,
611481 ,
611502 ,
611197 ,
610852 ,
611474 ,
611242 ,
611206 ,
611744 ,
610895 ,
611479)
		order by doc.DataDocumento desc 

/*
select * from tbDocumento 
where NumeroDocumento in (
608360 ,
608498 ,
608452 ,
608389 ,
608257 ,
608513 ,
609668 ,
609668 ,
609509 ,
608176 ,
608259 ,
608152 ,
608079 ,
608462 ,
609654 ,
608365 ,
609215 ,
608663 ,
608717 ,
608577 ,
608568 ,
608271 ,
608415 ,
608492 ,
609009 ,
608688 ,
608702 ,
608219 ,
608192 ,
608470 ,
608376 ,
609847 ,
608155 ,
608567 ,
608363 ,
608668 ,
609952 ,
608772 ,
608752 ,
608873 ,
608765 ,
608831 ,
608814 ,
609342 ,
608771 ,
610397 ,
609506 ,
609056 ,
609347 ,
609331 ,
609050 ,
610397 ,
610397 ,
610397 ,
608911 ,
608986 ,
608972 ,
609179 ,
609285 ,
609085 ,
609110 ,
609375 ,
609390 ,
609460 ,
609404 ,
609372 ,
609087 ,
608839 ,
610227 ,
609391 ,
609454 ,
609007 ,
609523 ,
608871 ,
610393 ,
610941 ,
609595 ,
609673 ,
609700 ,
609650 ,
609687 ,
609662 ,
609645 ,
609582 ,
609593 ,
609647 ,
609654 ,
610560 ,
610947 ,
609829 ,
609863 ,
610658 ,
610523 ,
609943 ,
610038 ,
610078 ,
610006 ,
609794 ,
610461 ,
610075 ,
610993 ,
610028 ,
610742 ,
609799 ,
610502 ,
609952 ,
610227 ,
610155 ,
609791 ,
610356 ,
609801 ,
611203 ,
609843 ,
609847 ,
609795 ,
611082 ,
610109 ,
610409 ,
610110 ,
610177 ,
610170 ,
611181 ,
609962 ,
611181 ,
610346 ,
610251 ,
611663 ,
610289 ,
610349 ,
610796 ,
611689 ,
610372 ,
610375 ,
611256 ,
610235 ,
610705 ,
610230 ,
611720 ,
610675 ,
610892 ,
610472 ,
610645 ,
610404 ,
610664 ,
611410 ,
610747 ,
610653 ,
611690 ,
610573 ,
610577 ,
611003 ,
610863 ,
610809 ,
610936 ,
610534 ,
610731 ,
612087 ,
610785 ,
610601 ,
610957 ,
610413 ,
610911 ,
610355 ,
610660 ,
610696 ,
610661 ,
610795 ,
610431 ,
610393 ,
610529 ,
610511 ,
610659 ,
610587 ,
610360 ,
610120 ,
610724 ,
611087 ,
610984 ,
612228 ,
611848 ,
610861 ,
610968 ,
611048 ,
611116 ,
611744 ,
611117 ,
611408 ,
611173 ,
611453 ,
611211 ,
611383 ,
611391 ,
611511 ,
611185 ,
611402 ,
611481 ,
611502 ,
611197 ,
610852 ,
611474 ,
611242 ,
611206 ,
611744 ,
610895 ,
611479)
*/