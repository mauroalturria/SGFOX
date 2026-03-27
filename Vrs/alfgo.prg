do sp_conexion
	select bristolord
	scan
		scatter memvar
		mret = sqlexec(mcon1, "insert into Bristol.SG_INTERNACION (" + ;
			"OS_ID,NROAFIL,TIPODOC,NRODOC,APELLIDO,NOMBRE,SEXO,FECHANAC "+;
			",FECHORAING,DIAGNOSTICO,FECHORAEGR,FECHAORDEN,LUGARINTERNAC"+;
			",CODADMISION,TIPOMOV,USUARIO,FECHAHORA ) "+;
			"values(" + ;
			"?m.OS_ID,?m.NROAFIL,?m.TIPODOC,?m.NRODOC,?m.APELLIDO,?m.NOMBRE,?m.SEXO,?m.FECHANAC "+;
			",?m.FECHORAING,?m.DIAGNOSTICO,?m.FECHORAEGR,?m.FECHAORDEN,?m.LUGARINTERNAC"+;
			",?m.CODADMISION,?m.TIPOMOV,?m.USUARIO,?m.FECHAHORA )")
		if mret<1
			set step on
			do log_errores with error(), message(), message(1), program(), lineno()
		endif
	endscan