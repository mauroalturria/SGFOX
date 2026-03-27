*
* Actualizacion de derivaciones y observaciones
*
Lparameters mthisform

Dimension mvobs[3]

With mthisform

   mfechor	= .txtfecha.Value
   mderiva	= Allt(.txtderiva.Value)

   If !Used("mwkbuspacie1")

      oo=0
      mipro = Program(oo)
      Do While !Empty(mipro)
         oo = oo + 1
         mipro = Program(oo)
      Enddo

      oo = oo-2
      amipro = Program(oo)
      Do Log_errores With 1, "no existe mwkbuspacie1" ,'',amipro ,-1
      mnroreg = 0
      mnroafi = ""
      mcodent = 0

   Else
      mnroreg = mwkbuspacie1.REG_nroregistrac
      mnroafi = .txtnroafi.value
      mcodent = .CboEntidad.Value

   Endif

   msexo	= Allt(.txtsexo.Value)
   medad	= .txtedad.Value
   mcodint = Round(.cbodestino.Value, 0)
   mtrasla = Allt(.txttraslado.Value)
   mnoti	= Allt(.txtnoti.Value)
   mdiagno = Allt(.txtdiagno.Value)
   mdenupo = .optdenupo.Value
   mpadron = .optpadron.Value
   mestado	= .optrech.Value + Iif(.optrech.Value < 3 ,0 ,1)
   mcama 	= Alltrim(.txthabita.Value)
   mfhingr	= Iif(Inlist(mestado,0,3),Ctot("01/01/1900"),sp_busco_fecha_serv('DT'))
   mtieneobs = .lobserva
   musua     = Alltrim(mwkusuario.idusuario)
   mfeca     = sp_busco_fecha_serv('DT')

   *-- Campos Nuevos para contener universo de disponibilidades (ver Panel web) Eduardo17/02/2020
   mCamasLibres 		=  .CamasLibres
   mDenunciasEgreso 	=  .DenunciasEgreso
   mPreAltas 			=  .PreAltas
   mPrePasesSalientes 	=  .PrePaseSaliente
   mPasesSalientes 		=  .PaseSaliente
   mCirugiasConInternacion = .CirugiasConInternacion
   mInternadosEnEME		=  .InternadosEnEME
   mSolicInternacion    =  .SolicInternacion
   mPrePasesEntrantes 	=  .PrePaseEntrante
   mPasesEntrantes      =  .PaseEntrante
   mDerivacionesEnCurso =  .DerivacionesEntrantes

   With .PageObs
      mobserv    = Alltrim(.Page1.txtobservacion.Value)
      mobservant = Alltrim(.Page1.txtobserva.Value)
      mvobs[1]   = Alltrim(.Page2.txtobsrechazo1.Value)  &&  1
      mvobs[2]   = Alltrim(.Page3.txtobsdirmed1.Value )  &&  2
      mvobs[3]   = ''
   Endwith

   mpaso = .F.

   If .maltamodi = 1 && alta

      *-- Sentencai para guardar datos anterior
      *!*	      mret = SQLExec(mcon1, "insert into tabderivacion (codent, codint, denpolicial, " + ;
      *!*	         "derivadopor, diagnostico, edad, estado, fechahora, fechahoraIngreso, notifica, " + ;
      *!*	         "nroafi, nroregistrac, observa, padron, sexo, traslado, usuario, habitacion, vaxbloqreg) " + ;
      *!*	         "values( ?mcodent, ?mcodint, ?mdenupo, ?mderiva, ?mdiagno, ?medad, " + ;
      *!*	         "?mestado, ?mfechor, ?mfhingr, ?mnoti, ?mnroafi, ?mnroreg, ?mobserv, ?mpadron, " + ;
      *!*	         "?msexo, ?mtrasla, ?midusu, ?mcama, 0 )")

      *     Set Step On

      Local lcCmdSQL As String
      lcCmdSQL = ''

      TEXT TO lcCmdSQL TEXTMERGE NOSHOW PRETEXT 7
			INSERT INTO tabderivacion (codent, codint, denpolicial,
			         derivadopor, diagnostico, edad, estado, fechahora, fechahoraIngreso, notifica,
			         nroafi, nroregistrac, observa, padron, sexo, traslado, usuario, habitacion, vaxbloqreg ,
			     	 CamasLibres , DenunciasEgreso , PreAltas , PrePasesSalientes, CirugiasConInternacion,
			         InternadosEnEME , PrePasesEntrantes, PasesSalientes, PasesEntrantes, DerivacionesEnCurso )
				      	 VALUES ( ?mcodent, ?mcodint, ?mdenupo, ?mderiva, ?mdiagno, ?medad,
				         ?mestado, ?mfechor, ?mfhingr, ?mnoti, ?mnroafi, ?mnroreg, ?mobserv, ?mpadron, ?msexo, ?mtrasla, ?midusu, ?mcama, 0 ,
			    		 ?mCamasLibres , ?mDenunciasEgreso , ?mPreAltas , ?mPrePasesSalientes, ?mCirugiasConInternacion,
			        	 ?mInternadosEnEME , ?mPrePasesEntrantes, ?mPasesSalientes, ?mPasesEntrantes , ?mDerivacionesEnCurso )
      ENDTEXT

      mRet = SQLExec( mCon1, lcCmdSQL , 'mwkTemp' )

      *!*	         *//////////////////////////////////////////////////////////////////////// para localizar error de ejecucion
      *!*	         If SQLExec( mcon1, lcCmdSQL ) < 1

      *!*	            Local aErrData[1]

      *!*	            = Aerror(aErrData)
      *!*	            Do Case
      *!*	               Case aErrData[1,1] = 1526
      *!*	                  * ODBC Error
      *!*	                  Wait Window "ODBC Error Occurred" Nowait
      *!*	               Case Between( aErrData[1,1], 1426, 1429)
      *!*	                  * OLE Error
      *!*	                  Wait Window "OLE Error Occurred" Nowait
      *!*	               Otherwise
      *!*	                  * FoxPro error
      *!*	                  Wait Window "FoxPro Error Occurred" Nowait
      *!*	            Endcase

      *!*	            List Memory To File ErrInfo.TXT Additive Noconsole
      *!*	         Endif

      *!*	         *////////////////////////////////////////////////////////////////////////

      If mRet > 0
         Messagebox('DERIVACION REGISTRADA', 64,'Validacion')

         If Len(mvobs[1])>0 Or Len(mvobs[2])>0 Or Len(mvobs[3])>0 Or Len(mobserv)>0

            mRet = SQLExec(mCon1,"select id as lid from tabderivacion where usuario=?midusu and fechahora=?mfechor","mwkbusder")

            If mRet > 0
               If Used('mwkbusder')
                  Select mwkbusder
                  mid  = mwkbusder.lid
                  mpaso = (Reccount('mwkbusder')>0)
                  Use In mwkbusder
               Endif
            Else
               Messagebox("EN BUSQUEDA DE DERIVACION"+Chr(10)+ "PARA ASENTAR OBSERVACIONES",16,"ERROR")
            Endif
         Endif
         .cmdsave.Enabled = .F.
         msaveder = .T.
      Else
         Messagebox('ERROR EN EL INGRESO DE LA DERIVACION, AVISAR A SISTEMAS', 64,'Validacion')
      Endif

   Endif

   If .maltamodi = 2

      If !mthisform.lbloq

         mid  = mwkderiva1.Id
         mRet = SQLExec(mCon1,"select observa,estado,fechahora,usuario,codent from tabderivacion where id = ?mid","mwkbusderob")

         *!*		    miobserva = alltrim(nvl(mwkbusderob.observa,''))

         mesta = 100 + Iif(mwkbusderob.estado # mestado,mestado,99)
         mcambioos = ''
         If .lcambiaos
            mcambioos = 'codent = ?mcodent,'
            mobserv = mobserv +" Cambia OS " + Transf(mwkbusderob.codent)
         Endif
         mRet = SQLExec(mCon1, "update tabderivacion set diagnostico = ?mdiagno, habitacion= ?mcama, " + ;
            "observa = ?mobserv , estado = ?mestado, denpolicial = ?mdenupo, " + ;
            "padron = ?mpadron, notifica = ?mnoti, codint = ?mcodint, " + mcambioos +;
            "traslado = ?mtrasla, fechahoraingreso = ?mfhingr where id = ?mid")

         If mRet > 0
            mpaso = .T.
         Else
            Messagebox("EN ACTUALIZACION DE LA DERIVACION",16,"ERROR")
         Endif

         If !Empty(mobservant) And mtieneobs
            mestant = 199
            musuant = Alltrim(usuario)
            mfechant = fechahora
            mRet = SQLExec(mCon1,"insert into TabDerivaObs "+;
               "(TDO_idderiva,TDO_idusuario,TDO_fechamov,TDO_categoria,TDO_Observ) "+;
               "values (?mid,?musuant,?mfechant ,?mestant,?mobservant)")
         Endif
         If !(Empty(mobserv) And mesta=199)
            miobserva = Ttoc(mfeca)+', '+musua+' : '+ Alltrim(mobserv)
            mRet = SQLExec(mCon1,"insert into TabDerivaObs "+;
               "(TDO_idderiva,TDO_idusuario,TDO_fechamov,TDO_categoria,TDO_Observ) "+;
               "values (?mid,?musua,?mfeca,?mesta,?mobserv)")
            mpaso = .F.
         Endif

      Else

         mpaso = .T.
         mid   = mwkderiva1.Id

      Endif

   Endif

   If mpaso

      For mindi = 1 To Alen(mvobs)

         If Len(mvobs[mindi]) > 0
            mlobs = Ttoc(mfeca)+', '+musua+' : '+mvobs[mindi]
            mRet  = SQLExec(mCon1,"insert into TabDerivaObs "+;
               "(TDO_idderiva,TDO_Observ,TDO_idusuario,TDO_fechamov,TDO_categoria) "+;
               "values (?mid,?mlobs,?musua,?mfeca,?mindi)")
            If mRet < 0
               mpaso = .F.
               Messagebox("EN ACTUALIZACION DE OBSERVACIONES DE DERIVACION",16,"ERROR")
               Exit
            Endif
            With .PageObs
               Do Case
                  Case mindi = 1
                     .Page2.txtobsrechazo2.Value = .Page2.txtobsrechazo2.Value + mlobs
                     .Page2.txtobsrechazo1.Value = ''
                  Case mindi = 2
                     .Page3.txtobsdirmed2.Value  = .Page3.txtobsdirmed2.Value  + mlobs
                     .Page3.txtobsdirmed1.Value  = ''
               Endcase
            Endwith
         Endif

      Next mindi

      If Len(mobserv)>0
         mesta = 199
         mRet  = SQLExec(mCon1,"insert into TabDerivaObs "+;
            "(TDO_idderiva,TDO_idusuario,TDO_fechamov,TDO_categoria,TDO_Observ) "+;
            "values (?mid,?musua,?mfeca,?mesta,?mobserv)")
      Endif

   Endif

Endwith
Release mvobs
