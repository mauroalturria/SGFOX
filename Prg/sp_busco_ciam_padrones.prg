*
* Busqueda en REGISTRACIO, PADCABE, TABCIAMENTIDAD
*
Parameter mnrobus, mqbusco, mqpadron

If vartype(mqpadron)#"N"
	mqpadron = 0
Endif

If vartype(mqbusco)#"N"
	mqbusco = 1
Endif

If mqpadron=1 or mqpadron=0
*
* REGISTRACIO
*
	Select mwkciamg1
	Go top
	Zap
	Do case
	Case mqbusco = 1
		mbuscar = " where registracio.REG_numdocumento = ?mnrobus and "
	Case mqbusco = 2
		mbuscar = " where afiliacion.AFI_nroafiliado = ?mnrobus and "
	Case mqbusco = 3
		mbuscar = " where registracio.REG_nroregistrac = ?mnrobus and "
	Endcase
	Do sp_busco_nombre_paciente with mbuscar,1
	If used('mwkbuspacie')
		If reccount('mwkbuspacie')>0
			Select mwkbuspacie
			Scan
				If len(alltrim(nvl(mwkbuspacie.ENT_descrient,'')))>0
					mdireccion   = nvl(mwkbuspacie.REG_domicilio,'')
					mlocalidad   = nvl(mwkbuspacie.REG_localidad,'')
					mprovincia   = nvl(mwkbuspacie.REG_provincia,'')
					mfecnac      = nvl(mwkbuspacie.REG_fecnacimiento,ctod('  /  /    '))
					msexo        = nvl(mwkbuspacie.REG_sexo,'')
					mnombre      = nvl(mwkbuspacie.REG_nombrepac,'')
					mdocumento   = nvl(mwkbuspacie.REG_numdocumento,0)
					mnroregistra = mwkbuspacie.REG_nroregistrac
					Insert into mwkciamg1 (GCI_nombre,GCI_nroafi,GCI_entidad,GCI_fechabaja,GCI_direccion,;
						GCI_localidad,GCI_provincia,GCI_fecnac,GCI_sexo,GCI_documento,GCI_Idos,GCI_nregistracio);
						values ;
						(mnombre,mwkbuspacie.AFI_nroafiliado,mwkbuspacie.ENT_descrient,nvl(mwkbuspacie.ENT_fecpas,;
						ctod('  /  /    ')),mdireccion,mlocalidad,mprovincia,mfecnac,msexo,mdocumento,;
						mwkbuspacie.ENT_codent,mnroregistra)
				Endif
			Endscan
		Endif
	Endif
Endif

