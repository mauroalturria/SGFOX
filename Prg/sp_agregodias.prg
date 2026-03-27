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

fecaudi   = sp_busco_fecha_serv('DT')
if type('mthrdes') = 'N'
	mdhdesde1 	= ctot('01/01/1900 '+ strtran(transf(mthrdes*100,"99:99:99")," ","0") )
	mdhhasta1 	= ctot('01/01/1900 '+ strtran(transf(mthrhas*100,"99:99:99")," ","0") )
	hhmmD		= mthrdes
	hhmmH		= mthrhas
	mcthrdes	= strtran(transf(mthrdes*100,"99:99:99")," ","0")
	mcthrhas	= strtran(transf(mthrhas*100,"99:99:99")," ","0")
	
else
	mdhdesde1 	= ctot('01/01/1900 '+ mthrdes)
	mdhhasta1 	= ctot('01/01/1900 '+ mthrhas)
	hhmmD		= val(left(mthrdes,2)+substr(mthrdes,4,2))
	hhmmH		= val(left(mthrhas,2)+substr(mthrhas,4,2))
	mcthrdes	= mthrdes
	mcthrhas	= mthrhas
endif
mccampo = ''
mvcampo = ''
if mxambito >1
	mccampo = ", codambito "
	mvcampo = ", ?mxambito "
endif

 mret=sqlexec(mcon1," INSERT INTO medpresta(GeneraAgen, codesp, codmed, codprest,  codserv, "+;
				   " DiaSem, duracion, HoraDesde, HoraHasta,reservados , sala, fecvigend,  " +; 
				   " fecvigenh, fechaUltAgenda, usuario, fhgraba, canturnos,   " +;
				   " hdesde1, hhasta1, demanda, hhmmDes, hhmmHas &mccampo  ) values (?mnagenda,?mccodesp,  ?mncodmed,         " +;
				   " ?mncodprest, ?mncodserv, ?mndia, ?mtdura,      " +;
				   " ?mcthrdes, ?mcthrhas, ?optres, ?mcsala,  ?mfecvigend, ?mfecvigenh,   " +;
				   " ?mdfecagen, ?midusu, ?fecaudi, ?mncanttur, ?mdhdesde1,    " +;
				   " ?mdhhasta1, ?mndemanda, ?hhmmD, ?hhmmH &mvcampo )")

if mret < 0
	messagebox("Los datos No se pudieron Grabar",16, "Validacion") 
	mret=0

else
	vr_ok_prest = .t.
	*wait 'Los Datos Se guardaron Exitosamente!!!' window nowait timeout 120	
endif	
*endif

