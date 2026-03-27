*********************************************************************************
* BUSCA historias en despachadas                                                    *
*********************************************************************************
lparameters mfecha

mcfecha = prg_dtoc(mfecha)
mfechanula = "1900-01-01 00:00:00"
mret = sqlexec(mcon1,"select hca_estado,hca_registrac  as afiliado, hcm_codmed as otrocod " + ;
	" from TabHCArchivo " +;
	"left outer join TabHCMovct on TabHCMovct.hcm_registrac = TabHCArchivo.hca_registrac "+;
	" where  hcm_fechatur >= ?mcFecha " +;
	" and hcm_fechaIngr  = ?mfechanula " +;
	" order by hca_registrac " , "mwkmovhcp" )


if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")

endif
select afiliado, nombre as otromed,otrocod ;
	from mwkmovhcp left join mwkpmed on otrocod = mwkpmed.id ;
	where hca_estado = 1 into cursor mwkmovhc
