*************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*************************
* MODIFICADO:14/05/2003
****************************************************************************
* Trae en funcion de un codigo de médicos  y una prestacion y su duracion  *
* los horarios de esa prestacion,sala,y demás datos                        *
* Sirve para validar si se ingresa una prestacion con diferentes duraciones*
****************************************************************************
If Type('mthrdes')= "N"
	vr_horad = mthrdes
	vr_horah = mthrhas
Else
	vr_horad = Val(Left(Strtran(mthrdes,":",""),4))
	vr_horah = Val(Left(Strtran(mthrhas,":",""),4))
Endif
mccpoamb = ''
If mxambito >1
	mccpoamb = "  and medpresta.codambito = ?mxambito "
Endif

mret=SQLExec(mcon1,"SELECT * FROM Medpresta WHERE codmed=?mncodmed AND "+;
	" duracion<>?mtdura AND diasem = ?mndia and fecvigend <> fecvigenH  "+mccpoamb +;
	"AND hhmmdes = ?vr_horad AND hhmmhas = ?vr_horah " + ;
	"AND ( ?mdfecvigend BETWEEN fecvigend AND fecvigenH  " + ;
	"OR ?mdfecVigenh BETWEEN fecvigend AND fecvigenH ) ","MwkMedDura" )

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR DURACION, REINTENTE",16, "Validacion")
	mret=0
Endif
