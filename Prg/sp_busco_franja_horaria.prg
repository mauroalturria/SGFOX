****
**  Busca los horarios de un medico, diasem
****
LPARAMETERS lsinmk
if mxambito >1
	mccpoamb = " codambito = ?mxambito and "
else
	mccpoamb = ''	
endif
If Vartype(lsinMK)="N"
	mccpoamb  = mccpoamb + " usuario <> 'TURNOSMARKEY' AND "
Endif
mret=sqlexec(mcon1,"SELECT horadesde, horahasta, sala,codprest,id,usuario " + ;
	"from medpresta " + ;
	"where &mccpoamb codmed = ?mncodmed and diasem = ?mddiasem and " + ;
	"?mfecturno2 >= fecvigend  and ?mfecturno2 < fecvigenh " + ;
	"and  fecvigend <> fecvigenh " + ;
	"group by horadesde, horahasta " + ;
	"order by horadesde" ,"mwkfranjahora")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	do prg_cancelo
endif
*!*		If !Used('MwkUbica')
*!*			Do sp_muestra_ubicacion
*!*		Endif
*!*		Select MWKmedpresta1pre.* From MWKmedpresta1pre,MwkUbica ;
*!*			where centromedico = mxcentromedico And MWKmedpresta1pre.sala = lugar;
*!*			INTO Cursor MWKmedpresta1
***********************************
** Para reprogramacion frmturnos13
***************************************************
* le muestro las franjas vencidas 1 mes hacia atrás
***************************************************
mfecturno0 = sp_busco_fecha_serv('DD') - 30

mret=sqlexec(mcon1,"SELECT horadesde, horahasta, sala,codprest,id, fecvigend, fecvigenh ,usuario " + ;
	"from medpresta " + ;
	"where &mccpoamb codmed = ?mncodmed and diasem = ?mddiasem and " + ;
	" fecvigenh > ?mfecturno0 " + ;
	"and  fecvigend <> fecvigenh " + ;
	"group by horadesde, horahasta " + ;
	"order by horadesde" ,"mwkfranjahoraRep")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	do prg_cancelo
endif


********
** Con día de la semana
** para frmturno25
** Modificado:21/03/2003-Claudia
******

mfecturno2 = sp_busco_fecha_serv('DD')
if mxambito >1
	mccpoambm = " a.codambito = ?mxambito and "
else
	mccpoambm = ''	
endif
if mxambito >1
	mccpoambf = " f.codambito = ?mxambito and "
else
	mccpoambf = ''	
endif
	mccpocmed = " and centromed = ?mxcentromedico "

mret=sqlexec(mcon1,"SELECT a.diasem, a.horadesde, a.horahasta,f.horadesde,f.horahasta, "+;
	" a.sala,a.codprest,a.id,a.fecvigend,a.fecvigenh,a.hdesde1,a.hhasta1,a.usuario "+;
	" from medpresta as a,franjahoraria as f "+;
	" where &mccpoambf &mccpoambm a.codmed = ?mncodmed and "+;
	" a.diasem = f.diasem and a.horadesde = {fn convert(f.horadesde,sql_time)}"+;
	" and a.horahasta = {fn convert(f.horahasta,sql_time)} "+;
	" and a.fecvigend =f.fecvigend and a.fecvigenh=f.fecvigenh "+;
	" and a.fecvigenh >= ?mfecturno2 "+;
	" and  a.fecvigend <> a.fecvigenh " + ;
	" and  f.fecvigend <> f.fecvigenh " + mccpocmed +;
	" group by a.diasem, a.fecvigend, a.fecvigenh, a.horadesde,a.horahasta "+;
	" order by a.diasem, a.fecvigend, a.fecvigenh, a.horadesde,a.fecvigend " ,"mwkfranjahora1")


if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	mret=0
	do prg_cancelo
else

	select iif(diasem = 2,'Lun',iif(diasem = 3,'Mar',;
		iif(diasem = 4,'Mie',iif(diasem = 5,'Jue',;
		iif(diasem = 6,'Vie',iif(diasem = 7,'Sab','Dom')))))) as semana,;
		ttoc(horadesde,2) as horad,;
		ttoc(horahasta,2) as horah, sala,codprest,id, fecvigend,;
		fecvigenh, diasem,usuario ;
		from mwkfranjahora1 into cursor mwkfranjahora2


endif
