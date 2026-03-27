****
** actualizo la tabla de ejecutables version
****
parameter mexeid, mversion

mfecha = sp_busco_fecha_serv('DT')

mret = sqlexec(mcon1, "insert into TabExeVer(FechaHora , IdTabExe , Version ) " + ;
	"values(?mfecha, ?mexeid, ?mversion)")

mret = sqlexec(mcon1, "update tabexe set versionactual = ?mversion,fechaversionactual = ?mfecha where id = ?mexeid")
