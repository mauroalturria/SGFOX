* ------------ Obtenemos los registros log para la fecha de cirugia
Lparameters dFechaDesde,dFechaHasta,lagrupado

Local lResult
Local cCursor

lResult = .T.
cCursor = ""

If lagrupado
	cCursor = "mwkFechaLogA"
Else
	cCursor = "mwkFechaLog"
Endif

dFechaHasta = Iif(Vartype(dFechaHasta) <> "D",dFechaDesde,dFechaHasta)

mret = SQLExec(mcon1,"select idQuirof, NroRegistrac,FechaQuirof,FechaHora " +;
	"from TabQuirofanoLog " +;
	"where FechaQuirof between ?dFechaDesde and ?dFechaHasta " +;
	"order by idQuirof, FechaHora ",cCursor)

If mret < 0

	Messagebox("ERROR EN LA LECTURA DEL LOG DE QUIROFANO",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()

	lResult = .F.

Endif

If lagrupado
	Select IdQuirof, NroRegistrac, FechaQuirof, Min(FechaHora) As FechaHora ;
		FROM mwkFechaLogA ;
		GROUP By IdQuirof,NroRegistrac ;
		INTO Cursor mwkFechaLog
Endif

Use In Select("mwkFechaLogA")

Return lResult
