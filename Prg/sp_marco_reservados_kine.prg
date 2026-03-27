***********************************************
* AUTOR: Claudia Antoniow
* FECHA: 08/02/2002
* MODIFICADO POR ULT. VEZ:10/06/2002
***********************************************

Do sp_busco_reservados_Kine
Sele MWKResGuardiaInter
Go Top
Dimension tipot(20)
Store 0 To tipot
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif


mcicpoamb = ''
mvicpoamb = ''
If mxambito >1
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
Endif

Do While !Eof('MWKResGuardiaInter')

	mthrGuardia = MWKResGuardiaInter.guardia
	mthrInter   = MWKResGuardiaInter.internado
	mncodmed    = MWKResGuardiaInter.codmed
	mccodesp    = MWKResGuardiaInter.codesp
	mddiasem    = MWKResGuardiaInter.diasem
	mthorad     = MWKResGuardiaInter.Horadesde
	mthorah     = MWKResGuardiaInter.HoraHasta
	mntipotur   = MWKResGuardiaInter.tipoturno
	If mxambito =1 And  MWKResGuardiaInter.grupo < 2 And MWKResGuardiaInter.tipoturno<>6
		SKIP 1
		Loop
	Endif
	If 	mncodmed # MWKResGuardiaInter.codmed
		For itt = 1 To 20
			If tipot(itt) > 0
				ctipot = tipot(itt)
				mret=SQLExec(mcon1,'select tipoturno from turnos '+;
					'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
					'and tipoturno = ?itt and fechatur = ?mdmasX','mwkTurresCtrl')
				If Reccount('mwkTurresCtrl') < tipot(itt)
					mret = SQLExec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, observa, codigo &mcicpoamb) "+;
						"values (  ?mncodmed, ?itt, ?mdmasX, ?ctipot, ?myip, 22 &mvicpoamb) ")
				Endif
			Endif
		Next itt
		Store 0 To tipot
	Endif

	If Isnull(mthrInter)
		mthrInter=Datetime(Year(mthorad),Month(mthorad),Day(mthorad),0,0,0)
	Endif
	If Isnull(mthrGuardia)
		mthrGuardia=Datetime(Year(mthorad),Month(mthorad),Day(mthorad),0,0,0)
	Endif

* armo la hora que necesito buscar
	Do While Ttoc(mthorad,2) <= Ttoc(mthorah,2)
		nohay = 0
		If Minute(mthrGuardia) > 0
			If Isnull(MWKResGuardiaInter.tipoturno)
				mntipotur=3
			Endif
			mthorad   =Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),Hour(mthorad),Minute(mthrGuardia),0)
			tipot(mntipotur) = tipot(mntipotur) +1
			Do sp_modifico_tipoturno
		Else
			If Minute(mthrGuardia)= 0
				nohay = nohay + 1
			Endif
		Endif
		If  Minute(mthrInter) > 0
			mntipotur=3
			mthorad   =Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),Hour(mthorad),Minute(mthrInter),0)
			tipot(mntipotur) = tipot(mntipotur) +1
			Do sp_modifico_tipoturno
		Else
			If Minute(mthrInter)=0
				nohay = nohay + 1
			Endif
		Endif
		If nohay = 2
			Exit
		Else
			mvnuehs = Hour(mthorad) + 1
			If Minute(mthrGuardia) > 0
				mthorad   =Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),mvnuehs,Minute(mthrGuardia),0)
			Else
				mthorad   =Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),mvnuehs,Minute(mthrInter),0)
			Endif
		Endif
		Loop
	Enddo

	Skip 1 In MWKResGuardiaInter
	If Eof('MWKResGuardiaInter')
		Exit
	Endif
Enddo
For itt = 1 To 20
	If tipot(itt) > 0
		ctipot = tipot(itt)
		mret=SQLExec(mcon1,'select tipoturno from turnos '+;
			'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
			'and tipoturno = ?itt and fechatur = ?mdmasX','mwkTurresCtrl')
		If Reccount('mwkTurresCtrl') < tipot(itt)
			mret = SQLExec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, observa, codigo &mcicpoamb) "+;
				"values (  ?mncodmed, ?itt, ?mdmasX, ?ctipot, ?myip, 22 &mvicpoamb) ")
		Endif
	Endif
Next itt


