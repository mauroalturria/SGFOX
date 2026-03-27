*********
* Busca turnos cancelados o reporgramados  de un profesional o un codigo de reserva
*********
lparameters mcancelado,mfechad,mcodmed,mcodreserv


if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif
mcfecdes 	= prg_dtoc(mfechad)
mcfecHas 	= prg_dtoc(mfechad + 1)
if empty(mcodreserv)
	if mcancelado = 1
		mret = sqlexec(mcon1," select horatur,reg_nombrepac as nombre,"+ ;
			" reg_telefonos,codmed,turnoscall.usuario,turnoscancel.id, "+;
			" turnoscall.codreserva as codreserv,afiliado,turnoscancel.codreserva,fechatur "+;
			" from registracio ,turnoscancel "+;
			" left join turnoscall on turnoscall.codreserva  = turnoscancel.codreserva "+;
			" where  &mccpoamb feccancela>=?mcfecdes and feccancela<?mcfecHas and  "+;
			" turnoscancel.afiliado = registracio.reg_nroregistrac and codcancela = 5 "+;
			" and codmed = ?mcodmed  " + ;
			" " ,"mwkcancrepro01")

		mret = sqlexec(mcon1, "select horatur, nombre,"+ ;
			" telefono as reg_telefonos,codmed,turnoscall.usuario,turnoscancel.id, "+;
			" turnoscall.codreserva as codreserv, turnoscancel.afiliado,turnoscancel.codreserva,fechatur "+;
			" from  preregistra,turnoscancel " + ;
			" left join turnoscall on turnoscall.codreserva  = turnoscancel.codreserva "+;
			" where &mccpoamb turnoscancel.afiliado = nroregistracio and feccancela>=?mcfecdes and feccancela<?mcfecHas  " + ;
			" and codcancela = 5  and codmed = ?mcodmed " + ;
			"  " , "mwkcancrepro02")

		if mret < 0
			=aerr(eros)
			do prg_error with eros,'sp_lista_turnos_cancel1'
			cancel
		endif

		select *,iif(empty(codreserv),100-100,count(codreserv)) as cantcodreserva;
			from mwkcancrepro01 ;
			group by fechatur,afiliado, codreserva,horatur union all ;
			select *,iif(empty(codreserv),100-100,count(codreserv)) as cantcodreserva ;
			from mwkcancrepro02  ;
			group by fechatur,afiliado, codreserva,horatur into cursor  mwkturnocancel

		select horatur as fecha,nombre,nvl(reg_telefonos,'') as reg_telefonos, ;
			cantcodreserva ,codreserva from mwkturnocancel ;
			group by fechatur,afiliado, codreserva into cursor mwkcancrepro
	else
		mret = sqlexec(mcon1," select fechaturnva ,cantidadpac, "+;
			" turnosreprog.codmed as codmedr,"+;
			" turnos.codmed as codmedt,codmedrepro,fecharep,fechaturant,fechatur,hhmmtur,"+;
			" reg_nombrepac as nombre,reg_telefonos,turnos.observa, "+;
			" turnos.codreserva,turnoscall.usuario,estado,horatur,turnos.id,   "+;
			" turnoscall.codreserva as codreserv,afiliado"+;
			" from registracio , turnosreprog left join turnos on turnos.fechatur = turnosreprog.fechaturnva  "+;
			" left join turnoscall on turnoscall.codreserva  = turnos.codreserva "+;
			" where  &mccpoamb fecharep>=?mcfecdes and fecharep<=?mcfecHas and "+;
			" turnos.afiliado = registracio.reg_nroregistrac   "+;
			" and turnosreprog.codmed = ?mcodmed and codmedrepro = turnos.codmed "+;
			" union all " +;
			" select fechaturnva,cantidadpac,turnosreprog.codmed as codmedr,"+;
			" turnos.codmed as codmedt,codmedrepro,fecharep,fechaturant,fechatur,hhmmtur,"+;
			" reg_nombrepac as nombre,reg_telefonos,turnos.observa, "+;
			" turnos.codreserva,turnoscall.usuario,estado,horatur,turnos.id,  "+;
			" turnoscall.codreserva as codreserv,afiliado "+;
			" from registracio,turnosreprog  left join turnos on turnos.fechatur = turnosreprog.fechaturnva  "+;
			" left join turnoscall on turnoscall.codreserva  = turnos.codreserva "+;
			" where &mccpoamb  fecharep>=?mcfecdes and fecharep<=?mcfecHas and "+;
			" turnos.afiliado = registracio.reg_nroregistrac   "+;
			" and turnos.codmed = ?mcodmed and (turnosreprog.codmed = ?mcodmed  "+;
			" and codmedrepro = 1) " +;
			" ","mwkturnos")

		select horatur as fecha,nombre,nvl(reg_telefonos,'') as reg_telefonos,;
			iif(empty(codreserv),100-100,count(codreserv)) as cantcodreserva,;
			fechaturant,;
			cantidadpac,codmedr,;
			iif(codmedrepro = 1,codmedr,codmedrepro) as codmedrepro,;
			usuario,codreserva,estado ;
			from mwkturnos where substr(alltrim(observa),1,3) = 'REP' ;
			group by fechatur, afiliado,codreserva order by horatur ;
			into cursor mwkcancrepro
	endif
endif

if mret < 0
	messagebox("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
endif

