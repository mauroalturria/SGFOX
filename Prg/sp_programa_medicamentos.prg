*!*
*!* Parametros para armar la descripcion.
*!*
Parameters midevol

*midevol = 334

*Set Step On

mfecpasiva = Ctod("01/01/1900")

Create Cursor mwkprograma (c1 T, c2 N(1), c3 M, c4 C(100))

For midtipo = 1 To 3

	Do Case
	Case midtipo = 1
		mleye = "Endovenoso Continuo"
	Case midtipo = 2
		mleye = "Endovenoso No Continuo"
	Case midtipo = 3
		mleye = "No Endovenoso"
	Endcase

*!*	1 Endovenoso Continuo      : PRINCIPAL c/VIAS + AGREGADOS
*!*	2 Endovenoso No Continuo   : PRINCIPAL c/VIAS + AGREGADOS + PLANIFICA
*!*	3 No Endovenoso            : PRINCIPAL c/VIAS + PLANIFICA

	Use In Select("mwksolprin")
	Use In Select("mwkagregad")
	Use In Select("mwkplanifi")

* ------------------------------------- Solución Principal (Endovenoso) / Insumo Principal (No Endovenoso) ------------------------------------------------------------------------------- *

	mret = SQLExec(mcon1,"select * from TabIntPmSolu"+;
		" where PS_idevol = ?midevol and PS_tipo = ?midtipo and PS_fecpasiva = ?mfecpasiva "+;
		" order by PS_fechormodif desc","mwksolprin")

	If mret < 0
		mltabla = "PRESCRIPCION MEDICA - SOLUCIONES PRINCIPALES - " + Upper(mleye)
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

* -------------------------------------- Agregados -------------------------------------------------------------------------------------------------------------------------------------- *

	mret = SQLExec(mcon1,"select * from TabIntPmAgre"+;
		" where PA_idevol = ?midevol and PA_tipo = ?midtipo and PA_fecpasiva = ?mfecpasiva"+;
		" order by PA_fechormodif desc","mwkagregad")

	If mret < 0
		mltabla = "PRESCRIPCION MEDICA - AGREGADOS - " + Upper(mleye)
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

*-------------------------------------- Planificación ---------------------------------------------------------------------------------------------------------------------------------- *

	mret = SQLExec(mcon1,"select * from TabIntPmPlan"+;
		" where PP_idevol = ?midevol and PP_tipo = ?midtipo and PP_fecpasiva = ?mfecpasiva"+;
		" order by PP_fechormodif desc","mwkplanifi")

	If mret < 0
		mltabla = "PRESCRIPCION MEDICA - PLANIFICACION - " + Upper(mleye)
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	If !Used("mwkIguia")
		Do sp_busco_estados With 25,' and tipo = 28  order by estado','mwkguias'
		Select Descrip As _guia, estado As _id From mwkguias Order By subestado Where estado <> 10 Into Cursor mwkIguia Readwrite
	Endif

	If !Used("mwkIvias")
		Create Cursor mwkIvias( _via C(13), _id N(6))
		Insert Into mwkIvias( _via, _id) Values (Space(10)   ,1)
		Insert Into mwkIvias( _via, _id) Values ('Periferica',2)
		Insert Into mwkIvias( _via, _id) Values ('Central   ',3)
	Endif

	Select mwksolprin
	Go Top
	Scan All
		mAgregados     = ""
		mevolPrinci1      = ""
		mEvolPrinci2      = ""
		mEvolPrinciNoEndo = ""
		mgoteo            = ""
		minicioyVia       = ""
    	mPlanificacion    = ""
		mPlanificacion2   = ""
		mEvol = ""
