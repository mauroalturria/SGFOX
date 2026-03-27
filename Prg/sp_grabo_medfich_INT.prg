*
* Fichadas de Profesionales de Pisos
*
lparameters mabm,mcodmed,mestado,mfecent,msalida,msect,mitipo

do case
	case mabm = 1 && nuevo
		mret = sqlexec(mcon1,"insert into ZabIntIEMed (CodAmbito,TII_fichaEnt,TII_fichaSal,TII_sector,TII_supervisor,TII_tipo,TII_usuario) "+;
			"values (?mxambito,?mfecent,?msalida,?msect,?mestado,?mitipo,?mcodmed)")

		if mret < 0
			messagebox("EN BUSQUEDA DEL PROFESIONAL EN FICHADAS",16,"ERROR")
			do log_errores with error(), message(), message(1), program(), lineno()
		endif

	case mabm = 2 && actualizo

		mfecnull = ctod("01/01/1900")
		mbussec = iif(empty(msect ),""," and TII_sector = ?msect ")
		mret = sqlexec(mcon1,"update ZabIntIEMed set TII_fichasal=?msalida "+;
			"where TII_usuario=?mcodmed and TII_fichasal=?mfecnull and TII_fichaEnt=?mfecent "+mbussec )
		if mret < 0
			messagebox("EN BUSQUEDA DEL PROFESIONAL EN FICHADAS",16,"ERROR")
			do log_errores with error(), message(), message(1), program(), lineno()
		else
			mret = sqlexec(mcon1,"select ID,TII_fichaEnt, TII_fichaSal, TII_sector, TII_supervisor, TII_tipo, TII_usuario FROM ZabIntIEMed  "+;
				" where TII_usuario =?mcodmed  and TII_fichasal=?mfecnull ","mwkbusmedaux")
			if mret < 0
				messagebox("EN BUSQUEDA DEL PROFESIONAL EN FICHADAS",16,"ERROR")
				do log_errores with error(), message(), message(1), program(), lineno()
			else
				if reccount("mwkbusmedaux")>0
					messagebox("HAY INGRESOS SIN FICHAR LA SALIDA",48,"Control de egreso")
				endif

			endif
		endif

*!*    TGF_estado=1
endcase
