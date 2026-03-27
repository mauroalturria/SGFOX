*!*	--------------------------------------------------------------
*!*	PRESTACIONES QUE SE UTILIZAN PARA EL CONTROL DE DEMORAS
*!*	--------------------------------------------------------------
lparameters mopcion,mbusco
mfecnull = ctod("01/01/1900")
mfecha = sp_busco_fecha_serv("DD")
mret = Sqlexec(mcon1,"UPDATE Tabturdemora SET TD_fecpasiva = ?mfecha " + ;
	"WHERE TD_fecpasiva = ?mfecnull ")
select mwkGrilla
scan
	mcodprest = Pre_CodPrest
	mret = Sqlexec(mcon1,"SELECT id from Tabturdemora  " + ;
		"WHERE TD_codprest = ?mcodprest " ,"mwkDem")
	if reccount("mwkDem")>0
		mid = mwkDem.id
		mret = Sqlexec(mcon1,"UPDATE Tabturdemora SET TD_fecpasiva = ?mfecnull " + ;
			"WHERE id = ?id ")
	else
		mret = Sqlexec(mcon1,"insert into Tabturdemora (TD_agrupa, TD_codprest, TD_demora, TD_fecpasiva)"+;
			" values (0,?mcodprest,0,?mfecnull)")
	endif
	if mret <= 0
		=aerr(eros)
		messagebox(eros(3), 48, "VALIDACION")

	endif
	select mwkGrilla
endscan

