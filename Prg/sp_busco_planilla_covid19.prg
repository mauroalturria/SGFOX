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

If Vartype(tcTipe)#"C"
   mTipe = "COVID19"
Endif

* lmFecBase = prg_Dtoc( sp_Busco_Fecha_Serv( "DD" ) - 30 )

Do Case
      *///////////////
   Case tcTipo = 1 							&& tcTipo = 1 (Epidemiología) / tcBuscar = protocolo

      *///////////////
   Case tcTipo = 2 							&& tcTipo = 2 (Contactos)     / tcBuscar = id de TabFichEp


      *///////////////
   Case tcTipo = 3  						&& tcTipo = 3 (Todas )    	/ tcBuscar = desde hasta fecha

      Wait Windows 'Ejecutando la búsqueda según datos ingresados' NOWAIT TIMEOUT 10 

      Private dFechaBusca, ldFechaDesde , ldFechaHasta
      Local ldFecha

      * ldFecha = sp_busco_fecha_serv("DD")								&& Cargo fecha servidor

      *///////////////////////////////////////////////////////////////////////////////////////
      *-- Guardo el Inicio de la atividad al ejecutar - General
      *Strtofile( Replicate('/',100) +Chr(13)+Chr(10),"ConsultaCOVID19.LOG",1)
      * Strtofile( Dtoc( This.dfechaServer )+" "+Time()+" - Inicio Reloj " + Chr(13) + Chr(10),"ConsultaCOVID19.LOG",1)

      *-- Pasamos las fecha a variables locales para la consulta
      *!*	            m.ldFechaDesde = tcFechaDesde
      *!*	            m.ldFechaHasta = tcFechaHasta

      *-- Cambio el formato de fecha a '2021-04-01'
      m.ldFechaDesde = Alltrim( Str( Year( tcFechaDesde ))) +'-'+ ;
         PADL( Alltrim( Str( Month(tcFechaDesde))), 2, '0' ) +'-'+ ;
         PADL( Alltrim( Str( Day(tcFechaDesde))), 2, '0' )
         
      m.ldFechaHasta = Alltrim( Str( Year( tcFechaHasta ))) +'-'+ ;
         PADL( Alltrim( Str( Month(tcFechaHasta))),2, '0' ) +'-'+ ;
         PADL( Alltrim( Str( Day(tcFechaHasta)))  ,2, '0' )


      If Used('mwkCOVID19')
         Use In(Select('mwkCOVID19'))
      Endif

      *-- pase la busqueda de paciente como primera medida - Verifico si ya existe el cursor
      If Used('mwkpacint1')
         Use In(Select('mwkpacint1'))
      Endif

      *-- Antes estaba al final para terminar el resultado
      If !Used("mwkpacint")
	      Do sp_Busco_Pac_Internados With '',''
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

      *////////////////////////////////////////
      *		Hacemos el Union de Guardia y Ambulatorio
      *////////////////////////////////////////
      * Strtofile( Dtoc( This.dfechaServer )+" "+Time()+" - Consulta de Guardia/Tabambulatorio (Union) - Inicio " + Chr(13) + Chr(10),"ConsultaCOVID19.LOG",1)
      lcCMD_SQL = ''
      TEXT TO lcCMD_SQL TEXTMERGE NOSHOW PRETEXT 7
	                   SELECT DISTINCT Guardia.Id, Guardia.nroregistrac, Guardia.fechahoraing,
					      Guardia.protocolo, Guardia.codent
					      From Guardia
	                      INNER JOIN ZabFichePnCov19 On ZabFichePnCov19.COV_Registrac = Guardia.nroregistrac
	   		           WHERE ZabFichePnCov19.Fechordbadd >= ?m.ldFechaDesde AND ZabFichePnCov19.Fechordbadd <= ?m.ldFechaHasta AND
	   		              Zabfichepncov19.FecHorDbAdd IS NOT NULL AND
	   		              Guardia.fechahoraing >= ?m.ldFechaDesde AND Guardia.fechahoraing <= ?m.ldFechaHasta
      				UNION
				      SELECT DISTINCT Tabambulatorio.NroRegistrac, Tabambulatorio.ID,
						  Tabambulatorio.fechahoraing, Tabambulatorio.protocolo,
						  Tabambulatorio.codent
				      FROM Tabambulatorio
				      RIGHT OUTER JOIN Zabfichepncov19 ON Zabfichepncov19.COV_Registrac = Tabambulatorio.nroregistrac
						 WHERE  ZabFichePnCov19.Fechordbadd >= ?m.ldFechaDesde AND ZabFichePnCov19.Fechordbadd <= ?m.ldFechaHasta AND
	   		                    Zabfichepncov19.FecHorDbAdd IS NOT NULL AND
						 Tabambulatorio.fechahoraing >= ?m.ldFechaDesde AND Tabambulatorio.FechahoraIng <= ?m.ldFechaHasta
      				
      ENDTEXT

