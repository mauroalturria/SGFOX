Lparameters mAdmision, mRegistracion,mSectorInt,mHabitacion,mCama,mPlan,mCodEnt


Local lclink
Local loXmlHttp
Local lcresp
Local cMsg
Local lResult

mPlan = Iif(Vartype(mPlan)<>"C", "...",mPlan)
mPlan = Iif(Empty(mPlan),"...",mPlan )
lResult = .T.

Try
	loXmlHttp = Createobject("MSXML2.XMLHTTP.3.0")

	mccon = ''
	mccon = Left(SQLGetprop(mcon1,'ConnectString'),80)

* SET STEP ON

	Do Case
	Case  (".190" $ mccon) && Desarrollo 190
* lclink = "https://desa.sg.com.ar/ws-osana/sg-hotel-msg.php?"
	Case  (".50.110" $ mccon) && Desarrollo 50.110
* lclink = "https://desa.sg.com.ar/ws-osana/sg-hotel-msg.php?"
	Case  (".50.102" $ mccon) && QAS 50.102
		lclink = "https://desa.sg.com.ar/ws-osana/sg-hotel-msg.php?"  
	Otherwise  && Producción
		lclink = "https://servicios.sg.com.ar/ws-osana/sg-hotel-msg.php?"
	Endcase

* ----- Admisión
	lclink = lclink + "&admision=" + mAdmision

* ----- nro de registración
	lclink = lclink + "&registracio=" + Transform(mRegistracion)

* ----- habitacion
	lclink = lclink + "&habitacion="+ mSectorInt + " Hab : " + mHabitacion + " Cama: "+ mCama

* ----- Plan (ahora para indicar si es alta o cambio de cama)
* lclink = lclink + "&plan=CAMBIO_DE_CAMA."
	lclink = lclink + "&plan=" + mPlan

* ----- Nro de Entidad
	lclink = lclink + "&entidad="+Transform(mCodEnt)

	loXmlHttp.Open( "GET" , lclink, .F. )
	loXmlHttp.Send()
	lcresp = Alltrim(loXmlHttp.responseText)
*** ? lcresp

	If At('"errors"',lcresp) > 0
		Messagebox("No se pudo enviar el mensaje a HOTELERIA." + CHR(10) + lcresp ,64,"HOTELERIA")
		lResult = .F.
	Endif

Catch To lo

	cMsg = "ERROR AL ENVIAR MENSAJE A HOTELERIA" + Chr(10)
	cMsg = cMsg + ' Comment: '+ lo.Comment+ Chr(10)
	cMsg = cMsg + ' Details: ' + lo.Details+Chr(10)
	cMsg = cMsg + ' ErrorNo: '+ Transform(lo.ErrorNo)+Chr(10)
	cMsg = cMsg + ' LineContents: '+ Transform(lo.LineContents)+Chr(10)
	cMsg = cMsg + ' LineNo: ' + Transform(lo.Lineno)+Chr(10)
	cMsg = cMsg + ' Message: ' + lo.Message+Chr(10)
	cMsg = cMsg + ' Procedure: '+ lo.Procedure+Chr(10)

	Messagebox(cMsg,64,"HOTELERIA")

	lResult = .F.

Endtry

Release loXmlHttp

* SET STEP ON

RETURN lResult
