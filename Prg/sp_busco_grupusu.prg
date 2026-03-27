
parameters mbandera,mIdGrupo


if mbandera = 1
	mret = sqlexec(mcon1,"select nomape,tabusuario.id,TabGcusugrup.fecactiva  from tabusuario,tabpermisosexe,tabexe  "+;
		" left join TabGcusugrup  on TabGcusugrup.idUsuario = tabusuario.Id "+;
		" where tabpermisosexe.codusuario = tabusuario.id  and tabpermisosexe.codexe = tabexe.id  "+;
		" and tabusuario.fecpasiva = to_date( '01/01/1900','dd/mm/yyyy') and tabexe.nomexe='CALIDAD' "+;
		" and tabpermisosexe.fecpasiva = to_date( '01/01/1900','dd/mm/yyyy')  "+;
		" and tabexe.fecpasiva = to_date( '01/01/1900','dd/mm/yyyy')   and tabusuario.id<10000000  "+;
		" group by tabusuario.id order by nomape " ,"mwkGrupUsu" )
else

	mret = sqlexec(mcon1," select nomape,tabusuario.id,TabGcusugrup.fecactiva  from tabusuario,tabpermisosexe,tabexe  "+;
		" left join TabGcusugrup  on TabGcusugrup.idUsuario = tabusuario.Id "+;
		" where tabpermisosexe.codusuario = tabusuario.id  and tabpermisosexe.codexe = tabexe.id  "+;
		" and tabusuario.fecpasiva = to_date( '01/01/1900','dd/mm/yyyy') and tabexe.nomexe='CALIDAD' "+;
		" and tabpermisosexe.fecpasiva = to_date( '01/01/1900','dd/mm/yyyy')  "+;
		" and tabexe.fecpasiva = to_date( '01/01/1900','dd/mm/yyyy')   and tabusuario.id<10000000  "+;
		" and TabGcusugrup.fecactiva <> to_date( '01/01/1900','dd/mm/yyyy')    "+;
		" and idgrupo = ?mIdGrupo group by tabusuario.id order by nomape ","mwkGrupUsu2" )
endif
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif





