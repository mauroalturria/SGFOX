*!*	--------------------------------------------------------------------------
* BUSCA PACIENTES
*!*	--------------------------------------------------------------------------
Parameter mbusco1, nroreg,mbuscop
Do sp_busco_estados With 57,' and Tipo = 3 ','mwkbloqueaplan'
mcpoplan = ''
If mwkbloqueaplan.estado = 0
	mcpoplan = ',AFI_idplan '
Endif
mfecpas = Ctod("01/01/1900")
If Vartype(mbuscop)<>"C"
	mbuscop=""
Endif
mnr = ''
If Vartype(nroreg)="N"
	mnr = " REG_nroregistrac <> ?nroreg "
Endif
Use In Select('mwkbuscopa1')
Use In Select('mwkbuspadron')

mret = SQLExec(mcon1,"select REG_nrohclinica, REG_nombrepac, REG_domicilio, "+;
	"reg_tipodocumento, REG_numdocumento, REG_fecaltapadron, reg_cuit," + ;
	"REG_fecnacimiento, REG_fecbajapadron, " + ;
	"REG_nroregistrac, REG_cpostal, REG_provincia, " + ;
	"REG_localidad, REG_sexo, REG_telefonos,REG_fechamod, " + ;
	"blr_codigobloqueo, blr_descripcion, REG_bloq_comen, REG_distrito, TPV_Estado, " + ;
	"TPV_Audit, TPV_Observa,reg_email "  +;
	"FROM registracio " + ;
	"left outer join bloqregist on registracio.REG_bloqueo = bloqregist.blr_codigobloqueo " + ;
	"left outer join TabPacVip on registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
	"where &mbusco1 " + mnr , "mwkbuscopa0")

If mret <= 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif

If At("afi_nroafiliado",Lower(mbusco1))>0
	pbusco = Strtran(Lower(mbusco1) ,'afi_nroafiliado','NroAfiliado')
	pbusco = Strtran(Lower(pbusco) ,'afi_codentidad','Entidad')
Else
	pbusco = Strtran(Lower(mbusco1) ,'reg_numdocumento','Documento')
Endif
If At("reg_tipodocumento",Lower(pbusco ))>0
	pbusco = Strtran(Lower(pbusco) ,'reg_tipodocumento','TipoDocumento')
Endif
pbusco = IIF(!EMPTY(mbuscop),mbuscop,Left(pbusco,Rat("and",pbusco )-1 ))
mret = SQLExec(mcon1,"select ApeyNom , CUIL , Documento  "+;
	", FecEgreso , FecIngreso , FecNac , Nombre , NroAfiliado "+;
	", Sexo , TipoDocumento,entidad,plan,AFTipoAfiliacion  "+;
	" FROM PadCabe where  " + pbusco , "mwkbuspadron")

If mret <= 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif

If At("reg_numdocumento",Lower(mbusco1))>0

	qbusco = Strtran(Lower(mbusco1) ,'reg_numdocumento','TRD_NroDoc')

	mret = SQLExec(mcon1,"select REG_nrohclinica, REG_nombrepac, REG_domicilio, "+;
		"cast(TRD_TipoDoc as character) as reg_tipodocumento, "+;
		"cast(TRD_NroDoc as float) as REG_numdocumento, REG_fecaltapadron, reg_cuit, " + ;
		"REG_fecnacimiento, REG_fecbajapadron, " + ;
		"REG_nroregistrac, REG_cpostal, REG_provincia, " + ;
		"REG_localidad, REG_sexo, REG_telefonos,REG_fechamod, " + ;
		"blr_codigobloqueo, blr_descripcion, REG_bloq_comen, REG_distrito, TPV_Estado, " + ;
		"TPV_Audit, TPV_Observa,reg_email "+;
		"FROM TabRegDocu, registracio " + ;
		"left outer join bloqregist on registracio.REG_bloqueo = bloqregist.blr_codigobloqueo " + ;
		"left outer join TabPacVip on registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
		"Where "+qbusco +mnr +" and TRD_fechapasiva = ?mfecpas and TRD_Registracio = REG_nroregistrac ", "mwkbuscopa01")

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif

	If Reccount('mwkbuscopa01')>0
		Select REG_nrohclinica, REG_nombrepac, REG_domicilio, ;
			reg_tipodocumento + Space(17) As reg_tipodocumento, REG_numdocumento, REG_fecaltapadron, ;
			REG_fecnacimiento, REG_fecbajapadron,  ;
			REG_nroregistrac, REG_cpostal, REG_provincia,  reg_cuit,;
			REG_localidad, REG_sexo, REG_telefonos,REG_fechamod, ;
			blr_codigobloqueo, blr_descripcion, REG_bloq_comen, REG_distrito, TPV_Estado, ;
			TPV_Audit, TPV_Observa,reg_email ;
			from mwkbuscopa01 ;
			Into Cursor mwkbuscopa1
	Else
		Select * From mwkbuscopa0 Into Cursor mwkbuscopa1
	Endif
Else
	Select * From mwkbuscopa0 Into Cursor mwkbuscopa1
Endif
If Used('mwkbuspacie1')
	If mwkbuspacie1.preacre = 1  &&& tengo que buscar las entidades
		Select Distinct REG_nroregistrac ;
			From mwkbuscopa1 ;
			Into Cursor mwkregis

		Select mwkregis
		mwhere = ' where AFI_codentidad = ENT_codent  and registracio in ('+Transf(REG_nroregistrac)

		Select mwkregis
		Skip Iif(Eof('mwkregis'),0,1)
		Do While !Eof('mwkregis')
			mwhere = mwhere + ","+Transf(REG_nroregistrac)
			Select mwkregis
			Skip
		Enddo
		mwhere = mwhere + ")"

		mret = SQLExec(mcon1,"select registracio, ENT_codent "+mcpoplan +;
			"FROM afiliacion, entidades " + ;
			"" + mwhere +  " " + ;
			"and ENT_fecpas is null " + ;
			"order by AFI_fechabaja desc ","mwkafi")

		If mret < 0
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif

		Select mwkbuscopa1.*,ENT_codent From mwkbuscopa1,mwkafi;
			where REG_nroregistrac = registracio  ;
			group By REG_nroregistrac,reg_tipodocumento ;
			order By TPV_Estado,REG_nombrepac ;
			into Cursor mwkbuscopa
	Else
		Select * From mwkbuscopa1 ;
			group By REG_nroregistrac,reg_tipodocumento ;
			order By TPV_Estado,REG_nombrepac ;
			into Cursor mwkbuscopa
	Endif
Else
	Select * From mwkbuscopa1 ;
		group By REG_nroregistrac,reg_tipodocumento ;
		order By TPV_Estado,REG_nombrepac ;
		into Cursor mwkbuscopa
Endif

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Messagebox(eros(3))
	Do prg_cancelo
Endif
