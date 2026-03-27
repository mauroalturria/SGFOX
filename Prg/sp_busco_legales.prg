*
* Armo cursor maestro Legales Demandas
*
Lparameters mfecha,mpendien,moptg1,moptg2,mcbo1,mcbo2,mproviene

If type('mfecha')="D"
	mbusca = dtoc(mfecha)
	mbuscb = "01/"+right(mbusca,7)
Else
	mbusca = alltrim(str(mfecha))
	mbuscb = "01"+"/"+right(mbusca,2)+"/"+left(mbusca,4)
Endif
mbusca = ctod( mbuscb )

If used('mwklegales')
	Use in mwklegales
Endif

mwhere = ""

If type('mproviene') = "N"
	mwhere = " and TLD_idproviene=?mproviene and TabLGDema.id = TabLGAsegv.TAV_idreclamo "+;
		iif(moptg2=2," and TAV_idasegura=?mcbo2","")
Endif

* TLD_idasegura

if used('mwklegalesA')
  use in mwklegalesA
endif  

mret = sqlexec(mcon1,"select TLD_freclamo,TLD_nroregistrac,TLD_idHecho,TAV_idasegura,TLD_idEstado,"+;
	" REG_nombrepac,REG_numdocumento,TLD_actor,TabLGDema.Id as TLG_idema,"+;
	" TLD_fecacuerdo, TLD_fecsenten, TLD_fechamov"+;
	" from TabLGDEma,registracio,TabLGAsegv "+;
	" where TLD_nroregistrac=REG_nroregistrac and TLD_nroregistrac>0 and TLD_freclamo >= ?mbusca"+;
	mwhere,"mwklegalesA")
	
If mret < 0
	Messagebox("EN BUSQUEDA DE DEMANDAS, AVISE A SISTEMAS",16,"ERROR")
	Return
Endif

if used('mwklegalesB')
  use in mwklegalesB
endif  

mret = sqlexec(mcon1,"select TLD_freclamo,TLD_nroregistrac,TLD_idHecho,TAV_idasegura,TLD_idEstado,"+;
	" TLP_nombre as REG_nombrepac,TLP_nrodocumento as REG_numdocumento,TLD_actor,TabLGDema.Id as TLG_idema,"+;
	" TLD_fecacuerdo, TLD_fecsenten, TLD_fechamov"+;
	" from TabLGDEma,TabLGPrereg,TabLGAsegv"+;
	" where TLD_nroregisext=TabLGPrereg.id and TLD_nroregisext>0 and TLD_freclamo >= ?mbusca"+;
	mwhere,"mwklegalesB")
	
If mret < 0
	Messagebox("EN BUSQUEDA DE DEMANDAS, AVISE A SISTEMAS",16,"ERROR")
	Return
Endif

select * from mwklegalesA union select * from mwklegalesB into cursor mwklegales

*
* Ctrl de Aseguradora/s
*
If used('mwkasegrep')
	Use in mwkasegrep
Endif
mret = sqlexec(mcon1,"select tav_idreclamo,count(tav_idreclamo) as Tav_casegura"+;
	" from TabLGAsegv group by tav_idreclamo","mwkasegrep")
If mret > 0
	If reccount('mwklegales') > 0
		If mpendien = 1 && Solo pendientes
			mwhere=" and TLD_idEstado = mwkEstado.SubEstado and mwkEstado.Tipo = 0"
		Else            && Todos, por ahora valido tipo 0 y 1
			mwhere=" and TLD_idEstado = mwkEstado.SubEstado and (mwkEstado.Tipo = 0 or mwkEstado.Tipo = 1)"
		Endif
		If moptg1 = 2 && Estado Todos ó Uno
			mwhere = mwhere + " and TLD_idEstado = mcbo1"	 && Si es Uno
		Endif
		If moptg2 = 2 && Aseguradora Todas ó Una
			mwhere = mwhere + " and TAV_idasegura = mcbo2"  && Si es Uno
		Endif
		Set date to ymd
		
		if used('mwklegalesM')
		  use in mwklegalesM
		endif
		
		msql = "Select transform(left(dtoc(TLD_freclamo),7),'9999/99') as reclamo,"+;
			"REG_nombrepac as nombre,REG_numdocumento as documento,mwkHechosg.TLH_descrip as hecho,"+;
			"alltrim(mwkAsegura.TLA_nombre)+iif(mwkasegrep.Tav_casegura>1,' /Vrs','') as seguro,"+;
			"mwkEstado.descrip as lestado,TLD_actor as lactor,"+;
			"mwklegales.TLG_idema as orden,"+;
			"mwklegales.TLD_fechamov as fecmovi,"+;
			"TLD_nroregistrac,TLD_idHecho,TAV_idasegura,TLD_idEstado,"+;
			"sp_busco_legales_evoest(mwklegales.TLG_idema,1) as lcambio,"+;
			"mwklegales.TLD_fecacuerdo as facuerd, mwklegales.TLD_fecsenten as fsenten"+;
			" from mwklegales,mwkEstado,mwkAsegura,mwkHechosg,mwkasegrep"+;
			" where mwklegales.TLD_idHecho = mwkHechosg.TLH_idcod and"+;
			" mwklegales.TLD_idEstado = mwkEstado.Subestado"+;
			" and mwklegales.TAV_idasegura = mwkAsegura.lid"+;
			" and mwkasegrep.tav_idreclamo = mwklegales.TLG_idema"+;
			mwhere + " group by mwklegales.TLG_idema order by nombre into cursor mwklegalesM"

		&msql
		
		Select * from mwklegalesM into cursor mwklegales
		
		Set date to dmy
	Endif
Else
	Messagebox("EN BUSQUEDA DE ASEGURADORAS PARA LAS POLIZAS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif

Return


