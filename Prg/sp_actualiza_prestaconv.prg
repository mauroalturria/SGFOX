**********************************************************************
* Program....: SP_ACTUALIZA_PRESTAPRECIOS.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 30 January 2020, 13:03:52
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: carmen porque tenia las bolas llenas de codigo inutil
* Purpose....:
**********************************************************************
*
Define Class PrestaPrecios As Custom

	nConexionSQL = 0								&& Contiene el Valor de conexion para las conuslta si se opto por conexion local
	lDisconnect = .F.
	llok = .T.
	dfechaServer = {}							&& Contiene la fecha del servidor
	oVismLib = .Null.  								&& Contiene el cubo Vism
	Procedure Init( )
	If !Used("mwkserver1")
		Do sp_conexion
		This.lDisconnect = .T.
	Endif
*mcon3 = SQLConnect("conec02")
	This.nConexionSQL = mCon1
	This.dfechaServer = sp_busco_fecha_serv('DT')

	This.oVismLib = Newobject('VISM.VisMCtrl.1')
	If Vartype( This.oVismLib ) == "O"     && Se pudo crear el objeto
	Else
		Wait Windows "Error. Vism Control no está instalado" Timeout 10
	Endif

	Endproc

***************************************************************************************************
*  Procedure : ArmaSetDatos
***************************************************************************************************
*
	Procedure ArmaSetDatos()

	If Used('mwkprestpres')
		Use In mwkprestpres
	Endif

	lcCMDSql = ''
	TEXT TO lcCMDSql TEXTMERGE NOSHOW PRETEXT 7
				   SELECT Prestacions.PRE_codprest,FecHorDbUpd  FROM PRESTACIONS LEFT JOIN Tabprestaprecios
				   ON PRE_codprest  = codigo
				 WHERE    ( pre_FechaPasiva IS NULL ) AND ( pre_AgendaTurnos =  'S' or
				 	PRE_codprest in (select codprest from GuardiaPrestacion where fechapasiva = '1900-01-01'  ))
				 	order by FecHorDbUpd  ,PRE_codprest
	ENDTEXT

*-- Ejecutamos la consulta al motor
*	If SQLExec( This.nConexionSQL , lcCMDSql, 'mwkPrestaciones') = 1
	lcCMDSql = ''
	TEXT TO lcCMDSql TEXTMERGE NOSHOW PRETEXT 7
		SELECT ID, PC_FechaVigHasta, PC_codent, PC_codprest
    		FROM Zabprestconvenio INNER JOIN Entidades ON  PC_codent = ENT_codent
			WHERE  PC_FechaVigHasta > { fn curdate()}  AND  Entidades.ENT_fecpas IS NULL
   			AND  PC_incluidaAMB = 2 and PC_codent=149 order by PC_codent,PC_codprest
	ENDTEXT

*-- Ejecutamos la consulta al motor
	If SQLExec( This.nConexionSQL , lcCMDSql, 'mwkconvenidas') = 1
	Else
		This.llok = .F.
	Endif

	Endproc


***************************************************************************************************
*  Procedure : ActualizaPrecios
***************************************************************************************************
*  Parameters  :
*  Description :   Procesa las prestaciones para conseguir los valores o precios
***************************************************************************************************
*
	Procedure ActualizaPrecios()

	mGraba		= '1'
	mFechasol	= Dtoc( Ttod( mwkFecServ.FechaHora ) )
	FechaHora = Datetime()
*-- Antes de empezar a buscar y reemplazar blanquemos los datos de precios
*	This.BlanqueoPrecios()

	Do sp_busco_estados With 8," and tipo =10 "
	Select mwkEstado
	Go Top
	Scan
		This.precio_pension(Val(Alltrim(mwkEstado.Descrip)))
	Endscan
	This.oVismLib.mServer   = Allt( mwkTabcfg.OLEServer )
	This.oVismLib.NameSpace = Allt( mwkTabcfg.OLESpaces )
*	This.SendMail( Time(), "INICIO DE PROCESO",1 )

*//////////////////////////////////////////////////////////
*   Proceso para los dos valores 1 = Privado y 2 = Carpeta SG  - * Solo sirve para mensaje de error
*//////////////////////////////////////////////////////////
	Select mwkPrestaciones
