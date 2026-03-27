********************
*** Busco bloqueos pedidos
********************
lparameters v_codmed, V_fdesde, V_fhasta,v_todos,V_bajas
if vartype (v_todos)#"N"
	v_todos = 2
endif
if vartype (v_bajas)#"N"
	v_bajas = 1
endif
if v_todos = 2
	selmed = ' prestadores.id = ?v_codmed and '
else 
	selmed = ''
endif		
mwhere = ''
if v_bajas = 0
	mwhere = " where bloqAnulado = 0  "
endif
mccpoambra = ''
*!*	if mxambito >1
*!*		mccpoambra = "  and tabbloqueoAmb.codambito = ?mxambito "
*!*	endif
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and franjaHoraria.codambito = ?mxambito "
endif
 
	mccpocmed = " and centromed = ?mxcentromedico "


mfecnul = CTOD("01/01/1900")
mret =sqlexec(mcon1,"SELECT prestadores.nombre,tabbloqueoAmb.*, "+;
	" franjaHoraria.diasem as fdia, franjaHoraria.horadesde as fhd, "+;
	" franjaHoraria.horahasta as fhh, franjaHoraria.fecvigend as ffd, "+;
	" franjaHoraria.fecvigenh as ffh, tabreemplazoAmb.*  "+;
	" FROM prestadores "+;
	" left JOIN tabbloqueoAmb  ON (tabbloqueoAmb.codmed = prestadores.id )"+;
	" left JOIN tabreemplazoAmb ON (tabreemplazoAmb.codmed = prestadores.id "+;
		"and tabreemplazoAmb.idfranja = tabbloqueoAmb.idfranja ) "+;
	" left JOIN franjaHoraria ON franjaHoraria.id = tabbloqueoAmb.idfranja   "+;
	" WHERE (fecpasivap = ?mfecnul OR fecpasivap >?V_fdesde ) and "+ selmed + ;
	" tabbloqueoAmb.fvigenh >= ?V_fdesde "+;
	" and tabbloqueoAmb.fvigend <= ?V_fhasta "+mccpocmed +mccpoamb +;
	" ORDER by prestadores.nombre,tabbloqueoAmb.fvigend,tabbloqueoAmb.fvigenh","MWkBloqueosAmb")
*!*		" and tabreemplazoAmb.idfranja = tabbloqueoAmb.idfranja "+;
*!*		" and tabreemplazoAmb.fvigend = tabbloqueoAmb.fvigend "+;
*!*		" and tabreemplazoAmb.fvigenh = tabbloqueoAmb.fvigenh "+;
*!*		" and tabreemplazoAmb.bloqanulado = tabbloqueoAmb.bloqanulado "+;
*!*		" and tabreemplazoAmb.fecanula = tabbloqueoAmb.fecanula "+;

if mret < 0
	=aerror(merror)
	iif (merror(1) >0,messagebox(str(merror(1))+ ''+ merror(3),16,''),'')
	messagebox('Error de Conexion, REINTENTE',16,'Validacion')
	do prg_cancelo
	mret=0
endif

if !eof("MWkBloqueosAmb")
	select nombre,left (iif(fdia=2,'LUN',iif(fdia=3,'MAR',iif(fdia=4,'MIE',;
		iif(fdia=5,'JUE',iif(fdia=6,'VIE',iif(fdia=7,'SAB','DOM')) ) ) ) ), 3) + ' ' + ;
		left (ttoc(fhd,2), 5) +  ' - ' + left (ttoc(fhh,2), 5)+ '   (  ' + ;
		left (allt(dtoc(ffd)), 10) + ' - ' +;
		left (allt(dtoc(ffh)), 10) + '  )' as franja,;
		ttoc(horadesde,2) as horaD,  + ;
		ttoc(horahasta,2) as horaH, fvigend, fvigenh,;
		iif(reemplazo=1,'NO','SI') as Reemplaza,;
		iif(bloqAnulado=1 ,'SI','NO') as BAnulado,;
		iif(bloqAnulado1=1,'SI','NO') as RAnulado,;
		reemplazo, idfranja, codmed,;
		id,nvl(id1,0) as idR;
		from MWkBloqueosAmb &mwhere;
		into cursor MWkBloqueosAmb1
endif
