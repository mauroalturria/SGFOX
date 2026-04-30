Lparameters minsumo

Local mval
Local mResultado
Local lKardex
Local oInsumos
Local oInsumos2
Local oIn
Local oX
Local oX2
Local oDescriStock
Local oDatos
Local lcResp
Local oRespuesta
Local oItemK
Local cArmarioK
Local cArmarioK
Local cInsumoK
Local nCantArmario
Local nCuenta
Local mInsumos
Local mInsumos2
Local nResultado
Local lResult

mval = "N"
mResultado = .F.
nResultado = 0
mFecha = sp_busco_fecha_serv("DD")
mTabla = ""
lKardexWeb = .F.

mbusca = Alltrim(minsumo)


* ---------------------------------- Buscamos la url para consultar stock en kardex
Do sp_busco_estados With 57," and tipo = 61", "mwkkardexweb"

Select mwkkardexweb
Go Top

If mwkkardexweb.estado = 1
	lKardexWeb = .T.
	lcUrl = Alltrim(mwkkardexweb.Descrip)
Endif

Use In Select("mwkkardexweb")
* -----------------------------------------------------------

*Set Step On

If !lKardexWeb

	mval = "S"

	Use In Select("mwkEtkardex")
	mves = 0
	Do While .T.

		mves = mves + 1
		If mves = 3
			Exit
		Endif
***mret = SQLExec(mcon1,"SELECT * FROM Grifols.MERCURIO_STOCKS WHERE CODART = ?mbusca and EXTERNO = 'S' ", "mwkEtkardex")
		mret = SQLExec(mcon1,"SELECT * FROM Grifols.MERCURIO_STOCKS WHERE CODART = ?mbusca ", "mwkEtkardex")
		If mret < 0
*!*			=Aerr(eros)
*!*			mmsgerr = eros(3)
*!*			mdetalle= "Error en consulta, maestro Grifols.MERCURIO_STOCKS - externo_kardex"
*!*			Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mwkusuario.idusuario, "externo_kardex"