*!*		DO WHILE ISNULL(FecHorDbUpd)
*!*			SKIP 1
*!*		enddo
*!*		multupd =Ttod( Nvl(FecHorDbUpd,FechaHora))+1
	Set Step On
	mfecvac= Ctod("12/01/1900")
*!*		Locate For FecHorDbUpd>=multupd
*!*	  	If Eof() &&
	Go Top
*!*	  	ENDIF   && sacar para preciosap
	micuenta = 0
	Fecha = Dtoc( This.dfechaServer )
	Hora  = Ttoc( This.dfechaServer , 2 )

	ClaseEpisodio = "2"
	aseguradora = ''
	cobertura = "E"
	indmedicamento = " "
	cantidad = "1"
	Do While !Eof()
		lcodigopractica = ''
		lcimporteCobertura = ''
		lcimportePaciente =''
		lcpracticaSinCargo = ''
		lcpracticaConvenida = ''
		lnValorPrecio =0
		lnValorPrecio1 = 0
		lnValorPrecio2 = 0
		mnCodDia	  =  mwkPrestaciones.PRE_CodPrest
		mCodDia	  = Alltrim( Transf ( mnCodDia))
		If mnCodDia > 0
			mresp = prg_preciosap(11,mnCodDia,@lcimporteCobertura,@lcimportePaciente ,@lcpracticaSinCargo ,@lcpracticaConvenida )
			If !Empty(mresp ) And At("mensaje",MRESP)=0
				lnValorPrecio1 =  Val(Strtran(lcimportePaciente , '.', ',' ))
				lnValorPrecio2 =  Val(Strtran(lcimporteCobertura, '.', ',' ))
			Endif

			mret = SQLExec(mcon1,"SELECT PRE_codservicio,PRA_codprestasocia FROM Prestacions "+;
				"  left join Prestasocia on Prestasocia.PRA_PRESTACIONS = Prestacions.PRE_codprest " +;
				" WHERE  PRE_codprest = "+Transform(mnCodDia)	,"mwkservpres")
			Select mwkservpres
			Scan
				If Nvl(mwkservpres.PRA_codprestasocia,0)>0
					lcodigopractica = ''
					lcimporteCobertura = ''
					lcimportePaciente =''
					lcpracticaSinCargo = ''
					lcpracticaConvenida = ''
					mresp = prg_preciosap(11 ,mwkservpres.PRA_codprestasocia ,@lcimporteCobertura,@lcimportePaciente ,@lcpracticaSinCargo ,@lcpracticaConvenida )
					mresp = ''
					lnValorPrecio1 = lnValorPrecio1 + Val(Strtran(lcimportePaciente , '.', ',' ))
					lnValorPrecio2 = lnValorPrecio2 + Val(Strtran(lcimporteCobertura, '.', ',' ))
				Endif
			Endscan
*!*				Else
*!*					lnValorPrecio1 = Val(Strtran(lcimportePaciente , '.', ',' ))
*!*					lnValorPrecio2 =  Val(Strtran(lcimporteCobertura, '.', ',' ))

