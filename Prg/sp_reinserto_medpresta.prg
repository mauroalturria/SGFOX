parameters cmed, dsem,hd, hh, fvd, fvh


mret=sqlexec(mcon1,"SELECT generaAgen, canturnos, codesp, codmed , "+;
	" codprest, codserv, demanda, diasem ,duracion,"+;
	" fecvigend , fecvigenh ,fechaultagenda, "+;
	" fhgraba, hdesde1, hhasta1, hhmmDes, hhmmHas, "+;
	" horadesde, horahasta , sala, usuario "+;
	" FROM medpresta "+;
	" WHERE codmed = ?cmed and diasem = ?dsem and "+;
	" horadesde =?hd and horahasta =?hh "+;
	" fecvigend=?fvd and fecvigenh =?fvh ","MWKMedprestaREI")

if mret < 0
	messagebox('Error de cursor, avisar a sistemas',16,'Validacion')
	mret=0
	cancel
else
	fgraba= sp_busco_fecha_ser('DT')

	sele MWKMedprestaREI
	go top
	scatt memv

	do while !eof("MWKMedprestaREI")
		mret=sqlexec(mcon1,"Insert into medpresta (generaAgen, canturnos,  "+;
			" codesp, codmed , codprest, codserv, demanda, diasem, "+;
			" duracion,fecvigend, fecvigenh, fechaultagenda, fhgraba, "+;
			" hdesde1, hhasta1, hhmmDes, hhmmHas, horadesde, horahasta,"+;
			" sala, usuario) "+;
			" Values (?m.generaAgen, ?m.canturnos, ?m.codesp, ?m.codmed , "+;
			" ?m.codprest, ?m.codserv, ?m.demanda, ?m.diasem ,?m.duracion,"+;
			" ?m.fecvigend , ?m.fecvigenh ,?m.fechaultagenda, "+;
			" ?fgraba, ?m.hdesde1, ?m.hhasta1, ?m.hhmmDes, ?m.hhmmHas, "+;
			" ?m.horadesde, ?m.horahasta , ?m.sala, ?midusu)" )
			
	endif

