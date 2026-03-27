****
** busco internados aislados
****
Parameters mbusco1ac

mbusco1ac = Iif(Vartype(mbusco1ac)#"C",'',mbusco1ac)

*!*	--------------------------------------------------------------
*!*	Car 11/12/2014
*!*	--------------------------------------------------------------
Do sp_busco_estados With 25," and tipo = 45 ","mwktipoaisla"

mret = SQLExec(mcon1, "select apv_codadmision, apv_estado , apv_fechaauditoria"+;
	", apv_horaauditoria , apv_idautprevias"+;
	", apv_descripsolic, APVP_tipoaisla "+;
	" from Zautprevprm " + ;
	" inner join autprevias on Zautprevprm.APVP_idAutprevia = autprevias.id " + ;
	" inner join pacinternad on autprevias.apv_codadmision = pacinternad.pin_codadmision " + ;
	" where APV_Estado = 3 and apv_presinsu = 'S' "  + mbusco1ac +;
	" group by autprevias.id ", "mwkpacint0")

If mret<1
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR MWKPACINT00",48,"VALIDACION")
	Return .F.
Endif
mret = SQLExec(mcon1," SELECT PACIENTE,IdMotivo,Atendido,horaatencion    "+;
	" FROM	SOCIO " + ;
	" WHERE	 IdMotivo = 68  AND HoraLLegada>=?MIFECHA and atendido = 1 ","mwknoaislac")

mret = SQLExec(mcon1," SELECT PACIENTE,IdMotivo,Atendido,horaatencion    "+;
	" FROM	SOCIOhis " + ;
	" WHERE	 IdMotivo = 68  AND horaatencion >=?MIFECHA and atendido = 1 ","mwknoaislah")
Select * From mwknoaislah Union All;
	select * From mwknoaislac;
	into Cursor mwknoaisla
Select apv_codadmision,horaatencion,Ctot(Dtoc(apv_fechaauditoria)+" "+Left(Ttoc(apv_horaauditoria,2),5)) As horaaud ;
	From MWKPACINT0,mwknoaisla ;
	Where Left(mwknoaisla.paciente,8) = MWKPACINT0.apv_codadmision Order By apv_codadmision,horaatencion ;
	Into Cursor mwkpacintnoaist

Select * From mwkpacintnoaist Where horaaud < horaatencion Group By apv_codadmision Into Cursor mwkpacintnoais


Select MWKPACINT0.*,Descrip As tipoaisla;
	From MWKPACINT0,mwktipoaisla;
	Where mwktipoaisla.estado = APVP_tipoaisla ;
	AND apv_codadmision Not In (Select apv_codadmision  From mwkpacintnoais Where horaaud < horaatencion);
	Group By apv_codadmision Into Cursor mwkpacintaisla
Return .T.