*!*				Endif
*!*				mret = SQLExec(mcon1,"SELECT PRI_PRESTACIONS, PRI_cantidad,PRI_codinsumo, INS_codinsumo,"+;
*!*					" INS_grupo, INS_tipo FROM Prestinsumo "+;
*!*					"INNER JOIN  Insumos ON  PRI_codinsumo = INS_codpuntero "+;
*!*					" WHERE  INS_fechapasivo IS NULL and PRI_PRESTACIONS = "+Transform(mnCodDia)	,"mwkservpres")
*!*				Select mwkservpres
*!*				Scan
*!*					If Nvl(mwkservpres.PRI_codinsumo,0)>0
*!*						codinsu = Iif(Inlist(mwkservpres.INS_grupo,"M","U","W"),"IM","ID")+Alltrim(Transform(mwkservpres.PRI_codinsumo))
*!*						lcodigopractica = ''
*!*						lcimporteCobertura = ''
*!*						lcimportePaciente =''
*!*						lcpracticaSinCargo = ''
*!*						lcpracticaConvenida = ''
*!*						mresp = prg_preciosap(11 ,codinsu  ,@lcimporteCobertura,@lcimportePaciente ,@lcpracticaSinCargo ,@lcpracticaConvenida )
*!*						mresp = ''
*!*						lnValorPrecio1 = lnValorPrecio1 + Val(Strtran(lcimportePaciente , '.', ',' ))
*!*						lnValorPrecio2 = lnValorPrecio2 + Val(Strtran(lcimporteCobertura, '.', ',' ))
*!*					Endif
*!*				Endscan

			If lnValorPrecio1 >0
				lnValorPrecio1 =   Alltrim(Transform(Round(lnValorPrecio1,2),"99999999.99"))
				lnValorPrecio2 =   Alltrim(Transform(Round(lnValorPrecio2,2),"99999999.99"))

			Else

				micuenta =micuenta +1
				If micuenta >100
					micuenta =0
					This.oVismLib.mServer = ""
					This.oVismLib.mServer   = Allt( mwkTabcfg.OLEServer )
					This.oVismLib.NameSpace = Allt( mwkTabcfg.OLESpaces )
				Endif
&& Alltrim(Transf  (.txtcodigo.Value))  		&& Codigo de prestacion

				idprestacion = mCodDia
				aseguradora = ''
				lnValorPreciogua = -1
				indprivado = 'X'
				indguardia = ' '
				indnormal = ' '
				mDetalle  = indmedicamento+ Chr(9) +idprestacion+ Chr(9) +cantidad+ Chr(9) +Fecha+ Chr(9) +Hora&&+ chr(1)
				mCabecera = ClaseEpisodio + Chr(9) +aseguradora + Chr(9) +indprivado+ Chr(9) +indguardia + Chr(9) +indnormal + Chr(9) +cobertura&&+ chr(1)
				This.oVismLib.Code = 'D PidoPrecio^ZSAPI015("' + mCabecera + '","' + mDetalle+ '")'
				This.oVismLib.ExecFlag = 1
				mmsgerr = This.oVismLib.ErrorName
				mok		= Alltrim( This.oVismLib.p0 )
				lnValorPrecio1 = "-1"
				If Len(mok) > 1 Or !Empty(mmsgerr)
					Do sp_insert_tabCtrlErr With This.oVismLib.Code, mmsgerr , 'CFUNES', 'Preciosap'
				Else
					mNroItem = 0
					Do Prg_Separo_Datos_91 With This.oVismLib.p3, 4, mNroItem
					lnValorPrecio =  Val(Strtran(vec_vale(1,2), '.', ',' )	)
					lnValorPrecio1 =  Alltrim(Transform(Round(lnValorPrecio/1.21,2),"99999999.99"))
				Endif
*	If Val(lnValorPrecio1)>0
				lnValorPrecio2 = Alltrim(Transform( Round(Val(lnValorPrecio1)/1.15,3),"99999999.999"))
*	Else
				aseguradora = '11'  &&898
				indprivado = ' '
				indguardia = ' '
				indnormal = 'X'
				mCabecera = ClaseEpisodio + Chr(9) +aseguradora + Chr(9) +indprivado+ Chr(9) +indguardia + Chr(9) +indnormal + Chr(9) +cobertura&&+ chr(1)
				This.oVismLib.Code = 'D PidoPrecio^ZSAPI015("' + mCabecera + '","' + mDetalle+ '")'
				This.oVismLib.ExecFlag = 1
				mmsgerr = This.oVismLib.ErrorName
				mok		= Alltrim( This.oVismLib.p0 )
*		lnValorPrecio2 = "-1"
				If Len( mok ) > 1 Or !Empty( mmsgerr )
					Do sp_insert_tabCtrlErr With This.oVismLib.Code, mmsgerr , 'CFUNES', 'Preciosap'
				Else
					mNroItem = 0
					Do Prg_Separo_Datos_91 With This.oVismLib.p3, 4, mNroItem
					lnValorPrecio =  Val(Strtran(vec_vale(1,2), '.', ',' )	)
					If lnValorPrecio >0
						lnValorPrecio2 =   Alltrim(Transform(Round(lnValorPrecio,2),"99999999.99"))
					Endif
