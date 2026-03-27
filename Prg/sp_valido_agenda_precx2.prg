* Validaciones de Agenda
parameters ldFechad,ldFechah,lnQuiro


ldFechah = ldFechah + 1

if lnQuiro <> 0
	lcWhere = " and pqq_quirofano = " + alltrim(str(lnQuiro))
else
	lcWhere = ""
endif


* VER ESTA PARTE, SINO HACER UN JOIN DE AMBAS TABLAS PARA LAS FECHAS

do while ldFechad < ldFechah

	lcSQL = "select * from tabpqquiro where pqq_fecha = ?ldFechad" + lcWhere
	if !Prg_EjecutoSql(lcSQL,"mwkTabPQQuiro",.f.)
		return .f.
	endif

	if reccount("mwkTabPQQuiro")>0
		return 0
	else
		return 1

		ldFechad = ldFechad + 1
	endif
enddo

