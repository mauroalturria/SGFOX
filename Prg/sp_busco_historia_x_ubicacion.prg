*********************************************************************************
* BUSCA historias por ubicacion                                      *
*********************************************************************************
lparameters mbuscar

mfechanula = "1900-01-01 00:00:00"

mret = sqlexec(mcon1,"select REG_nrohclinica,  REG_nombrepac, hca_estado,hcm_fechatur " + ;
	",nombre as hcm_descMed,hcm_fechaIngr " +;
	" from registracio,TabHCArchivo "+ ;
	"left outer join TabHCMovct on TabHCArchivo.hca_registrac = TabHCMovct.hcm_registrac "+;
	"left outer join prestadores on TabHCMovct.hcm_codmed = prestadores.id "+;
	"where "+;
	"hca_registrac = REG_nroregistrac  " + mbuscar , "mwkmovhist11" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")

endif

mfechanula = ctot("01/01/1900")
select REG_nombrepac,REG_nrohclinica;
	,iif(isnull(hcm_fechatur),space(10),dtoc(ttod(hcm_fechatur))) as  hcm_fechatur ;
	,iif(isnull(hcm_fechatur),space(100),'C/T '+ hcm_descMed ) as hcm_descMed  ;
	from mwkmovhist11 where nvl(hcm_fechaIngr,mfechanula) = mfechanula ;
	order by REG_nrohclinica into cursor mwkmovhist01

mret = sqlexec(mcon1,"select REG_nrohclinica,  REG_nombrepac, TabHCMovst.* "+;
	"from registracio ,TabHCArchivo " +;
	"left outer join TabHCMovst on TabHCArchivo.hca_registrac = TabHCMovst.hcm_registrac "+;
	" where hca_registrac = REG_nroregistrac " + mbuscar , "mwkmovhist22" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
endif
select REG_nombrepac,REG_nrohclinica;
	,iif(isnull(hcm_fechatur),space(10),dtoc(ttod(hcm_fechatur))) as hcm_fechatur ;
	,iif(isnull(hcm_fechatur),space(100),'S/T '+ hcm_descMed ) as hcm_descMed  ;
	from mwkmovhist22 where nvl(hcm_fechaIngr,mfechanula) = mfechanula ;
	order by REG_nrohclinica into cursor mwkmovhist02

if reccount('mwkmovhist02')>0 and reccount('mwkmovhist01')>0
	select * from mwkmovhist01 ;
		union ;
		select * from mwkmovhist02 ;
		into cursor mwkmovhist1
else
	if reccount('mwkmovhist02')>0
		select * from mwkmovhist02 ;
			into cursor mwkmovhist1
	else
		select * from mwkmovhist01 ;
			into cursor mwkmovhist1
	endif
endif
if used('mwkmovhist01')
	use in mwkmovhist01
endif
if used('mwkmovhist02')
	use in mwkmovhist02
endif
if used('mwkmovhist11')
	use in mwkmovhist11
endif
if used('mwkmovhist22')
	use in mwkmovhist22
endif
