** Clase CONFIGURACION.

Define Class CONFIGURACION As Custom

	pAmbito       = 0
	pLogoRep1     = ""
	pPathImagenes = ""
	pPathDefault  = "c:\temp\imagenes\"
	pAplicacion   = ""
	ldesconecto = .F.

*--------------------
	Procedure SetCentro
	Lparameters mAplicacion    &&numero de centro y nombre de Aplicacion

	This.pAplicacion = Iif(Vartype(mAplicacion) <> "C","",mAplicacion)

&&Path de imagenes temporales.
	This.pPathImagenes = Iif(Vartype(mPathImagenes) <> "C",This.pPathDefault,mPathImagenes)


** Borramos archivos temporales
**This.RemoveFiles

	If This.ConSRV()

** Leemos el archivo .INI para buscar el AMBITO.
		This.CargaIni()


**If Upper(This.pAplicacion) == "TURNOS"    &&Solo cuando es TURNOS

**Obtener los registros de la tabla de Configuracion.
		mret = SQLExec(mCon1,"select * from tabconfigura where TBC_centro = " + Alltrim(Str(This.pAmbito)),"mwkConfig")

		If mret<=0
			Messagebox("ERROR EN LA LECTURA DE PROTOCOLOS",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

**Cargar las propiedades con los valores de registro.
		Select mwkConfig
		Go Top

		Scan All

**Creamos la propiedad con el nombre del campo (PROTECTED)
			cValor = ""
			Do Case
				Case mwkConfig.TBC_Tipo == "C"   &&Cadena
					cValor = Alltrim(mwkConfig.TBC_valor)
				Case mwkConfig.TBC_Tipo == "I"   &&Imagen
**Volcamos el contenido del campo binario a un archivo JPG.
					cValor = This.loadimage(Alltrim(mwkConfig.TBC_concepto), "_" + Transform(mwkConfig.Id))
			Endcase


**This.AddProperty("p"+Upper(Alltrim(mwkConfig.TBCConcepto)),Alltrim(mwkConfig.TBCDescripcion))
			This.AddProperty("p"+Upper(Alltrim(mwkConfig.TBC_concepto)),Alltrim(cValor))

		Endscan
**ELSE  &&Si no es Turnos, cargamos los valores por defecto.
**	This.SetDefault()
**ENDIF

	Endif

	Use In Select("mwkCentro")
	Use In Select("mwkConfig")
	If ldesconecto
		Do sp_desconexion With "sp_conf_class"
		ldesconecto = .F.
	Endif

	Return .T.

	Endproc


*--------------------
** Establecemos valores por defecto.
	Procedure SetDefault


	This.pAmbito = 1
	This.AddProperty("pNombre_Centro","Sanatorio Güemes")
	This.AddProperty("pMail_Centro","info@silver-cross.com")
	This.AddProperty("pTelef_centro","1111-1111")
	This.AddProperty("pDire_Centro","Av.Cordoba 3900")
	This.AddProperty("pLogo_Centro","c:\desaguemes\bmp\2.jpg")
	This.AddProperty("pLogo_Rep1","")
	This.AddProperty("pFondo_Centro","c:\qepd1a1\solo_marca.jpg")
	This.AddProperty("pFondo_Centro2","c:\qepd1a1\solo_marca2.jpg")
	This.AddProperty("ptt_leyenda1","")
	This.AddProperty("ptt_leyenda2","")
	This.AddProperty("ptt_leyenda3","")


	Endproc


*--------------------
	Procedure ConSRV
*!*		If !Used("mwkusuario")
*!*			Return .F.
*!*		Endif
	If !Used("mwkserver1")
		Do sp_conexion
		ldesconecto = .T.
	Endif
	Return .T.

	Endproc


** Devolvemos el valor de la propiedad, si esta existe. Sino un valor en blanco.
*--------------------
	Procedure GetValue(strNombreProp)

	Local nPos
	Local xbloque
	Local gaPropArray[1]

	strNombreProp = Upper(strNombreProp)

	=Amembers(gaPropArray, This, 1)
	nPos = Ascan(gaPropArray, strNombreProp)
	nPos = 1

	If nPos > 0
** 		Devolvemos valor
		xbloque = "this."+ strNombreProp
		Return &xbloque
	Else
** 		Devolvemos blanco.
		Return ""
	Endif

	Endproc


*--------------------
	Procedure loadimage(cPropImage, lcAdic)

	Local cFiledb

**cFiledb = This.pPathImagenes + Padl(Round(10000 * Rand(),0),5,"0")
	cFiledb = This.pPathImagenes + Alltrim(cPropImage) + lcAdic

	If Used('ima')
		Use In ima
	Endif

	If Used('__DATA')
		Use In __DATA
	Endif

	Use In Select(cFiledb)

	Select TBC_Foto As foto From mwkConfig Where TBC_concepto = ?cPropImage Into Cursor ima

	Select ima
	Copy To (cFiledb)
	Use In Select("ima")

* cambia el campo grneral de tipo memo
	LL = Fopen(cFiledb+".dbf",12)
	Fseek(LL,43)
	Fwrite(LL,'M')
	Fclose(LL)

* graba los datos campo memo en un archivo-imagen
	Use (cFiledb) Alias ima
	miresp = ''
	Do prg_saveBin With foto,cFiledb,miresp,'JPG'

	If Used('__DATA')
		Use In __DATA
	Endif

	Use In Select(cFiledb)
	Use In Select("ima")

	Delete File Forceext(cFiledb,"dbf")
	Delete File Forceext(cFiledb,"fpt")
	Delete File Forceext(cFiledb,"")

	Return cFiledb

	Endproc


** Borra todas las imagenes y tablas temporales creadas en directorio c:\temp\Imagenes\
*------------------
	Procedure RemoveFiles

	Local lcErrorAnt

	lcErrorAnt = On("ERROR")
	On Error *

	Delete File This.pPathImagenes+"*.*"

	On Error &lcErrorAnt

	Endproc


** Cargamos los valores contenidos en INI.TXT
*---------------------
	Procedure CargaIni
*---------------------
	Local xlleoini,lnFileHandle,cContenido,nPos,cTemp,mfile
	xlleoini = .T.
	If Used("mwkambitoini")
		If Reccount("mwkambitoini")>0
			xlleoini = .F.
		Endif
	Endif

	mfile = Justpath(Sys(16,0))+"\inicio\ini.txt"

	If At("EXE",Upper(mfile))=0
		mfile = "..\exe\inicio\ini.txt"
	Endif

*!*		lnFileHandle= Fopen(mfile)

	If xlleoini
		mcadcon = Filetostr(mfile)
	Else
		mcadcon = mwkambitoini.ini
	Endif
	nlineas = Alines(mimatini,mcadcon)
	
	lmiambito = Ascan(mimatini,"[AMBITO]", 1)
	cmiambito = Iif(lmiambito>0,mimatini(lmiambito+1 ),"1")
	This.pAmbito = Val(cmiambito)
	
*!*		Do While Not Feof(lnFileHandle)
*!*			cContenido = Fgets(lnFileHandle, 50)
*!*			nPos = At("=",cContenido)
*!*			If nPos > 0
*!*				cTemp = Alltrim(Substr(cContenido,1,nPos - 1))
*!*				If cTemp == "AMBITO"   &&ALMACENAMOS VALOR
*!*					This.pAmbito = Val(Alltrim(Substr(cContenido,nPos + 1)))
*!*				Endif
*!*			Endif

*!*		Enddo

*!*		=Fclose(lnFileHandle)


	Endproc

Enddefine

