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
	", hhmmDes, hhmmHas,demanda,ESP_descripcion ,nombre as nn,generaagen " +;
	" from medpresta, especialid"+;
	" left join prestadores on codmed = prestadores.id "+;
	" where medpresta.codesp = trim(especialid.ESP_codesp) "+qbusco +;
	" and fecvigenh > ?vr_fecha1 and fecvigend <= ?vr_fecha2 "+;
	" and fecvigenh <> fecvigend "+;
	" group by codmed, medpresta.codesp, diasem, fecvigenh, hdesde1 ","Mwkmedpre0")

if mret < 0
	=aerr(eros)
	messagebox(eros(3), 16, "Validacion")
endif

mret = sqlexec(mcon1, "select codmed ,diasem, hhmmdes,hhmmhas, fecvigend, fecvigenh, tiposervicio "+;
	" from franjahoraria as a "+;
	" where diasem > 0 "+ ;
	" and fecvigenh > ?vr_fecha1 and fecvigend <= ?vr_fecha2 "+;
	" and fecvigenh <> fecvigend "+;
	" group by codmed, diasem, fecvigenh, hhmmdes,tipoturno ","Mwkfran0")
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
	" ,{fn hour(horadesde)}*100 + {fn minute(horadesde)} as hhmmdes "+;
	" ,{fn hour(horahasta)}*100 + {fn minute(horahasta)} as hhmmhas "+;
	" FROM horarioConsulE as a LEFT OUTER JOIN horarioConsuld as b ON a.id = b.ide "+;
	" WHERE a.fecha between ?vr_fecha1 and ?vr_fecha2 "+ mbusco2 +;
	" ORDER by fecha,horadesde,horahasta,a.codmed, entsal ","MwkControlM")

if mret < 0
	mret = 0
	messagebox('ERROR DE GENERACION DE CURSOR 1, AVISAR A SISTEMAS',16,'VALIDACION')
	cancel

else
	select nombre,fecha, horadesde ,horahasta, iif(entrada=mfechent,salida ,entrada ) as entrada;
		,iif(salida=mfechsal ,entrada ,salida ) as salida,codmed,;
		hhmmdes as hhmmd,hhmmhas as hhmmh,reemplazo,ide,diasem ,hhmmdes,;
		hhmmhas ,dow(fecha) as diasemana,iif(entrada=mfechent,0,1) as he,iif(salida=mfechsal ,0,1) as hs;
		from MwkControlM into cursor MwkControlM0

	select nombre, fecha, MwkControlM0.horadesde, MwkControlM0.horahasta, min(entrada) as entrada,  ;
		max(salida) as salida,	reemplazo,tiposervicio,codesp ,ESP_descripcion,max(he) as he,max(hs) as hs;
		from MwkControlM0;
		left join Mwkfran0 on (;
		MwkControlM0.codmed	= Mwkfran0.codmed and  ;
		MwkControlM0.diasem = Mwkfran0.diasem and ;
		Mwkfran0.hhmmDes 	= MwkControlM0.hhmmDes and ;
		Mwkfran0.hhmmHas 	= MwkControlM0.hhmmHas and ;
		Mwkfran0.fecvigend 	<= MwkControlM0.fecha and ;
		Mwkfran0.fecvigenh 	>= MwkControlM0.fecha);
		left join Mwkmedpre0 on ( ;
		nn	= nombre and  ;
		Mwkmedpre0.diasem 	= diasemana and ;
		hhmmD 	>= Mwkmedpre0.hhmmDes and ;
		hhmmH 	<= Mwkmedpre0.hhmmHas and ;
		fecha >= Mwkmedpre0.fecvigend and ;
		fecha <= Mwkmedpre0.fecvigenh );
		group by nombre, fecha, MwkControlM0.horadesde, MwkControlM0.horahasta;
		order by nombre, fecha, MwkControlM0.horadesde, MwkControlM0.horahasta  ;
		into cursor MwkControlM1
endif
