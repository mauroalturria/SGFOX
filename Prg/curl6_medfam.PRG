Parameters lcVar

If vartype(lcVar)!="C"
	Return 
Endif 
If Empty(lcVar)
	Return 
Endif 	

Local loRequest as MsXml2.XmlHttp

Local lcUrl 

*!*	lcUrl = "https://desa.sg.com.ar/ws-osana/sg-curl6.php?"

lcUrl = "https://servicios.sg.com.ar/ws-osana/sg-curl6.php?"
lcUrl = lcUrl + lcVar

#Define lAsync .F.

Local lbResu 
lbResu = .T.
TRY 
	loRequest = Createobject('MsXml2.XmlHttp')
	loRequest.Open("GET",lcUrl, lAsync )
	loRequest.Send()
	If(!Empty(	loRequest.ResponseText ))
		Messagebox( loRequest.ResponseText )
		Do log_errores With 0, lcVar, '', PROGRAM(), LINENO()
		Do log_errores With 0, loRequest.ResponseText, '', PROGRAM(), LINENO()
	Endif 
*!*		? loRequest.Status
*!*		? loRequest.ResponseText 
Catch To oerr
	Messagebox(oErr.Message,16,"ERROR")
	Do Log_errores With oErr.ErrorNo, oErr.Message, oErr.Details, Program(), oErr.LineNo
	Do log_errores With 0, lcVar, '', PROGRAM(), LINENO()
	lbResu = .F.
FINALLY

Endtry

loRequest = null 
Release loRequest

Return lbResu