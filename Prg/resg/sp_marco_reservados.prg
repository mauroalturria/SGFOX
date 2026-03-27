***********************************************
* AUTOR: Claudia Antoniow
* FECHA: 08/02/2002
* MODIFICADO POR ULT. VEZ:08/02/2002
***********************************************
do sp_busco_reservados
dimension tipot(20)
store 0 to tipot
dimension ntipot(20)
store '' to ntipot
mret = SQLExec(mcon1, "SELECT tipoturno, Abreviatura FROM Tabtipoturno ", "mwkTTCXN")
select mwkTTCXN
scan
	if tipoturno>0
		ntipot(tipoturno)=Abreviatura
	endif
endscan
use in select('controlturno')
create cursor  controlturno (codmed n(9),nombre c(50),cantfranja n(5),cantreal n(5),tipoturno n(2),descrip c(5))
if mxambito >1
	mccpoamb = " codambito = ?mxambito and "
else
	mccpoamb = ''
endif


mcicpoamb = ''
mvicpoamb = ''
if mxambito >1
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
endif

do while !eof('MWKResGuardiaInter')

	mthrGuardia = MWKResGuardiaInter.guardia
	mthrInter   = MWKResGuardiaInter.internado
	mncodmed    = MWKResGuardiaInter.codmed
	mccodesp    = MWKResGuardiaInter.codesp
	mddiasem    = MWKResGuardiaInter.diasem
	mthorad     = MWKResGuardiaInter.Horadesde
	mthorah     = MWKResGuardiaInter.HoraHasta
	mntipotur   = MWKResGuardiaInter.tipoturno
	if 	mncodmed # MWKResGuardiaInter.codmed
		for itt = 1 to 20
			if tipot(itt) > 0
				ctipot = tipot(itt)
				mret=sqlexec(mcon1,'select tipoturno,nombre from turnos,prestadores '+;
					'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed and codmed = prestadores.id '+;
					'and tipoturno = ?itt and fechatur = ?mdmasX','mwkTurresCtrl')
				if reccount('mwkTurresCtrl') < tipot(itt)
					*
					insert into controlturno values (mncodmed,mwkTurresCtrl.nombre ,tipot(itt),reccount('mwkTurresCtrl') ,itt,ntipot(itt))
					mret = sqlexec(mcon1, "insert into turnosaudit (afiliado, turnoid,"+;
						" fechatomado, usuario, observa, codigo &mcicpoamb ) "+;
						"values (  ?mncodmed, ?itt, ?mdmasX, ?ctipot, ?myip, 22 &mvicpoamb) ")

				endif
			endif
		next itt
		store 0 to tipot
	endif

	if isnull(mthrInter)
		mthrInter=datetime(year(mthorad),month(mthorad),day(mthorad),0,0,0)
	endif
	if isnull(mthrGuardia)
		mthrGuardia=datetime(year(mthorad),month(mthorad),day(mthorad),0,0,0)
	endif

* armo la hora que necesito buscar

	do while ttoc(mthorad,2) <= ttoc(mthorah,2)
		nohay = 0
		if minute(mthrGuardia) > 0
			if isnull(MWKResGuardiaInter.tipoturno)
				mntipotur=3
			endif
			mthorad   =datetime(year(mdmasX),month(mdmasX),day(mdmasX),hour(mthorad),minute(mthrGuardia),0)
			tipot(mntipotur) = tipot(mntipotur) +1
			do sp_modifico_tipoturno
		else
			if minute(mthrGuardia)= 0
				nohay = nohay + 1
			endif
		endif
		if  minute(mthrInter) > 0
			if isnull(MWKResGuardiaInter.tipoturno)
				mntipotur=3
			endif
			mthorad   =datetime(year(mdmasX),month(mdmasX),day(mdmasX),hour(mthorad),minute(mthrInter),0)
			tipot(mntipotur) = tipot(mntipotur) +1
			do sp_modifico_tipoturno
		else
			if minute(mthrInter)=0
				nohay = nohay + 1
			endif
		endif
		if nohay = 2
			exit
		else
			mvnuehs = hour(mthorad) + 1
			if minute(mthrGuardia) > 0
				mthorad   =datetime(year(mdmasX),month(mdmasX),day(mdmasX),mvnuehs,minute(mthrGuardia),0)
			else
				mthorad   =datetime(year(mdmasX),month(mdmasX),day(mdmasX),mvnuehs,minute(mthrInter),0)
			endif
		endif
		loop
	enddo

	skip 1 in MWKResGuardiaInter
	if eof('MWKResGuardiaInter')
		exit
	endif
enddo
for itt = 1 to 20
	if tipot(itt) > 0
		ctipot = tipot(itt)
		mret=sqlexec(mcon1,'select tipoturno,nombre from turnos,prestadores '+;
			'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed and codmed = prestadores.id '+;
			'and tipoturno = ?itt and fechatur = ?mdmasX','mwkTurresCtrl')
		if reccount('mwkTurresCtrl') < tipot(itt)
				*	set step on
			mret = sqlexec(mcon1, "insert into turnosaudit (afiliado, turnoid,"+;
				" fechatomado, usuario, observa, codigo &mcicpoamb) "+;
				"values (  ?mncodmed, ?itt, ?mdmasX, ?ctipot, ?myip, 22 &mvicpoamb) ")
			insert into controlturno values (mncodmed,mwkTurresCtrl.nombre ,tipot(itt),reccount('mwkTurresCtrl') ,itt,ntipot(itt))
		endif
	endif
next itt
if reccount('controlturno')>0
	select controlturno
	go top
	mfecha = date()
	mcpathact = allt(sys(5))+sys(2003)
	cd "C:\tempdoc"
	i=0
	mcarch = "RES"+ alltrim(dtos(mfecha))+'.xls'
	do while file(mcarch )
		i=i+1
		mcarch = "RES"+ alltrim(dtos(mfecha))+alltrim(str(i,2,0))+'.xls'
	enddo
	copy to &mcarch type xl5
	cd alltrim(mcpathact)
	messagebox("FALTO TIPIFICAR ALGUNOS TURNOS, CONTROLE EL ARCHIVO QUE SE ENCUENTRA EN LA CARPETA TEMPDOC LLAMADO "+MCARCH,64,"Control de Turnos")
ENDIF

