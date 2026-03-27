*Function prg_ejecutosql
Parameters tcSql, tcCursor, tbError

If Parameters() = 1
	tcCursor = ''
	tbError = .t.
Endif

If Parameters() = 2
	tbError = .t.
Endif

Local lbResu
lbResu = .F.

USE IN SELECT(tcCursor)
Do While .T.
	mRet = Sqlexec(mcon1,tcSql,tcCursor)
	If mRet <= 0
	
		lcMessage = MESSAGE()
			
	  	if inlist(mwkexe.nomexe,'CIAM','INFORMES')
			mistack = ASTACKINFO(allamada)-1
			do Log_errores with error(), lcMessage, message(1),allamada(mistack,4), allamada(mistack,5)
		ELSE		
			oo=0
			mipro = program(oo)
			do while !empty(mipro)
				oo = oo + 1
				mipro = program(oo)
			enddo
			oo = oo-2
			amipro = program(oo)
			do Log_errores with error(), lcMessage, tcSql,amipro ,-1
		endif
&& 		SE PUEDEN SALVAR ERRORES // LOOP

		If Not tbError
			Do Case
			Case "UPDATE" $ Upper(tcSql) Or "INSERT" $ Upper(tcSql)
				tcError = 'ERROR AL ACTUALIZAR - REINTENTE'
			Case "SELECT" $ Upper(tcSql)
				tcError = 'ERROR DE LECTURA - REINTENTE'
			Otherwise
				tcError = 'ERROR NO CONTEMPLADO'
			Endcase
			Messagebox(tcError,48,"VALIDACION")
		Endif
		Exit
	Endif

	lbResu = .T.
	Exit
Enddo

Return (lbResu) && 
