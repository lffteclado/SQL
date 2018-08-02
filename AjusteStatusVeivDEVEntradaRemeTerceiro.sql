select * from tbVeiculoCV where NumeroChassisCV like '%9BM979098JB101323%'

--update tbVeiculoCV   set StatusVeiculoCV = 'ERT'  where NumeroChassisCV like '%9BM979098JB101323%'

select * from tbItemDocumento where CodigoItemDocto = '9BM979098JB101323'

select CondicaoNFCancelada,* from tbDocumento where NumeroDocumento = 202823 and DataDocumento = '20180716'