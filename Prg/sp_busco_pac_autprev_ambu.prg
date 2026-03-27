****
** busco internados
****
parameters mbusco1ac, mnomcur

if vartype(mnomcur)# "C"
	mnomcur = "mwkpacamb"
endif

mbusco1ac = iif(vartype(mbusco1ac)#"C",'',mbusco1ac)

mret = sqlexec(mcon1, "select apv_codadmision, apv_codmedicosolic "+;
	", apv_codsector , apv_estado , apv_fechaauditoria"+;
	", apv_fechasolicitud , apv_horaauditoria , apv_horasolicitud , apv_idautprevias"+;
	", apv_nommedicosolic ,apv_observaciones , apv_operauditoria , apv_opersolicitud"+;
	", apv_presinsu , apv_subestadopend "+;
	", autprevias.id as autid, autprevias.apv_diagnostico , autprevias.apv_resprev "+;
	", apv_descripsolic "+;
	" from autprevias " + ;
	" where  apv_presinsu = 'S' and apv_descripsolic = 'AMBULANCIA' "  + mbusco1ac +;
	"  ",mnomcur )
if mret<1
	do log_errores with error(), message(), message(1), program(), lineno()
	messagebox("ERROR EN LA GENERACION DEL CURSOR",48,"VALIDACION")
	return .f.
endif
return .t.
