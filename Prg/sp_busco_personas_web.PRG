*
* Elaboración de Tabla Personas
*

*!*	Set DATE TO FRENCH
*!*	Set CENTURY ON
*!*	Set SYSMENU TO
*!*	Set EXCLUSIVE OFF
*!*	Set DECIMALS TO 2
*!*	Set MULTILOCKS ON
*!*	Set NOTIFY OFF
*!*	Set CPDIALOG OFF
*!*	Set SAFETY OFF

If used('mwkcoord')
	Use in mwkcoord
Endif

*!*	hConn = Sqlstringconnect("Driver=MySQL ODBC 3.51 Driver;Server=172.16.2.101;UID=malturria;PWD=mauro;Database=prueba")
*!*	=SQLSETPROP(hConn,"Transactions",2)
*!*	=SQLSETPROP(hConn,"Asynchronous",.F.)

* mret = sqlexec(hConn,"delete from personas")

mret = sqlexec(hConn,"select * from TabCoord order by TCO_especialidad","mwkcoord")
If mret > 0
	If used('mwkcoord')
		If reccount('mwkcoord') > 0
			Select mwkcoord
			Go top
			Scan
				If mwkcoord.TCO_registro <> 'REG0035' and mwkcoord.TCO_registro <> 'REG0036' and ;
						mwkcoord.TCO_registro <> 'REG0009' and mwkcoord.TCO_registro <> 'REG0027'

					mbusca = mwkcoord.TCO_idmed
					mespec = mwkcoord.TCO_especialidad

					mv1 = mwkcoord.TCO_actividad2
					mv2 = mwkcoord.TCO_formacion
					mv3 = mwkcoord.TCO_actlab
					mv4 = mwkcoord.TCO_organismos
					mv5 = mwkcoord.TCO_investiga
					mv6 = mwkcoord.TCO_cursos
					mv7 = mwkcoord.TCO_docente

					mret = sqlexec(hConn,"select * from prestadores where IDmedico=?mbusca","mwkpresta")
					If mret>0
						If used('mwkpresta')
							If reccount('mwkpresta')>0
								Select mwkpresta
								Go top
								mnomb = mwkpresta.nombre
								mmail = mwkpresta.email
								mret = sqlexec(hConn,"insert into personas (idmed,apenom,especialidad,numero,email,"+;
									"actividad,formacion,actlab,organismos,investiga,cursos,docente) "+;
									"values (?mbusca,?mnomb,?mespec,5,?mmail,?mv1,?mv2,?mv3,?mv4,?mv5,?mv6,?mv7)")
								If mret < 0
*!*										=aerror(merror)
*!*										Iif (merror(1) >0,messagebox(str(merror(1))+ ''+ merror(3),16,''),'')
									Messagebox("EN ALTA DE COORDINADOR",16,"ERROR")
									Exit
								Endif
							Endif
						Endif
					Else
						Messagebox("EN BUSQUEDA DE PRESTADOR",16,"ERROR")
						Exit
					Endif
				Endif
			Endscan
		Endif
	Endif
Else
	Messagebox("EN ACCESO A TABLA DE COORDINADORES",16,"ERROR")
	Return
Endif

If used('mwkcoord')
	Use in mwkcoord
Endif

mret = sqlexec(hConn,"select * from TabSubCoord order by TSO_especialidad","mwkcoord")
If mret > 0
	If used('mwkcoord')
		If reccount('mwkcoord') > 0
			Select mwkcoord
			Go top
			Scan
					mbusca = mwkcoord.TSO_idmed
					mespec = mwkcoord.TSO_especialidad

					mv1 = mwkcoord.TSO_actividad2
					mv2 = mwkcoord.TSO_formacion
					mv3 = mwkcoord.TSO_actlab
					mv4 = mwkcoord.TSO_organismos
					mv5 = mwkcoord.TSO_investiga
					mv6 = mwkcoord.TSO_cursos
					mv7 = mwkcoord.TSO_docente

					If used('mwkpresta')
						Use in mwkpresta
					Endif

					mret = sqlexec(hConn,"select * from prestadores where IDmedico=?mbusca","mwkpresta")
					If mret>0
						If used('mwkpresta')
							If reccount('mwkpresta')>0
								Select mwkpresta
								Go top
								mnomb = mwkpresta.nombre
								mmail = mwkpresta.email
								mret = sqlexec(hConn,"insert into personas (idmed,apenom,especialidad,numero,email,"+;
									"actividad,formacion,actlab,organismos,investiga,cursos,docente) "+;
									"values (?mbusca,?mnomb,?mespec,5,?mmail,?mv1,?mv2,?mv3,?mv4,?mv5,?mv6,?mv7)")
								If mret < 0
									Messagebox("EN ALTA DE SUBCOORDINADOR",16,"ERROR")
									Exit
								Endif
							Endif
						Endif
					Else
						Messagebox("EN BUSQUEDA DE PRESTADOR",16,"ERROR")
						Exit
					Endif
			Endscan
		Endif
	Endif
Else
	Messagebox("EN ACCESO A TABLA DE SUBCOORDINADORES",16,"ERROR")
	Return
Endif

If used('mwkcoord')
	Use in mwkcoord
Endif

*!* = SQLDisconnect(hConn)
*!* Messagebox("PROCESO CONTENIDOS, FINALIZADO",48,"Validación")

Return
