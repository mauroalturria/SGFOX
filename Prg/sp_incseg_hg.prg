*
* Incidente de Seguridad (Seguridad e Higiene) - Registro / Actualización de datos
*
Parameters mformp, mformhg

*Set Step On

mlidinc = mformp.idincidente

muser = Iif(Used("mwkusuarios"),mwkusuarios.idusuario,mwkusuario.idusuario)

mfech   = sp_busco_fecha_serv("DT")

*mretr   = .T.

*!* ZabISegHig

*!*	// Involucrar Seguridad e Higiene
*!*	ZIS_invseghig ];

*!*	// Respuesta Seguridad e Higiene
*!*	ZIS_respseghig ];

*!*	// Involucrar Legales
*!*	ZIS_invlegales ];

*!*	// Respuesta Legales
*!*	ZIS_respleg ];

*!*	// Derivar mantenimiento
*!*	ZIS_derivamant ];

*!*	// Registracion
*!*	ZIS_nroregistrac ];

*!*	// Estado S&H
*!*	ZIS_estadosh ];

*!*	// Estado Legales
*!*	ZIS_estadolg ];

*-- De el Gripo de Paginas Principales
With mformhg.PagPrin

   *-- Antes    Dimension datos[50]
   Dimension Datos[52]

   With .Page1.PageFrame1 && Datos 1

      With .Page1 && Ampliación del suceso
         Datos[1] = .optsuceso.Value
         Datos[2] = Alltrim(.txtdes.Value) && Actualizar el maestro
         Datos[3] = .opttipo.Value
         mtipoin  = .opttipo.Value
         Datos[51] = .txtNroMantenimiento.Value
         Datos[52] = .optReq_Intervencion.Value
      Endwith

      *		Do Case
      *		Case mtipoin = 1 && Visitante involucrado

      With .Page3 && Visitante

         Datos[4] = Nvl(.txtdocu.Value,0)
         Datos[5] = Nvl(.txtapenom.Value,'')
         Datos[6] = Nvl(.cbogenero.Value,'')
         Datos[7] = Nvl(.combo7.Value,'') &&elementos
         Datos[8] = Nvl(.txtelemento.Value,'')
         Datos[45] = Iif(.txtfecnac.Value = {//}, Null, .txtfecnac.Value )

      Endwith

      *		Case mtipoin = 2 && Empleado involucrado

      With .Page2 && Empleado

         Datos[9]  = Nvl(.txtfinf.Value,0) && Legajo
         Datos[10] = Nvl(.txtapenom.Value,'')
         Datos[11] = Iif(mtipoin=2,mwkturno.lid,0)
         Datos[12] = Iif(mtipoin=2,mwkpuesto.orden,0)
         Datos[13] = Iif(mtipoin=2,mwkanti.lid,0)
         Datos[14] = Nvl(.combo5.Value,'')
         Datos[15] = Nvl(.combo6.Value,'')
         Datos[16] = Nvl(.combo7.Value,'')
         Datos[17] = Nvl(.txtelemento.Value,'')
         Datos[18] = Nvl(.txtprocedi.Value,'')
         **datos[19] = Nvl(.combo8.Value,'')
         Datos[19] = mwkProteccion.lid
         Datos[20] = Iif(mtipoin=2,mwkzona.orden,0)  && Cuerpo
         Datos[21] = .optfluido.Value
         Datos[22] = Iif(mtipoin=2,mwkExposicion.orden,0) && Exposición
         Datos[46] = Nvl(.OptEmpresa.Value,0)
         Datos[47] = Nvl(.txtproteccion.Value,'')
         Datos[48] = .optaccidente.Value
         Datos[49] = .txtdni.Value
         Datos[50] = Alltrim(.txttelcontacto.Value)

      Endwith

      *		Endcase

   Endwith

   With .Page2 && Datos 2


      */////////////// mformhg <- Formulario Principal


      *!*	      datos[23] = .opt1.Value
      *!*	      datos[24] = .opt2.Value
      *!*	      datos[25] = .opt3.Value
      *!*	      datos[26] = .opt4.Value
      *!*	      datos[27] = .opt5.Value
      *!*	      datos[28] = .opt6.Value
      *!*	      datos[29] = .opt7.Value

      *//////////////////////////////

      Datos[23] = mformhg.optPersona.Value   					&& .opt1.Value
      Datos[24] = mformhg.optPacientes.Value 					&& .opt2.Value
      Datos[25] = mformhg.optLegal.Value     					&& .opt3.Value
      Datos[26] = mformhg.optMedioAmbiente.Value 				&& .opt4.Value
      Datos[27] = mformhg.optGestionOperacional.Value  			&& .opt5.Value
      Datos[28] = mformhg.optComunidad.Value 					&& .opt6.Value
      Datos[29] = mformhg.optSanatorioEdificio.Value  			&& .opt7.Value

      *//////////////////////////////

      Datos[30] = .optpersonas.Value
      Datos[31] = .optmedio.Value
      Datos[32] = .optrespleg.Value

      *!*	   Endwith

      *!*	   With .Page3 && Datos 3

      *!*	      datos[33] = .opt1.Value
      *!*	      datos[34] = .opt2.Value
      *!*	      datos[35] = .opt3.Value
      *!*	      datos[36] = .opt4.Value
      *!*	      datos[37] = .opt5.Value

* Thisform.pagPrin.page1.pageframe1.page1

      Datos[33] = mformhg.optrara.Value 
      Datos[34] = mformhg.optPocoProbable.Value
      Datos[35] = mformhg.optPosible.Value
      Datos[36] = mformhg.optProbable.Value
      Datos[37] = mformhg.optCasiCierta.Value

      Datos[38] = .optpublico.Value
      Datos[39] = .optgestion.Value
      Datos[40] = .optcomuna.Value

   Endwith

   *-- Pagina Tres
   With .Page3

      If .combo1.DisplayValue = ''
         mestado = 5 && Pendiente
      Else
         mestado = mwkestado41.lid  &&.combo1.Value
      Endif

      Datos[41] = mestado
      Datos[42] = .optinvolucra.Value
      Datos[43] = .optinvestiga.Value
      Datos[44] = Nvl(Alltrim(.txtdes.Value),'')

   Endwith

Endwith

*!*	// ID Incidente : maestro User.ZabISeg
*!*	// Tipo : sugerencia, incidente, etc.
*!*	// Involucra (0: Cerrar -nada p/el momento- 1: Visitante, 2: Empleado)
*!*	// Visitante documento
*!*	// Visitante : Nombre
*!*	// Visitante Genero Masculino, Femenino
*!*	// Visitante Fecha Nac.
*!*	// Visitante : Elemento Involucrado
*!*	// Visitante : Elemento que causo accidente
*!*	// Empleado : Elemento Involucrado
*!*	// Empleado : Elemento que causo accidente
*!*	// Empleado Legajo
*!*	// Empleado : Nombre
*!*	// Empleado Turno
*!*	// Empleado Puesto
*!*	// Empleado Antiguedad
*!*	// Empleado Tareas Habitual
*!*	// Empleado Horas Extras
*!*	// Empleado Procedimiento
*!*	// Empleado Protección
*!*	// Empleado Nro. Cuerpo
*!*	// Empleado Exp. fluidos
*!*	// Empleado Exposición detalle
*!*	//- Option's Nivel de Gravedad Real o Potencial

*!*	// Persona / empleado
*!*	// Paciente / Publico
*!*	// Responsabilidad Legal
*!*	// Medio Ambiente
*!*	// Gestion Operacional
*!*	// Comunidad
*!*	// Sanatorio - Edificio
*!*	// Personas Tipo

*!*	// Medio Ambiente Tipo
*!*	// Responsabilidad Legal Tipo
*!*	-// Option's Nivel de Gravedad Consecuencias
*!*	// Rara
*!*	// Poco probable
*!*	// Posible
*!*	// Probable
*!*	// Casi cierta
*!*	// Consecuencias, Publico - Autoridades - Tipo
*!*	// Consecuencias, Gestion Operacional - Tipo
*!*	// Consecuencias, Comunidad - Tipo
*!*	// Involucra Legales - Deriva Mantenimiento
*!*	// Corresponde Investigación
*!*	// Texto Investigacion
*!*	// Identificador de Intervencion de Mantenimiento -> Zabiseghig.ZSH_IDIntervMant,;
*!*	// Requiere Intervencion de Mantenimiento si/no -> Zabiseghig.ZSH_ReqIntervMant,

*ZabISegHig

Use In Select("mwkdSegHig")

mret = SQLExec(mcon1,"select id as lid from ZabISegHig where ZSH_idinciden = ?mlidinc","mwkdSegHig")

If mret < 0
   =Aerr(eros)
   mmsgerr = eros(3)
   mdetalle= "BUSQUEDA DE REGISTRO SEGURIDAD E HIGIENE"
   Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , muser, "Log Incidente Seguridad"
   Messagebox("Busqueda Incidente de Seguridad", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
   Return .F.
Endif

** Pasar este dato como parametro ahora busca para evaluar insert o update
mmov = .T.
If Used("mwkdSegHig")
   If Reccount("mwkdSegHig")>0
      mmov = .F.
   Endif
Endif

Use In Select("mwkdSegHig")

If mmov
   mdetalle = Ttoc(mfech) + ' : ' + 'REGISTRO DE INCIDENTE, SEGURIDAD E HIGIENE '

   mret = SQLExec(mcon1,"INSERT INTO ZabISegHig (ZSH_idinciden, "+;
      "ZSH_tipo,ZSH_tinvolucra,ZSH_vdocumento,ZSH_vapenom,ZSH_vgenero,ZSH_vfecnac," +;
      "ZSH_veleinv,ZSH_velecacc,ZSH_elegajo,ZSH_eapenom,ZSH_eturno,ZSH_epuesto,ZSH_eantigu,ZSH_etarhab,"+;
      "ZSH_ehorextra,ZSH_eeleinv,ZSH_eelecacc,ZSH_eproced,ZSH_eprotec,ZSH_enrocuerpo,ZSH_expfluidos,ZSH_exposicion,"+;
      "ZSH_operemp,ZSH_opacpub,ZSH_orespleg,ZSH_omedamb,ZSH_ogesocu,ZSH_ocomunidad,ZSH_osanedif,ZSH_otpersonas,"+;
      "ZSH_otmedioamb,ZSH_otrespleg,ZSH_orara,ZSH_opprobable,ZSH_oposible,ZSH_oprobable,ZSH_ocasicierta,"+;
      "ZSH_ocnpubauto,ZSH_ocngesope,ZSH_ocncomunidad,ZSH_oinvlegmant,ZSH_investiga,ZSH_detinves,ZSH_eprotecOtros,ZSH_eOrigEmp,"+;
      "ZSH_eTipAccidente, ZSH_eDniEmp, ZSH_eTelEmp , ZSH_IDIntervMant, ZSH_ReqIntervMant ) "+;
      "VALUES    (?mlidinc,?datos[1],?datos[3],?datos[4],?datos[5],?datos[6],?datos[45],?datos[7],?datos[8],?datos[9],?datos[10],?datos[11],"+;
      "?datos[12],?datos[13],?datos[14],?datos[15],?datos[16],?datos[17],?datos[18],?datos[19],?datos[20],?datos[21],?datos[22],"+;
      "?datos[23],?datos[24],?datos[25],?datos[26],?datos[27],?datos[28],?datos[29],?datos[30],?datos[31],?datos[32],?datos[33],"+;
      "?datos[34],?datos[35],?datos[36],?datos[37],?datos[38],?datos[39],?datos[40],?datos[42],?datos[43],?datos[44],?datos[47],?datos[46],"+;
      "?datos[48],?datos[49],?datos[50],?datos[51],?datos[52] )" )

   If mret < 0
      =Aerr(eros)
      mmsgerr = eros(3)
      mdetalle= "ACTUALIZACION MAESTRO SEGURIDAD E HIGIENE"
      Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , muser, "Log Incidente Seguridad"
      Messagebox("Grabación Incidente de Seguridad", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
      Return .F.

   ELSE
   
   Endif

Else

   mdetalle = Ttoc(mfech) + ' : ' + 'ACTUALIZACION DE INCIDENTE, SEGURIDAD E HIGIENE '

   mret = SQLExec(mcon1,"update ZabISegHig set "+;
      "ZSH_tipo         = ?datos[1],"+;
      "ZSH_tinvolucra   = ?datos[3],"+;
      "ZSH_vdocumento   = ?datos[4],"+;
      "ZSH_vapenom      = ?datos[5],"+;
      "ZSH_vgenero      = ?datos[6],"+;
      "ZSH_vfecnac      = ?datos[45],"+;
      "ZSH_veleinv      = ?datos[7],"+;
      "ZSH_velecacc     = ?datos[8],"+;
      "ZSH_elegajo      = ?datos[9],"+;
      "ZSH_eapenom      = ?datos[10],"+;
      "ZSH_eturno       = ?datos[11],"+;
      "ZSH_epuesto      = ?datos[12],"+;
      "ZSH_eantigu      = ?datos[13],"+;
      "ZSH_etarhab      = ?datos[14],"+;
      "ZSH_ehorextra    = ?datos[15],"+;
      "ZSH_eeleinv      = ?datos[16],"+;
      "ZSH_eelecacc     = ?datos[17],"+;
      "ZSH_eproced      = ?datos[18],"+;
      "ZSH_eprotec      = ?datos[19],"+;
      "ZSH_enrocuerpo   = ?datos[20],"+;
      "ZSH_expfluidos   = ?datos[21],"+;
      "ZSH_exposicion   = ?datos[22],"+;
      "ZSH_operemp      = ?datos[23],"+;
      "ZSH_opacpub      = ?datos[24],"+;
      "ZSH_orespleg     = ?datos[25],"+;
      "ZSH_omedamb      = ?datos[26],"+;
      "ZSH_ogesocu      = ?datos[27],"+;
      "ZSH_ocomunidad   = ?datos[28],"+;
      "ZSH_osanedif     = ?datos[29],"+;
      "ZSH_otpersonas   = ?datos[30],"+;
      "ZSH_otmedioamb   = ?datos[31],"+;
      "ZSH_otrespleg    = ?datos[32],"+;
      "ZSH_orara        = ?datos[33],"+;
      "ZSH_opprobable   = ?datos[34],"+;
      "ZSH_oposible     = ?datos[35],"+;
      "ZSH_oprobable    = ?datos[36],"+;
      "ZSH_ocasicierta  = ?datos[37],"+;
      "ZSH_ocnpubauto   = ?datos[38],"+;
      "ZSH_ocngesope    = ?datos[39],"+;
      "ZSH_ocncomunidad = ?datos[40],"+;
      "ZSH_oinvlegmant  = ?datos[42],"+;
      "ZSH_investiga    = ?datos[43],"+;
      "ZSH_detinves     = ?datos[44],"+;
      "ZSH_eprotecOtros = ?datos[47],"+;
      "ZSH_eOrigEmp     = ?datos[46],"+;
      "ZSH_eTipAccidente = ?datos[48],"+;
      "ZSH_eDniEmp      = ?datos[49],"+;
      "ZSH_eTelEmp      = ?datos[50], "+;
      "ZSH_IDIntervMant  = ?datos[51], "+;
      "ZSH_ReqIntervMant = ?datos[52] "+;
      " WHERE ZSH_idinciden = ?mlidinc")

   If mret < 0
      =Aerr(eros)
      mmsgerr = eros(3)
      mdetalle= "ACTUALIZACION MAESTRO SEGURIDAD E HIGIENE"
      Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , muser, "Log Incidente Seguridad"
      Messagebox("Grabación Incidente de Seguridad", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
      Return .F.
   
   Else

   Endif

Endif

*!* Seguridad e Higiene Medidas Correctivas

If Used("mwklegdatp4")

   If Reccount("mwklegdatp4")>0

      mret = SQLExec(mcon1,"delete from ZabISegHigMedidas where ZSM_idinciden = ?mlidinc")
      If mret < 0
         =Aerr(eros)
         mmsgerr = eros(3)
         mdetalle= "ACTUALIZACION MAESTRO SEGURIDAD E HIGIENE"
         Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , muser, "Log Incidente Seguridad"
         Messagebox("Busqueda Incidente de Seguridad", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
         Return .F.
         *//////////
         Sqlrollback( mcon1 )
         *//////////
      Else
         *////////// Termino la transaccion
         Sqlcommit( mcon1 )
         *///////////
      Endif

   Endif

   *!*	 mwklegdatp4 (cmed C(100), cresp C(50), cplazo C(30), cestado C(10), cestadon N(1))
   *!*	 ID Incidente : maestro User.ZabISeg
   *!*	 Medidas Correctivas
   *!*	 Responsable
   *!*	 Plazo
   *!*	 Estado

   Select mwklegdatp4
   Go Top
   Scan All

      md1 = Alltrim(mwklegdatp4.cmed)
      md2 = Alltrim(mwklegdatp4.cresp)
      md3 = Alltrim(mwklegdatp4.cplazo)
      md4 = mwklegdatp4.cestadon

      mret = SQLExec(mcon1,"insert into ZabISegHigMedidas (ZSM_idinciden, ZSM_medcorrec, ZSM_responsable, ZSM_plazo, ZSM_estado)"+;
         " values (?mlidinc, ?md1, ?md2, ?md3, ?md4)")

      If mret < 0
         =Aerr(eros)
         mmsgerr = eros(3)
         mdetalle= "REGISTRO DE MEDIDAS CORRECTIVAS"
         Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , muser, "Log Incidente Seguridad"
         Messagebox("Registro de Medidas Correctivas", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
         Return .F.
         *//////////
         Sqlrollback( mcon1 )
         *//////////
      Else
         *////////// Termino la transaccion
         Sqlcommit( mcon1 )
         *///////////
      Endif

   Endscan

Endif


*!*	// Involucrar Seguridad e Higiene
*!*	ZIS_invseghig ];

*!*	// Respuesta Seguridad e Higiene
*!*	ZIS_respseghig ];

*!*	// Involucrar Legales
*!*	ZIS_invlegales ];

*!*	// Respuesta Legales
*!*	ZIS_respleg ];

*!*	// Derivar mantenimiento
*!*	ZIS_derivamant ];

*!*	// Registracion
*!*	ZIS_nroregistrac ];

*!*	// Estado S&H
*!*	ZIS_estadosh ];

*!*	// Estado Legales
*!*	ZIS_estadolg ];


mretr = .T.

mret = SQLExec(mcon1,"update ZabISeg set "+;
   "ZIS_invseghig    = ?datos[43],"+;
   "ZIS_invlegmant   = ?datos[42],"+;
   "ZIS_estadosh     = ?datos[41],"+;
   "ZIS_logmov       = ZIS_logmov + ?mdetalle ," +;
   "ZIS_descripcion  = ?datos[2]," +;
   "ZIS_idusuario    = ?muser, "+;
   "ZIS_fecmov       = ?mfech "+;
   "where id = ?mlidinc")

If mret < 0
   =Aerr(eros)
   mmsgerr = eros(3)
   mdetalle= "ACTUALIZACION MAESTRO INCIDENTE DE SEGURIDAD"
   Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , muser, "Log Incidente Seguridad"
   Messagebox("Actualización Incidente de Seguridad", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
   mretr = .F.

Else

endif

Return mretr
