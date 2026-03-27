****
** busco internados
****
Parameters mbusco1ac, msql_pac, mnomcur

If Vartype(mnomcur)# "C"
	mnomcur = "mwkpacint"
Endif

mbusco1ac = Iif(Vartype(mbusco1ac)#"C",'',mbusco1ac)


mret = SQLExec(mcon1, "select  apv_cantautorizada , apv_cantefectuadas , apv_cantsolicitada , apv_codadmision"+;
	" from autprevias " + ;
	" left join pacientes on pacientes.pac_codadmision = autprevias.apv_codadmision " + ;
	" where pac_tipopac < 2 "  + mbusco1ac ,mnomcur )
If mret<1
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR",48,"VALIDACION")
	Return .F.
Endif

