**********************************************
* Trae la fecha del día del servidor
* Parametro DT si es datetime y DD si es date
**********************************************
Function sp_busco_fecha_srv2(vr_tipo)

mret=SQLExec(mcon1,"SELECT currENT_timestamp  as fechaHora "+;
	"from deltfec ","MWKFecServ")
*!*	If myip='172.16.1.7' And Ttod(MWKFecServ.fechaHora )=Ctod("24/09/2024")
*!*	Select Ctot(Dtoc(Date())+" "+"06:00:00")  As fechaHora FROM MWKFecServ Into Cursor MWKFecServ
*!*	Endif
If mret < 0
	mret = 0
	Messagebox('ERROR DE GENERACION DE CURSOR, REINTENTE',16,'Validacion')
Else
	If vr_tipo = 'DT'
		vr_fdia = MWKFecServ.fechaHora
	Else
		vr_fdia = Ttod(MWKFecServ.fechaHora)
	Endif
	Return vr_fdia
Endif
