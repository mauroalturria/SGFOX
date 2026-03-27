****
** busco Fecha de inicio del contagio por paciente
****

Parameters mnreg

mfecnul = Ctod("01/01/1900")
mhoy = sp_busco_fecha_serv("DD")
mret = SQLExec(mcon1,  "select * from ZabRegContagio where RC_nroregistracio = ?mnreg "+;
	"and RC_fechaPasiva =?mfecnul ","mwkinictgaux")
If Reccount("mwkinictgaux")>0
	Select mwkinictgaux
	Locate For RC_fechaFin > mhoy
	If !Eof()
		Return NVL(mwkinictgaux.RC_fechaIniSegmto,mwkinictgaux.RC_fechaInicio) 
	Else

		Return CTOD("01/01/1900")
	Endif
Else

	Return CTOD("01/01/1900")
Endif
