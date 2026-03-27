******************************
* AUTOR : Claudia Antoniow T.
* FECHA : 25/09/2003
******************************
* valida la franja horaria
******************************
PARAMETERS vr_med, vr_dia, vr_horades, vr_horahas,vr_fecha
if type('vr_horades')= "N"
	vr_horad = vr_horades
	vr_horah = vr_horahas
else
	vr_horad = val(left(strtran(left(ttoc(vr_horades,2),5),":",""),4))
	
	vr_horah = val(left(strtran(left(ttoc(vr_horahas,2),5),":",""),4))
endif

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

mret = sqlexec(mcon1,'SELECT * FROM medpresta WHERE &mccpoamb codmed =?vr_med '+;
						' AND diasem =?vr_dia AND hhmmdes = ?vr_horad '+;
						' AND hhmmhas = ?vr_horah '+;
						' AND ?vr_fecha between fecvigend and fecvigenh '+;
						' GROUP BY hdesde1,hhasta1','MWKExisteFr')

if mret < 0
	messagebox('ERROR EN EL CURSOR, AVISAR A SISTEMA ',64,'VALIDACION')
	mret = 0
endif						