If mqpadron=2 or mqpadron=0
*
* PADCABE
*
	Select mwkciamg2
	Go top
	Zap
	If used('mwkpadcabe')
		Use in mwkpadcabe
	Endif
	If used('mwkpadcab')
		Use in mwkpadcab
	Endif
	mfct = ctod("01/01/2100")

	mbus = iif(mqbusco=1,"documento","NroAfiliado")+"=?mnrobus"

	mret = sqlexec(mcon1,"select id,* from PadCabe where " + mbus +;
		" and fecegreso=?mfct","mwkpadcabe")

	If mret > 0
		Select mwkpadcabe
		Go top
		If reccount('mwkpadcabe')>0
			Scan
				mentidad     = mwkpadcabe.Entidad
				midpadca     = mwkpadcabe.id
				msexo        = nvl(mwkpadcabe.sexo,'')
				mdocumento   = nvl(mwkpadcabe.documento,0)
				mnombre      = nvl(mwkpadcabe.apeynom,'')
				mfecnac      = nvl(mwkpadcabe.fecnac,ctod('  /  /    '))

				If used('mwkpadcabe0')
					Use in mwkpadcabe0
				Endif
				mret = sqlexec(mcon1,"select * from PadDomicilio where IDPadCabe=?midpadca","mwkpadcabe0")
				mdireccion = ''
				If mret > 0
					Select mwkpadcabe0
					Go top
					If reccount('mwkpadcabe0')>0
						mdireccion = mwkpadcabe0.domicilio+' '+alltrim(str(nvl(mwkpadcabe0.numero,0)))
						mlocalidad = nvl(mwkpadcabe0.localidad,'')
						mprovincia = nvl(mwkpadcabe0.provincia,'')
					Endif
				Else
					Messagebox("EN BUSQUEDA DE DOMICLIO PADRON",0+16,"ERROR")
				Endif
				mret = sqlexec(mcon1,"select * from entidades " + ;
					"where " + ;
					"entidades.ENT_codent = ?mentidad", "mwkpadcab2")
				If mret > 0
					If used('mwkpadcab3')
						Use in mwkpadcab3
					Endif
					Select NroAfiliado, ENT_descrient, Entidad, ;
						ENT_fecpas, ENT_codent, ENT_turnoshabilit, ENT_capita ;
						from mwkpadcabe, mwkpadcab2 where ;
						mwkpadcabe.Entidad = mwkpadcab2.ENT_codent into cursor mwkpadcab3
					Select mwkpadcab3
					Go top
					Scan
						Insert into mwkciamg2 (GCI_nombre,;
							GCI_nroafi,;
							GCI_entidad,;
							GCI_fechabaja,;
							GCI_direccion,;
							GCI_localidad,;
							GCI_provincia,;
							GCI_fecnac,;
							GCI_sexo,;
							GCI_documento,;
							GCI_Idos) values ;
							(mnombre,;
							alltrim(str(mwkpadcab3.NroAfiliado,20)),;
							mwkpadcab3.ENT_descrient,;
							nvl(mwkpadcab3.ENT_fecpas,ctod('  /  /    ')),;
							mdireccion,;
							mlocalidad,;
							mprovincia,;
							mfecnac,;
							msexo,;
							mdocumento,;
							mwkpadcab3.Entidad)
					Endscan
				Else
					Messagebox("EN BUSQUEDA DE ENTIDADES",0+16,"ERROR")
				Endif
			Endscan
		Endif
	Else
		Messagebox("EN BUSQUEDA DEL DOCUMENTO EN PADRONES",0+16,"ERROR")
	Endif
Endif

If mqpadron=3 or mqpadron=0
*
* PADRON CIAM OTRAS ENTIDADES
*
	Select mwkciamg3
	Go top
	Zap
	If used('mwkpadentl')
		Use in mwkpadentl
	Endif

	mbus = iif(mqbusco=1,"TCD_documento","TCD_nroafi")+"=?mnrobus"

	mret = sqlexec(mcon1,"select TCD_nombrepac,TCD_nroafi,ENT_descrient,ENT_fecpas,ENT_codent,TCD_documento"+;
		" from TabCiamderiva"+;
		" left join entidades on entidades.ENT_codent = TabCiamderiva.TCD_entidad"+;
		" where TCD_tipoent=3 and "+mbus+;
		" group by TCD_entidad","mwkpadentl")

	If mret > 0
		If used('mwkpadentl')
			If reccount('mwkpadentl')>0
				Select mwkpadentl
				Scan
					mnom = mwkpadentl.TCD_nombrepac
					If vartype(mwkpadentl.TCD_nroafi)="N"
						mafi = Alltrim(str(nvl(mwkpadentl.TCD_nroafi,0)))
					Else
						mafi = Alltrim(nvl(mwkpadentl.TCD_nroafi,'0'))
					Endif
					mdes = nvl(mwkpadentl.ENT_descrient,'')
					mbaj = nvl(mwkpadentl.ENT_fecpas,{//})
					mcod = mwkpadentl.ENT_codent
					mdoc = mwkpadentl.TCD_documento
					Insert into mwkciamg3 (GCI_nombre,GCI_nroafi,GCI_entidad,GCI_fechabaja,GCI_codent,GCI_documento);
						values;
						(mnom,mafi,mdes,mbaj,mcod,mdoc)
				Endscan
			Endif
			Use in mwkpadentl
		Endif
	Else
		Messagebox("EN CONSULTA DE ENTIDADES NUEVAS PARA EL BENEFICIARIO",16,"ERROR")
	Endif
Endif

Return
