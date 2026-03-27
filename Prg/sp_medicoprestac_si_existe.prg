*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
* MODIFICADO:13/09/2002
*****************************************************************
* Esta rutina ejecuta el cursor de médicos que tienen
* prestaciones ya asignadas, recibe como variables el
* codigo del médico,especialidad, prestacion, Día de la semana
* hora desde y hasta disponibles del médico y vigencias
*****************************************************************
*do sp_conexion.prg
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and medpresta.codambito = ?mxambito "
endif

If Type('mthrdes')= "N"
	vr_horad = mthrdes
	vr_horah = mthrhas
Else
	vr_horad = Val(Left(Strtran(mthrdes,":",""),4))
	vr_horah = Val(Left(Strtran(mthrhas,":",""),4))
Endif

mret=SQLExec(mcon1," SELECT * FROM medpresta WHERE codmed = ?mncodmed " + ;
	" AND codesp  = ?mccodesp AND codprest = ?mncodprest  " + ;
	" AND codserv = ?mncodserv AND diasem = ?mndia   "+;
	" AND hhmmdes = ?vr_horad AND hhmmhas = ?vr_horah " + ;
	" AND fecvigend <> fecvigenH "+;
	" AND not ( fecvigenH  <= ?mdfecvigend or fecvigend > ?mdfecVigenh  ) "+;
	mccpoamb ,"MWKmedprestaUnico")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR MWKmedprestaUnico, REINTENTE",16, "Validacion")
	mret = 0
Endif