*	Endif
					If Val(lnValorPrecio1)<=0
						lnValorPrecio1 = Alltrim(Transform(Round(Val(lnValorPrecio2)*1.15,3),"99999999.999"))
					Endif


				Endif
			Endif
			mihora = sp_busco_fecha_serv("DT")
			mReturn = SQLExec(mCon1, "select id from TabPrestaPrecios WHERE TabPrestaPrecios.Codigo = ?mnCodDia ",'mwkctrlprest')
			mid = mwkctrlprest.Id
			Strtofile( Ttoc( mihora )+" - "+Transform(mnCodDia )+Chr(9)+Transform(lnValorPrecio1) +Chr(13)+Chr(10),"PrestaPrecios.txt",1)

			If mid=0
				mReturn = SQLExec(mCon1, "insert into TabPrestaPrecios (Codigo,Precio1,Precio2 ) "+;
					" values ( ?mnCodDia,?lnValorPrecio1,?lnValorPrecio2    )")
			Else
				mReturn = SQLExec(mCon1, "UPDATE TabPrestaPrecios SET Precio1 = ?lnValorPrecio1,Precio2 = ?lnValorPrecio2 "+;
					",FecHorDbUpd = ?mihora  WHERE id  = ?mid  ")
			Endif
		Endif
		Select mwkPrestaciones
		Skip 1
	Enddo
	This.SendMail( Time(), "FIN DE PROCESO",1 )
	Select  mwkconvenidas
*ID, PC_FechaVigHasta, PC_codent, PC_codprest
	micuenta = 0
	Fecha = Dtoc( This.dfechaServer )
	Hora  = Ttoc( This.dfechaServer , 2 )


	Scan


		lcodigopractica = ''
		lcimporteCobertura = ''
		lcimportePaciente =''
		lcpracticaSinCargo = ''
		lcpracticaConvenida = ''
		lnValorPrecio =0
		lnValorPrecio1 = 0
		lnValorPrecio2 = 0
		aseguradora =  mwkconvenidas.PC_codent
		mnCodDia	  =  mwkconvenidas.PC_codprest
		mCodDia	  = Alltrim( Transf ( mnCodDia))
		If mnCodDia > 0
			mresp = prg_preciosap(aseguradora ,mnCodDia,@lcimporteCobertura,@lcimportePaciente ,@lcpracticaSinCargo ,@lcpracticaConvenida )
			If  Empty(lcpracticaConvenida) And At("mensaje",MRESP)=0
				Loop
			Else
				mid = mwkconvenidas.Id
				mret = SQLExec(mcon1,"update Zabprestconvenio  set PC_FechaVigHasta = {fn curdate()} " +;
					" WHERE  id = "+Transform(mid)	,"mwkservpres")

			Endif
		Endif
	Endscan
	This.oVismLib.mServer = ""

	This.Unload()
	Endproc

***************************************************************************************************
*  Procedure : BlanqueoPrecios
***************************************************************************************************
*  Parameters  :
*  Description :  Antes de cargar los valores de precios a las prestaciones las elimino a todas de la tabla
***************************************************************************************************
*
	Procedure BlanqueoPrecios()

*-- Eliminacion de datos de Precios
*	mReturn = SQLExec(This.nConexionSQL, "UPDATE TabPrestaPrecios SET   TabPrestaPrecios.Precio1 = '' , TabPrestaprecios.Precio2 = ''  ")
*       mReturn = SQLExec(This.nConexionSQL, "Update TabUsuario set IdUsuario = UPPER( idUsuario )")


	Endproc

***************************************************************************************************
*  Procedure : SendMail



***************************************************************************************************
*  Procedure : SendMail
***************************************************************************************************
*  Parameters  :
*  Description :   Envia mails de procesamiento de datos
***************************************************************************************************
*
	Procedure SendMail( MiCod, MiPrest, MiEnti )
* Lparameters micod,miprest,mienti

	mfecha = This.dfechaServer 								&& Date()
	sinask = .T.
	mresp = 6

	mAsunto    = "Valor SAP "
	mResponder = "noreplyturnos@silver-cross.com.ar"
	MemoMail   = "Prestacion:" +  Transform( MiCod ) +" - "+ MiPrest + Chr(13)
	MemoMail   = MemoMail + "Entidad/contrato:" +  Transform(MiEnti ) + Chr(13)
