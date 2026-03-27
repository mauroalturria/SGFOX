*!*	sp_grabo_derivasal
lparameters mabm, mid
mfhingr = sp_busco_fecha_serv("DT")
mpaso = .f.
mf1 = prg_dtoc(mfhingr-60)
if mabm = 1
	mRet = SqlExec( mcon1, " Insert Into TabDerivaSal "+ ;
		"(codent, diagnostico, edad, estado, fechahora, fechahoraIngreso, " + ;
		" notifica, nroafi, nroregistrac, observa, sexo, ubicacion, " + ;
		" traslado, usuario, codmedtrat ) Values " + ;
		"(?mcodent,  ?mdiagno, ?medad, ?mestado, ?mfechor, ?mfhingr, " + ;
		" ?mnoti, ?mnroafi, ?mnroreg, '', ?msexo, ?mubi, " + ;
		" ?mtrasla, ?midusu, ?mcodmedtrat  )"  )

	if len(mobserv)>0
		mret = sqlexec(mcon1,"select id as lid from TabDerivaSal"+;
			" where usuario=?midusu and fechahora>=?mf1 and "+;
			" nroregistrac = ?mnroreg ","mwkbusder")
		if mret > 0
			if used('mwkbusder')
				select mwkbusder
				go bottom
				mid  = mwkbusder.lid
				if mid=0	
					mf1= prg_dtoc(ttod(mfhingr-3600))
					mret = sqlexec(mcon1,"select id as lid from TabDerivaSal"+;
						" where usuario=?midusu and fechahora>=?mf1 and "+;
						" nroregistrac = ?mnroreg ","mwkbusder")
					select mwkbusder
					go bottom
					mid  = mwkbusder.lid
				endif				
				mret = sqlexec(mcon1,"insert into TabDerivaObs "+;
					"(TDO_idderiva,TDO_Observ,TDO_idusuario,TDO_fechamov,TDO_categoria) "+;
					"values (?mid,?mobserv,?midusu  ,?mfhingr,299)")
			endif
		else
			messagebox("EN BUSQUEDA DE DERIVACION"+chr(10)+;
				"PARA ASENTAR OBSERVACIONES",16,"ERROR")
		endif
	endif
endif

if mabm = 2
*****
	mret = sqlexec(mcon1,"select observa,estado,fechahora,usuario from TabDerivaSal"+;
		" where id = ?mid","mwkbusderob")
	mobservant = alltrim(nvl(mwkbusderob.observa,''))

	mesta = 200 + iif(mwkbusderob.estado # mestado,mestado,99)

	mRet = SqlExec( mcon1, " Update TabDerivaSal Set diagnostico = ?mdiagno, " + ;
		" estado = ?mestado, fechahoraingreso = ?mfhingr, notifica = ?mnoti, " + ;
		" observa = '', traslado = ?mtrasla, Ubicacion = ?mubi, codmedtrat = ?mcodmedtrat " + ;
		" where id = ?mid ")

	if mret < 1
		messagebox("EN ACTUALIZACION DE LA DERIVACION",16,"ERROR")
	endif
	if !empty(mobservant)
		mestant = 299
		musuant = alltrim(mwkbusderob.usuario)
		mfechant = mwkbusderob.fechahora
		mret = sqlexec(mcon1,"insert into TabDerivaObs "+;
			"(TDO_idderiva,TDO_idusuario,TDO_fechamov,TDO_categoria,TDO_Observ) "+;
			"values (?mid,?musuant,?mfechant ,?mestant,?mobservant)")
	endif
	if !(empty(mobserv) and mesta=299)
		mret = sqlexec(mcon1,"insert into TabDerivaObs "+;
			"(TDO_idderiva,TDO_idusuario,TDO_fechamov,TDO_categoria,TDO_Observ) "+;
			"values (?mid,?midusu ,?mfhingr,?mesta,?mobserv)")
	endif

endif

if mRet < 0
	messagebox("ERROR EN LA ACTUALIZACION, AVISAR A SISTEMAS", 16, "Validacion")
*	DO sp_desconexion WITH "error"
endif
