*
* Busqueda de Auditorias de Internación
*
Lparameters mltipo, mopt1, mopt2, mcbo1, mcbo2, mfecha, mllama

mwhereA = ""
mwhereB = ""
mwhereC = ""
mwhere  = "TCI_idmotivo <> 9 "

If used('mwkciam')
	Use in mwkciam
Endif

If vartype(mfecha) <> 'D'
	mfecha = ctod("01/01/1900")
Endif

If vartype(mltipo) <> 'N'
	mltipo = 0
Endif

If vartype(mopt1) <> 'N'
	mopt1 = 1
Endif

If vartype(mopt2) <> 'N'
	mopt2 = 1
Endif

If mltipo = 1
	mwhere  = mwhere  + " and TCI_fecing >= ?mfecha "
Else
	mwhere  = mwhere  + " and TCI_fecegr = '1900-01-01'"
	mfecha2 = mfecha && - 1
	mwhereU = " and (TCI_fecing = ?mfecha or TCI_fecegr >= ?mfecha2 and TCI_fecegr <= ?mfecha) "
Endif

If mopt1 = 2
	mwhereA = " and TCI_idcentro = ?mcbo1 "
Endif

If mopt2 = 2
	mwhereB = " and TCI_idtipo = ?mcbo2 "
Endif

If mllama = 1
	mwhereC = " and TCI_llamado = 0 "
Endif

mwhere =" ("+ mwhere + mwhereA + mwhereB + mwhereC +") "

If mopt1 = 1 and mopt1 = 1 and mltipo = 0 and mllama = 0
	mwhere = mwhere + " or ( TCI_idmotivo <> 9 and CAST(TCI_fecmov as DATE) = ?mfecha ) "
Endif

mret = sqlexec(mcon1,"select TCI_fecing,TCI_nroafi,TCI_nombrepac,TCI_nrodoc,"+;
	"ENT_descrient,TCI_sexo,TCI_diagnos,TabSectorInt.descrip as sec_descripsec,"+;
	"TCI_idmotivo,TCI_fecegr,TabCiamAudInt.id as lidP,TCI_hhmming,TCI_fecnac,"+;
	"TCI_txtedad,TCI_hhmmegr,TCI_idcentro,TabSectorInt.id as lsecid,"+;
	"TCI_enpadron,TCI_enregistracio,TCI_identi,TCI_llamado,TCI_fecmov"+;
	" from TabCiamAudInt"+;
	" join ENTIDADES on ENT_codent = TCI_identi"+;
	" join TabSectorInt on TabSectorInt.id = TCI_idtipo"+;
	" where "+ mwhere,"mwkciam")

*!* TCI_idmotivo = 9 : Registro Pasivado - Baja

If mret > 0

	Select TCI_fecing, mwkClinicaG.descrip as lclinica,INT(TCI_nroafi) as TCI_nroafi,;
		TCI_nombrepac,TCI_nrodoc,ENT_descrient,TCI_sexo,;
		TCI_diagnos,sec_descripsec,lmotdes,;
		iif(TCI_fecegr=ctod('01/01/1900'),{//},TCI_fecegr) as TCI_fecegr2,;
		descrip,lidP,TCI_hhmming,TCI_fecnac,;
		TCI_txtedad,TCI_hhmmegr,TCI_idmotivo,TCI_idcentro,lsecid, ;
		TCI_enpadron,TCI_enregistracio,TCI_identi, mwkClinicaG.lid as lclinicaid,;
		nvl(TCI_llamado,0) as TCI_llamado ,TCI_fecmov;
		from mwkciam ;
		left outer join mwktipo on mwktipo.lidmot = TCI_idmotivo ;
		left outer join mwkClinicaG on mwkClinicaG.lid = TCI_idcentro ;
		into cursor mwkciam

	If mltipo = 0

		If used('mwkciamu')
			Use in mwkciamU
		Endif

		mwhereU = mwhereU + mwhereA + mwhereB + mwhereC

		mret = sqlexec(mcon1,"select TCI_fecing,TCI_nroafi,TCI_nombrepac,TCI_nrodoc,"+;
			"ENT_descrient,TCI_sexo,TCI_diagnos,TabSectorInt.descrip as sec_descripsec,"+;
			"TCI_idmotivo,TCI_fecegr,TabCiamAudInt.id as lidP,TCI_hhmming,TCI_fecnac,"+;
			"TCI_txtedad,TCI_hhmmegr,TCI_idcentro,TabSectorInt.id as lsecid,"+;
			"TCI_enpadron,TCI_enregistracio,TCI_identi,TCI_llamado,TCI_fecmov"+;
			" from TabCiamAudInt"+;
			" join ENTIDADES on ENT_codent = TCI_identi"+;
			" join TabSectorInt on TabSectorInt.id = TCI_idtipo"+;
			" where TCI_idmotivo <> 9 " + mwhereU,"mwkciamu")

		If mret > 0
			If used('mwkciamu')
				If reccount('mwkciamu')>0

					Select TCI_fecing, mwkClinicaG.descrip as lclinica,INT(TCI_nroafi) as TCI_nroafi,;
						TCI_nombrepac,TCI_nrodoc,ENT_descrient,TCI_sexo,;
						TCI_diagnos,sec_descripsec,lmotdes,;
						iif(TCI_fecegr=ctod('01/01/1900'),{//},TCI_fecegr) as TCI_fecegr2,;
						descrip,lidP,TCI_hhmming,TCI_fecnac,;
						TCI_txtedad,TCI_hhmmegr,TCI_idmotivo,TCI_idcentro,lsecid, ;
						TCI_enpadron,TCI_enregistracio,TCI_identi,mwkClinicaG.lid as lclinicaid,;
						nvl(TCI_llamado,0) as TCI_llamado,TCI_fecmov ;
						from mwkciamU ;
						left outer join mwktipo on mwktipo.lidmot = TCI_idmotivo ;
						left outer join mwkClinicaG on mwkClinicaG.lid = TCI_idcentro ;
						into cursor mwkciamU

					Select * from mwkciam union select * from mwkciamU into cursor mwkciam

				Endif
			Endif
		Endif
	Endif
Endif

If mret < 0
	Messagebox("EN CONSULTA DE AUDITORIAS DE INTERNACION",16,"ERROR")
Endif









