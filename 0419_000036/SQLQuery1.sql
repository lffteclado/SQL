select sigla, nome, * from tb_cooperado where nome like 'Centro de Repr Humana%' -- 13324

select * from tb_entidade where sigla like '%GINECOOP%' --6

select * from rl_entidade_cooperado where fk_cooperado = 13324 and fk_entidade = 6 --2898

select * from rl_cooperado_movimentacao where fk_entidade_cooperado = 2898

select top 100 * from tb_tipo_movimentacao

--update rl_cooperado_movimentacao set registro_ativo = 0, sql_update = ISNULL('',sql_update)+'#0419-000036' where id =109979


/*

ATIVO("Ativo"), 0
  EXCLUIDO("Excluído"), 1
  DEMITIDO("Demitido"), 2
  FALECIDO("Falecido"), 3
  INATIVO("Inativo"), 4
  EXCLUSIVO_UNIMED("Exclusivo Unimed"), 5
  A_VERIFICAR("A verificar"), 6
  ELIMINADO("Eliminado"), 7
  VINCULADO_DE_OUTRO_PRESTADOR("Vinculado de Outro Prestador"), 8
  A_INTEGRALIZAR("A Integralizar"), 9
  LICENCIADO("Licenciado"), 10
  SUSPENSO("Suspenso"), 11
  ADESAO_A_COOPERATIVA("Adesão à Cooperativa"); 12

*/

