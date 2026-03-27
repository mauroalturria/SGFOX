***************************
*Claudia Antoniow
*FECHA: 28/06/2002
*MODIFICADO:02/06/03
*******************************
* Trae la hora del primer turno
********************************
lparameters sope
if vartype(sope) = "U"
	sope = .f.
endif
tt = iif(sope,",7","")

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif
fhorahasta = datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),;
	hour(vr_horah_teo),minute(vr_horah_teo),0)
fhoradesde = datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),;
	hour(vr_horad_teo),minute(vr_horad_teo),0)

mret=sqlexec(mcon1,"select min(horatur) as horadesde FROM Turnos, Tabtipoturno " + ;
	" where &mccpoamb Turnos.tipoturno = Tabtipoturno.tipoturno and fechatur=?mtfechatur "+;
	" and codmed=?mncodmed and Tabtipoturno.grupo IN (0,1,3) " +;
	" and horatur between ?fhoradesde and ?fhorahasta ",'MwkPrimertur')

if mret < 0
	messagebox('ERROR DEL CURSOR 1ER TURNO, REINTENTE',36,'VALIDACION')
	mret=0
endif
