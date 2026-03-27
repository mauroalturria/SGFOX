*
* Ingreso FICHA EPIDEMILOGIA
*
Lparameters mf

muse = mwkusuario.idusuario
mfec = sp_busco_fecha_serv('DT')

mret = sqlexec(mcon1,"insert into TabFichEp"+;
	"(FE_proto,FE_ocup,FE_domlab,FE_telab,FE_vacgr,FE_fecvac,FE_viajo,FE_vlugar,"+;
	"FE_fecvdes,FE_fecvhas,FE_linea,FE_nrovuelo,FE_nroasie,FE_contacto,FE_nombrecon,"+;
	"FE_insesclab,FE_fecini,FE_feccon,FE_ambulat,FE_internado,FE_optdat,FE_rxtorax,"+;
	"FE_descimg,FE_ttoantiv,FE_destto,FE_diastto,FE_complica,FE_chkcomp,FE_hnfmue,"+;
	"FE_hnffproc,FE_hnfresul,FE_hnfobs,FE_anffmue,FE_anffproc,FE_anfresul,FE_anfobs,"+;
	"FE_smafmue,FE_smafproc,FE_smaresul,FE_smaobs,FE_smbfmue,FE_smbfproc,FE_smbresul,"+;
	"FE_smbobs,FE_fecalta,FE_deriva,FE_hptal,FE_fallecido,FE_fecfallece,FE_clasfinal,"+;
	"FE_comenta,FE_comorb,FE_comordet,FE_csintomas,FE_usuario,FE_ipadress,FE_fecmodifica,FE_pais,"+;
	"FE_triva,FE_triot,FE_relviaje,FE_contave,FE_cavedon,FE_tipoinf,FE_subtipo,FE_sinsubt,FE_otrovir,"+;
	"FE_otrodon,FE_gesta,FE_fecinitto,FE_amblug,FE_fecnotifica,FE_hospital,FE_fecint,FE_intsala,"+;
	"FE_sospbronq, FE_sospinflu, FE_sospneumo, FE_sospotros, FE_sosptotros)"+;
	" values ("+;
	"?mf[01],?mf[02],?mf[03],?mf[04],?mf[05],?mf[06],?mf[07],?mf[08],?mf[09],?mf[10],?mf[11],?mf[12],"+;
	"?mf[13],?mf[14],?mf[15],?mf[16],?mf[17],?mf[18],?mf[19],?mf[20],?mf[21],?mf[22],?mf[23],?mf[24],"+;
	"?mf[25],?mf[26],?mf[27],?mf[28],?mf[29],?mf[30],?mf[31],?mf[32],?mf[33],?mf[34],?mf[35],?mf[36],"+;
	"?mf[37],?mf[38],?mf[39],?mf[40],?mf[41],?mf[42],?mf[43],?mf[44],?mf[45],?mf[46],?mf[47],?mf[48],"+;
	"?mf[49],?mf[50],?mf[51],?mf[52],?mf[54],?mf[53],?muse,?myip,?mfec,?mf[55],?mf[56],?mf[57],"+;
	"?mf[58],?mf[59],?mf[60],?mf[61],?mf[62],?mf[63],?mf[64],?mf[65],?mf[66],?mf[67],"+;
	"?mf[68],?mf[69],?mf[70],?mf[71],?mf[72],?mf[73],?mf[74],?mf[75],?mf[76],?mf[77])")
	

If mret > 0

	If used('mwkcontactos')
		If used('mwkedidat')
			Use in mwkedidat
		Endif
		mret = sqlexec(mcon1,"select id as lid from TabFichEp where FE_usuario=?muse and FE_ipadress=?myip"+;
			" and FE_fecmodifica=?mfec","mwkedidat")
			
		If mret > 0
			Select mwkedidat
			go top
			mvid = mwkedidat.lid
			If reccount('mwkcontactos') > 0
				Select mwkcontactos
				Scan
					mnom = mwkcontactos.TC_apenom
					mrel = mwkcontactos.TC_idtiprel
					mdom = mwkcontactos.TC_domicil
					mtel = mwkcontactos.TC_telef
					mqui = mwkcontactos.TC_quimiopro
					mret = sqlexec(mcon1,"insert into TabFichEpCon"+;
					"(FEC_idfich,FEC_apenom,FEC_tiprel,FEC_direccion,FEC_telefono,FEC_quiprof)"+;
					" values (?mvid,?mnom,?mrel,?mdom,?mtel,?mqui)")
					If mret < 0
						do log_errores with error(), message(), message(1), program(), lineno()
						Messagebox("EN INCORPORACION DE CONTACTOS"+chr(10)+;
							"AVISE A SISTEMAS",16,"ERROR")

*!*							=aerror(merror)
*!*							Messagebox(merror(3))

					Endif
				Endscan
			Endif
		Else
				do log_errores with error(), message(), message(1), program(), lineno()
				Messagebox("EN BUSQUEDA DE IDENTIFICADOR DE F.EPIDEMIOLOGIA"+chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")

*!*				=aerror(merror)
*!*				Messagebox(merror(3))

		Endif
	Endif
Else

	mpaso = .f.
	do log_errores with error(), message(), message(1), program(), lineno()
	Messagebox("EN INCORPORACION DE UNA F.EPIDEMIOLOGIA"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")

*!*		=aerror(merror)
*!*		Messagebox(merror(3))

Endif


