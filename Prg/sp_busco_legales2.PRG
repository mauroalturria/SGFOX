*
* Busqueda en mestro legales, según argumentos
*
Lparameters mwhere

If used('mwklegales')
	Use in mwklegales
Endif

If used('mwklegalesA')
	Use in mwklegalesA
Endif

mret = sqlexec(mcon1,"select TabLGDema.Id as TLG_idema,TLD_freclamo,TLD_fecinimed,TLD_fecacuerdo,"+;
	"TLD_nroregistrac,TLD_idHecho,TAV_idAsegura,TLD_idEstado,REG_nombrepac,REG_numdocumento,TLD_actor,"+;
	"TLD_montoreq,TLD_montofre,TLD_montacor,TLD_monsent,TLM_nombremed,TAV_idasegura,TLD_fecsiniestro,"+;
	"TLD_idservicio"+;
	" from registracio,TabLGAsegv,TabLGDEma "+;
	" left join TabLGMedv on TabLGMedv.TLM_idreclamo = TabLGDema.Id"+;
	" where TLD_nroregistrac=REG_nroregistrac and TLD_nroregistrac>0 and "+mwhere+;
	" order by TabLGDema.Id","mwklegalesA")

If mret > 0

	If used('mwklegalesB')
		Use in mwklegalesB
	Endif

	mret = sqlexec(mcon1,"select TabLGDema.Id as TLG_idema,TLD_freclamo,TLD_fecinimed,TLD_fecacuerdo,"+;
		"TLD_nroregistrac,TLD_idHecho,TAV_idAsegura,TLD_idEstado,"+;
		"TLP_nombre as REG_nombrepac,TLP_nrodocumento as REG_numdocumento,TLD_actor,"+;
		"TLD_montoreq,TLD_montofre,TLD_montacor,TLD_monsent,TLM_nombremed,TAV_idasegura,"+;
		"TLD_fecsiniestro,"+;
		"TLD_idservicio"+;
		" from TabLGPrereg,TabLGAsegv,TabLGDEma "+;
		" left join TabLGMedv on TabLGMedv.TLM_idreclamo = TabLGDema.Id"+;
		" where TLD_nroregisext=TabLGPrereg.id and TLD_nroregisext>0 and "+mwhere+;
		" order by TabLGDema.id","mwklegalesB")
Endif

If mret > 0

	Select * from mwklegalesA union select * from mwklegalesB into cursor mwklegales

	If used('mwklegalesI')
		Use in mwklegalesI
	Endif

	If used('mwkasegrep')
		Use in mwkasegrep
	Endif

	mret = sqlexec(mcon1,"select tav_idreclamo as TAV_idreclamo1,count(tav_idreclamo) as Tav_casegura"+;
		" from TabLGAsegv group by tav_idreclamo","mwkasegrep")

	If mret < 0
		Messagebox("EN CONSULTA DE ASEGURADORAS ASIGNADAS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return
	Endif

	If used('mwkmedrep')
		Use in mwkmedrep
	Endif

	mret = sqlexec(mcon1,"select TLM_idreclamo as TLM_idreclamo1,count(TLM_idreclamo) as TLM_casmedico"+;
		" from TabLGMedv group by TLM_idreclamo","mwkmedrep")

	If mret > 0


		Set date to ymd

		msql = "Select mwklegales.TLG_idema as orden,Transform(left(dtoc(TLD_freclamo),7),'9999/99') as Freclamo,"+;
			"Transform(left(dtoc(TLD_fecinimed),7),'9999/99') as FIniMed,"+;
			"Transform(left(dtoc(TLD_fecacuerdo),7),'9999/99') as FAcuerdo,"+;
			"REG_nombrepac as nombre,REG_numdocumento as documento,"+;
			"mwkHechosg.TLH_descrip as hecho,"+;
			"alltrim(mwkAsegura.TLA_nombre)+iif(mwkasegrep.Tav_casegura>1,' /otras','') as seguro,"+;
			"mwkEstado.descrip as lestado,TLD_actor as lactor,"+;
			"TLD_montoreq,TLD_montofre,TLD_montacor,TLD_monsent,"+;
			"alltrim(TLM_nombremed)+iif(mwkmedrep.TLM_casmedico>1,' /otros','') as TLM_nombremed1,"+;
			"TAV_idasegura,TLD_fecsiniestro,TLD_idservicio,mwkServ.ser_descripserv "+;
			" from mwkEstado,mwkAsegura,mwkHechosg,mwkasegrep,mwklegales "+;
			" left join mwkmedrep on mwkmedrep.TLM_idreclamo1 = mwklegales.TLG_idema "+;
			" left join mwkServ on mwkServ.ser_codserv = TLD_idservicio "+;
			" where"+;
			" mwklegales.TLD_idHecho = mwkHechosg.TLH_idcod and"+;
			" mwklegales.TAV_idAsegura = mwkAsegura.lid and"+;
			" mwklegales.TLD_idEstado = mwkEstado.Subestado and"+;
			" mwklegales.TLG_idema = mwkasegrep.TAV_idreclamo1"+;
			" group by mwklegales.TLG_idema order by mwklegales.TLG_idema into cursor mwklegalesI"
			
		&msql
		If used('mwklegalesI')
			If reccount('mwklegalesI')>0
				Select * from mwklegalesI into cursor mwklegales
			Endif
		Endif
		Set date to dmy
	Else
*		Messagebox("EN CONSULTA DE MEDICOS ASIGNADOS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		=aerror(merror)
		Messagebox(merror(3))

	Endif
Else
*	Messagebox("EN BUSQUEDA DE REQUERIMIENTOS/DEMANDAS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	=aerror(merror)
	Messagebox(merror(3))
Endif
Return