*!*			Messagebox("EN LA CONSULTA GRIFOLS MAESTRO DE INSUMOS - EXTERNOS" + CHR(10) + "INSUMO : " + mBusca, 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
			Wait Window "CONSULTA GRIFOLS MAESTRO DE INSUMOS - EXTERNOS INSUMO : " + mbusca+ " AGUARDE ..." Timeout 1

		Else

			mResultado = .T.
			Exit

		Endif

	Enddo

	If mResultado

		If Used("mwkEtkardex")
			If Reccount("mwkEtkardex")>0

				mval =  mwkEtKardex.EXTERNO
*mval = "N"

** ------- Actualizo ZabMercurioExterno
				mret = SQLExec(mcon1,"select * from ZabMercurioExterno where Zab_CODART = ?mBusca","mwkExterno")

				If mret < 0
					mTabla = "CONSULTA DE ACTUALIZACION - ZABMERCURIOEXTERNO"
				Else

					Select mwkExterno
					Go Top
					If Reccount() > 0
						mret = SQLExec(mcon1,"update ZabMercurioExterno set " +;
							"Zab_Externo = ?mVal, " +;
							"Zab_FecModif = ?mFecha " +;
							"where Zab_codart = ?mBusca")
						mTabla = "UPDATE  - ZABMERCURIOEXTERNO"
					Else
						mret = SQLExec(mcon1,"insert into ZabMercurioExterno (Zab_codart,Zab_externo,Zab_fecAlta,Zab_fecmodif) values(" +;
							"?mBusca,?mVal,?mFecha,?mFecha)")
						mTabla = "INSERT - ZABMERCURIOEXTERNO"
					Endif

				Endif
			Endif
		Endif

	Else

		mret = SQLExec(mcon1,"SELECT * FROM ZabMercurioExterno WHERE Zab_CODART = ?mbusca ", "mwkExterno")

		If mret < 0
			mTabla = "CONSULTA EXTERNOS - ZABMERCURIOEXTERNO"
		Else
			Select mwkExterno
			Go Top
			If Reccount() > 0
				mval = mwkExterno.EXTERNO
*mval = "N"
			Else &&no existe aun el registro en la tabla local
				mTabla = "CONSULTA GRIFOLS.MERCURIO_STOCKS. NO EXISTE EL ITEM EN LA TABLA LOCAL."
				mret = -1
			Endif
		Endif

	Endif


	If mret < 0
		=Aerr(eros)
		mmsgerr = eros(3)
***mdetalle= "Error en consulta, maestro Grifols.MERCURIO_STOCKS - externo_kardex"
		mDetalle = "ERROR DE EXTERNOS. " + mTabla
		Do sp_insert_tabCtrlErr With mDetalle, mmsgerr , mwkusuario.idusuario, "externo_kardex"

		Messagebox("EN LA CONSULTA GRIFOLS MAESTRO DE INSUMOS - EXTERNOS" + Chr(10) + "INSUMO : " + mbusca, 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
	Endif

	Use In Select("mwkEtkardex")
	Use In Select("mwkExterno")

	oInsumos = mval

Else

* ------------------------ Pasamos los insumos solicitados al objeto collection
	Use In Select("mwkExterno")

	Create Cursor mwkExterno (codins c(11), EXTERNO c(1), hokas I,kardexIz I, kardexDer I, admh c(1),admiz c(1),admder c(1))

	oInsumos = Createobject("collection")

	Alines(aInsumos,minsumo,",")

* SET STEP ON

	If Alen(aInsumos,1) = 1
		Dimension aInsumos(3)

*       Agregamos 2 registros porque devuelve EXTERNO cuando consultamos por un solo articulo HOKA
		aInsumos(2) = "UNILEVOP025"
		aInsumos(3) = "UNIHALOP005"

	Endif

	For Each cIn In aInsumos

		oItem = Createobject("empty")
		If !Empty(Alltrim(cIn))
			AddProperty(oItem,"cInsumo",Alltrim(cIn))
			AddProperty(oItem,"jInsumo","")
			AddProperty(oItem,"nDerecha",0)
			AddProperty(oItem,"nIzquierda",0)
			AddProperty(oItem,"nCentral",0)

			oInsumos.Add(oItem)
		Endif

		Insert Into mwkExterno (codins,EXTERNO,hokas,kardexIz,kardexDer,admh,admiz,admder) Values(Alltrim(cIn),"S",0,0,0,"N","N","N")

	Next
* ------------------------------------------------------------------------------

	Set Procedure To json.prg Additive

* Consutamos al servicio para obtener los insumos externos
* Marcelo Torres, 27/02/2025
*!*	Servicio: http://172.16.240.41:12992/services/stock/

*lcUrl = "https://desa.sg.com.ar/api/kardex/stock/solicitar/"
*	lcToken = "tj7uYIz3dR2270LkpfWNLHaOX7EOOEfDz54wk0V50wroZuuAHsizqP69lqbx"  && Produccion

* SET STEP ON

	mccon = ''
	mccon = Left(SQLGetprop(mcon1,'ConnectString'),80)

	Do Case
	Case  (".190" $ mccon) && Desarrollo 190
		lcToken = "94ecbc1edeee37aaef258dd36bed9888"
	Case  (".50.110" $ mccon) && Desarrollo 50.110
		lcToken = "94ecbc1edeee37aaef258dd36bed9888"
	Case  (".50.102" $ mccon) && QAS 50.102
		lcToken = "94ecbc1edeee37aaef258dd36bed9888"
	Case ("CACHEQAS"	$ mccon)  && QAS post migración - Marcelo Torres, 29/08/2024
		lcToken = "94ecbc1edeee37aaef258dd36bed9888"
	Otherwise  && Producción
		lcToken = "tj7uYIz3dR2270LkpfWNLHaOX7EOOEfDz54wk0V50wroZuuAHsizqP69lqbx"
	Endcase

*!*	Ej. de llamada:
*!*	{
*!*	  "consultarStocks" : {
*!*	    "codsArticulos" : "UOCPARAC011"
*!*	  }
*!*	}

*!*	Se pueden invocar para varios artículos, separándolos por COMA dentro de las COMILLAS. Por ej: “UOCPARC011,DDEJERIN001,DDEJERIN002”

*	Set Step On

*   Agrupamos de a 20 insumos
	nCuenta = 0
	mInsumos = ""
	mInsumos2 = ""
	oInsumos2 = Createobject("collection")

	For nI = 1 To Alen(aInsumos,1)
		nCuenta = nCuenta + 1

		If nCuenta < 40

			mInsumos2 = mInsumos + aInsumos[nI]+","

			If Len(mInsumos2) < 500
				mInsumos = mInsumos + aInsumos[nI]+","
			Else

				mInsumos = Substr(mInsumos,1,Len(mInsumos)-1)

				oInsumos2.Add(mInsumos)
				mInsumos = aInsumos[nI]+","
				nCuenta = 0

			Endif

		Else
			If !Empty(mInsumos)
				mInsumos = Substr(mInsumos,1,Len(mInsumos)-1)

				oInsumos2.Add(mInsumos)
			Endif
			mInsumos = aInsumos[nI]+","
			nCuenta = 0
		Endif

	Next

	If !Empty(mInsumos)
		If Right(mInsumos,1) = ","
			mInsumos = Substr(mInsumos,1,Len(mInsumos)-1)
		Endif
		oInsumos2.Add(mInsumos)
	Endif


*   Consultamos al servicio de stock. Iteramos sobre el objeto oInsumos2.
*   En caso de fallar, se sale de la iteración
	For Each minsumo In oInsumos2

		Wait Window "Consultando stock del artículo : " + minsumo+". Aguarde ..." Nowait

		TEXT To lcJson Textmerge Noshow Pretext 7
{
    "AppGuid": "PEDIDO_DE_STOCK",
    "codInsumo": "<<mInsumo>>"
}

		ENDTEXT

		xmlHTTP = ""

		lOk = prg_crea_xmlhttp(@xmlHTTP)

*Set Step On

		If lOk
***xmlHTTP.Open("POST", this.purl, .F.)
			xmlHTTP.Open("POST", lcUrl, .F.)
			xmlHTTP.setRequestHeader("Content-Type","application/json")
			xmlHTTP.setRequestHeader("Authorization", lcToken)
			xmlHTTP.setTimeouts(5000, 5000, 5000, 10000)    &&para que espere 10 segundos la consulta

			xmlHTTP.Send(lcJson)

			nCuenta = 0
			lResult = .T.

			Do While xmlHTTP.readyState<>4
				DoEvents
				nCuenta = nCuenta + 1

				If nCuenta >= 1000
					lResult = .F.
					Exit
				Endif
			Enddo

			lnServidor = xmlHTTP.Status

			Wait Clear

*			Set Step On

			If !xmlHTTP.Status = 200 Or !lResult
				Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status) + Chr(10)+ "Descripción " + Chr(10) + xmlHTTP.responseText ),48,'Problemas con el Servidor')
				lOk = .F.
				nResultado = -4
				lcResp = "ERROR DE SERVIDOR-REGISTRO EN KARDEX"
				Exit
			Else

				If lnServidor = 200

					lcResp = xmlHTTP.responseText

					If At(lcResp,'"Estado": "ERROR"') > 0

						Messagebox(lcResp,16,"Error consulta Externo Kardex")
						nResultado = -1
						Strtofile(lcResp,"c:\temp\errorstock.json")
						Exit

					Else

						If Alltrim(Upper(lcResp)) = "NULL"  &&insumo Externo?

