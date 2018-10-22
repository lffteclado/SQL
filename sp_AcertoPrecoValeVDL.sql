drop procedure sp_AcertoPrecoValeVDL
create procedure sp_AcertoPrecoValeVDL  
 as  
 begin transaction  
 update tbIP   
  set tbIP.PrecoUnitarioItemPed = tbPA.PrecoUnitarioItemPed  
   from tbItemPedido tbIP   
   inner join tbPedido tbP  
    on  tbIP.CodigoLocal = tbP.CodigoLocal  
    and tbIP.CentroCusto = tbP.CentroCusto  
    and tbIP.NumeroPedido = tbP.NumeroPedido  
   inner join [dbVDL].[dbo].tbPedidoAutorizado tbPA   
    on tbIP.CodigoEmpresa = tbPA.CodigoEmpresa  
    and tbIP.CodigoLocal = tbPA.CodigoLocal   
    and tbIP.NumeroPedido = tbPA.NumeroPedido   
    and tbIP.CentroCusto = tbPA.CentroCusto   
    and tbIP.CodigoProduto = tbPA.CodigoProduto collate SQL_Latin1_General_CP1_CS_AS  
   inner join [dbVDL].[dbo].tbClienteAutorizado tbCA   
    on tbCA.CodigoCliFor = tbPA.CodigoCliFor  
   inner join tbPedidoTK tbPTK   
    on tbPTK.NumeroPedido = tbPA.NumeroPedido  
    and tbPTK.CentroCusto = tbPA.CentroCusto  
    and tbPTK.CodigoCliFor = tbPA.CodigoCliFor  
   where tbP.StatusPedidoPed = 1 or tbP.StatusPedidoPed = 2
commit transaction  
delete from [dbVDL].[dbo].tbPedidoAutorizado 