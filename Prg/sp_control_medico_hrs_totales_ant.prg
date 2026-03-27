****************************
**** Autor:Claudia Antoniow
**** Fecha:25/09/2003
****************************
parameter vr_fecha1, vr_fecha2, vr_med, vr_esp,mtole,mtols
mbusco2 = ''
if !isblank(vr_esp) and used('mwkmedicos') and isblank(vr_med)
	sele mwkmedicos
	go top
	if !eof()
		mbusco2 = " AND a.codmed in ("
		scan
			mbusco2 = mbusco2  + allt(str(mwkmedicos.id)) + ","
		endscan
		mbusco2 = mbusco2  +  "0)"
	endif
else
	mbusco2 =iif(!isblank(vr_med), " AND a.codmed=?vr_med ","")
endif

qbusco = iif(empty(mbusco2), '',strtran(mbusco2 ,'a.','medpresta.'))

mret = sqlexec(mcon1, " select diasem, fecvigend,medpresta.codesp "+;
	", fecvigenh,  hdesde1, hhasta1, horadesde, horahasta, bloquedesde , bloquehasta  "+;
	", hhmmDes, hhmmHas,demanda,ESP_descripcion ,generaagen,codmed" +;
	" from especialid,medpresta "+;
	" left join prestadores on medpresta.codmed = prestadores.id "+;
	" where medpresta.codesp = trim(especialid.ESP_codesp) "+qbusco +;
	" and fecvigenh > ?vr_fecha1 and fecvigend <= ?vr_fecha2 "+;
	" and fecvigenh <> fecvigend "+;
	" group by codmed, medpresta.codesp, diasem, fecvigenh, hdesde1 ","Mwkmedpre0")

if mret < 0
	=aerr(eros)
	messagebox(eros(3), 16, "Validacion")
endif

mret = sqlexec(mcon1, "select codmed,diasem,hhmmdes,hhmmhas,fecvigend,fecvigenh,tiposervicio,"+;
    " TabTipoturno.abreviatura as tturno"+;
	" from franjahoraria as a "+;
	" left join TabTipoTurno on TabTipoturno.tipoturno = a.tipoturno"+;
	" where diasem > 0 "+ ;
	" and fecvigenh > ?vr_fecha1 and fecvigend <= ?vr_fecha2 "+;
	" and fecvigenh <> fecvigend "+;
	" group by codmed, diasem, fecvigenh, hhmmdes,a.tipoturno ","Mwkfran0")


if mret < 0
	= aerr(eros)
	messagebox(eros(3),16,'VALIDACION')
endif
mfechent = ctot("01/01/2100")
mfechsal = ctot("01/01/1900")
mret=sqlexec(mcon1, " SELECT a.nombre,fecha, horadesde ,horahasta, "+;
	" cast(CASE WHEN entsal=1 THEN fechahora "+;
	" ELSE ?mfechent END as TIMESTAMP) as entrada, "+;
	" cast(CASE WHEN entsal=2 THEN fechahora "+;
	" ELSE ?mfechsal END as  TIMESTAMP) as salida,codmed,"+;
	" b.nombre as reemplazo,ide,{fn DAYOFWEEK(fecha )} as diasem "+;
	" FROM horarioConsulE as a LEFT OUTER JOIN horarioConsuld as b ON a.id = b.ide "+;
	" WHERE a.fecha between ?vr_fecha1 and ?vr_fecha2 "+ mbusco2 +;
	" ORDER by fecha,horadesde,horahasta,a.codmed, entsal ","MwkControlM")

if mret < 0
	mret = 0
	messagebox('ERROR DE GENERACION DE CURSOR 1, AVISAR A SISTEMAS',16,'VALIDACION')
	cancel

else
	select nombre,fecha, horadesde ,horahasta, iif(entrada=mfechent,salida ,entrada ) as entrada;
		,iif(salida=mfechsal ,entrada ,salida ) as salida,codmed;
		,hour(horadesde)*100+minute(horadesde) as hhmmdes;
		,hour(horahasta)*100 + minute(horahasta)  as hhmmhas ;
		,reemplazo,ide,diasem ,dow(fecha) as diasemana;
		,iif(entrada=mfechent,0,1) as he,iif(salida=mfechsal ,0,1) as hs ;
		from MwkControlM into cursor MwkControlM0

	do sp_busco_bloqueos_franja with vr_fecha1, vr_fecha2

	select MwkControlM0.codmed,nombre,fecha, MwkControlM0.horadesde, MwkControlM0.horahasta, ;
		min(entrada) as entrada, max(salida) as salida,	reemplazo,tiposervicio,codesp ;
		,ESP_descripcion,max(he) as he,max(hs) as hs;
		,MwkControlM0.hhmmdes,MwkControlM0.hhmmhas ;
		,CodCargo ,descrip,mwkbloqueo.horadesde as hdb ,mwkbloqueo.horahasta as hhb,;
		Mwkfran0.tturno;
		from MwkControlM0;
		left join Mwkfran0 on (;
		MwkControlM0.codmed	= Mwkfran0.codmed and  ;
		MwkControlM0.diasem = Mwkfran0.diasem and ;
		Mwkfran0.hhmmDes 	= MwkControlM0.hhmmDes and ;
		Mwkfran0.hhmmHas 	= MwkControlM0.hhmmHas and ;
		Mwkfran0.fecvigend 	<= MwkControlM0.fecha and ;
		Mwkfran0.fecvigenh 	>= MwkControlM0.fecha);
		left join Mwkmedpre0 on ( ;
		Mwkmedpre0.codmed = MwkControlM0.codmed	and  ;
		Mwkmedpre0.diasem 	= MwkControlM0.diasem and ;
		MwkControlM0.hhmmDes >= Mwkmedpre0.hhmmDes and ;
		MwkControlM0.hhmmHas <= Mwkmedpre0.hhmmHas and ;
		fecha >= Mwkmedpre0.fecvigend and ;
		fecha <= Mwkmedpre0.fecvigenh );
		left join mwkMedicoscar on MwkControlM0.codmed = mwkMedicoscar.id;
		left join mwkbloqueo on (;
		MwkControlM0.codmed	= mwkbloqueo.codmed and  ;
		dow(MwkControlM0.fecha) = mwkbloqueo.diasem and ;
		MwkControlM0.hhmmHas >=	mwkbloqueo.hhmmDes and ;
		MwkControlM0.hhmmdes <= mwkbloqueo.hhmmHas and ;
		MwkControlM0.fecha 	>= mwkbloqueo.fvigend and ;
		MwkControlM0.fecha	<= mwkbloqueo.fvigenh);
		group by nombre, fecha, MwkControlM0.horadesde, MwkControlM0.horahasta;
		order by nombre, fecha, MwkControlM0.horadesde, MwkControlM0.horahasta  ;
		into cursor MwkControlM1

endif
