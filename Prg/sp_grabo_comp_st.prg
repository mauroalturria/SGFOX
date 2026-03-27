************
*		Grabo ???
*************
parameter mdecr,mtipo,mstock,mid,mabm

mfechatope = sp_busco_fecha_serv('DD')

do case
	case mabm = 1
		mret =	sqlexec(mcon1,"select descr from tabStComponente where descr = ?mDecr and TipoComp = ?mTipo ","mwkValidComp")
		if reccount('mwkValidComp') > 0
			messagebox("COMPONENTE EXISTENTE",16,"VALIDACION")
			grabo = .f.
			return
		endif
		mret =	sqlexec(mcon1,"insert into tabStComponente (descr,tipocomp,stock)" +;
			" values(?mdecr,?mtipo,?mstock)")

	case mabm = 2
		mret =	sqlexec(mcon1,"update tabStComponente set descr= ?mDecr,tipocomp= ?mTipo,stock= ?mStock"+;
			" where id = ?mid ")
	case mabm = 3
		mret =	sqlexec(mcon1," select * from tabStDetPuesto where idComp  = ?mid  ","mwkValidc")
		if reccount('mwkValidc') > 0
			messagebox("COMPONENTE VINCULADO A UN PUESTO DE TRABAJO",16,"VALIDACION")
			grabo = .f.
			return
		endif
		mret =	sqlexec(mcon1,"delete from tabStComponente where id = ?mid ")
endcase


if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
