Lparameters tnRegistracio, tcTabla


If Vartype(tcTabla)#"C"
	tcTabla = "mwkULabo"
Endif

Mret = SQLExec(mcon1,"Select top 1 * " + ;
	"From TabAmbGestSerologia " + ;
	"Where SN_Registracio = ?tnRegistracio " + ;
	"Order by SN_fecha Desc ",tcTabla)

If Mret < 0
	Messagebox("ERROR DE LECTURA DE SEROLOGIA",16,"error")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif