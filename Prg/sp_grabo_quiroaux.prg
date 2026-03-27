parameter mabm,mauxiliar,mcateg,mid

mfechatope = sp_busco_fecha_serv('DD')
mfechanul = ctod("01/01/1900")

do case
	case mabm = 1
		mret =	sqlexec(mcon1,"select * from TabQuirAux " +;
			" where Descripcion = ?mauxiliar and Categoria = ?mcateg","mwkauxi")

		if reccount('mwkauxi') > 0
			messagebox("AUXILIAR EXISTENTE",16,"VALIDACION")
			grabo = .f.
			return
		endif
		mret =	sqlexec(mcon1,"insert into TabQuirAux (Categoria , Descripcion , FecPasiva )" +;
			" values( ?mcateg, ?mauxiliar, ?mfechanul )")

	case mabm = 2
		mret =	sqlexec(mcon1,"update TabQuirAux set Descripcion = ?mauxiliar  "+;
			" where id = ?mid ")
	case mabm = 3
		mret =	sqlexec(mcon1,"update TabQuirAux set FecPasiva = ?mfechatope "+;
			" where id = ?mid ")
endcase


if mret<1
	=aerr(eros)
	messagebox(eros(3)  )
endif
