Parameters tnNroRegi, tnPreReg, tcMsg

*!*	tnNroRegi = 1443002
*!*	*tnPreReg = 11
*!*	tcMsg = "Recordatorio de Turno"

*!* tnNroRegi = 3694303
*!* tcMsg     = "Recordatorio de Turno"

If tnNroRegi > 0
	lcWhere = " and (TWR_Registra = ?tnNroRegi) "
Else
	lcWhere = " and (TWR_PreRegist = ?tnPreReg) "
Endif

*!* 2016-12-15

lcsql = "SELECT TWR_Mail, TWR_Apellido, TWR_Nombre, TabWToken.TWT_Token, TabWToken.TWT_Iduser, tabwregistra.id as lidusermsg " + ;
	"FROM TabWToken " + ;
	"Inner join tabwregistra on TabWToken.TWT_Iduser = tabwregistra.id " + ;
	"where TWT_Pasivado = '1900-01-01' " + lcWhere

If !prg_ejecutosql(lcsql,"mwkRegWT",.F.)
	Return .F.
Endif

lbresu = .T.

Do While .T.
	If Reccount("mwkRegWT") = 0
		Exit
	Endif

	Select mwkRegWT
	Scan All

*!*			lcfile = ""
*!*			loBrowser = createobject("InternetExplorer.Application")
*!*			loBrowser.Navigate(lcfile)
*!*			loBrowser.visible=.t.
*!*			Release loBrowser

*!*			TEXT To lcsql Textmerge Noshow Pretext 7
*!*				INSERT INTO TabWMsg (TWM_IdUser, TWM_Mensaje, TWM_TipoMsg, TWM_FecHorAct) VALUES (?mwkRegWT.TWT_Iduser, ?tcMsg, 2, GetDate() )
*!*			ENDTEXT

*!*			IF !prg_ejecutosql(lcSql,"c")
*!*				RETURN .f.
*!*			ENDIF

*!*			lmsg = "Prueba_Recordatorio Final"
*!*	        ltkn = "cT0hnmkAcwQ:APA91bGmRgBtRMThLqSO2Xc82Ve7DMIvKhNbHTtAVljQE8N7jDzRRD-M2t0YR1GHQK2y_7hSRtT05_iPHw0BeY7DK2xPEnZUYSpR5hRSuKhoxdSX2ztZFOYScCXwmd92coi-tCsqHf79"
*!*			lnombre = "MAURO"
*!*			lapellido = "ALTURRIA"
*!*			lidusuario1 = 25337


*!*		lmsg = "Prueba_Recordatorio Final"
		ltkn = Alltrim(mwkRegWT.twt_token)

		If !prg_modo_exe()
*			ltkn = "cT0hnmkAcwQ:APA91bGmRgBtRMThLqSO2Xc82Ve7DMIvKhNbHTtAVljQE8N7jDzRRD-M2t0YR1GHQK2y_7hSRtT05_iPHw0BeY7DK2xPEnZUYSpR5hRSuKhoxdSX2ztZFOYScCXwmd92coi-tCsqHf79"
*!*         Token Mauro
			ltkn = "fIbLw1G97og:APA91bF7AM-qNCgLsc5I1uHRZoEmX_wMSPiQVhOeAUCikt3QK-IpEIAoRCVWaMPeH4mmpK-0T8x4xfaHJ_NV7qG_oIloBgTJKk_eTMlP1NiPz800brGO6-gfZOo9gezCRXGQDV-CVg8Q"
			&& Pablo
			ltkn = "dvQxO5ohxlo:APA91bHp-10p74TvjZS4aMMokJv9VuskBY-KuKPx5SBL982VItxBOclnM_irp-5FSua5rnUTE_C62PhWm9KEhQSqEAVnZO6lwaYecKQ43TMQW5QMG0dR5VJg2ZAePiu5OSW05CYBCBvr"
		Endif

		lnombre     = Alltrim(mwkRegWT.TWR_Nombre)
		lapellido   = Alltrim(mwkRegWT.TWR_Apellido)
		lidusuario1 = mwkRegWT.TWT_Iduser

*!*  	lcFullURL = "http://online.sg.com.ar:8060/online/app-mob/notifica/pusher.php"
		lcFullURL = "http://online.sg.com.ar:8060/online/app-mob/notifica/pusherfox.php"

*!*     2016-12-15

		lideluser = Alltrim(Transform(mwkRegWT.lidusermsg))

