lparameters mafili

if vartype(mcon3)= "U"
	public mcon3
	mcon3 = 0
endif
moldambito = mxambito

mcon3 = 0
if !used("mwktabambito")
	do sp_busco_tabla_id with 'tabambito', '  ','mwktabambito'
	select mwktabambito
	locate for id = mxambito
endif
do sp_busco_estados with 126, '',"mwksuperamb"
mcon1a = mcon1
do sp_conexion_sa with "OTROAMBITO"
if mcon3>0
	mcon1 = mcon3
	mcadcon = mwkambitoini.ini
	nlineas = alines(mimatini,mcadcon)
	lEXE = ascan(mimatini,"[OTROAMBITO]")
	lexeini = lEXE +1
	lsuper = ascan(mimatini,"[SUPER]", lexeini)
	mSuper 	= val(mimatini(1+lsuper))
	select mwksuperamb
	locate for estado = msuper
	mxambito = msuper
***
	mexisBristol = .t.
	mret = sqlexec(mcon1, "select codambito from turnos " + ;
		"where afiliado = ?mafili group by codambito " , "mwkconsumos")
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_controlbristol'
	endif
	lbuscohis = .f.
	if used("mwkconsumos")
		if reccount("mwkconsumos")=0
			lbuscohis = .t.
		endif
	else
		lbuscohis = .t.
	endif
	if 	lbuscohis
		mret = sqlexec(mcon1, "select codambito from turnoshis " + ;
			"where afiliado = ?mafili group by codambito " , "mwkconsumos")
		if mret < 0
			=aerr(eros)
			do prg_error with eros,'sp_controlbristol'
		endif
		lbuscohis = .f.
		if used("mwkconsumos")
			if reccount("mwkconsumos")=0
				lbuscohis = .t.
			endif
		else
			lbuscohis = .t.
		endif
		if 	lbuscohis
			mret = sqlexec(mcon1, "select codambito from turnoscancel " + ;
				"where afiliado = ?mafili group by codambito " , "mwkconsumos")
			if mret < 0
				=aerr(eros)
				do prg_error with eros,'sp_controlbristol'
			endif
		endif
	endif
	mret = sqlexec(mcon1, "select HIS_nroregistrac " + ;
		"from  histambgua, valesasist " + ;
		"where HIS_codadmision = VAL_codadmision and " + ;
		"VAL_codsector = 'AMB' and " + ;
		"his_nroregistrac = ?mafili " , "mwkconsumosv")

	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_controlbristol'
	endif
	if reccount("mwkconsumos")=0 and reccount("mwkconsumosv")=0
		mexisBristol = .f.
	endif

*******
	select * from mwkconsumos,mwktabambito where codambito=mwktabambito.id into cursor mwkconsumos

	mcon1 = mcon1a
	do sp_desconexion_sa with "sp_control_bristol"
	use in select("mwksuperamb")
	mxambito = moldambito
endif
release mcon3
