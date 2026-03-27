**********************************************************************
* Program....: SP_GRABO_PRESTA.PRG
* Version....:
* Author.....:
* Date.......: 
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....:
* Purpose....:    Graba en Tabla Prestadores
**********************************************************************
*
Parameter   mabm, mid, mbdesde, mbhasta, mbloqueo, mespe, miva, mloca, mpcia, mcpostal, ;
            mprofesion, mestudio, mcuit, mambula, mguardia, minterna,  ;
            mdomici, memail, memailcorp, mestado, ;
            mfaltaa, mfaltag, mfaltai, mfaltaq ,;
            mfecnac, ;
            mfbajaa, mfbajag, mfbajai, mfbajaq, ;
            mweb, mobser, msexo, ;
            mmatricula, mnombre, mmovil, mtele, mradio, mfecmod, musua, mfecvtoanssal ,mfecvtoseg ,;
            mlanssal ,mlcertdef ,mldocum ,mlhepat ,mlregfirma ,mlseguro ,mnroproveedor,mmatprov, ;
            mfaltap, mfbajap, menreldep, mlregincomp, mlidseguro, mfecvtomat, mapellido, mnrolegajo , ;
            mquirofano 

*///////////////
musuarios =  mwkusuario.codigovax
mfechaMod = sp_busco_fecha_serv("DT")
mfecnul = Ctod("01/01/1900")

mnombretotal = mapellido + " " + mnombre

If mabm = 1

   mret = SQLExec(mcon1, "INSERT INTO Prestadores ( bloquedesde, bloquehasta, bloqueo, codesp, " + ;
      "codiva, codloca, codpcia, codpostal, codprof, coduniv, cuil, dambula, " + ;
      "dguardia, dinterna, domicilio, email, emailcorp, estado, fecalta, fecaltag, fecaltai, " + ;
      "fecnac, fecpasiva, fecpasivag, fecpasivai, fecpasivaq, web, obser, sexo, " + ;
      "matriculas, nombre, telcelular, telefono, telradio, fechamod, usuario, "+;
      "FecVtoAnssal ,FecVtoSeg ,lanssal ,lcertdef ,ldocum ,lhepat ,"+;
      "lregfirma ,lseguro ,nroproveedor, matprov, fecaltap, fecpasivap, enreldep ,"+;
      "lregIncomp,idseguro,fecvtomatricula,nom,ape,nrolegajo , dquirofano, fecaltaq ,fecpasivaq ) " + ;
      "VALUES(?mbdesde, ?mbhasta, ?mbloqueo, ?mespe, ?miva, " + ;
      "?mloca, ?mpcia, ?mcpostal, ?mprofesion, ?mestudio, ?mcuit, ?mambula, ?mguardia, " + ;
      "?minterna, ?mdomici, ?memail, ?memailcorp ,?mestado, ?mfaltaa, ?mfaltag, ?mfaltai, ?mfecnac, " + ;
      "?mfbajaa, ?mfbajag, ?mfbajai, ?mfbajaq, ?mweb, ?mobser,?msexo, ?mmatricula, " + ;
      "?mnombretotal, ?mmovil, ?mtele, ?mradio, ?mfecmod, ?musua ,"+;
      "?mFecVtoAnssal ,?mFecVtoSeg ,?mlanssal ,?mlcertdef ,"+;
      "?mldocum ,?mlhepat ,?mlregfirma ,?mlseguro ,?mnroproveedor,"+;
      "?mmatprov, ?mfaltap,?mfbajap,?menreldep, ?mlregIncomp, ?mlidseguro, ?mfecvtomat,"+;
      "?mnombre, ?mapellido,?mnrolegajo, ?mquirofano, ?mfaltaq , ?mfbajaq )")

   If mret < 0

      mret = SQLExec(mcon1, "INSERT INTO Prestadores ( bloquedesde, bloquehasta, bloqueo, codesp, " + ;
         "codiva, codloca, codpcia, codpostal, codprof, coduniv, cuil, dambula, " + ;
         "dguardia, dinterna, domicilio, email, emailcorp, estado, fecalta, fecaltag, fecaltai, " + ;
         "fecnac, fecpasiva, fecpasivag, fecpasivai, fecpasivaq ,web, obser, sexo, " + ;
         "matriculas, nombre, telcelular, telefono, telradio, fechamod, usuario ,"+;
         "FecVtoAnssal ,FecVtoSeg ,lanssal ,lcertdef ,ldocum ,lhepat ,"+;
         "lregfirma ,lseguro ,nroproveedor, matprov, fecaltap, fecpasivap, "+ ;
         "enreldep,fecvtomatricula, nom,ape,nrolegajo, dquirofano, fecaltaq ,fecpasivaq ) " + ;
         "VALUES ( ?mbdesde, ?mbhasta, ?mbloqueo, ?mespe, ?miva, " + ;
         "?mloca, ?mpcia, ?mcpostal, ?mprofesion, ?mestudio, ?mcuit, ?mambula, ?mguardia, " + ;
         "?minterna, ?mdomici, ?memail, ?memailcorp , ?mestado, ?mfaltaa, ?mfaltag, ?mfaltai, ?mfecnac, " + ;
         "?mfbajaa, ?mfbajag, ?mfbajai, ?mfbajaq, ?mweb, ?mobser,?msexo, ?mmatricula, " + ;
         "?mnombretotal, ?mmovil, ?mtele, ?mradio, ?mfecmod, ?musua," +;
         "?mFecVtoAnssal ,?mFecVtoSeg ,?mlanssal ,?mlcertdef ," +;
         "?mldocum ,?mlhepat ,?mlregfirma ,?mlseguro ,?mnroproveedor," +;
         "?mmatprov, ?mfaltap,?mfbajap,?menreldep,?mfecvtomat, " +;
         "?mnombre, ?mapellido, ?mnrolegajo , ?mquirofano, ?mfaltaq ,?mfbajaq )" )
  
      If mret < 0
         Messagebox("NO SE PUDO GUARDAR LA INFORMACION",48,"ALTA DE PRESTADOR")
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
      Endif

   ENDIF
   
   mret = SQLExec(mcon1, "select id from Prestadores where nombre = ?mnombre and "  + ;
      'matriculas = ?mmatricula and usuario = ?musua and fechamod = ?mfecmod and '+;
      "matprov = ?mmatprov","mwkctrlprest")
   mid = mwkctrlprest.Id

   If mid>0
      Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Endif

