--EXEC sp_BloqueiaAbaixoCusto 260, 0, 'V'

--EXEC sp_BloqueiaPlano 260, '526', 'V'

--EXEC sp_BloqueiaDescMinimo 260, 0, 'V', '51.00'

--SELECT * FROM vwCheckVDL

sp_helptext sp_BloqueiaAbaixoCusto

sp_helptext sp_BloqueiaPlano

sp_helptext sp_BloqueiaDescMinimo

sp_helptext vwCheckVDL