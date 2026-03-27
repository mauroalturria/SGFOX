***********************************************
* AUTOR: Claudia Antoniow
* FECHA: 21/04/2002
***********************************************
* MODIFICADO POR ULT. VEZ:19/06/2002
***********************************************
Lparameters mihorad,mihorah
Dimension tipot(20)
Store 0 To tipot
*mncodmed=4
fechatop=Ctod('01/01/1900')
If mxambito >1
	mccpoamb = "  a.codambito = ?mxambito and b.codambito = ?mxambito and "
Else
	mccpoamb = ' b.id>5000 and '
Endif
mcicpoamb = ''
mvicpoamb = ''
If mxambito >1
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
Endif

mret=SQLExec(mcon1,"SELECT  B.DIASEM,B.CODMED,B.CODESP,B.INTERNADO,B.GUARDIA,b.HORArDESDE, b.HORADESDE,"+;
	" b.HORArHASTA,b.HORAHASTA,B.TIPOTURNO,a.HORADESDE as hdesfran,a.HORAHASTA as hhasfran"+;
	" FROM medpresta AS a,TABRESERVADO AS B "+;
	" WHERE &mccpoamb A.CODMED=B.CODMED AND B.Diasem=?mddiasem AND generaagen >0 "+;
	" AND a.Diasem=?mddiasem AND  a.horadesde is not null "+;
	" and b.fecvigenh >= ?mdmasx and a.fecvigenh >= ?mdmasx and b.codmed = ?mncodmed " + ;
	" and b.fecvigenh > b.fecvigend "+;
	" ORDER BY B.codmed","MWKResGuardiaIntera")
Select DIASEM,CODMED,CODESP,INTERNADO,GUARDIA,Nvl(HORArDESDE,HORADESDE) As HORADESDE,;
	nvl(HORArHASTA,HORAHASTA) As HORAHASTA,TIPOTURNO,hdesfran,hhasfran From MWKResGuardiaIntera;
	where Ttoc(Nvl(HORArDESDE,HORADESDE),2)>=Ttoc(hdesfran,2) And Ttoc(Nvl(HORArHASTA,HORAHASTA),2)<=Ttoc(hhasfran,2) ;
	group  By  CODMED,GUARDIA,INTERNADO,HORADESDE,HORAHASTA,TIPOTURNO ;
	into Cursor MWKResGuardiaInter

&&& saco esto (guardia > 0 or b.internado >0 ) and
If mret < 0
	mret=0
Else
	Select MWKResGuardiaInter
	Scan
		mthrGuardia = MWKResGuardiaInter.GUARDIA
		mthrInter   = MWKResGuardiaInter.INTERNADO
		mncodmed    = MWKResGuardiaInter.CODMED
		mccodesp    = MWKResGuardiaInter.CODESP
		mddiasem    = MWKResGuardiaInter.DIASEM

		If Type('mihorad') = "U"
			mthorad     = MWKResGuardiaInter.HORADESDE
			mthorah     = MWKResGuardiaInter.HORAHASTA
		Else
			If mihorad = Ctot('00:00:00')
				mthorad     = MWKResGuardiaInter.HORADESDE
				mthorah     = MWKResGuardiaInter.HORAHASTA
			Else
				mthorad     = mihorad
				mthorah     = mihorah
			Endif

		Endif
		mntipotur   = MWKResGuardiaInter.TIPOTURNO
		If  (Ttoc(MWKResGuardiaInter.HORAHASTA-1,2)< Ttoc(mthorad,2) Or Ttoc(MWKResGuardiaInter.HORADESDE,2) >Ttoc(mthorah,2))
			Skip 1 In MWKResGuardiaInter
			If Eof('MWKResGuardiaInter')
				Exit
			Else
				Loop
			Endif
		Endif
		If Isnull(mthrInter)
			mthrInter=Datetime(Year(mthorad),Month(mthorad),Day(mthorad),0,0,0)
		Endif
		If Isnull(mthrGuardia)
			mthrGuardia=Datetime(Year(mthorad),Month(mthorad),Day(mthorad),0,0,0)
		Endif

* armo la hora que necesito buscar
		If mthorad > MWKResGuardiaInter.HORADESDE
			mthorad_ini   = mthorad
		Else
			mthorad_ini   = MWKResGuardiaInter.HORADESDE
		Endif
		If mthorah<MWKResGuardiaInter.HORAHASTA
			mthorah_ini   = mthorah
		Else
			mthorah_ini   = MWKResGuardiaInter.HORAHASTA
		Endif
		Do While Ttoc(mthorad_ini ,2) <= Ttoc(mthorah_ini,2)
			nohay = 0
			If Minute(mthrGuardia) > 0
				If Isnull(MWKResGuardiaInter.TIPOTURNO)
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
				If Isnull(MWKResGuardiaInter.TIPOTURNO)
					mntipotur=3
				Endif
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
		Select MWKResGuardiaInter
	Endscan
	If mxambito = 1
		mccpoamb = ' '
	Endif
	For itt = 1 To 20
		If tipot(itt) > 0
			ctipot = tipot(itt)
			mret=SQLExec(mcon1,'select tipoturno from turnos '+;
				'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
				'and tipoturno = ?itt and fechatur = ?mdmasX','mwkTurresCtrl')
			If Reccount('mwkTurresCtrl') < tipot(itt)
				mret = SQLExec(mcon1, "insert into turnosaudit (afiliado, turnoid,"+;
					" fechatomado, usuario, observa, codigo &mcicpoamb ) "+;
					"values (  ?mncodmed, ?itt, ?mdmasX, ?ctipot, ?myip, 22 &mvicpoamb) ")
			Endif
		Endif
	Next itt

Endif
