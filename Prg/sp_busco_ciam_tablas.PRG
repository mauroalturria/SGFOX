****
** Tablas CIAM, Propietario = 33
****

Lparameters mltipo

If vartype(mltipo)<>'C'
	mltipo = 'GEN'
Endif

If mltipo = 'GEN'

*!* Sectores de Internacion
	If used("mwksectorint")
		Use in mwksectorint
	Endif
	mret = sqlexec(mcon1, "select sec_codsector, sec_descripsec, sec_habitsala"+;
		",SEC_secquirur,SEC_internacion from sectores " + ;
		"where sec_internacion = 1 order by sec_descripsec", "mwksectorint")
	If mret < 1
		Messagebox("EN CONSULTA DE SECTORES DE INT."+chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
		Return
	Endif

*!* ORIGEN
*!* mdestino = 1
	If used('mwkTabOrigen')
		Use in mwkTabOrigen
	Endif
	mret = sqlexec(mcon1,"select * from tabestados where propietario=33 and estado=9 and subestado in"+;
		" (select distinct(tcu_tipifica) from TabCiamUbica where TCU_tipop=1) order by descrip","mwkTabOrigen")
	If mret<1
		Messagebox("EN TABLA ESTADOS - TIPOS DE ORIGEN"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Endif

*!* TRASLADO
*!* mdestino = 2
	If used('mwkTabTraslado')
		Use in mwkTabTraslado
	Endif
*!*  Solapa gestión traslado TCU_tipot = 1
	mret = sqlexec(mcon1,"select * from tabestados where propietario=33 and estado=9 and subestado in"+;
		" (select distinct(tcu_tipifica) from TabCiamUbica where TCU_tipot=1) order by descrip","mwkTabTraslado")
	If mret<1
		Messagebox("EN TABLA ESTADOS - TRASLADOS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Endif

*!* ESTADOS
	mdestino = 3
	If used('mwkTabEstados')
		Use in mwkTabEstados
	Endif
	mret  =  sqlexec(mcon1,"select * from TabEstados where propietario = 33 and estado = ?mdestino", "mwkTabEstados")
	If mret<1
		Messagebox("EN TABLA ESTADOS GENERAL"+CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
	Endif

*!* COMPL. CAMA
	If used('mwkcategoria')
		Use in mwkcategoria
	Endif
	mret = sqlexec(mcon1, "select * from tabcategoria where id <100000 order by descrip", "mwkcategoria") && id as lid,
	If mret<1
		Messagebox("EN TABLA CATEGORIAS - COMPLEJIDAD DE CAMA"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Endif

*!* COMPL. MOVIL
	mdestino = 5
	If used('mwkTabComMov')
		Use in mwkTabComMov
	Endif
	mret  =  sqlexec(mcon1,"select * from TabEstados where propietario = 33 and estado = ?mdestino"+;
		" order by descrip", "mwkTabComMov")
	If mret<1
		Messagebox("EN TABLA ESTADOS - COMPLEJIDAD DE MOVIL"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Endif

*!* Tipo de dirección / Ubicación
*!* mdestino = 7
	If used('mwkTipDire')
		Use in mwkTipDire
	Endif
*!* Solapa Paciente TCU_tipou = 1
	mret = sqlexec(mcon1,"select * from tabestados where propietario=33 and estado=9 and subestado in"+;
		" (select distinct(tcu_tipifica) from TabCiamUbica where TCU_tipou=1) order by descrip","mwkTipDire")
	If mret<1
		Messagebox("EN TABLA ESTADOS - TIPOS DE DIRECCION"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Endif

*!* Tipos de denuncias
	mdestino = 8
	If used('mwkTabdenu')
		Use in mwkTabdenu
	Endif
	mret  =  sqlexec(mcon1,"select * from TabEstados where propietario = 33 and estado = ?mdestino"+;
		" order by descrip", "mwkTabdenu")
	If mret<1
		Messagebox("EN TABLA ESTADOS - TIPOS DE DENUNCIA"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Endif

*!* Gestion de Busquedas
	If used('mwkTabGesBus')
		Use in mwkTabGesBus
	Endif
	mret = sqlexec(mcon1,"select * from tabestados where propietario=33 and estado=9 and subestado in"+;
		" (select distinct(tcu_tipifica) from TabCiamUbica where TCU_tipob=1) order by descrip","mwkTabGesBus")
	If mret<1
		Messagebox("EN TABLA ESTADOS - GESTION DE BUSQUEDAS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Endif

	If used("mwkCiap2e")
		Use in mwkCiap2e
	Endif
	mret = sqlexec(mcon1, "select * from  TabCiap2E order by DescrAbrev ", "mwkCiap2e")

*!* Autorizacion
	If used("mwkautoriza")
		Use in mwkautoriza
	Endif
	mret = sqlexec(mcon1, "select * from tabautoriza where codsector = 16 order by descrip", "mwkautoriza")
	If mret < 1
		Messagebox("EN CONSULTA DE AUTORIZACIONES"+chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
		Return
	Endif


Endif

*!* TIPO INTERNACION / Sector
If used('mwksecint')
	Use in mwksecint
Endif
mret = sqlexec(mcon1, "select * from tabsectorint where id<100000  order by descrip", "mwksecint") && id as lid,
If mret<1
	Messagebox("EN TALBA TIPOS DE INTERNACION"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif

*!* Clinicas
If used("mwkClinica")
	Use in mwkClinica
Endif
mret = sqlexec(mcon1,"select id, id as lid,TCU_nombre as descrip,"+;
	"TCU_direccion,TCU_localdes,TCU_bristol,TCU_telef from Tabciamubica"+;
	" order by tcu_nombre","mwkClinica")

*!*		mret = sqlexec(mcon1,"select id, id as lid,TCU_nombre as descrip,"+;
*!*		"TCU_direccion,TCU_localdes from Tabciamubica"+;
*!*			" where TCU_idprovincia in (1,2)"+;
*!*			" and TCU_NOMBRE like '%CLINICA%'"+;
*!*			" order by tcu_nombre","mwkClinica")

If mret < 1
	Messagebox("EN CONSULTA DE CLINICAS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Return
Endif

*!* Tipo ó motivo

If used('mwktipo')
	Use in mwktipo
Endif
Create cursor mwktipo (lidmot n(3), lmotdes c(15))
Insert into mwktipo (lidmot, lmotdes) values (1,'URGENTE')
Insert into mwktipo (lidmot, lmotdes) values (2,'PROGRAMADO')
Insert into mwktipo (lidmot, lmotdes) values (3,'SIN ESPECIFICAR')

*!*	Insert into mwktipo (lidmot, lmotdes) values (9,'BAJA - PASIVADO')

*!* Endif

*!* Entidades
If used('mwkentidad1')
	Use in mwkentidad1
Endif
mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient from entidades " + ;
	"where ENT_fecpas is null and (ENT_capita is null or ENT_capita <> 'S') and " + ;
	"(ENT_turnoshabilit is null or ENT_turnoshabilit <> 'S') " + ;
	"order by ENT_descrient", "mwkentidad1")
If mret < 1
	Messagebox("EN CONSULTA DE ENTIDADES"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Return
Endif

*!* Documentos
If used('mwkdocu')
	Use in mwkdocu
Endif

mret = sqlexec(mcon1,"select abrevio, descrip, codigovax, id " + ;
	"from tabdocumentos order by id", "mwkdocu")
If mret < 1
	Messagebox("EN CONSULTA DE DOCUMENTOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Return
Endif


Return
