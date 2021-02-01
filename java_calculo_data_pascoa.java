/*
@param ano o ano para calcular 
*/
private void dataPascoa_Carnaval(int ano) {
	GregorianCalendar data_Pascoa = new GregorianCalendar();
	GregorianCalendar data_Carnaval = new GregorianCalendar();
	GregorianCalendar data_CorpusChristi = new GregorianCalendar();
	GregorianCalendar data_SextaFeiraSanta = new GregorianCalendar();

		int a = ano % 19;
		int b = ano / 100;
		int c = ano % 100;
		int d = b / 4;
		int e = b % 4;
		int f = (b + 8) / 25;
		int g = (b - f + 1) / 3;
		int h = (19 * a + b - d - g + 15) % 30;
		int i = c / 4;
		int k = c % 4;
		int l = (32 + 2 * e + 2 * i - h - k) % 7;
		int m = (a + 11 * h + 22 * l) / 451;
		int mes = (h + l - 7 * m + 114) / 31;
		int dia = ((h + l - 7 * m + 114) % 31) + 1;

		data_Pascoa.set(Calendar.YEAR, ano);
		data_Pascoa.set(Calendar.MONTH, mes-1);
		data_Pascoa.set(Calendar.DAY_OF_MONTH, dia);
		
		//Carnaval 47 dias antes da pascoa
		data_Carnaval.setTimeInMillis(data_Pascoa.getTimeInMillis());
		data_Carnaval.add(Calendar.DAY_OF_MONTH, -47);
		//CorpusChristi 60 dias apos a pascoa
		data_CorpusChristi.setTimeInMillis(data_Pascoa.getTimeInMillis());
		data_CorpusChristi.add(Calendar.DAY_OF_MONTH, 60);
		
		data_SextaFeiraSanta.setTimeInMillis(data_Pascoa.getTimeInMillis());
		data_SextaFeiraSanta.add(Calendar.DAY_OF_MONTH, -2);
	}