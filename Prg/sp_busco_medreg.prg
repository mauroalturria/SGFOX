*** Registracion de medicos en consultorio
***
Lparameters mFecha

mret = SQLExec(mcon1, "select TabAmbIEMed.* " + ;
	"from TabAmbIEMed " + ;
	"where TAI_Fecha = ?mFecha order by tai_codmed,tai_consultorio,tai_hhmming desc ", "mwkregmed") 
	
If mret < 1
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",48,"Validacion")
	Cancel
Endif