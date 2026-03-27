
Parameters ldfecha,lnnumero,miopcion

Do Case

Case miopcion=1

	mret = SQLExec(mcon1,"select  valesasist.*,presinsuvas.PIA_codprest as codprest,informes.estadoinforme,informes.id as nroinf"+;
		",PIA_cantsolicitada,Pacientes.PAC_CentroMedico  from valesasist " + ;
		" inner join pacientes on valesasist.VAL_codadmision = pacientes.PAC_codadmision " + ;
		" left join informes on VAL_nroprotocolo=nroprotocolo" + ;
		" inner join presinsuvas on valesasist.valesasist=presinsuvas.PIA_valesasist" +  ;
		" where  VAL_fechasolicitud=?ldfecha and VAL_nroprotocolo=?lnnumero order by informes.id desc" ,"mwkvalpro")

Case miopcion=2
	mret = SQLExec(mcon1,"select  valesasist.*,presinsuvas.PIA_codprest as codprest,informes.estadoinforme,informes.id as nroinf"+;
		",PIA_cantsolicitada,Pacientes.PAC_CentroMedico from valesasist " + ;
		" inner join pacientes on valesasist.VAL_codadmision = pacientes.PAC_codadmision " + ;
		" left join informes on VAL_nroprotocolo=nroprotocolo" + ;
		" inner join presinsuvas on valesasist.valesasist=presinsuvas.PIA_valesasist " + ;
		" where  VAL_codvaleasist = ?lnnumero order by informes.id desc","mwkvalpro")
Endcase

If mret < 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16,"VALIDACION")
	Return .F.
Endif
