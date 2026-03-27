	msep = ":"
mbusco1 = '170083-9'
	mret = sqlexec(mcon3, "select pac_nombrepaciente, pac_edad, sec_codsector, " + ;
							"sec_descripsec, pac_habitacion, pac_cama, ent_descrient, " + ;
							"pac_sexo, pac_edad, pac_codadmision, pac_fechaadmision, " + ;
							"pac_horaadmision , " + ;
							"pac_codhce, afi_nroafiliado, pac_descripdiagn, " + ;
							"pac_fechaalta,pac_categoria, entidexclu.fecpasiva " + ;
							"from pacinternad,entidades, sectores " + ;
							"left join  pacientes on pin_codadmision = pac_codadmision " +;
							"left join  afiliacion on " +;
   							"	pac_codhci = registracio and " + ;
   							"	pin_codentidad = afi_codentidad " + ;
							"left join  entidexclu on pin_codentidad = entidexclu.codent  " +;
 							"where pin_codentidad   = ent_codent and " + ;
       							"pac_sectorinternac = sec_codsector and pac_codadmision = ?mbusco1 " + ;
       						"order by pac_nombrepaciente", "mwkbuspacie1") 
 
	if mret<1
		=aerr(eros)
		messagebox(eros(2))

	endif       						
