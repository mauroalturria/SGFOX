**********************************************************************
* Program....: SP_INCSEG.PRG
* Version....:
* Author.....: Marcelo Torres
* Date.......: 01 October 2019, 10:01:29
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: mtorres, Created 01 October 2019 / 10:01:29
* Purpose....:
**********************************************************************
*
* Incidente de Seguridad - Registro / Actualziación de datos de cabecera
*
****

Parameters mform , tnEstadoActual , tnFueCovidPositivo

mUser = Iif(Used("mwkusuarios"),mwkusuarios.idusuario,mwkusuario.idusuario)
mFech = sp_busco_fecha_serv("DT")
mRetr = .T.
gControlGR = .T.

*!*	Paciente Involucrado
*!*	Paciente Involucrado carga inicial
*!*	Fecha informe
*!*	Persona que completo este formulario
*!*	Area mwksectores.sec_codsector
*!*	Puesto
*!*	Interno
*!*	Telefono contacto
*!*	Fecha incidente
*!*	Hora incidente
*!*	Edificio
*!*	Piso
*!*	Sector
*!*	Descripcion
*!*	Log Movimientos
*!*	Fecha Movimiento
*!*	Usuario

Dimension vd[20]

vd[01] = mform.opttipo.Value
vd[02] = mform.opttipo.Value
vd[03] = mform.txtfinf.Value
vd[04] = Alltrim(mform.txtperso.Value)
vd[05] = Iif(Empty(mform.txtarea.Value),0,mwksectores.SEC_codsector)
vd[06] = Iif((Empty(mform.txtpuesto.Value) And Empty(mform.combo4.DisplayValue)),0,mwkpuesto2.lid)
vd[07] = mform.txtinterno.Value
vd[08] = mform.txttelef.Value
vd[09] = mform.txtfinc.Value
vd[10] = mform.txthorad.Value
vd[11] = Iif(Empty(mform.combo1.DisplayValue),0,mwkedificios._id)   &&Edificio donde ocurrio
vd[12] = Iif((Empty(mform.txtpiso.Value) And Empty(mform.combo2.DisplayValue)),0,mwkplantas._id)   &&Piso donde ocurrio
vd[13] = Iif(Empty(mform.combo3.DisplayValue),0,mwkareas._id)   &&Sector donde ocurrio
vd[14] = Alltrim(mform.txtdes.Value)   							&&Descripcion del incidente

*-- Parece que fallan los controles si es Nulo . Vuelvo a verificar el dato aca 02/12/2020 Eduardo
vd[16] = Iif( Vartype( tnEstadoActual ) <> 'N' , 0, tnEstadoActual )
vd[17] = Iif( Vartype( tnFueCovidPositivo ) <> 'N' , 0, tnFueCovidPositivo )

If mform.idincidente = 0 										&& Nuevo registro

   vd[15] = Ttoc(mFech) + ' : ' + 'REGISTRO DE INCIDENTE, ' + Iif(mform.opttipo.Value = 1, 'CON PACIENTE INVOLUCRADO', 'SIN PACIENTE INVOLUCRADO')

   *!*	   mret = SQLExec( mCon1, "insert into ZabISeg " +;
   *!*	      "(ZIS_pacinv, ZIS_pacinvorg, ZIS_fecinf, ZIS_percompleto, ZIS_area, ZIS_puesto, ZIS_interno, ZIS_telcontac, ZIS_fecincidente, "+;
   *!*	      "ZIS_horincidente, ZIS_edificio, ZIS_piso, ZIS_sector, ZIS_descripcion, ZIS_logmov, ZIS_fecmov, ZIS_idusuario)"+;
   *!*	      " values "+;
   *!*	      "(?vd[01], ?vd[02], ?vd[03], ?vd[04], ?vd[05], ?vd[06], ?vd[07], ?vd[08], ?vd[09], ?vd[10], ?vd[11], ?vd[12], ?vd[13], ?vd[14], ?vd[15], ?mfech, ?muser)")

   mret = SQLExec( mCon1, "INSERT INTO ZabISeg " +;
      "( ZIS_pacinv, ZIS_pacinvorg, ZIS_fecinf, ZIS_percompleto, ZIS_area, ZIS_puesto, ZIS_interno, ZIS_telcontac, ZIS_fecincidente, "+;
      "ZIS_horincidente, ZIS_edificio, ZIS_piso, ZIS_sector, ZIS_descripcion, ZIS_logmov, "+;
      "ZIS_EstadoActualCovid, ZIS_FueCovidPositivo , "+;
      "ZIS_fecmov, ZIS_idusuario ) "+;
      " VALUES "+;
      "( ?vd[01], ?vd[02], ?vd[03], ?vd[04], ?vd[05], ?vd[06], ?vd[07], ?vd[08], ?vd[09], ?vd[10], ?vd[11], "+;
      "?vd[12], ?vd[13], ?vd[14], ?vd[15] ,  ?vd[16], ?vd[17] ,?mfech, ?muser )" )

