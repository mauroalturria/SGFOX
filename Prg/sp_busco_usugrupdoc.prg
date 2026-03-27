
PARAMETERS mbandera,mIdGrupo



mret = sqlexec(mcon1,"select nomape,tabusuario.idusuario,TabGcusugrup.fecactiva,descr,denominacion,codigoProc " +;
 " from tabpermisosexe,tabexe,tabusuario "  +;
 " left join TabGcusugrup  on TabGcusugrup.idUsuario = tabusuario.Id " +;
 " left join TabGcGrupo  on TabGcGrupo.id = TabGcusugrup.IdGrupo "+;
 " left join TabGcgrupoDoc  on TabGcgrupoDoc.IdGrupo = TabGcusugrup.IdGrupo "+;
 " left join TabGcProc  on TabGcProc.id = TabGcgrupoDoc.IdDocumento "+;
 " where tabpermisosexe.codusuario = tabusuario.id  and tabpermisosexe.codexe = tabexe.id  "+;
 " and tabusuario.fecpasiva = to_date( '01/01/1900','dd/mm/yyyy') and tabexe.nomexe='CALIDAD' "+; 
 " and tabpermisosexe.fecpasiva = to_date( '01/01/1900','dd/mm/yyyy')   "+;
 " and tabexe.fecpasiva = to_date( '01/01/1900','dd/mm/yyyy')   and tabusuario.id<10000000   "+;
 " and TabGcusugrup.fecactiva <> to_date( '01/01/1900','dd/mm/yyyy') " +;
 " and TabGcgrupoDoc.fecactiva <> to_date( '01/01/1900','dd/mm/yyyy') " +;
 " order by nomape","mwkUsuGrupDoc")
  
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
	cancel
ENDIF





