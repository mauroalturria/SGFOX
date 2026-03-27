************
*
************
parameter mdecr,mid,mabm

mfechatope = sp_busco_fecha_serv('DD')

do case
	case mabm = 1
		mret =	sqlexec(mcon1,"select descr from tabStMod where descr = ?mDecr  ","mwkValidMod")
		if reccount('mwkValidMod') > 0
			messagebox("MODELO EXISTENTE",16,"VALIDACION")
			grabo = .f.
			return
		endif
		mret =	sqlexec(mcon1,"insert into tabStMod (descr)" +;
			" values(?mdecr)")

	case mabm = 2
		mret =	sqlexec(mcon1,"update tabStMod set descr= ?mDecr "+;
			" where id = ?mid ")
	case mabm = 3
		mret =	sqlexec(mcon1," select * from tabStPuesto where idModelo  = ?mid  ","mwkValid")
		if reccount('mwkValid') > 0
			messagebox("MODELO VINCULADO A UN PUESTO DE TRABAJO",16,"VALIDACION")
			grabo = .f.
			return
		endif
		mret =	sqlexec(mcon1,"delete from tabStMod where id = ?mid ")
endcase


if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