*!*		lcVariables = "lidusuario1=" + "25337" + "&" + "lmsg=" + tcMsg + "&" + "ltkn" +"=" + ltkn + "&" + "lnombre=" + lnombre + "&" + "lapellido=" + lapellido
*!*		lcVariables = "lidusuario1=" + "37496" + "&" + "lmsg=" + tcMsg + "&" + "ltkn" +"=" + ltkn + "&" + "lnombre=" + lnombre + "&" + "lapellido=" + lapellido

*!*     2016-12-15

		lcVariables = "lidusuario1=" + lideluser + "&" + "lmsg=" + tcMsg + "&" + "ltkn" +"=" + ltkn + "&" + "lnombre=" + lnombre + "&" + "lapellido=" + lapellido


*!*			?lcVariables
*!*			?"----------------------------"
*!*	*!*	*!*	lcVariables = '{ "r1":[{' + '"lmsg":"' + lmsg + '","' + 'ltkm":"' + ltkm + '"}' + '}'
*!*	*!*	*!*	?lcVariables

*+ '","lnombre:" + lnombre + ",lapellido :" + lapellido + ",lidusuario1:" + TRANSFORM(lidusuario1) + "}"


*!*	{
*!*	    "rows":[
*!*	        {
*!*	            "FirstName":"Mike",
*!*	            "LastName":"Johnson",
*!*	            "Phone":"(123) 123-1234"
*!*	        },
*!*	        {
*!*	            "FirstName":"Andy",
*!*	            "LastName":"Johnson",
*!*	            "Phone":"(999) 999-9999"
*!*	        }
*!*	    ]
*!*	}

*!*	 data: { lmsg : lmsgn, ltkn : ltknn, lnombre : lnombren, lapellido : lapellidon, lidusuario : lidusuario },


*!*	lmsg -> mensaje
*!*	ltkn   -> token
*!*	lnombre  -> nombre
*!*	lapellido   -> apellido
*!*	lidusuario1 -> id Tabwregistra
lcError = ON("ERROR")
ON ERROR *

loXML = Createobject("MSXML2.ServerXMLHTTP.4.0") && Could use version 3.0, 4.0, 5.0, 6.0
IF VARTYPE(loXML) <> "O"
	loXML = Createobject("MSXML2.ServerXMLHTTP.3.0") && Could use version 3.0, 4.0, 5.0, 6.0
ENDIF 	
IF VARTYPE(loXML) <> "O"
	loXML = Createobject("MSXML2.ServerXMLHTTP.5.0") && Could use version 3.0, 4.0, 5.0, 6.0
ENDIF 	
IF VARTYPE(loXML) <> "O"
	loXML = Createobject("MSXML2.ServerXMLHTTP.6.0") && Could use version 3.0, 4.0, 5.0, 6.0
ENDIF 	
IF VARTYPE(loXML) <> "O"
	MESSAGEBOX("NO EXISTE EL OBJ MSXML2.ServerXMLHTTP",16,"ERROR"  )
	RETURN .f.
ENDIF 

ON ERROR &lcError

*!*			Try
*!*				loXML = Createobject("MSXML2.ServerXMLHTTP.4.0") && Could use version 3.0, 4.0, 5.0, 6.0
*!*			Catch
*!*				Try
*!*					loXML = Createobject("MSXML2.ServerXMLHTTP.3.0") && Could use version 3.0, 4.0, 5.0, 6.0
*!*				Catch
*!*					Try
*!*						loXML = Createobject("MSXML2.ServerXMLHTTP.5.0") && Could use version 3.0, 4.0, 5.0, 6.0
*!*					Catch
*!*						Try
*!*							loXML = Createobject("MSXML2.ServerXMLHTTP.6.0") && Could use version 3.0, 4.0, 5.0, 6.0
*!*						Catch
*!*						Endtry
*!*					Endtry
*!*				Endtry
*!*			Endtry

		loXML.Open("POST", lcFullURL, .F.)
*		loXML.SetRequestHeader("Content-Type", "application/xml")
*		loXML.setRequestHeader("Content-Type", "text/xml; charset=utf-8")
		loXML.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
*		loXML.setRequestHeader("Content-Type", "application/json")

		loXML.Send(lcVariables)

		If Not '"success":1' $ loXML.ResponseText
*!*				Set Step On
*!*				Messagebox(loXML.ResponseText)
			lbresu = .F. && ver si contunua por mas que no funcione
			Exit
		Endif

*		STRTOFILE(loXML.ResponseText,"c:\wamp64\www\p3.php")
		Select mwkRegWT
	Endscan

	Exit
Enddo

Use In Select("mwkRegW")

Return (lbresu)
