***
*** Generacion de planilla de Turnos _ busqueda base
***
parameter mft,mbus
** Dia anterior

mfectur_ant = mft - iif( dow(mft) = 2, 2, 1)
** Dia anterior
if !used('MWKFeriados')
	do while .t.
		mret=sqlexec(mcon1,"SELECT dia FROM feriaturnosA WHERE dia =?mfectur_ant",'MWKFeriados')
		if reccount('MWKFeriados')>0
			mfectur_ant = mfectur_ant -1
		else
			exit
		endif
	enddo
endif
if !used('mwkdatos')
	do sp_busco_datos
endif
mfechafiltro = ctod(trans(mwkdatos.valorfloat2,"99/99/9999"))
mfiltraesp = ''

if reccount('MWKFeriados')>0
	mfectur_ant = mfectur_ant -1
endif
if used('MWKFeriados')
	use in 	mwkferiados
endif
if dow(mfectur_ant) = 7
	mfectur_antv = mfectur_ant-1
	cbusca = " (fechatur = ?mfectur_ant or fechatur = ?mfectur_antv) "
else
	cbusca = " fechatur = ?mfectur_ant "
endif

do sp_busco_medprestam with mft

mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
	'turnos.diasem, turnos.codprest, AFI_nroafiliado, REG_telefonos, ' + ;
	'turnos.codreserva, hhmmtur ,registracio.REG_nrohclinica, registracio.REG_numdocumento, turnos.codmed, ' + ;
	'registracio.REG_nombrepac, turnos.codent ,' + ;
	'turnos.fechatomado, turnos.codserv, turnos.usuario, turnos.afiliado ,  hca_motfalta,hca_fechaInic,reg_email ' + ;
	'from turnos , afiliacion, registracio ' + ;
	" left outer join TabHCArchivo on registracio.REG_nroregistrac = TabHCArchivo.hca_registrac " + ;
	'where  ' + ;
	'turnos.afiliado = registracio.REG_nroregistrac and ' + mbus + ;
	'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
	'turnos.codent = afiliacion.AFI_codentidad and ' + ;
	" turnos.CODprest not in (78010600,78010601,67010201,22020300) and (not (turnos.CODprest like '28010%') or turnos.CODprest = 28010602 ) and " + ;
	" not (turnos.CODprest like '20012%') and codserv <> 1130 and  " + ;
	'turnos.fechatur = ?mft and ' + ;
	"turnos.codesp not in('KINE', 'NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', 'ECOI', 'ERGO', 'LABO', 'RADI', 'RESO', 'TOMO') " + ;
	'group by turnos.fechatur, AFI_nroafiliado, turnos.codreserva ' + ;
	'', 'mwkphorario1')

mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, preregistra.telefono as REG_telefonos, " + ;
	"turnos.diasem, turnos.codprest, preregistra.afiliado as AFI_nroafiliado, " + ;
	"turnos.codreserva, hhmmtur, ('0000000000') as REG_nrohclinica, nrodocumento as REG_numdocumento, " + ;
	"(preregistra.nombre) as REG_nombrepac, turnos.codent , " + ;
	"turnos.fechatomado, turnos.codserv, turnos.usuario, turnos.codmed " + ;
	', turnos.afiliado, cast(0 as smallint) as hca_motfalta ' + ;
	"from turnos , preregistra " + ;
	"where  " + ;
	"turnos.afiliado = preregistra.id and " + mbus + ;
	" turnos.CODprest not in (78010600,78010601,67010201,22020300)  and (not (turnos.CODprest like '28010%') or turnos.CODprest = 28010602 ) and " + ;
	" not (turnos.CODprest like '20012%') and turnos.codserv <> 1130 and " + ;
	"turnos.fechatur = ?mft and " + ;
	"turnos.codesp not in('KINE', 'NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', 'ECOI', 'ERGO', 'LABO', 'RADI', 'RESO', 'TOMO') " + ;
	"group by turnos.fechatur, preregistra.afiliado, turnos.codreserva " + ;
	"", "mwkphorario2")
*	'turnos.codmed in (605,313,984,146,241,514,127,554) and ' + ;

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	do sp_desconexion with "error"
	cancel
endif
