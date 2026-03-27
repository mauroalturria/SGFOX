**********************************************************************
* Program....: SP_INCSEG_LGDT.PRG
* Version....:
* Author.....: Marcelo Torres
* Date.......: 10 October 2019, 10:04:35
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: mtorres, Created 10 October 2019 / 10:04:35
* Purpose....:
**********************************************************************
*
* Incidente de Seguridad (Seguridad e Higiene) - Registro / Actualización de datos LEGALES
*
Parameters mformp, mformlg

mlidinc  = mformp.idincidente
muser = Iif(Used("mwkusuarios"),mwkusuarios.idusuario,mwkusuario.idusuario)
mfech    = sp_busco_fecha_serv("DT")
mdetalle = ""


With mformlg.PagPrin

   Dimension datos[40]

   *!* Thisform.tipoincidente
   *!*	msel = mpagina + Alltrim(mwktaxindiceb.ldestino)+ ".label6.caption"
   *!*	.PagPrin.Page2.PGIndice.Page1.Label1.Caption = "Selección : " + &msel
   *!*	&mdestino

   mtipoinc = mformlg.tipoincidente

   With .Page1
      mdescripcion = Alltrim(.txtdes.Value)
   Endwith

   With .Page2

      With .PGIndice.Page1 && Tipo de Incidente // No hace falta poner el PageFrame pero para control lo pongo

         Do Case
            Case mtipoinc = 0 Or mtipoinc = 99 	&& nada

               datos[1] = 0
               datos[2] = 0
               datos[3] = 0
               datos[4] = 0

            Case mtipoinc = 1 && Caida

               datos[1] = 0
               datos[2] = 0
               datos[3] = 0
               datos[4] = 0

            Case mtipoinc = 2 && Medicacion

               datos[1] = mwktaxoP1a1.orden
               datos[2] = mwktaxoP1b1.orden
               datos[3] = Iif( mformlg.lperfil = "LEGALES", mwktaxoP1a2.orden, 0)
               datos[4] = Iif( mformlg.lperfil = "LEGALES", mwktaxoP1b2.orden, 0)

            Case mtipoinc = 3 &&Sangre

               datos[1] = mwktaxo2P1a1.orden
               datos[2] = mwktaxo2P1b1.orden
               datos[3] = Iif( mformlg.lperfil = "LEGALES", mwktaxo2P1a2.orden, 0)
               datos[4] = Iif( mformlg.lperfil = "LEGALES", mwktaxo2P1b2.orden, 0)

            Case mtipoinc = 4 &&DISPOSITIVOS MEDICOS

               datos[1] = mwktaxo3P1a1.orden
               datos[2] = mwktaxo3P1b1.orden
               datos[3] = Iif( mformlg.lperfil = "LEGALES", mwktaxo3P1a2.orden, 0)
               datos[4] = Iif( mformlg.lperfil = "LEGALES", mwktaxo3P1b2.orden, 0)

            Case mtipoinc = 5 &&DOCUMENTACION

               datos[1] = mwktaxo4P1a1.orden
               datos[2] = mwktaxo4P1b1.orden
               datos[3] = Iif( mformlg.lperfil = "LEGALES", mwktaxo4P1a2.orden, 0)
               datos[4] = Iif( mformlg.lperfil = "LEGALES", mwktaxo4P1b2.orden, 0)

            Case mtipoinc = 6 &&INFRAESTRUCTURA

               datos[1] = mwktaxo5P1a1.orden
               datos[2] = mwktaxo5P1b1.orden
               datos[3] = Iif( mformlg.lperfil = "LEGALES", mwktaxo5P1a2.orden, 0)
               datos[4] = Iif( mformlg.lperfil = "LEGALES", mwktaxo5P1b2.orden, 0)

            Case mtipoinc = 7 &&RECURSOS GESTION

               datos[1] = mwktaxo6P1a1.orden
               **datos[2] = mwktaxo6P1b1.orden
               datos[3] = Iif( mformlg.lperfil = "LEGALES", mwktaxo6P1a2.orden, 0)
               **datos[4] = Iif( mformlg.lperfil = "LEGALES", mwktaxo6P1b2.orden, 0)

            Case mtipoinc = 8 &&Administración clínica

               datos[1] = mwktaxo7P1a1.orden
               datos[2] = mwktaxo7P1b1.orden
               datos[3] = Iif( mformlg.lperfil = "LEGALES", mwktaxo7P1a2.orden, 0)
               datos[4] = Iif( mformlg.lperfil = "LEGALES", mwktaxo7P1b2.orden, 0)

            Case mtipoinc = 9 &&Proceso / Procedimiento clínico

               datos[1] = mwktaxo8P1a1.orden
               datos[2] = mwktaxo8P1b1.orden
               datos[3] = Iif( mformlg.lperfil = "LEGALES", mwktaxo8P1a2.orden, 0)
               datos[4] = Iif( mformlg.lperfil = "LEGALES", mwktaxo8P1b2.orden, 0)

            Case mtipoinc = 10 &&Infección asociada a la atención sanitaria

               datos[1] = mwktaxo9P1a1.orden
               datos[2] = mwktaxo9P1b1.orden
               datos[3] = Iif( mformlg.lperfil = "LEGALES", mwktaxo9P1a2.orden, 0)
               datos[4] = Iif( mformlg.lperfil = "LEGALES", mwktaxo9P1b2.orden, 0)

            Case mtipoinc = 11 &&Nutrición

               datos[1] = mwktaxo10P1a1.orden
               datos[2] = mwktaxo10P1b1.orden
               datos[3] = Iif( mformlg.lperfil = "LEGALES", mwktaxo10P1a2.orden, 0)
               datos[4] = Iif( mformlg.lperfil = "LEGALES", mwktaxo10P1b2.orden, 0)

            Case mtipoinc = 12 &&Oxígeno / gases / vapores

               datos[1] = mwktaxo11P1a1.orden
               datos[2] = mwktaxo11P1b1.orden
               datos[3] = Iif( mformlg.lperfil = "LEGALES", mwktaxo11P1a2.orden, 0)
               datos[4] = Iif( mformlg.lperfil = "LEGALES", mwktaxo11P1b2.orden, 0)

            Case mtipoinc = 13 &&Comportamiento

               datos[1] = mwktaxo12P1a1.orden
               datos[2] = mwktaxo12P1b1.orden
               datos[3] = Iif( mformlg.lperfil = "LEGALES", mwktaxo12P1a2.orden, 0)
               datos[4] = Iif( mformlg.lperfil = "LEGALES", mwktaxo12P1b2.orden, 0)

         Endcase

      Endwith

      *!*		ZabISLegTip

      Use In Select("mwkdCtrl")
      mret = SQLExec(mcon1,"select id as lid from ZabISLegTip where ZIL_idinciden = ?mlidinc","mwkdCtrl")
      If mret < 0
         *!*	         =Aerr(eros)
         *!*	         mmsgerr = eros(3)
         *!*	         mdetalle= "BUSQUEDA DE REGISTRO TIPO DE INCIDENTE"
         *!*	         Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , muser, "Log Incidente Seguridad"
         *!*	         Messagebox("Busqueda Tipo de Incidente", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
         *!*	         Return .F.

         =Aerror(merror)
         Messagebox("Búsqueda Tipo de Incidente " + Chr(10)+Alltrim(merror(3)),16,"ERROR")   && mensaje al usuario con el error, porque aunque él no entienda que corno dice, copia la pantalla y nos lo manda...
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()                      &&  Y esto para que grabe lo correcto en el lugar correcto del archivo de errores
         Return .F.

      Endif

      **      Pasar este dato como parametro ahora busca para evaluar insert o update

      mmov = .T.
      If Used("mwkdCtrl")
         If Reccount("mwkdCtrl")>0
            mmov = .F.
         Endif
      Endif
      Use In Select("mwkdCtrl")

      If mmov

         mdetalle = mdetalle + Ttoc(mfech) + ' : ' + 'REGISTRO DE TIPO DE INCIDENTE' + Chr(13)

         mret = SQLExec(mcon1,"INSERT INTO ZabISLegTip ( ZIL_idinciden, ZIL_tipoinc, ZIL_procreg, ZIL_probreg, ZIL_procaleg, ZIL_probaleg ) "+;
            "Values (?mlidinc, ?mtipoinc, ?datos[1], ?datos[2], ?datos[3], ?datos[4] )" )

      Else

         mdetalle = mdetalle + Ttoc(mfech) + ' : ' + 'ACTUALIZACION DE TIPO DE INCIDENTE' + Chr(13)

         *!*				mret = SQLExec(mcon1,"update ZabISLegTip set "+;
         *!*					"ZIL_tipoinc  = ?mtipoinc,"+;
         *!*					"ZIL_procreg  = ?datos[1],"+;
         *!*					"ZIL_probreg  = ?datos[2],"+;
         *!*					"ZIL_procaleg = ?datos[3],"+;
         *!*					"ZIL_probaleg = ?datos[4]"+;
         *!*					" where ZIL_idinciden = ?mlidinc")

         mret = SQLExec(mcon1,"update ZabISLegTip set "+;
            "ZIL_tipoinc  = ?mtipoinc,"+;
            "ZIL_procaleg = ?datos[3],"+;
            "ZIL_probaleg = ?datos[4]"+;
            " where ZIL_idinciden = ?mlidinc")

      Endif

      If mret < 0
         *!*	         =Aerr(eros)
         *!*	         mmsgerr = eros(3)
         *!*	         mdetalle= "ACTUALIZACION MAESTRO DE TIPO DE INCIDENTE"
         *!*	         Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , muser, "Log Incidente Seguridad"
         *!*	         Messagebox("Actualización Incidente de Seguridad", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
         *!*	         Return .F.

         =Aerror(merror)
         Messagebox("Actualizacion Maestro de Tipo de Incidente " + Chr(10)+Alltrim(merror(3)),16,"ERROR")   && mensaje al usuario con el error, porque aunque él no entienda que corno dice, copia la pantalla y nos lo manda...
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()                      &&  Y esto para que grabe lo correcto en el lugar correcto del archivo de errores
         Return .F.

      Endif


      With .PGIndice.Page2 && Caidas

         datos[5]  = .opt1.Value && Acompañado
         datos[6]  = .opt2.Value && sujeción
         datos[7]  = .opt3.Value && Riesgo Caida
         datos[8]  = .opt4.Value &&  "" x evaluado

         datos[9]  = .opt5.Value && mecanismo

         Do Case
            Case datos[9] = 1 && Desde la cama
               datos[10] = .opt6.Value

            Case datos[9] = 2 && Al bajar de la cama
               datos[10] = .opt7.Value

            Case datos[9] = 4 && En el baño
               datos[10] = .opt8.Value
         Endcase

         datos[11] = Alltrim(.txtcaidaotros.Value)
         datos[12] = Alltrim(.txtproblemas.Value)
         datos[13] = Alltrim(.txtmecanismo.Value)

      Endwith


      If mmov

         mdetalle = mdetalle + Ttoc(mfech) + ' : ' + 'REGISTRO CAIDAS' + Chr(13)

         mret = SQLExec(mcon1,"insert into ZabISLegCaida(ZIC_idinciden, ZIC_pacacomp, ZIC_sujecion, ZIC_riesgoeval, ZIC_tipoeval, ZIC_mecancaa,"+;
            " ZIC_mecancab, ZIC_detotros, ZIC_problinf, ZIC_detmeca)"+;
            " Values (?mlidinc, ?datos[5], ?datos[6], ?datos[7], ?datos[8], ?datos[9], ?datos[10], ?datos[11], ?datos[12], ?datos[13])")
      Else

         mdetalle = mdetalle + Ttoc(mfech) + ' : ' + 'ACTUALIZACION CAIDAS' + Chr(13)

         mret = SQLExec(mcon1,"update ZabISLegCaida set "+;
            "ZIC_pacacomp   = ?datos[5],"+;
            "ZIC_sujecion   = ?datos[6],"+;
            "ZIC_riesgoeval = ?datos[7],"+;
            "ZIC_tipoeval   = ?datos[8],"+;
            "ZIC_mecancaa   = ?datos[9],"+;
            "ZIC_mecancab   = ?datos[10],"+;
            "ZIC_detotros   = ?datos[11],"+;
            "ZIC_problinf   = ?datos[12],"+;
            "ZIC_detmeca    = ?datos[13]"+;
            " where ZIC_idinciden = ?mlidinc")

      Endif

      If mret < 0
         *!*	         =Aerr(eros)
         *!*	         mmsgerr = eros(3)
         *!*	         mdetalle= "ACTUALIZACION MAESTRO DE CAIDAS"
         *!*	         Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , muser, "Log Incidente Seguridad"
         *!*	         Messagebox("Actualización Incidente de Seguridad Caidas", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
         *!*	         Return .F.

         =Aerror(merror)
         Messagebox("Actualización Incidente de Seguridad Caídas " + Chr(10)+Alltrim(merror(3)),16,"ERROR")   && mensaje al usuario con el error, porque aunque él no entienda que corno dice, copia la pantalla y nos lo manda...
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()                      &&  Y esto para que grabe lo correcto en el lugar correcto del archivo de errores
         Return .F.

      Endif

   Endwith

   With .Page3

      datos[14] = .chkcon1.Value
      datos[15] = .chkcon2.Value
      datos[16] = .chkcon3.Value
      datos[17] = .chkcon4.Value
      datos[18] = .chkcon5.Value
      datos[19] = .chkcon6.Value
      datos[20] = Alltrim(.txtotraconse.Value)
      datos[21] = .optcomunico.Value
      datos[22] = Alltrim(.txtaquien.Value)
      datos[23] = Alltrim(.txtseledijo.Value)
      datos[24] = Alltrim(.txtreaccion.Value)
      datos[25] = .optconstancia.Value  &&.chkconst1.Value
      datos[26] = .chkconst2.Value
      datos[27] = .chkconst3.Value
      datos[28] = .chkconst4.Value
      datos[29] = .chkconst5.Value
      datos[30] = .chkconst6.Value
      datos[31] = Alltrim(.txtotroconsta.Value)

   Endwith

   *!*	ZabISLegConse
   *!*	// ID Incidente : maestro User.ZabISeg
   *!*	// Tipo de Consecuencia  6
   *!*	// Comunico el hecho 1
   *!*	// Constancia documental 6
   *!*	// Consecuencia p/paciente texto Otros
   *!*	// Comunicación del hecho, A Quien ?
   *!*	// Comunicación del hecho, Qué se le dijo ?
   *!*	// Comunicación del hecho, Cuál fue la reacción ?
   *!*	// Constancias documentales del incidente, texto otra

   If mmov

      mdetalle = mdetalle + Ttoc(mfech) + ' : ' + 'REGISTRO CONSECUENCIAS' + Chr(13)

      mret = SQLExec(mcon1,"insert into ZabISLegConse(ZCL_idinciden, ZCL_cslesion, ZCL_csmuerte, ZCL_csreoper, ZCL_csinfecc,"+;
         "ZCL_csprolin, ZCL_csotros, ZCL_comunico  , ZCL_cdhiscli, ZCL_cdevolme, ZCL_cdevolen, ZCL_cdreport, ZCL_cddenpol,"+;
         "ZCL_cdotros , ZCL_conpacotros, ZCL_aquien, ZCL_qsdijo  , ZCL_reaccion, ZCL_consotras)"+;
         " Values (?mlidinc,?datos[14], ?datos[15], ?datos[16], ?datos[17], ?datos[18], ?datos[19], ?datos[21], ?datos[25],"+;
         "?datos[26], ?datos[27], ?datos[28], ?datos[29], ?datos[30], ?datos[20], ?datos[22], ?datos[23], ?datos[24], ?datos[31])")

   Else

      mdetalle = mdetalle + Ttoc(mfech) + ' : ' + 'ACTUALIZACION CONSECUENCIAS' + Chr(13)

      mret = SQLExec(mcon1,"update ZabISLegConse set "+;
         "ZCL_cslesion  = ?datos[14],"+;
         "ZCL_csmuerte  = ?datos[15],"+;
         "ZCL_csreoper  = ?datos[16],"+;
         "ZCL_csinfecc  = ?datos[17],"+;
         "ZCL_csprolin  = ?datos[18],"+;
         "ZCL_csotros   = ?datos[19],"+;
         "ZCL_comunico  = ?datos[21],"+;
         "ZCL_cdhiscli  = ?datos[25],"+;
         "ZCL_cdevolme  = ?datos[26],"+;
         "ZCL_cdevolen  = ?datos[27],"+;
         "ZCL_cdreport  = ?datos[28],"+;
         "ZCL_cddenpol  = ?datos[29],"+;
         "ZCL_cdotros   = ?datos[30],"+;
         "ZCL_conpacotros = ?datos[20],"+;
         "ZCL_aquien    = ?datos[22],"+;
         "ZCL_qsdijo    = ?datos[23],"+;
         "ZCL_reaccion  = ?datos[24],"+;
         "ZCL_consotras = ?datos[31]"+;
         " where ZCL_idinciden = ?mlidinc")

   Endif

   If mret < 0
*!*	      =Aerr(eros)
*!*	      mmsgerr = eros(3)
*!*	      mdetalle= "ACTUALIZACION MAESTRO DE CONSECUENCIAS PACIENTE"
*!*	      Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , muser, "Log Incidente Seguridad"
*!*	      Messagebox("Actualización Incidente de Seguridad Consecuencias", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
*!*	      Return .F.

         =Aerror(merror)
         Messagebox("Actualización Incidente de Seguridad Consecuencias " + Chr(10)+Alltrim(merror(3)),16,"ERROR")   && mensaje al usuario con el error, porque aunque él no entienda que corno dice, copia la pantalla y nos lo manda...
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()                      &&  Y esto para que grabe lo correcto en el lugar correcto del archivo de errores
         Return .F.

   Endif

   With .Page4

      *!*		.cbomedico.ControlSource   = 'mwkMedicosAll0.id'
      *!*		.cboservicio.ControlSource = 'mwkServ.ser_codserv'
      *!*		.cboservicio2.ControlSource = 'mwkServicio.scodserv'
      *!*		.cbohecho.AddItem('Near miss' ,1)
      *!*		.cboriesgo.AddItem('NINGUNO',1)
      *!*		.cboestr.AddItem('Pendiente' ,5)

      datos[32] = Iif(Len(Alltrim(.cbomedico.DisplayValue))>0   , mwkMedicosAll0.Id   , 0)
      datos[33] = Iif(Len(Alltrim(.cboservicio.DisplayValue))>0 , mwkServ.ser_codserv , 0)
      datos[34] = Iif(Len(Alltrim(.cboservicio2.DisplayValue))>0, mwkServicio.scodserv, 0)
      datos[35] = Iif(Len(Alltrim(.cbohecho.DisplayValue))>0    , mwkHecho.lId     , 0)
      datos[36] = Iif(Len(Alltrim(.cboriesgo.DisplayValue))>0   , mwkRiesgo.lId    , 0)
      datos[37] = mwkEstr.lId  						&&Iif(Len(Alltrim(.cboestr.DisplayValue))>0     , .cboestr.Value      , 0)
      datos[38] = Alltrim(.txtcomentarios.Value)
      datos[39] = .chkinvo.Value						&& Involucra a seguridad e Higiene
      datos[40] = mwkTipAnalisis.lId

   Endwith

   *!* ZabISLegDatos
   *!*	// Id Incidente : maestro User.ZabISeg
   *!*	// mwkServ -> Servicio involucrado -> ser_codserv
   *!*	// mwkServicio -> Servicio que notifica -> scodserv
   *!*	// Nivel de daño
   *!*	// Nivel de riesgo medico legal
   *!*	// Estado de Resolucion en ZabISeg ("Estado Legales")
   *!*	// Comentarios


   If mmov

      mdetalle = mdetalle + Ttoc(mfech) + ' : ' + 'REGISTRO DATOS SOLAPA LEGALES' + Chr(13)

      *!*		mret = SQLExec(mcon1,"insert into ZabISLegDatos(ZLD_idinciden, ZLD_serinv, ZLD_sernot, ZLD_niveldanio, ZLD_nivelrgmed, ZLD_comentario)"+;
      *!*			" Values (?mlidinc, ?datos[33], ?datos[34], ?datos[35], ?datos[36], ?datos[38])")

      mret = SQLExec(mcon1,"insert into ZabISLegDatos(ZLD_idinciden, ZLD_idInvolucrado, ZLD_serinv, ZLD_sernot, ZLD_niveldanio, ZLD_nivelrgmed, ZLD_comentario, ZLD_InvolucraLegales )"+;
         " Values (?mlidinc, ?datos[32], ?datos[33], ?datos[34], ?datos[35], ?datos[36], ?datos[38] , ?datos[39] )")

   Else

      mdetalle = mdetalle + Ttoc(mfech) + ' : ' + 'ACTUALIZACION DATOS SOLAPA LEGALES' + Chr(13)

      mret = SQLExec(mcon1,"update ZabISLegDatos SET " +;
         "ZLD_idInvolucrado = ?datos[32]," +;
         "ZLD_serinv = ?datos[33],"+;
         "ZLD_sernot = ?datos[34],"+;
         "ZLD_niveldanio = ?datos[35],"+;
         "ZLD_nivelrgmed = ?datos[36],"+;
         "ZLD_comentario = ?datos[38],"+;
         "ZLD_InvolucraLegales = ?datos[39],"+;
         "ZLD_tipanalisis = ?datos[40]" +;
         " where ZLD_idinciden = ?mlidinc")

   Endif

   If mret < 0
      *!*			=Aerr(eros)
      *!*			mmsgerr = eros(3)
      *!*			mdetalle= "ACTUALIZACION MAESTRO DE DATOS LEGALES"
      *!*			Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mUser, "Log Incidente Seguridad"
      *!*			Messagebox("Actualización Incidente de Seguridad Datos Legales", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
      *!*			Return .F.

      =Aerror( merror )
      Messagebox("Actualización Incidente de Seguridad Datos Legales " + Chr(10)+Alltrim(merror(3)),16,"ERROR - FAVOR DE AVISAR A SISTEMAS ")   && mensaje al usuario con el error, porque aunque él no entienda que corno dice, copia la pantalla y nos lo manda...
      Do log_errores With Error(), Message(), Message(1), Program(), Lineno()                      &&  Y esto para que grabe lo correcto en el lugar correcto del archivo de errores
      Return .F.

   Endif

Endwith

If Used("mwkmedgrid")
   If Reccount("mwkmedgrid")>0

      *!* 	ZabISLegReemp
      *!*		// ID Incidente : maestro User.ZabISeg
      *!*		// Codigo de Medico
      *!*		// Nombre del Medico
      *!*		// Tipo de Medico (Externo, etc.)
      *!* 	Create Cursor mwkmedgrid (nombre c(40), tipo c(30), codigo N(9))

      mret = SQLExec(mcon1,"delete from ZabISLegReemp where ZMD_idinciden = ?mlidinc")
      If mret < 0
         *!*				=Aerr(eros)
         *!*				mmsgerr = eros(3)
         *!*				mdetalle= "ACTUALIZACION MAESTRO DE MEDICOS REEMPLAZO"
         *!*				Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mUser, "Log Incidente Seguridad"
         *!*				Messagebox("Actualización Incidente de Seguridad Medicos Reemplazo", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
         *!*				Return .F.

         =Aerror( merror )
         Messagebox("Actualización Incidente de Seguridad Medicos Reemplazo " + Chr(10)+Alltrim(merror(3)),16,"ERROR - FAVOR DE AVISAR A SISTEMAS ")   && mensaje al usuario con el error, porque aunque él no entienda que corno dice, copia la pantalla y nos lo manda...
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()                      &&  Y esto para que grabe lo correcto en el lugar correcto del archivo de errores
         Return .F.

      Endif

      Select mwkmedgrid
      Go Top
      Scan All

         v1 = mwkmedgrid.codigo
         v2 = Alltrim(mwkmedgrid.nombre)
         v3 = Alltrim(mwkmedgrid.tipo)

         mret = SQLExec(mcon1,"insert into ZabISLegReemp (ZMD_idinciden, ZMD_codmed, ZMD_mednom, ZMD_tipmed)"+;
            " values (?mlidinc, ?v1, ?v2, ?v3)")

         If mret < 0
            *!*					=Aerr(eros)
            *!*					mmsgerr = eros(3)
            *!*					mdetalle= "REGISTRO MAESTRO DE MEDICOS REEMPLAZO"
            *!*					Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mUser, "Log Incidente Seguridad"
            *!*					Messagebox("Registro Incidente de Seguridad Medicos Reemplazo", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
            *!*					Return .F.

            =Aerror( merror )
            Messagebox("Actualización Incidente de Seguridad Medicos Reemplazo " + Chr(10)+Alltrim(merror(3)),16,"ERROR - FAVOR DE AVISAR A SISTEMAS ")   && mensaje al usuario con el error, porque aunque él no entienda que corno dice, copia la pantalla y nos lo manda...
            Do log_errores With Error(), Message(), Message(1), Program(), Lineno()                      &&  Y esto para que grabe lo correcto en el lugar correcto del archivo de errores
            Return .F.

         Endif

      Endscan

   Endif
Endif

** ACTUALIZAR PRINCIPAL DATOS

mlreg = mformlg.nregistro

mretr = .T.

mret = SQLExec(mcon1,"update ZabISeg set "+;
   "ZIS_invseghig    = ?datos[39],"+;
   "ZIS_nroregistrac = ?mlreg,"+;
   "ZIS_estadolg     = ?datos[37],"+;
   "ZIS_logmov       = ZIS_logmov + ?mdetalle ," +;
   "ZIS_descripcion  = ?mdescripcion ," +;
   "ZIS_idusuario    = ?muser, "+;
   "ZIS_fecmov       = ?mfech"+;
   " where id = ?mlidinc")

If mret < 0
   *!*	   =Aerr(eros)
   *!*	   mmsgerr = eros(3)
   *!*	   mdetalle= "ACTUALIZACION MAESTRO INCIDENTE DE SEGURIDAD"
   *!*	   Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , muser, "Log Incidente Seguridad"
   *!*	   Messagebox("Actualización Incidente de Seguridad", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
   *!*	   mretr = .F.

   =Aerror( merror )
   Messagebox("Actualización Incidente de Seguridad " + Chr(10)+Alltrim(merror(3)),16,"ERROR - FAVOR DE AVISAR A SISTEMAS ")   && mensaje al usuario con el error, porque aunque él no entienda que corno dice, copia la pantalla y nos lo manda...
   Do log_errores With Error(), Message(), Message(1), Program(), Lineno()                      &&  Y esto para que grabe lo correcto en el lugar correcto del archivo de errores
   mretr = .F.

Endif

Return mretr
