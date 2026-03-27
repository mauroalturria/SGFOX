lparameters tnadmision,tncodmed,tnidautprevia
*--------------------------------------------------------------------------------
* Cuidados Domiciliarios Equipamiento
* mwkequip
* TabAutCDE
* mwkequip (esel N(1), etipo c(30), eotra c(30), eid N(1)
* ID Solicitud maestro
* ACE_idautprevia = 55 corresponden a pedidos de prealta
* ID Equipo
* ACE_ideqp
*--------------------------------------------------------------------------------
muser  = tncodmed
mfhoy  = sp_busco_fecha_serv('DD')
mfhoyT = sp_busco_fecha_serv('DT')
mfnull = ctod("01/01/1900")
mlid = tnidautprevia
dimension vd[2]
select mwkequip
go top
scan all
	if mwkequip.esel = 1
		vd[1] = mwkequip.eid
		vd[2] = mwkequip.eotra
		mlidEQP = 0
*ID	ACE_admision	ACE_codmed	ACE_idautprevia	ACE_ideqp	ACE_otroeqp	ACE_pasivado

		use in select("mwkpEQP")
		mret = sqlexec(mcon1,"select * from TabAutCDE "+;
			" where ACE_idautprevia = ?mlid and ACE_admision = ?tnadmision	and ACE_ideqp = ?vd[1] and ACE_pasivado = ?mfnull","mwkpEQP")
		if mret < 0
			do LOG_ERRORES with error(), message(), message(1), program(), lineno()
			return .f.
		endif

		if reccount("mwkpEQP")>0
			mlidEQP = mwkpEQP.id
		endif

		if mlidEQP = 0

			mret = sqlexec(mcon1,"insert into TabAutCDE "+;
				"(ACE_idautprevia,ACE_ideqp,ACE_otroeqp,ACE_pasivado,ACE_codmed,ACE_admision )" +;
				" values " +;
				"(?mlid, ?vd[1], ?vd[2], ?mfnull, ?muser,?tnadmision)")

		else

			mret = sqlexec(mcon1,"update TabAutCDE set"+;
				" ACE_codmed   = ?muser, "+;
				" ACE_otroeqp  = ?vd[2]"+;
				" where ID = ?mlidEQP")

		endif

		if mret < 0
			do LOG_ERRORES with error(), message(), message(1), program(), lineno()
			return .f.
		endif
	else
		if mwkequip.ebaja = 1  && se da de baja
			vd[1] = mwkequip.eid
			vd[2] = mwkequip.eotra
			mlidEQP = 0
*ID	ACE_admision	ACE_codmed	ACE_idautprevia	ACE_ideqp	ACE_otroeqp	ACE_pasivado

			use in select("mwkpEQP")
			mret = sqlexec(mcon1,"select * from TabAutCDE "+;
				" where ACE_idautprevia = ?mlid and ACE_admision = ?tnadmision	and ACE_ideqp = ?vd[1] and ACE_pasivado = ?mfnull","mwkpEQP")
			if mret < 0
				do LOG_ERRORES with error(), message(), message(1), program(), lineno()
				return .f.
			endif

			if reccount("mwkpEQP")>0
				mlidEQP = mwkpEQP.id
			endif

			mret = sqlexec(mcon1,"update TabAutCDE set"+;
				" ACE_codmed   = ?muser, "+;
				" ACE_pasivado = ?mfhoy "+;
				" where ID = ?mlidEQP")

			if mret < 0
				do LOG_ERRORES with error(), message(), message(1), program(), lineno()
				return .f.
			endif

		endif
	endif
endscan
release vd
use in select("mwkpEQP")

return .t.

