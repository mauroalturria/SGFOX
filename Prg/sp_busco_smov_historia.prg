*********************************************************************************
* BUSCA Movimientos de la historia                                                    *
*********************************************************************************
lparameters mbusco,mbusco2

if type('mbusco2') # "C"
	mbusco2 = ''
endif
mret = sqlexec(mcon1,"select TabHCnsal.*, nombre , hce_descrip " + ;
	" from TabHCnsal left outer join prestadores on hcn_codmed = prestadores.id "+;
	"left join TabHCEstado on TabHCnsal.hcn_estado = TabHCEstado.hce_id " + ;
	" where hcn_registrac = ?mbusco " +mbusco2 , "mwkmovhist11" )
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
endif

select hcn_codmed as hcm_codmed,nombre as hcm_descMed,hce_descrip ;
	,hcn_estado as hcm_estado,hcn_fechamov as hcm_fechamov,hcn_fechatur as hcm_fechatur;
	,hcn_registrac as hcm_registrac,hcn_usuario  as hcm_usuario ;
	from mwkmovhist11 where !isnull(hcn_registrac) ;
	order by hcm_fechatur asc ;
	into cursor mwkmovhist01

select hcm_fechatur, hcm_descMed, hcm_usuario,hcm_fechamov, ;
	hce_descrip  from mwkmovhist01 ;
	into cursor mwkmovhist1

if used('mwkmovhist01')
	use in mwkmovhist01
endif
if used('mwkmovhist11')
	use in mwkmovhist11
endif
