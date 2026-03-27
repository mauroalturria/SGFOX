****
** Busco todas las camas del paciente
****

parameter mcodadm, msql_hab

use in select('mwkcamas')
mret = sqlexec(mcon1, "select *, {fn hour(lug_horaingreso)}  as horaingreso from lugarintern " + ;
	"where lug_pacientes = ?mcodadm " + ;
	"order by lug_fechaingreso", "mwkcamas")
msql_hab = "select lug_fechaingreso, left(ttoc(lug_horaingreso, 2), 5) as hora, "+;
	"lug_categoria, lug_codsector, lug_habitacion, lug_cama,nvl(usuario,space(20)) as usuario  "+;
	" from mwkcamas into cursor mwkcamas1"
if mret <= 0
*	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
	do log_errores with error(), message(), message(1), program(), lineno()
else
	if reccount('mwkcamas')=0
		messagebox("!"+mcodadm+"!")
	endif
endif

