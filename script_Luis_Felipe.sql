

select * from rl_repasse_credito where fk_cooperado in (18555, 18438, 12047) and fk_repasse in (
 select id from tb_repasse where numero_repasse = 1887 and fk_entidade in (Select id from tb_entidade where sigla = 'COOPANEST')
)


GO

Select cooperado.id,
       cooperado.nome,
       dadosBancarios.situacao,
       banco.descricao,
	   dadosBancarios.registro_ativo
from tb_cooperado cooperado 
inner join rl_entidade_cooperado cooperadoEntidade on cooperadoEntidade.fk_cooperado = cooperado.id
inner join rl_entidade_cooperado_dados_bancarios dadosBancarios on dadosBancarios.fk_entidade_cooperado = cooperadoEntidade.id
inner join tb_banco banco on banco.id = dadosBancarios.fk_banco
where cooperadoEntidade.fk_entidade in (Select id from tb_entidade where sigla = 'COOPANEST')
and cooperado.nome in ('SABINEST - CLINICA MEDICA DE ANESTESIOLOGISTAS HOSPITAL ALBERT SABIN LTDA - EPP',
                       'Clinica de Anestesia Ltda.',
					   'Sanest - Serviço de Anestesiologia Medica - EPP')

select top 10 * from rl_repasse_calculado order by id desc where fk_repasse = 

select * from tb_banco where id =  36


