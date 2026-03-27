***********************************************
* AUTOR: Claudia Antoniow
* FECHA: 08/02/2002
* MODIFICADO POR ULT. VEZ:10/06/2002
***********************************************

do sp_busco_reservados_Kine
sele MWKResGuardiaInter
go top
dimension tipot(20)
store 0 to tipot
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
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
				mret=sqlexec(mcon1,'select tipoturno from turnos '+;
					'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
					'and tipoturno = ?itt and fechatur = ?mdmasX','mwkTurresCtrl')
				if reccount('mwkTurresCtrl') < tipot(itt)
					mret = sqlexec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, observa, codigo &mcicpoamb) "+;
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
			mntipotur=3
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
	if EOF('MWKResGuardiaInter')
		exit
	endif
enddo
for itt = 1 to 20
	if tipot(itt) > 0
	ctipot = tipot(itt)
		mret=sqlexec(mcon1,'select tipoturno from turnos '+;
			'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
			'and tipoturno = ?itt and fechatur = ?mdmasX','mwkTurresCtrl')
		if reccount('mwkTurresCtrl') < tipot(itt)
			mret = sqlexec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, observa, codigo &mcicpoamb) "+;
				"values (  ?mncodmed, ?itt, ?mdmasX, ?ctipot, ?myip, 22 &mvicpoamb) ")
		endif
	endif
next itt


