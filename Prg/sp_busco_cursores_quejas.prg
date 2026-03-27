Lparameters tbobtengodatos
*!* ------------------------- BUSCAMOS DATOS EN TABLA TABESTADOS ----------------------------------
*!* ------------------------BUSCAMOS LOS RESPONSABLES DE UNA QUEJA--------------------------------------------------------
mret=SQLExec(mcon1,"select tabquejaresponsables.ID as id,TQR_Cargo as descrip,TABUSUARIO.email as mail,TABUSUARIO.nomape as nombre,TABUSUARIO.codigovax,TQR_ResAgrup "+;
	" from tabquejaresponsables "+;
	" left join TABUSUARIO on tqr_codigovax=codigovax " +;
	"where tqr_codigovax <> 0","mwkresponsables")
If mret<1
	*!*			=Aerror(eros)
	*!*			Messagebox(eros(3))
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	Return .F.
ENDIF

**Select * From mwkresponsables WHERE NVL(codigovax,0) > 0 GROUP BY TQR_resagrup Into Cursor mwkrespo Readwrite                     && Cursor de Responsable
**SELECT ID,Descrip,mail,nombre,codigovax,tqr_resagrup From mwkresponsables WHERE NVL(codigovax,0) > 0 AND id = TQR_ResAgrup Into Cursor mwkrespo Readwrite
SELECT ID,Descrip,mail,nombre,codigovax,tqr_resagrup From mwkresponsables WHERE id = TQR_ResAgrup Into Cursor mwkrespo Readwrite                     && Cursor de Responsable

If !tbobtengodatos
	mret = SQLExec(mcon1,"select * from tabestados where propietario = 15","mwkgeneral")
	If mret<1
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("ERROR DE LECTURA",48,"VALIDACION")
		Return .F.
	Endif
	*!* ------------------------- BUSCAMOS DATOS EN TABLA MOTIVOS ---------------------------------------
	*!*	mret=SQLExec(mcon1,"select IDmotivo,motivotext from MOTIVOS where MOTIVOS.IDmotivo>=31 AND MOTIVOS.IDmotivo<=55"+;
	*!*	" order by id asc","mwkmotiv")
	*!*	If mret<1
	*!*	    Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	*!*	    Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	*!*	    Return .F.
	*!*	Endif

	*!* ------------------------- BUSCAMOS DATOS EN TABLA TABAREADES --------------------------------------------------------
	mret = SQLExec(mcon1,"select * from tabareades where ID >= 1 AND id <= 3","mwksector")
	If mret<1
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("ERROR DE LECTURA",48,"VALIDACION")
		Return .F.
	Endif

	*!* ------------------------ GENERAMOS CURSORES DE ESCRITURA-LECTURA DE TABLA TABESTADOS ---------------------------------
	Select * From mwkgeneral Where tipo	= 5  Order By  Descrip Into Cursor mwkcateg Readwrite   && Cursor de categorías
	Select * From mwkgeneral Where tipo = 0  Into Cursor mwkdev Readwrite    	  			    && Cursor devolución
	Select * From mwkgeneral Where tipo = 1  Into Cursor mwkareas Readwrite                     && Cursor de Areas
	Select * From mwkgeneral Where tipo = 2  Into Cursor mwksubadmi Readwrite                   && Cursor de Subarea Administrativa
	Select * From mwkgeneral Where tipo = 3  Into Cursor mwksubmedica Readwrite                 && Cursor de SubArea Medica
	Select * From mwkgeneral Where tipo = 6  Into Cursor mwkestadoqueja Readwrite 		        && Cursor de Estado Queja
	Select * From mwkgeneral Where tipo = 7  Into Cursor mwkparentesco Readwrite 		        && Cursor de Parentesco
	Select * From mwkgeneral Where tipo = 10 Into Cursor mwkmotiv Readwrite                     && Cursor de Motivos
	Select * From mwkgeneral Where tipo = 12 Into Cursor mwkRiesgo1 Readwrite                   && Cursor de Riesgos
	
	INSERT INTO mwkRiesgo1 (descrip, estado, propietario, subestado, tipo) VALUES ( ;
	'                     ',0,15,1,12)
	
	SELECT * FROM mwkRiesgo1 ORDER BY estado INTO CURSOR mwkRiesgo READWRITE 
	
	USE IN SELECT("mwkRiesgo1")
	
	*!* ----------------------- GENERAMOS CURSORES DE ESCRITURA-LECTURA DE TABLA MOTIVOS -------------------------------------
	* ESTOS CURSORES CONTIENEN LOS MOTIVOS Y DECISIONES DE DIRECCION A LA FECHA 2013-02-26
	Select Descrip As motivotext,estado As IDmotivo, subestado From mwkmotiv ;
		Into Cursor mwkmotiv Readwrite

*!*		Select * From mwkmotiv Where IDmotivo<=48  Into Cursor MWKMOTIVO Readwrite                   &&Cursor de Motivo
*!*		Select * From mwkmotiv Where IDmotivo>=49 AND IDmotivo<=55 Into Cursor MWKDECISDIR Readwrite		        	&&Cursor de Decisión Dirección
** Marcelo Torres, 29/05/2019
    Select motivotext,IDmotivo From mwkmotiv Where subestado=1 Into Cursor MWKMOTIVO Readwrite                   &&Cursor de Motivo
    Select motivotext,IDmotivo From mwkmotiv Where subestado=2 Into Cursor MWKDECISDIR Readwrite		         &&Cursor de Decisión Dirección
	
	*!* ----------------------- GENERAMOS CURSORES DE ESCRITURA-LECTURA DE TABLA TABAREADES ------------------------------------
	Select * From mwksector Into Cursor mwksector Readwrite  						            &&Cursor de sectores
	*!* ---------------------- AGREGAMOS 1 REGISTRO EN BLANCO A CADA CURSOR ----------------------------------------------------
	* LA AGREGACION SIRVE PARA QUE SE PUEDA GUARDAR SIN TENER TODOS LOS DATOS COMPLETOS; LOS FALTANTES SE GUARDAN EN BLANCO QUE
	* ES ESTE REGISTRO QUE SE AGREGA AL CURSOR
	Append Blank In mwksubmedica
	Append Blank In mwkareas
	Append Blank In mwkestadoqueja
	Append Blank In mwksubadmi
	Append Blank In MWKDECISDIR
	Append Blank In MWKMOTIVO
	Append Blank In mwkdev
	*Append Blank In mwkrespo
	Append Blank In mwksector
	Append Blank In mwkparentesco
	Use In mwkgeneral
Endif
