****
** Busco TabEstados para CIAM, Propietario = 33
****

* ORIGEN
mdestino = 1
If used('mwkTabOrigen')
	Use in mwkTabOrigen
Endif
mret  =  sqlexec(mcon1,"select * from TabEstados where propietario = 33 and estado = ?mdestino", "mwkTabOrigen")
If mret<1
	Messagebox("ERROR EN EL CURSOR DE ESTADOS"+chr(10)+"ORIGEN, AVISE A SISTEMAS",0,"Validacion")
Endif

* TRASLADO
mdestino = 2
If used('mwkTabTraslado')
	Use in mwkTabTraslado
Endif
mret  =  sqlexec(mcon1,"select * from TabEstados where propietario = 33 and estado = ?mdestino", "mwkTabTraslado")
If mret<1
	Messagebox("ERROR EN EL CURSOR DE ESTADOS"+chr(10)+"TRASLADO, AVISE A SISTEMAS",0,"Validacion")
Endif

* ESTADO
mdestino = 3
If used('mwkTabEstados')
	Use in mwkTabEstados
Endif
mret  =  sqlexec(mcon1,"select * from TabEstados where propietario = 33 and estado = ?mdestino", "mwkTabEstados")
If mret<1
	Messagebox("ERROR EN EL CURSOR DE ESTADOS GRAL., AVISE A SISTEMAS",0,"Validacion")
Endif

* COMPL. CAMA
*!*	mdestino = 4
*!*	If used('mwkTabComCam')
*!*		Use in mwkTabComCam
*!*	Endif
*!*	mret  =  sqlexec(mcon1,"select * from TabEstados where propietario = 33 and estado = ?mdestino", "mwkTabComCam")
*!*	If mret<1
*!*		Messagebox("ERROR EN EL CURSOR DE ESTADOS"+chr(10)+"COMPL. CAMA, AVISE A SISTEMAS",0,"Validacion")
*!*	Endif
If used('mwkcategoria')
	Use in mwkcategoria
Endif
mret = sqlexec(mcon1, "select * from tabcategoria where id <100000 order by descrip", "mwkcategoria") && id as lid,
If mret<1
	Messagebox("ERROR EN EL CURSOR DE ESTADOS"+chr(10)+"COMPL. CAMA, AVISE A SISTEMAS",0,"Validacion")
Endif

* COMPL. MOVIL
mdestino = 5
If used('mwkTabComMov')
	Use in mwkTabComMov
Endif
mret  =  sqlexec(mcon1,"select * from TabEstados where propietario = 33 and estado = ?mdestino", "mwkTabComMov")
If mret<1
	Messagebox("ERROR EN EL CURSOR DE ESTADOS"+chr(10)+"COMPL. MOVIL, AVISE A SISTEMAS",0,"Validacion")
Endif

* TIPO INTERNACION
*!*	mdestino = 6
*!*	If used('mwkTabInte')
*!*		Use in mwkTabInte
*!*	Endif
*!*	mret  =  sqlexec(mcon1,"select * from TabEstados where propietario = 33 and estado = ?mdestino", "mwkTabInte")
*!*	If mret<1
*!*		Messagebox("ERROR EN EL CURSOR DE ESTADOS"+chr(10)+"TIPO INTER., AVISE A SISTEMAS",0,"Validacion")
*!*	Endif
If used('mwksecint')
	Use in mwksecint
Endif
mret = sqlexec(mcon1, "select * from tabsectorint where id<100000  order by descrip", "mwksecint") && id as lid,
If mret<1
	Messagebox("ERROR EN EL CURSOR DE ESTADOS"+chr(10)+"TIPO INTER., AVISE A SISTEMAS",0,"Validacion")
Endif

*!*	select mwksecint
*!*	go top
*!*	brow

*!*	select mwkcategoria
*!*	go top
*!*	brow

Return
