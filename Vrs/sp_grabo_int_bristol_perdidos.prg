
* Graba protocolo de la atencion
*
set step on
select agrego
scan
	mfHoy   = prg_dtoc(fechahora)
	mfecorden = left(mfHoy  ,10)
	musua 	= usuario
	mfechaingr = prg_dtoc(FECHORAING)
	mfechaegr = prg_dtoc(FECHORAEGR)
	mmotivoegreso = MOTIVOEGRESO
	msector = LUGARINTERNAC
	mcodadm	= CODADMISION
	ctipomov = TIPOMOV
	mdiagno = DIAGNOSTICO
	mnrodoc = NRODOC
	mtipodoc = TIPODOC
	mnroafil = NROAFIL
	mapel = APELLIDO
	mnombre = NOMBRE
	msex = SEXO
	mfecnac = left(prg_dtoc(FECHANAC),10)
	mcodigoent = OS_ID
*menttipo = val(mwkctrlpad.contenido)
	mret = sqlexec(mcon1, "insert into Bristol.SG_INTERNACION (" + ;
		"OS_ID,NROAFIL,TIPODOC,NRODOC,APELLIDO,NOMBRE,SEXO,FECHANAC "+;
		",FECHORAING,DIAGNOSTICO,FECHORAEGR,FECHAORDEN,LUGARINTERNAC"+;
		",CODADMISION,TIPOMOV,USUARIO,FECHAHORA, Motivoegreso ) "+;
		"values(" + ;
		"?mcodigoent,?mnroafil ,?mtipodoc , ?mnrodoc , ?mapel  " + ;
		",?mnombre, ?msex, ?mfecnac, ?mfechaingr, ?mdiagno,?mfechaegr,?mfecorden "+;
		",?msector,?mcodadm,?ctipomov,?musua, ?mfHoy, ?mmotivoegreso )")
	if mret<1
		set step on
	endif
endscan
