parameters tcSql, tcCursor, tbError

if vartype(tcCursor)#"C"
	tcCursor = ''
endif

if vartype(tbError)#"L"
	tbError = .f.
endif

local lbResu
lbResu = .f.


do while .t.
	mRet = Sqlexec(mcon1,tcSql,tcCursor)
	if mRet <= 0
		if inlist(mwkexe.nomexe,'CIAM','INFORMES')
			mistack = ASTACKINFO(allamada)-1
			do Log_errores with error(), message(), message(1),allamada(mistack,4), allamada(mistack,5)
		else
			oo=0
			mipro = program(oo)
			do while !empty(mipro)
				oo = oo + 1
				mipro = program(oo)
			enddo
			oo = oo-2
			amipro = program(oo)
			do Log_errores with error(), message(), tcSql,amipro ,-1
		endif

&& 		SE PUEDEN SALVAR ERRORES // LOOP

		if not tbError
			do case
				case "UPDATE" $ upper(tcSql) or "INSERT" $ upper(tcSql)
					tcError = 'ERROR AL ACTUALIZAR - REINTENTE'
				case "SELECT" $ upper(tcSql)
					tcError = 'ERROR DE LECTURA - REINTENTE'
				otherwise
					tcError = 'ERROR NO CONTEMPLADO'
			endcase
			messagebox(tcError,48,"VALIDACION")
		endif
		exit
	endif

	lbResu = .t.
	exit
enddo

return (iif(lbResu = .t.,1,-1)) && 1
