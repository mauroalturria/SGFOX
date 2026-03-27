*
* Incorporación de Entidades utilizadas por sistema CIAM anterior, relevadas x operador Carlos
*

Public mcon1
Close databases

Set DATE TO FRENCH
Set CENTURY ON
*Set SYSMENU TO
Set EXCLUSIVE OFF
Set DECIMALS TO 0
Set MULTILOCKS ON
Set NOTIFY OFF
Set CPDIALOG OFF
Set SAFETY OFF

mcon1 = SQLCONNECT("conec01") && Real
* mcon1 = SQLCONNECT("conec02") && Desarrollo

Dimension mvec[7,2]

mvec[1,1] = 1
mvec[1,2] = 2
mvec[2,1] = 2
mvec[2,2] = 1
mvec[3,1] = 3
mvec[3,2] = 3
mvec[4,1] = 4
mvec[4,2] = 7
mvec[5,1] = 5
mvec[5,2] = 6
mvec[6,1] = 6
mvec[6,2] = 8
mvec[7,1] = 7
mvec[7,2] = 9

mobser = 'PROCEDE DE EXCEL CIAM - PROCESADO POR EL OPERADOR CARLOS'
mfecpa = ctod("01/01/1900")
mregis = 0

Do sp_control_aplicacion with "Microsoft Excel"
oleapp = createobject("excel.application")
oleapp.workbooks.open("C:\ciam.xls")

For i = 9 to 440

	mval1 = oleapp.cells(i,9).value

	If vartype(mval1)<>"C"
		mvalor = alltrim(str(nvl(mval1,0)))
	Else
		mvalor = alltrim(mval1)
	Endif

	If nvl(mvalor,'') = '*'

		mempno = oleapp.cells(i,2).value && R.S.
		mdirec = oleapp.cells(i,3).value && Direccion
		mlocal = oleapp.cells(i,5).value && Localidad
		mcodpo = oleapp.cells(i,6).value && Codigo Postal
		midpro = oleapp.cells(i,7).value && ID Provincia
		midloc = oleapp.cells(i,8).value && ID Localiad

		mtp = nvl(oleapp.cells(i,10).value,0) && Tipo Pac.
		mto = nvl(oleapp.cells(i,11).value,0) && Tipo Origen
		mtb = nvl(oleapp.cells(i,12).value,0) && Tipo Busqueda
		mtt = nvl(oleapp.cells(i,13).value,0) && Tipo Traslado

		If vartype(mtp)="C"
			mtp = 0
		Endif

		If vartype(mto)="C"
			mto = 0
		Endif

		If vartype(mtb)="C"
			mtb = 0
		Endif

		If vartype(mtt)="C"
			mtt = 0
		Endif

		mtipifica = 0
		If mtp > 0
			mtipifica = mvec[mtp,2]
		Else
			If mto > 0
				mtipifica = mvec[mto,2]
			Else
				If mtb > 0
					mtipifica = mvec[mtb,2]
				Else
					If mtt > 0
						mtipifica = mvec[mtt,2]
					Endif
				Endif
			Endif
		Endif

		mv1 = iif(mtp>0,1,0)  && TCU_tipou
		mv2 = iif(mto>0,1,0)  && TCU_tipop
		mv3 = iif(mtb>0,1,0)  && TCU_tipob
		mv4 = iif(mtt>0,1,0)  && TCU_tipot

		If mtipifica > 0
			mret = sqlexec(mcon1,"insert into TabCiamUbica"+;
				" (TCU_nombre,TCU_direccion,TCU_localdes,TCU_telef,TCU_obser,TCU_idcodpostal,TCU_idprovincia,"+;
				"TCU_idlocal,TCU_usofrec,"+;
				"TCU_tipou,TCU_tipop,TCU_tipob,TCU_tipot,"+;
				"TCU_tipifica,TCU_fecpasiva)"+;
				" values (?mempno,?mdirec,?mlocal,' ',?mobser,?mcodpo,?midpro,?midloc,0,"+;
				"?mv1,?mv2,?mv3,?mv4,"+;
				"?mtipifica,?mfecpa)")
			If mret < 0
				=aerr(eros)
				Messagebox(eros(3),16,"ERROR")
				set step on
			Else
				mregis = mregis + 1
			Endif
		Endif

	Endif
Next

Release mvec
Release oleapp

*!* Registros en planilla xls marcados para eliminar de la base

*!*	mret = sqlexec(mcon1,"delete from TabCiamUbica where id = 229")
*!*	mret = sqlexec(mcon1,"delete from TabCiamUbica where id = 304")
*!*	mret = sqlexec(mcon1,"delete from TabCiamUbica where id = 305")
*!*	mret = sqlexec(mcon1,"delete from TabCiamUbica where id = 655")
*!*	mret = sqlexec(mcon1,"delete from TabCiamUbica where id = 684")
*!*	mret = sqlexec(mcon1,"delete from TabCiamUbica where id = 825")
*!*	mret = sqlexec(mcon1,"delete from TabCiamUbica where id = 228")
*!*	mret = sqlexec(mcon1,"delete from TabCiamUbica where id = 440")

Close databases
= SQLDisconnect(mcon1)

If mregis > 0
	Messagebox("REGISTROS PROCESADOS : "+alltrim(str(mregis)),48,"Validación")
Endif

Return
