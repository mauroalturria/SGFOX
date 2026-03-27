***
*** Busqueda de usuario
***
parameter midusua, mpasswo

mfecpas = ctod('01/01/1900')
mfechoy = sp_busco_fecha_serv('DD')
if vartype(mpasswo) ="C"
	mret = sqlexec(mcon1, "select * from tabusuario " + ;
		"where idusuario = ?midusua and password = ?mpasswo " + ;
		" and fecpasiva = ?mfecpas ", "mwkusuario_sec")
	if reccount("mwkusuario_sec")>0
		if mwkusuario_sec.fecexpira <= mfechoy
			if mwkusuario_sec.diasaviso=ctod("01/01/2100")
				diasrestan = mfechoy+7
				mcodid = mwkusuario_sec.id
				mret = sqlexec(mcon1, 'update tabusuario set diasaviso = ?diasrestan '  +;
					'where id = ?mcodid')
				mret = sqlexec(mcon1, "select * from tabusuario " + ;
					"where idusuario = ?midusua and password = ?mpasswo " + ;
					" and fecpasiva = ?mfecpas ", "mwkusuario_sec")
			endif
		endif
	endif
else
	mret = sqlexec(mcon1, "select * from tabusuario " + ;
		"where idusuario = ?midusua " , "mwkusuario_sec")
endif
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	do prg_cancelo
endif
