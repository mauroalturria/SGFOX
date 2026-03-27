*
* Consulta de Partes Quirurgicos fechas desde / hasta de pacientes internados
*
Parameters mfecdes, mfechas,mbusco

If Used('mwkservicios')
	Use In mwkservicios
Endif
If Used("mwkpquir")
	Use In mwkpquir
Endif
If Used("mwkpquir00")
	Use In mwkpquir00
Endif
If Used("mwkpacint01")
	Use In mwkpacint01
Endif
If Used("mwkpacint02")
	Use In mwkpacint02
Endif
If Used("mwkpacin")
	Use In mwkpacin
Endif
If Vartype(mbusco)#"C"
	mbusco = ''
Endif
mfecdesInt = mfecdes - 1
mfechasint = mfechas +1
mfecdescx = mfecdes -4
mret = SQLExec(mcon1,"select * from servicios","mwkservicios")
If mret < 0
	Messagebox("EN CONSULTA DE SERVICIOS"+Chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Else
	mret = SQLExec(mcon1, " SELECT tabquirofano.ID , Cardiologo , CirujanoTE ,   "+;
		" Edad , TabQuirofano.Estado , FechaQuirof , NroProtocolo  ,TabQuirofano.NroQuirofano , Nroregistrac ,"+;
		" OperCod , Operacion , PacNombre ,codmed,cirujano,ent_descrient,diagnostico,ent_codent, "+;
		" REG_fecnacimiento, REG_nrohclinica, Servicio, SER_descripserv "+;
		" FROM TabQuirofano "+;
		" left join entidades on entidades.ENT_codent = TabQuirofano.codent "+;
		" left join servicios on servicios.ser_codserv = TabQuirofano.servicio "+;
		" left outer join registracio on Registracio.REG_nroregistrac = TabQuirofano.Nroregistrac "+;
		" where FechaQuirof >= ?mfecdes And FechaQuirof < ?mfechasint "+mbusco,"mwkpquir00")

	If mret < 0
		Messagebox("EN CONSULTA DE PARTE QUIRURGICO 1"+Chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
	Else

		mret = SQLExec(mcon1, "select APV_CodAdmision ,APV_FechaSolicitud,APV_DescripSolic ,APV_FechaCirugia " + ;
			" from  autPREVIAS   " + ;
			" where  APV_PresInsu = 'Q'  and APV_FechaCirugia>= ?mfecdescx "+;
			"  " , "mwkpacac")

		mret = SQLExec(mcon1, "select pac_codadmision , Pac_codhci,Pac_fechaadmision, Pac_horaadmision, "+;
			"   Pac_fechaalta ,Pac_horaalta " + ;
			" from   pacientes inner join pacinternad on pac_codadmision = pin_codadmision " + ;
			"  " , "mwkpacint1")
		mret = SQLExec(mcon1, "select pac_codadmision , Pac_codhci,Pac_fechaadmision, Pac_horaadmision, "+;
			"  Pac_fechaalta ,Pac_horaalta " + ;
			" from   pacientes " + ;
			" where    PAC_fechaalta >?mfecdes   and pac_tipopac = 1 "+;
			"  " , "mwkpacint2")
		If mret < 0
			Messagebox("EN CONSULTA DE PARTE QUIRURGICO 2"+Chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
		Endif

*Select * From mwkpacin1 Union All Select * From mwkpacin0 Into Cursor mwkpacint
		Select * From mwkpacint2 Union All Select * From mwkpacint1 Into Cursor mwkpacint

		Select mwkpquir00.*,mwkMedrpzt.nombre,mwkMedrpzt.codesp As codespP, ;
			mwkpacint.*,mwkpacac.*  ;
			from mwkpquir00 ;
			inner Join mwkpacint On mwkpacint.Pac_codhci= mwkpquir00.Nroregistrac  Left Join mwkMedrpzt On mwkMedrpzt.Id = mwkpquir00.codmed ;
			left Join mwkpacac On mwkpacac.APV_CodAdmision  =  mwkpacint.Pac_codadmision ;
			group By mwkpquir00.Id Into Cursor mwkpquir   &&mwkpquir_a

	Endif
Endif
