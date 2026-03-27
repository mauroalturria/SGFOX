*
* Bloqueo de Derivaciones
*

Use in select("mwkblqder")

mid = mwkderiva1.id          && ID derivación
mvx = mwkUsuario.codigovax   && Codigo VAX usuario p/bloqueo de registro
mtd = mwkderiva1.ltipreg     && Registro proviene de Registracio o Preregistra

mret = sqlexec(mcon1,"select * from TabDerivacion"+;
	" where id = ?mid", "mwkblqder")

If mret < 0
	Messagebox("EN CONSULTA DE DERIVACIONES"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

If used("mwkblqder")
	If reccount("mwkblqder")>0
		If mwkblqder.vaxbloqreg = 0

			mret = sqlexec(mcon1,"update TabDerivacion set vaxbloqreg = ?mvx"+;
				" where id = ?mid")

			If mret < 0
				Messagebox("EN ACTUALIZACION DE DERIVACION"+chr(10)+;
					"AVISE A SISTEMAS",16,"ERROR")
				Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
				Return .F.
			Endif


		Endif
	Endif
Endif

&& Armo nuevamente mwkderiva1 como mwkblqder
Use in select("mwkblqder")

If mtd = 'R'

	mret = sqlexec(mcon1, "select tabderivacion.id, tabderivacion.codent, codint, denpolicial,"+;
		"derivadopor, diagnostico, edad, tabderivacion.estado, tabderivacion.fechahora, notifica,"+;
		"nroafi, nroregistrac, observa, padron, sexo, traslado, usuario,"+;
		"ENT_descrient, REG_nombrepac, tabsectorint.descrip as sectorint,"+;
		"fechahoraingreso, tabderivacion.habitacion, tabderivacion.cama,"+;
		"REG_numdocumento as nrodocumento, TabEstados.Descrip as estado1,'R' as ltipreg, vaxbloqreg, TabUsuario.nomape"+;
		" From tabderivacion"+;
		" left join TabUsuario on codigovax = TabDerivacion.vaxbloqreg"+;
		" join registracio on nroregistrac = REG_nroregistrac"+;
		" join entidades on ENT_codent = Tabderivacion.codent"+;
		" join tabsectorint on Tabsectorint.id = codint"+;
		" join TabEstados on TabEstados.Estado =  Tabderivacion.Estado and TabEstados.Propietario = 81"+;
		" where Tabderivacion.ID = ?mid","mwkblqder")		

	If mret < 0
		=Aerror(merror)
		Messagebox(merror(3))
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif
	do sp_busco_entidad_afiliado with mwkblqder.nroregistrac
Else

	mret = sqlexec(mcon1, "select tabderivacion.id, tabderivacion.codent, codint,"+;
		"denpolicial, derivadopor, diagnostico, edad, tabderivacion.estado,"+;
		"tabderivacion.fechahora, notifica, nroafi, nroregistrac,"+;
		"observa, padron, tabderivacion.sexo, traslado,"+;
		"tabderivacion.usuario, ENT_descrient, nombre as REG_nombrepac,"+;
		"tabsectorint.descrip as sectorint, fechahoraingreso, tabderivacion.habitacion,"+;
		"tabderivacion.cama,preregistra.nrodocumento, TabEstados.Descrip as estado1,'P' as ltipreg,vaxbloqreg,TabUsuario.nomape"+;
		" From tabderivacion"+;
		" left join TabUsuario on codigovax = TabDerivacion.vaxbloqreg"+;
		" join preregistra on nroregistrac = preregistra.id"+;
		" join entidades on ENT_codent = Tabderivacion.codent"+;
		" join tabsectorint on Tabsectorint.id = codint"+;
		" join TabEstados on TabEstados.Estado = Tabderivacion.Estado and TabEstados.Propietario = 81"+;
		" where Tabderivacion.ID = ?mid","mwkblqder")		

	If mret < 0
		=Aerror(merror)
		Messagebox(merror(3))
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

Endif

Select fechahora,REG_nombrepac,ent_descrient,substr(alltrim(diagnostico),1,200) as diag,;
	sectorint,estado1,iif(fechahoraingreso > ctot('01/01/1900'),;
	ttoc(fechahoraingreso),space(16)) as fechahorai,;
	nvl(habitacion,space(50)) + ' ' + nvl(cama,'') as habcam,;
	observa,codent,codint,denpolicial,derivadopor,edad,estado,nrodocumento,;
	notifica,nroafi,nroregistrac,padron,sexo,traslado,usuario,id,diagnostico,ltipreg,vaxbloqreg,nomape;
	from mwkblqder;
	into cursor mwkblqder

Return .T.
