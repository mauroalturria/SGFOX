*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
* MODIFICADO:23/07/2003
*******************************
parameter mfectur1, midmedico, vr_horad, vr_horah
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

if type('vr_horad')="N"
	mret = sqlexec(mcon1, "SELECT * FROM turnos " + ;
		" WHERE &mccpoamb codmed = ?midmedico and fechatur = ?mfectur1 " + ;
		" ", "mwkRephorariosst")
	if mret < 0
		=aerr(eros)
		messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
		messagebox(eros(3))
	endif

	select * from mwkRephorariosst ;
		where between (hhmmtur ,vr_horad,vr_horah) ;
		and afiliado > 0 order by diasem, horatur into cursor mwkRephorarios
else
	mret = sqlexec(mcon1, "SELECT * FROM turnos " + ;
		" WHERE &mccpoamb codmed = ?midmedico and fechatur = ?mfectur1 " + ;
		" ", "mwkRephorariosst")
	if mret < 0
		=aerr(eros)
		messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
		messagebox(eros(3))
	endif
	select * from mwkRephorariosst ;
		where between (horatur ,vr_horad,vr_horah) ;
		and afiliado > 0 order by diasem, horatur into cursor mwkRephorarios
endif
*		" fechatur = ?mfectur1 and " + 
*and hhmmtur between ?vr_horad and ?vr_horah 
*and horatur between ?vr_horad and ?vr_horah 
if mret < 0
	do prg_cancelo
endif
