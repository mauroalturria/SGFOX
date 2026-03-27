** sp_permite_acompaniante
Lparameters nopcion, mAdmision, cIdUsuario,cNombres,nTipoVisita

Local cMensaje
Local mFecActual
Local mFecNull

mFecActual = sp_busco_fecha_srv2("DT")
mFecNull = "1900-01-01 00:00:00"

Do Case
Case nopcion = 1  &&Alta

	mret = SQLExec(mcon1,"select * " +;
		"from zabacvshab " +;
		"where Zav_Admision = ?mAdmision and Zav_habilitado = 1 and NVL(Zav_FecPasiva,'1900-01-01 00:00:00') = ?mFecNull","mwkAcompAisla")

	Select mwkAcompAisla
	Go Top

	If Reccount() = 0
		mret = SQLExec(mcon1,"insert into zabacvshab (Zav_admision,Zav_habilitado,Zav_UsuAlta,Zav_FecAlta,Zav_FecModif,Zav_nomape,Zav_FecPasiva,Zav_TipoVisita) values(" +;
			"?mAdmision,1,?cIdUsuario,?mFecActual,?mFecNull,?cNombres,?mFecNull,?nTipoVisita)")
	Endif

	Use In Select("mwkAcompAisla")

	cMensaje = "GRABANDO NUEVO ESTADO ACOMPAÑANTE."

Case nopcion = 2  &&Pasivar

	mret = SQLExec(mcon1,"update zabacvshab set " +;
		"Zav_habilitado = 0 ," +;
		"Zav_UsuModif = ?cIdUsuario, " +;		
		"Zav_FecPasiva = ?mFecActual " +;
		"where Zav_Admision = ?mAdmision and Zav_habilitado = 1")

	cMensaje = "ACTUALIZANDO ESTADO ACOMPAÑANTE."

Case nopcion  = 3  && consulta de datos

	mret = SQLExec(mcon1,"select * " +;
		"from zabacvshab " +;
		"where Zav_Admision = ?mAdmision and Zav_habilitado = 1 and NVL(Zav_FecPasiva,'1900-01-01 00:00:00') = ?mFecNull","mwkAcompAisla")

	cMensaje = "CONSULTANDO ESTADO ACOMPAÑANTE."

Case nopcion = 4   &&Edita los nombres o Tipo de Visita

	mret = SQLExec(mcon1,"select * " +;
		"from zabacvshab " +;
		"where Zav_Admision = ?mAdmision and Zav_habilitado = 1 and NVL(Zav_FecPasiva,'1900-01-01 00:00:00') = ?mFecNull","mwkAcompAisla")

	If mret >= 0

		If Reccount("mwkAcompAisla") > 0
			If (Alltrim(mwkAcompAisla.zav_nomape) <> cNombres) OR (mwkAcompAisla.zav_TipoVisita <> nTipoVisita)
				mret = SQLExec(mcon1,"update zabacvshab set " +;
					"Zav_nomape = ?cNombres ," +;
					"Zav_UsuModif = ?cIdUsuario, " +;
					"Zav_FecModif = ?mFecActual, " +;
					"Zav_TipoVisita = ?nTipoVisita " +;
					"where Zav_Admision = ?mAdmision and Zav_habilitado = 1 and NVL(Zav_FecPasiva,'1900-01-01 00:00:00') = ?mFecNull")
			Endif
		ENDIF
		
	   USE IN SELECT("mwkAcompAisla")	
	   
	Endif

    cMensaje = "MODIFICANDO DATOS DE ACOMPAÑANTE."

Endcase


If mret < 0
	Messagebox("ERROR " + cMensaje,26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()

Endif
