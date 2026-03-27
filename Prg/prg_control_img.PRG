Lparameters tdFecIni, tdFecFin, tcNomCursor
*!*	Clear 
*!*	Set Escape On

*mCon1 = Sqlconnect("172.16.1.3")
lcCodServ = 7700

*!*	7700 tomo
*!*	7100 rayos

lnCant = (tdFecFin - tdFecIni) + 1
ldFec = tdFecIni

Use In Select("mwkValesAux")

For I = 1 To lnCant 
	If !Used("mwkValesAux")

		mRet = Sqlexec(mcon1,"Select Pacientes.PAC_nombrepaciente, PAC_codhce, " + ;
			"VALESASIST.val_codadmision, " + ;
			"VALESASIST.val_codsector, " + ;
			"VALESASIST.val_codvaleasist, " + ;
			"VALESASIST.val_horasolicitud, " + ;
			"VALESASIST.val_nroprotocolo, " + ;
			"VALESASIST.val_tipopaciente, " + ;
			"VALESASIST.Val_CodServVale, " + ;
			"VALESASIST.VAL_fechasolicitud, " + ;
			"VALESASIST.VAL_codpun, TabValObs.TVO_SubEstado " + ;
			",VALESASIST.VAL_FHSolicitud " + ;
			"from VALESASIST " + ;
			"Left join Pacientes on Val_CodAdmision = PAC_codadmision " + ;
			"Left join TabValObs on TabValObs.TVO_codpun = valesasist.VAL_codpun " + ; 
			"where VAL_fechasolicitud = ?ldFec " + ;
			"  ","mwkValesAux")

		If mRet<=0
			Messagebox("ERROR EN LA LECTURA DE PROTOCOLOS",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		 	Return .f.
		Endif 

	Else
		mRet = Sqlexec(mcon1,"Select Pacientes.PAC_nombrepaciente, PAC_codhce, " + ;
			"VALESASIST.val_codadmision, " + ;
			"VALESASIST.val_codsector, " + ;
			"VALESASIST.val_codvaleasist, " + ;
			"VALESASIST.val_horasolicitud, " + ;
			"VALESASIST.val_nroprotocolo, " + ;
			"VALESASIST.val_tipopaciente, " + ;
			"VALESASIST.Val_CodServVale, " + ;
			"VALESASIST.VAL_fechasolicitud, " + ;
			"VALESASIST.VAL_codpun, TabValObs.TVO_SubEstado " + ;
			",VALESASIST.VAL_FHSolicitud " + ;
			"from VALESASIST " + ;
			"Left join Pacientes on Val_CodAdmision = PAC_codadmision " + ;
			"Left join TabValObs on TabValObs.TVO_codpun = valesasist.VAL_codpun " + ; 
			"where VAL_fechasolicitud = ?ldFec " + ;
			"  ","mwkValesApp")

		If mRet<=0
			Messagebox("ERROR EN LA LECTURA DE PROTOCOLOS",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		 	Return .f.
		Endif 

		Select mwkValesAux
		Append From Dbf("mwkValesApp")

	Endif 
	
	ldFec = tdFecIni + I 
	
	
Next 

Select *, prg_proto_en_img(val_nroprotocolo, .t.) as Result ;
	From mwkValesAux ;
	Where Val_CodServVale = lcCodServ ;
	Having Result = .F.  And TVO_SubEstado Not in (89, 82);
	Group By VAL_codpun ;
	Into Cursor &tcNomCursor
	
Use In Select("mwkValesAux")


	




*Sqldisconnect(mCon1)