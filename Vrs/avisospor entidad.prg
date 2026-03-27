do sp_conexion
mfecp =sp_busco_fecha_serv("DD")-1
select aviso082
go top
do while !eof()
*!*		for iy = 1 to 6
	mentidad = 992
	mpresta = aviso992.codigo
	mcontrato = 0
	mtipopac = 'AMB'
	mabm = 100
	medtaviso = aviso992.aviso
	mret = sqlexec(mcon1, "select * from Tabavisos " + ;
		"where AV_codent = ?mentidad and AV_codcont = ?mcontrato "+;
		"and AV_prestacion = ?mpresta" + ;
		" and AV_tipopaciente= ?mtipopac ", "mwkTabaviso")

	if reccount("mwktabaviso") > 0
		nid = mwkTabaviso.id
		mret = sqlexec(mcon1, "update TabAvisos set av_fechaPasiva = ?mfecp " + ;
			"where id = ?nid ")
	endif
	do sp_grabo_aviso with mentidad, mcontrato, mtipopac, mpresta, medtaviso, mabm,,.t.
*!*			mentidad = menti(iy)
*!*			mpresta = aviso.codprest
*!*			mcontrato = mentic(iy)
*!*			mtipopac = 'AMB'
*!*			mabm = 100
*!*			medtaviso = aviso.aviso
*!*			do sp_grabo_aviso with mentidad, mcontrato, mtipopac, mpresta, medtaviso, mabm,date()-3

*!*		next iy
	select aviso992
	skip
enddo

do sp_desconexion


*!*	* 484 - 948 - 945 - 909 - 904 - 707
*!*	*	484,948,945,909,904,707
*!*	do sp_conexion
*!*	select aviso
*!*	go top
*!*	do while !eof()
*!*		mentidad = avisos.codent
*!*		mpresta = avisos.codigo
*!*		mcontrato = 0
*!*		mtipopac = 'AMB'
*!*		mabm = 100
*!*		medtaviso = "Orden interna requiere autorización de Auditoría Medica Ambulatoria SG"
*!*		mret = sqlexec(mcon1, "select * from Tabavisos " + ;
*!*			"where AV_codent = ?mentidad and AV_codcont = ?mcontrato "+;
*!*			"and AV_prestacion = ?mpresta" + ;
*!*			" and AV_tipopaciente= ?mtipopac ", "mwkTabaviso")

*!*		if reccount("mwktabaviso") > 0
*!*			medtaviso = alltrim(mwkTabaviso.av_aviso) + chr(10) + "Orden interna requiere autorización de Auditoría Medica Ambulatoria SG"
*!*		endif
*!*		do sp_grabo_aviso with mentidad, mcontrato, mtipopac, mpresta, medtaviso, mabm
*!*		select avisos
*!*		skip
*!*	enddo
*!*	do sp_desconexion







*!*	set step on
*!*	select aviso
*!*	do while !eof()
*!*		select  entpro
*!*		go top
*!*		do while !eof()
*!*			mentidad = entpro.codent
*!*			mpresta = aviso.codigo
*!*			mcontrato = 0
*!*			mtipopac = 'AMB'
*!*			mabm = 100
*!*			medtaviso = "Requiere autorización previa de Auditoria Medica Ambulatoria"
*!*			mret = sqlexec(mcon1, "select * from Tabavisos " + ;
*!*				"where AV_codent = ?mentidad and AV_codcont = ?mcontrato "+;
*!*				"and AV_prestacion = ?mpresta" + ;
*!*				" and AV_tipopaciente= ?mtipopac ", "mwkTabaviso")

*!*			if reccount("mwktabaviso") > 0
*!*				medtaviso = mwkTabaviso.av_aviso + chr(10) + "Otorgar turno con técnica Erika Hermosilla"
*!*			endif
*!*			do sp_grabo_aviso with mentidad, mcontrato, mtipopac, mpresta, medtaviso, mabm
*!*			mentidad = entpro.codent
*!*			mpresta = aviso.codigo
*!*			mcontrato = val("17"+alltrim(transf(mentidad)))
*!*			mtipopac = 'AMB'
*!*			mabm = 100
*!*			medtaviso = "Ordenes externas requieren autorización de Bristol Park / "+;
*!*				"Ordenes generadas en Sanatorio Güemes requieren autorización de Auditoría Médica Ambulatoria"
*!*			medtaviso = "Otorgar turno con técnica Erika Hermosilla"
*!*			mret = sqlexec(mcon1, "select * from Tabavisos " + ;
*!*				"where AV_codent = ?mentidad and AV_codcont = ?mcontrato "+;
*!*				"and AV_prestacion = ?mpresta" + ;
*!*				" and AV_tipopaciente= ?mtipopac ", "mwkTabaviso")

