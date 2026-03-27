Parameters mFecNac,mTipo,mAlta

If Empty(mFecNac) Or Isnull(mFecNac)
	Return ""
Endif

mtexto = ""

* Para pruebas
*Set Step On
*mTipo = 2
*mFecNac = "28/07/2017 21:10:00"
*mHoy = Ctot("06/07/2017 16:57:10") &&DATETIME()
* ----------------------------------------------

If Vartype(mFecNac)="C"
	mFecNac = Ctot(mFecNac)
Endif
If Vartype(mFecNac)="D"
	mFecNac = Dtot(mFecNac)
Endif

If Isnull(mAlta) Or Vartype(mAlta)#"D"
	mHoy = sp_busco_fecha_serv('DT')
Else
	mHoy = mAlta
Endif


Do Case

Case mTipo = 1

* mdias = (tTOD(mHoy)-tTOD(mFecNac)) && Devuelve días

	mEdadi = mHoy - mFecNac && Devuelve segundos

* 1 min = 60 seg
* 1 hor = 60 min = 3600 seg
* 1 dia = 24 hor = 1440 min = 86400 seg
* 1 mes = 2592000 seg
* 1 año = 31536000 seg

	mEdad = mEdadi/86400

	mHorai=mEdadi/3600
	If mHorai<1
		mMinu=mEdadi/60
		mtexto =  Alltrim(Str(mMinu)) + " Minutos"
	Else
		mtexto = Alltrim(Str(mHorai)) + " hora/s"
	Endif

	Return mtexto

Case mTipo = 2

	mtexto = ""
	FechaFinal = mHoy
	FechaInicial = mFecNac
	años = Year(FechaFinal) - Year(FechaInicial)
	meses = Month(FechaFinal) - Month(FechaInicial)
	dias = Day(FechaFinal) - Day(FechaInicial)
	nmes = Month(FechaFinal)
	If dias < 0
		If Inlist(nmes,1,3,5,7,8,10,12)
			dias = dias + 31
		Endif
		If Inlist(nmes,4,6,9,11)
			dias = dias + 30
		Endif
		If Inlist(nmes,2)
			If Day(FechaFinal)=28
				dias = dias + 28
			Else
				dias = dias + 29
			Endif
		Endif
		dias = dias + 1
		meses = meses - 1
	Endif
	If meses < 0
		meses = meses + 12
		años = años - 1
	Endif

	If dias + meses + años = 0 && Calculo Horas
		mEdadi = mHoy - mFecNac && Devuelve Segundos
		mEdad = mEdadi/86400
		mHorai=mEdadi/3600
		If mHorai<1
			mMinu=mEdadi/60
			mtexto =  Alltrim(Str(mMinu)) + " Minutos"
		Else
			mtexto = Alltrim(Str(mHorai)) + " hora/s"
		Endif
	Endif

	If años > 0
		If años = 1
			mtexto = Transform(años) + " Año "
		Else
			mtexto = Transform(años) + " Años "
		Endif
	Endif

	If meses > 0
		If meses = 1
			mtexto = mtexto + Transform(meses) + " Mes "
		Else
			mtexto = mtexto + Transform(meses) + " Meses "
		Endif
	Endif

	If dias > 0
		If dias = 1
			mtexto = mtexto + Transform(dias) + " Día "
		Else
			mtexto = mtexto + Transform(dias) + " Días "
		Endif
	Endif
Case mTipo = 3 &&de acuerdo a la OMS (dividir días de vida por 30,4375 y 365,25 para meses y años respectivamente)
&& para calculos y clasificaciones farmacológicas, escores, etc.
	mtexto = ""
	fechadia = Ttod(mHoy)
	mfec = Iif(Vartype(mFecNac) ="T",Ttod(mFecNac),Iif(Vartype(mFecNac) ="C",Ctod(mFecNac),mFecNac))
	aa = Year(fechadia) - Year(mfec)
	aa = aa - Iif(Month(fechadia) < Month(mfec),1,0)
	mm = Iif(Month(fechadia) < Month(mfec),12 - Month(mfec) + Month(fechadia),Month(fechadia) - Month(mfec) )
	mm = mm - Iif(Day(fechadia) < Day(mfec),1,0)
	If mm = -1
		aa = aa -1
		mm = 11
	Endif
	dd = Iif(Day(fechadia) >= Day(mfec),Day(fechadia) - Day(mfec), ;
		day( Ctod("01/"+Padl(Month(mfec+31),2,"0")+"/"+Str(Year(mfec+31),4)) -1 )- Day(mfec)+ Day(fechadia))

	diasdevida = fechadia - mfec

	If diasdevida  = 0 && Calculo Horas
		mEdadi = mHoy - mFecNac && Devuelve Segundos
		mEdad = mEdadi/86400
		mHorai=mEdadi/3600
		If mHorai<1
			mMinu=mEdadi/60
			mtexto =  Alltrim(Str(mMinu)) + " Minutos"
		Else
			mtexto = Alltrim(Str(mHorai)) + " hora/s"
		Endif
	Endif
	meses_v = Int(diasdevida /30.4375)
	meses_v_extra = meses_v
	años_v = Int(diasdevida /365.25)
	If Mod(diasdevida,365.25)>30
		meses_v_extra = Int(Mod(diasdevida,365.25)/30.4375)
	Else
		meses_v_extra = 0
	Endif
	Do Case
	Case diasdevida <31
		mtexto = Transform(diasdevida)
	Case diasdevida <731
		mtexto = Transf(años_v *10000+ Iif(años_v = 0,meses_v_extra,meses_v )*100)+ dd
		mtexto = Transform(meses_v)
		mtexto = Transform(años) + " Años "
	Endcase

Endcase

*Messagebox(mtexto) && Para pruebas
Return mtexto
