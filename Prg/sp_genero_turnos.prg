*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
LPARAMETERS mnnnada
mxcantur = mncanttur
 
Do While mthorad < mthorah

	mntipotur = Iif(Isnull(mntipotur),0,mntipotur)
&& busco turnos para un medico
&& si no hay busco en turnos bloqueados
	Do sp_valido_turnos.prg
&&

	Sele MWKExisteTurno
	Go Top

	mxcantur = Iif(Nvl(MWKExisteTurno.bloqueo,0) = 0,Reccount('MWKExisteTurno'),Nvl(mncanttur,1)) &&& si esta bloqueado no genra nada
*	if reccount('MWKExisteTurno') < nvl(mncanttur,1)
	If mxcantur < Nvl(mncanttur,1)
		If !(mncanttur > 0) Or Isnull(mncanttur)
			mxcantur=1
		Else
			mxcantur = mncanttur - Reccount('MWKExisteTurno')
		Endif
		If !Used("MWKValCtrlTur")
			For i=1 To mxcantur Step 1
				Do sp_inserto_turno.prg
			Endfor
		Endif
		mthorad = SumaTime(mthorad,mtdura,mtfechatur,0)
	Else
		If (mntipotur = 2 Or mntipotur = 1)  
* Sobreoferta=2 o Sobreturno=1 sumo 3 minutos a la hora del turno
			mthorad = SumaTime(mthorad,'',mtfechatur,3)
		Else
*if inlist(mntipotur,0,3,4,5,6,7)
* turnos Normales o reservados para internados
			mthorad = SumaTime(mthorad,mtdura,mtfechatur,0)
		Endif
	Endif
	Loop
Enddo
*sele MWKmedpresta1




************************************************************
************************************************************
Function SumaTime(vrFechaHr1,vrFechaHr2,vrFechaX,vrMinu_mas)
************************************************************
mttot_min1 =0
mttot_min2 =0
If !Isblank(vrFechaX)
	mddate = vrFechaX
Else
	If Used('MWKFecServ')
		mddate = Iif(Type('MWKFecServ.fechaHora')#'T',Ttod(MWKFecServ.fechaHora),MWKFecServ.fechaHora)
	Else
		mddate = sp_busco_fecha_serv('DD')
	Endif
Endif
If !Isblank(vrFechaHr1)
	mttot_min1 = Hour(vrFechaHr1)*60 + Minute(vrFechaHr1)
Endif
If !Isblank(vrFechaHr2)
	mttot_min2  = Hour(vrFechaHr2)*60 + Minute(vrFechaHr2)
Endif
mnsumat    = mttot_min1 + mttot_min2+vrMinu_mas

If mnsumat > 0
	If Int(mnsumat/60) >= 24
		mthr  = Int(mnsumat/60)%24     &&Modulo 24
	Else
		mthr  = Int(mnsumat/60)
	Endif
	mtmin = (mnsumat % 60)   &&Modulo 60
	mddate = mddate +  Iif (mnsumat>= 1440,1,0)
	mdtime= Datetime(Year(mddate),Month(mddate),Day(mddate),mthr,mtmin,0)
****************************
* Armo el string del time
*****************************
	mchr  = Strtran(Str(mthr,2),' ','0')
	mcmin = Strtran(Str(mtmin,2),' ','0')
	mttime = mchr + ':' + mcmin + ':00'
Endif
Return mdtime

