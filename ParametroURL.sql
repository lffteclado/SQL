--insert tbParametro
--select 
--	CGCLocal,
--	'UrlIntegracaoTOTVS',
--	'http://192.168.0.114:8080/wsatst/wsvdltst/wsdl?targetURI=urn:tempuri-org',
--	getdate()
--from tbLocal
--where CodigoEmpresa = 930
--and CodigoLocal = 0

select Valor from tbParametro where Parametro like 'UrlIntegracaoTOTVS'

--update tbParametro set Valor = 'http://192.168.0.114:8080/wsatst/wsvdltst/' where Parametro like 'UrlIntegracaoTOTVS'
