*****************************************************************************
* AUTOR:Claudia Antoniow
* FECHA:18/06/2003
******************************************************************************
* Modificado:18/06/2003
**********************************************
* hago un insert del registro de prestaciones
* al de medico -prestaciones
**********************************************
*do sp_conexion.prg
*!*	parameters mncodmed, mndia, mctipostruc,mfecvigend, mfecvigenh, mthrdes, ;
*!*			   mthrhas, mnimparch, mntipofranja,midusua,  mntipotur

fecaudi   = sp_busco_fecha_serv('DT')
mccampo = ''
mvcampo = ''
If mxambito >1
	mccampo = ", codambito "
	mvcampo = ", ?mxambito "
Endif
If Type('mthrdes')='N'
	mdhdesde1 = Ctot('01/01/1900 '+ Strtran(Transf(mthrdes*100,"99:99:99")," ","0"))
	mdhhasta1 = Ctot('01/01/1900 ' + Strtran(Transf(mthrhas*100,"99:99:99")," ","0"))

	hhmmD		= mthrdes
	hhmmH		= mthrhas
Else
	mdhdesde1 = Ctot('01/01/1900 '+ mthrdes)
	mdhhasta1 = Ctot('01/01/1900 ' + mthrhas)

	hhmmD		= Val(Left(mthrdes,2)+Substr(mthrdes,4,2))
	hhmmH		= Val(Left(mthrhas,2)+Substr(mthrhas,4,2))
Endif


mret = SQLExec(mcon1," INSERT INTO FranjaHoraria ( codmed,  diasem,  estructura," +;
	"  fechagraba, fecvigend, fecvigenh,  HoraDesde, HoraHasta,  " +;
	"  ImpArchivo, tiposervicio, usuario, tipoturno, hhmmDes, hhmmHas,centromed &mccampo )" +;
	"  values (?mncodmed, ?mndia, ?mctipostruc, ?fecaudi,        " +;
	"  ?mfecvigend, ?mfecvigenh, ?mdhdesde1 , ?mdhhasta1, ?mnimparch, " +;
	"  ?mntipofranja, ?midusu, ?mntipotur, ?hhmmD, ?hhmmH,?mxcentromedico &mvcampo )")

If mret < 0
	Messagebox("Los datos No se pudieron Grabar en la franja, avisar a sistemas",16, "Validacion")
	mret=0
Else
	Wait 'Los Datos Se guardaron Exitosamente!!!' Window Nowait Timeout 120
Endif


