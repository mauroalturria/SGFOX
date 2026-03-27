*
* Guardias Pasivas - Interfaz Web
*                  - 12/07/2013: Se contempla Enfermería
*
Lparameters mtipo

mfnull  = ctod("01/01/1900")

MsqlCon = Sqlstringconnect("Driver=MySQL ODBC 3.51 Driver; Server=190.228.29.63; UID=cuiddom; PWD=cuiddom01; Database=guarpas")
*MsqlCon = Sqlstringconnect("Driver=MySQL ODBC 3.51 Driver; Server=localhost; UID=root; PWD=mysql01; Database=guarpas")

If MsqlCon > 0

	=SQLSETPROP(MsqlCon,"Transactions",2)
	=SQLSETPROP(MsqlCon,"Asynchronous",.F.)

	If mtipo = 0 && Todo
		mret = sqlexec(MsqlCon,"update tblgpuser set estado = '' ")
		If mret < 0
			=sqldisconnect(MsqlCon)
			MTABLA = "TABLA WEB USUARIOS INICIALIZA ESTADOS"
			Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
			Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
			Return .F.
		Endif
	Else
		Dimension vd[6]
		Select mwkbase2
		Go top
		Scan all
			vd[01] = nvl(mwkbase2.IDTUSER,'')
			vd[02] = mwkbase2.LIDCARGO
			vd[03] = mwkbase2.IDMEDICO
			vd[04] = mwkbase2.LESPE2
			vd[05] = nvl(mwkbase2.IDUSUARIO,'')
			vd[06] = nvl(mwkbase2.password,'')
			mret = sqlexec(MsqlCon,"update tblgpuser set estado = ' '"+;
				" where "+;
				" iduser = ?vd[01] and idcarg = ?vd[02] and idprof = ?vd[03] and "+;
				" idespe = ?vd[04] and idusuario = ?vd[05] and password = ?vd[06]")
			If mret < 0
				=sqldisconnect(MsqlCon)
				MTABLA = "TABLA WEB USUARIOS INICIALIZA ESTADOS"
				Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
				Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
				Return .F.
			Endif
		Endscan
		Release vd
	Endif

	Dimension vd[11]
	Select mwkbase2
	Go top
	Scan all

		vd[01] = mwkbase2.IDMEDICO
		vd[02] = mwkbase2.LNOMBRE
		vd[03] = mwkbase2.LCARGO
		vd[04] = mwkbase2.LESPE2

		mmails = CHRTRAN(mwkbase2.EMAIL, '*', ';')

		vd[05] = CHRTRAN(mmails, '/', ';')

		vd[06] = mwkbase2.TELCELULAR
		vd[07] = mwkbase2.TELEFONO
		vd[08] = nvl(mwkbase2.IDUSUARIO,'')
		vd[09] = nvl(mwkbase2.password,'')
		vd[10] = mwkbase2.LIDCARGO
		vd[11] = nvl(mwkbase2.IDTUSER,'')

		If mwkbase2.IDUSUARIO = 'MOVIEDO' or;
		   mwkbase2.IDUSUARIO = 'HELASCANO' or;
		   mwkbase2.IDUSUARIO = 'SMROJAS'  && Enfermeria caso especial desginación de Jefes
		   
			vd[10] = 20
		
		Endif

		Use in select("mwkctrl")

		mret = sqlexec(MsqlCon,"select id as lid from tblgpuser"+;
			" where iduser = ?vd[11]"+;
			" and idcarg = ?vd[10]"+;
			" and idprof = ?vd[01]","mwkctrl")

		If mret < 0
			=sqldisconnect(MsqlCon)
			MTABLA = "TABLA WEB USUARIOS CONSULTAS"
			Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
			Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
			Return .F.
		Endif

		If used("mwkctrl")

*!*         Profesionales / Usuarios
			If reccount("mwkctrl") > 0
				mbus = mwkctrl.lid

				If vd[04] = 'ENFE' && Excluyo actualizar tel, cel

					mret = sqlexec(MsqlCon,"update tblgpuser set "+;
						"apenom    = ?vd[02],"+;
						"idespe    = ?vd[04],"+;
						"email     = ?vd[05],"+;
						"estado    = 'A'    ,"+;
						"idusuario = ?vd[08],"+;
						"password  = ?vd[09],"+;
						"idcarg    = ?vd[10]"+;
						" where id = ?mbus")

				Else

					mret = sqlexec(MsqlCon,"update tblgpuser set "+;
						"apenom    = ?vd[02],"+;
						"idespe    = ?vd[04],"+;
						"tel1      = ?vd[07],"+;
						"cel1      = ?vd[06],"+;
						"email     = ?vd[05],"+;
						"estado    = 'A'    ,"+;
						"idusuario = ?vd[08],"+;
						"password  = ?vd[09],"+;
						"idcarg    = ?vd[10]"+;
						" where id = ?mbus")

				Endif

				If mret < 0
					=sqldisconnect(MsqlCon)
					MTABLA = "TABLA WEB USUARIOS ACTUALIZA DATOS"
					Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
					Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
					Return .F.
				Endif

			Else
				mret = sqlexec(MsqlCon,"insert into tblgpuser"+;
					" (iduser,idcarg,idprof,apenom,idespe,tel1,cel1,email,estado,idusuario,password) "+;
					" values "+;
					" (?vd[11],?vd[10],?vd[01],?vd[02],?vd[04],?vd[07],?vd[06],?vd[05],'A',?vd[08],?vd[09])")

				If mret < 0
					=sqldisconnect(MsqlCon)
					MTABLA = "TABLA WEB USUARIOS REGISTRO"
					Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
					Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
					Return .F.
				Endif
			Endif

			If !empty(vd[04])
