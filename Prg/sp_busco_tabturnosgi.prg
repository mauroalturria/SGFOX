Lparameters tnOpcion, tdGI_FecAlta, tnNroVale
*!*	tnOpcion = 1
*!*	tdGI_FecAlta = sp_busco_fecha_serv('DD')
*!*	tnOpcion = 2
*!*	tnNroVale = 25671210
*--------------------------------
ltGI_FecPasiva = Ctot('01/01/1900')


Do Case
	Case tnOpcion = 1
		tdGI_FecAlta2 = tdGI_FecAlta + 1
		mRet = SQLExec(mcon1,"Select * " + ;
			"from TabTurnosGi " + ;
			"WHERE GI_FecAlta between ?tdGI_FecAlta and ?tdGI_FecAlta2 " + ;
			" and GI_FecPasiva = ?m.ltGI_FecPasiva","TabTurnosGi")

	Case tnOpcion = 2
		mRet = SQLExec(mcon1,"Select Turnos.*, Prestadores.Nombre  " + ;
			"from TabTurnosGi "  + ;
			"Inner join Turnos On Turnos.Id = TabTurnosGi.GI_IdTurno " + ;
			"Inner join Prestadores on Prestadores.Id = Turnos.CodMed " + ;
			"WHERE GI_FecPasiva = ?m.ltGI_FecPasiva and " + ;
			"GI_CodValeAsist = ?tnNroVale","TabTurnosGi")

	Otherwise

Endcase


If mRet <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	Return .F.
Endif