************************
* AUTOR :Claudia Antoniow
*************************
* FECHA : 10/06/2003
***********************
* Modificado:
****************************************************************
* Para agrega a ausentismo los datos de SO y ST
****************************************************************

parameters vr_fechah,mbuscar,mfecdes
if mxambito >1
	mccpoambm = "  m.codambito = ?mxambito and "
	mccpoamb = "  medpresta.codambito = ?mxambito and "
	mccpoambst = "  t.codambito = ?mxambito and "
else
	mccpoambm = ''	
	mccpoamb = ''	
	mccpoambst = ''	
endif

mret = sqlexec(mcon1, " select m.codmed,m.codesp, m.diasem, m.fecvigend, "+;
	" m.fecvigenh,  m.hdesde1,    m.hhasta1, m.horadesde, m.horahasta, "+;
	" t.cantidad,   t.porcentaje "+;
	", m.hhmmDes, m.hhmmHas, m.duracion   " +;
	" from medpresta as m, tabsobretoa as t "+;
	" where &mccpoambst  &mccpoambm m.diasem > 0 and m.codmed = t.codmed "+;
	" and m.fecvigenh > ?mfecdes and m.fecvigend <= ?vr_fechah " + ;
	" and m.fecvigenh <> m.fecvigend  " +;
	" and m.diasem = t.diasem and " + ;
	" m.hhmmDes = t.hhmmDes and "+;
	" m.hhmmHas = t.hhmmHas and "+;
	" t.fvigenh >= ?vr_fechah "+;
	" group by m.codmed, m.codesp, m.diasem, m.fecvigenh, m.hdesde1 "+;
	" ","Mwkmedsost")

*!*						  " datepart(hh,hdesde1) = datepart(hh,t.horadesde) and "+;
*!*						  " datepart(hh,hhasta1) = datepart(hh,t.horahasta) and "+;

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE", 16, "Validacion")
	cancel
else
	mret = sqlexec(mcon1, " select codmed,codesp,   diasem,   fecvigend,  "+;
		" fecvigenh, hdesde1, hhasta1, horadesde, horahasta, " + ;
		"cast('0' as integer) as cantidad,  cast('0' as integer) as porcentaje  "+;
		", hhmmDes, hhmmHas,duracion  " +;
		" from medpresta   "+;
		" where &mccpoamb diasem > 0 and not id in (select m.id  "+;
		" from medpresta as m, tabsobretoa as t  "+;
		" where m.diasem > 0 and m.codmed = t.codmed  "+;
		" and m.fecvigenh > ?mfecdes and m.fecvigend <= ?vr_fechah " + ;
		" and m.diasem = t.diasem and " + ;
		" m.hhmmDes = t.hhmmDes and "+;
		" m.hhmmHas = t.hhmmHas and "+;
		" t.fvigenh >= ?vr_fechah )  "+;
		" and fecvigenh > ?mfecdes and fecvigend <= ?vr_fechah " + ;
		" and fecvigenh <> fecvigend  " +;
		" group by codmed, codesp, diasem, fecvigenh,hdesde1  "+;
		"","Mwkmedsinsost")

*!*		  					  " datepart(hh,hdesde1) = datepart(hh,t.horadesde) and "+;
*!*							  " datepart(hh,hhasta1) = datepart(hh,t.horahasta) and "+;

	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE", 16, "Validacion")
		cancel
	else
		select * from Mwkmedsost ;
			union all ;
			select * from Mwkmedsinsost ;
			where 1= 1 &mbuscar ;
			order by 1,2,5 into cursor mwkmedpre
	endif
endif

