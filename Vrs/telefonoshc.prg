*!*	Create Cursor Docu (Docu c(9))
*!*	Append From c:\desaguemes\hcli.txt Delimited With Tab
*Use c:\desaguemes\docu.Dbf In 0 Exclusive
Use c:\desaguemes\docutehc.Dbf In 0 Exclusive
Select docutehc
Zap
Pack
SET STEP ON
Append From Dbf('docu')
set
Dimension mTiposTel[20]
*SET STEP ON
mTiposTel[1] = "PART1   "
mTiposTel[2] = "PART2   "
mTiposTel[3] = "LABORAL "
mTiposTel[4] = "CELULAR "
mTiposTel[5] = "MENSAJE "
mTiposTel[6] = "NO TIENE"
mTiposTel[7] = "WASAP"
mTiposTel[9] = "RESP.INT"
Select docutehc
Use registelhc Again In 0
Select registelhc

Select docutehc

mtipotel1=0
mnro1=''
mobs1=''
mtipotel2=0
mnro2=''
mobs2=''
mtipotel3=0
mnro3=''
mobs3=''
mtipotel4=0
mnro4=''
mobs4=''
mfecpas = Ctod("01/01/1900")
Scan
	mireg = Docu  && como arraco con una cocina coon documento,siguio asi....

	Wait Windows Transform(Recno()) Nowait
	Requery('registelhc')
	If Reccount('registelhc')>0
		ir = 1
		mimail = Nvl(registelhc.reg_email,"NO TIENE")
		mitel = NVL(registelhc.REG_telefonos,'')
		Select registelhc
		Scan
			If Val(Nvl(registelhc.trt_numero,''))>0 And Val(Nvl(registelhc.trt_numero,''))#Val(mitel) ;
				And Nvl(registelhc.trt_pasiva,Date()) = mfecpas
				mctt ="mtipotel"+Transform(ir)
				mcnr ="mnro"+Transform(ir)
				mobs ="mobs"+Transform(ir)
				mit = registelhc.TRT_tipo
				mit = Iif(mit=0,1,mit)
				&mctt = mTiposTel(mit)
				&mcnr = registelhc.trt_numero
				&mobs = Nvl(registelhc.TRT_Observacion,'')
				ir=ir+1
				If ir>4
					Exit
				Endif
			Endif
		Endscan
		Select docutehc
		Replace reg_telef With mitel,email With mimail
		For uu= 1 To ir-1
			mctt ="mtipotel"+Transform(uu)
			mcnr ="mnro"+Transform(uu)
			mobs ="mobs"+Transform(uu)
			mdtt ="tipotel"+Transform(uu)
			mdnr ="nro"+Transform(uu)
			mdobs ="obs"+Transform(uu)

			Replace &mdtt With &mctt,&mdnr With &mcnr ,&mdobs With &mobs

		Next
	Endif

Endscan
Select docutehc
Copy To tele Type Xl5

*!*	esta es la vista
*!*	SELECT Registracio.REG_telefonos, Tabregtel.TRT_Numero,;
*!*	  Tabregtel.TRT_tipo, Tabregtel.TRT_Observacion, Registracio.REG_email,;
*!*	  Tabregtel.TRT_Pasiva;
*!*	 FROM ;
*!*	   {oj  SQLUser.REGISTRACIO Registracio ;
*!*	    LEFT OUTER JOIN SQLUser.TabRegTel Tabregtel ;
*!*	   ON  Registracio.REG_nroregistrac = Tabregtel.TRT_Registracio};
*!*	 WHERE  Registracio.REG_nrohclinica = ( ?mireg );
*!*	 ORDER BY Tabregtel.TRT_Pasiva