Else

   mret = SQLExec(mcon1, "UPDATE Prestadores SET nombre = ?mnombretotal, nom = ?mnombre, ape = ?mapellido, domicilio = ?mdomici, " + ;
      'codpostal = ?mcpostal, telefono = ?mtele, telcelular = ?mmovil, fecnac = ?mfecnac, ' + ;
      'telradio = ?mradio, email = ?memail, emailcorp = ?memailcorp ,codpcia = ?mpcia, codloca = ?mloca, ' + ;
      'codprof = ?mprofesion, coduniv = ?mestudio, codiva = ?miva, codesp = ?mespe, ' + ;
      'matriculas = ?mmatricula, dguardia = ?mguardia, dambula = ?mambula, ' + ;
      'dinterna = ?minterna, estado = ?mestado, bloqueo = ?mbloqueo, fecalta = ?mfaltaa, ' + ;
      'fecpasiva = ?mfbajaa, bloquedesde = ?mbdesde, bloquehasta = ?mbhasta, cuil = ?mcuit, ' + ;
      'fecaltag = ?mfaltag, fecaltai = ?mfaltai, fecpasivag = ?mfbajag, fecpasivai = ?mfbajai, fecpasivaq = ?mfbajaq, ' + ;
      'usuario = ?musua, fechamod = ?mfecmod, matprov = ?mmatprov, fecpasivap = ?mfbajap, '+;
      "FecVtoAnssal = ?mFecVtoAnssal ,FecVtoSeg = ?mFecVtoSeg ,"+;
      "lanssal = ?mlanssal ,lcertdef = ?mlcertdef ,ldocum = ?mldocum ,lhepat = ?mlhepat ,"+;
      "lregfirma = ?mlregfirma ,lseguro = ?mlseguro ,nroproveedor = ?mnroproveedor, nrolegajo = ?mnrolegajo ,"+;
      "fecaltap = ?mfaltap,enreldep = ?menreldep, fecvtomatricula =?mfecvtomat ,"+;
      "web = ?mweb, obser = ?mobser, sexo = ?msexo, lregIncomp = ?mlregIncomp, idseguro=?mlidseguro ," +;
      "dquirofano = ?mquirofano , fecaltaq = ?mfaltaq , fecpasivaq = ?mfbajaq " +;
      " where id = ?mid" )

   If mret < 0

      mret = SQLExec(mcon1, "Update Prestadores set nombre = ?mnombretotal, nom = ?mnombre, ape = ?mapellido, domicilio = ?mdomici, " + ;
         'codpostal = ?mcpostal, telefono = ?mtele, telcelular = ?mmovil, fecnac = ?mfecnac, ' + ;
         'telradio = ?mradio, email = ?memail, emailcorp = ?memailcorp , codpcia = ?mpcia, codloca = ?mloca, ' + ;
         'codprof = ?mprofesion, coduniv = ?mestudio, codiva = ?miva, codesp = ?mespe, ' + ;
         'matriculas = ?mmatricula, dguardia = ?mguardia, dambula = ?mambula, ' + ;
         'dinterna = ?minterna, estado = ?mestado, bloqueo = ?mbloqueo, fecalta = ?mfaltaa, ' + ;
         'fecpasiva = ?mfbajaa, bloquedesde = ?mbdesde, bloquehasta = ?mbhasta, cuil = ?mcuit, ' + ;
         'fecaltag = ?mfaltag, fecaltai = ?mfaltai, fecpasivag = ?mfbajag, fecpasivai = ?mfbajai, fecpasivaq = ?mfbajaq ,' + ;
         'usuario = ?musua, fechamod = ?mfecmod, matprov = ?mmatprov, fecpasivap = ?mfbajap ,'+;
         "FecVtoAnssal = ?mFecVtoAnssal ,FecVtoSeg = ?mFecVtoSeg , fecvtomatricula =?mfecvtomat ,"+;
         "lanssal = ?mlanssal ,lcertdef = ?mlcertdef ,ldocum = ?mldocum ,lhepat = ?mlhepat ,"+;
         "lregfirma = ?mlregfirma ,lseguro = ?mlseguro ,nroproveedor = ?mnroproveedor, nrolegajo = ?mnrolegajo ,"+;
         "fecaltap = ?mfaltap, enreldep = ?menreldep ,"+;
         "dquirofano = ?mquirofano, "+;
         "fecaltaq = ?mfaltaq , fecpasivaq = ?mfbajaq " +;
         "web = ?mweb, obser = ?mobser, sexo = ?msexo " +;
         " WHERE id = ?mid" )
    
      If mret<0
         Messagebox("ERROR AL ACTUALIZAR LOS DATOS DEL PRESTADOR",48,"AVISO")
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
      Endif
   Endif
 
   mret = SQLExec(mcon1, "select id from tabProfAmbito "+;
      " where CodAmbito = ?mxambito and CodMed =?mid " ,"mwkctrlpa")

   If Reccount("mwkctrlpa")= 0
      mret = SQLExec(mcon1, "Insert into tabProfAmbito (CodAmbito, CodMed,"+;
         "FechaHoraIng, FechaPasiva,Usuario) " + ;
         " values (?mxambito,?mid,?mfecmod, ?mfecnul , ?musua)")
      If mret<0
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
      Endif
   Endif

Endif

If mret < 1
   =Aerr(eros)
   Messagebox(eros(3))
Endif


*!*	      TRY

*!*	      Catch To oError
*!*	         =Messagebox("Error en : "+Chr(13)+;
*!*	            [ Error: 		] + Str(oError.ErrorNo) +Chr(13)+;
*!*	            [ LineNo: 	] + Str(oError.Lineno) +Chr(13)+;
*!*	            [ Message: 	] + oError.Message 	+Chr(13)+;
*!*	            [ Procedure: 	] + oError.Procedure +Chr(13)+;
*!*	            [ Details: 	] + oError.Details 	+Chr(13)+;
*!*	            [ StackLevel: ] + Str(oError.StackLevel) +Chr(13)+;
*!*	            [ LineContents: ] + oError.LineContents  +Chr(13)+;
*!*	            [ UserValue: 	] + oError.UserValue ,48,"Error")
*!*	      Endtry