*!*             Especialidades
				Use in select("mwkctrl")
				mret = sqlexec(MsqlCon,"select * from tblgpespe where codigo = ?vd[04]","mwkctrl")

				If mret < 0
					=sqldisconnect(MsqlCon)
					MTABLA = "TABLA WEB ESPECIALIDADES CONSULTA"
					Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
					Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
					Return .F.
				Endif

				If used("mwkctrl")
					If reccount("mwkctrl") = 0
						Use in select("mwkctrl")
						mret = sqlexec(mcon1,"select ESP_descripcion"+;
							" from ESPECIALID"+;
							" where ESP_codesp = ?vd[04]","mwkctrl")

						If mret < 0
							=sqldisconnect(MsqlCon)
							MTABLA = "TABLA WEB ESPECIALIDADES CONSULTA DESC."
							Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
							Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
							Return .F.
						Endif

						mdetesp = ""
						If used("mwkctrl")
							If reccount("mwkctrl") > 0
								mdetesp = alltrim(mwkctrl.ESP_descripcion)
							Endif
						Endif
						mret = sqlexec(MsqlCon,"insert into tblgpespe (codigo,detalle) values (?vd[04],?mdetesp)")

						If mret < 0
							=sqldisconnect(MsqlCon)
							MTABLA = "TABLA WEB ESPECIALIDADES REGISTRO"
							Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
							Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
							Return .F.
						Endif

					Endif
				Endif
			Endif

			If !empty(vd[03])
*!*             Cargos
				Use in select("mwkctrl")
				mret = sqlexec(MsqlCon,"select * from tblgpcargo where codigo = ?vd[10]","mwkctrl")

				If mret < 0
					=sqldisconnect(MsqlCon)
					MTABLA = "TABLA WEB CARGOS CONSULTA"
					Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
					Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
					Return .F.
				Endif

				If used("mwkctrl")
					If reccount("mwkctrl") = 0
						mret = sqlexec(MsqlCon,"insert into tblgpcargo (codigo,detalle) values (?vd[10],?vd[03])")

						If mret < 0
							=sqldisconnect(MsqlCon)
							MTABLA = "TABLA WEB CARGO REGISTRO"
							Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
							Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
							Return .F.
						Endif

					Endif
				Endif
			Endif

		Endif
		Select mwkbase2
	Endscan

	Release vd

*!* Usuario de Consultas

	Use in select("mwkuserc")

	mret = sqlexec(MsqlCon,"SELECT * FROM tblgpuser"+;
		" WHERE iduser = 0 and idprof = 0 and idcarg = 0 and apenom = 'CONSULTAS'","mwkuserc")

	If mret < 0
		=sqldisconnect(MsqlCon)
		MTABLA = "TABLA WEB USUARIOS CONSULTA ADMINISTRATIVO"
		Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	If used("mwkuserc")

		If reccount("mwkuserc")>0

			mbus = mwkuserc.id
			mret = sqlexec(MsqlCon,"update tblgpuser set estado = 'A' where id = ?mbus")

			If mret < 0
				=sqldisconnect(MsqlCon)
				MTABLA = "TABLA WEB USUARIOS ACTUALIZA ADMINISTRATIVO"
				Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
				Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
				Return .F.
			Endif

		Else

			mret = sqlexec(MsqlCon,"insert into tblgpuser"+;
				" (iduser,idcarg,idprof,apenom,estado,idusuario,password) "+;
				" values "+;
				" (0,0,0,'CONSULTAS','A','CONSULTA','CONSULTA')")

			If mret > 0
*!*             Cargo 0: Administrativo
				Use in select("mwkctrl")
				mret = sqlexec(MsqlCon,"select * from tblgpcargo where codigo = 0","mwkctrl")

				If mret < 0
					=sqldisconnect(MsqlCon)
					MTABLA = "TABLA WEB CARGOS CONSULTA"
					Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
					Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
					Return .F.
				Endif

				If used("mwkctrl")
					If reccount("mwkctrl") = 0
						mret = sqlexec(MsqlCon,"insert into tblgpcargo (codigo,detalle) values (0,'ADMINISTRATIVO')")
						If mret < 0
							=sqldisconnect(MsqlCon)
							MTABLA = "TABLA WEB CARGOS REGISTRA ADMINISTRATIVO"
							Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
							Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
							Return .F.
						Endif
					Endif
				Endif
			Endif

		Endif

	Endif

	Use in select("mwkuserc")

	mret = sqlexec(MsqlCon,"update tblgpuser set idcarg = 20"+;
		" where idusuario = 'SMROJAS' and idespe = 'ENFE' and idcarg = -1 ")

	If mret < 0
		=sqldisconnect(MsqlCon)
		MTABLA = "TABLA WEB USUARIOS ACTUALIZA ENF (1)"
		Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	mret = sqlexec(MsqlCon,"update tblgpuser set idcarg = 20"+;
		" where idusuario = 'HELASCANO' and idespe = 'ENFE' and idcarg = -1 ")

	If mret < 0
		=sqldisconnect(MsqlCon)
		MTABLA = "TABLA WEB USUARIOS ACTUALIZA ENF (2)"
		Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	muser  = mwkusuario.IDUSUARIO
	mfhoy  = dtoc(sp_busco_fecha_serv('DD'))
	mfhoyT = ttoc(sp_busco_fecha_serv('DT'))

	mret = sqlexec(MsqlCon,"insert into tblgpfechas (fecha,fecmov,iduser) values (?mfhoy,?mfhoyT,?muser)")
	If mret < 0
		=sqldisconnect(MsqlCon)
		MTABLA = "TABLA WEB REGISTRO DE FECHA"
		Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	=sqldisconnect(MsqlCon)

Else

	MTABLA = "NO SE LOGRO CONEXION A MYSQL"
	Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.

Endif

Return .T.








