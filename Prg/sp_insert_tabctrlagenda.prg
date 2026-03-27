****
** grabo un movimiento cuando Accede a Manejo de agenda
****

parameter mxbloqueo, mxcodespdesbloqueo, mxcodmed, mxdesdefecha, mxformulario, ;
	mxhastafecha,mxseleccion,mxturnodesbloqueo
*if mxambito>=1
	mxfecha 	= sp_busco_fecha_serv('DT')
	mxidusuario = mwkusuario.idusuario
	mxcodespdesbloqueo = left(mxcodespdesbloqueo,50)
	mret = sqlexec(mcon1, "insert into Tabctrlagenda( bloqueo, codespdesbloqueo, codmed, desdefecha, "+;
		"fecha, formulario, hastafecha,idusuario, seleccion,turnodesbloqueo) "+;
		"values(?mxbloqueo, ?mxcodespdesbloqueo, ?mxcodmed, ?mxdesdefecha, "+;
		"?mxfecha, ?mxformulario,?mxhastafecha,?mxidusuario,?mxseleccion,?mxturnodesbloqueo )")
	if mret<1
		do log_errores with error(), message(), message(1), program(), lineno()
		select mwkusuario
		go top
		midusua     = mwkusuario.idusuario
		merr1 = transf(mxformulario)+"+"+transf(mxcodmed)+"+"+transf(mxdesdefecha)+"+"+transf(mxseleccion)+;
			"+"+transf(mxbloqueo)+"+"+transf(mxcodespdesbloqueo)+"+"+transf(mxturnodesbloqueo )
		do sp_insert_tabctrlerr with merr1, merr1 , midusua, mwkexe.nomexe
*	set step on
	endif

*endif
