*******************************
* AUTOR:Claudia Antoniow
* FECHA:28/05/2002
* ULTIMA MODIFICACION=28/05/2002
********************************
*****************************************************
* Carga los trunos de sobreoferta
*****************************************************
parameter vr_tipotur, vr_porc,vr_horad_teo, vr_horah_teo

do sp_primer_turno_disponible
if !eof('MwkPrimertur') and !isnull(MwkPrimertur.horadesde)
	mthorad    =MwkPrimertur.horadesde 
	*datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),hour(MWKSobre.horadesde),minute(MWKSobre.horadesde),0)  && campo de insert
	do sp_ultimoturno_sobreoferta
	if !eof('MWKUltTurno') and !isnull(MWKUltTurno.ulthr)
		mthorah    =MWKUltTurno.ulthr
		* datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),hour(MWKSobre.horahasta),minute(MWKSobre.horahasta),0)  && campo de insert
		mccodesp   = "" 
		mncodserv  = 0 

		* calculo la cant de horas que trabaja el prestador
		mttot_minH = hour(mthorah)*60 + minute(mthorah)
		mttot_minD = hour(mthorad)*60 + minute(mthorad)
		mnsumat    = mttot_minH - mttot_minD
		* Calculo el intervalo de sobreoferta
		mtduraMin  = round(Mod((mnsumat/mnporc),60),0) 
		mthoramin  = int((mnsumat/mnporc)/60)
		if mtduraMin=60
			mtduraMin=0
			mthoramin =mthoramin +1
		endif	

		mtdura     = datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),mthoramin,mtduraMin,0)  && campo de insert
		mntipotur  =5 &&campo de insert

		do sp_genero_turnos.prg
	
	endif

endif