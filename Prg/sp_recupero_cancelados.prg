*****
** recupero de turnoscancel a turnos
*****
parameters mfecha,mcodmed,mmot,mfecan


mccpoamb = ''	
mctcpoamb = ''	
mcicpoamb = ''
mvicpoamb = ''
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
	mctcpoamb = "  t.codambito = ?mxambito and "
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
endif


mret = sqlexec(mcon1,"select * from turnoscancel "+;
	"where &mccpoamb  codreserva<>'' and  codmed = ?mcodmed and fechatur = ?mfecha "+;
	"and codcancela = ?mmot "+;
	' and cast(feccancela as date) = ?mfecan ', "mwkhay")
mselec = ''
do sp_insert_tabctrlagenda with 9,transf(reccount('mwkhay')),mcodmed,mfecha,.name,mfecha,mselec

sele mwkhay
scan

	midturno 	=  mwkhay.idturnos

	mnrohc		= mwkhay.afiliado
	midusua		= mwkhay.usuario
	mhtomado	= mwkhay.fechatomado
	mcodprest	= mwkhay.codprest
	mcodsoli	= mwkhay.codmedsoli
	msolicigia  = mwkhay.solicigia
	mcreserva	= mwkhay.codreserva
	mcodent		= mwkhay.codent
	mcodserv	= mwkhay.codserv
	mcodespe	= mwkhay.codesp
	mtiptur		= mwkhay.tipoturno
	mtomado  	= 1
	mdiasem		= diasem
	mhhmmtur	= hhmmtur
	mhoratur	= mwkhay.horatur
	mususec		= mwkhay.UsuarioSector
	mobserva	= observa
	mnrovale	= mwkhay.nrovale
	mconfirmado	= NVL( mwkhay.confirmado,0)
	musuariogenera = mwkusuario.idusuario
	mfechagenera = mwkfecserv.fechahora
	mret = sqlexec(mcon1,"select * from turnos where &mccpoamb   codreserva<>'' and  codmed = ?mcodmed "+;
		" and fechatur = ?mfecha and horatur= ?mhoratur and afiliado = ?mnrohc and codprest = ?mcodprest ","mwkcontrol")
	if reccount("mwkcontrol") = 0
		mret = sqlexec(mcon1,"select id,tipoturno from turnos where &mccpoamb  turnos.codreserva<>'' and  id = ?midturno and codmed = ?mcodmed "+;
			" and fechatur = ?mfecha and horatur= ?mhoratur and afiliado <= 1 ","mwkcontrol")
		if reccount("mwkcontrol") = 0
			mret = sqlexec(mcon1,"select id,tipoturno from turnos where &mccpoamb  turnos.codreserva<>'' and  codmed = ?mcodmed and tipoturno= 9 "+;
				" and fechatur = ?mfecha and horatur= ?mhoratur and afiliado <= 1 ","mwkcontrol")
			if reccount("mwkcontrol") > 0
				midturno = mwkcontrol.id
			endif
		endif
		if mwkcontrol.tipoturno = 9
			mret = sqlexec(mcon1,"update turnos set afiliado = ?mnrohc, usuario = ?midusua, " + ;
				"fechatomado = ?mhtomado, codprest = ?mcodprest, tipoturno =  ?mtiptur, "+;
				"UsuarioSector = ?mususec, observa = ?mobserva ,nrovale = ?mnrovale,confirmado = ?mconfirmado," + ;
				"codmedsoli = ?mcodsoli, solicigia = ?msolicigia, codreserva = ?mcreserva, " + ;
				"codent = ?mcodent, codserv = ?mcodserv, codesp = ?mcodespe, tipotomado = ?mtomado " + ;
				"where &mccpoamb id = ?midturno and  codmed = ?mcodmed and fechatur = ?mfecha and horatur= ?mhoratur and afiliado <= 1 "+;
				"and tipoturno= 9 ")
		else
			mret=sqlexec(mcon1,"INSERT INTO turnos (afiliado,codent,codesp,codmed,codserv,"+;
				" confirmado,diasem,fechatur,hhmmtur,horatur,tipotomado,"+;
				" codprest,usuario,solicigia,fechatomado,codreserva,codmedsoli,"+;
				" tipoturno,usuariogenera, fechagenera,  observa,UsuarioSector,nrovale,confirmado &mcicpoamb) " + ;
				"VALUES (?mnrohc,?mcodent,?mcodespe,?mcodmed ,?mcodserv,"+;
				"0,?mdiasem,?mfecha ,?mhhmmTur,?mhoratur,?mtomado,?mcodprest, "+;
				"?midusua, ?msolicigia, ?mhtomado, ?mcreserva, ?mcodsoli, "+;
				"?mtiptur, ?musuariogenera, ?mfechagenera , ?mobserva,?mususec,?mnrovale,?mconfirmado &mvicpoamb)")
		endif
	endif
endscan
sele mwkhay
scan
	midcance = id
	mid 	= left(mwkhay.codreserva, 7)
	if val(mid)<5000000
		midr= val(mid)+5555555
		mid = transf(midr,"@L 9999999")
	endif
	mcreserva	= mwkhay.codreserva
	mhoratur	= mwkhay.horatur
	mafi 		= mwkhay.afiliado
	mret = sqlexec(mcon1,"select id from turnos  " + ;
		"where &mccpoamb  and codmed = ?mcodmed and fechatur = ?mfecha and horatur= ?mhoratur "+;
		" and afiliado = ?mafi " ,"mwkcontrol")
	if reccount("mwkcontrol")>0
		mret = sqlexec(mcon1,"delete from turnoscancel  " + ;
			"where &mccpoamb  id = ?midcance and horatur= ?mhoratur and codreserva = ?mcreserva ","mwkcontrol")
	endif

endscan
mret = sqlexec(mcon1, 'select t.id, t.fechatur, t.horatur, t.codesp, t.diasem, t.codprest, ' + ;
	't.usuario, t.fechatomado, t.confirmado, t.codreserva, prestadores.nombre, ' + ;
	't.codmedsoli, t.solicigia, t.tipoturno, t.codserv, t.codmed, t.codent, ' + ;
	'AFI_nroafiliado, registracio.REG_nrohclinica, registracio.REG_numdocumento,registracio.REG_bloq_comen, ' + ;
	'registracio.REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
	'registracio.REG_telefonos, t.afiliado, 0 as preacre, t.codcancela, t.observa, null as fechaobserva,' + ;
	'feccancela, usucancela,nrovale,confirmado ' + ;
	'from turnoscancel as t, prestadores, registracio, prestacions, entidades, afiliacion ' + ;
	" where &mctcpoamb  t.codreserva<>'' and t.codmed = prestadores.id and " + ;
	't.codprest = prestacions.pre_codprest and '  + ;
	't.afiliado = registracio.REG_nroregistrac and ' + ;
	't.codent = entidades.ENT_codent and ' + ;
	'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
	't.codent = afiliacion.AFI_codentidad and ' + ;
	'(t.tipoturno < 8 or t.tipoturno >=13) and ' + ;
	" codmed = ?mcodmed and fechatur = ?mfecha "+;
	" and codcancela = ?mmot "+;
	' and cast(feccancela as date) = ?mfecan ', 'mwkphorario')