* mRecibe    = "sdobry@silver-cross.com.ar"
	mRecibe    = 'calvarez@sg.com.ar'
	MiMensaje  = 'D SEND^%ZMAIL("' + mRecibe + '","' + mAsunto + '","' + MemoMail + '","","","","' + mResponder +'",1 )'  &&

	This.oVismLib.Code = MiMensaje
	This.oVismLib.ExecFlag = 1

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
		Do sp_Desconexion
*!*			mcon1 = mcon3
*!*			Do sp_Desconexion
&& WITH thisform.name
	Endif
	This.oVismLib.mServer = ""

	Endproc




	Procedure precio_pension(MiCod)
	If myip = '172.16.1.7'
		Set Step On
	Endif
	mnCodDia = MiCod
	mCodDia		= Alltrim(Transf(MiCod))  && Codigo de prestacion
	mfhoy = Ttod(mwkFecServ.FechaHora)
	This.oVismLib.mServer   = Allt( mwkTabcfg.OLEServer )
	This.oVismLib.NameSpace = Allt( mwkTabcfg.OLESpaces )
	ClaseEpisodio = "1"
	aseguradora = ' '
	mcodent = 11
	indprivado = 'X'
	indguardia = ' '
	indnormal = ' '
	cobertura = "E"
	indmedicamento = " "
	idprestacion = mCodDia
	cantidad = "1"
	Fecha = Dtoc(mfhoy)
	lnValorPrecio2 ='-1'
	lnValorPrecio1 = '-1'
	Hora = Ttoc(mwkFecServ.FechaHora,2)
	mCabecera= ClaseEpisodio+ Chr(9) +aseguradora+ Chr(9) +indprivado+ Chr(9) +indguardia + Chr(9) +indnormal + Chr(9) +cobertura&&+ chr(1)
	mDetalle = indmedicamento+ Chr(9) +idprestacion+ Chr(9) +cantidad+ Chr(9) +Fecha+ Chr(9) +Hora&&+ chr(1)
	This.oVismLib.Code = 'D PidoPrecio^ZSAPI015("' + mCabecera + '","' + mDetalle+ '")'
	This.oVismLib.ExecFlag = 1
	mmsgerr = This.oVismLib.ErrorName
	mok		= Alltrim( This.oVismLib.p0 )

	If Len( mok ) > 1 Or !Empty( mmsgerr )
		Do sp_insert_tabCtrlErr With This.oVismLib.Code, mmsgerr , 'CFUNES', 'Preciosap'
	Else
		mNroItem = 0
		Do Prg_Separo_Datos_91 With This.oVismLib.p3, 4, mNroItem
		valor = Val(Strtran(vec_vale(1,2), '.', ','))/1.21
		lnValorPrecio2 = Alltrim(Transform(valor ))
		lnValorPrecio1 = lnValorPrecio2
		mihora = sp_busco_fecha_serv("DT")
		mReturn = SQLExec(mCon1, "select id from TabPrestaPrecios WHERE TabPrestaPrecios.Codigo = ?mnCodDia ",'mwkctrlprest')
		mid = mwkctrlprest.Id
		Strtofile( Ttoc( mihora )+" - "+Transform(mnCodDia )+Chr(9)+lnValorPrecio1 +Chr(13)+Chr(10),"PrestaPrecios.txt",1)
		If Val(lnValorPrecio1)>0
			If mid=0
				mReturn = SQLExec(mCon1, "insert into TabPrestaPrecios (Codigo,Precio1,Precio2 ) "+;
					" values ( ?mnCodDia,?lnValorPrecio1,?lnValorPrecio2    )")
			Else
				mReturn = SQLExec(mCon1, "UPDATE TabPrestaPrecios SET Precio1 = ?lnValorPrecio1,Precio2 = ?lnValorPrecio2 "+;
					",FecHorDbUpd = ?mihora  WHERE id  = ?mid  ")
			Endif
		Endif
	Endif
	This.oVismLib.mServer = ""

	Endproc

Enddefine
