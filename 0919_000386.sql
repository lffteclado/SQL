select top 100 * from tb_entidade_cooperado_dependente where dependente_pensao = 1 order by id desc
select * from tb_entidade where sigla like '%FELICOOP%'

select * from tb_entidade_cooperado_dependente where nome = 'Felipe Costa Silluzio'

select * from tb_entidade where id = 17
select data_criacao, data_confirmacao, * from tb_repasse where numero_repasse = 920 and fk_entidade = 17

select top 10 * from tb_lancamento_repasse order by id desc
select top 10 * from rl_repasse_lancamento order by id desc
select top 10  * from tb_repasse where id = 12663 and registro_ativo = 1 and fk_entidade = 17 order by id desc
select top 100 * from rl_repasse_dependente order by id desc
select top 10 * from tb_banco
select * from 

select * from rl_repasse_dependente where fk_repasse = 12663

select * from sysobjects where name like '%repasse%'


select cooperado.nome as 'Cooperado'-- 0
       ,cooperado.numero_conselho as 'CRM' --1
       ,dependente.nome as 'Pensionista' -- 2
	   ,banco.numero_banco as 'Numero Banco' --3
	   ,banco.descricao as 'Nome Banco' --4
	   ,dependente.agencia as 'Agencia' --5
	   ,dependente.conta_corrente as 'Conta Corrente' --6
	   ,repasse.data_criacao as 'Data Criação' --7
	   ,repasse.data_confirmacao as 'Data Confirmação' --8
	   ,sum(repasseDependente.valor_desconto) as 'Valor Lançamento' --9
	   ,repasse.numero_repasse as 'Numero Repasse' --10
from tb_entidade_cooperado_dependente dependente WITH(NOLOCK)
INNER JOIN rl_entidade_cooperado entidadeCooperado WITH(NOLOCK) ON (dependente.fk_entidade_cooperado = entidadeCooperado.id and entidadeCooperado.registro_ativo = 1 and dependente.registro_ativo = 1)
INNER JOIN tb_cooperado cooperado with(nolock) on (cooperado.id = entidadeCooperado.fk_cooperado and cooperado.registro_ativo = 1)
INNER JOIN rl_repasse_dependente repasseDependente with(nolock) on (repasseDependente.fk_entidade_cooperado_dependente = dependente.id and repasseDependente.fk_cooperado = cooperado.id and repasseDependente.registro_ativo = 1)
INNER JOIN tb_repasse repasse with(nolock) on (repasse.id = repasseDependente.fk_repasse and repasse.registro_ativo = 1)
INNER JOIN tb_banco banco with(nolock) on (banco.id = dependente.fk_banco and banco.registro_ativo = 1)

LEFT JOIN rl_entidade_grupo_cooperado_vincular_cooperado grupoCooperadoVinculado with(nolock) on (grupoCooperadoVinculado.fk_entidade_cooperado = entidadeCooperado.id and grupoCooperadoVinculado.registro_ativo = 1)
INNER JOIN rl_entidade_grupo_cooperado as entidadeGrupoCooperado with(nolock) on (entidadeGrupoCooperado.id = grupoCooperadoVinculado.fk_entidade_grupo_cooperado and entidadeGrupoCooperado.registro_ativo = 1)

where entidadeCooperado.fk_entidade = 17 and repasse.data_criacao between '2019-01-01 00:00:00.0000000' and '2019-10-31 00:00:00.0000000' and repasseDependente.valor_desconto > 0
group by dependente.nome
         ,cooperado.nome
		 ,cooperado.numero_conselho
		 ,dependente.agencia
		 ,dependente.conta_corrente
		 ,repasse.data_confirmacao
		 ,repasse.numero_repasse
		 ,banco.numero_banco
		 ,banco.descricao
		 ,repasse.data_criacao
order by repasse.numero_repasse, banco.descricao, cooperado.nome, dependente.nome