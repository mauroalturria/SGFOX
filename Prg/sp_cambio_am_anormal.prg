*!*	---------------------------------------------------
*!*	cambio de turno de TIPO1 A TIPO 2 atencion mediata a Turno normal
*!*	---------------------------------------------------
parameter mfecha, vr_codesp,mtipo1,mtipo2

if vartype(mtipo1)#"N"
	mtipo1 = 11
endif
if vartype(mtipo2)#"N"
	mtipo2 = 0
endif
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif
mtexto = 'Turnos '+iif(mtipo1=11,"AM",iif(mtipo1=7,"PE","DI"))+' del ' + dtoc(mfecha)

if vr_codesp = ''
	mret = sqlexec(mcon1, "select count(tipoturno) as total from turnos " + ;
		"where &mccpoamb afiliado <= 1 and tipoturno = ?mtipo1 and " + ;
		"fechatur = ?mfecha ", "mwkveops")

	if mtipo1 = 12 
		mret = sqlexec(mcon1, "update turnos set afiliado = 0 " + ;
			"where &mccpoamb afiliado <= 1 and tipoturno = ?mtipo1 and " + ;
			"fechatur = ?mfecha ")
	endif
	mret = sqlexec(mcon1, "update turnos set tipoturno  = ?mtipo2, observa = ?mtexto " + ;
		"where &mccpoamb afiliado <= 1 and tipoturno = ?mtipo1 and " + ;
		"fechatur = ?mfecha ")
	if mtipo1 = 7 and mtipo2= 5
		mret = sqlexec(mcon1, "update turnos set tipoturno  = ?mtipo2 " + ;
			"where &mccpoamb afiliado > 1 and tipoturno = ?mtipo1 and " + ;
			"fechatur = ?mfecha ")
	endif
else
	mret = sqlexec(mcon1, "select count(tipoturno) as total from turnos " + ;
		" where &mccpoamb afiliado <= 1 and tipoturno = ?mtipo1 and " + ;
		" fechatur = ?mfecha and codmed in (select codmed "+;
		" From medpresta where &mccpoamb codesp = ?vr_codesp "+;
		" group by codmed )", "mwkveops")

	if mret < 0
		mret=0
		do prg_cancelo
	else

		mret = sqlexec(mcon1, "update turnos set tipoturno  = ?mtipo2, observa = ?mtexto " + ;
			" where &mccpoamb afiliado <= 1 and tipoturno = ?mtipo1 and " + ;
			" fechatur = ?mfecha and codmed in ( select codmed "+;
			" From medpresta where &mccpoamb codesp = ?vr_codesp "+;
			"  group by codmed )")
	endif

endif

