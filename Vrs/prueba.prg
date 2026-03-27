***
*** Generacion de planilla de Turnos
***
public mcon1
do sp_conexion
mfecturno=date()
hora = seconds()
mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
	'turnos.diasem, turnos.codprest, prestadores.nombre, AFI_nroafiliado, REG_telefonos, ' + ;
	'turnos.codreserva, registracio.REG_nrohclinica, registracio.REG_numdocumento, turnos.codmed, ' + ;
	'registracio.REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
	'turnos.fechatomado, turnos.usuario, especialid.ESP_descripcion, hdesde1 ,turnos.afiliado ' + ;
	', sala ' + ;
	'from turnos , prestadores, registracio, prestacions, entidades, afiliacion, especialid , medpresta ' + ;
	'where turnos.codmed = prestadores.id and ' + ;
	'turnos.codprest = prestacions.pre_codprest and '  + ;
	'turnos.afiliado = registracio.REG_nroregistrac and ' + ;
	'turnos.codmed = medpresta.codmed and ' + ;
	'turnos.codprest = medpresta.codprest and ' + ;
	'medpresta.diasem > 0 and ' + ;
	'medpresta.diasem = turnos.diasem and ' + ;
	'turnos.fechatur >= medpresta.fecvigend and ' + ;
	'turnos.fechatur <  medpresta.fecvigenh and ' + ; 
	'hhmmtur >= medpresta.hhmmdes and hhmmtur<medpresta.hhmmhas and ' + ;
	'trim(turnos.codesp) = trim(especialid.ESP_codesp) and ' + ;
	'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
	'turnos.codent = afiliacion.AFI_codentidad and ' + ;
	'turnos.codent = entidades.ENT_codent and ' + ;
	'turnos.tipoturno < 9 and ' + ;
	'turnos.fechatur = ?mfecturno and ' + ;
	"turnos.afiliado > 0 and turnos.id < 1000000000 " + ;
	'group by turnos.fechatur, AFI_nroafiliado, turnos.codreserva ' + ;
	'', 'mwkphorario2')

messagebox(transform(seconds()-hora ))
hora = seconds()
mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
	'turnos.diasem, turnos.codprest, prestadores.nombre, AFI_nroafiliado, REG_telefonos, ' + ;
	'turnos.codreserva, registracio.REG_nrohclinica, registracio.REG_numdocumento, turnos.codmed, ' + ;
	'registracio.REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
	'turnos.fechatomado, turnos.usuario, especialid.ESP_descripcion, hdesde1 ,turnos.afiliado ' + ;
	', sala ' + ;
	'from turnos , prestadores, registracio, prestacions, entidades, afiliacion, especialid , medpresta ' + ;
	'where turnos.codmed = prestadores.id and ' + ;
	'turnos.codprest = prestacions.pre_codprest and '  + ;
	'turnos.afiliado = registracio.REG_nroregistrac and ' + ;
	'turnos.codmed = medpresta.codmed and ' + ;
	'turnos.codprest = medpresta.codprest and ' + ;
	'medpresta.diasem > 0 and ' + ;
	'medpresta.diasem = turnos.diasem and ' + ;
	'turnos.fechatur >= medpresta.fecvigend and ' + ;
	'turnos.fechatur <  medpresta.fecvigenh and ' + ; 
	'hhmmtur >= medpresta.hhmmdes and hhmmtur<medpresta.hhmmhas and ' + ;
	'trim(turnos.codesp) = trim(especialid.ESP_codesp) and ' + ;
	'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
	'turnos.codent = afiliacion.AFI_codentidad and ' + ;
	'turnos.codent = entidades.ENT_codent and ' + ;
	" turnos.CODprest <> 2202300 and (not (turnos.CODprest like '28010%') or turnos.CODprest = 28010602 ) and " + ;
	" not (turnos.CODprest like '20012%') and " + ;
	'turnos.tipoturno < 9 and ' + ;
	'turnos.fechatur = ?mfecturno and ' + ;
	"turnos.afiliado > 0 and turnos.id < 1000000000 and " + ;
	"turnos.codesp not in('NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOG', 'ECOI', 'ERGO', 'KINE', 'LABO', 'RADI', 'RESO', 'TOMO') " + ;
	'group by turnos.fechatur, AFI_nroafiliado, turnos.codreserva ' + ;
	'', 'mwkphorario1')

messagebox(transform(seconds()-hora ))

