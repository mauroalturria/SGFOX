**********************************************************************
* Program....: SP_ACTUALIZA_TABUSUARIOS_ZABSF.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 16 October 2019, 11:14:38
* Notice.....: Copyright © 2019, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 16 October 2019 / 11:14:38
* Purpose....: Actualiza TabUsuarios contra los datos de ZabSF (  Sussces Factor )
**********************************************************************
*
cComTabUsuarios = Newobject("_ComparaTabUsuarios","c:\desaguemes\prg\sp_actualiza_tabusuarios_zabsf.prg")
* cComTabUsuarios.Proc_Correctivo()

* cComTabUsuarios.ArmaSetDatos()
* cComTabUsuarios.ArmaCodigos()
* cComTabUsuarios.ControlTabUsuarios()



*-- Compara Prestadores con Success Factors y genera un TXT para Lista
Define Class _ComparaTabUsuarios As Custom

   oFormLauncher = '' 							&& Contiene el objeto formulario llamante
   nConexionSQL = 0								&& Contiene el calor de conexion para las conuslta si se opto por conexion local
   lDisconnect = .F.
   loFormularioLlamante = '' 					&& Contiene el Formulario que llamo al procedimiento (Objeto)
   llok = .T.
   llArmoListado = .T. 							&& Contiene si se lista mediante TXT ( Generacion de archivo para listar)
   dfechaServer = {}							&& Contiene la fecha del servidor
   nNewVaxCode = 0 								&& Contiene el nuevo codigo Vax obtenido del motor
   cNombreApellido = '' 						&& Contiene nombre y apellido para la invoccion de OA en cahce

   ***************************************************************************************************
   *  Procedure : Init
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Iniciio de Procedimiento
   ***************************************************************************************************
   *
   Procedure Init( toObjectLauncher )

      *-- Cargo el formulario en una propiedad
      This.oFormLauncher = toObjectLauncher

      *-- Verificacion de rigos si esta conextado
      If !Used("mwkserver1")
         Do sp_conexion
         This.lDisconnect = .T.
      Endif

      *-- Guardo la conexion en una propiedad de la clase
      This.nConexionSQL = mCon1

      This.dfechaServer = sp_busco_fecha_serv('DD')

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
   Procedure ArmaSetDatos()


      *-- Si la tabla esta en uso la cierro
      Use In(Select( 'mkwZabsf' ) )

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
		 WHERE Zabsf.SF_CUIL <> '' AND Zabsf.SF_DNI <> ''
		 ORDER BY Zabsf.SF_DNI
      ENDTEXT

      *-- Ejecutamos la consulta al motor
      If SQLExec( This.nConexionSQL , cmdSQL_Zabsf, 'mkwZabsf') = 1
         * Got all US Customers
         * Browse Title "Cursor curZabsf " Nowait
      Else
         =Messagebox('Problemas al procesar la consulta ZabSF ', 48, 'Aviso al Usuario - SQL Connect Message')
         *-- Fallo la consulta al motor
         This.llok = .F.

      Endif


      *-- Si la tabla es en uso la cierro
      Use In(Select( 'mkwTabUsuarios' ))

      *////////////////////////////// Cursor de Usuarios
      TEXT TO cmdSQL_TabUsuarios TEXTMERGE NOSHOW PRETEXT 7
				SELECT Tabusuario.ID, Tabusuario.IDCodMed, Tabusuario.Leg_ID,
				  Tabusuario.codigovax, Tabusuario.descrip, Tabusuario.diasaviso,
				  Tabusuario.directorio, Tabusuario.email, Tabusuario.fecexpira,
				  Tabusuario.fecingreso, Tabusuario.fecpasiva, Tabusuario.idusuario,
				  Tabusuario.nomape, Tabusuario.nrodocumento, Tabusuario.password,
				  Tabusuario.passwordldap, Tabusuario.tipodni, Tabusuario.usuarioSAP
				  FROM TabUsuario
			  where TabUsuario.NroDocumento <> 0
			 order by TabUsuario.NroDocumento
      ENDTEXT

      *-- Ejecutamos la consulta al motor
      If SQLExec( This.nConexionSQL , cmdSQL_TabUsuarios, 'mkwTabUsuarios') = 1
         * Indixamos la tabla para busqueda y control
         * Index On Alltrim( Cuil ) Tag IDXPresta
         * Browse Title "Cursor TabUsuarios " Nowait
      Else
         =Messagebox('Problemas al procesar la consulta TabUsuarios ', 48, 'Aviso al Usuario - SQL Connect Message')
         *-- Fallo la consulta al motor
         This.llok = .F.
      Endif

      *-- Armamso tabla de prestadores
      TEXT TO cmdSQL_Prestadores TEXTMERGE NOSHOW PRETEXT 7
	     SELECT Prestadores.ape, Prestadores.nombre, Prestadores.cuil,
			  Prestadores.ID, Prestadores.NroLegajo, Prestadores.Estado,
			  Prestadores.nroproveedor, Prestadores.matriculas
			 FROM  Prestadores
			  where Prestadores.Cuil <> ''
      ENDTEXT

      *-- Ejecutamos la consulta al motor
      If SQLExec( This.nConexionSQL , cmdSQL_Prestadores, 'mkwPrestadores') = 1
         * Indixamos la tabla para busqueda y control
         * Index On Alltrim( Cuil ) Tag IDXPresta
         * Browse Title "Cursor Prestadores " Nowait
      Else
         =Messagebox('Problemas al procesar la consulta Prestadores ', 48, 'Aviso al Usuario - SQL Connect Message')
         *-- Fallo la consulta al motor
         This.llok = .F.
      Endif


   Endproc

   ***************************************************************************************************
   *  Procedure : ArmaCodigos
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Arma unos cursores con lso codigos y la descripcion de la tabla ZABSF
   ***************************************************************************************************
   *
   Procedure ArmaCodigos()

      *-- Armamos varios cursores conteniendo el codigo y la descripcion separados - Se usa para busqueda y reemplazo en el cursor final
      Select Distinct Substr( sf_direccion,1,8 ) As cCodigoDireccion , Substr( sf_direccion,10 ) As cDescrip ;
         From mkwZabsf ;
         Into Cursor mwkDireccion
      *-- Indexo por codigo para la busqueda
      Index On cCodigoDireccion Tag cCodigo1

      Select Distinct Substr( sf_agrupfun,1,8) As cCodigoAgrup , Substr( sf_agrupfun,10 ) As cDescripo From mkwZabsf ;
         Into Cursor mwkAgrupacion
      *-- Indexo por codigo para la busqueda
      Index On cCodigoAgrup Tag cCodigo2

      Select Distinct Substr( sf_areaserv ,1,8 ) As cCodigoArea, Substr( sf_areaserv ,10 ) As cCodigo From mkwZabsf ;
         Into Cursor mwkArea
      *-- Indexo por codigo para la busqueda
      Index On cCodigoArea Tag cCodigo3

   Endproc


   ***************************************************************************************************
   *  Procedure : ControlTabUsuarios
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Hace control de datos a partir del set generado para despues isertarlo en el motor
   ***************************************************************************************************
   *
   Procedure ControlTabUsuarios()

      *-- Cerramos el cursor su ya esta formado para una nueva consulta
      Use In(Select( 'mkwCompara' ))

      *-- Sacar los registros de ZabSF que no esten contenidos en TAbUsuarios
      Select mkwZabsf.SF_Apellido, mkwZabsf.SF_Nombre, mkwZabsf.SF_CUIL, mkwZabsf.SF_Dni, ;
         mkwZabsf.Id, mkwZabsf.SF_Legajo, ;
         mkwZabsf.SF_CodEstado, mkwZabsf.SF_Estado, mkwZabsf.SF_NroMatricula, mkwZabsf.SF_TipoMatricula, ;
         mkwZabsf.sf_direccion, ;
         mkwZabsf.sf_agrupfun,  mkwZabsf.sf_areaserv, ;
         mkwZabsf.SF_CodigoTurno, ;
         mkwZabsf.SF_DetaFterm,   mkwZabsf.SF_Empresa, ;
         mkwZabsf.SF_FecEmisionMat, mkwZabsf.SF_FecEntrada, ;
         mkwZabsf.SF_FecHorAdd, mkwZabsf.FecHorDbUpd, mkwZabsf.SF_FecTermEmpl, ;
         mkwZabsf.SF_FecVtoMat, mkwZabsf.SF_Funcion,  mkwZabsf.SF_MailEmpr, ;
         mkwZabsf.SF_MailPerson, mkwZabsf.SF_MailPrinc, ;
         mkwZabsf.SF_Sector, mkwZabsf.SF_SupDirect ;
         FROM mkwZabsf ;
         where Val( mkwZabsf.SF_Dni )  Not In ( Select mkwTabUsuarios.nrodocumento  From mkwTabUsuarios ) ;
         INTO Cursor mkwCompara

      *-- Browse Title "Cursor Compara " Nowait
      Private lcNombreApellido , lnLegajo , lnNumeroDoc , lcDescTipo , lcEmail , ldFechaPasiva, ldDiasAviso , lcIdUsuario , lcPassword , ;
         m.ldFecExpira , m.ldFechaIngreso

      *-- Selecciono area de trabajo
      Select mkwCompara

      Scan 							&& For Inlist( Val(mkwCompara.SF_Legajo), 24028, 1516, 23958 )

         *!*	         Try

         *-- Cargamos los Valores para la Insercion
         m.lcNombreApellido = Upper( Alltrim( mkwCompara.SF_Apellido ) ) + ', ' + Upper( Alltrim( mkwCompara.SF_Nombre ) )   	&& Apellido y nombre
         This.cNombreApellido = Upper( Alltrim( mkwCompara.SF_Apellido ) ) + ', ' + Upper( Alltrim( mkwCompara.SF_Nombre ) )   	&& Para la invocacion de OA en Cache

         m.lnLegajo = Val( mkwCompara.SF_Legajo )

         m.lnNumeroDoc = Val( mkwCompara.SF_Dni)
         m.lnIDCodMed = This.ObtengoIDMedico( m.lnNumeroDoc )

         *-- Si es Enfermeria el codigo Vax es igual al Legajo
         If Upper( Alltrim( Substr( mkwCompara.SF_Funcion, 10 ) ) ) = 'ENFERMERIA DE PISO'
            m.lnCodigoVax = m.lnLegajo
         Else
            m.lnCodigoVax = This.ObtengoCodigoVax()
         Endif

         m.lcDescTipo = Upper( Alltrim( Substr( mkwCompara.SF_Funcion, 10 ) ) )																					&& Campo Descripcion - Eje: Medico Kinesiologo

         m.lcEmail  = Alltrim( mkwCompara.SF_MailEmpr )
         m.ldFechaPasiva = Ctod('01/01/1900')
         *
         m.ldDiasAviso = Ctod('01/01/2100')
         m.lcIdUsuario =  This.ArmarIdUsaurio( )				&& Generacion y control de Usuario

         m.lcPassword = 'SANATORIO' 							&& Antes '1234'
         *
         * m.ldFecExpira = sp_busco_fecha_serv('DD') + 2 			&& Ctod( '01/01/2100' ) <- antes - Ahora se calcula 5 dias
         m.ldFecExpira = This.dfechaServer + 2
         * m.ldFecIngreso = sp_busco_fecha_serv('DD')             && Date()
         m.ldFecIngreso = This.dfechaServer
         *//////////////////////////
         * Generar un txt en c:\temp con los usuarios que generas (alg˙n dato)  - Nombre del archivo Usufechahora.txt
         *//////////

         lcmdLinea = ' LineaUsuario = ' + m.lcNombreApellido + ','+ ;
            STR( m.lnLegajo ) + ', '+ ;
            STR( m.lnNumeroDoc ) + ', '+ ;
            m.lcDescTipo + ', '+ ;
            m.lcEmail + ', '+ ;
            DTOC( m.ldFechaPasiva ) + ', '+ ;
            DTOC( m.ldDiasAviso ) + ', '+ ;
            m.lcIdUsuario + ', '+ ;
            m.lcPassword + ', '+ ;
            STR( m.lnCodigoVax ) + ', '+ ;
            DTOC( m.ldFecExpira ) + ', '+ ;
            DTOC( m.ldFecIngreso )

         *-- Generamos el TXT con los datos a Insertar
         This.GeneraTXTControl( lcmdLinea )

         *////////////////////////// fin de Genera TXT
         *-- Armo la sentencia de insercion
         TEXT TO lcmdSQL_Usuario TEXTMERGE NOSHOW PRETEXT 7
					   Insert Into TabUsuario ( NomApe , Leg_ID ,NroDocumento , Descrip ,Email ,FecPasiva , DiasAviso,
					   IdUsuario, Password, CodigoVax, FecExpira, FecIngreso  )
					       Values( ?m.lcNombreApellido, ?m.lnLegajo , ?m.lnNumeroDoc, ?m.lcDescTipo , ?m.lcEmail,
					       ?m.ldFechaPasiva , ?m.ldDiasAviso , ?m.lcIdUsuario ,?m.lcPassword , ?m.lnCodigoVax, ?m.ldFecExpira , ?m.ldFecIngreso)

         ENDTEXT

         *-- Ejecutamos la consulta al motor
         If SQLExec( This.nConexionSQL , lcmdSQL_Usuario, 'mkwTemp1') = 1
            *!*	            mReturn = Sqlcommit( This.nConexionSQL )
            *!*	            If mReturn < 1
            *!*	               =Aerror( AErrorSQL )
            *!*	               Messagebox( AErrorSQL( 3 ) )
            *!*	            Endif

            *-- Impacto el Nuevo Codigo Vax Utilizado para que otro usuario lo pueda utilizar
            Do Sp_Grabo_New_Vax With This.nNewVaxCode + 1

            This.GeneraOA_en_Cache()									&& Genero OA con los datos de este usario que se grabo

         Else
            =Aerror( AErrorSQL )
            lcErrorSQL = AErrorSQL( 3 )
            * mret = Sqlrollback( This.nConexionSQL)

            =Messagebox('Problemas al insertar valores en TABUsuarios '+ lcErrorSQL, 48, 'Aviso al Usuario - SQL Connect Message')
            *-- Fallo la consulta al motor
            This.llok = .F.

         Endif

         *!*	         Catch To oError
         *!*	            *-- Muestra Mensaje a Pantalla
         *!*	            lcOK = 'Error en ejecucion de comando ' +Chr(13)+;
         *!*	               "Error #:"+Transform(oError.ErrorNo)+Chr(13)+;
         *!*	               "Line #:"+Transform(oError.Lineno)+Chr(13)+;
         *!*	               "Error #:"+Transform(oError.LineContents)

         *!*	         Endtry

      Endscan

   Endproc

   ***************************************************************************************************
   *  Procedure : ObtengoIDMedico
   ***************************************************************************************************
   *  Parameters  : tnNroDocumento -> Contiene el Numero de Docuemnto del Prestador buscado
   *  Description :   Obtengo el ID del prestados ( Medico / otros ) segun numero de documento pasado como parametro
   ***************************************************************************************************
   *
   Procedure ObtengoIDMedico( tnNroDocumento )

      Local lnIdEncontrado

      lnIdEncontrado = 0

      Select mkwPrestadores
      Locate

      If Not Empty( mkwPrestadores.cuil )
         *-- Hago un locate aunque es mejor indezar el cursor
         Locate For Val( Substr( Alltrim( mkwPrestadores.cuil ) ,4,8 ) ) = tnNroDocumento
         If Found()
            lnIdEncontrado = mkwPrestadores.Id
         Else
            lnIdEncontrado = 1												&& Valor por defecto si no se encuentra
         Endif
      Endif

      Return lnIdEncontrado

   Endproc

   ***************************************************************************************************
   *  Procedure : MakeIDUsuario
   ***************************************************************************************************
   *  Parameters  :
   *  Description :  Generacion y control de Usuario
   ***************************************************************************************************
   *				mkwZabsf.SF_Dni
   Procedure ArmarIdUsaurio( )

      Local lcNombreApellido, lcmdSQL_IDUsuario , lcnombre1 ,lcNombre2 ,lcNombre3 , lcApellido, llok

      *-- Cargo vacio por defecto para el IdUsuario
      m.lcNombreApellido = ''
      llok = .F. 					&& Contiene falso para el Id de usuario (repeticion)
      lnCaso = 1                   && Inicializo el Bucle de construccion del Id usuario

      *-- Contenplo hasta tres nombres de usuario . Es para el armado si se repite
      lcnombre1 = Alltrim( Substr( mkwCompara.SF_Nombre, 1                        , At(' ' ,  mkwCompara.SF_Nombre, 1 ) ) )
      lcNombre2 = Alltrim( Substr( mkwCompara.SF_Nombre, At(' ' ,  mkwCompara.SF_Nombre, 1 ) , At(' ' ,  mkwCompara.SF_Nombre, 2 ) ) )
      lcNombre3 = Alltrim( Substr( mkwCompara.SF_Nombre, At(' ' ,  mkwCompara.SF_Nombre, 2 ) , At(' ' ,  mkwCompara.SF_Nombre, 3 ) ) )

      lcApellido =  Upper( Substr( mkwCompara.SF_Apellido ,1, At(' ', mkwCompara.SF_Apellido ) ) )

      *///////////
      *   Por concenso segun Rodriguez Vazquez  se sacan los acentos en el identificador de Usuario
      Do While llok = .F.

         Do Case
            Case lnCaso = 1
               *-- Aplicamos la combinacion de Primera letra del Nobre (El primero ) y el Apellido
               m.lcNombreApellido = Chrtran( Substr( lcnombre1, 1,1 ) + Alltrim( lcApellido ) , "¿»Ã“Ÿ", "AEIOU" )
               lnCaso = 2

            Case lnCaso = 2

               If .Not. Empty(lcNombre2)
                  *-- Aplicamos la combinacion de Primera letra del Nobre (El primero ) y el Apellido
                  m.lcNombreApellido = Chrtran( Substr( lcnombre1, 1,1 ) + Substr( lcNombre2, 1,1 ) + Alltrim( lcApellido ) , "¿»Ã“Ÿ", "AEIOU" )
               Else
                  m.lcNombreApellido = Chrtran( Substr( lcnombre1, 1,1 ) +  Alltrim( lcApellido ) + '123' , "¿»Ã“Ÿ", "AEIOU" )
               Endif
               lnCaso = 3

            Case lnCaso = 3

               If .Not. Empty( lcNombre3 )
                  *-- Aplicamos la combinacion de Primera letra del Nobre (El primero ) y el Apellido
                  m.lcNombreApellido = Chrtran( Substr( lcnombre1, 1,1 ) + Substr( lcNombre2, 1,1 ) + Substr( lcNombre3, 1,1 ) + Alltrim( lcApellido ) , "¿»Ã“Ÿ", "AEIOU" )
               Else
                  m.lcNombreApellido = Chrtran( Substr( lcnombre1, 1,1 ) + Substr( lcNombre2, 1,1 ) +  Alltrim( lcApellido ) + '1234' , "¿»Ã“Ÿ", "AEIOU" )
               Endif
               lnCaso = 4

            Otherwise
               *-- Aplicamos la combinacion de Primera letra del Nobre (El primero ) y el Apellido
               m.lcNombreApellido = Chrtran( Substr( lcnombre1, 1,1 ) +  Alltrim( lcApellido ) + '12345' , "¿»Ã“Ÿ", "AEIOU" )
         Endcase

         *-- verifico que el nombre de usuario sea unico e irrepetible. Consulto directamente al motor ZabSF/TabUsuario
         *!*	         TEXT TO lcmdSQL_IDUsuario TEXTMERGE NOSHOW PRETEXT 7
         *!*				SELECT Zabsf.SF_Nombre, Zabsf.SF_Apellido, Tabusuario.idusuario
         *!*				 FROM Tabusuario
         *!*				    INNER JOIN zabsf Zabsf ON  Zabsf.SF_Dni = Tabusuario.nrodocumento
         *!*				 WHERE  LTRIM(RTRIM(Tabusuario.idusuario)) = ?m.lcNombreApellido
         *!*				 ORDER BY Tabusuario.idusuario
         *!*	         ENDTEXT

         TEXT TO lcmdSQL_IDUsuario TEXTMERGE NOSHOW PRETEXT 7
			SELECT Tabusuario.idusuario, Tabusuario.NomApe
			 FROM Tabusuario
			 WHERE LTRIM(RTRIM(Tabusuario.idusuario)) = ?m.lcNombreApellido
			 ORDER BY Tabusuario.idusuario
         ENDTEXT

         *-- Ejecutamos la consulta al motor
         If SQLExec( This.nConexionSQL , lcmdSQL_IDUsuario, 'mkwTemp1') = 1
            If Reccount('mkwTemp1') = 0
               llok = .T.
            Else
               *-- Armo de nuevo otro Id
               Loop
            Endif

         Endif

      Enddo

      *-- Devuelvo el Id de usuario generado
      Return m.lcNombreApellido

   Endproc


   ***************************************************************************************************
   *  Procedure : GeneraTXTControl
   ***************************************************************************************************
   *  Parameters  :
   *  Description :  Genera un txt de control con los dato a insertar
   ***************************************************************************************************
   *
   Procedure GeneraTXTControl( tcLineaUsuarioNuevo )

      *!*	      If File('C:\Temp\UsuFechaHora.txt')  && Does file exist?
      *!*	         gnErrFile = Fopen('C:\Temp\UsuFechaHora.txt',12)     && If so, open read/write
      *!*	      Else
      *!*	         gnErrFile = Fcreate('C:\Temp\UsuFechaHora.txt')  && If not create it
      *!*	      Endif
      *!*	      If gnErrFile < 0     			&& Check for error opening file
      *!*	         Wait 'No se puede abrir o crear C:\Temp\UsuFechaHora ' Window Nowait
      *!*	      Else  						&& If no error, write to file
      *!*	         =Fwrite(gnErrFile , tcLienaUsuarioNuevo  )
      *!*	      Endif

      *!*	      =Fclose(gnErrFile )     && Close file

      *!*	      If gnErrFile > 0
      *!*	         Modify File C:\Temp\UsuFechaHora.txt Nowait  && Open file in edit window
      *!*	      Endif

      Local lcSavePathLog As String

      *-- Retrono de carro para el archivo de usuarios incluidos
      This.AddProperty( 'CRLF' ,Chr(13)+Chr(10) )
      *   CRLF = Chr(13)+Chr(10)

      *-- Guardo el ath para grabar el archivo de usuarios insertados
      lcSavePathLog = 'C:\Temp\'										&& Fullpath(Curdir())
      lcNombreArchivo = Strtran( Dtoc( This.dfechaServer ) ,'/' , '_', 1 , 2 ) + ',txt'

      *-- Guardamos los datos sel usuario insertado en el archivo
      Strtofile(  ' - ' + tcLineaUsuarioNuevo + This.CRLF , lcSavePathLog + lcNombreArchivo , .T. )

   Endproc


   ***************************************************************************************************
   *  Procedure : GeneraTXTControl
   ***************************************************************************************************
   *  Parameters  :
   *  Description :  Genera un txt de control con los dato a insertar
   ***************************************************************************************************
   *
   Procedure ObtengoCodigoVax( )

      * mReturn = sqlexec(mcon1, "SELECT newvax FROM TabDatos ", "mwknewvax")
      If Used('mwknewvax')
         Use In( Select( 'mwknewvax' ))
      Endif
      *-- Busco en nuevo codigo vax para asignarselo al Usuario nuevo
      Do sp_busco_new_vax

      Select mwknewvax
      This.nNewVaxCode = mwknewvax.newvax

      *-- Retornamos el Codigo Vax obtenido
      Return This.nNewVaxCode

      ***************************************************************************************************
      *  Procedure : GeneraOA_en_Cache
      ***************************************************************************************************
      *  Parameters  :
      *  Description :  Rutina de Cahce para Generar OA*
      ***************************************************************************************************
      *
   Procedure GeneraOA_en_Cache()

      mgraba	= '1'
      mcCodigoVax  = Alltrim(Str( This.nNewVaxCode ,5,0 ) )							&& Alltrim(Str( .txtcodvax.Value,5,0 ) )
      mNombre = This.cNombreApellido  							&& Alltrim( .txtnombre.Value )
      Dat =  '"' +   mcCodigoVax + Chr(9) + mNombre + Chr(9) +  '"'

      With This.oFormLauncher
         .olevism.mserver	= Alltrim(mwktabcfg.OLEServer)
         .olevism.namespace	= Alltrim(mwktabcfg.olespaces)
         .olevism.Code = "D ALTAUSER^SPZ031(" + mgraba + ',' + Dat + ')'
         .olevism.execflag = 1

         mmsgerr = .olevism.errorname
         If !Empty( mmsgerr )
            midusua     = "YO"
            Do sp_insert_tabCtrlErr With .olevism.Code, mmsgerr , midusua, .Name
            Messagebox ("ERROR en ALTAUSER^SPZ031:"+Alltrim(mmsgerr), 48, 'Validacion')
         Endif

         mok	 = .olevism.P0					&& Codigo de error
         mresp1  = .olevism.P1
         mresp2  = .olevism.P2

         If .olevism.P0 <> ''
            mcoderr = Round( Val( .olevism.P0 ), 0 )
            Do sp_busco_texto_error With mcoderr
            Messagebox("ERROR en ALTAUSER^SPZ031:"+ Chr(13) + mok + Alltrim(mwktaberror.textoerror), 48, "Validacion")
         Else
            *** todo bien
         Endif

      Endwith

   Endproc

   ***************************************************************************************************
   *  Procedure : ProCorrectivo
   ***************************************************************************************************
   *  Parameters  :
   *  Description :  Corrige o eleimina datos de pueba (evita ensuciar la base de datos ) - Invocar solamente este metodo
   ***************************************************************************************************
   *
   Procedure Proc_Correctivo()

      Local FechaIngreso

      * Fecha de ingreso para controlar la carga de datos
      m.FechaIngreso = Ctod('20/01/2020' ) 										&& Date() && - 1

      *-- Ejecuto la eliminacion de datos de prueba
      mReturn = SQLExec(This.nConexionSQL, "Delete from TabUsuario where fecIngreso = ?m.FechaIngreso ")
      *       mReturn = SQLExec(This.nConexionSQL, "Update TabUsuario set IdUsuario = UPPER( idUsuario )")

      *-- Control de Error
      If mReturn < 1
         =Aerror( AErrorSQL )
         lcErrorSQL = AErrorSQL( 3 )
         mret = Sqlrollback( This.nConexionSQL)
         If mReturn = 1
            Messagebox( lcErrorSQL )
            Messagebox( "Hubo este error se volvio atras todo!!!" , 0+64, 'Aviso al Usuario ' )
         Else
            =Aerror(AErrorSQL)
            Wait Windows lcErrorSQL Nowait
            Messagebox("Hubo este error, se trato de revertir todo pero...al tratar de volver atras todo..." )
            Messagebox( AErrorSQL(3) )
         Endif
      Else
         mReturn = Sqlcommit( This.nConexionSQL )
         If mReturn < 1
            =Aerror( AErrorSQL )
            Messagebox( AErrorSQL( 3 ) )
         Else
            Messagebox("Proceso Terminado con Exito ",0+64, 'Acviso al Usuario' )
         Endif
      Endif

      = SQLSetprop(This.nConexionSQL, 'Transactions', 1)  && Manual

   Endproc



Enddefine

