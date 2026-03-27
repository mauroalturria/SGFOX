*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************

*****************************************************
* Carga los trunos de sobreoferta
*****************************************************
parameter vr_tipotur, vr_porc,vr_horad_teo, vr_horah_teo,SOtipoPE

if vartype(SOtipoPE)="U"
	SOtipoPE = .f.
endif

do sp_primer_turno_disponible with SOtipoPE
if !eof('MwkPrimertur') and !isnull(MwkPrimertur.horadesde)				   
	mthorad    = datetime(year(mtfechatur),month(mtfechatur),;
		day(mtfechatur),hour(MwkPrimertur.horadesde),;
		minute(MwkPrimertur.horadesde),0)  && campo de insert
else	
	mthorad    = datetime(year(mtfechatur),month(mtfechatur),;
	day(mtfechatur),hour(MWKSobre.horadesde),;
	minute(MWKSobre.horadesde),0)  && campo de insert
endif
do sp_ultimoturno_sobreoferta with "SO",SOtipoPE

if !eof('MWKUltTurno') and !isnull(MWKUltTurno.ulthr)				   
	mthorah    = datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),;
		hour(MWKUltTurno.ulthr),minute(MWKUltTurno.ulthr),0)  && campo de insert
else
	mthorah    = datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),;
	hour(MWKSobre.horahasta),minute(MWKSobre.horahasta),0)  && campo de insert
endif	

mccodesp   = "" && MWKHorasTr.codesp    &&campo de insert
mncodserv  = 0 && MWKHorasTr.codserv   &&campo de insert

* calculo la cant de horas que trabaja el prestador
mttot_minH = hour(mthorah)*60 + minute(mthorah)
mttot_minD = hour(mthorad)*60 + minute(mthorad)
mnsumat    = mttot_minH - mttot_minD
* Calculo el intervalo de sobreoferta
mtduraMin  = round(Mod((mnsumat/ROUND(MwkPorcSOfer.porc+1,0)),60),0) 
mtHoraMin  = int((mnsumat/ROUND(MwkPorcSOfer.porc+1,0))/60)
if mtduraMin =60
	mtduraMin  = 0
	mtHoraMin  = mtduraMin + 1
endif
mtdura     = datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),mthoramin,mtduraMin,0)  && campo de insert
mntipotur  = iif(SOtipoPE,7,1)  &&campo de insert
mcObservac = iif(SOtipoPE,"SO En PE","")
mthorad = SumaTime(mthorad,mtdura,mtfechatur,0)
mcanso = 0
*do sp_genero_turnos.prg
do while mthorad < mthorah and mcanso < MwkPorcSOfer.porc
	do sp_valido_turnos
	sele MWKExisteTurno
	go top
	if eof('MWKExisteTurno') or bof('MWKExisteTurno') 
		if !used("MWKValCtrlTur")
			do sp_inserto_turno 
		Endif 
		mcanso = mcanso +1
		mthorad = SumaTime(mthorad,mtdura,mtfechatur,0)
	else
		mthorad = SumaTime(mthorad,'',mtfechatur,3)
	endif
	loop
enddo	


************************************************************
************************************************************
Function SumaTime(vrFechaHr1,vrFechaHr2,vrFechaX,vrMinu_mas)
************************************************************
mttot_min1 =0
mttot_min2 =0
if !isblank(vrfechax)
	mddate = vrFechaX
else
	if used('MWKFecServ')
		mddate = iif(type('MWKFecServ.fechaHora')#'T',ttod(MWKFecServ.fechaHora),MWKFecServ.fechaHora)
	else
		mddate = sp_busco_fecha_serv('DD')
	endif	
endif	
if !isblank(vrFechaHr1)
	mttot_min1 = hour(vrFechaHr1)*60 + minute(vrFechaHr1)
endif
if !isblank(vrFechaHr2)
	mttot_min2  = hour(vrFechaHr2)*60 + minute(vrFechaHr2)
endif
mnsumat    = mttot_min1 + mttot_min2+vrMinu_mas

if mnsumat > 0  
  if int(mnsumat/60) > 24
  	 mthr  = int(mnsumat/60)%24     &&Modulo 24
  else
   	 mthr  = int(mnsumat/60)
  endif 	 
  mtmin = (mnsumat % 60)   &&Modulo 60
  
  mdtime= datetime(year(mddate),month(mddate),day(mddate),mthr,mtmin,0)
****************************
* Armo el string del time
*****************************
  mchr  = strtran(str(mthr,2),' ','0')
  mcmin = strtran(str(mtmin,2),' ','0')
  mttime = mchr + ':' + mcmin + ':00' 
endif
RETURN mdtime

