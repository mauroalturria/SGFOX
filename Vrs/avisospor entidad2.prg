* 948,945,964,806,904,909,988,987,886

do sp_conexion
dimension menti(10),mentic(10)
menti[1] = 948
menti[2] = 945
menti[3] = 964
menti[4] = 806
menti[5] = 904
menti[6] = 909
menti[7] = 988
menti[8] = 987
menti[9] = 886
mentic[1] = 17948
mentic[2] = 17945
mentic[3] = 17964
mentic[4] = 17806
mentic[5] = 17904
mentic[6] = 17909
mentic[7] = 17988
mentic[8] = 17987
mentic[9] = 17886
set step on
select aviso
do while !eof()
		mentidad = 0
		mpresta = aviso.codigo
		mcontrato = 0
		mtipopac = 'AMB'
		mabm = 100
		medtaviso = "Orden interna requiere autorización de Auditoría Medica Ambulatoria SG"
		mret = sqlexec(mcon1, "select * from Tabavisos " + ;
			"where AV_codent = ?mentidad and AV_codcont = ?mcontrato "+;
			"and AV_prestacion = ?mpresta" + ;
			" and AV_tipopaciente= ?mtipopac ", "mwkTabaviso")

		if reccount("mwktabaviso") > 0
			medtaviso = mwkTabaviso.av_aviso + chr(10) + 'Orden interna requiere autorización de Auditoría Medica Ambulatoria SG'
		endif
		do sp_grabo_aviso with mentidad, mcontrato, mtipopac, mpresta, medtaviso, mabm
	select aviso
	skip 
enddo
do sp_desconexion
