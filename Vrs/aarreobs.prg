mcon1 = SQLConnect("conec01")
Set Step On
Select algo
Scan
	miid = Id
	midevol = obs_idevol
	If midevol>       169338
		mret = SQLExec(mcon1, "select * from Tabintobsenf " + ;
			"where id>=?miid and obs_idevol =?midevol and OBS_sector= 4 ", "mwkobs")
		Go Bottom
		miobs = OBS_obser
		mifec = mwkobs.obs_fechor
		mret = SQLExec(mcon1, "SELECT ID, EIM_idevol, EIM_codmed, EIM_evol, EIM_fechaH, EIM_indicacion "+;
			" FROM Tabintevolmed WHERE  EIM_idevol =?midevol and  EIM_fechaH = ?mifec","mwkevol")
		If Reccount("mwkevol")=1 And Empty(Nvl(EIM_indicacion,''))
			mid = mwkevol.Id
			mret = SQLExec(mcon1, "update Tabintevolmed set EIM_indicacion =?miobs  wheRE  id = ?mid")
		Else
			If Reccount("mwkevol")=1 And !Empty(Nvl(EIM_indicacion,''))
				Loop
			Endif
			If Reccount("mwkevol")=0
				mifec = mwkobs.obs_fechor-1
				mret = SQLExec(mcon1, "SELECT ID, EIM_idevol, EIM_codmed, EIM_evol, EIM_fechaH, EIM_indicacion "+;
					" FROM Tabintevolmed WHERE  EIM_idevol =?midevol and  EIM_fechaH = ?mifec","mwkevol")
				If Reccount("mwkevol")=1 And !Empty(Nvl(EIM_indicacion,''))
					Loop
				Endif
				If Reccount("mwkevol")=1 And Empty(Nvl(EIM_indicacion,''))
					mid = mwkevol.Id
					mret = SQLExec(mcon1, "update Tabintevolmed set EIM_indicacion =?miobs  wheRE  id = ?mid")
				Else
					If Empty(Nvl(EIM_indicacion,''))
						Set Step On
					Endif
				Endif
			Endif
		Endif
	Endif

Endscan

Do sp_desconexion