*
							nResultado = Null

						Else

							Wait "PARSEANDO JSON A TABLA DE DATOS, AGUARDE ..." Window Nowait

							oJson = Newobject('json','json.prg')

							cMsg = ""
							lcmsg = ""
							Try

								oDatos = oJson.decode(lcResp)

								If Not Empty(oJson.cError)
									lcmsg =  'Error in decode:'+oJson.cError + Chr(10) + "Se cancela la conexión."
									Messagebox(lcmsg,16,"Error Stock Kardex")
									Strtofile(lcResp,"c:\temp\errorstock.json")
									nResultado = -3
									lOk = .F.
								Endif

							Catch To lo

								cMsg = "ERROR EN DECODE RESPUESTA DE STOCK" + Chr(10)
								cMsg = cMsg + ' Comment: '+ lo.Comment+ Chr(10)
								cMsg = cMsg + ' Details: ' + lo.Details+Chr(10)
								cMsg = cMsg + ' ErrorNo: '+ Transform(lo.ErrorNo)+Chr(10)
								cMsg = cMsg + ' LineContents: '+ Transform(lo.LineContents)+Chr(10)
								cMsg = cMsg + ' LineNo: ' + Transform(lo.Lineno)+Chr(10)
								cMsg = cMsg + ' Message: ' + lo.Message+Chr(10)
								cMsg = cMsg + ' Procedure: '+ lo.Procedure+Chr(10)

								Strtofile(lcResp,"c:\temp\errorstock.json")
								Messagebox(cMsg,16,"Error Stock Kardex")

								lOk = .F.
								nResultado = -3

							Finally

							Endtry


