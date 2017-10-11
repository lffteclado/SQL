select * from sysobjects where name like '%Log%'

sp_helptext spILogTransNegocio

select * from tbLogTransNegocio where CamposTabela like '%%' order by DataHoraOperacao

select * from tbLogTransNegocio where CodigoSistema = 'CG' and DataHoraOperacao between '2016-12-01' and '2017-02-28'

select * from tbLogTransNegocio where CamposTabela like '%11216%' and DataHoraOperacao between '2016-12-01' and '2017-02-28' order by DataHoraOperacao

select * from tbLogTransNegocio where CodigoUsuario = 'LSOUZA' and TextoHistoricoOperacao like '%11216%'

select * from tbLogTrans where IdentificacaoUsuarioTrans = 'WBHGADM77'

Exclusão do Registro   Chave:   Codigo Empresa = 930  Origem = CR  Data Lançamento = 01/12/2016  Numero Controle = 76538  Sequencia Lançamento = 3  Documento = 273423  