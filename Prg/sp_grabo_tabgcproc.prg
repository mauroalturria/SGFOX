****
** Grabo TabGcproc
****
lparameters mabm,mcodigoproc,mdenominacion,midrelac,mtipo,mubicacion,mrevision,mid,mtipoform,miversion,mclaves
if mabm = 1
	mid=0
endif
if vartype(mclaves)#"C"
	mclaves = ''
endif
do case
	case mAbm = 1

		mret = sqlexec(mcon1,"SELECT * FROM TabGcproc WHERE  codigoproc = ?mcodigoproc"+;
			" and idrelac = ?midrelac and tipo = ?mtipo ","mwkControl4")

		if mret < 0
			=aerr(eros)
			messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
			mret=0
			cancel
		endif
		if reccount('mwkControl4') = 0
			mret = sqlexec(mcon1,"insert into TabGcproc ( codigoproc,denominacion,idrelac,tipo,ubicacion,revision,formato,version,claves) "+;
				"values(?mcodigoproc,?mdenominacion,?midrelac,?mtipo,?mubicacion,?mrevision,?mtipoform,?miversion,?mclaves)")
			if mret < 0
				=aerr(eros)
				messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
				mret=0
				cancel
			endif

			mret = sqlexec(mcon1,"SELECT * FROM TabGcproc WHERE  codigoproc = ?mcodigoproc"+;
				" and denominacion = ?mdenominacion ","mwkMaxId")
			if mret < 0
				=aerr(eros)
				messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
				mret=0
				cancel
			endif
			select mwkMaxId
			midrelac = id
			mret = sqlexec(mcon1,"update TabGcproc set codigoproc = ?mcodigoproc,denominacion = ?mdenominacion,"+;
				" idrelac = ?midrelac ,tipo = ?mtipo,ubicacion = ?mubicacion, formato = ?mtipoform "+;
				" ,version = ?miversion,claves = ?mclaves "+;
				" where id = ?midrelac " )
&&&,revision= ?mrevision
			if mret < 0
				=aerr(eros)
				messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
				mret=0
				cancel
			endif

		endif

	case mAbm = 2
		mret = sqlexec(mcon1,"update TabGcproc set codigoproc = ?mcodigoproc,denominacion = ?mdenominacion,"+;
			" idrelac = ?midrelac ,tipo = ?mtipo,ubicacion = ?mubicacion "+;
			" ,version = ?miversion ,formato = ?mtipoform, claves = ?mclaves"+;
			",revision= ?mrevision where id = ?mid " )
		if mret < 0
			=aerr(eros)
			messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
			mret=0
			cancel
		endif

	case mAbm = 3
		mret = sqlexec(mcon1," select * from TabGcgrupodoc  where id = ?mid", "mwkControl")
		mret = sqlexec(mcon1," select * from TabGcvincproc where id = ?mid ", "mwkControl2")
		if reccount('mwkControl') > 0 or  reccount('mwkControl2') > 0
			messagebox("NO SE PUEDE ELIMINAR ESTE DONUMENTO YA QUE ESTA VINCULADO CON UN GRUPO O PROCEDIMIENTO",16,"VALIDACION")
			return
		endif
		mret = sqlexec(mcon1, " delete from TabGcproc  where id = ?mid ")
		if mret < 0
			=aerr(eros)
			messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
			mret=0
			cancel
		endif
	case mAbm = 4
		mret = sqlexec(mcon1,"update TabGcproc set  idrelac = ?midrelac ,tipo = ?mtipo where id = ?mid " )
		if mret < 0
			=aerr(eros)
			messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
			mret=0
			cancel
		endif
	case mAbm = 5 &&&solo claves
		mret = sqlexec(mcon1,"update TabGcproc set  claves = ?mclaves where id = ?mid " )
		if mret < 0
			=aerr(eros)
			messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
			mret=0
			cancel
		endif
endcase

