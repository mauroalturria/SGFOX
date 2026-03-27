**********************************************************************
* Program....: SP_BUSCO_PLANILLA_COVID19.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 16 April 2020, 12:31:35
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: mpistiner, Created 16 April 2020 / 12:31:35
* Purpose....:  Consulta de Pacientes con ficha de Coronavirus ( Covid19 ) para Fromulario FrmAdmision38_Edu
**********************************************************************
*
*
* Fichas de Epidemiología / Contactos ( Clonado de sp_busco_planilla_epide.prg  )
*
* tcTipo = 1 (Epidemiología) / tcBuscar = Protocolo
* tcTipo = 2 (Contactos)     / tcBuscar = id de TabFichEp
* tcTipo = 3 (Todas )    	 / tcBuscar = Desde / Hasta fecha
* tcTipo = 4 (Todas )    	 / tcBuscar = Nro de registracion
*
* tcTipe = "Covid19"
**********************************************************************
*
Lparameters tcFechaDesde, tcFechaHasta , tcTipo, tcTipe

If Vartype(mtipe)#"C"
   mtipe = "COVID19"
Endif

* lmFecBase = prg_Dtoc( sp_Busco_Fecha_Serv( "DD" ) - 30 )

Do Case
      *///////////////
   Case tcTipo = 1 							&& tcTipo = 1 (Epidemiología) / tcBuscar = protocolo

      *///////////////
   Case tcTipo = 2 							&& tcTipo = 2 (Contactos)     / tcBuscar = id de TabFichEp


      *///////////////
   Case tcTipo = 3  						&& tcTipo = 3 (Todas )    	/ tcBuscar = desde hasta fecha

      Private dFechaBusca, ldFechaDesde , ldFechaHasta

      * dFechaBusca = tcBuscar

      *-- Pasamos las fecha a variables locales para la consulta
      m.ldFechaDesde = tcFechaDesde
      m.ldFechaHasta = tcFechaHasta

      If Used('mwkCOVID19')
         Use In(Select('mwkCOVID19'))
      Endif

      */////////////////////////////////////////////////////////////////////////////////
      *!*	      lcCMDSQL = ''

      *!*	      *   TEXT to lcCMDSQL TEXTMERGE NOSHOW PRETEXT 7
      *!*	      lcCMDSQL ="SELECT Zabfichepncov19.COV_Registrac, Zabfichepncov19.FecHorDbAdd, Zabfichepncov19.ID, "+ ;
      *!*	         "Guardia.nroregistrac, Guardia.fechahoraing, Guardia.protocolo, Guardia.codent ,"+ ;
      *!*	         "Registracio.REG_nombrepac,Registracio.REG_nrohclinica, Registracio.REG_fecnacimiento, "+ ;
      *!*	         "Entidades.ENT_descrient,COV_inisintoma "+ ;
      *!*	         "FROM Zabfichepncov19 "+ ;
      *!*	         "left  JOIN Guardia      ON  Zabfichepncov19.COV_Registrac = Guardia.nroregistrac "+ ;
      *!*	         "inner JOIN Registracio  ON  Zabfichepncov19.COV_Registrac = Registracio.REG_nroregistrac "+ ;
      *!*	         "left  JOIN Entidades    ON  Guardia.codent  = Entidades.ENT_codent "+ ;
      *!*	         "left  JOIN tabambulatorio ON Zabfichepncov19.COV_Registrac = tabambulatorio.nroregistrac "+ ;
      *!*	         "GROUP BY Zabfichepncov19.Id "+ ;
      *!*	         "ORDER BY Zabfichepncov19.FecHorDbAdd "
      *!*	      *    ENDTEXT

      *!*	      *-- Sacar al compilar
      *!*	      * Strtofile( lcCMDSQL ,'ConsultaSQL.txt' )

      *!*	      *-- Ejecuto la consulta
      *!*	      nReturn = SQLExec( mcon1, lcCMDSQL , 'mwkGuardiaTemp'  )

      *!*	      Select mwkGuardiaTemp
      */////////////////////////////////////////////////////////////////////////////////

      *////////////////////////////////////////////////
      *		 Buscamos Guardia por Fecha

      lcCDM_SQL = ''
      TEXT TO lcCMD_SQL TEXTMERGE NOSHOW PRETEXT 7
	      Select Guardia.Id, Guardia.nroregistrac, Guardia.fechahoraing,
	      Guardia.protocolo, Guardia.codent
	      From Guardia
	      inner Join Zabfichepncov19 On Zabfichepncov19.COV_Registrac = Guardia.nroregistrac
	      Where  Zabfichepncov19.FecHorDbAdd >= ?m.ldFechaDesde And Zabfichepncov19.FecHorDbAdd <= ?m.ldFechaHasta
	      Order By Guardia.nroregistrac Desc
      ENDTEXT

      *-- Ejecuto la consulta al motor
      lnReturn = SQLExec( mcon1, lcCMD_SQL , 'mwkGuardia' )

      If lnReturn < 0
         =Aerror(lcArrayError)
         Messagebox("Fallo la Consulta de Tabla Guardia  "+Chr(13)+ Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
         Return .F.
      Else
         Select mwkGuardia
         * Browse
      Endif


      *////////////////////////////////////////////////
      *  Buescamos Ambulatorio por fecha
      lcCDM_SQL = ''

      TEXT TO lcCMD_SQL TEXTMERGE NOSHOW PRETEXT 7
		 	SELECT 	Tabambulatorio.ID, Tabambulatorio.nroregistrac, 
 		  			Tabambulatorio.fechahoraing, Tabambulatorio.protocolo, Tabambulatorio.codent
      		FROM Tabambulatorio
		    INNER JOIN Zabfichepncov19 ON Zabfichepncov19.COV_Registrac = Tabambulatorio.nroregistrac
 			Where  Zabfichepncov19.FecHorDbAdd >= ?m.ldFechaDesde And Zabfichepncov19.FecHorDbAdd <= ?m.ldFechaHasta
 		 	ORDER BY Tabambulatorio.fechahoraing, Tabambulatorio.nroregistrac DESC
      ENDTEXT

      *-- 	     		 WHERE Tabambulatorio.fechahoraate BETWEEN ?m.ldFechaDesde AND ?m.ldFechaHasta
      lnReturn = SQLExec( mcon1, lcCMD_SQL , 'mwkTabambulatorio' )

      *////////////////////////////////////////
      *		Hacemos el Union de Guardia y Ambulatorio
      *////////////////////////////////////////
      If lnReturn < 0
         * Messagebox("Fallo la Consulta de las Tabambulatorio "+Chr(10)+ "Aviso ",16," Mensaje al Usuario ")
         =Aerror(lcArrayError)
         Messagebox("Fallo la Consulta de las Tabambulatorio "+Chr(13)+ Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
         Return .F.
      Else

         *-- Union de los dos cursores
         Select * From mwkGuardia ;
            UNION ;
            SELECT * From mwkTabambulatorio ;
            INTO Cursor mwkGuardi_Ambula

         Select mwkGuardi_Ambula
         * Browse
      Endif

      *//////////////////////////////////////// Fin de Union

      *-- Tabla Entidades
      lcCMD_SQL = ''
      TEXT TO lcCMD_SQL TEXTMERGE NOSHOW PRETEXT 7
		SELECT * FROM Entidades ORDER BY Entidades.ENT_codent
      ENDTEXT

      lnReturn = SQLExec( mcon1, lcCMD_SQL , 'mwkEntidades' )

      If lnReturn < 0
         * Messagebox("Fallo la Consulta de las mwkEntidades "+Chr(10)+ "Aviso ",16," Mensaje al Usuario ")
         =Aerror(lcArrayError)
         Messagebox("Fallo la Consulta de las mwkEntidades "+Chr(13)+ Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
         Return .F.
      Else
         Select mwkEntidades
         * Browse
      Endif

      *-- Tabla Registracio
      lcCMD_SQL = ''
      TEXT TO lcCMD_SQL TEXTMERGE NOSHOW PRETEXT 7
			SELECT Registracio.REG_nroregistrac,
			  Registracio.REG_nombrepac, Registracio.REG_nrohclinica,
			  Registracio.REG_fecnacimiento
			 FROM Registracio
			    INNER JOIN Zabfichepncov19 Zabfichepncov19 ON  Zabfichepncov19.COV_Registrac = Registracio.REG_nroregistrac
			 WHERE  Zabfichepncov19.FecHorDbAdd >= ?m.ldFechaDesde AND Zabfichepncov19.FecHorDbAdd <= ?m.ldFechaHasta
      ENDTEXT

      lnReturn = SQLExec( mcon1, lcCMD_SQL , 'mwkRegistracio' )

      If lnReturn < 0
         * Messagebox("Fallo la Consulta de generación de mwkRegistracio "+Chr(10)+ "Aviso ",16," Mensaje al Usuario ")
         =Aerror(lcArrayError)
         Messagebox("Fallo la Consulta de generación de mwkRegistracio  "+Chr(13)+ Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
         Return .F.
      Else
         Select mwkRegistracio
         * Browse
      Endif

      *-- Fichas de COVID19
      TEXT TO lcCMD_SQL TEXTMERGE NOSHOW PRETEXT 7
		SELECT Zabfichepncov19.COV_Registrac, Zabfichepncov19.FecHorDbAdd, Zabfichepncov19.ID, COV_inisintoma
		 FROM Zabfichepncov19
         WHERE Zabfichepncov19.FecHorDbAdd >= ?m.ldFechaDesde AND Zabfichepncov19.FecHorDbAdd <= ?m.ldFechaHasta
         ORDER BY Zabfichepncov19.COV_Registrac DESC
      ENDTEXT

      *-- Ejecuto la consulta al motor
      lnReturn = SQLExec( mcon1, lcCMD_SQL , 'mwkZabfichepncov19' )

      If lnReturn < 0
         * Messagebox("Fallo la Consulta de las Zabfichepncov19 "+Chr(10)+ "Aviso ",16," Mensaje al Usuario ")
         =Aerror(lcArrayError)
         Messagebox("Fallo la Consulta de generación de mwkRegistracio  "+Chr(13)+ Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
         Return .F.
      Else
         Select mwkTabambulatorio
         * Browse
      Endif

      *-- Cursor Final para las consltas previas
      lcCMDSQL ="SELECT mwkZabfichepncov19.COV_Registrac, mwkZabfichepncov19.FecHorDbAdd, mwkZabfichepncov19.ID, "+ ;
         "mwkGuardi_Ambula.Nroregistrac, mwkGuardi_Ambula.fechahoraing, mwkGuardi_Ambula.protocolo, mwkGuardi_Ambula.codent ,"+ ;
         "mwkRegistracio.REG_nombrepac, mwkRegistracio.REG_nrohclinica, mwkRegistracio.REG_fecnacimiento, "+ ;
         "mwkEntidades.ENT_descrient, mwkZabfichepncov19.COV_inisintoma "+ ;
         "FROM mwkZabfichepncov19 "+ ;
         "INNER JOIN mwkGuardi_Ambula ON mwkGuardi_ambula.NroRegistrac = mwkZabfichepncov19.COV_Registrac "+ ;
         "INNER JOIN mwkRegistracio ON mwkRegistracio.REG_NroRegistrac =  mwkZabfichepncov19.COV_Registrac "+ ;
         "INNER JOIN mwkEntidades ON mwkEntidades.ENT_codent = mwkGuardi_ambula.codent "+ ;
         "GROUP BY mwkZabfichepncov19.Id "+ ;
         "ORDER BY mwkZabfichepncov19.FecHorDbAdd " + ;
         "INTO cursor mwkCOVID19"

      *-- Ejecutamos al consulta final
      &lcCMDSQL

      Select mwkCOVID19
      * Browse

      Do sp_Busco_Pac_Internados With '',''

      *-- Extracto de los datos que coinciden con fecha por Nro de Registracion
      Select mwkCOVID19.* , mwkPacInt.pac_codadmision, mwkPacInt.PAC_descripdiagn , ;
         mwkPacInt.PAC_habitacion , mwkPacInt.PAC_Cama , mwkPacInt.Pac_Codhci , mwkPacInt.Sec_DescripSec,  ;
         mwkPacInt.Pac_NombrePaciente ;
         From mwkCOVID19;
         Left Join mwkPacInt On  mwkCOVID19.COV_Registrac = mwkPacInt.lregistracion ;
         WHERE !Empty( mwkPacInt.Pac_Codhci ) ;
         into Cursor mwkEpidemioCOVID19

*-- antes era mwkPacInt.Pac_Codhci

      Select mwkEpidemioCOVID19
      * BROWSE


   Case tcTipo = 4  						&& tcTipo = 4 (Todas )    	/ tcBuscar = Nro de registracion


Endcase
