*******************
* Claudia Antoniow
*******************
* Fecha:05/11/2002
*******************
* Actualizado:
**********************************************
* Trae la fecha del día del servidor
* Parametro DT si es datetime y DD si es date
**********************************************
Function sp_busco_fecha_serv(vr_tipo, tbNoDefa)

mret=SQLExec(Iif(tbNoDefa,mcon3,mcon1),"SELECT currENT_timestamp  as fechaHora "+;
	"from deltfec ","MWKFecServ")
*!*	If myip='172.16.1.7' And Ttod(MWKFecServ.fechaHora )=Ctod("24/09/2024")
*!*		Select Ctot(Dtoc(Date())+" "+"06:00:00")  As fechaHora FROM MWKFecServ Into Cursor MWKFecServ
*!*	Endif
If mret < 0
	mret = 0
*		messagebox('ERROR DE GENERACION DE CURSOR, REINTENTE',16,'VALIDACION')
	Do prg_cancelo
Else
	If vr_tipo = 'DT'
		vr_fdia = MWKFecServ.fechaHora
	Else
		vr_fdia = Ttod(MWKFecServ.fechaHora)
	Endif
	Return vr_fdia
Endif

*!*		if vr_tipo = 'DT'
*!*			return datetime()
*!*		else
*!*			return date()

*!*		endif
