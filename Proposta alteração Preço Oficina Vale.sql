sp_helptext spAItemOROS
sp_helptext spPItemOROS
sp_helptext whLRequisicaoOS

sp_help tbItemOROS

/* Pegar o numero da requisição */
select NumeroOROS, CodigoCIT, NumeroRequisicaoOS, CodigoProduto from tbRequisicaoOS where NumeroOROS = '97820' and CodigoCIT = 'CCV'

select * from tbRequisicaoOS where NumeroOROS = '97820' and CodigoCIT = 'CCV' and CodigoProduto = 'A9583200344' and NumeroRequisicaoOS = '175140'

/* Pegar a Sequencia do Item */
EXECUTE whLRequisicaoOS @CodigoEmpresa = 130,@CodigoLocal = 0,@FlagOROS = 'S',@NumeroRequisicaoOS = 175140,@PesquisaDuplicado = 'V'


--EXECUTE spPItemOROS @CodigoEmpresa = 130,@CodigoLocal = 0,@FlagOROS = 'S',@NumeroOROS = 97166,@CodigoCIT = 'CCV',@TipoItemOS = 'P',@SequenciaItemOS = 9

EXECUTE whLRequisicaoOS @CodigoEmpresa = 130,@CodigoLocal = 0,@FlagOROS = 'S',@NumeroRequisicaoOS = 175140,@PesquisaDuplicado = 'V'

--insert tempItemOSVALE exec whLRequisicaoOS @CodigoEmpresa = 130,@CodigoLocal = 0,@FlagOROS = 'S',@NumeroRequisicaoOS = 174272,@PesquisaDuplicado = 'V'

select CodigoEmpresa,CodigoLocal, FlagOROS, NumeroOROS, CodigoCIT, ValorUnitarioItemOS, SequenciaItemOS, TipoItemOS, ValorBrutoItemOS, ValorLiquidoItemOS from tbItemOROS where NumeroOROS = '97820' and TipoItemOS = 'P'

select * from tbItemOROS where NumeroOROS = '97820'

update tbItemOROS set ValorUnitarioItemOS = '159.22' where CodigoEmpresa = 130 and CodigoLocal = 0 and NumeroOROS = '97820' and CodigoCIT = 'CCV' and FlagOROS = 'S' and SequenciaItemOS = 1 and TipoItemOS = 'P'

update tbRequisicaoOS set ValorUnitarioRequisicaoOS = '159.22' where NumeroOROS = '97820' and CodigoCIT = 'CCV' and CodigoProduto = 'A9583200344' and NumeroRequisicaoOS = '175140'