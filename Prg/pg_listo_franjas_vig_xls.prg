*********************
* fecha :03/10/2003
*********************
* Claudia Antoniow
*********************
SET CENTURY ON 
set mark to "/"
set date to french

mfec = sp_busco_fecha_serv('DD')

mret=sqlexec(mcon1, "select f.id,codmed,nombre,diasem, cast(horadesde as time) as hd, "+;
					" cast(horahasta as time) as hh, abrevio, estructura, "+;
					" fecvigend, fecvigenh, tipoturno "+;
					" from franjahoraria as f, prestadores as p , tabtipofranja as t "+;
					" where f.codmed=p.id and "+;
					" f.tiposervicio=t.id and "+;
					" ?mfec between fecvigend and fecvigenh","MwkFranjasVig")

if mret <0
	mret=0
	cancel
else
	select nombre, abrevio,iif(diasem=2,'LUN',iif(diasem=3,'MAR',;
			iif(diasem=4,'MIE',iif(diasem=5,'JUE',iif(diasem=6,'VIE','SAB'))))) as Dia,;
			ttoc(hd,2) as Hora_desde, ttoc(hh,2) as Hora_hasta,;
			iif(tipoturno =0,'NOR',iif(tipoturno =1,'SO',iif(tipoturno =2,'ST',;
			iif(tipoturno =3,'GI',iif(tipoturno =4,'ESP',iif(tipoturno =5,'PS',;
			iif(tipoturno =6,'RE',iif(tipoturno =7,'PE','AN')))))))) as Tipo_Turno,fecvigend,fecvigenh; 
	from MwkFranjasVig ;
	group by nombre, diasem, Hora_desde, Hora_hasta;
	order by nombre, diasem, Hora_desde, Hora_hasta;
	into cursor FranjaVig
	
	copy to c:/desaguemes/FranjaVig1 type xls
			
endif	
mret=sqlexec(mcon1, "select f.id,codmed,nombre,diasem, horadesde as hd, "+;
					" horahasta as hh, fecvigend, fecvigenh "+;
					" from MEDPRESTA as f, prestadores as p  "+;
					" where f.codmed=p.id and "+;
					" ?mfec between fecvigend and fecvigenh "+;
					" Group by codmed,diasem,horadesde,horahasta,fecvigend,fecvigenh "+;
					" order by codmed,diasem,horadesde,horahasta,fecvigend,fecvigenh ","MwkmedprestaVig")

if mret <0
	mret=0
	messagebox('cancelado',16,'')
	cancel
else

	mfr=reccount('MwkFranjasVig')
	mmp=reccount('MwkmedprestaVig')
	
	select f.id as fr,m.id as Mp from MwkFranjasVig as f ,MwkmedprestaVig as M;
	where  f.codmed=m.codmed and f.diasem=m.diasem;
	and between(m.hd,f.hd,f.hh) and between(m.hh,f.hd,f.hh);
	and between(m.fecvigend,f.fecvigend,f.fecvigenh); 
	and between(m.fecvigenh,f.fecvigend,f.fecvigenh) into cursor mwkcompar
	
	select M.* from MwkmedprestaVig as m;
	 where m.id not in (select Mp from  mwkcompar);
	 into cursor mwkdiff
	  copy to c:/desaguemes/DiffFranjaVig1 type xls
	 
ENDIF

if used('MwkFranjasVig')
	sele MwkFranjasVig
	use
endif
if used('FranjaVIg')
	sele FranjaVig
	use
endif
