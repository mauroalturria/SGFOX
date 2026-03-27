*********************************************************************************
* BUSCA historias en rotacion                                                    *
*********************************************************************************
lparameters mcodmed, mfecha

mcfecha = prg_dtoc(mfecha)
mfechanula = "1900-01-01 00:00:00"

mqbusca = iif(mcodmed = 306, '', ' and hcm_codmed = ?mcodmed ')
mret = sqlexec(mcon1,"select REG_nrohclinica,  REG_nombrepac, TabHCArchivo.* "+;
	", TabHCMovct.*, nombre, ESP_descripcion, abrevio " + ;
	" from registracio, especialid, TabHCUbica ,TabHCArchivo " +;
	" left outer join TabHCMovct on TabHCMovct.hcm_registrac = TabHCArchivo.hca_registrac "+;
	" left outer join prestadores on TabHCMovct.hcm_codmed = prestadores.id "+;
	" where hca_estado >= 3 and trim(hcm_codesp) = trim(ESP_codesp) " + mqbusca + ;
	" and hcm_fechaIngr  = ?mfechanula and hcm_fechatur <= ?mcfecha" + ;
	" and hca_registrac = REG_nroregistrac " +;
	" and codubi = hca_motfalta order by hca_registrac " , "mwkmovhist11" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")

endif

select *,'C/T' as tipo,space(50) as hcm_retira,nombre as hcm_descMed, ESP_descripcion as hcm_descEsp ;
	, iif(hcm_origen=0,"ARCH","CONS") as desde ;
	from mwkmovhist11 where !isnull(hcm_registrac) into cursor mwkmovhist01

mret = sqlexec(mcon1,"select REG_nrohclinica,  REG_nombrepac, TabHCArchivo.*,TabHCMovst.*,abrevio "+;
	" from TabHCUbica,TabHCArchivo  " +;
	" left outer join TabHCMovst on TabHCArchivo.hca_registrac = TabHCMovst.hcm_registrac "+;
	" left outer join registracio on TabHCArchivo.hca_registrac = registracio.REG_nroregistrac "+;
	" where hca_estado >= 3  and hcm_fechaIngr = ?mfechanula  " + ;
	" and codubi = hca_motfalta and hcm_fechatur <= ?mcfecha " + mqbusca , "mwkmovhist22" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
endif
select *,'S/T' as tipo, iif(hcm_origen=0,"ARCH","CONS") as desde ;
	from mwkmovhist22 where !isnull(hcm_registrac) into cursor mwkmovhist02


select REG_nombrepac,REG_nrohclinica, hcm_fechasal, hcm_fechatur,hcm_origen,hcm_descMed;
	, Tipo, hcm_descEsp, hcm_retira,desde, mfecha as diafalta,abrevio from mwkmovhist01 ;
	union ;
	select REG_nombrepac,REG_nrohclinica, hcm_fechasal, hcm_fechatur,hcm_origen,hcm_descMed;
	, Tipo, hcm_descEsp, hcm_retira,desde, mfecha as diafalta,abrevio from mwkmovhist02 ;
	into cursor mwkmovhist1
*!*	if reccount('mwkmovhist02')>0 and reccount('mwkmovhist01')>0
*!*	else
*!*		mname = iif( reccount('mwkmovhist02')>0 ,'mwkmovhist02','mwkmovhist01')
*!*		select * from &mname into cursor mwkmovhist1
*!*	endif

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
