*******************************
* AUTOR:Claudia Antoniow
* FECHA:15/07/2003
* ULTIMA MODIFICACION:15/07/2003
*******************************
*Cuando se da de baja una franja
*en medpresta hay que dar la baja
*correspondiente en Franjahoraria
********************************
parameters vr_mdvigenh, vr_usu, vr_mfgraba, vr_mfecturnod, vr_mfecturnoh, vr_codmed,;
	vr_diasem, vr_mthorad, vr_mthorah, vr_prestac, vr_id

hhmmD		= val(left(vr_mthorad,2)+substr(vr_mthorad,4,2))
hhmmH		= val(left(vr_mthorah,2)+substr(vr_mthorah,4,2))
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
endif

mret = sqlexec(mcon1," Update FranjaHoraria set FecvigenH = ?vr_mdvigenh, "+;
	" usuario = ?vr_usu, fechagraba = ?vr_mfgraba,centromed = ?mxcentromedico "+;
	" where fecvigend = ?vr_mfecturnod And "+;
	" fecvigenh = ?vr_mfecturnoh "+;
	" And codmed = ?vr_codmed And id=?vr_id "+;
	" and diasem = ?vr_diasem "+;
	" and hhmmDes = ?hhmmD"+;
	" and hhmmHas= ?hhmmH" +mccpoamb )



if mret < 0
	messagebox("NO SE GUARDO LA MODIFICACIÓN, VERIFIQUE",16, "Modificacion de Datos")
	mret=0
	do prg_cancelo
endif
