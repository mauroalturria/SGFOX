******************************
*AUTOR:Claudia Antoniow T.
******************************
*Fecha:25/10/2002
**************************************************
* Busca quienes generan prepaga, segun el criterio
**************************************************
parameter vr_fecha,vr_dia,vr_crit,vr_tipoD,vr_work,vr_med

if vr_med=0
	mret=sqlexec(mcon1,"select a.cantidadps,a.codmed,a.tipodato,a.criterio,b.diasem,b.horadesde,b.horahasta from tabprepaga as a, " +;
				" (select codmed,diasem,horadesde,horahasta,fecvigend,fecvigenh "+;
 				" from medpresta WHERE diasem =?vr_dia "+;
				" and ?vr_fecha between medpresta.fecvigend and medpresta.fecvigenh "+;
 				" group by codmed,horadesde) as b "+;
 				" where ?vr_fecha between a.fecvigend and a.fecvigenh "+;
 				" and a.criterio=?vr_crit and a.tipodato=?vr_tipoD And a.codmed=b.codmed "+;  
				" order by A.Codmed",vr_work)
else
	mret=sqlexec(mcon1,"select a.cantidadps,a.codmed,a.tipodato,a.criterio,b.diasem,b.horadesde,b.horahasta from tabprepaga as a, " +;
				" medpresta as b "+;
				" where b.diasem =?vr_dia and b.codmed=?vr_med "+;
				" and ?vr_fecha between b.fecvigend and b.fecvigenh "+;
				" and ?vr_fecha between a.fecvigend and a.fecvigenh "+;
 				" and a.criterio=?vr_crit and a.tipodato=?vr_tipoD And a.codmed=b.codmed "+;
 				" group by a.codmed,b.diasem,b.horadesde,b.horahasta "+;
				" order by A.Codmed,b.horadesde,b.horahasta",vr_work)
endif
if mret <0
	messagebox('ERROR DE CURSOR,Plan de Salud, AVISAR A SISTEMAS',16,'VALIDACION') 
	mret=0
endif
