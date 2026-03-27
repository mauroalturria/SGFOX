******************************
*AUTOR:Claudia Antoniow T.
******************************
*Fecha:25/10/2002
**************************************************
* Busca quienes generan prepaga, segun el criterio
**************************************************
parameters vr_fecha, vr_dia, vr_crit, vr_tipoD, vr_work, vr_med
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif


if vr_med=0
	mret=sqlexec(mcon1,"select a.cantidadps, a.codmed, a.tipodato, a.criterio, " + ;
		" a.diasem, a.horadesde, a.horahasta " + ;
		" from tabprepaga as a  " +;
		" where ?vr_fecha between a.fecvigend and a.fecvigenh " + ;
		" and a.diasem = ?vr_dia and a.criterio = ?vr_crit and " + ;
		" a.tipodato = ?vr_tipoD And a.codmed in ( select codmed from turnos " + ;
		" where "+ mccpoamb +"fechatur = ?vr_fecha and tipoturno in (0,4) " + ;
		" group by codmed ) order by A.Codmed ", vr_work )

*!*		mret=sqlexec(mcon1,"select a.cantidadps, a.codmed, a.tipodato, a.criterio, " + ;
*!*						   " a.diasem, a.horadesde, a.horahasta " + ;
*!*					       " from tabprepaga as a, ( select codmed from turnos " + ;
*!*					       " where fechatur = ?vr_fecha and tipoturno in (0,4) " + ;
*!*					       " group by codmed ) as b " +;
*!*					       " where ?vr_fecha between a.fecvigend and a.fecvigenh " + ;
*!*					       " and a.diasem = ?vr_dia and a.criterio = ?vr_crit and " + ;
*!*					       " a.tipodato = ?vr_tipoD And a.codmed = b.codmed " + ;
*!*						   " order by A.Codmed ", vr_work )
else
	mret=sqlexec(mcon1,"select a.cantidadps, a.codmed, a.tipodato, " + ;
		" a.criterio, a.diasem, a.horadesde, a.horahasta " + ;
		" from tabprepaga as a " + ;
		" where "+ mccpoamb +" a.diasem = ?vr_dia and a.codmed = ?vr_med " + ;
		" and ?vr_fecha between a.fecvigend and a.fecvigenh "+;
		" and a.criterio = ?vr_crit and a.tipodato = ?vr_tipoD "+;
		" group by a.codmed, a.diasem, a.horadesde, a.horahasta "+;
		" order by a.Codmed, a.horadesde, a.horahasta",vr_work)
endif
if mret <0
	messagebox('ERROR DE CURSOR,Plan de Salud, REINTENTE',16,'VALIDACION')
	mret=0
endif
