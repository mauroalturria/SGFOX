**********************************************************************
* Program....: _sp_FRMPlan30.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 23 September 2019, 11:10:27
* Notice.....: Copyright © 2019, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: mpistiner, Created 23 September 2019 / 11:10:27
* Purpose....: Compara tablas presadores contra ZABSF
**********************************************************************
*

*//////////////////////////////////////////////////////////////////////////////////////////////////// Tarea ( Enviada por correo - Rodrigo Vazquez)
*!*			Eduardo:

*!*			Por ahora, dejá en blanco todos esos campos, excepto:
*!*			Condición ante el IVA    --> poner el código de Monotributista (por ahora) Nota: El codigo es 1 ( Uno )
*!*			Fecha de alta     -> SF_FecHorAdd
*!*			Fecha de Baja    -> 1900-01-01

*!*			Qué registros de ZabSF incluir en Prestadores:

*!*			SF_Direccion  =     '10001003-Dirección Médica'  or  '20000001-Coord. de Docencia e Investigación'
*!*			y además que el campo SF_AgrupFun sea uno de los de la planilla adjunta que NO ESTÉN pintados en ROJO.

*!*			En TabUsuario deben estar TODOS los registros activos de ZabSF.

*//////////////////////////////////////////////////////////////////////////////////////////////////// Fin Tarea


cComPretadores = Newobject("_ComparaPrestadores","c:\desaguemes\prg\sp_frmplan30.prg")
* cComPretadores.Arma_Control()
cComPretadores.ControlPrestadores()