* Set Step On

							If lOk

*!*								oRespuesta = oDatos._respuesta

*!*								IF TYPE("oRespuesta._consultarStocksResp") <> "U" and (Alltrim(Upper(oRespuesta._consultarStocksResp)) = "NULL")  && Insumos Externo

*!*									oInsumos = Null

*!*								Else

								For Each oIn In oDatos.Array

									Wait "Incorporando datos obtenidos, aguarde ... " Window Nowait

									oItemK = ""
									cArmarioK = ""

									If Vartype(oIn) = "O"

										oItemK = oIn._articulo

										If Type("oItemK.array") !="U"   &&venimos consultando mas de un insumo.

											cArmarioK = Alltrim(oIn._descripcion)

											For Each oItemk2 In oItemK.Array

*cArmarioK = Alltrim(oIn._descripcion)
												cInsumoK = oItemk2._codArticulo
												nCantArmario = oItemk2._stockGrupo

												CargaCursorK(cInsumoK,cArmarioK,nCantArmario)

*!*												Select mwkExterno
*!*												Go Top
*!*	*Locate For Alltrim(codins) = Alltrim(oX.cInsumo)
*!*												Locate For Alltrim(codins) = Alltrim(cInsumoK2)

*!*												If Found()
*!*													Replace mwkExterno.EXTERNO With "N"

*!*													Do Case   &&Para identificar que armario administra el insumo
*!*													Case cArmarioK = 'HOKAS'
*!*														Replace mwkExterno.admh With "S"
*!*														Replace mwkExterno.hokas With nCantArmario
*!*													Case cArmarioK = 'KVIZQ'
*!*														Replace mwkExterno.admiz With "S"
*!*														Replace mwkExterno.kardexIz With nCantArmario
*!*													Case cArmarioK = 'KVDER'
*!*														Replace mwkExterno.admder With "S"
*!*														Replace mwkExterno.kardexDer With nCantArmario
*!*													Endcase
*!*												Endif

											Next

										Else
											cArmarioK = Alltrim(oIn._descripcion)
											cInsumoK = oItemK._codArticulo
											nCantArmario = oItemK._stockGrupo

											CargaCursorK(cInsumoK,cArmarioK,nCantArmario)

*!*											Select mwkExterno
*!*											Go Top
*!*	*Locate For Alltrim(codins) = Alltrim(oX.cInsumo)
*!*											Locate For Alltrim(codins) = Alltrim(cInsumoK)

*!*											If Found()
*!*												Replace mwkExterno.EXTERNO With "N"

*!*												Do Case   &&Para identificar que armario administra el insumo
*!*												Case cArmarioK = 'HOKAS'
*!*													Replace mwkExterno.admh With "S"
*!*													Replace mwkExterno.hokas With nCantArmario
*!*												Case cArmarioK = 'KVIZQ'
*!*													Replace mwkExterno.admiz With "S"
*!*													Replace mwkExterno.kardexIz With nCantArmario
*!*												Case cArmarioK = 'KVDER'
*!*													Replace mwkExterno.admder With "S"
*!*													Replace mwkExterno.kardexDer With nCantArmario
*!*												Endcase
*!*											Endif

										Endif

									Endif

								Next
							Else
								Exit
							Endif
						Endif
					Endif
				Endif
			Endif
		Else

			Messagebox("No se pudo crear el objeto HTTP para consulta de STOCK",16,"Stock")
			nRespuesta = -2

		Endif

	Next

	oInsumos = nResultado

Endif

Release oJson
Release xmlHTTP

Return oInsumos


* ----------------------------------------
Function CargaCursorK(cInsumoK,cArmarioK,nCantArmario)

Select mwkExterno
Go Top
Locate For Alltrim(codins) = Alltrim(cInsumoK)

If Found()
	Replace mwkExterno.EXTERNO With "N"

	Do Case   &&Para identificar que armario administra el insumo
	Case cArmarioK = 'HOKAS'
		Replace mwkExterno.admh With "S"
		Replace mwkExterno.hokas With nCantArmario
	Case cArmarioK = 'KVIZQ'
		Replace mwkExterno.admiz With "S"
		Replace mwkExterno.kardexIz With nCantArmario
	Case cArmarioK = 'KVDER'
		Replace mwkExterno.admder With "S"
		Replace mwkExterno.kardexDer With nCantArmario
	Endcase
