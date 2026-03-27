*
* Actualización de Sala / Modificación de Franjas - Prestaciones
*
lparameters mlcodmed, mlfechat, mlcodmed, mlidfran, mlconant, mlconnew

&& Horarios ConsulE
use in select("mwkctrlcons")
lcErrorAnt = ON("ERROR")
mret = sqlexec(mcon1,"Select ID as lid from horarioconsule"+;
	" where codmed = ?mlcodmed"+;
	" and sala = ?mlconant"+;
	" and fecha = ?mlfechat","mwkctrlcons")

if mret < 0
	messagebox("Error al consultar Horarios",26,"Error")
	on error do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif

if used("mwkctrlcons")
	if reccount("mwkctrlcons") > 0
		mbusid = mwkctrlcons.lid
		mret = sqlexec(mcon1,"update horarioconsule set sala = ?mlconnew where id = ?mbusid")
		if mret < 0
			messagebox("Error al actualizar Horarios",26,"Error")
			on error do log_errores with error(), message(), message(1), program(), lineno()
			return .f.
		endif
	endif
endif
use in select("mwkctrlcons")

&& TabAmbIEMed
use in select("mwkctrliemd")

mret = sqlexec(mcon1,"Select ID as lid from tabambiemed"+;
	" where TAI_codmed = ?mlcodmed"+;
	" and TAI_idfranja = ?mlidfran"+;
	" and TAI_fecha = ?mlfechat"+;
	" and TAI_consultorio = ?mlconant"+;
	" and TAI_hhmmEgr = 9999","mwkctrliemd")

if mret < 0
	messagebox("Error al consultar Registro de Profesionales",26,"Error")
	on error do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif
if used("mwkctrliemd")
	if reccount("mwkctrliemd") > 0
		mbusid = mwkctrliemd.lid
		mret = sqlexec(mcon1,"update tabambiemed set TAI_consultorio = ?mlconnew where id = ?mbusid")
		if mret < 0
			messagebox("Error al actualizar Registro de Profesionales",26,"Error")
			on error do log_errores with error(), message(), message(1), program(), lineno()
			return .f.
		endif
	else
		mret = sqlexec(mcon1,"Select ID as lid ,hhmmdes,hhmmhas from tabambiemed"+;
			" inner join franjahoraria on TAI_idfranja = franjahoraria.id "+;
			" where TAI_codmed = ?mlcodmed"+;
			" and TAI_fecha = ?mlfechat"+;
			" and TAI_consultorio = ?mlconant"+;
			" and TAI_hhmmEgr = 9999","mwkctrliemd")
			
	endif

endif
use in select("mwkctrliemd")

On Error &lcErrorAnt
return .t.
