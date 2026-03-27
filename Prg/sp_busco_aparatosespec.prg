lparameters mOpcion, lcCodEsp, lcWhere, lcCursor

If Vartype(lcCursor) # "C"
	lcCursor = "mwkapaxEsp"
Endif 

If Vartype(lcWhere) # "C"
	lcWhere = ""
Endif 


mFecHoy = sp_busco_fecha_serv('DD')

Do Case
	Case mOpcion = 0 && UNA ESPECIALIDAD
		mret = SqlExec(mcon1,"Select TabapaxEsp.*, " + ;
			"Especialid.Esp_Descripcion as Espec, " + ;
			"TabAparatos.Apa_Descrip, Especialid.Esp_CodEsp " + ;
			"from TabapaxEsp " + ;
			"Inner Join TabAparatos On TabAparatos.Id = TabapaxEsp.Ape_IdApa " + ;
			"Inner Join Especialid On Especialid.Esp_CodEsp = TabapaxEsp.Ape_CodEsp " + ;
			"Where Ape_CodEsp = ?lcCodEsp and (TabapaxEsp.Ape_fpasiva is null Or " + ;
			"TabapaxEsp.Ape_fpasiva < ?mFecHoy) " + lcWhere + "" + ;
			"", lcCursor )

	Case mOpcion = 1 && TODAS LAS ESPECIALIDADES
		mret = SqlExec(mcon1,"Select TabapaxEsp.*, " + ;
			"Especialid.Esp_Descripcion as Espec, " + ;
			"TabAparatos.Apa_Descrip, Especialid.Esp_CodEsp " + ;
			"from TabapaxEsp " + ;
			"Inner Join TabAparatos On TabAparatos.Id = TabapaxEsp.Ape_IdApa " + ;
			"Inner Join Especialid On Especialid.Esp_CodEsp = TabapaxEsp.Ape_CodEsp " + ;
			"Where (TabapaxEsp.Ape_fpasiva is null Or " + ;
			"TabapaxEsp.Ape_fpasiva < ?mFecHoy) " + lcWhere + ;
			"",lcCursor )
			
EndCase


If mret <= 0
	aerror(eros)
	MessageBox("ERROR DE LECTURA",48,"VALIDACION")
	Return .f.
Endif 