*!*			if reccount("mwktabaviso") > 0
*!*				medtaviso = mwkTabaviso.av_aviso + chr(10) + "Otorgar turno con técnica Erika Hermosilla"
*!*			endif
*!*			do sp_grabo_aviso with mentidad, mcontrato, mtipopac, mpresta, medtaviso, mabm
*!*			select entpro
*!*			skip
*!*		enddo
*!*		select aviso
*!*		skip
*!*	enddo

*!*	set step on
*!*	select aviso
*!*	go top
*!*	do while !eof()
*!*		mentidad = 0
*!*		mpresta = aviso.codigo
*!*		mcontrato = 0
*!*		mtipopac = 'AMB'
*!*		mabm = 100
*!*		medtaviso = "Requiere autorización previa de Auditoria Medica Ambulatoria"
*!*		mret = sqlexec(mcon1, "select * from Tabavisos " + ;
*!*			"where AV_codent = ?mentidad and AV_codcont = ?mcontrato "+;
*!*			"and AV_prestacion = ?mpresta" + ;
*!*			" and AV_tipopaciente= ?mtipopac ", "mwkTabaviso")

*!*		if reccount("mwktabaviso") > 0
*!*			medtaviso = mwkTabaviso.av_aviso + chr(10) + "Requiere autorización previa de Auditoria Medica Ambulatoria"
*!*		endif
*!*		do sp_grabo_aviso with mentidad, mcontrato, mtipopac, mpresta, medtaviso, mabm
*!*		select aviso
*!*		skip
*!*	enddo


*!*	do sp_desconexion



*!*	dimension menti(10),mentic(10)
*!*	menti[1] = 948
*!*	menti[2] = 945
*!*	menti[3] = 484
*!*	menti[4] = 909
*!*	menti[5] = 904
*!*	menti[6] = 707
*!*	*menti[7] = 988
*!*	*menti[8] = 987
*!*	*menti[9] = 886
*!*	mentic[1] = 17948
*!*	mentic[2] = 17945
*!*	mentic[3] = 17484
*!*	mentic[4] = 17909
*!*	mentic[5] = 17904
*!*	mentic[6] = 17707
*!*	*!*	mentic[7] = 17988
*!*	*!*	mentic[8] = 17987
*!*	*!*	mentic[9] = 17886
*!*	do sp_desconexion


*!*	dimension menti(10),mentic(10)
*!*	menti[1] = 948
*!*	menti[2] = 945
*!*	menti[3] = 964
*!*	menti[4] = 806
*!*	menti[5] = 904
*!*	menti[6] = 909
*!*	menti[7] = 988
*!*	menti[8] = 987
*!*	menti[9] = 886
*!*	mentic[1] = 17948
*!*	mentic[2] = 17945
*!*	mentic[3] = 17964
*!*	mentic[4] = 17806
*!*	mentic[5] = 17904
*!*	mentic[6] = 17909
*!*	mentic[7] = 17988
*!*	mentic[8] = 17987
*!*	mentic[9] = 17886

*!*	for iy = 1 to 9
*!*		mentidad = menti(iy)
*!*		mpresta =    aviso.
*!*		mcontrato = 0
*!*		mtipopac = 'AMB'
*!*		mabm = 100
*!*		medtaviso = "Ordenes externas requieren autorización de Bristol Park / Ordenes generadas en Sanatorio Güemes requieren autorización de Auditoría Médica Ambulatoria"
*!*		medtaviso = "."
*!*		mret = sqlexec(mcon1, "select * from Tabavisos " + ;
*!*			"where AV_codent = ?mentidad and AV_codcont = ?mcontrato "+;
*!*			"and AV_prestacion = ?mpresta" + ;
*!*			" and AV_tipopaciente= ?mtipopac ", "mwkTabaviso")

*!*		if reccount("mwktabaviso") > 0
*!*	*			medtaviso = mwkTabaviso.av_aviso + chr(10) + "Requiere autorización previa de Auditoria Medica Ambulatoria"
*!*		endif
*!*		do sp_grabo_aviso with mentidad, mcontrato, mtipopac, mpresta, medtaviso, mabm
*!*	next iy



*!*	948,945,964,806,904,909,988,987,886

*!*	do sp_grabo_aviso with 27, 0, 'INF', 0, "DEBE FIRMAR Y SELLAR EL BONO DE IOMA EN EL CASILLERO CORRESPONDIENTE. ANTE CUALQUIER DUDA CONSULTAR AL AREA ADMINISTRATIVA", 100,,.t.