*		mfctrl = mwksolprin.ps_fechormodif
		If midtipo <> 3
			Select mwkIguia
			Go Top
			Locate For mwkIguia._id = mwksolprin.PS_guia
			If Found()
				mlidguia = mwkIguia._guia
			Endif
			mevolPrinci1 = ' GUIA: ' +  Alltrim(mlidguia) + Iif(!Empty(Nvl(mwksolprin.PS_baxter,""))," BAXTER : " + Alltrim(mwksolprin.PS_baxter),"")
		Endif
		mpv2 = mwksolprin.PS_insumo
		Do sp_busco_insumo_codigo With mpv2,,,'T'
		If Used("mwkinsumo")
			If Reccount("mwkinsumo")>0
				mdetalleins = mwkinsumo.INS_descriinsumo
			Endif
		Endif

		Select mwksolprin
		mEvolPrinci2 = " " + Alltrim(mdetalleins) + ' ' + Iif(midtipo<>3, Alltrim(Str(mwksolprin.PS_volumen)) + ' ML ', '' )

		If midtipo = 3   && solo si viene por NO ENDOVENOSO
			mEvolPrinciNoEndo = Iif( mwksolprin.ps_cantidad > 0, Alltrim(Str(mwksolprin.ps_cantidad)) ,'') + ' ' + Alltrim(mwksolprin.ps_unidad) + ' ' + Iif(mwksolprin.ps_cantpres > 0 ,Alltrim(Str(mwksolprin.ps_cantpres)),'') + ' ' + Alltrim(mwksolprin.ps_unipres)
		Endif

		mgoteo = ''

		If midtipo <> 3
			If mwksolprin.PS_goteo = 1
				mgoteo = ' (GOTEO LIBRE) '
			Else
				mgoteo  = ' (GOTEO) VOLUMEN: ' + Alltrim(Str(mwksolprin.PS_goteovol)) + ' ML' + ;
					', TIEMPO: ' + Alltrim(Str(mwksolprin.PS_goteotmp)) + Iif(mwksolprin.PS_goteotuni = 1," HORAS"," MINUTOS") +;
					', '+Alltrim(Str(mwksolprin.PS_goteogtsmin)) + Iif(mwksolprin.PS_goteomacmic = 1," MACROGOTAS"," MICROGOTAS") + " POR MINUTO"+;
					', '+Alltrim(Str(mwksolprin.PS_goteomlhr)) + ' MILILITROS POR HORA'
			Endif
		Endif

		If midtipo <> 3
			Select mwkIvias
			Go Top
			Locate For mwkIvias._id = mwksolprin.PS_via
			mvia =  mwkIvias._via
		Else
			Select mwkIvias3
			Go Top
			Locate For mwkIvias3._id = mwksolprin.PS_via
			mvia = mwkIvias3._via
		Endif

		mfctrl      = mwksolprin.PS_fechoraini
		minicioyVia = ' VIA ' + mvia + Iif(mwksolprin.PS_urgente=1, ' - URGENTE -', '')

		mb1 = mwksolprin.PS_guia
		mb2 = mwksolprin.ps_fechormodif

		If midtipo <> 3 && Agregados
			Use In Select("mwkagregad2")
			Select * From mwkagregad;
				WHERE mwkagregad.PA_guia = mb1 And mwkagregad.PA_fechormodif = mb2 ;
				INTO Cursor mwkagregad2

			mAgregados = " (AGREGADOS) "

			Select mwkagregad2
			Go Top

			Scan All
				mdetalleins = ""
				mpv2 = mwkagregad2.PA_insumo
				Do sp_busco_insumo_codigo With mpv2,,,'T'
				If Used("mwkinsumo")
					If Reccount("mwkinsumo")>0
						mdetalleins = mwkinsumo.INS_descriinsumo
					Endif
				Endif

				mAgregados = mAgregados + Alltrim(mdetalleins) + ' ' + Iif( mwkagregad2.PA_dosis > 0 , Alltrim(Str(mwkagregad2.PA_dosis)),'') + ' ' + Alltrim(mwkagregad2.PA_unidadvol) ;
					+ ' ' + Iif( mwkagregad2.PA_cantpres > 0 , Alltrim(Str(mwkagregad2.PA_cantpres)), '') + ' ' + Alltrim(mwkagregad2.PA_unipres) + ' ' + Alltrim(mwkagregad2.PA_comentarios) + Chr(13)
			Endscan
			Use In Select("mwkagregad2")
		Endif

		If midtipo > 1 && Planificacion
			Use In Select("mwkplanifi2")
			Select * From mwkplanifi ;
				WHERE mwkplanifi.PP_guia = mb1 And mwkplanifi.PP_fechormodif = mb2;
				INTO Cursor mwkplanifi2
			mPlanificacion = ""
			Select mwkplanifi2
			Go Top
			Scan All
				mPlanificacion = mPlanificacion + Alltrim(Str(mwkplanifi2.PP_dosis)) + ' ' + Alltrim(mwkplanifi2.PP_unidadvol) + ' ' +  mwkplanifi2.PP_urgente + Chr(13)
				mPlanificacion2 = mPlanificacion2 + Alltrim(mwkplanifi2.PP_frecuencia) + ' ' + Chr(13)					             
			ENDSCAN
			Use In Select("mwkplanifi2")
		Endif

		mEvol = mevolPrinci1 + CHR(10) + mEvolPrinci2 + CHR(10) + mEvolPrinciNoEndo + CHR(10) + mgoteo + CHR(10) + minicioyVia + CHR(10) + mAgregados + CHR(10) + mPlanificacion
  		Insert Into mwkprograma (c1, c2, c3, c4) VALUES (mfctrl, midtipo, mEvol, mPlanificacion2)
 
		Select mwksolprin

	Endscan

	Use In Select("mwksolprin")
	Use In Select("mwkagregad")
	Use In Select("mwkplanifi")

Endfor

*Select * From mwkprograma

Return .T.
