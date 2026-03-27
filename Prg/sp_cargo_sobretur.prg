*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
* ULTIMA MODIFICACION=14/03/2002
********************************
************************************
* Carga los turnos de sobreoferta
************************************
parameters vr_tipotur, vr_cant, vr_horad_teo, vr_horah_teo

do sp_primer_turno_disponible

if !eof('MwkPrimertur') and !isnull(MwkPrimertur.horadesde)
	mthorad    = datetime(year(mtfechatur),month(mtfechatur),;
		day(mtfechatur),hour(MwkPrimertur.horadesde),;
		minute(MwkPrimertur.horadesde),0)  && campo de insert
else
	mthorad    = datetime(year(mtfechatur),month(mtfechatur),;
		day(mtfechatur),hour(vr_horad_teo),;
		minute(vr_horad_teo),0)  && campo de insert
endif
do sp_ultimoturno_sobreoferta

if !eof('MWKUltTurno') and !isnull(MWKUltTurno.ulthr)
	mthorah    = datetime(year(mtfechatur),month(mtfechatur),;
		day(mtfechatur),hour(MWKUltTurno.ulthr),;
		minute(MWKUltTurno.ulthr),0)  && campo de insert
else
	mthorah    = datetime(year(mtfechatur),month(mtfechatur),;
		day(mtfechatur),hour(vr_horah_teo),;
		minute(vr_horah_teo),0)  && campo de insert
endif

mccodesp   = "" && MWKHorasTr.codesp    &&campo de insert
mncodserv  = 0 && MWKHorasTr.codserv   &&campo de insert

* calculo la cant de horas que trabaja el prestador

mttot_minH = hour(mthorah)*60 + minute(mthorah)
mttot_minD = hour(mthorad)*60 + minute(mthorad)
mnsumat    = mttot_minH - mttot_minD
if mnsumat < 0
	messagebox('ERROR EN LA FRANJA HORARIA, VERIFIQUE LOS DATOS, ID DE MEDICO: '+ ;
		str(mncodmed) + ' TIPO DE TURNO: ' + str(vr_tipotur),16,'VALIDACION')
else
* Calculo el intervalo de sobreoferta

	mtduraMin  = round(mod((mnsumat/vr_cant),60),0)
	mthoramin  = int((mnsumat/vr_cant)/60)

	if mtduraMin = 60
		mtduraMin = 0
		mthoramin = mthoramin +1
	endif


	mtdura     = datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),mthoramin,mtduraMin,0)  && campo de insert
	mntipotur  = vr_tipotur &&campo de insert

	do sp_genero_turnos WITH "(1,2)"
endif
