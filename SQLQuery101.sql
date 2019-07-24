select LEN(codigo_item_despesa_temp) as tamanhoCampo, descricao_item_despesa_temp, * from tb_procedimento where codigo_item_despesa_temp = '100102'

select descricao_item_despesa_temp, codigo_item_despesa_temp, * from tb_procedimento where descricao_item_despesa_temp like '%Consulta Pediat%'

select * from tb_item_despesa where LEN(codigo) > 9

select * from tb_item_despesa
order by (case when LEN(codigo) < 6 then 0
               when LEN(codigo) < 7 then 1
			   when LEN(codigo) < 8 then 2
			   when LEN(codigo) < 9 then 3 else 4 end)