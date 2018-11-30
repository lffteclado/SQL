select count(*),'Card' from dbCardiesel_I.dbo.tbDMSTransitoNFe where DataDocumento between '2016-11-30 00:00:00.000' and '2016-11-30 23:59:00.000' and MsgRetorno like '%sendo processado no SEFAZ.'
union all
select count(*),'Auto' from dbAutosete.dbo.tbDMSTransitoNFe where DataDocumento between '2016-11-30 00:00:00.000' and '2016-11-30 23:59:00.000' and MsgRetorno like '%sendo processado no SEFAZ.'
union all
select count(*),'Cali' from dbCalisto.dbo.tbDMSTransitoNFe where DataDocumento between '2016-11-30 00:00:00.000' and '2016-11-30 23:59:00.000' and MsgRetorno like '%sendo processado no SEFAZ.'
union all
select count(*),'Goia' from dbGoias.dbo.tbDMSTransitoNFe where DataDocumento between '2016-11-30 00:00:00.000' and '2016-11-30 23:59:00.000' and MsgRetorno like '%sendo processado no SEFAZ.'
union all
select count(*),'Post' from dbPostoImperialDP.dbo.tbDMSTransitoNFe where DataDocumento between '2016-11-30 00:00:00.000' and '2016-11-30 23:59:00.000' and MsgRetorno like '%sendo processado no SEFAZ.'
union all
select count(*),'Rede' from dbRedeMineira.dbo.tbDMSTransitoNFe where DataDocumento between '2016-11-30 00:00:00.000' and '2016-11-30 23:59:00.000' and MsgRetorno like '%sendo processado no SEFAZ.'
union all
select count(*),'Uber' from dbUberlandia.dbo.tbDMSTransitoNFe where DataDocumento between '2016-11-30 00:00:00.000' and '2016-11-30 23:59:00.000' and MsgRetorno like '%sendo processado no SEFAZ.'
union all
select count(*),'Vadi' from dbVadiesel.dbo.tbDMSTransitoNFe where DataDocumento between '2016-11-30 00:00:00.000' and '2016-11-30 23:59:00.000' and MsgRetorno like '%sendo processado no SEFAZ.'
union all
select count(*),'Vala' from dbValadaresCNV.dbo.tbDMSTransitoNFe where DataDocumento between '2016-11-30 00:00:00.000' and '2016-11-30 23:59:00.000' and MsgRetorno like '%sendo processado no SEFAZ.'



--select top(10) * from tbDMSTransitoNFe order by DataDocumento desc

--select * from tbDMSTransitoNFe where MsgRetorno like '%sendo processado no SEFAZ.'