Endif


Return .T.


*Messagebox(oItem._codarticulo)
















*!*	*                               Buscar e incoporar al objeto collection

*!*											For Each oX In oInsumos

*!*												If Type("oItem.array") = "O"

*!*													For Each oX2 In oItem.Array

*!*														If Alltrim(oX.cInsumo) = Alltrim(oX2._codarticulo)
*!*															If Empty(oX.jInsumo)

*!*																oX.jInsumo = Alltrim(oX2._codarticulo)
*!*																Do Case
*!*																Case oDescriStock = 'HOKAS'
*!*																	oX.nCentral = oX2._stockGrupo
*!*																Case oDescriStock = 'KVIZQ'
*!*																	oX.nIzquierda = oX2._stockGrupo
*!*																Case oDescriStock = 'KVDER'
*!*																	oX.nDerecha = oX2._stockGrupo
*!*																Endcase

*!*															Else
*!*																Do Case
*!*																Case oDescriStock = 'HOKAS'
*!*																	oX.nCentral = oX.nCentral + oX2._stockGrupo
*!*																Case oDescriStock = 'KVIZQ'
*!*																	oX.nIzquierda = oX.nIzquierda + oX2._stockGrupo
*!*																Case oDescriStock = 'KVDER'
*!*																	oX.nDerecha = oX.nDerecha + oX2._stockGrupo
*!*																Endcase
*!*															Endif
*!*														Endif

*!*													Next

*!*												Else

*!*													If Alltrim(oX.cInsumo) = Alltrim(oItem._codarticulo)
*!*														If Empty(oX.jInsumo)

*!*															oX.jInsumo = Alltrim(oItem._codarticulo)
*!*															Do Case
*!*															Case oDescriStock = 'HOKAS'
*!*																oX.nCentral = oItem._stockGrupo
*!*															Case oDescriStock = 'KVIZQ'
*!*																oX.nIzquierda = oItem._stockGrupo
*!*															Case oDescriStock = 'KVDER'
*!*																oX.nDerecha = oItem._stockGrupo
*!*															Endcase

*!*														Else
*!*															Do Case
*!*															Case oDescriStock = 'HOKAS'
*!*																oX.nCentral = oX.nCentral + oItem._stockGrupo
*!*															Case oDescriStock = 'KVIZQ'
*!*																oX.nIzquierda = oX.nIzquierda + oItem._stockGrupo
*!*															Case oDescriStock = 'KVDER'
*!*																oX.nDerecha = oX.nDerecha + oItem._stockGrupo
*!*															Endcase
*!*														Endif
*!*													Endif
*!*												Endif


*!*	* -------------------------------------------------------------
*!*												Select mwkExterno
*!*												Go Top
*!*												*Locate For Alltrim(codins) = Alltrim(oX.cInsumo)
*!*												Locate For Alltrim(codins) = Alltrim(oItem._codarticulo)
*!*												If Found()
*!*													Replace mwkExterno.EXTERNO With "N"
*!*	*!*													Replace mwkExterno.hokas With oX.nCentral
*!*	*!*													Replace mwkExterno.kardexIz With oX.nIzquierda
*!*	*!*													Replace mwkExterno.kardexDer With oX.nDerecha

*!*													Do Case   &&Para identificar que armario administra el insumo
*!*													Case oDescriStock = 'HOKAS'
*!*														Replace mwkExterno.admh With "S"
*!*														Replace mwkExterno.hokas With oItem._stockGrupo
*!*													Case oDescriStock = 'KVIZQ'
*!*														Replace mwkExterno.admiz With "S"
*!*														Replace mwkExterno.kardexIz With oItem._stockGrupo
*!*													Case oDescriStock = 'KVDER'
*!*														Replace mwkExterno.admder With "S"
*!*														Replace mwkExterno.kardexDer With oItem._stockGrupo
*!*													Endcase
*!*												Endif
*!*	*--------------------------------------------------------------

*!*											Next

*!*										Endif

*!*									Next

*!*	*!*								Endif

*!*							Endif

*!*						Endif
*!*					Endif
*!*				Endif

*!*			Endif

*!*		Endif

*!*	Endif


