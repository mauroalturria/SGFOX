*!*	 Msg de Advertencias medicas
*!*	-----------------------------------------------------
Lparameters mtipo, mnroreg,mcodesp,mtb,mcursor
*mnroreg = 1
If Vartype(mtipo)#"N"
	mtipo = 1
Endif
If Vartype(mtb)#"N"
	mtb = 0
Endif
If Vartype(mcodesp)#"C"
	mcodesp = ''
Endif
If Vartype(mcursor)#"C"
	mcursor = 'mwkAdvmed'
Endif
mfecpas = Ctod("01/01/1900")
Do Case
Case mtb = 0
	mret = SQLExec(mcon1,"select * from TabRegAdvMed " + ;
		" Where TRAM_registracio = ?mnroreg and TRAM_fechapasiva = ?mfecpas " + ;
		" and (TRAM_codesp = ?mcodesp or TRAM_codesp = '') and TRAM_tipo = 0  "+;
		" " ,"mwkAdvmed0")  &&and TRAM_tipo = 0
	If Reccount()>0
		mret = SQLExec(mcon1,"select * from TabRegAdvMed " + ;
			" Where TRAM_registracio = 1 and TRAM_fechapasiva = ?mfecpas " + ;
			" and (TRAM_codesp = ?mcodesp or TRAM_codesp = '') "+;
			" and TRAM_tipo = ?mtipo " ,"mwkAdvmedgral")
		If Reccount()>0
			Select mwkAdvmed0.TRAM_codesp, mwkAdvmed0.TRAM_fechapasiva,;
				mwkAdvmedgral.TRAM_mensaje, mwkAdvmed0.TRAM_registracio,mwkAdvmed0.TRAM_tipo ;
				from mwkAdvmed0,mwkAdvmedgral Into Cursor &mcursor 
		Else
			Select * From mwkAdvmed0;
				into Cursor &mcursor
		Endif
	Else
		Select * From mwkAdvmed0;
			into Cursor &mcursor
	Endif
Case mtb = 1
	mret = SQLExec(mcon1,"select * from TabRegAdvMed " + ;
		" Where TRAM_registracio = ?mnroreg and TRAM_fechapasiva = ?mfecpas " + ;
		" and (TRAM_codesp = ?mcodesp or TRAM_codesp = '') and TRAM_tipo = ?mtipo "+;
		" " , mcursor)  

Endcase
If mret < 1
	=Aerr(eros)
	Messagebox(eros(3)+"ERROR EN LA LECTURA DE LOS DATOS",16,"VALIDACION")
Endif
