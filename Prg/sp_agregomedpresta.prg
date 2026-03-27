*!*	PARAMETERS mnagenda,mccodesp,mncodmed,mncodprest, mncodserv,mndia, mtdura,mcthrdes, mcthrhas, mcsala,;
*!*	 mfecvigend, mfecvigenh,mdfecagen, midusu, mfhgraba, mncanttur, mdhdesde1,mdhhasta1,mndemanda, ;
*!*	 hhmmD,hhmmH

mfhgraba    = sp_busco_fecha_serv('DT')
mccampo = ''
mvcampo = ''
if mxambito >1
	mccampo = ", codambito "
	mvcampo = ", ?mxambito "
endif
mret=sqlexec(mcon1," INSERT INTO medpresta (GeneraAgen, codesp, codmed, codprest,  codserv, "+;
	" DiaSem, duracion, HoraDesde, HoraHasta, reservados ,sala, fecvigend,  " +;
	" fecvigenh, fechaUltAgenda, usuario, fhgraba, canturnos,   " +;
	" hdesde1, hhasta1, demanda, hhmmDes, hhmmHas &mccampo ) values (?mnagenda,?mccodesp,  ?mncodmed,         " +;
	" ?mncodprest, ?mncodserv, ?mndia, ?mtdura,      " +;
	" ?mcthrdes, ?mcthrhas, 0,?mcsala,  ?mfecvigend, ?mfecvigenh,   " +;
	" ?mdfecagen, ?midusu, ?mfhgraba, ?mncanttur, ?mdhdesde1,    " +;
	" ?mdhhasta1, ?mndemanda, ?hhmmD, ?hhmmH &mvcampo)")

if mret < 0
	=aerr(eros)
	messagebox("Los datos No se pudieron Grabar",16, "Validacion")
	messagebox(eros(3))
	mret=0

else
	vr_ok_prest = .t.
*wait 'Los Datos Se guardaron Exitosamente!!!' window nowait timeout 120
endif
*endif