*!*					      SELECT DISTINCT Tabambulatorio.NroRegistrac, Tabambulatorio.ID,
*!*							  Tabambulatorio.fechahoraing, Tabambulatorio.protocolo,
*!*							  Tabambulatorio.codent
*!*					      FROM Tabambulatorio
*!*					      RIGHT OUTER JOIN Zabfichepncov19 ON Zabfichepncov19.COV_Registrac = Tabambulatorio.nroregistrac
*!*							 WHERE  ZabFichePnCov19.Fechordbadd >= ?m.ldFechaDesde AND ZabFichePnCov19.Fechordbadd <= ?m.ldFechaHasta AND
*!*		   		                    Zabfichepncov19.FecHorDbAdd IS NOT NULL AND
*!*							 Tabambulatorio.fechahoraing >= ?m.ldFechaDesde AND Tabambulatorio.FechahoraIng <= ?m.ldFechaHasta
*!*	 


*!*	SELECT DISTINCT Tabambulatorio.NroRegistrac, Tabambulatorio.ID,
*!*						 	  Tabambulatorio.fechahoraing, Tabambulatorio.protocolo,
*!*						 	  Tabambulatorio.codent
*!*						 FROM Zabfichepncov19 
*!*						 INNER JOIN (Select * from Tabambulatorio where Tabambulatorio.fechahoraing >= ?m.ldFechaDesde AND Tabambulatorio.FechahoraIng <= ?m.ldFechaHasta) as Tabambulatorio 
*!*						 	ON Zabfichepncov19.COV_Registrac = Tabambulatorio.nroregistrac 
*!*						 WHERE ZabFichePnCov19.Fechordbadd >= ?m.ldFechaDesde
*!*						  AND ZabFichePnCov19.Fechordbadd <= ?m.ldFechaHasta
*!*						 AND Zabfichepncov19.FecHorDbAdd IS NOT NULL
 
      *-- Ejecuto la consulta al motor
      lnReturn = SQLExec( mCon1, lcCMD_SQL , 'mwkGuardi_Ambula' )

      If lnReturn < 0
         * Messagebox("Fallo la Consulta de las Tabambulatorio "+Chr(10)+ "Aviso ",16," Mensaje al Usuario ")
         =Aerror(lcArrayError)
         Messagebox("Fallo la Consulta de las Tabambulatorio "+Chr(13)+ Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
         Return .F.
      Else
         Select mwkGuardi_Ambula
         * Browse
      Endif

      *//////////////////////////////////////// Fin de Union
      * Strtofile( Replicate('/',100) +Chr(13)+Chr(10),"ConsultaCOVID19.LOG",1)
      * Strtofile( Dtoc( This.dfechaServer )+" "+Time()+" - Consulta de Entidades Inicio ( mwkEntidades ) " + Chr(13) + Chr(10),"ConsultaCOVID19.LOG",1)

      *-- Tabla Entidades
      lcCMD_SQL = ''
      TEXT TO lcCMD_SQL TEXTMERGE NOSHOW PRETEXT 7
					SELECT * FROM Entidades ORDER BY Entidades.ENT_codent
      ENDTEXT

      lnReturn = SQLExec( mCon1, lcCMD_SQL , 'mwkEntidades' )

      * Strtofile( Replicate('/',100) +Chr(13)+Chr(10),"ConsultaCOVID19.LOG",1)
      * Strtofile( Dtoc( This.dfechaServer )+" "+Time()+" - Consulta de Entidades Fin ( mwkEntidades ) " + Chr(13) + Chr(10),"ConsultaCOVID19.LOG",1)

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
      * Strtofile( Replicate('/',100) +Chr(13)+Chr(10),"ConsultaCOVID19.LOG",1)
      * Strtofile( Dtoc( This.dfechaServer )+" "+Time()+" - Consulta de Registracion Inicio ( mwkRegistracio ) " + Chr(13) + Chr(10),"ConsultaCOVID19.LOG",1)

      lcCMD_SQL = ''
      TEXT TO lcCMD_SQL TEXTMERGE NOSHOW PRETEXT 7
				SELECT DISTINCT Registracio.REG_nroregistrac,
				  Registracio.REG_nombrepac, Registracio.REG_nrohclinica,
				  Registracio.REG_fecnacimiento
				 FROM Registracio
				    INNER JOIN Zabfichepncov19 ON  Zabfichepncov19.COV_Registrac = Registracio.REG_nroregistrac
				 WHERE  Zabfichepncov19.FecHorDbAdd >= ?m.ldFechaDesde AND Zabfichepncov19.FecHorDbAdd <= ?m.ldFechaHasta AND
  				        Zabfichepncov19.FecHorDbAdd IS NOT NULL
      ENDTEXT

      lnReturn = SQLExec( mCon1, lcCMD_SQL , 'mwkRegistracio' )

      *///////////////////////////////
      * Strtofile( Replicate('/',100) +Chr(13)+Chr(10),"ConsultaCOVID19.LOG",1)
      * Strtofile( Dtoc( This.dfechaServer )+" "+Time()+" - Consulta de Registracion Fin ( mwkRegistracio ) " + Chr(13) + Chr(10),"ConsultaCOVID19.LOG",1)

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

      *///////////////////////////////////////////////
      * Strtofile( Replicate('/',100) +Chr(13)+Chr(10),"ConsultaCOVID19.LOG",1)
      * Strtofile( Dtoc( This.dfechaServer )+" "+Time()+" - Fichas de COVID19 Inicio ( mwkZabfichepncov19) " + Chr(13) + Chr(10),"ConsultaCOVID19.LOG",1)

      TEXT TO lcCMD_SQL TEXTMERGE NOSHOW PRETEXT 7
				SELECT Zabfichepncov19.COV_Registrac, Zabfichepncov19.FecHorDbAdd, Zabfichepncov19.ID, COV_inisintoma
				 FROM Zabfichepncov19
		         WHERE ( Zabfichepncov19.FecHorDbAdd >= ?m.ldFechaDesde AND Zabfichepncov19.FecHorDbAdd <= ?m.ldFechaHasta ) AND
		         Zabfichepncov19.FecHorDbAdd IS NOT NULL
      ENDTEXT

      *-- Ejecuto la consulta al motor
      lnReturn = SQLExec( mCon1, lcCMD_SQL , 'mwkZabfichepncov19' )

      * Strtofile( Replicate('/',100) +Chr(13)+Chr(10),"ConsultaCOVID19.LOG",1)
      * Strtofile( Dtoc( This.dfechaServer )+" "+Time()+" - Fichas de COVID19 Fin ( mwkZabfichepncov19) " + Chr(13) + Chr(10),"ConsultaCOVID19.LOG",1)

      If lnReturn < 0
         * Messagebox("Fallo la Consulta de las Zabfichepncov19 "+Chr(10)+ "Aviso ",16," Mensaje al Usuario ")
         =Aerror(lcArrayError)
         Messagebox("Fallo la Consulta de generación de mwkRegistracio  "+Chr(13)+ Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
         Return .F.
      Else
         * Select mwkTabambulatorio
         * Browse
      Endif


      *////////////////////////////////////
      * Strtofile( Replicate('/',100) +Chr(13)+Chr(10),"ConsultaCOVID19.LOG",1)
      * Strtofile( Dtoc( This.dfechaServer )+" "+Time()+" - Inicio consulta Final ( mwkCOVID19 ) " + Chr(13) + Chr(10),"ConsultaCOVID19.LOG",1)


      *-- Cursor Final para agrupar las consltas previas
      *!*	            lcCMDSQL ="SELECT mwkZabfichepncov19.COV_Registrac, mwkZabfichepncov19.FecHorDbAdd, mwkZabfichepncov19.ID, "+ ;
      *!*	               "mwkGuardi_Ambula.Nroregistrac, mwkGuardi_Ambula.fechahoraing, mwkGuardi_Ambula.protocolo, mwkGuardi_Ambula.codent ,"+ ;
      *!*	               "mwkRegistracio.REG_nombrepac, mwkRegistracio.REG_nrohclinica, mwkRegistracio.REG_fecnacimiento, "+ ;
      *!*	               "mwkEntidades.ENT_descrient, mwkZabfichepncov19.COV_inisintoma "+ ;
      *!*	               "FROM mwkZabfichepncov19 "+ ;
      *!*	               "INNER JOIN mwkGuardi_Ambula ON mwkGuardi_ambula.NroRegistrac = mwkZabfichepncov19.COV_Registrac "+ ;
      *!*	               "INNER JOIN mwkRegistracio ON mwkRegistracio.REG_NroRegistrac =  mwkZabfichepncov19.COV_Registrac "+ ;
      *!*	               "INNER JOIN mwkEntidades ON mwkEntidades.ENT_codent = mwkGuardi_ambula.codent "+ ;
      *!*	               "GROUP BY mwkZabfichepncov19.Id "+ ;
      *!*	               "ORDER BY mwkZabfichepncov19.FecHorDbAdd " + ;
      *!*	               "INTO cursor mwkCOVID19"

      lcCMDSQL ="SELECT mwkZabfichepncov19.COV_Registrac, mwkZabfichepncov19.FecHorDbAdd, mwkZabfichepncov19.ID, "+ ;
         "mwkGuardi_Ambula.Nroregistrac, mwkGuardi_Ambula.fechahoraing, mwkGuardi_Ambula.protocolo, mwkGuardi_Ambula.codent ,"+ ;
         "mwkRegistracio.REG_nombrepac, mwkRegistracio.REG_nrohclinica, mwkRegistracio.REG_fecnacimiento, "+ ;
         "mwkEntidades.ENT_descrient, mwkZabfichepncov19.COV_inisintoma "+ ;
         "FROM mwkZabfichepncov19 "+ ;
         "INNER JOIN mwkGuardi_Ambula ON mwkGuardi_ambula.NroRegistrac = mwkZabfichepncov19.COV_Registrac "+ ;
         "INNER JOIN mwkRegistracio ON mwkRegistracio.REG_NroRegistrac =  mwkZabfichepncov19.COV_Registrac "+ ;
         "INNER JOIN mwkEntidades ON mwkEntidades.ENT_codent = mwkGuardi_ambula.codent "+ ;
         "ORDER BY mwkZabfichepncov19.FecHorDbAdd " + ;
         "INTO cursor mwkCOVID19"

      *-- Ejecutamos al consulta final
      &lcCMDSQL

      *////////////////////////////////////
      * Strtofile( Replicate('/',100) +Chr(13)+Chr(10),"ConsultaCOVID19.LOG",1)
      * Strtofile( Dtoc( This.dfechaServer )+" "+Time()+" - Fin consulta Final ( mwkCOVID19 ) " + Chr(13) + Chr(10),"ConsultaCOVID19.LOG",1)

      Select mwkCOVID19
      * Browse

      *-- Do sp_Busco_Pac_Internados With '',''
      * Strtofile( Replicate('/',100) +Chr(13)+Chr(10),"ConsultaCOVID19.LOG",1)
      * Strtofile( Dtoc( This.dfechaServer )+" "+Time()+" - Filtro Inicio ( mwkEpidemioCOVID19 ) " + Chr(13) + Chr(10),"ConsultaCOVID19.LOG",1)

      *!*	      *-- Extracto de los datos que coinciden con fecha por Nro de Registracion
      *!*	      Select mwkCOVID19.* , mwkPacInt.pac_codadmision, mwkPacInt.PAC_descripdiagn , ;
      *!*	         mwkPacInt.PAC_habitacion , mwkPacInt.PAC_Cama , mwkPacInt.Pac_Codhci , mwkPacInt.Sec_DescripSec,  ;
      *!*	         mwkPacInt.Pac_NombrePaciente ;
      *!*	         From mwkCOVID19;
      *!*	         Left Join mwkPacInt On  mwkCOVID19.COV_Registrac = mwkPacInt.Pac_Codhci ;
      *!*	         WHERE !Empty( mwkPacInt.Pac_Codhci ) ;
      *!*	         into Cursor mwkEpidemioCOVID19

      *-- Extracto de los datos que coinciden con fecha por Nro de Registracion
      Select mwkCOVID19.* , mwkPacInt.pac_codadmision, mwkPacInt.PAC_descripdiagn , ;
         mwkPacInt.PAC_habitacion , mwkPacInt.PAC_Cama , mwkPacInt.Pac_Codhci , mwkPacInt.Sec_DescripSec,  ;
         mwkPacInt.Pac_NombrePaciente ;
         From mwkCOVID19;
         Left Join mwkPacInt On mwkCOVID19.COV_Registrac = mwkPacInt.Pac_Codhci And !Empty( mwkPacInt.Pac_Codhci ) ;
         into Cursor mwkEpidemioCOVID19

      Select mwkEpidemioCOVID19
      * Browse Nowait

      * Strtofile( Replicate('/',100) +Chr(13)+Chr(10),"ConsultaCOVID19.LOG",1)
      * Strtofile( Dtoc( This.dfechaServer )+" "+Time()+" - Filtro Final ( mwkEpidemioCOVID19 ) " + Chr(13) + Chr(10),"ConsultaCOVID19.LOG",1)

      Wait Window At 20,20 Nowait "Proceso Terminado..." Timeout 30


      *///////////////////////////////////////////// Del Formulario Directamente
      *-- Conssulta para 'COVID19' -- Cursor creado mwkFichaCOVID19
      Select mwkEpidemioCOVID19

      Select Iif(COV_inisintoma = Ctod("01/01/1900"),Ttod(FecHorDbAdd),COV_inisintoma ) As fechahoraing, ;
         NVL( Reg_nombrepac,'' )      As Reg_nombrepac , ;
         Ent_DescriEnt , ;
         NVL( PAC_descripdiagn,'' )   As Diagnostico, ;
         nvl( Sec_DescripSec,'' )     As Sec_DescripSec,  ;
         nvl( PAC_habitacion,'' )     As PAC_habitacion, ;
         Nvl( PAC_Cama,'' )           As PAC_Cama, ;
         Id, " " As Fe_Proto, ;
         pac_codadmision , COV_Registrac As Pac_Codhci , 'COVI' As cTipo  ;
         From mwkEpidemioCOVID19 ;
         into Cursor mwkEpidems3


      *-- Viene de la busqueda de Pacientes Internados y registracion
      Select mwkEpidems3
      Count For !Isnull(pac_codadmision) To lnTotalCOVID19     && .TxtPacInt.Value
      * Browse

      *///////////////
   Case tcTipo = 4  						&& tcTipo = 4 (Todas )    	/ tcBuscar = Nro de registracion


Endcase
