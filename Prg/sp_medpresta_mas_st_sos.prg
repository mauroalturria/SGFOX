************************
* AUTOR :Claudia Antoniow
*************************
* FECHA : 10/06/2003
***********************
* Modificado:
****************************************************************
* Para agrega a ausentismo los datos de SO y ST
****************************************************************

parameters vr_fechah

mret = sqlexec(mcon1, " select m.codmed, m.diasem, m.fecvigend, "+;
					  " m.fecvigenh,  m.hdesde1,    m.hhasta1, m.horadesde, m.horahasta, "+;
					  " t.cantidad,   t.porcentaje  "+;
					", {fn HOUR(hdesde1)}*100+{fn MINUTE(hdesde1)} as hdm " +;
					", {fn HOUR(hhasta1)}*100+{fn MINUTE(hhasta1)} as hhm " +;
					  " from medpresta as m, tabsobretoa as t "+;
					  " where m.diasem > 0 and m.codmed = t.codmed "+;
					  " and m.diasem = t.diasem and " + ;
					  " datepart(hh,hdesde1) = datepart(hh,t.horadesde) and "+;
					  " datepart(hh,hhasta1) = datepart(hh,t.horahasta) and "+; 
					  " t.fvigenh >= ?vr_fechah "+;
					  " group by m.codmed, m.diasem, m.fecvigenh, m.hdesde1 "+;
					  " order by m.codmed, m.diasem, m.hdesde1 ","Mwkmedsost")


if mret < 0 
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	cancel
else
	mret = sqlexec(mcon1, " select codmed,   diasem,   fecvigend,  "+;
						  " fecvigenh, hdesde1, hhasta1, horadesde, horahasta, " + ;
						  "cast('0' as integer) as cantidad,  cast('0' as integer) as porcentaje  "+;
							", {fn HOUR(hdesde1)}*100+{fn MINUTE(hdesde1)} as hdm " +;
							", {fn HOUR(hhasta1)}*100+{fn MINUTE(hhasta1)} as hhm " +;
						  " from medpresta  "+;
						  " where diasem > 0 and not id in (select m.id  "+;
						  " from medpresta as m, tabsobretoa as t  "+;
						  " where m.diasem > 0 and m.codmed = t.codmed  "+;
						  " and m.diasem = t.diasem and " + ;
	  					  " datepart(hh,hdesde1) = datepart(hh,t.horadesde) and "+;
						  " datepart(hh,hhasta1) = datepart(hh,t.horahasta) and "+; 
						  " t.fvigenh >= ?vr_fechah )  "+;
						  " group by codmed, diasem, fecvigenh,hdesde1  "+;
						  " order by codmed, diasem, hdesde1 ","Mwkmedsinsost")
	if mret < 0 
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
		cancel
	else					  
		select * from Mwkmedsost ;
		union all ;
		select * from Mwkmedsinsost ;
		order by 1,2,5 into cursor mwkmedpre
	endif
endif	

*mret = sqlexec(mcon1, "select id, codmed, diasem, fecvigend, fecvigenh, hdesde1, hhasta1 from medpresta " + ;
*						"where diasem > 0 group by codmed, diasem, fecvigenh, hdesde1 " + ;
*						"order by codmed, diasem, hdesde1 " , "mwkmedpre")			

*if mret < 0 
*	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
*	cancel
*endif

  