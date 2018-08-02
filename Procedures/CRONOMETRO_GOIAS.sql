IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id('vwMonitServicoEXP_GO'))
BEGIN
	DROP VIEW dbo.vwMonitServicoEXP_GO
END
GO
CREATE VIEW [dbo].[vwMonitServicoEXP_GO]

/*
* VIEW CRIADA PARA ALIMENTAR O CRONOMETRO DO SERVIÇO EXPRESSO DA OFICINA
* AUTOR: Luís Felipe Ferreira
* DATA: 01/08/2018
*/
as    
select
tbOS.CodigoEmpresa,
tbOS.CodigoLocal,     
tbOS.NumeroOROS,    
tbOS.CodigoCIT,    
tbC.NomeCliFor as ContatoClienteOS    
--ContatoClienteOS    
 from dbGoias.dbo.tbOROSCIT tbOS    
inner join dbGoias.dbo.tbCliFor tbC on     
tbC.CodigoCliFor = tbOS.CodigoCliFor    
where tbOS.StatusOSCIT <> 'N'  
and tbOS.CodigoLocal = 0

