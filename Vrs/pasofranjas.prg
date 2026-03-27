*****************************************************************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
******************************************************************************
* Modificado:18/06/2003
**********************************************
* hago un insert del registro de prestaciones
* al de medico -prestaciones
**********************************************
*do sp_conexion.prg
mret = sqlexec(mcon1,"SELECT * FROM medpresta " + ;
	"WHERE codesp = 'TOMO' and  diasem is null and codmed = 319 " ,"Mwkpresta1")
select Mwkpresta1
scan
	mnagenda =GeneraAgen
	mccodesp =codesp
	mncodmed=codmed
	mncodprest=codprest
	mncodserv=codserv
	mndia= DiaSem
	mtdura= ttoc(duracion,2)
	mcthrdes=ttoc(HoraDesde,2)
	mcthrhas= ttoc(HoraHasta,2)
	mcsala=  sala
	mfecvigend= fecvigend
	mfecvigenh=fecvigenh
	mdfecagen= fechaUltAgenda
	midusu= usuario
	fecaudi= fhgraba
	mncanttur= canturnos
	mdhdesde1=hdesde1
	mdhhasta1 =hhasta1
	mndemanda =demanda
	hhmmD  =hhmmDes
	hhmmH=hhmmHas

	mret = sqlexec(mcon1,"SELECT * FROM medpresta " + ;
		"WHERE codesp = 'TOMO' and  diasem is null and codmed = 1535 "+ ;
		" and codprest = ?mncodprest " ,"Mwkp")
	if reccount("Mwkp")= 0
	
		mret=sqlexec(mcon1,"INSERT INTO medpresta (codesp,codmed,codprest,codserv,usuario,fhgraba,canturnos) " + ;
			"values(?mccodesp,1535,?mncodprest,?mncodserv,?midusu,?fecaudi,?mncanttur)")

		if mret < 0
			=aerr(eros)
			messagebox(eros(3))
			set step on
		endif
	endif
endscan




mdate = date()
mret = sqlexec(mcon1,"SELECT * FROM franjahoraria " + ;
	"WHERE fecvigend < ?mdate and fecvigenh>=?mdate and " + ;
	"diasem > 3 and codmed = 319 " ,"Mwkfranja")


select Mwkfranja
scan
	mncodmed=1535
	mndia= DiaSem
	mctipostruc=estructura
	fecaudi= fechagraba
	mfecvigend= fecvigend
	mfecvigenh=fecvigenh
	mdhdesde1 =ttoc(HoraDesde,2)
	mdhhasta1= ttoc(HoraHasta,2)
	mnimparch=ImpArchivo
	mntipofranja=tiposervicio
	midusu= usuario
	mntipotur=tipoturno
	hhmmD  =hhmmDes
	hhmmH=hhmmHas

mret = sqlexec(mcon1," INSERT INTO FranjaHoraria ( codmed,  diasem,  estructura," +;
				       "  fechagraba, fecvigend, fecvigenh,  HoraDesde, HoraHasta,  " +; 
				       "  ImpArchivo, tiposervicio, usuario, tipoturno, hhmmDes, hhmmHas )             " +;
				       "  values (?mncodmed, ?mndia, ?mctipostruc, ?fecaudi,        " +;
				       "  ?mfecvigend, ?mfecvigenh, ?mdhdesde1 , ?mdhhasta1, ?mnimparch, " +;
				       "  ?mntipofranja, ?midusu, ?mntipotur, ?hhmmD, ?hhmmH )")
	

	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
		set step on
	endif
endscan
