**********************************************************************
* Program....: PRG_GENERA_IMPRESION_COVID19.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 22 December 2020, 10:03:29
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 22 December 2020 / 10:03:29
* Purpose....: 		Genera los datos e imprime la ficha Epidemiologica Covid19 segun seleccion 
*				
**********************************************************************
*
* ocImpresionCovid19 = Newobject("cImpresionCOVID19","c:\desaguemes\prg\PRG_GENERA_IMPRESION_COVID19.prg")
* ocImpresionCovid19.ProcesaImpresion( 2992417 ) && 3143240 )

* Set Step On

&&nroregistro = 960346  && prueba
&&nroregistro = 3143240 && prueba
&&nroregistro = 2992417 && real

*-- Codigo de prueba
* mregistra = 3874824

* Select mwkMiMenu

* mordenficha = mwkMiMenu.orden
* mhemoid = mwkMiMenu.Id

* If !Thisform.fechad > Ctod('01/04/2020')
*   Return .F.
* Endif

Define Class cImpresionCOVID19 As Custom

   lfirma = 0

   ***************************************************************************************************
   *  Procedure : Init
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Inicio de la clase
   ***************************************************************************************************
   *
   Procedure Init()

      If !Used("mwkserver1")
         ldisconnec = .T.
         Do sp_conexion
      Endif

   Endproc

   ***************************************************************************************************
   *  Procedure : ProcesaImpresion
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Procesa toda la impresion de l aplanilla Covid
   ***************************************************************************************************
   *
   Procedure ProcesaImpresion( tNroRegistracion )

      mOrdenFicha = 1 						&& Ordenamiento de la salida de la ficha

      *-- Codigo de prueba
      * mregistra = 3874824
      nNroRegistracion = tNroRegistracion 		&& 3143240

      csql = 'SELECT * FROM zabregcontagio WHERE rc_nroregistracio = ?nNroRegistracion'
      nReturn = SQLExec(mcon1,csql,'mwkcovidpac')

      *!*	      If !Used('mwkcovidpac')
      *!*	         Return .F.
      *!*	      Endif

      If nReturn < 0
         =Aerror(merror)
         Messagebox("Fallo en la consulta a la  Tabla ZabRegContagio "+Chr(10)+ Alltrim(merror(3)),16,"ERROR - Avisar a Sistemas ")
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
         Return .F.
      Else
         If !Reccount('mwkcovidpac') > 0
            Return .F.
         Endif
      Endif


      Local lsigo

      mlmed = ''
      mlmat = ''
      mhayfirma = .F.

      *      A = 1
      *      If A = 1 && Antes Thisform.pfMain.page1.optFichaCovid.Value

      * Busco Firma
      lsigo = .F.
      nRegistracion = nNroRegistracion    && Thisform.nroregistracion
      lcSQL ='SELECT cov_usuario FROM ZabFichEpnCov19 WHERE COV_Registrac = ?nRegistracion order by id desc'

      nReturn = SQLExec(mcon1,lcSQL,'mwkmedcovid')

      *-- Control de Ejecucion
      If nReturn < 0
         =Aerror(merror)
         Messagebox("Fallo en la consulta a la  Tabla ZabRegContagio "+Chr(10)+ Alltrim(merror(3)),16,"ERROR - Avisar a Sistemas ")
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
         Return .F.
      Else

         If Used('mwkmedcovid')
            Select mwkmedcovid
            musuario = Alltrim( mwkmedcovid.cov_usuario )
            lcSQL = 'SELECT * FROM tabusuario WHERE IdUsuario = ?mUsuario'

            nReturn = SQLExec(mcon1,lcSQL,'mwkIdMed')

            If Used('mwkIdMed')
               Select mwkIdMed
               mcodmed = mwkIdMed.idcodmed
            Endif

         Endif

      Endif

      *-- Busco medico - Nombre y Matricula
      Do sp_Busco_Medico_Dat With mcodmed

      If Used("MwkDatMed")
         If Reccount("MwkDatMed")>0
            mlmed = Nvl(MwkDatMed.nombre,'')
            mlmat = Nvl(MwkDatMed.matriculas,'')
         Endif
         Use In Select('MwkDatMed')
      Endif

      This.lfirma = mcodmed > 1
      This.CargaFirma( mcodmed , 2 )

      *-- Si tenemos imagen y firma seguimos
      lsigo = Iif( File("C:\temp\imagenes\firmas\firma_ms.tif") And This.lfirma, .T. , .F.  )

      If lsigo
         mhayfirma = .T.
      Endif

      *      Else
      *         lsigo = .T.
      *      Endif

      * If lsigo
      *  Do prg_armo_impresion_covid With 1,mregistra,mordenficha,mhayfirma,mlmed,mlmat
      This.ArmoImpresionCovid( 1, nNroRegistracion, mOrdenFicha, mhayfirma, mlmed, mlmat )
      * Endif


      Use In Select('mwkcovidpac')

   Endproc


   ***************************************************************************************************
   *  Procedure : CargaFirma
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Carga Firma del profesional
   ***************************************************************************************************
   *
   Procedure CargaFirma( Codigov, mTipo)

      &&& carga_firma
      * Lparameter Codigov, mTipo
      Release mlcfirma,msolfirma ,lfile ,lok

      If mTipo = 1 &&& auditor
         If File("C:\temp\imagenes\firma_ac.tif")
            Erase "C:\temp\imagenes\firma_ac.tif"
         Endif
         *busco en tabdocgral la firma y lo grabo en C:\temp\imagenes\firma_ac.jpg
         Do sp_busco_docgral With 19, "frmautor01",,Codigov,,"C:\temp\imagenes\firma_ac."
         *!*		mPropietario = 38
         If !File("C:\temp\imagenes\firma_ac.tif")
            Do sp_busco_docgral With 19, "frmautor01",,54035,,"C:\temp\imagenes\firma_ac."
         Endif
      Else

         If This.lfirma

            *	busco en tabdocgral la firma y lo grabo en C:\temp\imagenes\firma_ac.jpg
            lcdirectorio = 'C:\temp\imagenes\firmas'
            If !Directory(lcdirectorio)
               Md &lcdirectorio
            Endif

            Do sp_busco_prof_foto With Codigov,3   && en codigov trae el id de medico

            Select Top 1 Imagen  As firmag From mprofFoto ;
               order By Id Desc ;
               into Cursor mprofFirma

            If Reccount('mprofFirma') =0
               This.lfirma = .F.
            Else

               If Isnull(mprofFirma.firmag)
                  This.lfirma = .F.
               Else

                  If File("C:\temp\imagenes\firmas\firma_ms.tif")
                     Erase "C:\temp\imagenes\firmas\firma_ms.tif"
                  Endif

                  If File("C:\temp\imagenes\firmas\firma_ms.tif")
                     Messagebox("NO SE PUDO RECUPERAR LA FIRMA DEL PROFESIONAL!!"+Chr(13)+;
                        "SALGA TOTALMENTE DE LA APLICACION Y VUELVA A INGRESAR" +Chr(13)+;
                        "SI PERSISTE EL ERROR COMUNIQUESE CON SISTEMAS",48,"ALERTA")
                     Thisform.lfirma = .F.
                     Return
                  Endif

                  If Used('ima')
                     Use In ima
                  Endif

                  If Used('__DATA')
                     Use In __DATA
                  Endif

                  If Used ('imagen')
                     Use In Imagen
                  Endif

                  If File("C:\temp\imagenes\firmas\imagen.dbf")
                     Erase ("C:\temp\imagenes\firmas\imagen.dbf")
                  Endif

                  If File("C:\temp\imagenes\firmas\imagen.dbf")
                     Messagebox("NO SE PUDO RECUPERAR LA FIRMA DEL PROFESIONAL!!"+Chr(13)+;
                        "SALGA TOTALMENTE DE LA APLICACION Y VUELVA A INGRESAR" +Chr(13)+;
                        "SI PERSISTE EL ERROR COMUNIQUESE CON SISTEMAS",48,"ALERTA",1000)
                     Thisform.lfirma = .F.
                     Return
                  Endif

                  If File("C:\temp\imagenes\firmas\imagen.fpt")
                     Erase ("C:\temp\imagenes\firmas\imagen.fpt")
                  Endif

                  If File("C:\temp\imagenes\firmas\imagen.fpt")
                     Messagebox("NO SE PUDO RECUPERAR LA FIRMA DEL PROFESIONAL!!"+Chr(13)+;
                        "SALGA TOTALMENTE DE LA APLICACION Y VUELVA A INGRESAR" +Chr(13)+;
                        "SI PERSISTE EL ERROR COMUNIQUESE CON SISTEMAS",48,"ALERTA",1000)
                     Thisform.lfirma = .F.
                     Return
                  Endif

                  Select mprofFirma
                  Copy To "C:\temp\imagenes\firmas\imagen"
                  Use In mprofFirma

                  * cambia el campo grneral de tipo memo
                  LL = Fopen("C:\temp\imagenes\firmas\imagen.dbf",12)
                  Fseek(LL,43)
                  Fwrite(LL,'M')
                  Fclose(LL)
                  If Used('__DATA')
                     Use In __DATA
                  Endif
                  If Used ('imagen')
                     Use In Imagen
                  Endif
                  If Used('mprofFirma')
                     Use In mprofFirma
                  Endif

                  lcdirectorio = 'C:\temp\imagenes\firmas'
                  lcnombre    = 'C:\temp\imagenes\firmas\firma_ms.tif'
                  Use C:\temp\imagenes\firmas\Imagen.Dbf In 0 Alias mFirma
                  lfile = mFirma.firmag
                  lok = Strtofile(lfile ,lcnombre)
                  lcnombre    = 'C:\temp\imagenes\firmas\firma_ms.tif'
                  Use In Select("mFirma")

               Endif

            Endif

            =Adir(acontrolfirma,"C:\temp\imagenes\firmas\firma_ms.tif")

            If File("C:\temp\imagenes\firmas\firma_ms.tif")
               If acontrolfirma( 1, 2 ) < 10
                  Messagebox("NO SE PUDO RECUPERAR LA FIRMA",0,'FIRMAS',1000)
                  Erase "C:\temp\imagenes\firmas\firma_ms.tif"
                  *thisform.enviomail(codigov)
               Endif
            Endif

         Endif
      Endif

      *!* ------------------ PRUEBA LA IMAGEN EN UN REPORTE NATIVO DE VFP9.0 ---------------
      *!*			lnimage = 	Filetostr(lcnombre)
      *!*			lcfirma = lcdirectorio  +'\' + lcid   + '.tif'
      *!*			.Pg.PgAnexos.Olefirmaguardar.Imagefileformat= 6
      *!*			.Pg.PgAnexos.Olefirmaguardar.Writeimagefile(lcfirma)
      *!*			mlcfirma = lcfirma
      *!*			Report Form reportfirma.frx To Printer Noconsole
      *!* ------------------- FIN DE PRUEBA DE IMPRESION EN REPORTE -------------------
      Return

   Endproc


   ***************************************************************************************************
   *  Procedure : ArmoImpresionCovid
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Arma la impresion de la ficha - Impresión de Ficha Epidemiológica COVID-19
   ***************************************************************************************************
   *
   Procedure ArmoImpresionCovid( tipoimpresion, nroregistro, ordenimpre, firma, medico, matricula )

      * Impresión de Ficha Epidemiológica COVID-19
      * Parameters tipoimpresion,nroregistro,ordenimpre,firma,medico,matricula

      &&Do sp_conexion

      &&nroregistro = 960346  && prueba
      &&nroregistro = 3143240 && prueba
      &&nroregistro = 2992417 && real
      &&tipoimpresion = 2

      Local lntipoimpresion, lnnroregistro, cfile, lnordenimpre, ldFechaImp

      lntipoimpresion = 0
      lnnroregistro = 0
      tipoimpresion = 2

      cfile1 = 'c:\tempdoc\covid'+Sys(2015) + '.pdf'
      cfile2 = 'c:\tempdoc\covid'+Sys(2015) + '.pdf'

      If !Vartype( nroregistro )='N'
         Return .F.
      Endif

      If nroregistro = 0
         Return .F.
      Endif

      lntipoimpresion = tipoimpresion
      lnnroregistro = nroregistro
      lnordenimpre = ordenimpre

      If !Vartype(ordenimpre)='N'
         lnordenimpre = 1
      Endif

      Do SP_BUSCO_PLANILLA_EPIDE_COV19 With  "", lnnroregistro

      If !Used('mwkEpidemioCov19')
         Return .F.
      Endif

      If Reccount('mwkEpidemioCov19')=0
         Return .F.
      Endif

      Create Cursor mwkReporte (titulo C(180), Descrip C(120), valor l,firma l)

      Select * From mwkEpidemioCov19  Into Cursor mwkECov Readwrite
      Use In Select("mwkEpidemioCov19")

      * Datos del Paciente
      Public mPaciente, mDomicilio, mCiudad, mProvincia, mPais, mFechaNac, mSexo, mEdad, mDNI, mOcupacion, mDomilabo,;
         mTellabo,mTelefono,mMedico,mFecImpresion,mFirma,mfirmadoc

      lcSQL = "select * from registracio where REG_nroregistrac = ?lnnroregistro"

      nReturn = SQLExec(mcon1,lcSQL,'mwkDatosPac')

      Select mwkDatosPac

      ldFechaImp = sp_busco_fecha_serv('DD')

      mFecImpresion = Dtoc(ldFechaImp)
      mPaciente = Alltrim(mwkDatosPac.reg_nombrepac)
      mFechaNac = Dtoc(mwkDatosPac.reg_fecnacimiento)
      mDomicilio = Alltrim(mwkDatosPac.reg_domicilio)
      mCiudad = Alltrim(mwkDatosPac.reg_localidad)
      mProvincia = Alltrim(mwkDatosPac.reg_provincia)
      mSexo = Iif( mwkDatosPac.reg_sexo = 'M','Masculino', Iif(mwkDatosPac.reg_sexo = 'F','Femenino',''))
      mEdad = prg_edad(Ctod(mFechaNac))
      mDNI = mwkDatosPac.reg_numdocumento
      mTelefono = mwkDatosPac.reg_telefonos
      mFirma = firma
      mdoc = Alltrim(medico)
      mmatricula = 'Matrícula ' + Alltrim(matricula)
      mfirmadoc = 'C:\temp\imagenes\firmas\firma_ms.tif'

      Select mwkECov
      mMedico = Alltrim(medico)
      mPais = Alltrim(Nvl(mwkECov.cov_pais,''))
      mOcupacion = Nvl(Alltrim(mwkECov.cov_ocupacion),'')
      mDomilabo = Nvl(Alltrim(mwkECov.cov_domicilio),'')
      mTellabo = Nvl(Alltrim(mwkECov.cov_telefono),'')

      * Información Clínica
      Insert Into mwkReporte (titulo,Descrip,valor) Values ("INFORMACION CLINICA","",.T.)
      Insert Into mwkReporte (titulo,Descrip) Values ("Fecha de Inicio de 1º síntoma (FIS): " , Iif(mwkECov.cov_inisintoma=Ctod('01/01/1900'),'',Dtoc(mwkECov.cov_inisintoma)))
      Insert Into mwkReporte (titulo,Descrip) Values ("Semana epidemiológica de FIS: " , Alltrim(Str(mwkECov.cov_semanaepi)))
      Insert Into mwkReporte (titulo,Descrip) Values ("Fecha de 1º Consulta: " , Iif(mwkECov.cov_primconsulta=Ctod('01/01/1900'),'',Dtoc(mwkECov.cov_primconsulta)))
      Insert Into mwkReporte (titulo,Descrip) Values ("Establecimiento de 1º Consulta: " , Alltrim(Upper(mwkECov.cov_estabprimconsul)))
      Insert Into mwkReporte (titulo,Descrip) Values ("Ambulatorio: " , Iif(mwkECov.cov_ambulat1 = 1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Internado: " , Iif(mwkECov.cov_internado = 1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Fecha de Internación: " , Iif(mwkECov.cov_fechInterna=Ctod('01/01/1900'),'',Dtoc(mwkECov.cov_fechInterna)))
      Insert Into mwkReporte (titulo,Descrip) Values ("Establecimiento de Internación: " , Alltrim(Upper(mwkECov.cov_estabinternac)))
      Insert Into mwkReporte (titulo,Descrip) Values ("Terapia Intensiva: " , Iif(mwkECov.cov_internaUTI=1,"Si",Iif(mwkECov.cov_internaUTI=2,"No","")))
      Insert Into mwkReporte (titulo,Descrip) Values ("Fecha de Internación UTI: " , Iif(mwkECov.cov_fechInternaUTI=Ctod('01/01/1900'),'',Dtoc(mwkECov.cov_fechInternaUTI)))
      Insert Into mwkReporte (titulo,Descrip) Values ("Requerimiento de ARM: " , Iif(mwkECov.cov_requierearm=1,"X",""))
      For nvar = 1 To 3
         Insert Into mwkReporte (titulo,Descrip) Values ("","")
      Endfor

      * Signos y Sintomas
      Insert Into mwkReporte (titulo,Descrip) Values ("SIGNOS Y SINTOMAS","")
      Insert Into mwkReporte (titulo,Descrip) Values ("Fiebre (>=38ºC):",Iif(mwkECov.COV_fiebremasmenos38=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Tos:",Iif(mwkECov.COV_tos=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Dolor de Garganta:",Iif(mwkECov.COV_dolorgaganta=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Odinofagia:",Iif(mwkECov.COV_odinofagia=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Taquipnea/Disnea:",Iif(mwkECov.COV_taquipnea=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Tiraje:",Iif(mwkECov.COV_tiraje=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Insuficiencia ,Respiratoria:",Iif(mwkECov.COV_insufrespirat=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Dolor Torácico:",Iif(mwkECov.COV_dolortoracico=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Diarrea:",Iif(mwkECov.COV_diarrea=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Vómitos:",Iif(mwkECov.COV_vomitos=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Dolor Abdominal:",Iif(mwkECov.COV_dolorabdominal=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Rechazo del ,Alimento:",Iif(mwkECov.COV_rechaaliemnt=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Artralgias:",Iif(mwkECov.COV_artalgias=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Mialgias:",Iif(mwkECov.COV_mialgias=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Cefalea:",Iif(mwkECov.COV_cefalea=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Irritabilidad / ,Confusión:",Iif(mwkECov.COV_irritabconfu=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Malestar General:",Iif(mwkECov.COV_malestargral=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Evidencia ,Radiologica de Neumonía:",Iif(mwkECov.COV_rxneumonia=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Inyección ,Conjuntival:",Iif(mwkECov.COV_inyecconjuntival=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Convulsiones:",Iif(mwkECov.COV_convulsiones=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Coma:",Iif(mwkECov.COV_coma=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Otros:",Iif(!Empty(mwkECov.COV_otrossint),Alltrim(mwkECov.COV_otrossint),""))
      For nvar = 1 To 3
         Insert Into mwkReporte (titulo,Descrip) Values ("","")
      Endfor

      * Enfermedades Previas
      Insert Into mwkReporte (titulo,Descrip) Values ("ENFERMEDADES PREVIAS / COMORBILIDADES","")
      *insert into mwkReporte (titulo,descrip) values ("Presenta enfermedades previas:",Iif(mwkECov.COV_enfermprev=1,"Si",Iif(mwkECov.COV_enfermprev=2,"No",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Inmunosupresión Congénita o Adquirida:",Iif(mwkECov.COV_inmunSupres=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Diabetes:",Iif(mwkECov.COV_diabetes=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Obesidad:",Iif(mwkECov.COV_obesidad=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Embarazo:",Iif(mwkECov.COV_embarazo=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Puerperio:",Iif(mwkECov.COV_puerperio=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Prematuridad:",Iif(mwkECov.COV_prematuridad=1,"X (" + Alltrim(Str(mwkECov.COV_prematsemana)) + " Semanas )",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Bajo Peso al Nacer:",Iif(mwkECov.COV_bajopesonac=1,"X (" + Alltrim(Str(mwkECov.COV_bajopesogr)) + " Grs. )",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Enfermedad Neurológica:",Iif(mwkECov.COV_endfneurolog=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Enfermedad Hepática:",Iif(mwkECov.COV_enferpatica=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Enfermedad Renal Crónica:",Iif(mwkECov.COV_enfrenal=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Hipertensión Arterial:",Iif(mwkECov.COV_hiparterial=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Enfermedad Cardíaca:",Iif(mwkECov.COV_insufcardiaca=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Enfermedad Oncológica:",Iif(mwkECov.COV_enfoncologica=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Bronquiolitis Previa:",Iif(mwkECov.COV_bronquiolitis=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("N.A.C. Previa:",Iif(mwkECov.COV_nac=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("EPOC:",Iif(mwkECov.COV_epoc=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Asma:",Iif(mwkECov.COV_asma=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Tuberculosis:",Iif(mwkECov.COV_tuberculosis=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Ninguna de las anteriores:",Iif(mwkECov.COV_ningunaant=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Otros:",Alltrim(mwkECov.COV_otrosespec))
      Insert Into mwkReporte (titulo,Descrip) Values ("","")
      Insert Into mwkReporte (titulo,Descrip) Values ("TRATAMIENTOS","")
      Insert Into mwkReporte (titulo,Descrip) Values ("Antibióticos:", Iif(mwkECov.COV_fecAntibiot=Ctod('01/01/1900'),'',"Fecha de Inicio: " + Dtoc(mwkECov.COV_fecAntibiot) + " Resultado: En Curso: " + Iif(mwkECov.COV_resulencurso=1,"X"," ") + " Terminado: " + Iif(mwkECov.COV_resulterminado=1,"X"," ")))
      Insert Into mwkReporte (titulo,Descrip) Values ("Antiviral:", Iif(mwkECov.COV_fecAntiviral=Ctod('01/01/1900'),'',"Fecha de Inicio: " + Dtoc(mwkECov.COV_fecAntiviral) + " Resultado: En Curso: " + Iif(mwkECov.COV_antivencurso=1,"X"," ")+ " Terminado: " + Iif(mwkECov.COV_antivterminado=1,"X"," ")))
      Insert Into mwkReporte (titulo,Descrip) Values ("","")
      Insert Into mwkReporte (titulo,Descrip) Values ("ESTADO AL MOMENTO DEL REPORTE","")
      Insert Into mwkReporte (titulo,Descrip) Values ("Recuperado:",Iif(mwkECov.COV_estadorepencurso=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("No Recupeado:",Iif(mwkECov.COV_estadorepnorecup=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Fallecido:",Iif(mwkECov.COV_estadorepfallecido=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Fecha:","")
      Insert Into mwkReporte (titulo,Descrip) Values ("","")
      Insert Into mwkReporte (titulo,Descrip) Values ("DIAGNOSTICO","")
      Insert Into mwkReporte (titulo,Descrip) Values ("Síndrome Gripal:",Iif(mwkECov.COV_diagsmegripal=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Bronquitis:",Iif(mwkECov.COV_diagbronquitis=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Neumonía:",Iif(mwkECov.COV_diagneumonia=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Otros:",Iif(!Empty(mwkECov.COV_DiagEspecif),"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Especificar:",Alltrim(mwkECov.COV_DiagEspecif))

      For nvar = 1 To 3
         Insert Into mwkReporte (titulo,Descrip) Values ("","")
      Endfor

      * Antecedentes Epidemiológicos

      Insert Into mwkReporte (titulo,Descrip) Values ("ANTECEDENTES EPIDEMIOLÓGICOS","")
      Insert Into mwkReporte (titulo,Descrip) Values ("","")
      Insert Into mwkReporte (titulo,Descrip) Values ("OCUPACIONES","")
      Insert Into mwkReporte (titulo,Descrip) Values ("Trabajador de Atención de la Salud:",Iif(mwkECov.COV_trabsalud=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Trabajador de Laboratorio:",Iif(mwkECov.COV_trablaborat=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Trabaja con Animales:",Iif(mwkECov.COV_trabanimales=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("","")
      Insert Into mwkReporte (titulo,Descrip) Values ("ANTECEDENTES DE VACUNACIÓN","")
      Insert Into mwkReporte (titulo,Descrip) Values ("Antigripal:",Iif(mwkECov.COV_antvacunaAntigrip=1,"X",""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Fechas:", Iif(mwkECov.COV_fechavacuantigrip1=Ctod('01/01/1900'),'',Dtoc(mwkECov.COV_fechavacuantigrip1)) + " - " + Iif(mwkECov.COV_antvacunaAntigrip2=Ctod('01/01/1900'),'',Dtoc(mwkECov.COV_antvacunaAntigrip2)))
      Insert Into mwkReporte (titulo,Descrip) Values ("","")
      Insert Into mwkReporte (titulo,Descrip) Values ("VIAJES Y OTRAS EXPOSICIONES DE RIESGO","")
      Insert Into mwkReporte (titulo,Descrip) Values ("¿Ha Viajado o residido en una zona de riesgo conocida fuera del país en los últimos 14 días previos al inicio de los síntomas ?",Iif(mwkECov.COV_viajoresidio=1,"Si",Iif(mwkECov.COV_viajoresidio=2,"No","")))
      Insert Into mwkReporte (titulo,Descrip) Values ("¿ País / Ciudad ?",Alltrim(mwkECov.COV_ViajoDonde))
      Insert Into mwkReporte (titulo,Descrip) Values ("Fechas:","Desde el " + Iif(mwkECov.COV_viajoDesde=Ctod('01/01/1900'),'',Dtoc(mwkECov.COV_viajoDesde)) + " Hasta el " + Iif(mwkECov.COV_viajoHasta=Ctod('01/01/1900'),'',Dtoc(mwkECov.COV_viajoHasta)))
      Insert Into mwkReporte (titulo,Descrip) Values ("Viajó en ","Avión " + Iif(mwkECov.COV_viajoavion=1,"(X)","( )") + " - Barco " + Iif(mwkECov.COV_viajobarco=1,"(X)","( )") + " - Omnibus " + Iif(mwkECov.COV_viajoomnibus=1,"(X)","( )"))
      Insert Into mwkReporte (titulo,Descrip) Values ("Fecha de Ingreso al País:", Iif(mwkECov.COV_fechaingresopais=Ctod('01/01/1900'),'',Dtoc(mwkECov.COV_fechaingresopais)))
      Insert Into mwkReporte (titulo,Descrip) Values ("Compañía de Transporte:",Alltrim(mwkECov.COV_companiaviaje))

      Insert Into mwkReporte (titulo,Descrip) Values ("","")
      Insert Into mwkReporte (titulo,Descrip) Values ("Ha viajado o residido en zona dentro del País (Distinto del Domicilio) en los últimos 14 días previos al inicio de los síntomas ?",Iif(mwkECov.COV_viajodentropais=1,"Si",Iif(mwkECov.COV_viajodentropais=2,"No","")))
      Insert Into mwkReporte (titulo,Descrip) Values ("¿Dónde (Domicilio) ?",Alltrim(mwkECov.COV_dentropaisdonde))
      Insert Into mwkReporte (titulo,Descrip) Values ("Fecha:",Iif(mwkECov.COV_viajoresidioDesde=Ctod('01/01/1900'),'',"Desde el " + Dtoc(mwkECov.COV_viajoresidioDesde)) + Iif(mwkECov.COV_dentropaishasta=Ctod('01/01/1900'),""," - Hasta el " +Dtoc(mwkECov.COV_dentropaishasta)))
      Insert Into mwkReporte (titulo,Descrip) Values ("País / Ciudad:",Alltrim(mwkECov.COV_ciudadcentronCOV19))

      Insert Into mwkReporte (titulo,Descrip) Values ("","")
      Insert Into mwkReporte (titulo,Descrip) Values ("¿ Ha concurrido a un centro de Salud que ha asistido casos confirmados COVID-19 dentro de los 14 días previos al inicio de los síntomas ?",Iif(mwkECov.COV_concasosconf=1,"Si",Iif(mwkECov.COV_concasosconf=2,"No","")))
      Insert Into mwkReporte (titulo,Descrip) Values ("Nombre del Centro:",Alltrim(mwkECov.COV_nomcentronCOV19))
      Insert Into mwkReporte (titulo,Descrip) Values ("Ciudad:",Alltrim(mwkECov.COV_nomcentronCOV19))
      Insert Into mwkReporte (titulo,Descrip) Values ("Fecha:",Iif(mwkECov.COV_centroFechanCOV19=Ctod('01/01/1900'),'',Dtoc(mwkECov.COV_centroFechanCOV19)))
      Insert Into mwkReporte (titulo,Descrip) Values ("¿ Estuvo en contacto con Animales dentro de los 14 días previos al inicio de síntomas ?","Cerdos " + Iif(mwkECov.COV_Cerdos=1,"(X)","( )") + " - Aves " + Iif(mwkECov.COV_ContactoConAves=1,"(X)","( )") + " - Camelidos " + Iif(mwkECov.COV_Camelidos=1,"(X)","( )") + " - Mercado de animales vivos " + Iif(mwkECov.COV_ContactoMercados=1,"(X)","( )"))
      *insert into mwkReporte (titulo,descrip) values ("Otros (Especificar):", - FALTA -

      Insert Into mwkReporte (titulo,Descrip) Values ("","")
      Insert Into mwkReporte (titulo,Descrip) Values ("¿Tuvo contacto cercano con personas con infección respiratoria aguda dentro de los 14 días previos al inicio de síntomas ?",Iif(mwkECov.COV_ContactoCerc14Prev=1,"Si",Iif(mwkECov.COV_ContactoCerc14Prev=2,"No","")))
      Insert Into mwkReporte (titulo,Descrip) Values ("En entornos:","Familiar " + Iif(mwkECov.COV_EnntorFliar14Prev=1,"(X)","( )") + " - Asistencial " + Iif(mwkECov.COV_EntorAsistencial14Prev=1,"(X)","( )") + " - Laboral " + Iif(mwkECov.COV_EntorLaboral14Prev=1,"(X)","( )"))
      Insert Into mwkReporte (titulo,Descrip) Values ("Otros (Especificar):",Nvl(mwkECov.COV_ContacOtros14Prev,""))

      Insert Into mwkReporte (titulo,Descrip) Values ("","")
      Insert Into mwkReporte (titulo,Descrip) Values ("Tuvo contacto estrecho con casos probables o confirmados dentro de los 14 días previos al inicio de síntomas ?",Iif(mwkECov.COV_ContacPersoOtros=1,"Si",Iif(mwkECov.COV_ContacPersoOtros=1,"No","")))
      Insert Into mwkReporte (titulo,Descrip) Values ("Apellido / Nombre:",Alltrim(mwkECov.COV_ContEstrechoNomApe))
      Insert Into mwkReporte (titulo,Descrip) Values ("DNI o DE:",Alltrim(mwkECov.COV_ContEstrechoDNI))
      Insert Into mwkReporte (titulo,Descrip) Values ("País / Área en la que tuvo la exposición:",Alltrim(mwkECov.COV_ContEstrechoArea))
 
      For nvar = 1 To 3
         Insert Into mwkReporte (titulo,Descrip) Values ("","")
      Endfor

      * Laboratorio
      Insert Into mwkReporte (titulo,Descrip) Values ("LABORATORIO","")
      Insert Into mwkReporte (titulo,Descrip) Values ("","")
      Insert Into mwkReporte (titulo,Descrip) Values ("Aspirado:",Iif(mwkECov.COV_MuesAspirado=1,"(X)","( )"))
      Insert Into mwkReporte (titulo,Descrip) Values ("Hisopado:",Iif(mwkECov.COV_MuesHisopado=1,"(X)","( )"))
      Insert Into mwkReporte (titulo,Descrip) Values ("Lavado Broncoalveolar:",Iif(mwkECov.COV_MuesBronalv=1,"(X)","( )"))
      Insert Into mwkReporte (titulo,Descrip) Values ("Estupo:",Iif(mwkECov.COV_MuesEstupo=1,"(X)","( )"))
      Insert Into mwkReporte (titulo,Descrip) Values ("Otros (Especificar):",Nvl(mwkECov.COV_MuestraOtro,""))
      Insert Into mwkReporte (titulo,Descrip) Values ("Fecha de Toma de Muestra:",Iif(mwkECov.COV_MuestraFecha=Ctod('01/01/1900'),'',Dtoc(mwkECov.COV_MuestraFecha)))
      Insert Into mwkReporte (titulo,Descrip) Values ("Fecha de Derivación al LNR:",Iif(mwkECov.COV_MuestraFechaLNR=Ctod('01/01/1900'),'',Dtoc(mwkECov.COV_MuestraFechaLNR)))
      *Insert Into mwkReporte (titulo,Descrip,valor) Values ("","",.T.)
      Insert Into mwkReporte (titulo,Descrip,valor,firma) Values ("","",.T.,.T.)
      Select mwkReporte

      Public mlogo
      mlogo = '' && Preparar una imagen en blanco por si no encuentra la original.
      If File("C:\qepd1a1\xlt\sg1.bmp")
         mlogo = "C:\qepd1a1\xlt\sg1.bmp"
      Endif

      Do Case
         Case lntipoimpresion = 1 && Reporte Impreso en PDF
            *	Set Reportbehavior 90
            Select mwkReporte
            Report Form repfichacovid Object Type 10 To File &cfile1
            
            Insert Into mwkImpreOK (impresion,archivo,hojas,orden) Values ('Ficha Epidemiológica COVID-19',cfile1,1,lnordenimpre)
            
            Select mwkEpidemioCov19cont
            
            If Reccount('mwkEpidemioCov19cont') > 0
               Report Form repfichacovid_con Object Type 10 To File &cfile2
               Insert Into mwkImpreOK (impresion,archivo,hojas,orden) Values ('Ficha Epidemiológica COVID-19',cfile1,1,lnordenimpre)
            Endif
            *	Set Reportbehavior 80

         Case lntipoimpresion = 2 && Reporte Impreso en Papel

            *	Set Reportbehavior 90
            Select mwkReporte
            Report Form repfichacovid2 Preview

            * Select mwkEpidemioCov19cont

            * If Reccount('mwkEpidemioCov19cont') > 0
            *    Report Form repfichacovid_con Preview
            * Endif

         Case lntipoimpresion = 3 		&& HCEpdf - Pisos23

      Endcase

      *-- Ibero variables de memoria
      Release mPaciente, mDomicilio, mCiudad, mProvincia, mPais, mFechaNac, mSexo, mEdad, mDNI, mOcupacion, mDomilabo,;
         mTellabo,mTelefono,mMedico,mFecImpresion


   Endproc

Enddefine



*!*	Saludos Cordiales

*!*	Fabián Castelli
*!*	Sistemas
*!*	fcastelli@sg.com.ar


*!*	 Sanatorio Güemes

*!*
