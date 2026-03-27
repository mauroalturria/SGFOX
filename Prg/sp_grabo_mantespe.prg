
Parameter mabm,mespecialidad,mid

Dimension cf(100)
Store '' to cf

mfechatope = sp_busco_fecha_serv('DD')
mfecnull   = ctod("01/01/1900")

Do case
Case mabm = 1
	mret =	sqlexec(mcon1,"select especialidad  from tabMantespecialidad " +;
		" where especialidad  = ?mespecialidad  ","mwkMantespecialidad")

	If reccount('mwkMantespecialidad') > 0
		Messagebox("ESPECIALDIDAD EXISTENTE",16,"VALIDACION")
		grabo = .f.
		Return
	Endif
	mret =	sqlexec(mcon1,"insert into tabMantespecialidad(especialidad  )" +;
		" values(?mespecialidad)")

Case mabm = 2
	mret =	sqlexec(mcon1,"update tabMantespecialidad set especialidad  = ?mespecialidad  "+;
		" where id = ?mid ")

Case mabm = 3
	mret =	sqlexec(mcon1," select * from TabMantTecnico where idespecialidad = ?mid "+;
		" and FechaPasiva = ?mfecnull ","mwkValidc")

	If reccount('mwkValidc') > 0
		Messagebox("ESPECIALDIDAD VINCULADO A UN TÉCNICO",16,"VALIDACION")
		grabo = .f.
		Return
	Endif
	mret =	sqlexec(mcon1,"delete from tabMantespecialidad where id = ?mid ")
Endcase

If mret<1
	=aerr(eros)
	Messagebox(eros(2))
Endif
