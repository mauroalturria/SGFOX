parameters mbandera,mIdGrupo

if mbandera = 1
	mret = sqlexec(mcon1,"select codigoProc,denominacion,* from TabGcProc " +;
		"  left join TabGcGrupoDoc  on TabGcGrupoDoc.iddocumento  = TabGcProc.Id " +;
		"  where  TabGcGrupoDoc.fecactiva = to_date( '01/01/1900','dd/mm/yyyy')  group by denominacion order by  codigoProc ","mwkGrupDoc" )
*or  TabGcGrupoDoc.fecpasiva is null  group by denominacion
else
	mret = sqlexec(mcon1,"select  codigoProc,denominacion,* from TabGcProc " +;
		"  left join TabGcGrupoDoc  on TabGcGrupoDoc.iddocumento  = TabGcProc.Id " +;
		"  where  TabGcGrupoDoc.fecactiva <> to_date( '01/01/1900','dd/mm/yyyy') and TabGcGrupoDoc.IdGrupo = ?mIdGrupo  group by codigoProc order by  denominacion ","mwkGrupDoc2" )
endif
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif

