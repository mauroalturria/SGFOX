*!*	determina si una prestacion es de atencion directa si es de atencion directa devuelve 2 si no devuelve 9 si esta liberada devuelve 1 practicas x ejemplo

Lparameters lncodprest,lncodesp,lncodent
Local lnDirecta
lnDirecta = 1
If Vartype(lncodesp)<>"C"
	lncodesp = ''
Endif
If Vartype(lncodent)<>"N"
	lncodent= 948
Endif
mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, pre_especialidad "+;
	" FROM prestacions where pre_fechapasiva is null and " + ;
	"pre_codprest = ?lncodprest " , "mwkprestdi")
lncodesp = mwkprestdi.pre_especialidad
lnservi = mwkprestdi.pre_codservicio
Use In Select("mwkprestdi")
If lnservi  <>2200
	Return lnDirecta
Else
	mret = SQLExec(mcon1," select id  FROM Zabespecexcluentidad "+;
		" where {fn curdate()} between  EXE_VigenciaDesde and  EXE_VigenciaHasta"+;
		" and EXE_CodEntidad = ?lncodent and CodAmbito=?mxambito and EXE_CodEspecialidad = ?lncodesp "  +;
		" and EXE_TipoExclusion = -1 ", "mwkMFdir")
	If Reccount("mwkMFdir")>0 
		lnDirecta = 2
		Use In Select("mwkMFdir")
		Return lnDirecta
	Else
		mret = SQLExec(mcon1," select id FROM Zabprestacexcluentidad "+;
			" where {fn curdate()} between  PXE_VigenciaDesde and  PXE_VigenciaHasta"+;
			" and PXE_CodEntidad= ?lncodent and CodAmbito=?mxambito and PXE_CodPrestacion= ?lncodprest "  +;
			" and PXE_TipoExclusion= -1 ", "mwkMFdir")
		lnDirecta = Iif(Reccount("mwkMFdir")>0,2,9)
		Use In Select("mwkMFdir")
		Return lnDirecta
	Endif
Endif
