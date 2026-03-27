****
**  Genera dos cursores para la pantalla de mensajes
****
mfecpas = sp_busco_fecha_serv('DD')
mfecnul = ctod("01/01/1900")

mret = SQLExec(mcon1,"SELECT Prestadores.id, nombre ,TPF_filtro " + ;
	" FROM Prestadores " + ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	"WHERE (fecpasivap = ?mfecnul or fecpasivap > ?mfecpas ) and  (estado = 1 or fecpasiva > ?mfecpas ) and dambula = 1 " + ;
	"ORDER BY nombre", "mwkMedico" )

if mret < 0
	do Log_errores with error(), message(), message(1), program(), lineno()
	messagebox("ERROR DE LECTURA DE PRESTADORES",48,"VALIDACION")
	return .f.
endif

mret = SQLExec(mcon1,"SELECT pre_codprest, pre_descriprest  " + ;
	" FROM prestacions "+;
	" WHERE pre_fechapasiva is null and pre_agendaturnos = 'S' " + ;
	" union " + ;
	" SELECT PRL_PRESTACIONS as pre_codprest, "+;
	" PRL_descrianalog as pre_descriprest " + ;
	" from PRESTANALOG ,prestacions as pp "+;
	" WHERE PRL_PRESTACIONS = pp.pre_codprest "+;
	" and pp.pre_fechapasiva is null and pp.pre_agendaturnos = 'S' " + ;
	" ", "mwkpresta0" )

if mret < 0
	do Log_errores with error(), message(), message(1), program(), lineno()
	messagebox("ERROR DE LECTURA DE PRESTACIONES",48,"VALIDACION")
	return .f.
endif
&&ORDER BY pre_descriprest

if used('mwkpresta')
	use in mwkpresta
endif

select pre_codprest, pre_descriprest;
	from mwkpresta0 order by pre_descriprest ;
	group by pre_codprest, pre_descriprest ;
	into cursor mwkpresta1

use dbf('mwkpresta1') again  in 0 alias mwkpresta

use in mwkpresta0
use in mwkpresta1
