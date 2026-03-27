Lparameters miadmi,mcursor
If Vartype(mcursor)#"C"
	mcursor = "mwkpacint01"
Endif
mret = SQLExec(mcon1, "select apv_codadmision, apv_estado , apv_fechaauditoria"+;
	",apv_observaciones , apv_descripsolic,apv_idautprevias,IAP_Estado, IAP_Fechora1Control,IAP_FechoraFin, "+;
	"IAP_FechoraInicio,  IAP_TipoAisla,APVP_tipoaisla  "+;
	" from autprevias " + ;
	" inner join pacientes on pacientes.pac_codadmision = autprevias.apv_codadmision " + ;
	" inner join pacinternad on pacientes.pac_codadmision = pacinternad.pin_codadmision " + ;
	" left join Zautprevprm on autprevias.id = Zautprevprm.APVP_idAutprevia " + ;	
	" left join Zabintaislapac on autprevias.id = Zabintaislapac .IAP_IdAutprevia " + ;
	" where  pac_codadmision = ?miadmi and apv_presinsu ='S' and apv_descripsolic %STARTSWITH 'AISLAMIENTO' "+;
	" order by apv_idautprevias desc ", mcursor)
If mret<1
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR",48,"VALIDACION")
	Return .F.
Else
	Return apv_descripsolic
Endif
