*****
**  busco profesionales
*****

parameter msql_age ,mfechita

if type ('mfechita')#"D"
	mfecpas = sp_busco_fecha_serv('DD')+1
else
	mfecpas = mfechita
endif
mfecnul = ctod("01/01/1900")
mret = SQLExec(mcon1,"SELECT nombre, id,matriculas " + ;
	"FROM prestadores " + ;
	"WHERE (fecpasivap = ?mfecnul or fecpasivap > ?mfecpas )"+;
	" and (estado = 1 or fecpasiva > ?mfecpas )  " +;
	"and id > 1 "	+ ;
	"ORDER BY nombre", "mwkmed01" )
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
