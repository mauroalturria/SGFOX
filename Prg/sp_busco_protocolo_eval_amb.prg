
lparameters mfechades, mfechahas,cpresta

if vartype(cpresta)#"C"
	cpresta = ""
endif

mret = SQLExec(mcon1, "select tabambulatorio.*, REG_nombrepac, " + ;
	" pre_descriprest, pre_especialidad,pre_codservicio,"+;
	"tipoest,REG_nrohclinica,REG_numdocumento,"+;
	"reg_fecnacimiento,reg_sexo,TPV_Estado,EA_exFisico, EA_motConsulta,"+;
	" EA_evolucion,ent_codent,ENT_descrient "+;
	"from tabambulatorio "+;
	"join registracio  on registracio.REG_nroregistrac=tabambulatorio.nroregistrac "+;
	"join prestacions  on prestacions.pre_codprest=tabambulatorio.codprest "+;
	"join entidades on ent_codent = Tabambulatorio.codent "+;
	"join Tabambevol on Tabambevol.EA_protocolo = Tabambulatorio.protocolo "+;
	"join tabtipoaltas on tabtipoaltas.id=tabambulatorio.codestado "+;
	"left outer join TabPacVip on TabPacVip.TPV_NroReg = registracio.REG_nroregistrac "+;
	"where tabambulatorio.fechaate >= ?mfechades and " + ;
	"tabambulatorio.fechaate <= ?mfechahas " +cpresta + ;
	" and Tabambulatorio.nrovale  >0 ", "mwkprotquir1")
	


if mret <= 0
	do Log_errores with error(), message(), message(1), program(), lineno()
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
	do sp_desconexion with "Err sp_busco_protocolo_historia"
	cancel
	return .f.
endif

select mwkprotquir1.*,Nombre as Prof, Matriculas, '' as eam_evol,;
	prg_edad(REG_fecnacimiento,ttod(FechaHoraing),"N" ) as edad;
	from mwkprotquir1,mwkmedsoli where codMed = mwkmedsoli.id;
	and !empty(nvl(Ea_Evolucion,'')) ;
	group by protocolo,codmed into cursor mwkprotquir


if used ("mwkprotquir1")
	use in mwkprotquir1
endif

if mRet < 0
	messagebox("ERROR EN LA GENERACION , AVISAR A SISTEMAS",16, "Validacion")
	do sp_desconexion with "error"
	cancel
endif
