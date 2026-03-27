*
* Etiquetas Citostáticos, actualización
*
Lparameters mrestos,mutiliz,mactu,mdescrib,mvalida,mpartida,mcodigo,mtotals,mfechemi,musuario,;
	mpacient,mdescris,mrespua,mbus3b,mbus4b,mbus6,mbus5

If vartype(mrespua) # "C"
	mrespua = 'NO'
Endif

If mrespua = 'NO' && 7

	mret = sqlexec(mcon1, "update TabFarmCitosI" + ;
		" set TCI_resto = ?mrestos, TCI_utilizado = ?mutiliz, TCI_remanentes = ?mactu, "+;
		" TCI_insumodescripb = ?mdescrib"+;
		" where Id = ?mvalida" )
Else

	Do case
	Case mrestos <= mwkdatg1.UnidadAmpolla

		mlrestos = 0
		mlutiliz = 0
		mldescar = mrestos

	Case mrestos > mwkdatg1.UnidadAmpolla

		mlrestos = mwkdatg1.UnidadAmpolla * int(mrestos/mwkdatg1.UnidadAmpolla)
		mldescar = mrestos - mlrestos
*		mwkdatg1.UnidadAmpolla
		mlutiliz = mutiliz + mldescar
		mutiliz  = mlutiliz

	Endcase

	mret = sqlexec(mcon1, "update TabFarmCitosI"+;
		" set TCI_resto = ?mlrestos"+;
		iif(mlutiliz=0,",TCI_utilizado=TCI_total", ",TCI_utilizado=?mutiliz")+;
		iif(mlutiliz=0,",TCI_remanentes='N'     ", ",TCI_remanentes='S'    ")+;
		" ,TCI_insumodescripb = ?mdescrib"+;
		" where Id=?mvalida" )

	If mret < 0
		Messagebox("EN ACTUALIZACION DE STOCK",16,"ERROR")
		Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Return .F.
	Endif

*!*	 15-02-2011 discrimino los descartes automatizados por emisión de etiqueta
*!*	 para luego recuperar ante la anulación de la misma
*!*	 mfechamovl = sp_busco_fecha_serv("DT")
*!*	 Do sp_grabo_farmacia_log with mpartida,mcodigo,mldescar,;
*!*	 'Descarte '+alltrim(mwkdatg1.nropof),'ITEM',mfechamovl,musuario

Endif

If mret < 0
	Messagebox("EN ACTUALIZACION DE STOCK"+CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Else

	mret = sqlexec(mcon1, "insert into TabFarmCitosE" + ;
		"(TCE_partida,TCE_insumocodigo,TCE_medidauso,TCE_fechaemite,TCE_idusuario,"+;
		"TCE_nombrepac,TCE_insumodescrip,TCE_insumodescripb)"+;
		" values (?mpartida,?mcodigo,?mtotals,?mfechemi,?musuario,?mpacient,?mdescris,?mdescrib)")

	If mret < 0
		Messagebox("EN INGRESO MAESTRO DE ETIQUETAS CITOSTATICOS"+CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
		Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Return .F.
	Else

		If used('mwknropof')
			Use in mwknropof
		Endif

		maudint = .T.
		If mwkdatg1.intra = 1 and len(alltrim(mnropof)) > 0
			maudint = .F.
		Endif

		mret = sqlexec(mcon1,"select id as lid from TabFarmCitosE where "+;
			"TCE_idusuario=?musuario and TCE_fechaemite=?mfechemi and TCE_insumocodigo=?mcodigo",+;
			"mwknropof")

		If mret < 0
			Messagebox("CONSULTA DEL PROTOCOLO ONCOLOGICO DE FARMACIA"+CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
			Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
			Return .F.
		Else

			mvalid = 0
			
			If used('mwknropof')
				If reccount('mwknropof') > 0

*!*                 31/12/2012 Ctrl Insumos por separado
					Select mwknropof
					Go bottom
					mvalid = mwknropof.lid

					mret = sqlexec(mcon1,"select top 1 TCE_nropof from TabFarmcitosE"+;
						" where TCE_nropof is not NULL  order by id desc","mwknropofN")
						
					If mret > 0
						If maudint
							Select mwknropofN
							Go bottom
							mnropofn = val(right(mwknropofN.TCE_nropof,6))+1
							mnropof  = 'POF'+Transform(mnropofn,"@L 999999")
						Endif
						Use in mwknropofN
					Else
						Messagebox("EN BUSQUEDA DE NRO POF"+chr(10)+;
							"AVISE A SISTEMAS",16,"ERROR")
						Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
						Return .F.
					Endif
					
				Else
					mnropof = 'POF000001'
				Endif
			Endif

*****       ACTUALIZAR CONTEMPLANDO SERIE VERIFICAR TRAZABLE Y NO ---- VER DE SUMAR UN IDENTIFICADOR TIPO SERIE 28-12-2012

			mret = sqlexec(mcon1,"update TabFarmCitosE set TCE_nropof = ?mnropof where "+;
				"TCE_idusuario = ?musuario and TCE_fechaemite = ?mfechemi and TCE_insumocodigo = ?mcodigo"+;
				iif(mwkdatg1.intra = 0 and mvalid > 0, " and TabFarmCitosE.id = ?mvalid", ""))

*!*			Iif(mvalid > 0," and TabFarmCitosE.id = ?mvalid",""))				

			If mret < 0
				Messagebox("ACTUALIZACION DEL PROTOCOLO ONCOLOGICO FARMACIA"+CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
				Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
				Return .F.
			Else
				Select mwkdatg1
				Replace mwkdatg1.nropof with mnropof
			Endif

			If mrespua = 'SI'
*!* 			15-02-2011 discrimino los descartes automatizados por emisión de etiqueta para luego recuperar ante la anulación de la misma
				mfechamovl = sp_busco_fecha_serv("DT")
				Do sp_grabo_farmacia_log with mpartida,mcodigo,mldescar,;
					'Descarte '+alltrim(mwkdatg1.nropof),'ITEM',mfechamovl,musuario,;
					mbus3b,mbus4b,mbus6,mbus5
			Endif
		Endif
	Endif
Endif
Return .T.