* Obtenemos tabla Prioridad Plexus

Lparameters cSector

LOCAL xmlHTTP 
LOCAL oJson 
LOCAL oDatos
LOCAL oIn
LOCAL lcURL
LOCAL lnServidor
LOCAL nError
LOCAL lcError 
LOCAL lcDatos
LOCAL nDatos
LOCAL lcResp
LOCAL cWhere
LOCAL lOk
LOCAL cResultado
			
Set Procedure To json.prg Additive

Create Cursor mwkPriorPlexus ( ;
	lSel I, Descrip c(100), orden N(2), lid I)

* ------------------------------------------
* Set Step On

cWhere = " "
lOk = .T.
cResultado = ""
lcError = ""
lcDatos = ""
nDatos = 0
nError = 0

TEXT to cWhere textmerge noshow
{
  "sector":"<< cSector >>"
}

ENDTEXT

xmlHTTP = Createobject("Microsoft.XMLHTTP")
If Alltrim(Type("xmlHTTP")) <> "O"
	Messagebox( "No se pudo crear el objeto (XMLHTTP). No se pudo consultar PRIORIDADES.",48,"Aviso")
	lOk = .F.
Endif

* ----------------
*Strtofile(cWhere,'c:\temp\jsonCabe.txt')
* ----------------

* Set Step On
**lcURL = "https://desa.sg.com.ar/api/plexus/sp_busca_prioridad.php"

lcURL = ""
Do sp_busco_estados With 57, " and tipo=56 and subestado = 1 ", "mwkEstadoUrl"

Select mwkEstadoUrl
Go Top

Scan All

	If mwkEstadoUrl.estado = 1
		lcURL = Alltrim(mwkEstadoUrl.Descrip)
	Endif

Endscan

Use In Select("mwkEstadoUrl")

lOk = !Empty(lcURL)

If lOk

	xmlHTTP.Open("POST", lcURL, .F.)
	xmlHTTP.setRequestHeader ("Content-Type", "application/json;charset=utf-8")

	xmlHTTP.Send(cWhere)

	Do While xmlHTTP.readyState<>4
		DoEvents
	Enddo

	lnServidor = xmlHTTP.Status

	Wait Clear

*	Create Cursor mwkprestaciones (prestacion c(50))

	If !(lnServidor = 200)
		Messagebox('Problemas con el Servidor Local.'+Chr(10)+'Tipo de Error: '+Alltrim(Str(lnServidor)),48,"Laboratorio Plexus")
		lOk = .F.
		lcResp = "ERROR DE SERVIDOR"
	Else

		If lnServidor = 200

			lcResp = xmlHTTP.responseText

			lcError = ""
			lcDatos = ""

*           Extraemos error
			nError = At(',"errors":',lcResp)

			If nError > 0
				lcError = Substr(lcResp,nError+10,Len(lcResp))
				lcError = Strtran(lcError,"}","")
				lcError = Strtran(lcError,"{","")
			Endif

*           Extraemos datos
			nDatos = At('{"datos":',lcResp)

			If nDatos > 0
*lcDatos = Substr(lcResp,10,nError-1)
				If nError > 0
					lcDatos = Substr(lcResp,10,nError - 10)
					lcDatos = Strtran(lcDatos,"\u00c3\u0091","N")
					lcDatos = Strtran(lcDatos,"A\u00c3\u0082\u00c2\u00ad","I")
					lcDatos = Strtran(lcDatos,"\u00e1","a")
					lcDatos = Strtran(lcDatos,"\u00e9","e")
					lcDatos = Strtran(lcDatos,"\u00ed","i")
					lcDatos = Strtran(lcDatos,"\u00f3","o")
					lcDatos = Strtran(lcDatos,"\u00fa","u")
				Else
					lcDatos = Substr(lcResp,10,Len(lcResp))
					lcDatos = Strtran(lcDatos,"\u00c3\u0091","N")
					lcDatos = Strtran(lcDatos,"A\u00c3\u0082\u00c2\u00ad","I")
					lcDatos = Strtran(lcDatos,"\u00e1","a")
					lcDatos = Strtran(lcDatos,"\u00e9","e")
					lcDatos = Strtran(lcDatos,"\u00ed","i")
					lcDatos = Strtran(lcDatos,"\u00f3","o")
					lcDatos = Strtran(lcDatos,"\u00fa","u")
				Endif
			Endif

* If !Empty(lcDatos)
			If Empty(lcError) And nDatos > 0

				Wait "PARSEANDO JSON A TABLA DE DATOS, AGUARDE ..." Window Nowait

				oJson = Newobject('json','json.prg')
				oDatos = oJson.decode(lcDatos)

*SET STEP ON

				If !Empty(oJson.cError)
					Messagebox(oJson.cError,16,"Error de Datos MariaDB")
*Set Step On

					Strtofile(lcDatos,"c:\temp\errorplx.log")
				Else

					For Each oIn In oDatos.Array

						Wait "Incorporando datos obtenidos, aguarde ... " Window Nowait

						If Vartype(oIn) = "O"

*!*								xValor = ""

							Select mwkPriorPlexus
							Append Blank

* lId I, descrip c(100), orden n(2))
							Replace mwkPriorPlexus.lSel With 0
							Replace mwkPriorPlexus.lid With Val(oIn._id)
							Replace mwkPriorPlexus.Descrip With oIn._descrip
							Replace mwkPriorPlexus.orden With VAL(oIn._orden)

						Endif

					Next

				Endif

			Else
				Messagebox("Error al intentar obtener el listado de PRIORIDADES." + Chr(10)+lcResp ,16,"Prioridades")
			Endif

		Endif

	Endif

Endif

xmlHTTP = Null
oJson = Null
oDatos = Null
oIn = Null



