SELECT  sum(tbHorasColaboradorFAMOOS.TotalHorasFAMOS) HorasFAMO 

FROM 	tbHorasColaboradorFAMOOS  	(NOLOCK)

INNER JOIN tbCIT			(NOLOCK)
ON	tbHorasColaboradorFAMOOS.CodigoEmpresa 	= tbCIT.CodigoEmpresa
AND	tbHorasColaboradorFAMOOS.CodigoCIT 	= tbCIT.CodigoCIT

WHERE 	tbHorasColaboradorFAMOOS.CodigoEmpresa 		= 2620			AND
	tbHorasColaboradorFAMOOS.CodigoLocal 		= 0	 			AND
	tbHorasColaboradorFAMOOS.CodigoColaboradorOS 	= 39			AND
	tbHorasColaboradorFAMOOS.DataReferenciaFAMOOS 	BETWEEN '2017-03-13 00:00'   AND  '2017-03-18 23:59'	AND
	tbHorasColaboradorFAMOOS.CodigoCIT 		BETWEEN '0'    AND 'ZZZZ' 	AND 
	tbHorasColaboradorFAMOOS.CentroCusto 		BETWEEN 0 AND 99999999 AND
	tbCIT.TipoHoraFAMO 				= 3

SET NOCOUNT OFF

select * from tbHorasColaboradorFAMOOS where CodigoColaboradorOS = 39