update rl_situacao_procedimento set digitado = 0, valorDigitado = 0.00
	where digitado <> 0
	 and repassado <> 0
	 and valorDigitado <> 0
	 and valorRepassado <> 0