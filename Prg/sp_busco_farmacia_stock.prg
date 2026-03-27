*
* Stok de Farmacia
*

*!* --  Gotas y pomadas
if used('mwkstkgp')
	use in mwkstkgp
endif
mret = sqlexec(mcon1,"select INS_codpuntero,INS_GRUPO,INS_TIPO,INS_CODINSUMO,INS_descriinsumo,"+;
	" nvl(STSALDO.SALDO,0) as saldo"+;
	" from INSUMOS left JOIN STSALDO"+;
	" ON INSUMOS.INS_codpuntero = STSALDO.Codigo and stsaldo.deposito=1"+;
	" where (ins_grupo = 'A' or ins_grupo = 'D' or ins_grupo='M' or ins_grupo = 'U'"+;
	" or ins_grupo='W') and"+;
	" ins_tipo in ('AR', 'DL', 'MA', 'ME', 'OG', 'OP', 'SO', 'US', 'DD', 'GG', 'MM', 'DC', 'AT')"+;
	" and ins_fechapasivo is null"+;
	" and saldo <> 0"+;
	" ORDER BY INS_descriinsumo","mwkstkgp")
if mret < 0
	messagebox("EN CONSULTA DE STOCK GOTAS Y POMADAS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
endif

*!* -- Comprimidos OC PP - Alfabetico
if used('mwkstkocp')
	use in mwkstkocp
endif
mret = sqlexec(mcon1,"select INS_codpuntero,INS_GRUPO,INS_TIPO,INS_CODINSUMO,INS_descriinsumo,"+;
	" nvl(STSALDO.SALDO,0) as saldo"+;
	" from INSUMOS left JOIN STSALDO"+;
	" ON INSUMOS.INS_codpuntero = STSALDO.Codigo and stsaldo.deposito=1"+;
	" where (ins_grupo = 'A' or ins_grupo = 'D' or ins_grupo='M' or ins_grupo = 'U'"+;
	" or ins_grupo='W') and"+;
	" ins_tipo in ( 'OC','PP')"+;
	" and ins_fechapasivo is null"+;
	" and saldo <> 0"+;
	" ORDER BY INS_descriinsumo","mwkstkocp")
if mret < 0
	messagebox("EN CONSULTA DE STOCK COMPRIMIDOS OC PP"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
endif

*!* -- Ampollas
if used('mwkstkamp')
	use in mwkstkamp
endif
mret = sqlexec(mcon1,"select INS_codpuntero,INS_GRUPO,INS_TIPO,INS_CODINSUMO,INS_descriinsumo,"+;
	" nvl(STSALDO.SALDO,0) as saldo"+;
	" from INSUMOS left JOIN STSALDO"+;
	" ON INSUMOS.INS_codpuntero = STSALDO.Codigo and stsaldo.deposito=1"+;
	" where (ins_grupo = 'A' or ins_grupo = 'D' or ins_grupo='M' or ins_grupo = 'U'"+;
	" or ins_grupo='W') and"+;
	" ins_tipo in ( 'NI', 'NN', 'SS', 'II', 'PS','RD')"+;
	" and ins_fechapasivo is null"+;
	" and saldo <> 0"+;
	" ORDER BY INS_descriinsumo","mwkstkamp")
if mret < 0
	messagebox("EN CONSULTA DE STOCK AMPOLLAS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
endif

*!* -- Asistenciales y Descartables
if used('mwkstkades')
	use in mwkstkades
endif
mret = sqlexec(mcon1,"select INS_codpuntero,INS_GRUPO,INS_TIPO,INS_CODINSUMO,INS_descriinsumo,"+;
	" nvl(STSALDO.SALDO,0) as saldo"+;
	" from INSUMOS left JOIN STSALDO"+;
	" ON INSUMOS.INS_codpuntero = STSALDO.Codigo and stsaldo.deposito=1"+;
	" where (ins_grupo = 'A' or ins_grupo = 'D' )"+;
	" and ins_fechapasivo is null"+;
	" and saldo <> 0"+;
	" ORDER BY INS_descriinsumo","mwkstkades")
if mret < 0
	messagebox("EN CONSULTA DE STOCK COMPRIMIDOS ASISTENCIALES Y DESCARTABLES"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
endif
