update tb_correspondencia_endereco set registro_ativo=0 where fk_entidade_cooperado in(
select fk_entidade_cooperado
from tb_correspondencia_endereco where fk_entidade_cooperado in(
select id from rl_entidade_cooperado where fk_entidade=14 ) and registro_ativo=1
group by fk_entidade_cooperado
having count(*)>1) and discriminator='EntidadeCooperado'


insert into tb_correspondencia_endereco (discriminator,resolveu_dependencia,data_ultima_alteracao,registro_ativo,fk_usuario_ultima_alteracao,fk_endereco,fk_entidade_cooperado,sql_update)
select 'EntidadeCooperado',0,getdate(),1,1,tabelao.fk_endereco,entidadeCooperadoAcima.id,'#0619-000264'
from  rl_entidade_cooperado entidadeCooperadoAcima 
cross apply ( 
             select top 1 endereco.id as fk_endereco,endereco.fk_cooperado,endereco.situacao from tb_endereco endereco
             inner join  rl_entidade_cooperado entidadeCooperado on(endereco.fk_cooperado=entidadeCooperado.fk_cooperado and endereco.fk_entidade=entidadeCooperado.fk_entidade and endereco.registro_ativo=1 and entidadeCooperado.registro_ativo=1)
             where endereco.fk_entidade=14 and discriminator='Cooperado'
             and entidadeCooperadoAcima.fk_entidade=14 
             and entidadeCooperado.id=entidadeCooperadoAcima.id
             and not exists(select correspondencia.id from tb_correspondencia_endereco correspondencia
             inner join rl_entidade_cooperado entidadeCooperado on(entidadeCooperado.id=correspondencia.fk_entidade_cooperado and entidadeCooperado.registro_ativo=1 and correspondencia.registro_ativo=1)
             where entidadeCooperado.fk_entidade=14 
             and entidadeCooperado.fk_cooperado=endereco.fk_cooperado)
             order by isnull(fk_tipo_endereco,9) asc,case when endereco.email is not null then 0 else 1 end asc,endereco.id asc
) as tabelao 
where entidadeCooperadoAcima.fk_entidade=14 and entidadeCooperadoAcima.registro_ativo=1
and not exists(select correspondencia.id from tb_correspondencia_endereco correspondencia
where correspondencia.fk_entidade_cooperado=entidadeCooperadoAcima.id and correspondencia.registro_ativo=1)

/*
Consultar endere�o cadastrado
select cooperado.nome as cooperado,endereco.email,endereco.bairro,endereco.cep,
endereco.complemento,endereco.logradouro,endereco.numero,cidade.descricao as cidade
from tb_correspondencia_endereco correspondencia
inner join rl_entidade_cooperado entidadeCooperado on(correspondencia.fk_entidade_cooperado=entidadeCooperado.id)
inner join tb_cooperado cooperado on(cooperado.id=entidadeCooperado.fk_cooperado)
inner join tb_endereco endereco on(endereco.id=correspondencia.fk_endereco)
inner join tb_cidade cidade on(endereco.fk_cidade=cidade.id)
where correspondencia.sql_update='#0619-000264'
*/