*!*	*-- Copia del log del servidor 
*!*	INSERT INTO ZabISeg ( ZIS_pacinv , ZIS_pacinvorg , ZIS_fecinf , ZIS_percompleto , ZIS_area , ZIS_puesto , ZIS_interno ,
*!*	 ZIS_telcontac , ZIS_fecincidente , ZIS_horincidente , ZIS_edificio , ZIS_piso , ZIS_sector , ZIS_descripcion , ZIS_logmov , 
*!*	 ZIS_EstadoActualCovid , ZIS_FueCovidPositivo , ZIS_fecmov , ZIS_idusuario ) 
*!*	 VALUES ( :%qpar(1) , :%qpar(2) , :%qpar(3) , :%qpar(4) , :%qpar(5) , :%qpar(6) , :%qpar(7) , :%qpar(8) , :%qpar(9) , :%qpar(10) ,
*!*	  :%qpar(11) , :%qpar(12) , :%qpar(13) , :%qpar(14) , :%qpar(15) , :%qpar(16) , :%qpar(17) , :%qpar(18) , :%qpar(19) )


   If mret < 0
      =Aerror(merror)
      Messagebox("Registro Incidente de Seguridad  - Inserción  " + Chr(10)+Alltrim(merror(3)),16,"ERROR")   && mensaje al usuario con el error, porque aunque él no entienda que corno dice, copia la pantalla y nos lo manda...
      Do log_errores With Error(), Message(), Message(1), Program(), Lineno()                      &&  Y esto para que grabe lo correcto en el lugar correcto del archivo de errores
      mRetr = .F.

      *!*	   If mret < 0
      *!*	      =Aerr(eros)
      *!*	      mmsgerr = eros(3)
      *!*	      mdetalle= "REGISTRO INCIDENTE DE SEGURIDAD"
      *!*	      Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mUser, "Log Incidente Seguridad"
      *!*	      Messagebox("Registro Incidente de Seguridad   ", 48, "ERROR ( ZabISeg ) - AVISAR A SISTEMAS")
      *!*	      mRetr = .F.

   Else

      Use In Select("mwkisdat")
      mret = SQLExec( mCon1, "SELECT id as lid FROM ZabISeg WHERE ZIS_idusuario = ?muser AND ZIS_fecmov = ?mfech","mwkisdat")

      If mret < 0
         *!*	         =Aerr(eros)
         *!*	         mmsgerr = eros(3)
         *!*	         mdetalle= "BUSQUEDA DE REGISTRO INCIDENTE DE SEGURIDAD"
         *!*	         Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mUser, "Log Incidente Seguridad"
         *!*	         Messagebox("Busqueda Incidente de Seguridad", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
         =Aerror(merror)
         Messagebox("Búsqueda Incidente de Seguridad  " + Chr(10)+Alltrim(merror(3)),16,"ERROR")   && mensaje al usuario con el error, porque aunque él no entienda que corno dice, copia la pantalla y nos lo manda...
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()                      &&  Y esto para que grabe lo correcto en el lugar correcto del archivo de errores
         mRetr = .F.

      Endif

      If Used("mwkisdat")
         Select mwkisdat
         * Go Top
         Locate
         mform.idincidente = mwkisdat.lid
      Endif

      Use In Select("mwkisdat")

   Endif

Else


   mlid = mform.idincidente
   vd[15] = Chr(13) + Ttoc(mFech) + ' : ' + 'ACTUALIZA INCIDENTE, ' + Iif(mform.opttipo.Value = 1, 'CON PACIENTE INVOLUCRADO', 'SIN PACIENTE INVOLUCRADO')

   mret = SQLExec(mCon1,"UPDATE ZabISeg SET " +;
      "ZIS_fecinf = ?vd[03]," +;
      "ZIS_percompleto = ?vd[04]," +;
      "ZIS_area = ?vd[05]," +;
      "ZIS_puesto = ?vd[06]," +;
      "ZIS_interno = ?vd[07]," +;
      "ZIS_telcontac = ?vd[08]," +;
      "ZIS_fecincidente = ?vd[09], "+;
      "ZIS_horincidente = ?vd[10]," +;
      "ZIS_edificio = ?vd[11]," +;
      "ZIS_piso = ?vd[12]," +;
      "ZIS_sector = ?vd[13]," +;
      "ZIS_descripcion = ?vd[14]," +;
      "ZIS_logmov = ZIS_logmov + ?vd[15], " +;
      "ZIS_EstadoActualCovid = ?vd[16] , "+;
      "ZIS_FueCovidPositivo = ?vd[17] , "+;
      "ZIS_fecmov = ?mfech, " +;
      "ZIS_idusuario = ?muser "+;
      "WHERE id = ?mlid")


   If mret < 0
      *!*	      =Aerr(eros)
      *!*	      mmsgerr = eros(3)
      *!*	      mdetalle= "ACT. DE INCIDENTE DE SEGURIDAD"
      *!*	      Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mUser, "Log Incidente Seguridad"
      *!*	      Messagebox("Actualización Incidente de Seguridad", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
      
      =Aerror(merror)
      Messagebox("Actualización Incidente de Seguridad  " + Chr(10)+Alltrim(merror(3)),16,"ERROR")   && mensaje al usuario con el error, porque aunque él no entienda que corno dice, copia la pantalla y nos lo manda...
      Do log_errores With Error(), Message(), Message(1), Program(), Lineno()                      &&  Y esto para que grabe lo correcto en el lugar correcto del archivo de errores
      mRetr = .F.

   Endif

Endif

Release vd

Return mRetr
