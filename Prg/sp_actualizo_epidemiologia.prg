*
* Actualizacion de Ficha Epidemiologica & Contactos
*
Lparameters mf

muse = mwkusuario.idusuario
mfec = sp_busco_fecha_serv('DT')

mret = sqlexec(mcon1,"update TabFichEp set"+;
	" FE_ocup       =?mf[02]"+;
	",FE_domlab     =?mf[03]"+;
	",FE_telab      =?mf[04]"+;
	",FE_vacgr      =?mf[05]"+;
	",FE_fecvac     =?mf[06]"+;
	",FE_viajo      =?mf[07]"+;
	",FE_vlugar     =?mf[08]"+;
	",FE_fecvdes    =?mf[09]"+;
	",FE_fecvhas    =?mf[10]"+;
	",FE_linea      =?mf[11]"+;
	",FE_nrovuelo   =?mf[12]"+;
	",FE_nroasie    =?mf[13]"+;
	",FE_contacto   =?mf[14]"+;
	",FE_nombrecon  =?mf[15]"+;
	",FE_insesclab  =?mf[16]"+;
	",FE_fecini     =?mf[17]"+;
	",FE_feccon     =?mf[18]"+;
	",FE_ambulat    =?mf[19]"+;
	",FE_internado  =?mf[20]"+;
	",FE_optdat     =?mf[21]"+;
	",FE_rxtorax    =?mf[22]"+;
	",FE_descimg    =?mf[23]"+;
	",FE_ttoantiv   =?mf[24]"+;
	",FE_destto     =?mf[25]"+;
	",FE_diastto    =?mf[26]"+;
	",FE_complica   =?mf[27]"+;
	",FE_chkcomp    =?mf[28]"+;
	",FE_hnfmue     =?mf[29]"+;
	",FE_hnffproc   =?mf[30]"+;
	",FE_hnfresul   =?mf[31]"+;
	",FE_hnfobs     =?mf[32]"+;
	",FE_anffmue    =?mf[33]"+;
	",FE_anffproc   =?mf[34]"+;
	",FE_anfresul   =?mf[35]"+;
	",FE_anfobs     =?mf[36]"+;
	",FE_smafmue    =?mf[37]"+;
	",FE_smafproc   =?mf[38]"+;
	",FE_smaresul   =?mf[39]"+;
	",FE_smaobs     =?mf[40]"+;
	",FE_smbfmue    =?mf[41]"+;
	",FE_smbfproc   =?mf[42]"+;
	",FE_smbresul   =?mf[43]"+;
	",FE_smbobs     =?mf[44]"+;
	",FE_fecalta    =?mf[45]"+;
	",FE_deriva     =?mf[46]"+;
	",FE_hptal      =?mf[47]"+;
	",FE_fallecido  =?mf[48]"+;
	",FE_fecfallece =?mf[49]"+;
	",FE_clasfinal  =?mf[50]"+;
	",FE_comenta    =?mf[51]"+;
	",FE_comorb     =?mf[52]"+;
	",FE_comordet   =?mf[54]"+;
	",FE_csintomas  =?mf[53]"+;
	",FE_usuario    =?muse"  +;
	",FE_ipadress   =?myip"  +;
	",FE_fecmodifica=?mfec"  +;
	",FE_pais       =?mf[55]"+;
	",FE_triva      =?mf[56]"+;
	",FE_triot      =?mf[57]"+;
	",FE_relviaje   =?mf[58]"+;
	",FE_contave    =?mf[59]"+;
	",FE_cavedon    =?mf[60]"+;
	",FE_tipoinf    =?mf[61]"+;
	",FE_subtipo    =?mf[62]"+;
	",FE_sinsubt    =?mf[63]"+;
	",FE_otrovir    =?mf[64]"+;
	",FE_otrodon    =?mf[65]"+;
	",FE_gesta      =?mf[66]"+;
	",FE_fecinitto  =?mf[67]"+;
	",FE_amblug     =?mf[68]"+;
	",FE_fecnotifica=?mf[69]"+;
	",FE_hospital   =?mf[70]"+;
	",FE_fecint     =?mf[71]"+;
	",FE_intsala    =?mf[72]"+;
	",FE_sospbronq  =?mf[73]"+;
	",FE_sospinflu  =?mf[74]"+;
	",FE_sospneumo  =?mf[75]"+;
	",FE_sospotros  =?mf[76]"+;
	",FE_sosptotros =?mf[77]"+;
	" where FE_proto=?mf[01]")

If mret > 0
	If used('mwkcontactos')
		If used('mwkedidat')
			Use in mwkedidat
		Endif
		mret = sqlexec(mcon1,"select id as lid from TabFichEp where FE_usuario=?muse and FE_ipadress=?myip"+;
			" and FE_fecmodifica=?mfec","mwkedidat")
		If mret > 0
			Select mwkedidat
			Go top
			mvid = mwkedidat.lid
			mret = sqlexec(mcon1,"delete from TabFichEpCon where FEC_idfich=?mvid")
			If mret < 0
				Messagebox("EN ACTUALIZACION DE CONTACTOS"+chr(10)+;
					"AVISE A SISTEMAS",16,"ERROR")
			Else
				If reccount('mwkcontactos') > 0
					Select mwkcontactos
					Scan
						mnom = mwkcontactos.TC_apenom
						mrel = mwkcontactos.TC_idtiprel
						mdom = mwkcontactos.TC_domicil
						mtel = mwkcontactos.TC_telef
						mqui = mwkcontactos.TC_quimiopro
						mret = sqlexec(mcon1,"insert into TabFichEpCon"+;
							" (FEC_idfich,FEC_apenom,FEC_tiprel,FEC_direccion,FEC_telefono,FEC_quiprof)"+;
							" values (?mvid,?mnom,?mrel,?mdom,?mtel,?mqui)")
						If mret < 0
							Messagebox("EN INCORPORACION DE CONTACTOS"+chr(10)+;
								"AVISE A SISTEMAS",16,"ERROR")
						Endif
					Endscan
				Endif
			Endif
		Else
*			=aerror(merror)
*			Messagebox(merror(3))
			Messagebox("EN BUSQUEDA DE IDENTIFICADOR DE F.EPIDEMIOLOGIA"+chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
		Endif
	Endif
Else
	mpaso = .f.
	Messagebox("EN ACTUALIZACION DE F.EPIDEMIOLOGIA"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
