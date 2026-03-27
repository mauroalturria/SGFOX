
****************************
* Autor:Claudia C. Antoniow
****************************
* Fecha :22/05/2003
**************************************
* Fecha Ult. Modificacion:22/05/2003
**************************************
parameters vr_cant, vr_med, vr_fecha, vr_tipotur, vr_diasem, vr_horad, vr_horah

do sp_cantidad_turnos_generados with vr_med, vr_fecha, vr_diasem, vr_horad, vr_horah,' tipoturno in (0 ) '
									   
if used('MwkCantxFranja')
	if MwkCantxFranja.totalturnos > 0
		mncant   = Round((MwkCantxFranja.totalturnos /vr_cant),0)
		
		mttot_minH = hour(vr_horah)*60 + minute(vr_horah)
		mttot_minD = hour(vr_horad)*60 + minute(vr_horad)
		mnsumat    = mttot_minH - mttot_minD

		* Calculo el intervalo de sobreoferta

		mtduraMin  = round(Mod((mnsumat/ROUND(mncant,0)),60),0) 
		mtHoraMin  = int((mnsumat/ROUND(mncant,0))/60)

		if mtduraMin   = 60
			mtduraMin  = 0
			mtHoraMin  = mtduraMin + 1
		endif

		mtdura   = datetime(year(vr_fecha),month(vr_fecha),day(vr_fecha),mthoramin,mtduraMin,0)
		mthora_r = datetime(year(vr_fecha),month(vr_fecha),day(vr_fecha),hour(vr_horad),minute(vr_horad),0)
		for i=1 to vr_cant
		* tengo que  buscar el turno
			
			if sp_busco_turno_res (vr_med, vr_diasem, mthora_r,'0')
				do sp_modifico_tipoturno with vr_tipotur, vr_med, vr_diasem, '0', mthora_r
				mthora_r = SumaTime(mthora_r, mtdura, vr_fecha,0)
			endif
			
			do while not sp_busco_turno_res (vr_med, vr_diasem, mthora_r,'0')
				if ttoc(mthora_r,2) < ttoc(vr_horah,2)
					mthora_r = SumaTime(mthora_r, '', vr_fecha,1)
				else
					i = vr_cant
					exit	
				endif	
			enddo
		endfor	
	endif
endif			






**********************************************************************
Function sp_busco_turno_res 
***********************************************************************
parameters vr_med, vr_diasem, vr_hora_r, vr_tipo_tur_mod


if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

mret =sqlexec(mcon1,"select id from turnos where &mccpoamb codmed  = ?vr_med "+;
					"and diasem = ?vr_diasem and horatur = ?vr_hora_r "+;
					"and tipoturno in (" +  vr_tipo_tur_mod + ")","mwkturbus")

if mret < 0
	messagebox("ERROR DE CURSOR, TURNOS A RESERVAR",16,"VALIDACION")
	mret = 0
	return .t.
else
	if !eof('mwkturbus')
		return .t.
	else
		return .f.
	endif	
endif		
endfunc		

************************************************************
************************************************************
Function SumaTime(vrFechaHr1,vrFechaHr2,vrFechaX,vrMinu_mas)
************************************************************
mttot_min1 =0
mttot_min2 =0

if !isblank(vrfechax)
	mddate = vrFechaX
else
	mddate = sp_busco_fecha_serv('DD')	
endif	

if !isblank(vrFechaHr1)
	mttot_min1 = hour(vrFechaHr1)*60 + minute(vrFechaHr1)
endif

if !isblank(vrFechaHr2)
	mttot_min2  = hour(vrFechaHr2)*60 + minute(vrFechaHr2)
endif
mnsumat    = mttot_min1 + mttot_min2 + vrMinu_mas

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