*-- Compara Prestadores con Success Factors y genera un TXT para Lista
Define Class _ComparaPrestadores As Custom

   nConexionSQL = 0								&& Contiene el calor de conexion para las conuslta si se opto por conexion local
   lDisconnect = .F.
   loFormularioLlamante = '' 					&& Contiene el Formulario que llamo al procedimiento (Objeto)
   llok = .T.
   llArmoListado = .T. 							&& Contiene si se lista mediante TXT ( Generacion de archivo para listar)

   ***************************************************************************************************
   *  Procedure : Init
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Iniciio de Procedimiento
   ***************************************************************************************************
   *
   Procedure Init()
   
   SET STEP ON 

      *-- Verificacion de rigos si esta conextado
      If !Used("mwkserver1")
         Do sp_conexion
         This.lDisconnect = .T.
      Endif

      *-- Guardo la conexion en una propiedad de la clase
      This.nConexionSQL = mCon1

      *-- Arma cursor de control para la incorporacion de datos
      If This.Arma_Control()
         * Browse Nowait							&& Sacar Browse en produccion
      Else
         *-- Error
         =Messagebox('Problemas al armar datos de control para ZabSF ', 48, 'Aviso al Usuario ')
         *-- Fallo la consulta al motor
         This.llok = .F.

      Endif

   Endproc

   ***************************************************************************************************
   *  Procedure : Unload
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Descargando la clase y cerrando
   ***************************************************************************************************
   *
   Procedure Unload()

      If This.lDisconnect = .T.
         Do sp_Desconexion() 										&& WITH thisform.name
      Endif

   Endproc


   ***************************************************************************************************
   *  Procedure : ControlPrestadores
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Control de los prestadores contra ZABSF
   ***************************************************************************************************
   *
   Procedure ControlPrestadores()

      *-- Generamos el cursor de ZABSF
      TEXT TO cmdSQL_Zabsf TEXTMERGE NOSHOW PRETEXT 7
		SElECT Zabsf.SF_Apellido, Zabsf.SF_Nombre, Zabsf.SF_CUIL, Zabsf.SF_Dni,
   		  Zabsf.ID, Zabsf.SF_Legajo,
   		  Zabsf.SF_CodEstado, Zabsf.SF_Estado, Zabsf.SF_NroMatricula, Zabsf.SF_TipoMatricula,
		  Zabsf.SF_Direccion,
		  Zabsf.SF_AgrupFun,  Zabsf.SF_AreaServ,
		  Zabsf.SF_CodigoTurno,
		  Zabsf.SF_DetaFterm,   Zabsf.SF_Empresa,
		  Zabsf.SF_FecEmisionMat, Zabsf.SF_FecEntrada,
		  Zabsf.SF_FecHorAdd, Zabsf.FecHorDbUpd, Zabsf.SF_FecTermEmpl,
		  Zabsf.SF_FecVtoMat, Zabsf.SF_Funcion,  Zabsf.SF_MailEmpr,
		  Zabsf.SF_MailPerson, Zabsf.SF_MailPrinc,
		  Zabsf.SF_Sector, Zabsf.SF_SupDirect
		 FROM ZabSF
		 WHERE Zabsf.SF_CUIL <> ''
		 ORDER BY Zabsf.SF_CUIL
      ENDTEXT

      *-- Filtro antes  AND Zabsf.SF_Dni <> '' AND Zabsf.SF_NroMatricula <> ''


      *-- Ejecutamos la consulta al motor
      If SQLExec( This.nConexionSQL , cmdSQL_Zabsf, 'mkwZabsf') = 1
         * Got all US Customers
         * Browse Title "Cursor curZabsf " Nowait
      Else
         =Messagebox('Problemas al procesar la consulta ZabSF ', 48, 'Aviso al Usuario - SQL Connect Message')
         *-- Fallo la consulta al motor
         This.llok = .F.

      Endif

      *-- Generamso el cursor de prestadores
      TEXT TO cmdSQL_Presta TEXTMERGE NOSHOW PRETEXT 7
		SELECT Prestadores.ape , Prestadores.nombre, Prestadores.cuil,
		  Prestadores.ID , Prestadores.NroLegajo, Prestadores.estado,
		  Prestadores.NroProveedor,
		  Prestadores.matriculas, Prestadores.fecVtoMatricula,
		  Prestadores.sexo,Prestadores.fecnac,
    	  Prestadores.codpostal,Prestadores.codpcia,Prestadores.codloca,
		  Prestadores.telradio, Prestadores.email,
		  Prestadores.telefono,Prestadores.telcelular,
		  Prestadores.codesp,
		  Prestadores.fecVtoAnssal, Prestadores.fecVtoSeg,
		  Prestadores.codprof, Prestadores.coduniv,
		  Prestadores.codiva, Prestadores.fecpasivag,
		  Prestadores.fecpasivai, Prestadores.fecpasiva, Prestadores.fecalta,
		  Prestadores.fecaltag, Prestadores.fecaltai,
		  Prestadores.bloquedesde,Prestadores.bloquehasta,
		  Prestadores.dambula, Prestadores.dinterna,
		  Prestadores.dguardia, Prestadores.bloqueo,
		  Prestadores.codespe,
		  Prestadores.lanssal, Prestadores.lcertdef, Prestadores.ldocum,
		  Prestadores.lhepat, Prestadores.lseguro, Prestadores.matProv,
		  Prestadores.lregIncomp,
    	  Prestadores.fecaltap, Prestadores.fecpasivap,
		  Prestadores.enreldep, Prestadores.web,
		  Prestadores.fechamod, Prestadores.idseguro, Prestadores.nom
		 FROM Prestadores
		 Where Prestadores.Cuil <> '' AND Prestadores.Matriculas <> ''
		 ORDER BY Prestadores.Cuil
      ENDTEXT

      *-- Ejecutamos la consulta al motor
      If SQLExec( This.nConexionSQL , cmdSQL_Presta, 'mkwPrestadores') = 1
         * Indixamos la tabla para busqueda y control
         Index On Alltrim( Cuil ) Tag IDXPresta
         * Browse Title "Cursor Prestadores " Nowait
         Select * From mkwPrestadores Where mkwPrestadores.Id = 99999999 Into Cursor mkwPrestadoresII Readwrite
      Else
         =Messagebox('Problemas al procesar la consulta Prestadores ', 48, 'Aviso al Usuario - SQL Connect Message')
         *-- Fallo la consulta al motor
         This.llok = .F.
      Endif
      */////////////////////////////// Fin Cursor Prestadores

      *////////////////////////////// Cursor de Usuarios
      TEXT TO cmdSQL_TabUsuarios TEXTMERGE NOSHOW PRETEXT 7
			SELECT Tabusuario.ID, Tabusuario.IDCodMed, Tabusuario.Leg_ID,
			  Tabusuario.codigovax, Tabusuario.descrip, Tabusuario.diasaviso,
			  Tabusuario.directorio, Tabusuario.email, Tabusuario.fecexpira,
			  Tabusuario.fecingreso, Tabusuario.fecpasiva, Tabusuario.idusuario,
			  Tabusuario.nomape, Tabusuario.nrodocumento, Tabusuario.passcrip,
			  Tabusuario.password, Tabusuario.passwordldap, Tabusuario.tipodni,
			  Tabusuario.usuarioSAP
			 FROM TabUsuario
      ENDTEXT

      *-- Ejecutamos la consulta al motor
      If SQLExec( This.nConexionSQL , cmdSQL_TabUsuarios, 'mkwTabUsuarios') = 1
         * Indixamos la tabla para busqueda y control
         * Index On Alltrim( Cuil ) Tag IDXPresta
         * Browse Title "Cursor Prestadores " Nowait
      Else
         =Messagebox('Problemas al procesar la consulta TabUsuarios ', 48, 'Aviso al Usuario - SQL Connect Message')
         *-- Fallo la consulta al motor
         This.llok = .F.
      Endif

      *////////////////////////////// Fin curso de Usuarios

      * Browse Title 'Prestadores que no estan en ZABSF ' Nowait

      *-- Despues de generar los cursores de las tablas , comparamos y agregamos en Prestadores
      * Select mkwZabSF

      Select * From mkwZabSF ;
         Where ( Substr( mkwZabSF.SF_Direccion,1,8 ) = '10001003' Or ;
         SUBSTR( mkwZabSF.SF_Direccion,1,8 ) = '20000001' ) And ;
         SUBSTR( mkwZabSF.sf_agrupfun,1,8 ) In( Select ALLTRIM( mkwControl.cAgrupFun) From mkwControl ) And ;
         ALLTRIM( mkwZabsf.sf_cuil ) NOT IN ( Select ALLTRIM( mkwPrestadores.Cuil) FROM mkwPrestadores ) ;
         INTO Cursor mkwInsercion

      *-- Seleccionamos el set de datoa para ir insertndo en Prestadores
      Select mkwInsercion
      * Browse Title 'ZABSf que no estan en Prestadores ( Filtro ) ' && Nowait

      *-- Para todo el set de datos 
      Scan 				&& El filtro por cuil esta armado en la generacion de el cursor 

         m.lcApellido 	= Alltrim( mkwInsercion.SF_Apellido )
         m.lcNombre 	= Alltrim( mkwInsercion.SF_Nombre )
         m.lcCuil 		= Alltrim( mkwInsercion.SF_CUIL )
         m.lnNroLegajo 	= Int( Val( mkwInsercion.SF_Legajo ) )
         m.LnEstado 	= 1
         m.lnNroMatricula = mkwInsercion.SF_NroMatricula
         m.lnCodIva 	= 1
         m.ldFecHorAdd 	= Ttod( mkwInsercion.SF_FecHorAdd )
         m.LdFechaBaja 	= Ctod( '01/01/1900' )

         *//////////////////////////////////////////////// Insercion de datos en tabla Prestadores ()

         *-- Si esta el ID obtenido insertamos valores
         TEXT TO cmdSQL_InsPrestadores TEXTMERGE NOSHOW PRETEXT 7
	            Insert Into Prestadores ( Ape , nombre, Cuil, NroLegajo, Estado,
	               matriculas, codiva, fecalta, fecpasivap )
	               VALUES ( ?m.lcApellido, ?m.lcNombre, ?m.lcCuil ,
	               ?m.lnNroLegajo, ?m.LnEstado, ?m.lnNroMatricula, ?m.lnCodIva,
	               ?m.ldFecHorAdd, ?m.LdFechaBaja )
         ENDTEXT

         *-- Ejecutamos la consulta al motor
         If SQLExec( This.nConexionSQL , cmdSQL_InsPrestadores, 'mkwPretadores') = 1
            *-- Todo Ok
         Else
            =Messagebox('Problemas al procesar la consulta de Insercion de Prestadores ', 48, 'Aviso al Usuario - SQL Connect Message')
            *-- Fallo la consulta al motor
            This.llok = .F.
         Endif

         *////////////////////////////////////////////////

         *-- Forzamos el area de trabajo , que al boton por que el scan lo hace solo
         Select mkwInsercion

      Endscan

   Endproc


   ***************************************************************************************************
   *  Procedure : Arma_Control
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Arma un cursor de control apara la incorporacion de datos a ZabSF
   ***************************************************************************************************
   *
   Procedure Arma_Control()

      Create Cursor mkwControl ( cagrupfun C(10), cDescripcion	C(60), nCantidad N(10,0) )

      Insert Into mkwControl Values( '30000009', 'Bioquímicos',	17 )
      Insert Into mkwControl Values( '30000012', 'Coordinadores', 93 )
      Insert Into mkwControl Values( '30000013', 'Directores', 3 )
      Insert Into mkwControl Values( '30000018', 'Farmacéuticos', 5 )
      Insert Into mkwControl Values( '30000021', 'Jefes', 34 )
      Insert Into mkwControl Values( '30000022', 'Médico de Planta',	741 )
      Insert Into mkwControl Values( '30000026', 'Profesionales de Planta',	165 )
      Insert Into mkwControl Values( '30000030', 'Referentes Médicos', 2 )
      Insert Into mkwControl Values( '30000032', 'Subjefes',	4 )
      Insert Into mkwControl Values( '30000033', 'Supervisores',	5 )
      Insert Into mkwControl Values( '70000004', 'Jefe de Residentes', 30 )
      Insert Into mkwControl Values( '70000006', 'Residentes de 1ro', 86 )
      Insert Into mkwControl Values( '70000007', 'Residentes de 2do', 73 )
      Insert Into mkwControl Values( '70000008', 'Residentes de 3ro', 65 )
      Insert Into mkwControl Values( '70000009', 'Residentes de 4to', 84 )
      Insert Into mkwControl Values( '90000003', 'Residentes de 5to', 1 )

      *-- Indexo el campo de AgrupFun para controlar los valores a ingresar
      Index On Alltrim( cagrupfun ) Tag IDXcAgrFun

   Endproc



   *!*	   ***************************************************************************************************
   *!*	   *  Procedure : Armar_Listado
   *!*	   ***************************************************************************************************
   *!*	   *  Parameters  :
   *!*	   *  Description :   Arma un archivo TXT para un listado de control
   *!*	   ***************************************************************************************************
   *!*	   *
   *!*	   Procedure Armar_Listado()

   *!*	      *-- Leeo el cursor de SF para controla contra Prstadores
   *!*	      Select mkwZabSF 								&& Success Factors

   *!*	      *-- Armo un cursor con los campos de curZabsf como repositorio final de los datos comparados
   *!*	      Select mkwZabSF.SF_Apellido, mkwZabSF.SF_Nombre, mkwZabSF.SF_CUIL, mkwZabSF.Id, mkwZabSF.SF_Legajo, ;
   *!*	         mkwZabSF.SF_Estado, mkwZabSF.SF_NroMatricula, mkwZabSF.SF_FecEntrada, mkwZabSF.SF_Funcion, ;
   *!*	         Space(60) As cTabla ;
   *!*	         FROM  mkwZabSF ;
   *!*	         WHERE mkwZabSF.SF_CUIL = '' ;
   *!*	         into Cursor mkwFinalComp Readwrite

   *!*	      *-- Coloco el area de trabajo
   *!*	      Select mkwZabSF

   *!*	      Scan
   *!*	         * Guardo el cuil y busco en Prestadores
   *!*	         cCuitSF = Alltrim( mkwZabSF.SF_CUIL )

   *!*	         * WAIT DATE() WINDOW AT 20,20 TIMEOUT 10

   *!*	         Wait 'Control de Cuit '  + cCuitSF Window Nowait 		&&  Timeout 10

   *!*	         Select mkwPrestadores						&& Prestadores
   *!*	         Seek cCuitSF
   *!*	         *-- Si esta comparo campos para ver que diferencia encuantro
   *!*	         If Found()
   *!*	            * Wait 'Encontrado ' Window Nowait

   *!*	            *-- Chequeo el numero de legajo - Control Basico
   *!*	            If mkwPrestadores.NroLegajo <> Val( Alltrim( mkwZabSF.SF_Legajo ) )

   *!*	               Select mkwZabSF
   *!*	               *-- Insertamos un registro con el valor que difiere desde Prestadores
   *!*	               Insert Into mkwFinalComp ( SF_Apellido, SF_Nombre, SF_CUIL, Id, SF_Legajo, ;
   *!*	                  SF_Estado, SF_NroMatricula, SF_FecEntrada, SF_Funcion, cTabla ) ;
   *!*	                  values   ;
   *!*	                  ( mkwZabSF.SF_Apellido, mkwZabSF.SF_Nombre, mkwZabSF.SF_CUIL, Zabsf.Id, ;
   *!*	                  mkwZabSF.SF_Estado, mkwZabSF.SF_NroMatricula, mkwZabSF.SF_FecEntrada, mkwZabSF.SF_Funcion , 'Success Factors' )

   *!*	               Select mkwPrestadores
   *!*	               *-- Insertamos un registro con el valor que difiere desde Prestadores
   *!*	               Insert Into mkwFinalComp ( SF_Apellido, SF_Nombre, SF_CUIL, Id, SF_Legajo, ;
   *!*	                  SF_Estado, SF_NroMatricula, SF_FecEntrada, SF_Funcion, cTabla ) ;
   *!*	                  values   ;
   *!*	                  (   Prestadores.ape ,  Prestadores.nombre , Prestadores.Cuil , ;
   *!*	                  Prestadores.Id , Prestadores.NroLegajo,  Prestadores.Estado,  Prestadores.matriculas, ;
   *!*	                  Prestadores.fecalta ,'' ,     'Prestadores' )
   *!*	            Endif

   *!*	         Else

   *!*	            *-- No se encontro , analizando
   *!*	            Insert Into mkwFinalComp ( SF_Apellido, SF_Nombre, SF_CUIL, Id, SF_Legajo, ;
   *!*	               SF_Estado, SF_NroMatricula, SF_FecEntrada, SF_Funcion, cTabla  ) ;
   *!*	               VALUES ( mkwZabSF.SF_Apellido, mkwZabSF.SF_Nombre, mkwZabSF.SF_CUIL, Zabsf.Id, ;
   *!*	               mkwZabSF.SF_Estado, mkwZabSF.SF_NroMatricula, mkwZabSF.SF_FecEntrada, mkwZabSF.SF_Funcion , 'No en Prestadores' )

   *!*	         Endif

   *!*	      Endscan


   *!*	   Endproc




Enddefine
